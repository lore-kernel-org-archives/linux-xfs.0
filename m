Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD023C4727D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 23:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E9420878
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 23:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sr/VsPEs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgIYXvO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 19:51:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgIYXvN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 19:51:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PJ4qXb016501;
        Fri, 25 Sep 2020 19:08:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VYHyX7U/mqiMBBMEKbLMARuIgJ/vO/E2o11wmu54dYo=;
 b=Sr/VsPEs1W9gLGKpUoabBybfgdE/yVJvcJl475+Aclfxhay6fJ7H39DlfyAWbhHd8I2J
 76xbx8kDTeLrL8e/hASTOHmw8BXngIqkUYsb0yEaFAjUhYLEVpQ47gEG944N0Wrqy8BJ
 E1JQ4nu7aQdz1GGG/TS16M7bE1CVi33ld0M90TjOsbVYQ7RKrk6n2Nw9tzMhNWHqu0nQ
 vsMTNS2cxhGwQeln5OvdydA1yuGD2auPgki4gWum8Tn/ahNQzEq+9KguGChO3pDGS6mQ
 /1mEkFB7CsY0W5xP09MathmcfpYZzSTiB1zoz1IxUdqLnWHTRotk44EBlREyWLRTKeOM 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33ndnuycn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 19:08:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PJ4XPG045952;
        Fri, 25 Sep 2020 19:06:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33nury64y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 19:06:46 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08PJ6iAc014723;
        Fri, 25 Sep 2020 19:06:44 GMT
Received: from localhost (/10.159.232.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 12:06:43 -0700
Date:   Fri, 25 Sep 2020 12:06:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: periodically relog deferred intent items
Message-ID: <20200925190643.GN7964@magnolia>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919968.1401135.1020138085396332868.stgit@magnolia>
 <20200925111540.GB2646051@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925111540.GB2646051@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=5
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=5 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009250132
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 25, 2020 at 07:15:40AM -0400, Brian Foster wrote:
> On Tue, Sep 22, 2020 at 10:33:19PM -0700, Darrick J. Wong wrote:
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
> > periodically so that we can always move the log tail forward.  Most
> > chains will never get relogged, except for operations that generate very
> > long chains (large extents containing many blocks with different sharing
> > levels) or are on filesystems with small logs and a lot of ongoing
> > metadata updates.
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
> 
> Looks like this last bit needs to be updated.

Yep.  The next version will replace that paragraph with the following:

"The decision to relog an intent item is made based on two factors: (a)
whether the intent was logged in a previous checkpoint, and (b) if the
log has hit the 75% full threshold.  There's no point in relogging an
intent into the same checkpoint, and there's no need to relog if there's
plenty of free space in the log."

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++
> >  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++
> >  fs/xfs/xfs_trace.h         |    1 +
> >  fs/xfs/xfs_trans.h         |   10 ++++++++
> >  7 files changed, 173 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 84a70edd0da1..c601cc2af254 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> ...
> > @@ -447,6 +494,11 @@ xfs_defer_finish_noroll(
> >  		if (error)
> >  			goto out_shutdown;
> >  
> > +		/* Every few rolls we relog all the intent items. */
> 
> Stale comment?

Yes.  Change that to:

/* Possibly relog intent items to keep the log tail moving. */

> Those nits aside:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

--D

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
