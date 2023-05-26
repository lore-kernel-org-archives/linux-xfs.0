Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2540C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEZA0g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZA0f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:26:35 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC89F18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:26:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ae3a5dfa42so1267455ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685060792; x=1687652792;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xDwthdF9l5A1G/jPbnhcwlSQwaUy6ygIVLh1DItuo+s=;
        b=cazu/HblLRUSTELIJYWtCONdZMt3w2mAubh67NU9h7KW3epibrAogEfi75ZOEZCPVQ
         8UZyczs0uW26aaCcS7lU8uzkARvKKIwIpdzfsTgNcYshpwn4BuRtbDPU32DwaKTp3xZx
         9Z5qNctK/bURrjT/EAm5myAV/t/rkBA6KktYqzT7eJ8OyRrUDJnX/DGo4YeymnIbmqIA
         ILY/YO+MM25VS9ztbBQihp2Exbm9Z0U5ez0dPr0vufyzzKsQmdWHBnfpXEm+Zx0sfDd6
         NsKw8AKwmTwmHIbs35XLFmCcF8ebcvQg3bsYC66OC8Q8DHXLbuZpSnJWmtvUCBmwxq/V
         icKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685060792; x=1687652792;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDwthdF9l5A1G/jPbnhcwlSQwaUy6ygIVLh1DItuo+s=;
        b=G3ufNaUjCOioDoJpULFQRAg1jeGMWJFFT9cm3Y9fO8p1uHn8jq23EvsMUCUIK21I0K
         XsaM8rimbI2Po9+oNJTnviqpD3oOBPH8wTwMj9EAL1+SpKYIGRr6/N+LNKF8ySJe6FKE
         o3W8pFtCmV91WDqxG5+Tf1HXzT3nq7d3LS1mCaazgfokN6NPvC9P/ymw9Ws1Xfvz83cC
         bv/V16N/kCNcuAggBHFEIe7NoQpX2k+iB7c7DNt/XStgoZGSPsOm9hGFvWnLPt+AAjpp
         WAxEJOqc2Wasv7zI4lDfSl+8Y6xIED+CZ2/7KxkSjkq0cAvG0VVOTq+lkiwqsm700fAx
         3m0g==
X-Gm-Message-State: AC+VfDzoBNeVH61JPAuOyiz7/XYXZqZ6s6E64/p/4NFsV97bqKbfsDSh
        WAdCNfuKntdf/+AZVl2IbNSgSQ==
X-Google-Smtp-Source: ACHHUZ5GwmGMvTMhFbSR5hznSTvFGV75zBUHdvZppl+H6rhYQOKYYWg6gCpip6G6IJFDgI9g+6djtQ==
X-Received: by 2002:a17:903:1d2:b0:1af:b7cd:5961 with SMTP id e18-20020a17090301d200b001afb7cd5961mr714289plh.1.1685060792006;
        Thu, 25 May 2023 17:26:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902654400b001a505f04a06sm1974480pln.190.2023.05.25.17.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 17:26:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q2LHn-003vRZ-38;
        Fri, 26 May 2023 10:26:27 +1000
Date:   Fri, 26 May 2023 10:26:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Message-ID: <ZG/8s3zDr1t0mxbr@dread.disaster.area>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
 <ZGrCpXoEk9achabI@dread.disaster.area>
 <E6E92519-4AD7-4115-903F-00D7633B1B3A@oracle.com>
 <ZGvvZaQWvxf2cqlz@dread.disaster.area>
 <8DD695CE-4965-4B33-8F16-6B907D8A0884@oracle.com>
 <20230524002743.GF11620@frogsfrogsfrogs>
 <7D3E40A7-4D94-4EF0-8BED-FE11C76B8A84@oracle.com>
 <ZG7F6xj5N/ahwOMH@dread.disaster.area>
 <83930F11-431B-4E32-85EB-4B83DC623543@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83930F11-431B-4E32-85EB-4B83DC623543@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:13:41PM +0000, Wengang Wang wrote:
> 
> 
> > On May 24, 2023, at 7:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Wed, May 24, 2023 at 04:27:19PM +0000, Wengang Wang wrote:
> >>> On May 23, 2023, at 5:27 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> >>> On Tue, May 23, 2023 at 02:59:40AM +0000, Wengang Wang wrote:
> >>>>> On May 22, 2023, at 3:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>>> On Mon, May 22, 2023 at 06:20:11PM +0000, Wengang Wang wrote:
> >>>>>>> On May 21, 2023, at 6:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>>>>> On Fri, May 19, 2023 at 10:18:29AM -0700, Wengang Wang wrote:
> >>>>>>>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> >>>>>> For existing other cases (if there are) where new intents are added,
> >>>>>> they don’t use the capture_list for delayed operations? Do you have example then? 
> >>>>>> if so I think we should follow their way instead of adding the defer operations
> >>>>>> (but reply on the intents on AIL).
> >>>>> 
> >>>>> All of the intent recovery stuff uses
> >>>>> xfs_defer_ops_capture_and_commit() to commit the intent being
> >>>>> replayed and cause all further new intent processing in that chain
> >>>>> to be defered until after all the intents recovered from the journal
> >>>>> have been iterated. All those new intents end up in the AIL at a LSN
> >>>>> index >= last_lsn.
> >>>> 
> >>>> Yes. So we break the AIL iteration on seeing an intent with lsn equal to
> >>>> or bigger than last_lsn and skip the iop_recover() for that item?
> >>>> and shall we put this change to another separated patch as it is to fix
> >>>> an existing problem (not introduced by my patch)?
> >>> 
> >>> Intent replay creates non-intent log items (like buffers or inodes) that
> >>> are added to the AIL with an LSN higher than last_lsn.  I suppose it
> >>> would be possible to break log recovery if an intent's iop_recover
> >>> method immediately logged a new intent and returned EAGAIN to roll the
> >>> transaction, but none of them do that;
> >> 
> >> I am not quite sure for above. There are cases that new intents are added
> >> in iop_recover(), for example xfs_attri_item_recover():
> >> 
> >> 632         error = xfs_xattri_finish_update(attr, done_item);
> >> 633         if (error == -EAGAIN) {
> >> 634                 /*
> >> 635                  * There's more work to do, so add the intent item to this
> >> 636                  * transaction so that we can continue it later.
> >> 637                  */
> >> 638                 xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> >> 639                 error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> >> 640                 if (error)
> >> 641                         goto out_unlock;
> >> 642
> >> 643                 xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >> 644                 xfs_irele(ip);
> >> 645                 return 0;
> >> 646         }
> >> 
> >> I am thinking line 638 and 639 are doing so.
> > 
> > I don't think so. @attrip is the attribute information recovered
> > from the original intent - we allocated @attr in
> > xfs_attri_item_recover() to enable the operation indicated by
> > @attrip to be executed.  We copy stuff from @attrip (the item we are
> > recovering) to the new @attr structure (the work we need to do) and
> > run it through the attr modification state machine. If there's more
> > work to be done, we then add @attr to the defer list.
> 
> Assuming “if there’s more work to be done” is the -EAGAIN case...
> 
> > 
> > If there is deferred work to be continued, we still need a new
> > intent to indicate what attr operation needs to be performed next in
> > the chain.  When we commit the transaction (639), it will create a
> > new intent log item for the deferred attribute operation in the
> > ->create_intent callback before the transaction is committed.
> 
> Yes, that’s true. But it has no conflict with what I was saying. The thing I wanted
> to say is that:
> The new intent log item (introduced by xfs_attri_item_recover()) could appear on
> AIL before the AIL iteration ends in xlog_recover_process_intents(). 
> Do you agree with above?

Recovery of intents has *always* been able to do this. What I don't
understand is why you think this is a problem.

> In the following I will talk about the new intent log item. 
> 
> The iop_recover() is then executed on the new intent during the AIL intents iteration.
> I meant this loop:
> 
> 2548         for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> 2549              lip != NULL;
> 2550              lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
> ….
> 2584         }
> Do you agree with above?

Repeatedly asserting that I must agree that your logic is correct
comes across as unecessarily aggressive and combative and is not
acceptible behaviour.

Aggressively asserting that you are right doesn't make your logic
any more compelling. It just makes you look really bad when,
inevitably, you get politely told that you've made yet another
mistake.

> And the lsn for the new intent is equal to or bigger than last_lsn.
> Do you agree with above?
> 
> In above case the iop_recover() is xfs_attri_item_recover(). The later
> creates a xfs_attr_intent, attr1, copying things from the new ATTRI to attr1
> and process attr1.
> Do you agree with above?
> 
> Above xfs_attri_item_recover() runs successfully and the AIL intent iteration ends.

We ran xfs_xattri_finish_update(attr, done_item) which returned
-EAGAIN. This means we ran xfs_xattri_finish_update() and modified
-something- before we logged the new intent. That, however, doesn't
dictate what we need to log in the new intent - that is determined
by the overall intent chain and recovery architecture the subsystem
uses. And the attribute modification architecture is extremely
subtle, complex and full of unexpected loops.

> Now it’s time to process the capture_list with xlog_finish_defer_ops(). The
> capture_list contains the deferred operation which was added at line 639 with type
> XFS_DEFER_OPS_TYPE_ATTR. 
> Do you agree with above?
> 
> In xlog_finish_defer_ops(), a new transaction is created by xfs_trans_alloc().
> the deferred XFS_DEFER_OPS_TYPE_ATTR operation is attached to that new
> transaction by xfs_defer_ops_continue(). Then the new transaction is committed by
> xfs_trans_commit().
> Do you agree with above?

So at this point it we are logging the same intent *information*
again. But it's not the same intent - we've retired the original
intent and we have a new intent chain for the operations we are
going to perform. But why are we logging the same information in a
new intent?

Well, the attr modification state machine was -carefully- designed
to work this way: if we crash part way through an intent chain, we
always need to restart it in recovery with a "garbage collection"
step that undoes the partially complete changes that had been made
before we crashed. Only once we've done that garbage collection step
can we restart the original operation the intent described.

Indeed, the operations we perform recovering an attr intent are
actually different to the operations we perform with those intents
at runtime. Recovery has to perform garbage collection as a first
step, yet runtime does not.

IOWs, xfs_attri_item_recover() -> xfs_xattri_finish_update() is
typically performing garbage collection in the first recovery
transaction.  If it does perform a gc operation, then it is
guaranteed to return -EAGAIN so that the actual operation recovery
needs to perform can have new intents logged, be deferred and then
eventually replayed.

If we don't need to perform gc, then the operation we perform may
still require multiple transactions to complete and we get -EAGAIN
in that case, too. When that happens, we need to ensure if we crash
before recovery completes that the next mount will perform the
correct GC steps before it replays the intent from scratch. So we
always need to log an intent for the xattr operation that will
trigger the GC step on recovery.

Either way, we need to log new intents that are identical to the
original one at each step of the process so that log recovery will
always start the intent recovery process with the correct garbage
collection operation....

> During the xfs_trans_commit(), xfs_defer_finish_noroll() is called. and
> xfs_defer_finish_one() is called inside xfs_defer_finish_noroll(). For the
> deferred XFS_DEFER_OPS_TYPE_ATTR operation, xfs_attr_finish_item()
> is called.
> Do you agree with above?
> 
> In xfs_attr_finish_item(), xfs_attr_intent (attr2) is taken out from above new ATTRI
> and is processed.  attr2 and attr1 contain exactly same thing because they are both
> from the new ATTRI.  So the processing on attr2 is pure a duplication of the processing
> on attr1.  So actually the new ATTRI are double-processed.
> Do you agree with above? 

No, that's wrong. There is now "attr1 and attr2" structures - they
are one and the same. i.e. the xfs_attr_intent used in
xfs_attr_finish_item() is the same one created in
xfs_attri_item_recover() that we called
xfs_defer_add(&attr->xattri_list) with way back at line 638. 

xfs_attr_finish_item(
        struct xfs_trans                *tp,
        struct xfs_log_item             *done,
        struct list_head                *item,
        struct xfs_btree_cur            **state)
{
        struct xfs_attr_intent          *attr;
        struct xfs_attrd_log_item       *done_item = NULL;
        int                             error;

>>>>>   attr = container_of(item, struct xfs_attr_intent, xattri_list);
        if (done)
                done_item = ATTRD_ITEM(done);

xfs_attr_finish_item() extracts the @attr structure from the
listhead that is linking it into the deferred op chain, and we
run xfs_attr_set_iter() again to run the next step(s) in the xattr
modification state machine. If this returns -EAGAIN (and it can)
we go around the "defer(attr->attri_list), create new intent,
commit, ... ->finish_item() -> xfs_attr_finish_item()" loop again.

From this, I am guessing that you are confusing the per-defer-cycle
xfs_attri_log_item with the overall xfs_attr_intent context. i.e. We
allocate a new xfs_attri_log_item (and xfs_attrd_log_item) every
time we create new intents in the deferred operation chain. Each
xfs_attri_log_item is created from the state that is carried
across entire the attr recovery chain in the xfs_attr_intent
structure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
