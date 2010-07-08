Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o68JI5k7058911 for <xfs@oss.sgi.com>; Thu, 8 Jul 2010 14:18:05 -0500
Received: from mail-yx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6142815BAD53
	for <xfs@oss.sgi.com>; Thu,  8 Jul 2010 12:26:35 -0700 (PDT)
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	IJExBRLqbFdfwA9A for <xfs@oss.sgi.com>;
	Thu, 08 Jul 2010 12:26:35 -0700 (PDT)
Received: by yxm34 with SMTP id 34so254202yxm.26
	for <xfs@oss.sgi.com>; Thu, 08 Jul 2010 12:20:55 -0700 (PDT)
From: Peter Watkins <treestem@gmail.com>
Subject: [PATCH] Check block magic number so we scan only valid blocks.
Date: Thu,  8 Jul 2010 15:20:50 -0400
Message-Id: <1278616850-32451-1-git-send-email-treestem@gmail.com>
In-Reply-To: <20100707235218.GA30851@infradead.org>
References: <20100707235218.GA30851@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Peter Watkins <treestem@gmail.com>

OK, thanks for taking a look.

Here's the complete patch in case anyone is interested.

 -Peter

Signed-off-by: Peter Watkins <treestem@gmail.com>
---
 db/freesp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/db/freesp.c b/db/freesp.c
index e1902c6..c4dabad 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -286,6 +286,9 @@ scanfunc_bno(
 	xfs_alloc_ptr_t		*pp;
 	xfs_alloc_rec_t		*rp;
 
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTB_MAGIC)
+		return;
+
 	if (level == 0) {
 		rp = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
@@ -310,6 +313,9 @@ scanfunc_cnt(
 	xfs_alloc_ptr_t		*pp;
 	xfs_alloc_rec_t		*rp;
 
+	if (be32_to_cpu(block->bb_magic) != XFS_ABTC_MAGIC)
+		return;
+
 	if (level == 0) {
 		rp = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
-- 
1.6.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
