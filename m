Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BC9C6377E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 01:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08366128D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 01:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhGVBNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 21:13:18 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:38902 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230017AbhGVBNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jul 2021 21:13:06 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 76ACA80B3FD
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 11:53:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6Nu6-009JQ9-8e
        for linux-xfs@vger.kernel.org; Thu, 22 Jul 2021 11:53:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m6Nu5-00CquV-UG
        for linux-xfs@vger.kernel.org; Thu, 22 Jul 2021 11:53:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] xfs: fix log cache flush regressions
Date:   Thu, 22 Jul 2021 11:53:30 +1000
Message-Id: <20210722015335.3063274-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=4B8MH4RbZXiobv8yyc8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The first four patches in this series fix regressions introduced by
commit eef983ffeae7 ("xfs: journal IO cache flush reductions") and
exposed by generic/482. I have one test machine that reproduces
the failures, and in general a failure occurs 1 in every 30 test
iterations.

The first two patches are related to external logs. These were found
by code inspection while looking for the cause of the generic/482
failures.

The third patch addresses a race condition between the new
unconditional async data device cache flush run by the CIL push and
the log tail changing between that flush completing and the commit
iclog being synced. In this situation, if the commit_iclog doesn't
issue a REQ_PREFLUSH, we fail to guarantee that the metadata IO
completions that moved the log tail are on stable storage. The fix
for this issue is to sample the log tail before we issue the async
cache flush, and if the log tail has changed when we release the
commit_iclog we set the XLOG_ICL_NEED_FLUSH flag on the iclog to
guarantee a cache flush is issued before the commit record that
moves the tail of the log forward is written to the log.

The fourth patch addresses an oversight about log forces. Log forces
imply a cache flush if they result in iclog IO being issued,
allowing the caller to elide cache flushes that they might require
for data integrity. The change to requiring the iclog owner to
signal that a cache flush is required completely missed the log
force code. This patch ensures that all ACTIVE and WANT_SYNC iclogs
that we either flush or wait on issue cache flushes and so guarantee
that they are on stable storage at IO completion before they signal
completion to log force waiters.

The last patch is not a regression, but a fix for another log force
iclog related flush problem I noticed and found while triaging the
above problems. Occasionally the tests would sit idle doing nothing
for up to 30s waiting on a xfs_log_force_seq() call to complete. The
trigger for them to wake up was the background log worker issuing a
new log force. This appears to be another "incorrectly wait on
future iclog state changes" situation, and it's notable that
xfs_log_force() specifically handles this situation while
xfs_log_force_seq() does not. Changing xfs_log_force_seq() to use
the same "iclog IO already completed" detection as xfs_log_force()
made those random delays go away.

I'm still not sure that I've caught all the cases where we don't
issue cache flushes correctly - debugging this has been a slow
process of whack-a-mole, and there are still questionable failures
occurring where an fsync is not appearing to issue an iclog with a
cache flush correctly after hundreds of test cycles. Capturing a
failure with enough debug information for it to be meaningful is a
slow, time-consuming process...

However, this patchset as it stands makes things a lot better, so I
figure it's better to get this out there now and get more eyes on it
sooner rather than later...

Version 1:
- based on 5.14-rc1

