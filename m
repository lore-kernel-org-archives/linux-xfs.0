Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2T7iYVn118097 for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:44:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20F9F13D8322
	for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:44:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IqTDL7kRtB6hkzlV for
	<xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:44:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Lnpgf-0004LR-2S
	for xfs@oss.sgi.com; Sun, 29 Mar 2009 07:44:09 +0000
Date: Sun, 29 Mar 2009 03:44:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: kill xfs_qmops
Message-ID: <20090329074408.GB16402@infradead.org>
References: <20090224143736.GA16616@infradead.org>
	<20090316075529.GA22373@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316075529.GA22373@infradead.org>
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
To: xfs@oss.sgi.com

ping^2?

On Mon, Mar 16, 2009 at 03:55:29AM -0400, Christoph Hellwig wrote:
> ping?
> 
> On Tue, Feb 24, 2009 at 09:37:36AM -0500, Christoph Hellwig wrote:
> > 
> > Kill the quota ops function vector and replace it with direct calls or
> > stubs in the CONFIG_XFS_QUOTA=n case.
> > 
> > Make sure we check XFS_IS_QUOTA_RUNNING in the right spots.  We can remove
> > the number of those checks because the XFS_TRANS_DQ_DIRTY flag can't be set
> > otherwise.
> > 
> > This brings us back closer to the way this code worked in IRIX and earlier
> > Linux versions, but we keep a lot of the more useful factoring of common
> > code.
> > 
> > Eventually we should also kill xfs_qm_bhv.c, but that's left for a later
> > patch.
> > 
> > Reduces the size of the source code by about 250 lines and the size of
> > XFS module by about 1.5 kilobytes with quotas enabled:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >  615957	   2960	   3848	 622765	  980ad	fs/xfs/xfs.o
> >  617231	   3152	   3848	 624231	  98667	fs/xfs/xfs.o.old
> > 
> > 
> > Fallout:
> > 
> >  - xfs_qm_dqattach is split into xfs_qm_dqattach_locked which expects
> >    the inode locked and xfs_qm_dqattach which does the locking around it,
> >    thus removing XFS_QMOPT_ILOCKED.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2009-02-24 15:32:16.063369993 +0100
> > +++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2009-02-24 15:32:35.845494182 +0100
> > @@ -111,7 +111,7 @@ xfs_trans_log_dquot(
> >   * Carry forward whatever is left of the quota blk reservation to
> >   * the spanky new transaction
> >   */
> > -STATIC void
> > +void
> >  xfs_trans_dup_dqinfo(
> >  	xfs_trans_t	*otp,
> >  	xfs_trans_t	*ntp)
> > @@ -167,19 +167,17 @@ xfs_trans_dup_dqinfo(
> >  /*
> >   * Wrap around mod_dquot to account for both user and group quotas.
> >   */
> > -STATIC void
> > +void
> >  xfs_trans_mod_dquot_byino(
> >  	xfs_trans_t	*tp,
> >  	xfs_inode_t	*ip,
> >  	uint		field,
> >  	long		delta)
> >  {
> > -	xfs_mount_t	*mp;
> > +	xfs_mount_t	*mp = tp->t_mountp;
> >  
> > -	ASSERT(tp);
> > -	mp = tp->t_mountp;
> > -
> > -	if (!XFS_IS_QUOTA_ON(mp) ||
> > +	if (!XFS_IS_QUOTA_RUNNING(mp) ||
> > +	    !XFS_IS_QUOTA_ON(mp) ||
> >  	    ip->i_ino == mp->m_sb.sb_uquotino ||
> >  	    ip->i_ino == mp->m_sb.sb_gquotino)
> >  		return;
> > @@ -229,6 +227,7 @@ xfs_trans_mod_dquot(
> >  	xfs_dqtrx_t	*qtrx;
> >  
> >  	ASSERT(tp);
> > +	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
> >  	qtrx = NULL;
> >  
> >  	if (tp->t_dqinfo == NULL)
> > @@ -346,7 +345,7 @@ xfs_trans_dqlockedjoin(
> >   * Unreserve just the reservations done by this transaction.
> >   * dquot is still left locked at exit.
> >   */
> > -STATIC void
> > +void
> >  xfs_trans_apply_dquot_deltas(
> >  	xfs_trans_t		*tp)
> >  {
> > @@ -357,7 +356,7 @@ xfs_trans_apply_dquot_deltas(
> >  	long			totalbdelta;
> >  	long			totalrtbdelta;
> >  
> > -	if (! (tp->t_flags & XFS_TRANS_DQ_DIRTY))
> > +	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> >  		return;
> >  
> >  	ASSERT(tp->t_dqinfo);
> > @@ -531,7 +530,7 @@ xfs_trans_apply_dquot_deltas(
> >   * we simply throw those away, since that's the expected behavior
> >   * when a transaction is curtailed without a commit.
> >   */
> > -STATIC void
> > +void
> >  xfs_trans_unreserve_and_mod_dquots(
> >  	xfs_trans_t		*tp)
> >  {
> > @@ -768,6 +767,8 @@ xfs_trans_reserve_quota_bydquots(
> >  {
> >  	int		resvd = 0, error;
> >  
> > +	if (!XFS_IS_QUOTA_RUNNING(mp))
> > +		return 0;
> >  	if (!XFS_IS_QUOTA_ON(mp))
> >  		return 0;
> >  
> > @@ -811,17 +812,18 @@ xfs_trans_reserve_quota_bydquots(
> >   * This doesn't change the actual usage, just the reservation.
> >   * The inode sent in is locked.
> >   */
> > -STATIC int
> > +int
> >  xfs_trans_reserve_quota_nblks(
> > -	xfs_trans_t	*tp,
> > -	xfs_mount_t	*mp,
> > -	xfs_inode_t	*ip,
> > -	long		nblks,
> > -	long		ninos,
> > -	uint		flags)
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	long			nblks,
> > +	long			ninos,
> > +	uint			flags)
> >  {
> > -	int		error;
> > +	struct xfs_mount	*mp = ip->i_mount;
> >  
> > +	if (!XFS_IS_QUOTA_RUNNING(mp))
> > +		return 0;
> >  	if (!XFS_IS_QUOTA_ON(mp))
> >  		return 0;
> >  	if (XFS_IS_PQUOTA_ON(mp))
> > @@ -831,7 +833,6 @@ xfs_trans_reserve_quota_nblks(
> >  	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
> >  	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
> >  				XFS_TRANS_DQ_RES_RTBLKS ||
> >  	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
> > @@ -840,11 +841,9 @@ xfs_trans_reserve_quota_nblks(
> >  	/*
> >  	 * Reserve nblks against these dquots, with trans as the mediator.
> >  	 */
> > -	error = xfs_trans_reserve_quota_bydquots(tp, mp,
> > -						 ip->i_udquot, ip->i_gdquot,
> > -						 nblks, ninos,
> > -						 flags);
> > -	return error;
> > +	return xfs_trans_reserve_quota_bydquots(tp, mp,
> > +						ip->i_udquot, ip->i_gdquot,
> > +						nblks, ninos, flags);
> >  }
> >  
> >  /*
> > @@ -895,25 +894,15 @@ STATIC void
> >  xfs_trans_alloc_dqinfo(
> >  	xfs_trans_t	*tp)
> >  {
> > -	(tp)->t_dqinfo = kmem_zone_zalloc(xfs_Gqm->qm_dqtrxzone, KM_SLEEP);
> > +	tp->t_dqinfo = kmem_zone_zalloc(xfs_Gqm->qm_dqtrxzone, KM_SLEEP);
> >  }
> >  
> > -STATIC void
> > +void
> >  xfs_trans_free_dqinfo(
> >  	xfs_trans_t	*tp)
> >  {
> >  	if (!tp->t_dqinfo)
> >  		return;
> > -	kmem_zone_free(xfs_Gqm->qm_dqtrxzone, (tp)->t_dqinfo);
> > -	(tp)->t_dqinfo = NULL;
> > +	kmem_zone_free(xfs_Gqm->qm_dqtrxzone, tp->t_dqinfo);
> > +	tp->t_dqinfo = NULL;
> >  }
> > -
> > -xfs_dqtrxops_t	xfs_trans_dquot_ops = {
> > -	.qo_dup_dqinfo			= xfs_trans_dup_dqinfo,
> > -	.qo_free_dqinfo			= xfs_trans_free_dqinfo,
> > -	.qo_mod_dquot_byino		= xfs_trans_mod_dquot_byino,
> > -	.qo_apply_dquot_deltas		= xfs_trans_apply_dquot_deltas,
> > -	.qo_reserve_quota_nblks		= xfs_trans_reserve_quota_nblks,
> > -	.qo_reserve_quota_bydquots	= xfs_trans_reserve_quota_bydquots,
> > -	.qo_unreserve_and_mod_dquots	= xfs_trans_unreserve_and_mod_dquots,
> > -};
> > Index: xfs/fs/xfs/xfs_quota.h
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_quota.h	2009-02-24 15:32:16.089369812 +0100
> > +++ xfs/fs/xfs/xfs_quota.h	2009-02-24 15:32:35.846494310 +0100
> > @@ -197,7 +197,6 @@ typedef struct xfs_qoff_logformat {
> >  #define XFS_QMOPT_UMOUNTING	0x0000100 /* filesys is being unmounted */
> >  #define XFS_QMOPT_DOLOG		0x0000200 /* log buf changes (in quotacheck) */
> >  #define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
> > -#define XFS_QMOPT_ILOCKED	0x0000800 /* inode is already locked (excl) */
> >  #define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
> >  #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
> >  #define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
> > @@ -302,69 +301,72 @@ typedef struct xfs_dqtrx {
> >  	long		qt_delrtb_delta;  /* delayed RT blk count changes */
> >  } xfs_dqtrx_t;
> >  
> > -/*
> > - * Dquot transaction functions, used if quota is enabled.
> > - */
> > -typedef void	(*qo_dup_dqinfo_t)(struct xfs_trans *, struct xfs_trans *);
> > -typedef void	(*qo_mod_dquot_byino_t)(struct xfs_trans *,
> > -				struct xfs_inode *, uint, long);
> > -typedef void	(*qo_free_dqinfo_t)(struct xfs_trans *);
> > -typedef void	(*qo_apply_dquot_deltas_t)(struct xfs_trans *);
> > -typedef void	(*qo_unreserve_and_mod_dquots_t)(struct xfs_trans *);
> > -typedef int	(*qo_reserve_quota_nblks_t)(
> > -				struct xfs_trans *, struct xfs_mount *,
> > -				struct xfs_inode *, long, long, uint);
> > -typedef int	(*qo_reserve_quota_bydquots_t)(
> > -				struct xfs_trans *, struct xfs_mount *,
> > -				struct xfs_dquot *, struct xfs_dquot *,
> > -				long, long, uint);
> > -typedef struct xfs_dqtrxops {
> > -	qo_dup_dqinfo_t			qo_dup_dqinfo;
> > -	qo_free_dqinfo_t		qo_free_dqinfo;
> > -	qo_mod_dquot_byino_t		qo_mod_dquot_byino;
> > -	qo_apply_dquot_deltas_t		qo_apply_dquot_deltas;
> > -	qo_reserve_quota_nblks_t	qo_reserve_quota_nblks;
> > -	qo_reserve_quota_bydquots_t	qo_reserve_quota_bydquots;
> > -	qo_unreserve_and_mod_dquots_t	qo_unreserve_and_mod_dquots;
> > -} xfs_dqtrxops_t;
> > -
> > -#define XFS_DQTRXOP(mp, tp, op, args...) \
> > -		((mp)->m_qm_ops->xfs_dqtrxops ? \
> > -		((mp)->m_qm_ops->xfs_dqtrxops->op)(tp, ## args) : 0)
> > -
> > -#define XFS_DQTRXOP_VOID(mp, tp, op, args...) \
> > -		((mp)->m_qm_ops->xfs_dqtrxops ? \
> > -		((mp)->m_qm_ops->xfs_dqtrxops->op)(tp, ## args) : (void)0)
> > -
> > -#define XFS_TRANS_DUP_DQINFO(mp, otp, ntp) \
> > -	XFS_DQTRXOP_VOID(mp, otp, qo_dup_dqinfo, ntp)
> > -#define XFS_TRANS_FREE_DQINFO(mp, tp) \
> > -	XFS_DQTRXOP_VOID(mp, tp, qo_free_dqinfo)
> > -#define XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, field, delta) \
> > -	XFS_DQTRXOP_VOID(mp, tp, qo_mod_dquot_byino, ip, field, delta)
> > -#define XFS_TRANS_APPLY_DQUOT_DELTAS(mp, tp) \
> > -	XFS_DQTRXOP_VOID(mp, tp, qo_apply_dquot_deltas)
> > -#define XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, nblks, ninos, fl) \
> > -	XFS_DQTRXOP(mp, tp, qo_reserve_quota_nblks, mp, ip, nblks, ninos, fl)
> > -#define XFS_TRANS_RESERVE_QUOTA_BYDQUOTS(mp, tp, ud, gd, nb, ni, fl) \
> > -	XFS_DQTRXOP(mp, tp, qo_reserve_quota_bydquots, mp, ud, gd, nb, ni, fl)
> > -#define XFS_TRANS_UNRESERVE_AND_MOD_DQUOTS(mp, tp) \
> > -	XFS_DQTRXOP_VOID(mp, tp, qo_unreserve_and_mod_dquots)
> > -
> > -#define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp, tp, ip, nblks, ninos, flags) \
> > -	XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, -(nblks), -(ninos), flags)
> > -#define XFS_TRANS_RESERVE_QUOTA(mp, tp, ud, gd, nb, ni, f) \
> > -	XFS_TRANS_RESERVE_QUOTA_BYDQUOTS(mp, tp, ud, gd, nb, ni, \
> > -				f | XFS_QMOPT_RES_REGBLKS)
> > -#define XFS_TRANS_UNRESERVE_QUOTA(mp, tp, ud, gd, nb, ni, f) \
> > -	XFS_TRANS_RESERVE_QUOTA_BYDQUOTS(mp, tp, ud, gd, -(nb), -(ni), \
> > +#ifdef CONFIG_XFS_QUOTA
> > +extern void xfs_trans_dup_dqinfo(struct xfs_trans *, struct xfs_trans *);
> > +extern void xfs_trans_free_dqinfo(struct xfs_trans *);
> > +extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
> > +		uint, long);
> > +extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
> > +extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
> > +extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
> > +		struct xfs_inode *, long, long, uint);
> > +extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
> > +		struct xfs_mount *, struct xfs_dquot *,
> > +		struct xfs_dquot *, long, long, uint);
> > +
> > +extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
> > +		struct xfs_dquot **, struct xfs_dquot **);
> > +extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
> > +		struct xfs_dquot *, struct xfs_dquot *);
> > +extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
> > +extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
> > +		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
> > +extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
> > +		struct xfs_dquot *, struct xfs_dquot *, uint);
> > +extern int xfs_qm_dqattach(struct xfs_inode *, uint);
> > +extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
> > +extern void xfs_qm_dqdetach(struct xfs_inode *);
> > +extern void xfs_qm_dqrele(struct xfs_dquot *);
> > +extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
> > +extern int xfs_qm_sync(struct xfs_mount *, int);
> > +extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
> > +extern void xfs_qm_mount_quotas(struct xfs_mount *);
> > +extern void xfs_qm_unmount(struct xfs_mount *);
> > +extern void xfs_qm_unmount_quotas(struct xfs_mount *);
> > +
> > +#else
> > +#define xfs_trans_dup_dqinfo(tp, tp2)
> > +#define xfs_trans_free_dqinfo(tp)
> > +#define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
> > +#define xfs_trans_apply_dquot_deltas(tp)
> > +#define xfs_trans_unreserve_and_mod_dquots(tp)
> > +#define xfs_trans_reserve_quota_nblks(tp, ip, nblks, ninos, flags)	(0)
> > +#define xfs_trans_reserve_quota_bydquots(tp, mp, u, g, nb, ni, fl)	(0)
> > +#define xfs_qm_vop_dqalloc(ip, uid, gid, prid, fl, ou, og)		(0)
> > +#define xfs_qm_vop_create_dqattach(tp, ip, u, g)
> > +#define xfs_qm_vop_rename_dqattach(it)					(0)
> > +#define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
> > +#define xfs_qm_vop_chown_reserve(tp, ip, u, g, fl)			(0)
> > +#define xfs_qm_dqattach(ip, fl)						(0)
> > +#define xfs_qm_dqattach_locked(ip, fl)					(0)
> > +#define xfs_qm_dqdetach(ip)
> > +#define xfs_qm_dqrele(d)
> > +#define xfs_qm_statvfs(ip, s)
> > +#define xfs_qm_sync(mp, fl)						(0)
> > +#define xfs_qm_newmount(mp, a, b)					(0)
> > +#define xfs_qm_mount_quotas(mp)
> > +#define xfs_qm_unmount(mp)
> > +#define xfs_qm_unmount_quotas(mp)					(0)
> > +#endif /* CONFIG_XFS_QUOTA */
> > +
> > +#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
> > +	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
> > +#define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
> > +	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
> >  				f | XFS_QMOPT_RES_REGBLKS)
> >  
> >  extern int xfs_qm_dqcheck(xfs_disk_dquot_t *, xfs_dqid_t, uint, uint, char *);
> >  extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
> >  
> > -extern struct xfs_qmops xfs_qmcore_xfs;
> > -
> >  #endif	/* __KERNEL__ */
> > -
> >  #endif	/* __XFS_QUOTA_H__ */
> > Index: xfs/fs/xfs/xfs_trans.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_trans.c	2009-02-24 15:32:16.093370321 +0100
> > +++ xfs/fs/xfs/xfs_trans.c	2009-02-24 15:32:35.847494368 +0100
> > @@ -297,7 +297,7 @@ xfs_trans_dup(
> >  	tp->t_rtx_res = tp->t_rtx_res_used;
> >  	ntp->t_pflags = tp->t_pflags;
> >  
> > -	XFS_TRANS_DUP_DQINFO(tp->t_mountp, tp, ntp);
> > +	xfs_trans_dup_dqinfo(tp, ntp);
> >  
> >  	atomic_inc(&tp->t_mountp->m_active_trans);
> >  	return ntp;
> > @@ -831,7 +831,7 @@ shut_us_down:
> >  		 * means is that we have some (non-persistent) quota
> >  		 * reservations that need to be unreserved.
> >  		 */
> > -		XFS_TRANS_UNRESERVE_AND_MOD_DQUOTS(mp, tp);
> > +		xfs_trans_unreserve_and_mod_dquots(tp);
> >  		if (tp->t_ticket) {
> >  			commit_lsn = xfs_log_done(mp, tp->t_ticket,
> >  							NULL, log_flags);
> > @@ -850,10 +850,9 @@ shut_us_down:
> >  	/*
> >  	 * If we need to update the superblock, then do it now.
> >  	 */
> > -	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
> > +	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
> >  		xfs_trans_apply_sb_deltas(tp);
> > -	}
> > -	XFS_TRANS_APPLY_DQUOT_DELTAS(mp, tp);
> > +	xfs_trans_apply_dquot_deltas(tp);
> >  
> >  	/*
> >  	 * Ask each log item how many log_vector entries it will
> > @@ -1058,7 +1057,7 @@ xfs_trans_uncommit(
> >  	}
> >  
> >  	xfs_trans_unreserve_and_mod_sb(tp);
> > -	XFS_TRANS_UNRESERVE_AND_MOD_DQUOTS(tp->t_mountp, tp);
> > +	xfs_trans_unreserve_and_mod_dquots(tp);
> >  
> >  	xfs_trans_free_items(tp, flags);
> >  	xfs_trans_free_busy(tp);
> > @@ -1183,7 +1182,7 @@ xfs_trans_cancel(
> >  	}
> >  #endif
> >  	xfs_trans_unreserve_and_mod_sb(tp);
> > -	XFS_TRANS_UNRESERVE_AND_MOD_DQUOTS(mp, tp);
> > +	xfs_trans_unreserve_and_mod_dquots(tp);
> >  
> >  	if (tp->t_ticket) {
> >  		if (flags & XFS_TRANS_RELEASE_LOG_RES) {
> > @@ -1213,7 +1212,7 @@ xfs_trans_free(
> >  	xfs_trans_t	*tp)
> >  {
> >  	atomic_dec(&tp->t_mountp->m_active_trans);
> > -	XFS_TRANS_FREE_DQINFO(tp->t_mountp, tp);
> > +	xfs_trans_free_dqinfo(tp);
> >  	kmem_zone_free(xfs_trans_zone, tp);
> >  }
> >  
> > Index: xfs/fs/xfs/xfs_utils.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_utils.c	2009-02-24 15:32:16.098369701 +0100
> > +++ xfs/fs/xfs/xfs_utils.c	2009-02-24 15:32:35.848494914 +0100
> > @@ -166,7 +166,7 @@ xfs_dir_ialloc(
> >  			xfs_buf_relse(ialloc_context);
> >  			if (dqinfo) {
> >  				tp->t_dqinfo = dqinfo;
> > -				XFS_TRANS_FREE_DQINFO(tp->t_mountp, tp);
> > +				xfs_trans_free_dqinfo(tp);
> >  			}
> >  			*tpp = ntp;
> >  			*ipp = NULL;
> > Index: xfs/fs/xfs/xfs_bmap.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_bmap.c	2009-02-24 15:32:16.102370140 +0100
> > +++ xfs/fs/xfs/xfs_bmap.c	2009-02-24 15:32:35.853494922 +0100
> > @@ -2691,7 +2691,7 @@ xfs_bmap_rtalloc(
> >  		 * Adjust the disk quota also. This was reserved
> >  		 * earlier.
> >  		 */
> > -		XFS_TRANS_MOD_DQUOT_BYINO(mp, ap->tp, ap->ip,
> > +		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> >  			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
> >  					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
> >  	} else {
> > @@ -2995,7 +2995,7 @@ xfs_bmap_btalloc(
> >  		 * Adjust the disk quota also. This was reserved
> >  		 * earlier.
> >  		 */
> > -		XFS_TRANS_MOD_DQUOT_BYINO(mp, ap->tp, ap->ip,
> > +		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> >  			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
> >  					XFS_TRANS_DQ_BCOUNT,
> >  			(long) args.len);
> > @@ -3066,7 +3066,7 @@ xfs_bmap_btree_to_extents(
> >  		return error;
> >  	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
> >  	ip->i_d.di_nblocks--;
> > -	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> > +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> >  	xfs_trans_binval(tp, cbp);
> >  	if (cur->bc_bufs[0] == cbp)
> >  		cur->bc_bufs[0] = NULL;
> > @@ -3386,7 +3386,7 @@ xfs_bmap_del_extent(
> >  	 * Adjust quota data.
> >  	 */
> >  	if (qfield)
> > -		XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, qfield, (long)-nblks);
> > +		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
> >  
> >  	/*
> >  	 * Account for change in delayed indirect blocks.
> > @@ -3523,7 +3523,7 @@ xfs_bmap_extents_to_btree(
> >  	*firstblock = cur->bc_private.b.firstblock = args.fsbno;
> >  	cur->bc_private.b.allocated++;
> >  	ip->i_d.di_nblocks++;
> > -	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
> > +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
> >  	abp = xfs_btree_get_bufl(mp, tp, args.fsbno, 0);
> >  	/*
> >  	 * Fill in the child block.
> > @@ -3666,7 +3666,7 @@ xfs_bmap_local_to_extents(
> >  		XFS_BMAP_TRACE_POST_UPDATE("new", ip, 0, whichfork);
> >  		XFS_IFORK_NEXT_SET(ip, whichfork, 1);
> >  		ip->i_d.di_nblocks = 1;
> > -		XFS_TRANS_MOD_DQUOT_BYINO(args.mp, tp, ip,
> > +		xfs_trans_mod_dquot_byino(tp, ip,
> >  			XFS_TRANS_DQ_BCOUNT, 1L);
> >  		flags |= xfs_ilog_fext(whichfork);
> >  	} else {
> > @@ -4024,7 +4024,7 @@ xfs_bmap_add_attrfork(
> >  			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
> >  		goto error0;
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, blks, 0, rsvd ?
> > +	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
> >  			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
> >  			XFS_QMOPT_RES_REGBLKS);
> >  	if (error) {
> > @@ -4959,10 +4959,11 @@ xfs_bmapi(
> >  				 * adjusted later.  We return if we haven't
> >  				 * allocated blocks already inside this loop.
> >  				 */
> > -				if ((error = XFS_TRANS_RESERVE_QUOTA_NBLKS(
> > -						mp, NULL, ip, (long)alen, 0,
> > +				error = xfs_trans_reserve_quota_nblks(
> > +						NULL, ip, (long)alen, 0,
> >  						rt ? XFS_QMOPT_RES_RTBLKS :
> > -						     XFS_QMOPT_RES_REGBLKS))) {
> > +						     XFS_QMOPT_RES_REGBLKS);
> > +				if (error) {
> >  					if (n == 0) {
> >  						*nmap = 0;
> >  						ASSERT(cur == NULL);
> > @@ -5011,8 +5012,8 @@ xfs_bmapi(
> >  					if (XFS_IS_QUOTA_ON(mp))
> >  						/* unreserve the blocks now */
> >  						(void)
> > -						XFS_TRANS_UNRESERVE_QUOTA_NBLKS(
> > -							mp, NULL, ip,
> > +						xfs_trans_unreserve_quota_nblks(
> > +							NULL, ip,
> >  							(long)alen, 0, rt ?
> >  							XFS_QMOPT_RES_RTBLKS :
> >  							XFS_QMOPT_RES_REGBLKS);
> > @@ -5667,14 +5668,14 @@ xfs_bunmapi(
> >  				do_div(rtexts, mp->m_sb.sb_rextsize);
> >  				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
> >  						(int64_t)rtexts, rsvd);
> > -				(void)XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,
> > -					NULL, ip, -((long)del.br_blockcount), 0,
> > +				(void)xfs_trans_reserve_quota_nblks(NULL,
> > +					ip, -((long)del.br_blockcount), 0,
> >  					XFS_QMOPT_RES_RTBLKS);
> >  			} else {
> >  				xfs_mod_incore_sb(mp, XFS_SBS_FDBLOCKS,
> >  						(int64_t)del.br_blockcount, rsvd);
> > -				(void)XFS_TRANS_RESERVE_QUOTA_NBLKS(mp,
> > -					NULL, ip, -((long)del.br_blockcount), 0,
> > +				(void)xfs_trans_reserve_quota_nblks(NULL,
> > +					ip, -((long)del.br_blockcount), 0,
> >  					XFS_QMOPT_RES_REGBLKS);
> >  			}
> >  			ip->i_delayed_blks -= del.br_blockcount;
> > Index: xfs/fs/xfs/xfs_bmap_btree.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_bmap_btree.c	2009-02-24 15:32:16.106369811 +0100
> > +++ xfs/fs/xfs/xfs_bmap_btree.c	2009-02-24 15:32:35.854494491 +0100
> > @@ -590,7 +590,7 @@ xfs_bmbt_alloc_block(
> >  	cur->bc_private.b.allocated++;
> >  	cur->bc_private.b.ip->i_d.di_nblocks++;
> >  	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
> > -	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
> > +	xfs_trans_mod_dquot_byino(args.tp, cur->bc_private.b.ip,
> >  			XFS_TRANS_DQ_BCOUNT, 1L);
> >  
> >  	new->l = cpu_to_be64(args.fsbno);
> > @@ -618,7 +618,7 @@ xfs_bmbt_free_block(
> >  	ip->i_d.di_nblocks--;
> >  
> >  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > -	XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> > +	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
> >  	xfs_trans_binval(tp, bp);
> >  	return 0;
> >  }
> > Index: xfs/fs/xfs/xfs_vnodeops.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-02-24 15:32:16.111370238 +0100
> > +++ xfs/fs/xfs/xfs_vnodeops.c	2009-02-24 15:32:35.855495805 +0100
> > @@ -118,7 +118,7 @@ xfs_setattr(
> >  		 */
> >  		ASSERT(udqp == NULL);
> >  		ASSERT(gdqp == NULL);
> > -		code = XFS_QM_DQVOPALLOC(mp, ip, uid, gid, ip->i_d.di_projid,
> > +		code = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
> >  					 qflags, &udqp, &gdqp);
> >  		if (code)
> >  			return code;
> > @@ -183,7 +183,7 @@ xfs_setattr(
> >  		if ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
> >  		    (XFS_IS_GQUOTA_ON(mp) && igid != gid)) {
> >  			ASSERT(tp);
> > -			code = XFS_QM_DQVOPCHOWNRESV(mp, tp, ip, udqp, gdqp,
> > +			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> >  						capable(CAP_FOWNER) ?
> >  						XFS_QMOPT_FORCE_RES : 0);
> >  			if (code)	/* out of quota */
> > @@ -217,7 +217,7 @@ xfs_setattr(
> >  		/*
> >  		 * Make sure that the dquots are attached to the inode.
> >  		 */
> > -		code = XFS_QM_DQATTACH(mp, ip, XFS_QMOPT_ILOCKED);
> > +		code = xfs_qm_dqattach_locked(ip, 0);
> >  		if (code)
> >  			goto error_return;
> >  
> > @@ -354,7 +354,7 @@ xfs_setattr(
> >  			if (XFS_IS_UQUOTA_ON(mp)) {
> >  				ASSERT(mask & ATTR_UID);
> >  				ASSERT(udqp);
> > -				olddquot1 = XFS_QM_DQVOPCHOWN(mp, tp, ip,
> > +				olddquot1 = xfs_qm_vop_chown(tp, ip,
> >  							&ip->i_udquot, udqp);
> >  			}
> >  			ip->i_d.di_uid = uid;
> > @@ -365,7 +365,7 @@ xfs_setattr(
> >  				ASSERT(!XFS_IS_PQUOTA_ON(mp));
> >  				ASSERT(mask & ATTR_GID);
> >  				ASSERT(gdqp);
> > -				olddquot2 = XFS_QM_DQVOPCHOWN(mp, tp, ip,
> > +				olddquot2 = xfs_qm_vop_chown(tp, ip,
> >  							&ip->i_gdquot, gdqp);
> >  			}
> >  			ip->i_d.di_gid = gid;
> > @@ -461,10 +461,10 @@ xfs_setattr(
> >  	/*
> >  	 * Release any dquot(s) the inode had kept before chown.
> >  	 */
> > -	XFS_QM_DQRELE(mp, olddquot1);
> > -	XFS_QM_DQRELE(mp, olddquot2);
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(olddquot1);
> > +	xfs_qm_dqrele(olddquot2);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  
> >  	if (code) {
> >  		return code;
> > @@ -482,8 +482,8 @@ xfs_setattr(
> >  	commit_flags |= XFS_TRANS_ABORT;
> >  	/* FALLTHROUGH */
> >   error_return:
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  	if (tp) {
> >  		xfs_trans_cancel(tp, commit_flags);
> >  	}
> > @@ -739,7 +739,8 @@ xfs_free_eofblocks(
> >  		/*
> >  		 * Attach the dquots to the inode up front.
> >  		 */
> > -		if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
> > +		error = xfs_qm_dqattach(ip, 0);
> > +		if (error)
> >  			return error;
> >  
> >  		/*
> > @@ -1181,7 +1182,8 @@ xfs_inactive(
> >  
> >  	ASSERT(ip->i_d.di_nlink == 0);
> >  
> > -	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
> > +	error = xfs_qm_dqattach(ip, 0);
> > +	if (error)
> >  		return VN_INACTIVE_CACHE;
> >  
> >  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> > @@ -1307,7 +1309,7 @@ xfs_inactive(
> >  		/*
> >  		 * Credit the quota account(s). The inode is gone.
> >  		 */
> > -		XFS_TRANS_MOD_DQUOT_BYINO(mp, tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
> > +		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
> >  
> >  		/*
> >  		 * Just ignore errors at this point.  There is nothing we can
> > @@ -1323,11 +1325,11 @@ xfs_inactive(
> >  			xfs_fs_cmn_err(CE_NOTE, mp, "xfs_inactive: "
> >  				"xfs_trans_commit() returned error %d", error);
> >  	}
> > +
> >  	/*
> >  	 * Release the dquots held by inode, if any.
> >  	 */
> > -	XFS_QM_DQDETACH(mp, ip);
> > -
> > +	xfs_qm_dqdetach(ip);
> >  	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> >  
> >   out:
> > @@ -1398,14 +1400,16 @@ xfs_create(
> >  	uint			cancel_flags;
> >  	int			committed;
> >  	xfs_prid_t		prid;
> > -	struct xfs_dquot	*udqp = NULL;
> > -	struct xfs_dquot	*gdqp = NULL;
> > +	struct xfs_dquot	*udqp, *gdqp;
> >  	uint			resblks;
> >  	uint			log_res;
> >  	uint			log_count;
> >  
> >  	xfs_itrace_entry(dp);
> >  
> > +	udqp = NULL;
> > +	gdqp = NULL;
> > +
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return XFS_ERROR(EIO);
> >  
> > @@ -1427,8 +1431,7 @@ xfs_create(
> >  	/*
> >  	 * Make sure that we have allocated dquot(s) on disk.
> >  	 */
> > -	error = XFS_QM_DQVOPALLOC(mp, dp,
> > -			current_fsuid(), current_fsgid(), prid,
> > +	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> >  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
> >  	if (error)
> >  		goto std_return;
> > @@ -1482,7 +1485,7 @@ xfs_create(
> >  	/*
> >  	 * Reserve disk quota and the inode.
> >  	 */
> > -	error = XFS_TRANS_RESERVE_QUOTA(mp, tp, udqp, gdqp, resblks, 1, 0);
> > +	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -1554,7 +1557,7 @@ xfs_create(
> >  	 * These ids of the inode couldn't have changed since the new
> >  	 * inode has been locked ever since it was created.
> >  	 */
> > -	XFS_QM_DQVOPCREATE(mp, tp, ip, udqp, gdqp);
> > +	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
> >  
> >  	/*
> >  	 * xfs_trans_commit normally decrements the vnode ref count
> > @@ -1573,8 +1576,8 @@ xfs_create(
> >  		goto out_dqrele;
> >  	}
> >  
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  
> >  	*ipp = ip;
> >  
> > @@ -1595,8 +1598,8 @@ xfs_create(
> >   out_trans_cancel:
> >  	xfs_trans_cancel(tp, cancel_flags);
> >   out_dqrele:
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  
> >  	if (unlock_dp_on_error)
> >  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > @@ -1830,11 +1833,11 @@ xfs_remove(
> >  			return error;
> >  	}
> >  
> > -	error = XFS_QM_DQATTACH(mp, dp, 0);
> > +	error = xfs_qm_dqattach(dp, 0);
> >  	if (error)
> >  		goto std_return;
> >  
> > -	error = XFS_QM_DQATTACH(mp, ip, 0);
> > +	error = xfs_qm_dqattach(ip, 0);
> >  	if (error)
> >  		goto std_return;
> >  
> > @@ -2021,11 +2024,11 @@ xfs_link(
> >  
> >  	/* Return through std_return after this point. */
> >  
> > -	error = XFS_QM_DQATTACH(mp, sip, 0);
> > +	error = xfs_qm_dqattach(sip, 0);
> >  	if (error)
> >  		goto std_return;
> >  
> > -	error = XFS_QM_DQATTACH(mp, tdp, 0);
> > +	error = xfs_qm_dqattach(tdp, 0);
> >  	if (error)
> >  		goto std_return;
> >  
> > @@ -2198,8 +2201,7 @@ xfs_symlink(
> >  	/*
> >  	 * Make sure that we have allocated dquot(s) on disk.
> >  	 */
> > -	error = XFS_QM_DQVOPALLOC(mp, dp,
> > -			current_fsuid(), current_fsgid(), prid,
> > +	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> >  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
> >  	if (error)
> >  		goto std_return;
> > @@ -2241,7 +2243,7 @@ xfs_symlink(
> >  	/*
> >  	 * Reserve disk quota : blocks and inode.
> >  	 */
> > -	error = XFS_TRANS_RESERVE_QUOTA(mp, tp, udqp, gdqp, resblks, 1, 0);
> > +	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
> >  	if (error)
> >  		goto error_return;
> >  
> > @@ -2281,7 +2283,7 @@ xfs_symlink(
> >  	/*
> >  	 * Also attach the dquot(s) to it, if applicable.
> >  	 */
> > -	XFS_QM_DQVOPCREATE(mp, tp, ip, udqp, gdqp);
> > +	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
> >  
> >  	if (resblks)
> >  		resblks -= XFS_IALLOC_SPACE_RES(mp);
> > @@ -2369,8 +2371,8 @@ xfs_symlink(
> >  		goto error2;
> >  	}
> >  	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  
> >  	/* Fall through to std_return with error = 0 or errno from
> >  	 * xfs_trans_commit	*/
> > @@ -2394,8 +2396,8 @@ std_return:
> >  	cancel_flags |= XFS_TRANS_ABORT;
> >   error_return:
> >  	xfs_trans_cancel(tp, cancel_flags);
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  
> >  	if (unlock_dp_on_error)
> >  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > @@ -2534,7 +2536,8 @@ xfs_alloc_file_space(
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return XFS_ERROR(EIO);
> >  
> > -	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
> > +	error = xfs_qm_dqattach(ip, 0);
> > +	if (error)
> >  		return error;
> >  
> >  	if (len <= 0)
> > @@ -2621,8 +2624,8 @@ retry:
> >  			break;
> >  		}
> >  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -		error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip,
> > -						      qblocks, 0, quota_flag);
> > +		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
> > +						      0, quota_flag);
> >  		if (error)
> >  			goto error1;
> >  
> > @@ -2681,7 +2684,7 @@ dmapi_enospc_check:
> >  
> >  error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
> >  	xfs_bmap_cancel(&free_list);
> > -	XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp, tp, ip, qblocks, 0, quota_flag);
> > +	xfs_trans_unreserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
> >  
> >  error1:	/* Just cancel transaction */
> >  	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
> > @@ -2820,7 +2823,8 @@ xfs_free_file_space(
> >  
> >  	xfs_itrace_entry(ip);
> >  
> > -	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
> > +	error = xfs_qm_dqattach(ip, 0);
> > +	if (error)
> >  		return error;
> >  
> >  	error = 0;
> > @@ -2946,9 +2950,9 @@ xfs_free_file_space(
> >  			break;
> >  		}
> >  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -		error = XFS_TRANS_RESERVE_QUOTA(mp, tp,
> > -				ip->i_udquot, ip->i_gdquot, resblks, 0,
> > -				XFS_QMOPT_RES_REGBLKS);
> > +		error = xfs_trans_reserve_quota(tp, mp,
> > +				ip->i_udquot, ip->i_gdquot,
> > +				resblks, 0, XFS_QMOPT_RES_REGBLKS);
> >  		if (error)
> >  			goto error1;
> >  
> > Index: xfs/fs/xfs/quota/xfs_qm.h
> > ===================================================================
> > --- xfs.orig/fs/xfs/quota/xfs_qm.h	2009-02-24 15:32:16.067369944 +0100
> > +++ xfs/fs/xfs/quota/xfs_qm.h	2009-02-24 15:32:35.856495653 +0100
> > @@ -127,8 +127,6 @@ typedef struct xfs_quotainfo {
> >  } xfs_quotainfo_t;
> >  
> >  
> > -extern xfs_dqtrxops_t	xfs_trans_dquot_ops;
> > -
> >  extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
> >  extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
> >  			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
> > @@ -159,17 +157,11 @@ typedef struct xfs_dquot_acct {
> >  #define XFS_QM_RTBWARNLIMIT	5
> >  
> >  extern void		xfs_qm_destroy_quotainfo(xfs_mount_t *);
> > -extern void		xfs_qm_mount_quotas(xfs_mount_t *);
> >  extern int		xfs_qm_quotacheck(xfs_mount_t *);
> > -extern void		xfs_qm_unmount_quotadestroy(xfs_mount_t *);
> > -extern void		xfs_qm_unmount_quotas(xfs_mount_t *);
> >  extern int		xfs_qm_write_sb_changes(xfs_mount_t *, __int64_t);
> > -extern int		xfs_qm_sync(xfs_mount_t *, int);
> >  
> >  /* dquot stuff */
> >  extern boolean_t	xfs_qm_dqalloc_incore(xfs_dquot_t **);
> > -extern int		xfs_qm_dqattach(xfs_inode_t *, uint);
> > -extern void		xfs_qm_dqdetach(xfs_inode_t *);
> >  extern int		xfs_qm_dqpurge_all(xfs_mount_t *, uint);
> >  extern void		xfs_qm_dqrele_all_inodes(xfs_mount_t *, uint);
> >  
> > @@ -183,19 +175,6 @@ extern int		xfs_qm_scall_getqstat(xfs_mo
> >  extern int		xfs_qm_scall_quotaon(xfs_mount_t *, uint);
> >  extern int		xfs_qm_scall_quotaoff(xfs_mount_t *, uint);
> >  
> > -/* vop stuff */
> > -extern int		xfs_qm_vop_dqalloc(xfs_mount_t *, xfs_inode_t *,
> > -					uid_t, gid_t, prid_t, uint,
> > -					xfs_dquot_t **, xfs_dquot_t **);
> > -extern void		xfs_qm_vop_dqattach_and_dqmod_newinode(
> > -					xfs_trans_t *, xfs_inode_t *,
> > -					xfs_dquot_t *, xfs_dquot_t *);
> > -extern int		xfs_qm_vop_rename_dqattach(xfs_inode_t **);
> > -extern xfs_dquot_t *	xfs_qm_vop_chown(xfs_trans_t *, xfs_inode_t *,
> > -					xfs_dquot_t **, xfs_dquot_t *);
> > -extern int		xfs_qm_vop_chown_reserve(xfs_trans_t *, xfs_inode_t *,
> > -					xfs_dquot_t *, xfs_dquot_t *, uint);
> > -
> >  /* list stuff */
> >  extern void		xfs_qm_freelist_append(xfs_frlist_t *, xfs_dquot_t *);
> >  extern void		xfs_qm_freelist_unlink(xfs_dquot_t *);
> > Index: xfs/fs/xfs/quota/xfs_qm_bhv.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2009-02-24 15:32:16.071370174 +0100
> > +++ xfs/fs/xfs/quota/xfs_qm_bhv.c	2009-02-24 15:32:35.856495653 +0100
> > @@ -84,7 +84,7 @@ xfs_fill_statvfs_from_dquot(
> >   * return a statvfs of the project, not the entire filesystem.
> >   * This makes such trees appear as if they are filesystems in themselves.
> >   */
> > -STATIC void
> > +void
> >  xfs_qm_statvfs(
> >  	xfs_inode_t		*ip,
> >  	struct kstatfs		*statp)
> > @@ -92,20 +92,13 @@ xfs_qm_statvfs(
> >  	xfs_mount_t		*mp = ip->i_mount;
> >  	xfs_dquot_t		*dqp;
> >  
> > -	if (!(ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
> > -	    !((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
> > -	    		      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
> > -		return;
> > -
> >  	if (!xfs_qm_dqget(mp, NULL, ip->i_d.di_projid, XFS_DQ_PROJ, 0, &dqp)) {
> > -		xfs_disk_dquot_t	*dp = &dqp->q_core;
> > -
> > -		xfs_fill_statvfs_from_dquot(statp, dp);
> > +		xfs_fill_statvfs_from_dquot(statp, &dqp->q_core);
> >  		xfs_qm_dqput(dqp);
> >  	}
> >  }
> >  
> > -STATIC int
> > +int
> >  xfs_qm_newmount(
> >  	xfs_mount_t	*mp,
> >  	uint		*needquotamount,
> > @@ -114,9 +107,6 @@ xfs_qm_newmount(
> >  	uint		quotaondisk;
> >  	uint		uquotaondisk = 0, gquotaondisk = 0, pquotaondisk = 0;
> >  
> > -	*quotaflags = 0;
> > -	*needquotamount = B_FALSE;
> > -
> >  	quotaondisk = xfs_sb_version_hasquota(&mp->m_sb) &&
> >  				(mp->m_sb.sb_qflags & XFS_ALL_QUOTA_ACCT);
> >  
> > @@ -179,66 +169,6 @@ xfs_qm_newmount(
> >  	return 0;
> >  }
> >  
> > -STATIC int
> > -xfs_qm_endmount(
> > -	xfs_mount_t	*mp,
> > -	uint		needquotamount,
> > -	uint		quotaflags)
> > -{
> > -	if (needquotamount) {
> > -		ASSERT(mp->m_qflags == 0);
> > -		mp->m_qflags = quotaflags;
> > -		xfs_qm_mount_quotas(mp);
> > -	}
> > -
> > -#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
> > -	if (! (XFS_IS_QUOTA_ON(mp)))
> > -		xfs_fs_cmn_err(CE_NOTE, mp, "Disk quotas not turned on");
> > -	else
> > -		xfs_fs_cmn_err(CE_NOTE, mp, "Disk quotas turned on");
> > -#endif
> > -
> > -#ifdef QUOTADEBUG
> > -	if (XFS_IS_QUOTA_ON(mp) && xfs_qm_internalqcheck(mp))
> > -		cmn_err(CE_WARN, "XFS: mount internalqcheck failed");
> > -#endif
> > -
> > -	return 0;
> > -}
> > -
> > -STATIC void
> > -xfs_qm_dqrele_null(
> > -	xfs_dquot_t	*dq)
> > -{
> > -	/*
> > -	 * Called from XFS, where we always check first for a NULL dquot.
> > -	 */
> > -	if (!dq)
> > -		return;
> > -	xfs_qm_dqrele(dq);
> > -}
> > -
> > -
> > -struct xfs_qmops xfs_qmcore_xfs = {
> > -	.xfs_qminit		= xfs_qm_newmount,
> > -	.xfs_qmdone		= xfs_qm_unmount_quotadestroy,
> > -	.xfs_qmmount		= xfs_qm_endmount,
> > -	.xfs_qmunmount		= xfs_qm_unmount_quotas,
> > -	.xfs_dqrele		= xfs_qm_dqrele_null,
> > -	.xfs_dqattach		= xfs_qm_dqattach,
> > -	.xfs_dqdetach		= xfs_qm_dqdetach,
> > -	.xfs_dqpurgeall		= xfs_qm_dqpurge_all,
> > -	.xfs_dqvopalloc		= xfs_qm_vop_dqalloc,
> > -	.xfs_dqvopcreate	= xfs_qm_vop_dqattach_and_dqmod_newinode,
> > -	.xfs_dqvoprename	= xfs_qm_vop_rename_dqattach,
> > -	.xfs_dqvopchown		= xfs_qm_vop_chown,
> > -	.xfs_dqvopchownresv	= xfs_qm_vop_chown_reserve,
> > -	.xfs_dqstatvfs		= xfs_qm_statvfs,
> > -	.xfs_dqsync		= xfs_qm_sync,
> > -	.xfs_dqtrxops		= &xfs_trans_dquot_ops,
> > -};
> > -EXPORT_SYMBOL(xfs_qmcore_xfs);
> > -
> >  void __init
> >  xfs_qm_init(void)
> >  {
> > Index: xfs/fs/xfs/xfs_attr.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_attr.c	2009-02-24 15:32:16.115370119 +0100
> > +++ xfs/fs/xfs/xfs_attr.c	2009-02-24 15:32:35.857495152 +0100
> > @@ -249,8 +249,9 @@ xfs_attr_set_int(xfs_inode_t *dp, struct
> >  	/*
> >  	 * Attach the dquots to the inode.
> >  	 */
> > -	if ((error = XFS_QM_DQATTACH(mp, dp, 0)))
> > -		return (error);
> > +	error = xfs_qm_dqattach(dp, 0);
> > +	if (error)
> > +		return error;
> >  
> >  	/*
> >  	 * If the inode doesn't have an attribute fork, add one.
> > @@ -311,7 +312,7 @@ xfs_attr_set_int(xfs_inode_t *dp, struct
> >  	}
> >  	xfs_ilock(dp, XFS_ILOCK_EXCL);
> >  
> > -	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, args.trans, dp, args.total, 0,
> > +	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
> >  				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
> >  				       XFS_QMOPT_RES_REGBLKS);
> >  	if (error) {
> > @@ -501,8 +502,9 @@ xfs_attr_remove_int(xfs_inode_t *dp, str
> >  	/*
> >  	 * Attach the dquots to the inode.
> >  	 */
> > -	if ((error = XFS_QM_DQATTACH(mp, dp, 0)))
> > -		return (error);
> > +	error = xfs_qm_dqattach(dp, 0);
> > +	if (error)
> > +		return error;
> >  
> >  	/*
> >  	 * Start our first transaction of the day.
> > Index: xfs/fs/xfs/xfs_iomap.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_iomap.c	2009-02-24 15:32:16.119370349 +0100
> > +++ xfs/fs/xfs/xfs_iomap.c	2009-02-24 15:32:35.858495489 +0100
> > @@ -417,7 +417,7 @@ xfs_iomap_write_direct(
> >  	 * Make sure that the dquots are there. This doesn't hold
> >  	 * the ilock across a disk read.
> >  	 */
> > -	error = XFS_QM_DQATTACH(ip->i_mount, ip, XFS_QMOPT_ILOCKED);
> > +	error = xfs_qm_dqattach_locked(ip, 0);
> >  	if (error)
> >  		return XFS_ERROR(error);
> >  
> > @@ -476,8 +476,7 @@ xfs_iomap_write_direct(
> >  	if (error)
> >  		goto error_out;
> >  
> > -	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip,
> > -					      qblocks, 0, quota_flag);
> > +	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
> >  	if (error)
> >  		goto error1;
> >  
> > @@ -527,7 +526,7 @@ xfs_iomap_write_direct(
> >  
> >  error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
> >  	xfs_bmap_cancel(&free_list);
> > -	XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp, tp, ip, qblocks, 0, quota_flag);
> > +	xfs_trans_unreserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
> >  
> >  error1:	/* Just cancel transaction */
> >  	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
> > @@ -620,7 +619,7 @@ xfs_iomap_write_delay(
> >  	 * Make sure that the dquots are there. This doesn't hold
> >  	 * the ilock across a disk read.
> >  	 */
> > -	error = XFS_QM_DQATTACH(mp, ip, XFS_QMOPT_ILOCKED);
> > +	error = xfs_qm_dqattach_locked(ip, 0);
> >  	if (error)
> >  		return XFS_ERROR(error);
> >  
> > @@ -715,7 +714,8 @@ xfs_iomap_write_allocate(
> >  	/*
> >  	 * Make sure that the dquots are there.
> >  	 */
> > -	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
> > +	error = xfs_qm_dqattach(ip, 0);
> > +	if (error)
> >  		return XFS_ERROR(error);
> >  
> >  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> > Index: xfs/fs/xfs/xfs_mount.h
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_mount.h	2009-02-24 15:32:16.124369938 +0100
> > +++ xfs/fs/xfs/xfs_mount.h	2009-02-24 15:32:35.859495267 +0100
> > @@ -18,6 +18,7 @@
> >  #ifndef __XFS_MOUNT_H__
> >  #define	__XFS_MOUNT_H__
> >  
> > +
> >  typedef struct xfs_trans_reservations {
> >  	uint	tr_write;	/* extent alloc trans */
> >  	uint	tr_itruncate;	/* truncate trans */
> > @@ -64,6 +65,8 @@ struct xfs_swapext;
> >  struct xfs_mru_cache;
> >  struct xfs_nameops;
> >  struct xfs_ail;
> > +struct xfs_quotainfo;
> > +
> >  
> >  /*
> >   * Prototypes and functions for the Data Migration subsystem.
> > @@ -107,86 +110,6 @@ typedef struct xfs_dmops {
> >  	(*(mp)->m_dm_ops->xfs_send_unmount)(mp,ip,right,mode,rval,fl)
> >  
> >  
> > -/*
> > - * Prototypes and functions for the Quota Management subsystem.
> > - */
> > -
> > -struct xfs_dquot;
> > -struct xfs_dqtrxops;
> > -struct xfs_quotainfo;
> > -
> > -typedef int	(*xfs_qminit_t)(struct xfs_mount *, uint *, uint *);
> > -typedef int	(*xfs_qmmount_t)(struct xfs_mount *, uint, uint);
> > -typedef void	(*xfs_qmunmount_t)(struct xfs_mount *);
> > -typedef void	(*xfs_qmdone_t)(struct xfs_mount *);
> > -typedef void	(*xfs_dqrele_t)(struct xfs_dquot *);
> > -typedef int	(*xfs_dqattach_t)(struct xfs_inode *, uint);
> > -typedef void	(*xfs_dqdetach_t)(struct xfs_inode *);
> > -typedef int	(*xfs_dqpurgeall_t)(struct xfs_mount *, uint);
> > -typedef int	(*xfs_dqvopalloc_t)(struct xfs_mount *,
> > -			struct xfs_inode *, uid_t, gid_t, prid_t, uint,
> > -			struct xfs_dquot **, struct xfs_dquot **);
> > -typedef void	(*xfs_dqvopcreate_t)(struct xfs_trans *, struct xfs_inode *,
> > -			struct xfs_dquot *, struct xfs_dquot *);
> > -typedef int	(*xfs_dqvoprename_t)(struct xfs_inode **);
> > -typedef struct xfs_dquot * (*xfs_dqvopchown_t)(
> > -			struct xfs_trans *, struct xfs_inode *,
> > -			struct xfs_dquot **, struct xfs_dquot *);
> > -typedef int	(*xfs_dqvopchownresv_t)(struct xfs_trans *, struct xfs_inode *,
> > -			struct xfs_dquot *, struct xfs_dquot *, uint);
> > -typedef void	(*xfs_dqstatvfs_t)(struct xfs_inode *, struct kstatfs *);
> > -typedef int	(*xfs_dqsync_t)(struct xfs_mount *, int flags);
> > -
> > -typedef struct xfs_qmops {
> > -	xfs_qminit_t		xfs_qminit;
> > -	xfs_qmdone_t		xfs_qmdone;
> > -	xfs_qmmount_t		xfs_qmmount;
> > -	xfs_qmunmount_t		xfs_qmunmount;
> > -	xfs_dqrele_t		xfs_dqrele;
> > -	xfs_dqattach_t		xfs_dqattach;
> > -	xfs_dqdetach_t		xfs_dqdetach;
> > -	xfs_dqpurgeall_t	xfs_dqpurgeall;
> > -	xfs_dqvopalloc_t	xfs_dqvopalloc;
> > -	xfs_dqvopcreate_t	xfs_dqvopcreate;
> > -	xfs_dqvoprename_t	xfs_dqvoprename;
> > -	xfs_dqvopchown_t	xfs_dqvopchown;
> > -	xfs_dqvopchownresv_t	xfs_dqvopchownresv;
> > -	xfs_dqstatvfs_t		xfs_dqstatvfs;
> > -	xfs_dqsync_t		xfs_dqsync;
> > -	struct xfs_dqtrxops	*xfs_dqtrxops;
> > -} xfs_qmops_t;
> > -
> > -#define XFS_QM_INIT(mp, mnt, fl) \
> > -	(*(mp)->m_qm_ops->xfs_qminit)(mp, mnt, fl)
> > -#define XFS_QM_MOUNT(mp, mnt, fl) \
> > -	(*(mp)->m_qm_ops->xfs_qmmount)(mp, mnt, fl)
> > -#define XFS_QM_UNMOUNT(mp) \
> > -	(*(mp)->m_qm_ops->xfs_qmunmount)(mp)
> > -#define XFS_QM_DONE(mp) \
> > -	(*(mp)->m_qm_ops->xfs_qmdone)(mp)
> > -#define XFS_QM_DQRELE(mp, dq) \
> > -	(*(mp)->m_qm_ops->xfs_dqrele)(dq)
> > -#define XFS_QM_DQATTACH(mp, ip, fl) \
> > -	(*(mp)->m_qm_ops->xfs_dqattach)(ip, fl)
> > -#define XFS_QM_DQDETACH(mp, ip) \
> > -	(*(mp)->m_qm_ops->xfs_dqdetach)(ip)
> > -#define XFS_QM_DQPURGEALL(mp, fl) \
> > -	(*(mp)->m_qm_ops->xfs_dqpurgeall)(mp, fl)
> > -#define XFS_QM_DQVOPALLOC(mp, ip, uid, gid, prid, fl, dq1, dq2) \
> > -	(*(mp)->m_qm_ops->xfs_dqvopalloc)(mp, ip, uid, gid, prid, fl, dq1, dq2)
> > -#define XFS_QM_DQVOPCREATE(mp, tp, ip, dq1, dq2) \
> > -	(*(mp)->m_qm_ops->xfs_dqvopcreate)(tp, ip, dq1, dq2)
> > -#define XFS_QM_DQVOPRENAME(mp, ip) \
> > -	(*(mp)->m_qm_ops->xfs_dqvoprename)(ip)
> > -#define XFS_QM_DQVOPCHOWN(mp, tp, ip, dqp, dq) \
> > -	(*(mp)->m_qm_ops->xfs_dqvopchown)(tp, ip, dqp, dq)
> > -#define XFS_QM_DQVOPCHOWNRESV(mp, tp, ip, dq1, dq2, fl) \
> > -	(*(mp)->m_qm_ops->xfs_dqvopchownresv)(tp, ip, dq1, dq2, fl)
> > -#define XFS_QM_DQSTATVFS(ip, statp) \
> > -	(*(ip)->i_mount->m_qm_ops->xfs_dqstatvfs)(ip, statp)
> > -#define XFS_QM_DQSYNC(mp, flags) \
> > -	(*(mp)->m_qm_ops->xfs_dqsync)(mp, flags)
> > -
> >  #ifdef HAVE_PERCPU_SB
> >  
> >  /*
> > @@ -516,8 +439,6 @@ extern int	xfs_sb_validate_fsb_count(str
> >  
> >  extern int	xfs_dmops_get(struct xfs_mount *);
> >  extern void	xfs_dmops_put(struct xfs_mount *);
> > -extern int	xfs_qmops_get(struct xfs_mount *);
> > -extern void	xfs_qmops_put(struct xfs_mount *);
> >  
> >  extern struct xfs_dmops xfs_dmcore_xfs;
> >  
> > Index: xfs/fs/xfs/Makefile
> > ===================================================================
> > --- xfs.orig/fs/xfs/Makefile	2009-02-24 15:32:16.158369937 +0100
> > +++ xfs/fs/xfs/Makefile	2009-02-24 15:32:35.859495267 +0100
> > @@ -88,8 +88,7 @@ xfs-y				+= xfs_alloc.o \
> >  				   xfs_utils.o \
> >  				   xfs_vnodeops.o \
> >  				   xfs_rw.o \
> > -				   xfs_dmops.o \
> > -				   xfs_qmops.o
> > +				   xfs_dmops.o
> >  
> >  xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o \
> >  				   xfs_dir2_trace.o
> > Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2009-02-24 15:32:16.137370546 +0100
> > +++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2009-02-24 15:32:35.865370666 +0100
> > @@ -907,7 +907,7 @@ xfs_ioctl_setattr(
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_trans	*tp;
> >  	unsigned int		lock_flags = 0;
> > -	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
> > +	struct xfs_dquot	*udqp, *gdqp;
> >  	struct xfs_dquot	*olddquot = NULL;
> >  	int			code;
> >  
> > @@ -918,6 +918,9 @@ xfs_ioctl_setattr(
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return XFS_ERROR(EIO);
> >  
> > +	udqp = NULL;
> > +	gdqp = NULL;
> > +
> >  	/*
> >  	 * If disk quotas is on, we make sure that the dquots do exist on disk,
> >  	 * before we start any other transactions. Trying to do this later
> > @@ -927,7 +930,7 @@ xfs_ioctl_setattr(
> >  	 * because the i_*dquot fields will get updated anyway.
> >  	 */
> >  	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
> > -		code = XFS_QM_DQVOPALLOC(mp, ip, ip->i_d.di_uid,
> > +		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
> >  					 ip->i_d.di_gid, fa->fsx_projid,
> >  					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
> >  		if (code)
> > @@ -965,7 +968,7 @@ xfs_ioctl_setattr(
> >  		if (XFS_IS_PQUOTA_ON(mp) &&
> >  		    ip->i_d.di_projid != fa->fsx_projid) {
> >  			ASSERT(tp);
> > -			code = XFS_QM_DQVOPCHOWNRESV(mp, tp, ip, udqp, gdqp,
> > +			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> >  						capable(CAP_FOWNER) ?
> >  						XFS_QMOPT_FORCE_RES : 0);
> >  			if (code)	/* out of quota */
> > @@ -1068,7 +1071,7 @@ xfs_ioctl_setattr(
> >  		 */
> >  		if (ip->i_d.di_projid != fa->fsx_projid) {
> >  			if (XFS_IS_PQUOTA_ON(mp)) {
> > -				olddquot = XFS_QM_DQVOPCHOWN(mp, tp, ip,
> > +				olddquot = xfs_qm_vop_chown(tp, ip,
> >  							&ip->i_gdquot, gdqp);
> >  			}
> >  			ip->i_d.di_projid = fa->fsx_projid;
> > @@ -1114,9 +1117,9 @@ xfs_ioctl_setattr(
> >  	/*
> >  	 * Release any dquot(s) the inode had kept before chown.
> >  	 */
> > -	XFS_QM_DQRELE(mp, olddquot);
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(olddquot);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  
> >  	if (code)
> >  		return code;
> > @@ -1130,8 +1133,8 @@ xfs_ioctl_setattr(
> >  	return 0;
> >  
> >   error_return:
> > -	XFS_QM_DQRELE(mp, udqp);
> > -	XFS_QM_DQRELE(mp, gdqp);
> > +	xfs_qm_dqrele(udqp);
> > +	xfs_qm_dqrele(gdqp);
> >  	xfs_trans_cancel(tp, 0);
> >  	if (lock_flags)
> >  		xfs_iunlock(ip, lock_flags);
> > Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-02-24 15:32:16.141370566 +0100
> > +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-02-24 15:32:35.866394539 +0100
> > @@ -416,6 +416,14 @@ xfs_parseargs(
> >  		return EINVAL;
> >  	}
> >  
> > +#ifndef CONFIG_XFS_QUOTA
> > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > +		cmn_err(CE_WARN,
> > +			"XFS: quota support not available in this kernel.");
> > +		return EINVAL;
> > +	}
> > +#endif
> > +
> >  	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
> >  	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
> >  		cmn_err(CE_WARN,
> > @@ -1110,7 +1118,6 @@ xfs_fs_put_super(
> >  	xfs_freesb(mp);
> >  	xfs_icsb_destroy_counters(mp);
> >  	xfs_close_devices(mp);
> > -	xfs_qmops_put(mp);
> >  	xfs_dmops_put(mp);
> >  	xfs_free_fsname(mp);
> >  	kfree(mp);
> > @@ -1180,6 +1187,7 @@ xfs_fs_statfs(
> >  {
> >  	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
> >  	xfs_sb_t		*sbp = &mp->m_sb;
> > +	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
> >  	__uint64_t		fakeinos, id;
> >  	xfs_extlen_t		lsize;
> >  
> > @@ -1214,7 +1222,10 @@ xfs_fs_statfs(
> >  	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
> >  	spin_unlock(&mp->m_sb_lock);
> >  
> > -	XFS_QM_DQSTATVFS(XFS_I(dentry->d_inode), statp);
> > +	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
> > +	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
> > +			      (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
> > +		xfs_qm_statvfs(ip, statp);
> >  	return 0;
> >  }
> >  
> > @@ -1422,16 +1433,13 @@ xfs_fs_fill_super(
> >  	error = xfs_dmops_get(mp);
> >  	if (error)
> >  		goto out_free_fsname;
> > -	error = xfs_qmops_get(mp);
> > -	if (error)
> > -		goto out_put_dmops;
> >  
> >  	if (silent)
> >  		flags |= XFS_MFSI_QUIET;
> >  
> >  	error = xfs_open_devices(mp);
> >  	if (error)
> > -		goto out_put_qmops;
> > +		goto out_put_dmops;
> >  
> >  	if (xfs_icsb_init_counters(mp))
> >  		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
> > @@ -1500,8 +1508,6 @@ xfs_fs_fill_super(
> >   out_destroy_counters:
> >  	xfs_icsb_destroy_counters(mp);
> >  	xfs_close_devices(mp);
> > - out_put_qmops:
> > -	xfs_qmops_put(mp);
> >   out_put_dmops:
> >  	xfs_dmops_put(mp);
> >   out_free_fsname:
> > Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-02-24 15:32:16.149399312 +0100
> > +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-02-24 15:32:35.867425537 +0100
> > @@ -43,6 +43,7 @@
> >  #include "xfs_buf_item.h"
> >  #include "xfs_inode_item.h"
> >  #include "xfs_rw.h"
> > +#include "xfs_quota.h"
> >  
> >  #include <linux/kthread.h>
> >  #include <linux/freezer.h>
> > @@ -311,12 +312,12 @@ xfs_quiesce_data(
> >  
> >  	/* push non-blocking */
> >  	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
> > -	XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
> > +	xfs_qm_sync(mp, SYNC_BDFLUSH);
> >  	xfs_filestream_flush(mp);
> >  
> >  	/* push and block */
> >  	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
> > -	XFS_QM_DQSYNC(mp, SYNC_WAIT);
> > +	xfs_qm_sync(mp, SYNC_WAIT);
> >  
> >  	/* write superblock and hoover up shutdown errors */
> >  	error = xfs_sync_fsdata(mp, 0);
> > @@ -482,7 +483,7 @@ xfs_sync_worker(
> >  		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
> >  		xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
> >  		/* dgc: errors ignored here */
> > -		error = XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
> > +		error = xfs_qm_sync(mp, SYNC_BDFLUSH);
> >  		error = xfs_sync_fsdata(mp, SYNC_BDFLUSH);
> >  		if (xfs_log_need_covered(mp))
> >  			error = xfs_commit_dummy_trans(mp, XFS_LOG_FORCE);
> > Index: xfs/fs/xfs/quota/xfs_dquot.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/quota/xfs_dquot.c	2009-02-24 15:32:16.080370342 +0100
> > +++ xfs/fs/xfs/quota/xfs_dquot.c	2009-02-24 15:32:35.867425537 +0100
> > @@ -1194,7 +1194,9 @@ void
> >  xfs_qm_dqrele(
> >  	xfs_dquot_t	*dqp)
> >  {
> > -	ASSERT(dqp);
> > +	if (!dqp)
> > +		return;
> > +
> >  	xfs_dqtrace_entry(dqp, "DQRELE");
> >  
> >  	xfs_dqlock(dqp);
> > Index: xfs/fs/xfs/quota/xfs_dquot.h
> > ===================================================================
> > --- xfs.orig/fs/xfs/quota/xfs_dquot.h	2009-02-24 15:32:16.085370350 +0100
> > +++ xfs/fs/xfs/quota/xfs_dquot.h	2009-02-24 15:32:35.868518762 +0100
> > @@ -181,7 +181,6 @@ extern void		xfs_qm_adjust_dqlimits(xfs_
> >  extern int		xfs_qm_dqget(xfs_mount_t *, xfs_inode_t *,
> >  					xfs_dqid_t, uint, uint, xfs_dquot_t **);
> >  extern void		xfs_qm_dqput(xfs_dquot_t *);
> > -extern void		xfs_qm_dqrele(xfs_dquot_t *);
> >  extern void		xfs_dqlock(xfs_dquot_t *);
> >  extern void		xfs_dqlock2(xfs_dquot_t *, xfs_dquot_t *);
> >  extern void		xfs_dqunlock(xfs_dquot_t *);
> > Index: xfs/fs/xfs/quota/xfs_qm.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-02-24 15:32:16.076370112 +0100
> > +++ xfs/fs/xfs/quota/xfs_qm.c	2009-02-24 15:32:35.869518471 +0100
> > @@ -287,11 +287,13 @@ xfs_qm_rele_quotafs_ref(
> >   * Just destroy the quotainfo structure.
> >   */
> >  void
> > -xfs_qm_unmount_quotadestroy(
> > -	xfs_mount_t	*mp)
> > +xfs_qm_unmount(
> > +	struct xfs_mount	*mp)
> >  {
> > -	if (mp->m_quotainfo)
> > +	if (mp->m_quotainfo) {
> > +		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
> >  		xfs_qm_destroy_quotainfo(mp);
> > +	}
> >  }
> >  
> >  
> > @@ -311,6 +313,9 @@ xfs_qm_mount_quotas(
> >  	int		error = 0;
> >  	uint		sbf;
> >  
> > +	if (!XFS_IS_QUOTA_RUNNING(mp))
> > +		return;
> > +
> >  	/*
> >  	 * If quotas on realtime volumes is not supported, we disable
> >  	 * quotas immediately.
> > @@ -323,8 +328,6 @@ xfs_qm_mount_quotas(
> >  		goto write_changes;
> >  	}
> >  
> > -	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> > -
> >  	/*
> >  	 * Allocate the quotainfo structure inside the mount struct, and
> >  	 * create quotainode(s), and change/rev superblock if necessary.
> > @@ -385,8 +388,13 @@ xfs_qm_mount_quotas(
> >  	if (error) {
> >  		xfs_fs_cmn_err(CE_WARN, mp,
> >  			"Failed to initialize disk quotas.");
> > +		return;
> >  	}
> > -	return;
> > +
> > +#ifdef QUOTADEBUG
> > +	if (XFS_IS_QUOTA_ON(mp))
> > +		xfs_qm_internalqcheck(mp);
> > +#endif
> >  }
> >  
> >  /*
> > @@ -774,12 +782,11 @@ xfs_qm_dqattach_grouphint(
> >   * Given a locked inode, attach dquot(s) to it, taking U/G/P-QUOTAON
> >   * into account.
> >   * If XFS_QMOPT_DQALLOC, the dquot(s) will be allocated if needed.
> > - * If XFS_QMOPT_ILOCKED, then inode sent is already locked EXCL.
> >   * Inode may get unlocked and relocked in here, and the caller must deal with
> >   * the consequences.
> >   */
> >  int
> > -xfs_qm_dqattach(
> > +xfs_qm_dqattach_locked(
> >  	xfs_inode_t	*ip,
> >  	uint		flags)
> >  {
> > @@ -787,17 +794,14 @@ xfs_qm_dqattach(
> >  	uint		nquotas = 0;
> >  	int		error = 0;
> >  
> > -	if ((! XFS_IS_QUOTA_ON(mp)) ||
> > -	    (! XFS_NOT_DQATTACHED(mp, ip)) ||
> > -	    (ip->i_ino == mp->m_sb.sb_uquotino) ||
> > -	    (ip->i_ino == mp->m_sb.sb_gquotino))
> > +	if (!XFS_IS_QUOTA_RUNNING(mp) ||
> > +	    !XFS_IS_QUOTA_ON(mp) ||
> > +	    !XFS_NOT_DQATTACHED(mp, ip) ||
> > +	    ip->i_ino == mp->m_sb.sb_uquotino ||
> > +	    ip->i_ino == mp->m_sb.sb_gquotino)
> >  		return 0;
> >  
> > -	ASSERT((flags & XFS_QMOPT_ILOCKED) == 0 ||
> > -	       xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -
> > -	if (! (flags & XFS_QMOPT_ILOCKED))
> > -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> >  
> >  	if (XFS_IS_UQUOTA_ON(mp)) {
> >  		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
> > @@ -849,8 +853,7 @@ xfs_qm_dqattach(
> >  		xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
> >  	}
> >  
> > -      done:
> > -
> > + done:
> >  #ifdef QUOTADEBUG
> >  	if (! error) {
> >  		if (XFS_IS_UQUOTA_ON(mp))
> > @@ -858,15 +861,22 @@ xfs_qm_dqattach(
> >  		if (XFS_IS_OQUOTA_ON(mp))
> >  			ASSERT(ip->i_gdquot);
> >  	}
> > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> >  #endif
> > +	return error;
> > +}
> > +
> > +int
> > +xfs_qm_dqattach(
> > +	struct xfs_inode	*ip,
> > +	uint			flags)
> > +{
> > +	int			error;
> >  
> > -	if (! (flags & XFS_QMOPT_ILOCKED))
> > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	error = xfs_qm_dqattach_locked(ip, flags);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  
> > -#ifdef QUOTADEBUG
> > -	else
> > -		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -#endif
> >  	return error;
> >  }
> >  
> > @@ -912,7 +922,7 @@ xfs_qm_sync(
> >  	boolean_t	nowait;
> >  	int		error;
> >  
> > -	if (! XFS_IS_QUOTA_ON(mp))
> > +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> >  		return 0;
> >  
> >  	restarts = 0;
> > @@ -2319,20 +2329,20 @@ xfs_qm_write_sb_changes(
> >   */
> >  int
> >  xfs_qm_vop_dqalloc(
> > -	xfs_mount_t	*mp,
> > -	xfs_inode_t	*ip,
> > -	uid_t		uid,
> > -	gid_t		gid,
> > -	prid_t		prid,
> > -	uint		flags,
> > -	xfs_dquot_t	**O_udqpp,
> > -	xfs_dquot_t	**O_gdqpp)
> > -{
> > -	int		error;
> > -	xfs_dquot_t	*uq, *gq;
> > -	uint		lockflags;
> > +	struct xfs_inode	*ip,
> > +	uid_t			uid,
> > +	gid_t			gid,
> > +	prid_t			prid,
> > +	uint			flags,
> > +	struct xfs_dquot	**O_udqpp,
> > +	struct xfs_dquot	**O_gdqpp)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_dquot	*uq, *gq;
> > +	int			error;
> > +	uint			lockflags;
> >  
> > -	if (!XFS_IS_QUOTA_ON(mp))
> > +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> >  		return 0;
> >  
> >  	lockflags = XFS_ILOCK_EXCL;
> > @@ -2346,8 +2356,8 @@ xfs_qm_vop_dqalloc(
> >  	 * if necessary. The dquot(s) will not be locked.
> >  	 */
> >  	if (XFS_NOT_DQATTACHED(mp, ip)) {
> > -		if ((error = xfs_qm_dqattach(ip, XFS_QMOPT_DQALLOC |
> > -					    XFS_QMOPT_ILOCKED))) {
> > +		error = xfs_qm_dqattach_locked(ip, XFS_QMOPT_DQALLOC);
> > +		if (error) {
> >  			xfs_iunlock(ip, lockflags);
> >  			return error;
> >  		}
> > @@ -2469,8 +2479,10 @@ xfs_qm_vop_chown(
> >  	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
> >  				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
> >  
> > +	if (!XFS_IS_QUOTA_RUNNING(ip->i_mount))
> > +		return NULL;
> > +
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
> >  
> >  	/* old dquot */
> >  	prevdq = *IO_olddq;
> > @@ -2508,14 +2520,15 @@ xfs_qm_vop_chown_reserve(
> >  	xfs_dquot_t	*gdqp,
> >  	uint		flags)
> >  {
> > -	int		error;
> > -	xfs_mount_t	*mp;
> > +	xfs_mount_t	*mp = ip->i_mount;
> >  	uint		delblks, blkflags, prjflags = 0;
> >  	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
> > +	int		error;
> > +
> > +	if (!XFS_IS_QUOTA_RUNNING(mp))
> > +		return 0;
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> > -	mp = ip->i_mount;
> > -	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> >  
> >  	delblks = ip->i_delayed_blks;
> >  	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
> > @@ -2582,28 +2595,23 @@ xfs_qm_vop_chown_reserve(
> >  
> >  int
> >  xfs_qm_vop_rename_dqattach(
> > -	xfs_inode_t	**i_tab)
> > +	struct xfs_inode	**i_tab)
> >  {
> > -	xfs_inode_t	*ip;
> > -	int		i;
> > -	int		error;
> > -
> > -	ip = i_tab[0];
> > +	struct xfs_mount	*mp = i_tab[0]->i_mount;
> > +	int			i;
> >  
> > -	if (! XFS_IS_QUOTA_ON(ip->i_mount))
> > +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> >  		return 0;
> >  
> > -	if (XFS_NOT_DQATTACHED(ip->i_mount, ip)) {
> > -		error = xfs_qm_dqattach(ip, 0);
> > -		if (error)
> > -			return error;
> > -	}
> >  	for (i = 1; (i < 4 && i_tab[i]); i++) {
> > +		struct xfs_inode	*ip = i_tab[i];
> > +		int			error;
> > +
> >  		/*
> >  		 * Watch out for duplicate entries in the table.
> >  		 */
> > -		if ((ip = i_tab[i]) != i_tab[i-1]) {
> > -			if (XFS_NOT_DQATTACHED(ip->i_mount, ip)) {
> > +		if (i == 0 || ip != i_tab[i-1]) {
> > +			if (XFS_NOT_DQATTACHED(mp, ip)) {
> >  				error = xfs_qm_dqattach(ip, 0);
> >  				if (error)
> >  					return error;
> > @@ -2614,17 +2622,19 @@ xfs_qm_vop_rename_dqattach(
> >  }
> >  
> >  void
> > -xfs_qm_vop_dqattach_and_dqmod_newinode(
> > -	xfs_trans_t	*tp,
> > -	xfs_inode_t	*ip,
> > -	xfs_dquot_t	*udqp,
> > -	xfs_dquot_t	*gdqp)
> > +xfs_qm_vop_create_dqattach(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	struct xfs_dquot	*udqp,
> > +	struct xfs_dquot	*gdqp)
> >  {
> > -	if (!XFS_IS_QUOTA_ON(tp->t_mountp))
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +
> > +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> >  		return;
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > -	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
> > +	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> >  
> >  	if (udqp) {
> >  		xfs_dqlock(udqp);
> > @@ -2632,7 +2642,7 @@ xfs_qm_vop_dqattach_and_dqmod_newinode(
> >  		xfs_dqunlock(udqp);
> >  		ASSERT(ip->i_udquot == NULL);
> >  		ip->i_udquot = udqp;
> > -		ASSERT(XFS_IS_UQUOTA_ON(tp->t_mountp));
> > +		ASSERT(XFS_IS_UQUOTA_ON(mp));
> >  		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
> >  		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
> >  	}
> > @@ -2642,8 +2652,8 @@ xfs_qm_vop_dqattach_and_dqmod_newinode(
> >  		xfs_dqunlock(gdqp);
> >  		ASSERT(ip->i_gdquot == NULL);
> >  		ip->i_gdquot = gdqp;
> > -		ASSERT(XFS_IS_OQUOTA_ON(tp->t_mountp));
> > -		ASSERT((XFS_IS_GQUOTA_ON(tp->t_mountp) ?
> > +		ASSERT(XFS_IS_OQUOTA_ON(mp));
> > +		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
> >  			ip->i_d.di_gid : ip->i_d.di_projid) ==
> >  				be32_to_cpu(gdqp->q_core.d_id));
> >  		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
> > Index: xfs/fs/xfs/xfs_iget.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_iget.c	2009-02-24 15:32:16.153369650 +0100
> > +++ xfs/fs/xfs/xfs_iget.c	2009-02-24 15:32:35.870518109 +0100
> > @@ -490,10 +490,7 @@ xfs_ireclaim(
> >  	 * ilock one but will still hold the iolock.
> >  	 */
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> > -	/*
> > -	 * Release dquots (and their references) if any.
> > -	 */
> > -	XFS_QM_DQDETACH(ip->i_mount, ip);
> > +	xfs_qm_dqdetach(ip);
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> >  
> >  	switch (ip->i_d.di_mode & S_IFMT) {
> > Index: xfs/fs/xfs/xfs_mount.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_mount.c	2009-02-24 15:32:16.164399755 +0100
> > +++ xfs/fs/xfs/xfs_mount.c	2009-02-24 15:32:35.871518446 +0100
> > @@ -886,6 +886,53 @@ xfs_check_sizes(xfs_mount_t *mp)
> >  }
> >  
> >  /*
> > + * Clear the quotaflags in memory and in the superblock.
> > + */
> > +int
> > +xfs_mount_reset_sbqflags(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int			error;
> > +	struct xfs_trans	*tp;
> > +
> > +	mp->m_qflags = 0;
> > +
> > +	/*
> > +	 * It is OK to look at sb_qflags here in mount path,
> > +	 * without m_sb_lock.
> > +	 */
> > +	if (mp->m_sb.sb_qflags == 0)
> > +		return 0;
> > +	spin_lock(&mp->m_sb_lock);
> > +	mp->m_sb.sb_qflags = 0;
> > +	spin_unlock(&mp->m_sb_lock);
> > +
> > +	/*
> > +	 * If the fs is readonly, let the incore superblock run
> > +	 * with quotas off but don't flush the update out to disk
> > +	 */
> > +	if (mp->m_flags & XFS_MOUNT_RDONLY)
> > +		return 0;
> > +
> > +#ifdef QUOTADEBUG
> > +	xfs_fs_cmn_err(CE_NOTE, mp, "Writing superblock quota changes");
> > +#endif
> > +
> > +	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
> > +	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
> > +				      XFS_DEFAULT_LOG_COUNT);
> > +	if (error) {
> > +		xfs_trans_cancel(tp, 0);
> > +		xfs_fs_cmn_err(CE_ALERT, mp,
> > +			"xfs_mount_reset_sbqflags: Superblock update failed!");
> > +		return error;
> > +	}
> > +
> > +	xfs_mod_sb(tp, XFS_SB_QFLAGS);
> > +	return xfs_trans_commit(tp, 0);
> > +}
> > +
> > +/*
> >   * This function does the following on an initial mount of a file system:
> >   *	- reads the superblock from disk and init the mount struct
> >   *	- if we're a 32-bit kernel, do a size check on the superblock
> > @@ -902,7 +949,8 @@ xfs_mountfs(
> >  	xfs_sb_t	*sbp = &(mp->m_sb);
> >  	xfs_inode_t	*rip;
> >  	__uint64_t	resblks;
> > -	uint		quotamount, quotaflags;
> > +	uint		quotamount = 0;
> > +	uint		quotaflags = 0;
> >  	int		error = 0;
> >  
> >  	xfs_mount_common(mp, sbp);
> > @@ -1145,9 +1193,28 @@ xfs_mountfs(
> >  	/*
> >  	 * Initialise the XFS quota management subsystem for this mount
> >  	 */
> > -	error = XFS_QM_INIT(mp, &quotamount, &quotaflags);
> > -	if (error)
> > -		goto out_rtunmount;
> > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > +		error = xfs_qm_newmount(mp, &quotamount, &quotaflags);
> > +		if (error)
> > +			goto out_rtunmount;
> > +	} else {
> > +		ASSERT(!XFS_IS_QUOTA_ON(mp));
> > +
> > +		/*
> > +		 * If a file system had quotas running earlier, but decided to
> > +		 * mount without -o uquota/pquota/gquota options, revoke the
> > +		 * quotachecked license.
> > +		 */
> > +		if (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_ACCT) {
> > +			cmn_err(CE_NOTE,
> > +                	        "XFS: resetting qflags for filesystem %s",
> > +                	        mp->m_fsname);
> > +
> > +			error = xfs_mount_reset_sbqflags(mp);
> > +			if (error)
> > +				return error;
> > +		}
> > +	}
> >  
> >  	/*
> >  	 * Finish recovering the file system.  This part needed to be
> > @@ -1163,9 +1230,19 @@ xfs_mountfs(
> >  	/*
> >  	 * Complete the quota initialisation, post-log-replay component.
> >  	 */
> > -	error = XFS_QM_MOUNT(mp, quotamount, quotaflags);
> > -	if (error)
> > -		goto out_rtunmount;
> > +	if (quotamount) {
> > +		ASSERT(mp->m_qflags == 0);
> > +		mp->m_qflags = quotaflags;
> > +
> > +		xfs_qm_mount_quotas(mp);
> > +	}
> > +
> > +#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
> > +	if (XFS_IS_QUOTA_ON(mp))
> > +		xfs_fs_cmn_err(CE_NOTE, mp, "Disk quotas turned on");
> > +	else
> > +		xfs_fs_cmn_err(CE_NOTE, mp, "Disk quotas not turned on");
> > +#endif
> >  
> >  	/*
> >  	 * Now we are mounted, reserve a small amount of unused space for
> > @@ -1215,12 +1292,7 @@ xfs_unmountfs(
> >  	__uint64_t		resblks;
> >  	int			error;
> >  
> > -	/*
> > -	 * Release dquot that rootinode, rbmino and rsumino might be holding,
> > -	 * and release the quota inodes.
> > -	 */
> > -	XFS_QM_UNMOUNT(mp);
> > -
> > +	xfs_qm_unmount_quotas(mp);
> >  	xfs_rtunmount_inodes(mp);
> >  	IRELE(mp->m_rootip);
> >  
> > @@ -1237,10 +1309,7 @@ xfs_unmountfs(
> >  	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
> >  	xfs_reclaim_inodes(mp, 0, XFS_IFLUSH_ASYNC);
> >  
> > -	XFS_QM_DQPURGEALL(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
> > -
> > -	if (mp->m_quotainfo)
> > -		XFS_QM_DONE(mp);
> > +	xfs_qm_unmount(mp);
> >  
> >  	/*
> >  	 * Flush out the log synchronously so that we know for sure
> > Index: xfs/fs/xfs/xfs_qmops.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_qmops.c	2009-02-24 15:32:16.128369539 +0100
> > +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> > @@ -1,152 +0,0 @@
> > -/*
> > - * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> > - * All Rights Reserved.
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License as
> > - * published by the Free Software Foundation.
> > - *
> > - * This program is distributed in the hope that it would be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - *
> > - * You should have received a copy of the GNU General Public License
> > - * along with this program; if not, write the Free Software Foundation,
> > - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > - */
> > -#include "xfs.h"
> > -#include "xfs_fs.h"
> > -#include "xfs_types.h"
> > -#include "xfs_log.h"
> > -#include "xfs_inum.h"
> > -#include "xfs_trans.h"
> > -#include "xfs_sb.h"
> > -#include "xfs_ag.h"
> > -#include "xfs_dir2.h"
> > -#include "xfs_dmapi.h"
> > -#include "xfs_mount.h"
> > -#include "xfs_quota.h"
> > -#include "xfs_error.h"
> > -
> > -
> > -STATIC struct xfs_dquot *
> > -xfs_dqvopchown_default(
> > -	struct xfs_trans	*tp,
> > -	struct xfs_inode	*ip,
> > -	struct xfs_dquot	**dqp,
> > -	struct xfs_dquot	*dq)
> > -{
> > -	return NULL;
> > -}
> > -
> > -/*
> > - * Clear the quotaflags in memory and in the superblock.
> > - */
> > -int
> > -xfs_mount_reset_sbqflags(xfs_mount_t *mp)
> > -{
> > -	int			error;
> > -	xfs_trans_t		*tp;
> > -
> > -	mp->m_qflags = 0;
> > -	/*
> > -	 * It is OK to look at sb_qflags here in mount path,
> > -	 * without m_sb_lock.
> > -	 */
> > -	if (mp->m_sb.sb_qflags == 0)
> > -		return 0;
> > -	spin_lock(&mp->m_sb_lock);
> > -	mp->m_sb.sb_qflags = 0;
> > -	spin_unlock(&mp->m_sb_lock);
> > -
> > -	/*
> > -	 * if the fs is readonly, let the incore superblock run
> > -	 * with quotas off but don't flush the update out to disk
> > -	 */
> > -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> > -		return 0;
> > -#ifdef QUOTADEBUG
> > -	xfs_fs_cmn_err(CE_NOTE, mp, "Writing superblock quota changes");
> > -#endif
> > -	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
> > -	if ((error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
> > -				      XFS_DEFAULT_LOG_COUNT))) {
> > -		xfs_trans_cancel(tp, 0);
> > -		xfs_fs_cmn_err(CE_ALERT, mp,
> > -			"xfs_mount_reset_sbqflags: Superblock update failed!");
> > -		return error;
> > -	}
> > -	xfs_mod_sb(tp, XFS_SB_QFLAGS);
> > -	error = xfs_trans_commit(tp, 0);
> > -	return error;
> > -}
> > -
> > -STATIC int
> > -xfs_noquota_init(
> > -	xfs_mount_t	*mp,
> > -	uint		*needquotamount,
> > -	uint		*quotaflags)
> > -{
> > -	int		error = 0;
> > -
> > -	*quotaflags = 0;
> > -	*needquotamount = B_FALSE;
> > -
> > -	ASSERT(!XFS_IS_QUOTA_ON(mp));
> > -
> > -	/*
> > -	 * If a file system had quotas running earlier, but decided to
> > -	 * mount without -o uquota/pquota/gquota options, revoke the
> > -	 * quotachecked license.
> > -	 */
> > -	if (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_ACCT) {
> > -		cmn_err(CE_NOTE,
> > -                        "XFS resetting qflags for filesystem %s",
> > -                        mp->m_fsname);
> > -
> > -		error = xfs_mount_reset_sbqflags(mp);
> > -	}
> > -	return error;
> > -}
> > -
> > -static struct xfs_qmops xfs_qmcore_stub = {
> > -	.xfs_qminit		= (xfs_qminit_t) xfs_noquota_init,
> > -	.xfs_qmdone		= (xfs_qmdone_t) fs_noerr,
> > -	.xfs_qmmount		= (xfs_qmmount_t) fs_noerr,
> > -	.xfs_qmunmount		= (xfs_qmunmount_t) fs_noerr,
> > -	.xfs_dqrele		= (xfs_dqrele_t) fs_noerr,
> > -	.xfs_dqattach		= (xfs_dqattach_t) fs_noerr,
> > -	.xfs_dqdetach		= (xfs_dqdetach_t) fs_noerr,
> > -	.xfs_dqpurgeall		= (xfs_dqpurgeall_t) fs_noerr,
> > -	.xfs_dqvopalloc		= (xfs_dqvopalloc_t) fs_noerr,
> > -	.xfs_dqvopcreate	= (xfs_dqvopcreate_t) fs_noerr,
> > -	.xfs_dqvoprename	= (xfs_dqvoprename_t) fs_noerr,
> > -	.xfs_dqvopchown		= xfs_dqvopchown_default,
> > -	.xfs_dqvopchownresv	= (xfs_dqvopchownresv_t) fs_noerr,
> > -	.xfs_dqstatvfs		= (xfs_dqstatvfs_t) fs_noval,
> > -	.xfs_dqsync		= (xfs_dqsync_t) fs_noerr,
> > -};
> > -
> > -int
> > -xfs_qmops_get(struct xfs_mount *mp)
> > -{
> > -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > -#ifdef CONFIG_XFS_QUOTA
> > -		mp->m_qm_ops = &xfs_qmcore_xfs;
> > -#else
> > -		cmn_err(CE_WARN,
> > -			"XFS: qouta support not available in this kernel.");
> > -		return EINVAL;
> > -#endif
> > -	} else {
> > -		mp->m_qm_ops = &xfs_qmcore_stub;
> > -	}
> > -
> > -	return 0;
> > -}
> > -
> > -void
> > -xfs_qmops_put(struct xfs_mount *mp)
> > -{
> > -}
> > Index: xfs/fs/xfs/xfs_rename.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_rename.c	2009-02-24 15:32:16.132369560 +0100
> > +++ xfs/fs/xfs/xfs_rename.c	2009-02-24 15:32:35.872519970 +0100
> > @@ -166,7 +166,8 @@ xfs_rename(
> >  	/*
> >  	 * Attach the dquots to the inodes
> >  	 */
> > -	if ((error = XFS_QM_DQVOPRENAME(mp, inodes))) {
> > +	error = xfs_qm_vop_rename_dqattach(inodes);
> > +	if (error) {
> >  		xfs_trans_cancel(tp, cancel_flags);
> >  		goto std_return;
> >  	}
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
