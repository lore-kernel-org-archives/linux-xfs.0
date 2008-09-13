Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:13:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DEDW5d018050
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:13:33 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 245DC1ADE34C
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:15:02 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id asjUoRFdxrE0s6T7 for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:15:02 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVts-0007yS-DX
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:15:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] XFS: use is_bad_inode() directly in xfs_reclaim_inode()
Date: Sun, 14 Sep 2008 00:15:00 +1000
Message-Id: <1221315300-30336-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1221315300-30336-1-git-send-email-david@fromorbit.com>
References: <1221315300-30336-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index d0354a6..22006b5 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -633,7 +633,7 @@ xfs_reclaim_inode(
 	 * In the case of a forced shutdown we rely on xfs_iflush() to
 	 * wait for the inode to be unpinned before returning an error.
 	 */
-	if (!VN_BAD(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
+	if (!is_bad_inode(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {
 		/* synchronize with xfs_iflush_done */
 		xfs_iflock(ip);
 		xfs_ifunlock(ip);
-- 
1.5.6
