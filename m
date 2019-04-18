Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40516 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731317AbfDRUBe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Apr 2019 16:01:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C1D83082204
        for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2019 20:01:34 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8C921001DC0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2019 20:01:33 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: more static function tidyups
Message-ID: <d0ba0699-12c8-8c42-3e69-c0e7976d579d@redhat.com>
Date: Thu, 18 Apr 2019 15:01:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Make many more functions static if they can be.  This is not all
of them; some are omitted for symmetry reasons, i.e. even if
btree_lookup_prev() is not used, I've left it available.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index a6d6703..54679d7 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -48,9 +48,9 @@ static pthread_mutex_t	mainwait;
 #define ACTIVE		1
 #define INACTIVE	2
 
-xfs_off_t	write_log_trailer(int fd, wbuf *w, xfs_mount_t *mp);
-xfs_off_t	write_log_header(int fd, wbuf *w, xfs_mount_t *mp);
-static int	format_logs(struct xfs_mount *);
+static xfs_off_t	write_log_trailer(int fd, wbuf *w, xfs_mount_t *mp);
+static xfs_off_t	write_log_header(int fd, wbuf *w, xfs_mount_t *mp);
+static int		format_logs(struct xfs_mount *);
 
 /* general purpose message reporting routine */
 
diff --git a/db/io.c b/db/io.c
index 6b66472..bb16618 100644
--- a/db/io.c
+++ b/db/io.c
@@ -51,10 +51,10 @@ static const cmdinfo_t  ring_cmd =
 	{ "ring", NULL, ring_f, 0, 1, 0, NULL,
 	  N_("show position ring or move to a specific entry"), ring_help };
 
-iocur_t	*iocur_base;
-iocur_t	*iocur_top;
-int	iocur_sp = -1;
-int	iocur_len;
+static iocur_t	*iocur_base;
+iocur_t		*iocur_top;
+int		iocur_sp = -1;
+static int	iocur_len;
 
 #define RING_ENTRIES 20
 static iocur_t iocur_ring[RING_ENTRIES];
diff --git a/db/io.h b/db/io.h
index c29a748..0e4f74a 100644
--- a/db/io.h
+++ b/db/io.h
@@ -35,10 +35,8 @@ typedef struct iocur {
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
 #define DB_RING_IGN 0                   /* do not add to ring on set_cur */
 
-extern iocur_t	*iocur_base;		/* base of stack */
 extern iocur_t	*iocur_top;		/* top element of stack */
 extern int	iocur_sp;		/* current top of stack */
-extern int	iocur_len;		/* length of stack array */
 
 extern void	io_init(void);
 extern void	off_cur(int off, int len);
diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 9e01cce..277b371 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -33,7 +33,7 @@ cvtnum(char *s)
 	return 0LL;
 }
 
-int ffn(const char *, const struct stat *, int, struct FTW *);
+static int ffn(const char *, const struct stat *, int, struct FTW *);
 
 #define BLOCKSIZE	4096
 #define INODESIZE	256
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index fef6262..55711bf 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -61,7 +61,7 @@ static time_t starttime;
 static xfs_ino_t	leftoffino = 0;
 static int	pagesize;
 
-void usage(int ret);
+static void usage(int ret);
 static int  fsrfile(char *fname, xfs_ino_t ino);
 static int  fsrfile_common( char *fname, char *tname, char *mnt,
                             int fd, xfs_bstat_t *statp);
@@ -73,17 +73,16 @@ static void initallfs(char *mtab);
 static void fsrallfs(char *mtab, int howlong, char *leftofffile);
 static void fsrall_cleanup(int timeout);
 static int  getnextents(int);
-int xfsrtextsize(int fd);
-int xfs_getrt(int fd, struct statvfs *sfbp);
-char * gettmpname(char *fname);
-char * getparent(char *fname);
-int fsrprintf(const char *fmt, ...);
-int read_fd_bmap(int, xfs_bstat_t *, int *);
-int cmp(const void *, const void *);
+static int xfs_getrt(int fd, struct statvfs *sfbp);
+static char * gettmpname(char *fname);
+static char * getparent(char *fname);
+static int fsrprintf(const char *fmt, ...);
+static int read_fd_bmap(int, xfs_bstat_t *, int *);
+static int cmp(const void *, const void *);
 static void tmp_init(char *mnt);
 static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
-int xfs_getgeom(int , xfs_fsop_geom_v1_t * );
+static int xfs_getgeom(int , xfs_fsop_geom_v1_t * );
 
 static xfs_fsop_geom_v1_t fsgeom;	/* geometry of active mounted system */
 
diff --git a/include/libxlog.h b/include/libxlog.h
index 92c54f4..14544db 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -76,8 +76,6 @@ extern int xlog_is_dirty(struct xfs_mount *, struct xlog *, libxfs_init_t *,
 			 int);
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
 extern void	xlog_put_bp(struct xfs_buf *);
-extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
-				xfs_buf_t *bp, char **offset);
 extern int	xlog_bread_noalign(struct xlog *log, xfs_daddr_t blk_no,
 				int nbblks, xfs_buf_t *bp);
 
@@ -90,7 +88,6 @@ extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
 
 extern int	xlog_recover(struct xlog *log, int readonly);
 extern void	xlog_recover_print_data(char *p, int len);
-extern void	xlog_recover_print_logitem(xlog_recover_item_t *item);
 extern void	xlog_recover_print_trans_head(xlog_recover_t *tr);
 extern int	xlog_print_find_oldest(struct xlog *log, xfs_daddr_t *last_blk);
 
diff --git a/io/io.h b/io/io.h
index 6469179..0b5b4dc 100644
--- a/io/io.h
+++ b/io/io.h
@@ -59,8 +59,6 @@ typedef struct mmap_region {
 	char		*name;		/* name of backing file */
 } mmap_region_t;
 
-extern mmap_region_t	*maptable;	/* mmap'd region array */
-extern int		mapcount;	/* #entries in the mapping table */
 extern mmap_region_t	*mapping;	/* active mapping table entry */
 extern int maplist_f(void);
 extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
diff --git a/io/mmap.c b/io/mmap.c
index f9383e5..db57c3e 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -20,9 +20,9 @@ static cmdinfo_t mwrite_cmd;
 static cmdinfo_t mremap_cmd;
 #endif /* HAVE_MREMAP */
 
-mmap_region_t	*maptable;
-int		mapcount;
-mmap_region_t	*mapping;
+static mmap_region_t	*maptable;
+static int		mapcount;
+mmap_region_t		*mapping;
 
 static void
 print_mapping(
diff --git a/io/pread.c b/io/pread.c
index 1b4352b..b14c51b 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -47,11 +47,11 @@ pread_help(void)
 "\n"));
 }
 
-void	*io_buffer;
-size_t	highwater;
-size_t	io_buffersize;
-int	vectors;
-struct iovec *iov;
+void		*io_buffer;
+static size_t	highwater;
+size_t		io_buffersize;
+int		vectors;
+struct iovec 	*iov;
 
 static int
 alloc_iovec(
@@ -112,7 +112,7 @@ alloc_buffer(
 	return 0;
 }
 
-void
+static void
 __dump_buffer(
 	void		*buf,
 	off64_t		offset,
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index ab56fcd..2b3683a 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -125,7 +125,7 @@ xlog_bread_noalign(
 	return libxfs_readbufr(log->l_dev, XFS_BUF_ADDR(bp), bp, nbblks, 0);
 }
 
-int
+static int
 xlog_bread(
 	struct xlog	*log,
 	xfs_daddr_t	blk_no,
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c325f04..2368e9e 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -26,7 +26,7 @@ typedef struct xlog_split_item {
 
 static xlog_split_item_t *split_list = NULL;
 
-void
+static void
 print_xlog_op_line(void)
 {
     printf("--------------------------------------"
@@ -47,7 +47,7 @@ print_xlog_record_line(void)
 	   "======================================\n");
 }	/* print_xlog_record_line */
 
-void
+static void
 print_stars(void)
 {
     printf("***********************************"
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index eafffe2..082d11c 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -380,7 +380,7 @@ xlog_recover_print_icreate(
 		be32_to_cpu(icl->icl_isize), be32_to_cpu(icl->icl_gen));
 }
 
-void
+static void
 xlog_recover_print_logitem(
 	xlog_recover_item_t	*item)
 {
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 98ac0d4..0515628 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -26,8 +26,6 @@ extern void xfs_log_print(struct xlog *, int, int);
 extern void xfs_log_print_trans(struct xlog *, int);
 
 extern void print_xlog_record_line(void);
-extern void print_xlog_op_line(void);
-extern void print_stars(void);
 
 extern struct xfs_inode_log_format *
 	xfs_inode_item_format_convert(char *, uint, struct xfs_inode_log_format *);
diff --git a/repair/btree.c b/repair/btree.c
index 292fa51..f101233 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -306,7 +306,7 @@ btree_find(
 	return root->cursor->node->ptrs[root->cursor->index];
 }
 
-void *
+static void *
 btree_lookup(
 	struct btree_root	*root,
 	unsigned long		key)
diff --git a/repair/btree.h b/repair/btree.h
index a9ea61a..0e57db8 100644
--- a/repair/btree.h
+++ b/repair/btree.h
@@ -23,11 +23,6 @@ btree_is_empty(
 	struct btree_root	*root);
 
 void *
-btree_lookup(
-	struct btree_root	*root,
-	unsigned long		key);
-
-void *
 btree_find(
 	struct btree_root	*root,
 	unsigned long		key,
diff --git a/repair/globals.c b/repair/globals.c
index ae9d55b..706303a 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -13,25 +13,6 @@
 char	*fs_name;		/* name of filesystem */
 int	verbose;		/* verbose flag, mostly for debugging */
 
-
-/* for reading stuff in manually (bypassing libsim) */
-
-char	*iobuf;			/* large buffer */
-int	iobuf_size;
-char	*smallbuf;		/* small (1-4 page) buffer */
-int	smallbuf_size;
-int	sbbuf_size;
-
-/* direct I/O info */
-
-int	minio_align;		/* min I/O size and alignment */
-int	mem_align;		/* memory alignment */
-int	max_iosize;		/* max I/O size */
-
-/* file descriptors */
-
-int	fs_fd;			/* filesystem fd */
-
 /* command-line flags */
 
 int	verbose;
diff --git a/repair/globals.h b/repair/globals.h
index 05121d4..a85e96a 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -54,25 +54,6 @@
 extern char	*fs_name;		/* name of filesystem */
 extern int	verbose;		/* verbose flag, mostly for debugging */
 
-
-/* for reading stuff in manually (bypassing libsim) */
-
-extern char	*iobuf;			/* large buffer */
-extern int	iobuf_size;
-extern char	*smallbuf;		/* small (1-4 page) buffer */
-extern int	smallbuf_size;
-extern int	sbbuf_size;
-
-/* direct I/O info */
-
-extern int	minio_align;		/* min I/O size and alignment */
-extern int	mem_align;		/* memory alignment */
-extern int	max_iosize;		/* max I/O size */
-
-/* file descriptors */
-
-extern int	fs_fd;			/* filesystem fd */
-
 /* command-line flags */
 
 extern int	verbose;
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 1de0e2f..a9af8de 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -870,7 +870,7 @@ init_prefetch(
 	pf_batch_fsbs = DEF_BATCH_BYTES >> (mp->m_sb.sb_blocklog + 1);
 }
 
-prefetch_args_t *
+static prefetch_args_t *
 start_inode_prefetch(
 	xfs_agnumber_t		agno,
 	int			dirs_only,
diff --git a/repair/prefetch.h b/repair/prefetch.h
index 54ece48..504e617 100644
--- a/repair/prefetch.h
+++ b/repair/prefetch.h
@@ -37,12 +37,6 @@ void
 init_prefetch(
 	xfs_mount_t		*pmp);
 
-prefetch_args_t *
-start_inode_prefetch(
-	xfs_agnumber_t		agno,
-	int			dirs_only,
-	prefetch_args_t		*prev_args);
-
 void
 do_inode_prefetch(
 	struct xfs_mount	*mp,
diff --git a/repair/versions.c b/repair/versions.c
index 4c44b4e..16805b3 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -15,13 +15,13 @@
  * is on, 0 otherwise
  */
 
-int fs_attributes;
-int fs_attributes2;
-int fs_inode_nlink;
+static int fs_attributes;
+static int fs_attributes2;
+static int fs_inode_nlink;
+static int fs_sb_feature_bits;
+static int fs_has_extflgbit;
 int fs_quotas;
 int fs_aligned_inodes;
-int fs_sb_feature_bits;
-int fs_has_extflgbit;
 
 /*
  * inode chunk alignment, fsblocks
diff --git a/repair/versions.h b/repair/versions.h
index e1e2521..512dbec 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -16,13 +16,8 @@
  * is on, 0 otherwise
  */
 
-extern int		fs_attributes;
-extern int		fs_attributes2;
-extern int		fs_inode_nlink;
 extern int		fs_quotas;
 extern int		fs_aligned_inodes;
-extern int		fs_sb_feature_bits;
-extern int		fs_has_extflgbit;
 
 /*
  * inode chunk alignment, fsblocks
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index f928a86..d9dd6be 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -6,8 +6,8 @@
 
 #include "libxfs.h"
 
-int rtcp(char *, char *, int);
-int xfsrtextsize(char *path);
+static int rtcp(char *, char *, int);
+static int xfsrtextsize(char *path);
 
 static int pflag;
 char *progname;
@@ -96,7 +96,7 @@ main(int argc, char **argv)
 	exit(r?2:0);
 }
 
-int
+static int
 rtcp( char *source, char *target, int fextsize)
 {
 	int		fromfd, tofd, readct, writect, iosz, reopen;
@@ -365,7 +365,7 @@ rtcp( char *source, char *target, int fextsize)
 /*
  * Determine the realtime extent size of the XFS file system
  */
-int
+static int
 xfsrtextsize( char *path)
 {
 	int fd, rval, rtextsize;
diff --git a/scrub/repair.c b/scrub/repair.c
index 4ed3c09..f33c1f1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -202,7 +202,7 @@ xfs_action_list_add(
 }
 
 /* Splice two repair lists. */
-void
+static void
 xfs_action_list_splice(
 	struct xfs_action_list		*dest,
 	struct xfs_action_list		*src)
diff --git a/scrub/repair.h b/scrub/repair.h
index c8693cc..ab39795 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -19,8 +19,6 @@ void xfs_action_list_init(struct xfs_action_list *alist);
 size_t xfs_action_list_length(struct xfs_action_list *alist);
 void xfs_action_list_add(struct xfs_action_list *dest,
 		struct action_item *item);
-void xfs_action_list_splice(struct xfs_action_list *dest,
-		struct xfs_action_list *src);
 
 void xfs_action_list_find_mustfix(struct xfs_action_list *actions,
 		struct xfs_action_list *immediate_alist,
