Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70747C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32EBD246AE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 14:06:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XCbn6sUj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgB1OGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 09:06:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41659 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727053AbgB1OGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 09:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582898792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yrSHP5xvftR2ZsWgAS5GecH8jjqfkywT3xNwE20QTsc=;
        b=XCbn6sUjp6oPrknK354AmDJ4lDEt6NT6ZHU5KFjDSc47E6S9HcvKceVEaRC/JC+PTacGUx
        UuAhvZC703eLFEOE1T0IaIzvupVDG57i/4k+wrcdUTPpJLzxjijvK8arX9YHVov4A9u0kO
        pu/USKR5csZNr1X8uIYsT/8QE2je8SA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-9lJycZ81PVqOnUiJa-r06Q-1; Fri, 28 Feb 2020 09:06:30 -0500
X-MC-Unique: 9lJycZ81PVqOnUiJa-r06Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0FC6107ACC9;
        Fri, 28 Feb 2020 14:06:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9299D60C63;
        Fri, 28 Feb 2020 14:06:28 +0000 (UTC)
Date:   Fri, 28 Feb 2020 09:06:26 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 9/9] xfs: relog random buffers based on errortag
Message-ID: <20200228140626.GH2751@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-10-bfoster@redhat.com>
 <677810e5-2e4f-66a0-5f20-51c14fabfcc4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <677810e5-2e4f-66a0-5f20-51c14fabfcc4@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 04:48:59PM -0700, Allison Collins wrote:
> 
> 
> On 2/27/20 6:43 AM, Brian Foster wrote:
> > Since there is currently no specific use case for buffer relogging,
> > add some hacky and experimental code to relog random buffers when
> > the associated errortag is enabled. Update the relog reservation
> > calculation appropriately and use fixed termination logic to help
> > ensure that the relog queue doesn't grow indefinitely.
> > 
> > Note that this patch was useful in causing log reservation deadlocks
> > on an fsstress workload if the relog mechanism code is modified to
> > acquire its own log reservation rather than rely on the relog
> > pre-reservation mechanism. In other words, this helps prove that the
> > relog reservation management code effectively avoids log reservation
> > deadlocks.
> > 
> 
> Oh i see, so the last three are sort of an internal test case.  They look
> like they are good sand box tools for testing though.  I guess they dont
> really get RVBs since they dont apply?  Otherwise looks good for the purpose
> they are meant for.  :-)
> 

Right. I'm actually not opposed to polishing up the buffer relogging
code and packaging it with an fstest that invokes the errortag, but the
original intent is for these to stay RFC and drop off the series. I have
already cleaned up some of the code to use a new ->iop_relog() callback
and also have a patch to use buffer relogging as a solution for an
already fixed xattr buffer write verifier failure bug caused by
premature writeback. That use case is contrived (aside from being
already fixed), however, so by itself doesn't justify inclusion of the
buffer bits. I think it's more of a question of if anybody looks at this
patch and can think of any reasonable future use case ideas. If so, it
might be worth retaining and working out any kinks..

Brian

> Allison
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   fs/xfs/libxfs/xfs_trans_resv.c |  8 +++++++-
> >   fs/xfs/xfs_trans.h             |  4 +++-
> >   fs/xfs/xfs_trans_ail.c         | 11 +++++++++++
> >   fs/xfs/xfs_trans_buf.c         | 13 +++++++++++++
> >   4 files changed, 34 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index f49b20c9ca33..59a328a0dec6 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -840,7 +840,13 @@ STATIC uint
> >   xfs_calc_relog_reservation(
> >   	struct xfs_mount	*mp)
> >   {
> > -	return xfs_calc_qm_quotaoff_reservation(mp);
> > +	uint			res;
> > +
> > +	res = xfs_calc_qm_quotaoff_reservation(mp);
> > +#ifdef DEBUG
> > +	res = max(res, xfs_calc_buf_res(4, XFS_FSB_TO_B(mp, 1)));
> > +#endif
> > +	return res;
> >   }
> >   void
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 81cb42f552d9..1783441f6d03 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -61,6 +61,7 @@ struct xfs_log_item {
> >   #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
> >   #define	XFS_LI_RELOG	4	/* automatically relog item */
> >   #define	XFS_LI_RELOGGED	5	/* item relogged (not committed) */
> > +#define	XFS_LI_RELOG_RAND 6
> >   #define XFS_LI_FLAGS \
> >   	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
> > @@ -68,7 +69,8 @@ struct xfs_log_item {
> >   	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
> >   	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
> >   	{ (1 << XFS_LI_RELOG),		"RELOG" }, \
> > -	{ (1 << XFS_LI_RELOGGED),	"RELOGGED" }
> > +	{ (1 << XFS_LI_RELOGGED),	"RELOGGED" }, \
> > +	{ (1 << XFS_LI_RELOG_RAND),	"RELOG_RAND" }
> >   struct xfs_item_ops {
> >   	unsigned flags;
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 103ab62e61be..9b1d7c8df6d8 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -188,6 +188,17 @@ xfs_ail_relog(
> >   			xfs_log_ticket_put(ailp->ail_relog_tic);
> >   		spin_unlock(&ailp->ail_lock);
> > +		/*
> > +		 * Terminate random/debug relogs at a fixed, aggressive rate to
> > +		 * avoid building up too much relog activity.
> > +		 */
> > +		if (test_bit(XFS_LI_RELOG_RAND, &lip->li_flags) &&
> > +		    ((prandom_u32() & 1) ||
> > +		     (mp->m_flags & XFS_MOUNT_UNMOUNTING))) {
> > +			clear_bit(XFS_LI_RELOG_RAND, &lip->li_flags);
> > +			xfs_trans_relog_item_cancel(lip, false);
> > +		}
> > +
> >   		/*
> >   		 * TODO: Ideally, relog transaction management would be pushed
> >   		 * down into the ->iop_push() callbacks rather than playing
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index e17715ac23fc..de7b9a68fe38 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -14,6 +14,8 @@
> >   #include "xfs_buf_item.h"
> >   #include "xfs_trans_priv.h"
> >   #include "xfs_trace.h"
> > +#include "xfs_error.h"
> > +#include "xfs_errortag.h"
> >   /*
> >    * Check to see if a buffer matching the given parameters is already
> > @@ -527,6 +529,17 @@ xfs_trans_log_buf(
> >   	trace_xfs_trans_log_buf(bip);
> >   	xfs_buf_item_log(bip, first, last);
> > +
> > +	/*
> > +	 * Relog random buffers so long as the transaction is relog enabled and
> > +	 * the buffer wasn't already relogged explicitly.
> > +	 */
> > +	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_RELOG) &&
> > +	    (tp->t_flags & XFS_TRANS_RELOG) &&
> > +	    !test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags)) {
> > +		if (xfs_trans_relog_buf(tp, bp))
> > +			set_bit(XFS_LI_RELOG_RAND, &bip->bli_item.li_flags);
> > +	}
> >   }
> > 
> 

