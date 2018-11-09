Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbeKJANW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:13:22 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42525811D9
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:32:31 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 21/24] xfsdump: (style) format intercharacter spaces
Date: Fri,  9 Nov 2018 15:30:01 +0100
Message-Id: <20181109143004.24963-22-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

This patch changes intercharacter spaces, e.g. adds a space around binary
operators, removes multiple spaces where they are not used for alignment,
removes a space in a function header ("fnt ()" -> "fnt()"), etc.

Created by Uncrustify with this config file:

#
# uncrustify config, format intercharacter spaces
#

indent_with_tabs	= 2		# 1=indent with tabs, align with spaces, 2=use all tabs
input_tab_size		= 8		# original tab size
output_tab_size		= 8		# new tab size
indent_columns		= output_tab_size

indent_label		= 1		# pos: absolute col, neg: relative column

#
# inter-symbol newlines
#

nl_enum_brace		= ignore	# "enum {" vs "enum
 {"
nl_union_brace		= ignore	# "union {" vs "union
 {"
nl_struct_brace		= ignore	# "struct {" vs "struct
 {"
nl_do_brace 		= ignore	# "do {" vs "do
 {"
nl_if_brace 		= ignore	# "if () {" vs "if ()
 {"
nl_for_brace 		= ignore	# "for () {" vs "for ()
 {"
nl_else_brace 		= ignore	# "else {" vs "else
 {"
nl_while_brace 		= ignore	# "while () {" vs "while ()
 {"
nl_switch_brace 	= ignore	# "switch () {" vs "switch ()
 {"
nl_brace_while		= ignore	# "} while" vs "}
 while" - cuddle while
nl_brace_else		= ignore	# "} else" vs "}
 else" - cuddle else
sp_brace_else		= ignore
sp_else_brace		= ignore
nl_fcall_brace		= ignore	# "list_for_each() {" vs "list_for_each()
{"
nl_fdef_brace		= ignore		# "int foo() {" vs "int foo()
{"

#
# Source code modifications
#

mod_paren_on_return	= ignore	# "return 1;" vs "return (1);"
mod_full_brace_for	= ignore	# "for () a--;" vs "for () { a--; }"
mod_full_brace_do	= ignore	# "do a--; while ();" vs "do { a--; } while ();"
mod_full_brace_while	= ignore	# "while (a) a--;" vs "while (a) { a--; }"

#
# inter-character spacing options
#

sp_return_paren		= force		# "return (1);" vs "return(1);"
sp_sizeof_paren		= remove	# "sizeof (int)" vs "sizeof(int)"
sp_before_sparen	= force		# "if (" vs "if("
sp_after_sparen		= force		# "if () {" vs "if (){"
sp_after_cast		= remove	# "(int) a" vs "(int)a"
sp_inside_braces	= force		# "{ 1 }" vs "{1}"
sp_inside_braces_struct	= force	# "{ 1 }" vs "{1}"
sp_inside_braces_enum	= force	# "{ 1 }" vs "{1}"
sp_assign		= force
sp_arith		= force
sp_bool			= force
sp_compare		= force
sp_assign		= force
sp_after_comma		= force
sp_func_def_paren	= remove	# "int foo (){" vs "int foo(){"
sp_func_call_paren	= remove	# "foo (" vs "foo("
sp_func_proto_paren	= remove	# "int foo ();" vs "int foo();"

#
# Aligning stuff
#

align_with_tabs		= TRUE		# use tabs to align
align_on_tabstop	= TRUE 		# align on tabstops
align_enum_equ_span	= 4		# '=' in enum definition
align_var_def_colon	= TRUE
align_struct_init_span	= 3		# align stuff in a structure init '= { }'
align_right_cmt_span	= 3

#
# other
#

nl_func_paren = ignore
nl_func_decl_start = ignore
nl_func_decl_empty = ignore
nl_func_decl_args = ignore
nl_func_decl_end = ignore

sp_inside_paren = remove
sp_inside_square = remove
sp_inside_paren_cast = remove
sp_inside_fparen = remove
sp_inside_sparen = remove
sp_paren_paren = remove
sp_before_ptr_star = force
sp_after_ptr_star = remove
sp_between_ptr_star = remove
align_func_params = true
align_var_struct_span = 6

eat_blanks_after_open_brace   = false
eat_blanks_before_close_brace = false
pp_indent = ignore

nl_start_of_file   = ignore
nl_end_of_file     = ignore
nl_end_of_file_min = 1
nl_comment_func_def = 1

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/cldmgr.c         |   2 +-
 common/cleanup.c        |   2 +-
 common/content_inode.h  |  20 ++--
 common/dlog.c           |   8 +-
 common/drive.h          |   2 +-
 common/drive_minrmt.c   |  28 +++---
 common/drive_scsitape.c |  38 ++++----
 common/drive_simple.c   |  14 +--
 common/fs.c             |   4 +-
 common/getdents.h       |   2 +-
 common/global.c         |   6 +-
 common/global.h         |   2 +-
 common/hsmapi.c         |   8 +-
 common/inventory.c      | 112 +++++++++++-----------
 common/inventory.h      |   6 +-
 common/main.c           |  14 +--
 common/mlog.c           |   8 +-
 common/path.c           |  12 +--
 common/path.h           |   4 +-
 common/stream.c         |  10 +-
 common/timeutil.c       |   4 +-
 common/ts_mtio.h        |   4 +-
 common/types.h          |   4 +-
 common/util.c           |   4 +-
 common/util.h           |  12 +--
 dump/content.c          |  56 +++++------
 dump/inomap.c           |  24 ++---
 dump/var.c              |   4 +-
 include/swab.h          |  24 ++---
 include/swap.h          |   2 +-
 inventory/inv_api.c     | 106 ++++++++++----------
 inventory/inv_core.c    |  34 +++----
 inventory/inv_fstab.c   |  48 +++++-----
 inventory/inv_idx.c     |  64 ++++++-------
 inventory/inv_mgr.c     |  72 +++++++-------
 inventory/inv_oref.c    |  22 ++---
 inventory/inv_oref.h    |  40 ++++----
 inventory/inv_priv.h    |  48 +++++-----
 inventory/inv_stobj.c   | 208 ++++++++++++++++++++--------------------
 inventory/inventory.h   |  12 +--
 inventory/testmain.c    |  86 ++++++++---------
 invutil/cmenu.h         |   2 +-
 invutil/fstab.c         |   8 +-
 invutil/invidx.c        |  30 +++---
 invutil/invutil.c       | 106 ++++++++++----------
 invutil/invutil.h       |  18 ++--
 invutil/menu.c          |   2 +-
 invutil/stobj.c         |  26 ++---
 librmt/isrmt.c          |   2 +-
 librmt/rmtaccess.c      |   6 +-
 librmt/rmtclose.c       |  12 +--
 librmt/rmtcommand.c     |   4 +-
 librmt/rmtcreat.c       |  10 +-
 librmt/rmtdev.c         |   6 +-
 librmt/rmtfstat.c       |  12 +--
 librmt/rmtioctl.c       |  38 ++++----
 librmt/rmtisatty.c      |   6 +-
 librmt/rmtlib.h         |   4 +-
 librmt/rmtlseek.c       |  12 +--
 librmt/rmtmsg.c         |   2 +-
 librmt/rmtopen.c        |  40 ++++----
 librmt/rmtread.c        |  14 +--
 librmt/rmtstatus.c      |  10 +-
 librmt/rmtwrite.c       |  14 +--
 restore/bag.h           |   2 +-
 restore/content.c       | 110 ++++++++++-----------
 restore/dirattr.c       |   4 +-
 restore/inomap.c        |   8 +-
 restore/mmap.c          |   6 +-
 restore/namreg.c        |   8 +-
 restore/node.c          |   4 +-
 restore/tree.c          |  40 ++++----
 72 files changed, 873 insertions(+), 873 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index d56363d..cfefa62 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -81,7 +81,7 @@ cldmgr_create(int (*	entry)(void *arg1),
 	cld_t *cldp;
 	int rval;
 
-	assert(pthread_equal(pthread_self(), cldmgr_parenttid) );
+	assert(pthread_equal(pthread_self(), cldmgr_parenttid));
 
 	cldp = cldmgr_getcld();
 	if (! cldp) {
diff --git a/common/cleanup.c b/common/cleanup.c
index 68f3cc6..c473705 100644
--- a/common/cleanup.c
+++ b/common/cleanup.c
@@ -139,7 +139,7 @@ cleanup_early(void)
 		if (cuptr->cu_flags & CU_EARLY) {
 			(*cuptr->cu_funcp)(cuptr->cu_arg1, cuptr->cu_arg2);
 			free((void *)cuptr);
-			if (cuprevp)  {
+			if (cuprevp) {
 				cuprevp->cu_nextp = cunextp;
 			} else {
 				cu_rootp = cunextp;
diff --git a/common/content_inode.h b/common/content_inode.h
index 0fbb9b0..7b94ba2 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -124,16 +124,16 @@ typedef struct content_inode_hdr content_inode_hdr_t;
 /*
  * dump attributes
  */
-#define CIH_DUMPATTR_SUBTREE                    (1 <<  0)
-#define CIH_DUMPATTR_INDEX                      (1 <<  1)
-#define CIH_DUMPATTR_INVENTORY                  (1 <<  2)
-#define CIH_DUMPATTR_INCREMENTAL                (1 <<  3)
-#define CIH_DUMPATTR_RETRY                      (1 <<  4)
-#define CIH_DUMPATTR_RESUME                     (1 <<  5)
-#define CIH_DUMPATTR_INOMAP                     (1 <<  6)
-#define CIH_DUMPATTR_DIRDUMP                    (1 <<  7)
-#define CIH_DUMPATTR_FILEHDR_CHECKSUM           (1 <<  8)
-#define CIH_DUMPATTR_EXTENTHDR_CHECKSUM         (1 <<  9)
+#define CIH_DUMPATTR_SUBTREE                    (1 << 0)
+#define CIH_DUMPATTR_INDEX                      (1 << 1)
+#define CIH_DUMPATTR_INVENTORY                  (1 << 2)
+#define CIH_DUMPATTR_INCREMENTAL                (1 << 3)
+#define CIH_DUMPATTR_RETRY                      (1 << 4)
+#define CIH_DUMPATTR_RESUME                     (1 << 5)
+#define CIH_DUMPATTR_INOMAP                     (1 << 6)
+#define CIH_DUMPATTR_DIRDUMP                    (1 << 7)
+#define CIH_DUMPATTR_FILEHDR_CHECKSUM           (1 << 8)
+#define CIH_DUMPATTR_EXTENTHDR_CHECKSUM         (1 << 9)
 #define CIH_DUMPATTR_DIRENTHDR_CHECKSUM         (1 << 10)
 #define CIH_DUMPATTR_DIRENTHDR_GEN              (1 << 11)
 #define CIH_DUMPATTR_EXTATTR                    (1 << 12)
diff --git a/common/dlog.c b/common/dlog.c
index c998321..0b71370 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -471,7 +471,7 @@ promptinput(char *	buf,
 		FD_SET(dlog_ttyfd, &rfds);
 
 		rc = select(dlog_ttyfd + 1, &rfds, NULL, NULL, &tv);
-		if (rc > 0 && FD_ISSET(dlog_ttyfd, &rfds) ) {
+		if (rc > 0 && FD_ISSET(dlog_ttyfd, &rfds)) {
 			nread = read(dlog_ttyfd, bufp, bufsz);
 			if (nread < 0) {
 				break; // error handled below
@@ -479,13 +479,13 @@ promptinput(char *	buf,
 				mlog(MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, "\n");
 				*bufp = 0;
 				break; // no input, return an empty string
-			} else if (nread > 0 && bufp[nread-1] == '\n') {
+			} else if (nread > 0 && bufp[nread - 1] == '\n') {
 				// received a full line, chomp the newline
-				bufp[nread-1] = 0;
+				bufp[nread - 1] = 0;
 				break;
 			} else if (nread == bufsz) {
 				// no more room, truncate and return
-				bufp[nread-1] = 0;
+				bufp[nread - 1] = 0;
 				break;
 			}
 
diff --git a/common/drive.h b/common/drive.h
index 2700187..ddcc230 100644
--- a/common/drive.h
+++ b/common/drive.h
@@ -626,7 +626,7 @@ struct drive_ops {
 	 * and performance info. set to NULL if
 	 * nothing to say.
 	 */
-	void	(*do_quit)(drive_t * drivep);
+	void	(*do_quit)(drive_t *drivep);
 	/*
 	 * tells the drive manager to de-allocate
 	 * resources, INCLUDING the slave process.
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 9a6c252..1423486 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -292,7 +292,7 @@ extern int rmtopen(char *, int, ...);
 extern int rmtclose(int);
 extern int rmtfstat(int, struct stat *);
 extern int rmtioctl(int, int, ...);
-extern int rmtread(int, void*, uint);
+extern int rmtread(int, void *, uint);
 extern int rmtwrite(int, const void *, uint);
 
 
@@ -319,7 +319,7 @@ static void do_get_mark(drive_t *, drive_mark_t *);
 static void do_end_read(drive_t *);
 static int do_begin_write(drive_t *);
 static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
-static char * do_get_write_buf(drive_t *, size_t, size_t *);
+static char *do_get_write_buf(drive_t *, size_t, size_t *);
 static int do_write(drive_t *, char *, size_t);
 static size_t do_get_align_cnt(drive_t *);
 static int do_end_write(drive_t *, off64_t *);
@@ -366,7 +366,7 @@ static int getrec(drive_t *drivep);
 static int
 write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
 	     bool_t xlatepr);
-static ring_msg_t * Ring_get(ring_t *ringp);
+static ring_msg_t *Ring_get(ring_t *ringp);
 static void Ring_reset(ring_t *ringp, ring_msg_t *msgp);
 static void Ring_put(ring_t *ringp, ring_msg_t *msgp);
 static int validate_media_file_hdr(drive_t *drivep);
@@ -1123,7 +1123,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 		off64_t nextrecoffset;
 		rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 
-		nextrecoffset = contextp->dc_reccnt  * (off64_t)tape_recsz
+		nextrecoffset = contextp->dc_reccnt * (off64_t)tape_recsz
 				+
 				(off64_t)rechdrp->rec_used;
 		if (wantedoffset >= nextrecoffset) {
@@ -1756,7 +1756,7 @@ do_begin_write(drive_t *drivep)
 	tpwhdrp->recsize = (int32_t)tape_recsz;
 	tpwhdrp->rec_used = 0;
 	tpwhdrp->file_offset = 0;
-	tpwhdrp->first_mark_offset= 0;
+	tpwhdrp->first_mark_offset = 0;
 	tpwhdrp->capability = drivep->d_capabilities;
 
 	/*
@@ -1827,7 +1827,7 @@ do_begin_write(drive_t *drivep)
 	/*
 	 * intialize header in new record
 	 */
-	rechdrp = (rec_hdr_t*)contextp->dc_recp;
+	rechdrp = (rec_hdr_t *)contextp->dc_recp;
 	rechdrp->magic = STAPE_MAGIC;
 	rechdrp->version = STAPE_VERSION;
 	rechdrp->file_offset = contextp->dc_reccnt * (off64_t)tape_recsz;
@@ -2120,7 +2120,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
  *	the number of bytes to next alignment
  */
 static size_t
-do_get_align_cnt(drive_t * drivep)
+do_get_align_cnt(drive_t *drivep)
 {
 	char *next_alignment_point;
 	intptr_t next_alignment_off;
@@ -2147,7 +2147,7 @@ do_get_align_cnt(drive_t * drivep)
 	 * and a multiple of PGSZ.
 	 */
 	next_alignment_off = (intptr_t)contextp->dc_nextp;
-	next_alignment_off +=  PGMASK;
+	next_alignment_off += PGMASK;
 	next_alignment_off &= ~PGMASK;
 	next_alignment_point = (char *)next_alignment_off;
 	assert(next_alignment_point <= contextp->dc_recendp);
@@ -2416,7 +2416,7 @@ do_fsf(drive_t *drivep, int count, int *statp)
 
 			op_failed = 0;
 			assert(contextp->dc_fd >= 0);
-			if (mt_op(contextp->dc_fd, MTFSF, 1) ) {
+			if (mt_op(contextp->dc_fd, MTFSF, 1)) {
 				op_failed = 1;
 			}
 
@@ -2425,7 +2425,7 @@ do_fsf(drive_t *drivep, int count, int *statp)
 			 * Check for a file mark to
 			 * determine if the fsf command worked.
 			 */
-			if  (! op_failed) {
+			if (! op_failed) {
 				done = 1;
 			}
 
@@ -3552,7 +3552,7 @@ checkhdr:
 					     _("may be an EFS dump at BOT\n"));
 				} else
 				/* Check if the tape was erased by us */
-				if  (isxfsdumperasetape(drivep)) {
+				if (isxfsdumperasetape(drivep)) {
 					mlog(MLOG_NORMAL | MLOG_DRIVE,
 					     _("This tape was erased earlier "
 					       "by xfsdump.\n"));
@@ -3772,7 +3772,7 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
 
 	xlate_rec_hdr(tmprh, rechdrp, 1);
 
-	if (rechdrp->magic != STAPE_MAGIC)  {
+	if (rechdrp->magic != STAPE_MAGIC) {
 		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		     _("record %lld corrupt: bad magic number\n"),
 		     contextp->dc_iocnt - 1);
@@ -4181,7 +4181,7 @@ erase_and_verify(drive_t *drivep)
 	 * detect if we have erased the tape.
 	 */
 
-	tempbufp = (char *) calloc(1, (size_t)tape_recsz);
+	tempbufp = (char *)calloc(1, (size_t)tape_recsz);
 	strcpy(tempbufp, ERASE_MAGIC);
 	Write(drivep, tempbufp, tape_recsz, &saved_errno);
 	free(tempbufp);
@@ -4245,7 +4245,7 @@ isefsdump(drive_t *drivep)
 static bool_t
 isxfsdumperasetape(drive_t *drivep)
 {
-	if (! strcmp((char *)drivep->d_greadhdrp, ERASE_MAGIC) )
+	if (! strcmp((char *)drivep->d_greadhdrp, ERASE_MAGIC))
 		return BOOL_TRUE;
 	else
 		return BOOL_FALSE;
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index e39e884..be1bb46 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -342,7 +342,7 @@ extern int rmtopen(char *, int, ...);
 extern int rmtclose(int);
 extern int rmtfstat(int, struct stat *);
 extern int rmtioctl(int, int, ...);
-extern int rmtread(int, void*, uint);
+extern int rmtread(int, void *, uint);
 extern int rmtwrite(int, const void *, uint);
 
 
@@ -369,7 +369,7 @@ static void do_get_mark(drive_t *, drive_mark_t *);
 static void do_end_read(drive_t *);
 static int do_begin_write(drive_t *);
 static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
-static char * do_get_write_buf(drive_t *, size_t, size_t *);
+static char *do_get_write_buf(drive_t *, size_t, size_t *);
 static int do_write(drive_t *, char *, size_t);
 static size_t do_get_align_cnt(drive_t *);
 static int do_end_write(drive_t *, off64_t *);
@@ -425,7 +425,7 @@ static int getrec(drive_t *drivep);
 static int
 write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
 	     bool_t xlatepr);
-static ring_msg_t * Ring_get(ring_t *ringp);
+static ring_msg_t *Ring_get(ring_t *ringp);
 static void Ring_reset(ring_t *ringp, ring_msg_t *msgp);
 static void Ring_put(ring_t *ringp, ring_msg_t *msgp);
 static int validate_media_file_hdr(drive_t *drivep);
@@ -448,7 +448,7 @@ static void map_ts_status(struct mtget *, struct mtget_sgi);
 static int dbgrmtopen(char *, int);
 static int dbgrmtclose(int);
 static int dbgrmtioctl(int, int, void *);
-static int dbgrmtread(int, void*, uint);
+static int dbgrmtread(int, void *, uint);
 static int dbgrmtwrite(int, void *, uint);
 #endif /* RMTDBG */
 
@@ -457,7 +457,7 @@ static int dbgrmtwrite(int, void *, uint);
 /*
  * tape driver
  */
-int TS_ISDRIVER=0;
+int TS_ISDRIVER = 0;
 
 /*
  * scsitape drive strategy. referenced by drive.c
@@ -1248,7 +1248,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 		off64_t nextrecoffset;
 		rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 
-		nextrecoffset = contextp->dc_reccnt  * (off64_t)tape_recsz
+		nextrecoffset = contextp->dc_reccnt * (off64_t)tape_recsz
 				+
 				(off64_t)rechdrp->rec_used;
 		if (wantedoffset >= nextrecoffset) {
@@ -1918,7 +1918,7 @@ do_begin_write(drive_t *drivep)
 	tpwhdrp->recsize = (int32_t)tape_recsz;
 	tpwhdrp->rec_used = 0;
 	tpwhdrp->file_offset = 0;
-	tpwhdrp->first_mark_offset= 0;
+	tpwhdrp->first_mark_offset = 0;
 	tpwhdrp->capability = drivep->d_capabilities;
 
 	/*
@@ -1989,7 +1989,7 @@ do_begin_write(drive_t *drivep)
 	/*
 	 * intialize header in new record
 	 */
-	rechdrp = (rec_hdr_t*)contextp->dc_recp;
+	rechdrp = (rec_hdr_t *)contextp->dc_recp;
 	rechdrp->magic = STAPE_MAGIC;
 	rechdrp->version = STAPE_VERSION;
 	rechdrp->file_offset = contextp->dc_reccnt * (off64_t)tape_recsz;
@@ -2282,7 +2282,7 @@ do_write(drive_t *drivep, char *bufp, size_t retcnt)
  *	the number of bytes to next alignment
  */
 static size_t
-do_get_align_cnt(drive_t * drivep)
+do_get_align_cnt(drive_t *drivep)
 {
 	char *next_alignment_point;
 	intptr_t next_alignment_off;
@@ -2309,7 +2309,7 @@ do_get_align_cnt(drive_t * drivep)
 	 * and a multiple of PGSZ.
 	 */
 	next_alignment_off = (intptr_t)contextp->dc_nextp;
-	next_alignment_off +=  PGMASK;
+	next_alignment_off += PGMASK;
 	next_alignment_off &= ~PGMASK;
 	next_alignment_point = (char *)next_alignment_off;
 	assert(next_alignment_point <= contextp->dc_recendp);
@@ -2594,11 +2594,11 @@ do_fsf(drive_t *drivep, int count, int *statp)
 			/*
 			 * check for end-of-data and end-of-tape conditions
 			 */
-			if (IS_EOT(mtstat) ) {
+			if (IS_EOT(mtstat)) {
 				*statp = DRIVE_ERROR_EOM;
 				return i;
 
-			} else if (IS_EOD(mtstat) ) {
+			} else if (IS_EOD(mtstat)) {
 				*statp = DRIVE_ERROR_EOD;
 				return i;
 			}
@@ -2613,7 +2613,7 @@ do_fsf(drive_t *drivep, int count, int *statp)
 
 			op_failed = 0;
 			assert(contextp->dc_fd >= 0);
-			if (mt_op(contextp->dc_fd, MTFSF, 1) ) {
+			if (mt_op(contextp->dc_fd, MTFSF, 1)) {
 				op_failed = 1;
 			}
 
@@ -2977,7 +2977,7 @@ do_quit(drive_t *drivep)
 	    &&
 	    contextp->dc_cansetblkszpr
 	    &&
-	    (contextp->dc_origcurblksz != 0) ) {
+	    (contextp->dc_origcurblksz != 0)) {
 		(void)set_fixed_blksz(drivep, contextp->dc_origcurblksz);
 	}
 
@@ -3196,7 +3196,7 @@ read_label(drive_t *drivep)
 #ifdef RESTORE
 
 	/* Linux case */
-	if (IS_EOD(mtstat) && IS_FMK(mtstat) ) {
+	if (IS_EOD(mtstat) && IS_FMK(mtstat)) {
 		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		     "hit EOM\n");
 		return DRIVE_ERROR_EOM;
@@ -3405,7 +3405,7 @@ set_fixed_blksz(drive_t *drivep, size_t blksz)
 		 */
 		if (mt_op(contextp->dc_fd,
 			  MTSETBLK,
-			  (int)blksz) ) {
+			  (int)blksz)) {
 			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			     "MTSETBLK %u failed: %s (%d)\n",
 			     blksz,
@@ -3842,7 +3842,7 @@ determine_write_error(drive_t *drivep, int nwritten, int saved_errno)
 
 		ret = DRIVE_ERROR_EOM;
 	} else if ((saved_errno == 0) &&
-		   (nwritten > 0)     &&
+		   (nwritten > 0) &&
 		   contextp->dc_isQICpr) {
 		/*
 		 * short write on one of this devices indicates
@@ -4070,7 +4070,7 @@ is_variable(drive_t *drivep, bool_t *varblk)
 	contextp = (drive_context_t *)drivep->d_contextp;
 
 	if (TS_ISDRIVER) {
-		char value[MT_ATTR_MAX_VALLEN+1];
+		char value[MT_ATTR_MAX_VALLEN + 1];
 		struct mt_attr mtattr;
 
 		value[0] = '\0';
@@ -5120,7 +5120,7 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
 
 	xlate_rec_hdr(tmprh, rechdrp, 1);
 
-	if (rechdrp->magic != STAPE_MAGIC)  {
+	if (rechdrp->magic != STAPE_MAGIC) {
 		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		     _("record %lld corrupt: bad magic number\n"),
 		     contextp->dc_iocnt - 1);
diff --git a/common/drive_simple.c b/common/drive_simple.c
index 1f75bb7..b415c43 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -57,10 +57,10 @@
 #define write   rmtwrite
 
 extern int rmtclose(int);
-extern int rmtcreat (char *path, int mode);
+extern int rmtcreat(char *path, int mode);
 extern int rmtioctl(int, int, ...);
 extern int rmtopen(char *, int, ...);
-extern int rmtread(int, void*, uint);
+extern int rmtread(int, void *, uint);
 extern int rmtwrite(int, const void *, uint);
 
 
@@ -131,7 +131,7 @@ static void do_get_mark(drive_t *, drive_mark_t *);
 static void do_end_read(drive_t *);
 static int do_begin_write(drive_t *);
 static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
-static char * do_get_write_buf(drive_t *, size_t, size_t *);
+static char *do_get_write_buf(drive_t *, size_t, size_t *);
 static int do_write(drive_t *, char *, size_t);
 static size_t do_get_align_cnt(drive_t *);
 static int do_end_write(drive_t *, off64_t *);
@@ -517,7 +517,7 @@ do_begin_read(drive_t *drivep)
 			return DRIVE_ERROR_FORMAT;
 		}
 	}
-	if  (rval) {
+	if (rval) {
 		free(tmphdr);
 		return rval;
 	}
@@ -846,7 +846,7 @@ do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 				 (rfp_t)drivep->d_opsp->do_read,
 				 (rrbfp_t)drivep->d_opsp->do_return_read_buf,
 				 &rval);
-		if  (rval) {
+		if (rval) {
 			return rval;
 		}
 		nreadneeded64 -= nread;
@@ -1295,7 +1295,7 @@ do_get_write_buf(drive_t *drivep, size_t wanted_bufsz, size_t *actual_bufszp)
 	/*
 	 * calculate how much buffer remains
 	 */
-	remaining_bufsz =(size_t)(contextp->dc_emptyp - contextp->dc_nextp);
+	remaining_bufsz = (size_t)(contextp->dc_emptyp - contextp->dc_nextp);
 
 	/*
 	 *  give the caller the lesser of what he wants and what is available
@@ -1432,7 +1432,7 @@ do_get_align_cnt(drive_t *drivep)
 	 * a multiple of PGSZ.
 	 */
 	next_alignment_off = (intptr_t)contextp->dc_nextp;
-	next_alignment_off +=  PGMASK;
+	next_alignment_off += PGMASK;
 	next_alignment_off &= ~PGMASK;
 	next_alignment_point = (char *)next_alignment_off;
 	assert(next_alignment_point <= contextp->dc_emptyp);
diff --git a/common/fs.c b/common/fs.c
index 6ed86d9..7b816be 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -217,7 +217,7 @@ fs_getid(char *mnts, uuid_t *idb)
 		uuid_clear(*idb);
 		return -1;
 	}
-	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geo) ) {
+	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geo)) {
 		uuid_clear(*idb);
 		close(fd);
 		return -1;
@@ -279,7 +279,7 @@ fs_tab_free(void)
 	     ;
 	     tep
 	     ;
-	     otep = tep, tep = tep->fte_nextp, fs_tab_ent_free(otep) )
+	     otep = tep, tep = tep->fte_nextp, fs_tab_ent_free(otep))
 
 		;
 }
diff --git a/common/getdents.h b/common/getdents.h
index 3640d25..687334c 100644
--- a/common/getdents.h
+++ b/common/getdents.h
@@ -18,6 +18,6 @@
 #ifndef GETDENTS_H
 #define GETDENTS_H
 
-int getdents_wrap (int fd, char *buf, size_t nbytes);
+int getdents_wrap(int fd, char *buf, size_t nbytes);
 
 #endif /* GETDENTS_H */
diff --git a/common/global.c b/common/global.c
index ba424d8..bf08961 100644
--- a/common/global.c
+++ b/common/global.c
@@ -46,7 +46,7 @@ extern bool_t pipeline;
 /* forward declarations of locally defined static functions ******************/
 
 #ifdef DUMP
-static char * prompt_label(char *bufp, size_t bufsz);
+static char *prompt_label(char *bufp, size_t bufsz);
 #endif /* DUMP */
 
 /* definition of locally defined global variables ****************************/
@@ -97,7 +97,7 @@ global_hdr_alloc(int argc, char *argv[])
 	 * will be included in increments on this base. This may be
 	 * overridden with the GETOPT_DUMPTIME option.
 	 */
-	ghdrp->gh_timestamp = (time32_t) time(0);
+	ghdrp->gh_timestamp = (time32_t)time(0);
 
 	/*
 	 * fill in the host id: typecast to fit into a 64 bit field
@@ -172,7 +172,7 @@ global_hdr_alloc(int argc, char *argv[])
 				return 0;
 			}
 
-			if (! uuid_parse(optarg, ghdrp->gh_dumpid) ) {
+			if (! uuid_parse(optarg, ghdrp->gh_dumpid)) {
 				mlog(MLOG_NORMAL | MLOG_ERROR,
 				     _("-%c argument not a valid uuid\n"),
 				     c);
diff --git a/common/global.h b/common/global.h
index 36ec456..8a111cd 100644
--- a/common/global.h
+++ b/common/global.h
@@ -76,7 +76,7 @@ typedef struct global_hdr global_hdr_t;
  * used by main() to allocate and populate a global header template.
  * drive managers will copy this into the write header.
  */
-extern global_hdr_t * global_hdr_alloc(int argc, char *argv[]);
+extern global_hdr_t *global_hdr_alloc(int argc, char *argv[]);
 
 
 /*
diff --git a/common/hsmapi.c b/common/hsmapi.c
index cf25702..4ffc1fd 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -116,10 +116,10 @@ typedef struct {
  * Interesting bit combinations within the bs_dmevmask field of xfs_bstat_t:
  * OFL, UNM, and PAR files have exactly these bits set.
  * DUL and MIG files have all but the DM_EVENT_READ bit set */
-#define DMF_EV_BITS     ((1<<DM_EVENT_DESTROY) | \
-			 (1<<DM_EVENT_READ)    | \
-			 (1<<DM_EVENT_WRITE)   | \
-			 (1<<DM_EVENT_TRUNCATE))
+#define DMF_EV_BITS     ((1 << DM_EVENT_DESTROY) | \
+			 (1 << DM_EVENT_READ) | \
+			 (1 << DM_EVENT_WRITE) | \
+			 (1 << DM_EVENT_TRUNCATE))
 
 /* OFL file's managed region event flags */
 #define DMF_MR_FLAGS    (0x1 | 0x2 | 0x4)
diff --git a/common/inventory.c b/common/inventory.c
index 0e2ffba..07e5e5a 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -53,8 +53,8 @@ inv_open(inv_predicate_t bywhat, void *pred)
 
 	int index = 0;
 
-	assert (pred);
-	if ((fd = init_idb (pred, bywhat, uuname, &tok)) < 0)
+	assert(pred);
+	if ((fd = init_idb(pred, bywhat, uuname, &tok)) < 0)
 		return tok;
 
 	/*
@@ -69,7 +69,7 @@ inv_open(inv_predicate_t bywhat, void *pred)
 		return INV_TOKEN_NULL;
 	}
 
-	assert (index > 0);
+	assert(index > 0);
 
 	/* Now we need to make sure that this has enough space */
 	num = GET_SESCOUNTERS(stobjfd, &sescnt);
@@ -83,14 +83,14 @@ inv_open(inv_predicate_t bywhat, void *pred)
 	/*
 	 * create another storage object (and, an inv_index entry for it too)
 	   if we've filled this one up */
-	if ((uint) num >= sescnt->ic_maxnum) {
+	if ((uint)num >= sescnt->ic_maxnum) {
 #ifdef INVT_DEBUG
 		printf("$ creating a new storage obj & index entry. \n");
 #endif
-		close (stobjfd);
+		close(stobjfd);
 
 		stobjfd = create_invindex_entry(&tok, fd, uuname, BOOL_FALSE);
-		free (sescnt);
+		free(sescnt);
 		if (stobjfd < 0) {
 			close(fd);
 			close(sesslock_fd);
@@ -100,7 +100,7 @@ inv_open(inv_predicate_t bywhat, void *pred)
 		return tok;
 	}
 
-	free (sescnt);
+	free(sescnt);
 	tok = get_token(fd, stobjfd);
 	tok->d_invindex_off = INVINDEX_HDR_OFFSET(index - 1);
 
@@ -121,8 +121,8 @@ inv_open(inv_predicate_t bywhat, void *pred)
 bool_t
 inv_close(inv_idbtoken_t tok)
 {
-	close (tok->d_invindex_fd);
-	close (tok->d_stobj_fd);
+	close(tok->d_invindex_fd);
+	close(tok->d_stobj_fd);
 	destroy_token(tok);
 	close(sesslock_fd);
 	sesslock_fd = -1;
@@ -149,10 +149,10 @@ inv_lasttime_level_lessthan(
 	time32_t **	tm)
 {
 	int rval;
-	assert (tok != INV_TOKEN_NULL);
+	assert(tok != INV_TOKEN_NULL);
 
-	rval =  search_invt(tok, level, (void **) tm,
-			    (search_callback_t) tm_level_lessthan);
+	rval = search_invt(tok, level, (void **)tm,
+			   (search_callback_t)tm_level_lessthan);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 }
@@ -174,10 +174,10 @@ inv_lastsession_level_lessthan(
 	inv_session_t **ses)
 {
 	int rval;
-	assert (tok != INV_TOKEN_NULL);
+	assert(tok != INV_TOKEN_NULL);
 
-	rval = search_invt(tok, level, (void **) ses,
-			   (search_callback_t) lastsess_level_lessthan);
+	rval = search_invt(tok, level, (void **)ses,
+			   (search_callback_t)lastsess_level_lessthan);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 
@@ -201,9 +201,9 @@ inv_lastsession_level_equalto(
 	inv_session_t **ses)
 {
 	int rval;
-	assert (tok != INV_TOKEN_NULL);
-	rval = search_invt(tok, level, (void **) ses,
-			   (search_callback_t) lastsess_level_equalto);
+	assert(tok != INV_TOKEN_NULL);
+	rval = search_invt(tok, level, (void **)ses,
+			   (search_callback_t)lastsess_level_equalto);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 
@@ -240,12 +240,12 @@ inv_writesession_open(
 	invt_seshdr_t hdr;
 	inv_sestoken_t sestok;
 
-	assert (tok != INV_TOKEN_NULL);
-	assert (sesid && fsid && mntpt && devpath);
+	assert(tok != INV_TOKEN_NULL);
+	assert(sesid && fsid && mntpt && devpath);
 
-	if (!(tok->d_update_flag & FSTAB_UPDATED) ) {
+	if (!(tok->d_update_flag & FSTAB_UPDATED)) {
 		if (put_fstab_entry(fsid, mntpt, devpath) < 0) {
-			printf ("put_fstab_entry :(\n");
+			printf("put_fstab_entry :(\n");
 			return INV_TOKEN_NULL;
 		}
 		tok->d_update_flag |= FSTAB_UPDATED;
@@ -253,11 +253,11 @@ inv_writesession_open(
 
 
 
-	ses = (invt_session_t *) calloc(1, sizeof(invt_session_t) );
+	ses = (invt_session_t *)calloc(1, sizeof(invt_session_t));
 
 	/* copy the session information to store */
-	memcpy(&ses->s_sesid, sesid, sizeof(uuid_t) );
-	memcpy(&ses->s_fsid, fsid, sizeof(uuid_t) );
+	memcpy(&ses->s_sesid, sesid, sizeof(uuid_t));
+	memcpy(&ses->s_fsid, fsid, sizeof(uuid_t));
 	strcpy(ses->s_label, label);
 	strcpy(ses->s_mountpt, mntpt);
 	strcpy(ses->s_devpath, devpath);
@@ -268,7 +268,7 @@ inv_writesession_open(
 
 	fd = tok->d_stobj_fd;
 
-	assert (fd > 0);
+	assert(fd > 0);
 
 	hdr.sh_time = time;
 	hdr.sh_level = level;
@@ -282,8 +282,8 @@ inv_writesession_open(
 
 	INVLOCK(fd, LOCK_EX);
 	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
-		free (ses);
-		free (sestok);
+		free(ses);
+		free(sestok);
 		INVLOCK(fd, LOCK_UN);
 		return INV_TOKEN_NULL;
 	}
@@ -292,7 +292,7 @@ inv_writesession_open(
 	 * create the writesession, and get ready for the streams to come
 	   afterwards */
 	rval = create_session(sestok, fd, sescnt, ses, &hdr);
-	assert (rval > 0);
+	assert(rval > 0);
 
 
 	INVLOCK(fd, LOCK_UN);
@@ -301,14 +301,14 @@ inv_writesession_open(
 
 	if (tok->d_update_flag & NEW_INVINDEX) {
 		if (put_sesstime(sestok, INVT_STARTTIME) < 0) {
-			printf ("put_starttime :(\n");
+			printf("put_starttime :(\n");
 			return INV_TOKEN_NULL;
 		}
 		tok->d_update_flag &= ~(NEW_INVINDEX);
 	}
 
-	free (ses);
-	free (sescnt);
+	free(ses);
+	free(sescnt);
 
 
 	return (rval < 0) ? INV_TOKEN_NULL : sestok;
@@ -330,14 +330,14 @@ inv_writesession_close(inv_sestoken_t tok)
 {
 	int rval;
 
-	assert (tok != INV_TOKEN_NULL);
+	assert(tok != INV_TOKEN_NULL);
 
 	/* now update end_time in the inv index header */
 	rval = put_sesstime(tok, INVT_ENDTIME);
 
-	memset(tok, 0, sizeof(invt_sesdesc_entry_t) );
+	memset(tok, 0, sizeof(invt_sesdesc_entry_t));
 
-	free (tok);
+	free(tok);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 
@@ -360,14 +360,14 @@ inv_stream_open(
 	invt_seshdr_t seshdr;
 	int fd;
 
-	assert (tok != INV_TOKEN_NULL);
+	assert(tok != INV_TOKEN_NULL);
 
 	stream.st_nmediafiles = 0;
 	stream.st_interrupted = BOOL_FALSE;
 
 
 	/* XXX yukk... make the token descriptors not pointers */
-	stok = (inv_stmtoken_t) malloc(sizeof(invt_strdesc_entry_t) );
+	stok = (inv_stmtoken_t)malloc(sizeof(invt_strdesc_entry_t));
 
 	stok->md_sesstok = tok;
 	stok->md_lastmfile = 0;
@@ -381,7 +381,7 @@ inv_stream_open(
 	/* get the session header first */
 	if (GET_REC_NOLOCK(fd, &seshdr, sizeof(invt_seshdr_t),
 			   tok->sd_sesshdr_off) <= 0) {
-		free (stok);
+		free(stok);
 		INVLOCK(fd, LOCK_UN);
 		sess_unlock();
 		return INV_TOKEN_NULL;
@@ -392,7 +392,7 @@ inv_stream_open(
 	/* XXX Have one func that gives both seshdr and session */
 	if (GET_REC_NOLOCK(fd, &ses, sizeof(invt_session_t),
 			   tok->sd_session_off) <= 0) {
-		free (stok);
+		free(stok);
 		INVLOCK(fd, LOCK_UN);
 		sess_unlock();
 		return INV_TOKEN_NULL;
@@ -401,22 +401,22 @@ inv_stream_open(
 
 	if (ses.s_cur_nstreams < ses.s_max_nstreams) {
 		/* this is where this stream header will be written to */
-		stok->md_stream_off = (off64_t) (sizeof(invt_stream_t) *
-						 ses.s_cur_nstreams)
+		stok->md_stream_off = (off64_t)(sizeof(invt_stream_t) *
+						ses.s_cur_nstreams)
 				      + seshdr.sh_streams_off;
 		ses.s_cur_nstreams++;
 
 		/* write it back. this locks and unlocks fd EXclusively */
 		if (PUT_REC(fd, &ses, sizeof(ses),
 			    tok->sd_session_off) < 0) {
-			free (stok);
+			free(stok);
 			sess_unlock();
 			return INV_TOKEN_NULL;
 		}
 	} else {
 		fprintf(stderr, "Cant create more than %d streams. Max'd out..\n",
 			ses.s_cur_nstreams);
-		free (stok);
+		free(stok);
 		sess_unlock();
 		return INV_TOKEN_NULL;
 	}
@@ -427,7 +427,7 @@ inv_stream_open(
 	/* now put the stream header on to the disk */
 	if (PUT_REC(fd, &stream, sizeof(invt_stream_t),
 		    stok->md_stream_off) < 0) {
-		free (stok);
+		free(stok);
 		return INV_TOKEN_NULL;
 	}
 
@@ -482,9 +482,9 @@ inv_stream_close(
 end:
 	INVLOCK(fd, LOCK_UN);
 
-	free (tok->md_lastmfile);
-	memset(tok, 0, sizeof(invt_strdesc_entry_t) );
-	free (tok);
+	free(tok->md_lastmfile);
+	memset(tok, 0, sizeof(invt_strdesc_entry_t));
+	free(tok);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 }
@@ -512,14 +512,14 @@ inv_put_mediafile(
 	int rval;
 
 
-	assert (tok != INV_TOKEN_NULL);
-	assert (tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED);
-	assert (tok->md_sesstok->sd_invtok->d_stobj_fd >= 0);
+	assert(tok != INV_TOKEN_NULL);
+	assert(tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED);
+	assert(tok->md_sesstok->sd_invtok->d_stobj_fd >= 0);
 
-	mf = (invt_mediafile_t *) calloc(1, sizeof(invt_mediafile_t) );
+	mf = (invt_mediafile_t *)calloc(1, sizeof(invt_mediafile_t));
 
 	/* copy the media file information */
-	memcpy(&mf->mf_moid, moid, sizeof(uuid_t) );
+	memcpy(&mf->mf_moid, moid, sizeof(uuid_t));
 	strcpy(mf->mf_label, label);
 	mf->mf_startino.ino = startino;
 	mf->mf_startino.offset = startino_offset;
@@ -566,7 +566,7 @@ inv_get_inolist(
 
 #ifdef NOTDEF
 	*inolist = NULL;
-	curitem = malloc(sizeof(inv_inolist_t) );
+	curitem = malloc(sizeof(inv_inolist_t));
 
 	/* get the array of all indices in the invindex */
 	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
@@ -588,7 +588,7 @@ inv_get_inolist(
 		create_inolist_item(curitem, statbuf.st_ino);
 	}
 	/* The inventory index */
-	if (fstat64(invfd, &statbuf) ) {
+	if (fstat64(invfd, &statbuf)) {
 		perror("InvIndex file");
 		return -1;
 	}
@@ -655,8 +655,8 @@ inv_DEBUG_printallsessions(
 	inv_session_t **ses)
 {
 	int rval;
-	rval = search_invt(tok, 0, (void **) ses,
-			   (search_callback_t) DEBUG_displayallsessions);
+	rval = search_invt(tok, 0, (void **)ses,
+			   (search_callback_t)DEBUG_displayallsessions);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 
diff --git a/common/inventory.h b/common/inventory.h
index 7660e07..7f81643 100644
--- a/common/inventory.h
+++ b/common/inventory.h
@@ -133,9 +133,9 @@ struct invt_sesdesc_entry;
 struct invt_strdesc_entry;
 
 /* The three kinds of access tokens for the inventory */
-typedef struct invt_desc_entry          *inv_idbtoken_t;
-typedef struct invt_sesdesc_entry       *inv_sestoken_t;
-typedef struct invt_strdesc_entry       *inv_stmtoken_t;
+typedef struct invt_desc_entry *inv_idbtoken_t;
+typedef struct invt_sesdesc_entry *inv_sestoken_t;
+typedef struct invt_strdesc_entry *inv_stmtoken_t;
 
 
 
diff --git a/common/main.c b/common/main.c
index c364fc9..49dcd90 100644
--- a/common/main.c
+++ b/common/main.c
@@ -93,7 +93,7 @@ bool_t preemptchk(int);
 /* forward declarations of locally defined static functions ******************/
 
 static bool_t loadoptfile(int *argcp, char ***argvp);
-static char * stripquotes(char *p);
+static char *stripquotes(char *p);
 static void shiftleftby1(char *p, char *endp);
 static void sighandler(int);
 static int childmain(void *);
@@ -1081,7 +1081,7 @@ usage(void)
 	 * catch all of those cases below
 	 */
 
-	(void) mlog_exit(EXIT_ERROR, RV_OPT);
+	(void)mlog_exit(EXIT_ERROR, RV_OPT);
 }
 
 /*
@@ -1210,7 +1210,7 @@ loadoptfile(int *argcp, char ***argvp)
 	 */
 	optind = 1;
 	opterr = 0;
-	optfilename =  0;
+	optfilename = 0;
 	while ((c = getopt(*argcp, *argvp, GETOPT_CMDSTRING)) != EOF) {
 		switch (c) {
 		case GETOPT_OPTFILE:
@@ -1234,7 +1234,7 @@ loadoptfile(int *argcp, char ***argvp)
 			break;
 		}
 	}
-	if (! optfilename)  {
+	if (! optfilename) {
 		return BOOL_TRUE;
 	}
 
@@ -1243,7 +1243,7 @@ loadoptfile(int *argcp, char ***argvp)
 	 */
 	errno = 0;
 	fd = open(optfilename, O_RDONLY);
-	if (fd  < 0) {
+	if (fd < 0) {
 		mlog(MLOG_ERROR | MLOG_NOLOCK,
 		     _("cannot open option file %s: %s (%d)\n"),
 		     optfilename,
@@ -1282,7 +1282,7 @@ loadoptfile(int *argcp, char ***argvp)
 	 * skip the GETOPT_OPTFILE option which put us here!
 	 */
 	sz = 0;
-	for (i =  0; i < *argcp; i++) {
+	for (i = 0; i < *argcp; i++) {
 		if (i == (int)optfileix) {
 			i++; /* to skip option argument */
 			continue;
@@ -1484,7 +1484,7 @@ sighandler(int signo)
 	/*
 	 * dialog gets first crack at the signal
 	 */
-	if (dlog_sighandler(signo) )
+	if (dlog_sighandler(signo))
 		return;
 
 	/*
diff --git a/common/mlog.c b/common/mlog.c
index 290d076..11a923b 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -303,7 +303,7 @@ mlog_init1(int argc, char *argv[])
 	 * mlog_fd set to stderr, see if we can switch
 	 * to stdout.
 	 */
-	if (optind >= argc ||  strcmp(argv[optind], "-")) {
+	if (optind >= argc || strcmp(argv[optind], "-")) {
 		mlog_fp = stdout;
 	}
 #endif /* DUMP */
@@ -605,7 +605,7 @@ _mlog_exit(const char *file, int line, int exit_code, rv_t rv)
 	 * most accurate information about the termination condition.
 	 */
 
-	if (pthread_equal(tid, parenttid) ) {
+	if (pthread_equal(tid, parenttid)) {
 		if (mlog_main_exit_code == -1) {
 			mlog_main_exit_code = exit_code;
 			mlog_main_exit_return = rv;
@@ -665,7 +665,7 @@ _mlog_exit_hint(const char *file, int line, rv_t rv)
 	 * information about the termination condition.
 	 */
 
-	if (pthread_equal(tid, parenttid) )
+	if (pthread_equal(tid, parenttid))
 		mlog_main_exit_hint = rv;
 	else
 		stream_set_hint(tid, rv);
@@ -680,7 +680,7 @@ mlog_get_hint(void)
 	bool_t ok;
 	rv_t hint;
 
-	if (pthread_equal(pthread_self(), parenttid) )
+	if (pthread_equal(pthread_self(), parenttid))
 		return mlog_main_exit_hint;
 
 	ok = stream_get_exit_status(pthread_self(), states, N(states),
diff --git a/common/path.c b/common/path.c
index 7467d4f..5196e9d 100644
--- a/common/path.c
+++ b/common/path.c
@@ -33,9 +33,9 @@ struct pem {
 
 typedef struct pem pem_t;
 
-static pem_t * pem_alloc(char *path);
+static pem_t *pem_alloc(char *path);
 static void pem_free(pem_t *pemp);
-static char * pem_next(pem_t *pemp);
+static char *pem_next(pem_t *pemp);
 
 #define PAMAX   1024
 
@@ -46,11 +46,11 @@ struct pa {
 
 typedef struct pa pa_t;
 
-static pa_t * pa_alloc(void);
+static pa_t *pa_alloc(void);
 static void pa_free(pa_t *pap);
 static void pa_append(pa_t *pap, char *pep);
 static int pa_peel(pa_t *pap);
-static char * pa_gen(pa_t *pap);
+static char *pa_gen(pa_t *pap);
 
 char *
 path_diff(char *path, char *base)
@@ -100,7 +100,7 @@ path_reltoabs(char *dir, char *basedir)
 	 * check if the path starts with a / or
 	 * is a remote path (i.e. contains  machine:/path/name).
 	 */
-	if ((*dir != '/') && (strchr(dir, ':') == 0) ) {
+	if ((*dir != '/') && (strchr(dir, ':') == 0)) {
 		char *absdir;
 		absdir = (char *)malloc(strlen(basedir)
 					+
@@ -119,7 +119,7 @@ path_reltoabs(char *dir, char *basedir)
 	if (strchr(dir, ':') == 0) {
 		absdir = path_normalize(dir);
 	} else {
-		absdir = (char *)malloc(strlen(dir)  + 1);
+		absdir = (char *)malloc(strlen(dir) + 1);
 		(void)sprintf(absdir, "%s", dir);
 	}
 
diff --git a/common/path.h b/common/path.h
index b81b92b..58d0c53 100644
--- a/common/path.h
+++ b/common/path.h
@@ -21,9 +21,9 @@
 /*
  * various pathname helpers
  */
-extern char * path_reltoabs(char *dir, char *basedir);
+extern char *path_reltoabs(char *dir, char *basedir);
 extern char *path_normalize(char *path);
-extern char * path_diff(char *path, char *base);
+extern char *path_diff(char *path, char *base);
 extern int path_beginswith(char *path, char *base);
 
 #endif /* PATH_H */
diff --git a/common/stream.c b/common/stream.c
index 1965a7e..e091359 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -94,7 +94,7 @@ stream_dead(pthread_t tid)
 	spm_t *ep = spm + N(spm);
 
 	for (; p < ep; p++)
-		if (pthread_equal(p->s_tid, tid) ) {
+		if (pthread_equal(p->s_tid, tid)) {
 			p->s_state = S_ZOMBIE;
 			break;
 		}
@@ -109,8 +109,8 @@ stream_free(pthread_t tid)
 
 	lock();
 	for (; p < ep; p++) {
-		if (pthread_equal(p->s_tid, tid) ) {
-			(void) memset((void *) p, 0, sizeof(spm_t));
+		if (pthread_equal(p->s_tid, tid)) {
+			(void)memset((void *)p, 0, sizeof(spm_t));
 			p->s_state = S_FREE;
 			break;
 		}
@@ -154,7 +154,7 @@ stream_find(pthread_t tid, stream_state_t s[], int nstates)
 
 	/* note we don't lock the stream array in this function */
 	for (; p < ep; p++)
-		if (pthread_equal(p->s_tid, tid) ) {
+		if (pthread_equal(p->s_tid, tid)) {
 			/* check state */
 			for (i = 0; i < nstates; i++)
 				if (p->s_state == s[i])
@@ -174,7 +174,7 @@ stream_find(pthread_t tid, stream_state_t s[], int nstates)
 	}
 #endif /* STREAM_DEBUG */
 
-	return (spm_t *) NULL;
+	return (spm_t *)NULL;
 }
 
 /*
diff --git a/common/timeutil.c b/common/timeutil.c
index a25b0c4..b327c2f 100644
--- a/common/timeutil.c
+++ b/common/timeutil.c
@@ -26,14 +26,14 @@
 char *
 ctime32(const time32_t *timep)
 {
-	time_t t = (time_t) *timep;
+	time_t t = (time_t)*timep;
 	return ctime(&t);
 }
 
 char *
 ctime32_r(const time32_t *timep, char *buf)
 {
-	time_t t = (time_t) *timep;
+	time_t t = (time_t)*timep;
 	return ctime_r(&t, buf);
 }
 
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index b044c6f..3e0432d 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -238,7 +238,7 @@ typedef struct  mtacct {
 #define MT_MAX_VID      6       /* Max characters in volume id sans null    */
 
 struct  mtvid {
-	char vid[MT_MAX_VID+1];
+	char vid[MT_MAX_VID + 1];
 };
 
 /*	structure for MTIOCGETBLKINFO - all quantities in bytes.
@@ -438,7 +438,7 @@ struct mt_capablity {
  *
  */
 #define MTPDTRACE       6000                    /* From pd_ioctl.h */
-#define MTIOCODE(x)     ('t'<<8|(x))
+#define MTIOCODE(x)     ('t' << 8 | (x))
 
 #ifndef _SYS_MTIO_H
 #define MTIOCTOP        MTIOCODE('a')           /* perform tape op */
diff --git a/common/types.h b/common/types.h
index 1d5c2f5..5ebee5c 100644
--- a/common/types.h
+++ b/common/types.h
@@ -28,7 +28,7 @@
  * have nothing to do with file handle operations.
  */
 #define sizeofmember(t, m)      sizeof(((t *)0)->m)
-#define offsetofmember(t, m)    ((size_t)(char *)&(((t *)0)->m) )
+#define offsetofmember(t, m)    ((size_t)(char *)&(((t *)0)->m))
 
 #define XFSDUMP_DIRPATH inv_basepath()
 
@@ -60,7 +60,7 @@ typedef int32_t time32_t;
 
 typedef uint64_t xfs_ino_t;
 
-#define constpp        char * const *
+#define constpp        char *const *
 
 /*
  * limits
diff --git a/common/util.c b/common/util.c
index c6d768e..55c1d48 100644
--- a/common/util.c
+++ b/common/util.c
@@ -124,7 +124,7 @@ bigstat_iter(jdm_fshandle_t *	fshandlep,
 	     bstat_seekfp_t	seekfp,
 	     void *		seek_arg1,
 	     int *		statp,
-	     bool_t (pfp)(int),
+	     bool_t(pfp)(int),
 	     xfs_bstat_t *	buf,
 	     size_t		buflenin)
 {
@@ -363,7 +363,7 @@ diriter(jdm_fshandle_t *					fshandlep,
 	int cbrval;
 
 	if (usrgdp) {
-		assert(usrgdsz >= sizeof(struct dirent) );
+		assert(usrgdsz >= sizeof(struct dirent));
 		gdsz = usrgdsz;
 		gdp = (struct dirent *)usrgdp;
 	} else {
diff --git a/common/util.h b/common/util.h
index e67c56a..e4e6b32 100644
--- a/common/util.h
+++ b/common/util.h
@@ -97,16 +97,16 @@ typedef int (*bstat_cbfp_t)(void *		arg1,
 typedef xfs_ino_t (*bstat_seekfp_t)(void *	arg1,
 				    xfs_ino_t	lastino);
 
-extern int bigstat_iter(jdm_fshandle_t *fshandlep,
+extern int bigstat_iter(jdm_fshandle_t * fshandlep,
 			int fsfd,
 			int selector,
 			xfs_ino_t start_ino,
 			bstat_cbfp_t fp,
-			void * cb_arg1,
+			void *cb_arg1,
 			bstat_seekfp_t seekfp,
-			void * seek_arg1,
+			void *seek_arg1,
 			int *statp,
-			bool_t (pfp)(int),       /* preemption chk func */
+			bool_t(pfp)(int),        /* preemption chk func */
 			xfs_bstat_t *buf,
 			size_t buflen);
 
@@ -159,8 +159,8 @@ extern int diriter(jdm_fshandle_t *					fshandlep,
  * Align pointer up to alignment
  */
 #define ALIGN_PTR(p, a) \
-	(((intptr_t)(p) & ((a)-1)) ? \
-	 ((void *)(((intptr_t)(p) + ((a)-1)) & ~((a)-1))) : \
+	(((intptr_t)(p) & ((a) - 1)) ? \
+	 ((void *)(((intptr_t)(p) + ((a) - 1)) & ~((a) - 1))) : \
 	 ((void *)(p)))
 
 #endif /* UTIL_H */
diff --git a/dump/content.c b/dump/content.c
index 62a4f13..236c06c 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -252,7 +252,7 @@ typedef struct extent_group_context extent_group_context_t;
  */
 #define EXTATTR_NAMESPACE(flag) (((flag) & ATTR_ROOT) ? _("root") : \
 				 (((flag) & ATTR_SECURE) ? _("secure") : \
-				  _("non-root")) )
+				  _("non-root")))
 
 /*
  * for printing file type
@@ -665,7 +665,7 @@ content_init(int		argc,
 	dwhdrtemplatep = (drive_hdr_t *)gwhdrtemplatep->gh_upper;
 	mwhdrtemplatep = (media_hdr_t *)dwhdrtemplatep->dh_upper;
 	cwhdrtemplatep = (content_hdr_t *)mwhdrtemplatep->mh_upper;
-	scwhdrtemplatep = (content_inode_hdr_t *) cwhdrtemplatep->ch_specific;
+	scwhdrtemplatep = (content_inode_hdr_t *)cwhdrtemplatep->ch_specific;
 
 	if (gwhdrtemplatep->gh_version < GLOBAL_HDR_VERSION_3) {
 		sc_use_old_direntpr = BOOL_TRUE;
@@ -728,7 +728,7 @@ content_init(int		argc,
 			maxdumpfilesize = strtoull(optarg, NULL, 0);
 			if (maxdumpfilesize == 0 ||
 			    maxdumpfilesize > ULONGLONG_MAX / 1024 ||
-			    (maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE) ) {
+			    (maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE)) {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					     "-%c argument is not a valid file size\n"),
 				     c);
@@ -910,8 +910,8 @@ content_init(int		argc,
 				if (save_quotas(mntpnt, &quotas[i])) {
 					if (subtreecnt) {
 						subtreecnt++;
-						subtreep = (char **) realloc(subtreep,
-									     subtreecnt * sizeof(char *));
+						subtreep = (char **)realloc(subtreep,
+									    subtreecnt * sizeof(char *));
 						assert(subtreep);
 						subtreep[subtreecnt - 1] = quotas[i].quotafile;
 					}
@@ -979,7 +979,7 @@ content_init(int		argc,
 			     baseuuidstr);
 			return BOOL_FALSE;
 		}
-		strcnt =  (ix_t)sessp->s_nstreams;
+		strcnt = (ix_t)sessp->s_nstreams;
 		for (strix = 0; strix < strcnt; strix++) {
 			bsp = &sessp->s_streams[strix];
 			if (bsp->st_interrupted) {
@@ -993,10 +993,10 @@ content_init(int		argc,
 			resumereqpr = BOOL_TRUE;
 			samefoundpr = BOOL_TRUE;
 			sametime = sessp->s_time;
-			uuid_copy (sameid, sessp->s_sesid);
+			uuid_copy(sameid, sessp->s_sesid);
 			samepartialpr = sessp->s_ispartial;
 			sameinterruptedpr = BOOL_TRUE;
-			sc_resumerangecnt =  (size_t)sessp->s_nstreams;
+			sc_resumerangecnt = (size_t)sessp->s_nstreams;
 			sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
 							     sizeof(drange_t));
 			assert(sc_resumerangep);
@@ -1058,7 +1058,7 @@ content_init(int		argc,
 			sc_level = (ix_t)sessp->s_level + 1;
 			undertime = sessp->s_time;
 			underlevel = (ix_t)sessp->s_level;
-			uuid_copy (underid, sessp->s_sesid);
+			uuid_copy(underid, sessp->s_sesid);
 			underpartialpr = sessp->s_ispartial;
 			underinterruptedpr = BOOL_FALSE;
 			underfoundpr = BOOL_TRUE;
@@ -1099,10 +1099,10 @@ content_init(int		argc,
 
 			undertime = sessp->s_time;
 			underlevel = (ix_t)sessp->s_level;
-			uuid_copy (underid, sessp->s_sesid);
+			uuid_copy(underid, sessp->s_sesid);
 			underpartialpr = sessp->s_ispartial;
 			underinterruptedpr = BOOL_FALSE;
-			strcnt =  (ix_t)sessp->s_nstreams;
+			strcnt = (ix_t)sessp->s_nstreams;
 			for (strix = 0; strix < strcnt; strix++) {
 				bsp = &sessp->s_streams[strix];
 				if (bsp->st_interrupted) {
@@ -1145,7 +1145,7 @@ content_init(int		argc,
 		uuid_copy(sameid, sessp->s_sesid);
 		samepartialpr = sessp->s_ispartial;
 		sameinterruptedpr = BOOL_FALSE;
-		sc_resumerangecnt =  (size_t)sessp->s_nstreams;
+		sc_resumerangecnt = (size_t)sessp->s_nstreams;
 		sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
 						     sizeof(drange_t));
 		assert(sc_resumerangep);
@@ -1521,9 +1521,9 @@ baseuuidbypass:
 		}
 
 		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
-			mlog (MLOG_NORMAL | MLOG_NOTE,
-			      _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
-			      sc_rootxfsstatp->bs_ino, rootstat.st_ino);
+			mlog(MLOG_NORMAL | MLOG_NOTE,
+			     _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
+			     sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
 
 	/*
@@ -1650,7 +1650,7 @@ baseuuidbypass:
 	direntsz = inocnt * (uint64_t)(DIRENTHDR_SZ + 8);
 	filesz = inocnt * (uint64_t)(FILEHDR_SZ + EXTENTHDR_SZ);
 
-	hdr_mfilesz =   GLOBAL_HDR_SZ
+	hdr_mfilesz = GLOBAL_HDR_SZ
 		      +
 		      inomapsz
 		      +
@@ -1710,7 +1710,7 @@ baseuuidbypass:
 			contextp->cc_getdentsbufsz = GETDENTSBUF_SZ_MIN;
 		}
 		contextp->cc_getdentsbufp =
-			(char *) calloc(1, contextp->cc_getdentsbufsz);
+			(char *)calloc(1, contextp->cc_getdentsbufsz);
 		assert(contextp->cc_getdentsbufp);
 
 		contextp->cc_mdirentbufsz = sizeof(direnthdr_t)
@@ -1719,7 +1719,7 @@ baseuuidbypass:
 					    +
 					    DIRENTHDR_ALIGN;
 		contextp->cc_mdirentbufp =
-			(char *) calloc(1, contextp->cc_mdirentbufsz);
+			(char *)calloc(1, contextp->cc_mdirentbufsz);
 		assert(contextp->cc_mdirentbufp);
 
 		contextp->cc_extattrlistbufsz = EXTATTR_LISTBUF_SZ;
@@ -1748,7 +1748,7 @@ baseuuidbypass:
 
 		contextp->cc_readlinkbufsz = MAXPATHLEN + SYMLINK_ALIGN;
 		contextp->cc_readlinkbufp =
-			(char *) calloc(1, contextp->cc_readlinkbufsz);
+			(char *)calloc(1, contextp->cc_readlinkbufsz);
 		assert(contextp->cc_readlinkbufp);
 
 		contextp->cc_inomap_contextp = inomap_alloc_context();
@@ -1971,8 +1971,8 @@ content_statline(char **linespp[])
 			tmp->tm_hour,
 			tmp->tm_min,
 			tmp->tm_sec,
-			(unsigned long long) nondirdone,
-			(unsigned long long) sc_stat_nondircnt,
+			(unsigned long long)nondirdone,
+			(unsigned long long)sc_stat_nondircnt,
 			percent,
 			elapsed);
 	} else {
@@ -2864,7 +2864,7 @@ content_complete(void)
 					mlog(MLOG_ERROR, _(
 						     "unable to remove %s: %s\n"),
 					     quotas[i].quotapath,
-					     strerror (errno));
+					     strerror(errno));
 				}
 			}
 		}
@@ -3199,7 +3199,7 @@ dump_dir(ix_t			strmix,
 	if (fd < 0) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			     "unable to open directory: ino %llu: %s\n"),
-		     statp->bs_ino, strerror(errno) );
+		     statp->bs_ino, strerror(errno));
 		return RV_OK; /* continue anyway */
 	}
 
@@ -4214,7 +4214,7 @@ dump_file_reg(drive_t *			drivep,
 				register time32_t ltime = max(mtime, ctime);
 				if (ltime < sc_resumebasetime) {
 					if (rp->dr_begin.sp_offset > offset) {
-						offset =rp->dr_begin.sp_offset;
+						offset = rp->dr_begin.sp_offset;
 					}
 				}
 				break;
@@ -4564,7 +4564,7 @@ init_extent_group_context(jdm_fshandle_t *		fshandlep,
 	 * after this check but before all reads have completed.
 	 * This change just closes the window a bit.
 	 */
-	if ((statp->bs_mode & S_ISGID) && (!(statp->bs_mode&S_IXOTH)) ) {
+	if ((statp->bs_mode & S_ISGID) && (!(statp->bs_mode & S_IXOTH))) {
 		fl.l_type = F_RDLCK;
 		fl.l_whence = SEEK_SET;
 		fl.l_start = (off_t)0;
@@ -5011,7 +5011,7 @@ dump_extent_group(drive_t *			drivep,
 		if (isrealtime || extsz >= PGALIGNTHRESH * PGSZ) {
 			size_t cnt_to_align;
 			cnt_to_align = (*dop->do_get_align_cnt)(drivep);
-			if ((size_t)cnt_to_align < 2*sizeof(extenthdr_t)) {
+			if ((size_t)cnt_to_align < 2 * sizeof(extenthdr_t)) {
 				cnt_to_align += PGSZ;
 			}
 
@@ -5309,7 +5309,7 @@ dump_extenthdr(drive_t *	drivep,
 	rv_t rv;
 	char typestr[20];
 
-	switch (type)  {
+	switch (type) {
 	case EXTENTHDR_TYPE_LAST:
 		strcpy(typestr, "LAST");
 		break;
@@ -6946,7 +6946,7 @@ save_quotas(char *mntpnt, quota_info_t *quotainfo)
 		     sts == -1 ? -1 : WEXITSTATUS(sts));
 		return BOOL_FALSE;
 	}
-	if ((fd = open(quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
+	if ((fd = open(quotainfo->quotapath, O_RDONLY | O_DSYNC)) < 0) {
 		mlog(MLOG_ERROR, _(
 			     "open failed %s: %s\n"),
 		     quotainfo->quotapath,
diff --git a/dump/inomap.c b/dump/inomap.c
index be505ea..17c6909 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -324,11 +324,11 @@ inomap_build(jdm_fshandle_t *	fshandlep,
 		*inomap_statpassp = 0;
 		*inomap_statphasep = 2;
 
-		(void) supprt_prune(&rootdump,
-				    fshandlep,
-				    fsfd,
-				    rootstatp,
-				    NULL);
+		(void)supprt_prune(&rootdump,
+				   fshandlep,
+				   fsfd,
+				   rootstatp,
+				   NULL);
 		*inomap_statphasep = 0;
 
 		if (preemptchk(PREEMPT_FULL)) {
@@ -405,7 +405,7 @@ inomap_build(jdm_fshandle_t *	fshandlep,
 				mlog(MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
 				     _("end\n"));
 			} else {
-				mlog(MLOG_VERBOSE |  MLOG_BARE | MLOG_INOMAP,
+				mlog(MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
 				     _("ino %llu offset %lld\n"),
 				     ep->sp_ino,
 				     ep->sp_offset);
@@ -1281,11 +1281,11 @@ inomap_find_seg(seg_addr_t *addrp, xfs_ino_t ino)
 	int lower;
 	int upper;
 
-	if (! inomap_validaddr(addrp) ) {
+	if (! inomap_validaddr(addrp)) {
 		inomap_reset_context(addrp);
 	}
 
-	if (! inomap_find_hnk(addrp, ino) )
+	if (! inomap_find_hnk(addrp, ino))
 		return BOOL_FALSE;
 
 	/* find the correct segment */
@@ -1377,7 +1377,7 @@ inomap_set_state(void *contextp, xfs_ino_t ino, int state)
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (! inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino))
 		return MAP_INO_UNUSED;
 
 	segp = inomap_addr2seg(addrp);
@@ -1396,7 +1396,7 @@ inomap_get_state(void *contextp, xfs_ino_t ino)
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (! inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino))
 		return MAP_INO_UNUSED;
 
 	segp = inomap_addr2seg(addrp);
@@ -1414,7 +1414,7 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (! inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino))
 		return;
 
 	segp = inomap_addr2seg(addrp);
@@ -1435,7 +1435,7 @@ inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen)
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (! inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino))
 		return 1;
 
 	segp = inomap_addr2seg(addrp);
diff --git a/dump/var.c b/dump/var.c
index 47ec9fa..75a239e 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -50,13 +50,13 @@ var_create(void)
 		p++;
 		if (*p == '/') {
 			*p = '\0';
-			if (! var_create_component(path) )
+			if (! var_create_component(path))
 				return;
 			*p = '/';
 		}
 	} while (*p);
 
-	(void) var_create_component(path);
+	(void)var_create_component(path);
 }
 
 static int
diff --git a/include/swab.h b/include/swab.h
index 2fa21f2..0a5289f 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -18,8 +18,8 @@
 		__u32 __x = (x); \
 		((__u32)( \
 			 (((__u32)(__x) & (__u32)0x000000ffUL) << 24) | \
-			 (((__u32)(__x) & (__u32)0x0000ff00UL) <<  8) | \
-			 (((__u32)(__x) & (__u32)0x00ff0000UL) >>  8) | \
+			 (((__u32)(__x) & (__u32)0x0000ff00UL) << 8) | \
+			 (((__u32)(__x) & (__u32)0x00ff0000UL) >> 8) | \
 			 (((__u32)(__x) & (__u32)0xff000000UL) >> 24))); \
 	})
 
@@ -30,8 +30,8 @@
 			 (__u64)(((__u64)(__x) & (__u64)0x00000000000000ffULL) << 56) | \
 			 (__u64)(((__u64)(__x) & (__u64)0x000000000000ff00ULL) << 40) | \
 			 (__u64)(((__u64)(__x) & (__u64)0x0000000000ff0000ULL) << 24) | \
-			 (__u64)(((__u64)(__x) & (__u64)0x00000000ff000000ULL) <<  8) | \
-			 (__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >>  8) | \
+			 (__u64)(((__u64)(__x) & (__u64)0x00000000ff000000ULL) << 8) | \
+			 (__u64)(((__u64)(__x) & (__u64)0x000000ff00000000ULL) >> 8) | \
 			 (__u64)(((__u64)(__x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
 			 (__u64)(((__u64)(__x) & (__u64)0x00ff000000000000ULL) >> 40) | \
 			 (__u64)(((__u64)(__x) & (__u64)0xff00000000000000ULL) >> 56))); \
@@ -44,16 +44,16 @@
 #define ___constant_swab32(x) \
 	((__u32)( \
 		 (((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
-		 (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
-		 (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
+		 (((__u32)(x) & (__u32)0x0000ff00UL) << 8) | \
+		 (((__u32)(x) & (__u32)0x00ff0000UL) >> 8) | \
 		 (((__u32)(x) & (__u32)0xff000000UL) >> 24)))
 #define ___constant_swab64(x) \
 	((__u64)( \
 		 (__u64)(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) | \
 		 (__u64)(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) | \
 		 (__u64)(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) | \
-		 (__u64)(((__u64)(x) & (__u64)0x00000000ff000000ULL) <<  8) | \
-		 (__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) | \
+		 (__u64)(((__u64)(x) & (__u64)0x00000000ff000000ULL) << 8) | \
+		 (__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >> 8) | \
 		 (__u64)(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
 		 (__u64)(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) | \
 		 (__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56)))
@@ -119,7 +119,7 @@ static __inline__ __u16 __swab16p(__u16 *x)
 }
 static __inline__ void __swab16s(__u16 *addr)
 {
-	(__extension__ ({ __arch__swab16s(addr); }));
+	(__extension__({ __arch__swab16s(addr); }));
 }
 
 static __inline__ __u32 __fswab32(__u32 x)
@@ -132,14 +132,14 @@ static __inline__ __u32 __swab32p(__u32 *x)
 }
 static __inline__ void __swab32s(__u32 *addr)
 {
-	(__extension__ ({ __arch__swab32s(addr); }));
+	(__extension__({ __arch__swab32s(addr); }));
 }
 
 static __inline__ __u64 __fswab64(__u64 x)
 {
 #  ifdef __SWAB_64_THRU_32__
 	__u32 h = x >> 32;
-	__u32 l = x & ((1ULL<<32)-1);
+	__u32 l = x & ((1ULL << 32) - 1);
 	return (((__u64)__swab32(l)) << 32) | ((__u64)(__swab32(h)));
 #  else
 	return (__extension__ __arch__swab64(x));
@@ -151,7 +151,7 @@ static __inline__ __u64 __swab64p(__u64 *x)
 }
 static __inline__ void __swab64s(__u64 *addr)
 {
-	(__extension__ ({ __arch__swab64s(addr); }));
+	(__extension__({ __arch__swab64s(addr); }));
 }
 
 #endif /* SWAB_H */
diff --git a/include/swap.h b/include/swap.h
index a0593d4..d6252ee 100644
--- a/include/swap.h
+++ b/include/swap.h
@@ -55,7 +55,7 @@
 			 (INT_SWAP((ref), (valueref))) : (valueref))) : \
 	 (void)(((ref) = (valueref)), \
 		(((arch) != ARCH_NOCONVERT) ? \
-		 (ref) = INT_SWAP((ref), (ref)) : 0) ))
+		 (ref) = INT_SWAP((ref), (ref)) : 0)))
 
 #define INT_XLATE(buf, p, dir, arch) \
 	((dir > 0) ? ((p) = INT_GET((buf), (arch))) : INT_SET((buf), (arch), (p)))
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index 7a5332a..2467115 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -55,8 +55,8 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 
 	int index = 0;
 
-	assert (pred);
-	fd = retval = init_idb (pred, bywhat, forwhat, &tok);
+	assert(pred);
+	fd = retval = init_idb(pred, bywhat, forwhat, &tok);
 
 	if (retval == I_DONE)
 		return tok;
@@ -81,7 +81,7 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 		return INV_TOKEN_NULL;
 	}
 
-	assert (index > 0);
+	assert(index > 0);
 
 	/* Now we need to make sure that this has enough space */
 	INVLOCK(stobjfd, LOCK_SH);
@@ -98,17 +98,17 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 	 * create another storage object (and, an inv_index entry for it
 	   too) if we've filled this one up */
 
-	if ((uint) num >= sescnt->ic_maxnum) {
+	if ((uint)num >= sescnt->ic_maxnum) {
 		mlog(MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
 		     "index entry. \n");
 		INVLOCK(stobjfd, LOCK_UN);
-		close (stobjfd);
+		close(stobjfd);
 
 		INVLOCK(fd, LOCK_EX);
 		stobjfd = idx_create_entry(&tok, fd, BOOL_FALSE);
 		INVLOCK(fd, LOCK_UN);
 
-		free (sescnt);
+		free(sescnt);
 		if (stobjfd < 0) {
 			close(fd);
 			return INV_TOKEN_NULL;
@@ -118,7 +118,7 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 
 	INVLOCK(stobjfd, LOCK_UN);
 
-	free (sescnt);
+	free(sescnt);
 	tok = get_token(fd, stobjfd);
 	tok->d_invindex_off = IDX_HDR_OFFSET(index - 1);
 	tok->d_oflag = forwhat;
@@ -139,9 +139,9 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 bool_t
 inv_close(inv_idbtoken_t tok)
 {
-	close (tok->d_invindex_fd);
+	close(tok->d_invindex_fd);
 	if (tok->d_stobj_fd >= 0)
-		close (tok->d_stobj_fd);
+		close(tok->d_stobj_fd);
 	destroy_token(tok);
 	return BOOL_TRUE;
 }
@@ -180,14 +180,14 @@ inv_writesession_open(
 	inv_sestoken_t sestok;
 	inv_oflag_t forwhat;
 
-	assert (tok != INV_TOKEN_NULL);
-	assert (sesid && fsid && mntpt && devpath);
+	assert(tok != INV_TOKEN_NULL);
+	assert(sesid && fsid && mntpt && devpath);
 	forwhat = tok->d_oflag;
 	fd = tok->d_stobj_fd;
-	assert (forwhat != INV_SEARCH_ONLY);
-	assert (fd > 0);
+	assert(forwhat != INV_SEARCH_ONLY);
+	assert(fd > 0);
 
-	if (!(tok->d_update_flag & FSTAB_UPDATED) ) {
+	if (!(tok->d_update_flag & FSTAB_UPDATED)) {
 		if (fstab_put_entry(fsid, mntpt, devpath, forwhat) < 0) {
 			mlog(MLOG_NORMAL | MLOG_INV, _(
 				     "INV: put_fstab_entry failed.\n"));
@@ -198,9 +198,9 @@ inv_writesession_open(
 
 
 	/* copy the session information to store */
-	memset((void *)&ses, 0, sizeof(ses) );  /* paranoia */
-	memcpy(&ses.s_sesid, sesid, sizeof(uuid_t) );
-	memcpy(&ses.s_fsid, fsid, sizeof(uuid_t) );
+	memset((void *)&ses, 0, sizeof(ses));   /* paranoia */
+	memcpy(&ses.s_sesid, sesid, sizeof(uuid_t));
+	memcpy(&ses.s_fsid, fsid, sizeof(uuid_t));
 	strcpy(ses.s_label, label);
 	strcpy(ses.s_mountpt, mntpt);
 	strcpy(ses.s_devpath, devpath);
@@ -221,7 +221,7 @@ inv_writesession_open(
 
 	INVLOCK(fd, LOCK_EX);
 	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
-		free (sestok);
+		free(sestok);
 		INVLOCK(fd, LOCK_UN);
 		return INV_TOKEN_NULL;
 	}
@@ -230,7 +230,7 @@ inv_writesession_open(
 	 * create the writesession, and get ready for the streams to come
 	   afterwards */
 	rval = stobj_create_session(sestok, fd, sescnt, &ses, &hdr);
-	assert (rval > 0);
+	assert(rval > 0);
 
 
 	INVLOCK(fd, LOCK_UN);
@@ -246,7 +246,7 @@ inv_writesession_open(
 		tok->d_update_flag &= ~(NEW_INVINDEX);
 	}
 
-	free (sescnt);
+	free(sescnt);
 
 
 	return (rval < 0) ? INV_TOKEN_NULL : sestok;
@@ -268,13 +268,13 @@ inv_writesession_close(inv_sestoken_t tok)
 {
 	int rval;
 
-	assert (tok != INV_TOKEN_NULL);
+	assert(tok != INV_TOKEN_NULL);
 
 	/* now update end_time in the inv index header */
 	rval = idx_put_sesstime(tok, INVT_ENDTIME);
 
-	memset(tok, 0, sizeof(invt_sesdesc_entry_t) );
-	free (tok);
+	memset(tok, 0, sizeof(invt_sesdesc_entry_t));
+	free(tok);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 
@@ -299,7 +299,7 @@ inv_stream_open(
 	int fd;
 	bool_t err = BOOL_FALSE;
 
-	assert (tok != INV_TOKEN_NULL);
+	assert(tok != INV_TOKEN_NULL);
 
 	/*
 	 * this memset is needed as a dump interrupted/crashed very soon
@@ -314,7 +314,7 @@ inv_stream_open(
 	strcpy(stream.st_cmdarg, cmdarg);
 
 	/* XXX yukk... make the token descriptors not pointers */
-	stok = (inv_stmtoken_t) malloc(sizeof(invt_strdesc_entry_t) );
+	stok = (inv_stmtoken_t)malloc(sizeof(invt_strdesc_entry_t));
 
 	stok->md_sesstok = tok;
 	stok->md_lastmfile = 0;
@@ -328,10 +328,10 @@ inv_stream_open(
 	if (stobj_get_sessinfo(tok, &seshdr, &ses) <= 0)
 		err = BOOL_TRUE;
 
-	if ((! err)  && ses.s_cur_nstreams < ses.s_max_nstreams) {
+	if ((! err) && ses.s_cur_nstreams < ses.s_max_nstreams) {
 		/* this is where this stream header will be written to */
-		stok->md_stream_off = (off64_t) (sizeof(invt_stream_t) *
-						 ses.s_cur_nstreams)
+		stok->md_stream_off = (off64_t)(sizeof(invt_stream_t) *
+						ses.s_cur_nstreams)
 				      + seshdr.sh_streams_off;
 		ses.s_cur_nstreams++;
 
@@ -340,9 +340,9 @@ inv_stream_open(
 				   tok->sd_session_off) < 0)
 			err = BOOL_TRUE;
 	} else if (! err) {
-		mlog (MLOG_NORMAL, _(
-			      "INV: cant create more than %d streams."
-			      " Max'd out..\n"), ses.s_cur_nstreams);
+		mlog(MLOG_NORMAL, _(
+			     "INV: cant create more than %d streams."
+			     " Max'd out..\n"), ses.s_cur_nstreams);
 		err = BOOL_TRUE;
 	}
 
@@ -360,7 +360,7 @@ inv_stream_open(
 	}
 
 	/* error occured somewhere */
-	free (stok);
+	free(stok);
 	INVLOCK(fd, LOCK_UN);
 	return INV_TOKEN_NULL;
 
@@ -424,10 +424,10 @@ inv_stream_close(
 	INVLOCK(fd, LOCK_UN);
 
 	if (tok->md_lastmfile) {
-		free (tok->md_lastmfile);
+		free(tok->md_lastmfile);
 	}
-	memset(tok, 0, sizeof(invt_strdesc_entry_t) );
-	free (tok);
+	memset(tok, 0, sizeof(invt_strdesc_entry_t));
+	free(tok);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 }
@@ -459,14 +459,14 @@ inv_put_mediafile(
 	int rval;
 
 
-	assert (tok != INV_TOKEN_NULL);
-	assert (tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED);
-	assert (tok->md_sesstok->sd_invtok->d_stobj_fd >= 0);
+	assert(tok != INV_TOKEN_NULL);
+	assert(tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED);
+	assert(tok->md_sesstok->sd_invtok->d_stobj_fd >= 0);
 
-	mf = (invt_mediafile_t *) calloc(1, sizeof(invt_mediafile_t) );
+	mf = (invt_mediafile_t *)calloc(1, sizeof(invt_mediafile_t));
 
 	/* copy the media file information */
-	memcpy(&mf->mf_moid, moid, sizeof(uuid_t) );
+	memcpy(&mf->mf_moid, moid, sizeof(uuid_t));
 	strcpy(mf->mf_label, label);
 	mf->mf_mfileidx = mfileindex;
 	mf->mf_startino.ino = startino;
@@ -600,13 +600,13 @@ inv_free_session(
 
 	for (i = 0; i < (*ses)->s_nstreams; i++) {
 		/* the array of mediafiles is contiguous */
-		free ((*ses)->s_streams[i].st_mediafiles);
+		free((*ses)->s_streams[i].st_mediafiles);
 	}
 
 	/* all streams are contiguous too */
-	free ((*ses)->s_streams);
+	free((*ses)->s_streams);
 
-	free (*ses);
+	free(*ses);
 	*ses = NULL;
 }
 
@@ -630,9 +630,9 @@ inv_lasttime_level_lessthan(
 {
 	int rval;
 	if (tok != INV_TOKEN_NULL) {
-		rval =  search_invt(fsidp, tok->d_invindex_fd, &level,
-				    (void **)tm,
-				    (search_callback_t)tm_level_lessthan);
+		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
+				   (void **)tm,
+				   (search_callback_t)tm_level_lessthan);
 
 		return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
 	}
@@ -938,14 +938,14 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 				switch (d) {
 				/* process mntpt option */
 				case OPT_MNT:
-					bywhat = (inv_predicate_t) INV_BY_MOUNTPT;
+					bywhat = (inv_predicate_t)INV_BY_MOUNTPT;
 					fs = value;
 					npreds++;
 					break;
 
 				/* process fsid option */
 				case OPT_FSID:
-					bywhat = (inv_predicate_t) INV_BY_UUID;
+					bywhat = (inv_predicate_t)INV_BY_UUID;
 					npreds++;
 
 					uuid_parse(value, fsid);
@@ -953,7 +953,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 					break;
 
 				case OPT_DEV:       /* process dev option */
-					bywhat = (inv_predicate_t) INV_BY_DEVPATH;
+					bywhat = (inv_predicate_t)INV_BY_DEVPATH;
 					fs = value;
 					npreds++;
 					break;
@@ -968,7 +968,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 				case OPT_MOBJID:
 				{
 					uuid_t *u;
-					u = malloc (sizeof(uuid_t) );
+					u = malloc(sizeof(uuid_t));
 					uuid_parse(value, *u);
 					prctx->mobj.type = INVT_MOID;
 					prctx->mobj.value = (void *)u;
@@ -1066,10 +1066,10 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 					}
 					inv_close(tok);
 				}
-				free (arr);
+				free(arr);
 				rval |= I_IDONE;
 			}
-			if ((rval&I_IERR)) {
+			if ((rval & I_IERR)) {
 				mlog(MLOG_NORMAL | MLOG_INV, _(
 					     "INV: open failed on mount point \"%s\"\n"),
 				     fs);
@@ -1136,7 +1136,7 @@ inv_DEBUG_print(int argc, char **argv)
 				       forwhat,
 				       &arr[i].ft_uuid);
 			if (tok == INV_TOKEN_NULL) {
-				free (arr);
+				free(arr);
 				return BOOL_FALSE;
 			}
 
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index b966ebc..5670e60 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -50,12 +50,12 @@ get_counters(int fd, void **cntpp, size_t cntsz)
 {
 	/* object must be locked at least SHARED by caller */
 	uint num;
-	assert(cntsz >= sizeof(invt_counter_t) );
+	assert(cntsz >= sizeof(invt_counter_t));
 
-	*cntpp =  calloc(1, cntsz);
+	*cntpp = calloc(1, cntsz);
 
 	/* find the number of sessions and the max possible */
-	if (GET_REC_NOLOCK(fd, (void *) *cntpp, cntsz, (off64_t) 0) < 0) {
+	if (GET_REC_NOLOCK(fd, (void *)*cntpp, cntsz, (off64_t)0) < 0) {
 		free(*cntpp);
 		*cntpp = NULL;
 		return -1;
@@ -66,13 +66,13 @@ get_counters(int fd, void **cntpp, size_t cntsz)
 	if (((invt_counter_t *)(*cntpp))->ic_vernum != INV_VERSION) {
 		mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV : Unknown version %d - Expected version %d\n"),
-		     (int) ((invt_counter_t *)(*cntpp))->ic_vernum,
-		     (int) INV_VERSION);
-		assert (((invt_counter_t *)(*cntpp))->ic_vernum ==
-			INV_VERSION);
+		     (int)((invt_counter_t *)(*cntpp))->ic_vernum,
+		     (int)INV_VERSION);
+		assert(((invt_counter_t *)(*cntpp))->ic_vernum ==
+		       INV_VERSION);
 	}
 
-	return (int) num;
+	return (int)num;
 }
 
 
@@ -95,8 +95,8 @@ get_headers(int fd, void **hdrs, size_t bufsz, size_t off)
 	/* file must be locked at least SHARED by caller */
 
 	/* get the array of hdrs */
-	if (GET_REC_NOLOCK(fd, (void *) *hdrs, bufsz, (off64_t)off) < 0) {
-		free (*hdrs);
+	if (GET_REC_NOLOCK(fd, (void *)*hdrs, bufsz, (off64_t)off) < 0) {
+		free(*hdrs);
 		*hdrs = NULL;
 		return -1;
 	}
@@ -116,13 +116,13 @@ get_invtrecord(int fd, void *buf, size_t bufsz, off64_t off,
 {
 	int nread;
 
-	assert (fd >= 0);
+	assert(fd >= 0);
 
 	if (dolock)
 		INVLOCK(fd, LOCK_SH);
 
 	nread = pread(fd, buf, bufsz, (off_t)off);
-	if (nread != (int) bufsz) {
+	if (nread != (int)bufsz) {
 		INV_PERROR(_("Error in reading inventory record :"));
 		if (dolock)
 			INVLOCK(fd, LOCK_UN);
@@ -153,7 +153,7 @@ put_invtrecord(int fd, void *buf, size_t bufsz, off64_t off, bool_t dolock)
 		INVLOCK(fd, LOCK_EX);
 
 	nwritten = pwrite(fd, buf, bufsz, (off_t)off);
-	if (nwritten != (int) bufsz) {
+	if (nwritten != (int)bufsz) {
 		INV_PERROR(_("Error in writing inventory record :"));
 		if (dolock)
 			INVLOCK(fd, LOCK_UN);
@@ -190,7 +190,7 @@ get_headerinfo(int fd, void **hdrs, void **cnt,
 	/* If there are no sessions recorded yet, we're done too */
 	if (num > 0) {
 		if (get_headers(fd, hdrs, hdrsz * (size_t)num, cntsz) < 0) {
-			free (*cnt);
+			free(*cnt);
 			num = -1;
 		}
 	}
@@ -222,10 +222,10 @@ get_lastheader(int fd, void **ent, size_t hdrsz, size_t cntsz)
 	 * if there's space anywhere at all, then it must be in the last
 	   entry */
 	*ent = malloc(hdrsz);
-	pos = (char *) arr + ((uint)nindices - 1) * hdrsz;
+	pos = (char *)arr + ((uint)nindices - 1) * hdrsz;
 	memcpy(*ent, pos, hdrsz);
-	free (arr);
-	free (cnt);
+	free(arr);
+	free(cnt);
 
 	return nindices;
 }
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 1f6ed8d..6b603b6 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -54,16 +54,16 @@ fstab_getall(invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 {
 	int fd;
 
-	fd = open (INV_FSTAB, INV_OFLAG(forwhat));
+	fd = open(INV_FSTAB, INV_OFLAG(forwhat));
 
 	if (fd < 0)
 		return -1; /* if ENOENT, fstab_put_entry will CREAT */
 
 	INVLOCK(fd, LOCK_EX);
-	if ((*numfs = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void**) arr,
+	if ((*numfs = GET_ALLHDRS_N_CNTS_NOLOCK(fd, (void **)arr,
 						(void **)cnt,
 						sizeof(invt_fstab_t),
-						sizeof(invt_counter_t) )
+						sizeof(invt_counter_t))
 	     ) < 0) {
 		mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: couldn't get fstab headers\n"));
@@ -104,16 +104,16 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 		if (errno != ENOENT) {
 			return -1;
 		}
-		if ((fd = open(INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR))
+		if ((fd = open(INV_FSTAB, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR | S_IWUSR))
 		    < 0) {
-			INV_PERROR (INV_FSTAB);
+			INV_PERROR(INV_FSTAB);
 			return -1;
 		}
 
 		INVLOCK(fd, LOCK_EX);
 		fchmod(fd, INV_PERMS);
 
-		cnt = (invt_counter_t *) malloc(sizeof (invt_counter_t) );
+		cnt = (invt_counter_t *)malloc(sizeof(invt_counter_t));
 
 		cnt->ic_maxnum = -1;
 		cnt->ic_curnum = 0;
@@ -127,15 +127,15 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 /*			if ((STREQL(arr[i].ft_mountpt, mntpt) ) &&
                             (STREQL(arr[i].ft_devpath, dev) ))
  */
-				free (arr);
-				free (cnt);
+				free(arr);
+				free(cnt);
 				close(fd);
 				return 1;
 
 			}
 		}
 		/* entry not found. just follow thru to create a new one */
-		free (arr);
+		free(arr);
 	}
 
 	/*
@@ -145,7 +145,7 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 		invt_fstab_t ent;
 		off64_t hoff;
 
-		memcpy(&ent.ft_uuid, fsidp, sizeof(uuid_t) );
+		memcpy(&ent.ft_uuid, fsidp, sizeof(uuid_t));
 		strcpy(ent.ft_mountpt, mntpt);
 		strcpy(ent.ft_devpath, dev);
 
@@ -155,9 +155,9 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 		     mntpt);
 #endif
 		cnt->ic_curnum++;
-		hoff = (off64_t) (sizeof(invt_counter_t) +
-				  (size_t)(cnt->ic_curnum - 1) *
-				  sizeof(invt_fstab_t) );
+		hoff = (off64_t)(sizeof(invt_counter_t) +
+				 (size_t)(cnt->ic_curnum - 1) *
+				 sizeof(invt_fstab_t));
 
 		rval = PUT_COUNTERS(fd, cnt);
 		if (rval > 0) {
@@ -166,8 +166,8 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 
 	}
 	INVLOCK(fd, LOCK_UN);
-	free (cnt);
-	close (fd);
+	free(cnt);
+	close(fd);
 	return rval;
 }
 
@@ -201,16 +201,16 @@ fstab_get_fname(void *		pred,
 			return -1;
 		}
 		INVLOCK(fd, LOCK_UN);
-		close (fd);
-		free (cnt); /* we dont need it */
+		close(fd);
+		free(cnt);  /* we dont need it */
 
 		/* first get hold of the uuid for this mount point/device */
 
 		for (i = 0; i < numfs; i++) {
 			if ((bywhat == INV_BY_MOUNTPT &&
-			     (STREQL(arr[i].ft_mountpt, pred) )) ||
+			     (STREQL(arr[i].ft_mountpt, pred))) ||
 			    (bywhat == INV_BY_DEVPATH &&
-			     (STREQL(arr[i].ft_devpath, pred) ))) {
+			     (STREQL(arr[i].ft_devpath, pred)))) {
 
 				uuidp = &arr[i].ft_uuid;
 				break;
@@ -231,14 +231,14 @@ fstab_get_fname(void *		pred,
 
 	uuid_unparse(*uuidp, uuidstr);
 
-	strncpy (fname, INV_DIRPATH, INV_STRLEN);
-	strcat (fname, "/");
-	strcat (fname, uuidstr);
+	strncpy(fname, INV_DIRPATH, INV_STRLEN);
+	strcat(fname, "/");
+	strcat(fname, uuidstr);
 
 	if (bywhat != INV_BY_UUID)
-		free (arr);
+		free(arr);
 
-	assert((int) strlen(fname) < INV_STRLEN);
+	assert((int)strlen(fname) < INV_STRLEN);
 	return 1;
 }
 
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 927d36a..bfe1c68 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -67,15 +67,15 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 		/*
 		 * if our time is nicely within an existing entry's time
 		   period, hellalujah */
-		if (IS_WITHIN(&iarr[i].ie_timeperiod, tm) ) {
+		if (IS_WITHIN(&iarr[i].ie_timeperiod, tm)) {
 #ifdef INVT_DEBUG
 			mlog(MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n", i);
 #endif
 			*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 			return i;
 		}
-		if (iarr[i].ie_timeperiod.tp_end == 0  &&
-		    iarr[i].ie_timeperiod.tp_start  == 0) {
+		if (iarr[i].ie_timeperiod.tp_end == 0 &&
+		    iarr[i].ie_timeperiod.tp_start == 0) {
 #ifdef INVT_DEBUG
 			mlog(MLOG_DEBUG | MLOG_INV, "INV: end = start \n");
 			mlog(MLOG_DEBUG | MLOG_INV, "BEF: st %ld end %ld\n",
@@ -87,7 +87,7 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 				iarr[i].ie_timeperiod.tp_end = tm;
 			PUT_REC_NOLOCK(fd, iarr,
 				       icnt->ic_curnum * sizeof(invt_entry_t),
-				       (off64_t) sizeof(invt_counter_t) );
+				       (off64_t)sizeof(invt_counter_t));
 #ifdef INVT_DEBUG
 			mlog(MLOG_DEBUG | MLOG_INV, "AFT: st %ld end %ld\n",
 			     iarr[i].ie_timeperiod.tp_start,
@@ -120,7 +120,7 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 				return i;
 			}
 			/* see if the next entry starts later than us */
-			if (iarr[i+1].ie_timeperiod.tp_start > tm) {
+			if (iarr[i + 1].ie_timeperiod.tp_start > tm) {
 
 
 				/*
@@ -132,7 +132,7 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 
 				/* the timeperiods had better not overlap */
 				assert((tm > iarr[i].ie_timeperiod.tp_end) &&
-				       (tm < iarr[i+1].ie_timeperiod.tp_start));
+				       (tm < iarr[i + 1].ie_timeperiod.tp_start));
 
 				/*
 				 * shift everything from (i+1) onwards by
@@ -175,28 +175,28 @@ idx_put_newentry(
 	invt_counter_t *icnt = idx->icnt;
 
 	stobj_makefname(ient->ie_filename);
-	if ((stobjfd = stobj_create(ient->ie_filename) ) < 0)
+	if ((stobjfd = stobj_create(ient->ie_filename)) < 0)
 		return -1;
 
 	icnt->ic_curnum++; /* there is no maximum */
 
-	idxarr = (invt_entry_t *) calloc (icnt->ic_curnum,
-					  sizeof(invt_entry_t) );
-	memcpy(idxarr, iarr, (size_t) (sizeof(invt_entry_t) * index) );
+	idxarr = (invt_entry_t *)calloc(icnt->ic_curnum,
+					sizeof(invt_entry_t));
+	memcpy(idxarr, iarr, (size_t)(sizeof(invt_entry_t) * index));
 
 	/* shift everything from (i+1) onwards by one */
-	if (index <  icnt->ic_curnum - 1)
+	if (index < icnt->ic_curnum - 1)
 		memcpy(&idxarr[index + 1], &iarr[index],
-		       (size_t) ((icnt->ic_curnum - index - 1) *
-				 sizeof(invt_entry_t) ));
+		       (size_t)((icnt->ic_curnum - index - 1) *
+				sizeof(invt_entry_t)));
 	/* insert the new entry */
-	memcpy(&idxarr[index], ient, sizeof(invt_entry_t) );
+	memcpy(&idxarr[index], ient, sizeof(invt_entry_t));
 
 
 	if ((PUT_COUNTERS(fd, icnt) < 0) ||
 	    (PUT_REC_NOLOCK(fd, idxarr,
 			    icnt->ic_curnum * sizeof(invt_entry_t),
-			    sizeof(invt_counter_t) ) < 0) ) {
+			    sizeof(invt_counter_t)) < 0)) {
 		/* XXX delete the stobj that we just created */
 
 		memset(ient->ie_filename, 0, INV_STRLEN);
@@ -234,7 +234,7 @@ idx_find_stobj(invt_idxinfo_t * idx,
 	if (GET_ALLHDRS_N_CNTS_NOLOCK(idx->invfd, (void **)&idx->iarr,
 				      (void **)&idx->icnt,
 				      sizeof(invt_entry_t),
-				      sizeof(invt_counter_t) ) < 0) {
+				      sizeof(invt_counter_t)) < 0) {
 		return -1;
 	}
 
@@ -274,8 +274,8 @@ idx_create(char *fname, inv_oflag_t forwhat)
 	   the db for SEARCH_ONLY. */
 	assert(forwhat != INV_SEARCH_ONLY);
 
-	if ((fd = open (fname, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR) ) < 0) {
-		INV_PERROR (fname);
+	if ((fd = open(fname, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR | S_IWUSR)) < 0) {
+		INV_PERROR(fname);
 		return INV_TOKEN_NULL;
 	}
 
@@ -306,11 +306,11 @@ int
 idx_recons_time(time32_t tm, invt_idxinfo_t *idx)
 {
 	invt_timeperiod_t *tp = &idx->iarr[idx->index].ie_timeperiod;
-	if (tp->tp_start && IS_WITHIN(tp, tm) )
+	if (tp->tp_start && IS_WITHIN(tp, tm))
 		return 1;
 
 	if (tm > tp->tp_end || tp->tp_end == 0)
-		tp->tp_end =  tm;
+		tp->tp_end = tm;
 	if (tm < tp->tp_start || tp->tp_start == 0)
 		tp->tp_start = tm;
 	PUT_REC_NOLOCK(idx->invfd, &idx->iarr[idx->index],
@@ -367,7 +367,7 @@ idx_put_sesstime(inv_sestoken_t tok, bool_t whichtime)
 							  sizeof(invt_counter_t))) < 0) {
 			return -1;
 		}
-		idx_DEBUG_printinvindices(iarr, (uint) nindices);
+		idx_DEBUG_printinvindices(iarr, (uint)nindices);
 		free(iarr);
 		free(icnt);
 	}
@@ -403,7 +403,7 @@ idx_create_entry(
 	off64_t hoff;
 
 
-	memset (&ent, 0, sizeof(ent) );
+	memset(&ent, 0, sizeof(ent));
 
 	/* initialize the start and end times to be the same */
 	ent.ie_timeperiod.tp_start = ent.ie_timeperiod.tp_end = (time32_t)0;
@@ -431,7 +431,7 @@ idx_create_entry(
 	} else {
 		invt_counter_t *cnt = NULL;
 
-		if (GET_COUNTERS(invfd, &cnt)  < 0) {
+		if (GET_COUNTERS(invfd, &cnt) < 0) {
 			return -1;
 		}
 
@@ -452,7 +452,7 @@ idx_create_entry(
 		/* add the new index entry to the array, at the end */
 
 		hoff = IDX_HDR_OFFSET(cnt->ic_curnum - 1);
-		free (cnt);
+		free(cnt);
 #ifdef INVT_DEBUG
 		mlog(MLOG_NITTY | MLOG_INV, "new stobj name %s @ offset %d\n",
 		     ent.ie_filename, (int)hoff);
@@ -493,18 +493,18 @@ idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index)
 
 	if ((*index = get_lastheader(invfd, (void **)&ent,
 				     sizeof(invt_entry_t),
-				     sizeof(invt_counter_t)) ) < 0)
+				     sizeof(invt_counter_t))) < 0)
 		return -1;
 	/*
 	 * at this point we know that there should be at least one invindex
 	   entry present */
-	assert (ent != NULL);
-	assert (ent->ie_filename);
+	assert(ent != NULL);
+	assert(ent->ie_filename);
 
 	fd = open(ent->ie_filename, INV_OFLAG(forwhat));
 	if (fd < 0)
 		INV_PERROR(ent->ie_filename);
-	free (ent);
+	free(ent);
 
 	return fd;
 }
@@ -522,9 +522,9 @@ idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num)
 #define INV_UUID_STR_LEN        36 /* not exported via uuid.h */
 	for (i = 0; i < num; i++) {
 		k = strlen(iarr[i].ie_filename);
-		strncpy(s, (char *) iarr[i].ie_filename + k -
+		strncpy(s, (char *)iarr[i].ie_filename + k -
 			(INV_UUID_STR_LEN + strlen(INV_STOBJ_PREFIX)), 8);
-		s[8]= 0;
+		s[8] = 0;
 		printf("%d. %s \t(%d - %d)\n", i, s,
 		       iarr[i].ie_timeperiod.tp_start,
 		       iarr[i].ie_timeperiod.tp_end);
@@ -536,7 +536,7 @@ idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num)
 }
 
 int
-idx_DEBUG_print (int fd)
+idx_DEBUG_print(int fd)
 {
 	int nindices;
 	invt_entry_t *iarr = NULL;
@@ -548,7 +548,7 @@ idx_DEBUG_print (int fd)
 						  sizeof(invt_counter_t))) < 0) {
 		return -1;
 	}
-	idx_DEBUG_printinvindices(iarr, (uint) nindices);
+	idx_DEBUG_printinvindices(iarr, (uint)nindices);
 	free(iarr);
 	free(icnt);
 
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index 1552df3..e5aeb02 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -65,12 +65,12 @@ init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 	}
 
 	(void)strcpy(fname, uuname);
-	strcat (fname, INV_INVINDEX_PREFIX);
+	strcat(fname, INV_INVINDEX_PREFIX);
 
 	/* first check if the inv_index file exists: if not create it */
-	if ((fd = open(fname, INV_OFLAG(forwhat)) ) == -1) {
+	if ((fd = open(fname, INV_OFLAG(forwhat))) == -1) {
 		if (errno != ENOENT) {
-			INV_PERROR (fname);
+			INV_PERROR(fname);
 		} else if (forwhat == INV_SEARCH_N_MOD) {
 			*tok = idx_create(fname, forwhat);
 		} else {
@@ -95,15 +95,15 @@ get_token(int invfd, int stobjfd)
 {
 	invt_desc_entry_t *desc;
 
-	desc = (invt_desc_entry_t *) malloc
-		       (sizeof(invt_desc_entry_t) );
+	desc = (invt_desc_entry_t *)malloc
+		       (sizeof(invt_desc_entry_t));
 
 	desc->d_invindex_fd = invfd;
 	desc->d_stobj_fd = stobjfd;
 	desc->d_update_flag = 0;
 	desc->d_invindex_off = -1;
 
-	return (inv_idbtoken_t) desc; /* yukky, but ok for the time being */
+	return (inv_idbtoken_t)desc;  /* yukky, but ok for the time being */
 }
 
 
@@ -114,7 +114,7 @@ get_token(int invfd, int stobjfd)
 void
 destroy_token(inv_idbtoken_t tok)
 {
-	free ((invt_desc_entry_t *) tok);
+	free((invt_desc_entry_t *)tok);
 }
 
 
@@ -124,10 +124,10 @@ get_sesstoken(inv_idbtoken_t tok)
 {
 	inv_sestoken_t stok;
 
-	stok = (inv_sestoken_t) malloc(sizeof(invt_sesdesc_entry_t) );
+	stok = (inv_sestoken_t)malloc(sizeof(invt_sesdesc_entry_t));
 	stok->sd_invtok = tok;
 	stok->sd_session_off = stok->sd_sesshdr_off = -1;
-	stok->sd_sesstime = (time32_t) 0;
+	stok->sd_sesstime = (time32_t)0;
 	return stok;
 }
 
@@ -142,7 +142,7 @@ get_sesstoken(inv_idbtoken_t tok)
 /*                                                                           */
 /*---------------------------------------------------------------------------*/
 bool_t
-invmgr_query_all_sessions (
+invmgr_query_all_sessions(
 	uuid_t *		fsidp,
 	void *			inarg,
 	void **			outarg,
@@ -268,7 +268,7 @@ search_invt(
 		invt_seshdr_t *harr = NULL;
 		bool_t found;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY);
+		fd = open(iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
 			INV_PERROR(iarr[i].ie_filename);
 			continue;
@@ -286,7 +286,7 @@ search_invt(
 			close(fd);
 			continue;
 		}
-		free (scnt);
+		free(scnt);
 
 		for (j = nsess - 1; j >= 0; j--) {
 			invt_session_t ses;
@@ -372,7 +372,7 @@ invmgr_inv_print(
 	free(icnt);
 
 	if (prctx->invidx) {
-		idx_DEBUG_printinvindices(iarr, (uint) nindices);
+		idx_DEBUG_printinvindices(iarr, (uint)nindices);
 		free(iarr);
 		return (0);
 	}
@@ -385,7 +385,7 @@ invmgr_inv_print(
 		invt_seshdr_t *harr = NULL;
 		int s;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY);
+		fd = open(iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
 			INV_PERROR(iarr[i].ie_filename);
 			continue;
@@ -403,7 +403,7 @@ invmgr_inv_print(
 			close(fd);
 			continue;
 		}
-		free (scnt);
+		free(scnt);
 		for (s = 0; s < nsess; s++) {
 			/*
 			 * fd is kept locked until we return from the
@@ -425,7 +425,7 @@ invmgr_inv_print(
 		close(fd);
 	}
 
-	free (iarr);
+	free(iarr);
 	return 0;
 }
 
@@ -468,7 +468,7 @@ invmgr_inv_check(
 		invt_seshdr_t *harr = NULL;
 		int s;
 
-		fd = open (iarr[i].ie_filename, O_RDONLY);
+		fd = open(iarr[i].ie_filename, O_RDONLY);
 		if (fd < 0) {
 			INV_PERROR(iarr[i].ie_filename);
 			continue;
@@ -486,13 +486,13 @@ invmgr_inv_check(
 			close(fd);
 			continue;
 		}
-		free (scnt);
+		free(scnt);
 
 		if ((iarr[i].ie_timeperiod.tp_start != harr[0].sh_time) ||
-		    (iarr[i].ie_timeperiod.tp_end != harr[nsess-1].sh_time)) {
-			printf(_("INV: Check %d failed.\n"), i+1);
+		    (iarr[i].ie_timeperiod.tp_end != harr[nsess - 1].sh_time)) {
+			printf(_("INV: Check %d failed.\n"), i + 1);
 			printf(_("invidx (%d)\t%d - %d\n"),
-			       i+1,
+			       i + 1,
 			       iarr[i].ie_timeperiod.tp_start,
 			       iarr[i].ie_timeperiod.tp_end);
 			for (s = 0; s < nsess; s++) {
@@ -501,7 +501,7 @@ invmgr_inv_check(
 		}
 		else {
 			printf(_("INV: Check %d out of %d succeeded\n"),
-			       i+1, nindices);
+			       i + 1, nindices);
 		}
 		INVLOCK(fd, LOCK_UN);
 		close(fd);
@@ -524,15 +524,15 @@ tm_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
 {
 	u_char level = *(u_char *)arg;
 	*tm = NULL;
-	if (IS_PARTIAL_SESSION(hdr) )
+	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
 	if (hdr->sh_level < level) {
 #ifdef INVT_DEBUG
 		mlog(MLOG_DEBUG | MLOG_INV, "$ found level %d < %d\n", hdr->sh_level,
 		     level);
 #endif
-		*tm = calloc(1, sizeof(time32_t) );
-		memcpy(*tm, &hdr->sh_time, sizeof(time32_t) );
+		*tm = calloc(1, sizeof(time32_t));
+		memcpy(*tm, &hdr->sh_time, sizeof(time32_t));
 		return 1;
 	}
 	return 0;
@@ -553,14 +553,14 @@ lastsess_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
 {
 	u_char level = *(u_char *)arg;
 	*buf = NULL;
-	if (IS_PARTIAL_SESSION(hdr) )
+	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
 	if (hdr->sh_level < level) {
 #ifdef INVT_DEBUG
 		mlog(MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d < %d \n",
 		     hdr->sh_level, level);
 #endif
-		return stobj_make_invsess(fd, (inv_session_t **) buf, hdr);
+		return stobj_make_invsess(fd, (inv_session_t **)buf, hdr);
 	}
 	return 0;
 
@@ -580,14 +580,14 @@ lastsess_level_equalto(int fd, invt_seshdr_t *hdr,
 {
 	u_char level = *(u_char *)arg;
 	*buf = NULL;
-	if (IS_PARTIAL_SESSION(hdr) )
+	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
 	if (hdr->sh_level == level) {
 #ifdef INVT_DEBUG
 		mlog(MLOG_DEBUG | MLOG_INV, "$ found (ses) level %d == %d \n", hdr->sh_level,
 		     level);
 #endif
-		return stobj_make_invsess(fd, (inv_session_t **) buf, hdr);
+		return stobj_make_invsess(fd, (inv_session_t **)buf, hdr);
 	}
 	return 0;
 
@@ -615,10 +615,10 @@ insert_session(invt_sessinfo_t *s)
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 
 	/* initialize the inventory */
-	if ((invfd = init_idb ((void *) s->ses->s_fsid,
-			       (inv_predicate_t) INV_BY_UUID,
-			       forwhat,
-			       &tok) ) < 0) {
+	if ((invfd = init_idb((void *)s->ses->s_fsid,
+			      (inv_predicate_t)INV_BY_UUID,
+			      forwhat,
+			      &tok)) < 0) {
 		if (tok == INV_TOKEN_NULL) {
 #ifdef INVT_DEBUG
 			mlog(MLOG_DEBUG | MLOG_INV, "INV: insert_session: init_db "
@@ -653,7 +653,7 @@ insert_session(invt_sessinfo_t *s)
 	/* Now put the session in the storage-object */
 	INVLOCK(stobjfd, LOCK_EX);
 	if ((stobj_insert_session(&idx, stobjfd, s) < 0) ||
-	    (idx_recons_time (s->seshdr->sh_time, &idx) < 0) )
+	    (idx_recons_time(s->seshdr->sh_time, &idx) < 0))
 		ret = BOOL_TRUE;
 
 	INVLOCK(stobjfd, LOCK_UN);
@@ -729,11 +729,11 @@ invmgr_lockinit(void)
 {
 	if (invlock_fd == -1) {
 		if ((invlock_fd = open(INV_LOCKFILE,
-				       O_RDONLY | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+				       O_RDONLY | O_CREAT, S_IRUSR | S_IWUSR)) < 0) {
 			INV_PERROR(INV_LOCKFILE);
 			return BOOL_FALSE;
 		}
-		fchmod (invlock_fd, INV_PERMS);
+		fchmod(invlock_fd, INV_PERMS);
 	}
 	return BOOL_TRUE;
 }
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index 0879056..08045c5 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -75,8 +75,8 @@ oref_resolve_upto(
 {
 	int rval = INV_OK;
 
-	assert (OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
-	assert (OREF_ISLOCKED(obj));
+	assert(OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
+	assert(OREF_ISLOCKED(obj));
 
 	/* we arent interested in anything else */
 	type &= INVT_RES_MASK;
@@ -196,7 +196,7 @@ oref_sync(
 		rval = PUT_REC_NOLOCK(obj->fd,
 				      OREF_CNT(obj),
 				      sizeof(*OREF_CNT(obj)),
-				      (off64_t) 0);
+				      (off64_t)0);
 
 		break;
 
@@ -206,7 +206,7 @@ oref_sync(
 		rval = PUT_REC_NOLOCK(obj->fd,
 				      OREF_ENTRIES(obj),
 				      sizeof(*OREF_ENTRIES(obj)),
-				      (off64_t) sizeof(*OREF_CNT(obj)));
+				      (off64_t)sizeof(*OREF_CNT(obj)));
 
 		break;
 
@@ -325,13 +325,13 @@ oref_resolve(
 	if (fstab_get_fname(pred, uuname, bywhat) < 0) {
 		return INV_ERR;
 	}
-	(void) strcpy(fname, uuname);
+	(void)strcpy(fname, uuname);
 	strcat(fname, INV_INVINDEX_PREFIX);
 
 	/* first check if the inv_index file exists: if not create it */
 	if ((fd = open(fname, O_RDWR)) == -1) {
 		if (errno != ENOENT) {
-			INV_PERROR (fname);
+			INV_PERROR(fname);
 			return INV_ERR;
 		}
 		/* create the invidx */
@@ -406,8 +406,8 @@ oref_resolve_child(
 	/*
 	 * at this point we know that there should be at least one invindex
 	   entry present */
-	assert (ent != NULL);
-	assert (ent->ie_filename);
+	assert(ent != NULL);
+	assert(ent->ie_filename);
 
 	fd = open(ent->ie_filename, O_RDWR);
 	if (fd < 0) {
@@ -433,8 +433,8 @@ oref_resolve_new_invidx(
 	int stobjfd, fd;
 	inv_idbtoken_t tok;
 
-	if ((fd = open (fname, O_RDWR | O_CREAT, S_IRUSR|S_IWUSR) ) < 0) {
-		INV_PERROR (fname);
+	if ((fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)) < 0) {
+		INV_PERROR(fname);
 		return INV_ERR;
 	}
 	invidx->fd = fd;
@@ -468,7 +468,7 @@ oref_resolve_new_stobj(
 
 	assert(OREF_ISLOCKED(invidx));
 
-	memset (&ent, 0, sizeof(ent) );
+	memset(&ent, 0, sizeof(ent));
 	stobj = calloc(1, sizeof(invt_oref_t));
 	OREF_SET_CHILD(invidx, stobj);
 
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 3fa82ee..7de9441 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -159,48 +159,48 @@ typedef struct invt_oref {
 	{ (oref)->token = tok; }
 
 #define OREF_SET_CNT(oref, cnt) \
-	{ assert (OREF_ISRESOLVED(oref, INVT_OTYPE_MASK)); \
+	{ assert(OREF_ISRESOLVED(oref, INVT_OTYPE_MASK)); \
 	  ((oref)->type & INVT_OTYPE_STOBJ) ? \
 	  (oref)->cu_sescnt = (cnt) : (oref)->cu_cnt = (cnt); \
 	  (oref)->type |= INVT_RES_COUNTERS; }
 
 #define OREF_SET_ENTRIES(oref, ents) \
-	{ assert ((oref)->type & (INVT_OTYPE_INVIDX | INVT_OTYPE_FSTAB)); \
-	  assert ((oref)->type & INVT_RES_COUNTERS); \
+	{ assert((oref)->type & (INVT_OTYPE_INVIDX | INVT_OTYPE_FSTAB)); \
+	  assert((oref)->type & INVT_RES_COUNTERS); \
 	  ((oref)->type & INVT_OTYPE_INVIDX) ? \
 	  (oref)->eu_ent = ents : (oref)->eu_fstabent = ents; \
 	  (oref)->type |= INVT_RES_ENTRIES; }
 
 #define OREF_SET_HDRS(oref, hdrs) \
-	{ assert ((oref)->type & INVT_OTYPE_STOBJ); \
-	  assert ((oref)->type & INVT_RES_COUNTERS); \
+	{ assert((oref)->type & INVT_OTYPE_STOBJ); \
+	  assert((oref)->type & INVT_RES_COUNTERS); \
 	  (oref)->eu_hdr = hdrs; \
 	  (oref)->type |= INVT_STOBJ_RES_HDRS; }
 
 #define OREF_SET_SESSIONS(oref, ses) \
-	{ assert ((oref)->type & INVT_OTYPE_STOBJ); \
-	  assert ((oref)->type & INVT_RES_COUNTERS); \
+	{ assert((oref)->type & INVT_OTYPE_STOBJ); \
+	  assert((oref)->type & INVT_RES_COUNTERS); \
 	  (oref)->eu_ses = ses; \
 	  (oref)->type |= INVT_STOBJ_RES_SESSIONS; }
 
 #define OREF_SET_STRMS(oref, strms) \
-	{ assert ((oref)->type & INVT_OTYPE_STOBJ); \
-	  assert ((oref)->type & INVT_RES_COUNTERS); \
+	{ assert((oref)->type & INVT_OTYPE_STOBJ); \
+	  assert((oref)->type & INVT_RES_COUNTERS); \
 	  (oref)->eu_strm = strms; \
 	  (oref)->type |= INVT_STOBJ_RES_STRMS; }
 
 #define OREF_SET_CHILD(oref, stobjref) \
-	{ assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
+	{ assert(! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
 	  (oref)->ku_child = stobjref; \
 	  (oref)->type |= INVT_RES_CHILD; }
 
 #define OREF_SET_PARENT(oref, invidxref) \
-	{ assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
+	{ assert(! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
 	  (oref)->ku_parent = invidxref; \
 	  (oref)->type |= INVT_RES_PARENT; }
 
 #define OREF_UNRESOLVE_CHILD(oref) \
-	{ assert (OREF_ISRESOLVED(oref, INVT_RES_CHILD)); \
+	{ assert(OREF_ISRESOLVED(oref, INVT_RES_CHILD)); \
 	  close((oref)->ku_child->fd); \
 	  OREF_DESTROY((oref)->ku_child); \
 	  (oref)->ku_child = 0; \
@@ -280,10 +280,10 @@ _oref_free(
 
 #ifdef NOTDEF
 
-extern int xlv_oref_resolve (
+extern int xlv_oref_resolve(
 	xlv_oref_t *oref, xlv_tab_vol_entry_t *tab_vol_entry);
 
-extern int xlv_oref_resolve_from_list (
+extern int xlv_oref_resolve_from_list(
 	xlv_oref_t *oref, xlv_oref_t *oref_list);
 
 
@@ -291,7 +291,7 @@ extern int xlv_oref_resolve_from_list (
  *	Prints out the object referenced by an oref.
  */
 
-extern void xlv_oref_print (xlv_oref_t *oref, int p_mode);
+extern void xlv_oref_print(xlv_oref_t *oref, int p_mode);
 
 /*
  *	An iterator that applies a user-supplied function and arg
@@ -301,22 +301,22 @@ extern void xlv_oref_print (xlv_oref_t *oref, int p_mode);
  */
 typedef int (*XLV_OREF_PF) (xlv_oref_t *, void *);
 
-extern void xlv_for_each_ve_in_obj (
+extern void xlv_for_each_ve_in_obj(
 	xlv_oref_t *	oref,
 	XLV_OREF_PF	operation,
 	void *		arg);
 
-extern void xlv_for_each_ve_in_vol (
+extern void xlv_for_each_ve_in_vol(
 	xlv_oref_t *	oref,
 	XLV_OREF_PF	operation,
 	void *		arg);
 
-extern int xlv_for_each_ve_in_subvol (
+extern int xlv_for_each_ve_in_subvol(
 	xlv_oref_t *	oref,
 	XLV_OREF_PF	operation,
 	void *		arg);
 
-extern int xlv_for_each_ve_in_plex (
+extern int xlv_for_each_ve_in_plex(
 	xlv_oref_t *	oref,
 	XLV_OREF_PF	operation,
 	void *		arg);
@@ -326,7 +326,7 @@ extern int xlv_for_each_ve_in_plex (
  *	Returns 1 if the oref is a null reference; i.e., it has just
  *	been XLV_OREF_INIT'ed and no new fields have been set.
  */
-extern int xlv_oref_is_null (xlv_oref_t *oref);
+extern int xlv_oref_is_null(xlv_oref_t *oref);
 #endif /* NOTDEF */
 
 
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index e958b51..d8873b9 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -63,11 +63,11 @@
 #define INVLOCK(fd, m)  flock(fd, m)
 
 /* return values */
-#define INV_OK                  (int) 1
-#define INV_ERR                 (int) -1
+#define INV_OK                  (int)1
+#define INV_ERR                 (int)-1
 
-#define I_DONE                  (int) -1
-#define I_EMPTYINV              (int) -2
+#define I_DONE                  (int)-1
+#define I_EMPTYINV              (int)-2
 
 /* flags to oref_resolve_new_stobj() */
 #define IS_EMPTY                BOOL_TRUE
@@ -77,22 +77,22 @@
 
 #define IS_WITHIN(ttpe, tm)     (tm >= (ttpe)->tp_start && \
 				 tm <= (ttpe)->tp_end)
-#define IDX_HDR_OFFSET(n)       (off64_t) (sizeof(invt_entry_t) * \
-					   (size_t) (n) \
-					   + sizeof(invt_counter_t) )
-#define STOBJ_OFFSET(nhdrs, nsess) (off64_t) ( \
+#define IDX_HDR_OFFSET(n)       (off64_t)(sizeof(invt_entry_t) * \
+					  (size_t)(n) \
+					  + sizeof(invt_counter_t))
+#define STOBJ_OFFSET(nhdrs, nsess) (off64_t)( \
 		sizeof(invt_sescounter_t) + \
-		(size_t) nhdrs * sizeof(invt_seshdr_t) + \
-		(size_t) nsess * sizeof(invt_session_t) )
+		(size_t)nhdrs * sizeof(invt_seshdr_t) + \
+		(size_t)nsess * sizeof(invt_session_t))
 
 #define STREQL(n, m)            (strcmp((n), (m)) == 0)
 #define UUID_EQL(n, m, t)       (uuid_compare(n, m, t) == 0)
 #define IS_PARTIAL_SESSION(h) ((h)->sh_flag & INVT_PARTIAL)
 #define IS_RESUMED_SESSION(h) ((h)->sh_flag & INVT_RESUMED)
-#define SC_EOF_INITIAL_POS      (off64_t) (sizeof(invt_sescounter_t) + \
-					   INVT_STOBJ_MAXSESSIONS * \
-					   (sizeof(invt_seshdr_t) + \
-					    sizeof(invt_session_t) ))
+#define SC_EOF_INITIAL_POS      (off64_t)(sizeof(invt_sescounter_t) + \
+					  INVT_STOBJ_MAXSESSIONS * \
+					  (sizeof(invt_seshdr_t) + \
+					   sizeof(invt_session_t)))
 
 #define INV_PERROR(s)   mlog(MLOG_NORMAL, "INV: %s %s\n", s, strerror(errno))
 #define INV_OFLAG(f)    (f == INV_SEARCH_ONLY) ? O_RDONLY : O_RDWR
@@ -324,18 +324,18 @@ typedef bool_t (*search_callback_t) (int, invt_seshdr_t *, void *, void *);
 
 #define PUT_COUNTERS(fd, cnt) PUT_REC_NOLOCK(fd, (void *)(cnt), \
 					     sizeof(invt_counter_t), \
-					     (off64_t) 0)
+					     (off64_t)0)
 
 #define PUT_SESCOUNTERS(fd, cnt)  PUT_REC_NOLOCK(fd, (void *)(cnt), \
 						 sizeof(invt_sescounter_t), \
-						 (off64_t) 0)
+						 (off64_t)0)
 
-#define GET_SESHEADERS(fd, hdrs, n) get_headers(fd, (void**)(hdrs), \
-						(size_t) (n * sizeof(invt_seshdr_t) ), \
-						sizeof(invt_sescounter_t)  )
+#define GET_SESHEADERS(fd, hdrs, n) get_headers(fd, (void **)(hdrs), \
+						(size_t)(n * sizeof(invt_seshdr_t)), \
+						sizeof(invt_sescounter_t))
 
-#define GET_ENTRIES(fd, hdrs, n, sz) get_headers(fd, (void**)(hdrs), \
-						 (size_t) (n * sz), sizeof(invt_counter_t))
+#define GET_ENTRIES(fd, hdrs, n, sz) get_headers(fd, (void **)(hdrs), \
+						 (size_t)(n * sz), sizeof(invt_counter_t))
 
 /*----------------------------------------------------------------------*/
 /* Function Prototypes							*/
@@ -375,7 +375,7 @@ int
 idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num);
 
 int
-idx_DEBUG_print (int fd);
+idx_DEBUG_print(int fd);
 
 /*----------------------------------------------------------------------*/
 
@@ -425,7 +425,7 @@ stobj_delete_mfile(int fd, inv_stream_t *strm, invt_mediafile_t *mf,
 
 bool_t
 stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
-		    void  **bufpp, size_t *bufszp);
+		    void **bufpp, size_t *bufszp);
 
 bool_t
 stobj_unpack_sessinfo(
@@ -442,7 +442,7 @@ stobj_delete_mobj(int fd, invt_seshdr_t *hdr, void *arg,
 		  void **buf);
 
 int
-stobj_get_sessinfo (inv_sestoken_t tok, invt_seshdr_t *hdr, invt_session_t *ses);
+stobj_get_sessinfo(inv_sestoken_t tok, invt_seshdr_t *hdr, invt_session_t *ses);
 
 void
 stobj_makefname(char *fname);
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 2d1227c..5db757c 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -66,29 +66,29 @@ stobj_insert_session(invt_idxinfo_t *	idx,
 	if (sescnt->ic_curnum > 0) {
 		uint i;
 		invt_session_t *sessions = calloc(sescnt->ic_curnum,
-						  sizeof(invt_session_t) );
+						  sizeof(invt_session_t));
 		if (GET_REC_NOLOCK(fd, sessions, sescnt->ic_curnum *
 				   sizeof(invt_session_t),
-				   (off64_t) (sizeof(*sescnt) +
-					      sescnt->ic_maxnum * sizeof(invt_seshdr_t))) < 0) {
-			free (sescnt);
-			free (sessions);
+				   (off64_t)(sizeof(*sescnt) +
+					     sescnt->ic_maxnum * sizeof(invt_seshdr_t))) < 0) {
+			free(sescnt);
+			free(sessions);
 			return -1;
 		}
 
-		for (i = 0; i <  sescnt->ic_curnum; i++) {
+		for (i = 0; i < sescnt->ic_curnum; i++) {
 			if (uuid_compare(sessions[i].s_sesid,
 					 s->ses->s_sesid) == 0)
 				break;
 
 		}
-		free (sessions);
+		free(sessions);
 		if (i < sescnt->ic_curnum) {
 			mlog(MLOG_DEBUG | MLOG_INV,
 			     "INV: attempt to insert an "
 			     "existing session.\n"
 			     );
-			free (sescnt);
+			free(sescnt);
 			return 1;
 		}
 
@@ -106,11 +106,11 @@ stobj_insert_session(invt_idxinfo_t *	idx,
 
 	if (stobj_put_session(fd, sescnt, s->ses, s->seshdr, s->strms,
 			      s->mfiles) < 0) {
-		free (sescnt);
+		free(sescnt);
 		return -1;
 	}
 
-	free (sescnt);
+	free(sescnt);
 	return 1;
 }
 
@@ -130,12 +130,12 @@ stobj_find_splitpoint(int fd, invt_seshdr_t *harr, uint ns, time32_t tm)
 {
 	uint i;
 
-	if (harr[ns-1].sh_time < tm)
+	if (harr[ns - 1].sh_time < tm)
 		return ns;
 	/* since ns > 1, our split point > 0  */
 	for (i = ns - 1; i > 0; i--) {
 		/* these are ordered in ascending order */
-		if (harr[i].sh_time > harr[i-1].sh_time)
+		if (harr[i].sh_time > harr[i - 1].sh_time)
 			return i;
 	}
 
@@ -180,7 +180,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	assert(harr != NULL);
 
 	if ((ix = stobj_find_splitpoint(fd, harr, ns,
-					newsess->seshdr->sh_time) ) == 0)
+					newsess->seshdr->sh_time)) == 0)
 		return -1;
 
 	if (ix == ns) {
@@ -189,7 +189,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	} else {
 		ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end =
 			harr[ix].sh_time;
-		if (harr[ix - 1].sh_time >  newsess->seshdr->sh_time)
+		if (harr[ix - 1].sh_time > newsess->seshdr->sh_time)
 			idx->iarr[idx->index].ie_timeperiod.tp_end
 				= harr[ix - 1].sh_time;
 		else
@@ -243,7 +243,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 		/*
 		 * Now we need to put this in the new StObj. So, first
 		   unpack it. */
-		if (! stobj_unpack_sessinfo(bufpp, bufszp, &sesinfo) )
+		if (! stobj_unpack_sessinfo(bufpp, bufszp, &sesinfo))
 			return -1;
 
 		/* There is no chance of a recursion here */
@@ -253,7 +253,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 
 		/* Now delete that session from this StObj */
 		if (! stobj_delete_sessinfo(fd, sescnt, &session,
-					   &harr[i]) )
+					   &harr[i]))
 			return -1;
 		free(bufpp);
 	}
@@ -264,7 +264,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	   disk */
 	if (stobj_put_session(fd, sescnt, newsess->ses, newsess->seshdr,
 			      newsess->strms, newsess->mfiles) < 0) {
-		free (sescnt);
+		free(sescnt);
 		return -1;
 	}
 
@@ -327,7 +327,7 @@ stobj_put_session(
 	off64_t hoff;
 
 	/* figure out the place where the header will go */
-	hoff =  STOBJ_OFFSET(sescnt->ic_curnum, 0);
+	hoff = STOBJ_OFFSET(sescnt->ic_curnum, 0);
 
 	/* figure out where the session information is going to go. */
 	if (hdr->sh_sess_off < 0)
@@ -336,10 +336,10 @@ stobj_put_session(
 	sescnt->ic_curnum++;
 
 #ifdef INVT_DEBUG
-	mlog (MLOG_VERBOSE,
-	      "INV: create sess #%d @ offset %d ic_eof = %d\n",
-	      sescnt->ic_curnum, (int) hdr->sh_sess_off,
-	      (int) sescnt->ic_eof);
+	mlog(MLOG_VERBOSE,
+	     "INV: create sess #%d @ offset %d ic_eof = %d\n",
+	     sescnt->ic_curnum, (int)hdr->sh_sess_off,
+	     (int)sescnt->ic_eof);
 #endif
 
 	/*
@@ -349,14 +349,14 @@ stobj_put_session(
 
 	if (strms == NULL) {
 		sescnt->ic_eof += (off64_t)(ses->s_max_nstreams *
-					    sizeof(invt_stream_t) );
+					    sizeof(invt_stream_t));
 	} else {
 		uint i;
 		size_t nmf = 0;
 		sescnt->ic_eof += (off64_t)(ses->s_cur_nstreams *
-					    sizeof(invt_stream_t) );
-		for (i=0; i<ses->s_cur_nstreams; i++)
-			nmf += (size_t) strms[i].st_nmediafiles;
+					    sizeof(invt_stream_t));
+		for (i = 0; i < ses->s_cur_nstreams; i++)
+			nmf += (size_t)strms[i].st_nmediafiles;
 
 		sescnt->ic_eof += (off64_t)(sizeof(invt_mediafile_t)
 					    * nmf);
@@ -408,29 +408,29 @@ stobj_sortheaders(int fd, uint num)
 	hdrs = malloc(sz);
 	assert(hdrs);
 
-	if (GET_REC_NOLOCK(fd, hdrs, sz, STOBJ_OFFSET(0, 0) ) < 0) {
-		free (hdrs);
+	if (GET_REC_NOLOCK(fd, hdrs, sz, STOBJ_OFFSET(0, 0)) < 0) {
+		free(hdrs);
 		return -1;
 	}
 #ifdef INVT_DEBUG
 	printf("\nBEF\n");
-	for (i=0; i<(int)num; i++)
-		printf("%ld\n", (long) hdrs[i].sh_time);
+	for (i = 0; i < (int)num; i++)
+		printf("%ld\n", (long)hdrs[i].sh_time);
 #endif
-	qsort((void*) hdrs, (size_t) num,
+	qsort((void *)hdrs, (size_t)num,
 	      sizeof(invt_seshdr_t), stobj_hdrcmp);
 
 #ifdef INVT_DEBUG
 	printf("\n\nAFT\n");
-	for (i=0; i<(int)num; i++)
-		printf("%ld\n", (long) hdrs[i].sh_time);
+	for (i = 0; i < (int)num; i++)
+		printf("%ld\n", (long)hdrs[i].sh_time);
 #endif
-	if (PUT_REC_NOLOCK(fd, hdrs, sz, STOBJ_OFFSET(0, 0) ) < 0) {
-		free (hdrs);
+	if (PUT_REC_NOLOCK(fd, hdrs, sz, STOBJ_OFFSET(0, 0)) < 0) {
+		free(hdrs);
 		return -1;
 	}
 
-	free (hdrs);
+	free(hdrs);
 	return 1;
 
 }
@@ -452,14 +452,14 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 {
 	uint nstm = ses->s_cur_nstreams;
 	off64_t off = hdr->sh_streams_off;
-	off64_t mfileoff = off + (off64_t)(nstm * sizeof(invt_stream_t) );
+	off64_t mfileoff = off + (off64_t)(nstm * sizeof(invt_stream_t));
 	uint nmfiles = 0;
 	uint i, j;
 
 	/* fix the offsets in streams */
 	for (i = 0; i < nstm; i++) {
 		strms[i].st_firstmfile = mfileoff +
-					 (off64_t) ((size_t) nmfiles * sizeof(invt_mediafile_t) );
+					 (off64_t)((size_t)nmfiles * sizeof(invt_mediafile_t));
 		/* now fix the offsets in mediafiles */
 		for (j = 0; j < strms[i].st_nmediafiles; j++) {
 
@@ -467,13 +467,13 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 			if (j < strms[i].st_nmediafiles - 1)
 				mfiles[nmfiles + j].mf_nextmf =
 					strms[i].st_firstmfile +
-					(off64_t) ((j+1) * sizeof(invt_mediafile_t));
+					(off64_t)((j + 1) * sizeof(invt_mediafile_t));
 
 			/* no need to fix the first element's prev ptr */
 			if (j)
 				mfiles[nmfiles + j].mf_prevmf =
 					strms[i].st_firstmfile +
-					(off64_t) ((j-1) * sizeof(invt_mediafile_t));
+					(off64_t)((j - 1) * sizeof(invt_mediafile_t));
 		}
 
 		/*
@@ -522,7 +522,7 @@ stobj_makefname(char *fname)
 	strcat(fname, str);
 	strcat(fname, INV_STOBJ_PREFIX);
 
-	assert((int) strlen(fname) < INV_STRLEN);
+	assert((int)strlen(fname) < INV_STRLEN);
 }
 
 
@@ -544,8 +544,8 @@ stobj_create(char *fname)
 #endif
 
 	/* create the new storage object */
-	if ((fd = open(fname, INV_OFLAG(forwhat) | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
-		INV_PERROR (fname);
+	if ((fd = open(fname, INV_OFLAG(forwhat) | O_EXCL | O_CREAT, S_IRUSR | S_IWUSR)) < 0) {
+		INV_PERROR(fname);
 		memset(fname, 0, INV_STRLEN);
 		return -1;
 	}
@@ -558,7 +558,7 @@ stobj_create(char *fname)
 	sescnt.ic_maxnum = INVT_STOBJ_MAXSESSIONS;
 	sescnt.ic_eof = SC_EOF_INITIAL_POS;
 
-	if (PUT_SESCOUNTERS (fd, &sescnt) < 0) {
+	if (PUT_SESCOUNTERS(fd, &sescnt) < 0) {
 		memset(fname, 0, INV_STRLEN);
 		INVLOCK(fd, LOCK_UN);
 		close(fd);
@@ -619,7 +619,7 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 	invt_sescounter_t *sescnt = NULL;
 	invt_stream_t stream;
 	inv_sestoken_t sestok = tok->md_sesstok;
-	int fd =  sestok->sd_invtok->d_stobj_fd;
+	int fd = sestok->sd_invtok->d_stobj_fd;
 	off64_t pos;
 
 	/*
@@ -632,7 +632,7 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 	pos = sescnt->ic_eof;
 
 	/* increment the pointer to give space for this media file */
-	sescnt->ic_eof += (off64_t) sizeof(invt_mediafile_t);
+	sescnt->ic_eof += (off64_t)sizeof(invt_mediafile_t);
 
 	if (PUT_SESCOUNTERS(fd, sescnt) < 0)
 		return -1;
@@ -659,8 +659,8 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 
 	stream.st_nmediafiles++;
 #ifdef INVT_DEBUG
-	mlog (MLOG_VERBOSE, "#################### mediafile #%d "
-	      "###################\n", stream.st_nmediafiles);
+	mlog(MLOG_VERBOSE, "#################### mediafile #%d "
+	     "###################\n", stream.st_nmediafiles);
 #endif
 	/* add the new mediafile at the tail of the list */
 
@@ -687,7 +687,7 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 		rval = PUT_REC_NOLOCK(fd, tok->md_lastmfile,
 				      sizeof(invt_mediafile_t),
 				      mf->mf_prevmf);
-		free (tok->md_lastmfile);
+		free(tok->md_lastmfile);
 		if (rval < 0)
 			return -1;
 	}
@@ -722,15 +722,15 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 /*----------------------------------------------------------------------*/
 
 int
-stobj_get_sessinfo (inv_sestoken_t tok, invt_seshdr_t *hdr,
-		    invt_session_t *ses)
+stobj_get_sessinfo(inv_sestoken_t tok, invt_seshdr_t *hdr,
+		   invt_session_t *ses)
 {
 	int rval;
 	int fd = tok->sd_invtok->d_stobj_fd;
 
 	/* get the session header first */
 	if ((rval = GET_REC_NOLOCK(fd, hdr, sizeof(invt_seshdr_t),
-				   tok->sd_sesshdr_off) ) > 0) {
+				   tok->sd_sesshdr_off)) > 0) {
 		rval = GET_REC_NOLOCK(fd, ses, sizeof(invt_session_t),
 				      tok->sd_session_off);
 	}
@@ -748,7 +748,7 @@ stobj_get_sessinfo (inv_sestoken_t tok, invt_seshdr_t *hdr,
 
 bool_t
 stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
-		    void  **bufpp, size_t *bufszp)
+		    void **bufpp, size_t *bufszp)
 {
 	size_t stmsz;
 	uint i, j;
@@ -767,15 +767,15 @@ stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 		sizeof(invt_session_t) + sizeof(invt_seshdr_t) + stmsz;
 
 	/* now get all the streams of this session */
-	strms = calloc (ses->s_cur_nstreams, sizeof(invt_stream_t) );
+	strms = calloc(ses->s_cur_nstreams, sizeof(invt_stream_t));
 	if (GET_REC_NOLOCK(fd, strms, stmsz, hdr->sh_streams_off) < 0) {
-		free (strms);
+		free(strms);
 		return BOOL_FALSE;
 	}
 
 	for (i = 0; i < ses->s_cur_nstreams; i++)
 		sessz += sizeof(invt_mediafile_t) *
-			 (size_t) strms[i].st_nmediafiles;
+			 (size_t)strms[i].st_nmediafiles;
 
 	/* Now we know how big this entire thing is going to be */
 	sesbufcp = sesbuf = calloc(1, sessz);
@@ -791,7 +791,7 @@ stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 	 * magic cookie that we put for sanity checking in case of an
 	   earthquake or something :) */
 	strcpy(sesbuf, INVTSESS_COOKIE);
-	sesbuf += (size_t)(strlen(INVTSESS_COOKIE) * sizeof(char) );
+	sesbuf += (size_t)(strlen(INVTSESS_COOKIE) * sizeof(char));
 
 	/*
 	 * This was originally INV_VERSION. Changed it to mean packed inventory
@@ -945,11 +945,11 @@ stobj_delete_mobj(int			fd,
 		return -1;
 
 	/* now get all the streams of this session */
-	strms = calloc (ses.s_cur_nstreams, sizeof(invt_stream_t) );
+	strms = calloc(ses.s_cur_nstreams, sizeof(invt_stream_t));
 	if (GET_REC_NOLOCK(fd, strms,
 			   sizeof(invt_stream_t) * ses.s_cur_nstreams,
 			   hdr->sh_streams_off) < 0) {
-		free (strms);
+		free(strms);
 		return BOOL_FALSE;
 	}
 
@@ -957,7 +957,7 @@ stobj_delete_mobj(int			fd,
 	for (i = 0; i < ses.s_cur_nstreams; i++) {
 		off = strms[i].st_firstmfile;
 		nmfiles = strms[i].st_nmediafiles;
-		mfiles = mf = calloc(nmfiles, sizeof(invt_mediafile_t) );
+		mfiles = mf = calloc(nmfiles, sizeof(invt_mediafile_t));
 		for (j = 0; j < nmfiles;
 		     j++,
 		     off = mf->mf_nextmf,
@@ -984,7 +984,7 @@ stobj_delete_mobj(int			fd,
 
 		for (j = 0; j < nmfiles; j++) {
 			mf = &mfiles[j];
-			if (! uuid_compare(mf->mf_moid, *moid) ) {
+			if (! uuid_compare(mf->mf_moid, *moid)) {
 #ifdef INVT_DEBUG
 				printf(" found one\n");
 #endif
@@ -1003,11 +1003,11 @@ stobj_delete_mobj(int			fd,
 			}
 
 		}
-		free (mfiles);
+		free(mfiles);
 		if (dirty);
 	}
 
-	free (strms);
+	free(strms);
 
 	return BOOL_FALSE; /* ret FALSE, or it'll stop iteration */
 }
@@ -1033,14 +1033,14 @@ stobj_unpack_sessinfo(
 	char *tmpbuf;
 	char *p = (char *)bufp;
 
-	assert (bufp);
+	assert(bufp);
 
 	tmpbuf = (char *)malloc(bufsz);
 
 	/*
 	 * first make sure that the magic cookie at the beginning is right.
 	   this isn't null-terminated */
-	if (strncmp(p, INVTSESS_COOKIE, strlen(INVTSESS_COOKIE) ) != 0) {
+	if (strncmp(p, INVTSESS_COOKIE, strlen(INVTSESS_COOKIE)) != 0) {
 		mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: inv_put_session: unknown cookie\n"));
 		return BOOL_FALSE;
@@ -1052,7 +1052,7 @@ stobj_unpack_sessinfo(
 	 * Check the packing version number. In version 1, this was the only version number.
 	 * see the comment in stobj_pack_sessinfo().
 	 */
-	if (INT_GET(*(inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_1) {
+	if (INT_GET(*(inv_version_t *)p, ARCH_CONVERT) == PACKED_INV_VERSION_1) {
 		char *temp_p;
 		size_t tempsz;
 
@@ -1076,7 +1076,7 @@ stobj_unpack_sessinfo(
 		temp_p = calloc(1, tempsz);
 		bcopy(p, temp_p, tempsz);
 		p = temp_p;
-	} else if (INT_GET(*(inv_version_t *) p, ARCH_CONVERT) == PACKED_INV_VERSION_2) {
+	} else if (INT_GET(*(inv_version_t *)p, ARCH_CONVERT) == PACKED_INV_VERSION_2) {
 		mlog(MLOG_DEBUG | MLOG_INV, "INV: packed inventory version = 2\n");
 
 		p += sizeof(inv_version_t);     /* skip the packed inventory version */
@@ -1085,7 +1085,7 @@ stobj_unpack_sessinfo(
 	} else {
 		mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: inv_put_session: unknown packed inventory version"
-			     " %d\n"), *(inv_version_t *) p);
+			     " %d\n"), *(inv_version_t *)p);
 		return BOOL_FALSE;
 	}
 
@@ -1099,7 +1099,7 @@ stobj_unpack_sessinfo(
 
 
 	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
-	bcopy (tmpbuf, p, sizeof(invt_session_t));
+	bcopy(tmpbuf, p, sizeof(invt_session_t));
 	s->ses = (invt_session_t *)p;
 	p += sizeof(invt_session_t);
 
@@ -1114,11 +1114,11 @@ stobj_unpack_sessinfo(
 
 #ifdef INVT_DELETION
 	{
-		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR);
+		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
 		uint j;
 		invt_mediafile_t *mmf = s->mfiles;
-		for (i=0; i< s->ses->s_cur_nstreams; i++) {
-			for (j=0; j< s->strms[i].st_nmediafiles;
+		for (i = 0; i < s->ses->s_cur_nstreams; i++) {
+			for (j = 0; j < s->strms[i].st_nmediafiles;
 			     j++, mmf++)
 				xlate_invt_mediafile((invt_mediafile_t *)mmf, (invt_mediafile_t *)tmpbuf, 1);
 			bcopy(tmpbuf, mmf, sizeof(invt_mediafile_t));
@@ -1129,19 +1129,19 @@ stobj_unpack_sessinfo(
 	}
 #endif
 	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
-		p += (size_t) (s->strms[i].st_nmediafiles)
+		p += (size_t)(s->strms[i].st_nmediafiles)
 		     * sizeof(invt_mediafile_t);
 	}
 
 	/*
 	 * sanity check the size of the buffer given to us vs. the size it
 	   should be */
-	if ((size_t) (p - (char *) bufp) != bufsz) {
+	if ((size_t)(p - (char *)bufp) != bufsz) {
 		mlog(MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d entsz %d\n",
-		     (int)(p - (char *) bufp), (int) bufsz,
-		     (int) (sizeof(invt_entry_t) ));
+		     (int)(p - (char *)bufp), (int)bufsz,
+		     (int)(sizeof(invt_entry_t)));
 	}
-	assert((size_t) (p - (char *) bufp) == bufsz);
+	assert((size_t)(p - (char *)bufp) == bufsz);
 
 	return BOOL_TRUE;
 }
@@ -1172,7 +1172,7 @@ void
 stobj_convert_mfile(inv_mediafile_t *expmf, invt_mediafile_t *mf)
 {
 	/* copy the mediafile into the exported structure */
-	memcpy(&expmf->m_moid, &mf->mf_moid, sizeof(uuid_t) );
+	memcpy(&expmf->m_moid, &mf->mf_moid, sizeof(uuid_t));
 	strcpy(expmf->m_label, mf->mf_label);
 	expmf->m_mfile_index = mf->mf_mfileidx;
 	expmf->m_startino = mf->mf_startino.ino;
@@ -1214,8 +1214,8 @@ stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
 	ises->s_ispartial = IS_PARTIAL_SESSION(hdr) ? BOOL_TRUE : BOOL_FALSE;
 	ises->s_isresumed = IS_RESUMED_SESSION(hdr) ? BOOL_TRUE : BOOL_FALSE;
 	ises->s_nstreams = ses->s_cur_nstreams;
-	memcpy(&ises->s_sesid, &ses->s_sesid, sizeof(uuid_t) );
-	memcpy(&ises->s_fsid, &ses->s_fsid, sizeof(uuid_t) );
+	memcpy(&ises->s_sesid, &ses->s_sesid, sizeof(uuid_t));
+	memcpy(&ises->s_fsid, &ses->s_fsid, sizeof(uuid_t));
 	strcpy(ises->s_mountpt, ses->s_mountpt);
 	strcpy(ises->s_devpath, ses->s_devpath);
 	strcpy(ises->s_label, ses->s_label);
@@ -1243,22 +1243,22 @@ stobj_copy_invsess(int			fd,
 	int i;
 	invt_mediafile_t mf;
 
-	strms = calloc (ses->s_cur_nstreams, sizeof(invt_stream_t) );
+	strms = calloc(ses->s_cur_nstreams, sizeof(invt_stream_t));
 
 	/* load in all the stream-headers */
 	if (GET_REC_NOLOCK(fd, strms,
 			   ses->s_cur_nstreams * sizeof(invt_stream_t),
 			   hdr->sh_streams_off) < 0) {
-		free (strms);
+		free(strms);
 		return -1;
 	}
 
-	ises = calloc(1, sizeof(inv_session_t) );
+	ises = calloc(1, sizeof(inv_session_t));
 	stobj_convert_session(ises, ses, hdr);
 	ises->s_streams = calloc(ses->s_cur_nstreams, sizeof(inv_stream_t));
 
 	/* fill in the stream structures too */
-	i = (int) ses->s_cur_nstreams;
+	i = (int)ses->s_cur_nstreams;
 	while (i--) {
 		off64_t off;
 		uint j, nmf;
@@ -1269,7 +1269,7 @@ stobj_copy_invsess(int			fd,
 
 		if (nmf)
 			ises->s_streams[i].st_mediafiles = calloc(nmf,
-								  sizeof(inv_mediafile_t) );
+								  sizeof(inv_mediafile_t));
 		assert(! nmf || ises->s_streams[i].st_mediafiles);
 
 		for (j = 0; j < nmf;
@@ -1322,17 +1322,17 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 	int nstreams;
 	invt_mediafile_t *mf;
 
-	ises = calloc(1, sizeof(inv_session_t) );
+	ises = calloc(1, sizeof(inv_session_t));
 
 	stobj_convert_session(ises, sinfo->ses, sinfo->seshdr);
-	ises->s_streams = calloc(ises->s_nstreams, sizeof(inv_stream_t) );
+	ises->s_streams = calloc(ises->s_nstreams, sizeof(inv_stream_t));
 	mf = sinfo->mfiles;
-	nstreams = (int) ises->s_nstreams;
+	nstreams = (int)ises->s_nstreams;
 	for (i = 0; i < nstreams; i++) {
 		stobj_convert_strm(&ises->s_streams[i], &sinfo->strms[i]);
-		nmf = (int) ises->s_streams[i].st_nmediafiles;
-		ises->s_streams[i].st_mediafiles = calloc((uint) nmf,
-							  sizeof(inv_mediafile_t) );
+		nmf = (int)ises->s_streams[i].st_nmediafiles;
+		ises->s_streams[i].st_mediafiles = calloc((uint)nmf,
+							  sizeof(inv_mediafile_t));
 
 		for (j = 0; j < nmf; j++) {
 			stobj_convert_mfile(&ises->s_streams[i].st_mediafiles[j],
@@ -1348,8 +1348,8 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 int
 stobj_hdrcmp(const void *h1, const void *h2)
 {
-	return (int) (((invt_seshdr_t *)h1)->sh_time -
-		      ((invt_seshdr_t *)h2)->sh_time);
+	return (int)(((invt_seshdr_t *)h1)->sh_time -
+		     ((invt_seshdr_t *)h2)->sh_time);
 }
 
 
@@ -1375,17 +1375,17 @@ DEBUG_sessprint(invt_session_t *ses)
 }
 
 bool_t
-mobj_eql (inv_mediafile_t *mfp, invt_mobjinfo_t *mobj)
+mobj_eql(inv_mediafile_t *mfp, invt_mobjinfo_t *mobj)
 {
 
 	if (mobj->type == INVT_MOID) {
-		if (! uuid_compare(*((uuid_t*) mobj->value),
+		if (! uuid_compare(*((uuid_t *)mobj->value),
 				  mfp->m_moid)) {
 			return BOOL_TRUE;
 		}
 	} else {
-		if (STREQL((char*) mobj->value,
-			   mfp->m_label) ) {
+		if (STREQL((char *)mobj->value,
+			   mfp->m_label)) {
 			return BOOL_TRUE;
 		}
 	}
@@ -1395,13 +1395,13 @@ mobj_eql (inv_mediafile_t *mfp, invt_mobjinfo_t *mobj)
 
 
 bool_t
-check_for_mobj (inv_session_t *ses, invt_mobjinfo_t *mobj)
+check_for_mobj(inv_session_t *ses, invt_mobjinfo_t *mobj)
 {
 	int i;
 	uint j;
 	inv_mediafile_t *mfp;
 
-	for (i = 0; i < (int) ses->s_nstreams; i++) {
+	for (i = 0; i < (int)ses->s_nstreams; i++) {
 		for (j = 0; j < ses->s_streams[i].st_nmediafiles; j++) {
 			mfp = &ses->s_streams[i].st_mediafiles[j];
 			if (mobj_eql(mfp, mobj))
@@ -1427,12 +1427,12 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 
 	bool_t moidsearch = (mobj && mobj->type != INVT_NULLTYPE);
 	if (moidsearch) {
-		if (! check_for_mobj (ses, mobj))
+		if (! check_for_mobj(ses, mobj))
 			return;
 	}
 
-	if (ref == 0 || fsidxprinted != (uint) prctx->index) {
-		fsidxprinted = (uint) prctx->index;
+	if (ref == 0 || fsidxprinted != (uint)prctx->index) {
+		fsidxprinted = (uint)prctx->index;
 
 		printf("file system %d:\n", prctx->index);
 		uuid_unparse(ses->s_fsid, str);
@@ -1460,7 +1460,7 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 	if (prctx->depth == PR_SESSONLY)
 		return;
 
-	for (i = 0; i < (int) ses->s_nstreams; i++) {
+	for (i = 0; i < (int)ses->s_nstreams; i++) {
 		uint j;
 		printf("\t\tstream %d:\n", i);
 		printf("\t\t\tpathname:\t%s\n", ses->s_streams[i].st_cmdarg);
@@ -1481,7 +1481,7 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 		for (j = 0; j < ses->s_streams[i].st_nmediafiles; j++) {
 			mfp = &ses->s_streams[i].st_mediafiles[j];
 			if (moidsearch) {
-				if (! mobj_eql(mfp, mobj) )
+				if (! mobj_eql(mfp, mobj))
 					continue;
 			}
 			printf("\t\t\tmedia file %d:", j);
diff --git a/inventory/inventory.h b/inventory/inventory.h
index 728e104..d7a8726 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -49,15 +49,15 @@ typedef uint32_t inv_version_t;
 /*
  * This is the general inventory version.
  */
-#define INV_VERSION             (inv_version_t) 1
+#define INV_VERSION             (inv_version_t)1
 
 /*
  * This is the version of the on-tape (packed) inventory.
  * version 2 has an extra inv_version_t in it to make everything
  * 64 bit aligned.
  */
-#define PACKED_INV_VERSION_1    (inv_version_t) 1
-#define PACKED_INV_VERSION_2    (inv_version_t) 2
+#define PACKED_INV_VERSION_1    (inv_version_t)1
+#define PACKED_INV_VERSION_2    (inv_version_t)2
 #define PACKED_INV_VERSION      PACKED_INV_VERSION_2
 
 /* Print [-I] suboption -depth */
@@ -179,9 +179,9 @@ struct invt_sesdesc_entry;
 struct invt_strdesc_entry;
 
 /* The three kinds of access tokens for the inventory */
-typedef struct invt_desc_entry          *inv_idbtoken_t;
-typedef struct invt_sesdesc_entry       *inv_sestoken_t;
-typedef struct invt_strdesc_entry       *inv_stmtoken_t;
+typedef struct invt_desc_entry *inv_idbtoken_t;
+typedef struct invt_sesdesc_entry *inv_sestoken_t;
+typedef struct invt_strdesc_entry *inv_stmtoken_t;
 
 
 
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 0b6c822..7fabbfc 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -68,7 +68,7 @@ CREAT_mfiles(inv_stmtoken_t tok, uuid_t *moid, ino_t f, ino_t n)
 	uuid_create(&labelid, &stat);
 	uuid_to_string(&labelid, &str, &stat);
 	strncpy(strbuf, str, 8);
-	free (str);
+	free(str);
 	strbuf[8] = '\0';
 	sprintf(label, "%s_%s (%d-%d)\0", "MEDIA_FILE", strbuf, (int)f, (int)n);
 
@@ -95,7 +95,7 @@ recons_test(int howmany)
 
 	fd = open(sesfile, O_RDONLY);
 
-	for (i=0; i<howmany && i < SESLIM; i++) {
+	for (i = 0; i < howmany && i < SESLIM; i++) {
 		rval = get_invtrecord(fd, &sarr[i],
 				      sizeof(uuid_t) + sizeof(size_t), off,
 				      BOOL_FALSE);
@@ -111,7 +111,7 @@ recons_test(int howmany)
 
 
 
-	for (i=0; i<howmany && i < SESLIM; i++) {
+	for (i = 0; i < howmany && i < SESLIM; i++) {
 		if (inv_put_sessioninfo(sarr[i].buf, sarr[i].sz) < 0)
 			printf("$ insert failed.\n");
 	}
@@ -135,11 +135,11 @@ delete_test(int n)
 	fd = open("moids", O_RDONLY);
 	if (fd < 0) return -1;
 
-	get_invtrecord(fd, &moid, sizeof(uuid_t), (n-1)* sizeof(uuid_t), 0);
+	get_invtrecord(fd, &moid, sizeof(uuid_t), (n - 1) * sizeof(uuid_t), 0);
 	uuid_to_string(&moid, &str, &stat);
 	printf("Searching for Moid = %s\n", str);
 	free(str);
-	if (! inv_delete_mediaobj(&moid) ) return -1;
+	if (! inv_delete_mediaobj(&moid)) return -1;
 
 	return 1;
 
@@ -153,7 +153,7 @@ sess_queries_byuuid(char *uu)
 	inv_session_t *ses;
 	invt_pr_ctx_t prctx;
 
-	uuid_from_string (uu, &uuid, &stat);
+	uuid_from_string(uu, &uuid, &stat);
 	printf("uuid = %s\n", uu);
 	if (inv_get_session_byuuid(&uuid, &ses)) {
 		if (! ses)
@@ -205,14 +205,14 @@ query_test(int level)
 		printf("mount pt %s\n", sesfile);
 		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, sesfile);
 		if (! tok) return -1;
-		idx_DEBUG_print (tok->d_invindex_fd);
+		idx_DEBUG_print(tok->d_invindex_fd);
 		return 1;
 	}
 
-	for (i = 7; i<8; i++) {
+	for (i = 7; i < 8; i++) {
 		printf("\n\n\n----------------------------------\n"
-		       "$ Searching fs %s\n", mnt_str[7-i]);
-		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, mnt_str[7-i]);
+		       "$ Searching fs %s\n", mnt_str[7 - i]);
+		tok = inv_open(INV_BY_MOUNTPT, INV_SEARCH_ONLY, mnt_str[7 - i]);
 		if (! tok) return -1;
 
 		prctx.index = i;
@@ -220,20 +220,20 @@ query_test(int level)
 			invmgr_inv_print(tok->d_invindex_fd, &prctx);
 		else {
 			if (inv_lasttime_level_lessthan(tok, level, &tm) && tm) {
-				printf("\n\nTIME %s %ld\n", ctime(tm), (long) *tm);
-				free (tm);
+				printf("\n\nTIME %s %ld\n", ctime(tm), (long)*tm);
+				free(tm);
 			}
 			if (inv_lastsession_level_lessthan(tok, level, &ses) && ses) {
 				DEBUG_sessionprint(ses, 99, &prctx);
-				free (ses->s_streams);
-				free (ses);
+				free(ses->s_streams);
+				free(ses);
 			}
 
 			if (inv_lastsession_level_equalto(tok, level, &ses) && ses) {
 				printf("Gotcha\n");
 				DEBUG_sessionprint(ses, 99, &prctx);
-				free (ses->s_streams);
-				free (ses);
+				free(ses->s_streams);
+				free(ses);
 			}
 		}
 		inv_close(tok);
@@ -273,20 +273,20 @@ write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 
 #ifdef FIRSTTIME
 	printf("first time!\n");
-	for (i=0; i<8; i++) {
+	for (i = 0; i < 8; i++) {
 		uuid_create(&fsidarr[i], &stat);
-		assert (stat == uuid_s_ok);
+		assert(stat == uuid_s_ok);
 		uuid_create(&sesidarr[i], &stat);
-		assert (stat == uuid_s_ok);
+		assert(stat == uuid_s_ok);
 	}
 	fd = open("uuids", O_RDWR | O_CREAT);
-	PUT_REC(fd, (void *)fsidarr, sizeof (uuid_t) * 8, 0L);
-	PUT_REC(fd, (void *)sesidarr, sizeof (uuid_t) * 8, sizeof (uuid_t) * 8);
+	PUT_REC(fd, (void *)fsidarr, sizeof(uuid_t) * 8, 0L);
+	PUT_REC(fd, (void *)sesidarr, sizeof(uuid_t) * 8, sizeof(uuid_t) * 8);
 	close(fd);
 #endif
 	fd = open("uuids", O_RDONLY);
-	GET_REC(fd, fsidarr, sizeof (uuid_t) * 8, 0L);
-	GET_REC(fd, sesidarr, sizeof (uuid_t) * 8, sizeof (uuid_t) * 8);
+	GET_REC(fd, fsidarr, sizeof(uuid_t) * 8, 0L);
+	GET_REC(fd, sesidarr, sizeof(uuid_t) * 8, sizeof(uuid_t) * 8);
 	close(fd);
 #ifdef RECONS
 	rfd = open(sesfile, O_RDWR | O_CREAT);
@@ -306,31 +306,31 @@ write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 		dev = dev_str[7];
 		fsidp = &fsidarr[0]; /* j */
 		tok1 = inv_open(INV_BY_UUID, INV_SEARCH_N_MOD, fsidp);
-		assert (tok1 != INV_TOKEN_NULL);
+		assert(tok1 != INV_TOKEN_NULL);
 
 		uuid_create(&labelid, &stat);
 		uuid_to_string(&labelid, &str, &stat);
 		strncpy(strbuf, str, 8);
-		free (str);
+		free(str);
 		strbuf[8] = '\0';
 		sprintf(label, "%s_%s (%d)\0", "SESSION_LABEL", strbuf, i);
 
 		tok2 = inv_writesession_open(tok1, fsidp,
 					     &labelid,
 					     label,
-					     (bool_t)i%2,
-					     (bool_t)i%2,
+					     (bool_t)i % 2,
+					     (bool_t)i % 2,
 					     dumplevel, nstreams,
 					     time(NULL),
 					     mnt, dev);
-		assert (tok2 != INV_TOKEN_NULL);
-		for (m = 0; m<nstreams; m++) {
+		assert(tok2 != INV_TOKEN_NULL);
+		for (m = 0; m < nstreams; m++) {
 			tok3 = inv_stream_open(tok2, "/dev/rmt");
-			assert (tok3 != INV_TOKEN_NULL);
+			assert(tok3 != INV_TOKEN_NULL);
 
-			for (k = 0; k<nmedia; k++)
-				CREAT_mfiles(tok3, &labelid, k*100,
-					     k*100 + 99);
+			for (k = 0; k < nmedia; k++)
+				CREAT_mfiles(tok3, &labelid, k * 100,
+					     k * 100 + 99);
 			inv_stream_close(tok3, BOOL_TRUE);
 		}
 
@@ -372,25 +372,25 @@ mp_test(int nstreams)
 {
 #if 0
 	tok1 = inv_open(INV_BY_UUID, fsidp);
-	assert (tok1 != INV_TOKEN_NULL);
+	assert(tok1 != INV_TOKEN_NULL);
 
 	tok2 = inv_writesession_open(tok1, fsidp,
 				     &labelid,
 				     label,
-				     (bool_t)i%2,
-				     (bool_t)i%2,
+				     (bool_t)i % 2,
+				     (bool_t)i % 2,
 				     dumplevel, nstreams,
 				     time(NULL),
 				     mnt, dev);
-	assert (tok2 != INV_TOKEN_NULL);
+	assert(tok2 != INV_TOKEN_NULL);
 
-	for (m = 0; m<nstreams; m++) {
+	for (m = 0; m < nstreams; m++) {
 		tok3 = inv_stream_open(tok2, "/dev/rmt");
-		assert (tok3 != INV_TOKEN_NULL);
+		assert(tok3 != INV_TOKEN_NULL);
 
-		for (k = 0; k<nmedia; k++)
-			CREAT_mfiles(tok3, &labelid, k*100,
-				     k*100 + 99);
+		for (k = 0; k < nmedia; k++)
+			CREAT_mfiles(tok3, &labelid, k * 100,
+				     k * 100 + 99);
 		inv_stream_close(tok3, BOOL_TRUE);
 	}
 #endif
@@ -499,7 +499,7 @@ main(int argc, char *argv[])
 	else if (op == DEL)
 		rval = delete_test(nsess);
 	else if (op == MP)
-		rval = mp_test (nstreams);
+		rval = mp_test(nstreams);
 	else if (op == QUE2) {
 		if (uuid)
 			rval = sess_queries_byuuid(uuid);
diff --git a/invutil/cmenu.h b/invutil/cmenu.h
index 5da537e..5b6217b 100644
--- a/invutil/cmenu.h
+++ b/invutil/cmenu.h
@@ -32,7 +32,7 @@
 	beep(); \
 	wrefresh(stdscr); \
 	sleep(2)
-#define put_info_header(m)      put_line(infowin, 0, m, A_REVERSE|A_BOLD, ALIGN_LEFT)
+#define put_info_header(m)      put_line(infowin, 0, m, A_REVERSE | A_BOLD, ALIGN_LEFT)
 #define put_info_line(l, m)     put_line(infowin, l, m, 0, ALIGN_LEFT)
 #define put_option(w, l, t, a)  put_line(w, l, t, a, ALIGN_LEFT)
 #define clear_line(w, l)                wmove(w, l, 0); wclrtoeol(w);
diff --git a/invutil/fstab.c b/invutil/fstab.c
index 745f677..0052f9d 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -225,7 +225,7 @@ add_fstab_data(int fidx, invt_fstab_t *data)
 }
 
 node_t *
-generate_fstab_menu(char * inv_path, node_t *startnode, int level, char *fstabname)
+generate_fstab_menu(char *inv_path, node_t *startnode, int level, char *fstabname)
 {
 	int i;
 	char *invname;
@@ -242,7 +242,7 @@ generate_fstab_menu(char * inv_path, node_t *startnode, int level, char *fstabna
 	fstab_entry = (invt_fstab_t *)(fstab_file[idx].mapaddr + sizeof(invt_counter_t));
 
 	n = startnode;
-	for (i=0; i < fstab_file[idx].counter->ic_curnum; i++) {
+	for (i = 0; i < fstab_file[idx].counter->ic_curnum; i++) {
 		len = strlen(fstab_entry[i].ft_mountpt) + strlen(fstab_entry[i].ft_devpath) + 40;
 		txt = malloc(len);
 		if (txt == NULL) {
@@ -374,7 +374,7 @@ remmap_fstab(int fidx, int num)
 
 	/* regenerate the data index for the file given the new mapping */
 	fstab_entry = (invt_fstab_t *)(fstab_file[fidx].mapaddr + sizeof(invt_counter_t));
-	for (i=0; i < nEntries; i++) {
+	for (i = 0; i < nEntries; i++) {
 		if (i >= fstab_file[fidx].numrecords) {
 			add_fstab_data(fidx, &(fstab_entry[i]));
 		}
@@ -429,7 +429,7 @@ close_fstab(int fidx)
 	munmap(fstab_file[fidx].mapaddr,
 	       (fstab_file[fidx].counter->ic_curnum * sizeof(invt_fstab_t)) + sizeof(invt_counter_t));
 
-	if ((fstabentries != 0)  && (fstabentries < fstab_file[fidx].nEntries)) {
+	if ((fstabentries != 0) && (fstabentries < fstab_file[fidx].nEntries)) {
 		ftruncate(fstab_file[fidx].fd,
 			  sizeof(invt_counter_t) + (sizeof(invt_fstab_t) * fstabentries));
 	}
diff --git a/invutil/invidx.c b/invutil/invidx.c
index b19cb6e..a641f09 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -99,7 +99,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 				&inv_entry[idx + 1],
 				(sizeof(invt_entry_t) * (invidx_file[fidx].counter->ic_curnum - idx - 1)));
 
-			invidx_file[fidx].data[idx]=NULL;
+			invidx_file[fidx].data[idx] = NULL;
 			for (i = idx + 1; i < invidx_file[fidx].numrecords; i++) {
 				if (invidx_file[fidx].data[i] != NULL)
 					invidx_file[fidx].data[i]--;
@@ -283,7 +283,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 				return 0;
 			}
 
-			new_fd = open(dst_idxfile, O_CREAT|O_RDWR, S_IRUSR|S_IWUSR);
+			new_fd = open(dst_idxfile, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
 			if (new_fd < 0) {
 				put_error("Error: unable to open inventory index file");
 				return 0;
@@ -603,7 +603,7 @@ stobj_create(char *fname)
 	invt_sescounter_t sescnt;
 
 	/* create the new storage object */
-	if ((fd = open(fname, O_RDWR | O_EXCL | O_CREAT, S_IRUSR|S_IWUSR)) < 0) {
+	if ((fd = open(fname, O_RDWR | O_EXCL | O_CREAT, S_IRUSR | S_IWUSR)) < 0) {
 		return -1;
 	}
 
@@ -617,7 +617,7 @@ stobj_create(char *fname)
 	sescnt.ic_eof = SC_EOF_INITIAL_POS;
 
 	lseek(fd, 0, SEEK_SET);
-	write_n_bytes (fd, (char *)&sescnt, sizeof(sescnt), "new stobj file");
+	write_n_bytes(fd, (char *)&sescnt, sizeof(sescnt), "new stobj file");
 
 	INVLOCK(fd, LOCK_UN);
 	return fd;
@@ -630,23 +630,23 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 {
 	uint nstm = ses->s_cur_nstreams;
 	off64_t off = hdr->sh_streams_off;
-	off64_t mfileoff= off + (off64_t)(nstm * sizeof(invt_stream_t) );
+	off64_t mfileoff = off + (off64_t)(nstm * sizeof(invt_stream_t));
 	uint nmfiles = 0;
 	uint i, j;
 
 	/* fix the offsets in streams */
 	for (i = 0; i < nstm; i++) {
-		strms[i].st_firstmfile = mfileoff + (off64_t) ((size_t) nmfiles * sizeof(invt_mediafile_t) );
+		strms[i].st_firstmfile = mfileoff + (off64_t)((size_t)nmfiles * sizeof(invt_mediafile_t));
 		/* now fix the offsets in mediafiles */
 		for (j = 0; j < strms[i].st_nmediafiles; j++) {
 
 			/* no need to fix the last element's next ptr */
 			if (j < strms[i].st_nmediafiles - 1)
-				mfiles[nmfiles + j].mf_nextmf =  strms[i].st_firstmfile + (off64_t) ((j+1) * sizeof(invt_mediafile_t));
+				mfiles[nmfiles + j].mf_nextmf = strms[i].st_firstmfile + (off64_t)((j + 1) * sizeof(invt_mediafile_t));
 
 			/* no need to fix the first element's prev ptr */
 			if (j)
-				mfiles[nmfiles + j].mf_prevmf = strms[i].st_firstmfile + (off64_t) ((j-1) * sizeof(invt_mediafile_t));
+				mfiles[nmfiles + j].mf_prevmf = strms[i].st_firstmfile + (off64_t)((j - 1) * sizeof(invt_mediafile_t));
 		}
 
 		/*
@@ -833,7 +833,7 @@ find_invidx_insert_pos(int fidx, invt_entry_t *inv_entry)
 
 	for (i = 0; i < invidx_file[fidx].numrecords - 1; i++) {
 		entry = invidx_file[fidx].data[i];
-		next_entry = invidx_file[fidx].data[i+1];
+		next_entry = invidx_file[fidx].data[i + 1];
 
 		if (inv_entry->ie_timeperiod.tp_start > entry->ie_timeperiod.tp_end
 		    && inv_entry->ie_timeperiod.tp_end < next_entry->ie_timeperiod.tp_start) {
@@ -904,7 +904,7 @@ add_invidx_data(int fidx, invt_entry_t *data)
 }
 
 node_t *
-generate_invidx_menu(char * inv_path, node_t *startnode, int level, char *idxFileName)
+generate_invidx_menu(char *inv_path, node_t *startnode, int level, char *idxFileName)
 {
 	int i;
 	int idx;
@@ -921,7 +921,7 @@ generate_invidx_menu(char * inv_path, node_t *startnode, int level, char *idxFil
 	invidx_entry = (invt_entry_t *)(invidx_file[idx].mapaddr + sizeof(invt_counter_t));
 
 	n = startnode;
-	for (i=0; i < invidx_file[idx].counter->ic_curnum; i++) {
+	for (i = 0; i < invidx_file[idx].counter->ic_curnum; i++) {
 		len = strlen(invidx_entry[i].ie_filename) + 54;
 		txt = malloc(len);
 		if (txt == NULL) {
@@ -1022,7 +1022,7 @@ remmap_invidx(int fidx, int num)
 
 	/* regenerate the data index for the file given the new mapping */
 	inv_entry = (invt_entry_t *)(invidx_file[fidx].mapaddr + sizeof(invt_counter_t));
-	for (i=0; i < nEntries; i++) {
+	for (i = 0; i < nEntries; i++) {
 		if (i >= invidx_file[fidx].numrecords) {
 			add_invidx_data(fidx, &(inv_entry[i]));
 		}
@@ -1043,7 +1043,7 @@ open_invidx(char *idxFileName)
 	char *name;
 	invt_counter_t header;
 
-	errno=0;
+	errno = 0;
 	fd = open_and_lock(idxFileName, FILE_WRITE, wait_for_locks);
 	if (fd < 0) {
 		return fd;
@@ -1060,7 +1060,7 @@ open_invidx(char *idxFileName)
 	nEntries = header.ic_curnum;
 
 	mapaddr = mmap_n_bytes(fd,
-			       nEntries*sizeof(invt_entry_t) + sizeof(invt_counter_t),
+			       nEntries * sizeof(invt_entry_t) + sizeof(invt_counter_t),
 			       BOOL_FALSE,
 			       idxFileName);
 
@@ -1078,7 +1078,7 @@ close_invidx(int idx)
 
 	nEntries = invidx_file[idx].counter->ic_curnum;
 	munmap(invidx_file[idx].mapaddr,
-	       (invidx_file[idx].nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t));
+	       (invidx_file[idx].nEntries * sizeof(invt_entry_t)) + sizeof(invt_counter_t));
 
 	if (nEntries != 0 && nEntries != invidx_file[idx].nEntries) {
 		ftruncate(invidx_file[idx].fd,
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 1a49d39..13ebd56 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -301,7 +301,7 @@ get_mntpnt(char *txt)
 	if (p == NULL)
 		return txt;
 
-	return p+1;
+	return p + 1;
 }
 
 int
@@ -361,7 +361,7 @@ ParseDate(char *strDate)
 	};
 
 	for (fmt = &templateStr[0]; *fmt != NULL; fmt++) {
-		memset (&tm, 0, sizeof (struct tm)); /* ensure fields init'ed */
+		memset(&tm, 0, sizeof(struct tm));   /* ensure fields init'ed */
 		if (strptime(strDate, *fmt, &tm) != NULL)
 			break;
 	}
@@ -379,7 +379,7 @@ ParseDate(char *strDate)
 	/* HACK to ensure tm_isdst is set BEFORE calling mktime(3) */
 	if (tm.tm_isdst) {
 		int dst = tm.tm_isdst;
-		memset (&tm, 0, sizeof (struct tm));
+		memset(&tm, 0, sizeof(struct tm));
 		tm.tm_isdst = dst;
 		(void)strptime(strDate, *fmt, &tm);
 		tm.tm_isdst = dst;
@@ -405,35 +405,35 @@ ParseDate(char *strDate)
 }
 
 char *
-GetNameOfStobj (char *inv_path, char *filename)
+GetNameOfStobj(char *inv_path, char *filename)
 {
 	char *str;
 	char *name;
 
 	str = basename(filename);
-	name = (char *) malloc(strlen(inv_path) + 1  + strlen(str) + 1);
+	name = (char *)malloc(strlen(inv_path) + 1 + strlen(str) + 1);
 	strcpy(name, inv_path);
 	strcat(name, "/");
 	strcat(name, str);
 
-	return(name);
+	return (name);
 }
 
 char *
-GetNameOfInvIndex (char *inv_path, uuid_t uuid)
+GetNameOfInvIndex(char *inv_path, uuid_t uuid)
 {
 	char str[UUID_STR_LEN + 1];
 	char *name;
 
 	uuid_unparse(uuid, str);
-	name = (char *) malloc(strlen(inv_path) + 1  + strlen(str)
-			       + strlen(INV_INVINDEX_PREFIX) + 1);
+	name = (char *)malloc(strlen(inv_path) + 1 + strlen(str)
+			      + strlen(INV_INVINDEX_PREFIX) + 1);
 	strcpy(name, inv_path);
 	strcat(name, "/");
 	strcat(name, str);
 	strcat(name, INV_INVINDEX_PREFIX);
 
-	return(name);
+	return (name);
 }
 
 char *
@@ -441,12 +441,12 @@ GetFstabFullPath(char *inv_path)
 {
 	char *fstabname;
 
-	fstabname = (char *) malloc(strlen(inv_path) + 1 /* one for the "/" */
-				    + strlen("fstab") + 1);
+	fstabname = (char *)malloc(strlen(inv_path) + 1  /* one for the "/" */
+				   + strlen("fstab") + 1);
 	strcpy(fstabname, inv_path);
 	strcat(fstabname, "/");
 	strcat(fstabname, "fstab");
-	return(fstabname);
+	return (fstabname);
 }
 
 void
@@ -485,7 +485,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 	nEntries = cnt.ic_curnum;
 
 	mapaddr = mmap_n_bytes(fd,
-			       nEntries*sizeof(invt_fstab_t) + sizeof(invt_counter_t),
+			       nEntries * sizeof(invt_fstab_t) + sizeof(invt_counter_t),
 			       BOOL_FALSE,
 			       fstabname);
 
@@ -501,7 +501,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 
 		printf("   Found entry for %s\n", fstabentry[i].ft_mountpt);
 
-		for (j = i +1; j < counter->ic_curnum; j++) {
+		for (j = i + 1; j < counter->ic_curnum; j++) {
 			if (uuid_compare(fstabentry[i].ft_uuid, fstabentry[j].ft_uuid) == 0)
 			{
 				printf("     duplicate fstab entry\n");
@@ -570,14 +570,14 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 	fstabEntries = counter->ic_curnum;
 
 	munmap(mapaddr,
-	       (nEntries*sizeof(invt_fstab_t)) + sizeof(invt_counter_t));
+	       (nEntries * sizeof(invt_fstab_t)) + sizeof(invt_counter_t));
 
-	if ((fstabEntries != 0)  && (fstabEntries != nEntries)) {
+	if ((fstabEntries != 0) && (fstabEntries != nEntries)) {
 		if (debug) {
 			printf("ftruncate fstab from %d to %d (%ld bytes)\n",
 			       nEntries,
 			       fstabEntries,
-			       (long) sizeof(invt_counter_t) + (sizeof(invt_fstab_t) * fstabEntries));
+			       (long)sizeof(invt_counter_t) + (sizeof(invt_fstab_t) * fstabEntries));
 			printf("ftruncate %s\n", fstabname);
 		}
 		ftruncate(fd,
@@ -629,13 +629,13 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 	nEntries = header.ic_curnum;
 
 	temp = mmap_n_bytes(fd,
-			    nEntries*sizeof(invt_entry_t) + sizeof(invt_counter_t),
+			    nEntries * sizeof(invt_entry_t) + sizeof(invt_counter_t),
 			    BOOL_FALSE, idxFileName);
 
 	counter = (invt_counter_t *)temp;
 	invIndexEntry = (invt_entry_t *)(temp + sizeof(invt_counter_t));
 
-	for (i=0; i < counter->ic_curnum;)
+	for (i = 0; i < counter->ic_curnum;)
 	{
 		removeflag = BOOL_FALSE;
 		printf("         Checking access for\n"
@@ -647,7 +647,7 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 			       ctime32(&(invIndexEntry[i].ie_timeperiod.tp_end)));
 		}
 
-		if ((access(invIndexEntry[i].ie_filename, R_OK | W_OK) == -1)  &&
+		if ((access(invIndexEntry[i].ie_filename, R_OK | W_OK) == -1) &&
 		    (errno == ENOENT))
 		{
 			printf("         Unable to access %s referred in %s\n",
@@ -676,14 +676,14 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 
 	validEntries = counter->ic_curnum;
 
-	munmap(temp, (nEntries*sizeof(invt_entry_t)) + sizeof(invt_counter_t));
+	munmap(temp, (nEntries * sizeof(invt_entry_t)) + sizeof(invt_counter_t));
 
-	if ((validEntries != 0)  && (validEntries != nEntries)) {
+	if ((validEntries != 0) && (validEntries != nEntries)) {
 		if (debug) {
 			printf("ftruncate idx from %d to %d (%ld bytes)\n",
 			       nEntries,
 			       validEntries,
-			       (long) sizeof(invt_counter_t) + (validEntries * sizeof(invt_entry_t)));
+			       (long)sizeof(invt_counter_t) + (validEntries * sizeof(invt_entry_t)));
 			printf("- truncate %s\n", idxFileName);
 		}
 		ftruncate(fd,
@@ -704,10 +704,10 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 			printf("unlink idx file %s\n", idxFileName);
 		}
 		unlink(idxFileName);
-		return(-1);
+		return (-1);
 	}
 
-	return(0);
+	return (0);
 }
 
 int
@@ -758,7 +758,7 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 	StObjses = (invt_session_t *)(temp + StObjhdr->sh_sess_off);
 
 	sescount = 0;
-	for (i=0; i < counter->ic_curnum;) {
+	for (i = 0; i < counter->ic_curnum;) {
 		removeflag = BOOL_FALSE;
 		if (StObjhdr->sh_pruned)
 			prunedcount++;
@@ -796,7 +796,7 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 			printf("\t\tsession id:\t%s\n", str);
 			printf("\t\tlevel:\t\t%d\n", StObjhdr->sh_level);
 			printf("\t\tstreams:\t%d\n", StObjses->s_cur_nstreams);
-			for (i = 0; i < (int) StObjses->s_cur_nstreams; i++) {
+			for (i = 0; i < (int)StObjses->s_cur_nstreams; i++) {
 				printf("\t\tstream %d:\n", i);
 				StObjstrm = (invt_stream_t *)(temp +
 							      StObjhdr->sh_streams_off +
@@ -804,9 +804,9 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 				printf("\t\t\tpathname:\t%s\n",
 				       StObjstrm->st_cmdarg);
 				printf("\t\t\tinode start:\t%llu\n",
-				       (unsigned long long) StObjstrm->st_startino.ino);
+				       (unsigned long long)StObjstrm->st_startino.ino);
 				printf("\t\t\tinode   end:\t%llu\n",
-				       (unsigned long long) StObjstrm->st_endino.ino);
+				       (unsigned long long)StObjstrm->st_endino.ino);
 				printf("\t\t\tinterrupted:\t%s\n",
 				       StObjstrm->st_interrupted ? "YES" : "NO");
 				printf("\t\t\tmedia files:\t%d\n",
@@ -817,11 +817,11 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 									(j * sizeof(invt_mediafile_t)));
 					printf("\t\t\tmfile file %d:\n", j);
 					printf("\t\t\t\tmfile size:\t%lld\n",
-					       (long long) StObjmed->mf_size);
+					       (long long)StObjmed->mf_size);
 					printf("\t\t\t\tmfile start:\t%llu\n",
-					       (unsigned long long) StObjmed->mf_startino.ino);
+					       (unsigned long long)StObjmed->mf_startino.ino);
 					printf("\t\t\t\tmfile end:\t%llu\n",
-					       (unsigned long long) StObjmed->mf_endino.ino);
+					       (unsigned long long)StObjmed->mf_endino.ino);
 					printf("\t\t\t\tmedia label:\t\"%s\"\n",
 					       StObjmed->mf_label);
 				}
@@ -915,10 +915,10 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 		if (debug)
 			printf("Removing: %s\n", StObjFileName);
 		unlink(StObjFileName);
-		return(-1);
+		return (-1);
 	}
 
-	return(0);
+	return (0);
 }
 
 /*
@@ -942,7 +942,7 @@ uses_specified_mf_label(
 	if (! r_mf_label) {
 		return 1; /* prune */
 	}
-	for (s = 0; s < (int) StObjses->s_cur_nstreams; s++) {
+	for (s = 0; s < (int)StObjses->s_cur_nstreams; s++) {
 		StObjstrm = (invt_stream_t *)
 			    (temp + StObjhdr->sh_streams_off + (s * sizeof(invt_stream_t)));
 		for (m = 0; m < StObjstrm->st_nmediafiles; m++, num_media_objects++) {
@@ -1017,7 +1017,7 @@ inv_DEBUG_lock_str(int c)
  *      returns SYSCALL_FAILED for other failures.
  */
 int
-open_and_lock(char * path, Open_t open_type, uint lock_wait_flag)
+open_and_lock(char *path, Open_t open_type, uint lock_wait_flag)
 {
 	int fd;
 	int rc;
@@ -1106,58 +1106,58 @@ open_and_lock(char * path, Open_t open_type, uint lock_wait_flag)
 }
 
 void
-read_n_bytes(int fd, void * buf, size_t count, char *path)
+read_n_bytes(int fd, void *buf, size_t count, char *path)
 {
 	int rc;
 
 	rc = read(fd, buf, count);
 	if (rc < 0) {
 		fprintf(stderr, "%s: read of %ld bytes on %s failed.\n",
-			g_programName, (long) count, path);
+			g_programName, (long)count, path);
 		perror(path);
-		exit (2);
+		exit(2);
 	} else if (rc != count) {
 		fprintf(stderr, "%s: read of %ld bytes on %s failed.\n",
-			g_programName, (long) count, path);
+			g_programName, (long)count, path);
 		fprintf(stderr, "Tried to read %ld bytes, got %d.\n",
-			(long) count, rc);
-		exit (2);
+			(long)count, rc);
+		exit(2);
 	}
 }
 
 void
-write_n_bytes(int fd, void * buf, size_t count, char *path)
+write_n_bytes(int fd, void *buf, size_t count, char *path)
 {
 	int rc;
 
 	rc = write(fd, buf, count);
 	if (rc < 0) {
 		fprintf(stderr, "%s: write of %ld bytes on %s failed.\n",
-			g_programName, (long) count, path);
+			g_programName, (long)count, path);
 		perror(path);
-		exit (2);
+		exit(2);
 	} else if (rc != count) {
 		fprintf(stderr, "%s: write of %ld bytes on %s failed.\n",
-			g_programName, (long) count, path);
+			g_programName, (long)count, path);
 		fprintf(stderr, "Tried to write %ld bytes, wrote %d.\n",
-			(long) count, rc);
-		exit (2);
+			(long)count, rc);
+		exit(2);
 	}
 }
 
 void *
 mmap_n_bytes(int fd, size_t count, bool_t checkonly, char *path)
 {
-	void * temp;
+	void *temp;
 
 	lseek(fd, 0, SEEK_SET);
 	temp = mmap(NULL, count,
-		    (checkonly == BOOL_TRUE) ? PROT_READ : PROT_READ|PROT_WRITE,
+		    (checkonly == BOOL_TRUE) ? PROT_READ : PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
 
 	if (temp == (void *)-1) {
 		fprintf(stderr, "%s: error in mmap of %ld bytes for file %s\n",
-			g_programName, (long) count, path);
+			g_programName, (long)count, path);
 		perror("mmap");
 		fprintf(stderr, "%s: abnormal termination\n", g_programName);
 		exit(1);
@@ -1166,7 +1166,7 @@ mmap_n_bytes(int fd, size_t count, bool_t checkonly, char *path)
 }
 
 void
-usage (void)
+usage(void)
 {
 	int pfxsz;
 
diff --git a/invutil/invutil.h b/invutil/invutil.h
index b4a16b2..33b5284 100644
--- a/invutil/invutil.h
+++ b/invutil/invutil.h
@@ -18,7 +18,7 @@
 #ifndef INVUTIL_H
 #define INVUTIL_H
 
-#define STR_LEN                 INV_STRLEN+32
+#define STR_LEN                 INV_STRLEN + 32
 #define GEN_STRLEN              32
 
 /*      open_and_lock() return codes */
@@ -34,16 +34,16 @@ typedef enum {
 	DIRECTORY_UNSAFE
 } Open_t;
 
-extern char * g_programName;
-extern char * g_programVersion;
-extern char * inventory_path;
+extern char *g_programName;
+extern char *g_programVersion;
+extern char *inventory_path;
 extern bool_t debug;
 extern bool_t force;
 extern bool_t wait_for_locks;
 
-char *  GetFstabFullPath(char *);
-char * GetNameOfInvIndex (char *, uuid_t);
-char *  GetNameOfStobj (char *inv_path, char *filename);
+char *GetFstabFullPath(char *);
+char *GetNameOfInvIndex(char *, uuid_t);
+char *GetNameOfStobj(char *inv_path, char *filename);
 void CheckAndPruneFstab(
 	char *, bool_t, char *, uuid_t *, uuid_t *, time32_t, char *);
 int CheckAndPruneInvIndexFile(bool_t, char *, uuid_t *, time32_t, char *);
@@ -51,11 +51,11 @@ int CheckAndPruneStObjFile(bool_t, char *, uuid_t *, time32_t, char *);
 int     uses_specified_mf_label(
 	invt_seshdr_t *, invt_session_t *, char *, char *);
 time32_t ParseDate(char *);
-void    usage (void);
+void    usage(void);
 int open_and_lock(char *, Open_t, uint);
 void read_n_bytes(int, void *, size_t, char *);
 void write_n_bytes(int, void *, size_t, char *);
-void * mmap_n_bytes(int, size_t, bool_t, char *);
+void *mmap_n_bytes(int, size_t, bool_t, char *);
 void    ListFstab(void);
 int     ListInvIndexFile(char *);
 int     ListStObjFile(char *);
diff --git a/invutil/menu.c b/invutil/menu.c
index c866210..b50734c 100644
--- a/invutil/menu.c
+++ b/invutil/menu.c
@@ -168,7 +168,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 		if (quit == BOOL_TRUE)
 			continue;
 
-		c=wgetch(win);
+		c = wgetch(win);
 		switch (c) {
 		case '?':
 		case KEY_F(1):
diff --git a/invutil/stobj.c b/invutil/stobj.c
index b70f732..1c475da 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -192,7 +192,7 @@ stobjsess_highlight(WINDOW *win, node_t *current, node_t *list)
 		 (stobjhdr->sh_pruned == BOOL_TRUE) ? "yes" : "no",
 		 stobjhdr->sh_flag,
 		 ctime32(&(stobjhdr->sh_time)));
-	txt[strlen(txt)-1] = '\0';
+	txt[strlen(txt) - 1] = '\0';
 	put_info_line(1, txt);
 
 	uuid_unparse(stobjses->s_fsid, uuidstr);
@@ -230,13 +230,13 @@ stobjstrm_highlight(WINDOW *win, node_t *current, node_t *list)
 	put_info_line(1, txt);
 
 	snprintf(txt, sizeof(txt), "start ino: %llu, offset %lld",
-		 (unsigned long long) stobjstrm->st_startino.ino,
-		 (long long) stobjstrm->st_startino.offset);
+		 (unsigned long long)stobjstrm->st_startino.ino,
+		 (long long)stobjstrm->st_startino.offset);
 	put_info_line(2, txt);
 
 	snprintf(txt, sizeof(txt), "  end ino: %llu, offset %lld",
-		 (unsigned long long) stobjstrm->st_endino.ino,
-		 (long long) stobjstrm->st_endino.offset);
+		 (unsigned long long)stobjstrm->st_endino.ino,
+		 (long long)stobjstrm->st_endino.offset);
 	put_info_line(3, txt);
 
 	return FALSE;
@@ -266,13 +266,13 @@ stobjmed_highlight(WINDOW *win, node_t *current, node_t *list)
 	put_info_line(1, txt);
 
 	snprintf(txt, sizeof(txt), "start ino: %llu, offset %lld",
-		 (unsigned long long) stobjmed->mf_startino.ino,
-		 (long long) stobjmed->mf_startino.offset);
+		 (unsigned long long)stobjmed->mf_startino.ino,
+		 (long long)stobjmed->mf_startino.offset);
 	put_info_line(2, txt);
 
 	snprintf(txt, sizeof(txt), "  end ino: %llu, offset %lld",
-		 (unsigned long long) stobjmed->mf_endino.ino,
-		 (long long) stobjmed->mf_endino.offset);
+		 (unsigned long long)stobjmed->mf_endino.ino,
+		 (long long)stobjmed->mf_endino.offset);
 	put_info_line(3, txt);
 
 	return FALSE;
@@ -414,7 +414,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 
 	data_idx = 0;
 	n = startnode;
-	for (i=0; i < stobj_file[idx].counter->ic_curnum;) {
+	for (i = 0; i < stobj_file[idx].counter->ic_curnum;) {
 		session = malloc(sizeof(*session));
 		if (session == NULL) {
 			fprintf(stderr, "%s: internal memory error: session malloc\n", g_programName);
@@ -423,7 +423,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 		session->header = StObjhdr;
 		session->session = StObjses;
 
-		len = 60+strlen(session->session->s_label);
+		len = 60 + strlen(session->session->s_label);
 		txt = malloc(len);
 		if (txt == NULL) {
 			fprintf(stderr, "%s: internal memory error: invidx_text\n", g_programName);
@@ -453,7 +453,7 @@ generate_stobj_menu(node_t *startnode, int level, char *StObjFileName)
 		add_stobj_data(idx, session);
 
 		parent_session = n;
-		for (j = 0; j < (int) StObjses->s_cur_nstreams; j++) {
+		for (j = 0; j < (int)StObjses->s_cur_nstreams; j++) {
 			StObjstrm = (invt_stream_t *)(stobj_file[idx].mapaddr +
 						      StObjhdr->sh_streams_off +
 						      (j * sizeof(invt_stream_t)));
@@ -577,7 +577,7 @@ open_stobj(char *StObjFileName)
 	invt_sescounter_t cnt;
 	char *name;
 
-	errno=0;
+	errno = 0;
 	fd = open_and_lock(StObjFileName, FILE_WRITE, wait_for_locks);
 	if (fd < 0) {
 		return fd;
diff --git a/librmt/isrmt.c b/librmt/isrmt.c
index 138632b..79f685e 100644
--- a/librmt/isrmt.c
+++ b/librmt/isrmt.c
@@ -27,7 +27,7 @@
  *	Isrmt. Let a programmer know he has a remote device.
  */
 
-int isrmt (fd)
+int isrmt(fd)
 int fd;
 {
 	return (fd >= REM_BIAS);
diff --git a/librmt/rmtaccess.c b/librmt/rmtaccess.c
index f0d5417..0944d41 100644
--- a/librmt/rmtaccess.c
+++ b/librmt/rmtaccess.c
@@ -29,17 +29,17 @@
  *	to caller.
  */
 
-int rmtaccess (path, amode)
+int rmtaccess(path, amode)
 char *path;
 int amode;
 {
-	if (_rmt_dev (path))
+	if (_rmt_dev(path))
 	{
 		return (0);             /* Let /etc/rmt find out */
 	}
 	else
 	{
-		return (access (path, amode));
+		return (access(path, amode));
 	}
 }
 
diff --git a/librmt/rmtclose.c b/librmt/rmtclose.c
index 9ba214d..20be537 100644
--- a/librmt/rmtclose.c
+++ b/librmt/rmtclose.c
@@ -29,19 +29,19 @@ static int _rmt_close(int);
  *	Close a file.  Looks just like close(2) to caller.
  */
 
-int rmtclose (fildes)
+int rmtclose(fildes)
 int fildes;
 {
-	if (isrmt (fildes))
+	if (isrmt(fildes))
 	{
 		/* no longer know what host we have for this fildes */
 		RMTHOST(fildes - REM_BIAS) = UNAME_UNKNOWN;
 
-		return (_rmt_close (fildes - REM_BIAS));
+		return (_rmt_close(fildes - REM_BIAS));
 	}
 	else
 	{
-		return (close (fildes));
+		return (close(fildes));
 	}
 }
 
@@ -58,10 +58,10 @@ _rmt_close(int fildes)
 		rc = _rmt_status(fildes);
 
 		_rmt_abort(fildes);
-		return(rc);
+		return (rc);
 	}
 
-	return(-1);
+	return (-1);
 }
 
 
diff --git a/librmt/rmtcommand.c b/librmt/rmtcommand.c
index 5811d50..cfeaac3 100644
--- a/librmt/rmtcommand.c
+++ b/librmt/rmtcommand.c
@@ -48,7 +48,7 @@ char *buf;
 	blen = strlen(buf);
 	if (write(WRITE(fildes), buf, blen) == blen)
 	{
-		return(0);
+		return (0);
 	}
 
 /*
@@ -58,7 +58,7 @@ char *buf;
 	_rmt_abort(fildes);
 
 	setoserror(EIO);
-	return(-1);
+	return (-1);
 }
 
 
diff --git a/librmt/rmtcreat.c b/librmt/rmtcreat.c
index ae19bed..c86d608 100644
--- a/librmt/rmtcreat.c
+++ b/librmt/rmtcreat.c
@@ -30,19 +30,19 @@
 #include <fcntl.h>              /* use this one for S5 with remote stuff */
 #include "rmtlib.h"
 
-extern int rmtopen(char*, int, int);
+extern int rmtopen(char *, int, int);
 
-int rmtcreat (path, mode)
+int rmtcreat(path, mode)
 char *path;
 int mode;
 {
-	if (_rmt_dev (path))
+	if (_rmt_dev(path))
 	{
-		return (rmtopen (path, 1 | O_CREAT, mode));
+		return (rmtopen(path, 1 | O_CREAT, mode));
 	}
 	else
 	{
-		return (creat (path, mode));
+		return (creat(path, mode));
 	}
 }
 
diff --git a/librmt/rmtdev.c b/librmt/rmtdev.c
index 0bd011c..b1f2fbb 100644
--- a/librmt/rmtdev.c
+++ b/librmt/rmtdev.c
@@ -29,12 +29,12 @@
  *	0 otherwise.
  */
 
-int _rmt_dev (path)
+int _rmt_dev(path)
 register char *path;
 {
-	if ((path = strchr (path, ':')) != (char *)0)
+	if ((path = strchr(path, ':')) != (char *)0)
 	{
-		if (strncmp (path + 1, "/dev/", 5) == 0)
+		if (strncmp(path + 1, "/dev/", 5) == 0)
 		{
 			return (1);
 		}
diff --git a/librmt/rmtfstat.c b/librmt/rmtfstat.c
index 7c21219..75ff766 100644
--- a/librmt/rmtfstat.c
+++ b/librmt/rmtfstat.c
@@ -35,13 +35,13 @@ static int _rmt_fstat(int, char *);
  *	Get file status.  Looks just like fstat(2) to caller.
  */
 
-int rmtfstat (fildes, buf)
+int rmtfstat(fildes, buf)
 int fildes;
 struct stat *buf;
 {
-	if (isrmt (fildes))
+	if (isrmt(fildes))
 	{
-		return (_rmt_fstat (fildes - REM_BIAS, (char *)buf));
+		return (_rmt_fstat(fildes - REM_BIAS, (char *)buf));
 	}
 	else
 	{
@@ -69,7 +69,7 @@ _rmt_fstat(int fildes, char *arg)
 
 	if (_rmt_command(fildes, buffer) == -1 ||
 	    (rc = _rmt_status(fildes)) == -1)
-		return(-1);
+		return (-1);
 
 	/* adjust read count to prevent overflow */
 
@@ -84,7 +84,7 @@ _rmt_fstat(int fildes, char *arg)
 abortit:
 			_rmt_abort(fildes);
 			setoserror(EIO);
-			return(-1);
+			return (-1);
 		}
 	}
 
@@ -93,5 +93,5 @@ abortit:
 		if (read(READ(fildes), buffer, 1) <= 0)
 			goto abortit;
 
-	return(0);
+	return (0);
 }
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index c34dbeb..bcf9124 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -142,11 +142,11 @@ static int _rmt_ioctl(int, unsigned int, void *);
 int
 rmtioctl(int fildes, unsigned int request, void *arg)
 {
-	if (isrmt (fildes)) {
-		return (_rmt_ioctl (fildes - REM_BIAS, request, arg));
+	if (isrmt(fildes)) {
+		return (_rmt_ioctl(fildes - REM_BIAS, request, arg));
 	}
 	else {
-		return (ioctl (fildes, request, arg));
+		return (ioctl(fildes, request, arg));
 	}
 }
 
@@ -185,14 +185,14 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
  */
 
 	if (op == MTIOCTOP) {
-		int mt_op = ((struct mtop *) arg)->mt_op;
-		int mt_count = ((struct mtop *) arg)->mt_count;
+		int mt_op = ((struct mtop *)arg)->mt_op;
+		int mt_count = ((struct mtop *)arg)->mt_count;
 
 		if (RMTHOST(fildes) == UNAME_UNDEFINED) {
 			_rmt_msg(RMTWARN,
 				 _("rmtioctl: remote host type not supported for MTIOCTOP\n"));
 			setoserror(EPROTONOSUPPORT);
-			return(-1);
+			return (-1);
 		}
 
 		/* map the linux op code to the irix op code */
@@ -200,7 +200,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			mt_op = mtop_irixmap[mt_op];
 			if (mt_op == -1) {
 				setoserror(EINVAL);
-				return(-1);
+				return (-1);
 			}
 		}
 		else if (RMTHOST(fildes) != UNAME_LINUX) {
@@ -208,15 +208,15 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			mt_op = mtop_stdmap[mt_op];
 			if (mt_op == -1) {
 				setoserror(EINVAL);
-				return(-1);
+				return (-1);
 			}
 		}
 
 		sprintf(buffer, "I%d\n%d\n", mt_op, mt_count);
 		if (_rmt_command(fildes, buffer) == -1) {
-			return(-1);
+			return (-1);
 		}
-		return(_rmt_status(fildes));
+		return (_rmt_status(fildes));
 	}
 	else if (op == MTIOCGET) {
 
@@ -234,7 +234,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		 */
 		if (_rmt_command(fildes, "S") == -1 ||
 		    (rc = _rmt_status(fildes)) == -1)
-			return(-1);
+			return (-1);
 
 
 		/*
@@ -248,7 +248,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			_rmt_msg(RMTWARN,
 				 _("rmtioctl: remote host type not supported for MTIOCGET\n"));
 			setoserror(EPROTONOSUPPORT);
-			return(-1);
+			return (-1);
 		case UNAME_IRIX:
 			if (sizeof(struct irix_mtget) != rc) {
 				_rmt_msg(RMTWARN,
@@ -256,7 +256,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 					   " - got %d, wanted %d\n"),
 					 rc, sizeof(struct irix_mtget));
 				setoserror(EPROTONOSUPPORT);
-				return(-1);
+				return (-1);
 			}
 			break;
 		case UNAME_LINUX:
@@ -273,16 +273,16 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 					 rc, sizeof(struct linux32_mtget),
 					 sizeof(struct linux64_mtget));
 				setoserror(EPROTONOSUPPORT);
-				return(-1);
+				return (-1);
 			}
 			break;
 		default:
 			setoserror(EPROTONOSUPPORT);
-			return(-1);
+			return (-1);
 		}
 
 
-		assert(RMTHOST(fildes)==UNAME_LINUX || RMTHOST(fildes)==UNAME_IRIX);
+		assert(RMTHOST(fildes) == UNAME_LINUX || RMTHOST(fildes) == UNAME_IRIX);
 
 
 		if (RMTHOST(fildes) == UNAME_IRIX) {
@@ -303,7 +303,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			if (cnt <= 0) {
 				_rmt_abort(fildes);
 				setoserror(EIO);
-				return(-1);
+				return (-1);
 			}
 		}
 
@@ -416,11 +416,11 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			dstp->mt_dsreg = srcp->mt_dsreg;
 			dstp->mt_gstat = srcp->mt_gstat;
 		}
-		return(0);
+		return (0);
 
 	}
 	else {
 		setoserror(EINVAL);
-		return(-1);
+		return (-1);
 	}
 }
diff --git a/librmt/rmtisatty.c b/librmt/rmtisatty.c
index 2f6d96d..75ae9fc 100644
--- a/librmt/rmtisatty.c
+++ b/librmt/rmtisatty.c
@@ -28,15 +28,15 @@
  *	Rmtisatty.  Do the isatty function.
  */
 
-int rmtisatty (fd)
+int rmtisatty(fd)
 int fd;
 {
-	if (isrmt (fd))
+	if (isrmt(fd))
 	{
 		return (0);
 	}
 	else
 	{
-		return (isatty (fd));
+		return (isatty(fd));
 	}
 }
diff --git a/librmt/rmtlib.h b/librmt/rmtlib.h
index 1fd11cf..f7dbde0 100644
--- a/librmt/rmtlib.h
+++ b/librmt/rmtlib.h
@@ -77,10 +77,10 @@ extern int _rmt_host[MAXUNIT];
 #define setoserror(err) (errno = err) /* TODO: multithread check */
 
 /* prototypes */
-int isrmt (int);
+int isrmt(int);
 void _rmt_abort(int);
 int _rmt_command(int, char *);
-int _rmt_dev (char *);
+int _rmt_dev(char *);
 int _rmt_status(int);
 int _rmt_msgson(void);
 void _rmt_msg(int level, const char *msg, ...);
diff --git a/librmt/rmtlseek.c b/librmt/rmtlseek.c
index c59c157..350d444 100644
--- a/librmt/rmtlseek.c
+++ b/librmt/rmtlseek.c
@@ -32,18 +32,18 @@ static off_t _rmt_lseek(int, off_t, int);
  *	Perform lseek on file.  Looks just like lseek(2) to caller.
  */
 
-off_t rmtlseek (fildes, offset, whence)
+off_t rmtlseek(fildes, offset, whence)
 int fildes;
 off_t offset;
 int whence;
 {
-	if (isrmt (fildes))
+	if (isrmt(fildes))
 	{
-		return (_rmt_lseek (fildes - REM_BIAS, offset, whence));
+		return (_rmt_lseek(fildes - REM_BIAS, offset, whence));
 	}
 	else
 	{
-		return (lseek (fildes, offset, whence));
+		return (lseek(fildes, offset, whence));
 	}
 }
 
@@ -58,9 +58,9 @@ _rmt_lseek(int fildes, off_t offset, int whence)
 
 	sprintf(buffer, "L%ld\n%d\n", (long)offset, whence);
 	if (_rmt_command(fildes, buffer) == -1)
-		return(-1);
+		return (-1);
 
-	return(_rmt_status(fildes));
+	return (_rmt_status(fildes));
 }
 
 
diff --git a/librmt/rmtmsg.c b/librmt/rmtmsg.c
index 906293d..aeb599e 100644
--- a/librmt/rmtmsg.c
+++ b/librmt/rmtmsg.c
@@ -80,6 +80,6 @@ _rmt_msg(int level, const char *msg, ...)
 		vsprintf(msg_str, msg, arg);
 		va_end(arg);
 
-		fprintf(stderr, "%s%s", level==RMTWARN ? _("WARNING: ") : "", msg_str);
+		fprintf(stderr, "%s%s", level == RMTWARN ? _("WARNING: ") : "", msg_str);
 	}
 }
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index 7a74a11..383e9bf 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -39,8 +39,8 @@
 
 static int _rmt_open(char *, int, int);
 
-int _rmt_Ctp[MAXUNIT][2] = { {-1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
-int _rmt_Ptc[MAXUNIT][2] = { {-1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
+int _rmt_Ctp[MAXUNIT][2] = { { -1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
+int _rmt_Ptc[MAXUNIT][2] = { { -1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
 int _rmt_host[MAXUNIT] = { -1, -1, -1, -1 };
 
 struct uname_table
@@ -50,7 +50,7 @@ struct uname_table
 };
 
 struct uname_table uname_table[] =
-{ {UNAME_LINUX, "Linux" }, { UNAME_IRIX, "IRIX" }, { 0, 0 } };
+{ { UNAME_LINUX, "Linux" }, { UNAME_IRIX, "IRIX" }, { 0, 0 } };
 
 
 /*
@@ -58,18 +58,18 @@ struct uname_table uname_table[] =
  *	caller.
  */
 
-int rmtopen (path, oflag, mode)
+int rmtopen(path, oflag, mode)
 char *path;
 int oflag;
 int mode;
 {
-	if (strchr (path, ':') != NULL)
+	if (strchr(path, ':') != NULL)
 	{
-		return (_rmt_open (path, oflag, mode) | REM_BIAS);
+		return (_rmt_open(path, oflag, mode) | REM_BIAS);
 	}
 	else
 	{
-		return (open (path, oflag, mode));
+		return (open(path, oflag, mode));
 	}
 }
 
@@ -84,7 +84,7 @@ int mode;
 #define MAXDBGPATH      100
 
 /* ARGSUSED */
-static int _rmt_open (char *path, int oflag, int mode)
+static int _rmt_open(char *path, int oflag, int mode)
 {
 	int i, rc;
 	char buffer[BUFMAGIC];
@@ -121,7 +121,7 @@ static int _rmt_open (char *path, int oflag, int mode)
 	if (i == MAXUNIT)
 	{
 		setoserror(EMFILE);
-		return(-1);
+		return (-1);
 	}
 
 /*
@@ -158,7 +158,7 @@ static int _rmt_open (char *path, int oflag, int mode)
 
 	/* try to find out the uname of the remote host */
 	{
-#define MAX_UNAMECMD MAXHOSTLEN+40
+#define MAX_UNAMECMD MAXHOSTLEN + 40
 #define MAX_UNAME 20
 		FILE *rmt_f;
 		char cmd[MAX_UNAMECMD];
@@ -193,8 +193,8 @@ static int _rmt_open (char *path, int oflag, int mode)
 				goto do_rmt;
 			}
 			len = strlen(uname);
-			if (len > 0 && uname[len-1] == '\n')
-				uname[len-1] = '\0'; /* chomp the '\n' */
+			if (len > 0 && uname[len - 1] == '\n')
+				uname[len - 1] = '\0'; /* chomp the '\n' */
 		}
 
 		for (p = &uname_table[0]; p->name != 0; p++) {
@@ -219,10 +219,10 @@ static int _rmt_open (char *path, int oflag, int mode)
  */
 do_rmt:
 	if (pipe(_rmt_Ptc[i]) == -1 || pipe(_rmt_Ctp[i]) == -1)
-		return(-1);
+		return (-1);
 
 	if ((rc = fork()) == -1)
-		return(-1);
+		return (-1);
 
 	if (rc == 0)
 	{
@@ -232,8 +232,8 @@ do_rmt:
 		close(1);
 		dup(_rmt_Ctp[i][1]);
 		close(_rmt_Ctp[i][0]); close(_rmt_Ctp[i][1]);
-		(void) setuid (getuid ());
-		(void) setgid (getgid ());
+		(void)setuid(getuid());
+		(void)setgid(getgid());
 		if (_rmt_msgson() == RMTDBG) {
 			snprintf(rmt_cmd, sizeof(rmt_cmd), "%s %s.%d",
 				 rmt_path, RMT_DEBUG_FILE, getpid());
@@ -244,12 +244,12 @@ do_rmt:
 		if (user != login)
 		{
 			execl(rsh_path, "rsh", system, "-l", login,
-			      rmt_cmd, (char *) 0);
+			      rmt_cmd, (char *)0);
 		}
 		else
 		{
 			execl(rsh_path, "rsh", system,
-			      rmt_cmd, (char *) 0);
+			      rmt_cmd, (char *)0);
 		}
 
 /*
@@ -269,7 +269,7 @@ do_rmt:
 
 	sprintf(buffer, "O%s\n%d\n", device, oflag);
 	if (_rmt_command(i, buffer) == -1 || _rmt_status(i) == -1)
-		return(-1);
+		return (-1);
 
-	return(i);
+	return (i);
 }
diff --git a/librmt/rmtread.c b/librmt/rmtread.c
index bc37ff9..6edfb08 100644
--- a/librmt/rmtread.c
+++ b/librmt/rmtread.c
@@ -33,18 +33,18 @@ static int _rmt_read(int, char *, unsigned int);
  *	Read from stream.  Looks just like read(2) to caller.
  */
 
-int rmtread (fildes, buf, nbyte)
+int rmtread(fildes, buf, nbyte)
 int fildes;
 char *buf;
 unsigned int nbyte;
 {
-	if (isrmt (fildes))
+	if (isrmt(fildes))
 	{
-		return (_rmt_read (fildes - REM_BIAS, buf, nbyte));
+		return (_rmt_read(fildes - REM_BIAS, buf, nbyte));
 	}
 	else
 	{
-		return (read (fildes, buf, nbyte));
+		return (read(fildes, buf, nbyte));
 	}
 }
 
@@ -60,7 +60,7 @@ _rmt_read(int fildes, char *buf, unsigned int nbyte)
 
 	sprintf(buffer, "R%d\n", nbyte);
 	if (_rmt_command(fildes, buffer) == -1 || (rc = _rmt_status(fildes)) == -1)
-		return(-1);
+		return (-1);
 
 	for (i = 0; i < rc; i += nbyte, buf += nbyte)
 	{
@@ -69,9 +69,9 @@ _rmt_read(int fildes, char *buf, unsigned int nbyte)
 		{
 			_rmt_abort(fildes);
 			setoserror(EIO);
-			return(-1);
+			return (-1);
 		}
 	}
 
-	return(rc);
+	return (rc);
 }
diff --git a/librmt/rmtstatus.c b/librmt/rmtstatus.c
index 91ad308..11ff375 100644
--- a/librmt/rmtstatus.c
+++ b/librmt/rmtstatus.c
@@ -49,7 +49,7 @@ int fildes;
 		{
 			_rmt_abort(fildes);
 			setoserror(EIO);
-			return(-1);
+			return (-1);
 		}
 		if (*cp == '\n')
 		{
@@ -62,7 +62,7 @@ int fildes;
 	{
 		_rmt_abort(fildes);
 		setoserror(EIO);
-		return(-1);
+		return (-1);
 	}
 
 /*
@@ -83,7 +83,7 @@ int fildes;
 		if (*cp == 'F')
 			_rmt_abort(fildes);
 
-		return(-1);
+		return (-1);
 	}
 
 /*
@@ -94,10 +94,10 @@ int fildes;
 	{
 		_rmt_abort(fildes);
 		setoserror(EIO);
-		return(-1);
+		return (-1);
 	}
 
-	return(atoi(cp + 1));
+	return (atoi(cp + 1));
 }
 
 
diff --git a/librmt/rmtwrite.c b/librmt/rmtwrite.c
index f0b7c0a..4610222 100644
--- a/librmt/rmtwrite.c
+++ b/librmt/rmtwrite.c
@@ -33,18 +33,18 @@ static int _rmt_write(int, char *, unsigned int);
  *	Write to stream.  Looks just like write(2) to caller.
  */
 
-int rmtwrite (fildes, buf, nbyte)
+int rmtwrite(fildes, buf, nbyte)
 int fildes;
 char *buf;
 unsigned int nbyte;
 {
-	if (isrmt (fildes))
+	if (isrmt(fildes))
 	{
-		return (_rmt_write (fildes - REM_BIAS, buf, nbyte));
+		return (_rmt_write(fildes - REM_BIAS, buf, nbyte));
 	}
 	else
 	{
-		return (write (fildes, buf, nbyte));
+		return (write(fildes, buf, nbyte));
 	}
 }
 
@@ -59,14 +59,14 @@ _rmt_write(int fildes, char *buf, unsigned int nbyte)
 
 	sprintf(buffer, "W%d\n", nbyte);
 	if (_rmt_command(fildes, buffer) == -1)
-		return(-1);
+		return (-1);
 
 	if (write(WRITE(fildes), buf, nbyte) == nbyte)
 	{
-		return(_rmt_status(fildes));
+		return (_rmt_status(fildes));
 	}
 
 	_rmt_abort(fildes);
 	setoserror(EIO);
-	return(-1);
+	return (-1);
 }
diff --git a/restore/bag.h b/restore/bag.h
index 5157ad8..035d7d3 100644
--- a/restore/bag.h
+++ b/restore/bag.h
@@ -97,7 +97,7 @@ extern void bagiter_init(bag_t *bagp, bagiter_t *iterp);
  * returns the next element in the bag. caller may remove the element
  * prior to the next call.
  */
-extern bagelem_t * bagiter_next(bagiter_t *iterp, void **payloadpp);
+extern bagelem_t *bagiter_next(bagiter_t *iterp, void **payloadpp);
 
 /*
  * destroys the bag.
diff --git a/restore/content.c b/restore/content.c
index fa89bb4..c360205 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -875,12 +875,12 @@ static void pi_seestrmend(ix_t strmix);
 static void pi_seeobjstrmend(ix_t strmix, ix_t mediaix);
 static xfs_ino_t pi_scanfileendino(dh_t fileh);
 static bool_t pi_alldone(void);
-static bag_t * pi_neededobjs_dir_alloc(bool_t * knownholesprp,
-				       bool_t * maybeholesprp);
-static bag_t * pi_neededobjs_nondir_alloc(bool_t *	knownholesprp,
-					  bool_t *	maybeholesprp,
-					  bool_t	showobjindrivepr,
-					  bool_t	markskippr);
+static bag_t *pi_neededobjs_dir_alloc(bool_t *	knownholesprp,
+				      bool_t *	maybeholesprp);
+static bag_t *pi_neededobjs_nondir_alloc(bool_t *	knownholesprp,
+					 bool_t *	maybeholesprp,
+					 bool_t		showobjindrivepr,
+					 bool_t		markskippr);
 static void pi_neededobjs_free(bag_t *bagp);
 static void
 pi_bracketneededegrps(dh_t	thisfileh,
@@ -939,7 +939,7 @@ restore_extent_group(drive_t *	drivep,
 		     int	fd,
 		     bool_t	ehcs,
 		     rv_t *	rvp);
-static bool_t restore_complete_reg(stream_context_t*);
+static bool_t restore_complete_reg(stream_context_t *);
 static bool_t restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path);
 static bool_t
 restore_symlink(drive_t *	drivep,
@@ -971,7 +971,7 @@ addobj(bag_t *	bagp,
        ix_t	indriveix);
 static size_t cntobj(bag_t *bagp);
 static bool_t gapneeded(egrp_t *firstegrpp, egrp_t *lastegrpp);
-static char * ehdr_typestr(int32_t type);
+static char *ehdr_typestr(int32_t type);
 static int egrpcmp(egrp_t *egrpap, egrp_t *egrpbp);
 static void
 display_dump_label(bool_t		lockpr,
@@ -992,7 +992,7 @@ static void pi_show(char *introstring);
 static void pi_show_nomloglock(void);
 
 static bool_t extattr_init(size_t drivecnt);
-static char * get_extattrbuf(ix_t which);
+static char *get_extattrbuf(ix_t which);
 static rv_t
 restore_extattr(drive_t *	drivep,
 		filehdr_t *	fhdrp,
@@ -1007,8 +1007,8 @@ static void setextattr(char *path, extattrhdr_t *ahdrp);
 static void
 partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
 	    off64_t offset, off64_t sz);
-static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
-static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
+static bool_t partial_check(xfs_ino_t ino, off64_t fsize);
+static bool_t partial_check2(partial_rest_t *isptr, off64_t fsize);
 static int do_fssetdm_by_handle(char *path, fsdmidata_t *fdmp);
 static int quotafilecheck(char *type, char *dstdir, char *quotafile);
 
@@ -1523,7 +1523,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	 * arguments. three cases: no dumps applied so far, or one or more
 	 * dumps applied completely, or restore session was interrupted
 	 */
-	persp = (pers_t *) mmap_autogrow(perssz, tranp->t_persfd, 0);
+	persp = (pers_t *)mmap_autogrow(perssz, tranp->t_persfd, 0);
 
 	if (persp == (pers_t *)-1) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -1873,8 +1873,8 @@ content_init(int argc, char *argv[], size64_t vmsz)
 			 (off_t)pgsz);
 	assert(! rval);
 	stpgcnt = newstpgcnt;
-	persp = (pers_t *) mmap_autogrow(perssz + stpgcnt * pgsz,
-					 tranp->t_persfd, 0);
+	persp = (pers_t *)mmap_autogrow(perssz + stpgcnt * pgsz,
+					tranp->t_persfd, 0);
 	if (persp == (pers_t *)-1) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			     "could not map persistent state file %s: %s\n"),
@@ -1968,7 +1968,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	 */
 	if (persp->a.dstdirisxfspr) {
 		void *fshanp;
-		size_t fshlen=0;
+		size_t fshlen = 0;
 
 		if (path_to_fshandle(persp->a.dstdir, &fshanp, &fshlen)) {
 			mlog(MLOG_NORMAL,
@@ -1989,11 +1989,11 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	 */
 	assert(! descp);
 	if (descpgcnt) {
-		descp = (pers_desc_t *) mmap_autogrow(descpgcnt * pgsz,
-						      tranp->t_persfd,
-						      (off_t)perssz
-						      +
-						      (off_t)(stpgcnt * pgsz));
+		descp = (pers_desc_t *)mmap_autogrow(descpgcnt * pgsz,
+						     tranp->t_persfd,
+						     (off_t)perssz
+						     +
+						     (off_t)(stpgcnt * pgsz));
 		if (descp == (pers_desc_t *)-1) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				     "could not map persistent state file inv %s: "
@@ -2830,9 +2830,9 @@ content_complete(void)
 	if (! persp) {
 		completepr = BOOL_TRUE;
 	} else if (! persp->a.valpr) {
-		completepr =  BOOL_TRUE;
+		completepr = BOOL_TRUE;
 	} else if (! persp->s.valpr) {
-		completepr =  BOOL_TRUE;
+		completepr = BOOL_TRUE;
 	} else {
 		completepr = BOOL_FALSE;
 	}
@@ -3881,7 +3881,7 @@ finalize(char *path1, char *path2)
 					      if (! ok) {
 						      return RV_INTR;
 					      }
-					      persp->s.dirattrdonepr = BOOL_TRUE;}
+					      persp->s.dirattrdonepr = BOOL_TRUE; }
 
 		/*
 		 * remove orphanage if empty
@@ -3891,7 +3891,7 @@ finalize(char *path1, char *path2)
 					       if (! ok) {
 						       return RV_INTR;
 					       }
-					       persp->s.orphdeltriedpr = BOOL_TRUE;}
+					       persp->s.orphdeltriedpr = BOOL_TRUE; }
 
 		/*
 		 * delete the persistent ino map
@@ -4142,11 +4142,11 @@ Media_mfile_next(Media_t *		Mediap,
 	/*
 	 * pass back hdr and drive ptrs
 	 */
-	*grhdrpp =  grhdrp;
-	*drhdrpp =  drhdrp;
-	*mrhdrpp =  mrhdrp;
-	*crhdrpp =  crhdrp;
-	*scrhdrpp =  scrhdrp;
+	*grhdrpp = grhdrp;
+	*drhdrpp = drhdrp;
+	*mrhdrpp = mrhdrp;
+	*crhdrpp = crhdrp;
+	*scrhdrpp = scrhdrp;
 	*drivepp = drivep;
 
 	/*
@@ -5267,11 +5267,11 @@ pi_allocdesc(dh_t *deschp)
 		 */
 		assert(stpgcnt <= (ix_t)INTGENMAX);
 		assert(newdescpgcnt > 0);
-		descp = (pers_desc_t *) mmap_autogrow(newdescpgcnt * pgsz,
-						      tranp->t_persfd,
-						      (off_t)perssz
-						      +
-						      (off_t)(stpgcnt * pgsz));
+		descp = (pers_desc_t *)mmap_autogrow(newdescpgcnt * pgsz,
+						     tranp->t_persfd,
+						     (off_t)perssz
+						     +
+						     (off_t)(stpgcnt * pgsz));
 		if (descp == (pers_desc_t *)(-1)) {
 			pi_unlock();
 			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
@@ -5808,7 +5808,7 @@ pi_addfile(Media_t *		Mediap,
 				ok = BOOL_FALSE;
 			} else {
 				/* extract the session information from the buffer */
-				if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
+				if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo) < 0) {
 					ok = BOOL_FALSE;
 				} else {
 					stobj_convert_sessinfo(&sessp, &sessinfo);
@@ -5862,7 +5862,7 @@ pi_transcribe(inv_session_t *sessp)
 	/*
 	 * traverse inventory, transcribing into pers inv.
 	 */
-	strmcnt =  (size_t)sessp->s_nstreams;
+	strmcnt = (size_t)sessp->s_nstreams;
 	for (strmix = 0; strmix < strmcnt; strmix++) {
 		inv_stream_t *strmp;
 		size_t fileix;
@@ -6236,11 +6236,11 @@ pi_scanfileendino(dh_t fileh)
 						assert(!(DH2F(nexth)->f_flags & PF_INV));
 						assert(!(DH2F(nexth)->f_flags & PF_TERM));
 						if (DH2F(nexth)->f_firstegrp.eg_off) {
-							ino =  DH2F(nexth)->f_firstegrp.eg_ino;
+							ino = DH2F(nexth)->f_firstegrp.eg_ino;
 							return ino;
 						} else {
 							assert(DH2F(nexth)->f_firstegrp.eg_ino > 0);
-							ino =  DH2F(nexth)->f_firstegrp.eg_ino - 1;
+							ino = DH2F(nexth)->f_firstegrp.eg_ino - 1;
 							return ino;
 						}
 					}
@@ -6766,7 +6766,7 @@ pi_neededobjs_free(bag_t *bagp)
 	bagiter_init(bagp, &bagiter);
 
 	bagobjp = 0;
-	while ((bagelemp = bagiter_next(&bagiter, (void **)&bagobjp) )) {
+	while ((bagelemp = bagiter_next(&bagiter, (void **)&bagobjp))) {
 		bag_remove(bagp, bagelemp, &dummykey, &dummypayloadp);
 		assert(bagobjp);
 		assert(bagobjp == (bagobj_t *)dummypayloadp);
@@ -7823,7 +7823,7 @@ set_file_owner(
 		mode &= ~S_ISUID;
 	}
 
-	if ((mode & (S_ISGID|S_IXGRP)) == (S_ISGID|S_IXGRP)) {
+	if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
 		mlog(MLOG_VERBOSE | MLOG_WARNING,
 		     _("stripping setgid bit on %s since chown failed\n"),
 		     path);
@@ -7955,7 +7955,7 @@ restore_reg(drive_t *	drivep,
 		assert(bstatp->bs_extsize >= 0);
 		memset((void *)&fsxattr, 0, sizeof(fsxattr));
 		fsxattr.fsx_xflags = bstatp->bs_xflags & ~POST_DATA_XFLAGS;
-		fsxattr.fsx_extsize = (uint32_t) bstatp->bs_extsize;
+		fsxattr.fsx_extsize = (uint32_t)bstatp->bs_extsize;
 		fsxattr.fsx_projid = bstat_projid(bstatp);
 
 		rval = ioctl(*fdp, XFS_IOC_FSSETXATTR, (void *)&fsxattr);
@@ -8770,7 +8770,7 @@ read_dirent(drive_t *		drivep,
 		default:
 			return RV_CORE;
 		}
-		assert((size_t) nread == remsz);
+		assert((size_t)nread == remsz);
 	}
 
 	return RV_OK;
@@ -9314,7 +9314,7 @@ setextattr(char *path, extattrhdr_t *ahdrp)
 	int rval;
 
 	isdmpr = (isrootpr &&
-		  ! strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr)-1));
+		  ! strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr) - 1));
 
 	/*
 	 * If restoreextattrpr not set, then we are here because -D was
@@ -9370,14 +9370,14 @@ dump_partials(void)
 	pi_lock();
 	printf("\npartial_reg: count=%d\n", (int)persp->a.parrestcnt);
 	if (persp->a.parrestcnt > 0) {
-		for (i=0; i < partialmax; i++) {
+		for (i = 0; i < partialmax; i++) {
 			if (persp->a.parrest[i].is_ino > 0) {
 				int j;
 
 				isptr = &persp->a.parrest[i];
 				printf("\tino=%llu ",
 				       (unsigned long long)isptr->is_ino);
-				for (j=0, bsptr=isptr->is_bs;
+				for (j = 0, bsptr = isptr->is_bs;
 				     j < drivecnt;
 				     j++, bsptr++)
 				{
@@ -9419,12 +9419,12 @@ check_valid_partials(void)
 
 	pi_lock();
 	if (persp->a.parrestcnt > 0) {
-		for (i=0; i < partialmax; i++) {
+		for (i = 0; i < partialmax; i++) {
 			if (persp->a.parrest[i].is_ino > 0) {
 				int j;
 
 				isptr = &persp->a.parrest[i];
-				for (j=0, bsptr=isptr->is_bs;
+				for (j = 0, bsptr = isptr->is_bs;
 				     j < drivecnt;
 				     j++, bsptr++)
 				{
@@ -9487,7 +9487,7 @@ partial_reg(ix_t	d_index,
 	 * Search for a matching inode.  Gaps can exist so we must search
 	 * all entries.
 	 */
-	for (i=0; i < partialmax; i++) {
+	for (i = 0; i < partialmax; i++) {
 		if (persp->a.parrest[i].is_ino == ino) {
 			isptr = &persp->a.parrest[i];
 			break;
@@ -9499,7 +9499,7 @@ partial_reg(ix_t	d_index,
 		mlog(MLOG_NITTY | MLOG_NOLOCK,
 		     "partial_reg: no entry found for %llu\n", ino);
 		/* find a free one */
-		for (i=0; i < partialmax; i++) {
+		for (i = 0; i < partialmax; i++) {
 			if (persp->a.parrest[i].is_ino == 0) {
 				int j;
 
@@ -9512,7 +9512,7 @@ partial_reg(ix_t	d_index,
 				 * used to decide if an entry is used or
 				 * not
 				 */
-				for (j=0, bsptr=isptr->is_bs;
+				for (j = 0, bsptr = isptr->is_bs;
 				     j < drivecnt; j++, bsptr++) {
 					bsptr->endoffset = 0;
 				}
@@ -9573,7 +9573,7 @@ found:
  * been restored by another dump stream.
  */
 static bool_t
-partial_check (xfs_ino_t ino, off64_t fsize)
+partial_check(xfs_ino_t ino, off64_t fsize)
 {
 	partial_rest_t *isptr = NULL;
 	bool_t ret;
@@ -9594,7 +9594,7 @@ partial_check (xfs_ino_t ino, off64_t fsize)
 	 * Search for the inode.  Gaps can exist so we must search
 	 * all entries.
 	 */
-	for (i=0; i < partialmax; i++) {
+	for (i = 0; i < partialmax; i++) {
 		if (persp->a.parrest[i].is_ino == ino) {
 			isptr = &persp->a.parrest[i];
 			break;
@@ -9637,7 +9637,7 @@ gapsearch:
 	 * span has been restored.  Bytespans are not necessarily in order
 	 * so the search is repeated from the start each time.
 	 */
-	for (i=0, bsptr=isptr->is_bs; i < drivecnt; i++, bsptr++) {
+	for (i = 0, bsptr = isptr->is_bs; i < drivecnt; i++, bsptr++) {
 		if (bsptr->endoffset > 0 &&
 		    bsptr->offset <= curoffset &&
 		    bsptr->endoffset > curoffset)
@@ -10190,7 +10190,7 @@ do_fssetdm_by_handle(
 	fsdmidata_t *	fdmp)
 {
 	void *hanp;
-	size_t hlen=0;
+	size_t hlen = 0;
 	int rc;
 
 	if (path_to_handle(path, &hanp, &hlen)) {
@@ -10221,7 +10221,7 @@ quotafilecheck(char *type, char *dstdir, char *quotafile)
 		dstdir,
 		quotafile);
 
-	if (stat (buf, &s) >= 0 && S_ISREG(s.st_mode)) {
+	if (stat(buf, &s) >= 0 && S_ISREG(s.st_mode)) {
 		mlog(MLOG_NORMAL, _(
 			     "%s quota information written to '%s'\n"),
 		     type,
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 380110a..69557a9 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -68,7 +68,7 @@
  * with a handle checksum.
  */
 #define HDLSUMCNT               4
-#define HDLSUMSHIFT             (NBBY * sizeof (dah_t) - HDLSUMCNT)
+#define HDLSUMSHIFT             (NBBY * sizeof(dah_t) - HDLSUMCNT)
 #define HDLSUMLOMASK            ((1 << HDLSUMCNT) - 1)
 #define HDLSUMMASK              (HDLSUMLOMASK << HDLSUMSHIFT)
 #define HDLDIXCNT               HDLSUMSHIFT
@@ -968,7 +968,7 @@ dirattr_flush()
 	/*
 	 * sanity checks
 	 */
-	assert (dtp);
+	assert(dtp);
 
 	if (dtp->dt_off) {
 		/*
diff --git a/restore/inomap.c b/restore/inomap.c
index 066cd75..2611d98 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -84,7 +84,7 @@ extern size_t pgsz;
  */
 static int map_getset(xfs_ino_t, int, bool_t);
 static int map_set(xfs_ino_t ino, int);
-static seg_t * map_getsegment(xfs_ino_t ino);
+static seg_t *map_getsegment(xfs_ino_t ino);
 
 /* definition of locally defined global variables ****************************/
 
@@ -239,7 +239,7 @@ inomap_restore_pers(drive_t *			drivep,
 	/*
 	 * mmap the persistent hdr and space for the map
 	 */
-	persp = (pers_t *) mmap_autogrow(
+	persp = (pers_t *)mmap_autogrow(
 		PERSSZ
 		+
 		sizeof(hnk_t) * (size_t)hnkcnt,
@@ -397,7 +397,7 @@ inomap_sync_pers(char *hkdir)
 	/*
 	 * mmap the persistent hdr
 	 */
-	persp = (pers_t *) mmap_autogrow(
+	persp = (pers_t *)mmap_autogrow(
 		PERSSZ,
 		pers_fd,
 		(off64_t)0);
@@ -420,7 +420,7 @@ inomap_sync_pers(char *hkdir)
 	 * mmap the pers inomap
 	 */
 	assert(hnkcnt * sizeof(hnk_t) <= (size64_t)INT32MAX);
-	roothnkp = (hnk_t *) mmap_autogrow(
+	roothnkp = (hnk_t *)mmap_autogrow(
 		sizeof(hnk_t) * (size_t)hnkcnt,
 		pers_fd,
 		(off64_t)PERSSZ);
diff --git a/restore/mmap.c b/restore/mmap.c
index dcce98c..851b33c 100644
--- a/restore/mmap.c
+++ b/restore/mmap.c
@@ -33,9 +33,9 @@ mmap_autogrow(size_t len, int fd, off_t offset)
 
 	/* prealloc file if it is an empty file */
 	if (fstat(fd, &buf) == -1) {;
-				    return (void*)MAP_FAILED;}
-	if (buf.st_size < offset+len) {
-		(void)lseek(fd, offset+len-1, SEEK_SET);
+				    return (void *)MAP_FAILED; }
+	if (buf.st_size < offset + len) {
+		(void)lseek(fd, offset + len - 1, SEEK_SET);
 		(void)write(fd, nul_buffer, 1);
 	}
 
diff --git a/restore/namreg.c b/restore/namreg.c
index e02fc17..883f379 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -241,7 +241,7 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 	 * mmap the persistent descriptor
 	 */
 	assert(!(NAMREG_PERS_SZ % pgsz));
-	npp = (namreg_pers_t *) mmap_autogrow(
+	npp = (namreg_pers_t *)mmap_autogrow(
 		NAMREG_PERS_SZ,
 		ntp->nt_fd,
 		(off_t)0);
@@ -491,7 +491,7 @@ namreg_get(nrh_t	nrh,
 	/*
 	 * copy the name into the caller-supplied buffer.
 	 */
-	strncpy(bufp, in_bufp+1, len);
+	strncpy(bufp, in_bufp + 1, len);
 
 #ifdef NAMREGCHK
 
@@ -524,7 +524,7 @@ namreg_map(void)
 		return rv;
 	}
 
-	ntp->nt_map = (char *) mmap_autogrow(
+	ntp->nt_map = (char *)mmap_autogrow(
 		npp->np_appendoff - NAMREG_PERS_SZ,
 		ntp->nt_fd,
 		NAMREG_PERS_SZ);
@@ -535,7 +535,7 @@ namreg_map(void)
 	 */
 	if (ntp->nt_map == (char *)-1) {
 		mlog(MLOG_DEBUG, "failed to map namreg: %s\n",
-		     strerror(errno) );
+		     strerror(errno));
 		ntp->nt_map = NULL;
 	}
 
diff --git a/restore/node.c b/restore/node.c
index 071f4c3..edfa947 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -51,7 +51,7 @@ extern size_t pgmask;
  * that xfsrestore can handle.
  */
 #define HDLGENCNT               4
-#define HDLGENSHIFT             (NBBY * sizeof (nh_t) - HDLGENCNT)
+#define HDLGENSHIFT             (NBBY * sizeof(nh_t) - HDLGENCNT)
 #define HDLGENLOMASK            ((1 << HDLGENCNT) - 1)
 #define HDLGENMASK              (HDLGENLOMASK << HDLGENSHIFT)
 #define HDLMASK                 ((1 << HDLGENSHIFT) - 1)
@@ -195,7 +195,7 @@ node_map_internal(nh_t nh, void **pp)
 		relnix_t relnix = nh2relnix(nh);
 		*pp = (void *)((char *)(*pp) +
 			       ((off64_t)relnix *
-				node_hdrp->nh_nodesz) );
+				node_hdrp->nh_nodesz));
 	}
 }
 
diff --git a/restore/tree.c b/restore/tree.c
index cfe2eca..3f77c9a 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -311,7 +311,7 @@ Node_alloc(xfs_ino_t	ino,
 	   dah_t	dah,
 	   size_t	flags);
 static void Node_free(nh_t *nhp);
-static node_t * Node_map(nh_t nh);
+static node_t *Node_map(nh_t nh);
 static void Node_unmap(nh_t nh, node_t **npp);
 static int
 Node2path_recurse(nh_t nh, char *buf,
@@ -487,7 +487,7 @@ tree_init(char *	hkdir,
 	 * mmap the persistent state
 	 */
 	assert(!(PERSSZ % pgsz));
-	persp = (treepers_t *) mmap_autogrow(
+	persp = (treepers_t *)mmap_autogrow(
 		PERSSZ,
 		tranp->t_persfd,
 		(off64_t)0);
@@ -677,7 +677,7 @@ tree_sync(char *	hkdir,
 	 * mmap the persistent state
 	 */
 	assert(!(PERSSZ % pgsz));
-	persp = (treepers_t *) mmap_autogrow(
+	persp = (treepers_t *)mmap_autogrow(
 		PERSSZ,
 		tranp->t_persfd,
 		(off64_t)0);
@@ -2067,9 +2067,9 @@ tree_cb_links(xfs_ino_t					ino,
 					mkdir_r(dir);
 				}
 
-				mlog (MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
-					      "ino %llu salvaging file,"
-					      " placing in %s\n"), ino, path1);
+				mlog(MLOG_VERBOSE | MLOG_NOTE | MLOG_TREE, _(
+					     "ino %llu salvaging file,"
+					     " placing in %s\n"), ino, path1);
 				ok = (*funcp)(contextp, path == path2,
 					      path1, path2);
 				if (! ok) {
@@ -2237,9 +2237,9 @@ tree_extattr_recurse(nh_t parh,
 	dah = parp->n_dah;
 	Node_unmap(parh, &parp);
 	if (! Node2path(parh, path, _("set dir extattr"))) {
-		mlog (MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
-			      "tree_extattr_recurse: Could not convert node to "
-			      "path for %s\n"), path);
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+			     "tree_extattr_recurse: Could not convert node to "
+			     "path for %s\n"), path);
 		return BOOL_TRUE;
 	}
 	if (dah != DAH_NULL) {
@@ -2363,7 +2363,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		/*
 		 * not real, refed, but not selected, can't help
 		 */
-		if (! isrealpr &&   isrefpr && ! isselpr) {
+		if (! isrealpr && isrefpr && ! isselpr) {
 			mlog(MLOG_NITTY | MLOG_TREE,
 			     "skipping node %x: not selected\n",
 			     nh);
@@ -2374,7 +2374,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		/*
 		 * if unreal, refed, sel, add to dst list,
 		 */
-		if (! isrealpr &&   isrefpr &&   isselpr) {
+		if (! isrealpr && isrefpr && isselpr) {
 			mlog(MLOG_NITTY | MLOG_TREE,
 			     "making node %x dst: "
 			     "not real, refed, sel\n",
@@ -2389,7 +2389,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		/*
 		 * if real, unrefed, sel, add to src list
 		 */
-		if (isrealpr && ! isrefpr &&   isselpr) {
+		if (isrealpr && ! isrefpr && isselpr) {
 			mlog(MLOG_NITTY | MLOG_TREE,
 			     "making node %x src: real, not refed, sel\n",
 			     nh);
@@ -2405,7 +2405,7 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 		 * real and referenced, leave alone (sel doesn't matter).
 		 * consider as a lnk src, since real and not going away.
 		 */
-		if (isrealpr && (isrefpr || ! isselpr) ) {
+		if (isrealpr && (isrefpr || ! isselpr)) {
 			mlog(MLOG_NITTY | MLOG_TREE,
 			     "skipping node %x: %s\n",
 			     nh,
@@ -3743,7 +3743,7 @@ Node2path_recurse(nh_t nh, char *buf, int bufsz, int level)
 	 */
 	oldbuf = buf;
 	oldbufsz = bufsz;
-	bufsz = Node2path_recurse(parh, buf, bufsz, level+1); /* RECURSION */
+	bufsz = Node2path_recurse(parh, buf, bufsz, level + 1); /* RECURSION */
 	if (bufsz <= 0) {
 		return bufsz;
 	}
@@ -4386,7 +4386,7 @@ hash_init(size64_t	vmsz,
 	assert(persp->p_hashsz <= SIZEMAX);
 	assert(!(persp->p_hashsz % (size64_t)pgsz));
 	assert(!(PERSSZ % pgsz));
-	tranp->t_hashp = (nh_t *) mmap_autogrow(
+	tranp->t_hashp = (nh_t *)mmap_autogrow(
 		(size_t)persp->p_hashsz,
 		tranp->t_persfd,
 		(off64_t)PERSSZ);
@@ -4437,7 +4437,7 @@ hash_sync(char *perspath)
 	assert(hashsz <= SIZEMAX);
 	assert(!(hashsz % (size64_t)pgsz));
 	assert(!(PERSSZ % pgsz));
-	tranp->t_hashp = (nh_t *) mmap_autogrow(
+	tranp->t_hashp = (nh_t *)mmap_autogrow(
 		(size_t)hashsz,
 		tranp->t_persfd,
 		(off64_t)PERSSZ);
@@ -4456,11 +4456,11 @@ static inline size_t
 hash_val(xfs_ino_t ino, size_t hashmask)
 {
 	ino += ~(ino << 15);
-	ino ^=  (ino >> 10);
-	ino +=  (ino << 3);
-	ino ^=  (ino >> 6);
+	ino ^= (ino >> 10);
+	ino += (ino << 3);
+	ino ^= (ino >> 6);
 	ino += ~(ino << 11);
-	ino ^=  (ino >> 16);
+	ino ^= (ino >> 16);
 	return (size_t)ino & hashmask;
 }
 
-- 
2.19.1
