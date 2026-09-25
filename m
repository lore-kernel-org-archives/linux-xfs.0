Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A4509EEB
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376445; cv=none; b=IRIhunnY4Jd10PgRHlNECPfnNqySiUl41X8HgYiDg4wJI/AQFScsQmBgS5nARVgMJu3y8ZknO3ugl9sspL15Er2E05/45YWhT9d1uoJ7upeMTnP5yz+lsrJkLqJtEQUPnAGpYXl94RP5lfiW0Wfup/D07llWI5X24H7AOnRZI0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376445; c=relaxed/simple;
	bh=Fr/wo+isV6BjU7mEQfcuOiRFX11shP1TwFWEGHNZDVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ex5QMlFs0DRM4d//7fzv+ehb0NYaBYq8VeEo9YAwWoZM3MSjIxh809NExJdM9AE75vUIhxjbDlqUAguPUEggtmFa47BccdYJCwDFcnVpBGrC77AOWDfupebHgzhzZ5cROOOcyHKFPK7yxU7ZMLSc2X/TXF831rpJQslktfTf0SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5oizUB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5oizUB2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9E3A1F000FF;
	Fri, 25 Sep 2026 22:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790376440;
	bh=e8XUJD8rjkzTOQyQDo5ABEiG0XWaa0cYZ/Nwv/cQPHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E5oizUB2j3Vlz8HZnDfZ54+JCYQabum1/vY7OyV9bUh5DshvdQljRcSbCvOFYsHB3
	 6RxeBN+a44QCIn3NN+AmLznp5aYjVcpPGJ/g/tlmcQxRGUflu0PyTk0EmrKXlHGyU9
	 XyYuWPPaqJ7yiqqh6T2KA6gDK5oHpFN5u5kEXncJVOvKfXWr/JKEXKz+IaKZ4fDX5V
	 LljlXA2cbCzXs3R6xfwomXdO5a5FCRS7EyGZZFw+YM6YPzQ5V3ahsuCNXM5DUJIRXS
	 gN0g+f4U5ggDCcNqWGo7wWlzG2LPjS+fnCJ9lnT9iygLGrRdtgtfILmFQtPrkFmmif
	 NKN+McgpeTz6g==
Date: Fri, 25 Sep 2026 15:47:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] libfrog: improve ramdisk handling in
 platform_flush_device
Message-ID: <20260925224720.GX2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-10-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:55AM +0200, Christoph Hellwig wrote:
> The ramdisk driver was quirky for BLKFLSBUF, but there never was
> any reason to skip the fsync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  copy/xfs_copy.c    |  2 +-
>  libfrog/linux.c    | 13 ++++++-------
>  libfrog/platform.h |  2 +-
>  libxfs/init.c      |  2 +-
>  libxfs/rdwr.c      |  6 ++++--
>  5 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 5435c87dba38..4692a4ffb961 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -141,7 +141,7 @@ check_errors(void)
>  
>  	for (i = 0; i < num_targets; i++)  {
>  		if (target[i].state != INACTIVE) {
> -			if (platform_flush_device(target[i].fd, 0)) {
> +			if (platform_flush_device(target[i].fd)) {
>  				target[i].error = errno;
>  				target[i].state = INACTIVE;
>  				target[i].err_type = 2;
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 46a5ff39e2eb..5c0d3ed7e935 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -152,15 +152,11 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize,
>   */
>  int
>  platform_flush_device(
> -	int		fd,
> -	dev_t		device)
> +	int		fd)
>  {
>  	struct stat	st;
>  	int		ret;
>  
> -	if (major(device) == RAMDISK_MAJOR)
> -		return 0;
> -
>  	ret = fsync(fd);
>  	if (ret)
>  		return ret;
> @@ -169,9 +165,12 @@ platform_flush_device(
>  	if (ret)
>  		return ret;
>  
> -	if (S_ISBLK(st.st_mode))
> +	/*
> +	 * Historically the ram disk driver destroyed all data when BLKFLSBUF
> +	 * was called.  That has been fixed a long time, but still be careful.
> +	 */
> +	if (S_ISBLK(st.st_mode) && major(st.st_rdev) != RAMDISK_MAJOR)
>  		return ioctl(fd, BLKFLSBUF, 0);

BLKFLSBUF support on ramdisks hasn't been in the kernel since commit
ff26956875c2f0 ("brd: remove support for BLKFLSBUF") which was merged in
4.10 in late 2016.  Maybe we should remove it?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> -
>  	return 0;
>  }
>  
> diff --git a/libfrog/platform.h b/libfrog/platform.h
> index 20f9bdf5ce5b..39d558f08629 100644
> --- a/libfrog/platform.h
> +++ b/libfrog/platform.h
> @@ -12,7 +12,7 @@ int platform_check_ismounted(char *path, char *block, struct stat *sptr,
>  int platform_check_iswritable(char *path, char *block, struct stat *sptr);
>  void platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
>  		bool fatal);
> -int platform_flush_device(int fd, dev_t device);
> +int platform_flush_device(int fd);
>  int platform_direct_blockdev(void);
>  int platform_align_blockdev(void);
>  unsigned long platform_physmem(void);	/* in kilobytes */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 5a4b255165ab..4c71027d2805 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -172,7 +172,7 @@ libxfs_device_close(
>  {
>  	int			ret;
>  
> -	ret = platform_flush_device(dev->fd, dev->dev);
> +	ret = platform_flush_device(dev->fd);
>  	if (ret) {
>  		ret = -errno;
>  		fprintf(stderr,
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 837288be0307..33a0d144a1aa 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1112,8 +1112,10 @@ libxfs_blkdev_issue_flush(
>  	if (btp->bt_dev == 0)
>  		return 0;
>  
> -	ret = platform_flush_device(btp->bt_fd, btp->bt_dev);
> -	return ret ? -errno : 0;
> +	ret = platform_flush_device(btp->bt_fd);
> +	if (ret)
> +		return -errno;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
