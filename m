Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80F6C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 01:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbiC3BMh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 21:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241265AbiC3BMh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 21:12:37 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19C2B427E2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 18:10:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 593B510E5281
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 12:10:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZMrK-00BVQ5-8W
        for linux-xfs@vger.kernel.org; Wed, 30 Mar 2022 12:10:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nZMrK-005VF0-6v
        for linux-xfs@vger.kernel.org;
        Wed, 30 Mar 2022 12:10:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/8 v3] xfs: more shutdown/recovery fixes
Date:   Wed, 30 Mar 2022 12:10:40 +1100
Message-Id: <20220330011048.1311625-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6243ae1b
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=QC5Hdu5f_hCQNi3KR_QA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Here is an updated series of aggregated log fixes for recently
discovered shutdown bugs, log recovery issues and performance
regressions. See the change log for previous versions of this
patchset.

V3 of this patchset contains 8 patches because the extra fix
for the previous version (patch 7) and sweeping the async cache
flush fix into it (patch 8). There are small changes to comments
and commit messages, but otherwise is the same as version 2.

Cheers,

Dave.

Version 3:
- various typo and comment fixes.
- new patch to address a shutdown hang during log recovery (patch 7)
- sweep up fix for async cache flush regressions into the series
  (patch 8)

Version 2:
- https://lore.kernel.org/linux-xfs/20220324002103.710477-1-david@fromorbit.com/
- rework inode cluster buffer checks in inode item pushing (patch 1)
- clean up comments and separation of inode abort behaviour (p1)
- Fix shutdown callback/log force wakeup ordering issue (p3)
- Fix writeback of aborted, incomplete, unlogged changes during
  shutdown races (p4-6)

Version 1:
- https://lore.kernel.org/linux-xfs/20220321012329.376307-1-david@fromorbit.com/


