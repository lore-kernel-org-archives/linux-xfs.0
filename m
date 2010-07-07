Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o67F6Qeg242434 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 10:06:26 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAC174308A6
	for <xfs@oss.sgi.com>; Wed,  7 Jul 2010 08:09:17 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	2P0HOZc3iKEon7zP for <xfs@oss.sgi.com>;
	Wed, 07 Jul 2010 08:09:17 -0700 (PDT)
Received: by gyg4 with SMTP id 4so3990524gyg.26
	for <xfs@oss.sgi.com>; Wed, 07 Jul 2010 08:09:17 -0700 (PDT)
From: Peter Watkins <treestem@gmail.com>
Subject: [PATCH] Check block magic number so we scan only valid blocks.
Date: Wed,  7 Jul 2010 11:09:11 -0400
Message-Id: <1278515351-24928-1-git-send-email-treestem@gmail.com>
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

Hello,

Occasionally I've hit a SEGV while querying free space in xfs_db on a mounted
file system. In scanfunc_bno, block->bb_numrecs has crazy values. And bb_magic 
is not XFS_ABTB_MAGIC.

Does a check like this, similiar to other places, make sense?
Should scanfunc_cnt make a similiar check?

Signed-off-by: Peter Watkins <treestem@gmail.com>
---
 db/freesp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/db/freesp.c b/db/freesp.c
index e1902c6..7825628 100644
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
-- 
1.6.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
