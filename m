Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48276 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754745AbeCGXcc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 18:32:32 -0500
Subject: [PATCH 1/2] xfs: always check for and process unlinked inodes on
 mount
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d35d1067-a6f6-09be-9c4c-3e08a3bec3be@sandeen.net>
Date: Wed, 7 Mar 2018 17:32:29 -0600
MIME-Version: 1.0
In-Reply-To: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Process any unlinked inodes unconditionally; this allows us to
skip dirtying the log on frozen filesystems and still have
proper recovery on the next mount.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1937a93..2a645c0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5854,8 +5854,6 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 		 */
 		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 
-		xlog_recover_process_iunlinks(log);
-
 		xlog_recover_check_summary(log);
 
 		xfs_notice(log->l_mp, "Ending recovery (logdev: %s)",
@@ -5865,6 +5863,14 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 	} else {
 		xfs_info(log->l_mp, "Ending clean mount");
 	}
+
+	/*
+	 * Process any unlinked inodes unconditionally, this allows us to
+	 * skip dirtying the log on frozen filesystems and still have
+	 * proper recovery on the next mount.
+	 */
+	xlog_recover_process_iunlinks(log);
+
 	return 0;
 }
 

