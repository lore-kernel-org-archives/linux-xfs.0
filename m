Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDE8C48BE5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 04:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46CC66101D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 04:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFVEI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 00:08:28 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33576 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229674AbhFVEI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 00:08:26 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 71FBC68D5B
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 14:06:08 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-00FZEr-Dt
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-005PwN-3k
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] xfs: fix CIL shutdown UAF and shutdown hang
Date:   Tue, 22 Jun 2021 14:06:00 +1000
Message-Id: <20210622040604.1290539-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=DdC4s64k3o_t1qy2FY4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The following patches implement an initial fix for the UAF that can
occur in the CIL push code when a racing shutdown occurs. This was a
zero-day bug in the delayed logging code, and only recently
uncovered by the CIL pipelining changes that addresses a different
zero-day bug in the delayed logging code. This UAF exists regardless
in all kernels that support delayed logging (i.e. since 2.6.36), but
is extremely unlikely that anyone has hit it as it requires a
shutdown with extremely tight timing tolerances to trigger a UAF.

This is more of a problem for the current for-next tree, though,
because there is now a call to xlog_wait_on_iclog() in the UAF
window. While we don't reference the CIL context after the wait,
this will soon be needed to fix the /other/ zero-day problems found
by the CIL pipelining changes.

The encapsulation of the entire CIL commit iclog processing epilogue
in the icloglock effectively serialises this code against shutdown
races and allows us to error out before attaching the context to the
iclog if a shutdown has already occurred. Callbacks used to be under
the icloglock, but were split out in 2008 because of icloglock
contention causing log scalability problems (sound familiar? :).
Delayed logging fixed those icloglock scalability issues by moving
it out of the hot transaction commit path, so we can move the
callbacks back under the icloglock without re-introducing ancient
problems and solve the initial UAF problem this way.

With that problem solved, we can then fix the call to
xlog_wait_on_iclog() in the CIL push code by ensuring that it only
waits on older iclogs via LSN checks. As the wait drops the icloglock and
potentially re-opens us to the above UAF on shutdown, we have to be
careful not to reference the CIL context after the wait returns.

Hence the patches don't really fix the underlying cause of the
shutdown UAF here - this is intended as a low impact, easily
backportable solution to the problem. Work to fix the underlying
shutdown brokenness to remove the need to hold the icloglock from
callback attachment to xlog_state_release_iclog() is needed
(underway) before we can then apply start record ordering fixes and
re-introduce the CIL pipelining fixes and the rest of the CIL
scalabilty work....

Cheers,

Dave.


