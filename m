Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CEFC67F54
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 14:57:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C3588F804B
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:57:21 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KF2BZVFr5kmOjKBg for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2013 12:57:19 -0800 (PST)
Message-ID: <510837AE.4020807@sandeen.net>
Date: Tue, 29 Jan 2013 14:57:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: add agskip=value mount option
References: <20130129153914.801475275@sgi.com>
	<20130129153914.976867239@sgi.com>
In-Reply-To: <20130129153914.976867239@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On 1/29/13 9:39 AM, rjohnston@sgi.com wrote:
> The agskip mount option specifies  the allocation group, (AG) for a new
> file, relative to the start of the last created file. agskip has the
> opposite effect of the rotorstep  system tunable  parameter.   Each
> new  file  to  be placed in the location lastAG + agskipValue,
> where lastAG is the allocation group of the last created file.
> 
> For example, agskip=3 means each new file will be  allocated  three  AGs  away
> from the starting AG of the most recently created file.
> 
> The agskip mount option disables the rotorstep system tunable parameter.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com> 
> ---
>  fs/xfs/xfs_alloc.c      |   35 ++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_filestream.c |    8 +++++++-
>  fs/xfs/xfs_mount.c      |    1 +
>  fs/xfs/xfs_mount.h      |    4 +++-
>  fs/xfs/xfs_super.c      |   13 ++++++++++++-
>  5 files changed, 51 insertions(+), 10 deletions(-)
> 
> Index: b/fs/xfs/xfs_alloc.c
> ===================================================================
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -2365,12 +2365,20 @@ xfs_alloc_vextent(
>  		 * Try near allocation first, then anywhere-in-ag after
>  		 * the first a.g. fails.
>  		 */
> -		if ((args->userdata  == XFS_ALLOC_INITIAL_USER_DATA) &&
> -		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
> -			args->fsbno = XFS_AGB_TO_FSB(mp,
> -					((mp->m_agfrotor / rotorstep) %
> -					mp->m_sb.sb_agcount), 0);
> -			bump_rotor = 1;
> +		if (args->userdata == XFS_ALLOC_INITIAL_USER_DATA) {
> +			if (mp->m_flags & XFS_MOUNT_AGSKIP) {
> +				spin_lock(&mp->m_agfrotor_lock);

Hm, this seems like a bigger deal than the m_agirotor_lock, no?
That one got taken for dir creation or for AG sips, but this
is taken for every new file?

Also, I guess I had expected that this might cause new dirs to rotor
around, but it looks like with this option,there is no locality
of files in dirs (just like there is not with inode32, IIRC).
Is that correct? (and is that desired?)

> +				args->fsbno = XFS_AGB_TO_FSB(mp,
> +					mp->m_agfrotor, 0);
> +				mp->m_agfrotor = (mp->m_agfrotor + mp->m_agskip)
> +					% mp->m_sb.sb_agcount;
> +				spin_unlock(&mp->m_agfrotor_lock);
> +			} else if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +				args->fsbno = XFS_AGB_TO_FSB(mp,
> +						((mp->m_agfrotor / rotorstep) %
> +						mp->m_sb.sb_agcount), 0);
> +				bump_rotor = 1;
> +			}
>  		}
>  		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
>  		args->type = XFS_ALLOCTYPE_NEAR_BNO;
> @@ -2385,8 +2393,21 @@ xfs_alloc_vextent(
>  			/*
>  			 * Start with the last place we left off.
>  			 */
> -			args->agno = sagno = (mp->m_agfrotor / rotorstep) %
> +                        if (mp->m_flags & XFS_MOUNT_AGSKIP) {

tabs please

> +				/*
> +				 * The spinlock makes the combined assignment
> +				 * of args->fsbno and mp->m_agfrotor atomic.
> +				 * mp->m_agfrotor can not be advanced until
> +				 * args->fsbno is assigned.
> +				*/
> +                                spin_lock(&mp->m_agfrotor_lock);
> +                                sagno = mp->m_agfrotor;
> +                                spin_unlock(&mp->m_agfrotor_lock);

tabs please



> +                        } else {
> +				sagno = (mp->m_agfrotor / rotorstep) %
>  					mp->m_sb.sb_agcount;
> +			}
> +			args->agno = sagno;
>  			args->type = XFS_ALLOCTYPE_THIS_AG;
>  			flags = XFS_ALLOC_FLAG_TRYLOCK;
>  		} else if (type == XFS_ALLOCTYPE_FIRST_AG) {
> Index: b/fs/xfs/xfs_filestream.c
> ===================================================================
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -622,7 +622,13 @@ xfs_filestream_associate(
>  	 * Set the starting AG using the rotor for inode32, otherwise
>  	 * use the directory inode's AG.
>  	 */
> -	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +	if (mp->m_flags & XFS_MOUNT_AGSKIP) {
> +		spin_lock(&mp->m_agfrotor_lock);
> +		startag = mp->m_agfrotor;
> +		mp->m_agfrotor = (mp->m_agfrotor + mp->m_agskip)
> +			% mp->m_sb.sb_agcount;
> +		spin_unlock(&mp->m_agfrotor_lock);
> +	} else if (mp->m_flags & XFS_MOUNT_32BITINODES) {
>  		rotorstep = xfs_rotorstep;
>  		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
>  		mp->m_agfrotor = (mp->m_agfrotor + 1) %
> Index: b/fs/xfs/xfs_mount.c
> ===================================================================
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -768,6 +768,7 @@ STATIC void
>  xfs_mount_common(xfs_mount_t *mp, xfs_sb_t *sbp)
>  {
>  	mp->m_agfrotor = mp->m_agirotor = 0;
> +	spin_lock_init(&mp->m_agfrotor_lock);
>  	spin_lock_init(&mp->m_agirotor_lock);
>  	mp->m_maxagi = mp->m_sb.sb_agcount;
>  	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
> Index: b/fs/xfs/xfs_mount.h
> ===================================================================
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -119,6 +119,7 @@ typedef struct xfs_mount {
>  	char			*m_logname;	/* external log device name */
>  	int			m_bsize;	/* fs logical block size */
>  	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
> +	spinlock_t		m_agfrotor_lock;/* .. and lock protecting it */
>  	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
>  	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
>  	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> @@ -203,6 +204,7 @@ typedef struct xfs_mount {
>  	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
>  	int64_t			m_low_space[XFS_LOWSP_MAX];
>  						/* low free space thresholds */
> +	int			m_agskip;	/* extent allocation stride */

Not sure I grok that comment.  But then we don't have a real description yet
anyway - just be sure it matches the described behavior, I guess?

>  
>  	struct workqueue_struct	*m_data_workqueue;
>  	struct workqueue_struct	*m_unwritten_workqueue;
> @@ -246,7 +248,7 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
>  						   allocator */
>  #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
> -
> +#define XFS_MOUNT_AGSKIP	(1ULL << 26)	/* extent allocation stride */
>  
>  /*
>   * Default minimum read and write sizes.
> Index: b/fs/xfs/xfs_super.c
> ===================================================================
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -114,7 +114,7 @@ mempool_t *xfs_ioend_pool;
>  #define MNTOPT_NODELAYLOG  "nodelaylog"	/* Delayed logging disabled */
>  #define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
>  #define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
> -
> +#define MNTOPT_AGSKIP      "agskip"	/* initial extent allocation stride */

tabs please

>  /*
>   * Table driven mount option parser.
>   *
> @@ -383,6 +383,15 @@ xfs_parseargs(
>  		} else if (!strcmp(this_char, "irixsgid")) {
>  			xfs_warn(mp,
>  	"irixsgid is now a sysctl(2) variable, option is deprecated.");
> +		} else if (!strcmp(this_char, MNTOPT_AGSKIP)) {
> +			if (!value || !*value) {
> +				xfs_warn(mp,
> +					"%s option requires an argument",
> +					this_char);
> +				return EINVAL;
> +			}
> +			mp->m_flags |= XFS_MOUNT_AGSKIP;
> +			mp->m_agskip = simple_strtoul(value, &eov, 10);
>  		} else {
>  			xfs_warn(mp, "unknown mount option [%s].", this_char);
>  			return EINVAL;
> @@ -567,6 +576,8 @@ xfs_showargs(
>  
>  	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
>  		seq_puts(m, "," MNTOPT_NOQUOTA);
> +	if (mp->m_flags & XFS_MOUNT_AGSKIP)
> +		seq_printf(m, "," MNTOPT_AGSKIP "=%d", mp->m_agskip);
>  
>  	return 0;
>  }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
