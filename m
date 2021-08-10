Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDEBC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E7460551
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbhHJFTE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:19:04 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43752 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237571AbhHJFTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:19:03 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E98C61143C15
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:18:37 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-00GZYl-Rf
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-000Abg-K4
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/9 v3] xfs: shutdown is a racy mess
Date:   Tue, 10 Aug 2021 15:18:16 +1000
Message-Id: <20210810051825.40715-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Gw3JTCxDVW9RoVmuXrcA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the recent log problems we've uncovered, it's clear that the
way we shut down filesystems and the log is a chaotic mess. We can
have multiple filesystem shutdown executions being in progress at
once, all competing to run shutdown processing and emit log messages
saying the filesystem has been shut down and why. Further, shutdown
changes the log state and runs log IO completion callbacks without
any co-ordination with ongoing log operations.

This results in shutdowns running unpredictably, running multiple
times, racing with the iclog state machine transitions and exposing
us to use-after-free situations and unexpected state changes within
the log itself.

This patch series tries to address the chaotic nature of shutdowns
by making shutdown execution consistent and predictable. This is
achieved by:

- making the mount shutdown state transistion atomic and not
  dependent on log state.
- making operational log state transitions atomic
- making the log shutdown check be based entirely on the operational
  XLOG_IO_ERROR log state rather than a combination of log flags and
  iclog XLOG_STATE_IOERROR checks.
- Getting rid of XLOG_STATE_IOERROR means shutdown doesn't perturb
  iclog state in the middle of operations that are expecting iclogs
  to be in specific state(s).
- shutdown doesn't process iclogs that are actively referenced.
  This avoids use-after-free situations where shutdown runs
  callbacks and frees objects that own the reference to the iclog
  and are still in use by the iclog reference owner.
- Run shutdown processing when the last active reference to an iclog
  goes away. This guarantees that shutdown processing occurs on all
  iclogs, but it only occurs when it is safe to do so.
- acknowledge that log state is not consistent once shutdown has
  been entered and so don't try to apply consistency checking during
  a shutdown...

At the end of this patch series, shutdown runs once and once only at
the first trigger, iclog state is not modified by shutdown, and
iclog callbacks and wakeups are not processed until all active
references to the iclog(s) are dropped. Hence we now have
deterministic shutdown behaviour for both the mount and the log and
a consistent iclog lifecycle framework that we can build more
complex functionality on top of safely.

Version 3:
- rebase on 5.14-rc4 + for-next @ 130916145229
- Fixed typos in commit messages

Version 2:
- https://lore.kernel.org/linux-xfs/20210714031958.2614411-1-david@fromorbit.com/
- rebase on 5.14-rc1
- added comment about XFS_FORCED_SHUTDOWN -> xlog_is_shutdown in commit message.
- fix spurious semi-colon at end of for loop.
- fixed typos in commit messages
- undid the do {} while -> for {} conversion in xlog_state_do_callbacks()
- removed spurious blank lines in xfs_do_force_shutdown()
- added comment to commit description explaining the unconditional stack dump on
  shutdown if the error level is high enough.
- added comment about iclog IO completion avoiding shutdown races with
  referenced iclogs that haven't yet been submitted to commit description.
- cleaned up xlog_state_release_iclog() structure for better readability.
- cleaned up xlog_space_left() structure for better readability.

Version 1:
- https://lore.kernel.org/linux-xfs/20210630063813.1751007-1-david@fromorbit.com/

