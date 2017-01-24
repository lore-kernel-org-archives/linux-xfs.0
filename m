Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34032 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdAXRI4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 12:08:56 -0500
Date: Tue, 24 Jan 2017 09:08:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs/122: reduce xfs_dsb_t size
Message-ID: <20170124170819.GP14033@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

We're not going to do reverse-mapping on the realtime device for
some time, so let's fix xfs/122 in the meantime.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 67f7698..168cfd5 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -138,7 +138,7 @@ sizeof(xfs_dir2_sf_off_t) = 2
 sizeof(xfs_disk_dquot_t) = 104
 sizeof(xfs_dq_logformat_t) = 24
 sizeof(xfs_dqblk_t) = 136
-sizeof(xfs_dsb_t) = 272
+sizeof(xfs_dsb_t) = 264
 sizeof(xfs_efd_log_format_32_t) = 28
 sizeof(xfs_efd_log_format_64_t) = 32
 sizeof(xfs_efi_log_format_32_t) = 28
