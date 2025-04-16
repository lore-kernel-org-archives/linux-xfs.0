Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6779191
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819680; cv=none; b=GoS6M8NQi3yoObrGDBWF3o0/HAQ23gEuSpLG+VeKmM41lc05SpbAER6yX3CP0HSSaIzkXUWNPJLRQxNSnFnxucvtXYINyHrDV+hbw96Jgh+6771hOgX+t2je1l5ReqHPteuiqZZRCTOv8N/Rxyyw9ofEfCzPyTFsR0lYArxxAQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819680; c=relaxed/simple;
	bh=Cmzue8l0pLVe+48zM/5BU18veqvpBJNFW3D39isBb6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9NqDuRzqlQ3G6nhGTaLYBFYj3gSf1RhtprDWdRy1CMsUyK0E8dDTvdYGs/ohyBxZ1lOAviYjsb6bbGTfJ0V7hxvSIreCS8yJigL16PwVkbmYKOeLEf+zz00UQDXMsINhEP4seDPC/CNqeE38L45X9lJBJqWF/zjKeKtGFNmOBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZq+hyUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZq+hyUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEA7C4CEE2;
	Wed, 16 Apr 2025 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744819680;
	bh=Cmzue8l0pLVe+48zM/5BU18veqvpBJNFW3D39isBb6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZq+hyUF/VPPHuc9i9W0ChGmOIXYFueUAVpVSoKPGPAoUR36boBBTZ4+koVA6vtag
	 SHgC/ZREJ1IwsT4MwdPymE68cX/Bqn0hSx5VGF/RRS425qzONq+vYGpDiPnft9QTi4
	 tqID8gLQEOhWxESR5ZPkBxigRSGS9cyJfOcnqyQEEk1262LLPFpy4k95kHJsplgBFY
	 Tl/P+R293EPOtRp4uK5eYGrcmXD6uLWOI2atC/SZlGi+PcEwpRELDMUPBrSNDT5ruB
	 r83Y5NKozN3ElHe7ADpjzi3XS2lwjklBFakQ/FszwgZkfX62DpAbQLHEuN2eor8bqj
	 qcLHncph8G11A==
Date: Wed, 16 Apr 2025 09:07:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: Re: [PATCH RFC 1/2] xfs_proto: add origin also for directories,
 chardevs and symlinks
Message-ID: <20250416160759.GH25675@frogsfrogsfrogs>
References: <20250416144400.940532-1-luca.dimaio1@gmail.com>
 <20250416144400.940532-2-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416144400.940532-2-luca.dimaio1@gmail.com>

On Wed, Apr 16, 2025 at 04:43:32PM +0200, Luca Di Maio wrote:
> In order to preserve timestamps when populating target filesystem, we
> need to have a reference to the original file.
> 
> This is already done with regular files, we extend this to dirs,
> symlinks and chardevices.
> 
> Excerpt of old protofile:
> 
> ```
> /
> 0 0
> d--755 0 0
> : Descending path rootfs
>  bin   l--777 0 0 usr/bin
>  lib64 l--777 0 0 lib
>  sbin  l--777 0 0 usr/bin
>  dev d--755 0 0
>   console c--620 0 0 5 1
>   null    c--666 0 0 1 3
>   random  c--666 0 0 1 8
>   urandom c--666 0 0 1 9
>   zero    c--666 0 0 1 5
>  $
>  lib d--755 0 0
>   ld-linux-x86-64.so.2   ---755 0 0 rootfs/lib/ld-linux-x86-64.so.2
> ```
> 
> Excerpt of new protofile:
> 
> ```
> /
> 0 0
> d--755 65534 65534 rootfs
> : Descending path rootfs
>  bin   l--777 65534 65534 usr/bin rootfs/bin
>  lib64 l--777 65534 65534 lib rootfs/lib64
>  sbin  l--777 65534 65534 usr/bin rootfs/sbin
>  $
>  dev d--755 65534 65534 rootfs/dev
>   console c--620 65534 65534 5 1 rootfs/dev/console
>   null    c--666 65534 65534 1 3 rootfs/dev/null
>   random  c--666 65534 65534 1 8 rootfs/dev/random
>   urandom c--666 65534 65534 1 9 rootfs/dev/urandom
>   zero    c--666 65534 65534 1 5 rootfs/dev/zero

The trouble is, this new field     ^^^^^^^^^^^^^^^ will break parsers,
which I'll talk about in the next email.

--D

>  $
>  lib d--755 0 0 rootfs/lib
>   ld-linux-x86-64.so.2   ---755 0 0 rootfs/lib/ld-linux-x86-64.so.2
> ```
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  mkfs/xfs_protofile.in | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
> index e83c39f..066265b 100644
> --- a/mkfs/xfs_protofile.in
> +++ b/mkfs/xfs_protofile.in
> @@ -51,12 +51,12 @@ def stat_to_str(statbuf):
>  def stat_to_extra(statbuf, fullpath):
>  	'''Compute the extras column for a protofile.'''
> 
> -	if stat.S_ISREG(statbuf.st_mode):
> +	if stat.S_ISREG(statbuf.st_mode) or stat.S_ISDIR(statbuf.st_mode):
>  		return ' %s' % fullpath
>  	elif stat.S_ISCHR(statbuf.st_mode) or stat.S_ISBLK(statbuf.st_mode):
> -		return ' %d %d' % (os.major(statbuf.st_rdev), os.minor(statbuf.st_rdev))
> +		return ' %d %d %s' % (os.major(statbuf.st_rdev), os.minor(statbuf.st_rdev), fullpath)
>  	elif stat.S_ISLNK(statbuf.st_mode):
> -		return ' %s' % os.readlink(fullpath)
> +		return ' %s %s' % (os.readlink(fullpath), fullpath)
>  	return ''
> 
>  def max_fname_len(s1):
> @@ -105,8 +105,8 @@ def walk_tree(path, depth):
>  		fullpath = os.path.join(path, fname)
>  		sb = os.lstat(fullpath)
>  		extra = stat_to_extra(sb, fullpath)
> -		print('%*s%s %s' % (depth, ' ', fname, \
> -				stat_to_str(sb)))
> +		print('%*s%s %s%s' % (depth, ' ', fname, \
> +				stat_to_str(sb), extra))
>  		walk_tree(fullpath, depth + 1)
> 
>  	if depth > 1:
> @@ -134,7 +134,7 @@ def main():
>  		statbuf = os.stat(args.paths[0])
>  		if not stat.S_ISDIR(statbuf.st_mode):
>  			raise NotADirectoryError(path)
> -		print(stat_to_str(statbuf))
> +		print(stat_to_str(statbuf), args.paths[0])
> 
>  		# All files under each path go in the root dir, recursively
>  		for path in args.paths:
> --
> 2.49.0
> 
