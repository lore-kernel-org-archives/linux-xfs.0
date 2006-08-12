Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 Aug 2006 14:34:15 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7CLXkDW008232
	for <xfs@oss.sgi.com>; Sat, 12 Aug 2006 14:33:47 -0700
Received: by nf-out-0910.google.com with SMTP id c29so1338853nfb
        for <xfs@oss.sgi.com>; Sat, 12 Aug 2006 14:33:15 -0700 (PDT)
From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] XFS: possibly uninitialized variable use in fs/xfs/xfs_da_btree.c::xfs_da_node_lookup_int()
Date: Sat, 12 Aug 2006 23:34:21 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200608122334.21901.jesper.juhl@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com, nathans@sgi.com, xfs@oss.sgi.com, Jesper Juhl <jesper.juhl@gmail.com>

Ok, I'll honestly admit that I'm in over my head here. But, coverity found
a potential use of an uninitialized variable in 
fs/xfs/xfs_da_btree.c::xfs_da_node_lookup_int() and I think it might be 
correct (coverity bug #900).

The problem spot is this bit of code : 

...
 			if (blk->magic == XFS_DIR2_LEAFN_MAGIC) {
 				retval = xfs_dir2_leafn_lookup_int(blk->bp, args,
 								&blk->index, state);
 			}
 			else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
 				retval = xfs_attr_leaf_lookup_int(blk->bp, args);
 				blk->index = args->index;
 				args->blkno = blk->blkno;
 			}
 			if (((retval == ENOENT) || (retval == ENOATTR)) &&

                              ^^^--- 'retval' possibly used uninitialized here...

 			    (blk->hashval == args->hashval)) {
...

Nothing initializes 'retval' before this bit of code, so if 'blk->magic' is 
neither == XFS_DIR2_LEAFN_MAGIC or XFS_ATTR_LEAF_MAGIC then it'll be in an 
uninitialized state when we get to the "if (((retval == ENOENT) ..." bit.

Now we get to the part where I'm in over my head. 

Since there is code above that check 'blk->magic' against 
being == XFS_DA_NODE_MAGIC and I don't see how we would be skipping the 
code quoted above in that case, it looks to me like this could happen and 
lead to the uninitialized use of retval.
It also seems to me, from reading fs/xfs/xfs_da_btree.h, that 'blk->magic' 
might in some cases be == XFS_DIR2_LEAF1_MAGIC in which case we'd also end 
up using retval uninitialized.

Now, what to do about it. Well, if I'm reading the function correctly the 
safest thing would be to assume a 'retval' of ENOENT if the above 
"if/else if" didn't trigger, so below is a patch that initializes 'retval' 
to that value so that if we do hit this corner case we'll just act as if 
we couldn't find what we were looking for in the Btree.

I suspect I may be completely wrong, and if that's the case I'd sure like 
an explanation of where I went wrong along with the NACK for the patch.
In case my understanding is in fact correct and the patch below makes sense,
then kindly apply :-)



Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 fs/xfs/xfs_da_btree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.18-rc4-orig/fs/xfs/xfs_da_btree.c	2006-08-11 00:11:13.000000000 +0200
+++ linux-2.6.18-rc4/fs/xfs/xfs_da_btree.c	2006-08-12 23:18:23.000000000 +0200
@@ -1053,7 +1053,8 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 	xfs_da_intnode_t *node;
 	xfs_da_node_entry_t *btree;
 	xfs_dablk_t blkno;
-	int probe, span, max, error, retval;
+	int probe, span, max, error;
+	int retval = ENOENT;
 	xfs_dahash_t hashval;
 	xfs_da_args_t *args;
 
