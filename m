Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45CEC7FD1
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 12:11:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 26C878F808E
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 10:11:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ExVUYHREIcvrnIic (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 10:11:17 -0700 (PDT)
Date: Wed, 3 Jun 2015 13:11:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfsprogs: add xlog_is_empty() helper
Message-ID: <20150603171114.GB45447@bfoster.bfoster>
References: <5568B7CE.9030709@redhat.com>
 <5568B8B6.2050706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5568B8B6.2050706@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Fri, May 29, 2015 at 02:06:30PM -0500, Eric Sandeen wrote:
> xfs_repair and xfs_db both check for a dirty log, using roughly
> the same cut and pasted code.
> 
> Add a new helper to do this, xlog_is_dirty(), and use it instead.
> 
> Note, the helper (and the code before it) is a little odd in that
> it (re-)initializes some libxfs_init_t members before proceeding,
> I haven't yet worked out if that's necessary or correct, so I've
> just kept the same behavior for now.  Still, it seems like this
> should be done in libxfs_init, or not at all.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Yeah, messing with the libxfs_init structure seems strange, but it looks
like it preserves current behavior to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/sb.c           |   21 ++++---------------
>  include/libxlog.h |    2 +
>  libxlog/util.c    |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/phase2.c   |   55 +++++++++++----------------------------------------
>  4 files changed, 75 insertions(+), 59 deletions(-)
> 
> diff --git a/db/sb.c b/db/sb.c
> index 991478d..f9d39e6 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -225,8 +225,7 @@ int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
>  int
>  sb_logcheck(void)
>  {
> -	struct xlog	log;
> -	xfs_daddr_t	head_blk, tail_blk;
> +	int		dirty;
>  
>  	if (mp->m_sb.sb_logstart) {
>  		if (x.logdev && x.logdev != x.ddev) {
> @@ -242,25 +241,14 @@ sb_logcheck(void)
>  		}
>  	}
>  
> -	memset(&log, 0, sizeof(log));
>  	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
> -	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> -	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
> -	x.lbsize = BBSIZE;
> -	if (xfs_sb_version_hassector(&mp->m_sb))
> -		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
> -
> -	log.l_dev = mp->m_logdev_targp;
> -	log.l_logBBsize = x.logBBsize;
> -	log.l_logBBstart = x.logBBstart;
> -	log.l_sectBBsize  = BTOBB(x.lbsize);
> -	log.l_mp = mp;
> -
> -	if (xlog_find_tail(&log, &head_blk, &tail_blk)) {
> +
> +	dirty = xlog_is_dirty(mp, &x, 0);
> +
> +	if (dirty == -1) {
>  		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
>  		return 0;
> -	}
> -	if (head_blk != tail_blk) {
> +	} else if (dirty == 1) {
>  		dbprintf(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
>  "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
> @@ -270,6 +258,7 @@ sb_logcheck(void)
>  "of the filesystem before doing this.\n"), progname);
>  		return 0;
>  	}
> +	/* Log is clean */
>  	return 1;
>  }
>  
> diff --git a/include/libxlog.h b/include/libxlog.h
> index e6d915c..c6640a8 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -83,6 +83,8 @@ extern int	print_record_header;
>  /* libxfs parameters */
>  extern libxfs_init_t	x;
>  
> +
> +extern int xlog_is_dirty(xfs_mount_t *mp, libxfs_init_t *x, int verbose);
>  extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
>  extern void	xlog_put_bp(struct xfs_buf *);
>  extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
> diff --git a/libxlog/util.c b/libxlog/util.c
> index 053cf04..498c06c 100644
> --- a/libxlog/util.c
> +++ b/libxlog/util.c
> @@ -24,6 +24,62 @@ int print_skip_uuid;
>  int print_record_header;
>  libxfs_init_t x;
>  
> +/*
> + * Return 1 for dirty, 0 for clean, -1 for errors
> + */
> +int
> +xlog_is_dirty(
> +	xfs_mount_t *mp,
> +	libxfs_init_t *x,
> +	int verbose)
> +{
> +	int error;
> +	struct xlog	log;
> +	xfs_daddr_t head_blk, tail_blk;
> +
> +	memset(&log, 0, sizeof(log));
> +
> +	/* We (re-)init members of libxfs_init_t here?  really? */
> +	x->logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> +	x->logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
> +	x->lbsize = BBSIZE;
> +	if (xfs_sb_version_hassector(&mp->m_sb))
> +		x->lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
> +
> +	log.l_dev = mp->m_logdev_targp;
> +	log.l_logBBsize = x->logBBsize;
> +	log.l_logBBstart = x->logBBstart;
> +	log.l_sectBBsize = BTOBB(x->lbsize);
> +	log.l_mp = mp;
> +	if (xfs_sb_version_hassector(&mp->m_sb)) {
> +		log.l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
> +		ASSERT(log.l_sectbb_log <= mp->m_sectbb_log);
> +		/* for larger sector sizes, must have v2 or external log */
> +		ASSERT(log.l_sectbb_log == 0 ||
> +			log.l_logBBstart == 0 ||
> +			xfs_sb_version_haslogv2(&mp->m_sb));
> +		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
> +	}
> +	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
> +
> +	if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
> +		xlog_warn(_("%s: cannot find log head/tail "
> +			  "(xlog_find_tail=%d)\n"),
> +			__func__, error);
> +		return -1;
> +	}
> +
> +	if (verbose)
> +		xlog_warn(
> +	_("%s: head block %" PRId64 " tail block %" PRId64 "\n"),
> +			__func__, head_blk, tail_blk);
> +
> +	if (head_blk != tail_blk)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static int
>  header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
>  {
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 983aaa7..a23f472 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -38,62 +38,31 @@ int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
>  static void
>  zero_log(xfs_mount_t *mp)
>  {
> -	int error;
> -	struct xlog	log;
> -	xfs_daddr_t head_blk, tail_blk;
> -
> -	memset(&log, 0, sizeof(log));
> -	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
> -	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
> -	x.lbsize = BBSIZE;
> -	if (xfs_sb_version_hassector(&mp->m_sb))
> -		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
> -
> -	log.l_dev = mp->m_logdev_targp;
> -	log.l_logBBsize = x.logBBsize;
> -	log.l_logBBstart = x.logBBstart;
> -	log.l_sectBBsize  = BTOBB(x.lbsize);
> -	log.l_mp = mp;
> -	if (xfs_sb_version_hassector(&mp->m_sb)) {
> -		log.l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
> -		ASSERT(log.l_sectbb_log <= mp->m_sectbb_log);
> -		/* for larger sector sizes, must have v2 or external log */
> -		ASSERT(log.l_sectbb_log == 0 ||
> -			log.l_logBBstart == 0 ||
> -			xfs_sb_version_haslogv2(&mp->m_sb));
> -		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
> -	}
> -	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
> -
> -	if ((error = xlog_find_tail(&log, &head_blk, &tail_blk))) {
> -		do_warn(_("zero_log: cannot find log head/tail "
> -			  "(xlog_find_tail=%d), zeroing it anyway\n"),
> -			error);
> -	} else {
> -		if (verbose) {
> -			do_warn(
> -	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
> -				head_blk, tail_blk);
> -		}
> -		if (head_blk != tail_blk) {
> -			if (zap_log) {
> -				do_warn(_(
> +	int		dirty;
> +
> +	dirty = xlog_is_dirty(mp, &x, verbose);
> +
> +	if (dirty == -1)
> +		do_warn(_("zero_log: cannot find log head/tail, "
> +			  "zeroing it anyway\n"));
> +	else if (dirty == 1) {
> +		if (zap_log) {
> +			do_warn(_(
>  "ALERT: The filesystem has valuable metadata changes in a log which is being\n"
>  "destroyed because the -L option was used.\n"));
> -			} else {
> -				do_warn(_(
> +		} else {
> +			do_warn(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
>  "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
>  "re-running xfs_repair.  If you are unable to mount the filesystem, then use\n"
>  "the -L option to destroy the log and attempt a repair.\n"
>  "Note that destroying the log may cause corruption -- please attempt a mount\n"
>  "of the filesystem before doing this.\n"));
> -				exit(2);
> -			}
> +			exit(2);
>  		}
>  	}
>  
> -	libxfs_log_clear(log.l_dev,
> +	libxfs_log_clear(mp->m_logdev_targp,
>  		XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>  		(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
>  		&mp->m_sb.sb_uuid,
> -- 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
