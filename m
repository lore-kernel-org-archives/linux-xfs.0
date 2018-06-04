Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48302 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbeFDQKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 12:10:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54G5qkm180989
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:36 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2jbvyp47u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 16:10:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w54GAZ2F032728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:35 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54GAZKv008663
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:35 GMT
Subject: [PATCH 2/4] xfs: introduce xfs_btree_debug_check_ptr
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Jun 2018 09:10:34 -0700
Message-ID: <152812863422.2736.10487632470115859469.stgit@magnolia>
In-Reply-To: <152812862079.2736.15381483104759513267.stgit@magnolia>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make xfs_btree_check_ptr a non-debug function and introduce a new _debug
version that only runs when #ifdef DEBUG.   This will enable us to reuse
the checking logic with other parts of the btree code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   68 +++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index cc8122ad37c5..ef93721c0d49 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -234,7 +234,6 @@ xfs_btree_check_sptr(
 	return xfs_verify_agbno(cur->bc_mp, cur->bc_private.a.agno, agbno);
 }
 
-#ifdef DEBUG
 /*
  * Check that a given (indexed) btree pointer at a certain level of a
  * btree is valid and doesn't point past where it should.
@@ -258,6 +257,11 @@ xfs_btree_check_ptr(
 
 	return 0;
 }
+
+#ifdef DEBUG
+# define xfs_btree_debug_check_ptr	xfs_btree_check_ptr
+#else
+# define xfs_btree_debug_check_ptr(...)	(0)
 #endif
 
 /*
@@ -1947,11 +1951,10 @@ xfs_btree_lookup(
 				keyno = 1;
 			pp = xfs_btree_ptr_addr(cur, keyno, block);
 
-#ifdef DEBUG
-			error = xfs_btree_check_ptr(cur, pp, 0, level);
+			error = xfs_btree_debug_check_ptr(cur, pp, 0, level);
 			if (error)
 				goto error0;
-#endif
+
 			cur->bc_ptrs[level] = keyno;
 		}
 	}
@@ -2355,11 +2358,11 @@ xfs_btree_lshift(
 
 		lpp = xfs_btree_ptr_addr(cur, lrecs, left);
 		rpp = xfs_btree_ptr_addr(cur, 1, right);
-#ifdef DEBUG
-		error = xfs_btree_check_ptr(cur, rpp, 0, level);
+
+		error = xfs_btree_debug_check_ptr(cur, rpp, 0, level);
 		if (error)
 			goto error0;
-#endif
+
 		xfs_btree_copy_keys(cur, lkp, rkp, 1);
 		xfs_btree_copy_ptrs(cur, lpp, rpp, 1);
 
@@ -2394,15 +2397,14 @@ xfs_btree_lshift(
 	XFS_BTREE_STATS_ADD(cur, moves, rrecs - 1);
 	if (level > 0) {
 		/* It's a nonleaf. operate on keys and ptrs */
-#ifdef DEBUG
 		int			i;		/* loop index */
 
 		for (i = 0; i < rrecs; i++) {
-			error = xfs_btree_check_ptr(cur, rpp, i + 1, level);
+			error = xfs_btree_debug_check_ptr(cur, rpp, i + 1, level);
 			if (error)
 				goto error0;
 		}
-#endif
+
 		xfs_btree_shift_keys(cur,
 				xfs_btree_key_addr(cur, 2, right),
 				-1, rrecs);
@@ -2542,22 +2544,18 @@ xfs_btree_rshift(
 		rkp = xfs_btree_key_addr(cur, 1, right);
 		rpp = xfs_btree_ptr_addr(cur, 1, right);
 
-#ifdef DEBUG
 		for (i = rrecs - 1; i >= 0; i--) {
-			error = xfs_btree_check_ptr(cur, rpp, i, level);
+			error = xfs_btree_debug_check_ptr(cur, rpp, i, level);
 			if (error)
 				goto error0;
 		}
-#endif
 
 		xfs_btree_shift_keys(cur, rkp, 1, rrecs);
 		xfs_btree_shift_ptrs(cur, rpp, 1, rrecs);
 
-#ifdef DEBUG
-		error = xfs_btree_check_ptr(cur, lpp, 0, level);
+		error = xfs_btree_debug_check_ptr(cur, lpp, 0, level);
 		if (error)
 			goto error0;
-#endif
 
 		/* Now put the new data in, and log it. */
 		xfs_btree_copy_keys(cur, rkp, lkp, 1);
@@ -2730,13 +2728,11 @@ __xfs_btree_split(
 		rkp = xfs_btree_key_addr(cur, 1, right);
 		rpp = xfs_btree_ptr_addr(cur, 1, right);
 
-#ifdef DEBUG
 		for (i = src_index; i < rrecs; i++) {
-			error = xfs_btree_check_ptr(cur, lpp, i, level);
+			error = xfs_btree_debug_check_ptr(cur, lpp, i, level);
 			if (error)
 				goto error0;
 		}
-#endif
 
 		/* Copy the keys & pointers to the new block. */
 		xfs_btree_copy_keys(cur, rkp, lkp, rrecs);
@@ -2973,20 +2969,18 @@ xfs_btree_new_iroot(
 	xfs_btree_copy_keys(cur, ckp, kp, xfs_btree_get_numrecs(cblock));
 
 	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
-#ifdef DEBUG
 	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		error = xfs_btree_check_ptr(cur, pp, i, level);
+		error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 		if (error)
 			goto error0;
 	}
-#endif
+
 	xfs_btree_copy_ptrs(cur, cpp, pp, xfs_btree_get_numrecs(cblock));
 
-#ifdef DEBUG
-	error = xfs_btree_check_ptr(cur, &nptr, 0, level);
+	error = xfs_btree_debug_check_ptr(cur, &nptr, 0, level);
 	if (error)
 		goto error0;
-#endif
+
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
 	xfs_iroot_realloc(cur->bc_private.b.ip,
@@ -3322,22 +3316,18 @@ xfs_btree_insrec(
 		kp = xfs_btree_key_addr(cur, ptr, block);
 		pp = xfs_btree_ptr_addr(cur, ptr, block);
 
-#ifdef DEBUG
 		for (i = numrecs - ptr; i >= 0; i--) {
-			error = xfs_btree_check_ptr(cur, pp, i, level);
+			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 			if (error)
 				return error;
 		}
-#endif
 
 		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
 		xfs_btree_shift_ptrs(cur, pp, 1, numrecs - ptr + 1);
 
-#ifdef DEBUG
-		error = xfs_btree_check_ptr(cur, ptrp, 0, level);
+		error = xfs_btree_debug_check_ptr(cur, ptrp, 0, level);
 		if (error)
 			goto error0;
-#endif
 
 		/* Now put the new data in, bump numrecs and log it. */
 		xfs_btree_copy_keys(cur, kp, key, 1);
@@ -3582,13 +3572,13 @@ xfs_btree_kill_iroot(
 
 	pp = xfs_btree_ptr_addr(cur, 1, block);
 	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
-#ifdef DEBUG
+
 	for (i = 0; i < numrecs; i++) {
-		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
+		error = xfs_btree_debug_check_ptr(cur, cpp, i, level - 1);
 		if (error)
 			return error;
 	}
-#endif
+
 	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
 
 	error = xfs_btree_free_block(cur, cbp);
@@ -3722,13 +3712,11 @@ xfs_btree_delrec(
 		lkp = xfs_btree_key_addr(cur, ptr + 1, block);
 		lpp = xfs_btree_ptr_addr(cur, ptr + 1, block);
 
-#ifdef DEBUG
 		for (i = 0; i < numrecs - ptr; i++) {
-			error = xfs_btree_check_ptr(cur, lpp, i, level);
+			error = xfs_btree_debug_check_ptr(cur, lpp, i, level);
 			if (error)
 				goto error0;
 		}
-#endif
 
 		if (ptr < numrecs) {
 			xfs_btree_shift_keys(cur, lkp, -1, numrecs - ptr);
@@ -4061,13 +4049,13 @@ xfs_btree_delrec(
 		lpp = xfs_btree_ptr_addr(cur, lrecs + 1, left);
 		rkp = xfs_btree_key_addr(cur, 1, right);
 		rpp = xfs_btree_ptr_addr(cur, 1, right);
-#ifdef DEBUG
+
 		for (i = 1; i < rrecs; i++) {
-			error = xfs_btree_check_ptr(cur, rpp, i, level);
+			error = xfs_btree_debug_check_ptr(cur, rpp, i, level);
 			if (error)
 				goto error0;
 		}
-#endif
+
 		xfs_btree_copy_keys(cur, lkp, rkp, rrecs);
 		xfs_btree_copy_ptrs(cur, lpp, rpp, rrecs);
 

