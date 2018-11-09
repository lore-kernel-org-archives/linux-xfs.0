Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbeKJAN0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:13:26 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D8343082DDC
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:32:35 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 23/24] xfsdump: (style) add stars to multiline comments
Date: Fri,  9 Nov 2018 15:30:03 +0100
Message-Id: <20181109143004.24963-24-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

All lines of multiline comments should begin with a star.

Created by Uncrustify with this config file:

#
# uncrustify config, add stars to multiline comments
#

indent_with_tabs	= 2		# 1=indent with tabs, align with spaces, 2=use all tabs
input_tab_size		= 8		# original tab size
output_tab_size		= 8		# new tab size
indent_columns		= output_tab_size

indent_label		= 1		# pos: absolute col, neg: relative column

#
# inter-symbol newlines
#

nl_enum_brace		= remove	# "enum {" vs "enum
 {"
nl_union_brace		= remove	# "union {" vs "union
 {"
nl_struct_brace		= remove	# "struct {" vs "struct
 {"
nl_do_brace 		= remove	# "do {" vs "do
 {"
nl_if_brace 		= remove	# "if () {" vs "if ()
 {"
nl_for_brace 		= remove	# "for () {" vs "for ()
 {"
nl_else_brace 		= remove	# "else {" vs "else
 {"
nl_while_brace 		= remove	# "while () {" vs "while ()
 {"
nl_switch_brace 	= remove	# "switch () {" vs "switch ()
 {"
nl_brace_while		= remove	# "} while" vs "}
 while" - cuddle while
nl_brace_else		= remove	# "} else" vs "}
 else" - cuddle else
sp_brace_else		= force
sp_else_brace		= force
nl_func_var_def_blk	= 1
nl_fcall_brace		= remove	# "list_for_each() {" vs "list_for_each()
{"
nl_fdef_brace		= add		# "int foo() {" vs "int foo()
{"
nl_after_label_colon	= true		# "fail:
free(foo);" vs "fail: free(foo);"

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

cmt_star_cont = true

#
# other
#

nl_func_paren = remove
nl_func_decl_start = ignore
nl_func_decl_empty = remove
nl_func_decl_args = ignore
nl_func_decl_end = remove

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

eat_blanks_after_open_brace   = true
eat_blanks_before_close_brace = true
pp_indent = ignore

nl_start_of_file   = remove
nl_end_of_file     = force
nl_end_of_file_min = 1
nl_comment_func_def = 1

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/drive_minrmt.c |  8 ++--
 common/getdents.c     | 24 ++++++------
 common/hsmapi.c       | 26 ++++++-------
 common/inventory.c    | 16 ++++----
 common/inventory.h    |  6 +--
 common/main.c         |  6 +--
 common/media.c        |  4 +-
 common/ts_mtio.h      | 76 +++++++++++++++++++-------------------
 dump/content.c        |  6 +--
 dump/inomap.c         |  2 +-
 inventory/inv_api.c   | 54 +++++++++++++--------------
 inventory/inv_core.c  |  2 +-
 inventory/inv_fstab.c |  6 +--
 inventory/inv_idx.c   | 56 ++++++++++++++--------------
 inventory/inv_mgr.c   | 22 +++++------
 inventory/inv_oref.c  |  6 +--
 inventory/inv_oref.h  |  2 +-
 inventory/inv_priv.h  | 44 +++++++++++-----------
 inventory/inv_stobj.c | 86 +++++++++++++++++++++----------------------
 inventory/inventory.h | 12 +++---
 inventory/testmain.c  |  2 +-
 invutil/invidx.c      |  4 +-
 restore/content.c     |  2 +-
 23 files changed, 236 insertions(+), 236 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 28dd7d1..dc6d502 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -3098,7 +3098,7 @@ determine_write_error(int nwritten, int saved_errno)
 		(saved_errno == EIO)
 		||
 		((saved_errno == 0) && (nwritten >= 0))          /* short
-	                                                            write indicates EOM */
+	                                                          * write indicates EOM */
 		) {
 		mlog(MLOG_NORMAL,
 		     _("tape media error on write operation\n"));
@@ -4171,9 +4171,9 @@ erase_and_verify(drive_t *drivep)
 
 	/*
 	 * Erase is not standard rmt. So we cannot use the line below.
-
-	   (void)mt_op(contextp->dc_fd, MTERASE, 0);
-
+	 *
+	 * (void)mt_op(contextp->dc_fd, MTERASE, 0);
+	 *
 	 * So write a record of zeros to fake erase . Poor man's erase!
 	 * We put the ERASE_MAGIC string at the beginning so we can
 	 * detect if we have erased the tape.
diff --git a/common/getdents.c b/common/getdents.c
index 0f10741..9c9ed99 100644
--- a/common/getdents.c
+++ b/common/getdents.c
@@ -45,13 +45,13 @@ struct kernel_dirent64 {
 
 /*
  * The problem here is that we cannot simply read the next NBYTES
-   bytes.  We need to take the additional field into account.  We use
-   some heuristic.  Assuming the directory contains names with 14
-   characters on average we can compute an estimated number of entries
-   which fit in the buffer.  Taking this number allows us to specify a
-   reasonable number of bytes to read.  If we should be wrong, we can
-   reset the file descriptor.  In practice the kernel is limiting the
-   amount of data returned much more then the reduced buffer size.  */
+ * bytes.  We need to take the additional field into account.  We use
+ * some heuristic.  Assuming the directory contains names with 14
+ * characters on average we can compute an estimated number of entries
+ * which fit in the buffer.  Taking this number allows us to specify a
+ * reasonable number of bytes to read.  If we should be wrong, we can
+ * reset the file descriptor.  In practice the kernel is limiting the
+ * amount of data returned much more then the reduced buffer size.  */
 int
 getdents_wrap(int fd, char *buf, size_t nbytes)
 {
@@ -77,7 +77,7 @@ getdents_wrap(int fd, char *buf, size_t nbytes)
 
 	/*
 	 * If the structure returned by the kernel is identical to what we
-	   need, don't do any conversions.  */
+	 * need, don't do any conversions.  */
 	if (offsetof(struct dirent, d_name)
 	    == offsetof(struct kernel_dirent64, d_name)
 	    && sizeof(dp->d_ino) == sizeof(kdp->d_ino)
@@ -90,8 +90,8 @@ getdents_wrap(int fd, char *buf, size_t nbytes)
 		const size_t alignment = __alignof__(struct dirent);
 		/*
 		 * Since kdp->d_reclen is already aligned for the kernel
-		   structure this may compute a value that is bigger
-		   than necessary.  */
+		 * structure this may compute a value that is bigger
+		 * than necessary.  */
 		size_t old_reclen = kdp->d_reclen;
 		size_t new_reclen = ((old_reclen - size_diff + alignment - 1)
 				     & ~(alignment - 1));
@@ -105,8 +105,8 @@ getdents_wrap(int fd, char *buf, size_t nbytes)
 		    || (sizeof(dp->d_off) != sizeof(kdp->d_off))) {
 			/*
 			 * Overflow.  If there was at least one entry
-			   before this one, return them without error,
-			   otherwise signal overflow.  */
+			 * before this one, return them without error,
+			 * otherwise signal overflow.  */
 			if (last_offset != -1) {
 				lseek64(fd, last_offset, SEEK_SET);
 				return (char *)dp - buf;
diff --git a/common/hsmapi.c b/common/hsmapi.c
index 4ffc1fd..738edf9 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -45,7 +45,7 @@
 
 /*
  * DMF attribute name, size, and format as stored within XFS. (Stolen directly
-   from "dmfsapi/dmf_dmattr.H".
+ * from "dmfsapi/dmf_dmattr.H".
  */
 
 #define DMF_ATTR_NAME   "SGI_DMI_DMFATTR"       /* name of DMF's attr */
@@ -126,7 +126,7 @@ typedef struct {
 
 /*
  * The following definitions provide the internal format of the hsm_fs_ctxt_t
-   and hsm_f_ctxt_t structures, respectively.
+ * and hsm_f_ctxt_t structures, respectively.
  */
 
 typedef struct  {
@@ -217,7 +217,7 @@ HsmInitFsysContext(
 
 	/*
 	 * Malloc space for a filesystem context, and initialize any fields
-	   needed later by other routines.
+	 * needed later by other routines.
 	 */
 
 	if ((dmf_fs_ctxtp = malloc(sizeof(dmf_fs_ctxt_t))) == NULL) {
@@ -227,7 +227,7 @@ HsmInitFsysContext(
 
 	/*
 	 * Get the filesystem's handle for later use in building file
-	   handles in HsmInitFileContext.
+	 * handles in HsmInitFileContext.
 	 */
 	dmf_fs_ctxtp->fshanp = jdm_getfshandle((char *)mountpoint);
 	if (dmf_fs_ctxtp->fshanp == NULL) {
@@ -321,9 +321,9 @@ HsmEstimateFileSpace(
 	} else {
 		/*
 		 * This code is assuming that there are no MIG files, and so any
-		   file with DMAPI event bits set will be dumped as OFL. The
-		   non-dir dump size estimation will be somewhat low if there
-		   are MIG files.
+		 * file with DMAPI event bits set will be dumped as OFL. The
+		 * non-dir dump size estimation will be somewhat low if there
+		 * are MIG files.
 		 */
 		if ((statp->bs_mode & S_IFMT) != S_IFREG) {
 			return 0;       /* not a regular file */
@@ -486,8 +486,8 @@ HsmInitFileContext(
 
 	/*
 	 * We have a likely candidate, so we have to pay the price and look
-	   for the DMF attribute.  (It could be in a disk block separate from
-	   the inode.)
+	 * for the DMF attribute.  (It could be in a disk block separate from
+	 * the inode.)
 	 */
 	attr_op.am_opcode = ATTR_OP_GET;
 	attr_op.am_error = 0;
@@ -600,9 +600,9 @@ HsmModifyExtentMap(
 
 	/*
 	 * We are dumping a dualstate file.  Make it look like there is only
-	   one getbmapx extent and that it contains a hole which extends from
-	   the current offset to the end of the file.  The bmap[1].bmv_offset
-	   should already be correct.
+	 * one getbmapx extent and that it contains a hole which extends from
+	 * the current offset to the end of the file.  The bmap[1].bmv_offset
+	 * should already be correct.
 	 */
 
 	length = BTOBB(dmf_f_ctxtp->filesize) - bmap[1].bmv_offset;
@@ -670,7 +670,7 @@ HsmFilterExistingAttribute(
 
 	/*
 	 * Remove the existing DMF attribute, as we will later replace it with
-	   our own version.
+	 * our own version.
 	 */
 
 	*skip_entry = 1;
diff --git a/common/inventory.c b/common/inventory.c
index 7346ddd..d7609c0 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -58,7 +58,7 @@ inv_open(inv_predicate_t bywhat, void *pred)
 
 	/*
 	 * XXX also, see if it is too full. if so, make another and leave a
-	   reference to the new file in the old one */
+	 * reference to the new file in the old one */
 
 	stobjfd = get_storageobj(fd, &index);
 	if (stobjfd < 0) {
@@ -81,7 +81,7 @@ inv_open(inv_predicate_t bywhat, void *pred)
 	}
 	/*
 	 * create another storage object (and, an inv_index entry for it too)
-	   if we've filled this one up */
+	 * if we've filled this one up */
 	if ((uint)num >= sescnt->ic_maxnum) {
 #ifdef INVT_DEBUG
 		printf("$ creating a new storage obj & index entry. \n");
@@ -277,7 +277,7 @@ inv_writesession_open(
 
 	/*
 	 * we need to put the new session in the appropriate place in
-	   storage object. So first find out howmany sessions are there */
+	 * storage object. So first find out howmany sessions are there */
 
 	INVLOCK(fd, LOCK_EX);
 	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
@@ -289,7 +289,7 @@ inv_writesession_open(
 
 	/*
 	 * create the writesession, and get ready for the streams to come
-	   afterwards */
+	 * afterwards */
 	rval = create_session(sestok, fd, sescnt, ses, &hdr);
 	assert(rval > 0);
 
@@ -463,7 +463,7 @@ inv_stream_close(
 
 	/*
 	 * get the last media file to figure out what our last ino was.
-	   we have a pointer to that in the stream token */
+	 * we have a pointer to that in the stream token */
 	if (tok->md_lastmfile) {
 		if (strm.st_endino.ino != tok->md_lastmfile->mf_endino.ino ||
 		    strm.st_endino.offset != tok->md_lastmfile->mf_endino.offset) {
@@ -530,8 +530,8 @@ inv_put_mediafile(
 
 	/*
 	 * we dont free the mfile here. we always keep the last mfile
-	   around, inside the inv_stmtoken, and when we add a new mfile,
-	   we free the previous one. The last one is freed in stream_close()
+	 * around, inside the inv_stmtoken, and when we add a new mfile,
+	 * we free the previous one. The last one is freed in stream_close()
 	 */
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
@@ -636,7 +636,7 @@ inv_get_session(
 
 	/*
 	 * First get the session header, and the session information. Then
-	   we can figure out how much space to allocate */
+	 * we can figure out how much space to allocate */
 }
 
 
diff --git a/common/inventory.h b/common/inventory.h
index 7f81643..6d7c94e 100644
--- a/common/inventory.h
+++ b/common/inventory.h
@@ -82,8 +82,8 @@ typedef struct inv_stream {
 	xfs_ino_t	st_startino;    /* the starting pt */
 	off64_t		st_startino_off;
 	xfs_ino_t	st_endino;      /* where we actually ended up. this means
-	                                   we've written upto but not including
-	                                   this breakpoint. */
+	                                 * we've written upto but not including
+	                                 * this breakpoint. */
 	off64_t		st_endino_off;
 	int		st_nmediafiles; /* number of mediafiles */
 } inv_stream_t;
@@ -104,7 +104,7 @@ typedef struct inv_session {
 	time32_t	s_time;                 /* time of the dump */
 	u_char		s_level;                /* dump level */
 	char		s_label[INV_STRLEN];    /* session label, assigned by the
-	                                           operator */
+	                                         * operator */
 	char		s_mountpt[INV_STRLEN];  /* path to the mount point */
 	char		s_devpath[INV_STRLEN];  /* path to the device */
 } inv_session_t;
diff --git a/common/main.c b/common/main.c
index 16dee52..ee3c2bd 100644
--- a/common/main.c
+++ b/common/main.c
@@ -780,9 +780,9 @@ main(int argc, char *argv[])
 					(void)sigint_dialog();
 				}
 				/*
-				   mlog(MLOG_NORMAL,
-				      _("session interrupt in progress: "
-				      "please wait\n"));
+				 * mlog(MLOG_NORMAL,
+				 *    _("session interrupt in progress: "
+				 *    "please wait\n"));
 				 */
 			} else {
 				if (dlog_allowed()) {
diff --git a/common/media.c b/common/media.c
index bb7835f..c1d2b27 100644
--- a/common/media.c
+++ b/common/media.c
@@ -138,8 +138,8 @@ media_create(int argc, char *argv[], drive_strategy_t *dsp)
 	if (! medialabel) {
 		/*
 		 * not useful
-		   mlog(MLOG_VERBOSE,
-		      _("WARNING: no media label specified\n"));
+		 * mlog(MLOG_VERBOSE,
+		 *    _("WARNING: no media label specified\n"));
 		 */
 		medialabel = "";
 	}
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index 87faa15..5487a3f 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -92,7 +92,7 @@ typedef unsigned int minor_t;
 #define MTSCSI_CIPHER_SEC_OFF   0x6002  /* disable recovered error report */
 /*
  * These are meaningful only for Exabyte.  Default is to return
-        errors if read length is less than the block length */
+ *      errors if read length is less than the block length */
 #define MTSCSI_SILI             0x6003  /* suppress illegal length indication */
 #define MTSCSI_EILI             0x6004  /* enable illegal length indication.
 	                                 * currently implemented only for
@@ -242,27 +242,27 @@ struct  mtvid {
 };
 
 /*	structure for MTIOCGETBLKINFO - all quantities in bytes.
-        A value of 0 indicates no limit
-        When using the variable block size device, the lastread
-        field is determined by reading one block and then spacing
-        backwards, if no i/o has yet been done to this tape.  Unlike
-        MTIOCGETBLKSIZE, all quantities are in bytes.
+ *      A value of 0 indicates no limit
+ *      When using the variable block size device, the lastread
+ *      field is determined by reading one block and then spacing
+ *      backwards, if no i/o has yet been done to this tape.  Unlike
+ *      MTIOCGETBLKSIZE, all quantities are in bytes.
  */
 struct mtblkinfo {
 	unsigned	minblksz;       /* minimum block size */
 	unsigned	maxblksz;       /* maximum block size */
 	unsigned	curblksz;       /* size of block at last i/o.  For fixed
-	                                   mode, all requests must be a multiple of this. */
+	                                 * mode, all requests must be a multiple of this. */
 	unsigned	recblksz;       /* "recommended" size for i/o.  Mostly
-	                                   based on compatibility with earlier releases and/or
-	                                   other vendors */
+	                                 * based on compatibility with earlier releases and/or
+	                                 * other vendors */
 };
 
 
 /*	structure for MTSCSI_RDLOG
-        The fields in this structure reflect the values required in
-        the SCSI Log Sense command.  See a product manual for an
-        explanation of the fields.
+ *      The fields in this structure reflect the values required in
+ *      the SCSI Log Sense command.  See a product manual for an
+ *      explanation of the fields.
  */
 
 #define MTSCSI_LOGLEN   4096
@@ -329,7 +329,7 @@ struct mtaudio {
 	uchar_t			zero2	: 4, pno2 : 4;  /* fields should always be 0, or 0xA, when the */
 	uchar_t			zero3	: 4, pno3 : 4;  /* pno field is also 0xA, indicating not valid */
 	uchar_t			indexhi : 4, index : 4; /* index number within program; hi is the
-	                                                   most significant BCD digit, index the least. */
+	                                                 * most significant BCD digit, index the least. */
 	struct mtaudtimecode	ptime;                  /* program time */
 	struct mtaudtimecode	atime;                  /* absolute time */
 	struct mtaudtimecode	rtime;                  /* running time */
@@ -341,9 +341,9 @@ struct mtaudio {
 /* structure for MTCAPABILITY */
 struct mt_capablity {
 	int	mtsubtype;      /* this is NOT the same as mt_type, this is
-	                           the actual tape type, from invent.h, such as 9track, or DAT;
-	                           otherwise it is difficult to associate a particular device
-	                           with its type from a program. */
+	                         * the actual tape type, from invent.h, such as 9track, or DAT;
+	                         * otherwise it is difficult to associate a particular device
+	                         * with its type from a program. */
 	uint_t	mtcapablity;    /* the MTCAN* bits */
 	uint_t	mtfuture[8];    /* for future additions */
 };
@@ -355,21 +355,21 @@ struct mt_capablity {
 
 /*
  *      values for mt_dposn; values chosen for compatiblity with
-        existing programs!  Note that these bits and the gaps between
-        are also used in tpsc.h */
+ *      existing programs!  Note that these bits and the gaps between
+ *      are also used in tpsc.h */
 
 /*
  * The expected relative behaviour of MT_EW, MT_EOT and MTANSI can be
-   described as follows.
-   - writing from BOT, with MTANSI disabled, when LEOT is encountered,
-     MT_EW and MT_EOT are set. If MTANSI is now enabled, MT_EOT will be
-     reset and writing will be permitted until PEOT is encountered,
-     whereupon MT_EOT will again be set and will remain so until the
-     tape is repositioned.
-   - reading from BOT, MT_EOT will be set when PEOT is
-     encountered. LEOT is not normally reported by the drive, and therefore
-     MT_EW will normally not be set, unless the drive supports the REW mode
-     bit. (few do)
+ * described as follows.
+ * - writing from BOT, with MTANSI disabled, when LEOT is encountered,
+ *   MT_EW and MT_EOT are set. If MTANSI is now enabled, MT_EOT will be
+ *   reset and writing will be permitted until PEOT is encountered,
+ *   whereupon MT_EOT will again be set and will remain so until the
+ *   tape is repositioned.
+ * - reading from BOT, MT_EOT will be set when PEOT is
+ *   encountered. LEOT is not normally reported by the drive, and therefore
+ *   MT_EW will normally not be set, unless the drive supports the REW mode
+ *   bit. (few do)
  */
 
 #define MT_EOT          0x01    /* tape is at end of media */
@@ -614,12 +614,12 @@ struct mt_capablity {
 #define MTCAN_SEEK      0x20000         /* drive supports seeking to a particular
 	                                 * block (or sometimes program # if AUDIO supported) */
 #define MTCAN_CHTYPEANY 0x40000         /* drive can change density
-	                                   and/or fixed to variable at any point (if it can change at all).
-	                                   Otherwise it can change only at BOT */
+	                                 * and/or fixed to variable at any point (if it can change at all).
+	                                 * Otherwise it can change only at BOT */
 #define MTCANT_IMM      0x80000         /* drive doesn't work correctly when
-	                                   immediate mode rewind, etc. is enabled.  Setting this bit
-	                                   will disable immediate mode rewind on the drive, independent
-	                                   of the setting of tpsc_immediate_rewind (in master.d/tpsc) */
+	                                 * immediate mode rewind, etc. is enabled.  Setting this bit
+	                                 * will disable immediate mode rewind on the drive, independent
+	                                 * of the setting of tpsc_immediate_rewind (in master.d/tpsc) */
 #define MTCAN_COMPRESS  0x100000        /* drive supports compression */
 #define MTCAN_BUFFM     0x200000        /* drive supports writing of
 	                                 * buffered filemarks */
@@ -672,11 +672,11 @@ struct mt_fpmsg {
 			char	msg_type	: 3,    /* Message type: 0x00 = General
 			                                 * Status message */
 				msg_cntrl	: 3,    /* Message control:
-			                                   0 = Display message 0
-			                                   1 = Display message 1
-			                                   2 = Flash message 0
-			                                   3 = Flash message 1
-			                                   4 = Alternate message 0 and 1
+			                                 * 0 = Display message 0
+			                                 * 1 = Display message 1
+			                                 * 2 = Flash message 0
+			                                 * 3 = Flash message 1
+			                                 * 4 = Alternate message 0 and 1
 			                                 */
 				rsvd1 : 2;
 			char	rsvd2[4];
diff --git a/dump/content.c b/dump/content.c
index ddda3df..64f6029 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -172,8 +172,8 @@ struct context {
 	hsm_f_ctxt_t *	cc_hsm_f_ctxtp;
 	/*
 	 * pre-allocated HSM context used for holding HSM
-	   state information about a file across subroutine
-	   calls.
+	 * state information about a file across subroutine
+	 * calls.
 	 */
 	char *		cc_readlinkbufp;
 	size_t		cc_readlinkbufsz;
@@ -4139,7 +4139,7 @@ dump_file(void *		arg1,
 		return RV_OK;
 		/*
 		 * not yet implemented
-		   case S_IFMNT:
+		 * case S_IFMNT:
 		 */
 	}
 
diff --git a/dump/inomap.c b/dump/inomap.c
index 44d3724..12b3d2c 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1790,7 +1790,7 @@ estimate_dump_space(xfs_bstat_t *statp)
 	case S_IFLNK:
 		/*
 		 * not yet
-		   case S_IFUUID:
+		 * case S_IFUUID:
 		 */
 		return 0;
 	default:
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index 3d684f2..2494978 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -63,7 +63,7 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 
 	/*
 	 * if we just want to search the db, all we need is the invidx.
-	   at this point, we know that a tok wasnt created in init_idb() */
+	 * at this point, we know that a tok wasnt created in init_idb() */
 	if (forwhat == INV_SEARCH_ONLY) {
 		/* fd == I_EMPTYINV or fd == valid fd */
 		tok = get_token(fd, -1);
@@ -73,7 +73,7 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 
 	/*
 	 * XXX also, see if it is too full. if so, make another and leave a
-	   reference to the new file in the old one */
+	 * reference to the new file in the old one */
 
 	stobjfd = idx_get_stobj(fd, forwhat, &index);
 	if (stobjfd < 0) {
@@ -96,7 +96,7 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 
 	/*
 	 * create another storage object (and, an inv_index entry for it
-	   too) if we've filled this one up */
+	 * too) if we've filled this one up */
 
 	if ((uint)num >= sescnt->ic_maxnum) {
 		mlog(MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
@@ -216,7 +216,7 @@ inv_writesession_open(
 
 	/*
 	 * we need to put the new session in the appropriate place in
-	   storage object. So first find out howmany sessions are there */
+	 * storage object. So first find out howmany sessions are there */
 
 	INVLOCK(fd, LOCK_EX);
 	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
@@ -227,7 +227,7 @@ inv_writesession_open(
 
 	/*
 	 * create the writesession, and get ready for the streams to come
-	   afterwards */
+	 * afterwards */
 	rval = stobj_create_session(sestok, fd, sescnt, &ses, &hdr);
 	assert(rval > 0);
 
@@ -397,7 +397,7 @@ inv_stream_close(
 
 		/*
 		 * get the last media file to figure out what our last
-		   ino was. we have a pointer to that in the stream token */
+		 * ino was. we have a pointer to that in the stream token */
 		if (tok->md_lastmfile) {
 			if (strm.st_endino.ino !=
 			    tok->md_lastmfile->mf_endino.ino ||
@@ -475,8 +475,8 @@ inv_put_mediafile(
 
 	/*
 	 * This flag is used to indicate the media file that contains the
-	   dump of the sessioninfo structure that contains all but this
-	   media file */
+	 * dump of the sessioninfo structure that contains all but this
+	 * media file */
 	if (isinvdump)
 		mf->mf_flag |= INVT_MFILE_INVDUMP;
 
@@ -486,8 +486,8 @@ inv_put_mediafile(
 
 	/*
 	 * we dont free the mfile here. we always keep the last mfile
-	   around, inside the inv_stmtoken, and when we add a new mfile,
-	   we free the previous one. The last one is freed in stream_close()
+	 * around, inside the inv_stmtoken, and when we add a new mfile,
+	 * we free the previous one. The last one is freed in stream_close()
 	 */
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
@@ -531,7 +531,7 @@ inv_get_sessioninfo(
 
 	/*
 	 * Next we get the session header, and the session information. Then
-	   we can figure out how much space to allocate */
+	 * we can figure out how much space to allocate */
 	if (stobj_get_sessinfo(tok, &hdr, &ses) <= 0) {
 		INVLOCK(fd, LOCK_UN);
 		return BOOL_FALSE;
@@ -766,22 +766,22 @@ inv_delete_mediaobj(uuid_t *moid)
 
 	/*
 	 * forall fsids (fs) in fstab {
-	       open invindex table (t)
-	       forall indices (i) in t {
-	          open stobj (st)
-	          forall sessions (s) in st {
-	              forall streams (strm) in s {
-	                 forall mediafiles (m) in strm {
-	                     if (m.mediaobj == moid) {
-	                     // delete m
-	                     if (--strm.nmediafiles == 0)
-	                        if (--s.nstreams == 0)
-	                            delete-session (s)
-	                     }
-	                 }
-	              }
-	         }
-	      }
+	 *     open invindex table (t)
+	 *     forall indices (i) in t {
+	 *        open stobj (st)
+	 *        forall sessions (s) in st {
+	 *            forall streams (strm) in s {
+	 *               forall mediafiles (m) in strm {
+	 *                   if (m.mediaobj == moid) {
+	 *                   // delete m
+	 *                   if (--strm.nmediafiles == 0)
+	 *                      if (--s.nstreams == 0)
+	 *                          delete-session (s)
+	 *                   }
+	 *               }
+	 *            }
+	 *       }
+	 *    }
 	 */
 
 	invt_counter_t *cnt;
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index 00e8d1a..340c75e 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -221,7 +221,7 @@ get_lastheader(int fd, void **ent, size_t hdrsz, size_t cntsz)
 
 	/*
 	 * if there's space anywhere at all, then it must be in the last
-	   entry */
+	 * entry */
 	*ent = malloc(hdrsz);
 	pos = (char *)arr + ((uint)nindices - 1) * hdrsz;
 	memcpy(*ent, pos, hdrsz);
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 17ff6d7..3f1cbf0 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -74,7 +74,7 @@ fstab_getall(invt_fstab_t **arr, invt_counter_t **cnt, int *numfs,
 #endif
 	/*
 	 * fstab is left locked EX on exit. The caller takes does
-	   the unlocking */
+	 * the unlocking */
 	return fd;
 }
 
@@ -122,7 +122,7 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 		for (i = 0; i < numfs; i++) {
 			if (uuid_compare(*fsidp, arr[i].ft_uuid) == 0) {
 /*			if ((STREQL(arr[i].ft_mountpt, mntpt) ) &&
-                            (STREQL(arr[i].ft_devpath, dev) ))
+ *                          (STREQL(arr[i].ft_devpath, dev) ))
  */
 				free(arr);
 				free(cnt);
@@ -136,7 +136,7 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 
 	/*
 	 * make a new fstab entry and insert it at the end. the table
-	   is locked EXclusively at this point */
+	 * is locked EXclusively at this point */
 	{
 		invt_fstab_t ent;
 		off64_t hoff;
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 907cab3..edafe28 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -53,11 +53,11 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 
 /*	invt_entry_t ient;
-        ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end = tm; */
+ *      ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end = tm; */
 
 	/*
 	 * If time period of the new entry is before our first invindex,
-	   we have to insert a new invindex in the first slot */
+	 * we have to insert a new invindex in the first slot */
 	if (iarr[0].ie_timeperiod.tp_start > tm) {
 		/* *stobjfd = idx_put_newentry(fd, 0, iarr, icnt, &ient); */
 		*stobjfd = open(iarr[0].ie_filename, INV_OFLAG(forwhat));
@@ -67,7 +67,7 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 	for (i = 0; i < icnt->ic_curnum; i++) {
 		/*
 		 * if our time is nicely within an existing entry's time
-		   period, hellalujah */
+		 * period, hellalujah */
 		if (IS_WITHIN(&iarr[i].ie_timeperiod, tm)) {
 #ifdef INVT_DEBUG
 			mlog(MLOG_DEBUG | MLOG_INV, "INV: is_within %d\n", i);
@@ -102,21 +102,21 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 
 		/*
 		 * if it is beyond the end of this timeperiod, see if we
-		   belong to a timeperiod that doesn't have an entry */
+		 * belong to a timeperiod that doesn't have an entry */
 		if (iarr[i].ie_timeperiod.tp_end < tm) {
 			/* see if we're the last entry here */
 			if (i == icnt->ic_curnum - 1) {
 				/*
 				 * our slot is (i+1)th entry. Make the
-				   timeperiod's the same as it was. As far
-				   as I can see there is no way that
-				   timeperiods can overlap.
-
-				   insert the new entry and write back
-				   icnt and invindex entry */
+				 * timeperiod's the same as it was. As far
+				 * as I can see there is no way that
+				 * timeperiods can overlap.
+				 *
+				 * insert the new entry and write back
+				 * icnt and invindex entry */
 				/*
 				 * *stobjfd = idx_put_newentry(fd, i+1, iarr,
-				                             icnt, &ient); */
+				 *                           icnt, &ient); */
 				*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 				return i;
 			}
@@ -124,10 +124,10 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 			if (iarr[i + 1].ie_timeperiod.tp_start > tm) {
 				/*
 				 * We have the option of pushing entries
-				   after (i) forward by one slot, and
-				   taking the (i+1)th slot, OR just hooking
-				   up with the next entry.
-				   We choose the former. */
+				 * after (i) forward by one slot, and
+				 * taking the (i+1)th slot, OR just hooking
+				 * up with the next entry.
+				 * We choose the former. */
 
 				/* the timeperiods had better not overlap */
 				assert((tm > iarr[i].ie_timeperiod.tp_end) &&
@@ -135,11 +135,11 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 
 				/*
 				 * shift everything from (i+1) onwards by
-				   one. Then insert the new entry and write
-				   back icnt and invindex entries */
+				 * one. Then insert the new entry and write
+				 * back icnt and invindex entries */
 				/*
 				 * *stobjfd = idx_put_newentry(fd, i+1, iarr,
-				                             icnt, &ient); */
+				 *                           icnt, &ient); */
 				*stobjfd = open(iarr[i].ie_filename, INV_OFLAG(forwhat));
 				return i;
 			}
@@ -224,8 +224,8 @@ idx_find_stobj(invt_idxinfo_t * idx,
 
 	/*
 	 * since sessions can be inserted in random order, the invindex
-	   table can contain time-periods that don't have corresponding
-	   entries for */
+	 * table can contain time-periods that don't have corresponding
+	 * entries for */
 	if (GET_ALLHDRS_N_CNTS_NOLOCK(idx->invfd, (void **)&idx->iarr,
 				      (void **)&idx->icnt,
 				      sizeof(invt_entry_t),
@@ -240,7 +240,7 @@ idx_find_stobj(invt_idxinfo_t * idx,
 
 	/*
 	 * Now figure out where we are going to insert this stobj among the
-	   invindices and put it there */
+	 * invindices and put it there */
 	idx->index = idx_insert_newentry(idx->invfd, &stobjfd, idx->iarr,
 					 idx->icnt, tm);
 
@@ -266,7 +266,7 @@ idx_create(char *fname, inv_oflag_t forwhat)
 
 	/*
 	 * This is not to be called when the user wants to open
-	   the db for SEARCH_ONLY. */
+	 * the db for SEARCH_ONLY. */
 	assert(forwhat != INV_SEARCH_ONLY);
 
 	if ((fd = open(fname, INV_OFLAG(forwhat) | O_CREAT, S_IRUSR | S_IWUSR)) < 0) {
@@ -377,9 +377,9 @@ idx_put_sesstime(inv_sestoken_t tok, bool_t whichtime)
 
 /*
  * an inventory index entry keeps track of a single storage object;
-   it knows about its name (ie filename) and the timeperiod that the
-   it contains dump sessions for.
-   note that each file system has its own (set of) inventory indices.
+ * it knows about its name (ie filename) and the timeperiod that the
+ * it contains dump sessions for.
+ * note that each file system has its own (set of) inventory indices.
  */
 
 /*----------------------------------------------------------------------*/
@@ -433,7 +433,7 @@ idx_create_entry(
 
 		/*
 		 * XXX check if there are too many indices. if so, create
-		   another and leave a pointer to that in here */
+		 * another and leave a pointer to that in here */
 
 		/* create the new storage object */
 		fd = stobj_create(ent.ie_filename);
@@ -483,7 +483,7 @@ idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index)
 
 	/*
 	 * if there's space anywhere at all, then it must be in the last
-	   entry. get_lastheader() does the locking */
+	 * entry. get_lastheader() does the locking */
 
 	if ((*index = get_lastheader(invfd, (void **)&ent,
 				     sizeof(invt_entry_t),
@@ -491,7 +491,7 @@ idx_get_stobj(int invfd, inv_oflag_t forwhat, int *index)
 		return -1;
 	/*
 	 * at this point we know that there should be at least one invindex
-	   entry present */
+	 * entry present */
 	assert(ent != NULL);
 	assert(ent->ie_filename);
 
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index e332295..2ac1323 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -59,7 +59,7 @@ init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 
 	/*
 	 * come up with the unique file suffix that refers to this
-	   filesystem */
+	 * filesystem */
 	if (fstab_get_fname(pred, uuname, bywhat, forwhat) < 0) {
 		return I_DONE;
 	}
@@ -76,7 +76,7 @@ init_idb(void *pred, inv_predicate_t bywhat, inv_oflag_t forwhat,
 		} else {
 			/*
 			 * this happens when the inv is empty and the user
-			   wants to do a search. this is legal - not an error */
+			 * wants to do a search. this is legal - not an error */
 			return I_EMPTYINV;
 		}
 		return I_DONE; /* we are done whether token's NULL or not */
@@ -209,7 +209,7 @@ invmgr_query_all_sessions(
 
 	/*
 	 * return val indicates if there was an error or not. *buf
-	   says whether the search was successful */
+	 * says whether the search was successful */
 	return ret;
 }
 
@@ -260,7 +260,7 @@ search_invt(
 
 	/*
 	 * we need to get all the invindex headers and seshdrs in reverse
-	   order */
+	 * order */
 	for (i = nindices - 1; i >= 0; i--) {
 		int nsess, j;
 		invt_sescounter_t *scnt = NULL;
@@ -292,7 +292,7 @@ search_invt(
 
 			/*
 			 * fd is kept locked until we return from the
-			   callback routine */
+			 * callback routine */
 
 			/*
 			 * Check to see if this session has been pruned
@@ -405,7 +405,7 @@ invmgr_inv_print(
 		for (s = 0; s < nsess; s++) {
 			/*
 			 * fd is kept locked until we return from the
-			   callback routine */
+			 * callback routine */
 
 			/*
 			 * Check to see if this session has been pruned
@@ -630,11 +630,11 @@ insert_session(invt_sessinfo_t *s)
 
 	/*
 	 * at this point we know that invindex has at least one entry
-
-	   First we need to find out if this session is in the inventory
-	   already. To find the storage object that can possibly
-	   contain this session, it suffices to sequentially search the
-	   inventory indices of this filesystem for the particular invt-entry
+	 *
+	 * First we need to find out if this session is in the inventory
+	 * already. To find the storage object that can possibly
+	 * contain this session, it suffices to sequentially search the
+	 * inventory indices of this filesystem for the particular invt-entry
 	 */
 	INVLOCK(invfd, LOCK_EX);
 	idx.invfd = invfd;
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index 7260da7..26bf8bd 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -317,7 +317,7 @@ oref_resolve(
 
 	/*
 	 * come up with the unique file suffix that refers to this
-	   filesystem */
+	 * filesystem */
 	if (fstab_get_fname(pred, uuname, bywhat) < 0) {
 		return INV_ERR;
 	}
@@ -355,7 +355,7 @@ oref_resolve(
 
 	/*
 	 * create another storage object (and, an inv_index entry for it
-	   too) if we've filled this one up */
+	 * too) if we've filled this one up */
 	if (OREF_CNT_CURNUM(stobj) >= OREF_CNT_MAXNUM(stobj)) {
 		int rval;
 #ifdef INVT_DEBUG
@@ -401,7 +401,7 @@ oref_resolve_child(
 
 	/*
 	 * at this point we know that there should be at least one invindex
-	   entry present */
+	 * entry present */
 	assert(ent != NULL);
 	assert(ent->ie_filename);
 
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index 7de9441..f5c9515 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -40,7 +40,7 @@
 
 /*
  * Indicates if either its child or its parent has been resolved.
-   Only one kin per object can exist. i.e. a child cant have children.*/
+ * Only one kin per object can exist. i.e. a child cant have children.*/
 #define INVT_RES_CHILD          0x1000
 #define INVT_RES_PARENT         0x2000
 #define INVT_RES_KIN            INVT_RES_PARENT | INVT_RES_CHILD
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 63fd785..1cd90f9 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -109,16 +109,16 @@ typedef struct invt_session {
 	char	s_mountpt[INV_STRLEN];  /* path to the mount point */
 	char	s_devpath[INV_STRLEN];  /* path to the device */
 	uint	s_cur_nstreams;         /* number of streams created under
-	                                   this session so far */
+	                                 * this session so far */
 	uint	s_max_nstreams;         /* number of media streams in
-	                                   the session */
+	                                 * the session */
 	char	s_padding[16];
 } invt_session_t;
 
 typedef struct invt_seshdr {
 	off64_t		sh_sess_off;    /* offset to rest of the sessioninfo */
 	off64_t		sh_streams_off; /* offset to start of the set of
-	                                   stream hdrs */
+	                                 * stream hdrs */
 	time32_t	sh_time;        /* time of the dump */
 	uint32_t	sh_flag;        /* for misc flags */
 	u_char		sh_level;       /* dump level */
@@ -129,10 +129,10 @@ typedef struct invt_seshdr {
 
 /*
  * Each session consists of a number of media streams. While it is given that
-   there won't be multiple writesessions (ie. dumpsessions) concurrently,
-   there can be multiple media streams operating on a single file system,
-   each writing media files within its own stream. Hence, we have a linked
-   list of media files, that the stream keeps track of. */
+ * there won't be multiple writesessions (ie. dumpsessions) concurrently,
+ * there can be multiple media streams operating on a single file system,
+ * each writing media files within its own stream. Hence, we have a linked
+ * list of media files, that the stream keeps track of. */
 
 
 typedef struct invt_breakpt {
@@ -144,8 +144,8 @@ typedef struct invt_stream {
 	/* duplicate info from mediafiles for speed */
 	invt_breakpt_t	st_startino;            /* the starting pt */
 	invt_breakpt_t	st_endino;              /* where we actually ended up. this
-	                                           means we've written upto but not
-	                                           including this breakpoint. */
+	                                         * means we've written upto but not
+	                                         * including this breakpoint. */
 	off64_t		st_firstmfile;          /*offsets to the start and end of*/
 	off64_t		st_lastmfile;           /* .. linked list of mediafiles */
 	char		st_cmdarg[INV_STRLEN];  /* drive path */
@@ -161,7 +161,7 @@ typedef struct invt_mediafile {
 	char		mf_label[INV_STRLEN];   /* media file label */
 	invt_breakpt_t	mf_startino;            /* file that we started out with */
 	invt_breakpt_t	mf_endino;              /* the dump file we ended this
-	                                           media file with */
+	                                         * media file with */
 	off64_t		mf_nextmf;              /* links to other mfiles */
 	off64_t		mf_prevmf;
 	uint		mf_mfileidx;            /* index within the media object */
@@ -187,9 +187,9 @@ typedef struct invt_entry {
 #define INVT_COUNTER_FIELDS  \
 	uint32_t ic_vernum;     /* on disk version number for posterity */ \
 	uint ic_curnum;         /* number of sessions/invindices recorded \
-	                           so far */                              \
+	                         * so far */                              \
 	uint ic_maxnum;         /* maximum number of sessions/inv_indices \
-	                           that we can record on this stobj */
+	                         * that we can record on this stobj */
 #define INVT_COUNTER_FIELDS_SIZE 0xc
 
 typedef struct invt_counter {
@@ -200,7 +200,7 @@ typedef struct invt_counter {
 typedef struct invt_sescounter {
 	INVT_COUNTER_FIELDS
 	off64_t ic_eof;          /* current end of the file, where the next
-	                            media file or stream will be written to */
+	                         *  media file or stream will be written to */
 	char	ic_padding[0x20 - (INVT_COUNTER_FIELDS_SIZE +
 				   sizeof(off64_t))];
 } invt_sescounter_t;
@@ -223,12 +223,12 @@ typedef struct invt_desc_entry {
 	int		d_invindex_fd;  /* open file descriptor of inv index */
 	int		d_stobj_fd;     /* fd of storage object */
 	u_char		d_update_flag;  /* indicates whether fstab was updated with
-	                                   this file system or not and also if
-	                                   we had to create a new invindex file */
+	                                 * this file system or not and also if
+	                                 * we had to create a new invindex file */
 	inv_oflag_t	d_oflag;        /* the open mode (SEARCH_ONLY, SEARCH_N_MOD) */
 	off64_t		d_invindex_off; /* for every session, we need a reference
-	                                   to its invindex entry, so that when we
-	                                   close a session, we know which one */
+	                                 * to its invindex entry, so that when we
+	                                 * close a session, we know which one */
 } invt_desc_entry_t;
 
 
@@ -237,7 +237,7 @@ typedef struct invt_sesdesc_entry {
 	off64_t			sd_session_off;
 	off64_t			sd_sesshdr_off;
 	time32_t		sd_sesstime; /* time that session started.
-	                                        needed for closing the session */
+	                                      * needed for closing the session */
 } invt_sesdesc_entry_t;
 
 struct invt_mediafile;
@@ -245,11 +245,11 @@ struct invt_mediafile;
 typedef struct invt_strdesc_entry {
 	invt_sesdesc_entry_t *	md_sesstok;     /* the session token */
 	off64_t			md_stream_off;  /* offset to the media stream
-	                                           header */
+	                                         * header */
 	struct invt_mediafile * md_lastmfile;   /* just so that we dont have
-	                                           to get it back from disk
-	                                           when we add the next mfile
-	                                           to the linked list */
+	                                         * to get it back from disk
+	                                         * when we add the next mfile
+	                                         * to the linked list */
 } invt_strdesc_entry_t;
 
 
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 6956850..648f53d 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -62,7 +62,7 @@ stobj_insert_session(invt_idxinfo_t *	idx,
 
 	/*
 	 * Check the existing sessions to make sure that we're not
-	   duplicating this session */
+	 * duplicating this session */
 	if (sescnt->ic_curnum > 0) {
 		uint i;
 		invt_session_t *sessions = calloc(sescnt->ic_curnum,
@@ -139,9 +139,9 @@ stobj_find_splitpoint(int fd, invt_seshdr_t *harr, uint ns, time32_t tm)
 
 	/*
 	 * All the entries have the same sh_time. It's not clear if that's
-	   really possible, but either way, we split at the last entry.
-	   This will impact the guarantee that invindex tries to give - that
-	   there's always a unique stobj for every session. */
+	 * really possible, but either way, we split at the last entry.
+	 * This will impact the guarantee that invindex tries to give - that
+	 * there's always a unique stobj for every session. */
 	mlog(MLOG_VERBOSE | MLOG_INV, _(
 		     "INV: failed to find a different sh_time to split\n")
 	     );
@@ -193,8 +193,8 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 
 	/*
 	 * Get the new stobj to put the 'spilling' sessinfo in. We know the
-	   idx of the current stobj, and by definition, the new stobj
-	   should come right afterwards. */
+	 * idx of the current stobj, and by definition, the new stobj
+	 * should come right afterwards. */
 	newsess->stobjfd = idx_put_newentry(idx, &ient);
 	if (newsess->stobjfd < 0)
 		return -1;
@@ -205,7 +205,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 
 		/*
 		 * We dont need to split. So, just put the new session in
-		   the new stobj, and rest in peace */
+		 * the new stobj, and rest in peace */
 		idx->index++;
 
 		if (GET_SESCOUNTERS(newsess->stobjfd, &scnt) < 0)
@@ -236,7 +236,7 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 			return -1;
 		/*
 		 * Now we need to put this in the new StObj. So, first
-		   unpack it. */
+		 * unpack it. */
 		if (! stobj_unpack_sessinfo(bufpp, bufszp, &sesinfo))
 			return -1;
 
@@ -253,9 +253,9 @@ stobj_split(invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	}
 	/*
 	 * Put the new session in the stobj that we just split. Make
-	   sure that we use the updated sescnt and not the stale stuff
-	   from disk. stobj_put_session() writes sescnt and sessinfo to
-	   disk */
+	 * sure that we use the updated sescnt and not the stale stuff
+	 * from disk. stobj_put_session() writes sescnt and sessinfo to
+	 * disk */
 	if (stobj_put_session(fd, sescnt, newsess->ses, newsess->seshdr,
 			      newsess->strms, newsess->mfiles) < 0) {
 		free(sescnt);
@@ -288,13 +288,13 @@ stobj_delete_sessinfo(int fd, /* kept locked EX by caller */
 {
 	/*
 	 * we change the sescnt here, but dont write it back to disk
-	   until later */
+	 * until later */
 	sescnt->ic_curnum--;
 
 	/*
 	 * there is really no need to take out / zero out the deleted
-	   session. The seshdr and session will be over-written, but
-	   space taken by the streams and mediafiles will be wasted. */
+	 * session. The seshdr and session will be over-written, but
+	 * space taken by the streams and mediafiles will be wasted. */
 	return BOOL_TRUE;
 }
 
@@ -336,7 +336,7 @@ stobj_put_session(
 
 	/*
 	 * we need to know where the streams begin, and where the
-	   media files will begin, at the end of the streams */
+	 * media files will begin, at the end of the streams */
 	hdr->sh_streams_off = sescnt->ic_eof;
 
 	if (strms == NULL) {
@@ -468,7 +468,7 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 
 		/*
 		 * adjust the offsets of the first and the last elements
-		   in the mediafile chain */
+		 * in the mediafile chain */
 		mfiles[nmfiles].mf_prevmf = 0;
 		nmfiles += strms[i].st_nmediafiles;
 		mfiles[nmfiles - 1].mf_nextmf = 0;
@@ -612,8 +612,8 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 
 	/*
 	 * first we need to find out where the current write-position is.
-	   so, we first read the sescounter that is at the top of this
-	   storage object */
+	 * so, we first read the sescounter that is at the top of this
+	 * storage object */
 	if (GET_SESCOUNTERS(fd, &sescnt) < 0)
 		return -1;
 
@@ -627,8 +627,8 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 
 	/*
 	 * get the stream information, and update number of mediafiles.
-	   we also need to link the new mediafile into the linked-list of
-	   media files of this stream */
+	 * we also need to link the new mediafile into the linked-list of
+	 * media files of this stream */
 
 	if (GET_REC_NOLOCK(fd, &stream, sizeof(stream),
 			   tok->md_stream_off) < 0)
@@ -636,9 +636,9 @@ stobj_put_mediafile(inv_stmtoken_t tok, invt_mediafile_t *mf)
 
 	/*
 	 * We need to update the last ino of this STREAM, which is now the
-	   last ino of the new mediafile. If this is the first mediafile, we
-	   have to update the startino as well. Note that ino is a <ino, off>
-	   tuple */
+	 * last ino of the new mediafile. If this is the first mediafile, we
+	 * have to update the startino as well. Note that ino is a <ino, off>
+	 * tuple */
 	if (!(mf->mf_flag & INVT_MFILE_INVDUMP)) {
 		if (stream.st_nmediafiles == 0)
 			stream.st_startino = mf->mf_startino;
@@ -771,13 +771,13 @@ stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 
 	/*
 	 * Copy everything. Note that we don't bother to adjust the offsets
-	   either in the seshdr or in the mediafiles, because we don't need
-	   those in order to restore this session (since everything's
-	   contiguous) */
+	 * either in the seshdr or in the mediafiles, because we don't need
+	 * those in order to restore this session (since everything's
+	 * contiguous) */
 
 	/*
 	 * magic cookie that we put for sanity checking in case of an
-	   earthquake or something :) */
+	 * earthquake or something :) */
 	strcpy(sesbuf, INVTSESS_COOKIE);
 	sesbuf += (size_t)(strlen(INVTSESS_COOKIE) * sizeof(char));
 
@@ -860,7 +860,7 @@ stobj_getsession_byuuid(
 
 	/*
 	 * yay. we found the session. so, make the session struct and
-	   put it in the buffer */
+	 * put it in the buffer */
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);
 
 	return BOOL_TRUE;
@@ -896,7 +896,7 @@ stobj_getsession_bylabel(
 
 	/*
 	 * yay. we found the session. so, make the session struct and
-	   put it in the buffer */
+	 * put it in the buffer */
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);
 
 	return BOOL_TRUE;
@@ -950,7 +950,7 @@ stobj_delete_mobj(int			fd,
 		     mf++) {
 /*
  *  The prob is that we need to keep track of where we got these mfiles from
-    as we get them, or we wont know how to put them back if they are dirty.
+ *  as we get them, or we wont know how to put them back if they are dirty.
  */
 			assert(off);
 			if (GET_REC_NOLOCK(fd, mf,
@@ -964,7 +964,7 @@ stobj_delete_mobj(int			fd,
 
 		/*
 		 * We have all the media files of this stream. Make another
-		   pass, checking to see if we need to remove any mfiles */
+		 * pass, checking to see if we need to remove any mfiles */
 		dirty = BOOL_FALSE;
 
 		for (j = 0; j < nmfiles; j++) {
@@ -976,14 +976,14 @@ stobj_delete_mobj(int			fd,
 
 /*
  *                                dirty = BOOL_TRUE;
-
-                                if (j == 0)
-                                       strms[i].st_firstmfile = mf->mf_nextmf;
-                                else
-                                       mfiles[j-1].mf_nextmf = mf->mf_nextmf;
-
-                                if (j == nmfiles - 1)
-                                       strms[i].st_lastmfile =;
+ *
+ *                              if (j == 0)
+ *                                     strms[i].st_firstmfile = mf->mf_nextmf;
+ *                              else
+ *                                     mfiles[j-1].mf_nextmf = mf->mf_nextmf;
+ *
+ *                              if (j == nmfiles - 1)
+ *                                     strms[i].st_lastmfile =;
  */
 			}
 		}
@@ -1023,7 +1023,7 @@ stobj_unpack_sessinfo(
 
 	/*
 	 * first make sure that the magic cookie at the beginning is right.
-	   this isn't null-terminated */
+	 * this isn't null-terminated */
 	if (strncmp(p, INVTSESS_COOKIE, strlen(INVTSESS_COOKIE)) != 0) {
 		mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: inv_put_session: unknown cookie\n"));
@@ -1119,7 +1119,7 @@ stobj_unpack_sessinfo(
 
 	/*
 	 * sanity check the size of the buffer given to us vs. the size it
-	   should be */
+	 * should be */
 	if ((size_t)(p - (char *)bufp) != bufsz) {
 		mlog(MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d entsz %d\n",
 		     (int)(p - (char *)bufp), (int)bufsz,
@@ -1467,8 +1467,8 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 			}
 			printf("\t\t\tmedia file %d:", j);
 			/*
-			   if (mfp->m_isinvdump)
-			        printf(" SESSION INVENTORY");
+			 * if (mfp->m_isinvdump)
+			 *      printf(" SESSION INVENTORY");
 			 */
 			printf("\n");
 			printf("\t\t\t\tmfile index:\t%d\n", mfp->m_mfile_index);
diff --git a/inventory/inventory.h b/inventory/inventory.h
index ea61bb9..6e866e1 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -126,7 +126,7 @@ typedef struct inv_mediafile {
 	off64_t		m_size;                 /* size of mediafile in bytes */
 	bool_t		m_isgood;               /* distinguishes good mfiles */
 	bool_t		m_isinvdump;            /* is this the mfile that has the dump
-	                                           of the rest of the session? */
+	                                         * of the rest of the session? */
 	char		m_label[INV_STRLEN];    /* media file label */
 } inv_mediafile_t;
 
@@ -138,8 +138,8 @@ typedef struct inv_stream {
 	xfs_ino_t		st_startino;            /* the starting pt */
 	off64_t			st_startino_off;
 	xfs_ino_t		st_endino;              /* where we actually ended up. this
-	                                                   means we've written upto but not
-	                                                   including this breakpoint. */
+	                                                 * means we've written upto but not
+	                                                 * including this breakpoint. */
 	off64_t			st_endino_off;
 	char			st_cmdarg[INV_STRLEN];  /* the driver path user entered */
 	uint			st_nmediafiles;         /* number of mediafiles */
@@ -167,8 +167,8 @@ typedef struct inv_session {
 	uint		s_nstreams;             /* num of media streams recorded */
 	inv_stream_t *	s_streams;              /* array of streams */
 	uint		s_refnum;               /* storage location dependent ref.
-	                                            used in displaying the session and
-	                                            nowhere else */
+	                                         *  used in displaying the session and
+	                                         *  nowhere else */
 } inv_session_t;
 
 
@@ -240,7 +240,7 @@ inv_put_mediafile(
 	off64_t		endino_offset,
 	off64_t		size,           /* size of the mediafile in bytes */
 	bool_t		isgood,         /* to distinguish unimportant media
-                                           files from others */
+                                         * files from others */
 	bool_t		isinv_dump);
 
 /*
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 8ac9053..47c43ea 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -298,7 +298,7 @@ write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 	for (i = 0; i < nsess; i++) {
 		j = i % 8;
 		/*mnt = mnt_str[j];
-		   dev = dev_str[7-j]; */
+		 * dev = dev_str[7-j]; */
 		mnt = mnt_str[0];
 		dev = dev_str[7];
 		fsidp = &fsidarr[0]; /* j */
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 2482e74..ec72dd2 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -640,7 +640,7 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 
 		/*
 		 * adjust the offsets of the first and the last elements
-		   in the mediafile chain */
+		 * in the mediafile chain */
 		mfiles[nmfiles].mf_prevmf = 0;
 		nmfiles += strms[i].st_nmediafiles;
 		mfiles[nmfiles - 1].mf_nextmf = 0;
@@ -788,7 +788,7 @@ get_inventry_stobjfile(data_t *d)
 
 	/*
 	 * all the children will be from the same stobj file, so we can just
-	   get the name for the first */
+	 * get the name for the first */
 
 	child_data = d->children[0]->data;
 
diff --git a/restore/content.c b/restore/content.c
index 09080c3..7ede958 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -5008,7 +5008,7 @@ newmedia:
 		    DEVICE_NONREMOVABLE) {
 			/*
 			 * if no error has already been detected then don't log
-			   a failure */
+			 * a failure */
 			if (mlog_get_hint() == RV_NONE)
 				mlog_exit_hint(RV_OK);
 			return RV_QUIT;
-- 
2.19.1
