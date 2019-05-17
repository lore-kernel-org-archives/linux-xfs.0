Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfEQMDJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 08:03:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E89C30C7DE
        for <linux-xfs@vger.kernel.org>; Fri, 17 May 2019 12:03:09 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] xfsdump: add a space after commas and semicolons where was none
Date: Fri, 17 May 2019 13:52:54 +0200
Message-Id: <20190517115254.54436-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

A simple change: x,y -> x, y

Manual changes were for re-alignment, because expressions length
changed, and when a few lines got over 80 chars. Created by script:

find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
    $0 = gensub(/^([^"]*)([,;])([-.*_&a-zA-Z0-9])/, "\\1\\2 \\3", "g")
    $0 = gensub(/([,;])([-.*_&a-zA-Z0-9])([^"]*)$/, "\\1 \\2\\3", "g")
}; {print }' {} \;

As in the previous patches, do not touch strings. And this time the
patch is smaller, just 68 lines changed. There are some macros whose
definition was modified with a space, but there is no new warning in
gcc, so I'm including them.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/arch_xlate.c     |  2 +-
 common/content_inode.h  |  2 +-
 common/drive_minrmt.c   | 12 ++++++------
 common/drive_scsitape.c | 10 +++++-----
 common/getdents.c       |  2 +-
 common/inventory.h      |  2 +-
 common/main.c           |  8 ++++----
 common/ts_mtio.h        |  2 +-
 common/util.h           |  2 +-
 dump/content.c          | 10 +++++-----
 include/swap.h          | 24 ++++++++++++------------
 inventory/inv_idx.c     |  8 ++++----
 inventory/inv_oref.h    |  2 +-
 inventory/inv_priv.h    |  6 +++---
 inventory/inv_stobj.c   |  4 ++--
 inventory/inventory.h   |  2 +-
 inventory/testmain.c    |  6 +++---
 invutil/cmenu.h         | 14 +++++++-------
 invutil/fstab.c         |  2 +-
 invutil/invidx.c        |  4 ++--
 invutil/invutil.c       |  4 ++--
 librmt/rmtopen.c        |  2 +-
 restore/content.c       |  2 +-
 restore/tree.c          |  4 ++--
 24 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index 99b1d00..46d525f 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -35,7 +35,7 @@
 #include "inv_priv.h"
 #include "mlog.h"
 
-#define IXLATE(a1,a2,MEMBER)	\
+#define IXLATE(a1, a2, MEMBER)	\
 	INT_XLATE((a1)->MEMBER, (a2)->MEMBER, dir, ARCH_CONVERT)
 #define BXLATE(MEMBER)		\
 	bcopy(&(ptr1)->MEMBER, &(ptr2)->MEMBER, sizeof((ptr1)->MEMBER))
diff --git a/common/content_inode.h b/common/content_inode.h
index e1885fd..fa10649 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -75,7 +75,7 @@ struct content_inode_hdr {
 	char pad1[4];					/*   4  10 */
 		/* alignment */
 	time32_t cih_last_time;				/*   4  14 */
-		/* if an incremental,time of previous dump at a lesser level */
+		/* if an incremental, time of previous dump at a lesser level */
 	time32_t cih_resume_time;			/*   4  18 */
 		/* if a resumed dump, time of interrupted dump */
 	xfs_ino_t cih_rootino;				/*   8  20 */
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index e9be114..a094f0f 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -62,11 +62,11 @@
 /* remote tape protocol debug
  */
 #ifdef RMTDBG
-#define	open(p,f)		dbgrmtopen(p,f)
-#define	close(fd)		dbgrmtclose(fd)
-#define	ioctl(fd,op,arg)	dbgrmtioctl(fd,op,arg)
-#define	read(fd,p,sz)		dbgrmtread(fd,p,sz)
-#define	write(fd,p,sz)		dbgrmtwrite(fd,p,sz)
+#define	open(p, f)			dbgrmtopen(p, f)
+#define	close(fd)			dbgrmtclose(fd)
+#define	ioctl(fd, op, arg)	dbgrmtioctl(fd, op, arg)
+#define	read(fd, p, sz)		dbgrmtread(fd, p, sz)
+#define	write(fd, p, sz)	dbgrmtwrite(fd, p, sz)
 #else /* RMTDBG */
 #define	open rmtopen
 #define	close rmtclose
@@ -2661,7 +2661,7 @@ validate_media_file_hdr(drive_t *drivep)
 
 	/* check the magic number
 	 */
-	if (strncmp(grhdrp->gh_magic, GLOBAL_HDR_MAGIC,GLOBAL_HDR_MAGIC_SZ)) {
+	if (strncmp(grhdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ)) {
 	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	              "missing magic number in tape label\n");
 	        return DRIVE_ERROR_FORMAT;
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 5c9ee89..1c7057f 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -58,11 +58,11 @@
 /* remote tape protocol debug
  */
 #ifdef RMTDBG
-#define	open(p,f)		dbgrmtopen(p,f)
+#define	open(p, f)		dbgrmtopen(p, f)
 #define	close(fd)		dbgrmtclose(fd)
-#define	ioctl(fd,op,arg)	dbgrmtioctl(fd,op,arg)
-#define	read(fd,p,sz)		dbgrmtread(fd,p,sz)
-#define	write(fd,p,sz)		dbgrmtwrite(fd,p,sz)
+#define	ioctl(fd, op, arg)	dbgrmtioctl(fd, op, arg)
+#define	read(fd, p, sz)		dbgrmtread(fd, p, sz)
+#define	write(fd, p, sz)		dbgrmtwrite(fd, p, sz)
 #else /* RMTDBG */
 #define	open rmtopen
 #define	close rmtclose
@@ -3071,7 +3071,7 @@ validate_media_file_hdr(drive_t *drivep)
 
 	/* check the magic number
 	 */
-	if (strncmp(grhdrp->gh_magic, GLOBAL_HDR_MAGIC,GLOBAL_HDR_MAGIC_SZ)) {
+	if (strncmp(grhdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ)) {
 	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	              "missing magic number in tape label\n");
 	        return DRIVE_ERROR_FORMAT;
diff --git a/common/getdents.c b/common/getdents.c
index 957bb5a..7f79101 100644
--- a/common/getdents.c
+++ b/common/getdents.c
@@ -17,7 +17,7 @@
  */
 
 /*
- * Copyright (C) 1993, 95, 96, 97, 98, 99,2000,2001 Free Software Foundation, Inc.
+ * Copyright (C) 1993, 95, 96, 97, 98, 99, 2000, 2001 Free Software Foundation, Inc.
  * This file is based almost entirely on getdents.c in the GNU C Library.
  */
 
diff --git a/common/inventory.h b/common/inventory.h
index 599fc25..a87baae 100644
--- a/common/inventory.h
+++ b/common/inventory.h
@@ -144,7 +144,7 @@ typedef struct invt_strdesc_entry	*inv_stmtoken_t;
 extern inv_idbtoken_t
 inv_open(
 	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
-	 void 		 *pred);/* uuid_t *,char * mntpt, or char *dev */
+	 void 		 *pred);/* uuid_t *, char * mntpt, or char *dev */
 
 
 extern bool_t
diff --git a/common/main.c b/common/main.c
index 1edfae4..d98b0b0 100644
--- a/common/main.c
+++ b/common/main.c
@@ -980,7 +980,7 @@ usage(void)
 	ULO(_("(interactive)"),				GETOPT_INTERACTIVE);
 	ULO(_("(force usage of minimal rmt)"),		GETOPT_MINRMT);
 	ULO(_("<file> (restore only if newer than)"),	GETOPT_NEWER);
-	ULO(_("(restore owner/group even if not root)"),GETOPT_OWNER);
+	ULO(_("(restore owner/group even if not root)"), GETOPT_OWNER);
 	ULO(_("<seconds between progress reports>"),	GETOPT_PROGRESS);
 	ULO(_("<use QIC tape settings>"),		GETOPT_QIC);
 	ULO(_("(cumulative restore)"),			GETOPT_CUMULATIVE);
@@ -988,7 +988,7 @@ usage(void)
 	ULO(_("(contents only)"),			GETOPT_TOC);
 	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
 	ULO(_("(use small tree window)"),		GETOPT_SMALLWINDOW);
-	ULO(_("(don't restore extended file attributes)"),GETOPT_NOEXTATTR);
+	ULO(_("(don't restore extended file attributes)"), GETOPT_NOEXTATTR);
 	ULO(_("(restore root dir owner/permissions)"),	GETOPT_ROOTPERM);
 	ULO(_("(restore DMAPI event settings)"),	GETOPT_SETDM);
 #ifdef REVEAL
@@ -998,7 +998,7 @@ usage(void)
 	ULO(_("(don't prompt)"),			GETOPT_FORCE);
 	ULO(_("(display dump inventory)"),		GETOPT_INVPRINT);
 	ULO(_("(inhibit inventory update)"),		GETOPT_NOINVUPDATE);
-	ULO(_("(force use of format 2 generation numbers)"),GETOPT_FMT2COMPAT);
+	ULO(_("(force use of format 2 generation numbers)"), GETOPT_FMT2COMPAT);
 	ULO(_("<session label>"),			GETOPT_DUMPLABEL);
 #ifdef REVEAL
 	ULO(_("(timestamp messages)"),			GETOPT_TIMESTAMP);
@@ -1007,7 +1007,7 @@ usage(void)
 #ifdef REVEAL
 	ULO(_("(pin down I/O buffers)"),		GETOPT_RINGPIN);
 #endif /* REVEAL */
-	ULO(_("(force interrupted session completion)"),GETOPT_SESSCPLT);
+	ULO(_("(force interrupted session completion)"), GETOPT_SESSCPLT);
 	ULO(_("(resume)"),				GETOPT_RESUME);
 	ULO(_("<session id>"),				GETOPT_SESSIONID);
 	ULO(_("(don't timeout dialogs)"),		GETOPT_NOTIMEOUTS);
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index 9e4ae4c..1689c36 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -676,7 +676,7 @@ struct mt_fpmsg {
 			char   msg1[8];	        /* message 1 */
 			char   msg2[8];	        /* message 2 */
 		} ibm3590;
-		struct {		/* Format for Fujitsu Diana 1,2,3 */
+		struct {		/* Format for Fujitsu Diana 1, 2, 3 */
 			char   display_mode:3,
 		               display_len:1,
 		               flash:1,
diff --git a/common/util.h b/common/util.h
index ab43739..97a0ac6 100644
--- a/common/util.h
+++ b/common/util.h
@@ -151,7 +151,7 @@ extern int diriter(jdm_fshandle_t *fshandlep,
 /*
  * Align pointer up to alignment
  */
-#define	ALIGN_PTR(p,a)	\
+#define	ALIGN_PTR(p, a)	\
 	(((intptr_t)(p) & ((a)-1)) ? \
 		((void *)(((intptr_t)(p) + ((a)-1)) & ~((a)-1))) : \
 		((void *)(p)))
diff --git a/dump/content.c b/dump/content.c
index 43f51db..ccd15b6 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -5694,7 +5694,7 @@ position:
 			}
 
 			if ((int32_t)mwhdrp->mh_mediaix >= 0) {
-				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 				      "cannot interleave dump streams: "
 				      "must supply a blank media object\n"));
 				goto changemedia;
@@ -5829,7 +5829,7 @@ position:
 			}
 
 			if (contextp->cc_Media_useterminatorpr) {
-				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 				      "encountered EOD but expecting a media "
 				      "stream terminator: "
 				      "assuming full media\n"));
@@ -5882,7 +5882,7 @@ position:
 			}
 
 			if (contextp->cc_Media_useterminatorpr) {
-				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 				      "encountered corrupt or foreign data "
 				      "but expecting a media "
 				      "stream terminator: "
@@ -5890,7 +5890,7 @@ position:
 				mlog_exit_hint(RV_CORRUPT);
 				goto changemedia;
 			} else if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
-				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 				      "encountered corrupt or foreign data: "
 				      "unable to overwrite: "
 				      "assuming corrupted media\n"));
@@ -5898,7 +5898,7 @@ position:
 				goto changemedia;
 			} else {
 				int status;
-				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 				      "encountered corrupt or foreign data: "
 				      "repositioning to overwrite\n"));
 				mlog_exit_hint(RV_CORRUPT);
diff --git a/include/swap.h b/include/swap.h
index d74453f..ca42422 100644
--- a/include/swap.h
+++ b/include/swap.h
@@ -35,29 +35,29 @@
 #endif
 
 #ifndef HAVE_SWABMACROS
-#define INT_SWAP16(type,var) ((typeof(type))(__swab16((__u16)(var))))
-#define INT_SWAP32(type,var) ((typeof(type))(__swab32((__u32)(var))))
-#define INT_SWAP64(type,var) ((typeof(type))(__swab64((__u64)(var))))
+#define INT_SWAP16(type, var) ((typeof(type))(__swab16((__u16)(var))))
+#define INT_SWAP32(type, var) ((typeof(type))(__swab32((__u32)(var))))
+#define INT_SWAP64(type, var) ((typeof(type))(__swab64((__u64)(var))))
 #endif
 
 #define INT_SWAP(type, var) \
-	((sizeof(type) == 8) ? INT_SWAP64(type,var) : \
-	((sizeof(type) == 4) ? INT_SWAP32(type,var) : \
-	((sizeof(type) == 2) ? INT_SWAP16(type,var) : \
+	((sizeof(type) == 8) ? INT_SWAP64(type, var) : \
+	((sizeof(type) == 4) ? INT_SWAP32(type, var) : \
+	((sizeof(type) == 2) ? INT_SWAP16(type, var) : \
 	(var))))
 
-#define INT_GET(ref,arch) \
-	(((arch) == ARCH_NOCONVERT) ? (ref) : INT_SWAP((ref),(ref)))
+#define INT_GET(ref, arch) \
+	(((arch) == ARCH_NOCONVERT) ? (ref) : INT_SWAP((ref), (ref)))
 
-#define INT_SET(ref,arch,valueref) \
+#define INT_SET(ref, arch, valueref) \
 	(__builtin_constant_p(valueref) ? \
 	(void)((ref) = (((arch) != ARCH_NOCONVERT) ? \
-	  		   (INT_SWAP((ref),(valueref))) : (valueref))) : \
+			   (INT_SWAP((ref), (valueref))) : (valueref))) : \
 	(void)(((ref) = (valueref)), \
 			(((arch) != ARCH_NOCONVERT) ? \
-			   (ref) = INT_SWAP((ref),(ref)) : 0)))
+			   (ref) = INT_SWAP((ref), (ref)) : 0)))
 
-#define INT_XLATE(buf,p,dir,arch) \
+#define INT_XLATE(buf, p, dir, arch) \
 	((dir > 0) ? ((p) = INT_GET((buf),(arch))) : INT_SET((buf),(arch),(p)))
 
 #endif /* SWAP_H */
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 7f50a2b..5ca2b02 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -57,7 +57,7 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 	/* If time period of the new entry is before our first invindex,
 	   we have to insert a new invindex in the first slot */
 	if (iarr[0].ie_timeperiod.tp_start > tm) {
-		/* *stobjfd = idx_put_newentry(fd, 0, iarr, icnt, &ient);*/
+		/* *stobjfd = idx_put_newentry(fd, 0, iarr, icnt, &ient); */
 		*stobjfd = open(iarr[0].ie_filename, INV_OFLAG(forwhat));
 		return 0;
 	}
@@ -67,7 +67,7 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 		   period, hellalujah */
 		if (IS_WITHIN(&iarr[i].ie_timeperiod, tm)) {
 #ifdef INVT_DEBUG
-			mlog(MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n",i);
+			mlog(MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n", i);
 #endif
 			*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			return i;
@@ -110,7 +110,7 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 				   insert the new entry and write back
 				   icnt and invindex entry */
 				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
-							     icnt, &ient);*/
+							     icnt, &ient); */
 			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			      return i;
 			}
@@ -132,7 +132,7 @@ idx_insert_newentry(int fd, /* kept locked EX by caller */
 				   one. Then insert the new entry and write
 				   back icnt and invindex entries */
 				/* *stobjfd = idx_put_newentry(fd, i+1, iarr,
-							     icnt, &ient);*/
+							     icnt, &ient); */
 			      *stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 				return i;
 			}
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 836ce82..3118b38 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -125,7 +125,7 @@ typedef struct invt_oref {
 				       (oref)->lockflag == LOCK_UN)
 
 #define OREF_LOCK(oref, mode) \
-        { if (! OREF_LOCKMODE_EQL(oref,mode)) \
+        { if (! OREF_LOCKMODE_EQL(oref, mode)) \
 	      { INVLOCK((oref)->fd, mode); \
 		(oref)->lockflag = mode; } \
 	}
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 2310dc1..9b79b04 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -85,8 +85,8 @@
 			       (size_t) nhdrs * sizeof(invt_seshdr_t) + \
 			       (size_t) nsess * sizeof(invt_session_t))
 
-#define STREQL(n,m)		(strcmp((n),(m)) == 0)
-#define UUID_EQL(n,m,t)	(uuid_compare(n, m, t) == 0)
+#define STREQL(n, m)		(strcmp((n), (m)) == 0)
+#define UUID_EQL(n, m, t)	(uuid_compare(n, m, t) == 0)
 #define IS_PARTIAL_SESSION(h) ((h)->sh_flag & INVT_PARTIAL)
 #define IS_RESUMED_SESSION(h) ((h)->sh_flag & INVT_RESUMED)
 #define SC_EOF_INITIAL_POS	(off64_t) (sizeof(invt_sescounter_t) + \
@@ -94,7 +94,7 @@
 					 (sizeof(invt_seshdr_t) + \
 					   sizeof(invt_session_t)))
 
-#define INV_PERROR(s)  	mlog(MLOG_NORMAL,"INV: %s %s\n", s,strerror(errno))
+#define INV_PERROR(s)  	mlog(MLOG_NORMAL, "INV: %s %s\n", s, strerror(errno))
 #define INV_OFLAG(f)    (f == INV_SEARCH_ONLY) ? O_RDONLY: O_RDWR
 
 /*----------------------------------------------------------------------*/
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 74893d3..29dec74 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -445,7 +445,7 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 	off64_t off  = hdr->sh_streams_off;
 	off64_t mfileoff = off + (off64_t)(nstm * sizeof(invt_stream_t));
 	uint nmfiles = 0;
-	uint i,j;
+	uint i, j;
 
 	/* fix the offsets in streams */
 	for (i = 0; i < nstm; i++) {
@@ -636,7 +636,7 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 
 	/* We need to update the last ino of this STREAM, which is now the
 	   last ino of the new mediafile. If this is the first mediafile, we
-	   have to update the startino as well. Note that ino is a <ino,off>
+	   have to update the startino as well. Note that ino is a <ino, off>
 	   tuple */
 	if (! (mf->mf_flag & INVT_MFILE_INVDUMP)) {
 		if (stream.st_nmediafiles == 0)
diff --git a/inventory/inventory.h b/inventory/inventory.h
index ad27205..e81f153 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -189,7 +189,7 @@ extern inv_idbtoken_t
 inv_open(
 	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
 	 inv_oflag_t      forwhat,/* SEARCH_ONLY, SEARCH_N_MOD */
-	 void 		 *pred);/* uuid_t *,char * mntpt, or char *dev */
+	 void 		 *pred);/* uuid_t *, char * mntpt, or char *dev */
 
 
 extern bool_t
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 90654cc..976c38d 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -202,7 +202,7 @@ query_test(int level)
 	invt_pr_ctx_t prctx;
 
 	if (level == -2) {
-		printf("mount pt %s\n",sesfile);
+		printf("mount pt %s\n", sesfile);
 		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, sesfile);
 		if (! tok) return -1;
 		idx_DEBUG_print (tok->d_invindex_fd);
@@ -251,7 +251,7 @@ query_test(int level)
 int
 write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 {
-	int i,j,k,m,fd;
+	int i, j, k, m, fd;
 	unsigned int stat;
 	uuid_t *fsidp;
 	inv_idbtoken_t tok1;
@@ -301,7 +301,7 @@ write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 	for (i = 0; i < nsess; i++) {
 		j = i % 8;
 		/*mnt = mnt_str[j];
-		dev = dev_str[7-j];*/
+		dev = dev_str[7-j]; */
 		mnt = mnt_str[0];
 		dev = dev_str[7];
 		fsidp = &fsidarr[0]; /* j */
diff --git a/invutil/cmenu.h b/invutil/cmenu.h
index f3c205f..0700063 100644
--- a/invutil/cmenu.h
+++ b/invutil/cmenu.h
@@ -26,16 +26,16 @@
 /* number of lines for info window */
 #define INFO_SIZE 4
 
-#define put_header(m,a)		put_line(stdscr, 0, m, A_REVERSE | A_BOLD, a)
-#define put_footer(m,a)		put_line(stdscr, LINES - 1, m, A_REVERSE | A_BOLD, a)
-#define put_error(m)		put_line(stdscr, LINES - 1, m, A_REVERSE | A_BOLD, ALIGN_LEFT);\
+#define put_header(m, a)		put_line(stdscr, 0, m, A_REVERSE | A_BOLD, a)
+#define put_footer(m, a)		put_line(stdscr, LINES - 1, m, A_REVERSE | A_BOLD, a)
+#define put_error(m)			put_line(stdscr, LINES - 1, m, A_REVERSE | A_BOLD, ALIGN_LEFT);\
 					beep();\
 					wrefresh(stdscr);\
 					sleep(2)
-#define put_info_header(m)	put_line(infowin, 0, m, A_REVERSE|A_BOLD, ALIGN_LEFT)
-#define put_info_line(l,m)	put_line(infowin, l, m, 0, ALIGN_LEFT)
-#define put_option(w,l,t,a)	put_line(w, l, t, a, ALIGN_LEFT)
-#define clear_line(w,l)		wmove(w, l, 0); wclrtoeol(w);
+#define put_info_header(m)		put_line(infowin, 0, m, A_REVERSE|A_BOLD, ALIGN_LEFT)
+#define put_info_line(l, m)		put_line(infowin, l, m, 0, ALIGN_LEFT)
+#define put_option(w, l, t, a)	put_line(w, l, t, a, ALIGN_LEFT)
+#define clear_line(w, l)		wmove(w, l, 0); wclrtoeol(w);
 
 typedef enum {
     ALIGN_LEFT,
diff --git a/invutil/fstab.c b/invutil/fstab.c
index 3319a5c..88d849e 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -44,7 +44,7 @@ int fstab_numfiles;
 menu_ops_t fstab_ops = {
     NULL,
     NULL,
-    NULL, /*fstab_saveall,*/
+    NULL, /*fstab_saveall, */
     fstab_select,
     NULL,
     NULL,
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 3ba2d44..5874e8d 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -463,7 +463,7 @@ update_invidx_entry(int fd, char *filename, int stobj_fd)
     read_n_bytes(stobj_fd, &sescnt, sizeof(sescnt), "stobj file");
 
     memset(&hdr, 0, sizeof(hdr));
-    first_offset = STOBJ_OFFSET(0,0);
+    first_offset = STOBJ_OFFSET(0, 0);
     lseek(stobj_fd, first_offset, SEEK_SET);
     read_n_bytes(stobj_fd, &hdr, sizeof(hdr), "stobj file");
     start_time = hdr.sh_time;
@@ -632,7 +632,7 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
     off64_t	off	= hdr->sh_streams_off;
     off64_t	mfileoff= off + (off64_t)(nstm * sizeof(invt_stream_t));
     uint	nmfiles = 0;
-    uint	i,j;
+    uint	i, j;
 
     /* fix the offsets in streams */
      for (i = 0; i < nstm; i++) {
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 242574f..73e122c 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -460,7 +460,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
     int		j;
     bool_t	removeflag;
     invt_fstab_t *fstabentry;
-    invt_counter_t *counter,cnt;
+    invt_counter_t *counter, cnt;
 
     if (mountPt == NULL && uuid_is_null(*uuidp) && uuid_is_null(*sessionp)) {
 	fprintf(stderr, "%s: mountpoint, uuid or session "
@@ -613,7 +613,7 @@ CheckAndPruneInvIndexFile(bool_t checkonly,
     invt_counter_t header;
 
     printf("      processing index file \n"
-	   "       %s\n",idxFileName);
+	   "       %s\n", idxFileName);
 
     fd = open_and_lock(idxFileName,
 			FILE_WRITE,
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index a091c72..2f46324 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -50,7 +50,7 @@ struct uname_table
 };
 
 struct uname_table uname_table[] =
-{ {UNAME_LINUX, "Linux"}, {UNAME_IRIX, "IRIX"}, {0,0} };
+{ {UNAME_LINUX, "Linux"}, {UNAME_IRIX, "IRIX"}, {0, 0} };
 
 
 /*
diff --git a/restore/content.c b/restore/content.c
index 930a76c..dc2fcdd 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -2207,7 +2207,7 @@ content_stream_restore(ix_t thrdix)
 		if (fileh == DH_NULL) {
 			return mlog_exit(EXIT_FAULT, RV_ERROR);
 		}
-		uuid_copy(persp->s.dumpid,grhdrp->gh_dumpid);
+		uuid_copy(persp->s.dumpid, grhdrp->gh_dumpid);
 		persp->s.begintime = time(0);
 		tranp->t_dumpidknwnpr = BOOL_TRUE;
 		tranp->t_sync2 = SYNC_DONE;
diff --git a/restore/tree.c b/restore/tree.c
index 3f3084e..851a865 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -1974,7 +1974,7 @@ tree_cb_links(xfs_ino_t ino,
 			adopt(persp->p_orphh, nh, NRH_NULL);
 			ok = Node2path(nh, path1, _("orphan"));
 			assert(ok);
-			(void)(* funcp)(contextp, BOOL_FALSE, path1,path2);
+			(void)(* funcp)(contextp, BOOL_FALSE, path1, path2);
 		}
 	}
 	return RV_OK;
@@ -3130,7 +3130,7 @@ static tsi_cmd_tbl_t tsi_cmd_tbl[] = {
 	{ "cd",		"[ <path> ]",			tsi_cmd_cd,	1, 2 },
 	{ "add",	"[ <path> ]",			tsi_cmd_add,	1, 2 },
 	{ "delete",	"[ <path> ]",			tsi_cmd_delete,	1, 2 },
-	{ "extract",	"",				tsi_cmd_extract,1, 1 },
+	{ "extract",	"",				tsi_cmd_extract, 1, 1 },
 	{ "quit",	"",				tsi_cmd_quit,	1, 1 },
 	{ "help",	"",				tsi_cmd_help,	1, 1 },
 };
-- 
2.21.0
