Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0976129E51
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:05:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A4AEAC00A
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:05:50 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iLSHM1eyqHGhaBGN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:05:49 -0700 (PDT)
Subject: [PATCH 05/51] xfs_db: enable blocktrash for checksummed filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:05:46 -0700
Message-ID: <20151007050546.1504.55364.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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

v3: Fix changelog issues, allow trashing of log blocks and symlinks,
and require the caller to explicitly ask for trashing of log blocks
and super blocks because they seem to have been left out.  Allowing
log blocks by default skews the trashing heavily in favor of (probably
unused) log blocks, which doesn't help us with fuzzing.  Furthermore,
trashing the superblock results in a time consuming sector by sector
superblock hunt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/db/check.c b/db/check.c
index d28199d..8f3b5b6 100644
--- a/db/check.c
+++ b/db/check.c
@@ -944,6 +944,7 @@ blocktrash_b(
 	int		mask;
 	int		newbit;
 	int		offset;
+	const struct xfs_buf_ops *stashed_ops;
 	static char	*modestr[] = {
 		N_("zeroed"), N_("set"), N_("flipped"), N_("randomized")
 	};
@@ -952,8 +953,10 @@ blocktrash_b(
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
@@ -984,6 +987,7 @@ blocktrash_b(
 			buf[byte] &= ~mask;
 	}
 	write_cur();
+	iocur_top->bp->b_ops = stashed_ops;
 	pop_cur();
 	printf(_("blocktrash: %u/%u %s block %d bit%s starting %d:%d %s\n"),
 		agno, agbno, typename[type], len, len == 1 ? "" : "s",
@@ -1040,9 +1044,11 @@ blocktrash_f(
 		   (1 << DBM_BTINO) |
 		   (1 << DBM_DIR) |
 		   (1 << DBM_INODE) |
+		   (1 << DBM_LOG) |
 		   (1 << DBM_QUOTA) |
 		   (1 << DBM_RTBITMAP) |
 		   (1 << DBM_RTSUM) |
+		   (1 << DBM_SYMLINK) |
 		   (1 << DBM_SB);
 	while ((c = getopt(argc, argv, "0123n:s:t:x:y:")) != EOF) {
 		switch (c) {
@@ -1106,7 +1112,7 @@ blocktrash_f(
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
