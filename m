Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK9FDBI133655 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 03:15:13 -0600
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id aYyznkGLyruohyII
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:22 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id jt11so4740098pbb.26
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:17:22 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/4][RFC] btrfs: remove duplicated check from btrfs_fallocate
Date: Tue, 20 Nov 2012 17:29:44 +0800
Message-Id: <1353403785-3489-4-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
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
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

Remove a sanity check from btrfs_fallocate because vfs has already checked it.

Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/btrfs/file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..fd260a0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1999,10 +1999,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 	alloc_start = offset & ~mask;
 	alloc_end =  (offset + len + mask) & ~mask;
 
-	/* Make sure we aren't being give some crap mode */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
-
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return btrfs_punch_hole(inode, offset, len);
 
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
