Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKGD4nY193166 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 10:13:04 -0600
Date: Tue, 20 Nov 2012 10:15:11 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
Message-ID: <20121120161511.GE27055@sgi.com>
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121119213913.GB29498@quack.suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

Hi Jan,

On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:
> On Tue 13-11-12 01:36:13, Jan Kara wrote:
> > When project quota gets exceeded xfs_iomap_write_delay() ends up flushing
> > inodes because ENOSPC gets returned from xfs_bmapi_delay() instead of EDQUOT.
> > This makes handling of writes over project quota rather slow as a simple test
> > program shows:
> > 	fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > 	for (i = 0; i < 50000; i++)
> > 		pwrite(fd, buf, 4096, i*4096);
> > 
> > Writing 200 MB like this into a directory with 100 MB project quota takes
> > around 6 minutes while it takes about 2 seconds with this patch applied. This
> > actually happens in a real world load when nfs pushes data into a directory
> > which is over project quota.
> > 
> > Fix the problem by replacing XFS_QMOPT_ENOSPC flag with XFS_QMOPT_EPDQUOT.
> > That makes xfs_trans_reserve_quota_bydquots() return new error EPDQUOT when
> > project quota is exceeded. xfs_bmapi_delay() then uses this flag so that
> > xfs_iomap_write_delay() can distinguish real ENOSPC (requiring flushing)
> > from exceeded project quota (not requiring flushing).
> > 
> > As a side effect this patch fixes inconsistency where e.g. xfs_create()
> > returned EDQUOT even when project quota was exceeded.
>   Ping? Any opinions?

I think that there may be good reason to flush inodes even in the project quota
case.  Speculative allocation beyond EOF might need to be cleaned up.  I'm all
for passing back some data about why we hit ENOSPC.  Then we can combine this
with Brian Foster's work and flush only inodes that touch a given project,
user, or group quota.

-Ben


> 
> 								Honza
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_bmap.c        |    3 ++-
> >  fs/xfs/xfs_iomap.c       |    8 ++++++--
> >  fs/xfs/xfs_linux.h       |    1 +
> >  fs/xfs/xfs_qm.c          |   13 +++++--------
> >  fs/xfs/xfs_quota.h       |    2 +-
> >  fs/xfs/xfs_trans_dquot.c |   18 +++++++++---------
> >  6 files changed, 24 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> > index 848ffa7..027398f 100644
> > --- a/fs/xfs/xfs_bmap.c
> > +++ b/fs/xfs/xfs_bmap.c
> > @@ -4471,7 +4471,8 @@ xfs_bmapi_reserve_delalloc(
> >  	 * allocated blocks already inside this loop.
> >  	 */
> >  	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
> > -			rt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
> > +			XFS_QMOPT_EPDQUOT |
> > +			(rt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS));
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 973dff6..86e8016 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -428,6 +428,7 @@ retry:
> >  	case 0:
> >  	case ENOSPC:
> >  	case EDQUOT:
> > +	case EPDQUOT:
> >  		break;
> >  	default:
> >  		return XFS_ERROR(error);
> > @@ -441,8 +442,11 @@ retry:
> >  	 */
> >  	if (nimaps == 0) {
> >  		trace_xfs_delalloc_enospc(ip, offset, count);
> > -		if (flushed)
> > -			return XFS_ERROR(error ? error : ENOSPC);
> > +		if (flushed) {
> > +			if (error == 0 || error == EPDQUOT)
> > +				error = ENOSPC;
> > +			return XFS_ERROR(error);
> > +		}
> >  
> >  		if (error == ENOSPC) {
> >  			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> > index 828662f..31368df 100644
> > --- a/fs/xfs/xfs_linux.h
> > +++ b/fs/xfs/xfs_linux.h
> > @@ -145,6 +145,7 @@
> >  #define ENOATTR		ENODATA		/* Attribute not found */
> >  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
> >  #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
> > +#define EPDQUOT		EXFULL		/* Project quota exceeded */
> >  
> >  #define SYNCHRONIZE()	barrier()
> >  #define __return_address __builtin_return_address(0)
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 2e86fa0..99ace03 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1790,7 +1790,7 @@ xfs_qm_vop_chown_reserve(
> >  	uint		flags)
> >  {
> >  	xfs_mount_t	*mp = ip->i_mount;
> > -	uint		delblks, blkflags, prjflags = 0;
> > +	uint		delblks, blkflags;
> >  	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
> >  	int		error;
> >  
> > @@ -1817,11 +1817,8 @@ xfs_qm_vop_chown_reserve(
> >  		}
> >  	}
> >  	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
> > -		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
> > -		     xfs_get_projid(ip) != be32_to_cpu(gdqp->q_core.d_id))
> > -			prjflags = XFS_QMOPT_ENOSPC;
> > -
> > -		if (prjflags ||
> > +		if ((XFS_IS_PQUOTA_ON(ip->i_mount) &&
> > +		     xfs_get_projid(ip) != be32_to_cpu(gdqp->q_core.d_id)) ||
> >  		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
> >  		     ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id))) {
> >  			delblksgdq = gdqp;
> > @@ -1834,7 +1831,7 @@ xfs_qm_vop_chown_reserve(
> >  
> >  	if ((error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
> >  				delblksudq, delblksgdq, ip->i_d.di_nblocks, 1,
> > -				flags | blkflags | prjflags)))
> > +				flags | blkflags)))
> >  		return (error);
> >  
> >  	/*
> > @@ -1851,7 +1848,7 @@ xfs_qm_vop_chown_reserve(
> >  		ASSERT(unresudq || unresgdq);
> >  		if ((error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> >  				delblksudq, delblksgdq, (xfs_qcnt_t)delblks, 0,
> > -				flags | blkflags | prjflags)))
> > +				flags | blkflags)))
> >  			return (error);
> >  		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> >  				unresudq, unresgdq, -((xfs_qcnt_t)delblks), 0,
> > diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> > index b50ec5b..264b455 100644
> > --- a/fs/xfs/xfs_quota.h
> > +++ b/fs/xfs/xfs_quota.h
> > @@ -203,7 +203,7 @@ typedef struct xfs_qoff_logformat {
> >  #define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
> >  #define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
> >  #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
> > -#define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
> > +#define XFS_QMOPT_EPDQUOT	0x0004000 /* return EPDQUOT when project quota exceeded */
> >  
> >  /*
> >   * flags to xfs_trans_mod_dquot to indicate which field needs to be
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 0c7fa54..27acce3 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -728,8 +728,6 @@ xfs_trans_dqresv(
> >  
> >  error_return:
> >  	xfs_dqunlock(dqp);
> > -	if (flags & XFS_QMOPT_ENOSPC)
> > -		return ENOSPC;
> >  	return EDQUOT;
> >  }
> >  
> > @@ -741,7 +739,6 @@ error_return:
> >   * approach.
> >   *
> >   * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
> > - *	   XFS_QMOPT_ENOSPC returns ENOSPC not EDQUOT.  Used by pquota.
> >   *	   XFS_TRANS_DQ_RES_BLKS reserves regular disk blocks
> >   *	   XFS_TRANS_DQ_RES_RTBLKS reserves realtime disk blocks
> >   * dquots are unlocked on return, if they were not locked by caller.
> > @@ -767,8 +764,7 @@ xfs_trans_reserve_quota_bydquots(
> >  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
> >  
> >  	if (udqp) {
> > -		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
> > -					(flags & ~XFS_QMOPT_ENOSPC));
> > +		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
> >  		if (error)
> >  			return error;
> >  		resvd = 1;
> > @@ -785,6 +781,12 @@ xfs_trans_reserve_quota_bydquots(
> >  				xfs_trans_dqresv(tp, mp, udqp,
> >  						 -nblks, -ninos, flags);
> >  			}
> > +			if (error == EDQUOT && XFS_IS_PQUOTA_ON(mp)) {
> > +				if (flags & XFS_QMOPT_EPDQUOT)
> > +					error = EPDQUOT;
> > +				else
> > +					error = ENOSPC;
> > +			}
> >  			return error;
> >  		}
> >  	}
> > @@ -813,16 +815,14 @@ xfs_trans_reserve_quota_nblks(
> >  
> >  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> >  		return 0;
> > -	if (XFS_IS_PQUOTA_ON(mp))
> > -		flags |= XFS_QMOPT_ENOSPC;
> >  
> >  	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
> >  	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
> > +	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_EPDQUOT)) ==
> >  				XFS_TRANS_DQ_RES_RTBLKS ||
> > -	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
> > +	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_EPDQUOT)) ==
> >  				XFS_TRANS_DQ_RES_BLKS);
> >  
> >  	/*
> > -- 
> > 1.7.1
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
