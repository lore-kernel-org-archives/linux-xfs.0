Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 99C7E29E01
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:34:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8744F8F8033
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:34:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id lmxC9IUObsHepyho (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:34:35 -0700 (PDT)
Subject: [PATCH 14/24] xfs: implement copy-on-write for reflinked blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:34:28 -0700
Message-ID: <20150729223428.17414.64576.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Implement a copy-on-write handler for the buffered write path.  When
writepages is called, allocate a new block (which we then tell the log
that we intend to delete so that it's freed if we crash), and then
write the buffer to the new block.  Upon completion, remove the freed
block intent from the log and remap the file so that the changes
appear.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/xfs_aops.c    |   52 +++
 fs/xfs/xfs_aops.h    |    5 
 fs/xfs/xfs_file.c    |   11 +
 fs/xfs/xfs_icache.c  |    3 
 fs/xfs/xfs_inode.h   |    2 
 fs/xfs/xfs_reflink.c |  752 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |   41 +++
 8 files changed, 860 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/xfs_reflink.c
 create mode 100644 fs/xfs/xfs_reflink.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 90309ec..91992a9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -88,6 +88,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_reflink.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
 				   xfs_sysfs.o \
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3859f5e..7332d72 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -31,6 +31,8 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
+#include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
@@ -192,6 +194,8 @@ xfs_finish_ioend(
 
 		if (ioend->io_type == XFS_IO_UNWRITTEN)
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
+		else if (ioend->io_type == XFS_IO_FORKED)
+			queue_work(mp->m_cow_workqueue, &ioend->io_work);
 		else if (ioend->io_append_trans)
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
 		else
@@ -214,6 +218,25 @@ xfs_end_io(
 		ioend->io_error = -EIO;
 		goto done;
 	}
+
+	/*
+	 * If we forked the block, we need to remap the bmbt and possibly
+	 * finish up the i_size transaction too... or clean up after a
+	 * failed write.
+	 */
+	if (ioend->io_type == XFS_IO_FORKED) {
+		if (ioend->io_error) {
+			error = xfs_reflink_cancel_fork_ioend(ioend);
+			goto done;
+		}
+		error = xfs_reflink_fork_ioend(ioend);
+		if (error)
+			goto done;
+		if (ioend->io_append_trans)
+			error = xfs_setfilesize_ioend(ioend);
+		goto done;
+	}
+
 	if (ioend->io_error)
 		goto done;
 
@@ -268,6 +291,7 @@ xfs_alloc_ioend(
 	ioend->io_append_trans = NULL;
 
 	INIT_WORK(&ioend->io_work, xfs_end_io);
+	INIT_LIST_HEAD(&ioend->io_reflink_endio_list);
 	return ioend;
 }
 
@@ -550,6 +574,7 @@ xfs_cancel_ioend(
 		} while ((bh = next_bh) != NULL);
 
 		mempool_free(ioend, xfs_ioend_pool);
+		xfs_reflink_cancel_fork_ioend(ioend);
 	} while ((ioend = next) != NULL);
 }
 
@@ -566,7 +591,8 @@ xfs_add_to_ioend(
 	xfs_off_t		offset,
 	unsigned int		type,
 	xfs_ioend_t		**result,
-	int			need_ioend)
+	int			need_ioend,
+	struct xfs_reflink_ioend	*eio)
 {
 	xfs_ioend_t		*ioend = *result;
 
@@ -587,6 +613,8 @@ xfs_add_to_ioend(
 
 	bh->b_private = NULL;
 	ioend->io_size += bh->b_size;
+	if (eio)
+		xfs_reflink_add_ioend(ioend, eio);
 }
 
 STATIC void
@@ -787,7 +815,7 @@ xfs_convert_page(
 			if (type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type,
-					 ioendp, done);
+					 ioendp, done, NULL);
 
 			page_dirty--;
 			count++;
@@ -950,6 +978,8 @@ xfs_vm_writepage(
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
 	int			nonblocking = 0;
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			err2 = 0;
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
@@ -1118,11 +1148,15 @@ xfs_vm_writepage(
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 		}
 		if (imap_valid) {
+			struct xfs_reflink_ioend *eio = NULL;
+
+			err2 = xfs_reflink_write_fork_block(ip, &imap, offset,
+						     &type, &eio);
 			lock_buffer(bh);
 			if (type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
-					 new_ioend);
+					 new_ioend, eio);
 			count++;
 		}
 
@@ -1136,6 +1170,9 @@ xfs_vm_writepage(
 
 	xfs_start_page_writeback(page, 1, count);
 
+	if (err)
+		goto error;
+
 	/* if there is no IO to be submitted for this page, we are done */
 	if (!ioend)
 		return 0;
@@ -1170,8 +1207,9 @@ xfs_vm_writepage(
 	/*
 	 * Reserve log space if we might write beyond the on-disk inode size.
 	 */
-	err = 0;
-	if (ioend->io_type != XFS_IO_UNWRITTEN && xfs_ioend_is_append(ioend))
+	err = err2;
+	if (!err && ioend->io_type != XFS_IO_UNWRITTEN &&
+	    xfs_ioend_is_append(ioend))
 		err = xfs_setfilesize_trans_alloc(ioend);
 
 	xfs_submit_ioend(wbc, iohead, err);
@@ -1821,6 +1859,10 @@ xfs_vm_write_begin(
 	if (!page)
 		return -ENOMEM;
 
+	status = xfs_reflink_reserve_fork_block(XFS_I(mapping->host), pos, len);
+	if (status)
+		return status;
+
 	status = __block_write_begin(page, pos, len, xfs_get_blocks);
 	if (unlikely(status)) {
 		struct inode	*inode = mapping->host;
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 86afd1a..9cf206a 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -27,12 +27,14 @@ enum {
 	XFS_IO_DELALLOC,	/* covers delalloc region */
 	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
 	XFS_IO_OVERWRITE,	/* covers already allocated extent */
+	XFS_IO_FORKED,		/* covers copy-on-write region */
 };
 
 #define XFS_IO_TYPES \
 	{ XFS_IO_DELALLOC,		"delalloc" }, \
 	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
-	{ XFS_IO_OVERWRITE,		"overwrite" }
+	{ XFS_IO_OVERWRITE,		"overwrite" }, \
+	{ XFS_IO_FORKED,		"forked" }
 
 /*
  * xfs_ioend struct manages large extent writes for XFS.
@@ -50,6 +52,7 @@ typedef struct xfs_ioend {
 	xfs_off_t		io_offset;	/* offset in the file */
 	struct work_struct	io_work;	/* xfsdatad work queue */
 	struct xfs_trans	*io_append_trans;/* xact. for size update */
+	struct list_head	io_reflink_endio_list;/* remappings for CoW */
 } xfs_ioend_t;
 
 extern const struct address_space_operations xfs_address_space_operations;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f0e8249..981b028 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include "xfs_log.h"
 #include "xfs_icache.h"
 #include "xfs_pnfs.h"
+#include "xfs_reflink.h"
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
@@ -1495,6 +1496,14 @@ xfs_filemap_page_mkwrite(
 	file_update_time(vma->vm_file);
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
+	/* Set up the remapping for a CoW mmap'd page */
+	ret = xfs_reflink_reserve_fork_block(XFS_I(inode),
+			vmf->page->index << PAGE_CACHE_SHIFT, PAGE_CACHE_SIZE);
+	if (ret) {
+		ret = block_page_mkwrite_return(ret);
+		goto out;
+	}
+
 	if (IS_DAX(inode)) {
 		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_direct,
 				    xfs_end_io_dax_write);
@@ -1502,7 +1511,7 @@ xfs_filemap_page_mkwrite(
 		ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
 		ret = block_page_mkwrite_return(ret);
 	}
-
+out:
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 76a9f27..fec0647 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -33,6 +33,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_reflink.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -80,6 +81,7 @@ xfs_inode_alloc(
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
 	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	ip->i_remaps = RB_ROOT;
 
 	return ip;
 }
@@ -115,6 +117,7 @@ xfs_inode_free(
 		ip->i_itemp = NULL;
 	}
 
+	xfs_reflink_cancel_fork_blocks(ip);
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always
 	 * appears to be reclaimed with an invalid inode number when in the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 6153cf2..f405634 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -65,6 +65,8 @@ typedef struct xfs_inode {
 
 	xfs_icdinode_t		i_d;		/* most of ondisk inode */
 
+	struct rb_root		i_remaps;	/* CoW remappings in progress */
+
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
 } xfs_inode_t;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
new file mode 100644
index 0000000..263f30b
--- /dev/null
+++ b/fs/xfs/xfs_reflink.c
@@ -0,0 +1,752 @@
+/*
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_error.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_ioctl.h"
+#include "xfs_trace.h"
+#include "xfs_log.h"
+#include "xfs_icache.h"
+#include "xfs_pnfs.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_bit.h"
+#include "xfs_alloc.h"
+#include "xfs_quota_defs.h"
+#include "xfs_quota.h"
+#include "xfs_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
+
+#define CHECK_AG_NUMBER(mp, agno) \
+	do { \
+		ASSERT((agno) != NULLAGNUMBER); \
+		ASSERT((agno) < (mp)->m_sb.sb_agcount); \
+	} while(0);
+
+#define CHECK_AG_EXTENT(mp, agbno, len) \
+	do { \
+		ASSERT((agbno) != NULLAGBLOCK); \
+		ASSERT((len) > 0); \
+		ASSERT((unsigned long long)(agbno) + (len) <= \
+				(mp)->m_sb.sb_agblocks); \
+	} while(0);
+
+struct xfs_reflink_ioend {
+	struct rb_node		rlei_node;	/* tree of pending remappings */
+	struct list_head	rlei_list;	/* list of reflink ioends */
+	struct xfs_bmbt_irec	rlei_mapping;	/* new bmbt mapping to put in */
+	struct xfs_efi_log_item	*rlei_efi;	/* efi log item to cancel */
+	xfs_fsblock_t		rlei_oldfsbno;	/* old fsbno */
+};
+
+/**
+ * xfs_reflink_get_refcount() - get refcount and extent length for a given pblk
+ *
+ * @mp: XFS mount object
+ * @agno: AG number
+ * @agbno: AG block number
+ * @len: length of extent
+ * @nr: refcount
+ */
+int
+xfs_reflink_get_refcount(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		*len,
+	xfs_nlink_t		*nr)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agbp;
+	struct xfs_refcount_irec	tmp;
+	xfs_extlen_t		aglen;
+	int			error;
+	int			i, have;
+	int			bt_error;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+		*len = 0;
+		*nr = 1;
+		return 0;
+	}
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+	aglen = be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length);
+	ASSERT(agbno < aglen);
+
+	/*
+	 * See if there's an extent covering the block we want.
+	 */
+	bt_error = XFS_BTREE_ERROR;
+	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+	error = xfs_refcountbt_lookup_le(cur, agbno, &have);
+	if (error)
+		goto out_error;
+	if (!have)
+		goto hole;
+	error = xfs_refcountbt_get_rec(cur, &tmp, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno)
+		goto hole;
+
+	*len = tmp.rc_blockcount - (agbno - tmp.rc_startblock);
+	*nr = tmp.rc_refcount;
+	goto out;
+
+hole:
+	/*
+	 * We're in a hole, so pretend that this we have a refcount=1 extent
+	 * going to the next rlextent or the end of the AG.
+	 */
+	error = xfs_btree_increment(cur, 0, &have);
+	if (error)
+		goto out_error;
+	if (!have)
+		*len = aglen - agbno;
+	else {
+		error = xfs_refcountbt_get_rec(cur, &tmp, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		*len = tmp.rc_startblock - agbno;
+	}
+	*nr = 1;
+
+out:
+	bt_error = XFS_BTREE_NOERROR;
+out_error:
+	xfs_btree_del_cursor(cur, bt_error);
+	xfs_buf_relse(agbp);
+	return error;
+}
+
+/*
+ * Allocate a replacement block for a copy-on-write operation.
+ *
+ * XXX: Ideally we'd scan up and down the incore extent list
+ * looking for a block, but do this stupid thing for now.
+ */
+STATIC int
+fork_one_block(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		old,
+	xfs_fsblock_t		*new)
+{
+	int			error;
+	struct xfs_alloc_arg	args;		/* allocation arguments */
+
+	memset(&args, 0, sizeof(args));
+	args.tp = tp;
+	args.mp = mp;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.firstblock = args.fsbno = old;
+	args.minlen = args.maxlen = args.prod = 1;
+	args.userdata = XFS_ALLOC_USERDATA;
+	args.owner = ip->i_ino;
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto out_error;
+	ASSERT(args.len == 1);
+	ASSERT(args.fsbno != old);
+	*new = args.fsbno;
+
+out_error:
+	return error;
+}
+
+/* Compare two reflink ioend structures */
+STATIC int
+ioend_compare(
+	struct xfs_reflink_ioend	*i1,
+	struct xfs_reflink_ioend	*i2)
+{
+	if (i1->rlei_mapping.br_startoff > i2->rlei_mapping.br_startoff)
+		return 1;
+	if (i1->rlei_mapping.br_startoff < i2->rlei_mapping.br_startoff)
+		return -1;
+	return 0;
+}
+
+/* Attach a remapping object to an inode. */
+STATIC int
+remap_insert(
+	struct xfs_inode		*ip,
+	struct xfs_reflink_ioend	*eio)
+{
+	struct rb_node			**new = &(ip->i_remaps.rb_node);
+	struct rb_node			*parent = NULL;
+	struct xfs_reflink_ioend	*this;
+	int				result;
+
+        /* Figure out where to put new node */
+        while (*new) {
+                this = rb_entry(*new, struct xfs_reflink_ioend, rlei_node);
+		result = ioend_compare(eio, this);
+
+                parent = *new;
+                if (result < 0)
+                        new = &((*new)->rb_left);
+                else if (result > 0)
+                        new = &((*new)->rb_right);
+                else
+                        return -EEXIST;
+        }
+
+        /* Add new node and rebalance tree. */
+        rb_link_node(&eio->rlei_node, parent, new);
+        rb_insert_color(&eio->rlei_node, &ip->i_remaps);
+
+        return 0;
+}
+
+/* Find a remapping object for a block in an inode */
+STATIC int
+remap_search(
+	struct xfs_inode		*ip,
+	xfs_fileoff_t			fsbno,
+	struct xfs_reflink_ioend	**peio)
+{
+	struct rb_node			*node = ip->i_remaps.rb_node;
+	struct xfs_reflink_ioend	*data;
+	int				result;
+	struct xfs_reflink_ioend	f;
+
+	f.rlei_mapping.br_startoff = fsbno;
+        while (node) {
+                data = rb_entry(node, struct xfs_reflink_ioend, rlei_node);
+		result = ioend_compare(&f, data);
+
+                if (result < 0)
+                        node = node->rb_left;
+                else if (result > 0)
+                        node = node->rb_right;
+                else {
+			*peio = data;
+                        return 0;
+		}
+        }
+
+        return -ENOENT;
+}
+
+/* Allocate a block to handle a copy on write later. */
+STATIC int
+__reserve_fork_block(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset)
+{
+	xfs_fsblock_t		fsbno;
+	xfs_fsblock_t		new_fsbno;
+	xfs_off_t		iomap_offset;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	struct xfs_trans	*tp = NULL;
+	int			error;
+	struct xfs_reflink_ioend	*eio;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	ASSERT(xfs_is_reflink_inode(ip));
+	iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	fsbno = imap->br_startblock + XFS_B_TO_FSB(mp, offset - iomap_offset);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+	ASSERT(imap->br_state == XFS_EXT_NORM);
+
+	/* If we've already got a remapping, we're done. */
+	error = remap_search(ip, XFS_B_TO_FSB(mp, offset), &eio);
+	if (!error)
+		return 0;
+
+	/*
+	 * Ok, we have to fork this block.  Allocate a replacement block,
+	 * stash the new mapping, and add an EFI entry for recovery.  When
+	 * the (redirected) IO completes, we'll deal with remapping.
+	 */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+				  XFS_DIOSTRAT_SPACE_RES(mp, 2), 0);
+	if (error)
+		goto out_cancel;
+
+	error = fork_one_block(mp, tp, ip, fsbno, &new_fsbno);
+	if (error)
+		goto out_cancel;
+
+	trace_xfs_reflink_reserve_fork_block(ip, XFS_B_TO_FSB(mp, offset),
+			fsbno, 1, new_fsbno);
+
+	eio = kmem_zalloc(sizeof(*eio), KM_SLEEP | KM_NOFS);
+	eio->rlei_mapping.br_startblock = new_fsbno;
+	eio->rlei_mapping.br_startoff = XFS_B_TO_FSB(mp, offset);
+	eio->rlei_mapping.br_blockcount = 1;
+	eio->rlei_mapping.br_state = XFS_EXT_NORM;
+	eio->rlei_oldfsbno = fsbno;
+	eio->rlei_efi = xfs_trans_get_efi(tp, 1);
+	xfs_trans_log_efi_extent(tp, eio->rlei_efi, new_fsbno, 1);
+
+	error = remap_insert(ip, eio);
+	if (error)
+		goto out_cancel;
+
+	/*
+	 * ...and we're done.
+	 */
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+
+	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_reserve_fork_block_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_reflink_reserve_fork_block() -- Allocate blocks to satisfy a copy on
+ *				       write operation.
+ * @ip: XFS inode
+ * @pos: file offset to start forking
+ * @len: number of bytes to fork
+ */
+int
+xfs_reflink_reserve_fork_block(
+	struct xfs_inode	*ip,
+	xfs_off_t		pos,
+	xfs_off_t		len)
+{
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	int			error;
+	xfs_fileoff_t		lblk;
+	xfs_fileoff_t		next_lblk;
+	xfs_off_t		offset;
+	bool			type;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	trace_xfs_reflink_force_getblocks(ip, len, pos, 0);
+
+	error = 0;
+	lblk = XFS_B_TO_FSBT(ip->i_mount, pos);
+	next_lblk = 1 + XFS_B_TO_FSBT(ip->i_mount, pos + len - 1);
+	while (lblk < next_lblk) {
+		offset = XFS_FSB_TO_B(ip->i_mount, lblk);
+		/* Read extent from the source file */
+		nimaps = 1;
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmapi_read(ip, lblk, next_lblk - lblk, &imap,
+				&nimaps, 0);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			break;
+
+		if (nimaps == 0)
+			break;
+
+		error = xfs_reflink_should_fork_block(ip, &imap, offset, &type);
+		if (error)
+			break;
+		if (!type)
+			goto advloop;
+
+		error = __reserve_fork_block(ip, &imap, offset);
+		if (error)
+			break;
+
+advloop:
+		lblk += imap.br_blockcount;
+	}
+
+	return error;
+}
+
+/**
+ * xfs_reflink_write_fork_block() -- find a remapping object and redirect the
+ *				     write.
+ *
+ * @ip: XFS inode
+ * @offset: file offset we're trying to write
+ * @imap: the mapping for this block (I/O)
+ * @type: the io type (I/O)
+ * @peio: pointer to a reflink ioend; caller must attach to an ioend (O)
+ */
+int
+xfs_reflink_write_fork_block(
+	struct xfs_inode		*ip,
+	struct xfs_bmbt_irec		*imap,
+	xfs_off_t			offset,
+	unsigned int			*type,
+	struct xfs_reflink_ioend	**peio)
+{
+	int				error;
+	struct xfs_reflink_ioend	*eio = NULL;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+	if (*type == XFS_IO_DELALLOC || *type == XFS_IO_UNWRITTEN)
+		return 0;
+
+	error = remap_search(ip, XFS_B_TO_FSB(ip->i_mount, offset), &eio);
+	if (error == -ENOENT)
+		return 0;
+	else if (error) {
+		trace_xfs_reflink_write_fork_block_error(ip, error, _RET_IP_);
+		return error;
+	}
+
+	trace_xfs_reflink_write_fork_block(ip, eio->rlei_mapping.br_startoff,
+			eio->rlei_oldfsbno, 1, eio->rlei_mapping.br_startblock);
+
+	*imap = eio->rlei_mapping;
+	*type = XFS_IO_FORKED;
+	*peio = eio;
+	return 0;
+}
+
+/* Remap a range of file blocks after forking. */
+STATIC int
+xfs_reflink_remap_after_io(
+	struct xfs_mount		*mp,
+	struct xfs_inode		*ip,
+	struct xfs_reflink_ioend	*eio)
+{
+	struct xfs_trans	*tp = NULL;
+	int			error;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_fsblock_t		firstfsb;
+	int			committed;
+	struct xfs_bmbt_irec	imaps[1];
+	int			nimaps = 1;
+	int			done;
+	struct xfs_bmap_free	free_list;
+	struct xfs_bmbt_irec	*imap = &eio->rlei_mapping;
+	struct xfs_efd_log_item	*efd;
+	unsigned int		resblks;
+
+	ASSERT(xfs_is_reflink_inode(ip));
+	agno = XFS_FSB_TO_AGNO(mp, imap->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, imap->br_startblock);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+	ASSERT(imap->br_state == XFS_EXT_NORM);
+
+	trace_xfs_reflink_remap_after_io(ip, imap->br_startoff,
+			eio->rlei_oldfsbno, imap->br_blockcount,
+			imap->br_startblock);
+
+
+	/* Delete temporary mapping */
+	error = remap_search(ip, imap->br_startoff, &eio);
+	if (error)
+		return error;
+	rb_erase(&eio->rlei_node, &ip->i_remaps);
+
+	/* Unmap the old blocks */
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, imap->br_blockcount * 3);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+	if (error)
+		goto out_cancel;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	xfs_bmap_init(&free_list, &firstfsb);
+	error = xfs_bunmapi(tp, ip, imap->br_startoff, imap->br_blockcount, 0,
+			imap->br_blockcount, &firstfsb, &free_list, &done);
+	if (error)
+		goto out_freelist;
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+
+	/* Remove the EFD and map the new block into the file. */
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, imap->br_blockcount * 3);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+	if (error)
+		goto out_cancel;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	efd = xfs_trans_get_efd(tp, eio->rlei_efi, 1);
+	xfs_trans_log_efd_extent(tp, efd, imap->br_startblock,
+				 imap->br_blockcount);
+
+	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
+					XFS_BMAPI_EXACT, &imap->br_startblock,
+					0, &imaps[0], &nimaps, &free_list);
+	if (error)
+		goto out_freelist;
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return error;
+
+out_freelist:
+	xfs_bmap_cancel(&free_list);
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_remap_after_io_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_reflink_fork_ioend() - remap all blocks after forking
+ *
+ * @ioend: the io completion object
+ */
+int
+xfs_reflink_fork_ioend(
+	struct xfs_ioend	*ioend)
+{
+	int			error, err2;
+	struct list_head	*pos, *n;
+	struct xfs_reflink_ioend	*eio;
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+
+	error = 0;
+	list_for_each_safe(pos, n, &ioend->io_reflink_endio_list) {
+		eio = list_entry(pos, struct xfs_reflink_ioend, rlei_list);
+		err2 = xfs_reflink_remap_after_io(mp, ip, eio);
+		if (error == 0)
+			error = err2;
+		kfree(eio);
+	}
+	return error;
+}
+
+/**
+ * xfs_reflink_should_fork_block() - determine if a block should be forked
+ *
+ * @ip: XFS inode object
+ * @imap: the fileoff:fsblock mapping that we might fork
+ * @offset: the file offset of the block we're examining
+ * @type: set to true if reflinked, false otherwise.
+ */
+int
+xfs_reflink_should_fork_block(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset,
+	bool			*type)
+{
+	xfs_fsblock_t		fsbno;
+	xfs_off_t		iomap_offset;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_extlen_t		len;
+	xfs_nlink_t		nr;
+	int			error;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!xfs_is_reflink_inode(ip) ||
+	    ISUNWRITTEN(imap) ||
+	    imap->br_startblock == HOLESTARTBLOCK ||
+	    imap->br_startblock == DELAYSTARTBLOCK) {
+		*type = false;
+		return 0;
+	}
+
+	iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	fsbno = imap->br_startblock + XFS_B_TO_FSB(mp, offset - iomap_offset);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+	ASSERT(imap->br_state == XFS_EXT_NORM);
+
+	error = xfs_reflink_get_refcount(mp, agno, agbno, &len, &nr);
+	if (error)
+		return error;
+	ASSERT(len != 0);
+	*type = (nr > 1);
+	return error;
+}
+
+/* Cancel a forked block being held for a CoW operation */
+STATIC int
+xfs_reflink_free_forked(
+	struct xfs_mount		*mp,
+	struct xfs_inode		*ip,
+	struct xfs_reflink_ioend	*eio)
+{
+	struct xfs_trans	*tp = NULL;
+	int			error;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_fsblock_t		firstfsb;
+	int			committed;
+	struct xfs_bmap_free	free_list;
+	struct xfs_bmbt_irec	*imap = &eio->rlei_mapping;
+	struct xfs_efd_log_item	*efd;
+	unsigned int		resblks;
+
+	ASSERT(xfs_is_reflink_inode(ip));
+	agno = XFS_FSB_TO_AGNO(mp, imap->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, imap->br_startblock);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+	ASSERT(imap->br_state == XFS_EXT_NORM);
+
+	trace_xfs_reflink_free_forked(ip, imap->br_startoff,
+			eio->rlei_oldfsbno, imap->br_blockcount,
+			imap->br_startblock);
+
+	/* Remove the EFD and map the new block into the file. */
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, imap->br_blockcount * 3);
+	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+	if (error)
+		goto out_cancel;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	efd = xfs_trans_get_efd(tp, eio->rlei_efi, 1);
+	xfs_trans_log_efd_extent(tp, efd, imap->br_startblock,
+				 imap->br_blockcount);
+
+	xfs_bmap_init(&free_list, &firstfsb);
+	xfs_bmap_add_free(mp, &free_list, imap->br_startblock, 1, ip->i_ino);
+
+	error = xfs_bmap_finish(&tp, &free_list, &committed);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_reflink_free_forked_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_reflink_cancel_fork_ioend() - free all forked blocks attached to an ioend
+ *
+ * @ioend: the io completion object
+ */
+int
+xfs_reflink_cancel_fork_ioend(
+	struct xfs_ioend	*ioend)
+{
+	int			error, err2;
+	struct list_head	*pos, *n;
+	struct xfs_reflink_ioend	*eio;
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+
+	error = 0;
+	list_for_each_safe(pos, n, &ioend->io_reflink_endio_list) {
+		eio = list_entry(pos, struct xfs_reflink_ioend, rlei_list);
+		err2 = xfs_reflink_free_forked(mp, ip, eio);
+		if (error == 0)
+			error = err2;
+		kfree(eio);
+	}
+	return error;
+}
+
+/**
+ * xfs_reflink_cancel_fork_blocks() -- Free all forked blocks attached to an inode.
+ *
+ */
+int
+xfs_reflink_cancel_fork_blocks(
+	struct xfs_inode		*ip)
+{
+	struct rb_node			*node;
+	struct xfs_reflink_ioend	*eio;
+	int				error = 0;
+	int				err2;
+
+	while ((node = rb_first(&ip->i_remaps))) {
+		eio = rb_entry(node, struct xfs_reflink_ioend, rlei_node);
+		err2 = xfs_reflink_free_forked(ip->i_mount, ip, eio);
+		if (error == 0)
+			error = err2;
+		rb_erase(node, &ip->i_remaps);
+		kfree(eio);
+	}
+
+	return error;
+}
+
+/**
+ * xfs_reflink_add_ioend() -- Hook ourselves up to the ioend processing
+ * 			      so that we can finish forking a block after
+ * 			      the write completes.
+ *
+ * @ioend: The regular ioend structure.
+ * @eio: The reflink ioend context.
+ */
+void
+xfs_reflink_add_ioend(
+	struct xfs_ioend		*ioend,
+	struct xfs_reflink_ioend	*eio)
+{
+	list_add_tail(&eio->rlei_list, &ioend->io_reflink_endio_list);
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
new file mode 100644
index 0000000..b3e12d2
--- /dev/null
+++ b/fs/xfs/xfs_reflink.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2015 Oracle.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_REFLINK_H
+#define __XFS_REFLINK_H 1
+
+struct xfs_reflink_ioend;
+
+extern int xfs_reflink_get_refcount(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t *len, xfs_nlink_t *nr);
+extern int xfs_reflink_write_fork_block(struct xfs_inode *ip,
+		struct xfs_bmbt_irec *imap, xfs_off_t offset,
+		unsigned int *type, struct xfs_reflink_ioend **peio);
+extern int xfs_reflink_reserve_fork_block(struct xfs_inode *ip,
+		xfs_off_t pos, xfs_off_t len);
+extern int xfs_reflink_redirect_directio_write(struct xfs_inode *ip,
+		struct xfs_bmbt_irec *imap, xfs_off_t offset);
+extern int xfs_reflink_cancel_fork_ioend(struct xfs_ioend *ioend);
+extern int xfs_reflink_cancel_fork_blocks(struct xfs_inode *ip);
+extern int xfs_reflink_fork_ioend(struct xfs_ioend *ioend);
+extern void xfs_reflink_add_ioend(struct xfs_ioend *ioend,
+		struct xfs_reflink_ioend *eio);
+
+extern int xfs_reflink_should_fork_block(struct xfs_inode *ip,
+		struct xfs_bmbt_irec *imap, xfs_off_t offset, bool *type);
+
+#endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
