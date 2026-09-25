Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F6647CA77
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790376187; cv=none; b=ItmBEK3xcUrVKAmKhMQTSFmx7wD5QFb2qaubw8uqef9W2+NJulJD+z1IRMp0JcaQwnQqwQXUYLOoBbqw+nvyLvy/+u1BfwILI66RfgNssfHI1pvX13r0jpp/nYDJhSyuaKtvwtz374mI5IW1PAwmg7pRv+OnXB6TECzKfO+UXoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790376187; c=relaxed/simple;
	bh=fS3/gtib5sGmzGqbRCebiVLkKGrcGvF8FxOlqRgPYL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmPFKFEW2OE66xyxhe3H5sKXE8Oq4dzxJKlicNv3M/0gkR87FGD09AXpDYj41BiNBTz+WiMbO9E2xBTeu30VQ5Eads0zkZaOF4RAOQrZhDdVNUKE0fPr9cUW6B93xLIIezk4rfULNVQxgaxVjpER/Ok6rS7CoGbi2HSZrPjlcJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2F4Bn2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2F4Bn2h"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B27BD1F00893;
	Fri, 25 Sep 2026 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790376182;
	bh=Cos8eUEyFGtto4GJ1ewBEiDMgEIC5+FPP3bC/PJrfaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E2F4Bn2h9+G6qeJ/7Hrlww38tUmynp1gfXI91HvrCFvjwdLn9trkPQSmaJKFWf95c
	 bBtCShAVB/GhwAktV+ORWvdj3icHHFaLX+lNo6WKLq9198dN9boSLXHzYSWJoULUWh
	 1UcMjHcp8t9bNTxpjQ34GosllZkYTu/NsI3GVmjPgdOVBNlGS0OWKGr8eM3eLVbBK4
	 JCYL9KFOacpqavF18C8tIwQ8DuYJaakQF9a5nYE587H3zhIwDq9YXxCAAqhPZTNO8j
	 i939o+f/SthketTURJ/0SGAhTmgzTe372rF2uEIeXsBD9mZ7hqOQsWKtbAFE8HhtQD
	 lDxs47rZZPsbQ==
Date: Fri, 25 Sep 2026 15:43:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] libxfs: rename bt_bdev*
Message-ID: <20260925224302.GW2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-9-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:54AM +0200, Christoph Hellwig wrote:
> Unlike the kernel, there is no block device concept in libxfs.
> 
> Rename the bt_bdev field to bt_dev as it stores a dev_t, and bt_bdev_fd
> to just bt_fd to make the naming a bit less confusing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Make sense to me;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/buf_mem.c   |  4 ++--
>  libxfs/init.c      | 10 +++++-----
>  libxfs/libxfs_io.h |  4 ++--
>  libxfs/rdwr.c      | 12 ++++++------
>  repair/prefetch.c  |  2 +-
>  repair/zoned.c     |  2 +-
>  6 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
> index 3c8452de9689..f3db59dfc63e 100644
> --- a/libxfs/buf_mem.c
> +++ b/libxfs/buf_mem.c
> @@ -294,8 +294,8 @@ xmbuf_alloc(
>  
>  	/* Initialize buffer target */
>  	btp->bt_mount = mp;
> -	btp->bt_bdev = (dev_t)-1;
> -	btp->bt_bdev_fd = -1;
> +	btp->bt_dev = (dev_t)-1;
> +	btp->bt_fd = -1;
>  	btp->bt_xfile = xfile;
>  	btp->bcache = cache;
>  
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 97c5286c00a9..5a4b255165ab 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -457,8 +457,8 @@ libxfs_buftarg_alloc(
>  		exit(1);
>  	}
>  	btp->bt_mount = mp;
> -	btp->bt_bdev = dev->dev;
> -	btp->bt_bdev_fd = dev->fd;
> +	btp->bt_dev = dev->dev;
> +	btp->bt_fd = dev->fd;
>  	btp->bt_xfile = NULL;
>  	btp->flags = 0;
>  	pthread_mutex_init(&btp->lock, NULL);
> @@ -534,7 +534,7 @@ libxfs_buftarg_reinit(
>  	struct xfs_mount	*mp,
>  	struct libxfs_init	*xi)
>  {
> -	if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
> +	if (mp->m_ddev_targp->bt_dev != xi->data.dev ||
>  	    mp->m_ddev_targp->bt_mount != mp) {
>  		fprintf(stderr,
>  			_("%s: bad buftarg reinit, ddev\n"),
> @@ -544,7 +544,7 @@ libxfs_buftarg_reinit(
>  
>  	if (mp->m_logdev_targp != mp->m_ddev_targp) {
>  		if ((xi->log.dev && xi->log.dev == xi->data.dev) ||
> -		    mp->m_logdev_targp->bt_bdev != xi->log.dev ||
> +		    mp->m_logdev_targp->bt_dev != xi->log.dev ||
>  		    mp->m_logdev_targp->bt_mount != mp) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, logdev\n"),
> @@ -554,7 +554,7 @@ libxfs_buftarg_reinit(
>  	}
>  
>  	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> -		if (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
> +		if (mp->m_rtdev_targp->bt_dev != xi->rt.dev ||
>  		    mp->m_rtdev_targp->bt_mount != mp) {
>  			fprintf(stderr,
>  				_("%s: bad buftarg reinit, rtdev\n"),
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 5562e2928254..d861763a2a63 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -25,8 +25,8 @@ struct xfs_buftarg {
>  	struct xfs_mount	*bt_mount;
>  	pthread_mutex_t		lock;
>  	unsigned long		writes_left;
> -	dev_t			bt_bdev;
> -	int			bt_bdev_fd;
> +	dev_t			bt_dev;
> +	int			bt_fd;
>  	struct xfile		*bt_xfile;
>  	unsigned int		flags;
>  	struct cache		*bcache;	/* buffer cache */
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 14cfec7a2859..837288be0307 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -62,7 +62,7 @@ static void libxfs_brelse(struct cache_node *node);
>  int
>  libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  {
> -	int		fd = btp->bt_bdev_fd;
> +	int		fd = btp->bt_fd;
>  	xfs_off_t	start_offset, end_offset, offset;
>  	ssize_t		zsize, bytes;
>  	size_t		len_bytes;
> @@ -608,7 +608,7 @@ int
>  libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
>  		int len, int flags)
>  {
> -	int	fd = btp->bt_bdev_fd;
> +	int	fd = btp->bt_fd;
>  	int	bytes = BBTOB(len);
>  	int	error;
>  
> @@ -644,7 +644,7 @@ libxfs_readbuf_verify(
>  int
>  libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
>  {
> -	int	fd = btp->bt_bdev_fd;
> +	int	fd = btp->bt_fd;
>  	int	error = 0;
>  	void	*buf;
>  	int	i;
> @@ -834,7 +834,7 @@ int
>  libxfs_bwrite(
>  	struct xfs_buf	*bp)
>  {
> -	int		fd = bp->b_target->bt_bdev_fd;
> +	int		fd = bp->b_target->bt_fd;
>  
>  	/*
>  	 * we never write buffers that are marked stale. This indicates they
> @@ -1109,10 +1109,10 @@ libxfs_blkdev_issue_flush(
>  {
>  	int			ret;
>  
> -	if (btp->bt_bdev == 0)
> +	if (btp->bt_dev == 0)
>  		return 0;
>  
> -	ret = platform_flush_device(btp->bt_bdev_fd, btp->bt_bdev);
> +	ret = platform_flush_device(btp->bt_fd, btp->bt_dev);
>  	return ret ? -errno : 0;
>  }
>  
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 3d26636e5e56..3e03ae7f0210 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -878,7 +878,7 @@ init_prefetch(
>  	xfs_mount_t		*pmp)
>  {
>  	mp = pmp;
> -	mp_fd = mp->m_ddev_targp->bt_bdev_fd;;
> +	mp_fd = mp->m_ddev_targp->bt_fd;;
>  	pf_max_bytes = sysconf(_SC_PAGE_SIZE) << 7;
>  	pf_max_bbs = pf_max_bytes >> BBSHIFT;
>  	pf_max_fsbs = pf_max_bytes >> mp->m_sb.sb_blocklog;
> diff --git a/repair/zoned.c b/repair/zoned.c
> index 6ab91371d95a..1e949f549583 100644
> --- a/repair/zoned.c
> +++ b/repair/zoned.c
> @@ -50,7 +50,7 @@ void
>  check_zones(
>  	struct xfs_mount	*mp)
>  {
> -	int			fd = mp->m_rtdev_targp->bt_bdev_fd;
> +	int			fd = mp->m_rtdev_targp->bt_fd;
>  	uint64_t		sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
>  	unsigned int		zone_size, zone_capacity;
>  	uint64_t		device_size;
> -- 
> 2.53.0
> 
> 
