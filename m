Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F10C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 15:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FB8610CB
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 15:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbhESPZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 11:25:30 -0400
Received: from relay.herbolt.com ([37.46.208.54]:50512 "EHLO relay.herbolt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346350AbhESPZ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 11:25:29 -0400
Received: from ip-78-102-244-147.net.upcbroadband.cz (ip-78-102-244-147.net.upcbroadband.cz [78.102.244.147])
        by relay.herbolt.com (Postfix) with ESMTPSA id 0FA971034149;
        Wed, 19 May 2021 17:24:07 +0200 (CEST)
Received: from catweazle.local.lc (unknown [172.168.25.10])
        by mail.herbolt.com (Postfix) with ESMTPSA id 6A1BCD34A0A;
        Wed, 19 May 2021 17:24:06 +0200 (CEST)
From:   Lukas Herbolt <lukas@herbolt.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH RFC v2] xfs: Print XFS UUID on mount and umount events.
Date:   Wed, 19 May 2021 17:22:48 +0200
Message-Id: <20210519152247.1853357-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As of now only device names are printed out over __xfs_printk().
The device names are not persistent across reboots which in case
of searching for origin of corruption brings another task to properly
identify the devices. This patch add XFS UUID upon every mount/umount
event which will make the identification much easier.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
V2: Drop void casts and fix long lines

 fs/xfs/xfs_log.c   | 10 ++++++----
 fs/xfs/xfs_super.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 06041834daa31..8f4f671fd80d5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -570,12 +570,14 @@ xfs_log_mount(
 	int		min_logfsbs;
 
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
-		xfs_notice(mp, "Mounting V%d Filesystem",
-			   XFS_SB_VERSION_NUM(&mp->m_sb));
+		xfs_notice(mp, "Mounting V%d Filesystem %pU",
+			   XFS_SB_VERSION_NUM(&mp->m_sb),
+			   &mp->m_sb.sb_uuid);
 	} else {
 		xfs_notice(mp,
-"Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
-			   XFS_SB_VERSION_NUM(&mp->m_sb));
+"Mounting V%d filesystem %pU in no-recovery mode. Filesystem will be inconsistent.",
+			   XFS_SB_VERSION_NUM(&mp->m_sb),
+			   &mp->m_sb.sb_uuid);
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e5e0713bebcd8..a4b8a5ad8039f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1043,7 +1043,7 @@ xfs_fs_put_super(
 	if (!sb->s_fs_info)
 		return;
 
-	xfs_notice(mp, "Unmounting Filesystem");
+	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
-- 
2.31.1

