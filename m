Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCEBC43461
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70DDB611AF
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343630AbhDFL7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:59:39 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56138 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343632AbhDFL7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 07:59:39 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id B49D524FA
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 21:59:27 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-00Cns6-U0
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-007IOX-Ls
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: default attr fork size does not handle device inodes
Date:   Tue,  6 Apr 2021 21:59:22 +1000
Message-Id: <20210406115923.1738753-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210406115923.1738753-1-david@fromorbit.com>
References: <20210406115923.1738753-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=ugXx5VFp5meXLuiaRXkA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Device inodes have a non-default data fork size of 8 bytes
as checked/enforced by xfs_repair. xfs_default_attroffset() doesn't
handle this, so lets do a minor refactor so it does.

Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5574d345d066..414882ebcc8e 100644
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

