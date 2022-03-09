Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34520C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 01:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiCIB4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCIB4O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 20:56:14 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D50DB3B2B1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 17:55:16 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1708A530D32
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 12:55:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRlXn-003DPN-45
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 12:55:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRlXn-00B720-2Z
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 12:55:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: PATCH [0/4 V2] xfs: log recovery hang fixes
Date:   Wed,  9 Mar 2022 12:55:08 +1100
Message-Id: <20220309015512.2648074-1-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62280904
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=5owzy4Vl2kX1WQJ_INUA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

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

Version 2:
- updated to 5.17-rc7
- tested by Willy.

Version 1:
- https://lore.kernel.org/linux-xfs/20220307053252.2534616-1-david@fromorbit.com/

