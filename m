Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F1Fj8D043875 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 20:15:46 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tLP60t54ZOtH6UKj for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 18:15:42 -0700 (PDT)
Date: Wed, 15 Aug 2012 11:15:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v6 PATCH 2/5] xfs: Add pquota fields where gquota is used.
Message-ID: <20120815011538.GR2877@dastard>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230225.20477.87398.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120720230225.20477.87398.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 20, 2012 at 06:02:25PM -0500, Chandra Seetharaman wrote:
> Add project quota changes to all the places where group quota field
> is used:
>    * add separate project quota members into various structures
>    * split project quota and group quotas so that instead of overriding
>      the group quota members incore, the new project quota members are
>      used instead
>    * get rid of usage of the OQUOTA flag incore, in favor of separate group
>      and project quota flags.
>    * add a project dquot argument to various functions.
> 
> No externally visible interfaces changed and no superblock changes yet.

Lots of comments below.

> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_dquot.c       |   16 ++-
>  fs/xfs/xfs_dquot.h       |   11 ++-
>  fs/xfs/xfs_iget.c        |    2 +-
>  fs/xfs/xfs_inode.h       |    1 +
>  fs/xfs/xfs_ioctl.c       |   14 ++--
>  fs/xfs/xfs_iops.c        |    4 +-
>  fs/xfs/xfs_qm.c          |  255 ++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_qm.h          |   15 ++--
>  fs/xfs/xfs_qm_bhv.c      |    2 +-
>  fs/xfs/xfs_qm_syscalls.c |   19 +++-
>  fs/xfs/xfs_quota.h       |   38 ++++---
>  fs/xfs/xfs_sb.h          |    1 +
>  fs/xfs/xfs_super.c       |    5 +-
>  fs/xfs/xfs_trans_dquot.c |   71 ++++++++++---
>  fs/xfs/xfs_vnodeops.c    |   23 +++--
>  15 files changed, 326 insertions(+), 151 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index bf27fcc..42b8b79 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -751,7 +751,7 @@ xfs_qm_dqput_final(
>  	struct xfs_dquot	*dqp)
>  {
>  	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
> -	struct xfs_dquot	*gdqp;
> +	struct xfs_dquot	*gdqp, *pdqp;

We tend not to declare multiple variables on the one line - just add
a new line with the new variable.

>  
>  	trace_xfs_dqput_free(dqp);
>  
> @@ -765,21 +765,29 @@ xfs_qm_dqput_final(
>  
>  	/*
>  	 * If we just added a udquot to the freelist, then we want to release
> -	 * the gdquot reference that it (probably) has. Otherwise it'll keep
> -	 * the gdquot from getting reclaimed.
> +	 * the gdquot/pdquot reference that it (probably) has. Otherwise it'll
> +	 * keep the gdquot/pdquot from getting reclaimed.
>  	 */
>  	gdqp = dqp->q_gdquot;
>  	if (gdqp) {
>  		xfs_dqlock(gdqp);
>  		dqp->q_gdquot = NULL;
>  	}
> +
> +	pdqp = dqp->q_pdquot;
> +	if (pdqp) {
> +		xfs_dqlock(pdqp);
> +		dqp->q_pdquot = NULL;
> +	}

seeing this (and the various dupilications in this patch) makes me
wonder if we'd be better off with array based abstractions and
loops. That's not important for this patch set, but if we ever want
to add another type of quota, then it would make sense...

> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 7d20af2..893cd5e 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -46,6 +46,7 @@ typedef struct xfs_dquot {
>  	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
>  
>  	struct xfs_dquot*q_gdquot;	/* group dquot, hint only */
> +	struct xfs_dquot *q_pdquot;	/* project dquot, hint only */

You may as well put a space in the q_gdquot declaration so they are
consistent....

> +		return ip->i_pdquot;
>  	default:
>  		return NULL;
>  	}
> @@ -136,7 +139,9 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
>  #define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
>  #define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
>  				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
> -				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
> +				 (XFS_QM_ISGDQ(dqp) ? \
> +				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip : \
> +				 XFS_DQ_TO_QINF(dqp)->qi_pquotaip))

nested ?: constructs are a bit nasty. Perhaps this should be
converted to a static inline function like:

static inline struct xfs_inode *
xfs_dq_to_quota_inode(
	struct xfs_dquot	*dqp)
{
	if (XFS_QM_ISUDQ(dqp))
		return dqp->q_mount->m_quotainfo->qi_uquotaip;
	if (XFS_QM_ISGDQ(dqp))
		return dqp->q_mount->m_quotainfo->qi_gquotaip;
	ASSERT(XFS_QM_ISPDQ(dqp)));
	return dqp->q_mount->m_quotainfo->qi_pquotaip;
}


>  
>  extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
>  					uint, struct xfs_dquot	**);
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index 1bb4365..e97fb18 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -346,7 +346,7 @@ xfs_iget_cache_miss(
>  	iflags = XFS_INEW;
>  	if (flags & XFS_IGET_DONTCACHE)
>  		iflags |= XFS_IDONTCACHE;
> -	ip->i_udquot = ip->i_gdquot = NULL;
> +	ip->i_udquot = ip->i_gdquot = ip->i_pdquot = NULL;

That's getting a little messy. I think you should convert these to
an assignment per line. i.e:

	ip->i_udquot = NULL;
	ip->i_gdquot = NULL;
	ip->i_pdquot = NULL;

> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 3fb3730..46c7e4c 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -134,7 +134,7 @@ xfs_qm_dqpurge(
>  {
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> -	struct xfs_dquot	*gdqp = NULL;
> +	struct xfs_dquot	*gdqp = NULL, *pdqp = NULL;

New variable on a new line.

>  
>  	xfs_dqlock(dqp);
>  	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> @@ -143,8 +143,8 @@ xfs_qm_dqpurge(
>  	}
>  
>  	/*
> -	 * If this quota has a group hint attached, prepare for releasing it
> -	 * now.
> +	 * If this quota has a group/project hint attached, prepare for
> +	 * releasing it now.

I'd just say "If this quota has a hint attached..."

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
>  {
> -	xfs_dquot_t	*tmp;
> +	xfs_dquot_t	**tmp, *gpdq, *tmp1, *udq = ip->i_udquot;

Don't use typedefs for new definitions, tmp is a really bad name,
and use consistent style:

STATIC void
xfs_qm_dqattach_grouphint(
	struct xfs_inode	*ip,
	int			type)
{
	struct xfs_dquot	*udq = ip->i_udquot;
	struct xfs_dquot	*gpdq;
	struct xfs_dquot	**dqhint;
	struct xfs_dquot	*tmp1;

> +	gpdq = (type == XFS_DQ_GROUP) ? ip->i_gdquot : ip->i_pdquot;
>  	xfs_dqlock(udq);
>  
> -	tmp = udq->q_gdquot;
> -	if (tmp) {
> -		if (tmp == gdq)
> +	tmp = (type == XFS_DQ_GROUP) ? &udq->q_gdquot : &udq->q_pdquot;

	if (type == XFS_DQ_GROUP) {
		gpdq = ip->i_gdquot;
		dqhint = &udq->q_gdquot;
	} else {
		gpdq = ip->i_gdquot;
		dqhint = &udq->q_gdquot;
	}

> +
> +	if (*tmp) {
> +		if (*tmp == gpdq)
>  			goto done;
>  
> -		udq->q_gdquot = NULL;
> -		xfs_qm_dqrele(tmp);
> +		tmp1 = *tmp;
> +		*tmp = NULL;
> +		xfs_qm_dqrele(tmp1);
>  	}
>  
> -	udq->q_gdquot = xfs_qm_dqhold(gdq);
> +	*tmp = xfs_qm_dqhold(gpdq);

	if (*dqhint) {
		struct xfs_dquot	*tmp;

		if (*dqhint == gpdq)
			goto done;

		tmp = *dqhint;
		*dqhint = NULL;
		xfs_qm_rele(tmp);
	}
	*dqhint = xfs_qm_dqhold(gpdq);

And when we get rid of the tmp names, all of a sudden the code goes
from being unreadable to being obviously suboptimal. i.e:

	if (*dqhint == gpdq)
		goto done;

	if (*dqhint)
		xfs_qm_rele(*dqhint);
	*dqhint = xfs_qm_dqhold(gpdq);

We don't need the second temp variable because we have the dquot
locked and so nobody is going to be accessing the hint in the dquot
after we've released it. If they are accessing it unlocked, then it
is already racy and setting the dqhint to null doesn't change
anything....

> @@ -1227,7 +1269,7 @@ xfs_qm_quotacheck(
>  	int		done, count, error, error2;
>  	xfs_ino_t	lastino;
>  	size_t		structsz;
> -	xfs_inode_t	*uip, *gip;
> +	xfs_inode_t	*uip, *gip, *pip;

	struct xfs_inode *uip = mp->m_quotainfo->qi_uquotaip;
	struct xfs_inode *gip = mp->m_quotainfo->qi_gquotaip;
	struct xfs_inode *pip = mp->m_quotainfo->qi_pquotaip;

>  	uint		flags;
>  	LIST_HEAD	(buffer_list);
>  
> @@ -1236,7 +1278,8 @@ xfs_qm_quotacheck(
>  	lastino = 0;
>  	flags = 0;
>  
> -	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
> +	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip
> +			|| mp->m_quotainfo->qi_pquotaip);

	ASSERT(uip || gip || pip);

>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
>  	xfs_notice(mp, "Quotacheck needed: Please wait.");
> @@ -1257,13 +1300,20 @@ xfs_qm_quotacheck(
>  
>  	gip = mp->m_quotainfo->qi_gquotaip;
>  	if (gip) {
> -		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
> -					 XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA,
> +		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA,
>  					 &buffer_list);
>  		if (error)
>  			goto error_return;
> -		flags |= XFS_IS_GQUOTA_ON(mp) ?
> -					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
> +		flags |= XFS_GQUOTA_CHKD;
> +	}
> +
> +	pip = mp->m_quotainfo->qi_pquotaip;
> +	if (pip) {
> +		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA,
> +					 &buffer_list);
> +		if (error)
> +			goto error_return;
> +		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
>  	do {
> @@ -1358,13 +1408,13 @@ STATIC int
>  xfs_qm_init_quotainos(
>  	xfs_mount_t	*mp)
>  {
> -	xfs_inode_t	*uip, *gip;
> +	xfs_inode_t	*uip, *gip, *pip;
>  	int		error;
>  	__int64_t	sbflags;
>  	uint		flags;
>  
>  	ASSERT(mp->m_quotainfo);
> -	uip = gip = NULL;
> +	uip = gip = pip = NULL;

Same as above.

>  	sbflags = 0;
>  	flags = 0;
>  
> @@ -1379,7 +1429,7 @@ xfs_qm_init_quotainos(
>  					     0, 0, &uip)))
>  				return XFS_ERROR(error);
>  		}
> -		if (XFS_IS_OQUOTA_ON(mp) &&
> +		if (XFS_IS_GQUOTA_ON(mp) &&
>  		    mp->m_sb.sb_gquotino != NULLFSINO) {
>  			ASSERT(mp->m_sb.sb_gquotino > 0);
>  			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> @@ -1389,6 +1439,19 @@ xfs_qm_init_quotainos(
>  				return XFS_ERROR(error);
>  			}
>  		}
> +		if (XFS_IS_PQUOTA_ON(mp) &&
> +		    mp->m_sb.sb_pquotino != NULLFSINO) {
> +			ASSERT(mp->m_sb.sb_pquotino > 0);
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
> +					     0, 0, &pip);
> +			if (error) {
> +				if (uip)
> +					IRELE(uip);
> +				if (gip)
> +					IRELE(gip);
> +				return XFS_ERROR(error);
> +			}

This error handling is repeated a couple of times. It is better to
use an error stack at the end of the function for this. i.e.

			if (error)
				goto error_rele;
	...

	return 0;

error_rele:
	if (uip)
		IRELE(uip);
	if (gip)
		IRELE(gip);
	if (pip)
		IRELE(pip);
	return XFS_ERROR(error);
}

> @@ -1621,10 +1697,11 @@ xfs_qm_vop_dqalloc(
>  	prid_t			prid,
>  	uint			flags,
>  	struct xfs_dquot	**O_udqpp,
> -	struct xfs_dquot	**O_gdqpp)
> +	struct xfs_dquot	**O_gdqpp,
> +	struct xfs_dquot	**O_pdqpp)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_dquot	*uq, *gq;
> +	struct xfs_dquot	*uq, *gq, *pq;

Separate lines with initialisation...

>  	int			error;
>  	uint			lockflags;
>  
> @@ -1649,7 +1726,7 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  
> -	uq = gq = NULL;
> +	uq = gq = pq = NULL;

So this can be killed.

>  	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
>  		if (ip->i_d.di_uid != uid) {
>  			/*
> @@ -1705,25 +1782,28 @@ xfs_qm_vop_dqalloc(
>  			ASSERT(ip->i_gdquot);
>  			gq = xfs_qm_dqhold(ip->i_gdquot);
>  		}
> -	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
> +	}
> +	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
>  		if (xfs_get_projid(ip) != prid) {
>  			xfs_iunlock(ip, lockflags);
>  			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
>  						 XFS_DQ_PROJ,
>  						 XFS_QMOPT_DQALLOC |
>  						 XFS_QMOPT_DOWARN,
> -						 &gq))) {
> +						 &pq))) {

Separate the function call fro the if() statement. Also, both dqid_t
and prid_t are uint32_t, so there is no need for a cast:

			error = xfs_qm_dqget(mp, NULL, prid, XFS_DQ_PROJ,
					XFS_QMOPT_DQALLOC | XFS_QMOPT_DOWARN,
					&gq);
			if (error) {
				....

> @@ -1790,11 +1874,13 @@ xfs_qm_vop_chown_reserve(
>  	xfs_inode_t	*ip,
>  	xfs_dquot_t	*udqp,
>  	xfs_dquot_t	*gdqp,
> +	xfs_dquot_t	*pdqp,

Probably should remove the typedefs while adding new parameters.
>  	uint		flags)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
>  	uint		delblks, blkflags, prjflags = 0;
> -	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
> +	xfs_dquot_t	*unresudq, *unresgdq, *unrespdq;
> +	xfs_dquot_t	*delblksudq, *delblksgdq, *delblkspdq;
>  	int		error;

Same here, and use one variable per line with initialisation.
>  
>  
> @@ -1802,7 +1888,8 @@ xfs_qm_vop_chown_reserve(
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
>  	delblks = ip->i_delayed_blks;
> -	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
> +	delblksudq = delblksgdq = delblkspdq = NULL;
> +	unresudq = unresgdq = unrespdq = NULL;

So this can be removed.

>  	blkflags = XFS_IS_REALTIME_INODE(ip) ?
>  			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
>  
> @@ -1819,25 +1906,28 @@ xfs_qm_vop_chown_reserve(
>  			unresudq = ip->i_udquot;
>  		}
>  	}
> -	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
> -		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
> -		     xfs_get_projid(ip) != be32_to_cpu(gdqp->q_core.d_id))
> -			prjflags = XFS_QMOPT_ENOSPC;
> -
> -		if (prjflags ||
> -		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
> -		     ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id))) {
> -			delblksgdq = gdqp;
> -			if (delblks) {
> -				ASSERT(ip->i_gdquot);
> -				unresgdq = ip->i_gdquot;
> -			}
> +	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
> +	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
> +		delblksgdq = gdqp;
> +		if (delblks) {
> +			ASSERT(ip->i_gdquot);
> +			unresgdq = ip->i_gdquot;
> +		}
> +	}
> +
> +	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> +	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
> +		prjflags = XFS_QMOPT_ENOSPC;
> +		delblkspdq = pdqp;
> +		if (delblks) {
> +			ASSERT(ip->i_pdquot);
> +			unrespdq = ip->i_pdquot;
>  		}
>  	}
>  
>  	if ((error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
> -				delblksudq, delblksgdq, ip->i_d.di_nblocks, 1,
> -				flags | blkflags | prjflags)))
> +			delblksudq, delblksgdq, delblkspdq, ip->i_d.di_nblocks,
> +			1, flags | blkflags | prjflags)))

Separate the function call from the if().

>  		return (error);
>  
>  	/*
> @@ -1850,15 +1940,16 @@ xfs_qm_vop_chown_reserve(
>  		/*
>  		 * Do the reservations first. Unreservation can't fail.
>  		 */
> -		ASSERT(delblksudq || delblksgdq);
> -		ASSERT(unresudq || unresgdq);
> +		ASSERT(delblksudq || delblksgdq || delblkspdq);
> +		ASSERT(unresudq || unresgdq || unrespdq);
>  		if ((error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> -				delblksudq, delblksgdq, (xfs_qcnt_t)delblks, 0,
> +				delblksudq, delblksgdq, delblkspdq,
> +				(xfs_qcnt_t)delblks, 0,
>  				flags | blkflags | prjflags)))

Same again.

> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 44b858b..256ff71 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -44,9 +44,11 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>  typedef struct xfs_quotainfo {
>  	struct radix_tree_root qi_uquota_tree;
>  	struct radix_tree_root qi_gquota_tree;
> +	struct radix_tree_root qi_pquota_tree;
>  	struct mutex qi_tree_lock;
>  	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
>  	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
> +	xfs_inode_t	*qi_pquotaip;	 /* project quota inode */

convert to struct xfs_inode.

>  	struct list_head qi_lru_list;
>  	struct mutex	 qi_lru_lock;
>  	int		 qi_lru_count;
> @@ -70,26 +72,25 @@ typedef struct xfs_quotainfo {
>  } xfs_quotainfo_t;
>  
>  #define XFS_DQUOT_TREE(qi, type) \
> -	((type & XFS_DQ_USER) ? \
> -	 &((qi)->qi_uquota_tree) : \
> -	 &((qi)->qi_gquota_tree))
> +	((type & XFS_DQ_USER) ? &((qi)->qi_uquota_tree) : \
> +	((type & XFS_DQ_GROUP) ? &((qi)->qi_gquota_tree) : \
> +	 &((qi)->qi_pquota_tree)))

Convert to static inline, I think.

static inline struct radix_tree_root *
xfs_dquot_tree(
	struct xfs_quotainfo	*qi,
	int			type)
{
	switch(type) {
	case XFS_DQ_USER:
		return qi->qi_uquota_tree;
	case XFS_DQ_GROUP:
		return qi->qi_gquota_tree;
	case XFS_DQ_PROJ:
		return qi->qi_pquota_tree;
	default:
		ASSERT(0);
	}
	return NULL;
}

> @@ -267,8 +265,10 @@ typedef struct xfs_qoff_logformat {
>   */
>  #define XFS_NOT_DQATTACHED(mp, ip) ((XFS_IS_UQUOTA_ON(mp) &&\
>  				     (ip)->i_udquot == NULL) || \
> -				    (XFS_IS_OQUOTA_ON(mp) && \
> -				     (ip)->i_gdquot == NULL))
> +				    (XFS_IS_GQUOTA_ON(mp) && \
> +				     (ip)->i_gdquot == NULL) || \
> +				    (XFS_IS_PQUOTA_ON(mp) && \
> +				     (ip)->i_pdquot == NULL))

#define XFS_NOT_DQATTACHED(mp, ip)	\
	((XFS_IS_UQUOTA_ON(mp) && (ip)->i_udquot == NULL) || \
	 (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \
	 (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))

> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -113,7 +113,7 @@ xfs_trans_dup_dqinfo(
>  	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
>  		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  
> -	for (j = 0; j < 2; j++) {
> +	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
>  		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
>  			if (oqa[i].qt_dquot == NULL)
>  				break;
> @@ -138,8 +138,13 @@ xfs_trans_dup_dqinfo(
>  			oq->qt_ino_res = oq->qt_ino_res_used;
>  
>  		}
> -		oqa = otp->t_dqinfo->dqa_grpdquots;
> -		nqa = ntp->t_dqinfo->dqa_grpdquots;
> +		if (oqa == otp->t_dqinfo->dqa_usrdquots) {
> +			oqa = otp->t_dqinfo->dqa_grpdquots;
> +			nqa = ntp->t_dqinfo->dqa_grpdquots;
> +		} else {
> +			oqa = otp->t_dqinfo->dqa_prjdquots;
> +			nqa = ntp->t_dqinfo->dqa_prjdquots;
> +		}
>  	}

Ok, that's just plain nasty. And it's repeated nastiness.

I think that the best thing to do is redefine the struct
xfs_dquot_acct to something like:

enum {
	XFS_QM_TRANS_USR = 0,
	XFS_QM_TRANS_GRP,
	XFS_QM_TRANS_PROJ,
	XFS_QM_TRANS_DQTYPES,
};
#define XFS_QM_TRANS_MAXDQS 2
struct xfs_dquot_acct {
	struct xfs_dqtrx dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
}


and that makes all these loops something like:

	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
		oqa = &otp->t_dqinfo->dqs[j];

		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
		....
		}
	}

And all this nastiness of selecting the next structure element goes
away.

>  STATIC xfs_dqtrx_t *
> @@ -178,15 +185,20 @@ xfs_trans_get_dqtrx(
>  	int		i;
>  	xfs_dqtrx_t	*qa;
>  
> -	qa = XFS_QM_ISUDQ(dqp) ?
> -		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
> +	if (XFS_QM_ISUDQ(dqp))
> +		qa = tp->t_dqinfo->dqa_usrdquots;

		qa = &tp->t_dqinfo->dqs[XFS_QM_TRANS_USR];

> +	else if (XFS_QM_ISGDQ(dqp))
> +		qa = tp->t_dqinfo->dqa_grpdquots;

		qa = &tp->t_dqinfo->dqs[XFS_QM_TRANS_GRP];

> +	else if (XFS_QM_ISPDQ(dqp))
> +		qa = tp->t_dqinfo->dqa_prjdquots;

		qa = &tp->t_dqinfo->dqs[XFS_QM_TRANS_PROJ];

> +	else
> +		return NULL;
>  
>  	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
>  		if (qa[i].qt_dquot == NULL ||
>  		    qa[i].qt_dquot == dqp)
>  			return &qa[i];
>  	}
> -
>  	return NULL;
>  }
>  
> @@ -340,9 +352,12 @@ xfs_trans_apply_dquot_deltas(
>  
>  	ASSERT(tp->t_dqinfo);
>  	qa = tp->t_dqinfo->dqa_usrdquots;
> -	for (j = 0; j < 2; j++) {
> +	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */

Comments aren't necessary like this if the above enum/array
construct is used.

>  		if (qa[0].qt_dquot == NULL) {
> -			qa = tp->t_dqinfo->dqa_grpdquots;
> +			if (qa == tp->t_dqinfo->dqa_usrdquots)
> +				qa = tp->t_dqinfo->dqa_grpdquots;
> +			else
> +				qa = tp->t_dqinfo->dqa_prjdquots;
>  			continue;
>  		}
>  
> @@ -496,9 +511,12 @@ xfs_trans_apply_dquot_deltas(
>  				be64_to_cpu(dqp->q_core.d_rtbcount));
>  		}
>  		/*
> -		 * Do the group quotas next
> +		 * Do the group quotas or project quotas next
>  		 */
> -		qa = tp->t_dqinfo->dqa_grpdquots;
> +		if (qa == tp->t_dqinfo->dqa_usrdquots)
> +			qa = tp->t_dqinfo->dqa_grpdquots;
> +		else
> +			qa = tp->t_dqinfo->dqa_prjdquots;
>  	}
>  }
>  
> @@ -523,7 +541,7 @@ xfs_trans_unreserve_and_mod_dquots(
>  
>  	qa = tp->t_dqinfo->dqa_usrdquots;
>  
> -	for (j = 0; j < 2; j++) {
> +	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
>  		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
>  			qtrx = &qa[i];
>  			/*
> @@ -565,7 +583,10 @@ xfs_trans_unreserve_and_mod_dquots(
>  				xfs_dqunlock(dqp);
>  
>  		}
> -		qa = tp->t_dqinfo->dqa_grpdquots;
> +		if (qa == tp->t_dqinfo->dqa_usrdquots)
> +			qa = tp->t_dqinfo->dqa_grpdquots;
> +		else
> +			qa = tp->t_dqinfo->dqa_prjdquots;
>  	}

And all this repeated nastiness goes away...

>  }
>  
> @@ -734,8 +755,8 @@ error_return:
>  
>  /*
>   * Given dquot(s), make disk block and/or inode reservations against them.
> - * The fact that this does the reservation against both the usr and
> - * grp/prj quotas is important, because this follows a both-or-nothing
> + * The fact that this does the reservation against user, group and
> + * project quotas is important, because this follows a all-or-nothing
>   * approach.
>   *
>   * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
> @@ -750,6 +771,7 @@ xfs_trans_reserve_quota_bydquots(
>  	xfs_mount_t	*mp,
>  	xfs_dquot_t	*udqp,
>  	xfs_dquot_t	*gdqp,
> +	xfs_dquot_t	*pdqp,
>  	long		nblks,
>  	long		ninos,
>  	uint		flags)

kill the typedefs.

> @@ -787,6 +809,24 @@ xfs_trans_reserve_quota_bydquots(
>  		}
>  	}
>  
> +	if (pdqp) {
> +		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
> +		if (error) {
> +			/*
> +			 * can't do it, so backout previous reservation
> +			 */
> +			if (resvd) {
> +				flags |= XFS_QMOPT_FORCE_RES;
> +				xfs_trans_dqresv(tp, mp, udqp,
> +						 -nblks, -ninos, flags);
> +				if (gdqp)
> +					xfs_trans_dqresv(tp, mp, gdqp,
> +						 -nblks, -ninos, flags);
> +			}
> +			return error;
> +		}
> +	}
> +

This will only unwind group reservation is there was a user quota
reservation. I think that is wrong.

I think an unwind stack is better than the nested error
handling, and it removes the need for the "resvd" variable to
indicate that a user quota modification was made. i.e.

	if (udqp) {
		....
		if (error)
			return error;
		....
	}
	if (gdqp) {
		....
		if (error)
			goto unwind_usr;
		....
	}
	if (pdqp) {
		....
		if (error)
			goto unwind_grp;
		....
	}


unwind_grp:
	flags |= XFS_QMOPT_FORCE_RES
	if (gdqp)
		xfs_trans_dqresv(tp, mp, gdqp, -nblks, -ninos, flags);
unwind_usr:
	flags |= XFS_QMOPT_FORCE_RES
	if (udqp)
		xfs_trans_dqresv(tp, mp, udqp, -nblks, -ninos, flags);
	return error;

> @@ -1498,7 +1502,7 @@ xfs_symlink(
>  	int			n;
>  	xfs_buf_t		*bp;
>  	prid_t			prid;
> -	struct xfs_dquot	*udqp, *gdqp;
> +	struct xfs_dquot	*udqp = NULL, *gdqp = NULL, *pdqp = NULL;

One per line.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
