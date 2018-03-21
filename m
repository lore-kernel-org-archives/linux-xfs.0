Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754050AbeCUXYJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 19:24:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1ACD8764A
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 23:24:09 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4AB618BAC
        for <linux-xfs@vger.kernel.org>; Wed, 21 Mar 2018 23:24:09 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] metadump/restore: don't use errno after fwrite/fread failures
Message-ID: <f40f7d1b-31b5-e5a0-4077-9480530ebf0d@redhat.com>
Date: Wed, 21 Mar 2018 18:24:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

fread/fwrite don't set errno, so printing out strerror(errno)
after a failure leads to incorrect and confusing messages:

# xfs_mdrestore pre_repair.meta pre_repair.img
xfs_mdrestore: error reading from file: Success

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/metadump.c b/db/metadump.c
index 9d62958..231adc6 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -161,7 +161,7 @@ write_index(void)
 	 */
 	metablock->mb_count = cpu_to_be16(cur_index);
 	if (fwrite(metablock, (cur_index + 1) << BBSHIFT, 1, outf) != 1) {
-		print_warning("error writing to file: %s", strerror(errno));
+		print_warning("error writing to target file");
 		return -errno;
 	}
 
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c9d4b0c..262a385 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -93,15 +93,14 @@ perform_restore(
 	block_buffer = (char *)metablock + block_size;
 
 	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
-		fatal("error reading from file: %s\n", strerror(errno));
+		fatal("error reading from metadump file\n");
 
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
 
-	if (fread(block_buffer, mb_count << mbp->mb_blocklog,
-			1, src_f) != 1)
-		fatal("error reading from file: %s\n", strerror(errno));
+	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
+		fatal("error reading from metadump file\n");
 
 	libxfs_sb_from_disk(&sb, (xfs_dsb_t *)block_buffer);
 
@@ -157,7 +156,7 @@ perform_restore(
 			break;
 
 		if (fread(metablock, block_size, 1, src_f) != 1)
-			fatal("error reading from file: %s\n", strerror(errno));
+			fatal("error reading from metadump file\n");
 
 		mb_count = be16_to_cpu(metablock->mb_count);
 		if (mb_count == 0)
@@ -167,7 +166,7 @@ perform_restore(
 
 		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
 								1, src_f) != 1)
-			fatal("error reading from file: %s\n", strerror(errno));
+			fatal("error reading from metadump file\n");
 
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
 	}
@@ -253,7 +252,7 @@ main(
 	}
 
 	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
-		fatal("error reading from file: %s\n", strerror(errno));
+		fatal("error reading from metadump file\n");
 	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
 		fatal("specified file is not a metadata dump\n");
 

