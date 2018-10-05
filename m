Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48102 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 12/15] xfsprogs: kill EXTERN macro
Date: Thu,  4 Oct 2018 23:03:13 -0500
Message-Id: <1538712196-13625-13-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

The EXTERN macro was a too-clever hack to allow a header file to both
declare global variables and export them.  Get rid of the hack and do
things the predictable way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/globals.c  | 123 ++++++++++++++++++++++++++++++++++++++++++++++--
 repair/globals.h  | 136 +++++++++++++++++++++++++++---------------------------
 repair/versions.c |  23 +++++++--
 repair/versions.h |  16 +++----
 4 files changed, 214 insertions(+), 84 deletions(-)

diff --git a/repair/globals.c b/repair/globals.c
index d00e964..e963edb 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -1,10 +1,125 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
 
-#include "libxfs.h"
-
-#define EXTERN
 #include "globals.h"
+
+/* global variables for xfs_repair */
+
+/* arguments and argument flag variables */
+
+char	*fs_name;		/* name of filesystem */
+int	verbose;		/* verbose flag, mostly for debugging */
+
+
+/* for reading stuff in manually (bypassing libsim) */
+
+char	*iobuf;			/* large buffer */
+int	iobuf_size;
+char	*smallbuf;		/* small (1-4 page) buffer */
+int	smallbuf_size;
+int	sbbuf_size;
+
+/* direct I/O info */
+
+int	minio_align;		/* min I/O size and alignment */
+int	mem_align;		/* memory alignment */
+int	max_iosize;		/* max I/O size */
+
+/* file descriptors */
+
+int	fs_fd;			/* filesystem fd */
+
+/* command-line flags */
+
+int	verbose;
+int	no_modify;
+int	dangerously;		/* live dangerously ... fix ro mount */
+int	isa_file;
+int	zap_log;
+int	dumpcore;		/* abort, not exit on fatal errs */
+int	force_geo;		/* can set geo on low confidence info */
+int	assume_xfs;		/* assume we have an xfs fs */
+char	*log_name;		/* Name of log device */
+int	log_spec;		/* Log dev specified as option */
+char	*rt_name;		/* Name of realtime device */
+int	rt_spec;		/* Realtime dev specified as option */
+int	convert_lazy_count;	/* Convert lazy-count mode on/off */
+int	lazy_count;		/* What to set if to if converting */
+
+/* misc status variables */
+
+int	primary_sb_modified;
+int	bad_ino_btree;
+int	copied_sunit;
+int	fs_is_dirty;
+
+/* for hunting down the root inode */
+
+int	need_root_inode;
+int	need_root_dotdot;
+
+int	need_rbmino;
+int	need_rsumino;
+
+int	lost_quotas;
+int	have_uquotino;
+int	have_gquotino;
+int	have_pquotino;
+int	lost_uquotino;
+int	lost_gquotino;
+int	lost_pquotino;
+
+xfs_agino_t	first_prealloc_ino;
+xfs_agino_t	last_prealloc_ino;
+xfs_agblock_t	bnobt_root;
+xfs_agblock_t	bcntbt_root;
+xfs_agblock_t	inobt_root;
+
+/* configuration vars -- fs geometry dependent */
+
+int		inodes_per_block;
+int		inodes_per_cluster;
+unsigned int	glob_agcount;
+int		chunks_pblock;	/* # of 64-ino chunks per allocation */
+int		max_symlink_blocks;
+int64_t		fs_max_file_offset;
+
+/* realtime info */
+
+xfs_rtword_t	*btmcompute;
+xfs_suminfo_t	*sumcompute;
+
+/* inode tree records have full or partial backptr fields ? */
+
+int	full_ino_ex_data;	/*
+				 * if 1, use ino_ex_data_t component
+				 * of ino_un union, if 0, use
+				 * parent_list_t component.  see
+				 * incore.h for more details
+				 */
+
+#define ORPHANAGE	"lost+found"
+
+/* superblock counters */
+
+uint64_t	sb_icount;	/* allocated (made) inodes */
+uint64_t	sb_ifree;	/* free inodes */
+uint64_t	sb_fdblocks;	/* free data blocks */
+uint64_t	sb_frextents;	/* free realtime extents */
+
+/* superblock geometry info */
+
+xfs_extlen_t	sb_inoalignmt;
+uint32_t	sb_unit;
+uint32_t	sb_width;
+
+struct aglock	*ag_locks;
+
+int		report_interval;
+uint64_t	*prog_rpt_done;
+
+int		ag_stride;
+int		thread_count;
diff --git a/repair/globals.h b/repair/globals.h
index 9a9465f..05121d4 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -7,9 +7,7 @@
 #ifndef _XFS_REPAIR_GLOBAL_H
 #define _XFS_REPAIR_GLOBAL_H
 
-#ifndef EXTERN
-#define EXTERN extern
-#endif
+#include "libxfs.h"
 
 /* useful macros */
 
@@ -53,91 +51,91 @@
 
 /* arguments and argument flag variables */
 
-EXTERN char	*fs_name;		/* name of filesystem */
-EXTERN int	verbose;		/* verbose flag, mostly for debugging */
+extern char	*fs_name;		/* name of filesystem */
+extern int	verbose;		/* verbose flag, mostly for debugging */
 
 
 /* for reading stuff in manually (bypassing libsim) */
 
-EXTERN char	*iobuf;			/* large buffer */
-EXTERN int	iobuf_size;
-EXTERN char	*smallbuf;		/* small (1-4 page) buffer */
-EXTERN int	smallbuf_size;
-EXTERN int	sbbuf_size;
+extern char	*iobuf;			/* large buffer */
+extern int	iobuf_size;
+extern char	*smallbuf;		/* small (1-4 page) buffer */
+extern int	smallbuf_size;
+extern int	sbbuf_size;
 
 /* direct I/O info */
 
-EXTERN int	minio_align;		/* min I/O size and alignment */
-EXTERN int	mem_align;		/* memory alignment */
-EXTERN int	max_iosize;		/* max I/O size */
+extern int	minio_align;		/* min I/O size and alignment */
+extern int	mem_align;		/* memory alignment */
+extern int	max_iosize;		/* max I/O size */
 
 /* file descriptors */
 
-EXTERN int	fs_fd;			/* filesystem fd */
+extern int	fs_fd;			/* filesystem fd */
 
 /* command-line flags */
 
-EXTERN int	verbose;
-EXTERN int	no_modify;
-EXTERN int	dangerously;		/* live dangerously ... fix ro mount */
-EXTERN int	isa_file;
-EXTERN int	zap_log;
-EXTERN int	dumpcore;		/* abort, not exit on fatal errs */
-EXTERN int	force_geo;		/* can set geo on low confidence info */
-EXTERN int	assume_xfs;		/* assume we have an xfs fs */
-EXTERN char	*log_name;		/* Name of log device */
-EXTERN int	log_spec;		/* Log dev specified as option */
-EXTERN char	*rt_name;		/* Name of realtime device */
-EXTERN int	rt_spec;		/* Realtime dev specified as option */
-EXTERN int	convert_lazy_count;	/* Convert lazy-count mode on/off */
-EXTERN int	lazy_count;		/* What to set if to if converting */
+extern int	verbose;
+extern int	no_modify;
+extern int	dangerously;		/* live dangerously ... fix ro mount */
+extern int	isa_file;
+extern int	zap_log;
+extern int	dumpcore;		/* abort, not exit on fatal errs */
+extern int	force_geo;		/* can set geo on low confidence info */
+extern int	assume_xfs;		/* assume we have an xfs fs */
+extern char	*log_name;		/* Name of log device */
+extern int	log_spec;		/* Log dev specified as option */
+extern char	*rt_name;		/* Name of realtime device */
+extern int	rt_spec;		/* Realtime dev specified as option */
+extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
+extern int	lazy_count;		/* What to set if to if converting */
 
 /* misc status variables */
 
-EXTERN int		primary_sb_modified;
-EXTERN int		bad_ino_btree;
-EXTERN int		copied_sunit;
-EXTERN int		fs_is_dirty;
+extern int		primary_sb_modified;
+extern int		bad_ino_btree;
+extern int		copied_sunit;
+extern int		fs_is_dirty;
 
 /* for hunting down the root inode */
 
-EXTERN int		need_root_inode;
-EXTERN int		need_root_dotdot;
+extern int		need_root_inode;
+extern int		need_root_dotdot;
 
-EXTERN int		need_rbmino;
-EXTERN int		need_rsumino;
+extern int		need_rbmino;
+extern int		need_rsumino;
 
-EXTERN int		lost_quotas;
-EXTERN int		have_uquotino;
-EXTERN int		have_gquotino;
-EXTERN int		have_pquotino;
-EXTERN int		lost_uquotino;
-EXTERN int		lost_gquotino;
-EXTERN int		lost_pquotino;
+extern int		lost_quotas;
+extern int		have_uquotino;
+extern int		have_gquotino;
+extern int		have_pquotino;
+extern int		lost_uquotino;
+extern int		lost_gquotino;
+extern int		lost_pquotino;
 
-EXTERN xfs_agino_t	first_prealloc_ino;
-EXTERN xfs_agino_t	last_prealloc_ino;
-EXTERN xfs_agblock_t	bnobt_root;
-EXTERN xfs_agblock_t	bcntbt_root;
-EXTERN xfs_agblock_t	inobt_root;
+extern xfs_agino_t	first_prealloc_ino;
+extern xfs_agino_t	last_prealloc_ino;
+extern xfs_agblock_t	bnobt_root;
+extern xfs_agblock_t	bcntbt_root;
+extern xfs_agblock_t	inobt_root;
 
 /* configuration vars -- fs geometry dependent */
 
-EXTERN int		inodes_per_block;
-EXTERN int		inodes_per_cluster;
-EXTERN unsigned int	glob_agcount;
-EXTERN int		chunks_pblock;	/* # of 64-ino chunks per allocation */
-EXTERN int		max_symlink_blocks;
-EXTERN int64_t		fs_max_file_offset;
+extern int		inodes_per_block;
+extern int		inodes_per_cluster;
+extern unsigned int	glob_agcount;
+extern int		chunks_pblock;	/* # of 64-ino chunks per allocation */
+extern int		max_symlink_blocks;
+extern int64_t		fs_max_file_offset;
 
 /* realtime info */
 
-EXTERN xfs_rtword_t	*btmcompute;
-EXTERN xfs_suminfo_t	*sumcompute;
+extern xfs_rtword_t	*btmcompute;
+extern xfs_suminfo_t	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
 
-EXTERN int		full_ino_ex_data;/*
+extern int		full_ino_ex_data;/*
 					  * if 1, use ino_ex_data_t component
 					  * of ino_un union, if 0, use
 					  * parent_list_t component.  see
@@ -148,26 +146,26 @@ EXTERN int		full_ino_ex_data;/*
 
 /* superblock counters */
 
-EXTERN uint64_t	sb_icount;	/* allocated (made) inodes */
-EXTERN uint64_t	sb_ifree;	/* free inodes */
-EXTERN uint64_t	sb_fdblocks;	/* free data blocks */
-EXTERN uint64_t	sb_frextents;	/* free realtime extents */
+extern uint64_t	sb_icount;	/* allocated (made) inodes */
+extern uint64_t	sb_ifree;	/* free inodes */
+extern uint64_t	sb_fdblocks;	/* free data blocks */
+extern uint64_t	sb_frextents;	/* free realtime extents */
 
 /* superblock geometry info */
 
-EXTERN xfs_extlen_t	sb_inoalignmt;
-EXTERN uint32_t	sb_unit;
-EXTERN uint32_t	sb_width;
+extern xfs_extlen_t	sb_inoalignmt;
+extern uint32_t	sb_unit;
+extern uint32_t	sb_width;
 
 struct aglock {
 	pthread_mutex_t	lock __attribute__((__aligned__(64)));
 };
-EXTERN struct aglock	*ag_locks;
+extern struct aglock	*ag_locks;
 
-EXTERN int		report_interval;
-EXTERN uint64_t		*prog_rpt_done;
+extern int		report_interval;
+extern uint64_t		*prog_rpt_done;
 
-EXTERN int		ag_stride;
-EXTERN int		thread_count;
+extern int		ag_stride;
+extern int		thread_count;
 
 #endif /* _XFS_REPAIR_GLOBAL_H */
diff --git a/repair/versions.c b/repair/versions.c
index 9766e92..8fad41f 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -6,11 +6,28 @@
 
 #include "libxfs.h"
 
-#define EXTERN
-#include "versions.h"
-#undef EXTERN
 #include "err_protos.h"
 #include "globals.h"
+#include "versions.h"
+
+/*
+ * filesystem feature global vars, set to 1 if the feature
+ * is on, 0 otherwise
+ */
+
+int fs_attributes;
+int fs_attributes2;
+int fs_inode_nlink;
+int fs_quotas;
+int fs_aligned_inodes;
+int fs_sb_feature_bits;
+int fs_has_extflgbit;
+
+/*
+ * inode chunk alignment, fsblocks
+ */
+
+xfs_extlen_t	fs_ino_alignment;
 
 void
 update_sb_version(xfs_mount_t *mp)
diff --git a/repair/versions.h b/repair/versions.h
index 0cecf16..e1e2521 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -16,19 +16,19 @@
  * is on, 0 otherwise
  */
 
-EXTERN int		fs_attributes;
-EXTERN int		fs_attributes2;
-EXTERN int		fs_inode_nlink;
-EXTERN int		fs_quotas;
-EXTERN int		fs_aligned_inodes;
-EXTERN int		fs_sb_feature_bits;
-EXTERN int		fs_has_extflgbit;
+extern int		fs_attributes;
+extern int		fs_attributes2;
+extern int		fs_inode_nlink;
+extern int		fs_quotas;
+extern int		fs_aligned_inodes;
+extern int		fs_sb_feature_bits;
+extern int		fs_has_extflgbit;
 
 /*
  * inode chunk alignment, fsblocks
  */
 
-EXTERN xfs_extlen_t	fs_ino_alignment;
+extern xfs_extlen_t	fs_ino_alignment;
 
 /*
  * modify superblock to reflect current state of global fs
-- 
1.8.3.1
