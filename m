Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7950C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 05:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2C2E61999
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 05:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhC3Fbe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 01:31:34 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55901 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhC3FbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 01:31:03 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 566911AE866
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 16:31:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-008N4f-Cn
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-005cnn-5T
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: default attr fork size does not handle device inodes
Date:   Tue, 30 Mar 2021 16:30:58 +1100
Message-Id: <20210330053059.1339949-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210330053059.1339949-1-david@fromorbit.com>
References: <20210330053059.1339949-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=ugXx5VFp5meXLuiaRXkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Device inodes have a non-default data fork size of 8 bytes
as checked/enforced by xfs_repair. xfs_default_attroffset() doesn't
handle this, so lets do a minor refactor so it does.

Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2f72849c05f9..16c8730c140f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -195,6 +195,9 @@ xfs_default_attroffset(
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			offset;
 
+	if (ip->i_df.if_format == XFS_DINODE_FMT_DEV)
+		return roundup(sizeof(xfs_dev_t), 8);
+
 	if (mp->m_sb.sb_inodesize == 256)
 		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	else
@@ -1036,16 +1039,18 @@ xfs_bmap_set_attrforkoff(
 	int			size,
 	int			*version)
 {
+	int			default_size = xfs_default_attroffset(ip) >> 3;
+
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_DEV:
-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		ip->i_d.di_forkoff = default_size;
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
 		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
 		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
+			ip->i_d.di_forkoff = default_size;
 		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
 			*version = 2;
 		break;
-- 
2.31.0

