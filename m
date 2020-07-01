Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39FDC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 07:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB7E52074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 07:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgGAHvt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 03:51:49 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60493 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728294AbgGAHvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 03:51:49 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 7D8C9D7B589
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 17:51:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqXWy-0003uZ-KS
        for linux-xfs@vger.kernel.org; Wed, 01 Jul 2020 17:51:44 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jqXWy-00B3ED-Br
        for linux-xfs@vger.kernel.org; Wed, 01 Jul 2020 17:51:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix quota off hang from non-blocking flush
Date:   Wed,  1 Jul 2020 17:51:44 +1000
Message-Id: <20200701075144.2633976-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=3FCIVe6-SOTBwgIUsdsA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Found by inspection after having xfs/305 hang 1 in ~50 iterations
in a quotaoff operation:

[ 8872.301115] xfs_quota       D13888 92262  91813 0x00004002
[ 8872.302538] Call Trace:
[ 8872.303193]  __schedule+0x2d2/0x780
[ 8872.304108]  ? do_raw_spin_unlock+0x57/0xd0
[ 8872.305198]  schedule+0x6e/0xe0
[ 8872.306021]  schedule_timeout+0x14d/0x300
[ 8872.307060]  ? __next_timer_interrupt+0xe0/0xe0
[ 8872.308231]  ? xfs_qm_dqusage_adjust+0x200/0x200
[ 8872.309422]  schedule_timeout_uninterruptible+0x2a/0x30
[ 8872.310759]  xfs_qm_dquot_walk.isra.0+0x15a/0x1b0
[ 8872.311971]  xfs_qm_dqpurge_all+0x7f/0x90
[ 8872.313022]  xfs_qm_scall_quotaoff+0x18d/0x2b0
[ 8872.314163]  xfs_quota_disable+0x3a/0x60
[ 8872.315179]  kernel_quotactl+0x7e2/0x8d0
[ 8872.316196]  ? __do_sys_newstat+0x51/0x80
[ 8872.317238]  __x64_sys_quotactl+0x1e/0x30
[ 8872.318266]  do_syscall_64+0x46/0x90
[ 8872.319193]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 8872.320490] RIP: 0033:0x7f46b5490f2a
[ 8872.321414] Code: Bad RIP value.

Returning -EAGAIN from xfs_qm_dqpurge() without clearing the
XFS_DQ_FREEING flag means the xfs_qm_dqpurge_all() code can never
free the dquot, and we loop forever waiting for the XFS_DQ_FREEING
flag to go away on the dquot that leaked it via -EAGAIN.

Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d6cd83317344..938023dd8ce5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -148,6 +148,7 @@ xfs_qm_dqpurge(
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		} else if (error == -EAGAIN) {
+			dqp->dq_flags &= ~XFS_DQ_FREEING;
 			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
-- 
2.26.2.761.g0e0b3e54be

