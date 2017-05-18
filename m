Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754325AbdERG1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 02:27:17 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/23] xfs: use uuid_copy() helper to abstract uuid_t
Date: Thu, 18 May 2017 08:26:43 +0200
Message-Id: <20170518062705.25902-2-hch@lst.de>
In-Reply-To: <20170518062705.25902-1-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

uuid_t definition is about to change.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 08cb7d1a4a3a..013cc78d7daf 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -834,9 +834,7 @@ xfs_inode_item_format_convert(
 		in_f->ilf_dsize = in_f32->ilf_dsize;
 		in_f->ilf_ino = in_f32->ilf_ino;
 		/* copy biggest field of ilf_u */
-		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
-		       in_f32->ilf_u.ilfu_uuid.__u_bits,
-		       sizeof(uuid_t));
+		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f32->ilf_u.ilfu_uuid);
 		in_f->ilf_blkno = in_f32->ilf_blkno;
 		in_f->ilf_len = in_f32->ilf_len;
 		in_f->ilf_boffset = in_f32->ilf_boffset;
@@ -851,9 +849,7 @@ xfs_inode_item_format_convert(
 		in_f->ilf_dsize = in_f64->ilf_dsize;
 		in_f->ilf_ino = in_f64->ilf_ino;
 		/* copy biggest field of ilf_u */
-		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
-		       in_f64->ilf_u.ilfu_uuid.__u_bits,
-		       sizeof(uuid_t));
+		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f64->ilf_u.ilfu_uuid);
 		in_f->ilf_blkno = in_f64->ilf_blkno;
 		in_f->ilf_len = in_f64->ilf_len;
 		in_f->ilf_boffset = in_f64->ilf_boffset;
-- 
2.11.0

