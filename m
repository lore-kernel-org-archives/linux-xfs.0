Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C14FCCA47F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 01:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241957AbiGTB21 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 21:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241880AbiGTB1a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 21:27:30 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60F726BC01
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 18:18:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6D47210E81A8
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 11:18:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oDyM4-002yOY-ER
        for linux-xfs@vger.kernel.org; Wed, 20 Jul 2022 11:18:24 +1000
Date:   Wed, 20 Jul 2022 11:18:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: l_last_sync_lsn is really tracking AIL state
Message-ID: <20220720011824.GT3861211@dread.disaster.area>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-5-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62d757e3
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=BOaNo_aMDA9FApv5rF0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:55:54AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current implementation of xlog_assign_tail_lsn() assumes that
> when the AIL is empty, the log tail matches the LSN of the last
> written commit record. This is recorded in xlog_state_set_callback()
> as log->l_last_sync_lsn when the iclog state changes to
> XLOG_STATE_CALLBACK. This change is then immediately followed by
> running the callbacks on the iclog which then insert the log items
> into the AIL at the "commit lsn" of that checkpoint.
> 
> The "commit lsn" of the checkpoint is the LSN of the iclog that the
> commit record is place in. This is also the same iclog that the
> callback is attached to. Hence the log->l_last_sync_lsn is set to
> the same value as the commit lsn recorded for the checkpoint being
> inserted into the AIL and it effectively tracks the highest ever LSN
> that the AIL has seen.
> 
> This value is not used directly by the log. It was used to determine
> the maximum push threshold for AIL pushing to ensure we didn't set
> a push target larger than had been seen in the AIL, but the AIL now
> only needs to look at it's own internal state to set push targets.
> 
> The log itself tracks it's current head via the {current_lsn,
> current_block} tuple, so it doesn't need l_last_sync_lsn for
> tracking the head of the log.  Hence nothing actually uses
> log->l_last_sync_lsn except for the tail assignment when the AIL is
> empty.
> 
> This "highest commit LSN" really doesn't need to be tracked by the
> log - the max LSN seen by the AIL can be easily tracked by the AIL
> and it can be used to set the log tail LSN correctly when the last
> item is removed from the AIL.

Ok, there's a fundamental flaw in this patch: the AIL doesn't track
the commit record LSN of log items, it tracks the *start record LSN* of the
checkpoint.

l_last_sync_lsn is the highest commit record lsn seen by the log,
whilst ailp->ail_max_seen_lsn tracks the highest start record lsn.
The difference between the two is the size of the checkpoint, and
this means by the end of the patch the grant head space that is
tracked does not have the space used by the last checkpoint
committed removed from it.

i.e. grant head space won't go to zero even when the CIL is
empty and there are no transactions in flight - the log needs to be
covered for it to drop to the size of the last iclog written to the
log during covering operations.

This causes problems with small logs - there may be space in the log
for new reservations, but because the grant space doesn't get
decremented by a log force flushing the CIL correctly,
xlog_space_left() doesn't actually report them as free and so
reservations stall until the log is covered some 30s later. Then the
same thing happens again short while later...

Essentially, this patch needs to be reworked - l_last_sync_lsn needs
to stay, but the location that is updated at needs to change to the
CIL commit callbacks so we can update it while holding the AIL lock
and then it doesn't needs to be an atomic variable....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
