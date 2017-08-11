Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41572 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753517AbdHKTpH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 15:45:07 -0400
Subject: [PATCH 2/2 V2] xfs: toggle readonly state around xfs_log_mount_finish
From: Eric Sandeen <sandeen@sandeen.net>
References: <e98c7179-fdb0-1cc7-544b-c55489451db5@redhat.com>
 <6c81fb42-4601-dc0f-6ebb-a73c7c40aaa4@sandeen.net>
Message-ID: <537e1ca3-60be-8182-7130-dff3a1059078@sandeen.net>
Date: Fri, 11 Aug 2017 12:45:05 -0700
MIME-Version: 1.0
In-Reply-To: <6c81fb42-4601-dc0f-6ebb-a73c7c40aaa4@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---

V2: bool "readonly" per Christoph's request

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0bd1341..ca56d85 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -743,16 +743,23 @@
 	struct xfs_mount	*mp)
 {
 	int	error = 0;
+	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
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
 


