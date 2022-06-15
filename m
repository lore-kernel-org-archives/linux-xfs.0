Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5F8CCA473
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 22:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346327AbiFOWEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 18:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346329AbiFOWEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 18:04:23 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD7125639D
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 15:04:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4FAC510E7692
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 08:04:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1b7a-00768P-6v
        for linux-xfs@vger.kernel.org; Thu, 16 Jun 2022 08:04:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1b7a-00FS1I-5D
        for linux-xfs@vger.kernel.org;
        Thu, 16 Jun 2022 08:04:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2 V2] xfs: xfs: non-blocking inodegc pushes
Date:   Thu, 16 Jun 2022 08:04:14 +1000
Message-Id: <20220615220416.3681870-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62aa5765
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=80JqfrdUrcx2x15jGyEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These patches introduce non-blocking inodegc pushes to fix long
hold-offs in statfs() operations when inodegc is performing long
running inode inactivation operations.

The first patch introduces the bound maximum work start time for the
inodegc queues - it's short, only 1 jiffie (10ms) - but we don't
want to delay inodegc for an arbitrarily long period of time.
However, it means that work always starts quickly and so that
reduces the need for statfs() to have to wait for background inodegc
to start and complete to catch space "freed" by recent unlinks.

The second patch converts statfs to use a "push" rather than a
"flush". The push simply schedules any pending work that hasn't yet
timed out to run immediately and returns. It does not wait for the
inodegc work to complete - that's what a flush does, and that's what
caused all the problems for statfs(). Hence statfs() is converted to
push semantics at the same time, thereby removing the blocking
behaviour it currently has.

This should prevent a large amount of the issues that have been
seeing with lots of processes stuck in statfs() - that will no long
happen. The only time user processes should get stuck now is when
the inodegc throttle kicks in (unlinks only at this point) or if we
are waiting for a lock a long running inodegc operation holds to be
released. We had those specific problems before background inodegc -
they manifested as unkillable unlink operations that had every
backed up on them instead of background inodegc that has everything
backed up on them.

This patch has been running in my test environment for nearly a
month now without regressions occurring. While there are likely
still going to be inodegc flush related hold-offs in certain
circumstances, nothing appears to be impacting the correctness of
fstests tests or creating new issues. The 0-day kernel testing bot
also indicates that certain benchmarks (such as aim7 and
stress-ng.rename) run significantly faster with bound maximum delays
and non-blocking statfs operations.

Comments, thoughts and testing appreciated.

-Dave.

Version 2:
- Also convert quota reportting inodegc flushes to a push.


