Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9306B191
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819638; cv=none; b=CKIhUm+xeK/qsflRb+lwVNmGfpgORRIEodNgHCmqj3UeC6BQhkewNnw9oQx4pTbXPbeYkCl1wXDJgSLMYLv9zg14AvTMeM9H9YEeb2kCsCd5lpKGi+/IAWTTdo4ivtbk3OZtQHvPmCj265ubnJUzZgnHvk2Z745feJMwP6fqM4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819638; c=relaxed/simple;
	bh=WPtb2xrzrXSeQB9DVE+SL23NPkeAnMS4+yAXnKxYjsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQ8vjrh5DIW5EjtEDuEZRu+eV/4XFgcgdCd8rbADDkv56iwg7LGwCkil3qe5sSZsvx/mrTk/QQtPkO0J79Q/dMe7vthMGlHmk6bNqlcCYRCpV6gqZu6k6gJfsHiDdVlGP4swYr0dAbdCehf+mEmqxnFJP9FQ0wBqfC3exew+uWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoFnj3uM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoFnj3uM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3CCC4CEE2;
	Wed, 16 Apr 2025 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744819637;
	bh=WPtb2xrzrXSeQB9DVE+SL23NPkeAnMS4+yAXnKxYjsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FoFnj3uMLDbCzq1ls6BnVrCQTzjwg3YqToXz7ukFt7I2m+yS7BJSI69V6uAW0XdIa
	 W5wJREN3mNe9yTHcQ+/S1tSYBmjie1x4bInruaq2F2sXvNRweKw8R4xaCRTKJ+kI+f
	 LnZY39xjJP/LISSTkDpUzXdB/44nPMttuhLbupB90acpTJIPHcjzEzG2Z9mIqQYFWN
	 TMbID5RHewm/D69WNmA3DNGevCtoXiVp5Inb+Z4FN7ajwu6Sef+0XJxosHdZnUt+3j
	 GFdRfkNPbQKkBnLROONs3tif/gHmE8EMVSUiJMWfLbCK6vcGzF+pTcgoTEqKVPDccZ
	 LIaMWhIkpL9pw==
Date: Wed, 16 Apr 2025 09:07:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: Re: [PATCH RFC 2/2] proto: read origin also for directories,
 chardevs and symlinks. copy timestamps from origin.
Message-ID: <20250416160716.GG25675@frogsfrogsfrogs>
References: <20250416144400.940532-1-luca.dimaio1@gmail.com>
 <20250416144400.940532-3-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416144400.940532-3-luca.dimaio1@gmail.com>

On Wed, Apr 16, 2025 at 04:43:33PM +0200, Luca Di Maio wrote:
> Right now, when populating a filesystem with the prototype file,
> generated inodes will have timestamps set at the creation time.
> 
> This change enables more accurate filesystem initialization by preserving
> original file timestamps during inode creation rather than defaulting to
> the current time.
> 
> This patch leverages the xfs_protofile changes in order to carry the
> reference to the original files for files other than regular ones.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  mkfs/proto.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 6dd3a20..ed76155 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -352,6 +352,15 @@ writefile(
> 
>  	libxfs_trans_ijoin(tp, ip, 0);
>  	ip->i_disk_size = statbuf.st_size;
> +
> +	/* Copy timestamps from source file to destination inode */
> +	VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
> +	VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
> +	VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
> +	VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
> +	VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
> +	VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;

	inode_set_[acm]time()?

I don't have a particular problem with copying in timestamps for regular
files...

> +
>  	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = -libxfs_trans_commit(tp);
>  	if (error)
> @@ -689,6 +698,7 @@ parseproto(
>  	char		*fname = NULL;
>  	struct xfs_name	xname;
>  	struct xfs_parent_args *ppargs = NULL;
> +	struct stat		statbuf;
> 
>  	memset(&creds, 0, sizeof(creds));
>  	mstr = getstr(pp);
> @@ -823,10 +833,23 @@ parseproto(
>  		ppargs = newpptr(mp);
>  		majdev = getnum(getstr(pp), 0, 0, false);
>  		mindev = getnum(getstr(pp), 0, 0, false);
> +		fd = newregfile(pp, &fname);

...however, newregfile calls getstr, which advances *pp.  This breaks
parsing of all existing protofiles.  Take a file like this:

msr c--600 0 0 202 3
ptmx c--000 0 0 5 2

At the point where we assign mindev, the parser is sitting at the end of
the "msr" line.  The new newregfile() call reads the next word from the
file ("ptmx") and tries to open it to copy timestamps, but that's not
the correct thing to do.

Similarly, a new protofile from patch 1:

msr c--600 0 0 202 3 /dev/cpu/0/msr
ptmx c--000 0 0 5 2 /dev/pts/ptmx

Will break parsing on an old version of mkfs because the getstr at the
top of parseproto() will read the "/dev/cpu/0/msr" and think that's the
name of a new file.

In effect, you're revving the protofile format in an incompatible way.
If you really want this, then the new parsing logic should be gated on
some sort of version number specification, either through CLI options or
by overloading the "boot image name" on the first line or the two
numbers on the second line.

Though if you're going to all that trouble, why not just amend the CLI
to take a -p directory=$PATH and walk $PATH with nftw like mke2fs does?

The protofile format that mkfs.xfs uses has been static for 52 years,
I don't know that expending a large amount of effort on it is worth the
time.  If you really must have reproducible filesystem images, would it
be easier to allow overriding current_time() via environment vars?

(I also don't really get why anyone cares about bit-reproducible
filesystem images; the only behavioral guarantees are the userspace
interface contract.  Filesystem drivers have wide latitude to do
whatever they want under the covers.)

((Also not sure why you left out block device special files?))

--D

>  		error = creatproto(&tp, pip, mode | S_IFCHR,
>  				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> +
> +		/* Copy timestamps from source file to destination inode */
> +		error = fstat(fd, &statbuf);
> +		if (error < 0)
> +			fail(_("unable to stat file to copyin"), errno);
> +		VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
> +		VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
> +		VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
> +		VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
> +		VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
> +		VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
> +
>  		libxfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_CHRDEV;
>  		newdirent(mp, tp, pip, &xname, ip, ppargs);
> @@ -846,6 +869,7 @@ parseproto(
>  		break;
>  	case IF_SYMLINK:
>  		buf = getstr(pp);
> +		char* orig = getstr(pp);
>  		len = (int)strlen(buf);
>  		tp = getres(mp, XFS_B_TO_FSB(mp, len));
>  		ppargs = newpptr(mp);
> @@ -854,11 +878,24 @@ parseproto(
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
>  		writesymlink(tp, ip, buf, len);
> +
> +		/* Copy timestamps from source file to destination inode */
> +		error = lstat(orig, &statbuf);
> +		if (error < 0)
> +			fail(_("unable to stat file to copyin"), errno);
> +		VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
> +		VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
> +		VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
> +		VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
> +		VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
> +		VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
> +
>  		libxfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_SYMLINK;
>  		newdirent(mp, tp, pip, &xname, ip, ppargs);
>  		break;
>  	case IF_DIRECTORY:
> +		fd = newregfile(pp, &fname);
>  		tp = getres(mp, 0);
>  		error = creatproto(&tp, pip, mode | S_IFDIR, 0, &creds, fsxp,
>  				&ip);
> @@ -878,6 +915,18 @@ parseproto(
>  			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>  		}
>  		newdirectory(mp, tp, ip, pip);
> +
> +		/* Copy timestamps from source file to destination inode */
> +		error = stat(fname, &statbuf);
> +		if (error < 0)
> +			fail(_("unable to stat file to copyin"), errno);
> +		VFS_I(ip)->__i_atime.tv_sec = statbuf.st_atime;
> +		VFS_I(ip)->__i_mtime.tv_sec = statbuf.st_mtime;
> +		VFS_I(ip)->__i_ctime.tv_sec = statbuf.st_ctime;
> +		VFS_I(ip)->__i_atime.tv_nsec = statbuf.st_atim.tv_nsec;
> +		VFS_I(ip)->__i_mtime.tv_nsec = statbuf.st_mtim.tv_nsec;
> +		VFS_I(ip)->__i_ctime.tv_nsec = statbuf.st_ctim.tv_nsec;
> +
>  		libxfs_trans_log_inode(tp, ip, flags);
>  		error = -libxfs_trans_commit(tp);
>  		if (error)
> --
> 2.49.0
> 
