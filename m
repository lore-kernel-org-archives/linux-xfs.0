Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A789C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 02:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4891F64EF5
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 02:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhBYCQd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 21:16:33 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:50200 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236785AbhBYCQX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 21:16:23 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 72FFD1AD805
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 13:15:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF6Bg-0032fV-QO
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 13:15:32 +1100
Date:   Thu, 25 Feb 2021 13:15:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210225021532.GI4662@dread.disaster.area>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <20210224232600.GH4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224232600.GH4662@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=oLefN8dgAaCz4RDANdoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 10:26:00AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AIL pushing is stalling on log forces when it comes across
> pinned items. This is happening on removal workloads where the AIL
> is dominated by stale items that are removed from AIL when the
> checkpoint that marks the items stale is committed to the journal.
> This results is relatively few items in the AIL, but those that are
> are often pinned as directories items are being removed from are
> still being logged.
.....
> One of the complexities here is that the CIL push does not guarantee
> that the commit record for the CIL checkpoint is written to disk.
> The current log force ensures this by submitting the current ACTIVE
> iclog that the commit record was written to. We need the CIL to
> actually write this commit record to disk for an async push to
> ensure that the checkpoint actually makes it to disk and unpins the
> pinned items in the checkpoint on completion. Hence we need to pass
> down to the CIL push that we are doing an async flush so that it can
> switch out the commit_iclog if necessary to get written to disk when
> the commit iclog is finally released.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> Version 2:
> - ensure the CIL checkpoint issues the commit record to disk for an
>   async push. Fixes generic/530 hang on small logs.
> - increment log force stats when the CIL is forced and also when it
>   sleeps to give insight into the amount of blocking being done when
>   the CIL is forced.

Oops, looks like I forgot to strip debug trace_printk()s out of the
patch before sending it. They are gone now, so I'll wait for review
comments before resending again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
