Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571ADC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 17:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiKARZc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 13:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiKARZb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 13:25:31 -0400
X-Greylist: delayed 382 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 10:25:31 PDT
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05A421B1DA
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 10:25:30 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 719662B44;
        Tue,  1 Nov 2022 12:17:21 -0500 (CDT)
Message-ID: <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
Date:   Tue, 1 Nov 2022 12:19:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Lukas Herbolt <lukas@herbolt.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfs: Print XFS UUID on mount and umount events.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Lukas Herbolt <lukas@herbolt.com>

As of now only device names are printed out over __xfs_printk().
The device names are not persistent across reboots which in case
of searching for origin of corruption brings another task to properly
identify the devices. This patch add XFS UUID upon every mount/umount
event which will make the identification much easier.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
[sandeen: rebase onto current upstream kernel]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

[resending this as it seems to have gotten lost, and looks to me like 
a trivial and useful enhancement to xfs logmessages. This was requested
(and authored!) by our support folks.]

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f02a0dd522b3..0141d9907d31 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -644,12 +644,14 @@ xfs_log_mount(
 	int		min_logfsbs;
 
 	if (!xfs_has_norecovery(mp)) {
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
 		ASSERT(xfs_is_readonly(mp));
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f029c6702dda..0ed477df6480 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1110,7 +1110,7 @@ xfs_fs_put_super(
 	if (!sb->s_fs_info)
 		return;
 
-	xfs_notice(mp, "Unmounting Filesystem");
+	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 


