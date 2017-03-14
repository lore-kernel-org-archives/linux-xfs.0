Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34144 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750930AbdCNXX7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Mar 2017 19:23:59 -0400
Subject: [PATCH 2/2 V2] xfs: toggle readonly state around xfs_log_mount_finish
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <74f6a009-211c-617a-2d6f-0a115ceb366b@sandeen.net>
Date: Tue, 14 Mar 2017 18:23:57 -0500
MIME-Version: 1.0
In-Reply-To: <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

When we do log recovery on a readonly mount, unlinked inode
processing does not happen due to the readonly checks in
xfs_inactive(), which are trying to prevent any I/O on a
readonly mount.

This is misguided - we do I/O on readonly mounts all the time,
for consistency; for example, log recovery.  So do the same
RDONLY flag twiddling around xfs_log_mount_finish() as we
do around xfs_log_mount(), for the same reason.

This all cries out for a big rework but for now this is a
simple fix to an obvious problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: And now for something completely different...

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 62176b8..374edc1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -743,16 +743,23 @@
 	struct xfs_mount	*mp)
 {
 	int	error = 0;
+	int	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
+	} else if (readonly) {
+		/* Allow unlinked processing to proceed */
+		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 	}
 
 	error = xlog_recover_finish(mp->m_log);
 	if (!error)
 		xfs_log_work_queue(mp);
 
+	if (readonly)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+
 	return error;
 }
 

