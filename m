Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5872C111BE
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 09:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Um62rjGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B07AC433C8;
	Mon, 18 Dec 2023 09:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702890056;
	bh=k6TwKBkGyd7KWE1G5uJz8rEbcAFDTW4dxPGa8p38ySo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Um62rjGJH+XU47YKvUDquKJp9wBMmM8RjWNNF7oNPG9IXZDUMu2mNQEe6HKmH5le1
	 Fdb/+RzUq3pUMX8jxcxrltsBiFvBuChlaz/rXk1P1liCNG6++OTV1FgaXR0xeegRKh
	 Aux2hcVoNS/GhgOd9jh2kjXYzRPMA/8K4ZGHoKMCK9CLr7H3syivvJ/vyXbj8jxNSK
	 g3oEfLw+NJ9caGy0WLYUGFmYVJYQEnByVsWgYUl5M8tFL9laLsEcTBH3ZylZkciQZf
	 A+tJUVv10Bq+ZV38a5wtlkOGYG6D6aymdFu22D1K3nNNTGZlOLt2ViZ9IiKw3VQUsc
	 9fZHIMUAc90Bg==
Date: Mon, 18 Dec 2023 10:00:52 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/23] libxlog: add a helper to initialize a xlog without
 clobbering the x structure
Message-ID: <lgtc5lmxwnjhvtq5twjqn47g2ozvw7nwqkcqgyomb2vwizb4gq@77gj7jk3gvmw>
References: <20231211163742.837427-1-hch@lst.de>
 <TV8Be63Hur822KToXK-zj6UJa0eaiPsZqBcokYikB7QlWJlJFRHRLG3lLhgLeWvZmztT2bqhnrsCPFDBIW2DCw==@protonmail.internalid>
 <20231211163742.837427-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-8-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:26PM +0100, Christoph Hellwig wrote:
> xfsprogs has three copies of a code sequence to initialize an xlog
> structure from a libxfs_init structure. Factor the code into a helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  include/libxlog.h   |  1 +
>  libxlog/util.c      | 25 +++++++++++++++++--------
>  logprint/logprint.c | 25 +++++++++----------------
>  repair/phase2.c     | 23 +----------------------
>  4 files changed, 28 insertions(+), 46 deletions(-)
> 
> diff --git a/include/libxlog.h b/include/libxlog.h
> index a598a7b3c..657acfe42 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -71,6 +71,7 @@ extern int	print_record_header;
>  /* libxfs parameters */
>  extern libxfs_init_t	x;
> 
> +void xlog_init(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
>  int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
> 
>  extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
> diff --git a/libxlog/util.c b/libxlog/util.c
> index 1022e3378..bc4db478e 100644
> --- a/libxlog/util.c
> +++ b/libxlog/util.c
> @@ -12,18 +12,12 @@ int print_skip_uuid;
>  int print_record_header;
>  libxfs_init_t x;
> 
> -/*
> - * Return 1 for dirty, 0 for clean, -1 for errors
> - */
> -int
> -xlog_is_dirty(
> +void
> +xlog_init(
>  	struct xfs_mount	*mp,
>  	struct xlog		*log,
>  	libxfs_init_t		*x)
>  {
> -	int			error;
> -	xfs_daddr_t		head_blk, tail_blk;
> -
>  	memset(log, 0, sizeof(*log));
> 
>  	/* We (re-)init members of libxfs_init_t here?  really? */
> @@ -48,6 +42,21 @@ xlog_is_dirty(
>  		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
>  	}
>  	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
> +}
> +
> +/*
> + * Return 1 for dirty, 0 for clean, -1 for errors
> + */
> +int
> +xlog_is_dirty(
> +	struct xfs_mount	*mp,
> +	struct xlog		*log,
> +	libxfs_init_t		*x)
> +{
> +	int			error;
> +	xfs_daddr_t		head_blk, tail_blk;
> +
> +	xlog_init(mp, log, x);
> 
>  	error = xlog_find_tail(log, &head_blk, &tail_blk);
>  	if (error) {
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index 7d51cdd91..c78aeb2f8 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -58,7 +58,6 @@ logstat(
>  {
>  	int		fd;
>  	char		buf[BBSIZE];
> -	xfs_sb_t	*sb;
> 
>  	/* On Linux we always read the superblock of the
>  	 * filesystem. We need this to get the length of the
> @@ -77,19 +76,16 @@ logstat(
>  	close (fd);
> 
>  	if (!x.disfile) {
> +		struct xfs_sb	*sb = &mp->m_sb;
> +
>  		/*
>  		 * Conjure up a mount structure
>  		 */
> -		sb = &mp->m_sb;
>  		libxfs_sb_from_disk(sb, (struct xfs_dsb *)buf);
>  		mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
>  		mp->m_blkbb_log = sb->sb_blocklog - BBSHIFT;
> 
> -		x.logBBsize = XFS_FSB_TO_BB(mp, sb->sb_logblocks);
> -		x.logBBstart = XFS_FSB_TO_DADDR(mp, sb->sb_logstart);
> -		x.lbsize = BBSIZE;
> -		if (xfs_has_sector(mp))
> -			x.lbsize <<= (sb->sb_logsectlog - BBSHIFT);
> +		xlog_init(mp, log, &x);
> 
>  		if (!x.logname && sb->sb_logstart == 0) {
>  			fprintf(stderr, _("    external log device not specified\n\n"));
> @@ -100,16 +96,13 @@ logstat(
>  		struct stat	s;
> 
>  		stat(x.dname, &s);
> -		x.logBBsize = s.st_size >> 9;
> -		x.logBBstart = 0;
> -		x.lbsize = BBSIZE;
> -	}
> 
> -	log->l_dev = mp->m_logdev_targp;
> -	log->l_logBBstart = x.logBBstart;
> -	log->l_logBBsize = x.logBBsize;
> -	log->l_sectBBsize = BTOBB(x.lbsize);
> -	log->l_mp = mp;
> +		log->l_logBBsize = s.st_size >> 9;
> +		log->l_logBBstart = 0;
> +		log->l_sectBBsize = BTOBB(BBSIZE);
> +		log->l_dev = mp->m_logdev_targp;
> +		log->l_mp = mp;
> +	}
> 
>  	if (x.logname && *x.logname) {    /* External log */
>  		if ((fd = open(x.logname, O_RDONLY)) == -1) {
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 2ada95aef..a9dd77be3 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -30,28 +30,7 @@ zero_log(
>  	xfs_daddr_t		tail_blk;
>  	struct xlog		*log = mp->m_log;
> 
> -	memset(log, 0, sizeof(struct xlog));
> -	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> -	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
> -	x.lbsize = BBSIZE;
> -	if (xfs_has_sector(mp))
> -		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
> -
> -	log->l_dev = mp->m_logdev_targp;
> -	log->l_logBBsize = x.logBBsize;
> -	log->l_logBBstart = x.logBBstart;
> -	log->l_sectBBsize  = BTOBB(x.lbsize);
> -	log->l_mp = mp;
> -	if (xfs_has_sector(mp)) {
> -		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
> -		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
> -		/* for larger sector sizes, must have v2 or external log */
> -		ASSERT(log->l_sectbb_log == 0 ||
> -			log->l_logBBstart == 0 ||
> -			xfs_has_logv2(mp));
> -		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
> -	}
> -	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
> +	xlog_init(mp, mp->m_log, &x);
> 
>  	/*
>  	 * Find the log head and tail and alert the user to the situation if the
> --
> 2.39.2
> 
