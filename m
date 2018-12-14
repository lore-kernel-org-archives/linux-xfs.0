Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731276AbeLNMey (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 07:34:54 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35389DC91F
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:54 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4861272A5
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:53 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 3/5] xfs: refactor near alloc small case
Date: Fri, 14 Dec 2018 07:34:50 -0500
Message-Id: <20181214123452.20974-4-bfoster@redhat.com>
In-Reply-To: <20181214123452.20974-1-bfoster@redhat.com>
References: <20181214123452.20974-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

- open-code the empty cntbt case

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 61 +++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a7e3daa16717..cd35502eee2b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1323,21 +1323,21 @@ xfs_alloc_ag_vextent_near_bnobt(
  */
 STATIC int				/* error */
 xfs_alloc_ag_vextent_near(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+	struct xfs_alloc_arg	*args)	/* allocation argument structure */
 {
-	xfs_btree_cur_t	*bno_cur = NULL;/* cursor for bno btree */
-	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
-	int		error;		/* error code */
-	int		i;		/* result code, temporary */
-	xfs_agblock_t	ltbno;		/* start bno of left side entry */
-	xfs_extlen_t	ltlen;		/* length of left side entry */
-	bool		busy;
-	unsigned	busy_gen;
+	struct xfs_btree_cur	*bno_cur = NULL;/* cursor for bno btree */
+	struct xfs_btree_cur	*cnt_cur;	/* cursor for count btree */
+	int			error;		/* error code */
+	int			i;		/* result code, temporary */
+	xfs_agblock_t		ltbno;	      /* start bno of left side entry */
+	xfs_extlen_t		ltlen;		/* length of left side entry */
+	bool			busy;
+	unsigned		busy_gen;
 #ifdef DEBUG
 	/*
 	 * Randomly don't execute the first algorithm.
 	 */
-	int		dofirst;	/* set to do first algorithm */
+	int			dofirst;	/* set to do first algorithm */
 
 	dofirst = prandom_u32() & 1;
 #endif
@@ -1358,32 +1358,49 @@ xfs_alloc_ag_vextent_near(
 	busy = false;
 
 	/*
-	 * Get a cursor for the by-size btree.
+	 * Get a cursor for the by-size btree and start with a lookup for maxlen
+	 * free extents.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
-
-	/*
-	 * See if there are any free extents as big as maxlen.
-	 */
+					  args->agno, XFS_BTNUM_CNT);
 	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i);
 	if (error)
 		goto error;
+
 	/*
-	 * If none, then pick up the last entry in the tree unless the
-	 * tree is empty.
+	 * If there are no maxlen extents, check the last (largest) record
+	 * against minlen. If it's usable, the cntbt search will find the best
+	 * >= minlen extent to use in the last block. If the cntbt is completely
+	 * empty, the only other option is to try and allocate from the AGFL.
 	 */
 	if (!i) {
-		error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno,
-				&ltlen, &i);
+		error = xfs_btree_decrement(cnt_cur, 0, &i);
 		if (error)
 			goto error;
-		if (i == 0 || ltlen == 0) {
+		if (i) {
+			error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i);
+			if (error)
+				goto error;
+			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+			if (ltlen < args->minlen) {
+				trace_xfs_alloc_small_notenough(args);
+				return 0;
+			}
+		} else {
+			/*
+			 * We only get here if the cntbt is empty so this call
+			 * returns an AGFL block or nothing. We're done either
+			 * way.
+			 */
+			error = xfs_alloc_ag_vextent_small(args, cnt_cur,
+							   &ltbno, &ltlen, &i);
+			if (error)
+				goto error;
+			ASSERT(i == 0 || (i && ltlen == 0));
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_near_noentry(args);
 			return 0;
 		}
-		ASSERT(i == 1);
 	}
 	args->wasfromfl = 0;
 
-- 
2.17.2
