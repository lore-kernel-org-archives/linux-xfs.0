Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59838 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753799AbeCVOlp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:41:45 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C8B0A11649
        for <linux-xfs@vger.kernel.org>; Thu, 22 Mar 2018 09:41:27 -0500 (CDT)
Subject: [PATCH V2] metadump/restore: don't use errno after fwrite/fread
 failures
References: <f40f7d1b-31b5-e5a0-4077-9480530ebf0d@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7e510e30-3922-98d7-75c9-19f8e90610d0@sandeen.net>
Date: Thu, 22 Mar 2018 09:41:43 -0500
MIME-Version: 1.0
In-Reply-To: <f40f7d1b-31b5-e5a0-4077-9480530ebf0d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

fread/fwrite don't set errno, so printing out strerror(errno)
after a failure leads to incorrect and confusing messages:

# xfs_mdrestore pre_repair.meta pre_repair.img
xfs_mdrestore: error reading from file: Success

Don't return unset errno from write_index, either.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: don't return errno, either.

diff --git a/db/metadump.c b/db/metadump.c
index 9d62958..d33f901 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -161,8 +161,8 @@ write_index(void)
 	 */
 	metablock->mb_count = cpu_to_be16(cur_index);
 	if (fwrite(metablock, (cur_index + 1) << BBSHIFT, 1, outf) != 1) {
-		print_warning("error writing to file: %s", strerror(errno));
-		return -errno;
+		print_warning("error writing to target file");
+		return -1;
 	}
 
 	memset(block_index, 0, num_indices * sizeof(__be64));
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
 

