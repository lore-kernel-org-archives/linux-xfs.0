Return-Path: linux-xfs-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbfAaSJe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:09:34 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 10/10] xfs: fix inverted return from xfs_btree_sblock_verify_crc
Date: Thu, 31 Jan 2019 10:09:19 -0800
Message-Id: <20190131180919.2500-11-mcgrof@kernel.org>
In-Reply-To: <20190131180919.2500-1-mcgrof@kernel.org>
References: <20190131180919.2500-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: amir73il@gmail.com, hch@infradead.org, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

xfs_btree_sblock_verify_crc is a bool so should not be returning
a failaddr_t; worse, if xfs_log_check_lsn fails it returns
__this_address which looks like a boolean true (i.e. success)
to the caller.

(interestingly xfs_btree_lblock_verify_crc doesn't have the issue)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 34c6d7bd4d18..bbdae2b4559f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -330,7 +330,7 @@ xfs_btree_sblock_verify_crc(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
-			return __this_address;
+			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
 	}
 
-- 
2.18.0
