Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33D812B8C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 09:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfOx4vYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855D0C433C7;
	Mon, 18 Dec 2023 09:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702890416;
	bh=7CyqjFk/u3kmynJFNU3+MIkV3m1PzEt9120VyDGt+bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SfOx4vYq/qAhgn7vRNOj7sPkapIAXZLelapD9fhD4LGIb+A8NUzVATxIWqKAx41sZ
	 svLl9A1GDjf5SvVD+61V/JFGhauFM2zEGqQlwstD6EQMp9XLWEMPUAsvw3zPw0l3Ua
	 jW4hRXW6MDiDZauxXna/BiJ+1MD5LS9kJe/uOo0ZgGYIhBfJiGkvNlodlizV4wCXxo
	 9k6gyQnzrDUZPdzJ1KqxKLJWlEyGQS5QOXO2exIIwuvq87iF31mCLWaU535L+gHiVd
	 mmAtE4O6a3skd/biqSx117CliU4Gr4gBAYDf2xHlVWzqhh2TGVRmndrMbFsKHEQnd5
	 mpFV2y1TlKhmw==
Date: Mon, 18 Dec 2023 10:06:52 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] libxlog: don't require a libxfs_xinit structure
 for xlog_init
Message-ID: <6bqsoxq4ub7r2v744gb2dsetz52plkeoyfauffolgnih26qqnr@dfvyhhepxvbw>
References: <20231211163742.837427-1-hch@lst.de>
 <hsHgkYA32EOqRywZfwNcuDI6bmK5b7TChd0NvQFY4yX8jqzwbixT5AGZqgTKk1mME0uW_ebhXfNcqYIUCX0neQ==@protonmail.internalid>
 <20231211163742.837427-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-9-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:27PM +0100, Christoph Hellwig wrote:
> xlog_init currently requires a libxfs_args structure to be passed in,
> and then clobbers various log-related arguments to it.  There is no
> good reason for that as all the required information can be calculated
> without it.
> 
> Remove the x argument to xlog_init and xlog_is_dirty and the now unused
> logBBstart member in struct libxfs_xinit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  copy/xfs_copy.c     |  2 +-
>  db/metadump.c       |  4 ++--
>  db/sb.c             |  2 +-
>  include/libxfs.h    |  1 -
>  include/libxlog.h   |  4 ++--
>  libxfs/init.c       |  2 +-
>  libxlog/util.c      | 25 ++++++++++---------------
>  logprint/logprint.c |  2 +-
>  repair/phase2.c     |  2 +-
>  9 files changed, 19 insertions(+), 25 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 4bd473a04..86187086d 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -784,7 +784,7 @@ main(int argc, char **argv)
>  	 */
>  	memset(&xlog, 0, sizeof(struct xlog));
>  	mp->m_log = &xlog;
> -	c = xlog_is_dirty(mp, mp->m_log, &xargs);
> +	c = xlog_is_dirty(mp, mp->m_log);
>  	if (!duplicate) {
>  		if (c == 1) {
>  			do_log(_(
> diff --git a/db/metadump.c b/db/metadump.c
> index e57b024cd..bac35b9cc 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2615,7 +2615,7 @@ copy_log(void)
>  	if (!metadump.obfuscate && !metadump.zero_stale_data)
>  		goto done;
> 
> -	dirty = xlog_is_dirty(mp, &log, &x);
> +	dirty = xlog_is_dirty(mp, &log);
> 
>  	switch (dirty) {
>  	case 0:
> @@ -2945,7 +2945,7 @@ metadump_f(
>  		if (iocur_top->data) {	/* best effort */
>  			struct xlog	log;
> 
> -			if (xlog_is_dirty(mp, &log, &x))
> +			if (xlog_is_dirty(mp, &log))
>  				metadump.dirty_log = true;
>  		}
>  		pop_cur();
> diff --git a/db/sb.c b/db/sb.c
> index a3a4a758f..2f046c6aa 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -235,7 +235,7 @@ sb_logcheck(void)
> 
>  	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
> 
> -	dirty = xlog_is_dirty(mp, mp->m_log, &x);
> +	dirty = xlog_is_dirty(mp, mp->m_log);
>  	if (dirty == -1) {
>  		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
>  		return 0;
> diff --git a/include/libxfs.h b/include/libxfs.h
> index b35dc2184..270efb2c1 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -115,7 +115,6 @@ typedef struct libxfs_xinit {
>  	long long       logBBsize;      /* size of log subvolume (BBs) */
>  					/* (blocks allocated for use as
>  					 * log is stored in mount structure) */
> -	long long       logBBstart;     /* start block of log subvolume (BBs) */
>  	long long       rtsize;         /* size of realtime subvolume (BBs) */
>  	int		dbsize;		/* data subvolume device blksize */
>  	int		lbsize;		/* log subvolume device blksize */
> diff --git a/include/libxlog.h b/include/libxlog.h
> index 657acfe42..57f39e4e8 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -71,8 +71,8 @@ extern int	print_record_header;
>  /* libxfs parameters */
>  extern libxfs_init_t	x;
> 
> -void xlog_init(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
> -int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
> +void xlog_init(struct xfs_mount *mp, struct xlog *log);
> +int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log);
> 
>  extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
>  extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 894d84057..6482ba52b 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -304,7 +304,7 @@ libxfs_init(libxfs_init_t *a)
>  	a->dfd = a->logfd = a->rtfd = -1;
>  	a->ddev = a->logdev = a->rtdev = 0;
>  	a->dsize = a->lbsize = a->rtbsize = 0;
> -	a->dbsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
> +	a->dbsize = a->logBBsize = a->rtsize = 0;
> 
>  	flags = (a->isreadonly | a->isdirect);
> 
> diff --git a/libxlog/util.c b/libxlog/util.c
> index bc4db478e..d1377c2e2 100644
> --- a/libxlog/util.c
> +++ b/libxlog/util.c
> @@ -15,22 +15,18 @@ libxfs_init_t x;
>  void
>  xlog_init(
>  	struct xfs_mount	*mp,
> -	struct xlog		*log,
> -	libxfs_init_t		*x)
> +	struct xlog		*log)
>  {
> -	memset(log, 0, sizeof(*log));
> +	unsigned int		log_sect_size = BBSIZE;
> 
> -	/* We (re-)init members of libxfs_init_t here?  really? */
> -	x->logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> -	x->logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
> -	x->lbsize = BBSIZE;
> -	if (xfs_has_sector(mp))
> -		x->lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
> +	memset(log, 0, sizeof(*log));
> 
>  	log->l_dev = mp->m_logdev_targp;
> -	log->l_logBBsize = x->logBBsize;
> -	log->l_logBBstart = x->logBBstart;
> -	log->l_sectBBsize = BTOBB(x->lbsize);
> +	log->l_logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> +	log->l_logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
> +	if (xfs_has_sector(mp))
> +		log_sect_size <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
> +	log->l_sectBBsize  = BTOBB(log_sect_size);
>  	log->l_mp = mp;
>  	if (xfs_has_sector(mp)) {
>  		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
> @@ -50,13 +46,12 @@ xlog_init(
>  int
>  xlog_is_dirty(
>  	struct xfs_mount	*mp,
> -	struct xlog		*log,
> -	libxfs_init_t		*x)
> +	struct xlog		*log)
>  {
>  	int			error;
>  	xfs_daddr_t		head_blk, tail_blk;
> 
> -	xlog_init(mp, log, x);
> +	xlog_init(mp, log);
> 
>  	error = xlog_find_tail(log, &head_blk, &tail_blk);
>  	if (error) {
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index c78aeb2f8..bcdb6b359 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -85,7 +85,7 @@ logstat(
>  		mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
>  		mp->m_blkbb_log = sb->sb_blocklog - BBSHIFT;
> 
> -		xlog_init(mp, log, &x);
> +		xlog_init(mp, log);
> 
>  		if (!x.logname && sb->sb_logstart == 0) {
>  			fprintf(stderr, _("    external log device not specified\n\n"));
> diff --git a/repair/phase2.c b/repair/phase2.c
> index a9dd77be3..48263e161 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -30,7 +30,7 @@ zero_log(
>  	xfs_daddr_t		tail_blk;
>  	struct xlog		*log = mp->m_log;
> 
> -	xlog_init(mp, mp->m_log, &x);
> +	xlog_init(mp, mp->m_log);
> 
>  	/*
>  	 * Find the log head and tail and alert the user to the situation if the
> --
> 2.39.2
> 
> 
