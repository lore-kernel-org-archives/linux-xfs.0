Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43004 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbdLAWMf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 17:12:35 -0500
Subject: [PATCH 1/4] xfs: add scrub to XFS_BUILD_OPTIONS
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f5769e20-970a-53f5-4fc7-2afd11304ce2@sandeen.net>
Date: Fri, 1 Dec 2017 16:12:34 -0600
MIME-Version: 1.0
In-Reply-To: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Advertise this config option along with the others.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index fcc5dfc..8cee8e8 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -44,6 +44,12 @@
 # define XFS_REALTIME_STRING
 #endif
 
+#ifdef CONFIG_XFS_ONLINE_SCRUB
+# define XFS_SCRUB_STRING	"scrub, "
+#else
+# define XFS_SCRUB_STRING
+#endif
+
 #ifdef DEBUG
 # define XFS_DBG_STRING		"debug"
 #else
@@ -54,6 +60,7 @@
 #define XFS_BUILD_OPTIONS	XFS_ACL_STRING \
 				XFS_SECURITY_STRING \
 				XFS_REALTIME_STRING \
+				XFS_SCRUB_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
 struct xfs_inode;

