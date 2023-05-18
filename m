Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB47C7EE22
	for <linux-xfs@archiver.kernel.org>; Thu, 18 May 2023 01:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjERBBK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 21:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjERBBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 21:01:09 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C8D135
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 18:01:08 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-52cb78647ecso966718a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 18:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684371668; x=1686963668;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=07IoLjE1LdJCOzHRJp2YQeBXS/e2dw+PJJvylBesA0k=;
        b=g/ckvzkMTsRilsUa1Ld6bOLv6JRXQtYPoXmvHf8T6EpesfZbk4xQ4XczBRRBN33Z9R
         /PPscjkUlR/bINziYWMhYuEye6R+ALTsLkVkUCBf1yGwkR/Q2HqVgbnwpl8rgxLDpZTe
         XGg2i/0v/K32233+v3BqrvgtJDwPJsRE2m79KE2ygakCyhz6z023z4rWmlcYLadC2z8i
         Mstix3vXvtbd/XCGeWVG6hYqNiF1NdqUbF16s8nxPWSWrMmk1YRAOZPu2UslynlUl+Yb
         DIYg1CB5+ZoxZyQW7n8jNrn1WTEZfus5dlktSGHkRYl6wSrCH8ab0FdDXSJ5QYlyoz6E
         e2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684371668; x=1686963668;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=07IoLjE1LdJCOzHRJp2YQeBXS/e2dw+PJJvylBesA0k=;
        b=USqhsUGPWrO+oaIxjDQQl8roDs7Wcxw2TaRo+cOEB+IRXoaQekYVdgmuvrrnmd80NB
         zIxtqvz7DTgjYP1l3QE8M9ngQbnDBR2Eci5gsjlzEAHaklgHgu2JKXiSE4YflW952ocv
         c70Eo1qDUgT8C0NOO6R6Sq58+aH7UAd2Glg089CEhWO5YUleursjCY2BsLIaE8YfMFR0
         b8nkSPjoIA+xaSSJVy4knsafzGzvzrYJcmac6YMBqL/0knBHUlHi/8wFaCz/mOA4ZQl5
         LqhHLygf8l0uRzGOu5YyZC2EQrujfnM9W5kixXLVSGHInXZFaeNHFTIzbAz2X9KTZkzm
         P5kA==
X-Gm-Message-State: AC+VfDy9JLgRU4RRZ+4dm0GxJsFH5mrStbI4e5j4tBDPHadxDpQvxeLx
        FC3V0czpoVGeTzPvDSDALd9KFA==
X-Google-Smtp-Source: ACHHUZ7Au0a3hmZBsDhlPavZ/dd1zAaB2RGK3sMDa2eXC0d90kbNIZo/t8WpwyWo8tNneFFrW94QrQ==
X-Received: by 2002:a17:902:d2ca:b0:1ac:71a7:a1fb with SMTP id n10-20020a170902d2ca00b001ac71a7a1fbmr972656plc.18.1684371667886;
        Wed, 17 May 2023 18:01:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id iz11-20020a170902ef8b00b001acaf7d58fbsm11736plb.124.2023.05.17.18.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 18:01:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pzS0t-000lD8-1c;
        Thu, 18 May 2023 11:01:03 +1000
Date:   Thu, 18 May 2023 11:01:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Message-ID: <ZGV4z5TwbUVaHqeC@dread.disaster.area>
References: <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
 <ZGQwdes/DQPXRJgj@dread.disaster.area>
 <94FD314F-7819-4187-AC42-F984AF42C662@oracle.com>
 <ZGVZ9o1LIkZ5NPAo@dread.disaster.area>
 <51550386-87D3-4143-9649-04E69CC178F8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51550386-87D3-4143-9649-04E69CC178F8@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 18, 2023 at 12:10:53AM +0000, Wengang Wang wrote:
> 
> 
> > On May 17, 2023, at 3:49 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Wed, May 17, 2023 at 07:14:32PM +0000, Wengang Wang wrote:
> >>> On May 16, 2023, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>> On Tue, May 16, 2023 at 05:59:13PM -0700, Darrick J. Wong wrote:
> >>> I was thinking this code changes to:
> >>> 
> >>> flags |= XFS_ALLOC_FLAG_TRY_FLUSH;
> >>> ....
> >>> <attempt allocation>
> >>> ....
> >>> if (busy) {
> >>> xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> >>> trace_xfs_alloc_size_busy(args);
> >>> error = xfs_extent_busy_flush(args->tp, args->pag,
> >>> busy_gen, flags);
> >>> if (!error) {
> >>> flags &= ~XFS_ALLOC_FLAG_TRY_FLUSH;
> >> 
> >> What’s the benefits to use XFS_ALLOC_FLAG_TRY_FLUSH?
> >> If no change happened to pagb_gen, we would get nothing good in the retry
> >> but waste cycles. Or I missed something?
> > 
> > You missed something: the synchronous log force is always done.
> > 
> 
> It’s true that synchronous log force is done.
> 
> > The log force is what allows busy extents to be resolved - busy
> > extents have to be committed to stable storage before they can be
> > removed from the busy extent tree.
> 
> Yep.
> 
> > 
> > If online discards are not enabled, busy extents are resolved
> > directly in journal IO completion - the log force waits for this to
> > occur. In this case, pag->pagb_gen will have already incremented to
> > indicate progress has been made, and we should never wait in the
> > loop after the log force. The only time we do that is when the
> > current transaction holds busy extents itself, and hence if the
> > current tx holds busy extents we should not wait beyond the log
> > force....
> 
> So you are talking about the case of “pagb_gen will have already incremented”,
> In this case your next two lines:
> 
>   if (busy_gen != READ_ONCE(pag->pagb_gen))
> return 0;
> 
> would capture that and return immediately without waiting. So TRY_FLUSH is not
> helpful in this case. 

Except when pag->pagb_gen doesn't change. If it hasn't changed, then
we'd immediately return -EAGAIN without trying again. That is not
what the behaviour we want; we want the allocation to always try
again at least once after a flush has been run, because ....

> > If online discards are enabled, then they'll be scheduled by journal
> > IO completion. i.e. waiting on the log force guarntees pending
> > discards have been scheduled and they'll start completing soon after
> > the log force returns. When they complete they'll start incrementing
> > pag->pagb_gen. This is the case the pag->pagb_gen wait loop exists
> > for - it waits for a discard to complete and resolve the busy extent
> > in it's IO compeltion routine. At which point the allocation attempt
> > can restart.
> 
> In above case, you are talking about the case that pag->pagb_gen will be
> incremented soon without any blocking.
> In this case, in the allocator path, still the two lines:
>   if (busy_gen != READ_ONCE(pag->pagb_gen))
> return 0;
>
> The condition of "busy_gen != READ_ONCE(pag->pagb_gen)” can be true
> or a false according to the race of this process VS the queue workers (which
> start completing).  In case it’s true, the code return immediately. Otherwise
> the code runs into the loop waiting above condition become true. When
> the queue workers incremented pag->pagb_gen, the allocator path jumps
> out the loop and go — that’s perfect. I don't see why TRY_FLUSH is needed.

.... we sample pag->pagb_gen part way through the extent search and
we might sample it multiple times if we encounter multiple busy
extents.  The way the cursor currently works is that it stores the
last busy gen returned. The pag->pagb_gen value might change between
the first busy extent we encounter and the last that we encounter in
the search. If this happens, it implies that some busy extents have
resolved while we have been searching.

In that case, we can enter the flush with busy_gen = pag->pagb_gen,
but that doesn't mean no busy extents have been resolved since we
started the allocation search. Hence the flush itself may not
resolve any new busy extents, but we still may have other busy
extents that were resolved while we were scanning the tree.

Yes, we could change the way we track the busy gen in the cursor,
but that likely has other subtle impacts. e.g. we now have to
consider the fact we may never get a wakeup because all busy extents
in flight have already been resolved before we go to sleep.

It is simpler to always retry the allocation after a minimal flush
to capture busy extents that were resolved while we were scanning
the tree. This is a slow path - we don't care if we burn extra CPU
on a retry that makes no progress because this condition is only
likely to occur when we are trying to do allocation or freeing
extents very near ENOSPC.

The try-flush gives us a mechanism that always does a minimum flush
first before a retry. If that retry fails, then we block, fail or
retry based on whether progress has been made. But we always want
that initial retry before we block, fail or retry...

> So change the line of
>  
> flags |= XFS_ALLOC_FLAG_TRY_FLUSH;
> 
> to
> 
> if (xfs_has_discard(mp))
>     flags |= XFS_ALLOC_FLAG_TRY_FLUSH;
> 
> Sounds good?

No. The allocator itself should know nothing about when discards are
enabled - the whole point of the busy extent infrastructure handling
discards is to abstract discard delays away from the allocator
itself. The allocator only cares if the extent is busy or not, it
doesn't care why the extent is busy. And, as per above, the
TRY_FLUSH triggered retry is needed regardless of discards because
busy extents can resolve while a search is in progress instead of
being resolved by the log force...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
