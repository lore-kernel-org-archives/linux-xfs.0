Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbeKJANZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:13:25 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6F483082E4D
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:32:33 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 22/24] xfsdump: (style) format newlines
Date: Fri,  9 Nov 2018 15:30:02 +0100
Message-Id: <20181109143004.24963-23-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add and remove newlines to conform to the xfs/kernel coding style.

Created by Uncrustify with this config file:

#
# uncrustify config, format newlines
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
 common/arch_xlate.c     |  3 --
 common/content_inode.h  |  2 ++
 common/drive.c          |  1 -
 common/drive_minrmt.c   | 15 ++++-----
 common/drive_scsitape.c | 38 +++++++++------------
 common/drive_simple.c   |  7 ++--
 common/global.c         |  1 +
 common/inventory.c      | 12 +++----
 common/main.c           |  4 +++
 common/mlog.c           | 12 +++----
 common/path.c           |  2 ++
 common/ring.c           |  1 +
 common/stream.c         |  2 ++
 common/timeutil.c       |  2 ++
 common/ts_mtio.h        |  3 +-
 dump/content.c          |  9 ++---
 dump/inomap.c           | 18 +++++-----
 inventory/inv_api.c     | 28 +++++-----------
 inventory/inv_core.c    |  5 ++-
 inventory/inv_files.c   |  3 +-
 inventory/inv_fstab.c   |  7 ----
 inventory/inv_idx.c     | 15 +++------
 inventory/inv_mgr.c     | 16 +++------
 inventory/inv_oref.c    | 22 ++++---------
 inventory/inv_priv.h    |  1 -
 inventory/inv_stobj.c   | 25 ++------------
 inventory/inventory.h   |  1 -
 inventory/testmain.c    | 14 ++------
 invutil/cmenu.c         |  9 ++---
 invutil/fstab.c         | 15 +++------
 invutil/invidx.c        | 40 ++++++++--------------
 invutil/invutil.c       | 73 ++++++++++++++---------------------------
 invutil/list.c          |  3 +-
 invutil/list.h          |  1 -
 invutil/menu.c          |  9 ++---
 invutil/stobj.c         | 10 ++----
 librmt/rmtaccess.c      |  9 ++---
 librmt/rmtclose.c       | 12 ++-----
 librmt/rmtcommand.c     |  6 +---
 librmt/rmtcreat.c       |  9 ++---
 librmt/rmtdev.c         |  8 ++---
 librmt/rmtfstat.c       | 13 +++-----
 librmt/rmtioctl.c       | 46 ++++++++------------------
 librmt/rmtisatty.c      |  7 ++--
 librmt/rmtlseek.c       |  9 ++---
 librmt/rmtopen.c        | 42 ++++++++----------------
 librmt/rmtread.c        | 13 +++-----
 librmt/rmtstatus.c      | 21 ++++--------
 librmt/rmtwrite.c       | 10 ++----
 restore/content.c       | 59 +++++++++++++--------------------
 restore/dirattr.c       |  4 +++
 restore/inomap.c        |  3 ++
 restore/mmap.c          |  6 ++--
 restore/namreg.c        |  5 +--
 restore/node.c          |  5 +--
 restore/tree.c          | 17 +++++-----
 56 files changed, 248 insertions(+), 485 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index 24cfa2a..fc848e2 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -102,7 +102,6 @@ xlate_global_hdr(global_hdr_t *gh1, global_hdr_t *gh2, int dir)
 	     ptr2->gh_ipaddr,
 	     ptr2->gh_hostname,
 	     ptr2->gh_dumplabel);
-
 }
 
 /*
@@ -405,7 +404,6 @@ xlate_bstat(bstat_t *bs1, bstat_t *bs2, int dir)
 	     "\tbs_mode  %lo\n",
 	     ptr2->bs_ino,
 	     ptr2->bs_mode);
-
 }
 
 /*
@@ -676,7 +674,6 @@ xlate_invt_session(invt_session_t *is1, invt_session_t *is2, int dir)
 	     "\ts_max_nstreams %u\n",
 	     ptr2->s_cur_nstreams,
 	     ptr2->s_max_nstreams);
-
 }
 
 void
diff --git a/common/content_inode.h b/common/content_inode.h
index 7b94ba2..21f36ec 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -422,6 +422,7 @@ calc_checksum(void *bufp, size_t len)
 	uint32_t sum = 0;
 	uint32_t *sump = bufp;
 	uint32_t *endp = sump + len / sizeof(uint32_t);
+
 	assert(len % sizeof(uint32_t) == 0);
 	while (sump < endp)
 		sum += *sump++;
@@ -434,6 +435,7 @@ is_checksum_valid(void *bufp, size_t len)
 	uint32_t sum = 0;
 	uint32_t *sump = bufp;
 	uint32_t *endp = sump + len / sizeof(uint32_t);
+
 	assert(len % sizeof(uint32_t) == 0);
 	while (sump < endp)
 		sum += *sump++;
diff --git a/common/drive.c b/common/drive.c
index 1dcc01e..4ed3550 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -341,7 +341,6 @@ drive_mark_discard(drive_t *drivep)
 	     dmp
 	     ;
 	     drivep->d_markrecheadp = dmp->dm_nextp, dmp = dmp->dm_nextp) {
-
 		(*dmp->dm_cbfuncp)(dmp->dm_cbcontextp, dmp, BOOL_FALSE);
 	}
 }
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 1423486..28dd7d1 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -2405,7 +2405,6 @@ do_fsf(drive_t *drivep, int count, int *statp)
 		 * reach the next file.
 		 */
 		while (! done) {
-
 			/*
 			 * advance the tape to the next file mark
 			 * NOTE:
@@ -2502,7 +2501,6 @@ do_bsf(drive_t *drivep, int count, int *statp)
 	 * now loop, skipping media files
 	 */
 	for (skipped = 0; skipped < count; skipped++) {
-
 		/*
 		 * move to the left of the next file mark on the left.
 		 * check for BOT.
@@ -2847,7 +2845,6 @@ validate_media_file_hdr(drive_t *drivep)
 		mlog(MLOG_NORMAL | MLOG_DRIVE,
 		     _("tape record checksum error\n"));
 		return DRIVE_ERROR_CORRUPTION;
-
 	}
 
 	xlate_global_hdr(tmpgh, grhdrp, 1);
@@ -3125,7 +3122,6 @@ determine_write_error(int nwritten, int saved_errno)
 	     saved_errno);
 
 	return (ret);
-
 }
 
 static void
@@ -3178,6 +3174,7 @@ static int
 dbgrmtopen(char *path, int flags)
 {
 	int rval;
+
 	rval = rmtopen(path, flags);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTOPEN(%s, %d) returns %d: errno=%d (%s)\n"),
@@ -3192,6 +3189,7 @@ static int
 dbgrmtclose(int fd)
 {
 	int rval;
+
 	rval = rmtclose(fd);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTCLOSE(%d) returns %d: errno=%d (%s)\n"),
@@ -3205,6 +3203,7 @@ static int
 dbgrmtioctl(int fd, int op, void *arg)
 {
 	int rval;
+
 	rval = rmtioctl(fd, op, arg);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTIOCTL(%d, %d, 0x%x) returns %d: errno=%d (%s)\n"),
@@ -3220,6 +3219,7 @@ static int
 dbgrmtread(int fd, void *p, uint sz)
 {
 	int rval;
+
 	rval = rmtread(fd, p, sz);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTREAD(%d, 0x%x, %u) returns %d: errno=%d (%s)\n"),
@@ -3235,6 +3235,7 @@ static int
 dbgrmtwrite(int fd, void *p, uint sz)
 {
 	int rval;
+
 	rval = rmtwrite(fd, p, sz);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTWRITE(%d, 0x%x, %u) returns %d: errno=%d (%s)\n"),
@@ -3614,7 +3615,6 @@ largersize:
 			return DRIVE_ERROR_MEDIA;
 		}
 		continue;
-
 	}
 
 	mlog(MLOG_DEBUG | MLOG_DRIVE,
@@ -3767,7 +3767,6 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
 		     _("record %lld corrupt: bad record checksum\n"),
 		     contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
-
 	}
 
 	xlate_rec_hdr(tmprh, rechdrp, 1);
@@ -3780,7 +3779,6 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
 	}
 
 	if (uuid_is_null(rechdrp->dump_uuid)) {
-
 		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		     _("record %lld corrupt: null dump id\n"),
 		     contextp->dc_iocnt - 1);
@@ -3944,6 +3942,7 @@ static int
 getrec(drive_t *drivep)
 {
 	drive_context_t *contextp;
+
 	contextp = (drive_context_t *)drivep->d_contextp;
 
 	while (! contextp->dc_recp) {
@@ -4083,7 +4082,6 @@ calc_max_lost(drive_t *drivep)
 	} else {
 		contextp->dc_lostrecmax = 2;
 	}
-
 }
 
 static void
@@ -4233,6 +4231,7 @@ isefsdump(drive_t *drivep)
 {
 	int32_t *efshdrp = (int32_t *)drivep->d_greadhdrp;
 	int32_t efsmagic = efshdrp[6];
+
 	if (efsmagic == 60011
 	    ||
 	    efsmagic == 60012) {
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index be1bb46..3c0b139 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -555,13 +555,11 @@ is_scsi_driver(char *pathname)
 
 	if (dev_major == get_driver_character_major("st")) {
 		return BOOL_TRUE;
-	}
-	else if (dev_major == get_driver_character_major("ts") ||
-		 dev_major == get_driver_character_major("tmf")) {
+	} else if (dev_major == get_driver_character_major("ts") ||
+		   dev_major == get_driver_character_major("tmf")) {
 		TS_ISDRIVER = 1;
 		return BOOL_TRUE;
-	}
-	else {
+	} else {
 		return BOOL_FALSE;
 	}
 }
@@ -599,8 +597,7 @@ ds_match(int argc, char *argv[], drive_t *drivep)
 	} else {
 		if (is_scsi_driver(drivep->d_pathname)) {
 			return 10;
-		}
-		else {
+		} else {
 			return -10;
 		}
 	}
@@ -2597,7 +2594,6 @@ do_fsf(drive_t *drivep, int count, int *statp)
 			if (IS_EOT(mtstat)) {
 				*statp = DRIVE_ERROR_EOM;
 				return i;
-
 			} else if (IS_EOD(mtstat)) {
 				*statp = DRIVE_ERROR_EOD;
 				return i;
@@ -2753,7 +2749,6 @@ do_bsf(drive_t *drivep, int count, int *statp)
 	 * now loop, skipping media files
 	 */
 	for (skipped = 0; skipped < count; skipped++) {
-
 		/*
 		 * move to the left of the next file mark on the left.
 		 * check for BOT.
@@ -3284,7 +3279,6 @@ validate_media_file_hdr(drive_t *drivep)
 		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		     "tape record checksum error\n");
 		return DRIVE_ERROR_CORRUPTION;
-
 	}
 
 	xlate_global_hdr(tmpgh, grhdrp, 1);
@@ -3492,8 +3486,7 @@ get_tpcaps(drive_t *drivep)
 			contextp->dc_maxblksz = QIC_BLKSZ;
 			drivep->d_capabilities &= ~DRIVE_CAP_OVERWRITE;
 			drivep->d_capabilities &= ~DRIVE_CAP_BSF;
-		}
-		else {
+		} else {
 			contextp->dc_cangetblkszpr = BOOL_TRUE;
 			contextp->dc_cansetblkszpr = BOOL_TRUE;
 			contextp->dc_maxblksz = mtinfo.maxblksz;
@@ -3593,8 +3586,7 @@ mt_blkinfo(int fd, struct mtblkinfo *minfo)
 		}
 		minfo->curblksz = ts_blkinfo.curblksz;
 		minfo->maxblksz = ts_blkinfo.maxblksz;
-	}
-	else {
+	} else {
 		if (ioctl(fd, MTIOCGET, &mt_stat) < 0) {
 			/*
 			 * failure
@@ -3823,7 +3815,6 @@ determine_write_error(drive_t *drivep, int nwritten, int saved_errno)
 		status_failed_message(drivep);
 		ret = DRIVE_ERROR_DEVICE;
 	} else if (IS_WPROT(mtstat) && (saved_errno == EROFS)) {
-
 		mlog(MLOG_NORMAL,
 		     _("tape is write protected\n"));
 
@@ -3833,7 +3824,6 @@ determine_write_error(drive_t *drivep, int nwritten, int saved_errno)
 		    (saved_errno == ENOSPC))) {
 		ret = DRIVE_ERROR_EOM;
 	} else if (saved_errno == EIO) {
-
 		mlog(MLOG_NORMAL,
 		     _("tape media error on write operation\n"));
 
@@ -3864,7 +3854,6 @@ determine_write_error(drive_t *drivep, int nwritten, int saved_errno)
 	     saved_errno);
 
 	return (ret);
-
 }
 
 static void
@@ -3917,6 +3906,7 @@ static int
 dbgrmtopen(char *path, int flags)
 {
 	int rval;
+
 	rval = rmtopen(path, flags);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTOPEN(%s, %d) returns %d: errno=%d (%s)\n"),
@@ -3931,6 +3921,7 @@ static int
 dbgrmtclose(int fd)
 {
 	int rval;
+
 	rval = rmtclose(fd);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTCLOSE(%d) returns %d: errno=%d (%s)\n"),
@@ -3944,6 +3935,7 @@ static int
 dbgrmtioctl(int fd, int op, void *arg)
 {
 	int rval;
+
 	rval = rmtioctl(fd, op, arg);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTIOCTL(%d, %d, 0x%x) returns %d: errno=%d (%s)\n"),
@@ -3959,6 +3951,7 @@ static int
 dbgrmtread(int fd, void *p, uint sz)
 {
 	int rval;
+
 	rval = rmtread(fd, p, sz);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTREAD(%d, 0x%x, %u) returns %d: errno=%d (%s)\n"),
@@ -3974,6 +3967,7 @@ static int
 dbgrmtwrite(int fd, void *p, uint sz)
 {
 	int rval;
+
 	rval = rmtwrite(fd, p, sz);
 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	     _("RMTWRITE(%d, 0x%x, %u) returns %d: errno=%d (%s)\n"),
@@ -4928,7 +4922,6 @@ largersize:
 			return DRIVE_ERROR_MEDIA;
 		}
 		continue;
-
 	} /* loop reading 1st record 'til get correct blksz */
 
 	mlog(MLOG_DEBUG | MLOG_DRIVE,
@@ -5115,7 +5108,6 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
 		     _("record %lld corrupt: bad record checksum\n"),
 		     contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
-
 	}
 
 	xlate_rec_hdr(tmprh, rechdrp, 1);
@@ -5128,7 +5120,6 @@ record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
 	}
 
 	if (uuid_is_null(rechdrp->dump_uuid)) {
-
 		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		     _("record %lld corrupt: null dump id\n"),
 		     contextp->dc_iocnt - 1);
@@ -5294,6 +5285,7 @@ static int
 getrec(drive_t *drivep)
 {
 	drive_context_t *contextp;
+
 	contextp = (drive_context_t *)drivep->d_contextp;
 
 	while (! contextp->dc_recp) {
@@ -5433,7 +5425,6 @@ calc_max_lost(drive_t *drivep)
 	} else {
 		contextp->dc_lostrecmax = 2;
 	}
-
 }
 
 static void
@@ -5594,7 +5585,8 @@ bsf_and_verify(drive_t *drivep)
 		(void)mt_op(contextp->dc_fd, MTBSF, 1);
 
 		try = 1;
-status:         ok = mt_get_status(drivep, &mtstat);
+status:
+		ok = mt_get_status(drivep, &mtstat);
 		if (! ok) {
 			mtstat = 0;
 			status_failed_message(drivep);
@@ -5697,6 +5689,7 @@ isefsdump(drive_t *drivep)
 {
 	int32_t *efshdrp = (int32_t *)drivep->d_greadhdrp;
 	int32_t efsmagic = efshdrp[6];
+
 	if (efsmagic == 60011
 	    ||
 	    efsmagic == 60012) {
@@ -5776,4 +5769,3 @@ map_ts_status(struct mtget *mtstat, struct mtget_sgi mtstat_sgi)
 	}
 	return;
 }
-
diff --git a/common/drive_simple.c b/common/drive_simple.c
index b415c43..3b85da7 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -324,7 +324,6 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
 			drivep->d_capabilities |= DRIVE_CAP_ERASE;
 			contextp->dc_rampr = BOOL_TRUE;
 			oflags = O_RDWR | O_CREAT;
-
 		} else {
 			switch (statbuf.st_mode & S_IFMT) {
 			case S_IFREG:
@@ -359,7 +358,6 @@ ds_instantiate(int argc, char *argv[], drive_t *drivep)
 			     drivep->d_pathname,
 			     strerror(errno));
 			return BOOL_FALSE;
-
 		}
 		oflags = O_RDONLY;
 		switch (statbuf.st_mode & S_IFMT) {
@@ -1044,8 +1042,7 @@ do_begin_write(drive_t *drivep)
 	if (! global_hdr_checksum_check(tmphdr)) {
 		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 		     _("media file header checksum error\n"));
-	}
-	else {
+	} else {
 		mlog(MLOG_NITTY, "media file header checksum OK!\n");
 	}
 
@@ -1082,6 +1079,7 @@ do_set_mark(drive_t *		drivep,
 {
 	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	drive_mark_t mark;
+
 	mlog(MLOG_NITTY | MLOG_DRIVE,
 	     "drive_simple set_mark()\n");
 
@@ -1140,7 +1138,6 @@ do_set_mark(drive_t *		drivep,
 			 * adjust header checksum
 			 */
 			global_hdr_checksum_set(gwhdrp);
-
 		} else if (contextp->dc_rampr) {
 			global_hdr_t *gwhdrp = drivep->d_gwritehdrp;
 			drive_hdr_t *dwhdrp = drivep->d_writehdrp;
diff --git a/common/global.c b/common/global.c
index bf08961..91305b0 100644
--- a/common/global.c
+++ b/common/global.c
@@ -63,6 +63,7 @@ global_hdr_alloc(int argc, char *argv[])
 	global_hdr_t *ghdrp;
 	int c;
 	char *dumplabel;
+
 #ifdef DUMP
 	char labelbuf[GLOBAL_HDR_STRING_SZ];
 	struct stat64 statb;
diff --git a/common/inventory.c b/common/inventory.c
index 07e5e5a..7346ddd 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -45,7 +45,6 @@ int sesslock_fd = -1;
 inv_idbtoken_t
 inv_open(inv_predicate_t bywhat, void *pred)
 {
-
 	int fd, stobjfd, num;
 	char uuname[INV_STRLEN];
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
@@ -105,7 +104,6 @@ inv_open(inv_predicate_t bywhat, void *pred)
 	tok->d_invindex_off = INVINDEX_HDR_OFFSET(index - 1);
 
 	return tok;
-
 }
 
 
@@ -149,6 +147,7 @@ inv_lasttime_level_lessthan(
 	time32_t **	tm)
 {
 	int rval;
+
 	assert(tok != INV_TOKEN_NULL);
 
 	rval = search_invt(tok, level, (void **)tm,
@@ -174,13 +173,13 @@ inv_lastsession_level_lessthan(
 	inv_session_t **ses)
 {
 	int rval;
+
 	assert(tok != INV_TOKEN_NULL);
 
 	rval = search_invt(tok, level, (void **)ses,
 			   (search_callback_t)lastsess_level_lessthan);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
-
 }
 
 
@@ -201,12 +200,12 @@ inv_lastsession_level_equalto(
 	inv_session_t **ses)
 {
 	int rval;
+
 	assert(tok != INV_TOKEN_NULL);
 	rval = search_invt(tok, level, (void **)ses,
 			   (search_callback_t)lastsess_level_equalto);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
-
 }
 
 
@@ -340,7 +339,6 @@ inv_writesession_close(inv_sestoken_t tok)
 	free(tok);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
-
 }
 
 
@@ -537,7 +535,6 @@ inv_put_mediafile(
 	 */
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
-
 }
 
 
@@ -610,7 +607,6 @@ inv_get_inolist(
 #endif
 
 	return 1;
-
 }
 
 
@@ -655,11 +651,11 @@ inv_DEBUG_printallsessions(
 	inv_session_t **ses)
 {
 	int rval;
+
 	rval = search_invt(tok, 0, (void **)ses,
 			   (search_callback_t)DEBUG_displayallsessions);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
-
 }
 
 #endif
diff --git a/common/main.c b/common/main.c
index 49dcd90..16dee52 100644
--- a/common/main.c
+++ b/common/main.c
@@ -148,6 +148,7 @@ int
 main(int argc, char *argv[])
 {
 	int c;
+
 #ifdef DUMP
 	uid_t euid;
 #endif /* DUMP */
@@ -1624,6 +1625,7 @@ sigint_dialog(void)
 	size_t controlix;
 	size_t ioix;
 	size_t mediachangeix;
+
 #ifdef RESTORE
 	size_t piix;
 	size_t roix;
@@ -2150,6 +2152,7 @@ set_rlimits(size64_t *vmszp)
 #endif /* RESTORE */
 {
 	struct rlimit64 rlimit64;
+
 #ifdef RESTORE
 	size64_t vmsz;
 #endif /* RESTORE */
@@ -2368,6 +2371,7 @@ sig_numstring(int num)
 			       (sizeof(sig_printmap)
 				/
 				sizeof(sig_printmap[0]));
+
 	for (; p < endp; p++) {
 		if (p->num == num) {
 			return p->string;
diff --git a/common/mlog.c b/common/mlog.c
index 11a923b..17490ce 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -361,8 +361,7 @@ mlog_override_level(int levelarg)
 		for (ss = 0; ss < MLOG_SS_CNT; ss++) {
 			mlog_level_ss[ss] = level;
 		}
-	}
-	else { /* do a particular subsys */
+	} else { /* do a particular subsys */
 		mlog_level_ss[ss] = level;
 	}
 }
@@ -371,6 +370,7 @@ void
 mlog(int levelarg, char *fmt, ...)
 {
 	va_list args;
+
 	va_start(args, fmt);
 	mlog_va(levelarg, fmt, args);
 	va_end(args);
@@ -610,8 +610,7 @@ _mlog_exit(const char *file, int line, int exit_code, rv_t rv)
 			mlog_main_exit_code = exit_code;
 			mlog_main_exit_return = rv;
 		}
-	}
-	else {
+	} else {
 		stream_state_t states[] = { S_RUNNING };
 		stream_state_t state;
 		int streamix;
@@ -625,8 +624,7 @@ _mlog_exit(const char *file, int line, int exit_code, rv_t rv)
 					   &streamix,
 					   &exit_code,
 					   &exit_return,
-					   &exit_hint))
-		{
+					   &exit_hint)) {
 			if (exit_code == -1) {
 				stream_set_code(tid, exit_code);
 				stream_set_return(tid, rv);
@@ -669,7 +667,6 @@ _mlog_exit_hint(const char *file, int line, rv_t rv)
 		mlog_main_exit_hint = rv;
 	else
 		stream_set_hint(tid, rv);
-
 }
 
 rv_t
@@ -725,7 +722,6 @@ mlog_exit_flush(void)
 
 	ntids = stream_find_all(states, N(states), tids, STREAM_SIMMAX);
 	if (ntids > 0) {
-
 		/* print the state of all the streams */
 		fprintf(mlog_fp, _("%s: %s Summary:\n"), progname, PROGSTR_CAPS);
 
diff --git a/common/path.c b/common/path.c
index 5196e9d..12d4090 100644
--- a/common/path.c
+++ b/common/path.c
@@ -170,6 +170,7 @@ static pem_t *
 pem_alloc(char *path)
 {
 	pem_t *pemp = (pem_t *)calloc(1, sizeof(pem_t));
+
 	assert(pemp);
 	pemp->pem_head = path;
 	pemp->pem_next = pemp->pem_head;
@@ -246,6 +247,7 @@ static pa_t *
 pa_alloc(void)
 {
 	pa_t *pap = (pa_t *)calloc(1, sizeof(pa_t));
+
 	assert(pap);
 
 	return pap;
diff --git a/common/ring.c b/common/ring.c
index 030f65d..fddce15 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -458,6 +458,7 @@ ring_slave_entry(void *ringctxp)
 {
 	sigset_t blocked_set;
 	ring_t *ringp = (ring_t *)ringctxp;
+
 	enum { LOOPMODE_NORMAL, LOOPMODE_IGNORE, LOOPMODE_DIE } loopmode;
 
 	/*
diff --git a/common/stream.c b/common/stream.c
index e091359..e80fe74 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -126,6 +126,7 @@ stream_find_all(stream_state_t states[], int nstates,
 	int i, count = 0;
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
+
 	assert(nstates > 0 && ntids > 0);
 
 	if (! initialized)
@@ -188,6 +189,7 @@ stream_getix(pthread_t tid)
 	stream_state_t states[] = { S_RUNNING };
 	spm_t *p;
 	int ix;
+
 	p = stream_find(tid, states, N(states));
 	ix = p ? p->s_ix : -1;
 	return ix;
diff --git a/common/timeutil.c b/common/timeutil.c
index b327c2f..1f351a2 100644
--- a/common/timeutil.c
+++ b/common/timeutil.c
@@ -27,6 +27,7 @@ char *
 ctime32(const time32_t *timep)
 {
 	time_t t = (time_t)*timep;
+
 	return ctime(&t);
 }
 
@@ -34,6 +35,7 @@ char *
 ctime32_r(const time32_t *timep, char *buf)
 {
 	time_t t = (time_t)*timep;
+
 	return ctime_r(&t, buf);
 }
 
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index 3e0432d..87faa15 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -716,8 +716,7 @@ struct mt_fpmsg {
 /* Definition of MTGETPOS/MTSETPOS structure */
 #define MAX_VEND_POS_SIZE       256     /* Maximum vendor specific position
 	                                 * data size. */
-struct  vendor_specific_pos
-{
+struct  vendor_specific_pos {
 	u_short position_type;          /* Identifies which position type is required. */
 	short	size;                   /* Number of bytes of position data. */
 	u_char	pos[MAX_VEND_POS_SIZE]; /*Generic vendor specific position data*/
diff --git a/dump/content.c b/dump/content.c
index 236c06c..ddda3df 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -595,7 +595,6 @@ content_init(int		argc,
 	     char *		argv[],
 	     global_hdr_t *	gwhdrtemplatep)
 {
-
 	inv_idbtoken_t inv_idbt;
 	inv_session_t *sessp = 0;
 	drive_hdr_t *dwhdrtemplatep;
@@ -864,7 +863,6 @@ content_init(int		argc,
 		     sizeof(mntpnt),
 		     &fsid,
 		     srcname)) {
-
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			     "%s does not identify a file system\n"),
 		     srcname);
@@ -900,7 +898,6 @@ content_init(int		argc,
 
 	/* write quota information */
 	if (sc_savequotas) {
-
 		sc_savequotas = BOOL_FALSE;
 		for (i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
 			quotas[i].savequotas = BOOL_FALSE;
@@ -2123,6 +2120,7 @@ mark_set(drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	mark_t *markp = (mark_t *)calloc(1, sizeof(mark_t));
+
 	assert(markp);
 
 	if (flags & STARTPT_FLAGS_NULL) {
@@ -4391,7 +4389,6 @@ dump_file_reg(drive_t *			drivep,
 		 * update the media file size
 		 */
 		contextp->cc_mfilesz += bytecnt;
-
 	}
 
 	cleanup_extent_group_context(&extent_group_context);
@@ -6505,7 +6502,6 @@ Media_mfile_end(drive_t *	drivep,
 		contextp->cc_Media_begin_entrystate = BES_INVAL;
 		return RV_CORE;
 	}
-
 }
 
 static bool_t
@@ -6919,8 +6915,7 @@ save_quotas(char *mntpnt, quota_info_t *quotainfo)
 
 	if (unlink(quotainfo->quotapath) == 0) {
 		mlog(MLOG_WARNING, _("overwriting: %s\n"), quotainfo->quotapath);
-	}
-	else {
+	} else {
 		if (errno != ENOENT) {
 			mlog(MLOG_ERROR, _(
 				     "unable to remove %s: %s\n"),
diff --git a/dump/inomap.c b/dump/inomap.c
index 17c6909..44d3724 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -336,7 +336,6 @@ inomap_build(jdm_fshandle_t *	fshandlep,
 			free((void *)bstatbufp);
 			return BOOL_FALSE;
 		}
-
 	} else {
 		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 			     "ino map phase 2: "
@@ -515,6 +514,7 @@ static int
 cb_count_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 {
 	int *count = (int *)arg1;
+
 	(*count)++;
 	return 0;
 }
@@ -759,15 +759,13 @@ supprt_prune(void *		arg1,   /* ancestors marked as changed? */
 						 statp->bs_ino,
 						 MAP_DIR_NOCHNG);
 				cb_dircnt--;    /* dump size just changed! */
-			}
-			else {
+			} else {
 				/* Directory entries back up the hierarchy */
 				/* to be dumped - as either MAP_DIR_SUPPRT */
 				/* or as MAP_DIR_CHANGE in inode state map */
 				*(bool_t *)arg1 = BOOL_TRUE;
 			}
-		}
-		else if (state == MAP_DIR_CHANGE) {
+		} else if (state == MAP_DIR_CHANGE) {
 			/* Directory entries back up the hierarchy must get */
 			/* dumped - as either MAP_DIR_SUPPRT/MAP_DIR_CHANGE */
 			*(bool_t *)arg1 = BOOL_TRUE;
@@ -1010,6 +1008,7 @@ SEG_SET_BITS(seg_t *segp, xfs_ino_t ino, int state)
 	register xfs_ino_t relino;
 	register uint64_t mask;
 	register uint64_t clrmask;
+
 	relino = ino - segp->base;
 	mask = (uint64_t)1 << relino;
 	clrmask = ~mask;
@@ -1063,6 +1062,7 @@ SEG_GET_BITS(seg_t *segp, xfs_ino_t ino)
 	int state;
 	register xfs_ino_t relino;
 	register uint64_t mask;
+
 	relino = ino - segp->base;
 	mask = (uint64_t)1 << relino;
 	if (segp->lobits & mask) {
@@ -1135,6 +1135,7 @@ static inline seg_t *
 inomap_addr2seg(seg_addr_t *addrp)
 {
 	hnk_t *hunkp = inomap_addr2hnk(addrp);
+
 	return &hunkp->seg[addrp->segoff];
 }
 
@@ -1217,6 +1218,7 @@ void *
 inomap_alloc_context(void)
 {
 	void *addr = calloc(1, sizeof(seg_addr_t));
+
 	if (! addr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR,
 		     _("failed to allocate inomap context: %s\n"),
@@ -1319,11 +1321,9 @@ inomap_iter(void *contextp, int statemask)
 	for (;
 	     addrp->hnkoff <= inomap.lastseg.hnkoff;
 	     addrp->hnkoff++, addrp->segoff = 0, addrp->inooff = 0) {
-
 		for (;
 		     addrp->segoff <= inomap_lastseg(addrp->hnkoff);
 		     addrp->segoff++, addrp->inooff = 0) {
-
 			segp = inomap_addr2seg(addrp);
 
 			ino = segp->base + addrp->inooff;
@@ -1576,6 +1576,7 @@ subtreelist_parse_cb(void *		arg1,
 	 * temporarily terminate the subpath at the next slash
 	 */
 	char *nextslash = strchr(subpath, '/');
+
 	if (nextslash) {
 		*nextslash = 0;
 	}
@@ -1597,7 +1598,6 @@ subtreelist_parse_cb(void *		arg1,
 	cb_add(NULL, fshandlep, fsfd, statp);
 
 	if (nextslash) {
-
 		/*
 		 * if we're not at the end of the path, yet the current
 		 * path element is not a directory, complain and abort the
@@ -1625,7 +1625,6 @@ subtreelist_parse_cb(void *		arg1,
 			      NULL,
 			      0);
 		return cbrval;
-
 	} else {
 		/*
 		 * we've reached the specified subpath, so if we're
@@ -1661,7 +1660,6 @@ subtree_descend_cb(void *		arg1,
 	cb_add(NULL, fshandlep, fsfd, statp);
 
 	if ((statp->bs_mode & S_IFMT) == S_IFDIR) {
-
 		(void)diriter(fshandlep,
 			      fsfd,
 			      statp,
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index 2467115..3d684f2 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -123,7 +123,6 @@ inv_open(inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred)
 	tok->d_invindex_off = IDX_HDR_OFFSET(index - 1);
 	tok->d_oflag = forwhat;
 	return tok;
-
 }
 
 
@@ -277,7 +276,6 @@ inv_writesession_close(inv_sestoken_t tok)
 	free(tok);
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
-
 }
 
 
@@ -363,7 +361,6 @@ inv_stream_open(
 	free(stok);
 	INVLOCK(fd, LOCK_UN);
 	return INV_TOKEN_NULL;
-
 }
 
 
@@ -393,7 +390,6 @@ inv_stream_close(
 	INVLOCK(fd, LOCK_EX);
 	if ((rval = GET_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
 				   tok->md_stream_off)) > 0) {
-
 		if (strm.st_interrupted != wasinterrupted) {
 			strm.st_interrupted = wasinterrupted;
 			dowrite = BOOL_TRUE;
@@ -407,7 +403,6 @@ inv_stream_close(
 			    tok->md_lastmfile->mf_endino.ino ||
 			    strm.st_endino.offset !=
 			    tok->md_lastmfile->mf_endino.offset) {
-
 				mlog(MLOG_DEBUG | MLOG_INV, "INV: stream_close() "
 				     " - endinos dont match ! \n");
 				dowrite = BOOL_TRUE;
@@ -496,7 +491,6 @@ inv_put_mediafile(
 	 */
 
 	return (rval < 0) ? BOOL_FALSE : BOOL_TRUE;
-
 }
 
 
@@ -577,7 +571,6 @@ inv_put_sessioninfo(invt_sessinfo_t *s)
 	}
 
 	return insert_session(s);
-
 }
 
 
@@ -629,6 +622,7 @@ inv_lasttime_level_lessthan(
 	time32_t **	tm)
 {
 	int rval;
+
 	if (tok != INV_TOKEN_NULL) {
 		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
 				   (void **)tm,
@@ -662,6 +656,7 @@ inv_lastsession_level_lessthan(
 	inv_session_t **ses)
 {
 	int rval;
+
 	if (tok != INV_TOKEN_NULL) {
 		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
 				   (void **)ses,
@@ -674,7 +669,6 @@ inv_lastsession_level_lessthan(
 					 (void *)&level,        /* in */
 					 (void **)ses,          /* out */
 					 (search_callback_t)lastsess_level_lessthan);
-
 }
 
 /*----------------------------------------------------------------------*/
@@ -697,6 +691,7 @@ inv_lastsession_level_equalto(
 	inv_session_t **ses)
 {
 	int rval;
+
 	if (tok != INV_TOKEN_NULL) {
 		rval = search_invt(fsidp, tok->d_invindex_fd, &level,
 				   (void **)ses,
@@ -709,7 +704,6 @@ inv_lastsession_level_equalto(
 					 (void *)&level,        /* in */
 					 (void **)ses,          /* out */
 					 (search_callback_t)lastsess_level_equalto);
-
 }
 
 
@@ -728,7 +722,6 @@ inv_get_session_byuuid(
 	uuid_t *	sesid,
 	inv_session_t **ses)
 {
-
 	return invmgr_query_all_sessions(fsidp,         /* fs uuid */
 					 (void *)sesid, /* in */
 					 (void **)ses,  /* out */
@@ -750,7 +743,6 @@ inv_get_session_bylabel(
 	char *		session_label,
 	inv_session_t **ses)
 {
-
 	return invmgr_query_all_sessions(fsidp,                 /* fs uuid */
 					 (void *)session_label, /* in */
 					 (void **)ses,          /* out */
@@ -893,6 +885,7 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 	int npreds = 0;
 	int npreds2 = 0;
 	char invoptstring[128], *rptr, *wptr;
+
 	optind = 1;
 	opterr = 0;
 
@@ -1013,7 +1006,6 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 			}
 			break; /* case GETOPT_INVPRINT */
 		}
-
 	}
 
 	if (npreds > 1) {
@@ -1021,15 +1013,13 @@ inv_getopt(int argc, char **argv, invt_pr_ctx_t *prctx)
 			     "INV: Only one of mnt=, dev= and fsid=value can be used.\n")
 		     );
 		rval |= I_IERR;
-	}
-	else if (npreds2 > 1) {
+	} else if (npreds2 > 1) {
 		mlog(MLOG_NORMAL | MLOG_INV, _(
 			     "INV: Only one of mobjid= and mobjlabel= can be used.\n")
 		     );
 		rval |= I_IERR;
-	}
-	else if ((rval & I_IFOUND) && !(rval & I_IERR) && fs
-		 && ! prctx->fstab && ! prctx->invcheck) {
+	} else if ((rval & I_IFOUND) && !(rval & I_IERR) && fs
+		   && ! prctx->fstab && ! prctx->invcheck) {
 		inv_idbtoken_t tok;
 
 		/*
@@ -1106,6 +1096,7 @@ inv_DEBUG_print(int argc, char **argv)
 	int rval;
 	invt_pr_ctx_t prctx;
 	inv_oflag_t forwhat = INV_SEARCH_ONLY;
+
 	prctx.mobj.type = INVT_NULLTYPE;
 	prctx.fstab = prctx.invidx = prctx.invcheck = BOOL_FALSE;
 	prctx.level = PR_MAXLEVEL;
@@ -1146,8 +1137,7 @@ inv_DEBUG_print(int argc, char **argv)
 				     &arr[i].ft_mountpt
 				     );
 				invmgr_inv_check(tok->d_invindex_fd);
-			}
-			else {
+			} else {
 				prctx.index = i;
 				invmgr_inv_print(tok->d_invindex_fd,
 						 &prctx);
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index 5670e60..00e8d1a 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -50,6 +50,7 @@ get_counters(int fd, void **cntpp, size_t cntsz)
 {
 	/* object must be locked at least SHARED by caller */
 	uint num;
+
 	assert(cntsz >= sizeof(invt_counter_t));
 
 	*cntpp = calloc(1, cntsz);
@@ -86,7 +87,6 @@ get_counters(int fd, void **cntpp, size_t cntsz)
 int
 get_headers(int fd, void **hdrs, size_t bufsz, size_t off)
 {
-
 	*hdrs = malloc(bufsz);
 	if (*hdrs == NULL) {
 		INV_PERROR(_("get_headers() - malloc(seshdrs)\n"));
@@ -212,6 +212,7 @@ get_lastheader(int fd, void **ent, size_t hdrsz, size_t cntsz)
 	void *arr = NULL;
 	invt_counter_t *cnt = NULL;
 	char *pos;
+
 	/* get the entries in the inv_index */
 	if ((nindices = GET_ALLHDRS_N_CNTS(fd, &arr, (void **)&cnt,
 					   hdrsz, cntsz)) <= 0) {
@@ -229,5 +230,3 @@ get_lastheader(int fd, void **ent, size_t hdrsz, size_t cntsz)
 
 	return nindices;
 }
-
-
diff --git a/inventory/inv_files.c b/inventory/inv_files.c
index 9105ee2..48275a2 100644
--- a/inventory/inv_files.c
+++ b/inventory/inv_files.c
@@ -91,8 +91,7 @@ inv_setup_base(void)
 		if (new_sbuf.st_ino == old_sbuf.st_ino &&
 		    new_sbuf.st_dev == old_sbuf.st_dev) {
 			old_exists = 0; /* both the same, pretend */
-		}
-		else {                  /* die! */
+		} else {                /* die! */
 			return 0;
 		}
 	}
diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
index 6b603b6..17ff6d7 100644
--- a/inventory/inv_fstab.c
+++ b/inventory/inv_fstab.c
@@ -118,12 +118,9 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 		cnt->ic_maxnum = -1;
 		cnt->ic_curnum = 0;
 		cnt->ic_vernum = INV_VERSION;
-
 	} else if (numfs > 0) {
-
 		for (i = 0; i < numfs; i++) {
 			if (uuid_compare(*fsidp, arr[i].ft_uuid) == 0) {
-
 /*			if ((STREQL(arr[i].ft_mountpt, mntpt) ) &&
                             (STREQL(arr[i].ft_devpath, dev) ))
  */
@@ -131,7 +128,6 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 				free(cnt);
 				close(fd);
 				return 1;
-
 			}
 		}
 		/* entry not found. just follow thru to create a new one */
@@ -163,7 +159,6 @@ fstab_put_entry(uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat)
 		if (rval > 0) {
 			rval = PUT_REC_NOLOCK(fd, &ent, sizeof(ent), hoff);
 		}
-
 	}
 	INVLOCK(fd, LOCK_UN);
 	free(cnt);
@@ -211,7 +206,6 @@ fstab_get_fname(void *		pred,
 			     (STREQL(arr[i].ft_mountpt, pred))) ||
 			    (bywhat == INV_BY_DEVPATH &&
 			     (STREQL(arr[i].ft_devpath, pred)))) {
-
 				uuidp = &arr[i].ft_uuid;
 				break;
 			}
@@ -221,7 +215,6 @@ fstab_get_fname(void *		pred,
 			mlog(MLOG_DEBUG | MLOG_INV, "INV: get_fname: unable to find %s"
 			     " in the inventory\n", (char *)pred);
 #endif
-
 	} else {
 		uuidp = (uuid_t *)pred;
 	}
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index bfe1c68..907cab3 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -51,6 +51,7 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 {
 	uint i;
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
+
 /*	invt_entry_t ient;
         ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end = tm; */
 
@@ -121,8 +122,6 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 			}
 			/* see if the next entry starts later than us */
 			if (iarr[i + 1].ie_timeperiod.tp_start > tm) {
-
-
 				/*
 				 * We have the option of pushing entries
 				   after (i) forward by one slot, and
@@ -150,8 +149,6 @@ idx_insert_newentry(int fd,             /* kept locked EX by caller */
 	/* We couldnt find anything that fits */
 	assert(0);      /* We can't get here ! */
 	return -1;
-
-
 }
 
 
@@ -207,7 +204,6 @@ idx_put_newentry(
 	free(iarr);
 	idx->iarr = idxarr;
 	return stobjfd;
-
 }
 
 
@@ -224,7 +220,6 @@ int
 idx_find_stobj(invt_idxinfo_t * idx,
 	       time32_t		tm)
 {
-
 	int stobjfd;
 
 	/*
@@ -306,6 +301,7 @@ int
 idx_recons_time(time32_t tm, invt_idxinfo_t *idx)
 {
 	invt_timeperiod_t *tp = &idx->iarr[idx->index].ie_timeperiod;
+
 	if (tp->tp_start && IS_WITHIN(tp, tm))
 		return 1;
 
@@ -459,7 +455,6 @@ idx_create_entry(
 #endif
 		if (PUT_REC_NOLOCK(invfd, &ent, sizeof(ent), hoff) < 0)
 			return -1;
-
 	}
 
 	*tok = get_token(invfd, fd);
@@ -467,7 +462,6 @@ idx_create_entry(
 	(*tok)->d_update_flag |= NEW_INVINDEX;
 	(*tok)->d_oflag = INV_SEARCH_N_MOD;
 	return fd;
-
 }
 
 
@@ -517,6 +511,7 @@ idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num)
 	uint k;
 
 	char s[9];
+
 	printf("\n ==================================\n"
 	       " InvIndex\n # StObjs\t%d\n", num);
 #define INV_UUID_STR_LEN        36 /* not exported via uuid.h */
@@ -532,7 +527,6 @@ idx_DEBUG_printinvindices(invt_entry_t *iarr, uint num)
 #undef INV_UUID_STR_LEN
 	printf("\n ==================================\n");
 	return 1;
-
 }
 
 int
@@ -541,6 +535,7 @@ idx_DEBUG_print(int fd)
 	int nindices;
 	invt_entry_t *iarr = NULL;
 	invt_counter_t *icnt = NULL;
+
 	if ((nindices = GET_ALLHDRS_N_CNTS_NOLOCK(fd,
 						  (void **)&iarr,
 						  (void **)&icnt,
@@ -562,6 +557,7 @@ DEBUG_displayallsessions(int fd, invt_seshdr_t *hdr, uint ref,
 			 invt_pr_ctx_t *prctx)
 {
 	inv_session_t *ses;
+
 	if (stobj_make_invsess(fd, &ses, hdr) < 1)
 		return -1;
 
@@ -571,4 +567,3 @@ DEBUG_displayallsessions(int fd, invt_seshdr_t *hdr, uint ref,
 
 	return 0;
 }
-
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index e5aeb02..e332295 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -232,7 +232,6 @@ search_invt(
 	void **			buf,
 	search_callback_t	do_chkcriteria)
 {
-
 	int fd, i;
 	invt_entry_t *iarr = NULL;
 	invt_counter_t *icnt = NULL;
@@ -350,7 +349,6 @@ invmgr_inv_print(
 	int		invfd,
 	invt_pr_ctx_t * prctx)
 {
-
 	int fd, i;
 	invt_entry_t *iarr = NULL;
 	invt_counter_t *icnt = NULL;
@@ -442,7 +440,6 @@ int
 invmgr_inv_check(
 	int invfd)
 {
-
 	int fd, i;
 	invt_entry_t *iarr = NULL;
 	invt_counter_t *icnt = NULL;
@@ -498,8 +495,7 @@ invmgr_inv_check(
 			for (s = 0; s < nsess; s++) {
 				printf(_("tm (%d)\t%d\n"), s, harr[s].sh_time);
 			}
-		}
-		else {
+		} else {
 			printf(_("INV: Check %d out of %d succeeded\n"),
 			       i + 1, nindices);
 		}
@@ -523,6 +519,7 @@ tm_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
 		  void **tm)
 {
 	u_char level = *(u_char *)arg;
+
 	*tm = NULL;
 	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
@@ -552,6 +549,7 @@ lastsess_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
 			void **buf)
 {
 	u_char level = *(u_char *)arg;
+
 	*buf = NULL;
 	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
@@ -563,7 +561,6 @@ lastsess_level_lessthan(int fd, invt_seshdr_t *hdr, void *arg,
 		return stobj_make_invsess(fd, (inv_session_t **)buf, hdr);
 	}
 	return 0;
-
 }
 
 
@@ -579,6 +576,7 @@ lastsess_level_equalto(int fd, invt_seshdr_t *hdr,
 		       void *arg, void **buf)
 {
 	u_char level = *(u_char *)arg;
+
 	*buf = NULL;
 	if (IS_PARTIAL_SESSION(hdr))
 		return 0;
@@ -590,8 +588,6 @@ lastsess_level_equalto(int fd, invt_seshdr_t *hdr,
 		return stobj_make_invsess(fd, (inv_session_t **)buf, hdr);
 	}
 	return 0;
-
-
 }
 
 
@@ -671,7 +667,6 @@ insert_session(invt_sessinfo_t *s)
 
 	/* and we are done */
 	return BOOL_TRUE;
-
 }
 
 
@@ -743,6 +738,7 @@ bool_t
 invmgr_trylock(invt_mode_t mode)
 {
 	int md;
+
 	assert(invlock_fd >= 0);
 
 	md = (mode == INVT_RECONSTRUCT) ? LOCK_EX : LOCK_SH;
@@ -759,8 +755,6 @@ invmgr_unlock(void)
 	assert(invlock_fd >= 0);
 
 	INVLOCK(invlock_fd, LOCK_UN);
-
 }
 
 #endif
-
diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
index 08045c5..7260da7 100644
--- a/inventory/inv_oref.c
+++ b/inventory/inv_oref.c
@@ -124,8 +124,7 @@ oref_resolve_entries(
 			return INV_ERR;
 		}
 		obj->eu_ent = ent;
-	}
-	else {
+	} else {
 		invt_fstab_t *ent;
 		assert(OREF_CNT_CURNUM(obj));
 		if (GET_ENTRIES(obj->fd, &ent, OREF_CNT_CURNUM(obj),
@@ -160,8 +159,7 @@ oref_resolve_counters(
 			return INV_ERR;
 		}
 		obj->cu_sescnt = sescnt;
-	}
-	else {
+	} else {
 		invt_counter_t *cnt;
 		cnt = calloc(1, sizeof(invt_counter_t));
 		if (GET_COUNTERS(obj->fd, cnt) < 0) {
@@ -279,14 +277,12 @@ _oref_free(
 			free((oref)->eu_strm);
 		if (OREF_ISRESOLVED(obj, INVT_RES_MFILES))
 			free((oref)->eu_mfile);
-	}
-	else if (OREF_ISRESOLVED(obj, INVT_OTYPE_INVIDX)) {
+	} else if (OREF_ISRESOLVED(obj, INVT_OTYPE_INVIDX)) {
 		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
 			free((oref)->cu_cnt);
 		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
 			free((oref)->eu_ent);
-	}
-	else if (OREF_ISRESOLVED(obj, INVT_OTYPE_FSTAB)) {
+	} else if (OREF_ISRESOLVED(obj, INVT_OTYPE_FSTAB)) {
 		if (OREF_ISRESOLVED(obj, INVT_RES_COUNTERS))
 			free((oref)->cu_cnt);
 		if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
@@ -383,7 +379,6 @@ oref_resolve(
 
 	OREF_SET_TOKEN(tok);
 	return INV_OK;
-
 }
 
 /*
@@ -396,6 +391,7 @@ oref_resolve_child(
 	int *		index)
 {
 	invt_entry_t *ent;
+
 	assert(OREF_IS_LOCKED(invidx));
 
 	if (oref_resolve_upto(invidx, INVT_RES_ENTRIES) == INV_ERR)
@@ -449,7 +445,6 @@ oref_resolve_new_invidx(
 
 	OREF_UNLOCK(invidx);
 	return rval;
-
 }
 
 
@@ -496,8 +491,7 @@ oref_resolve_new_stobj(
 		    ||
 		    (oref_sync(invidx, INVT_RES_ENTRIES) == INV_ERR))
 			return INV_ERR;
-	}
-	else {
+	} else {
 		if (oref_resolve_upto(invidx, INVT_RES_COUNTERS) == INV_ERR)
 			return INV_ERR;
 
@@ -515,7 +509,6 @@ oref_resolve_new_stobj(
 		    (oref_sync_append(invidx, INVT_RES_ENTRIES,
 				      &ent, sizeof(ent)) == INV_ERR))
 			return INV_ERR;
-
 	}
 	tok = get_token(invfd, fd);
 	tok->d_invindex_off = IDX_HDR_OFFSET(OREF_CNT_CURNUM(invidx) - 1);
@@ -523,7 +516,4 @@ oref_resolve_new_stobj(
 
 	OREF_SET_TOKEN(invidx, tok);
 	return INV_OK;
-
 }
-
-
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index d8873b9..63fd785 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -250,7 +250,6 @@ typedef struct invt_strdesc_entry {
 	                                           to get it back from disk
 	                                           when we add the next mfile
 	                                           to the linked list */
-
 } invt_strdesc_entry_t;
 
 
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 5db757c..6956850 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -80,7 +80,6 @@ stobj_insert_session(invt_idxinfo_t *	idx,
 			if (uuid_compare(sessions[i].s_sesid,
 					 s->ses->s_sesid) == 0)
 				break;
-
 		}
 		free(sessions);
 		if (i < sescnt->ic_curnum) {
@@ -91,7 +90,6 @@ stobj_insert_session(invt_idxinfo_t *	idx,
 			free(sescnt);
 			return 1;
 		}
-
 	}
 
 	if (sescnt->ic_curnum >= sescnt->ic_maxnum) {
@@ -101,7 +99,6 @@ stobj_insert_session(invt_idxinfo_t *	idx,
 		}
 		free(sescnt);
 		return 1;
-
 	}
 
 	if (stobj_put_session(fd, sescnt, s->ses, s->seshdr, s->strms,
@@ -150,9 +147,6 @@ stobj_find_splitpoint(int fd, invt_seshdr_t *harr, uint ns, time32_t tm)
 	     );
 
 	return ns - 1;
-
-
-
 }
 
 
@@ -280,9 +274,7 @@ int
 stobj_delete_mfile(int fd, inv_stream_t *strm, invt_mediafile_t *mf,
 		   off64_t mfileoff)
 {
-
 	return 1;
-
 }
 
 
@@ -362,7 +354,6 @@ stobj_put_session(
 					    * nmf);
 		if (stobj_put_streams(fd, hdr, ses, strms, mfiles) < 0)
 			return -1;
-
 	}
 
 	/* we write back the counters of this storage object first */
@@ -400,6 +391,7 @@ stobj_sortheaders(int fd, uint num)
 {
 	size_t sz = sizeof(invt_seshdr_t) * num;
 	invt_seshdr_t *hdrs;
+
 #ifdef INVT_DEBUG
 	int i;
 #endif
@@ -432,7 +424,6 @@ stobj_sortheaders(int fd, uint num)
 
 	free(hdrs);
 	return 1;
-
 }
 
 
@@ -462,7 +453,6 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 					 (off64_t)((size_t)nmfiles * sizeof(invt_mediafile_t));
 		/* now fix the offsets in mediafiles */
 		for (j = 0; j < strms[i].st_nmediafiles; j++) {
-
 			/* no need to fix the last element's next ptr */
 			if (j < strms[i].st_nmediafiles - 1)
 				mfiles[nmfiles + j].mf_nextmf =
@@ -482,7 +472,6 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		mfiles[nmfiles].mf_prevmf = 0;
 		nmfiles += strms[i].st_nmediafiles;
 		mfiles[nmfiles - 1].mf_nextmf = 0;
-
 	}
 
 	/* first put the streams. hdr already points at the right place */
@@ -495,7 +484,6 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		return -1;
 
 	return 1;
-
 }
 
 
@@ -876,7 +864,6 @@ stobj_getsession_byuuid(
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);
 
 	return BOOL_TRUE;
-
 }
 
 
@@ -913,7 +900,6 @@ stobj_getsession_bylabel(
 	stobj_copy_invsess(fd, hdr, &ses, (inv_session_t **)buf);
 
 	return BOOL_TRUE;
-
 }
 
 
@@ -962,7 +948,6 @@ stobj_delete_mobj(int			fd,
 		     j++,
 		     off = mf->mf_nextmf,
 		     mf++) {
-
 /*
  *  The prob is that we need to keep track of where we got these mfiles from
     as we get them, or we wont know how to put them back if they are dirty.
@@ -1001,7 +986,6 @@ stobj_delete_mobj(int			fd,
                                        strms[i].st_lastmfile =;
  */
 			}
-
 		}
 		free(mfiles);
 		if (dirty);
@@ -1184,13 +1168,11 @@ stobj_convert_mfile(inv_mediafile_t *expmf, invt_mediafile_t *mf)
 			  BOOL_TRUE : BOOL_FALSE;
 	expmf->m_isinvdump = (mf->mf_flag & INVT_MFILE_INVDUMP) ?
 			     BOOL_TRUE : BOOL_FALSE;
-
 }
 
 void
 stobj_convert_strm(inv_stream_t *expstrm, invt_stream_t *strm)
 {
-
 	expstrm->st_interrupted = strm->st_interrupted;
 	expstrm->st_startino = strm->st_startino.ino;
 	expstrm->st_startino_off =
@@ -1222,7 +1204,6 @@ stobj_convert_session(inv_session_t *ises, invt_session_t *ses,
 
 	/* caller is responsible for initializing this */
 	ises->s_streams = NULL;
-
 }
 
 
@@ -1297,7 +1278,6 @@ stobj_copy_invsess(int			fd,
 				return -1;
 			}
 		}
-
 	}
 
 
@@ -1363,6 +1343,7 @@ void
 DEBUG_sessprint(invt_session_t *ses)
 {
 	char str[UUID_STR_LEN + 1];
+
 	uuid_unparse(ses->s_fsid, str);
 
 	printf("-------- session -------------\n");
@@ -1377,7 +1358,6 @@ DEBUG_sessprint(invt_session_t *ses)
 bool_t
 mobj_eql(inv_mediafile_t *mfp, invt_mobjinfo_t *mobj)
 {
-
 	if (mobj->type == INVT_MOID) {
 		if (! uuid_compare(*((uuid_t *)mobj->value),
 				  mfp->m_moid)) {
@@ -1426,6 +1406,7 @@ DEBUG_sessionprint(inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 	invt_mobjinfo_t *mobj = &prctx->mobj;
 
 	bool_t moidsearch = (mobj && mobj->type != INVT_NULLTYPE);
+
 	if (moidsearch) {
 		if (! check_for_mobj(ses, mobj))
 			return;
diff --git a/inventory/inventory.h b/inventory/inventory.h
index d7a8726..ea61bb9 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -169,7 +169,6 @@ typedef struct inv_session {
 	uint		s_refnum;               /* storage location dependent ref.
 	                                            used in displaying the session and
 	                                            nowhere else */
-
 } inv_session_t;
 
 
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 7fabbfc..8ac9053 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -74,7 +74,6 @@ CREAT_mfiles(inv_stmtoken_t tok, uuid_t *moid, ino_t f, ino_t n)
 
 	inv_put_mediafile(tok, moid, label, 12, f, 0, n, 0, 0xffff,
 			  BOOL_TRUE, BOOL_FALSE);
-
 }
 
 typedef struct ses {
@@ -117,8 +116,6 @@ recons_test(int howmany)
 	}
 
 	close(fd);
-
-
 }
 
 
@@ -142,7 +139,6 @@ delete_test(int n)
 	if (! inv_delete_mediaobj(&moid)) return -1;
 
 	return 1;
-
 }
 
 int
@@ -265,6 +261,7 @@ write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 	char strbuf[128];
 	void *bufp;
 	size_t sz;
+
 #ifdef RECONS
 	int rfd;
 	off64_t off;
@@ -406,8 +403,7 @@ mp_test(int nstreams)
 /*----------------------------------------------------------------------*/
 
 
-main(int argc, char *argv[])
-{
+main(int argc, char *argv[]){
 	int rval = -1, nsess = 8, nmedia = 2, nstreams = 3, level = 0;
 	int cc = 0;
 	extern char *optarg;
@@ -505,15 +501,11 @@ main(int argc, char *argv[])
 			rval = sess_queries_byuuid(uuid);
 		else if (label)
 			rval = sess_queries_bylabel(label);
-	}
-	else
+	} else
 		usage();
 
 	if (rval < 0)
 		printf("aborted\n");
 	else
 		printf("done\n");
-
-
 }
-
diff --git a/invutil/cmenu.c b/invutil/cmenu.c
index f7da523..e339ae9 100644
--- a/invutil/cmenu.c
+++ b/invutil/cmenu.c
@@ -488,16 +488,13 @@ list_prune(node_t *menulist, char *mountpt, uuid_t *uuidp, time32_t prunetime)
 			if (d->ops->op_prune(mountpt, uuidp, prunetime, n, menulist) == BOOL_TRUE) {
 				if (d->ops->op_delete == NULL) {
 					list_delete(n, menulist);
-				}
-				else {
+				} else {
 					d->ops->op_delete(NULL, n, menulist);
 				}
-			}
-			else {
+			} else {
 				if (d->ops->op_undelete == NULL) {
 					list_undelete(n, menulist);
-				}
-				else {
+				} else {
 					d->ops->op_undelete(NULL, n, menulist);
 				}
 			}
diff --git a/invutil/fstab.c b/invutil/fstab.c
index 0052f9d..9a03a05 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -96,8 +96,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
 			}
 		}
 		fstab_file[fidx].counter->ic_curnum--;
-	}
-	else if (d->imported == BOOL_TRUE) {
+	} else if (d->imported == BOOL_TRUE) {
 		invt_fstab_t *dest;
 
 		for (i = 0; i < d->nbr_children; i++) {
@@ -111,8 +110,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
 
 		if (fstab_file[0].counter->ic_curnum < fstab_file[0].nEntries) {
 			dest = fstab_file[0].data[fstab_file[0].counter->ic_curnum - 1] + 1;
-		}
-		else {
+		} else {
 			/* expand mmap by one */
 			dest = remmap_fstab(0, 1);
 		}
@@ -208,8 +206,7 @@ add_fstab_data(int fidx, invt_fstab_t *data)
 			fprintf(stderr, "%s: internal memory error: fstab data allocation\n", g_programName);
 			exit(1);
 		}
-	}
-	else {
+	} else {
 		fstab_file[fidx].data = realloc(fstab_file[fidx].data,
 						sizeof(*fstab_file[fidx].data)
 						* (fstab_file[fidx].numrecords + 1));
@@ -290,8 +287,7 @@ add_fstab(char *name, int fd, int nEntries, char *mapaddr, invt_counter_t *count
 			fprintf(stderr, "%s: internal memory error: malloc fstab_file\n", g_programName);
 			exit(1);
 		}
-	}
-	else {
+	} else {
 		if (fstab_numfiles >= highwatermark - 1) {
 			highwatermark += highwatermark;
 
@@ -377,8 +373,7 @@ remmap_fstab(int fidx, int num)
 	for (i = 0; i < nEntries; i++) {
 		if (i >= fstab_file[fidx].numrecords) {
 			add_fstab_data(fidx, &(fstab_entry[i]));
-		}
-		else {
+		} else {
 			fstab_file[fidx].data[i] = &(fstab_entry[i]);
 		}
 	}
diff --git a/invutil/invidx.c b/invutil/invidx.c
index a641f09..2482e74 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -106,8 +106,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 			}
 		}
 		invidx_file[fidx].counter->ic_curnum--;
-	}
-	else if (d->imported == BOOL_TRUE) {
+	} else if (d->imported == BOOL_TRUE) {
 		int dst_fileidx;
 		int dst_invpos;
 		int dst_invidx;
@@ -169,8 +168,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 
 					if (--i < 0)
 						break;
-				}
-				while ((dst_invidx = find_overlapping_invidx(dst_fileidx, inv_entry)) >= 0);
+				} while ((dst_invidx = find_overlapping_invidx(dst_fileidx, inv_entry)) >= 0);
 
 				mark_all_children_commited(current);
 
@@ -205,8 +203,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 				}
 
 				return 0;
-			}
-			else {
+			} else {
 				/* insert new invidx entry, and copy over stobj file */
 				if (invidx_file[dst_fileidx].counter->ic_curnum >= invidx_file[dst_fileidx].nEntries) {
 					dest = remmap_invidx(dst_fileidx, 1);
@@ -217,8 +214,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 					memmove(invidx_file[dst_fileidx].data[dst_invpos + 1],
 						invidx_file[dst_fileidx].data[dst_invpos],
 						sizeof(*inv_entry) * (invidx_file[dst_fileidx].counter->ic_curnum - dst_invpos));
-				}
-				else {
+				} else {
 					dest = invidx_file[dst_fileidx].data[invidx_file[dst_fileidx].counter->ic_curnum - 1] + 1;
 				}
 
@@ -244,8 +240,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 						put_error("Error: unable to copy stobj file: stat error");
 						return 0;
 					}
-				}
-				else {
+				} else {
 					put_error("Error: unable to copy stobj file: file exists");
 					return 0;
 				}
@@ -259,8 +254,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 				open_stobj(dst_stobjfile);
 				return 0;
 			}
-		}
-		else {
+		} else {
 			/* no matching inventory index file - just copy entry to a new file */
 			invt_counter_t cnt;
 			int new_fd;
@@ -277,8 +271,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 					put_error("Error: unable to stat inventory index file");
 					return 0;
 				}
-			}
-			else {
+			} else {
 				put_error("Error: unable to copy inventory index file: file exists");
 				return 0;
 			}
@@ -314,8 +307,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 					put_error("Error: unable to copy stobj file: stat error");
 					return 0;
 				}
-			}
-			else {
+			} else {
 				put_error("Error: unable to copy stobj file: file exists");
 				return 0;
 			}
@@ -382,12 +374,10 @@ read_stobj_info(int fd, int idx, invt_seshdr_t **out_hdr,
 		if (nmfiles > 0) {
 			mfiles = malloc(sizeof(*mfiles) * nmfiles);
 			read_n_bytes(fd, (char *)mfiles, sizeof(*mfiles) * nmfiles, "stobj file");
-		}
-		else {
+		} else {
 			mfiles = NULL;
 		}
-	}
-	else {
+	} else {
 		strms = NULL;
 		mfiles = NULL;
 	}
@@ -639,7 +629,6 @@ stobj_put_streams(int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		strms[i].st_firstmfile = mfileoff + (off64_t)((size_t)nmfiles * sizeof(invt_mediafile_t));
 		/* now fix the offsets in mediafiles */
 		for (j = 0; j < strms[i].st_nmediafiles; j++) {
-
 			/* no need to fix the last element's next ptr */
 			if (j < strms[i].st_nmediafiles - 1)
 				mfiles[nmfiles + j].mf_nextmf = strms[i].st_firstmfile + (off64_t)((j + 1) * sizeof(invt_mediafile_t));
@@ -886,8 +875,7 @@ add_invidx_data(int fidx, invt_entry_t *data)
 				g_programName);
 			exit(1);
 		}
-	}
-	else {
+	} else {
 		invidx_file[fidx].data = realloc(invidx_file[fidx].data,
 						 sizeof(*invidx_file[fidx].data)
 						 * (invidx_file[fidx].numrecords + 1));
@@ -967,8 +955,7 @@ add_invidx(char *name, int fd, int nEntries, char *mapaddr, invt_counter_t *coun
 			fprintf(stderr, "%s: internal memory error: malloc invidx_file\n", g_programName);
 			exit(1);
 		}
-	}
-	else {
+	} else {
 		if (invidx_numfiles >= highwatermark - 1) {
 			highwatermark += highwatermark;
 
@@ -1025,8 +1012,7 @@ remmap_invidx(int fidx, int num)
 	for (i = 0; i < nEntries; i++) {
 		if (i >= invidx_file[fidx].numrecords) {
 			add_invidx_data(fidx, &(inv_entry[i]));
-		}
-		else {
+		} else {
 			invidx_file[fidx].data[i] = &(inv_entry[i]);
 		}
 	}
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 13ebd56..24a7b6a 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -258,30 +258,25 @@ main(int argc, char *argv[])
 		time32_t temptime = 0;
 		CheckAndPruneFstab(inventory_path, BOOL_TRUE, tempstr, &uuid,
 				   &session, temptime, NULL);
-	}
-	else if (session_option) {
+	} else if (session_option) {
 		CheckAndPruneFstab(
 			inventory_path, BOOL_FALSE, mntPoint, &uuid,
 			&session, (time32_t)0, r_mf_label);
-	}
-	else if (uuid_option || mntpnt_option) {
+	} else if (uuid_option || mntpnt_option) {
 		time32_t timeSecs = ParseDate(argv[optind]);
 
 		if (interactive_option) {
 			invutil_interactive(inventory_path, mntPoint, &uuid, timeSecs);
 			printf("\n");
-		}
-		else {
+		} else {
 			CheckAndPruneFstab(
 				inventory_path, BOOL_FALSE, mntPoint, &uuid,
 				&session, timeSecs, r_mf_label);
 		}
-	}
-	else if (interactive_option) {
+	} else if (interactive_option) {
 		invutil_interactive(inventory_path, mntPoint, &uuid, 0);
 		printf("\n");
-	}
-	else {
+	} else {
 		usage();
 	}
 
@@ -495,23 +490,20 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 	printf("Processing file %s\n", fstabname);
 
 	/* check each entry in fstab for mount pt or uuid match */
-	for (i = 0; i < counter->ic_curnum;)
-	{
+	for (i = 0; i < counter->ic_curnum;) {
 		removeflag = BOOL_FALSE;
 
 		printf("   Found entry for %s\n", fstabentry[i].ft_mountpt);
 
 		for (j = i + 1; j < counter->ic_curnum; j++) {
-			if (uuid_compare(fstabentry[i].ft_uuid, fstabentry[j].ft_uuid) == 0)
-			{
+			if (uuid_compare(fstabentry[i].ft_uuid, fstabentry[j].ft_uuid) == 0) {
 				printf("     duplicate fstab entry\n");
 				removeflag = BOOL_TRUE;
 				break;
 			}
 		}
 
-		if (! removeflag)
-		{
+		if (! removeflag) {
 			bool_t IdxCheckOnly = BOOL_TRUE;
 
 			invname = GetNameOfInvIndex(inv_path, fstabentry[i].ft_uuid);
@@ -526,17 +518,14 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 				if (mountPt != NULL && strcmp(mountPt, fstabentry[i].ft_mountpt) == 0) {
 					printf("     Match on hostname and path\n");
 					IdxCheckOnly = BOOL_FALSE;
-				}
-				else if ((! uuid_is_null(*uuidp))
-					 && (uuid_compare(*uuidp, fstabentry[i].ft_uuid) == 0)) {
+				} else if ((! uuid_is_null(*uuidp))
+					   && (uuid_compare(*uuidp, fstabentry[i].ft_uuid) == 0)) {
 					printf("     Match on UUID only\n");
 					IdxCheckOnly = BOOL_FALSE;
-				}
-				else if (mountPt != NULL && mntpnt_equal(mountPt, fstabentry[i].ft_mountpt)) {
+				} else if (mountPt != NULL && mntpnt_equal(mountPt, fstabentry[i].ft_mountpt)) {
 					printf("     Match on directory name only: %s\n", mountPt);
 					IdxCheckOnly = BOOL_FALSE;
-				}
-				else if (! uuid_is_null(*sessionp)) {
+				} else if (! uuid_is_null(*sessionp)) {
 					// no session id to match against yet, defer deciding if this is
 					// a check-only run until we have a session
 					IdxCheckOnly = BOOL_FALSE;
@@ -550,11 +539,9 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 			}
 
 			free(invname);
-
 		}
 
-		if (removeflag == BOOL_TRUE)
-		{
+		if (removeflag == BOOL_TRUE) {
 			printf("     removing fstab entry %s\n", fstabentry[i].ft_mountpt);
 			if (counter->ic_curnum > 1) {
 				bcopy((void *)&fstabentry[i + 1],
@@ -562,8 +549,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 				      (sizeof(invt_fstab_t) * (counter->ic_curnum - i - 1)));
 			}
 			counter->ic_curnum--;
-		}
-		else
+		} else
 			i++; /* next entry if this entry not removed */
 	}
 
@@ -586,8 +572,7 @@ CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
 
 	close(fd);
 
-	if (fstabEntries == 0)
-	{
+	if (fstabEntries == 0) {
 		if (debug) {
 			printf("unlink fstab file %s\n", fstabname);
 		}
@@ -635,8 +620,7 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 	counter = (invt_counter_t *)temp;
 	invIndexEntry = (invt_entry_t *)(temp + sizeof(invt_counter_t));
 
-	for (i = 0; i < counter->ic_curnum;)
-	{
+	for (i = 0; i < counter->ic_curnum;) {
 		removeflag = BOOL_FALSE;
 		printf("         Checking access for\n"
 		       "          %s\n", invIndexEntry[i].ie_filename);
@@ -648,8 +632,7 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 		}
 
 		if ((access(invIndexEntry[i].ie_filename, R_OK | W_OK) == -1) &&
-		    (errno == ENOENT))
-		{
+		    (errno == ENOENT)) {
 			printf("         Unable to access %s referred in %s\n",
 			       invIndexEntry[i].ie_filename, idxFileName);
 			printf("         removing index entry \n");
@@ -661,16 +644,14 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 			removeflag = BOOL_TRUE; /* The StObj is gone */
 		}
 
-		if (removeflag == BOOL_TRUE)
-		{
+		if (removeflag == BOOL_TRUE) {
 			if (counter->ic_curnum > 1) {
 				bcopy((void *)&invIndexEntry[i + 1],
 				      (void *)&invIndexEntry[i],
 				      (sizeof(invt_entry_t) * (counter->ic_curnum - i - 1)));
 			}
 			counter->ic_curnum--;
-		}
-		else
+		} else
 			i++; /* next entry if this entry not removed */
 	}
 
@@ -698,8 +679,7 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 
 	close(fd);
 
-	if (validEntries == 0)
-	{
+	if (validEntries == 0) {
 		if (debug) {
 			printf("unlink idx file %s\n", idxFileName);
 		}
@@ -858,16 +838,14 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 				       str, StObjses->s_mountpt, StObjses->s_devpath,
 				       StObjses->s_label, ctime32(&StObjhdr->sh_time));
 				removeflag = BOOL_TRUE;
-			}
-			else {
+			} else {
 				printf("-------------------------------------------------\n");
 				printf("An entry matching the mount point/time is :\n");
 				printf("UUID\t\t:\t%s\nMOUNT POINT\t:\t%s\n"
 				       "DEV PATH\t:\t%s\nTIME OF DUMP\t:\t%s",
 				       str, StObjses->s_mountpt, StObjses->s_devpath,
 				       ctime32(&StObjhdr->sh_time));
-				while (GotResponse == BOOL_FALSE)
-				{
+				while (GotResponse == BOOL_FALSE) {
 					char *chp;
 
 					printf("\nDo you want to prune this entry: [y/n] ");
@@ -878,8 +856,7 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 					if (strcasecmp(response, "Y") == 0) {
 						removeflag = BOOL_TRUE;
 						GotResponse = BOOL_TRUE;
-					}
-					else if (strcasecmp(response, "N") == 0) {
+					} else if (strcasecmp(response, "N") == 0) {
 						GotResponse = BOOL_TRUE;
 					}
 				}
@@ -910,8 +887,7 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 
 	close(fd);
 
-	if (validEntries == 0)
-	{
+	if (validEntries == 0) {
 		if (debug)
 			printf("Removing: %s\n", StObjFileName);
 		unlink(StObjFileName);
@@ -1183,4 +1159,3 @@ usage(void)
 
 	exit(1);
 }
-
diff --git a/invutil/list.c b/invutil/list.c
index 8661650..201e7bc 100644
--- a/invutil/list.c
+++ b/invutil/list.c
@@ -109,8 +109,7 @@ list_add(node_t *prevnode, node_t *newnode)
 		if (newnode->next != NULL) {
 			newnode->next->prev = newnode;
 		}
-	}
-	else {
+	} else {
 		newnode->next = NULL;
 		newnode->prev = NULL;
 	}
diff --git a/invutil/list.h b/invutil/list.h
index 3a06c02..7d8d45e 100644
--- a/invutil/list.h
+++ b/invutil/list.h
@@ -52,4 +52,3 @@ node_t *free_all_children(node_t *node);
 node_t *mark_all_children_commited(node_t *node);
 
 #endif /* LIST_H */
-
diff --git a/invutil/menu.c b/invutil/menu.c
index b50734c..705c4c8 100644
--- a/invutil/menu.c
+++ b/invutil/menu.c
@@ -44,8 +44,7 @@ put_all_options(WINDOW *win, node_t *list, node_t *current)
 		}
 		if (node == current) {
 			attr = A_REVERSE;
-		}
-		else {
+		} else {
 			attr = 0;
 		}
 		put_option(win, i, d->text, attr);
@@ -138,8 +137,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 			if (d->ops != NULL && d->ops->op_highlight != NULL) {
 				quit = d->ops->op_highlight(win, current, list);
 			}
-		}
-		else if (last != current || redraw_options) {
+		} else if (last != current || redraw_options) {
 			put_option(win, last_line, ((data_t *)(last->data))->text, 0);
 			put_option(win, current_line, d->text, A_REVERSE);
 
@@ -291,8 +289,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
 					if (keyv[k].fn != NULL) {
 						quit = keyv[k].fn(win, current, list);
 						break;
-					}
-					else {
+					} else {
 						put_footer("internal error: can't execute function", ALIGN_CENTRE);
 						break;
 					}
diff --git a/invutil/stobj.c b/invutil/stobj.c
index 1c475da..2f538ca 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -159,8 +159,7 @@ stobjsess_commit(WINDOW *win, node_t *current, node_t *list)
 
 	if (d->deleted == BOOL_TRUE) {
 		stobjhdr->sh_pruned = 1;
-	}
-	else {
+	} else {
 		stobjhdr->sh_pruned = 0;
 	}
 
@@ -368,8 +367,7 @@ add_stobj_data(int fidx, void *data)
 				g_programName);
 			exit(1);
 		}
-	}
-	else {
+	} else {
 		stobj_file[fidx].data = realloc(stobj_file[fidx].data,
 						sizeof(*stobj_file[fidx].data)
 						* (stobj_file[fidx].numrecords + 1));
@@ -541,8 +539,7 @@ add_stobj(char *name, int fd, off_t size, char *mapaddr, invt_sescounter_t *coun
 			fprintf(stderr, "%s: internal memory error: malloc stobj_file\n", g_programName);
 			exit(1);
 		}
-	}
-	else {
+	} else {
 		if (stobj_numfiles >= highwatermark - 1) {
 			highwatermark += highwatermark;
 
@@ -636,7 +633,6 @@ close_all_stobj()
 	int unlink_ok;
 
 	for (i = 0; i < stobj_numfiles; i++) {
-
 		if (stobj_file[i].fd < 0)
 			continue;
 
diff --git a/librmt/rmtaccess.c b/librmt/rmtaccess.c
index 0944d41..ef1c2ac 100644
--- a/librmt/rmtaccess.c
+++ b/librmt/rmtaccess.c
@@ -33,14 +33,9 @@ int rmtaccess(path, amode)
 char *path;
 int amode;
 {
-	if (_rmt_dev(path))
-	{
+	if (_rmt_dev(path)) {
 		return (0);             /* Let /etc/rmt find out */
-	}
-	else
-	{
+	} else {
 		return (access(path, amode));
 	}
 }
-
-
diff --git a/librmt/rmtclose.c b/librmt/rmtclose.c
index 20be537..1744220 100644
--- a/librmt/rmtclose.c
+++ b/librmt/rmtclose.c
@@ -32,15 +32,12 @@ static int _rmt_close(int);
 int rmtclose(fildes)
 int fildes;
 {
-	if (isrmt(fildes))
-	{
+	if (isrmt(fildes)) {
 		/* no longer know what host we have for this fildes */
 		RMTHOST(fildes - REM_BIAS) = UNAME_UNKNOWN;
 
 		return (_rmt_close(fildes - REM_BIAS));
-	}
-	else
-	{
+	} else {
 		return (close(fildes));
 	}
 }
@@ -53,8 +50,7 @@ _rmt_close(int fildes)
 {
 	int rc;
 
-	if (_rmt_command(fildes, "C\n") != -1)
-	{
+	if (_rmt_command(fildes, "C\n") != -1) {
 		rc = _rmt_status(fildes);
 
 		_rmt_abort(fildes);
@@ -63,5 +59,3 @@ _rmt_close(int fildes)
 
 	return (-1);
 }
-
-
diff --git a/librmt/rmtcommand.c b/librmt/rmtcommand.c
index cfeaac3..6b96af9 100644
--- a/librmt/rmtcommand.c
+++ b/librmt/rmtcommand.c
@@ -46,8 +46,7 @@ char *buf;
  */
 
 	blen = strlen(buf);
-	if (write(WRITE(fildes), buf, blen) == blen)
-	{
+	if (write(WRITE(fildes), buf, blen) == blen) {
 		return (0);
 	}
 
@@ -60,6 +59,3 @@ char *buf;
 	setoserror(EIO);
 	return (-1);
 }
-
-
-
diff --git a/librmt/rmtcreat.c b/librmt/rmtcreat.c
index c86d608..7026a36 100644
--- a/librmt/rmtcreat.c
+++ b/librmt/rmtcreat.c
@@ -36,14 +36,9 @@ int rmtcreat(path, mode)
 char *path;
 int mode;
 {
-	if (_rmt_dev(path))
-	{
+	if (_rmt_dev(path)) {
 		return (rmtopen(path, 1 | O_CREAT, mode));
-	}
-	else
-	{
+	} else {
 		return (creat(path, mode));
 	}
 }
-
-
diff --git a/librmt/rmtdev.c b/librmt/rmtdev.c
index b1f2fbb..6271e20 100644
--- a/librmt/rmtdev.c
+++ b/librmt/rmtdev.c
@@ -32,14 +32,10 @@
 int _rmt_dev(path)
 register char *path;
 {
-	if ((path = strchr(path, ':')) != (char *)0)
-	{
-		if (strncmp(path + 1, "/dev/", 5) == 0)
-		{
+	if ((path = strchr(path, ':')) != (char *)0) {
+		if (strncmp(path + 1, "/dev/", 5) == 0) {
 			return (1);
 		}
 	}
 	return (0);
 }
-
-
diff --git a/librmt/rmtfstat.c b/librmt/rmtfstat.c
index 75ff766..67c1f7a 100644
--- a/librmt/rmtfstat.c
+++ b/librmt/rmtfstat.c
@@ -39,12 +39,9 @@ int rmtfstat(fildes, buf)
 int fildes;
 struct stat *buf;
 {
-	if (isrmt(fildes))
-	{
+	if (isrmt(fildes)) {
 		return (_rmt_fstat(fildes - REM_BIAS, (char *)buf));
-	}
-	else
-	{
+	} else {
 		int i;
 		i = fstat(fildes, buf);
 		return i;
@@ -76,11 +73,9 @@ _rmt_fstat(int fildes, char *arg)
 	adj_rc = (rc > sizeof(struct stat)) ? sizeof(struct stat) : rc;
 	rc -= adj_rc;
 
-	for (; adj_rc > 0; adj_rc -= cnt, arg += cnt)
-	{
+	for (; adj_rc > 0; adj_rc -= cnt, arg += cnt) {
 		cnt = read(READ(fildes), arg, adj_rc);
-		if (cnt <= 0)
-		{
+		if (cnt <= 0) {
 abortit:
 			_rmt_abort(fildes);
 			setoserror(EIO);
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index bcf9124..a948593 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -47,8 +47,7 @@ struct  irix_mtget {
 	int		mt_blkno;       /* block number of current position */
 };
 
-struct linux32_mtget
-{
+struct linux32_mtget {
 	int32_t mt_type;        /* Type of magtape device.  */
 	int32_t mt_resid;       /* Residual count: */
 	/* The following registers are device dependent.  */
@@ -60,8 +59,7 @@ struct linux32_mtget
 	int32_t mt_blkno;       /* Current block number.  */
 };
 
-struct linux64_mtget
-{
+struct linux64_mtget {
 	int64_t mt_type;        /* Type of magtape device.  */
 	int64_t mt_resid;       /* Residual count. */
 	/* The following registers are device dependent.  */
@@ -144,8 +142,7 @@ rmtioctl(int fildes, unsigned int request, void *arg)
 {
 	if (isrmt(fildes)) {
 		return (_rmt_ioctl(fildes - REM_BIAS, request, arg));
-	}
-	else {
+	} else {
 		return (ioctl(fildes, request, arg));
 	}
 }
@@ -202,8 +199,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 				setoserror(EINVAL);
 				return (-1);
 			}
-		}
-		else if (RMTHOST(fildes) != UNAME_LINUX) {
+		} else if (RMTHOST(fildes) != UNAME_LINUX) {
 			/* map the linux op code to the standard/fallback op code */
 			mt_op = mtop_stdmap[mt_op];
 			if (mt_op == -1) {
@@ -217,9 +213,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			return (-1);
 		}
 		return (_rmt_status(fildes));
-	}
-	else if (op == MTIOCGET) {
-
+	} else if (op == MTIOCGET) {
 		/*
 		 *  Grab the status and read it directly into the structure.
 		 *  Since the data is binary data, and the other machine might
@@ -262,11 +256,9 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		case UNAME_LINUX:
 			if (sizeof(struct linux32_mtget) == rc) {
 				islinux32 = 1;
-			}
-			else if (sizeof(struct linux64_mtget) == rc) {
+			} else if (sizeof(struct linux64_mtget) == rc) {
 				islinux32 = 0;
-			}
-			else {
+			} else {
 				_rmt_msg(RMTWARN,
 					 _("rmtioctl: Linux mtget structure of wrong size "
 					   "- got %d, wanted %d or %d\n"),
@@ -287,11 +279,9 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 
 		if (RMTHOST(fildes) == UNAME_IRIX) {
 			p = irixget = (char *)&irix_mtget;
-		}
-		else if (islinux32) {
+		} else if (islinux32) {
 			p = linux32get = (char *)&linux32_mtget;
-		}
-		else {
+		} else {
 			p = linux64get = (char *)&linux64_mtget;
 		}
 
@@ -324,8 +314,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 				irixp->mt_fileno = INT_SWAP(irixp->mt_fileno, irixp->mt_fileno);
 				irixp->mt_blkno = INT_SWAP(irixp->mt_blkno, irixp->mt_blkno);
 			}
-		}
-		else if (islinux32) {
+		} else if (islinux32) {
 			struct linux32_mtget *linuxp = (struct linux32_mtget *)linux32get;
 
 			if (linuxp->mt_type > 0xffff) {
@@ -338,10 +327,8 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 				linuxp->mt_fileno = INT_SWAP(linuxp->mt_fileno, linuxp->mt_fileno);
 				linuxp->mt_blkno = INT_SWAP(linuxp->mt_blkno, linuxp->mt_blkno);
 				linuxp->mt_gstat = INT_SWAP(linuxp->mt_gstat, linuxp->mt_gstat);
-
 			}
-		}
-		else {
+		} else {
 			struct linux64_mtget *linuxp = (struct linux64_mtget *)linux64get;
 
 			if (linuxp->mt_type > 0xffff) {
@@ -354,7 +341,6 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 				linuxp->mt_fileno = INT_SWAP(linuxp->mt_fileno, linuxp->mt_fileno);
 				linuxp->mt_blkno = INT_SWAP(linuxp->mt_blkno, linuxp->mt_blkno);
 				linuxp->mt_gstat = INT_SWAP(linuxp->mt_gstat, linuxp->mt_gstat);
-
 			}
 		}
 
@@ -391,8 +377,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 				dstp->mt_gstat |= GMT_EOF(0xffffffff);
 			if (status & IRIX_MT_EW)
 				; /* No GMT_ to map it to */
-		}
-		else if (islinux32) {
+		} else if (islinux32) {
 			struct mtget *dstp = (struct mtget *)arg;
 			struct linux32_mtget *srcp = (struct linux32_mtget *)linux32get;
 
@@ -403,8 +388,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			dstp->mt_blkno = srcp->mt_blkno;
 			dstp->mt_dsreg = srcp->mt_dsreg;
 			dstp->mt_gstat = srcp->mt_gstat;
-		}
-		else {
+		} else {
 			struct mtget *dstp = (struct mtget *)arg;
 			struct linux64_mtget *srcp = (struct linux64_mtget *)linux64get;
 
@@ -417,9 +401,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			dstp->mt_gstat = srcp->mt_gstat;
 		}
 		return (0);
-
-	}
-	else {
+	} else {
 		setoserror(EINVAL);
 		return (-1);
 	}
diff --git a/librmt/rmtisatty.c b/librmt/rmtisatty.c
index 75ae9fc..25758ca 100644
--- a/librmt/rmtisatty.c
+++ b/librmt/rmtisatty.c
@@ -31,12 +31,9 @@
 int rmtisatty(fd)
 int fd;
 {
-	if (isrmt(fd))
-	{
+	if (isrmt(fd)) {
 		return (0);
-	}
-	else
-	{
+	} else {
 		return (isatty(fd));
 	}
 }
diff --git a/librmt/rmtlseek.c b/librmt/rmtlseek.c
index 350d444..546b8c8 100644
--- a/librmt/rmtlseek.c
+++ b/librmt/rmtlseek.c
@@ -37,12 +37,9 @@ int fildes;
 off_t offset;
 int whence;
 {
-	if (isrmt(fildes))
-	{
+	if (isrmt(fildes)) {
 		return (_rmt_lseek(fildes - REM_BIAS, offset, whence));
-	}
-	else
-	{
+	} else {
 		return (lseek(fildes, offset, whence));
 	}
 }
@@ -62,5 +59,3 @@ _rmt_lseek(int fildes, off_t offset, int whence)
 
 	return (_rmt_status(fildes));
 }
-
-
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index 383e9bf..1458ade 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -43,8 +43,7 @@ int _rmt_Ctp[MAXUNIT][2] = { { -1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
 int _rmt_Ptc[MAXUNIT][2] = { { -1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
 int _rmt_host[MAXUNIT] = { -1, -1, -1, -1 };
 
-struct uname_table
-{
+struct uname_table {
 	int	id;
 	char *	name;
 };
@@ -63,12 +62,9 @@ char *path;
 int oflag;
 int mode;
 {
-	if (strchr(path, ':') != NULL)
-	{
+	if (strchr(path, ':') != NULL) {
 		return (_rmt_open(path, oflag, mode) | REM_BIAS);
-	}
-	else
-	{
+	} else {
 		return (open(path, oflag, mode));
 	}
 }
@@ -118,8 +114,7 @@ static int _rmt_open(char *path, int oflag, int mode)
 		if (READ(i) == -1 && WRITE(i) == -1)
 			break;
 
-	if (i == MAXUNIT)
-	{
+	if (i == MAXUNIT) {
 		setoserror(EMFILE);
 		return (-1);
 	}
@@ -134,16 +129,13 @@ static int _rmt_open(char *path, int oflag, int mode)
 	*user = '\0';
 	path++;
 
-	if (*(path - 1) == '@')
-	{
+	if (*(path - 1) == '@') {
 		while (*path != ':') {
 			*sys++ = *path++;
 		}
 		*sys = '\0';
 		path++;
-	}
-	else
-	{
+	} else {
 		for (user = login; (*sys = *user); user++, sys++)
 			;
 		user = login;
@@ -167,8 +159,7 @@ static int _rmt_open(char *path, int oflag, int mode)
 
 		if (user != login) {
 			snprintf(cmd, sizeof(cmd), "%s -l %s %s uname", rsh_path, login, system);
-		}
-		else {
+		} else {
 			snprintf(cmd, sizeof(cmd), "%s %s uname", rsh_path, system);
 		}
 
@@ -179,8 +170,7 @@ static int _rmt_open(char *path, int oflag, int mode)
 				 cmd);
 			RMTHOST(i) = UNAME_UNDEFINED;
 			goto do_rmt;
-		}
-		else {
+		} else {
 			int len;
 			char *c = fgets(uname, sizeof(uname), rmt_f);
 			pclose(rmt_f);
@@ -206,8 +196,7 @@ static int _rmt_open(char *path, int oflag, int mode)
 			_rmt_msg(RMTWARN, _(
 					 "rmtopen: remote host type, \"%s\", is unknown to librmt\n"),
 				 uname);
-		}
-		else {
+		} else {
 			RMTHOST(i) = p->id;
 			_rmt_msg(RMTDBG, "rmtopen: RMTHOST(%d) = %s\n", i, p->name);
 		}
@@ -224,8 +213,7 @@ do_rmt:
 	if ((rc = fork()) == -1)
 		return (-1);
 
-	if (rc == 0)
-	{
+	if (rc == 0) {
 		close(0);
 		dup(_rmt_Ptc[i][0]);
 		close(_rmt_Ptc[i][0]); close(_rmt_Ptc[i][1]);
@@ -237,17 +225,13 @@ do_rmt:
 		if (_rmt_msgson() == RMTDBG) {
 			snprintf(rmt_cmd, sizeof(rmt_cmd), "%s %s.%d",
 				 rmt_path, RMT_DEBUG_FILE, getpid());
-		}
-		else {
+		} else {
 			strncpy(rmt_cmd, rmt_path, sizeof(rmt_cmd));
 		}
-		if (user != login)
-		{
+		if (user != login) {
 			execl(rsh_path, "rsh", system, "-l", login,
 			      rmt_cmd, (char *)0);
-		}
-		else
-		{
+		} else {
 			execl(rsh_path, "rsh", system,
 			      rmt_cmd, (char *)0);
 		}
diff --git a/librmt/rmtread.c b/librmt/rmtread.c
index 6edfb08..1004992 100644
--- a/librmt/rmtread.c
+++ b/librmt/rmtread.c
@@ -38,12 +38,9 @@ int fildes;
 char *buf;
 unsigned int nbyte;
 {
-	if (isrmt(fildes))
-	{
+	if (isrmt(fildes)) {
 		return (_rmt_read(fildes - REM_BIAS, buf, nbyte));
-	}
-	else
-	{
+	} else {
 		return (read(fildes, buf, nbyte));
 	}
 }
@@ -62,11 +59,9 @@ _rmt_read(int fildes, char *buf, unsigned int nbyte)
 	if (_rmt_command(fildes, buffer) == -1 || (rc = _rmt_status(fildes)) == -1)
 		return (-1);
 
-	for (i = 0; i < rc; i += nbyte, buf += nbyte)
-	{
+	for (i = 0; i < rc; i += nbyte, buf += nbyte) {
 		nbyte = read(READ(fildes), buf, rc);
-		if (nbyte <= 0)
-		{
+		if (nbyte <= 0) {
 			_rmt_abort(fildes);
 			setoserror(EIO);
 			return (-1);
diff --git a/librmt/rmtstatus.c b/librmt/rmtstatus.c
index 11ff375..3691eef 100644
--- a/librmt/rmtstatus.c
+++ b/librmt/rmtstatus.c
@@ -43,23 +43,19 @@ int fildes;
  *	read the reply command line
  */
 
-	for (i = 0, cp = buffer; i < BUFMAGIC; i++, cp++)
-	{
-		if (read(READ(fildes), cp, 1) != 1)
-		{
+	for (i = 0, cp = buffer; i < BUFMAGIC; i++, cp++) {
+		if (read(READ(fildes), cp, 1) != 1) {
 			_rmt_abort(fildes);
 			setoserror(EIO);
 			return (-1);
 		}
-		if (*cp == '\n')
-		{
+		if (*cp == '\n') {
 			*cp = 0;
 			break;
 		}
 	}
 
-	if (i == BUFMAGIC)
-	{
+	if (i == BUFMAGIC) {
 		_rmt_abort(fildes);
 		setoserror(EIO);
 		return (-1);
@@ -73,8 +69,7 @@ int fildes;
 		if (*cp != ' ')
 			break;
 
-	if (*cp == 'E' || *cp == 'F')
-	{
+	if (*cp == 'E' || *cp == 'F') {
 		setoserror(atoi(cp + 1));
 		while (read(READ(fildes), &c, 1) == 1)
 			if (c == '\n')
@@ -90,8 +85,7 @@ int fildes;
  *	check for mis-synced pipes
  */
 
-	if (*cp != 'A')
-	{
+	if (*cp != 'A') {
 		_rmt_abort(fildes);
 		setoserror(EIO);
 		return (-1);
@@ -99,6 +93,3 @@ int fildes;
 
 	return (atoi(cp + 1));
 }
-
-
-
diff --git a/librmt/rmtwrite.c b/librmt/rmtwrite.c
index 4610222..830be20 100644
--- a/librmt/rmtwrite.c
+++ b/librmt/rmtwrite.c
@@ -38,12 +38,9 @@ int fildes;
 char *buf;
 unsigned int nbyte;
 {
-	if (isrmt(fildes))
-	{
+	if (isrmt(fildes)) {
 		return (_rmt_write(fildes - REM_BIAS, buf, nbyte));
-	}
-	else
-	{
+	} else {
 		return (write(fildes, buf, nbyte));
 	}
 }
@@ -61,8 +58,7 @@ _rmt_write(int fildes, char *buf, unsigned int nbyte)
 	if (_rmt_command(fildes, buffer) == -1)
 		return (-1);
 
-	if (write(WRITE(fildes), buf, nbyte) == nbyte)
-	{
+	if (write(WRITE(fildes), buf, nbyte) == nbyte) {
 		return (_rmt_status(fildes));
 	}
 
diff --git a/restore/content.c b/restore/content.c
index c360205..09080c3 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -1543,7 +1543,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		persp->v.housekeeping_magic = HOUSEKEEPING_MAGIC;
 		persp->v.housekeeping_version = HOUSEKEEPING_VERSION;
 		persp->v.pagesize = pgsz;
-
 	} else {
 		/*
 		 * cumulative or resuming a restore, verify the header
@@ -2573,7 +2572,6 @@ content_stream_restore(ix_t thrdix)
 				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_treeinitdonepr = BOOL_TRUE;
-
 		} else {
 			ok = tree_check_dump_format(grhdrp->gh_version);
 			if (! ok) {
@@ -3274,8 +3272,7 @@ applydirdump(drive_t *			drivep,
 			 * if in a pipeline, call preemptchk() to
 			 * print status reports
 			 */
-			if (pipeline)
-			{
+			if (pipeline) {
 				mlog(MLOG_DEBUG,
 				     "preemptchk()\n");
 				preemptchk();
@@ -3713,7 +3710,6 @@ applynondirdump(drive_t *		drivep,
 		 * complete the old one and begin the new one.
 		 */
 		if (bstatp->bs_ino != strctxp->sc_bstat.bs_ino) {
-
 			restore_complete_reg(strctxp);
 
 			/* start new ino */
@@ -3723,7 +3719,6 @@ applynondirdump(drive_t *		drivep,
 			strctxp->sc_ownerset = BOOL_FALSE;
 
 			rv = restore_file(drivep, fhdrp, ehcs, ahcs, path1, path2);
-
 		} else if (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR) {
 			rv = restore_extattr(drivep,
 					     fhdrp,
@@ -3845,8 +3840,7 @@ applynondirdump(drive_t *		drivep,
 		 * if in a pipeline, call preemptchk() to
 		 * print status reports
 		 */
-		if (pipeline)
-		{
+		if (pipeline) {
 			mlog(MLOG_DEBUG,
 			     "preemptchk()\n");
 			preemptchk();
@@ -3872,26 +3866,29 @@ finalize(char *path1, char *path2)
 	bool_t ok;
 
 	if (! tranp->t_toconlypr) {
-
 		/*
 		 * restore directory attributes
 		 */
-		if (! persp->s.dirattrdonepr) {;
-					      ok = tree_setattr(path1);
-					      if (! ok) {
-						      return RV_INTR;
-					      }
-					      persp->s.dirattrdonepr = BOOL_TRUE; }
+		if (! persp->s.dirattrdonepr) {
+			;
+			ok = tree_setattr(path1);
+			if (! ok) {
+				return RV_INTR;
+			}
+			persp->s.dirattrdonepr = BOOL_TRUE;
+		}
 
 		/*
 		 * remove orphanage if empty
 		 */
-		if (! persp->s.orphdeltriedpr) {;
-					       ok = tree_delorph();
-					       if (! ok) {
-						       return RV_INTR;
-					       }
-					       persp->s.orphdeltriedpr = BOOL_TRUE; }
+		if (! persp->s.orphdeltriedpr) {
+			;
+			ok = tree_delorph();
+			if (! ok) {
+				return RV_INTR;
+			}
+			persp->s.orphdeltriedpr = BOOL_TRUE;
+		}
 
 		/*
 		 * delete the persistent ino map
@@ -3950,6 +3947,7 @@ wipepersstate(void)
 	DIR *dirp;
 	struct dirent64 *direntp;
 	char pathname[MAXPATHLEN];
+
 	dirp = opendir(tranp->t_hkdir);
 	if (! dirp) {
 		return;
@@ -4520,7 +4518,6 @@ validate:
 		 */
 		if (uuid_compare(prevmfiledumpid,
 				 grhdrp->gh_dumpid) != 0) {
-
 			char string_uuid[UUID_STR_LEN + 1];
 
 			mlog_lock();
@@ -5008,8 +5005,7 @@ newmedia:
 		 */
 		if ((*dop->do_get_device_class)(drivep)
 		    ==
-		    DEVICE_NONREMOVABLE)
-		{
+		    DEVICE_NONREMOVABLE) {
 			/*
 			 * if no error has already been detected then don't log
 			   a failure */
@@ -6222,7 +6218,6 @@ pi_scanfileendino(dh_t fileh)
 			     nexth != DH_NULL
 			     ;
 			     nexth = DH2F(nexth)->f_nexth) {
-
 				switch (mode) {
 				case 0:
 					if (nexth == fileh) {
@@ -6636,7 +6631,6 @@ pi_neededobjs_nondir_alloc(bool_t *	knownholesprp,
 			    ! DH2F(tailh)->f_nondirdonepr
 			    &&
 			    ! DH2F(tailh)->f_nondirskippr) {
-
 				dh_t objh = DH2F(tailh)->f_parh;
 
 				if (! DH2O(objh)->o_indrivepr
@@ -6667,7 +6661,6 @@ pi_neededobjs_nondir_alloc(bool_t *	knownholesprp,
 		} while (tailh != headh);
 
 		tailegrp = headegrp;
-
 	} while (headh != DH_NULL);
 
 	pi_unlock();
@@ -7947,7 +7940,6 @@ restore_reg(drive_t *	drivep,
 	}
 
 	if (persp->a.dstdirisxfspr) {
-
 		/*
 		 * set the extended inode flags, except those which must
 		 * be set only after all data has been restored.
@@ -8312,7 +8304,6 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
 				return BOOL_TRUE;
 			}
 			(void)close(sockfd);
-
 		} else {
 			/*
 			 * create the node
@@ -9379,8 +9370,7 @@ dump_partials(void)
 				       (unsigned long long)isptr->is_ino);
 				for (j = 0, bsptr = isptr->is_bs;
 				     j < drivecnt;
-				     j++, bsptr++)
-				{
+				     j++, bsptr++) {
 					if (bsptr->endoffset > 0) {
 						printf("%d:%lld-%lld ",
 						       j, (long long)bsptr->offset,
@@ -9426,8 +9416,7 @@ check_valid_partials(void)
 				isptr = &persp->a.parrest[i];
 				for (j = 0, bsptr = isptr->is_bs;
 				     j < drivecnt;
-				     j++, bsptr++)
-				{
+				     j++, bsptr++) {
 					if (bsptr->endoffset > 0) {
 						num_partials[j]++;
 						if (num_partials[j] > 2) {
@@ -9640,8 +9629,7 @@ gapsearch:
 	for (i = 0, bsptr = isptr->is_bs; i < drivecnt; i++, bsptr++) {
 		if (bsptr->endoffset > 0 &&
 		    bsptr->offset <= curoffset &&
-		    bsptr->endoffset > curoffset)
-		{
+		    bsptr->endoffset > curoffset) {
 			curoffset = bsptr->endoffset;
 			goto gapsearch;
 		}
@@ -10165,7 +10153,6 @@ display_needed_objects(purp_t	purp,
 			     _("\nthere may be unidentified media "
 			       "objects containing media files not yet tried "
 			       "for directory hierarchy restoral:\n"));
-
 		}
 		if (purp == PURP_NONDIR) {
 			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
diff --git a/restore/dirattr.c b/restore/dirattr.c
index 69557a9..95d5d38 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -409,6 +409,7 @@ dirattr_add(filehdr_t *fhdrp)
 	dirattr_t dirattr;
 	off64_t oldoff;
 	dix_t dix;
+
 #ifdef DIRATTRCHK
 	uint16_t sum;
 #endif /* DIRATTRCHK */
@@ -790,6 +791,7 @@ void
 dirattr_update(dah_t dah, filehdr_t *fhdrp)
 {
 	dix_t dix;
+
 #ifdef DIRATTRCHK
 	uint16_t sum;
 #endif /* DIRATTRCHK */
@@ -1003,6 +1005,7 @@ dirattr_get(dah_t dah)
 	off64_t argoff;
 	off64_t newoff;
 	int nread;
+
 #ifdef DIRATTRCHK
 	uint16_t sum;
 #endif /* DIRATTRCHK */
@@ -1083,6 +1086,7 @@ dirattr_cacheflush(void)
 {
 	dah_t dah;
 	dix_t dix;
+
 #ifdef DIRATTRCHK
 	uint16_t sum;
 #endif /* DIRATTRCHK */
diff --git a/restore/inomap.c b/restore/inomap.c
index 2611d98..fabc557 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -115,6 +115,7 @@ SEG_SET_BITS(seg_t *segp, xfs_ino_t ino, int state)
 	register xfs_ino_t relino;
 	register uint64_t mask;
 	register uint64_t clrmask;
+
 	relino = ino - segp->base;
 	mask = (uint64_t)1 << relino;
 	clrmask = ~mask;
@@ -168,6 +169,7 @@ SEG_GET_BITS(seg_t *segp, xfs_ino_t ino)
 	int state;
 	register xfs_ino_t relino;
 	register uint64_t mask;
+
 	relino = ino - segp->base;
 	mask = (uint64_t)1 << relino;
 	if (segp->lobits & mask) {
@@ -468,6 +470,7 @@ void
 inomap_del_pers(char *hkdir)
 {
 	char *perspath = open_pathalloc(hkdir, PERS_NAME, 0);
+
 	(void)unlink(perspath);
 	free((void *)perspath);
 }
diff --git a/restore/mmap.c b/restore/mmap.c
index 851b33c..932fbe9 100644
--- a/restore/mmap.c
+++ b/restore/mmap.c
@@ -32,8 +32,10 @@ mmap_autogrow(size_t len, int fd, off_t offset)
 	char nul_buffer[] = "";
 
 	/* prealloc file if it is an empty file */
-	if (fstat(fd, &buf) == -1) {;
-				    return (void *)MAP_FAILED; }
+	if (fstat(fd, &buf) == -1) {
+		;
+		return (void *)MAP_FAILED;
+	}
 	if (buf.st_size < offset + len) {
 		(void)lseek(fd, offset + len - 1, SEEK_SET);
 		(void)write(fd, nul_buffer, 1);
diff --git a/restore/namreg.c b/restore/namreg.c
index 883f379..e760557 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -362,7 +362,6 @@ namreg_flush(void)
 	assert(ntp);
 
 	if (ntp->nt_off) {
-
 		/*
 		 * write the accumulated name strings.
 		 */
@@ -396,6 +395,7 @@ namreg_get(nrh_t	nrh,
 	size_t len;
 	char *in_bufp;
 	static char read_buf[256];
+
 	/* long enough for the longest allowed name (255), plus 1 for length */
 #ifdef NAMREGCHK
 	nrh_t chkbit;
@@ -436,11 +436,8 @@ namreg_get(nrh_t	nrh,
 	lock();
 
 	if (ntp->nt_map) {
-
 		in_bufp = ntp->nt_map + newoff - NAMREG_PERS_SZ;
-
 	} else {
-
 		if (ntp->nt_at_endpr && ntp->nt_off) {
 			if (namreg_flush() != RV_OK) {
 				unlock();
diff --git a/restore/node.c b/restore/node.c
index edfa947..a987160 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -335,7 +335,6 @@ node_init(int		fd,
 	}
 
 	for (winmapmax = 0, segcount = 1; winmapmax < WINMAP_MIN; segcount <<= 1) {
-
 		nodesperseg = max(dirs_nondirs_cnt / segcount, NODESPERSEG_MIN);
 
 		/* nodesperseg must be a power of 2 */
@@ -472,6 +471,7 @@ node_alloc(void)
 {
 	u_char_t *p;
 	nh_t nh;
+
 #ifdef NODECHK
 	u_char_t *hkpp;
 	u_char_t gen = 0;
@@ -504,7 +504,6 @@ node_alloc(void)
 		node_hdrp->nh_freenh = *linkagep;
 
 		node_unmap_internal(nh, (void **)&p, BOOL_TRUE);
-
 	} else {
 		if (nh2relnix(node_hdrp->nh_virgnh) == 0) {
 			/* need to start a new virgin segment */
@@ -566,6 +565,7 @@ void *
 node_map(nh_t nh)
 {
 	u_char_t *p;
+
 #ifdef NODECHK
 	register u_char_t hkp;
 	register u_char_t hdlgen;
@@ -617,6 +617,7 @@ node_free(nh_t *nhp)
 	nh_t nh;
 	u_char_t *p;
 	register nh_t *linkagep;
+
 #ifdef NODECHK
 	register u_char_t *hkpp;
 	register u_char_t hdlgen;
diff --git a/restore/tree.c b/restore/tree.c
index 3f77c9a..81b0d4a 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -788,6 +788,7 @@ tree_marknoref_recurse(nh_t parh)
 		cldh = parp->n_cldh;
 		Node_unmap(parh, &parp);
 	}
+
 	while (cldh != NH_NULL) {
 		node_t *cldp;
 		nh_t nextcldh;
@@ -1527,7 +1528,7 @@ noref_elim_recurse(nh_t		parh,
 				Node_unmap(renameh, &renamep);
 				Node_unmap(cldh, &cldp);
 			}
-		} else  {
+		} else {
 			/*
 			 * determine if we can unlink this node.
 			 * if its not real, and not refed, simple.
@@ -1581,8 +1582,7 @@ noref_elim_recurse(nh_t		parh,
 				}
 				if (neededpr) {
 					mustorphpr = BOOL_TRUE;
-				}
-				else {
+				} else {
 					canunlinkpr = BOOL_TRUE;
 				}
 			}
@@ -1728,7 +1728,6 @@ mkdirs_recurse(nh_t parh, nh_t cldh, char *path)
 					     "mkdir %s failed: %s\n"),
 				     path,
 				     strerror(errno));
-
 			} else {
 				cldp = Node_map(cldh);
 				cldp->n_flags |= NF_REAL;
@@ -2057,7 +2056,6 @@ tree_cb_links(xfs_ino_t					ino,
 					return RV_NOTOK;
 				}
 			} else {
-
 				if (! tranp->t_toconlypr) {
 					char *dir;
 					char tmp[PATH_MAX];
@@ -2146,6 +2144,7 @@ tree_adjref_recurse(nh_t	cldh,
 		grandcldh = cldp->n_cldh;
 		Node_unmap(cldh, &cldp);
 	}
+
 	while (grandcldh != NH_NULL) {
 		node_t *grandcldp;
 		nh_t nextgrandcldh;
@@ -2340,7 +2339,6 @@ proc_hardlinks_cb(void *contextp, nh_t hardheadh)
 	lnsrch = NH_NULL;
 	link_iter_init(&link_iter_context, hardheadh);
 	while ((nh = link_iter_next(&link_iter_context)) != NH_NULL) {
-
 		node_t *np = Node_map(nh);
 		bool_t isrealpr = np->n_flags & NF_REAL;
 		bool_t isrefpr = np->n_flags & NF_REFED;
@@ -2624,6 +2622,7 @@ tree_setattr_recurse(nh_t parh, char *path)
 {
 	node_t *parp = Node_map(parh);
 	nh_t cldh = parp->n_cldh;
+
 	Node_unmap(parh, &parp);
 	while (cldh != NH_NULL) {
 		nh_t nextcldh;
@@ -3624,6 +3623,7 @@ static void
 Node_free(nh_t *nhp)
 {
 	node_t *np;
+
 	np = Node_map(*nhp);
 	np->n_ino = 0;
 	np->n_gen = 0;
@@ -3652,6 +3652,7 @@ static node_t *
 Node_map(nh_t nh)
 {
 	node_t *n = (node_t *)node_map(nh);
+
 	if (n == NULL) {
 		mlog(MLOG_ERROR | MLOG_TREE, _(
 			     "failed to map in node (node handle: %u)\n"), nh);
@@ -3674,6 +3675,7 @@ static bool_t
 Node2path(nh_t nh, char *path, char *errmsg)
 {
 	int remainingcnt;
+
 	strcpy(path, "."); /* in case root node passed in */
 	remainingcnt = Node2path_recurse(nh, path, MAXPATHLEN, 0);
 	if (remainingcnt <= 0) {
@@ -5212,8 +5214,7 @@ mkdir_r(char *path)
 		if (mkdir_r(dirname(strdup(path))) < 0)
 			return -1;
 		return mkdir(path, 0755);
-	}
-	else if ((sbuf.st_mode & S_IFDIR) == 0) {
+	} else if ((sbuf.st_mode & S_IFDIR) == 0) {
 		mlog(MLOG_TRACE | MLOG_ERROR | MLOG_TREE, _(
 			     "%s is not a directory\n"),
 		     path);
-- 
2.19.1
