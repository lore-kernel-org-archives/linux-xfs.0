Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:25:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4PLgS027849
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:25:22 -0700
Subject: TAKE 979339 - xfs_bmbt_insert invalidates the btree cursor
Message-Id: <20080325042549.4D34258C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 15:25:49 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Ensure a btree insert returns a valid cursor.

When writing into preallocated regions there is a case where XFS can
oops or hang doing the unwritten extent conversion on I/O
completion. It turns out that the problem is related to the btree
cursor being invalid.

When we do an insert into the tree, we may need to split blocks in
the tree. When we only split at the leaf level (i.e. level 0),
everything works just fine. However, if we have a multi-level split
in the btreee, the cursor passed to the insert function is no longer
valid once the insert is complete.

The leaf level split is handled correctly because all the operations
at level 0 are done using the original cursor, hence it is updated
correctly. However, when we need to update the next level up the
tree, we don't use that cursor - we use a cloned cursor that points
to the index in the next level up where we need to do the insert.

Hence if we need to split a second level, the changes to the tree
are reflected in the cloned cursor and not the original cursor.
This clone-and-move-up-a-level-on-split behaviour recurses all the
way to the top of the tree.

The complexity here is that these cloned cursors do not point to the
original index that was inserted - they point to the newly allocated
block (the right block) and the original cursor pointer to that
level may still point to the left block. Hence, without deep
examination of the cloned cursor and buffers, we cannot update the
original cursor with the new path from the cloned cursor.

In these cases the original cursor could be pointing to the wrong
block(s) and hence a subsequent modification to the tree using that
cursor will lead to corruption of the tree.

The crash case occurs when the tree changes height - we insert a new
level in the tree, and the cursor does not have a buffer in it's
path for that level. Hence any attempt to walk back up the cursor to
the root block will result in a null pointer dereference.

To make matters even more complex, the BMAP BT is rooted in an
inode, so we can have a change of height in the btree *without a
root split*.  That is, if the root block in the inode is full when
we split a leaf node, we cannot fit the pointer to the new block in
the root, so we allocate a new block, migrate all the ptrs out of
the inode into the new block and point the inode root block at the
newly allocated block. This changes the height of the tree without a
root split having occurred and hence invalidates the path in the
original cursor.

The patch below prevents xfs_bmbt_insert() from returning with an
invalid cursor by detecting the cases that invalidate the original
cursor and refresh it by do a lookup into the btree for the original
index we were inserting at.

Note that the INOBT, AGFBNO and AGFCNT btree implementations also
have this bug, but the cursor is currently always destroyed or
revalidated after an insert for those trees. Hence this patch only
address the problem in the BMBT code.

Date:  Tue Mar 25 15:25:23 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30701a
fs/xfs/xfs_bmap_btree.c - 1.168 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.168&r2=text&tr2=1.167&f=h
	- Revalidate the btree cursor in xfs_bmbt_insert if we've done a
	  multi-level split or a split that has changed the height of the
	  tree. Some code assumes that the cursor returned after the insert
	  is valid, so revalidating the cursor ensures that such code functions
	  correctly.
