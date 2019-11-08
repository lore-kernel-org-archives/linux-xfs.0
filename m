Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61B5FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E4A21882
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:13:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n8TEeGkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKHWNy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 17:13:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfKHWNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 17:13:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8M9Qat041229;
        Fri, 8 Nov 2019 22:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Zhk5uHk0yzKzSKw4RbDDFzS35O4YckVmyZC3bjp1G40=;
 b=n8TEeGkrO5o3aFnH2gB1ezXbNHSenc2xMkJujlAdMXx6kAiDwX1LxpY3UYHWVjIoP/oe
 KPH0Ef+HZRX8uXqsL2/Id4UwLijXcvXBFXip3IEw88ec69sXCt3mvf7YuqB6kjXHhjzL
 40GzPXF63DFHQpzwQcMfXaxh5OrJRjbm7Cqb0jtc8mB962ItV43EhD/6ysJq8/7MKDDf
 2HXumAlPstXrsRZ8NItpbWb1/FS/VGyi/bRVHG9THqLYGXdvcu5YwqTcMVeuJoMkIS8w
 pCheeK63+bCzHrzLF6lJ+rjfZ9Htyxq/S1cOSL0aT6WIOX4odo784zvOs6XvUyhzuVol PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w1g0am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:13:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8M9Gof149330;
        Fri, 8 Nov 2019 22:13:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w50m6bgx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:13:40 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8MDdLZ011363;
        Fri, 8 Nov 2019 22:13:39 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 22:13:38 +0000
Date:   Fri, 8 Nov 2019 14:13:37 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
 typedefs
Message-ID: <20191108221337.GK6219@magnolia>
References: <20191108210612.423439-1-preichl@redhat.com>
 <20191108210612.423439-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108210612.423439-2-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080213
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080213
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 10:06:09PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  |  8 ++--
>  fs/xfs/libxfs/xfs_format.h     | 10 ++---
>  fs/xfs/libxfs/xfs_trans_resv.c |  1 -
>  fs/xfs/xfs_dquot.c             | 18 ++++-----
>  fs/xfs/xfs_dquot.h             | 67 +++++++++++++++++-----------------
>  fs/xfs/xfs_log_recover.c       |  5 ++-
>  fs/xfs/xfs_qm.c                | 28 +++++++-------
>  fs/xfs/xfs_qm_bhv.c            |  2 +-
>  fs/xfs/xfs_trans_dquot.c       | 38 +++++++++----------
>  9 files changed, 89 insertions(+), 88 deletions(-)
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
> index bcd4247b5014..5b089afd7087 100644
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
> @@ -113,8 +113,8 @@ xfs_qm_adjust_dqlimits(
>   */
>  void
>  xfs_qm_adjust_dqtimers(
> -	xfs_mount_t		*mp,
> -	xfs_disk_dquot_t	*d)
> +	struct xfs_mount	*mp,
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
> @@ -1019,7 +1019,7 @@ xfs_qm_dqflush_done(
>  	struct xfs_log_item	*lip)
>  {
>  	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
> -	xfs_dquot_t		*dqp = qip->qli_dquot;
> +	struct xfs_dquot	*dqp = qip->qli_dquot;
>  	struct xfs_ail		*ailp = lip->li_ailp;
>  
>  	/*
> @@ -1130,7 +1130,7 @@ xfs_qm_dqflush(
>  	}
>  
>  	/* This is the only portion of data that needs to persist */
> -	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
> +	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
>  
>  	/*
>  	 * Clear the dirty field and remember the flush lsn for later use.
> @@ -1188,8 +1188,8 @@ xfs_qm_dqflush(
>   */
>  void
>  xfs_dqlock2(
> -	xfs_dquot_t	*d1,
> -	xfs_dquot_t	*d2)
> +	struct xfs_dquot	*d1,
> +	struct xfs_dquot	*d2)
>  {
>  	if (d1 && d2) {
>  		ASSERT(d1 != d2);
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 4fe85709d55d..a6bb264d71ce 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -30,33 +30,33 @@ enum {
>  /*
>   * The incore dquot structure
>   */
> -typedef struct xfs_dquot {
> -	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
> -	struct list_head q_lru;		/* global free list of dquots */
> -	struct xfs_mount*q_mount;	/* filesystem this relates to */
> -	uint		 q_nrefs;	/* # active refs from inodes */
> -	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
> -	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
> -	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
> -
> -	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
> -	xfs_dq_logitem_t q_logitem;	/* dquot log item */
> -	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
> -	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
> -	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
> -	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
> -	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
> -	int64_t		 q_low_space[XFS_QLOWSP_MAX];
> -	struct mutex	 q_qlock;	/* quota lock */
> +struct xfs_dquot {
> +	uint		  dq_flags;	/* various flags (XFS_DQ_*) */
> +	struct list_head  q_lru;	/* global free list of dquots */
> +	struct xfs_mount *q_mount;	/* filesystem this relates to */
> +	uint		  q_nrefs;	/* # active refs from inodes */
> +	xfs_daddr_t	  q_blkno;	/* blkno of dquot buffer */
> +	int		  q_bufoffset;	/* off of dq in buffer (# dquots) */
> +	xfs_fileoff_t	  q_fileoffset;	/* offset in quotas file */
> +
> +	struct xfs_disk_dquot	q_core;	/* actual usage & quotas */
> +	xfs_dq_logitem_t  q_logitem;	/* dquot log item */
> +	xfs_qcnt_t	  q_res_bcount;	/* total regular nblks used+reserved */
> +	xfs_qcnt_t	  q_res_icount;	/* total inos allocd+reserved */
> +	xfs_qcnt_t	  q_res_rtbcount;/* total realtime blks used+reserved */
> +	xfs_qcnt_t	  q_prealloc_lo_wmark;/* prealloc throttle wmark */
> +	xfs_qcnt_t	  q_prealloc_hi_wmark;/* prealloc disabled wmark */
> +	int64_t		  q_low_space[XFS_QLOWSP_MAX];
> +	struct mutex	  q_qlock;	/* quota lock */
>  	struct completion q_flush;	/* flush completion queue */
> -	atomic_t          q_pincount;	/* dquot pin count */
> +	atomic_t	  q_pincount;	/* dquot pin count */
>  	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
> -} xfs_dquot_t;
> +};
>  
>  /*
>   * Lock hierarchy for q_qlock:
>   *	XFS_QLOCK_NORMAL is the implicit default,
> - * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
> + *	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
>   */
>  enum {
>  	XFS_QLOCK_NORMAL = 0,
> @@ -68,17 +68,17 @@ enum {
>   * queue synchronizes processes attempting to flush the in-core dquot back to
>   * disk.
>   */
> -static inline void xfs_dqflock(xfs_dquot_t *dqp)
> +static inline void xfs_dqflock(struct xfs_dquot *dqp)
>  {
>  	wait_for_completion(&dqp->q_flush);
>  }
>  
> -static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
> +static inline bool xfs_dqflock_nowait(struct xfs_dquot *dqp)
>  {
>  	return try_wait_for_completion(&dqp->q_flush);
>  }
>  
> -static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
> +static inline void xfs_dqfunlock(struct xfs_dquot *dqp)
>  {
>  	complete(&dqp->q_flush);
>  }
> @@ -112,7 +112,7 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
>  	}
>  }
>  
> -static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
> +static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
>  {
>  	switch (type & XFS_DQ_ALLTYPES) {
>  	case XFS_DQ_USER:
> @@ -147,13 +147,14 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
>  #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
>  #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
>  
> -extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
> -extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
> -extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
> -extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
> -					xfs_disk_dquot_t *);
> -extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
> -					       struct xfs_dquot *);
> +extern void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
> +extern int		xfs_qm_dqflush(struct xfs_dquot *dqp,
> +				       struct xfs_buf **bpp);
> +extern void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
> +extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *mp,
> +					       struct xfs_disk_dquot *d);
> +extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
> +					       struct xfs_dquot *d);
>  extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
>  					uint type);
>  extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
> @@ -167,7 +168,7 @@ extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
>  extern int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
>  					xfs_dqid_t id, uint type,
>  					struct xfs_dquot **dqpp);
> -extern void		xfs_qm_dqput(xfs_dquot_t *);
> +extern void		xfs_qm_dqput(struct xfs_dquot *dqp);
>  
>  extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 648d5ecafd91..16a44e821b71 100644
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
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 66ea8e4fca86..c11b3b1af8e9 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -244,14 +244,14 @@ xfs_qm_unmount_quotas(
>  
>  STATIC int
>  xfs_qm_dqattach_one(
> -	xfs_inode_t	*ip,
> -	xfs_dqid_t	id,
> -	uint		type,
> -	bool		doalloc,
> -	xfs_dquot_t	**IO_idqpp)
> +	xfs_inode_t		*ip,

Please de-typedef /all/ the parameters in /all/ of the structure
definitions, function declarations, function definitions, and local
variable definition clusters you touch.

Sorry, I should've mentioned that explicitly when reviewing the v1
patchset.  I forgot that unwritten convention isn't universally known.
:/

--D

> +	xfs_dqid_t		id,
> +	uint			type,
> +	bool			doalloc,
> +	struct xfs_dquot	**IO_idqpp)
>  {
> -	xfs_dquot_t	*dqp;
> -	int		error;
> +	struct xfs_dquot	*dqp;
> +	int			error;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	error = 0;
> @@ -544,7 +544,7 @@ xfs_qm_set_defquota(
>  	uint		type,
>  	xfs_quotainfo_t	*qinf)
>  {
> -	xfs_dquot_t		*dqp;
> +	struct xfs_dquot	*dqp;
>  	struct xfs_def_quota    *defq;
>  	struct xfs_disk_dquot	*ddqp;
>  	int			error;
> @@ -1746,14 +1746,14 @@ xfs_qm_vop_dqalloc(
>   * Actually transfer ownership, and do dquot modifications.
>   * These were already reserved.
>   */
> -xfs_dquot_t *
> +struct xfs_dquot *
>  xfs_qm_vop_chown(
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*ip,
> -	xfs_dquot_t	**IO_olddq,
> -	xfs_dquot_t	*newdq)
> +	xfs_trans_t		*tp,
> +	xfs_inode_t		*ip,
> +	struct xfs_dquot	**IO_olddq,
> +	struct xfs_dquot	*newdq)
>  {
> -	xfs_dquot_t	*prevdq;
> +	struct xfs_dquot	*prevdq;
>  	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
>  				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
>  
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 5d72e88598b4..1830f52d5975 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -58,7 +58,7 @@ xfs_qm_statvfs(
>  	struct kstatfs		*statp)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
> -	xfs_dquot_t		*dqp;
> +	struct xfs_dquot	*dqp;
>  
>  	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
>  		xfs_fill_statvfs_from_dquot(statp, dqp);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 16457465833b..ceb25d1cfdb1 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -25,8 +25,8 @@ STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
>   */
>  void
>  xfs_trans_dqjoin(
> -	xfs_trans_t	*tp,
> -	xfs_dquot_t	*dqp)
> +	xfs_trans_t		*tp,
> +	struct xfs_dquot	*dqp)
>  {
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  	ASSERT(dqp->q_logitem.qli_dquot == dqp);
> @@ -49,8 +49,8 @@ xfs_trans_dqjoin(
>   */
>  void
>  xfs_trans_log_dquot(
> -	xfs_trans_t	*tp,
> -	xfs_dquot_t	*dqp)
> +	xfs_trans_t		*tp,
> +	struct xfs_dquot	*dqp)
>  {
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  
> @@ -489,7 +489,7 @@ xfs_trans_unreserve_and_mod_dquots(
>  	xfs_trans_t		*tp)
>  {
>  	int			i, j;
> -	xfs_dquot_t		*dqp;
> +	struct xfs_dquot	*dqp;
>  	struct xfs_dqtrx	*qtrx, *qa;
>  	bool                    locked;
>  
> @@ -571,21 +571,21 @@ xfs_quota_warn(
>   */
>  STATIC int
>  xfs_trans_dqresv(
> -	xfs_trans_t	*tp,
> -	xfs_mount_t	*mp,
> -	xfs_dquot_t	*dqp,
> -	int64_t		nblks,
> -	long		ninos,
> -	uint		flags)
> +	xfs_trans_t		*tp,
> +	xfs_mount_t		*mp,
> +	struct xfs_dquot	*dqp,
> +	int64_t			nblks,
> +	long			ninos,
> +	uint			flags)
>  {
> -	xfs_qcnt_t	hardlimit;
> -	xfs_qcnt_t	softlimit;
> -	time_t		timer;
> -	xfs_qwarncnt_t	warns;
> -	xfs_qwarncnt_t	warnlimit;
> -	xfs_qcnt_t	total_count;
> -	xfs_qcnt_t	*resbcountp;
> -	xfs_quotainfo_t	*q = mp->m_quotainfo;
> +	xfs_qcnt_t		hardlimit;
> +	xfs_qcnt_t		softlimit;
> +	time_t			timer;
> +	xfs_qwarncnt_t		warns;
> +	xfs_qwarncnt_t		warnlimit;
> +	xfs_qcnt_t		total_count;
> +	xfs_qcnt_t		*resbcountp;
> +	xfs_quotainfo_t		*q = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
>  
>  
> -- 
> 2.23.0
> 
