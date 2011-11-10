Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZe2I126994 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:40 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 5/8] xfsprogs: Drop root inode refrerence in libxfs_umount()
Date: Thu, 10 Nov 2011 14:35:15 -0600
Message-Id: <8634b2514c7642f4cbcfdaf3b6852e129417c372.1320955676.git.aelder@sgi.com>
In-Reply-To: <1320957318-16269-1-git-send-email-aelder@sgi.com>
References: <1320957318-16269-1-git-send-email-aelder@sgi.com>
In-Reply-To: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Kevan Rehm <kfr@sgi.com>, Alex Elder <aelder@sgi.com>

From: Kevan Rehm <kfr@sgi.com>

Routine libxfs_umount() did not call libxfs_iput for the m_rootip
inode, so updates made to that inode could be lost.  This adds the
missing call, and re-initializes the m_rootip pointer to be null.

Since the root inode reference is now dropped by libxfs_umount(), it
should *not* be dropped in mkfs parseproto().

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxfs/init.c |    4 ++++
 mkfs/proto.c  |    3 ++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index ba44c9b..d34fd8c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -816,6 +816,10 @@ libxfs_umount(xfs_mount_t *mp)
 	int			agno;
 
 	libxfs_rtmount_destroy(mp);
+	if (mp->m_rootip) {
+		libxfs_iput(mp->m_rootip, 0);
+		mp->m_rootip = NULL;
+	}
 	libxfs_icache_purge();
 	libxfs_bcache_purge();
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 3021028..3f76862 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -571,7 +571,8 @@ parseproto(
 				break;
 			parseproto(mp, ip, fsxp, pp, name);
 		}
-		libxfs_iput(ip, 0);
+		if (!isroot)
+			libxfs_iput(ip, 0);
 		return;
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
