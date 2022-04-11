Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96CDC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiDKAeG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiDKAeD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:03 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12B38DED4
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 525D153AD07
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMV-7C
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pix-6H
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/17] xfs: convert bmap extent type flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:34 +1000
Message-Id: <20220411003147.2104423-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=iPUYN0WQYUd8Jtb8ip0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 14 +++++++-------
 fs/xfs/libxfs/xfs_bmap.h | 22 +++++++++++-----------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 74198dd82b03..d53dfe8db8f2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1399,7 +1399,7 @@ xfs_bmap_add_extent_delay_real(
 	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
 					/* left is 0, right is 1, prev is 2 */
 	int			rval=0;	/* return value (logging flags) */
-	int			state = xfs_bmap_fork_to_state(whichfork);
+	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	xfs_filblks_t		da_new; /* new count del alloc blocks used */
 	xfs_filblks_t		da_old; /* old count del alloc blocks used */
 	xfs_filblks_t		temp=0;	/* value for da_new calculations */
@@ -1950,7 +1950,7 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
 					/* left is 0, right is 1, prev is 2 */
 	int			rval=0;	/* return value (logging flags) */
-	int			state = xfs_bmap_fork_to_state(whichfork);
+	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	old;
 
@@ -2479,7 +2479,7 @@ xfs_bmap_add_extent_hole_delay(
 	xfs_filblks_t		newlen=0;	/* new indirect size */
 	xfs_filblks_t		oldlen=0;	/* old indirect size */
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
-	int			state = xfs_bmap_fork_to_state(whichfork);
+	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	xfs_filblks_t		temp;	 /* temp for indirect calculations */
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -2626,7 +2626,7 @@ xfs_bmap_add_extent_hole_real(
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			rval=0;	/* return value (logging flags) */
-	int			state = xfs_bmap_fork_to_state(whichfork);
+	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
@@ -4801,7 +4801,7 @@ xfs_bmap_del_extent_delay(
 	int64_t			da_old, da_new, da_diff = 0;
 	xfs_fileoff_t		del_endoff, got_endoff;
 	xfs_filblks_t		got_indlen, new_indlen, stolen;
-	int			state = xfs_bmap_fork_to_state(whichfork);
+	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	int			error = 0;
 	bool			isrt;
 
@@ -4926,7 +4926,7 @@ xfs_bmap_del_extent_cow(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	struct xfs_bmbt_irec	new;
 	xfs_fileoff_t		del_endoff, got_endoff;
-	int			state = BMAP_COWFORK;
+	uint32_t		state = BMAP_COWFORK;
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -5015,7 +5015,7 @@ xfs_bmap_del_extent_real(
 	xfs_bmbt_irec_t		new;	/* new record to be inserted */
 	/* REFERENCED */
 	uint			qfield;	/* quota field to update */
-	int			state = xfs_bmap_fork_to_state(whichfork);
+	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
 
 	mp = ip->i_mount;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 03d9aaf87413..29d38c3c2607 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -124,16 +124,16 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
 /*
  * Flags for xfs_bmap_add_extent*.
  */
-#define BMAP_LEFT_CONTIG	(1 << 0)
-#define BMAP_RIGHT_CONTIG	(1 << 1)
-#define BMAP_LEFT_FILLING	(1 << 2)
-#define BMAP_RIGHT_FILLING	(1 << 3)
-#define BMAP_LEFT_DELAY		(1 << 4)
-#define BMAP_RIGHT_DELAY	(1 << 5)
-#define BMAP_LEFT_VALID		(1 << 6)
-#define BMAP_RIGHT_VALID	(1 << 7)
-#define BMAP_ATTRFORK		(1 << 8)
-#define BMAP_COWFORK		(1 << 9)
+#define BMAP_LEFT_CONTIG	(1u << 0)
+#define BMAP_RIGHT_CONTIG	(1u << 1)
+#define BMAP_LEFT_FILLING	(1u << 2)
+#define BMAP_RIGHT_FILLING	(1u << 3)
+#define BMAP_LEFT_DELAY		(1u << 4)
+#define BMAP_RIGHT_DELAY	(1u << 5)
+#define BMAP_LEFT_VALID		(1u << 6)
+#define BMAP_RIGHT_VALID	(1u << 7)
+#define BMAP_ATTRFORK		(1u << 8)
+#define BMAP_COWFORK		(1u << 9)
 
 #define XFS_BMAP_EXT_FLAGS \
 	{ BMAP_LEFT_CONTIG,	"LC" }, \
@@ -243,7 +243,7 @@ void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
 
-static inline int xfs_bmap_fork_to_state(int whichfork)
+static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
 {
 	switch (whichfork) {
 	case XFS_ATTR_FORK:
-- 
2.35.1

