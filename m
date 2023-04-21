Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503A4C77B75
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 09:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjDUJfE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 05:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjDUJfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 05:35:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79810A5C6
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 02:35:00 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a526aa3dd5so22501185ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 02:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682069700; x=1684661700;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hrSZuR/3mYMLrxThUUkQwbhLfs41HMClpq/vYpLlGkw=;
        b=E6HRCEdayPWgv0iEkcOkdMT1fmkXd58Km1VR3OFp1Bbg/WYU4pagLRqHUuDxUe/SG9
         o4EVZWwzi8O3nOE82OuC1qcuLsC687xuGf+0TFBNG3a5WQnq+t8NS7eX5dKcuxlF/4tF
         94aEe09DDHLm4qCBKmPmuQnvqfCRZHLkEbR5QOtffvsi9E1VA4ObsoGzhKmdUNpTrsDA
         0Q8sZl210j/U5tRaC6IOiTTsXeIW5Zu4a0cKxtE7MVOEN+4VO6fLkkocdl7m3pxFJbHO
         Q+C/+2BwIPWboM3bP4PXTtfSSSvhgVEXX1xSNROAdrhD99Wdv20RsxrV1Rf8Dix1yqwc
         kTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682069700; x=1684661700;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hrSZuR/3mYMLrxThUUkQwbhLfs41HMClpq/vYpLlGkw=;
        b=R+aCoIVYZVW/taU9rOsS0jbquuZan1i+uF2SkfHnaSe/a6ZPy2LhkJadMSKprpdocG
         bx8eiN80EcOvDx0CEDfGUnQd/eC7CbPl3Xim3eLaNqrZyjGinWMGtEdy8IwcvG3MUrku
         i6OcI9E64udKIcMssRw7PMRBpNowj026xi3znQ7TC8NocpMI2SakTw6t274IxGINnm7S
         qLLUHIWeii7p5Y63U8xrkP9p5/EBgUkmAQv8ZuhaFYuIGr6wIkWIolr38QjgwGpWBZWr
         l7ZSWe362qE6ddQmF5KewSOPNaZX9x5NVx6yVNd2YyuK7EHNXItx+exLHOmKj2IRehI5
         BazQ==
X-Gm-Message-State: AAQBX9eKEdJ1lqBtFl8q+v7ws/AM4AcQdKkym6u5Z2++teePy/2erAwF
        EzvD/D2JCG7Q2Y90QCNxbhjjBw==
X-Google-Smtp-Source: AKy350YG+NLSww9WKQLeNnLqtudVgomOR9/+yN3sMf4a4GqnViXvV+5G9jTj8LL3UnzpVXc6BJrryg==
X-Received: by 2002:a17:902:ea03:b0:1a6:fe25:412b with SMTP id s3-20020a170902ea0300b001a6fe25412bmr5429325plg.26.1682069699822;
        Fri, 21 Apr 2023 02:34:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709028a8900b0019cb6222691sm2401071plo.133.2023.04.21.02.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 02:34:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppnAO-0060VG-3O; Fri, 21 Apr 2023 19:34:56 +1000
Date:   Fri, 21 Apr 2023 19:34:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: IO time one extent per EFI
Message-ID: <20230421093456.GE3223426@dread.disaster.area>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-2-wen.gang.wang@oracle.com>
 <20230419235559.GW3223426@dread.disaster.area>
 <71E9310C-06A6-41B9-AFE6-C8EE37CF5058@oracle.com>
 <20230420232206.GZ3223426@dread.disaster.area>
 <451AEBDF-7BBC-4C6E-BB0F-AFE18C51607C@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <451AEBDF-7BBC-4C6E-BB0F-AFE18C51607C@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 12:24:49AM +0000, Wengang Wang wrote:
> > On Apr 20, 2023, at 4:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> > We don't do that anymore for partially processed multi-extent
> > intents anymore. Instead, we use deferred ops to chain updates. i.e.
> > we log a complete intent done items alongside a new intent
> > containing the remaining work to be done in the same transaction.
> > This cancels the original intent and atomically replaces it with a
> > new intent containing the remaining work to be done.
> > 
> > So when I say "update the EFD" I'm using historic terminology for
> > processing and recovering multi-extent intents. In modern terms,
> > what I mean is "update the deferred work intent chain to reflect the
> > work remaining to be done".
> 
> OK. so let’s see the difference between your implementation from mine.
> Say, there are three extents to free.
> 
> My patch would result in:
> 
> EFI 1  with extent1
> free extent1
> EFD 1 with extent1
> transaction roll
> EFI 2 with extent2
> free extent2
> EFD 2 with extent2
> transaction roll
> EFI 3 with extent3
> free extent3
> EFD3 with extent3
> transaction commit

No, it wouldn't. This isn't how the deferred work processes work
items on the transaction. A work item with multiple extents on it
would result in this:

xfs_defer_finish(tp)  # tp contains three xefi work items 
  xfs_defer_finish_noroll
    xfs_defer_create_intents()
      list_for_each_defer_pending
        xfs_defer_create_intent(dfp)
	  ops->create_intent(tp, &dfp->dfp_work, dfp->dfp_count, sort);
	    xfs_extent_free_create_intent()
	      <create EFI>
	      list_for_each_xefi
	        xfs_extent_free_log_item(xefi)
		  <adds extent to current EFI>

  xfs_defer_trans_roll()
    <save>
    xfs_trans_roll()
      xfs_trans_dup()
      xfs_trans_commit()
    <restore>

At this point we have this committed to the CIL

EFI 1 with extent1
EFI 2 with extent2
EFI 3 with extent3

And xfs_defer_finish_noroll() continues with

  <grabs first work item>
  xfs_defer_finish_one(dfp)
    ->create_done(EFI 1)
      xfs_extent_free_create_done
	<create EFD>
    list_for_each_xefi
      ops->finish_item(tp, dfp->dfp_done, li, &state);
        xfs_extent_free_finish_item()
	  xfs_trans_free_extent
	    __xfs_free_extent
	      <adds extent to EFD>

And once the processing of the single work item is done we loop
back to the start of the xfs_defer_finish_noroll() loop. We don't
have any new intents, so xfs_defer_create_intents() returns false,
but we completed a dfp work item, so we run:

  xfs_defer_trans_roll()
    <save>
    xfs_trans_roll()
      xfs_trans_dup()
      xfs_trans_commit()
    <restore>

At this point we have this committed to the CIL

EFI 1 with extent1
EFI 2 with extent2
EFI 3 with extent3
<AGF, AGFL, free space btree block mods>
EFD 1 with extent1

Then we run xfs_defer_finish_one() on EFI 2, commit, then run
xfs_defer_finish_one() on EFI 3. At this point, we have in the log:

EFI 1 with extent1
EFI 2 with extent2
EFI 3 with extent3
<AGF, AGFL, free space btree block mods>
EFD 1 with extent1
<AGF, AGFL, free space btree block mods>
EFD 2 with extent2

But we have not committed the final extent free or EFD 3 - that's in
the last transaction context we pass back to the _xfs_trans_commit()
context for it to finalise and close off the rolling transaction
chain. At this point, we finally have this in the CIL:

EFI 1 with extent1
EFI 2 with extent2
EFI 3 with extent3
<AGF, AGFL, free space btree block mods>
EFD 1 with extent1
<AGF, AGFL, free space btree block mods>
EFD 2 with extent2
<AGF, AGFL, free space btree block mods>
EFD 3 with extent3

> The EFI/EFD log item pairs should not be written to log as they appear in same checkpoint.

I *always* ignore CIL intent whiteouts when thinking about
transaction chains and intents. That is purely a journal efficiency
optimisation, not something that is necessary for correct operation.

> Your idea yields this:
> 
> EFI 1 with extent1 extent2 extent3
> free extent1
> EFI 2 with extent2 extent3
> EFD 1 with extent1 extent2 extent3
> transaction commit
> create transaction
> free extent2
> EFI 3 with extent3
> EFD 2 with extent extent2 extent3
> transaction commit
> create transaction
> free extent3
> EFD 3 with extent3
> transaction commit.

The EFI/EFD contents are correct, but the rest of it is not - I am
not suggesting open coding transaction rolling like that. Everything
I am suggesting works through the same defer ops mechanism as you
are describing. So if we start with the initial journal contents
looks like this:

EFI 1 with extent1 extent2 extent3.

Then we run xfs_defer_finish_one() on that work, 

  xfs_defer_finish_one(dfp)
    ->create_done(EFI 1)
      xfs_extent_free_create_done
	<create EFD>
    list_for_each_xefi
      ops->finish_item(tp, dfp->dfp_done, li, &state);
        xfs_extent_free_finish_item()
	  xfs_trans_free_extent
	    __xfs_free_extent
	      <adds extent to EFD>

But now we have 3 xefis on the work to process. So on success of
the first call to xfs_trans_free_extent(), we want it to return
-EAGAIN to trigger the existing relogging code to create the new
EFI. How this works is describe in the section "Requesting a
Fresh Transaction while Finishing Deferred Work" in
fs/xfs/libxfs/xfs_defer.c, no point me duplicating that here.

The result is that the deferred work infrastructure does the work
of updaing the done intent and creating the new intents for the work
remaining. Hence after the next transaction roll, we have in the CIL

EFI 1 with extent1 extent2 extent3.
<AGF, AGFL, free space btree block mods>
EFD 1 with extent1 extent2 extent3.
EFI 2 with extent2 extent3.

And so the loop goes until there is no more work remaining.

> Your implementation also includes three EFI/EFD pairs, that’s the same as mine.
> So actually it’s still one extent per EFI per transaction. Though you are not changing
> XFS_EFI_MAX_FAST_EXTENTS.

The difference is that what I'm suggesting is that the extent free
code can decide when it needs a transaction to be rolled. It isn't
forced to always run a single free per transaction, it can decide
that it can free multiple extents per transaction if there is no
risk of deadlocks (e.g. extents are in different AGs).  Forcing
everything to be limited to a transaction per extent free even when
there is no risk of deadlocks freeing multiple extents in a single
transaction is unnecessary.

Indeed, if the second extent is in a different AG, we don't risk
busy extents causing us issues, so we could do:

EFI 1 with extent1 extent2 extent3.
<AGF 1, AGFL 1, free space btree block mods>
<AGF 2, AGFL 2, free space btree block mods>
EFD 1 with extent1 extent2 extent3.
EFI 2 with extent3.
.....

The difference is that limiting the number of xefi items per
deferred work item means we can only process a single extent per
work item regardless of the current context.

Using the existing defered work "on demand transaction rolling"
mechanism I'm suggesting we use doesn't put any artificial
constrains on how we log and process the intents. This allows us to
aggregate multiple extent frees into a single transaction when there
is no risk associated with doing so and we have sufficient
transaction reservations remaining to guarantee we can free the
extent. It's far more efficient, and the infrastructure we have in
place already supports this sort of functionality....

When we go back to the original problem of the AGFL allocation
needing to roll the transaction to get busy extents processed, then
we could have it return -EAGAIN all the way back up to the defer-ops
level and we simply then roll the transaction and retry the same
extent free operation again. i.e. where extent freeing needs to
block waiting on stuff like busy extents, we could now have these
commit the current transaction, push the current work item to the
back of the current context's queue and come back to it later.

At this point, I think the "single extent per transaction"
constraint that is needed to avoid the busy extent deadlock goes
away, and with it the need for limiting EFI processing to a single
extent goes away too....

> And your implementation may use more log space than mine in case the EFI
> (and EFD pair) can’t be cancelled.  :D

True, but it's really not a concern.  Don't conflate "intent
recovery intent amplification can cause log space deadlocks" with
"intent size is a problem". :)

> The only difference if that you use transaction commit and I am using transaction roll
> which is not safe as you said. 
> 
> Is my understanding correct?

I think I understand where we are misunderstanding each other :)
Perhaps it is now obvious to you as well from the analysis above.
If so, ignore the rest of this :)

What does "transaction roll" actually mean?

XFS has a concept of "rolling transactions". These are made up of a
series of individual transaction contexts that are linked together
by passing a single log reservation ticket between transaction
contexts.

xfs_trans_roll() effectively does:

	ntp = xfs_trans_dup(tp)
	....
	xfs_trans_commit(tp)

	return ntp;

i.e. it duplicates the current transaction handle, takes the unused
block reservation from it, grabs the log reservation ticket from it,
moves the defered ops from the old to the new transaction context,
then commits the old transaction context and returns the new one.

tl;dr: a rolling transaction is a series of linked independent
transactions that share a common set of block and log reservations.

To make a rolling transaction chain an atomic operation on a
specific object (e.g. an inode) that object has to remain locked and
be logged in every transaction in the chain of rolling transactions.
This keeps it moving forward in the log and prevents it from pinning
the tail of the log and causing log space deadlocks.

Fundamentally, though, each individual transaction in a rolling
transaction is an independent atomic change set. So when you say
"roll the transaction", what you are actually saying is "commit the
current transaction and start a new transaction using the
reservations the current transaction already holds."

When I say "transaction commit" I am only refering to the process
that closes off the current transaction. If this is in the middle of
a rolling transaction, then what I am talking about is
xfs_trans_roll() calling xfs_trans_commit() after it has duplicated
the current transaction context.

Transaction contexts running defered operations, intent chains, etc
are *always* rolling transactions, and each time we roll the
transaction we commit it.

IOWS, when I say "transaction commit" and you say "transaction roll"
we are talking about exactly the same thing - transaction commit is
the operation that roll performs to finish off the current change
set...

Ideally, nobody should be calling xfs_trans_roll() directly anymore.
All rolling transactions should be implemented using deferred ops
nowdays - xfs_trans_roll() is the historic method of running rolling
transactions. e.g. see the recent rework of the attribute code to
use deferred ops rather than explicit calls to xfs_trans_roll() so
we can use intents for running attr operations.

These days the transaction model is based around chains of deferred
operations. We attach deferred work to the transaction, and then
when we call xfs_trans_commit() it goes off into the deferred work
infrastructure that creates intents and manages the transaction
context for processing the intents itself.

This is the primary reason we are trying to move away from high
level code using transaction rolling - we can't easily change the
way we process operations when the high level code controls
transaction contexts. Using deferred intent chains gives us fine
grained control over transaction context in the deferred ops
processing code - we can roll to a new transaction whenever we need
to....

> One question is that if only one EFI is safe per transaction, how
> we ensure that there is only one EFI per transaction in case there
> are more than 16 (current XFS_EFI_MAX_FAST_EXTENTS) extents to
> free in current code?

That will handled exactly the same way it does with your change - it
will simply split up the work items so there are multiple intents
logged.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
