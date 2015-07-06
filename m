Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 160D17F54
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:17:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00055304032
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 11:17:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tyX8r5CVO2khIomf for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 11:17:21 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4273363CDA11
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:17:21 -0500 (CDT)
Message-ID: <559AC630.2090101@sandeen.net>
Date: Mon, 06 Jul 2015 13:17:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] metadump: handle multi-block directories
References: <559AC5AA.5040900@sandeen.net>
In-Reply-To: <559AC5AA.5040900@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

commit 6e79202b metadump: fully support discontiguous directory blocks

assembled a buffer from multiple dir blocks, and we can use that in
obfuscate_dir_data_block() to continue past the first filesystem block
and continue obfuscating the entire thing.

Without this, anything after the first block was skipped, and
remained as cleartext.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/metadump.c b/db/metadump.c
index 5baec6c..33f3ec9 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1152,9 +1152,6 @@ obfuscate_dir_data_block(
 
 	datahdr = (struct xfs_dir2_data_hdr *)block;
 
-	if (offset % mp->m_dir_geo->fsbcount != 0)
-		return;	/* corrupted, leave it alone */
-
 	if (is_block_format) {
 		xfs_dir2_leaf_entry_t	*blp;
 		xfs_dir2_block_tail_t	*btp;
@@ -1187,7 +1184,7 @@ obfuscate_dir_data_block(
 
 	dir_offset = M_DIROPS(mp)->data_entry_offset;
 	ptr = block + dir_offset;
-	endptr = block + mp->m_sb.sb_blocksize;
+	endptr = block + mp->m_dir_geo->blksize;
 
 	while (ptr < endptr && dir_offset < end_of_data) {
 		xfs_dir2_data_entry_t	*dep;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
