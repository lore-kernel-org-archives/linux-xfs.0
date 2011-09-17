Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8HDXeHS083935 for <xfs@oss.sgi.com>; Sat, 17 Sep 2011 08:33:40 -0500
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH] Return -EIO when xfs_vn_getattr() failed
Date: Sat, 17 Sep 2011 22:38:38 +0900
Message-ID: <20110917133838.27791.63070.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com

An attribute of inode can be fetched via xfs_vn_getattr() in XFS.
Currently it returns EIO, not negative value, when it failed.
As a result, the system call returns not negative value even though
an error occured. The stat(2), ls and mv commands cannot handle this
error and do not work correctly.

This patch fixes this bug, and returns -EIO, not EIO when an error
is detected in xfs_vn_getattr().

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
---

 fs/xfs/xfs_iops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b9c172b..33136d6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -457,7 +457,7 @@ xfs_vn_getattr(
 	trace_xfs_getattr(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return -XFS_ERROR(EIO);
 
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
