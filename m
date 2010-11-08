Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8Kd8VU118117 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 14:39:08 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C272F139B9E9
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 12:40:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lK29UnrrVjQJLyaC for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 12:40:35 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/6] Ocfs2: handle hole punching via fallocate properly
Date: Mon,  8 Nov 2010 15:32:04 -0500
Message-Id: <1289248327-16308-3-git-send-email-josef@redhat.com>
In-Reply-To: <1289248327-16308-1-git-send-email-josef@redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
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
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com, cluster-devel@redhat.com

This patch just makes ocfs2 use its UNRESERVP ioctl when we get the hole punch
flag in fallocate.  I didn't test it, but it seems simple enough.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ocfs2/file.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 77b4c04..ad23a18 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1992,6 +1992,7 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_space_resv sr;
 	int change_size = 1;
+	int cmd = OCFS2_IOC_RESVSP64;
 
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
@@ -2002,12 +2003,15 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	if (mode & FALLOC_FL_KEEP_SIZE)
 		change_size = 0;
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = OCFS2_IOC_UNRESVSP64;
+
 	sr.l_whence = 0;
 	sr.l_start = (s64)offset;
 	sr.l_len = (s64)len;
 
-	return __ocfs2_change_file_space(NULL, inode, offset,
-					 OCFS2_IOC_RESVSP64, &sr, change_size);
+	return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
+					 change_size);
 }
 
 int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
