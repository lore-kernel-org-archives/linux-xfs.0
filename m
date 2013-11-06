Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 773467F89
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 05:45:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2E90AC002
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 03:45:38 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JNXwAOMHbp5CBLQd (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 03:45:37 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Ve1YG-0004pS-S3
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 11:45:36 +0000
Date: Wed, 6 Nov 2013 03:45:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix the comment explaining xfs_trans_dqlockedjoin
Message-ID: <20131106114536.GA18548@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index cd2a10e..4117286 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -295,8 +295,8 @@ xfs_trans_mod_dquot(
 /*
  * Given an array of dqtrx structures, lock all the dquots associated and join
  * them to the transaction, provided they have been modified.  We know that the
- * highest number of dquots of one type - usr, grp OR prj - involved in a
- * transaction is 2 so we don't need to make this very generic.
+ * highest number of dquots of one type - usr, grp and prj - involved in a
+ * transaction is 3 so we don't need to make this very generic.
  */
 STATIC void
 xfs_trans_dqlockedjoin(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
