Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35373 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdEDN0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:18 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/8] xfs: use uuid_copy() helper to abstract uuid_t
Date: Thu,  4 May 2017 16:26:16 +0300
Message-Id: <1493904383-2187-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

uuid_t definition is about to change.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_inode_item.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d90e781..9967bd7 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -829,9 +829,7 @@ xfs_inode_item_format_convert(
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
@@ -846,9 +844,7 @@ xfs_inode_item_format_convert(
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
2.7.4

