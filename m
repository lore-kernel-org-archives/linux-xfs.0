Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Sep 2008 17:00:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8I00iIZ020015
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 17:00:45 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45CC11B47157
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 17:02:14 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id r9CKSlzuJlhAkv77 for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 17:02:14 -0700 (PDT)
Message-ID: <48D19A83.4040608@thebarn.com>
Date: Wed, 17 Sep 2008 19:02:11 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: REVIEW: Fix for incore extent corruption.
Content-Type: multipart/mixed;
 boundary="------------010401020805040703090908"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------010401020805040703090908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Reference:
 http://oss.sgi.com/archives/xfs/2008-06/msg00209.html


It turns out that the code in question is still broken.

xfs_iext_irec_compact_full will still corrupt the incore extent list if 
it does
the the partial copy of extents from one page to the next.
I haven't quit figured out where things get out of sync but somehow
if_real_bytes which tracks the total number of bytes available in
the extent buffers and if_bytes (which tracks the total bytes used
for extents.

So at some point the inode thinks is has more extents than allocated 
pages allow.
So what happens is xfs_iext_idx_to_irec which uses idxp to pass IN the
absolute extent index is suppose to change  idxp on the way OUT and erp_idxp
to be a buffer index pair. What happens is that it doesn't find the 
extent so idxp
is left holding the same value as was passed in and erp_idx is 0.
This causes the extent code to then index way past the end of extent 
buffer 0
into garbage mem.

with 4k ext buffers max extent count per buffer is 256.
example being:
IN:
idxp = 400
should become:
idexp = 144
erp_idxp = 1

but we end up not finding the extent so
we have
idxp = 400
erp_idxp =0

so we now index 6400 bytes into a 4k buffer.

Which often times  is a pages of mostly 0 so we end up with access to 
block 0 errors.

The more I looked at this code the more it didn't make sense to do 
partial moves.
Since the list of extent buffers is only scanned once vs restarting the 
list whenever a partial move is done,
it is very unlikely to actually free an extent buffer. (granted it's 
possible but unlikely)

xfs_iext_irec_compact_pages does the same thing as 
xfs_iext_irec_compact_full except that doesn't handle partial moves.

xfs_iext_irec_compact is written such that ratio of current extents has 
to be significantly smaller than the current allocated space
xfs_inode: 4513
nextents < ( nlists  * XFS_LINEAR_EXT) >> 3

As it turns out 99% of the time it calls xfs_iext_irec_compact_pages
 (which is why it has been so hard to track this bug down).

If you change the 3 to a 1 so the code alway calls compact_full vs 
compact_pages the extent list will corrupt amost
immediately.

Since the code is broken, almost never used, and provides only micro 
optimization of incore space I propose we just
remove it all together.

I'm also including an xfsidbg patch that for xexlist that prints out 
buffer offset and index.

-Russell Cattelan



--------------010401020805040703090908
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="remove_ex_compact_full"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove_ex_compact_full"

Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-09-16 10:04:37.910673498 -0500
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-09-16 10:30:11.000000000 -0500
@@ -4157,7 +4157,7 @@ xfs_iext_indirect_to_direct(
 	ASSERT(nextents <= XFS_LINEAR_EXTS);
 	size = nextents * sizeof(xfs_bmbt_rec_t);
 
-	xfs_iext_irec_compact_full(ifp);
+	xfs_iext_irec_compact_pages(ifp);
 	ASSERT(ifp->if_real_bytes == XFS_IEXT_BUFSZ);
 
 	ep = ifp->if_u1.if_ext_irec->er_extbuf;
@@ -4500,20 +4500,29 @@ xfs_iext_irec_compact(
 	int		nlists;		/* number of irec's (ex lists) */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
-	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 
 	if (nextents == 0) {
 		xfs_iext_destroy(ifp);
-	} else if (nextents <= XFS_INLINE_EXTS) {
+		return;
+	}
+
+	/* Combine all extents into the smallest number of pages */
+	xfs_iext_irec_compact_pages(ifp);
+
+	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+
+	printk("%s:%d LINEAR %d INLINE %d nextents %d nlists %d\n",
+	       __FUNCTION__,__LINE__, XFS_LINEAR_EXTS,  XFS_INLINE_EXTS,
+	       nextents,nlists);
+
+
+	if (nextents <= XFS_LINEAR_EXTS) {
 		xfs_iext_indirect_to_direct(ifp);
+	}
+	if (nextents <= XFS_INLINE_EXTS) {
 		xfs_iext_direct_to_inline(ifp, nextents);
-	} else if (nextents <= XFS_LINEAR_EXTS) {
-		xfs_iext_indirect_to_direct(ifp);
-	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 3) {
-		xfs_iext_irec_compact_full(ifp);
-	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 1) {
-		xfs_iext_irec_compact_pages(ifp);
 	}
 }
 
@@ -4555,91 +4564,6 @@ xfs_iext_irec_compact_pages(
 }
 
 /*
- * Fully compact the extent records managed by the indirection array.
- */
-void
-xfs_iext_irec_compact_full(
-	xfs_ifork_t	*ifp)			/* inode fork pointer */
-{
-	xfs_bmbt_rec_host_t *ep, *ep_next;	/* extent record pointers */
-	xfs_ext_irec_t	*erp, *erp_next;	/* extent irec pointers */
-	int		erp_idx = 0;		/* extent irec index */
-	int		ext_avail;		/* empty entries in ex list */
-	int		ext_diff;		/* number of exts to add */
-	int		nlists;			/* number of irec's (ex lists) */
-
-	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
-
-	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-	erp = ifp->if_u1.if_ext_irec;
-	ep = &erp->er_extbuf[erp->er_extcount];
-	erp_next = erp + 1;
-	ep_next = erp_next->er_extbuf;
-
-	while (erp_idx < nlists - 1) {
-		/*
-		 * Check how many extent records are available in this irec.
-		 * If there is none skip the whole exercise.
-		 */
-		ext_avail = XFS_LINEAR_EXTS - erp->er_extcount;
-		if (ext_avail) {
-
-			/*
-			 * Copy over as many as possible extent records into
-			 * the previous page.
-			 */
-			ext_diff = MIN(ext_avail, erp_next->er_extcount);
-			memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
-			erp->er_extcount += ext_diff;
-			erp_next->er_extcount -= ext_diff;
-
-			/*
-			 * If the next irec is empty now we can simply
-			 * remove it.
-			 */
-			if (erp_next->er_extcount == 0) {
-				/*
-				 * Free page before removing extent record
-				 * so er_extoffs don't get modified in
-				 * xfs_iext_irec_remove.
-				 */
-				kmem_free(erp_next->er_extbuf);
-				erp_next->er_extbuf = NULL;
-				xfs_iext_irec_remove(ifp, erp_idx + 1);
-				erp = &ifp->if_u1.if_ext_irec[erp_idx];
-				nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-
-			/*
-			 * If the next irec is not empty move up the content
-			 * that has not been copied to the previous page to
-			 * the beggining of this one.
-			 */
-			} else {
-				memmove(erp_next->er_extbuf, &ep_next[ext_diff],
-					erp_next->er_extcount *
-					sizeof(xfs_bmbt_rec_t));
-				ep_next = erp_next->er_extbuf;
-				memset(&ep_next[erp_next->er_extcount], 0,
-					(XFS_LINEAR_EXTS -
-						erp_next->er_extcount) *
-					sizeof(xfs_bmbt_rec_t));
-			}
-		}
-
-		if (erp->er_extcount == XFS_LINEAR_EXTS) {
-			erp_idx++;
-			if (erp_idx < nlists)
-				erp = &ifp->if_u1.if_ext_irec[erp_idx];
-			else
-				break;
-		}
-		ep = &erp->er_extbuf[erp->er_extcount];
-		erp_next = erp + 1;
-		ep_next = erp_next->er_extbuf;
-	}
-}
-
-/*
  * This is called to update the er_extoff field in the indirection
  * array when extents have been added or removed from one of the
  * extent lists. erp_idx contains the irec index to begin updating

--------------010401020805040703090908
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="xfsidbg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfsidbg.patch"

--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-09-16 00:10:26.000000000 -0500
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-09-16 09:44:52.000000000 -0500
@@ -2054,6 +2054,7 @@ kdbm_bp(int argc, const char **argv)
 static int
 kdbm_bpdelay(int argc, const char **argv)
 {
+#if 0
 	struct list_head	*xfs_buftarg_list = xfs_get_buftarg_list();
 	struct list_head	*curr, *next;
 	xfs_buftarg_t		*tp, *n;
@@ -2091,6 +2092,7 @@ kdbm_bpdelay(int argc, const char **argv
 			}
 		}
 	}
+#endif
 	return 0;
 }
 
@@ -3831,21 +3833,32 @@ xfs_rw_trace_entry(ktrace_entry_t *ktep)
 static void
 xfs_xexlist_fork(xfs_inode_t *ip, int whichfork)
 {
-	int nextents, i;
+	int nextents, nlists, i;
 	xfs_ifork_t *ifp;
 	xfs_bmbt_irec_t irec;
+	xfs_bmbt_rec_host_t *rec_h;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (ifp->if_flags & XFS_IFEXTENTS) {
 		nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-		kdb_printf("inode 0x%p %cf extents 0x%p nextents 0x%x\n",
+		nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
+		kdb_printf("inode 0x%p %cf extents 0x%p nextents %d nlists %d\n",
 			ip, "da"[whichfork], xfs_iext_get_ext(ifp, 0),
-			nextents);
+			   nextents,nlists);
 		for (i = 0; i < nextents; i++) {
-			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, i), &irec);
+			rec_h = xfs_iext_get_ext(ifp, i);
+
+			if (ifp->if_flags & XFS_IFEXTIREC) {
+				xfs_ext_irec_t	*erp;		/* irec pointer */
+				int		erp_idx = 0;	/* irec index */
+				xfs_extnum_t	page_idx = i;	/* ext index in target list */
+				erp = xfs_iext_idx_to_irec(ifp, &page_idx, &erp_idx, 0);
+				kdb_printf("page_idx %d erp_idx %d\t",page_idx,erp_idx);
+			}
+			xfs_bmbt_get_all(rec_h, &irec);
 			kdb_printf(
-		"%d: startoff %Ld startblock %s blockcount %Ld flag %d\n",
-			i, irec.br_startoff,
+		"%d: addr 0x%p startoff %Ld startblock %s blockcount %Ld flag %d\n",
+		        i, rec_h, irec.br_startoff,
 			xfs_fmtfsblock(irec.br_startblock, ip->i_mount),
 			irec.br_blockcount, irec.br_state);
 		}

--------------010401020805040703090908--
