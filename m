Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 06DC37F4E
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8714CAC00D
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iLEnzP8FmpVn2x1H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OENAWW002636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:11 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENAaZ030723
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 07/18] xfs: handle sparse inode chunks in icreate log recovery
Date: Thu, 24 Jul 2014 10:22:57 -0400
Message-Id: <1406211788-63206-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Recovery of icreate transactions assumes hardcoded values for the inode
count and chunk length.

Sparse inode chunks are allocated in units of the cluster size. Update
the icreate validity checks to allow for appropriately sized inode
chunks and verify the inode count matches what is expected based on the
extent length rather than assuming a hardcoded count.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cbe782a..5994fb5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3213,12 +3213,19 @@ xlog_recover_do_icreate_pass2(
 		return -EINVAL;
 	}
 
-	/* existing allocation is fixed value */
-	ASSERT(count == mp->m_ialloc_inos);
-	ASSERT(length == mp->m_ialloc_blks);
-	if (count != mp->m_ialloc_inos ||
-	     length != mp->m_ialloc_blks) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count 2");
+	/* inode chunk is either full or sparse (cluster sized) */
+	if (length != mp->m_ialloc_blks &&
+	    length != xfs_icluster_size_fsb(mp)) {
+		xfs_warn(log->l_mp,
+			 "%s: unsupported chunk length", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/* verify inode count is consistent with extent length */
+	if ((count >> mp->m_sb.sb_inopblog) != length) {
+		xfs_warn(log->l_mp,
+			 "%s: inconsistent inode count and chunk length",
+			 __FUNCTION__);
 		return -EINVAL;
 	}
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
