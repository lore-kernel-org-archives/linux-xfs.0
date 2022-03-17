Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E188AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 06:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiCQGGf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiCQGG3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 02:06:29 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88AD282D3B
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 22:39:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D05A910E4899
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 16:39:09 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUiqq-006QoL-W6
        for linux-xfs@vger.kernel.org; Thu, 17 Mar 2022 16:39:09 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nUiqq-000giD-Un
        for linux-xfs@vger.kernel.org;
        Thu, 17 Mar 2022 16:39:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7 v4] xfs: log recovery fixes
Date:   Thu, 17 Mar 2022 16:39:00 +1100
Message-Id: <20220317053907.164160-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6232c97d
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=AmCRXBs-6vWbMaXcZSAA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Willy reported generic/530 had started hanging on his test machines
and I've tried to reproduce the problem he reported. While I haven't
reproduced the exact hang he's been having, I've found a couple of
others while running g/530 in a tight loop on a couple of test
machines.

The first 3 patches are defensive fixes - the log worker acts as a
watchdog, and the issues in patch 2 and 3 were triggered on my
testing of g/530 and lead to 30s delays that the log worker watchdog
caught. Without the watchdog, these may actually be deadlock
triggers.

The 4th patch is the one that fixes the problem Willy reported.
It is a regression from conversion of the AIL pushing to use
non-blocking CIL flushes. It is unknown why this suddenly started
showing up on Willy's test machine right now, and why only on that
machine, but it is clearly a problem. This patch catches the state
that leads to the deadlock and breaks it with an immediate log
force to flush any pending iclogs.

In testing these patches, I found generic/388 was causing frequent
failures with recovery failing because inode clusters were being
found uninitialised in log recovery. That turns out to be a zero day
race condition in the forced shutdown code, and that is fixed over
the patches 5-7. In short, we can't abort writeback of log items
before we shut down the log (because that's separate to -mount-
shutdown) as removing aborted log items can move the tail of the log
forward and that can be propagated to the on-disk log and corrupt it
if timing is just right.

Fixing this takes failures of g/388 from 1 in 5-10 runs to 1 in 100
runs. There is a change in patch 7 that I mention "I'm not sure how
this can happen here, but it's handled elsewhere like this" that
avoids a double remove of an aborted inode from the AIL that results
in an ASSERT failure. I *think* I now know how that can occur, but
fixing it is another set of patches, and it may be a recent
regression rather than a long standing issue.

Version 4:
- rebase on 5.17-rc8
- commit message fixups.
- more comments for non-obvious xlog_is_shutdown() use cases.

Version 3:
- https://lore.kernel.org/linux-xfs/20220315064241.3133751-1-david@fromorbit.com/
- added fixes for generic/388 failures.

Version 2:
- https://lore.kernel.org/linux-xfs/20220309015512.2648074-1-david@fromorbit.com/
- updated to 5.17-rc7
- tested by Willy.

Version 1:
- https://lore.kernel.org/linux-xfs/20220307053252.2534616-1-david@fromorbit.com/

