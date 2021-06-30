Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE88AC11F72
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB0896187E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Jun 2021 06:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhF3Gkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 02:40:49 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42068 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232524AbhF3Gkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 02:40:47 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A0E853B3B
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 16:38:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrT-0012kA-TQ
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:15 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyTrT-007Ll5-Iz
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 16:38:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/9] xfs: shutdown is a racy mess
Date:   Wed, 30 Jun 2021 16:38:04 +1000
Message-Id: <20210630063813.1751007-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=vFmfuRArzDoZ1yUTTqsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

With the recent log problems we've uncovreed, it's clear that the
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
by making shutdown execution consistent and predictable. THis is
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

Cheers,

Dave.


