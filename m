Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AE0C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B5220869
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FW2jiXdG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfKGWCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:02:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGWCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 17:02:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7LxRWM053840;
        Thu, 7 Nov 2019 22:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EiAf6I33wgs3P9cKD8sGdqayAspx03LvQd/NMukT8G0=;
 b=FW2jiXdGcNPcDSstFDCx65Dz+S8KSgZ4gg1iW7Qep6KMBxJxsPzKbKzukQAtZKfeDh8I
 Z4zIrrBu/x5nsN9d1WfzycPg3PPY5vkALektRv8WjclnB4Jdr4F1svck4r4GPhU/ecTz
 Hb/395c/Pp2ea7Dg+rV12+kl8AXfeMzfG77NfkfnnU+nhH5WsJdxL+YSm3jDUzHYTPtS
 9B1KyE72oI622tetCyYZIkXY92lse3vzkF4cRHKKyGrfDpWPfaVkdCvVyky0vwxXA5zV
 JRWGoka6J0KR2idh+bg41KtzA5LJxph5DqiBZQ0dF0b/sL6aABEgLJVAOJG2aTOS+LOv OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w19b5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:02:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7LxP2M132259;
        Thu, 7 Nov 2019 22:02:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w41wja6u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:02:32 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA7M2V58019815;
        Thu, 7 Nov 2019 22:02:32 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 14:02:31 -0800
Date:   Thu, 7 Nov 2019 14:02:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: remove the xfs_disk_dquot_t typedef
Message-ID: <20191107220230.GH6219@magnolia>
References: <20191107113549.110129-1-preichl@redhat.com>
 <20191107113549.110129-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107113549.110129-2-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 12:35:45PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  |  8 ++++----
>  fs/xfs/libxfs/xfs_format.h     | 10 +++++-----
>  fs/xfs/libxfs/xfs_trans_resv.c |  1 -
>  fs/xfs/xfs_dquot.c             | 10 +++++-----
>  fs/xfs/xfs_dquot.h             |  8 ++++----
>  fs/xfs/xfs_log_recover.c       |  5 +++--
>  6 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index e8bd688a4073..67baed82f6a3 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -35,10 +35,10 @@ xfs_calc_dquots_per_chunk(
>  
>  xfs_failaddr_t
>  xfs_dquot_verify(
> -	struct xfs_mount *mp,
> -	xfs_disk_dquot_t *ddq,
> -	xfs_dqid_t	 id,
> -	uint		 type)	  /* used only during quotacheck */
> +	struct xfs_mount	*mp,
> +	struct xfs_disk_dquot	*ddq,
> +	xfs_dqid_t		id,
> +	uint			type)	  /* used only during quotacheck */
>  {
>  	/*
>  	 * We can encounter an uninitialized dquot buffer for 2 reasons:
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index c968b60cee15..4cae17f35e94 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1144,11 +1144,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  
>  /*
>   * This is the main portion of the on-disk representation of quota
> - * information for a user. This is the q_core of the xfs_dquot_t that
> + * information for a user. This is the q_core of the struct xfs_dquot that
>   * is kept in kernel memory. We pad this with some more expansion room
>   * to construct the on disk structure.
>   */
> -typedef struct	xfs_disk_dquot {
> +struct xfs_disk_dquot {
>  	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
>  	__u8		d_version;	/* dquot version */
>  	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
> @@ -1171,15 +1171,15 @@ typedef struct	xfs_disk_dquot {
>  	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
>  	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
>  	__be16		d_pad;
> -} xfs_disk_dquot_t;
> +};
>  
>  /*
>   * This is what goes on disk. This is separated from the xfs_disk_dquot because
>   * carrying the unnecessary padding would be a waste of memory.
>   */
>  typedef struct xfs_dqblk {
> -	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
> -	char		  dd_fill[4];	/* filling for posterity */
> +	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
> +	char			dd_fill[4];/* filling for posterity */
>  
>  	/*
>  	 * These two are only present on filesystems with the CRC bits set.
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index d12bbd526e7c..271cca13565b 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -718,7 +718,6 @@ xfs_calc_clear_agi_bucket_reservation(
>  
>  /*
>   * Adjusting quota limits.
> - *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
>   */
>  STATIC uint
>  xfs_calc_qm_setqlim_reservation(void)
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index bcd4247b5014..edf0e81b3a10 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -48,7 +48,7 @@ static struct lock_class_key xfs_dquot_project_class;
>   */
>  void
>  xfs_qm_dqdestroy(
> -	xfs_dquot_t	*dqp)
> +	struct xfs_dquot	*dqp)
>  {
>  	ASSERT(list_empty(&dqp->q_lru));
>  
> @@ -114,7 +114,7 @@ xfs_qm_adjust_dqlimits(
>  void
>  xfs_qm_adjust_dqtimers(
>  	xfs_mount_t		*mp,

So long as you're changing the parameter list, could you please
de-typedef the other parameters too?  e.g.

	struct xfs_mount	*mp,

Our general practice is to clean out all the struct typedefs any time we
touch a clumb of variable declarations or parameters.

(Earlier I was thinking that I might let that slide on the off chance you
were going to follow this up with more struct-typedef removal patches
but then realized there are 119 typedefs even after this series, and
that's too painful to do all at once. :)

> -	xfs_disk_dquot_t	*d)
> +	struct xfs_disk_dquot	*d)
>  {
>  	ASSERT(d->d_id);
>  
> @@ -497,7 +497,7 @@ xfs_dquot_from_disk(
>  	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
>  
>  	/* copy everything from disk dquot to the incore dquot */
> -	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
> +	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
>  
>  	/*
>  	 * Reservation counters are defined as reservation plus current usage
> @@ -989,7 +989,7 @@ xfs_qm_dqput(
>   */
>  void
>  xfs_qm_dqrele(
> -	xfs_dquot_t	*dqp)
> +	struct xfs_dquot	*dqp)
>  {
>  	if (!dqp)
>  		return;
> @@ -1130,7 +1130,7 @@ xfs_qm_dqflush(
>  	}
>  
>  	/* This is the only portion of data that needs to persist */
> -	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
> +	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
>  
>  	/*
>  	 * Clear the dirty field and remember the flush lsn for later use.
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 4fe85709d55d..7a580dd09a76 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -39,7 +39,7 @@ typedef struct xfs_dquot {
>  	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
>  	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
>  
> -	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
> +	struct xfs_disk_dquot	q_core;	/* actual usage & quotas */
>  	xfs_dq_logitem_t q_logitem;	/* dquot log item */
>  	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
>  	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
> @@ -49,14 +49,14 @@ typedef struct xfs_dquot {
>  	int64_t		 q_low_space[XFS_QLOWSP_MAX];
>  	struct mutex	 q_qlock;	/* quota lock */
>  	struct completion q_flush;	/* flush completion queue */
> -	atomic_t          q_pincount;	/* dquot pin count */
> +	atomic_t	  q_pincount;	/* dquot pin count */

If you're going to fix the indentation of the other fields, please fix
everything to line up again.  (Or leave the other fields alone...)

The rest looks ok though. :)

--D

>  	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
>  } xfs_dquot_t;
>  
>  /*
>   * Lock hierarchy for q_qlock:
>   *	XFS_QLOCK_NORMAL is the implicit default,
> - * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
> + *	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
>   */
>  enum {
>  	XFS_QLOCK_NORMAL = 0,
> @@ -151,7 +151,7 @@ extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
>  extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
>  extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
>  extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
> -					xfs_disk_dquot_t *);
> +					struct xfs_disk_dquot *);
>  extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
>  					       struct xfs_dquot *);
>  extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index c1a514ffff55..afb0ec772bdd 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2576,6 +2576,7 @@ xlog_recover_do_reg_buffer(
>  	int			bit;
>  	int			nbits;
>  	xfs_failaddr_t		fa;
> +	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
>  
>  	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
>  
> @@ -2618,7 +2619,7 @@ xlog_recover_do_reg_buffer(
>  					"XFS: NULL dquot in %s.", __func__);
>  				goto next;
>  			}
> -			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
> +			if (item->ri_buf[i].i_len < size_disk_dquot) {
>  				xfs_alert(mp,
>  					"XFS: dquot too small (%d) in %s.",
>  					item->ri_buf[i].i_len, __func__);
> @@ -3249,7 +3250,7 @@ xlog_recover_dquot_pass2(
>  		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
>  		return -EIO;
>  	}
> -	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
> +	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
>  		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
>  			item->ri_buf[1].i_len, __func__);
>  		return -EIO;
> -- 
> 2.23.0
> 
