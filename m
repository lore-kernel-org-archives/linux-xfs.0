Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8JEeoi4160606 for <xfs@oss.sgi.com>; Sat, 19 Sep 2009 09:40:51 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D68991BEF3EA
	for <xfs@oss.sgi.com>; Sat, 19 Sep 2009 07:42:05 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id YJ3UX7lyEuRAHOIU for
	<xfs@oss.sgi.com>; Sat, 19 Sep 2009 07:42:05 -0700 (PDT)
Received: from liberator.sandeen.net (sandeen.net [209.173.210.139])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 0D71F93A958
	for <xfs@oss.sgi.com>; Sat, 19 Sep 2009 09:42:04 -0500 (CDT)
Message-ID: <4AB4EDBC.9050609@sandeen.net>
Date: Sat, 19 Sep 2009 09:42:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_repair: fix record_allocation list manipulation
References: <4AB300CC.5020707@sandeen.net>
In-Reply-To: <4AB300CC.5020707@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

clang found this one too as a "Dead assignment"

Unless my pointer-fu is totally messed up, this function
was never actually updating the list head.

This would mean that the later free_allocations() calls in
incore_ext_teardown() and free_rt_dup_extent_tree() don't
actually free any items, and therefore leak memory.

V2: now with correct pointer-fu.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

(We could use Jeff's doubly-linked list patch too, though we
really don't need both pointers, and there are still other
singly-linked lists throughout repair...)

clang record:

http://sandeen.net/clang/xfsprogs/2009-09-09-1/report-1Jnl15.html#EndPath

diff --git a/repair/incore.c b/repair/incore.c
index 84626c9..0fd0e89 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -30,10 +30,10 @@
  * if set to NULL if empty.
  */
 void
-record_allocation(ba_rec_t *addr, ba_rec_t *list)
+record_allocation(ba_rec_t *addr, ba_rec_t **list)
 {
-	addr->next = list;
-	list = addr;
+	addr->next = *list;
+	*list = addr;
 
 	return;
 }
diff --git a/repair/incore.h b/repair/incore.h
index 1f0f45a..4f90dd6 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -33,7 +33,7 @@ typedef struct ba_rec  {
 	struct ba_rec	*next;
 } ba_rec_t;
 
-void			record_allocation(ba_rec_t *addr, ba_rec_t *list);
+void			record_allocation(ba_rec_t *addr, ba_rec_t **list);
 void			free_allocations(ba_rec_t *list);
 
 /*
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index a2acbf4..90d2074 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -120,7 +120,7 @@ mk_extent_tree_nodes(xfs_agblock_t new_startblock,
 			do_error(
 			_("couldn't allocate new extent descriptors.\n"));
 
-		record_allocation(&rec->alloc_rec, ba_list);
+		record_allocation(&rec->alloc_rec, &ba_list);
 
 		new = &rec->extents[0];
 
@@ -678,7 +678,7 @@ mk_rt_extent_tree_nodes(xfs_drtbno_t new_startblock,
 			do_error(
 			_("couldn't allocate new extent descriptors.\n"));
 
-		record_allocation(&rec->alloc_rec, rt_ba_list);
+		record_allocation(&rec->alloc_rec, &rt_ba_list);
 
 		new = &rec->extents[0];
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
