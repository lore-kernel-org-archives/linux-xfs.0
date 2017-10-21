Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35389 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752498AbdJUAD6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 20:03:58 -0400
Date: Fri, 20 Oct 2017 17:03:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/17] xfs: parent pointer attribute creation
Message-ID: <20171021000352.GB6624@magnolia>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-13-git-send-email-allison.henderson@oracle.com>
 <20171019193659.GG4755@magnolia>
 <9185d3e8-4b41-b2d8-294b-934f7d3409f0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9185d3e8-4b41-b2d8-294b-934f7d3409f0@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Fri, Oct 20, 2017 at 04:41:49PM -0700, Allison Henderson wrote:
> On 10/19/2017 12:36 PM, Darrick J. Wong wrote:
> >On Wed, Oct 18, 2017 at 03:55:28PM -0700, Allison Henderson wrote:
> >>From: Dave Chinner<dchinner@redhat.com>
> >>
> >>[bfoster: rebase, use VFS inode generation]
> >>[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> >>	   fixed some null pointer bugs]
> >>
> >>Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >>Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
> >>---
> >>v2: remove unnecessary ENOSPC handling in xfs_attr_set_first_parent
> >>
> >>Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
> >>---
> >>  fs/xfs/Makefile            |  1 +
> >>  fs/xfs/libxfs/xfs_attr.c   | 71 ++++++++++++++++++++++++++++++---
> >>  fs/xfs/libxfs/xfs_bmap.c   | 51 ++++++++++++++----------
> >>  fs/xfs/libxfs/xfs_bmap.h   |  1 +
> >>  fs/xfs/libxfs/xfs_parent.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  fs/xfs/xfs_attr.h          | 15 ++++++-
> >>  fs/xfs/xfs_inode.c         | 16 +++++++-
> >>  7 files changed, 225 insertions(+), 28 deletions(-)
> >>
> >>diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> >>index ec6486b..3015bca 100644
> >>--- a/fs/xfs/Makefile
> >>+++ b/fs/xfs/Makefile
> >>@@ -52,6 +52,7 @@ xfs-y				+= $(addprefix libxfs/, \
> >>  				   xfs_inode_fork.o \
> >>  				   xfs_inode_buf.o \
> >>  				   xfs_log_rlimit.o \
> >>+				   xfs_parent.o \
> >>  				   xfs_ag_resv.o \
> >>  				   xfs_rmap.o \
> >>  				   xfs_rmap_btree.o \
> >>diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >>index 8f8bfff9..8aad242 100644
> >>--- a/fs/xfs/libxfs/xfs_attr.c
> >>+++ b/fs/xfs/libxfs/xfs_attr.c
> >>@@ -91,12 +91,14 @@ xfs_attr_args_init(
> >>  	args->whichfork = XFS_ATTR_FORK;
> >>  	args->dp = dp;
> >>  	args->flags = flags;
> >>-	args->name = name;
> >>-	args->namelen = namelen;
> >>-	if (args->namelen >= MAXNAMELEN)
> >>-		return -EFAULT;		/* match IRIX behaviour */
> >>+	if (name) {
> >When do we have a NULL name?
> 
> Ideally we shouldn't, though on a remove we should have a NULL value, since
> we only need the name.  I suppose I'm still in the habit of coding
> defensively
> though it may make since to generate the oops, or even add an assert if it
> happens.
> Thx!

ASSERT(name != NULL);

at the top of the function if you think it's particularly likely to happen
or if it's likely that tracing an oops back to the source will be difficult.

(The ASSERTs are useful if you hand off work to a workqueue or any other
process such that the call stack is interrupted.)

> 
> >>+		args->name = name;
> >>+		args->namelen = namelen;
> >>+		if (args->namelen >= MAXNAMELEN)
> >>+			return -EFAULT;		/* match IRIX behaviour */
> >>-	args->hashval = xfs_da_hashname(args->name, args->namelen);
> >>+		args->hashval = xfs_da_hashname(args->name, args->namelen);
> >>+	}
> >>  	return 0;
> >>  }
> >>@@ -206,6 +208,65 @@ xfs_attr_calc_size(
> >>  }
> >>  /*
> >>+ * Add the initial parent pointer attribute.
> >>+ *
> >>+ * Inode must be locked and completely empty as we are adding the attribute
> >>+ * fork to the inode. This open codes bits of xfs_bmap_add_attrfork() and
> >>+ * xfs_attr_set() because we know the inode is completely empty at this point
> >Hrmm... in general I don't like opencoding bits of other functions
> >without a good justification.
> >
> >>+ * and so don't need to handle all the different combinations of fork
> >>+ * configurations here.
> >>+ */
> >>+int
> >>+xfs_attr_set_first_parent(
> >>+	struct xfs_trans	*tp,
> >>+	struct xfs_inode	*ip,
> >>+	struct xfs_parent_name_rec *rec,
> >>+	int			reclen,
> >>+	const char		*value,
> >>+	int			valuelen,
> >>+	struct xfs_defer_ops	*dfops,
> >>+	xfs_fsblock_t		*firstblock)
> >These all need one more level of indentation due to struct xfs_parent_name_rec.
> Sure, I will push those out a level
> >>+{
> >>+	struct xfs_da_args	args;
> >>+	int			flags = ATTR_PARENT;
> >>+	int			local;
> >>+	int			sf_size;
> >>+	int			error;
> >>+
> >>+	tp->t_flags |= XFS_TRANS_RESERVE;
> >>+
> >>+	error = xfs_attr_args_init(&args, ip, (char *)rec, reclen, flags);
> >>+	if (error)
> >>+		return error;
> >>+
> >>+	args.name = (char *)rec;
> >>+	args.namelen = reclen;
> >>+	args.hashval = xfs_da_hashname(args.name, args.namelen);
> >Aren't these already set by xfs_attr_args_init?
> Some of them are: name, namelen, hashval, dp, and flags.
> But not firstblock dfops, op_flags, total, or trans.
> 
> I guess I kind of liked seeing things initialized all in one spot rather
> than split up like that. But it shouldn't hurt anything to remove the
> re-inits if that is not preferable.

Me too, but so long as we /do/ have a partial initialization function,
there's no need to set fields twice.

> >>+	args.value = (char *)value;
> >>+	args.valuelen = valuelen;
> >>+	args.firstblock = firstblock;
> >>+	args.dfops = dfops;
> >>+	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> >>+	args.total = xfs_attr_calc_size(&args, &local);
> >>+	args.trans = tp;
> >>+	ASSERT(local);
> >>+
> >>+	/* set the attribute fork appropriately */
> >>+	sf_size = sizeof(struct xfs_attr_sf_hdr) +
> >>+			XFS_ATTR_SF_ENTSIZE_BYNAME(reclen, valuelen);
> >>+	xfs_bmap_set_attrforkoff(ip, sf_size, NULL);
> >>+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> >>+	ip->i_afp->if_flags = XFS_IFEXTENTS;
> >>+
> >>+
> >>+	/* Try to add the attr to the attribute list in the inode. */
> >>+	xfs_attr_shortform_create(&args);
> >Are we sure that we'll always be able to cram the parent attribute into
> >the shortform area?  Minimum inode size is 512 bytes, core size is
> >currently 176 bytes, max parent attribute size is ~280 bytes... I guess
> >that works.
> >
> >But I wouldn't want this to blow up some day when the inode core gets
> >bigger and this no longer fits.  Will using the regular xfs_attr_set
> >function cover all these sizing cases?  What's the benefit to all this
> >short circuiting?
> 
> Hmm, I'm going to speculate that the original intent was to optimize
> on the current conditions of the inode and the attrs fitting in just
> right?  (Dave may need to correct me if that's not right....).

I guess the attraction here is that so long as the attr fits, we can
initialize the inode and link it into a directory in a single
transaction without having to resort to defer_ops and other heavier
machinery.

Hmm.  xfs_bmap_add_attrfork allocates its own transaction, as does
xfs_attr_set.  If I may make a suggestion: a pair of functions that
takes an existing transaction context and tries to set up the attr fork,
erroring out if the attr fork is already set up and not in LOCAL format;
and a second function that also takes an existing transaction context
and tries to add a shortform attr, erroring out if there's no room.
Then your xfs_parent_create function can try to use both functions, and
if they don't succeed resort to the heavier defer_ops versions.

--D

> You make good points though.  Unless someone has an objection, I
> can put in the normal xfs_attr_set
> 
> >>+	error = xfs_attr_shortform_addname(&args);
> >>+
> >>+	return error;
> >>+}
> >>+
> >>+/*
> >>   * set the attribute specified in @args. In the case of the parent attribute
> >>   * being set, we do not want to roll the transaction on shortform-to-leaf
> >>   * conversion, as the attribute must be added in the same transaction as the
> >>diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> >>index 044a363..7ee98be 100644
> >>--- a/fs/xfs/libxfs/xfs_bmap.c
> >>+++ b/fs/xfs/libxfs/xfs_bmap.c
> >>@@ -1066,6 +1066,35 @@ xfs_bmap_add_attrfork_local(
> >>  	return -EFSCORRUPTED;
> >>  }
> >>+int
> >>+xfs_bmap_set_attrforkoff(
> >>+	struct xfs_inode	*ip,
> >>+	int			size,
> >>+	int			*version)
> >>+{
> >>+	switch (ip->i_d.di_format) {
> >>+	case XFS_DINODE_FMT_DEV:
> >>+		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
> >>+		break;
> >>+	case XFS_DINODE_FMT_UUID:
> >>+		ip->i_d.di_forkoff = roundup(sizeof(uuid_t), 8) >> 3;
> >>+		break;
> >>+	case XFS_DINODE_FMT_LOCAL:
> >>+	case XFS_DINODE_FMT_EXTENTS:
> >>+	case XFS_DINODE_FMT_BTREE:
> >>+		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
> >>+		if (!ip->i_d.di_forkoff)
> >>+			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> >>+		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
> >>+			*version = 2;
> >>+		break;
> >>+	default:
> >>+		ASSERT(0);
> >>+		return -EINVAL;
> >>+	}
> >>+	return 0;
> >>+}
> >>+
> >>  /*
> >>   * Convert inode from non-attributed to attributed.
> >>   * Must not be in a transaction, ip must not be locked.
> >>@@ -1120,27 +1149,7 @@ xfs_bmap_add_attrfork(
> >>  	xfs_trans_ijoin(tp, ip, 0);
> >>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> >>-	switch (ip->i_d.di_format) {
> >>-	case XFS_DINODE_FMT_DEV:
> >>-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
> >>-		break;
> >>-	case XFS_DINODE_FMT_UUID:
> >>-		ip->i_d.di_forkoff = roundup(sizeof(uuid_t), 8) >> 3;
> >>-		break;
> >>-	case XFS_DINODE_FMT_LOCAL:
> >>-	case XFS_DINODE_FMT_EXTENTS:
> >>-	case XFS_DINODE_FMT_BTREE:
> >>-		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
> >>-		if (!ip->i_d.di_forkoff)
> >>-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> >>-		else if (mp->m_flags & XFS_MOUNT_ATTR2)
> >>-			version = 2;
> >>-		break;
> >>-	default:
> >>-		ASSERT(0);
> >>-		error = -EINVAL;
> >>-		goto trans_cancel;
> >>-	}
> >>+	xfs_bmap_set_attrforkoff(ip, size, &version);
> >>  	ASSERT(ip->i_afp == NULL);
> >>  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> >>diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> >>index 851982a..533f40f 100644
> >>--- a/fs/xfs/libxfs/xfs_bmap.h
> >>+++ b/fs/xfs/libxfs/xfs_bmap.h
> >>@@ -209,6 +209,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
> >>  void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
> >>  		xfs_filblks_t len);
> >>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
> >>+int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
> >>  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> >>  void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> >>  			  xfs_fsblock_t bno, xfs_filblks_t len,
> >>diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> >>new file mode 100644
> >>index 0000000..88f7edc
> >>--- /dev/null
> >>+++ b/fs/xfs/libxfs/xfs_parent.c
> >>@@ -0,0 +1,98 @@
> >>+/*
> >>+ * Copyright (c) 2015 Red Hat, Inc.
> >>+ * All rights reserved.
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or
> >>+ * modify it under the terms of the GNU General Public License as
> >>+ * published by the Free Software Foundation.
> >>+ *
> >>+ * This program is distributed in the hope that it would be useful,
> >>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>+ * GNU General Public License for more details.
> >>+ *
> >>+ * You should have received a copy of the GNU General Public License
> >>+ * along with this program; if not, write the Free Software Foundation
> >>+ */
> >>+#include "xfs.h"
> >>+#include "xfs_fs.h"
> >>+#include "xfs_format.h"
> >>+#include "xfs_log_format.h"
> >>+#include "xfs_shared.h"
> >>+#include "xfs_trans_resv.h"
> >>+#include "xfs_mount.h"
> >>+#include "xfs_bmap_btree.h"
> >>+#include "xfs_inode.h"
> >>+#include "xfs_error.h"
> >>+#include "xfs_trace.h"
> >>+#include "xfs_trans.h"
> >>+#include "xfs_attr.h"
> >>+
> >>+/*
> >>+ * Parent pointer attribute handling.
> >>+ *
> >>+ * Because the attribute value is a filename component, it will never be longer
> >>+ * than 255 bytes. This means the attribute will always be a local format
> >>+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
> >>+ * always be larger than this (max is 75% of block size).
> >>+ *
> >>+ * Creating a new parent attribute will always create a new attribute - there
> >>+ * should never, ever be an existing attribute in the tree for a new inode.
> >>+ * ENOSPC behaviour is problematic - creating the inode without the parent
> >>+ * pointer is effectively a corruption, so we allow parent attribute creation
> >>+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
> >>+ * occurring.
> >>+ */
> >>+
> >>+/*
> >>+ * Create the initial parent attribute.
> >>+ *
> >>+ * The initial attribute creation also needs to be atomic w.r.t the parent
> >>+ * directory modification. Hence it needs to run in the same transaction and the
> >>+ * transaction committed by the caller.  Because the attribute created is
> >>+ * guaranteed to be a local attribute and is always going to be the first
> >>+ * attribute in the attribute fork, we can do this safely in the single
> >>+ * transaction context as it is impossible for an overwrite to occur and hence
> >>+ * we'll never have a rolling overwrite transaction occurring here. Hence we
> >>+ * can short-cut a lot of the normal xfs_attr_set() code paths that are needed
> >>+ * to handle the generic cases.
> >Is there some other part of inode creation (ACL propagation?) that
> >thinks it could be the creator of the first attribute and will react
> >negatively to this?
> Hmm, not that I can think of, but I wonder if there was at the time?
> >>+ */
> >>+static int
> >>+xfs_parent_create_nrec(
> >>+	struct xfs_trans	*tp,
> >>+	struct xfs_inode	*child,
> >>+	struct xfs_parent_name_irec *nrec,
> >>+	struct xfs_defer_ops	*dfops,
> >>+	xfs_fsblock_t		*firstblock)
> >>+{
> >>+	struct xfs_parent_name_rec rec;
> >>+
> >>+	rec.p_ino = cpu_to_be64(nrec->p_ino);
> >>+	rec.p_gen = cpu_to_be32(nrec->p_gen);
> >>+	rec.p_diroffset = cpu_to_be32(nrec->p_diroffset);
> >The disk->header and header->disk converters should be their own
> >functions so that later when I add parent pointer iterators I can pass
> >the irec to the iterator function directly.
> >
> >(Granted I could just as easily do that later in my own patch...)
> >
> I don't mind adding here if we're already have a need for it.  Saves time
> changing it later :-)
> >>+
> >>+	return xfs_attr_set_first_parent(tp, child, &rec, sizeof(rec),
> >>+				   nrec->p_name, nrec->p_namelen,
> >>+				   dfops, firstblock);
> >>+}
> >>+
> >>+int
> >>+xfs_parent_create(
> >What's this function do?  (Needs comment.)
> >
> >--D
> This is the subroutine that we use during creation, but I think you
> pointed out some issues with it in your later reviews, since this should
> probably be part of the deferred operation code. I will add comments
> when I revise it though.  Thx!
> 
> >>+	struct xfs_trans	*tp,
> >>+	struct xfs_inode	*parent,
> >>+	struct xfs_inode	*child,
> >>+	struct xfs_name		*child_name,
> >>+	xfs_dir2_dataptr_t	diroffset,
> >>+	struct xfs_defer_ops	*dfops,
> >>+	xfs_fsblock_t		*firstblock)
> >>+{
> >>+	struct xfs_parent_name_irec nrec;
> >>+
> >>+	nrec.p_ino = parent->i_ino;
> >>+	nrec.p_gen = VFS_I(parent)->i_generation;
> >>+	nrec.p_diroffset = diroffset;
> >>+	nrec.p_name = child_name->name;
> >>+	nrec.p_namelen = child_name->len;
> >>+
> >>+	return xfs_parent_create_nrec(tp, child, &nrec, dfops, firstblock);
> >>+}
> >>diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
> >>index 7901c3b..b48e31b 100644
> >>--- a/fs/xfs/xfs_attr.h
> >>+++ b/fs/xfs/xfs_attr.h
> >>@@ -19,6 +19,8 @@
> >>  #define	__XFS_ATTR_H__
> >>  #include "libxfs/xfs_defer.h"
> >>+#include "libxfs/xfs_da_format.h"
> >>+#include "libxfs/xfs_format.h"
> >>  struct xfs_inode;
> >>  struct xfs_da_args;
> >>@@ -183,5 +185,16 @@ int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
> >>  int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
> >>  			    const unsigned char *name, unsigned int namelen,
> >>  			    int flags);
> >>-
> >>+/*
> >>+ * Parent pointer attribute prototypes
> >>+ */
> >>+int xfs_parent_create(struct xfs_trans *tp, struct xfs_inode *parent,
> >>+		      struct xfs_inode *child, struct xfs_name *child_name,
> >>+		      xfs_dir2_dataptr_t diroffset, struct xfs_defer_ops *dfops,
> >>+		      xfs_fsblock_t *firstblock);
> >>+int xfs_attr_set_first_parent(struct xfs_trans *tp, struct xfs_inode *ip,
> >>+			      struct xfs_parent_name_rec *rec, int reclen,
> >>+			      const char *value, int valuelen,
> >>+			      struct xfs_defer_ops *dfops,
> >>+			      xfs_fsblock_t *firstblock);
> >>  #endif	/* __XFS_ATTR_H__ */
> >>diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >>index f7986d8..4396561 100644
> >>--- a/fs/xfs/xfs_inode.c
> >>+++ b/fs/xfs/xfs_inode.c
> >>@@ -1164,6 +1164,7 @@ xfs_create(
> >>  	struct xfs_dquot	*pdqp = NULL;
> >>  	struct xfs_trans_res	*tres;
> >>  	uint			resblks;
> >>+	xfs_dir2_dataptr_t	diroffset;
> >>  	trace_xfs_create(dp, name);
> >>@@ -1253,7 +1254,7 @@ xfs_create(
> >>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> >>  					&first_block, &dfops, resblks ?
> >>  					resblks - XFS_IALLOC_SPACE_RES(mp) : 0,
> >>-					NULL);
> >>+					&diroffset);
> >>  	if (error) {
> >>  		ASSERT(error != -ENOSPC);
> >>  		goto out_trans_cancel;
> >>@@ -1272,6 +1273,19 @@ xfs_create(
> >>  	}
> >>  	/*
> >>+	 * If we have parent pointers, we need to add the attribute containing
> >>+	 * the parent information now. This must be done within the same
> >>+	 * transaction the directory entry is created, while the new inode
> >>+	 * contains nothing in the inode literal area.
> >>+	 */
> >>+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> >>+		error = xfs_parent_create(tp, dp, ip, name, diroffset,
> >>+					  &dfops, &first_block);
> >>+		if (error)
> >>+			goto out_bmap_cancel;
> >>+	}
> >>+
> >>+	/*
> >>  	 * If this is a synchronous mount, make sure that the
> >>  	 * create transaction goes to disk before returning to
> >>  	 * the user.
> >>-- 
> >>2.7.4
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >>the body of a message tomajordomo@vger.kernel.org
> >>More majordomo info athttp://vger.kernel.org/majordomo-info.html
> 
