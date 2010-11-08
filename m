Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8KdBt0118145 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 14:39:11 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B04B1C24E23
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 12:40:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fs5YTeUvgdGdh6Oc for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 12:40:38 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 6/6] Gfs2: fail if we try to use hole punch
Date: Mon,  8 Nov 2010 15:32:07 -0500
Message-Id: <1289248327-16308-6-git-send-email-josef@redhat.com>
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

Gfs2 doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/gfs2/ops_inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 12cbea7..93ecc9f 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1439,6 +1439,10 @@ static long gfs2_fallocate(struct inode *inode, int mode, loff_t offset,
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode & FALLOC_FL_KEEP_SIZE))
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
