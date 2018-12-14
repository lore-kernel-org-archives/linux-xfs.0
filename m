Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbeLNMey (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 07:34:54 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C5652F3B
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:54 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55BA619C65
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:54 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 4/5] xfs: clean up variable names in xfs_alloc_ag_vextent_near()
Date: Fri, 14 Dec 2018 07:34:51 -0500
Message-Id: <20181214123452.20974-5-bfoster@redhat.com>
In-Reply-To: <20181214123452.20974-1-bfoster@redhat.com>
References: <20181214123452.20974-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index cd35502eee2b..95ee48e3fb9d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1329,8 +1329,8 @@ xfs_alloc_ag_vextent_near(
 	struct xfs_btree_cur	*cnt_cur;	/* cursor for count btree */
 	int			error;		/* error code */
 	int			i;		/* result code, temporary */
-	xfs_agblock_t		ltbno;	      /* start bno of left side entry */
-	xfs_extlen_t		ltlen;		/* length of left side entry */
+	xfs_agblock_t		bno;	      /* start bno of left side entry */
+	xfs_extlen_t		len;		/* length of left side entry */
 	bool			busy;
 	unsigned		busy_gen;
 #ifdef DEBUG
@@ -1354,7 +1354,7 @@ xfs_alloc_ag_vextent_near(
 		args->agbno = args->max_agbno;
 
 restart:
-	ltlen = 0;
+	len = 0;
 	busy = false;
 
 	/*
@@ -1378,11 +1378,11 @@ xfs_alloc_ag_vextent_near(
 		if (error)
 			goto error;
 		if (i) {
-			error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i);
+			error = xfs_alloc_get_rec(cnt_cur, &bno, &len, &i);
 			if (error)
 				goto error;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
-			if (ltlen < args->minlen) {
+			if (len < args->minlen) {
 				trace_xfs_alloc_small_notenough(args);
 				return 0;
 			}
@@ -1393,10 +1393,10 @@ xfs_alloc_ag_vextent_near(
 			 * way.
 			 */
 			error = xfs_alloc_ag_vextent_small(args, cnt_cur,
-							   &ltbno, &ltlen, &i);
+							   &bno, &len, &i);
 			if (error)
 				goto error;
-			ASSERT(i == 0 || (i && ltlen == 0));
+			ASSERT(i == 0 || (i && len == 0));
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_near_noentry(args);
 			return 0;
@@ -1415,22 +1415,22 @@ xfs_alloc_ag_vextent_near(
 		 * record smaller than maxlen, go to the start of this block,
 		 * and skip all those smaller than minlen.
 		 */
-		if (ltlen || args->alignment > 1) {
+		if (len || args->alignment > 1) {
 			cnt_cur->bc_ptrs[0] = 1;
 			do {
-				error = xfs_alloc_get_rec(cnt_cur, &ltbno,
-						&ltlen, &i);
+				error = xfs_alloc_get_rec(cnt_cur, &bno,
+						&len, &i);
 				if (error)
 					goto error;
 				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1,
 							error);
-				if (ltlen >= args->minlen)
+				if (len >= args->minlen)
 					break;
 				error = xfs_btree_increment(cnt_cur, 0, &i);
 				if (error)
 					goto error;
 			} while (i);
-			ASSERT(ltlen >= args->minlen);
+			ASSERT(len >= args->minlen);
 			if (!i)
 				goto near_bnobt;
 		}
-- 
2.17.2
