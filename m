Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73C9C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 16:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8845323A24
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 16:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhAHQ6o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 11:58:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbhAHQ6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 11:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610125037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qo8YyW8jXiDUWwqlQMF4PB6SO2KGvMpHDr6+fUpJeSU=;
        b=Lx6mEFmdXTMqAomFKYFrKUZXUZrxN6ENXDYox1YSvbiAX0FbrYfMX0FIbEWURdDnlXbXDA
        yjhQsTQqXMaPh8f0N5VaGiES4YqB3b4MdXYFOgm/KVtcCiwJE+VgoHa8d5B+yamJyLCF8+
        b3/elwdG8mUoAjsUb1v15AOOfgBmxA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-2GlSxO58M_yfKXtXB1A58Q-1; Fri, 08 Jan 2021 11:57:13 -0500
X-MC-Unique: 2GlSxO58M_yfKXtXB1A58Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F7311008560;
        Fri,  8 Jan 2021 16:57:00 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84BE460CDF;
        Fri,  8 Jan 2021 16:56:59 +0000 (UTC)
Date:   Fri, 8 Jan 2021 11:56:57 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>, linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20210108165657.GC893097@bfoster>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <20210104162353.GA254939@bfoster>
 <20210107215444.GG331610@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107215444.GG331610@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 08:54:44AM +1100, Dave Chinner wrote:
> On Mon, Jan 04, 2021 at 11:23:53AM -0500, Brian Foster wrote:
> > On Thu, Dec 31, 2020 at 09:16:11AM +1100, Dave Chinner wrote:
> > > On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
> > > > If the value goes below the limit while some threads are
> > > > already waiting but before the push worker gets to it, these threads are
> > > > not woken.
> > > > 
> > > > Always wake all CIL push waiters. Test with waitqueue_active() as an
> > > > optimization. This is possible, because we hold the xc_push_lock
> > > > spinlock, which prevents additions to the waitqueue.
> > > > 
> > > > Signed-off-by: Donald Buczek <buczek@molgen.mpg.de>
> > > > ---
> > > >  fs/xfs/xfs_log_cil.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > > index b0ef071b3cb5..d620de8e217c 100644
> > > > --- a/fs/xfs/xfs_log_cil.c
> > > > +++ b/fs/xfs/xfs_log_cil.c
> > > > @@ -670,7 +670,7 @@ xlog_cil_push_work(
> > > >  	/*
> > > >  	 * Wake up any background push waiters now this context is being pushed.
> > > >  	 */
> > > > -	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> > > > +	if (waitqueue_active(&cil->xc_push_wait))
> > > >  		wake_up_all(&cil->xc_push_wait);
> > > 
> > > That just smells wrong to me. It *might* be correct, but this
> > > condition should pair with the sleep condition, as space used by a
> > > CIL context should never actually decrease....
> > > 
> > 
> > ... but I'm a little confused by this assertion. The shadow buffer
> > allocation code refers to the possibility of shadow buffers falling out
> > that are smaller than currently allocated buffers. Further, the
> > _insert_format_items() code appears to explicitly optimize for this
> > possibility by reusing the active buffer, subtracting the old size/count
> > values from the diff variables and then reformatting the latest
> > (presumably smaller) item to the lv.
> 
> Individual items might shrink, but the overall transaction should
> grow. Think of a extent to btree conversion of an inode fork. THe
> data in the inode fork decreases from a list of extents to a btree
> root block pointer, so the inode item shrinks. But then we add a new
> btree root block that contains all the extents + the btree block
> header, and it gets rounded up to ithe 128 byte buffer logging chunk
> size.
> 
> IOWs, while the inode item has decreased in size, the overall
> space consumed by the transaction has gone up and so the CIL ctx
> used_space should increase. Hence we can't just look at individual
> log items and whether they have decreased in size - we have to look
> at all the items in the transaction to understand how the space used
> in that transaction has changed. i.e. it's the aggregation of all
> items in the transaction that matter here, not so much the
> individual items.
> 

Ok, that makes more sense...

> > Of course this could just be implementation detail. I haven't dug into
> > the details in the remainder of this thread and I don't have specific
> > examples off the top of my head, but perhaps based on the ability of
> > various structures to change formats and the ability of log vectors to
> > shrink in size, shouldn't we expect the possibility of a CIL context to
> > shrink in size as well? Just from poking around the CIL it seems like
> > the surrounding code supports it (xlog_cil_insert_items() checks len > 0
> > for recalculating split res as well)...
> 
> Yes, there may be situations where it decreases. It may be this is
> fine, but the assumption *I've made* in lots of the CIL push code is
> that ctx->used_space rarely, if ever, will go backwards.
> 

... and rarely seems a bit more pragmatic than never.

> e.g. we run the first transaction into the CIL, it steals the sapce
> needed for the cil checkpoint headers for the transaciton. Then if
> the space returned by the item formatting is negative (because it is
> in the AIL and being relogged), the CIL checkpoint now doesn't have
> the space reserved it needs to run a checkpoint. That transaction is
> a sync transaction, so it forces the log, and now we push the CIL
> without sufficient reservation to write out the log headers and the
> items we just formatted....
> 

Hmmm... that seems like an odd scenario because I'd expect the space
usage delta to reflect what might or might not have already been added
to the CIL context, not necessarily the AIL. IOW, shouldn't a negative
delta only occur for items being relogged while still CIL resident
(regardless of AIL residency)?

From a code standpoint, the way a particular log item delta comes out
negative is from having a shadow lv size smaller than the ->li_lv size.
Thus, xlog_cil_insert_format_items() subtracts the currently formatted
lv size from the delta, formats the current state of the item, and
xfs_cil_prepare_item() adds the new (presumably smaller) size to the
delta. We reuse ->li_lv in this scenario so both it and the shadow
buffer remain, but a CIL push pulls ->li_lv from all log items and
chains them to the CIL context for writing, so I don't see how we could
have an item return a negative delta on an empty CIL. Hm?

(I was also wondering whether repeated smaller relogs of an item could
be a vector for this to go wrong, but it looks like
xlog_cil_insert_format_items() always uses the formatted size of the
current buffer...).

Brian

> So, yeah, shrinking transaction space usage definitely violates some
> of the assumptions the code makes about how relogging works. It's
> entirely possible the assumptions I've made are not entirely correct
> in some corner cases - those particular cases are what we need to
> ferret out here, and then decide if they are correct or not and deal
> with it from there...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

