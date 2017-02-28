Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32394 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdB1Stq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 13:49:46 -0500
Subject: [PATCH 9/9] ext4: support GETFSMAP ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Feb 2017 10:46:48 -0800
Message-ID: <148830760844.22089.4495592356728562605.stgit@birch.djwong.org>
In-Reply-To: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
References: <148830755018.22089.4423076490708341523.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Support the GETFSMAP ioctls so that we can use the xfs free space
management tools to probe ext4 as well.  Note that this is a partial
implementation -- we only report fixed-location metadata and free space;
everything else is reported as "unknown".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/Makefile            |   10 -
 fs/ext4/fsmap.c             |  709 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/fsmap.h             |   74 ++++
 fs/ext4/ioctl.c             |   94 ++++++
 fs/ext4/mballoc.c           |   49 +++
 fs/ext4/mballoc.h           |   17 +
 fs/ext4/super.c             |    1 
 include/trace/events/ext4.h |   74 ++++
 8 files changed, 1023 insertions(+), 5 deletions(-)
 create mode 100644 fs/ext4/fsmap.c
 create mode 100644 fs/ext4/fsmap.h


diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index d511ffb..961ce09 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -4,11 +4,11 @@
 
 obj-$(CONFIG_EXT4_FS) += ext4.o
 
-ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
-		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
-		mmp.o indirect.o extents_status.o xattr.o xattr_user.o \
-		xattr_trusted.o inline.o readpage.o sysfs.o
+ext4-y	:= balloc.o bitmap.o block_validity.o dir.o ext4_jbd2.o extents.o \
+		extents_status.o file.o fsmap.o fsync.o hash.o ialloc.o \
+		indirect.o inline.o inode.o ioctl.o mballoc.o migrate.o \
+		mmp.o move_extent.o namei.o page-io.o readpage.o resize.o \
+		super.o symlink.o sysfs.o xattr.o xattr_trusted.o xattr_user.o
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
new file mode 100644
index 0000000..5fd4e26
--- /dev/null
+++ b/fs/ext4/fsmap.c
@@ -0,0 +1,709 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "ext4.h"
+#include <linux/fsmap.h>
+#include "fsmap.h"
+#include "mballoc.h"
+#include <linux/sort.h>
+#include <linux/list_sort.h>
+#include <trace/events/ext4.h>
+
+/* Convert an ext4_fsmap to an fsmap. */
+void ext4_fsmap_from_internal(struct super_block *sb, struct fsmap *dest,
+			      struct ext4_fsmap *src)
+{
+	dest->fmr_device = src->fmr_device;
+	dest->fmr_flags = src->fmr_flags;
+	dest->fmr_physical = src->fmr_physical << sb->s_blocksize_bits;
+	dest->fmr_owner = src->fmr_owner;
+	dest->fmr_offset = 0;
+	dest->fmr_length = src->fmr_length << sb->s_blocksize_bits;
+	dest->fmr_reserved[0] = 0;
+	dest->fmr_reserved[1] = 0;
+	dest->fmr_reserved[2] = 0;
+}
+
+/* Convert an fsmap to an ext4_fsmap. */
+void ext4_fsmap_to_internal(struct super_block *sb, struct ext4_fsmap *dest,
+			    struct fsmap *src)
+{
+	dest->fmr_device = src->fmr_device;
+	dest->fmr_flags = src->fmr_flags;
+	dest->fmr_physical = src->fmr_physical >> sb->s_blocksize_bits;
+	dest->fmr_owner = src->fmr_owner;
+	dest->fmr_length = src->fmr_length >> sb->s_blocksize_bits;
+}
+
+/* getfsmap query state */
+struct ext4_getfsmap_info {
+	struct ext4_fsmap_head	*head;
+	struct ext4_fsmap	*rkey_low;	/* lowest key */
+	ext4_fsmap_format_t	formatter;	/* formatting fn */
+	void			*format_arg;	/* format buffer */
+	bool			last;		/* last extent? */
+	ext4_fsblk_t		next_fsblk;	/* next fsblock we expect */
+	u32			dev;		/* device id */
+
+	ext4_group_t		agno;		/* bg number, if applicable */
+	struct ext4_fsmap	low;		/* low rmap key */
+	struct ext4_fsmap	high;		/* high rmap key */
+	struct ext4_fsmap	lastfree;	/* free ext at end of last bg */
+	struct list_head	meta_list;	/* fixed metadata list */
+};
+
+/* Associate a device with a getfsmap handler. */
+struct ext4_getfsmap_dev {
+	u32			dev;
+	int			(*fn)(struct super_block *sb,
+				      struct ext4_fsmap *keys,
+				      struct ext4_getfsmap_info *info);
+};
+
+/* Compare two getfsmap device handlers. */
+static int ext4_getfsmap_dev_compare(const void *p1, const void *p2)
+{
+	const struct ext4_getfsmap_dev *d1 = p1;
+	const struct ext4_getfsmap_dev *d2 = p2;
+
+	return d1->dev - d2->dev;
+}
+
+/* Compare a record against our starting point */
+static bool ext4_getfsmap_rec_before_low_key(struct ext4_getfsmap_info *info,
+					     struct ext4_fsmap *rec)
+{
+	return rec->fmr_physical < info->low.fmr_physical;
+}
+
+/*
+ * Format a reverse mapping for getfsmap, having translated rm_startblock
+ * into the appropriate daddr units.
+ */
+static int ext4_getfsmap_helper(struct super_block *sb,
+				struct ext4_getfsmap_info *info,
+				struct ext4_fsmap *rec)
+{
+	struct ext4_fsmap fmr;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_fsblk_t rec_fsblk = rec->fmr_physical;
+	ext4_group_t agno;
+	ext4_grpblk_t cno;
+	int error;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	/*
+	 * Filter out records that start before our startpoint, if the
+	 * caller requested that.
+	 */
+	if (ext4_getfsmap_rec_before_low_key(info, rec)) {
+		rec_fsblk += rec->fmr_length;
+		if (info->next_fsblk < rec_fsblk)
+			info->next_fsblk = rec_fsblk;
+		return EXT4_QUERY_RANGE_CONTINUE;
+	}
+
+	/* Are we just counting mappings? */
+	if (info->head->fmh_count == 0) {
+		if (rec_fsblk > info->next_fsblk)
+			info->head->fmh_entries++;
+
+		if (info->last)
+			return EXT4_QUERY_RANGE_CONTINUE;
+
+		info->head->fmh_entries++;
+
+		rec_fsblk += rec->fmr_length;
+		if (info->next_fsblk < rec_fsblk)
+			info->next_fsblk = rec_fsblk;
+		return EXT4_QUERY_RANGE_CONTINUE;
+	}
+
+	/*
+	 * If the record starts past the last physical block we saw,
+	 * then we've found a gap.  Report the gap as being owned by
+	 * whatever the caller specified is the missing owner.
+	 */
+	if (rec_fsblk > info->next_fsblk) {
+		if (info->head->fmh_entries >= info->head->fmh_count)
+			return EXT4_QUERY_RANGE_ABORT;
+
+		ext4_get_group_no_and_offset(sb, info->next_fsblk, &agno, &cno);
+		trace_ext4_fsmap_mapping(sb, info->dev, agno,
+				EXT4_C2B(sbi, cno),
+				rec_fsblk - info->next_fsblk,
+				EXT4_FMR_OWN_UNKNOWN);
+
+		fmr.fmr_device = info->dev;
+		fmr.fmr_physical = info->next_fsblk;
+		fmr.fmr_owner = EXT4_FMR_OWN_UNKNOWN;
+		fmr.fmr_length = rec_fsblk - info->next_fsblk;
+		fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
+		error = info->formatter(&fmr, info->format_arg);
+		if (error)
+			return error;
+		info->head->fmh_entries++;
+	}
+
+	if (info->last)
+		goto out;
+
+	/* Fill out the extent we found */
+	if (info->head->fmh_entries >= info->head->fmh_count)
+		return EXT4_QUERY_RANGE_ABORT;
+
+	ext4_get_group_no_and_offset(sb, rec_fsblk, &agno, &cno);
+	trace_ext4_fsmap_mapping(sb, info->dev, agno, EXT4_C2B(sbi, cno),
+			rec->fmr_length, rec->fmr_owner);
+
+	fmr.fmr_device = info->dev;
+	fmr.fmr_physical = rec_fsblk;
+	fmr.fmr_owner = rec->fmr_owner;
+	fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
+	fmr.fmr_length = rec->fmr_length;
+	error = info->formatter(&fmr, info->format_arg);
+	if (error)
+		return error;
+	info->head->fmh_entries++;
+
+out:
+	rec_fsblk += rec->fmr_length;
+	if (info->next_fsblk < rec_fsblk)
+		info->next_fsblk = rec_fsblk;
+	return EXT4_QUERY_RANGE_CONTINUE;
+}
+
+static inline ext4_fsblk_t ext4_fsmap_next_pblk(struct ext4_fsmap *f)
+{
+	return f->fmr_physical + f->fmr_length;
+}
+
+/* Transform a blockgroup's free record into a fsmap */
+static int ext4_getfsmap_datadev_helper(struct super_block *sb,
+					ext4_group_t agno, ext4_grpblk_t start,
+					ext4_grpblk_t len, void *priv)
+{
+	struct ext4_fsmap irec;
+	struct ext4_getfsmap_info *info = priv;
+	struct ext4_metadata_fsmap *p;
+	struct ext4_metadata_fsmap *tmp;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_fsblk_t fsb;
+	ext4_fsblk_t fslen;
+	int error;
+
+	fsb = (EXT4_C2B(sbi, start) + ext4_group_first_block_no(sb, agno));
+	fslen = EXT4_C2B(sbi, len);
+
+	/* If the retained free extent record is set... */
+	if (info->lastfree.fmr_owner) {
+		/* ...and abuts this one, lengthen it and return. */
+		if (ext4_fsmap_next_pblk(&info->lastfree) == fsb) {
+			info->lastfree.fmr_length += fslen;
+			return 0;
+		}
+
+		/*
+		 * There's a gap between the two free extents; emit the
+		 * retained extent prior to merging the meta_list.
+		 */
+		error = ext4_getfsmap_helper(sb, info, &info->lastfree);
+		if (error)
+			return error;
+		info->lastfree.fmr_owner = 0;
+	}
+
+	/* Merge in any relevant extents from the meta_list */
+	list_for_each_entry_safe(p, tmp, &info->meta_list, mf_list) {
+		if (p->mf_physical + p->mf_length <= info->next_fsblk) {
+			list_del(&p->mf_list);
+			kfree(p);
+		} else if (p->mf_physical < fsb) {
+			irec.fmr_physical = p->mf_physical;
+			irec.fmr_length = p->mf_length;
+			irec.fmr_owner = p->mf_owner;
+			irec.fmr_flags = 0;
+
+			error = ext4_getfsmap_helper(sb, info, &irec);
+			if (error)
+				return error;
+
+			list_del(&p->mf_list);
+			kfree(p);
+		}
+	}
+
+	irec.fmr_physical = fsb;
+	irec.fmr_length = fslen;
+	irec.fmr_owner = EXT4_FMR_OWN_FREE;
+	irec.fmr_flags = 0;
+
+	/* If this is a free extent at the end of an bg, buffer it. */
+	if (ext4_fsmap_next_pblk(&irec) ==
+			ext4_group_first_block_no(sb, agno + 1)) {
+		info->lastfree = irec;
+		return 0;
+	}
+
+	/* Otherwise, emit it */
+	return ext4_getfsmap_helper(sb, info, &irec);
+}
+
+/* Execute a getfsmap query against the log device. */
+static int ext4_getfsmap_logdev(struct super_block *sb, struct ext4_fsmap *keys,
+				struct ext4_getfsmap_info *info)
+{
+	journal_t *journal = EXT4_SB(sb)->s_journal;
+	struct ext4_fsmap irec;
+
+	/* Set up search keys */
+	info->low = keys[0];
+	info->low.fmr_length = 0;
+
+	memset(&info->high, 0xFF, sizeof(info->high));
+
+	trace_ext4_fsmap_low_key(sb, info->dev, 0,
+			info->low.fmr_physical,
+			info->low.fmr_length,
+			info->low.fmr_owner);
+
+	trace_ext4_fsmap_high_key(sb, info->dev, 0,
+			info->high.fmr_physical,
+			info->high.fmr_length,
+			info->high.fmr_owner);
+
+	if (keys[0].fmr_physical > 0)
+		return 0;
+
+	/* Fabricate an rmap entry for the external log device. */
+	irec.fmr_physical = journal->j_blk_offset;
+	irec.fmr_length = journal->j_maxlen;
+	irec.fmr_owner = EXT4_FMR_OWN_LOG;
+	irec.fmr_flags = 0;
+
+	return ext4_getfsmap_helper(sb, info, &irec);
+}
+
+/*
+ * This function returns the number of file system metadata blocks at
+ * the beginning of a block group, including the reserved gdt blocks.
+ */
+static unsigned int ext4_getfsmap_count_group_meta_blocks(
+		struct super_block *sb, ext4_group_t block_group)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	unsigned int num;
+
+	/* Check for superblock and gdt backups in this group */
+	num = ext4_bg_has_super(sb, block_group);
+
+	if (!ext4_has_feature_meta_bg(sb) ||
+	    block_group < le32_to_cpu(sbi->s_es->s_first_meta_bg) *
+			  sbi->s_desc_per_block) {
+		if (num) {
+			num += ext4_bg_num_gdb(sb, block_group);
+			num += le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
+		}
+	} else { /* For META_BG_BLOCK_GROUPS */
+		num += ext4_bg_num_gdb(sb, block_group);
+	}
+	return num;
+}
+
+/* Compare two fixed metadata items. */
+static int ext4_getfsmap_compare_fixed_metadata(void *priv,
+	struct list_head *a,
+	struct list_head *b)
+{
+	struct ext4_metadata_fsmap *fa;
+	struct ext4_metadata_fsmap *fb;
+
+	fa = container_of(a, struct ext4_metadata_fsmap, mf_list);
+	fb = container_of(b, struct ext4_metadata_fsmap, mf_list);
+	if (fa->mf_physical < fb->mf_physical)
+		return -1;
+	else if (fa->mf_physical > fb->mf_physical)
+		return 1;
+	return 0;
+}
+
+/* Merge adjacent extents of fixed metadata. */
+static void ext4_getfsmap_merge_fixed_metadata(struct list_head *meta_list)
+{
+	struct ext4_metadata_fsmap *p;
+	struct ext4_metadata_fsmap *prev = NULL;
+	struct ext4_metadata_fsmap *tmp;
+
+	list_for_each_entry_safe(p, tmp, meta_list, mf_list) {
+		if (!prev) {
+			prev = p;
+			continue;
+		}
+
+		if (prev->mf_owner == p->mf_owner &&
+		    prev->mf_physical + prev->mf_length == p->mf_physical) {
+			prev->mf_length += p->mf_length;
+			list_del(&p->mf_list);
+			kfree(p);
+		} else
+			prev = p;
+	}
+}
+
+/* Free a list of fixed metadata. */
+static void ext4_getfsmap_free_fixed_metadata(struct list_head *meta_list)
+{
+	struct ext4_metadata_fsmap *p;
+	struct ext4_metadata_fsmap *tmp;
+
+	list_for_each_entry_safe(p, tmp, meta_list, mf_list) {
+		list_del(&p->mf_list);
+		kfree(p);
+	}
+}
+
+/* Find all the fixed metadata in the filesystem. */
+int ext4_getfsmap_find_fixed_metadata(struct super_block *sb,
+				      struct list_head *meta_list)
+{
+	struct ext4_metadata_fsmap *fsm;
+	struct ext4_group_desc *gdp;
+	ext4_group_t agno;
+	unsigned int nr_super;
+	int error;
+
+	INIT_LIST_HEAD(meta_list);
+
+	/* Collect everything. */
+	for (agno = 0; agno < EXT4_SB(sb)->s_groups_count; agno++) {
+		gdp = ext4_get_group_desc(sb, agno, NULL);
+		if (!gdp) {
+			error = -EFSCORRUPTED;
+			goto err;
+		}
+
+		/* Superblock & GDT */
+		nr_super = ext4_getfsmap_count_group_meta_blocks(sb, agno);
+		if (nr_super) {
+			fsm = kmalloc(sizeof(*fsm), GFP_NOFS);
+			if (!fsm) {
+				error = -ENOMEM;
+				goto err;
+			}
+			fsm->mf_physical = ext4_group_first_block_no(sb, agno);
+			fsm->mf_owner = EXT4_FMR_OWN_FS;
+			fsm->mf_length = nr_super;
+			list_add_tail(&fsm->mf_list, meta_list);
+		}
+
+		/* Block bitmap */
+		fsm = kmalloc(sizeof(*fsm), GFP_NOFS);
+		if (!fsm) {
+			error = -ENOMEM;
+			goto err;
+		}
+		fsm->mf_physical = ext4_block_bitmap(sb, gdp);
+		fsm->mf_owner = EXT4_FMR_OWN_BLKBM;
+		fsm->mf_length = 1;
+		list_add_tail(&fsm->mf_list, meta_list);
+
+		/* Inode bitmap */
+		fsm = kmalloc(sizeof(*fsm), GFP_NOFS);
+		if (!fsm) {
+			error = -ENOMEM;
+			goto err;
+		}
+		fsm->mf_physical = ext4_inode_bitmap(sb, gdp);
+		fsm->mf_owner = EXT4_FMR_OWN_INOBM;
+		fsm->mf_length = 1;
+		list_add_tail(&fsm->mf_list, meta_list);
+
+		/* Inodes */
+		fsm = kmalloc(sizeof(*fsm), GFP_NOFS);
+		if (!fsm) {
+			error = -ENOMEM;
+			goto err;
+		}
+		fsm->mf_physical = ext4_inode_table(sb, gdp);
+		fsm->mf_owner = EXT4_FMR_OWN_INODES;
+		fsm->mf_length = EXT4_SB(sb)->s_itb_per_group;
+		list_add_tail(&fsm->mf_list, meta_list);
+	}
+
+	/* Sort the list */
+	list_sort(NULL, meta_list, ext4_getfsmap_compare_fixed_metadata);
+
+	/* Merge adjacent extents */
+	ext4_getfsmap_merge_fixed_metadata(meta_list);
+
+	return 0;
+err:
+	ext4_getfsmap_free_fixed_metadata(meta_list);
+	return error;
+}
+
+/* Execute a getfsmap query against the buddy bitmaps */
+static int ext4_getfsmap_datadev(struct super_block *sb,
+				 struct ext4_fsmap *keys,
+				 struct ext4_getfsmap_info *info)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_fsblk_t start_fsb;
+	ext4_fsblk_t end_fsb;
+	ext4_fsblk_t eofs;
+	ext4_group_t start_ag;
+	ext4_group_t end_ag;
+	ext4_grpblk_t first_cluster;
+	ext4_grpblk_t last_cluster;
+	int error = 0;
+
+	eofs = ext4_blocks_count(sbi->s_es);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	if (keys[1].fmr_physical >= eofs)
+		keys[1].fmr_physical = eofs - 1;
+	start_fsb = keys[0].fmr_physical;
+	end_fsb = keys[1].fmr_physical;
+
+	/* Determine first and last group to examine based on start and end */
+	ext4_get_group_no_and_offset(sb, start_fsb, &start_ag, &first_cluster);
+	ext4_get_group_no_and_offset(sb, end_fsb, &end_ag, &last_cluster);
+
+	/*
+	 * Convert the fsmap low/high keys to bg based keys.  Initialize
+	 * low to the fsmap low key and max out the high key to the end
+	 * of the bg.
+	 */
+	info->low = keys[0];
+	info->low.fmr_physical = EXT4_C2B(sbi, first_cluster);
+	info->low.fmr_length = 0;
+
+	memset(&info->high, 0xFF, sizeof(info->high));
+
+	/* Assemble a list of all the fixed-location metadata. */
+	error = ext4_getfsmap_find_fixed_metadata(sb, &info->meta_list);
+	if (error)
+		goto err;
+
+	/* Query each bg */
+	for (info->agno = start_ag; info->agno <= end_ag; info->agno++) {
+		/*
+		 * Set the bg high key from the fsmap high key if this
+		 * is the last bg that we're querying.
+		 */
+		if (info->agno == end_ag) {
+			info->high = keys[1];
+			info->high.fmr_physical = EXT4_C2B(sbi, last_cluster);
+			info->high.fmr_length = 0;
+		}
+
+		trace_ext4_fsmap_low_key(sb, info->dev, info->agno,
+				info->low.fmr_physical,
+				info->low.fmr_length,
+				info->low.fmr_owner);
+
+		trace_ext4_fsmap_high_key(sb, info->dev, info->agno,
+				info->high.fmr_physical,
+				info->high.fmr_length,
+				info->high.fmr_owner);
+
+		error = ext4_mballoc_query_range(sb, info->agno,
+				EXT4_B2C(sbi, info->low.fmr_physical),
+				EXT4_B2C(sbi, info->high.fmr_physical),
+				ext4_getfsmap_datadev_helper, info);
+		if (error)
+			goto err;
+
+		/*
+		 * Set the bg low key to the start of the bg prior to
+		 * moving on to the next bg.
+		 */
+		if (info->agno == start_ag)
+			memset(&info->low, 0, sizeof(info->low));
+	}
+
+	/* Do we have a retained free extent? */
+	if (info->lastfree.fmr_owner) {
+		error = ext4_getfsmap_helper(sb, info, &info->lastfree);
+		if (error)
+			goto err;
+	}
+
+	/* Report any gaps at the end of the bg */
+	info->last = true;
+	error = ext4_getfsmap_datadev_helper(sb, end_ag, last_cluster, 0, info);
+	if (error)
+		goto err;
+
+err:
+	ext4_getfsmap_free_fixed_metadata(&info->meta_list);
+	return error;
+}
+
+/* Do we recognize the device? */
+static bool ext4_getfsmap_is_valid_device(struct super_block *sb,
+					  struct ext4_fsmap *fm)
+{
+	if (fm->fmr_device == 0 || fm->fmr_device == UINT_MAX ||
+	    fm->fmr_device == new_encode_dev(sb->s_bdev->bd_dev))
+		return true;
+	if (EXT4_SB(sb)->journal_bdev &&
+	    fm->fmr_device == new_encode_dev(EXT4_SB(sb)->journal_bdev->bd_dev))
+		return true;
+	return false;
+}
+
+/* Ensure that the low key is less than the high key. */
+static bool ext4_getfsmap_check_keys(struct ext4_fsmap *low_key,
+				     struct ext4_fsmap *high_key)
+{
+	if (low_key->fmr_device > high_key->fmr_device)
+		return false;
+	if (low_key->fmr_device < high_key->fmr_device)
+		return true;
+
+	if (low_key->fmr_physical > high_key->fmr_physical)
+		return false;
+	if (low_key->fmr_physical < high_key->fmr_physical)
+		return true;
+
+	if (low_key->fmr_owner > high_key->fmr_owner)
+		return false;
+	if (low_key->fmr_owner < high_key->fmr_owner)
+		return true;
+
+	return false;
+}
+
+#define EXT4_GETFSMAP_DEVS	2
+/*
+ * Get filesystem's extents as described in head, and format for
+ * output.  Calls formatter to fill the user's buffer until all
+ * extents are mapped, until the passed-in head->fmh_count slots have
+ * been filled, or until the formatter short-circuits the loop, if it
+ * is tracking filled-in extents on its own.
+ *
+ * Key to Confusion
+ * ----------------
+ * There are multiple levels of keys and counters at work here:
+ * ext4_fsmap_head.fmh_keys	-- low and high fsmap keys passed in;
+ * 				   these reflect fs-wide block addrs.
+ * ext4_getfsmap_info.rkey_low	-- pointer to fmh_keys[0].
+ * dkeys			-- fmh_keys used to query each device;
+ * 				   these are fmh_keys but w/ the low key
+ * 				   bumped up by fmr_length.
+ * ext4_getfsmap_info.next_fsblk-- next fs block we expect to see; this
+ *				   is how we detect gaps in the fsmap
+ *				   records and report them.
+ * ext4_getfsmap_info.low/high	-- per-bg low/high keys computed from
+ * 				   dkeys; used to query the free space.
+ */
+int ext4_getfsmap(struct super_block *sb, struct ext4_fsmap_head *head,
+		  ext4_fsmap_format_t formatter, void *arg)
+{
+	struct ext4_fsmap dkeys[2];	/* per-dev keys */
+	struct ext4_getfsmap_dev handlers[EXT4_GETFSMAP_DEVS];
+	struct ext4_getfsmap_info info = {0};
+	int i;
+	int error = 0;
+
+	if (head->fmh_iflags & ~FMH_IF_VALID)
+		return -EINVAL;
+	if (!ext4_getfsmap_is_valid_device(sb, &head->fmh_keys[0]) ||
+	    !ext4_getfsmap_is_valid_device(sb, &head->fmh_keys[1]))
+		return -EINVAL;
+
+	head->fmh_entries = 0;
+
+	/* Set up our device handlers. */
+	memset(handlers, 0, sizeof(handlers));
+	handlers[0].dev = new_encode_dev(sb->s_bdev->bd_dev);
+	handlers[0].fn = ext4_getfsmap_datadev;
+	if (EXT4_SB(sb)->journal_bdev) {
+		handlers[1].dev = new_encode_dev(
+				EXT4_SB(sb)->journal_bdev->bd_dev);
+		handlers[1].fn = ext4_getfsmap_logdev;
+	}
+
+	sort(handlers, EXT4_GETFSMAP_DEVS, sizeof(struct ext4_getfsmap_dev),
+			ext4_getfsmap_dev_compare, NULL);
+
+	/*
+	 * To continue where we left off, we allow userspace to use the
+	 * last mapping from a previous call as the low key of the next.
+	 * This is identified by a non-zero length in the low key. We
+	 * have to increment the low key in this scenario to ensure we
+	 * don't return the same mapping again, and instead return the
+	 * very next mapping.
+	 *
+	 * Bump the physical offset as there can be no other mapping for
+	 * the same physical block range.
+	 */
+	dkeys[0] = head->fmh_keys[0];
+	dkeys[0].fmr_physical += dkeys[0].fmr_length;
+	dkeys[0].fmr_owner = 0;
+	dkeys[0].fmr_length = 0;
+	memset(&dkeys[1], 0xFF, sizeof(struct ext4_fsmap));
+
+	if (!ext4_getfsmap_check_keys(dkeys, &head->fmh_keys[1]))
+		return -EINVAL;
+
+	info.next_fsblk = head->fmh_keys[0].fmr_physical +
+			  head->fmh_keys[0].fmr_length;
+	info.rkey_low = &head->fmh_keys[0];
+	info.formatter = formatter;
+	info.format_arg = arg;
+	info.head = head;
+
+	/* For each device we support... */
+	for (i = 0; i < EXT4_GETFSMAP_DEVS; i++) {
+		/* Is this device within the range the user asked for? */
+		if (!handlers[i].fn)
+			continue;
+		if (head->fmh_keys[0].fmr_device > handlers[i].dev)
+			continue;
+		if (head->fmh_keys[1].fmr_device < handlers[i].dev)
+			break;
+
+		/*
+		 * If this device number matches the high key, we have
+		 * to pass the high key to the handler to limit the
+		 * query results.  If the device number exceeds the
+		 * low key, zero out the low key so that we get
+		 * everything from the beginning.
+		 */
+		if (handlers[i].dev == head->fmh_keys[1].fmr_device)
+			dkeys[1] = head->fmh_keys[1];
+		if (handlers[i].dev > head->fmh_keys[0].fmr_device)
+			memset(&dkeys[0], 0, sizeof(struct ext4_fsmap));
+
+		info.dev = handlers[i].dev;
+		info.last = false;
+		info.agno = -1;
+		error = handlers[i].fn(sb, dkeys, &info);
+		if (error)
+			break;
+		info.next_fsblk = 0;
+	}
+
+	head->fmh_oflags = FMH_OF_DEV_T;
+	return error;
+}
diff --git a/fs/ext4/fsmap.h b/fs/ext4/fsmap.h
new file mode 100644
index 0000000..23a4f39
--- /dev/null
+++ b/fs/ext4/fsmap.h
@@ -0,0 +1,74 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __EXT4_FSMAP_H__
+#define	__EXT4_FSMAP_H__
+
+struct fsmap;
+
+struct ext4_metadata_fsmap {
+	struct list_head	mf_list;
+	uint64_t	mf_physical;	/* device offset of segment */
+	uint64_t	mf_owner;	/* owner id */
+	uint64_t	mf_length;	/* length of segment, blocks */
+};
+
+/* internal fsmap representation */
+struct ext4_fsmap {
+	struct list_head	fmr_list;
+	dev_t		fmr_device;	/* device id */
+	uint32_t	fmr_flags;	/* mapping flags */
+	uint64_t	fmr_physical;	/* device offset of segment */
+	uint64_t	fmr_owner;	/* owner id */
+	uint64_t	fmr_length;	/* length of segment, blocks */
+};
+
+struct ext4_fsmap_head {
+	uint32_t	fmh_iflags;	/* control flags */
+	uint32_t	fmh_oflags;	/* output flags */
+	unsigned int	fmh_count;	/* # of entries in array incl. input */
+	unsigned int	fmh_entries;	/* # of entries filled in (output). */
+
+	struct ext4_fsmap fmh_keys[2];	/* low and high keys */
+};
+
+void ext4_fsmap_from_internal(struct super_block *sb, struct fsmap *dest,
+		struct ext4_fsmap *src);
+void ext4_fsmap_to_internal(struct super_block *sb, struct ext4_fsmap *dest,
+		struct fsmap *src);
+
+/* fsmap to userspace formatter - copy to user & advance pointer */
+typedef int (*ext4_fsmap_format_t)(struct ext4_fsmap *, void *);
+
+int ext4_getfsmap(struct super_block *sb, struct ext4_fsmap_head *head,
+		ext4_fsmap_format_t formatter, void *arg);
+
+#define EXT4_QUERY_RANGE_ABORT		1
+#define EXT4_QUERY_RANGE_CONTINUE	0
+
+/*	fmr_owner special values for FS_IOC_GETFSMAP; some share w/ XFS */
+#define EXT4_FMR_OWN_FREE	FMR_OWN_FREE      /* free space */
+#define EXT4_FMR_OWN_UNKNOWN	FMR_OWN_UNKNOWN   /* unknown owner */
+#define EXT4_FMR_OWN_FS		FMR_OWNER('X', 1) /* static fs metadata */
+#define EXT4_FMR_OWN_LOG	FMR_OWNER('X', 2) /* journalling log */
+#define EXT4_FMR_OWN_INODES	FMR_OWNER('X', 5) /* inodes */
+#define EXT4_FMR_OWN_BLKBM	FMR_OWNER('f', 1) /* inode bitmap */
+#define EXT4_FMR_OWN_INOBM	FMR_OWNER('f', 2) /* block bitmap */
+
+#endif /* __EXT4_FSMAP_H__ */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d534399..543ecf6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -18,6 +18,9 @@
 #include <linux/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
+#include <linux/fsmap.h>
+#include "fsmap.h"
+#include <trace/events/ext4.h>
 
 /**
  * Swap memory between @a and @b for @len bytes.
@@ -442,6 +445,94 @@ static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
 	return iflags;
 }
 
+struct getfsmap_info {
+	struct super_block	*sb;
+	struct fsmap __user	*data;
+	__u32			last_flags;
+};
+
+static int
+ext4_getfsmap_format(
+	struct ext4_fsmap	*xfm,
+	void			*priv)
+{
+	struct getfsmap_info	*info = priv;
+	struct fsmap		fm;
+
+	trace_ext4_getfsmap_mapping(info->sb, xfm);
+
+	info->last_flags = xfm->fmr_flags;
+	ext4_fsmap_from_internal(info->sb, &fm, xfm);
+	if (copy_to_user(info->data, &fm, sizeof(struct fsmap)))
+		return -EFAULT;
+
+	info->data++;
+	return 0;
+}
+
+static int
+ext4_ioc_getfsmap(
+	struct super_block	*sb,
+	void			__user *arg)
+{
+	struct getfsmap_info	info;
+	struct ext4_fsmap_head	xhead = {0};
+	struct fsmap_head	head;
+	bool			aborted = false;
+	int			error;
+
+	if (copy_from_user(&head, arg, sizeof(struct fsmap_head)))
+		return -EFAULT;
+	if (memchr_inv(head.fmh_reserved, 0, sizeof(head.fmh_reserved)) ||
+	    memchr_inv(head.fmh_keys[0].fmr_reserved, 0,
+		       sizeof(head.fmh_keys[0].fmr_reserved)) ||
+	    memchr_inv(head.fmh_keys[1].fmr_reserved, 0,
+		       sizeof(head.fmh_keys[1].fmr_reserved)))
+		return -EINVAL;
+	/*
+	 * ext4 doesn't report file extents at all, so the only valid
+	 * offsets are the magic ones (all zeroes or all ones).
+	 */
+	if (head.fmh_keys[0].fmr_offset ||
+	    (head.fmh_keys[1].fmr_offset != 0 &&
+	     head.fmh_keys[1].fmr_offset != -1ULL))
+		return -EINVAL;
+
+	xhead.fmh_iflags = head.fmh_iflags;
+	xhead.fmh_count = head.fmh_count;
+	ext4_fsmap_to_internal(sb, &xhead.fmh_keys[0], &head.fmh_keys[0]);
+	ext4_fsmap_to_internal(sb, &xhead.fmh_keys[1], &head.fmh_keys[1]);
+
+	trace_ext4_getfsmap_low_key(sb, &xhead.fmh_keys[0]);
+	trace_ext4_getfsmap_high_key(sb, &xhead.fmh_keys[1]);
+
+	info.sb = sb;
+	info.data = ((__force struct fsmap_head *)arg)->fmh_recs;
+	error = ext4_getfsmap(sb, &xhead, ext4_getfsmap_format, &info);
+	if (error == EXT4_QUERY_RANGE_ABORT) {
+		error = 0;
+		aborted = true;
+	} else if (error)
+		return error;
+
+	/* If we didn't abort, set the "last" flag in the last fmx */
+	if (!aborted && xhead.fmh_entries) {
+		info.data--;
+		info.last_flags |= FMR_OF_LAST;
+		if (copy_to_user(&info.data->fmr_flags, &info.last_flags,
+				sizeof(info.last_flags)))
+			return -EFAULT;
+	}
+
+	/* copy back header */
+	head.fmh_entries = xhead.fmh_entries;
+	head.fmh_oflags = xhead.fmh_oflags;
+	if (copy_to_user(arg, &head, sizeof(struct fsmap_head)))
+		return -EFAULT;
+
+	return 0;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -452,6 +543,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
+	case FS_IOC_GETFSMAP:
+		return ext4_ioc_getfsmap(sb, (void __user *)arg);
 	case EXT4_IOC_GETFLAGS:
 		ext4_get_inode_flags(ei);
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
@@ -959,6 +1052,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GETFSMAP:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7ae43c5..8813c54 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5258,3 +5258,52 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	range->len = EXT4_C2B(EXT4_SB(sb), trimmed) << sb->s_blocksize_bits;
 	return ret;
 }
+
+/* Iterate all the free extents in the group. */
+int
+ext4_mballoc_query_range(
+	struct super_block		*sb,
+	ext4_group_t			group,
+	ext4_grpblk_t			start,
+	ext4_grpblk_t			end,
+	ext4_mballoc_query_range_fn	formatter,
+	void				*priv)
+{
+	void				*bitmap;
+	ext4_grpblk_t			next;
+	struct ext4_buddy		e4b;
+	int				error;
+
+	error = ext4_mb_load_buddy(sb, group, &e4b);
+	if (error)
+		return error;
+	bitmap = e4b.bd_bitmap;
+
+	ext4_lock_group(sb, group);
+
+	start = (e4b.bd_info->bb_first_free > start) ?
+		e4b.bd_info->bb_first_free : start;
+	if (end >= EXT4_CLUSTERS_PER_GROUP(sb))
+		end = EXT4_CLUSTERS_PER_GROUP(sb) - 1;
+
+	while (start <= end) {
+		start = mb_find_next_zero_bit(bitmap, end + 1, start);
+		if (start > end)
+			break;
+		next = mb_find_next_bit(bitmap, end + 1, start);
+
+		ext4_unlock_group(sb, group);
+		error = formatter(sb, group, start, next - start, priv);
+		if (error)
+			goto out_unload;
+		ext4_lock_group(sb, group);
+
+		start = next + 1;
+	}
+
+	ext4_unlock_group(sb, group);
+out_unload:
+	ext4_mb_unload_buddy(&e4b);
+
+	return error;
+}
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 1aba469..2bed620 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -199,4 +199,21 @@ static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 	return ext4_group_first_block_no(sb, fex->fe_group) +
 		(fex->fe_start << EXT4_SB(sb)->s_cluster_bits);
 }
+
+typedef int (*ext4_mballoc_query_range_fn)(
+	struct super_block		*sb,
+	ext4_group_t			agno,
+	ext4_grpblk_t			start,
+	ext4_grpblk_t			len,
+	void				*priv);
+
+int
+ext4_mballoc_query_range(
+	struct super_block		*sb,
+	ext4_group_t			agno,
+	ext4_grpblk_t			start,
+	ext4_grpblk_t			end,
+	ext4_mballoc_query_range_fn	formatter,
+	void				*priv);
+
 #endif
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 66845a0..eef3a1a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -49,6 +49,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
+#include "fsmap.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 09c71e9..dfae175 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -15,6 +15,7 @@ struct ext4_inode_info;
 struct mpage_da_data;
 struct ext4_map_blocks;
 struct extent_status;
+struct ext4_fsmap;
 
 #define EXT4_I(inode) (container_of(inode, struct ext4_inode_info, vfs_inode))
 
@@ -2529,6 +2530,79 @@ TRACE_EVENT(ext4_es_shrink,
 		  __entry->scan_time, __entry->nr_skipped, __entry->retried)
 );
 
+/* fsmap traces */
+DECLARE_EVENT_CLASS(ext4_fsmap_class,
+	TP_PROTO(struct super_block *sb, u32 keydev, u32 agno, u64 bno, u64 len,
+		 u64 owner),
+	TP_ARGS(sb, keydev, agno, bno, len, owner),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(u32, agno)
+		__field(u64, bno)
+		__field(u64, len)
+		__field(u64, owner)
+	),
+	TP_fast_assign(
+		__entry->dev = sb->s_bdev->bd_dev;
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->agno = agno;
+		__entry->bno = bno;
+		__entry->len = len;
+		__entry->owner = owner;
+	),
+	TP_printk("dev %d:%d keydev %d:%d agno %u bno %llu len %llu owner %lld\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->len,
+		  __entry->owner)
+)
+#define DEFINE_FSMAP_EVENT(name) \
+DEFINE_EVENT(ext4_fsmap_class, name, \
+	TP_PROTO(struct super_block *sb, u32 keydev, u32 agno, u64 bno, u64 len, \
+		 u64 owner), \
+	TP_ARGS(sb, keydev, agno, bno, len, owner))
+DEFINE_FSMAP_EVENT(ext4_fsmap_low_key);
+DEFINE_FSMAP_EVENT(ext4_fsmap_high_key);
+DEFINE_FSMAP_EVENT(ext4_fsmap_mapping);
+
+DECLARE_EVENT_CLASS(ext4_getfsmap_class,
+	TP_PROTO(struct super_block *sb, struct ext4_fsmap *fsmap),
+	TP_ARGS(sb, fsmap),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(u64, block)
+		__field(u64, len)
+		__field(u64, owner)
+		__field(u64, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = sb->s_bdev->bd_dev;
+		__entry->keydev = new_decode_dev(fsmap->fmr_device);
+		__entry->block = fsmap->fmr_physical;
+		__entry->len = fsmap->fmr_length;
+		__entry->owner = fsmap->fmr_owner;
+		__entry->flags = fsmap->fmr_flags;
+	),
+	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner %lld flags 0x%llx\n",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->block,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->flags)
+)
+#define DEFINE_GETFSMAP_EVENT(name) \
+DEFINE_EVENT(ext4_getfsmap_class, name, \
+	TP_PROTO(struct super_block *sb, struct ext4_fsmap *fsmap), \
+	TP_ARGS(sb, fsmap))
+DEFINE_GETFSMAP_EVENT(ext4_getfsmap_low_key);
+DEFINE_GETFSMAP_EVENT(ext4_getfsmap_high_key);
+DEFINE_GETFSMAP_EVENT(ext4_getfsmap_mapping);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */

