Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDB8C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 05:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7AF061935
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 05:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhC3Fbd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 01:31:33 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45928 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230224AbhC3FbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 01:31:04 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 578061041C28
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 16:31:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-008N4J-B7
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-005cnh-3p
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature awareness
Date:   Tue, 30 Mar 2021 16:30:56 +1100
Message-Id: <20210330053059.1339949-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210330053059.1339949-1-david@fromorbit.com>
References: <20210330053059.1339949-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=6qBOr3qjZ7zTj1CIAF0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The pitfalls of regression testing on a machine without realising
that selinux was disabled. Only set the attr fork during inode
allocation if the attr feature bits are already set on the
superblock.

Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c09bb39baeea..3b516ab7f22b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -887,7 +887,7 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs) {
+	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
 		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
 	}
-- 
2.31.0

