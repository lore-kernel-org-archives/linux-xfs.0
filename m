Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91C81487DC
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 16:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136050; cv=none; b=RYesVfBxG/QO9axHNQ9K/qN7gjAJe95PFHLTRiUHlQXfQItUCriYMYZlKzoUGE9qwLjSGj0zQum8f82dZUrfY8Mt6WNtSgOlpDNQT+k7kntetJjjgBR/APFftKSy60UM8lPV5TTmR4Bzss/t2PhGvIKVo5XMKXCF7Cio9JDFUVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136050; c=relaxed/simple;
	bh=aZqQng1ZeDW0R8SAAIIfqapWxD4Ws0wTLojAfikCnzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZFNiDXUIO//S1XABfWEeO7NRaOnvW9laqokylsIodmZ0om5PiXqD2ciRgQiezbcbkhQkymwsVfrZ0mlaZFze9HFhRaIanD+FT41wqaUx79i2liMfWksjLu+q/3tydUBCfccStuAfvNuqlZ/5l9EpwhHlvz1r6zQLy3Xe3cUdk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DeazdIBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DeazdIBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DFDC433C7;
	Wed, 28 Feb 2024 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709136050;
	bh=aZqQng1ZeDW0R8SAAIIfqapWxD4Ws0wTLojAfikCnzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DeazdIBasgflls99W8d6MsekW7gGkM/u3bLld4tDLp/IcQQ2/NqN/plcug9XlixL5
	 fc7Pl/Ae6RgqYgTzBH23BlrPFP9NopbJ4KUzfTuYqFvEAmiEmIZsLTcKgGe+H1s+D2
	 n5cWpNfjhA3oX71N53ipiwXRYAg0QCqf8XkwYc/sB2hgW+sowFGCzULEmUiOA7U1ja
	 fYum8JrFXUMUDJhKggJ8ZQcy0fZMVwXdtUh6hg/OSFZ/C7upb2A9J2OmyB6g7xWHKV
	 RqNSQGLEe3IvQUX+732f08644f091qblEBgCVdClOrlUfM4TgE0/E1UYYVbolj1Fe5
	 wE8j1ZFMPGjcg==
Date: Wed, 28 Feb 2024 08:00:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdump/xfsrestore: don't use O_DIRECT on the RT device
Message-ID: <20240228160049.GE1927156@frogsfrogsfrogs>
References: <20240228135313.854307-1-hch@lst.de>
 <20240228135313.854307-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228135313.854307-2-hch@lst.de>

On Wed, Feb 28, 2024 at 05:53:13AM -0800, Christoph Hellwig wrote:
> For undocumented reasons xfsdump and xfsrestore use O_DIRECT for RT
> files.  On a rt device with 4k sector size this runs into alignment
> issues, e.g. xfs/060 fails with this message:
> 
> xfsrestore: attempt to write 237568 bytes to dumpdir/large000 at offset 54947844 failed: Invalid argument
> 
> Switch to using buffered I/O to match the main device and make these
> alignment issues go away.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hah, I have an (never submitted) patch in my xfsdump repo that does
exactly this.  Now I don't have to find someone to review mine,
excellent. :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  doc/xfsdump.html  | 1 -
>  dump/content.c    | 3 ---
>  restore/content.c | 3 ---
>  3 files changed, 7 deletions(-)
> 
> diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> index efd3890..eec7dac 100644
> --- a/doc/xfsdump.html
> +++ b/doc/xfsdump.html
> @@ -884,7 +884,6 @@ Initialize the mmap files of:
>                     <ul>
>                     <li> S_IFREG -> <b>restore_reg</b> - restore regular file
>                        <ul>
> -                      <li>if realtime set O_DIRECT
>                        <li>truncate file to bs_size
>                        <li>set the bs_xflags for extended attributes
>                        <li>set DMAPI fields if necessary
> diff --git a/dump/content.c b/dump/content.c
> index 9117d39..f06dda1 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -4325,9 +4325,6 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
>  
>  	isrealtime = (bool_t)(statp->bs_xflags & XFS_XFLAG_REALTIME);
>  	oflags = O_RDONLY;
> -	if (isrealtime) {
> -		oflags |= O_DIRECT;
> -	}
>  	(void)memset((void *)gcp, 0, sizeof(*gcp));
>  	gcp->eg_bmap[0].bmv_offset = 0;
>  	gcp->eg_bmap[0].bmv_length = -1;
> diff --git a/restore/content.c b/restore/content.c
> index 488ae20..c80ff34 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -7471,9 +7471,6 @@ restore_reg(drive_t *drivep,
>  		return BOOL_TRUE;
>  
>  	oflags = O_CREAT | O_RDWR;
> -	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
> -		oflags |= O_DIRECT;
> -
>  	*fdp = open(path, oflags, S_IRUSR | S_IWUSR);
>  	if (*fdp < 0) {
>  		mlog(MLOG_NORMAL | MLOG_WARNING,
> -- 
> 2.39.2
> 
> 
