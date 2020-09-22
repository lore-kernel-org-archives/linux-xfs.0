Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048C5C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B44452388B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OPHcCtCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgIVPnf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:43:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgIVPne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 11:43:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFXOxg163819;
        Tue, 22 Sep 2020 15:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iaWTdHY3G6KxRZyJwpe2nIjhMIsv+Ym/i/0chr9ZxYI=;
 b=OPHcCtCc9QSs6hLt8Xp4vcXSvJGr8t2YVN9+7PpinzjALNM/K3+VueVX7wHIc62UNHoe
 Bch4Vwt7vV29m7Zf5uli4w0UmkpB/mrOCNCmRbvxmQEH3E8TZ22oPAncyYqFAz3t5Ll2
 iuuPJsRWFh4hrYgpflV0/FO23fyjpXDNRSYhTQdluA+bThwi1kzi+2Oe2ErolgnoyH6L
 WBrORoToBI36zUrvdOnlztImWTERDBvF0J60lDdjIY4uNPMStPMkN8GdWDwXvqx5BuTG
 /5u2xtWw7vJ4spGRBg0QyJDR/sDQZohihsOJjZAW4H2Bpd0Su3QBhULTlmozJmhvVEuO zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rgbwvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 15:43:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MFURBs053921;
        Tue, 22 Sep 2020 15:43:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nurt4dqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 15:43:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08MFhQkl024987;
        Tue, 22 Sep 2020 15:43:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 08:43:26 -0700
Date:   Tue, 22 Sep 2020 08:43:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2.2 2/2] xfs: periodically relog deferred intent items
Message-ID: <20200922154326.GE7955@magnolia>
References: <160039574052.20335.5971639583254011729.stgit@magnolia>
 <160039575350.20335.983504069788744026.stgit@magnolia>
 <20200922035230.GD7955@magnolia>
 <20200922141746.GA2175303@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922141746.GA2175303@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 10:17:46AM -0400, Brian Foster wrote:
> On Mon, Sep 21, 2020 at 08:52:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a subtle design flaw in the deferred log item code that can lead
> > to pinning the log tail.  Taking up the defer ops chain examples from
> > the previous commit, we can get trapped in sequences like this:
> > 
> > Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
> > chain will look like the following if the transaction rolls succeed:
> > 
> > t1: D0(t0), D1(t0), D2(t0), D3(t0)
> > t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> > t3: d5(t1), D1(t0), D2(t0), D3(t0)
> > ...
> > t9: d9(t7), D3(t0)
> > t10: D3(t0)
> > t11: d10(t10), d11(t10)
> > t12: d11(t10)
> > 
> > In transaction 9, we finish d9 and try to roll to t10 while holding onto
> > an intent item for D3 that we logged in t0.
> > 
> > The previous commit changed the order in which we place new defer ops in
> > the defer ops processing chain to reduce the maximum chain length.  Now
> > make xfs_defer_finish_noroll capable of relogging the entire chain
> > periodically so that we can always move the log tail forward.  We do
> > this every seven loops, having observed that while most chains never
> > exceed seven items in length, the rest go far over that and seem to
> > be involved in most of the stall problems.
> > 
> > Callers are now required to ensure that the transaction reservation is
> > large enough to handle logging done items and new intent items for the
> > maximum possible chain length.  Most callers are careful to keep the
> > chain lengths low, so the overhead should be minimal.
> > 
> > The decision to relog an intent item is made based on whether or not the
> > intent was added to the current checkpoint.  If so, the checkpoint is
> > still open and there's no point in relogging.  Otherwise, the old
> > checkpoint is closed and we relog the intent to add it to the current
> > one.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: combine /all/ the predicate functions into the relogging patch
> > ---
> 
> Looks like there's still some unaccounted for feedback from the last
> variant that included the lsn logic:

DOH.  I missed some of that, sorry.  I'll go back and reply to that
message.

--D

> https://lore.kernel.org/linux-xfs/20200917152829.GC1874815@bfoster/
> 
> Brian
> 
> >  fs/xfs/libxfs/xfs_defer.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++
> >  fs/xfs/xfs_log.c           |   41 ++++++++++++++++++++++++++---------
> >  fs/xfs/xfs_log.h           |    2 ++
> >  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_trace.h         |    1 +
> >  fs/xfs/xfs_trans.h         |   10 ++++++++
> >  9 files changed, 206 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 84a70edd0da1..a6f57a918992 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -17,6 +17,7 @@
> >  #include "xfs_inode_item.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> > +#include "xfs_log.h"
> >  
> >  /*
> >   * Deferred Operations in XFS
> > @@ -361,6 +362,52 @@ xfs_defer_cancel_list(
> >  	}
> >  }
> >  
> > +/*
> > + * Prevent a log intent item from pinning the tail of the log by logging a
> > + * done item to release the intent item; and then log a new intent item.
> > + * The caller should provide a fresh transaction and roll it after we're done.
> > + */
> > +static int
> > +xfs_defer_relog(
> > +	struct xfs_trans		**tpp,
> > +	struct list_head		*dfops)
> > +{
> > +	struct xfs_defer_pending	*dfp;
> > +	xfs_lsn_t			threshold_lsn;
> > +
> > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +
> > +	/*
> > +	 * Figure out where we need the tail to be in order to maintain the
> > +	 * minimum required free space in the log.
> > +	 */
> > +	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
> > +	if (threshold_lsn == NULLCOMMITLSN)
> > +		return 0;
> > +
> > +	list_for_each_entry(dfp, dfops, dfp_list) {
> > +		/*
> > +		 * If the log intent item for this deferred op is behind the
> > +		 * desired log tail threshold and is not a part of the current
> > +		 * log checkpoint, relog the intent item to keep the log tail
> > +		 * moving forward.  We're ok with this being racy because an
> > +		 * incorrect decision means we'll be a little slower at pushing
> > +		 * the tail.
> > +		 */
> > +		if (dfp->dfp_intent == NULL ||
> > +		    XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) < 0 ||
> > +		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
> > +			continue;
> > +
> > +		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
> > +		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
> > +	}
> > +
> > +	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
> > +		return xfs_defer_trans_roll(tpp);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Log an intent-done item for the first pending intent, and finish the work
> >   * items.
> > @@ -447,6 +494,11 @@ xfs_defer_finish_noroll(
> >  		if (error)
> >  			goto out_shutdown;
> >  
> > +		/* Every few rolls we relog all the intent items. */
> > +		error = xfs_defer_relog(tp, &dop_pending);
> > +		if (error)
> > +			goto out_shutdown;
> > +
> >  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
> >  				       dfp_list);
> >  		error = xfs_defer_finish_one(*tp, dfp);
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 008436ef5bce..6317fdf4a3a0 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -532,6 +532,32 @@ xfs_bui_item_match(
> >  	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_bui_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_bud_log_item		*budp;
> > +	struct xfs_bui_log_item		*buip;
> > +	struct xfs_map_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = BUI_ITEM(intent)->bui_format.bui_nextents;
> > +	extp = BUI_ITEM(intent)->bui_format.bui_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
> > +	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
> > +
> > +	buip = xfs_bui_init(tp->t_mountp);
> > +	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&buip->bui_next_extent, count);
> > +	xfs_trans_add_item(tp, &buip->bui_item);
> > +	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
> > +	return &buip->bui_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_bui_item_ops = {
> >  	.iop_size	= xfs_bui_item_size,
> >  	.iop_format	= xfs_bui_item_format,
> > @@ -539,6 +565,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
> >  	.iop_release	= xfs_bui_item_release,
> >  	.iop_recover	= xfs_bui_item_recover,
> >  	.iop_match	= xfs_bui_item_match,
> > +	.iop_relog	= xfs_bui_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index 337fae015bca..30a53f3913d1 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -642,6 +642,34 @@ xfs_efi_item_match(
> >  	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_efi_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_efd_log_item		*efdp;
> > +	struct xfs_efi_log_item		*efip;
> > +	struct xfs_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = EFI_ITEM(intent)->efi_format.efi_nextents;
> > +	extp = EFI_ITEM(intent)->efi_format.efi_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
> > +	efdp->efd_next_extent = count;
> > +	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
> > +	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
> > +
> > +	efip = xfs_efi_init(tp->t_mountp, count);
> > +	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&efip->efi_next_extent, count);
> > +	xfs_trans_add_item(tp, &efip->efi_item);
> > +	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
> > +	return &efip->efi_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_efi_item_ops = {
> >  	.iop_size	= xfs_efi_item_size,
> >  	.iop_format	= xfs_efi_item_format,
> > @@ -649,6 +677,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
> >  	.iop_release	= xfs_efi_item_release,
> >  	.iop_recover	= xfs_efi_item_recover,
> >  	.iop_match	= xfs_efi_item_match,
> > +	.iop_relog	= xfs_efi_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index ad0c69ee8947..62c9e0aaa7df 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1475,14 +1475,15 @@ xlog_commit_record(
> >  }
> >  
> >  /*
> > - * Push on the buffer cache code if we ever use more than 75% of the on-disk
> > - * log space.  This code pushes on the lsn which would supposedly free up
> > - * the 25% which we want to leave free.  We may need to adopt a policy which
> > - * pushes on an lsn which is further along in the log once we reach the high
> > - * water mark.  In this manner, we would be creating a low water mark.
> > + * Compute the LSN push target needed to push on the buffer cache code if we
> > + * ever use more than 75% of the on-disk log space.  This code pushes on the
> > + * lsn which would supposedly free up the 25% which we want to leave free.  We
> > + * may need to adopt a policy which pushes on an lsn which is further along in
> > + * the log once we reach the high water mark.  In this manner, we would be
> > + * creating a low water mark.
> >   */
> > -STATIC void
> > -xlog_grant_push_ail(
> > +xfs_lsn_t
> > +xlog_grant_push_threshold(
> >  	struct xlog	*log,
> >  	int		need_bytes)
> >  {
> > @@ -1508,7 +1509,7 @@ xlog_grant_push_ail(
> >  	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
> >  	free_threshold = max(free_threshold, 256);
> >  	if (free_blocks >= free_threshold)
> > -		return;
> > +		return NULLCOMMITLSN;
> >  
> >  	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
> >  						&threshold_block);
> > @@ -1528,13 +1529,33 @@ xlog_grant_push_ail(
> >  	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
> >  		threshold_lsn = last_sync_lsn;
> >  
> > +	return threshold_lsn;
> > +}
> > +
> > +/*
> > + * Push on the buffer cache code if we ever use more than 75% of the on-disk
> > + * log space.  This code pushes on the lsn which would supposedly free up
> > + * the 25% which we want to leave free.  We may need to adopt a policy which
> > + * pushes on an lsn which is further along in the log once we reach the high
> > + * water mark.  In this manner, we would be creating a low water mark.
> > + */
> > +STATIC void
> > +xlog_grant_push_ail(
> > +	struct xlog	*log,
> > +	int		need_bytes)
> > +{
> > +	xfs_lsn_t	threshold_lsn;
> > +
> > +	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
> > +	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
> > +		return;
> > +
> >  	/*
> >  	 * Get the transaction layer to kick the dirty buffers out to
> >  	 * disk asynchronously. No point in trying to do this if
> >  	 * the filesystem is shutting down.
> >  	 */
> > -	if (!XLOG_FORCED_SHUTDOWN(log))
> > -		xfs_ail_push(log->l_ailp, threshold_lsn);
> > +	xfs_ail_push(log->l_ailp, threshold_lsn);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > index 1412d6993f1e..58c3fcbec94a 100644
> > --- a/fs/xfs/xfs_log.h
> > +++ b/fs/xfs/xfs_log.h
> > @@ -141,4 +141,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
> >  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> >  bool	xfs_log_in_recovery(struct xfs_mount *);
> >  
> > +xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
> > +
> >  #endif	/* __XFS_LOG_H__ */
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index c78412755b8a..cf0205fdc607 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -560,6 +560,32 @@ xfs_cui_item_match(
> >  	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_cui_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_cud_log_item		*cudp;
> > +	struct xfs_cui_log_item		*cuip;
> > +	struct xfs_phys_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = CUI_ITEM(intent)->cui_format.cui_nextents;
> > +	extp = CUI_ITEM(intent)->cui_format.cui_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
> > +	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
> > +
> > +	cuip = xfs_cui_init(tp->t_mountp, count);
> > +	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&cuip->cui_next_extent, count);
> > +	xfs_trans_add_item(tp, &cuip->cui_item);
> > +	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
> > +	return &cuip->cui_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_cui_item_ops = {
> >  	.iop_size	= xfs_cui_item_size,
> >  	.iop_format	= xfs_cui_item_format,
> > @@ -567,6 +593,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
> >  	.iop_release	= xfs_cui_item_release,
> >  	.iop_recover	= xfs_cui_item_recover,
> >  	.iop_match	= xfs_cui_item_match,
> > +	.iop_relog	= xfs_cui_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index c1a1fd62ca74..3237243d375d 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -583,6 +583,32 @@ xfs_rui_item_match(
> >  	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_rui_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_rud_log_item		*rudp;
> > +	struct xfs_rui_log_item		*ruip;
> > +	struct xfs_map_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = RUI_ITEM(intent)->rui_format.rui_nextents;
> > +	extp = RUI_ITEM(intent)->rui_format.rui_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
> > +	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
> > +
> > +	ruip = xfs_rui_init(tp->t_mountp, count);
> > +	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&ruip->rui_next_extent, count);
> > +	xfs_trans_add_item(tp, &ruip->rui_item);
> > +	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
> > +	return &ruip->rui_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_rui_item_ops = {
> >  	.iop_size	= xfs_rui_item_size,
> >  	.iop_format	= xfs_rui_item_format,
> > @@ -590,6 +616,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
> >  	.iop_release	= xfs_rui_item_release,
> >  	.iop_recover	= xfs_rui_item_recover,
> >  	.iop_match	= xfs_rui_item_match,
> > +	.iop_relog	= xfs_rui_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index a3a35a2d8ed9..362c155be525 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -2533,6 +2533,7 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_create_intent);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
> > +DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
> >  
> >  #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
> >  DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 995c1513693c..e838e8327510 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -78,6 +78,8 @@ struct xfs_item_ops {
> >  	int (*iop_recover)(struct xfs_log_item *lip,
> >  			   struct xfs_defer_capture **dfcp);
> >  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
> > +	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
> > +			struct xfs_trans *tp);
> >  };
> >  
> >  /*
> > @@ -239,4 +241,12 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
> >  
> >  extern kmem_zone_t	*xfs_trans_zone;
> >  
> > +static inline struct xfs_log_item *
> > +xfs_trans_item_relog(
> > +	struct xfs_log_item	*lip,
> > +	struct xfs_trans	*tp)
> > +{
> > +	return lip->li_ops->iop_relog(lip, tp);
> > +}
> > +
> >  #endif	/* __XFS_TRANS_H__ */
> > 
> 
