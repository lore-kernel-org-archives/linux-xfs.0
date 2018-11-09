Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14681 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbeKJAN1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:13:27 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95EDD58E46
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:32:36 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 24/24] xfsdump: (style) remove parentheses after return
Date: Fri,  9 Nov 2018 15:30:04 +0100
Message-Id: <20181109143004.24963-25-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

"return (foo);" -> "return foo;"

Created by Uncrustify with this config file:

#
# uncrustify config, remove parentheses after return
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

mod_paren_on_return	= remove	# "return 1;" vs "return (1);"
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
 common/drive_minrmt.c   |  2 +-
 common/drive_scsitape.c |  2 +-
 dump/content.c          |  4 ++--
 include/swab.h          | 12 ++++++------
 inventory/inv_mgr.c     |  2 +-
 inventory/inv_priv.h    |  2 +-
 invutil/invutil.c       | 14 +++++++-------
 librmt/isrmt.c          |  2 +-
 librmt/rmtaccess.c      |  4 ++--
 librmt/rmtclose.c       |  8 ++++----
 librmt/rmtcommand.c     |  4 ++--
 librmt/rmtcreat.c       |  4 ++--
 librmt/rmtdev.c         |  4 ++--
 librmt/rmtfstat.c       |  8 ++++----
 librmt/rmtioctl.c       | 30 +++++++++++++++---------------
 librmt/rmtisatty.c      |  4 ++--
 librmt/rmtlseek.c       |  8 ++++----
 librmt/rmtopen.c        | 14 +++++++-------
 librmt/rmtread.c        | 10 +++++-----
 librmt/rmtstatus.c      | 10 +++++-----
 librmt/rmtwrite.c       | 10 +++++-----
 21 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index dc6d502..e926eeb 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -3121,7 +3121,7 @@ determine_write_error(int nwritten, int saved_errno)
 	     nwritten,
 	     saved_errno);
 
-	return (ret);
+	return ret;
 }
 
 static void
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 3c0b139..4ab1b55 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -3853,7 +3853,7 @@ determine_write_error(drive_t *drivep, int nwritten, int saved_errno)
 	     nwritten,
 	     saved_errno);
 
-	return (ret);
+	return ret;
 }
 
 static void
diff --git a/dump/content.c b/dump/content.c
index 64f6029..29652c2 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -6975,7 +6975,7 @@ getxfsqstat(char *fsname)
 	memset(&qstat, 0, sizeof(fs_quota_stat_t));
 	if (quotactl(QCMD(Q_XGETQSTAT, 0), fsname, 0,
 		     (caddr_t)&qstat) < 0) {
-		return (-1);
+		return -1;
 	}
-	return ((int)qstat.qs_flags);
+	return (int)qstat.qs_flags;
 }
diff --git a/include/swab.h b/include/swab.h
index 0a5289f..55090fc 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -111,11 +111,11 @@
 
 static __inline__ __u16 __fswab16(__u16 x)
 {
-	return (__extension__ __arch__swab16(x));
+	return __extension__ __arch__swab16(x);
 }
 static __inline__ __u16 __swab16p(__u16 *x)
 {
-	return (__extension__ __arch__swab16p(x));
+	return __extension__ __arch__swab16p(x);
 }
 static __inline__ void __swab16s(__u16 *addr)
 {
@@ -124,11 +124,11 @@ static __inline__ void __swab16s(__u16 *addr)
 
 static __inline__ __u32 __fswab32(__u32 x)
 {
-	return (__extension__ __arch__swab32(x));
+	return __extension__ __arch__swab32(x);
 }
 static __inline__ __u32 __swab32p(__u32 *x)
 {
-	return (__extension__ __arch__swab32p(x));
+	return __extension__ __arch__swab32p(x);
 }
 static __inline__ void __swab32s(__u32 *addr)
 {
@@ -142,12 +142,12 @@ static __inline__ __u64 __fswab64(__u64 x)
 	__u32 l = x & ((1ULL << 32) - 1);
 	return (((__u64)__swab32(l)) << 32) | ((__u64)(__swab32(h)));
 #  else
-	return (__extension__ __arch__swab64(x));
+	return __extension__ __arch__swab64(x);
 #  endif
 }
 static __inline__ __u64 __swab64p(__u64 *x)
 {
-	return (__extension__ __arch__swab64p(x));
+	return __extension__ __arch__swab64p(x);
 }
 static __inline__ void __swab64s(__u64 *addr)
 {
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index 2ac1323..c7d0bb1 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -372,7 +372,7 @@ invmgr_inv_print(
 	if (prctx->invidx) {
 		idx_DEBUG_printinvindices(iarr, (uint)nindices);
 		free(iarr);
-		return (0);
+		return 0;
 	}
 
 
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 1cd90f9..3b6b545 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -200,7 +200,7 @@ typedef struct invt_counter {
 typedef struct invt_sescounter {
 	INVT_COUNTER_FIELDS
 	off64_t ic_eof;          /* current end of the file, where the next
-	                         *  media file or stream will be written to */
+	                          *  media file or stream will be written to */
 	char	ic_padding[0x20 - (INVT_COUNTER_FIELDS_SIZE +
 				   sizeof(off64_t))];
 } invt_sescounter_t;
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 24a7b6a..88c6b2d 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -411,7 +411,7 @@ GetNameOfStobj(char *inv_path, char *filename)
 	strcat(name, "/");
 	strcat(name, str);
 
-	return (name);
+	return name;
 }
 
 char *
@@ -428,7 +428,7 @@ GetNameOfInvIndex(char *inv_path, uuid_t uuid)
 	strcat(name, str);
 	strcat(name, INV_INVINDEX_PREFIX);
 
-	return (name);
+	return name;
 }
 
 char *
@@ -441,7 +441,7 @@ GetFstabFullPath(char *inv_path)
 	strcpy(fstabname, inv_path);
 	strcat(fstabname, "/");
 	strcat(fstabname, "fstab");
-	return (fstabname);
+	return fstabname;
 }
 
 void
@@ -684,10 +684,10 @@ CheckAndPruneInvIndexFile(bool_t	checkonly,
 			printf("unlink idx file %s\n", idxFileName);
 		}
 		unlink(idxFileName);
-		return (-1);
+		return -1;
 	}
 
-	return (0);
+	return 0;
 }
 
 int
@@ -891,10 +891,10 @@ CheckAndPruneStObjFile(bool_t	checkonly,
 		if (debug)
 			printf("Removing: %s\n", StObjFileName);
 		unlink(StObjFileName);
-		return (-1);
+		return -1;
 	}
 
-	return (0);
+	return 0;
 }
 
 /*
diff --git a/librmt/isrmt.c b/librmt/isrmt.c
index 79f685e..32d03ad 100644
--- a/librmt/isrmt.c
+++ b/librmt/isrmt.c
@@ -30,5 +30,5 @@
 int isrmt(fd)
 int fd;
 {
-	return (fd >= REM_BIAS);
+	return fd >= REM_BIAS;
 }
diff --git a/librmt/rmtaccess.c b/librmt/rmtaccess.c
index ef1c2ac..801a533 100644
--- a/librmt/rmtaccess.c
+++ b/librmt/rmtaccess.c
@@ -34,8 +34,8 @@ char *path;
 int amode;
 {
 	if (_rmt_dev(path)) {
-		return (0);             /* Let /etc/rmt find out */
+		return 0;             /* Let /etc/rmt find out */
 	} else {
-		return (access(path, amode));
+		return access(path, amode);
 	}
 }
diff --git a/librmt/rmtclose.c b/librmt/rmtclose.c
index 1744220..602cf01 100644
--- a/librmt/rmtclose.c
+++ b/librmt/rmtclose.c
@@ -36,9 +36,9 @@ int fildes;
 		/* no longer know what host we have for this fildes */
 		RMTHOST(fildes - REM_BIAS) = UNAME_UNKNOWN;
 
-		return (_rmt_close(fildes - REM_BIAS));
+		return _rmt_close(fildes - REM_BIAS);
 	} else {
-		return (close(fildes));
+		return close(fildes);
 	}
 }
 
@@ -54,8 +54,8 @@ _rmt_close(int fildes)
 		rc = _rmt_status(fildes);
 
 		_rmt_abort(fildes);
-		return (rc);
+		return rc;
 	}
 
-	return (-1);
+	return -1;
 }
diff --git a/librmt/rmtcommand.c b/librmt/rmtcommand.c
index 6b96af9..d722e86 100644
--- a/librmt/rmtcommand.c
+++ b/librmt/rmtcommand.c
@@ -47,7 +47,7 @@ char *buf;
 
 	blen = strlen(buf);
 	if (write(WRITE(fildes), buf, blen) == blen) {
-		return (0);
+		return 0;
 	}
 
 /*
@@ -57,5 +57,5 @@ char *buf;
 	_rmt_abort(fildes);
 
 	setoserror(EIO);
-	return (-1);
+	return -1;
 }
diff --git a/librmt/rmtcreat.c b/librmt/rmtcreat.c
index 7026a36..d2ecf2f 100644
--- a/librmt/rmtcreat.c
+++ b/librmt/rmtcreat.c
@@ -37,8 +37,8 @@ char *path;
 int mode;
 {
 	if (_rmt_dev(path)) {
-		return (rmtopen(path, 1 | O_CREAT, mode));
+		return rmtopen(path, 1 | O_CREAT, mode);
 	} else {
-		return (creat(path, mode));
+		return creat(path, mode);
 	}
 }
diff --git a/librmt/rmtdev.c b/librmt/rmtdev.c
index 6271e20..5eeef6a 100644
--- a/librmt/rmtdev.c
+++ b/librmt/rmtdev.c
@@ -34,8 +34,8 @@ register char *path;
 {
 	if ((path = strchr(path, ':')) != (char *)0) {
 		if (strncmp(path + 1, "/dev/", 5) == 0) {
-			return (1);
+			return 1;
 		}
 	}
-	return (0);
+	return 0;
 }
diff --git a/librmt/rmtfstat.c b/librmt/rmtfstat.c
index 67c1f7a..dae3d9a 100644
--- a/librmt/rmtfstat.c
+++ b/librmt/rmtfstat.c
@@ -40,7 +40,7 @@ int fildes;
 struct stat *buf;
 {
 	if (isrmt(fildes)) {
-		return (_rmt_fstat(fildes - REM_BIAS, (char *)buf));
+		return _rmt_fstat(fildes - REM_BIAS, (char *)buf);
 	} else {
 		int i;
 		i = fstat(fildes, buf);
@@ -66,7 +66,7 @@ _rmt_fstat(int fildes, char *arg)
 
 	if (_rmt_command(fildes, buffer) == -1 ||
 	    (rc = _rmt_status(fildes)) == -1)
-		return (-1);
+		return -1;
 
 	/* adjust read count to prevent overflow */
 
@@ -79,7 +79,7 @@ _rmt_fstat(int fildes, char *arg)
 abortit:
 			_rmt_abort(fildes);
 			setoserror(EIO);
-			return (-1);
+			return -1;
 		}
 	}
 
@@ -88,5 +88,5 @@ abortit:
 		if (read(READ(fildes), buffer, 1) <= 0)
 			goto abortit;
 
-	return (0);
+	return 0;
 }
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index a948593..abddbce 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -141,9 +141,9 @@ int
 rmtioctl(int fildes, unsigned int request, void *arg)
 {
 	if (isrmt(fildes)) {
-		return (_rmt_ioctl(fildes - REM_BIAS, request, arg));
+		return _rmt_ioctl(fildes - REM_BIAS, request, arg);
 	} else {
-		return (ioctl(fildes, request, arg));
+		return ioctl(fildes, request, arg);
 	}
 }
 
@@ -189,7 +189,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			_rmt_msg(RMTWARN,
 				 _("rmtioctl: remote host type not supported for MTIOCTOP\n"));
 			setoserror(EPROTONOSUPPORT);
-			return (-1);
+			return -1;
 		}
 
 		/* map the linux op code to the irix op code */
@@ -197,22 +197,22 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			mt_op = mtop_irixmap[mt_op];
 			if (mt_op == -1) {
 				setoserror(EINVAL);
-				return (-1);
+				return -1;
 			}
 		} else if (RMTHOST(fildes) != UNAME_LINUX) {
 			/* map the linux op code to the standard/fallback op code */
 			mt_op = mtop_stdmap[mt_op];
 			if (mt_op == -1) {
 				setoserror(EINVAL);
-				return (-1);
+				return -1;
 			}
 		}
 
 		sprintf(buffer, "I%d\n%d\n", mt_op, mt_count);
 		if (_rmt_command(fildes, buffer) == -1) {
-			return (-1);
+			return -1;
 		}
-		return (_rmt_status(fildes));
+		return _rmt_status(fildes);
 	} else if (op == MTIOCGET) {
 		/*
 		 *  Grab the status and read it directly into the structure.
@@ -228,7 +228,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 		 */
 		if (_rmt_command(fildes, "S") == -1 ||
 		    (rc = _rmt_status(fildes)) == -1)
-			return (-1);
+			return -1;
 
 
 		/*
@@ -242,7 +242,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			_rmt_msg(RMTWARN,
 				 _("rmtioctl: remote host type not supported for MTIOCGET\n"));
 			setoserror(EPROTONOSUPPORT);
-			return (-1);
+			return -1;
 		case UNAME_IRIX:
 			if (sizeof(struct irix_mtget) != rc) {
 				_rmt_msg(RMTWARN,
@@ -250,7 +250,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 					   " - got %d, wanted %d\n"),
 					 rc, sizeof(struct irix_mtget));
 				setoserror(EPROTONOSUPPORT);
-				return (-1);
+				return -1;
 			}
 			break;
 		case UNAME_LINUX:
@@ -265,12 +265,12 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 					 rc, sizeof(struct linux32_mtget),
 					 sizeof(struct linux64_mtget));
 				setoserror(EPROTONOSUPPORT);
-				return (-1);
+				return -1;
 			}
 			break;
 		default:
 			setoserror(EPROTONOSUPPORT);
-			return (-1);
+			return -1;
 		}
 
 
@@ -293,7 +293,7 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			if (cnt <= 0) {
 				_rmt_abort(fildes);
 				setoserror(EIO);
-				return (-1);
+				return -1;
 			}
 		}
 
@@ -400,9 +400,9 @@ _rmt_ioctl(int fildes, unsigned int op, void *arg)
 			dstp->mt_dsreg = srcp->mt_dsreg;
 			dstp->mt_gstat = srcp->mt_gstat;
 		}
-		return (0);
+		return 0;
 	} else {
 		setoserror(EINVAL);
-		return (-1);
+		return -1;
 	}
 }
diff --git a/librmt/rmtisatty.c b/librmt/rmtisatty.c
index 25758ca..9262694 100644
--- a/librmt/rmtisatty.c
+++ b/librmt/rmtisatty.c
@@ -32,8 +32,8 @@ int rmtisatty(fd)
 int fd;
 {
 	if (isrmt(fd)) {
-		return (0);
+		return 0;
 	} else {
-		return (isatty(fd));
+		return isatty(fd);
 	}
 }
diff --git a/librmt/rmtlseek.c b/librmt/rmtlseek.c
index 546b8c8..44b2d5e 100644
--- a/librmt/rmtlseek.c
+++ b/librmt/rmtlseek.c
@@ -38,9 +38,9 @@ off_t offset;
 int whence;
 {
 	if (isrmt(fildes)) {
-		return (_rmt_lseek(fildes - REM_BIAS, offset, whence));
+		return _rmt_lseek(fildes - REM_BIAS, offset, whence);
 	} else {
-		return (lseek(fildes, offset, whence));
+		return lseek(fildes, offset, whence);
 	}
 }
 
@@ -55,7 +55,7 @@ _rmt_lseek(int fildes, off_t offset, int whence)
 
 	sprintf(buffer, "L%ld\n%d\n", (long)offset, whence);
 	if (_rmt_command(fildes, buffer) == -1)
-		return (-1);
+		return -1;
 
-	return (_rmt_status(fildes));
+	return _rmt_status(fildes);
 }
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index 1458ade..65a519f 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -63,9 +63,9 @@ int oflag;
 int mode;
 {
 	if (strchr(path, ':') != NULL) {
-		return (_rmt_open(path, oflag, mode) | REM_BIAS);
+		return _rmt_open(path, oflag, mode) | REM_BIAS;
 	} else {
-		return (open(path, oflag, mode));
+		return open(path, oflag, mode);
 	}
 }
 
@@ -116,7 +116,7 @@ static int _rmt_open(char *path, int oflag, int mode)
 
 	if (i == MAXUNIT) {
 		setoserror(EMFILE);
-		return (-1);
+		return -1;
 	}
 
 /*
@@ -208,10 +208,10 @@ static int _rmt_open(char *path, int oflag, int mode)
  */
 do_rmt:
 	if (pipe(_rmt_Ptc[i]) == -1 || pipe(_rmt_Ctp[i]) == -1)
-		return (-1);
+		return -1;
 
 	if ((rc = fork()) == -1)
-		return (-1);
+		return -1;
 
 	if (rc == 0) {
 		close(0);
@@ -253,7 +253,7 @@ do_rmt:
 
 	sprintf(buffer, "O%s\n%d\n", device, oflag);
 	if (_rmt_command(i, buffer) == -1 || _rmt_status(i) == -1)
-		return (-1);
+		return -1;
 
-	return (i);
+	return i;
 }
diff --git a/librmt/rmtread.c b/librmt/rmtread.c
index 1004992..6b34c1e 100644
--- a/librmt/rmtread.c
+++ b/librmt/rmtread.c
@@ -39,9 +39,9 @@ char *buf;
 unsigned int nbyte;
 {
 	if (isrmt(fildes)) {
-		return (_rmt_read(fildes - REM_BIAS, buf, nbyte));
+		return _rmt_read(fildes - REM_BIAS, buf, nbyte);
 	} else {
-		return (read(fildes, buf, nbyte));
+		return read(fildes, buf, nbyte);
 	}
 }
 
@@ -57,16 +57,16 @@ _rmt_read(int fildes, char *buf, unsigned int nbyte)
 
 	sprintf(buffer, "R%d\n", nbyte);
 	if (_rmt_command(fildes, buffer) == -1 || (rc = _rmt_status(fildes)) == -1)
-		return (-1);
+		return -1;
 
 	for (i = 0; i < rc; i += nbyte, buf += nbyte) {
 		nbyte = read(READ(fildes), buf, rc);
 		if (nbyte <= 0) {
 			_rmt_abort(fildes);
 			setoserror(EIO);
-			return (-1);
+			return -1;
 		}
 	}
 
-	return (rc);
+	return rc;
 }
diff --git a/librmt/rmtstatus.c b/librmt/rmtstatus.c
index 3691eef..064b646 100644
--- a/librmt/rmtstatus.c
+++ b/librmt/rmtstatus.c
@@ -47,7 +47,7 @@ int fildes;
 		if (read(READ(fildes), cp, 1) != 1) {
 			_rmt_abort(fildes);
 			setoserror(EIO);
-			return (-1);
+			return -1;
 		}
 		if (*cp == '\n') {
 			*cp = 0;
@@ -58,7 +58,7 @@ int fildes;
 	if (i == BUFMAGIC) {
 		_rmt_abort(fildes);
 		setoserror(EIO);
-		return (-1);
+		return -1;
 	}
 
 /*
@@ -78,7 +78,7 @@ int fildes;
 		if (*cp == 'F')
 			_rmt_abort(fildes);
 
-		return (-1);
+		return -1;
 	}
 
 /*
@@ -88,8 +88,8 @@ int fildes;
 	if (*cp != 'A') {
 		_rmt_abort(fildes);
 		setoserror(EIO);
-		return (-1);
+		return -1;
 	}
 
-	return (atoi(cp + 1));
+	return atoi(cp + 1);
 }
diff --git a/librmt/rmtwrite.c b/librmt/rmtwrite.c
index 830be20..86c3c54 100644
--- a/librmt/rmtwrite.c
+++ b/librmt/rmtwrite.c
@@ -39,9 +39,9 @@ char *buf;
 unsigned int nbyte;
 {
 	if (isrmt(fildes)) {
-		return (_rmt_write(fildes - REM_BIAS, buf, nbyte));
+		return _rmt_write(fildes - REM_BIAS, buf, nbyte);
 	} else {
-		return (write(fildes, buf, nbyte));
+		return write(fildes, buf, nbyte);
 	}
 }
 
@@ -56,13 +56,13 @@ _rmt_write(int fildes, char *buf, unsigned int nbyte)
 
 	sprintf(buffer, "W%d\n", nbyte);
 	if (_rmt_command(fildes, buffer) == -1)
-		return (-1);
+		return -1;
 
 	if (write(WRITE(fildes), buf, nbyte) == nbyte) {
-		return (_rmt_status(fildes));
+		return _rmt_status(fildes);
 	}
 
 	_rmt_abort(fildes);
 	setoserror(EIO);
-	return (-1);
+	return -1;
 }
-- 
2.19.1
