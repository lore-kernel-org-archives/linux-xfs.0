Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 312237F60
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 105AD8F8049
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:29 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 4bAUAWvorwdYDwnT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:27 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/20] xfs: update the superblock using a synchronous
	transaction in growfs
Date: Thu, 22 Jan 2015 12:10:03 +0100
Message-Id: <1421925006-24231-18-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Growfs updates the secondary superblocks using synchronous unlogged
buffer writes after committing the updates to the primary superblock.

Mark the transaction to the primary superblock as synchronous so that
we guarantee it is committed to disk before we update the secondary
superblocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index fdc6422..74c6211 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -488,6 +488,7 @@ xfs_growfs_data_private(
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, nfree);
 	if (dpct)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
+	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
 	if (error)
 		return error;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
