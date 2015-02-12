Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70A107F5A
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 12:17:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46E86304062
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 10:17:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gHfh0tViitix7muR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 10:17:29 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1CIHTqg020189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1CIHSHd025880
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 11/18] xfs: handle sparse inode chunks in icreate log
	recovery
Date: Thu, 12 Feb 2015 13:17:18 -0500
Message-Id: <1423765045-15791-12-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
References: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
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

Sparse inode chunks are allocated in units of m_ialloc_min_blks. Update
the icreate validity checks to allow for appropriately sized inode
chunks and verify the inode count matches what is expected based on the
extent length rather than assuming a hardcoded count.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ecc73d5..74d504b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3068,12 +3068,22 @@ xlog_recover_do_icreate_pass2(
 		return -EINVAL;
 	}
 
-	/* existing allocation is fixed value */
-	ASSERT(count == mp->m_ialloc_inos);
-	ASSERT(length == mp->m_ialloc_blks);
-	if (count != mp->m_ialloc_inos ||
-	     length != mp->m_ialloc_blks) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count 2");
+	/*
+	 * The inode chunk is either full or sparse and we only support
+	 * m_ialloc_min_blks sized sparse allocations at this time.
+	 */
+	if (length != mp->m_ialloc_blks &&
+	    length != mp->m_ialloc_min_blks) {
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
