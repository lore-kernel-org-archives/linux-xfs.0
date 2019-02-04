Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729810AbfBDQyi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:54:38 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 10/10] xfs: fix inverted return from xfs_btree_sblock_verify_crc
Date: Mon,  4 Feb 2019 08:54:27 -0800
Message-Id: <20190204165427.23607-11-mcgrof@kernel.org>
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
References: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

commit 7d048df4e9b05ba89b74d062df59498aa81f3785 upstream.

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
