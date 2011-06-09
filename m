Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59GmLXr188491 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 11:48:22 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14BF5D95E45
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 09:48:20 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id PFRdUoNFiQ15HdOI for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2011 09:48:20 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p59GKWhi022060
	for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 12:20:32 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p59GmCjL092484 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 12:48:12 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p59AlVPi025089
	for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 04:47:31 -0600
Subject: PATCH: remove varibale that serve no purpose in
	xfs_alloc_ag_vextent_exact()
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 09 Jun 2011 09:47:49 -0700
Message-ID: <1307638069.7661.432.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>

Hi,

As per Alex Elder suggestion, here is a patch to remove non-purpose
variables in xfs_alloc_ag_vextent_exact()

chandra

--------------------
Remove the variables that serves no purpose.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 95862bb..7a53c8f 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -570,9 +570,7 @@ xfs_alloc_ag_vextent_exact(
 	xfs_agblock_t	tbno;	/* start block of trimmed extent */
 	xfs_extlen_t	tlen;	/* length of trimmed extent */
 	xfs_agblock_t	tend;	/* end block of trimmed extent */
-	xfs_agblock_t	end;	/* end of allocated extent */
 	int		i;	/* success/failure of operation */
-	xfs_extlen_t	rlen;	/* length of returned extent */
 
 	ASSERT(args->alignment == 1);
 
@@ -625,18 +623,16 @@ xfs_alloc_ag_vextent_exact(
 	 *
 	 * Fix the length according to mod and prod if given.
 	 */
-	end = XFS_AGBLOCK_MIN(tend, args->agbno + args->maxlen);
-	args->len = end - args->agbno;
+	args->len = XFS_AGBLOCK_MIN(tend, args->agbno + args->maxlen)
+						- args->agbno;
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args))
 		goto not_found;
 
-	rlen = args->len;
-	ASSERT(args->agbno + rlen <= tend);
-	end = args->agbno + rlen;
+	ASSERT(args->agbno + args->len <= tend);
 
 	/*
-	 * We are allocating agbno for rlen [agbno .. end]
+	 * We are allocating agbno for args->len
 	 * Allocate/initialize a cursor for the by-size btree.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
