Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DE1C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 00:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241627AbiCXAWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 20:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241621AbiCXAWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 20:22:38 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99BD874841
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 17:21:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DEB29533E91
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 11:21:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXBDt-0096Zw-Lm
        for linux-xfs@vger.kernel.org; Thu, 24 Mar 2022 11:21:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nXBDt-002z4a-JE
        for linux-xfs@vger.kernel.org;
        Thu, 24 Mar 2022 11:21:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/6 v2] xfs: more shutdown/recovery fixes
Date:   Thu, 24 Mar 2022 11:20:57 +1100
Message-Id: <20220324002103.710477-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623bb972
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=np4J-W9xBJrDHU-_H4sA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

V2 of this patchset has blown out from 2 to 6 patches because of
the sudden explosion of everyone having new problems with
shutdown/recovery behaviour. Patches 3-6 are new patches in the
series.

Patch 3 addresses the shutdown log force wakeup failure Brian
reported here:

https://lore.kernel.org/linux-xfs/YjneHEoFRDXu+EcA@bfoster/

Patches 4-6 fix a long standing shutdown race where
xfs_trans_commit() can abort modified log items and leave them
unpinned and dirty in memory while the log is still running,
allowing unjournalled, incomplete changes to be written back to disk
before the log is shut down. This race condition has been around
for a long time - it looks to be a zero-day bug in the original
shutdown code introduced in January 1997.

Fixing this requires the log to be able to shut down indepedently of
the mount (i.e. from log IO completion context), mount shutdowns to
be forced to wait until the log shutdown is complete and for log
shutdowns to also shut down the mount because otherwise shit just
breaks all over the place because random stuff errors out on log
shutdown and xfs_is_shutdown() is not set so those errors are
not handled appropriately by high level code. Or just assert fail
because the mount isn't shutdown down.

Once all that is done, we can fix xfs_trans_commit() and
xfs_trans_cancel() to not leak aborted items into memory until the
log is fully shut down.

This now makes recoveryloop largely stable on my test machines. I am
still seeing failures, but they are one-off, whacky things (like
weird udev/netlink memory freeing warnings) that I'm unable to
reproduce in any way.

-Dave.

Version 2:
- rework inode cluster buffer checks in inode item pushing (patch 1)
- clean up comments and separation of inode abort behaviour (p1)
- Fix shutdown callback/log force wakeup ordering issue (p3)
- Fix writeback of aborted, incomplete, unlogged changes during
  shutdown races (p4-6)

Version 1:
- https://lore.kernel.org/linux-xfs/20220321012329.376307-1-david@fromorbit.com/

