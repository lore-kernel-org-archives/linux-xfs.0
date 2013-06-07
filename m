Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F095829E1E
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DEAA0304089
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wnWitLk6Yok557ji for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:34 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWi-0003wy-Jc
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWY-0001NF-G4
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 45/48] xfs_repair: fix btree block magic number mapping
Date: Fri,  7 Jun 2013 10:26:08 +1000
Message-Id: <1370564771-4929-46-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The magic numbers for generic btree blocks were modified some time
ago (before the kernel code was committed) but the xfs_repair
mapping code was not updated to match. It's no longer a simple
mapping, so just make the code a dense array and use the magic
number as the search key.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/btblock.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/db/btblock.c b/db/btblock.c
index 37b9903..34188db 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -26,65 +26,66 @@
 #include "bit.h"
 #include "init.h"
 
-
 /*
  * Definition of the possible btree block layouts.
  */
 struct xfs_db_btree {
+	uint32_t		magic;
 	size_t			block_len;
 	size_t			key_len;
 	size_t			rec_len;
 	size_t			ptr_len;
 } btrees[] = {
-	[/*0x424d415*/0] = { /* BMAP */
+	{	XFS_BMAP_MAGIC,
 		XFS_BTREE_LBLOCK_LEN,
 		sizeof(xfs_bmbt_key_t),
 		sizeof(xfs_bmbt_rec_t),
 		sizeof(__be64),
 	},
-	[/*0x4142544*/2] = { /* ABTB */
+	{	XFS_ABTB_MAGIC,
 		XFS_BTREE_SBLOCK_LEN,
 		sizeof(xfs_alloc_key_t),
 		sizeof(xfs_alloc_rec_t),
 		sizeof(__be32),
 	},
-	[/*0x4142544*/3] = { /* ABTC */
+	{	XFS_ABTC_MAGIC,
 		XFS_BTREE_SBLOCK_LEN,
 		sizeof(xfs_alloc_key_t),
 		sizeof(xfs_alloc_rec_t),
 		sizeof(__be32),
 	},
-	[/*0x4941425*/4] = { /* IABT */
+	{	XFS_IBT_MAGIC,
 		XFS_BTREE_SBLOCK_LEN,
 		sizeof(xfs_inobt_key_t),
 		sizeof(xfs_inobt_rec_t),
 		sizeof(__be32),
 	},
-	[/*0x424d415*/8] = { /* BMAP_CRC */
+	{	XFS_BMAP_CRC_MAGIC,
 		XFS_BTREE_LBLOCK_CRC_LEN,
 		sizeof(xfs_bmbt_key_t),
 		sizeof(xfs_bmbt_rec_t),
 		sizeof(__be64),
 	},
-	[/*0x4142544*/0xa] = { /* ABTB_CRC */
+	{	XFS_ABTB_CRC_MAGIC,
 		XFS_BTREE_SBLOCK_CRC_LEN,
 		sizeof(xfs_alloc_key_t),
 		sizeof(xfs_alloc_rec_t),
 		sizeof(__be32),
 	},
-	[/*0x414254*/0xb] = { /* ABTC_CRC */
+	{	XFS_ABTC_CRC_MAGIC,
 		XFS_BTREE_SBLOCK_CRC_LEN,
 		sizeof(xfs_alloc_key_t),
 		sizeof(xfs_alloc_rec_t),
 		sizeof(__be32),
 	},
-	[/*0x4941425*/0xc] = { /* IABT_CRC */
+	{	XFS_IBT_CRC_MAGIC,
 		XFS_BTREE_SBLOCK_CRC_LEN,
 		sizeof(xfs_inobt_key_t),
 		sizeof(xfs_inobt_rec_t),
 		sizeof(__be32),
 	},
-
+	{	0,
+	},
 };
 
 /*
@@ -93,8 +94,20 @@ struct xfs_db_btree {
  * We use the least significant bit of the magic number as index into
  * the array of block defintions.
  */
-#define block_to_bt(bb) \
-	(&btrees[be32_to_cpu((bb)->bb_magic) & 0xf])
+static struct xfs_db_btree *
+block_to_bt(
+	struct xfs_btree_block	*bb)
+{
+	struct xfs_db_btree *btp = &btrees[0];
+
+	do {
+		if (be32_to_cpu((bb)->bb_magic) == btp->magic)
+			return btp;
+		btp++;
+	} while (btp->magic != 0);
+
+	return NULL;
+}
 
 /* calculate max records.  Only for non-leaves. */
 static int
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
