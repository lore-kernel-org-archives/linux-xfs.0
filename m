Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFHDJ7u149272 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 11:13:20 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3178513BF7EB
	for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 09:14:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NLEDU21znouAkqte for
	<xfs@oss.sgi.com>; Mon, 15 Nov 2010 09:14:51 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/6] fs: add hole punching to fallocate
Date: Mon, 15 Nov 2010 12:05:18 -0500
Message-Id: <1289840723-3056-2-git-send-email-josef@redhat.com>
In-Reply-To: <1289840723-3056-1-git-send-email-josef@redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
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
To: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com

Hole punching has already been implemented by XFS and OCFS2, and has the
potential to be implemented on both BTRFS and EXT4 so we need a generic way to
get to this feature.  The simplest way in my mind is to add FALLOC_FL_PUNCH_HOLE
to fallocate() since it already looks like the normal fallocate() operation.
I've tested this patch with XFS and BTRFS to make sure XFS did what it's
supposed to do and that BTRFS failed like it was supposed to.  Thank you,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/open.c              |    2 +-
 include/linux/falloc.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 4197b9e..ab8dedf 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
+	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
 		return -EOPNOTSUPP;
 
 	if (!(file->f_mode & FMODE_WRITE))
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 3c15510..851cba2 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -2,6 +2,7 @@
 #define _FALLOC_H_
 
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
+#define FALLOC_FL_PUNCH_HOLE	0X02 /* de-allocates range */
 
 #ifdef __KERNEL__
 
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
