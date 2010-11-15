Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFHDM7N149326 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 11:13:23 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F7B818065C
	for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 09:14:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P2xSxT6sERgvrzH3 for
	<xfs@oss.sgi.com>; Mon, 15 Nov 2010 09:14:54 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 6/6] Gfs2: fail if we try to use hole punch
Date: Mon, 15 Nov 2010 12:05:23 -0500
Message-Id: <1289840723-3056-7-git-send-email-josef@redhat.com>
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

Gfs2 doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/gfs2/ops_inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 12cbea7..65cb5f6 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1439,6 +1439,10 @@ static long gfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
 	offset = (offset >> sdp->sd_sb.sb_bsize_shift) <<
 		 sdp->sd_sb.sb_bsize_shift;
 
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
