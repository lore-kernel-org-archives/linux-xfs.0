Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B3927F89
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA91BAC002
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:26:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TIaNgNQxEXn90E5A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:05 -0700 (PDT)
Subject: [PATCH 03/15] xfs_db: enable blocktrash for checksummed filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:25:58 -0700
Message-ID: <20150630032558.572.98767.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Disable the write verifiers when we're trashing a block.  With this
in place, create a xfs fuzzer script that formats, populates, corrupts,
tries to use, repairs, and tries again to use a crash test xfs image.
Hopefully this will shake out some v5 filesystem bugs.

v2: Drop xfsfuzz, don't assume every block is an AGF when blocktrashing.
Don't trash log blocks by default, because that skews the blocktrash
heavily towards damaging only log blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


diff --git a/db/check.c b/db/check.c
index 288b2ab..9b40725 100644
--- a/db/check.c
+++ b/db/check.c
@@ -935,6 +935,7 @@ blocktrash_b(
 	int		mask;
 	int		newbit;
 	int		offset;
+	const struct xfs_buf_ops *stashed_ops;
 	static char	*modestr[] = {
 		N_("zeroed"), N_("set"), N_("flipped"), N_("randomized")
 	};
@@ -943,8 +944,10 @@ blocktrash_b(
 	offset = (int)(random() % (int)(mp->m_sb.sb_blocksize * NBBY));
 	newbit = 0;
 	push_cur();
-	set_cur(&typtab[DBM_UNKNOWN],
+	set_cur(NULL,
 		XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb, DB_RING_IGN, NULL);
+	stashed_ops = iocur_top->bp->b_ops;
+	iocur_top->bp->b_ops = NULL;
 	if ((buf = iocur_top->data) == NULL) {
 		dbprintf(_("can't read block %u/%u for trashing\n"), agno, agbno);
 		pop_cur();
@@ -975,6 +978,7 @@ blocktrash_b(
 			buf[byte] &= ~mask;
 	}
 	write_cur();
+	iocur_top->bp->b_ops = stashed_ops;
 	pop_cur();
 	printf(_("blocktrash: %u/%u %s block %d bit%s starting %d:%d %s\n"),
 		agno, agbno, typename[type], len, len == 1 ? "" : "s",
@@ -1031,9 +1035,12 @@ blocktrash_f(
 		   (1 << DBM_BTINO) |
 		   (1 << DBM_DIR) |
 		   (1 << DBM_INODE) |
+		   (1 << DBM_LOG) |
 		   (1 << DBM_QUOTA) |
 		   (1 << DBM_RTBITMAP) |
 		   (1 << DBM_RTSUM) |
+		   (1 << DBM_SYMLINK) |
+		   (1 << DBM_BTFINO) |
 		   (1 << DBM_SB);
 	while ((c = getopt(argc, argv, "0123n:s:t:x:y:")) != EOF) {
 		switch (c) {
@@ -1097,7 +1104,7 @@ blocktrash_f(
 		return 0;
 	}
 	if (tmask == 0)
-		tmask = goodmask;
+		tmask = goodmask & ~((1 << DBM_LOG) | (1 << DBM_SB));
 	lentab = xmalloc(sizeof(ltab_t));
 	lentab->min = lentab->max = min;
 	lentablen = 1;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
