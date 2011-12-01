Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1NS15f033852 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 17:28:01 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 3/6] xfs: Return -EIO when xfs_vn_getattr() failed
Date: Thu,  1 Dec 2011 17:27:41 -0600
Message-Id: <1322782064-1723-4-git-send-email-bpm@sgi.com>
In-Reply-To: <1322782064-1723-1-git-send-email-bpm@sgi.com>
References: <1322782064-1723-1-git-send-email-bpm@sgi.com>
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
To: stable@vger.kernel.org, greg@kroah.com
Cc: bpm@sgi.com, Alex Elder <aelder@sgi.com>, Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, xfs@oss.sgi.com

From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

commit ed32201e65e15f3e6955cb84cbb544b08f81e5a5 upstream.

An attribute of inode can be fetched via xfs_vn_getattr() in XFS.
Currently it returns EIO, not negative value, when it failed.  As a
result, the system call returns not negative value even though an
error occured. The stat(2), ls and mv commands cannot handle this
error and do not work correctly.

This patch fixes this bug, and returns -EIO, not EIO when an error
is detected in xfs_vn_getattr().

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_iops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 673704f..474920b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -465,7 +465,7 @@ xfs_vn_getattr(
 	trace_xfs_getattr(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return -XFS_ERROR(EIO);
 
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;
-- 
1.7.8.rc4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
