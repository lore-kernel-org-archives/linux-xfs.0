Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C9FC7F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 23:23:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC297AC004
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 21:23:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	43saQhI1TCsxldGd for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 21:23:07 -0700 (PDT)
Date: Fri, 17 May 2013 14:23:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 2/5] xfs: Add pquota fields where gquota is used.
Message-ID: <20130517042303.GN24635@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-3-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368220889-25188-3-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, May 10, 2013 at 04:21:26PM -0500, Chandra Seetharaman wrote:
> Add project quota changes to all the places where group quota field
> is used:
>    * add separate project quota members into various structures
>    * split project quota and group quotas so that instead of overriding
>      the group quota members incore, the new project quota members are
>      used instead
>    * get rid of usage of the OQUOTA flag incore, in favor of separate
>    * group
>      and project quota flags.
>    * add a project dquot argument to various functions.
> 
> No externally visible interfaces changed.

Looks pretty good. Some relatively minor changes below.

> @@ -568,6 +567,17 @@ xfs_qm_dqrepair(
>  	return 0;
>  }
>  
> +struct xfs_inode *
> +xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
> +{
> +	if (XFS_QM_ISUDQ(dqp))
> +		return dqp->q_mount->m_quotainfo->qi_uquotaip;
> +	if (XFS_QM_ISGDQ(dqp))
> +		return dqp->q_mount->m_quotainfo->qi_gquotaip;
> +	ASSERT(XFS_QM_ISPDQ(dqp));
> +	return dqp->q_mount->m_quotainfo->qi_pquotaip;
> +}

Consolidate this with xfs_dquot_tree() as a static inline function,
I think. Let's try and keep all these little helpers together so
they are easy to find ;)

> +
>  /*
>   * Maps a dquot to the buffer containing its on-disk version.
>   * This returns a ptr to the buffer containing the on-disk dquot
> @@ -584,7 +594,7 @@ xfs_qm_dqtobp(
>  	xfs_bmbt_irec_t map;
>  	int		nmaps = 1, error;
>  	xfs_buf_t	*bp;
> -	xfs_inode_t	*quotip = XFS_DQ_TO_QIP(dqp);
> +	xfs_inode_t	*quotip = xfs_dq_to_quota_inode(dqp);

convert to struct xfs_inode a the same time....

> @@ -52,7 +51,8 @@ typedef struct xfs_dquot {
> @@ -144,9 +146,6 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
>  #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
>  #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
>  #define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
> -#define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
> -				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
> -				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)

XFS_DQ_TO_QINF can go away, too.

> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -928,7 +928,7 @@ xfs_ioctl_setattr(
>  	struct xfs_trans	*tp;
>  	unsigned int		lock_flags = 0;
>  	struct xfs_dquot	*udqp = NULL;
> -	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*pdqp = NULL;
>  	struct xfs_dquot	*olddquot = NULL;
>  	int			code;
>  
> @@ -957,7 +957,7 @@ xfs_ioctl_setattr(
>  	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
>  		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
>  					 ip->i_d.di_gid, fa->fsx_projid,
> -					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
> +					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);

We're only passing in XFS_QMOPT_PQUOTA, so we do not need to pass in
uid, gid, udqp or gdqp here....

Can you add a comment here that this may cause user/group quotas
to be allocated, but we don't need it here in this function because
we are only specifically changing the project quota via a chown
operation.

Indeed, the only reason a user quota is passed in is to make use of
the dquot hint that the udq might hold that points to the other
dquots on the inode....

>  		if (code)
>  			return code;
>  	}
> @@ -994,8 +994,8 @@ xfs_ioctl_setattr(
>  		    XFS_IS_PQUOTA_ON(mp) &&
>  		    xfs_get_projid(ip) != fa->fsx_projid) {
>  			ASSERT(tp);
> -			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						capable(CAP_FOWNER) ?
> +			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL,
> +						pdqp, capable(CAP_FOWNER) ?
>  						XFS_QMOPT_FORCE_RES : 0);
> @@ -1113,7 +1113,7 @@ xfs_ioctl_setattr(
>  		if (xfs_get_projid(ip) != fa->fsx_projid) {
>  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
>  				olddquot = xfs_qm_vop_chown(tp, ip,
> -							&ip->i_gdquot, gdqp);
> +							&ip->i_pdquot, pdqp);

xfs_qm_vop_chown() is only called on one dquot at a time, so it can
only exchange one dquot at a time. and udqp is not used for hints,
so it looks to me like udqp and gdqp are wholly unnecessary in this
function....

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index d82efaa..7c54ea4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -517,7 +517,7 @@ xfs_setattr_nonsize(
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
>  		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
> -					 qflags, &udqp, &gdqp);
> +					 qflags, &udqp, &gdqp, NULL);

Why is there no project quota support here, even though we pass in a
project ID? I know the answer, but please add a comment so that a
couple of years down the track I don't need to go remind myself of
why....

>  /*
> - * Given a udquot and gdquot, attach a ptr to the group dquot in the
> + * Given a udquot and gdquot, attach a ptr to the group/project dquot in the
>   * udquot as a hint for future lookups.
>   */
>  STATIC void
> -xfs_qm_dqattach_grouphint(
> -	xfs_dquot_t	*udq,
> -	xfs_dquot_t	*gdq)
> +xfs_qm_dqattach_grouphint(xfs_inode_t *ip, int type)

Wrong format for the function header And it's not longer just for
the group dquot, so I'd rename just to xfs_qm_dqattach_hint. i.e:

STATIC void
xfs_qm_dqattach_hint(
	struct xfs_inode	*ip,
	int			 type)

>  {
> -	xfs_dquot_t	*tmp;
> +	struct xfs_dquot **dqhint;
> +	struct xfs_dquot *gpdq;

not a group dquot. so perhaps just call it dqp?

> @@ -1395,19 +1453,27 @@ xfs_qm_init_quotainos(
>  		if (XFS_IS_UQUOTA_ON(mp) &&
>  		    mp->m_sb.sb_uquotino != NULLFSINO) {
>  			ASSERT(mp->m_sb.sb_uquotino > 0);
> -			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
> -					     0, 0, &uip)))
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
> +					     0, 0, &uip);
> +			if (error)
>  				return XFS_ERROR(error);
>  		}
> -		if (XFS_IS_OQUOTA_ON(mp) &&
> +		if (XFS_IS_GQUOTA_ON(mp) &&
>  		    mp->m_sb.sb_gquotino != NULLFSINO) {
>  			ASSERT(mp->m_sb.sb_gquotino > 0);
> -			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> -					     0, 0, &gip))) {
> -				if (uip)
> -					IRELE(uip);
> -				return XFS_ERROR(error);
> -			}
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> +					     0, 0, &gip);
> +			if (error)
> +				goto error_rele;
> +		}
> +		/* Use sb_gquotino for now */
> +		if (XFS_IS_PQUOTA_ON(mp) &&
> +		    mp->m_sb.sb_gquotino != NULLFSINO) {
> +			ASSERT(mp->m_sb.sb_gquotino > 0);
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> +					     0, 0, &pip);
> +			if (error)
> +				goto error_rele;

There is no need for this trickery, right? All that is needed is:

			qino = xfs_sb_version_has_pquota(&mp->m_sb) ?
						mp->m_sb.sb_pquotino :
						mp->m_sb.sb_gquotino;

And the correct on-disk inode is read....


> @@ -1804,15 +1896,21 @@ xfs_qm_vop_chown(
>   */
>  int
>  xfs_qm_vop_chown_reserve(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip,
> -	xfs_dquot_t	*udqp,
> -	xfs_dquot_t	*gdqp,
> -	uint		flags)
> +	xfs_trans_t		*tp,
> +	xfs_inode_t		*ip,

struct xfs_trans, struct xfs_inode.

> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
> +	uint			flags)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
>  	uint		delblks, blkflags, prjflags = 0;
> -	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
> +	struct xfs_dquot	*unresudq = NULL;
> +	struct xfs_dquot	*unresgdq = NULL;
> +	struct xfs_dquot	*unrespdq = NULL;
> +	struct xfs_dquot	*delblksudq = NULL;
> +	struct xfs_dquot	*delblksgdq = NULL;
> +	struct xfs_dquot	*delblkspdq = NULL;
>  	int		error;

You may as well line up the other 3 declarations, and make is a
struct xfs_mount....

.... and I just realised that looking through this code reviewing
the xfs_ioctl_setattr() changes that I'd not read the existing
code correctly.

Why not? becuse unresudq and unresgdq are not very different. The
classic case of the brain not really seeing the difference between
single letters inside a larger word, and that's where the single
letter difference in the variables are. i.e: this phenomenon:

http://www.ecenglish.com/learnenglish/lessons/can-you-read

I can read that mess as fast as if it were spelt correctly, hence
the importance of the first/last letter of variable names...

So, can you rename these variables:

	udq_unres
	gdq_unres
	pdq_unres
	udq_delblks
	gdq_delblks
	pdq_delblks

so it's a little more obvious to my easily tricked brain that they
are different....

> @@ -1935,13 +2039,18 @@ xfs_qm_vop_create_dqattach(
>  	}
>  	if (gdqp) {
>  		ASSERT(ip->i_gdquot == NULL);
> -		ASSERT(XFS_IS_OQUOTA_ON(mp));
> -		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
> -			ip->i_d.di_gid : xfs_get_projid(ip)) ==
> -				be32_to_cpu(gdqp->q_core.d_id));
> -
> +		ASSERT(XFS_IS_GQUOTA_ON(mp));
> +		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
>  		ip->i_gdquot = xfs_qm_dqhold(gdqp);
>  		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
>  	}
> +	if (pdqp) {
> +		ASSERT(ip->i_pdquot == NULL);
> +		ASSERT(XFS_IS_PQUOTA_ON(mp));
> +		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
> +
> +		ip->i_pdquot = xfs_qm_dqhold(pdqp);
> +		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> +	}
>  }

Something this just triggered. All transaction reservations that
reserve space for dquots need to be upped from 2 to 3 dquots.

> -extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
> -extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
> -			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
> -extern void	xfs_trans_dqjoin(xfs_trans_t *, xfs_dquot_t *);
> -extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
> +extern void	xfs_trans_mod_dquot(xfs_trans_t *, struct xfs_dquot *, uint, long);
> +extern void	xfs_trans_dqjoin(xfs_trans_t *, struct xfs_dquot *);
> +extern void	xfs_trans_log_dquot(xfs_trans_t *, struct xfs_dquot *);

Remove the typedefs at the same time.


>  /*
> - * We keep the usr and grp dquots separately so that locking will be easier
> - * to do at commit time. All transactions that we know of at this point
> + * We keep the usr, grp, and prj dquots separately so that locking will be
> + * easier to do at commit time. All transactions that we know of at this point
>   * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
>   */
> +enum {
> +	XFS_QM_TRANS_USR = 0,
> +	XFS_QM_TRANS_GRP,
> +	XFS_QM_TRANS_PROJ,
> +	XFS_QM_TRANS_DQTYPES
> +};
>  #define XFS_QM_TRANS_MAXDQS		2
> -typedef struct xfs_dquot_acct {
> -	xfs_dqtrx_t	dqa_usrdquots[XFS_QM_TRANS_MAXDQS];
> -	xfs_dqtrx_t	dqa_grpdquots[XFS_QM_TRANS_MAXDQS];
> -} xfs_dquot_acct_t;
> +struct xfs_dquot_acct {
> +	struct xfs_dqtrx dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
> +};
>  
>  /*
>   * Users are allowed to have a usage exceeding their softlimit for
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 2d02eac..72a4fdd 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -115,7 +115,7 @@ xfs_qm_newmount(
>  	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
>  	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)) ||
>  	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
> -	    (!gquotaondisk &&  XFS_IS_OQUOTA_ON(mp)))  &&
> +	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)))  &&
>  	    xfs_dev_is_read_only(mp, "changing quota state")) {
>  		xfs_warn(mp, "please mount with%s%s%s%s.",
>  			(!quotaondisk ? "out quota" : ""),

Shouldn't this hunk be in the first patch?


> index 1501f4f..cd0d133 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -498,6 +498,7 @@ xfs_create(
>  	prid_t			prid;
>  	struct xfs_dquot	*udqp = NULL;
>  	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*pdqp = NULL;
>  	uint			resblks;
>  	uint			log_res;
>  	uint			log_count;
> @@ -516,7 +517,7 @@ xfs_create(
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
>  	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> -			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
> +		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);

break that into two lines.

				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
				&udqp, &gdqp, &pdqp);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
