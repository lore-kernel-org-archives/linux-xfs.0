Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37282 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbeDEDwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Apr 2018 23:52:45 -0400
Date: Wed, 4 Apr 2018 20:52:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: pass xfs_dqblk to
 xfs_dquot_verify/xfs_dquot_repair
Message-ID: <20180405035241.GB7500@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 01:54:26PM -0500, Eric Sandeen wrote:
> In order to validate the UUID in xfs_dquot_verify, we need
> the full xfs_qblk, not just the xfs_disk_dquot_t (which is

          ^^^^^^^^^ xfs_dqblk, right?

> a subset).
> 
> Do the same for xfs_dquot_repair, for the same reasons.
> Casting a xfs_disk_dquot to a xfs_qblk is risky if the source
> pointer wasn't a full xfs_dqblk, so enforce that by changing
> the arguments to these functions.
> 
> In xfs_qm_dqflush we move the memcpy up so that we have
> a full (and updated) xfs_dqblk to test.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  | 23 +++++++++--------------
>  fs/xfs/libxfs/xfs_quota_defs.h |  4 ++--
>  fs/xfs/xfs_dquot.c             | 12 +++++++-----
>  fs/xfs/xfs_log_recover.c       |  6 ++++--
>  fs/xfs/xfs_qm.c                |  6 +++---
>  5 files changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index a926058..f94e8c2 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -44,11 +44,13 @@
>   */
>  xfs_failaddr_t
>  xfs_dquot_verify(
> -	struct xfs_mount *mp,
> -	xfs_disk_dquot_t *ddq,
> -	xfs_dqid_t	 id,
> -	uint		 type)	  /* used only when IO_dorepair is true */
> +	struct xfs_mount	*mp,
> +	struct xfs_dqblk	*dqb,
> +	xfs_dqid_t		id,
> +	uint			type)	  /* used only during quota rebuild */
>  {
> +	struct xfs_disk_dquot	*ddq = &dqb->dd_diskdq;
> +
>  	/*
>  	 * We can encounter an uninitialized dquot buffer for 2 reasons:
>  	 * 1. If we crash while deleting the quotainode(s), and those blks got
> @@ -104,13 +106,10 @@
>  int
>  xfs_dquot_repair(
>  	struct xfs_mount	*mp,
> -	struct xfs_disk_dquot	*ddq,
> +	struct xfs_dqblk	*d,
>  	xfs_dqid_t		id,
>  	uint			type)
>  {
> -	struct xfs_dqblk	*d = (struct xfs_dqblk *)ddq;
> -
> -
>  	/*
>  	 * Typically, a repair is only requested by quotacheck.
>  	 */
> @@ -192,14 +191,10 @@

Any way you can get your diff generator to add -p to spit out the
alleged function this chunk is supposed to land in?  It makes reviewing
patches somewhat easier for me. :)

>  	 * buffer so corruptions could point to the wrong dquot in this case.
>  	 */
>  	for (i = 0; i < ndquots; i++) {
> -		struct xfs_disk_dquot	*ddq;
> -
> -		ddq = &d[i].dd_diskdq;
> -
>  		if (i == 0)
> -			id = be32_to_cpu(ddq->d_id);
> +			id = be32_to_cpu(d[i].dd_diskdq.d_id);
>  
> -		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
> +		fa = xfs_dquot_verify(mp, &d[i], id + i, 0);
>  		if (fa)
>  			return fa;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 8433656..424526a 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -152,9 +152,9 @@
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
>  extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
> -		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
> +		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
> -extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_disk_dquot *ddq,
> +extern int xfs_dquot_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
>  		xfs_dqid_t id, uint type);
>  
>  #endif	/* __XFS_QUOTA_H__ */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 7e203f9..f7bed3c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -955,6 +955,7 @@
>  {
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	struct xfs_buf		*bp;
> +	struct xfs_dqblk	*dqb;
>  	struct xfs_disk_dquot	*ddqp;
>  	xfs_failaddr_t		fa;
>  	int			error;
> @@ -998,12 +999,16 @@
>  	/*
>  	 * Calculate the location of the dquot inside the buffer.
>  	 */
> -	ddqp = bp->b_addr + dqp->q_bufoffset;
> +	dqb = bp->b_addr + dqp->q_bufoffset;
> +	ddqp = &dqb->dd_diskdq;
> +
> +	/* This is the only portion of data that needs to persist */
> +	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
>  
>  	/*
>  	 * A simple sanity check in case we got a corrupted dquot..
>  	 */
> -	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(ddqp->d_id), 0);
> +	fa = xfs_dquot_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
>  				be32_to_cpu(ddqp->d_id), fa);
> @@ -1013,9 +1018,6 @@
>  		return -EIO;
>  	}
>  
> -	/* This is the only portion of data that needs to persist */
> -	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));

About this memcpy() -- isn't the point of this function that we verify
the contents of the in-core q_core and only memcpy the contents into the
xfs_buf if it actually passes validation?  I guess the _dquot_verify
function needs the entire on-disk buffer so that it can validate the crc
and the uuid on a read, but we update the crc on dqflush and
(presumably) can set the uuid on write (quotacheck) or fail the dquot
read everywhere else, right?

Put another way, why not have xfs_dquot_buf_verify check the uuid?
xfs_dquot_repair seems to reset the uuid if it's garbage.

--D

> -
>  	/*
>  	 * Clear the dirty field and remember the flush lsn for later use.
>  	 */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 3b35feb..546df8e1 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3309,6 +3309,7 @@ struct xfs_buf_cancel {
>  {
>  	xfs_mount_t		*mp = log->l_mp;
>  	xfs_buf_t		*bp;
> +	struct xfs_dqblk	*dqb;
>  	struct xfs_disk_dquot	*ddq, *recddq;
>  	xfs_failaddr_t		fa;
>  	int			error;
> @@ -3322,7 +3323,8 @@ struct xfs_buf_cancel {
>  	if (mp->m_qflags == 0)
>  		return 0;
>  
> -	recddq = item->ri_buf[1].i_addr;
> +	dqb = item->ri_buf[1].i_addr;
> +	recddq = &dqb->dd_diskdq;
>  	if (recddq == NULL) {
>  		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
>  		return -EIO;
> @@ -3353,7 +3355,7 @@ struct xfs_buf_cancel {
>  	 */
>  	dq_f = item->ri_buf[0].i_addr;
>  	ASSERT(dq_f);
> -	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
> +	fa = xfs_dquot_verify(mp, dqb, dq_f->qlf_id, 0);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
>  				dq_f->qlf_id, fa);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 64c22c32..b422382 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -859,7 +859,7 @@ struct xfs_qm_isolate {
>  	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
>  		struct xfs_disk_dquot	*ddq;
>  
> -		ddq = (struct xfs_disk_dquot *)&dqb[j];
> +		ddq = &dqb[j].dd_diskdq;
>  
>  		/*
>  		 * Do a sanity check, and if needed, repair the dqblk. Don't
> @@ -867,9 +867,9 @@ struct xfs_qm_isolate {
>  		 * find uninitialised dquot blks. See comment in
>  		 * xfs_dquot_verify.
>  		 */
> -		fa = xfs_dquot_verify(mp, ddq, id + j, type);
> +		fa = xfs_dquot_verify(mp, &dqb[j], id + j, type);
>  		if (fa)
> -			xfs_dquot_repair(mp, ddq, id + j, type);
> +			xfs_dquot_repair(mp, &dqb[j], id + j, type);
>  
>  		/*
>  		 * Reset type in case we are reusing group quota file for
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
