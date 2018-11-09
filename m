Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbeKJANK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:13:10 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8C4BE307D844
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:32:18 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 18/24] xfsdump: (2/4)(style) indent and align the code
Date: Fri,  9 Nov 2018 15:29:58 +0100
Message-Id: <20181109143004.24963-19-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Tab length is 8 spaces.

Created by Uncrustify with this config file:

#
# uncrustify config file, indentation
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

sp_return_paren		= ignore		# "return (1);" vs "return(1);"
sp_sizeof_paren		= ignore	# "sizeof (int)" vs "sizeof(int)"
sp_before_sparen	= ignore		# "if (" vs "if("
sp_after_sparen		= ignore		# "if () {" vs "if (){"
sp_after_cast		= ignore	# "(int) a" vs "(int)a"
sp_inside_braces	= ignore		# "{ 1 }" vs "{1}"
sp_inside_braces_struct	= ignore	# "{ 1 }" vs "{1}"
sp_inside_braces_enum	= ignore	# "{ 1 }" vs "{1}"
sp_assign		= ignore
sp_arith		= ignore
sp_bool			= ignore
sp_compare		= ignore
sp_assign		= ignore
sp_after_comma		= force
sp_func_def_paren	= ignore	# "int foo (){" vs "int foo(){"
sp_func_call_paren	= ignore	# "foo (" vs "foo("
sp_func_proto_paren	= ignore	# "int foo ();" vs "int foo();"

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
sp_inside_paren = ignore
sp_inside_square = ignore
sp_inside_paren_cast = ignore
sp_inside_fparen = ignore
sp_inside_sparen = ignore
sp_paren_paren = ignore
sp_before_ptr_star = ignore
sp_after_ptr_star = ignore
sp_between_ptr_star = ignore
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
 dump/content.c | 3402 ++++++++++++++++++++++++------------------------
 dump/getopt.h  |   78 +-
 dump/inomap.c  |  714 +++++-----
 dump/inomap.h  |   74 +-
 dump/var.c     |   42 +-
 5 files changed, 2155 insertions(+), 2155 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index 7890eb9..62a4f13 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -74,20 +74,20 @@
 /*
  * max "unsigned long long int"
  */
-#define ULONGLONG_MAX	18446744073709551615LLU
+#define ULONGLONG_MAX   18446744073709551615LLU
 
 /*
  * legal range of dump levels
  */
-#define LEVEL_DEFAULT	0
-#define LEVEL_MAX	9
+#define LEVEL_DEFAULT   0
+#define LEVEL_MAX       9
 
 /*
  * ordinary files as big or bigger than this many pages will be
  * preceeded in the dump by enough padding to align the first byte
  * of that file's data to a page boundary
  */
-#define PGALIGNTHRESH	8
+#define PGALIGNTHRESH   8
 
 
 /* structure definitions used locally ****************************************/
@@ -95,12 +95,12 @@
 /*
  * number of bstats bstat_iter fetches at a time
  */
-#define BSTATBUFLEN	4096
+#define BSTATBUFLEN     4096
 
 /*
  * if the source file system type can't be determined, assume it is this
  */
-#define FS_DEFAULT	"xfs"
+#define FS_DEFAULT      "xfs"
 
 /*
  * marks consist of a opaque drive layer cookie and a startpoint.
@@ -110,7 +110,7 @@
  */
 struct mark {
 	drive_markrec_t dm;
-	startpt_t startpt;
+	startpt_t	startpt;
 };
 
 typedef struct mark mark_t;
@@ -118,7 +118,7 @@ typedef struct mark mark_t;
 /*
  * Media_mfile_begin() entry state.
  */
-enum bes { BES_INIT,	/* in the beginning */
+enum bes { BES_INIT,    /* in the beginning */
 	   BES_ENDOK,   /* last media file successfully flushed to media */
 	   BES_ENDEOM,  /* hit EOM while writing last media file */
 	   BES_INVAL }; /* to assert protocol being followed */
@@ -129,90 +129,90 @@ typedef enum bes bes_t;
  * per-stream context
  */
 struct context {
-	filehdr_t *cc_filehdrp;
-			/*
-			 * pre-allocated buffer: heads each dumped file
-			 */
-	extenthdr_t *cc_extenthdrp;
-			/*
-			 * pre-allocated buffer: heads each dumped file extent
-			 */
-	void *cc_inomap_contextp;
-			/*
-			 * pre-allocated context to speed inomap iteration
-			 */
-	char *cc_getdentsbufp;
-	size_t cc_getdentsbufsz;
-			/*
-			 * pre-allocated buffer for getdents() syscall
-			 */
-	char *cc_mdirentbufp;
-	size_t cc_mdirentbufsz;
-			/*
-			 * pre-allocated buffer for on-media dirent
-			 */
-	char *cc_extattrlistbufp;
-	size_t cc_extattrlistbufsz;
-			/*
-			 * pre-allocated buffer for retrieving a
-			 * list of extended file attributes
-			 */
+	filehdr_t *	cc_filehdrp;
+	/*
+	 * pre-allocated buffer: heads each dumped file
+	 */
+	extenthdr_t *	cc_extenthdrp;
+	/*
+	 * pre-allocated buffer: heads each dumped file extent
+	 */
+	void *		cc_inomap_contextp;
+	/*
+	 * pre-allocated context to speed inomap iteration
+	 */
+	char *		cc_getdentsbufp;
+	size_t		cc_getdentsbufsz;
+	/*
+	 * pre-allocated buffer for getdents() syscall
+	 */
+	char *		cc_mdirentbufp;
+	size_t		cc_mdirentbufsz;
+	/*
+	 * pre-allocated buffer for on-media dirent
+	 */
+	char *		cc_extattrlistbufp;
+	size_t		cc_extattrlistbufsz;
+	/*
+	 * pre-allocated buffer for retrieving a
+	 * list of extended file attributes
+	 */
 	attr_multiop_t *cc_extattrrtrvarrayp;
-	size_t cc_extattrrtrvarraylen;
-			/*
-			 * pre-allocated array of ops for retrieving the
-			 * values for a list of extended file attributes
-			 */
-	char *cc_extattrdumpbufp;
-	size_t cc_extattrdumpbufsz;
-			/*
-			 * pre-allocated buffer for dumping the names and
-			 * values for a list of extended file attributes
-			 */
-	hsm_f_ctxt_t *cc_hsm_f_ctxtp;
-			/*
-			 * pre-allocated HSM context used for holding HSM
-			   state information about a file across subroutine
-			   calls.
-			*/
-	char *cc_readlinkbufp;
-	size_t cc_readlinkbufsz;
-			/*
-			 * pre-allocated buffer for readlink()
-			 */
-	off64_t cc_mfilesz;
-			/*
-			 * total bytes dumped to media file
-			 */
-	size_t cc_markscommitted;
-			/*
-			 * number of marks committed in mfile. only useful
-			 * info is if greater than zero.
-			 */
-	xfs_ino_t cc_stat_lastino;
-			/*
-			 * monotonic strm nondir ino dumped
-			 */
-	bool_t cc_completepr;
-			/*
-			 * set if stream completely dumped. useful for
-			 * determining if dump was interrupted
-			 */
-	bool_t cc_Media_useterminatorpr;
-			/*
-			 * true if stream terminators are expected and
-			 * will be used
-			 */
-	char *cc_Media_firstlabel;
-			/*
-			 * optional command line media label. only used
-			 * for first media object in stream, and only if
-			 * media object does not already have a label
-			 */
-	bes_t cc_Media_begin_entrystate;
-			/*
-			 * Media_mfile_begin context entry state
-			 */
+	size_t		cc_extattrrtrvarraylen;
+	/*
+	 * pre-allocated array of ops for retrieving the
+	 * values for a list of extended file attributes
+	 */
+	char *		cc_extattrdumpbufp;
+	size_t		cc_extattrdumpbufsz;
+	/*
+	 * pre-allocated buffer for dumping the names and
+	 * values for a list of extended file attributes
+	 */
+	hsm_f_ctxt_t *	cc_hsm_f_ctxtp;
+	/*
+	 * pre-allocated HSM context used for holding HSM
+	   state information about a file across subroutine
+	   calls.
+	 */
+	char *		cc_readlinkbufp;
+	size_t		cc_readlinkbufsz;
+	/*
+	 * pre-allocated buffer for readlink()
+	 */
+	off64_t		cc_mfilesz;
+	/*
+	 * total bytes dumped to media file
+	 */
+	size_t		cc_markscommitted;
+	/*
+	 * number of marks committed in mfile. only useful
+	 * info is if greater than zero.
+	 */
+	xfs_ino_t	cc_stat_lastino;
+	/*
+	 * monotonic strm nondir ino dumped
+	 */
+	bool_t		cc_completepr;
+	/*
+	 * set if stream completely dumped. useful for
+	 * determining if dump was interrupted
+	 */
+	bool_t		cc_Media_useterminatorpr;
+	/*
+	 * true if stream terminators are expected and
+	 * will be used
+	 */
+	char *		cc_Media_firstlabel;
+	/*
+	 * optional command line media label. only used
+	 * for first media object in stream, and only if
+	 * media object does not already have a label
+	 */
+	bes_t		cc_Media_begin_entrystate;
+	/*
+	 * Media_mfile_begin context entry state
+	 */
 };
 
 typedef struct context context_t;
@@ -220,15 +220,15 @@ typedef struct context context_t;
 /*
  * extent group context, used by dump_file()
  */
-#define BMAP_LEN	512
+#define BMAP_LEN        512
 
 struct extent_group_context {
-	getbmapx_t eg_bmap[BMAP_LEN];
-	getbmapx_t *eg_nextbmapp;	/* ptr to the next extent to dump */
-	getbmapx_t *eg_endbmapp;		/* to detect extent exhaustion */
-	int eg_fd;			/* file desc. */
-	int eg_bmapix;		/* debug info only, not used */
-	int eg_gbmcnt;		/* debug, counts getbmapx calls for ino*/
+	getbmapx_t	eg_bmap[BMAP_LEN];
+	getbmapx_t *	eg_nextbmapp;   /* ptr to the next extent to dump */
+	getbmapx_t *	eg_endbmapp;    /* to detect extent exhaustion */
+	int		eg_fd;          /* file desc. */
+	int		eg_bmapix;      /* debug info only, not used */
+	int		eg_gbmcnt;      /* debug, counts getbmapx calls for ino*/
 };
 
 typedef struct extent_group_context extent_group_context_t;
@@ -237,42 +237,42 @@ typedef struct extent_group_context extent_group_context_t;
 /*
  * minimum getdents() buffer size
  */
-#define GETDENTSBUF_SZ_MIN	(2 * pgsz)
+#define GETDENTSBUF_SZ_MIN      (2 * pgsz)
 
 
 /*
  * minimum sizes for extended attributes buffers
  */
-#define EXTATTR_LISTBUF_SZ	(XATTR_LIST_MAX)
-#define EXTATTR_RTRVARRAY_LEN	(1 * pgsz)
-#define EXTATTR_DUMPBUF_SZ	(4 * pgsz)
+#define EXTATTR_LISTBUF_SZ      (XATTR_LIST_MAX)
+#define EXTATTR_RTRVARRAY_LEN   (1 * pgsz)
+#define EXTATTR_DUMPBUF_SZ      (4 * pgsz)
 
 /*
  * for printing ext attr namespace
  */
-#define EXTATTR_NAMESPACE(flag)	(((flag) & ATTR_ROOT) ? _("root") : \
-				(((flag) & ATTR_SECURE) ? _("secure") : \
+#define EXTATTR_NAMESPACE(flag) (((flag) & ATTR_ROOT) ? _("root") : \
+				 (((flag) & ATTR_SECURE) ? _("secure") : \
 				  _("non-root")) )
 
 /*
  * for printing file type
  */
-#define FILETYPE(statp)		(((statp)->bs_mode & S_IFMT) == S_IFDIR \
-				  ? _("dir") : _("nondir"))
+#define FILETYPE(statp)         (((statp)->bs_mode & S_IFMT) == S_IFDIR \
+				 ? _("dir") : _("nondir"))
 
 /*
  * per-drive status descriptor
  */
 struct pds {
-	enum { PDS_NULL,		/* per-drive activity not begun */
-	       PDS_INOMAP,		/* dumping inomap */
-	       PDS_DIRDUMP,		/* dumping dirs */
-	       PDS_NONDIR,		/* dumping nondirs */
-	       PDS_INVSYNC,		/* waiting for inventory */
-	       PDS_INVDUMP,		/* dumping session inventory */
-	       PDS_TERMDUMP		/* writing stream terminator */
+	enum { PDS_NULL,                /* per-drive activity not begun */
+	       PDS_INOMAP,              /* dumping inomap */
+	       PDS_DIRDUMP,             /* dumping dirs */
+	       PDS_NONDIR,              /* dumping nondirs */
+	       PDS_INVSYNC,             /* waiting for inventory */
+	       PDS_INVDUMP,             /* dumping session inventory */
+	       PDS_TERMDUMP             /* writing stream terminator */
 	} pds_phase;
-	size64_t pds_dirdone;		/* number of directories done */
+	size64_t pds_dirdone;           /* number of directories done */
 };
 
 typedef struct pds pds_t;
@@ -294,141 +294,141 @@ extern size_t pgsz;
  * file dumpers
  */
 static rv_t
-dump_dirs(ix_t strmix,
-		       xfs_bstat_t *bstatbufp,
-		       size_t bstatbuflen,
-		       void *inomap_contextp);
+dump_dirs(ix_t		strmix,
+	  xfs_bstat_t * bstatbufp,
+	  size_t	bstatbuflen,
+	  void *	inomap_contextp);
 static rv_t
 dump_dir(ix_t strmix,
-		      jdm_fshandle_t *,
-		      int,
-		      xfs_bstat_t *);
+	 jdm_fshandle_t *,
+	 int,
+	 xfs_bstat_t *);
 static rv_t
 dump_file(void *,
-		       jdm_fshandle_t *,
-		       int,
-		       xfs_bstat_t *);
+	  jdm_fshandle_t *,
+	  int,
+	  xfs_bstat_t *);
 static rv_t
-dump_file_reg(drive_t *drivep,
-			   context_t *contextp,
-			   content_inode_hdr_t *scwhdrp,
-			   jdm_fshandle_t *,
-			   xfs_bstat_t *,
-			   bool_t *);
+dump_file_reg(drive_t *			drivep,
+	      context_t *		contextp,
+	      content_inode_hdr_t *	scwhdrp,
+	      jdm_fshandle_t *,
+	      xfs_bstat_t *,
+	      bool_t *);
 static rv_t
-dump_file_spec(drive_t *drivep,
-			    context_t *contextp,
-			    jdm_fshandle_t *,
-			    xfs_bstat_t *);
+dump_file_spec(drive_t *	drivep,
+	       context_t *	contextp,
+	       jdm_fshandle_t *,
+	       xfs_bstat_t *);
 static rv_t
-dump_filehdr(drive_t *drivep,
-			  context_t *contextp,
-			  xfs_bstat_t *,
-			  off64_t,
-			  int);
+dump_filehdr(drive_t *	drivep,
+	     context_t *contextp,
+	     xfs_bstat_t *,
+	     off64_t,
+	     int);
 static rv_t
-dump_extenthdr(drive_t *drivep,
-			    context_t *contextp,
-			    int32_t,
-			    int32_t,
-			    off64_t,
-			    off64_t);
+dump_extenthdr(drive_t *	drivep,
+	       context_t *	contextp,
+	       int32_t,
+	       int32_t,
+	       off64_t,
+	       off64_t);
 static rv_t
-dump_dirent(drive_t *drivep,
-			 context_t *contextp,
-			 xfs_bstat_t *,
-			 xfs_ino_t,
-			 gen_t,
-			 char *,
-			 size_t);
+dump_dirent(drive_t *	drivep,
+	    context_t * contextp,
+	    xfs_bstat_t *,
+	    xfs_ino_t,
+	    gen_t,
+	    char *,
+	    size_t);
 static rv_t
 init_extent_group_context(jdm_fshandle_t *,
-				       xfs_bstat_t *,
-				       extent_group_context_t *);
+			  xfs_bstat_t *,
+			  extent_group_context_t *);
 static void cleanup_extent_group_context(extent_group_context_t *);
 static rv_t
-dump_extent_group(drive_t *drivep,
-			       context_t *contextp,
-			       xfs_bstat_t *,
-			       extent_group_context_t *,
-			       off64_t,
-			       off64_t,
-			       bool_t,
-			       off64_t *,
-			       off64_t *,
-			       bool_t *);
+dump_extent_group(drive_t *	drivep,
+		  context_t *	contextp,
+		  xfs_bstat_t *,
+		  extent_group_context_t *,
+		  off64_t,
+		  off64_t,
+		  bool_t,
+		  off64_t *,
+		  off64_t *,
+		  bool_t *);
 static bool_t
-dump_session_inv(drive_t *drivep,
-			        context_t *contextp,
-			        media_hdr_t *mwhdrp,
-			        content_inode_hdr_t *scwhdrp);
+dump_session_inv(drive_t *		drivep,
+		 context_t *		contextp,
+		 media_hdr_t *		mwhdrp,
+		 content_inode_hdr_t *	scwhdrp);
 static rv_t write_pad(drive_t *drivep, size_t);
 
 static void mark_callback(void *, drive_markrec_t *, bool_t);
 
 static void inv_cleanup(void);
 static void
-dump_terminator(drive_t *drivep,
-			     context_t *contextp,
-			     media_hdr_t *mwhdrp);
+dump_terminator(drive_t *	drivep,
+		context_t *	contextp,
+		media_hdr_t *	mwhdrp);
 static rv_t
-Media_mfile_begin(drive_t *drivep,
-			       context_t *contextp,
-			       bool_t intr_allowed);
+Media_mfile_begin(drive_t *	drivep,
+		  context_t *	contextp,
+		  bool_t	intr_allowed);
 static rv_t
-Media_mfile_end(drive_t *drivep,
-			     context_t *contextp,
-			     media_hdr_t *mwhdrp,
-			     off64_t *ncommittedp,
-			     bool_t hit_eom);
+Media_mfile_end(drive_t *	drivep,
+		context_t *	contextp,
+		media_hdr_t *	mwhdrp,
+		off64_t *	ncommittedp,
+		bool_t		hit_eom);
 static bool_t Media_prompt_overwrite(drive_t *drivep);
 static rv_t
 Media_erasechk(drive_t *drivep,
-			    int dcaps,
-			    bool_t intr_allowed,
-			    bool_t prevmediapresentpr);
+	       int	dcaps,
+	       bool_t	intr_allowed,
+	       bool_t	prevmediapresentpr);
 static bool_t Media_prompt_erase(drive_t *drivep);
 static char *Media_prompt_label(drive_t *drivep, char *bufp, size_t bufsz);
 static void
-update_cc_Media_useterminatorpr(drive_t *drivep,
-					     context_t *contextp);
+update_cc_Media_useterminatorpr(drive_t *	drivep,
+				context_t *	contextp);
 static void set_mcflag(ix_t thrdix);
 static void clr_mcflag(ix_t thrdix);
 
 static bool_t check_complete_flags(void);
 
 static rv_t
-dump_extattrs(drive_t *drivep,
-			   context_t *contextp,
-	       		   jdm_fshandle_t *fshandlep,
-			   xfs_bstat_t *statp);
+dump_extattrs(drive_t *		drivep,
+	      context_t *	contextp,
+	      jdm_fshandle_t *	fshandlep,
+	      xfs_bstat_t *	statp);
 static rv_t
-dump_extattr_list(drive_t *drivep,
-			       context_t *contextp,
-	       		       jdm_fshandle_t *fshandlep,
-			       xfs_bstat_t *statp,
-			       attrlist_t *listp,
-			       int flag,
-			       bool_t *abortprp);
-static char *dump_extattr_buildrecord(xfs_bstat_t *statp,
-				       char *dumpbufp,
-				       char *dumpbufendp,
-				       char *namesrcp,
-				       uint32_t valuesz,
-				       int flag,
-				       char **valuepp);
+dump_extattr_list(drive_t *		drivep,
+		  context_t *		contextp,
+		  jdm_fshandle_t *	fshandlep,
+		  xfs_bstat_t *		statp,
+		  attrlist_t *		listp,
+		  int			flag,
+		  bool_t *		abortprp);
+static char *dump_extattr_buildrecord(xfs_bstat_t *	statp,
+				      char *		dumpbufp,
+				      char *		dumpbufendp,
+				      char *		namesrcp,
+				      uint32_t		valuesz,
+				      int		flag,
+				      char **		valuepp);
 static rv_t
-dump_extattrhdr(drive_t *drivep,
-			     context_t *contextp,
-			     xfs_bstat_t *statp,
-			     size_t recsz,
-			     size_t valoff,
-			     ix_t flags,
-			     uint32_t valsz);
+dump_extattrhdr(drive_t *	drivep,
+		context_t *	contextp,
+		xfs_bstat_t *	statp,
+		size_t		recsz,
+		size_t		valoff,
+		ix_t		flags,
+		uint32_t	valsz);
 
 static bool_t
-save_quotas(char *mntpnt,
-			   quota_info_t *quotainfo);
+save_quotas(char *		mntpnt,
+	    quota_info_t *	quotainfo);
 static int getxfsqstat(char *fsdev);
 
 
@@ -445,137 +445,137 @@ bool_t allowexcludefiles_pr = BOOL_FALSE;
 /* definition of locally defined static variables *****************************/
 
 static bool_t sc_preerasepr = BOOL_FALSE;
-	/*
-	 * pre-erase media
-	 */
+/*
+ * pre-erase media
+ */
 static inv_idbtoken_t sc_inv_idbtoken = INV_TOKEN_NULL;
-	/*
-	 * handle to inventory
-	 */
+/*
+ * handle to inventory
+ */
 static inv_sestoken_t sc_inv_sestoken = INV_TOKEN_NULL;
-	/*
-	 * handle to inventory session
-	 */
+/*
+ * handle to inventory session
+ */
 static inv_stmtoken_t *sc_inv_stmtokenp = 0;
-	/*
-	 * array of inventory session stream handles
-	 */
+/*
+ * array of inventory session stream handles
+ */
 static bool_t sc_inv_updatepr = BOOL_TRUE;
-	/*
-	 * set if ok to update online inventory with stats of this dump
-	 */
+/*
+ * set if ok to update online inventory with stats of this dump
+ */
 static ix_t sc_level = LEVEL_DEFAULT;
-	/*
-	 * dump level requested
-	 */
+/*
+ * dump level requested
+ */
 static bool_t sc_incrpr = BOOL_FALSE;
 static time32_t sc_incrbasetime;
 static ix_t sc_incrbaselevel;
 static uuid_t sc_incrbaseid;
-	/*
-	 * if an incremental dump, the base, level and time of the incremental
-	 * base dump. TRICKY: if resuming an incremental dump, this is the
-	 * base of the original incremental.
-	 */
+/*
+ * if an incremental dump, the base, level and time of the incremental
+ * base dump. TRICKY: if resuming an incremental dump, this is the
+ * base of the original incremental.
+ */
 static bool_t sc_resumepr = BOOL_FALSE;
 static time32_t sc_resumebasetime = 0;
 static uuid_t sc_resumebaseid;
 static size_t sc_resumerangecnt = 0;
 static drange_t *sc_resumerangep = 0;
-	/*
-	 * if a resumed dump, the id, time and undumped ino/offset ranges
-	 * of the interrupted dump being resumed.
-	 */
+/*
+ * if a resumed dump, the id, time and undumped ino/offset ranges
+ * of the interrupted dump being resumed.
+ */
 static jdm_fshandle_t *sc_fshandlep = 0;
-	/*
-	 * dmi file system handle
-	 */
+/*
+ * dmi file system handle
+ */
 static int sc_fsfd = -1;
-	/*
-	 * open file descriptor for root directory
-	 */
+/*
+ * open file descriptor for root directory
+ */
 static xfs_bstat_t *sc_rootxfsstatp = 0;
-	/*
-	 * pointer to loaded bulkstat for root directory
-	 */
+/*
+ * pointer to loaded bulkstat for root directory
+ */
 static startpt_t *sc_startptp = 0;
-	/*
-	 * an array of stream ino/offset start points
-	 */
+/*
+ * an array of stream ino/offset start points
+ */
 static time32_t sc_stat_starttime = 0;
-	/*
-	 * for cacluating elapsed time
-	 */
+/*
+ * for cacluating elapsed time
+ */
 static ix_t sc_stat_inomapphase = 0;
 static ix_t sc_stat_inomappass = 0;
 static size64_t sc_stat_inomapcnt;
 static size64_t sc_stat_inomapdone;
 static size64_t sc_stat_dircnt = 0;
-	/*
-	 * total number of directory inodes to be dumped (strm 0)
-	 */
+/*
+ * total number of directory inodes to be dumped (strm 0)
+ */
 static pds_t sc_stat_pds[STREAM_SIMMAX];
-	/*
-	 * per-drive stream status
-	 */
+/*
+ * per-drive stream status
+ */
 static size64_t sc_stat_nondircnt = 0;
-	/*
-	 * total number of non-directory inodes to be dumped (all strms)
-	 */
+/*
+ * total number of non-directory inodes to be dumped (all strms)
+ */
 static size64_t sc_stat_nondirdone = 0;
-	/*
-	 * total number of non-directory inodes dumped (all strms)
-	 */
+/*
+ * total number of non-directory inodes dumped (all strms)
+ */
 static size64_t sc_stat_datasz = 0;
-	/*
-	 * total size in bytes of non-dirs to be dumped (all strms)
-	 */
+/*
+ * total size in bytes of non-dirs to be dumped (all strms)
+ */
 static size64_t sc_stat_datadone = 0;
-	/*
-	 * total size in bytes of non-dirs dumped (all strms)
-	 */
+/*
+ * total size in bytes of non-dirs dumped (all strms)
+ */
 static size_t sc_thrdsarrivedcnt = 0;
-	/*
-	 * each thread checks in by bumping this count under lock.
-	 * used to decide when its ok to begin waiting for all threads
-	 * to arrive at sync pt for session inventory dump.
-	 */
+/*
+ * each thread checks in by bumping this count under lock.
+ * used to decide when its ok to begin waiting for all threads
+ * to arrive at sync pt for session inventory dump.
+ */
 static size_t sc_thrdsdonecnt = 0;
-	/*
-	 * number of threads which are ready to dump the session inventory.
-	 * when equal to the number of streams remaining (stream_cnt()),
-	 * can proceed with inventory dumps
-	 */
+/*
+ * number of threads which are ready to dump the session inventory.
+ * when equal to the number of streams remaining (stream_cnt()),
+ * can proceed with inventory dumps
+ */
 static context_t *sc_contextp;
-	/*
-	 * an array of per-stream context descriptors
-	 */
+/*
+ * an array of per-stream context descriptors
+ */
 static bool_t sc_mcflag[STREAM_SIMMAX];
-	/*
-	 * media change flag
-	 */
+/*
+ * media change flag
+ */
 static bool_t sc_dumpextattrpr = BOOL_TRUE;
-	/*
-	 * dump extended attributes
-	 */
+/*
+ * dump extended attributes
+ */
 static bool_t sc_dumpasoffline = BOOL_FALSE;
-	/*
-	 * dump dual-residency HSM files as offline
-	 */
+/*
+ * dump dual-residency HSM files as offline
+ */
 static bool_t sc_use_old_direntpr = BOOL_FALSE;
-	/*
-	 * dump dirents as dirent_v1_t instead of dirent_t
-	 * (for compat with dump format 2)
-	 */
+/*
+ * dump dirents as dirent_v1_t instead of dirent_t
+ * (for compat with dump format 2)
+ */
 
 static bool_t sc_savequotas = BOOL_TRUE;
 /*
  * save quota information in dump
  */
 static quota_info_t quotas[] = {
-	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT, 0 },
-	{ "project quota",	BOOL_TRUE,	CONTENT_PQUOTAFILE,	"", "-pf", XFS_QUOTA_PDQ_ACCT, 0 },
-	{ "group quota",	BOOL_TRUE,	CONTENT_GQUOTAFILE,	"", "-gf", XFS_QUOTA_GDQ_ACCT, 0 }
+	{ "user quota",	   BOOL_TRUE, CONTENT_QUOTAFILE,  "", "-uf", XFS_QUOTA_UDQ_ACCT, 0 },
+	{ "project quota", BOOL_TRUE, CONTENT_PQUOTAFILE, "", "-pf", XFS_QUOTA_PDQ_ACCT, 0 },
+	{ "group quota",   BOOL_TRUE, CONTENT_GQUOTAFILE, "", "-gf", XFS_QUOTA_GDQ_ACCT, 0 }
 };
 
 /* definition of locally defined global functions ****************************/
@@ -583,17 +583,17 @@ static quota_info_t quotas[] = {
 
 /* definition of locally defined static functions ****************************/
 static bool_t create_inv_session(
-		global_hdr_t *gwhdrtemplatep,
-		uuid_t *fsidp,
-		const char *mntpnt,
-		const char *fsdevice,
-		ix_t subtreecnt,
-		size_t strmix);
+	global_hdr_t *	gwhdrtemplatep,
+	uuid_t *	fsidp,
+	const char *	mntpnt,
+	const char *	fsdevice,
+	ix_t		subtreecnt,
+	size_t		strmix);
 
 bool_t
-content_init(int argc,
-	      char *argv[],
-	      global_hdr_t *gwhdrtemplatep)
+content_init(int		argc,
+	     char *		argv[],
+	     global_hdr_t *	gwhdrtemplatep)
 {
 
 	inv_idbtoken_t inv_idbt;
@@ -655,8 +655,8 @@ content_init(int argc,
 	assert(sizeof(direnthdr_v1_t) == DIRENTHDR_SZ);
 	assert(DIRENTHDR_SZ % DIRENTHDR_ALIGN == 0);
 	assert(sizeofmember(content_hdr_t, ch_specific)
-		>=
-		sizeof(content_inode_hdr_t));
+	       >=
+	       sizeof(content_inode_hdr_t));
 	assert(sizeof(extattrhdr_t) == EXTATTRHDR_SZ);
 
 	/*
@@ -683,18 +683,18 @@ content_init(int argc,
 		case GETOPT_LEVEL:
 			if (! optarg || optarg[0] == '-') {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument missing\n"),
-				      c);
+					     "-%c argument missing\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
 			sc_level = (ix_t)atoi(optarg);
 			if (sc_level > LEVEL_MAX) {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument must be "
-				      "between 0 and %d\n"),
-				      c,
-				      LEVEL_MAX);
+					     "-%c argument must be "
+					     "between 0 and %d\n"),
+				     c,
+				     LEVEL_MAX);
 				usage();
 				return BOOL_FALSE;
 			}
@@ -702,16 +702,16 @@ content_init(int argc,
 		case GETOPT_SUBTREE:
 			if (! optarg || optarg[0] == '-') {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument missing\n"),
-				      c);
+					     "-%c argument missing\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
 			if (optarg[0] == '/') {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument (subtree) "
-				      "must be a relative pathname\n"),
-				      c);
+					     "-%c argument (subtree) "
+					     "must be a relative pathname\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
@@ -720,18 +720,18 @@ content_init(int argc,
 		case GETOPT_MAXDUMPFILESIZE:
 			if (! optarg || optarg [0] == '-') {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument missing\n"),
-				      c);
+					     "-%c argument missing\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
 			maxdumpfilesize = strtoull(optarg, NULL, 0);
 			if (maxdumpfilesize == 0 ||
-			     maxdumpfilesize > ULONGLONG_MAX / 1024 ||
-			     (maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE) ) {
+			    maxdumpfilesize > ULONGLONG_MAX / 1024 ||
+			    (maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE) ) {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument is not a valid file size\n"),
-				      c);
+					     "-%c argument is not a valid file size\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
@@ -755,8 +755,8 @@ content_init(int argc,
 		case GETOPT_ALERTPROG:
 			if (! optarg || optarg[0] == '-') {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-					"-%c argument missing\n"),
-				    c);
+					     "-%c argument missing\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
@@ -771,8 +771,8 @@ content_init(int argc,
 		case GETOPT_BASED:
 			if (! optarg || optarg[0] == '-') {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument missing\n"),
-				      c);
+					     "-%c argument missing\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
@@ -780,9 +780,9 @@ content_init(int argc,
 
 			if (uuid_parse(baseuuidstr, baseuuid) < 0) {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "-%c argument not a valid "
-				      "dump session id\n"),
-				      c);
+					     "-%c argument not a valid "
+					     "dump session id\n"),
+				     c);
 				usage();
 				return BOOL_FALSE;
 			}
@@ -792,9 +792,9 @@ content_init(int argc,
 
 	if (resumereqpr && baseuuidvalpr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
-		      "may not specify both -%c and -%c\n"),
-		      GETOPT_BASED,
-		      GETOPT_RESUME);
+			     "may not specify both -%c and -%c\n"),
+		     GETOPT_BASED,
+		     GETOPT_RESUME);
 		return BOOL_FALSE;
 	}
 
@@ -813,8 +813,8 @@ content_init(int argc,
 	 */
 	if (optind >= argc) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
-		      "source file system "
-		      "not specified\n"));
+			     "source file system "
+			     "not specified\n"));
 		usage();
 		return BOOL_FALSE;
 	}
@@ -856,18 +856,18 @@ content_init(int argc,
 	 * argument doesn't look like a file system.
 	 */
 	if (! fs_info(fstype,
-			sizeof(fstype),
-			FS_DEFAULT,
-			fsdevice,
-			sizeof(fsdevice),
-			mntpnt,
-			sizeof(mntpnt),
-			&fsid,
-			srcname)) {
+		     sizeof(fstype),
+		     FS_DEFAULT,
+		     fsdevice,
+		     sizeof(fsdevice),
+		     mntpnt,
+		     sizeof(mntpnt),
+		     &fsid,
+		     srcname)) {
 
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
-		      "%s does not identify a file system\n"),
-		      srcname);
+			     "%s does not identify a file system\n"),
+		     srcname);
 		usage();
 		return BOOL_FALSE;
 	}
@@ -879,8 +879,8 @@ content_init(int argc,
 	 */
 	if (! fs_mounted(fstype, fsdevice, mntpnt, &fsid)) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
-		      "%s must be mounted to be dumped\n"),
-		      srcname);
+			     "%s must be mounted to be dumped\n"),
+		     srcname);
 		return BOOL_FALSE;
 	}
 
@@ -888,14 +888,14 @@ content_init(int argc,
 	 * place the fs info in the write hdr template
 	 */
 	(void)strncpyterm(cwhdrtemplatep->ch_mntpnt,
-			     mntpnt,
-			     sizeof(cwhdrtemplatep->ch_mntpnt));
+			  mntpnt,
+			  sizeof(cwhdrtemplatep->ch_mntpnt));
 	(void)strncpyterm(cwhdrtemplatep->ch_fsdevice,
-			     fsdevice,
-			     sizeof(cwhdrtemplatep->ch_fsdevice));
+			  fsdevice,
+			  sizeof(cwhdrtemplatep->ch_fsdevice));
 	(void)strncpyterm(cwhdrtemplatep->ch_fstype,
-			     fstype,
-			     sizeof(cwhdrtemplatep->ch_fstype));
+			  fstype,
+			  sizeof(cwhdrtemplatep->ch_fstype));
 	uuid_copy(cwhdrtemplatep->ch_fsid, fsid);
 
 	/* write quota information */
@@ -911,7 +911,7 @@ content_init(int argc,
 					if (subtreecnt) {
 						subtreecnt++;
 						subtreep = (char **) realloc(subtreep,
-								subtreecnt * sizeof(char *));
+									     subtreecnt * sizeof(char *));
 						assert(subtreep);
 						subtreep[subtreecnt - 1] = quotas[i].quotafile;
 					}
@@ -919,8 +919,8 @@ content_init(int argc,
 					quotas[i].savequotas = BOOL_TRUE;
 				} else {
 					mlog(MLOG_NORMAL | MLOG_ERROR, _(
-					      "failed to save %s information, continuing\n"),
-					      quotas[i].desc);
+						     "failed to save %s information, continuing\n"),
+					     quotas[i].desc);
 				}
 			}
 		}
@@ -950,8 +950,8 @@ content_init(int argc,
 	 * to calculate incremental and resumed dumps.
 	 */
 	inv_idbt = inv_open((inv_predicate_t)INV_BY_UUID,
-			     INV_SEARCH_ONLY,
-			     (void *)&fsid);
+			    INV_SEARCH_ONLY,
+			    (void *)&fsid);
 
 	/*
 	 * if a based request, look for the indicated session.
@@ -974,9 +974,9 @@ content_init(int argc,
 		ok = inv_get_session_byuuid(&fsid, &baseuuid, &sessp);
 		if (! ok) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
-			      "could not find specified base dump (%s) "
-			      "in inventory\n"),
-			      baseuuidstr);
+				     "could not find specified base dump (%s) "
+				     "in inventory\n"),
+			     baseuuidstr);
 			return BOOL_FALSE;
 		}
 		strcnt =  (ix_t)sessp->s_nstreams;
@@ -998,7 +998,7 @@ content_init(int argc,
 			sameinterruptedpr = BOOL_TRUE;
 			sc_resumerangecnt =  (size_t)sessp->s_nstreams;
 			sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
-								sizeof(drange_t));
+							     sizeof(drange_t));
 			assert(sc_resumerangep);
 			for (strmix = 0; strmix < sc_resumerangecnt; strmix++) {
 				inv_stream_t *bsp;
@@ -1017,25 +1017,25 @@ content_init(int argc,
 					if (esp) {
 						p->dr_end.sp_ino = esp->st_startino;
 						p->dr_end.sp_offset =
-								esp->st_startino_off;
+							esp->st_startino_off;
 						mlog(MLOG_DEBUG,
-						      "resume range stream %u "
-						      "ino %llu:%lld to "
-						      "%llu:%lld\n",
-						      strmix,
-						      p->dr_begin.sp_ino,
-						      p->dr_begin.sp_offset,
-						      p->dr_end.sp_ino,
-						      p->dr_end.sp_offset);
+						     "resume range stream %u "
+						     "ino %llu:%lld to "
+						     "%llu:%lld\n",
+						     strmix,
+						     p->dr_begin.sp_ino,
+						     p->dr_begin.sp_offset,
+						     p->dr_end.sp_ino,
+						     p->dr_end.sp_offset);
 					} else {
 						p->dr_end.sp_flags = STARTPT_FLAGS_END;
 						mlog(MLOG_DEBUG,
-						      "resume range stream %u "
-						      "ino %llu:%lld to "
-						      "end\n",
-						      strmix,
-						      p->dr_begin.sp_ino,
-						      p->dr_begin.sp_offset);
+						     "resume range stream %u "
+						     "ino %llu:%lld to "
+						     "end\n",
+						     strmix,
+						     p->dr_begin.sp_ino,
+						     p->dr_begin.sp_offset);
 					}
 				} else {
 					/*
@@ -1048,11 +1048,11 @@ content_init(int argc,
 		} else {
 			if (sessp->s_level >= LEVEL_MAX) {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "cannot select dump session %d as base "
-				      "for incremental dump: "
-				      "level must be less than %d\n"),
-				      sessp->s_level,
-				      LEVEL_MAX);
+					     "cannot select dump session %d as base "
+					     "for incremental dump: "
+					     "level must be less than %d\n"),
+				     sessp->s_level,
+				     LEVEL_MAX);
 				return BOOL_FALSE;
 			}
 			sc_level = (ix_t)sessp->s_level + 1;
@@ -1080,8 +1080,8 @@ content_init(int argc,
 	if (sc_level > 0) {
 		if (inv_idbt == INV_TOKEN_NULL) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
-			      "cannot calculate incremental dump: "
-			      "online inventory not available\n"));
+				     "cannot calculate incremental dump: "
+				     "online inventory not available\n"));
 			return BOOL_FALSE;
 		}
 		ok = inv_lastsession_level_lessthan(&fsid,
@@ -1111,7 +1111,7 @@ content_init(int argc,
 				}
 			}
 			underfoundpr = BOOL_TRUE;
-			inv_free_session(& sessp);
+			inv_free_session(&sessp);
 			sessp = 0;
 		}
 	}
@@ -1147,7 +1147,7 @@ content_init(int argc,
 		sameinterruptedpr = BOOL_FALSE;
 		sc_resumerangecnt =  (size_t)sessp->s_nstreams;
 		sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
-						        sizeof(drange_t));
+						     sizeof(drange_t));
 		assert(sc_resumerangep);
 		for (strmix = 0; strmix < sc_resumerangecnt; strmix++) {
 			inv_stream_t *bsp;
@@ -1166,25 +1166,25 @@ content_init(int argc,
 				if (esp) {
 					p->dr_end.sp_ino = esp->st_startino;
 					p->dr_end.sp_offset =
-							esp->st_startino_off;
+						esp->st_startino_off;
 					mlog(MLOG_DEBUG,
-					      "resume range stream %u "
-					      "ino %llu:%lld to "
-					      "%llu:%lld\n",
-					      strmix,
-					      p->dr_begin.sp_ino,
-					      p->dr_begin.sp_offset,
-					      p->dr_end.sp_ino,
-					      p->dr_end.sp_offset);
+					     "resume range stream %u "
+					     "ino %llu:%lld to "
+					     "%llu:%lld\n",
+					     strmix,
+					     p->dr_begin.sp_ino,
+					     p->dr_begin.sp_offset,
+					     p->dr_end.sp_ino,
+					     p->dr_end.sp_offset);
 				} else {
 					p->dr_end.sp_flags = STARTPT_FLAGS_END;
 					mlog(MLOG_DEBUG,
-					      "resume range stream %u "
-					      "ino %llu:%lld to "
-					      "end\n",
-					      strmix,
-					      p->dr_begin.sp_ino,
-					      p->dr_begin.sp_offset);
+					     "resume range stream %u "
+					     "ino %llu:%lld to "
+					     "end\n",
+					     strmix,
+					     p->dr_begin.sp_ino,
+					     p->dr_begin.sp_offset);
 				}
 			} else {
 				/*
@@ -1194,7 +1194,7 @@ content_init(int argc,
 				p->dr_begin.sp_flags = STARTPT_FLAGS_END;
 			}
 		}
-		inv_free_session(& sessp);
+		inv_free_session(&sessp);
 		sessp = 0;
 		samefoundpr = BOOL_TRUE;
 	}
@@ -1212,11 +1212,11 @@ baseuuidbypass:
 	if (samefoundpr && ! resumereqpr) {
 		if (! underfoundpr || undertime <= sametime) {
 			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
-			      "most recent level %d dump "
-			      "was interrupted, "
-			      "but not resuming that dump since "
-			      "resume (-R) option not specified\n"),
-			      sc_level);
+				     "most recent level %d dump "
+				     "was interrupted, "
+				     "but not resuming that dump since "
+				     "resume (-R) option not specified\n"),
+			     sc_level);
 		}
 		free((void *)sc_resumerangep);
 		sc_resumerangep = 0;
@@ -1229,32 +1229,32 @@ baseuuidbypass:
 			if (undertime >= sametime) {
 				if (underinterruptedpr) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-					      "most recent base for "
-					      "incremental dump was "
-					      "interrupted (level %u): "
-					      "must resume or redump "
-					      "at or below level %d\n"),
-					      underlevel,
-					      sc_level);
+						     "most recent base for "
+						     "incremental dump was "
+						     "interrupted (level %u): "
+						     "must resume or redump "
+						     "at or below level %d\n"),
+					     underlevel,
+					     sc_level);
 					return BOOL_FALSE;
 				}
 				if (subtreecnt && ! underpartialpr) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-					      "level %u incremental "
-					      "subtree dump "
-					      "will be based on non-subtree "
-					      "level %u dump\n"),
-					      sc_level,
-					      underlevel);
+						     "level %u incremental "
+						     "subtree dump "
+						     "will be based on non-subtree "
+						     "level %u dump\n"),
+					     sc_level,
+					     underlevel);
 				}
 				if (! subtreecnt && underpartialpr) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-					      "level %u incremental "
-					      "non-subtree dump "
-					      "will be based on subtree "
-					      "level %u dump\n"),
-					      sc_level,
-					      underlevel);
+						     "level %u incremental "
+						     "non-subtree dump "
+						     "will be based on subtree "
+						     "level %u dump\n"),
+					     sc_level,
+					     underlevel);
 				}
 				sc_incrpr = BOOL_TRUE;
 				sc_incrbasetime = undertime;
@@ -1267,21 +1267,21 @@ baseuuidbypass:
 			} else {
 				if (subtreecnt && ! samepartialpr) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-					      "level %u incremental "
-					      "subtree dump "
-					      "will be based on non-subtree "
-					      "level %u resumed dump\n"),
-					      sc_level,
-					      sc_level);
+						     "level %u incremental "
+						     "subtree dump "
+						     "will be based on non-subtree "
+						     "level %u resumed dump\n"),
+					     sc_level,
+					     sc_level);
 				}
 				if (! subtreecnt && samepartialpr) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-					      "level %u incremental "
-					      "non-subtree dump "
-					      "will be based on subtree "
-					      "level %u resumed dump\n"),
-					      sc_level,
-					      sc_level);
+						     "level %u incremental "
+						     "non-subtree dump "
+						     "will be based on subtree "
+						     "level %u resumed dump\n"),
+					     sc_level,
+					     sc_level);
 				}
 				assert(sametime);
 				sc_incrpr = BOOL_TRUE;
@@ -1295,32 +1295,32 @@ baseuuidbypass:
 		} else {
 			if (underinterruptedpr) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "most recent base for "
-				      "incremental dump was "
-				      "interrupted (level %u): "
-				      "must resume or redump "
-				      "at or below level %d\n"),
-				      underlevel,
-				      sc_level);
+					     "most recent base for "
+					     "incremental dump was "
+					     "interrupted (level %u): "
+					     "must resume or redump "
+					     "at or below level %d\n"),
+				     underlevel,
+				     sc_level);
 				return BOOL_FALSE;
 			}
 			if (subtreecnt && ! underpartialpr) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "level %u incremental "
-				      "subtree dump "
-				      "will be based on non-subtree "
-				      "level %u dump\n"),
-				      sc_level,
-				      underlevel);
+					     "level %u incremental "
+					     "subtree dump "
+					     "will be based on non-subtree "
+					     "level %u dump\n"),
+				     sc_level,
+				     underlevel);
 			}
 			if (! subtreecnt && underpartialpr) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "level %u incremental "
-				      "non-subtree dump "
-				      "will be based on subtree "
-				      "level %u dump\n"),
-				      sc_level,
-				      underlevel);
+					     "level %u incremental "
+					     "non-subtree dump "
+					     "will be based on subtree "
+					     "level %u dump\n"),
+				     sc_level,
+				     underlevel);
 			}
 			sc_incrpr = BOOL_TRUE;
 			sc_incrbasetime = undertime;
@@ -1334,21 +1334,21 @@ baseuuidbypass:
 			assert(sametime);
 			if (subtreecnt && ! samepartialpr) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "level %u "
-				      "subtree dump "
-				      "will be based on non-subtree "
-				      "level %u resumed dump\n"),
-				      sc_level,
-				      sc_level);
+					     "level %u "
+					     "subtree dump "
+					     "will be based on non-subtree "
+					     "level %u resumed dump\n"),
+				     sc_level,
+				     sc_level);
 			}
 			if (! subtreecnt && samepartialpr) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "level %u "
-				      "non-subtree dump "
-				      "will be based on subtree "
-				      "level %u resumed dump\n"),
-				      sc_level,
-				      sc_level);
+					     "level %u "
+					     "non-subtree dump "
+					     "will be based on subtree "
+					     "level %u resumed dump\n"),
+				     sc_level,
+				     sc_level);
 			}
 			sc_incrpr = BOOL_FALSE;
 			sc_resumepr = BOOL_TRUE;
@@ -1361,9 +1361,9 @@ baseuuidbypass:
 			assert(! sc_resumerangep);
 			if (sc_level > 0) {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
-				      "cannot find earlier dump "
-				      "to base level %d increment upon\n"),
-				      sc_level);
+					     "cannot find earlier dump "
+					     "to base level %d increment upon\n"),
+				     sc_level);
 				return BOOL_FALSE;
 			}
 		}
@@ -1374,10 +1374,10 @@ baseuuidbypass:
 	 */
 	if (sc_incrpr && underinterruptedpr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
-		      "most recent base dump (level %d begun %s) "
-		      "was interrupted: aborting\n"),
-		      sc_incrbaselevel,
-		      ctimennl(&sc_incrbasetime));
+			     "most recent base dump (level %d begun %s) "
+			     "was interrupted: aborting\n"),
+		     sc_incrbaselevel,
+		     ctimennl(&sc_incrbasetime));
 		return BOOL_FALSE;
 	}
 
@@ -1386,9 +1386,9 @@ baseuuidbypass:
 	 */
 	if (! sc_resumepr && resumereqpr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
-		      "resume (-R) option inappropriate: "
-		      "no interrupted level %d dump to resume\n"),
-		      sc_level);
+			     "resume (-R) option inappropriate: "
+			     "no interrupted level %d dump to resume\n"),
+		     sc_level);
 		return BOOL_FALSE;
 	}
 
@@ -1406,39 +1406,39 @@ baseuuidbypass:
 			assert(strlen(incrtimestr) < sizeof(incrtimestr));
 
 			mlog(MLOG_VERBOSE, _(
-			      "resuming level %d incremental dump of %s:%s "
-			      "begun %s "
-			      "(incremental base level %d begun %s)\n"),
-			      sc_level,
-			      gwhdrtemplatep->gh_hostname,
-			      mntpnt,
-			      restimestr,
-			      sc_incrbaselevel,
-			      incrtimestr);
+				     "resuming level %d incremental dump of %s:%s "
+				     "begun %s "
+				     "(incremental base level %d begun %s)\n"),
+			     sc_level,
+			     gwhdrtemplatep->gh_hostname,
+			     mntpnt,
+			     restimestr,
+			     sc_incrbaselevel,
+			     incrtimestr);
 		} else {
 			mlog(MLOG_VERBOSE, _(
-			      "level %d incremental dump of %s:%s "
-			      "based on level %d dump begun %s\n"),
-			      sc_level,
-			      gwhdrtemplatep->gh_hostname,
-			      mntpnt,
-			      sc_incrbaselevel,
-			      ctimennl(&sc_incrbasetime));
+				     "level %d incremental dump of %s:%s "
+				     "based on level %d dump begun %s\n"),
+			     sc_level,
+			     gwhdrtemplatep->gh_hostname,
+			     mntpnt,
+			     sc_incrbaselevel,
+			     ctimennl(&sc_incrbasetime));
 		}
 	} else {
 		if (sc_resumepr) {
 			mlog(MLOG_VERBOSE, _(
-			      "resuming level %d dump of %s:%s begun %s\n"),
-			      sc_level,
-			      gwhdrtemplatep->gh_hostname,
-			      mntpnt,
-			      ctimennl(&sc_resumebasetime));
+				     "resuming level %d dump of %s:%s begun %s\n"),
+			     sc_level,
+			     gwhdrtemplatep->gh_hostname,
+			     mntpnt,
+			     ctimennl(&sc_resumebasetime));
 		} else {
 			mlog(MLOG_VERBOSE, _(
-			      "level %d dump of %s:%s\n"),
-			      sc_level,
-			      gwhdrtemplatep->gh_hostname,
-			      mntpnt);
+				     "level %d dump of %s:%s\n"),
+			     sc_level,
+			     gwhdrtemplatep->gh_hostname,
+			     mntpnt);
 		}
 	}
 
@@ -1450,8 +1450,8 @@ baseuuidbypass:
 	 * announce the dump time
 	 */
 	mlog(MLOG_VERBOSE, _(
-	      "dump date: %s\n"),
-	      ctimennl(&gwhdrtemplatep->gh_timestamp));
+		     "dump date: %s\n"),
+	     ctimennl(&gwhdrtemplatep->gh_timestamp));
 
 	/*
 	 * display the session UUID
@@ -1460,16 +1460,16 @@ baseuuidbypass:
 		char string_uuid[UUID_STR_LEN + 1];
 		uuid_unparse(gwhdrtemplatep->gh_dumpid, string_uuid);
 		mlog(MLOG_VERBOSE, _(
-		      "session id: %s\n"),
-		      string_uuid);
+			     "session id: %s\n"),
+		     string_uuid);
 	}
 
 	/*
 	 * display the session label
 	 */
 	mlog(MLOG_VERBOSE, _(
-	      "session label: \"%s\"\n"),
-	      gwhdrtemplatep->gh_dumplabel);
+		     "session label: \"%s\"\n"),
+	     gwhdrtemplatep->gh_dumplabel);
 
 	/*
 	 * get a file descriptor for the file system. any file
@@ -1479,9 +1479,9 @@ baseuuidbypass:
 	sc_fsfd = open(mntpnt, O_RDONLY);
 	if (sc_fsfd < 0) {
 		mlog(MLOG_NORMAL, _(
-		      "unable to open %s: %s\n"),
-		      mntpnt,
-		      strerror(errno));
+			     "unable to open %s: %s\n"),
+		     mntpnt,
+		     strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -1501,8 +1501,8 @@ baseuuidbypass:
 		rval = fstat64(sc_fsfd, &rootstat);
 		if (rval) {
 			mlog(MLOG_NORMAL, _(
-			      "could not stat %s\n"),
-			      mntpnt);
+				     "could not stat %s\n"),
+			     mntpnt);
 			return BOOL_FALSE;
 		}
 		sc_rootxfsstatp =
@@ -1516,14 +1516,14 @@ baseuuidbypass:
 		bulkreq.ocount = &ocount;
 		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
 			mlog(MLOG_ERROR,
-			      _("failed to get bulkstat information for root inode\n"));
+			     _("failed to get bulkstat information for root inode\n"));
 			return BOOL_FALSE;
 		}
 
 		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
 			mlog (MLOG_NORMAL | MLOG_NOTE,
-			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
-			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
+			      _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
+			      sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
 
 	/*
@@ -1533,9 +1533,9 @@ baseuuidbypass:
 	sc_fshandlep = jdm_getfshandle(mntpnt);
 	if (! sc_fshandlep) {
 		mlog(MLOG_NORMAL, _(
-		      "unable to construct a file system handle for %s: %s\n"),
-		      mntpnt,
-		      strerror(errno));
+			     "unable to construct a file system handle for %s: %s\n"),
+		     mntpnt,
+		     strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -1568,23 +1568,23 @@ baseuuidbypass:
 	sc_startptp = (startpt_t *)calloc(drivecnt, sizeof(startpt_t));
 	assert(sc_startptp);
 	ok = inomap_build(sc_fshandlep,
-			   sc_fsfd,
-			   sc_rootxfsstatp,
-			   sc_incrpr,
-			   sc_incrbasetime,
-			   sc_resumepr,
-			   sc_resumebasetime,
-			   sc_resumerangecnt,
-			   sc_resumerangep,
-			   subtreep,
-			   subtreecnt,
-			   skip_unchanged_dirs,
-			   sc_startptp,
-			   drivecnt,
-			   &sc_stat_inomapphase,
-			   &sc_stat_inomappass,
-			   sc_stat_inomapcnt,
-			   &sc_stat_inomapdone);
+			  sc_fsfd,
+			  sc_rootxfsstatp,
+			  sc_incrpr,
+			  sc_incrbasetime,
+			  sc_resumepr,
+			  sc_resumebasetime,
+			  sc_resumerangecnt,
+			  sc_resumerangep,
+			  subtreep,
+			  subtreecnt,
+			  skip_unchanged_dirs,
+			  sc_startptp,
+			  drivecnt,
+			  &sc_stat_inomapphase,
+			  &sc_stat_inomappass,
+			  sc_stat_inomapcnt,
+			  &sc_stat_inomapdone);
 	free((void *)subtreep);
 	subtreep = 0;
 	if (! ok) {
@@ -1633,7 +1633,7 @@ baseuuidbypass:
 	if (sc_dumpextattrpr) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_EXTATTR;
 		scwhdrtemplatep->cih_dumpattr |=
-					CIH_DUMPATTR_EXTATTRHDR_CHECKSUM;
+			CIH_DUMPATTR_EXTATTRHDR_CHECKSUM;
 	}
 
 	scwhdrtemplatep->cih_rootino = sc_rootxfsstatp->bs_ino;
@@ -1650,34 +1650,34 @@ baseuuidbypass:
 	direntsz = inocnt * (uint64_t)(DIRENTHDR_SZ + 8);
 	filesz = inocnt * (uint64_t)(FILEHDR_SZ + EXTENTHDR_SZ);
 
-	hdr_mfilesz =	GLOBAL_HDR_SZ
-			+
-			inomapsz
-			+
-			direntsz;
+	hdr_mfilesz =   GLOBAL_HDR_SZ
+		      +
+		      inomapsz
+		      +
+		      direntsz;
 	size_estimate = hdr_mfilesz
 			+
 			filesz
 			+
 			datasz;
 	mlog(MLOG_VERBOSE, _(
-	      "estimated dump size: %llu bytes\n"),
-	      size_estimate);
+		     "estimated dump size: %llu bytes\n"),
+	     size_estimate);
 
 	if (drivecnt > 1) {
-	    mlog(MLOG_VERBOSE, _(
-		  "estimated dump size per stream: %llu bytes\n"),
-		    hdr_mfilesz + (filesz + datasz) / drivecnt);
+		mlog(MLOG_VERBOSE, _(
+			     "estimated dump size per stream: %llu bytes\n"),
+		     hdr_mfilesz + (filesz + datasz) / drivecnt);
 	}
 	mlog(MLOG_DEBUG,
-	      "estimated dump header size: %llu bytes\n",
-	      hdr_mfilesz);
+	     "estimated dump header size: %llu bytes\n",
+	     hdr_mfilesz);
 	mlog(MLOG_DEBUG,
-	      "estimated component sizes: global hdr: %llu bytes, "
-	      "inomap: %llu bytes,  dir entries: %llu bytes, "
-	      "file hdrs: %llu bytes, datasz: %llu bytes\n",
-	      GLOBAL_HDR_SZ, inomapsz, direntsz,
-	      filesz, datasz);
+	     "estimated component sizes: global hdr: %llu bytes, "
+	     "inomap: %llu bytes,  dir entries: %llu bytes, "
+	     "file hdrs: %llu bytes, datasz: %llu bytes\n",
+	     GLOBAL_HDR_SZ, inomapsz, direntsz,
+	     filesz, datasz);
 
 	/*
 	 * extract the progress stat denominators from the write hdr
@@ -1696,21 +1696,21 @@ baseuuidbypass:
 		context_t *contextp = &sc_contextp[strmix];
 
 		contextp->cc_filehdrp =
-				(filehdr_t *)calloc(1, sizeof(filehdr_t));
+			(filehdr_t *)calloc(1, sizeof(filehdr_t));
 		assert(contextp->cc_filehdrp);
 
 		contextp->cc_extenthdrp =
-			    (extenthdr_t *)calloc(1, sizeof(extenthdr_t));
+			(extenthdr_t *)calloc(1, sizeof(extenthdr_t));
 		assert(contextp->cc_extenthdrp);
 
 		contextp->cc_getdentsbufsz = sizeof(struct dirent)
-					       +
-					       NAME_MAX + 1;
+					     +
+					     NAME_MAX + 1;
 		if (contextp->cc_getdentsbufsz < GETDENTSBUF_SZ_MIN) {
 			contextp->cc_getdentsbufsz = GETDENTSBUF_SZ_MIN;
 		}
 		contextp->cc_getdentsbufp =
-			   (char *) calloc(1, contextp->cc_getdentsbufsz);
+			(char *) calloc(1, contextp->cc_getdentsbufsz);
 		assert(contextp->cc_getdentsbufp);
 
 		contextp->cc_mdirentbufsz = sizeof(direnthdr_t)
@@ -1719,7 +1719,7 @@ baseuuidbypass:
 					    +
 					    DIRENTHDR_ALIGN;
 		contextp->cc_mdirentbufp =
-			   (char *) calloc(1, contextp->cc_mdirentbufsz);
+			(char *) calloc(1, contextp->cc_mdirentbufsz);
 		assert(contextp->cc_mdirentbufp);
 
 		contextp->cc_extattrlistbufsz = EXTATTR_LISTBUF_SZ;
@@ -1729,15 +1729,15 @@ baseuuidbypass:
 			contextp->cc_extattrdumpbufsz = EXTATTR_DUMPBUF_SZ;
 		}
 		contextp->cc_extattrlistbufp =
-			   (char *)calloc(1, contextp->cc_extattrlistbufsz);
+			(char *)calloc(1, contextp->cc_extattrlistbufsz);
 		assert(contextp->cc_extattrlistbufp);
 		contextp->cc_extattrrtrvarrayp =
-		  (attr_multiop_t *)calloc(contextp->cc_extattrrtrvarraylen,
-				    sizeof(attr_multiop_t));
+			(attr_multiop_t *)calloc(contextp->cc_extattrrtrvarraylen,
+						 sizeof(attr_multiop_t));
 		assert(contextp->cc_extattrrtrvarrayp);
 		contextp->cc_extattrdumpbufp =
-			   (char *)memalign(sizeof(extattrhdr_t),
-					       contextp->cc_extattrdumpbufsz);
+			(char *)memalign(sizeof(extattrhdr_t),
+					 contextp->cc_extattrdumpbufsz);
 		assert(contextp->cc_extattrdumpbufp);
 		if (hsm_fs_ctxtp) {
 			contextp->cc_hsm_f_ctxtp = HsmAllocateFileContext(
@@ -1748,7 +1748,7 @@ baseuuidbypass:
 
 		contextp->cc_readlinkbufsz = MAXPATHLEN + SYMLINK_ALIGN;
 		contextp->cc_readlinkbufp =
-			   (char *) calloc(1, contextp->cc_readlinkbufsz);
+			(char *) calloc(1, contextp->cc_readlinkbufsz);
 		assert(contextp->cc_readlinkbufp);
 
 		contextp->cc_inomap_contextp = inomap_alloc_context();
@@ -1772,16 +1772,16 @@ baseuuidbypass:
 			case GETOPT_MEDIALABEL:
 				if (cp >= ep) {
 					mlog(MLOG_NORMAL, _(
-					      "more -%c arguments "
-					      "than number of drives\n"),
-					      c);
+						     "more -%c arguments "
+						     "than number of drives\n"),
+					     c);
 					usage();
 					return BOOL_FALSE;
 				}
 				if (! optarg || optarg[0] == '-') {
 					mlog(MLOG_NORMAL, _(
-					      "-%c argument missing\n"),
-					      c);
+						     "-%c argument missing\n"),
+					     c);
 					usage();
 					return BOOL_FALSE;
 				}
@@ -1793,10 +1793,10 @@ baseuuidbypass:
 
 		if (cp > sc_contextp && cp < ep) {
 			mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      "media labels given for only %d out of %d "
-			      "drives\n"),
-			      cp - sc_contextp,
-			      drivecnt);
+				     "media labels given for only %d out of %d "
+				     "drives\n"),
+			     cp - sc_contextp,
+			     drivecnt);
 		}
 	}
 
@@ -1820,11 +1820,11 @@ baseuuidbypass:
 		pthread_sigmask(SIG_BLOCK, &tty_set, &orig_set);
 
 		result = create_inv_session(gwhdrtemplatep, &fsid, mntpnt,
-					     fsdevice, subtreecnt, strmix);
+					    fsdevice, subtreecnt, strmix);
 
 		pthread_sigmask(SIG_SETMASK, &orig_set, NULL);
 
-		if (!result) {
+		if (! result) {
 			return BOOL_FALSE;
 		}
 	}
@@ -1856,7 +1856,7 @@ baseuuidbypass:
 	return BOOL_TRUE;
 }
 
-#define STATLINESZ	160
+#define STATLINESZ      160
 
 size_t
 content_statline(char **linespp[])
@@ -1905,32 +1905,32 @@ content_statline(char **linespp[])
 	if (sc_stat_inomapphase && sc_stat_inomapcnt) {
 		if (sc_stat_inomappass) {
 			sprintf(statline[0],
-				 "status at %02d:%02d:%02d: "
-				 "inomap phase %u pass %u "
-				 "%llu/%llu inos scanned, "
-				 "%ld seconds elapsed\n",
-				 tmp->tm_hour,
-				 tmp->tm_min,
-				 tmp->tm_sec,
-				 (unsigned int)sc_stat_inomapphase,
-				 (unsigned int)sc_stat_inomappass,
-				 (unsigned long long)sc_stat_inomapdone,
-				 (unsigned long long)sc_stat_inomapcnt,
-				 elapsed);
+				"status at %02d:%02d:%02d: "
+				"inomap phase %u pass %u "
+				"%llu/%llu inos scanned, "
+				"%ld seconds elapsed\n",
+				tmp->tm_hour,
+				tmp->tm_min,
+				tmp->tm_sec,
+				(unsigned int)sc_stat_inomapphase,
+				(unsigned int)sc_stat_inomappass,
+				(unsigned long long)sc_stat_inomapdone,
+				(unsigned long long)sc_stat_inomapcnt,
+				elapsed);
 			assert(strlen(statline[0]) < STATLINESZ);
 		} else {
 			sprintf(statline[0],
-				 "status at %02d:%02d:%02d: "
-				 "inomap phase %u "
-				 "%llu/%llu inos scanned, "
-				 "%ld seconds elapsed\n",
-				 tmp->tm_hour,
-				 tmp->tm_min,
-				 tmp->tm_sec,
-				 (unsigned int)sc_stat_inomapphase,
-				 (unsigned long long)sc_stat_inomapdone,
-				 (unsigned long long)sc_stat_inomapcnt,
-				 elapsed);
+				"status at %02d:%02d:%02d: "
+				"inomap phase %u "
+				"%llu/%llu inos scanned, "
+				"%ld seconds elapsed\n",
+				tmp->tm_hour,
+				tmp->tm_min,
+				tmp->tm_sec,
+				(unsigned int)sc_stat_inomapphase,
+				(unsigned long long)sc_stat_inomapdone,
+				(unsigned long long)sc_stat_inomapcnt,
+				elapsed);
 			assert(strlen(statline[0]) < STATLINESZ);
 		}
 		return 1;
@@ -1948,11 +1948,11 @@ content_statline(char **linespp[])
 	if (nondirdone || datadone) {
 		/*
 		 * calculate percentage of data dumped
-		*/
+		 */
 		if (sc_stat_datasz) {
 			percent = (double)datadone
-				/
-				(double)sc_stat_datasz;
+				  /
+				  (double)sc_stat_datasz;
 			percent *= 100.0;
 		} else {
 			percent = 100.0;
@@ -1963,26 +1963,26 @@ content_statline(char **linespp[])
 
 		/*
 		 * format the status line in a local static buffer (non-re-entrant!)
-		*/
+		 */
 		sprintf(statline[0],
-				"status at %02d:%02d:%02d: %llu/%llu files dumped, "
-				"%.1lf%%%% data dumped, "
-				"%ld seconds elapsed\n",
-				tmp->tm_hour,
-				tmp->tm_min,
-				tmp->tm_sec,
-				(unsigned long long) nondirdone,
-				(unsigned long long) sc_stat_nondircnt,
-				percent,
-				elapsed);
+			"status at %02d:%02d:%02d: %llu/%llu files dumped, "
+			"%.1lf%%%% data dumped, "
+			"%ld seconds elapsed\n",
+			tmp->tm_hour,
+			tmp->tm_min,
+			tmp->tm_sec,
+			(unsigned long long) nondirdone,
+			(unsigned long long) sc_stat_nondircnt,
+			percent,
+			elapsed);
 	} else {
 		sprintf(statline[0],
-				"status at %02d:%02d:%02d: "
-				"%ld seconds elapsed\n",
-				tmp->tm_hour,
-				tmp->tm_min,
-				tmp->tm_sec,
-				elapsed);
+			"status at %02d:%02d:%02d: "
+			"%ld seconds elapsed\n",
+			tmp->tm_hour,
+			tmp->tm_min,
+			tmp->tm_sec,
+			elapsed);
 	}
 
 	assert(strlen(statline[0]) < STATLINESZ);
@@ -1994,46 +1994,46 @@ content_statline(char **linespp[])
 	for (i = 0; i < drivecnt; i++) {
 		pds_t *pdsp = &sc_stat_pds[i];
 		if (pdsp->pds_phase == PDS_NULL
-		     ||
-		     pdsp->pds_phase == PDS_NONDIR) {
+		    ||
+		    pdsp->pds_phase == PDS_NONDIR) {
 			continue;
 		}
 		statline[statlinecnt][0] = 0;
 		if (drivecnt > 1) {
 			sprintf(statline[statlinecnt],
-				 "drive %u: ",
-				 (unsigned int)i);
+				"drive %u: ",
+				(unsigned int)i);
 		}
 		switch (pdsp->pds_phase) {
 		case PDS_INOMAP:
 			strcat(statline[statlinecnt],
-				"dumping inomap");
+			       "dumping inomap");
 			break;
 		case PDS_DIRDUMP:
 			sprintf(&statline[statlinecnt]
-					  [strlen(statline[statlinecnt])],
-				 "%llu/%llu directories dumped",
-				 (unsigned long long)pdsp->pds_dirdone,
-				 (unsigned long long)sc_stat_dircnt);
+				[strlen(statline[statlinecnt])],
+				"%llu/%llu directories dumped",
+				(unsigned long long)pdsp->pds_dirdone,
+				(unsigned long long)sc_stat_dircnt);
 			break;
 		case PDS_INVSYNC:
 			strcat(statline[statlinecnt],
-				"waiting to dump inventory");
+			       "waiting to dump inventory");
 			break;
 		case PDS_INVDUMP:
 			strcat(statline[statlinecnt],
-				"dumping inventory");
+			       "dumping inventory");
 			break;
 		case PDS_TERMDUMP:
 			strcat(statline[statlinecnt],
-				"dumping stream terminator");
+			       "dumping stream terminator");
 			break;
 		default:
 			break;
 		}
 		sprintf(&statline[statlinecnt]
-				  [strlen(statline[statlinecnt])],
-			 "\n");
+			[strlen(statline[statlinecnt])],
+			"\n");
 		assert(strlen(statline[statlinecnt]) < STATLINESZ);
 		statlinecnt++;
 	}
@@ -2043,12 +2043,12 @@ content_statline(char **linespp[])
 
 static bool_t
 create_inv_session(
-		global_hdr_t *gwhdrtemplatep,
-		uuid_t *fsidp,
-		const char *mntpnt,
-		const char *fsdevice,
-		ix_t subtreecnt,
-		size_t strmix)
+	global_hdr_t *	gwhdrtemplatep,
+	uuid_t *	fsidp,
+	const char *	mntpnt,
+	const char *	fsdevice,
+	ix_t		subtreecnt,
+	size_t		strmix)
 {
 	int rval;
 	char *qmntpnt;
@@ -2059,18 +2059,18 @@ create_inv_session(
 	assert(! rval);
 
 	sc_inv_idbtoken = inv_open((inv_predicate_t)INV_BY_UUID,
-					INV_SEARCH_N_MOD,
-					(void *)fsidp);
+				   INV_SEARCH_N_MOD,
+				   (void *)fsidp);
 	if (sc_inv_idbtoken == INV_TOKEN_NULL) {
 		return BOOL_FALSE;
 	}
 	qmntpnt = (char *)calloc(1, strlen(gwhdrtemplatep->gh_hostname)
-					+ 1 + strlen(mntpnt) + 1);
+				 + 1 + strlen(mntpnt) + 1);
 	assert(qmntpnt);
 	assert(strlen(gwhdrtemplatep->gh_hostname));
 	sprintf(qmntpnt, "%s:%s", gwhdrtemplatep->gh_hostname, mntpnt);
 	qfsdevice = (char *)calloc(1, strlen(gwhdrtemplatep->gh_hostname)
-					 + 1 + strlen(fsdevice) + 1);
+				   + 1 + strlen(fsdevice) + 1);
 	assert(qfsdevice);
 	sprintf(qfsdevice, "%s:%s", gwhdrtemplatep->gh_hostname, fsdevice);
 
@@ -2079,7 +2079,7 @@ create_inv_session(
 						&gwhdrtemplatep->gh_dumpid,
 						gwhdrtemplatep->gh_dumplabel,
 						subtreecnt ? BOOL_TRUE
-							   : BOOL_FALSE,
+						: BOOL_FALSE,
 						sc_resumepr,
 						(u_char_t)sc_level,
 						drivecnt,
@@ -2092,9 +2092,9 @@ create_inv_session(
 
 	/*
 	 * open an inventory stream for each stream
-	*/
+	 */
 	sc_inv_stmtokenp = (inv_stmtoken_t *)
-				calloc(drivecnt, sizeof(inv_stmtoken_t));
+			   calloc(drivecnt, sizeof(inv_stmtoken_t));
 	assert(sc_inv_stmtokenp);
 	for (strmix = 0; strmix < drivecnt; strmix++) {
 		drive_t *drivep = drivepp[strmix];
@@ -2106,7 +2106,7 @@ create_inv_session(
 			drvpath = drivep->d_pathname;
 		}
 		sc_inv_stmtokenp[strmix] = inv_stream_open(sc_inv_sestoken,
-								drvpath);
+							   drvpath);
 		if (strcmp(drivep->d_pathname, "stdio")) {
 			free((void *)drvpath);
 		}
@@ -2127,25 +2127,25 @@ mark_set(drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags)
 
 	if (flags & STARTPT_FLAGS_NULL) {
 		mlog(MLOG_DEBUG,
-		      "setting media NULL mark\n");
+		     "setting media NULL mark\n");
 	} else if (flags & STARTPT_FLAGS_END) {
 		mlog(MLOG_DEBUG,
-		      "setting media END mark\n");
+		     "setting media END mark\n");
 	} else {
 		mlog(MLOG_DEBUG,
-		      "setting media mark"
-		      " for ino %llu offset %lld\n",
-		      ino,
-		      offset);
+		     "setting media mark"
+		     " for ino %llu offset %lld\n",
+		     ino,
+		     offset);
 	}
 
 	markp->startpt.sp_ino = ino;
 	markp->startpt.sp_offset = offset;
 	markp->startpt.sp_flags = flags;
 	(*dop->do_set_mark)(drivep,
-				mark_callback,
-				(void *)drivep->d_index,
-				(drive_markrec_t *)markp);
+			    mark_callback,
+			    (void *)drivep->d_index,
+			    (drive_markrec_t *)markp);
 }
 
 static void
@@ -2186,15 +2186,15 @@ mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 		 */
 		if (markp->startpt.sp_flags & STARTPT_FLAGS_NULL) {
 			mlog(MLOG_DEBUG,
-			      "media NULL mark committed"
-			      " in media file %d\n",
-			      mwhdrp->mh_dumpfileix);
+			     "media NULL mark committed"
+			     " in media file %d\n",
+			     mwhdrp->mh_dumpfileix);
 			scwhdrp->cih_startpt.sp_flags |= STARTPT_FLAGS_NULL;
 		} else if (markp->startpt.sp_flags & STARTPT_FLAGS_END) {
 			mlog(MLOG_DEBUG,
-			      "media END mark committed"
-			      " in media file %d\n",
-			      mwhdrp->mh_dumpfileix);
+			     "media END mark committed"
+			     " in media file %d\n",
+			     mwhdrp->mh_dumpfileix);
 			if (scwhdrp->cih_endpt.sp_flags & STARTPT_FLAGS_END) {
 				scwhdrp->cih_startpt.sp_ino++;
 				scwhdrp->cih_startpt.sp_offset = 0;
@@ -2204,12 +2204,12 @@ mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 			scwhdrp->cih_startpt.sp_flags |= STARTPT_FLAGS_END;
 		} else {
 			mlog(MLOG_DEBUG,
-			      "media mark committed"
-			      " for ino %llu offset %lld"
-			      " in media file %d\n",
-			      markp->startpt.sp_ino,
-			      markp->startpt.sp_offset,
-			      mwhdrp->mh_dumpfileix);
+			     "media mark committed"
+			     " for ino %llu offset %lld"
+			     " in media file %d\n",
+			     markp->startpt.sp_ino,
+			     markp->startpt.sp_offset,
+			     mwhdrp->mh_dumpfileix);
 			scwhdrp->cih_startpt = markp->startpt;
 		}
 	} else {
@@ -2218,16 +2218,16 @@ mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 		 */
 		if (markp->startpt.sp_flags & STARTPT_FLAGS_NULL) {
 			mlog(MLOG_DEBUG,
-			      "media NULL mark -NOT- committed\n");
+			     "media NULL mark -NOT- committed\n");
 		} else if (markp->startpt.sp_flags & STARTPT_FLAGS_END) {
 			mlog(MLOG_DEBUG,
-			      "media END mark -NOT- committed\n");
+			     "media END mark -NOT- committed\n");
 		} else {
 			mlog(MLOG_DEBUG,
-			      "media mark -NOT- committed"
-			      " for ino %llu offset %lld\n",
-			      markp->startpt.sp_ino,
-			      markp->startpt.sp_offset);
+			     "media mark -NOT- committed"
+			     " for ino %llu offset %lld\n",
+			     markp->startpt.sp_ino,
+			     markp->startpt.sp_offset);
 		}
 	}
 
@@ -2269,7 +2269,7 @@ content_stream_dump(ix_t strmix)
 	 * allocate a buffer for use by bstat_iter
 	 */
 	bstatbufp = (xfs_bstat_t *)calloc(bstatbuflen,
-					     sizeof(xfs_bstat_t));
+					  sizeof(xfs_bstat_t));
 	assert(bstatbufp);
 
 	/* allocate an inomap context */
@@ -2409,17 +2409,17 @@ content_stream_dump(ix_t strmix)
 		}
 		if (rv == RV_TIMEOUT) {
 			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
-			      "media change timeout will be treated as "
-			      "a request to stop using drive: "
-			      "can resume later\n"));
+				     "media change timeout will be treated as "
+				     "a request to stop using drive: "
+				     "can resume later\n"));
 			mlog_exit_hint(RV_QUIT);
 			return mlog_exit(EXIT_NORMAL, rv);
 		}
 		if (rv == RV_QUIT) {
 			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
-			      "media change decline will be treated as "
-			      "a request to stop using drive: "
-			      "can resume later\n"));
+				     "media change decline will be treated as "
+				     "a request to stop using drive: "
+				     "can resume later\n"));
 			mlog_exit_hint(RV_QUIT);
 			return mlog_exit(EXIT_NORMAL, rv);
 		}
@@ -2441,11 +2441,11 @@ content_stream_dump(ix_t strmix)
 		 * sync up here with other streams if reasonable
 		 */
 		mlog(MLOG_VERBOSE, _(
-		      "creating dump session media file %u "
-		      "(media %u, file %u)\n"),
-		      mwhdrp->mh_dumpfileix,
-		      mwhdrp->mh_mediaix,
-		      mwhdrp->mh_mediafileix);
+			     "creating dump session media file %u "
+			     "(media %u, file %u)\n"),
+		     mwhdrp->mh_dumpfileix,
+		     mwhdrp->mh_mediaix,
+		     mwhdrp->mh_mediafileix);
 
 		/*
 		 * initialize the count of marks committed in the media file.
@@ -2457,7 +2457,7 @@ content_stream_dump(ix_t strmix)
 		 * first dump the inomap
 		 */
 		mlog(MLOG_VERBOSE, _(
-		      "dumping ino map\n"));
+			     "dumping ino map\n"));
 		sc_stat_pds[strmix].pds_phase = PDS_INOMAP;
 		rv = inomap_dump(drivep);
 		if (rv == RV_INTR) {
@@ -2494,9 +2494,9 @@ content_stream_dump(ix_t strmix)
 		if (scwhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP) {
 			sc_stat_pds[strmix].pds_dirdone = 0;
 			rv = dump_dirs(strmix,
-					bstatbufp,
-					bstatbuflen,
-					inomap_contextp);
+				       bstatbufp,
+				       bstatbuflen,
+				       inomap_contextp);
 			if (rv == RV_INTR) {
 				stop_requested = BOOL_TRUE;
 				goto decision_more;
@@ -2534,23 +2534,23 @@ content_stream_dump(ix_t strmix)
 		 */
 		if (! all_nondirs_committed) {
 			mlog(MLOG_VERBOSE, _(
-			      "dumping non-directory files\n"));
+				     "dumping non-directory files\n"));
 			sc_stat_pds[strmix].pds_phase = PDS_NONDIR;
 			rv = RV_OK;
 			inomap_reset_context(inomap_contextp);
 			rval = bigstat_iter(sc_fshandlep,
-					     sc_fsfd,
-					     BIGSTAT_ITER_NONDIR,
-					     scwhdrp->cih_startpt.sp_ino,
-					     (bstat_cbfp_t)dump_file,
-					     (void *)strmix,
-					     inomap_next_nondir,
-					     inomap_contextp,
-					     (int *)&rv,
-					     pipeline ?
-					       (bool_t (*)(int))preemptchk : 0,
-					     bstatbufp,
-					     bstatbuflen);
+					    sc_fsfd,
+					    BIGSTAT_ITER_NONDIR,
+					    scwhdrp->cih_startpt.sp_ino,
+					    (bstat_cbfp_t)dump_file,
+					    (void *)strmix,
+					    inomap_next_nondir,
+					    inomap_contextp,
+					    (int *)&rv,
+					    pipeline ?
+					    (bool_t (*)(int))preemptchk : 0,
+					    bstatbufp,
+					    bstatbuflen);
 			if (rval) {
 				free((void *)bstatbufp);
 				return mlog_exit(EXIT_FAULT, RV_CORE);
@@ -2597,9 +2597,9 @@ content_stream_dump(ix_t strmix)
 		 */
 		all_nondirs_sent = BOOL_TRUE;
 		mark_set(drivep,
-			  INO64MAX,
-			  OFF64MAX,
-			  STARTPT_FLAGS_END);
+			 INO64MAX,
+			 OFF64MAX,
+			 STARTPT_FLAGS_END);
 
 decision_more:
 		/*
@@ -2611,16 +2611,16 @@ decision_more:
 		 */
 		if (! hit_eom) {
 			rv = dump_filehdr(drivep,
-					   contextp,
-					   0,
-					   0,
-					   all_nondirs_sent
-					   ?
-					   (FILEHDR_FLAGS_NULL
-					     |
-					     FILEHDR_FLAGS_END)
-					   :
-					   FILEHDR_FLAGS_NULL);
+					  contextp,
+					  0,
+					  0,
+					  all_nondirs_sent
+					  ?
+					  (FILEHDR_FLAGS_NULL
+					   |
+					   FILEHDR_FLAGS_END)
+					  :
+					  FILEHDR_FLAGS_NULL);
 			if (rv == RV_DRIVE) {
 				free((void *)bstatbufp);
 				return mlog_exit(EXIT_NORMAL, rv);
@@ -2640,13 +2640,13 @@ decision_more:
 			 * call returns if the null file header made it.
 			 */
 			mark_set(drivep,
-				  INO64MAX,
-				  OFF64MAX,
-				  all_nondirs_sent
-				  ?
-				  STARTPT_FLAGS_NULL | STARTPT_FLAGS_END
-				  :
-				  STARTPT_FLAGS_NULL);
+				 INO64MAX,
+				 OFF64MAX,
+				 all_nondirs_sent
+				 ?
+				 STARTPT_FLAGS_NULL | STARTPT_FLAGS_END
+				 :
+				 STARTPT_FLAGS_NULL);
 		}
 
 		/*
@@ -2657,13 +2657,13 @@ decision_more:
 		 * all pending marks.
 		 */
 		mlog(MLOG_VERBOSE, _(
-		      "ending media file\n"));
+			     "ending media file\n"));
 		ncommitted = 0;
 		rv = Media_mfile_end(drivep,
-				      contextp,
-				      mwhdrp,
-				      &ncommitted,
-				      hit_eom);
+				     contextp,
+				     mwhdrp,
+				     &ncommitted,
+				     hit_eom);
 		if (rv == RV_DRIVE) {
 			free((void *)bstatbufp);
 			return mlog_exit(EXIT_NORMAL, rv);
@@ -2673,8 +2673,8 @@ decision_more:
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 		mlog(MLOG_VERBOSE, _(
-		      "media file size %lld bytes\n"),
-		      ncommitted);
+			     "media file size %lld bytes\n"),
+		     ncommitted);
 
 		/*
 		 * if at least one mark committed, we know all of
@@ -2710,66 +2710,66 @@ decision_more:
 
 			if (! all_dirs_committed) {
 				mlog(MLOG_DEBUG,
-				      "giving inventory "
-				      "partial dirdump media file\n");
+				     "giving inventory "
+				     "partial dirdump media file\n");
 			} else if (done && empty_mediafile) {
 				mlog(MLOG_DEBUG,
-				      "giving inventory "
-				      "empty last media file: "
-				      "%llu:%lld\n",
-				       startino,
-				       startoffset);
+				     "giving inventory "
+				     "empty last media file: "
+				     "%llu:%lld\n",
+				     startino,
+				     startoffset);
 			} else if (empty_mediafile) {
 				mlog(MLOG_DEBUG,
-				      "giving inventory "
-				      "empty media file: "
-				      "%llu:%lld\n",
-				       startino,
-				       startoffset);
+				     "giving inventory "
+				     "empty media file: "
+				     "%llu:%lld\n",
+				     startino,
+				     startoffset);
 			} else if (done) {
 				mlog(MLOG_DEBUG,
-				      "giving inventory "
-				      "last media file: "
-				      "%llu:%lld\n",
-				       startino,
-				       startoffset);
+				     "giving inventory "
+				     "last media file: "
+				     "%llu:%lld\n",
+				     startino,
+				     startoffset);
 			} else {
 				mlog(MLOG_DEBUG,
-				      "giving inventory "
-				      "media file: "
-				      "%llu:%lld - %llu:%lld\n",
-				       startino,
-				       startoffset,
-				       scwhdrp->cih_startpt.sp_ino,
-				       scwhdrp->cih_startpt.sp_offset);
+				     "giving inventory "
+				     "media file: "
+				     "%llu:%lld - %llu:%lld\n",
+				     startino,
+				     startoffset,
+				     scwhdrp->cih_startpt.sp_ino,
+				     scwhdrp->cih_startpt.sp_offset);
 			}
 
 			/*
 			 * already thread-safe, don't need to lock
 			 */
 			ok = inv_put_mediafile(inv_stmt,
-						&mwhdrp->mh_mediaid,
-						mwhdrp->mh_medialabel,
-					(uint)mwhdrp->mh_mediafileix,
-						startino,
-						startoffset,
-						scwhdrp->cih_startpt.sp_ino,
-						scwhdrp->cih_startpt.sp_offset,
-						ncommitted,
-					        all_dirs_committed
-						&&
-						! empty_mediafile,
-						BOOL_FALSE);
+					       &mwhdrp->mh_mediaid,
+					       mwhdrp->mh_medialabel,
+					       (uint)mwhdrp->mh_mediafileix,
+					       startino,
+					       startoffset,
+					       scwhdrp->cih_startpt.sp_ino,
+					       scwhdrp->cih_startpt.sp_offset,
+					       ncommitted,
+					       all_dirs_committed
+					       &&
+					       ! empty_mediafile,
+					       BOOL_FALSE);
 			if (! ok) {
 				mlog(MLOG_NORMAL, _(
-				      "inventory media file put failed\n"));
+					     "inventory media file put failed\n"));
 			}
 		}
 		if (done) {
 			contextp->cc_completepr = BOOL_TRUE;
-			    /*
-			     * so inv_end_stream and main will know
-			     */
+			/*
+			 * so inv_end_stream and main will know
+			 */
 		}
 
 		/*
@@ -2796,20 +2796,20 @@ decision_more:
 	if (drivep->d_capabilities & DRIVE_CAP_FILES) {
 		if (stream_cnt() > 1) {
 			mlog(MLOG_VERBOSE, _(
-			      "waiting for synchronized "
-			      "session inventory dump\n"));
+				     "waiting for synchronized "
+				     "session inventory dump\n"));
 			sc_stat_pds[strmix].pds_phase = PDS_INVSYNC;
 		}
 
 		/*
 		 * first be sure all threads have begun
-		*/
+		 */
 		while (sc_thrdsarrivedcnt < drivecnt) {
 			sleep(1);
 		}
 		/*
 		 * now wait for survivors to checkin
-		*/
+		 */
 		while (sc_thrdsdonecnt < stream_cnt()) {
 			sleep(1);
 		}
@@ -2830,8 +2830,8 @@ decision_more:
 	elapsed = time(0) - sc_stat_starttime;
 
 	mlog(MLOG_TRACE, _(
-	      "ending stream: %ld seconds elapsed\n"),
-	      elapsed);
+		     "ending stream: %ld seconds elapsed\n"),
+	     elapsed);
 
 	return mlog_exit(EXIT_NORMAL, rv);
 }
@@ -2854,57 +2854,57 @@ content_complete(void)
 	elapsed = time(0) - sc_stat_starttime;
 
 	mlog(MLOG_VERBOSE, _(
-	      "dump size (non-dir files) : %llu bytes\n"),
-	      sc_stat_datadone);
+		     "dump size (non-dir files) : %llu bytes\n"),
+	     sc_stat_datadone);
 
 	if (completepr) {
 		if (sc_savequotas) {
 			for (i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
 				if (quotas[i].savequotas && unlink(quotas[i].quotapath) < 0) {
 					mlog(MLOG_ERROR, _(
-					"unable to remove %s: %s\n"),
-					quotas[i].quotapath,
-					strerror (errno));
+						     "unable to remove %s: %s\n"),
+					     quotas[i].quotapath,
+					     strerror (errno));
 				}
 			}
 		}
 
 		mlog(MLOG_VERBOSE, _(
-		      "dump complete"
-		      ": %ld seconds elapsed"
-		      "\n"),
-		      elapsed);
+			     "dump complete"
+			     ": %ld seconds elapsed"
+			     "\n"),
+		     elapsed);
 	} else {
 		if (sc_inv_updatepr) {
 			mlog(MLOG_VERBOSE | MLOG_NOTE, _(
-			      "dump interrupted"
-			      ": %ld seconds elapsed"
-			      ": may resume later using -%c option"
-			      "\n"),
-			      elapsed,
-			      GETOPT_RESUME);
+				     "dump interrupted"
+				     ": %ld seconds elapsed"
+				     ": may resume later using -%c option"
+				     "\n"),
+			     elapsed,
+			     GETOPT_RESUME);
 			mlog_exit_hint(RV_INTR);
 		} else {
 			mlog(MLOG_VERBOSE | MLOG_NOTE, _(
-			      "dump interrupted"
-			      ": %ld seconds elapsed"
-			      "\n"),
-			      elapsed);
+				     "dump interrupted"
+				     ": %ld seconds elapsed"
+				     "\n"),
+			     elapsed);
 			mlog_exit_hint(RV_INTR);
 		}
 	}
 	return completepr;
 }
 
-#define PREAMBLEMAX	3
-#define QUERYMAX	1
-#define CHOICEMAX	30
-#define ACKMAX		3
-#define POSTAMBLEMAX	3
-#define DLOG_TIMEOUT	300
-#define DLOG_TIMEOUT_MEDIA	3600
+#define PREAMBLEMAX     3
+#define QUERYMAX        1
+#define CHOICEMAX       30
+#define ACKMAX          3
+#define POSTAMBLEMAX    3
+#define DLOG_TIMEOUT    300
+#define DLOG_TIMEOUT_MEDIA      3600
 
-#define CHOICESTRSZ	10
+#define CHOICESTRSZ     10
 typedef struct { ix_t thrdix; char choicestr[CHOICESTRSZ]; } cttm_t;
 
 char *
@@ -2928,10 +2928,10 @@ content_mediachange_query(void)
 		if (sc_mcflag[thrdix]) {
 			choicetothrdmap[choicecnt].thrdix = thrdix;
 			sprintf(choicetothrdmap[choicecnt].choicestr,
-				 "drive %u",
-				 (unsigned int)thrdix);
+				"drive %u",
+				(unsigned int)thrdix);
 			choicestr[choicecnt] =
-					choicetothrdmap[choicecnt].choicestr;
+				choicetothrdmap[choicecnt].choicestr;
 			maxdrvchoiceix = choicecnt;
 			choicecnt++;
 		}
@@ -2940,18 +2940,18 @@ content_mediachange_query(void)
 	choicestr[choicecnt++] = "continue";
 	assert(choicecnt <= CHOICEMAX);
 	responseix = dlog_multi_query(querystr,
-				       querycnt,
-				       choicestr,
-				       choicecnt,
-				       0,           /* hilitestr */
-				       IXMAX,       /* hiliteix */
-				       0,           /* defaultstr */
-				       nochangeix,  /* defaultix */
-				       DLOG_TIMEOUT_MEDIA,
-				       nochangeix, /* timeout ix */
-				       nochangeix, /* sigint ix */
-				       nochangeix, /* sighup ix */
-				       nochangeix);/* sigquit ix */
+				      querycnt,
+				      choicestr,
+				      choicecnt,
+				      0,                /* hilitestr */
+				      IXMAX,            /* hiliteix */
+				      0,                /* defaultstr */
+				      nochangeix,       /* defaultix */
+				      DLOG_TIMEOUT_MEDIA,
+				      nochangeix,       /* timeout ix */
+				      nochangeix,       /* sigint ix */
+				      nochangeix,       /* sighup ix */
+				      nochangeix);      /* sigquit ix */
 	if (responseix <= maxdrvchoiceix) {
 		clr_mcflag(choicetothrdmap[responseix].thrdix);
 		return "media change acknowledged\n";
@@ -2967,29 +2967,29 @@ update_cc_Media_useterminatorpr(drive_t *drivep, context_t *contextp)
 	int dcaps = drivep->d_capabilities;
 
 	contextp->cc_Media_useterminatorpr = BOOL_TRUE;
-	if (! (dcaps & DRIVE_CAP_FILES)) {
+	if (!(dcaps & DRIVE_CAP_FILES)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
-	if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
+	if (!(dcaps & DRIVE_CAP_OVERWRITE)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
-	if (! (dcaps & DRIVE_CAP_BSF)) {
+	if (!(dcaps & DRIVE_CAP_BSF)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
-	if (! (dcaps & DRIVE_CAP_APPEND)) {
+	if (!(dcaps & DRIVE_CAP_APPEND)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
 }
 
 static rv_t
-dump_dirs(ix_t strmix,
-	   xfs_bstat_t *bstatbufp,
-	   size_t bstatbuflen,
-	   void *inomap_contextp)
+dump_dirs(ix_t		strmix,
+	  xfs_bstat_t * bstatbufp,
+	  size_t	bstatbuflen,
+	  void *	inomap_contextp)
 {
 	xfs_ino_t lastino;
 	size_t bulkstatcallcnt;
-        xfs_fsop_bulkreq_t bulkreq;
+	xfs_fsop_bulkreq_t bulkreq;
 
 	inomap_reset_context(inomap_contextp);
 
@@ -3005,7 +3005,7 @@ dump_dirs(ix_t strmix,
 
 		if (bulkstatcallcnt == 0) {
 			mlog(MLOG_VERBOSE, _(
-			      "dumping directories\n"));
+				     "dumping directories\n"));
 		}
 		sc_stat_pds[strmix].pds_phase = PDS_DIRDUMP;
 
@@ -3020,9 +3020,9 @@ dump_dirs(ix_t strmix,
 		 * get a bunch of bulkstats
 		 */
 		mlog(MLOG_NITTY,
-		      "dump_dirs SGI_FS_BULKSTAT %u buf len %u\n",
-		      bulkstatcallcnt,
-		      bstatbuflen);
+		     "dump_dirs SGI_FS_BULKSTAT %u buf len %u\n",
+		     bulkstatcallcnt,
+		     bstatbuflen);
 
 		bulkreq.lastip = (__u64 *)&lastino;
 		bulkreq.icount = bstatbuflen;
@@ -3033,15 +3033,15 @@ dump_dirs(ix_t strmix,
 
 		if (rval) {
 			mlog(MLOG_NORMAL, _(
-			      "SGI_FS_BULKSTAT failed: "
-			      "%s (%d)\n"),
-			      strerror(errno),
-			      errno);
+				     "SGI_FS_BULKSTAT failed: "
+				     "%s (%d)\n"),
+			     strerror(errno),
+			     errno);
 			return RV_ERROR;
 		}
 		mlog(MLOG_NITTY,
-		      "dump_dirs SGI_FS_BULKSTAT returns %d entries\n",
-		      buflenout);
+		     "dump_dirs SGI_FS_BULKSTAT returns %d entries\n",
+		     buflenout);
 
 		/*
 		 * check if done
@@ -3056,30 +3056,30 @@ dump_dirs(ix_t strmix,
 		 */
 		for (p = bstatbufp, endp = bstatbufp + buflenout
 		     ;
-		      p < endp
+		     p < endp
 		     ;
-		      p++) {
+		     p++) {
 			rv_t rv;
 
 			if (p->bs_ino == 0)
 				continue;
 
-			if (!p->bs_nlink || !p->bs_mode) {
+			if (! p->bs_nlink || ! p->bs_mode) {
 				/* inode being modified, get synced data */
 				mlog(MLOG_NITTY,
-				      "ino %llu needs second bulkstat\n",
-				      p->bs_ino);
+				     "ino %llu needs second bulkstat\n",
+				     p->bs_ino);
 
 				if (bigstat_one(sc_fsfd, p->bs_ino, p) < 0) {
-					mlog(MLOG_WARNING,  _(
-					      "failed to get bulkstat information for inode %llu\n"),
-					      p->bs_ino);
+					mlog(MLOG_WARNING, _(
+						     "failed to get bulkstat information for inode %llu\n"),
+					     p->bs_ino);
 					continue;
 				}
-				if (!p->bs_nlink || !p->bs_mode || !p->bs_ino) {
+				if (! p->bs_nlink || ! p->bs_mode || ! p->bs_ino) {
 					mlog(MLOG_TRACE,
-					      "failed to get valid bulkstat information for inode %llu\n",
-					      p->bs_ino);
+					     "failed to get valid bulkstat information for inode %llu\n",
+					     p->bs_ino);
 					continue;
 				}
 			}
@@ -3107,10 +3107,10 @@ dump_dirs(ix_t strmix,
 }
 
 static rv_t
-dump_dir(ix_t strmix,
-	  jdm_fshandle_t *fshandlep,
-	  int fsfd,
-	  xfs_bstat_t *statp)
+dump_dir(ix_t			strmix,
+	 jdm_fshandle_t *	fshandlep,
+	 int			fsfd,
+	 xfs_bstat_t *		statp)
 {
 	context_t *contextp = &sc_contextp[strmix];
 	drive_t *drivep = drivepp[strmix];
@@ -3147,15 +3147,15 @@ dump_dir(ix_t strmix,
 	 * skip if not in inomap
 	 */
 	if (state == MAP_INO_UNUSED
-	     ||
-	     state == MAP_DIR_NOCHNG
-	     ||
-	     state == MAP_NDR_NOCHNG) {
+	    ||
+	    state == MAP_DIR_NOCHNG
+	    ||
+	    state == MAP_NDR_NOCHNG) {
 		if (state == MAP_NDR_NOCHNG) {
 			mlog(MLOG_DEBUG,
-			      "inomap inconsistency ino %llu: "
-			      "map says is non-dir but is dir: skipping\n",
-			      statp->bs_ino);
+			     "inomap inconsistency ino %llu: "
+			     "map says is non-dir but is dir: skipping\n",
+			     statp->bs_ino);
 		}
 		return RV_OK;
 	}
@@ -3165,9 +3165,9 @@ dump_dir(ix_t strmix,
 	 */
 	if (state == MAP_NDR_CHANGE) {
 		mlog(MLOG_DEBUG,
-		      "inomap inconsistency ino %llu: "
-		      "map says non-dir but is dir: skipping\n",
-		      statp->bs_ino);
+		     "inomap inconsistency ino %llu: "
+		     "map says non-dir but is dir: skipping\n",
+		     statp->bs_ino);
 		return RV_OK;
 	}
 
@@ -3176,21 +3176,21 @@ dump_dir(ix_t strmix,
 	 */
 	sc_stat_pds[strmix].pds_dirdone++;
 
-        /*
-         * if bulkstat ino# occupied more than 32 bits and
-         * linux ino# for getdents is 32 bits then
-         * warn and skip.
-         */
+	/*
+	 * if bulkstat ino# occupied more than 32 bits and
+	 * linux ino# for getdents is 32 bits then
+	 * warn and skip.
+	 */
 	if (statp->bs_ino > (xfs_ino_t)INOMAX) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "unable to dump directory: ino %llu too large\n"),
-		      statp->bs_ino);
+			     "unable to dump directory: ino %llu too large\n"),
+		     statp->bs_ino);
 		return RV_OK; /* continue anyway */
 	}
 
 	mlog(MLOG_TRACE,
-	      "dumping directory ino %llu\n",
-	      statp->bs_ino);
+	     "dumping directory ino %llu\n",
+	     statp->bs_ino);
 
 	/*
 	 * open the directory named by statp
@@ -3198,8 +3198,8 @@ dump_dir(ix_t strmix,
 	fd = jdm_open(fshandlep, statp, O_RDONLY);
 	if (fd < 0) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "unable to open directory: ino %llu: %s\n"),
-		      statp->bs_ino, strerror(errno) );
+			     "unable to open directory: ino %llu: %s\n"),
+		     statp->bs_ino, strerror(errno) );
 		return RV_OK; /* continue anyway */
 	}
 
@@ -3229,11 +3229,11 @@ dump_dir(ix_t strmix,
 		 */
 		if (nread < 0) {
 			mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      "unable to read dirents (%d) for "
-			      "directory ino %llu: %s\n"),
-			      gdcnt,
-			      statp->bs_ino,
-			      strerror(errno));
+				     "unable to read dirents (%d) for "
+				     "directory ino %llu: %s\n"),
+			     gdcnt,
+			     statp->bs_ino,
+			     strerror(errno));
 			/*
 			 * !!! curtis looked at this, and pointed out that
 			 * we could take some recovery action here. if the
@@ -3256,21 +3256,21 @@ dump_dir(ix_t strmix,
 		 * and null entries.
 		 */
 		for (p = gdp,
-		      reclen = (size_t)p->d_reclen
+		     reclen = (size_t)p->d_reclen
 		     ;
-		      nread > 0
+		     nread > 0
 		     ;
-		      nread -= (int)reclen,
-		      assert(nread >= 0),
-		      p = (struct dirent *)((char *)p + reclen),
-		      reclen = (size_t)p->d_reclen) {
+		     nread -= (int)reclen,
+		     assert(nread >= 0),
+		     p = (struct dirent *)((char *)p + reclen),
+		     reclen = (size_t)p->d_reclen) {
 			xfs_ino_t ino;
 			register size_t namelen = strlen(p->d_name);
 #ifdef DEBUG
 			register size_t nameszmax = (size_t)reclen
 						    -
 						    offsetofmember(struct dirent,
-								    d_name);
+								   d_name);
 
 			/*
 			 * getdents(2) guarantees that the string will
@@ -3284,12 +3284,12 @@ dump_dir(ix_t strmix,
 			 * skip "." and ".."
 			 */
 			if (*(p->d_name + 0) == '.'
-			     &&
-			     (*(p->d_name + 1) == 0
-			       ||
-			       (*(p->d_name + 1) == '.'
-				 &&
-				 *(p->d_name + 2) == 0))) {
+			    &&
+			    (*(p->d_name + 1) == 0
+			     ||
+			     (*(p->d_name + 1) == '.'
+			      &&
+			      *(p->d_name + 2) == 0))) {
 				continue;
 			}
 
@@ -3297,10 +3297,10 @@ dump_dir(ix_t strmix,
 
 			if (ino == 0) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "encountered 0 ino (%s) in "
-				      "directory ino %llu: NOT dumping\n"),
-				      p->d_name,
-				      statp->bs_ino);
+					     "encountered 0 ino (%s) in "
+					     "directory ino %llu: NOT dumping\n"),
+				     p->d_name,
+				     statp->bs_ino);
 				continue;
 			}
 
@@ -3313,17 +3313,17 @@ dump_dir(ix_t strmix,
 				int scrval;
 
 				scrval = bigstat_one(fsfd,
-						      p->d_ino,
-						      &statbuf);
+						     p->d_ino,
+						     &statbuf);
 				if (scrval) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-					      "could not stat "
-					      "dirent %s ino %llu: %s: "
-					      "using null generation count "
-					      "in directory entry\n"),
-					      p->d_name,
-					      (xfs_ino_t)p->d_ino,
-					      strerror(errno));
+						     "could not stat "
+						     "dirent %s ino %llu: %s: "
+						     "using null generation count "
+						     "in directory entry\n"),
+					     p->d_name,
+					     (xfs_ino_t)p->d_ino,
+					     strerror(errno));
 					gen = 0;
 				} else {
 					gen = statbuf.bs_gen;
@@ -3331,12 +3331,12 @@ dump_dir(ix_t strmix,
 			}
 
 			rv = dump_dirent(drivep,
-					  contextp,
-					  statp,
-					  ino,
-					  gen,
-					  p->d_name,
-					  namelen);
+					 contextp,
+					 statp,
+					 ino,
+					 gen,
+					 p->d_name,
+					 namelen);
 			if (rv != RV_OK) {
 				break;
 			}
@@ -3351,10 +3351,10 @@ dump_dir(ix_t strmix,
 	}
 
 	if (rv == RV_OK
-	     &&
-	     sc_dumpextattrpr
-	     &&
-	     (statp->bs_xflags & XFS_XFLAG_HASATTR)) {
+	    &&
+	    sc_dumpextattrpr
+	    &&
+	    (statp->bs_xflags & XFS_XFLAG_HASATTR)) {
 		rv = dump_extattrs(drivep, contextp, fshandlep, statp);
 	}
 
@@ -3367,10 +3367,10 @@ dump_dir(ix_t strmix,
 }
 
 static rv_t
-dump_extattrs(drive_t *drivep,
-	       context_t *contextp,
-	       jdm_fshandle_t *fshandlep,
-	       xfs_bstat_t *statp)
+dump_extattrs(drive_t *		drivep,
+	      context_t *	contextp,
+	      jdm_fshandle_t *	fshandlep,
+	      xfs_bstat_t *	statp)
 {
 	ix_t pass;
 	int flag;
@@ -3382,9 +3382,9 @@ dump_extattrs(drive_t *drivep,
 	 * dump a file header specially marked as heading extended attributes
 	 */
 	mlog(MLOG_NITTY,
-	      "dumping %s ino %llu extended attributes filehdr\n",
-	      FILETYPE(statp),
-	      statp->bs_ino);
+	     "dumping %s ino %llu extended attributes filehdr\n",
+	     FILETYPE(statp),
+	     statp->bs_ino);
 
 	rv = dump_filehdr(drivep, contextp, statp, 0, FILEHDR_FLAGS_EXTATTR);
 	if (rv != RV_OK) {
@@ -3406,10 +3406,10 @@ dump_extattrs(drive_t *drivep,
 			flag = ATTR_SECURE;
 
 		mlog(MLOG_NITTY,
-		      "dumping %s extended attributes for %s ino %llu\n",
-		      EXTATTR_NAMESPACE(flag),
-		      FILETYPE(statp),
-		      statp->bs_ino);
+		     "dumping %s extended attributes for %s ino %llu\n",
+		     EXTATTR_NAMESPACE(flag),
+		     FILETYPE(statp),
+		     statp->bs_ino);
 
 		/*
 		 * loop dumping the extended attributes from the namespace
@@ -3422,18 +3422,18 @@ dump_extattrs(drive_t *drivep,
 			int rval = 0;
 
 			rval = jdm_attr_list(fshandlep, statp,
-				contextp->cc_extattrlistbufp,
-				(int)contextp->cc_extattrlistbufsz,
-				flag, &cursor);
+					     contextp->cc_extattrlistbufp,
+					     (int)contextp->cc_extattrlistbufsz,
+					     flag, &cursor);
 			if (rval) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "could not get list of %s attributes for "
-				      "%s ino %llu: %s (%d)\n"),
-				      EXTATTR_NAMESPACE(flag),
-				      FILETYPE(statp),
-				      statp->bs_ino,
-				      strerror(errno),
-				      errno);
+					     "could not get list of %s attributes for "
+					     "%s ino %llu: %s (%d)\n"),
+				     EXTATTR_NAMESPACE(flag),
+				     FILETYPE(statp),
+				     statp->bs_ino,
+				     strerror(errno),
+				     errno);
 				break;
 			}
 
@@ -3442,42 +3442,42 @@ dump_extattrs(drive_t *drivep,
 
 			abort = BOOL_FALSE;
 			rv = dump_extattr_list(drivep,
-						contextp,
-						fshandlep,
-						statp,
-						listp,
-						flag,
-						&abort);
+					       contextp,
+					       fshandlep,
+					       statp,
+					       listp,
+					       flag,
+					       &abort);
 			if (rv != RV_OK) {
 				return rv;
 			}
-		} while (more && !abort);
+		} while (more && ! abort);
 	}
 
 	/*
 	 * finally, dump a dummy extattr hdr so restore will know
 	 * we're done.
 	 */
-	/*DBG*/mlog(MLOG_NITTY,
+	/*DBG*/ mlog(MLOG_NITTY,
 		     "dumping NULL extattrhdr\n");
 	rv = dump_extattrhdr(drivep,
-			      contextp,
-			      statp,
-			      EXTATTRHDR_SZ,
-			      0,
-			      EXTATTRHDR_FLAGS_NULL,
-			      0);
+			     contextp,
+			     statp,
+			     EXTATTRHDR_SZ,
+			     0,
+			     EXTATTRHDR_FLAGS_NULL,
+			     0);
 	return rv;
 }
 
 static rv_t
-dump_extattr_list(drive_t *drivep,
-		   context_t *contextp,
-		   jdm_fshandle_t *fshandlep,
-		   xfs_bstat_t *statp,
-		   attrlist_t *listp,
-		   int flag,
-		   bool_t *abortprp)
+dump_extattr_list(drive_t *		drivep,
+		  context_t *		contextp,
+		  jdm_fshandle_t *	fshandlep,
+		  xfs_bstat_t *		statp,
+		  attrlist_t *		listp,
+		  int			flag,
+		  bool_t *		abortprp)
 {
 	size_t listlen = (size_t)listp->al_count;
 	ix_t nameix;
@@ -3521,19 +3521,19 @@ dump_extattr_list(drive_t *drivep,
 			 */
 
 			if (hsm_fs_ctxtp) {
-				int	skip_entry;
+				int skip_entry;
 
-				if (!HsmFilterExistingAttribute(
-				    contextp->cc_hsm_f_ctxtp, entp->a_name,
-				    entp->a_valuelen, flag,
-				    &skip_entry)) {
+				if (! HsmFilterExistingAttribute(
+					    contextp->cc_hsm_f_ctxtp, entp->a_name,
+					    entp->a_valuelen, flag,
+					    &skip_entry)) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      		    "HSM could not filter %s "
-					    "attribute %s for %s ino %llu\n"),
-					    EXTATTR_NAMESPACE(flag),
-					    entp->a_name,
-					    FILETYPE(statp),
-			      		    statp->bs_ino);
+						     "HSM could not filter %s "
+						     "attribute %s for %s ino %llu\n"),
+					     EXTATTR_NAMESPACE(flag),
+					     entp->a_name,
+					     FILETYPE(statp),
+					     statp->bs_ino);
 					*abortprp = BOOL_TRUE;
 					return RV_OK;
 				}
@@ -3544,16 +3544,16 @@ dump_extattr_list(drive_t *drivep,
 			}
 
 			dumpbufp = dump_extattr_buildrecord(statp,
-							     dumpbufp,
-							     dumpbufendp,
-							     entp->a_name,
-							     entp->a_valuelen,
-							     flag,
-							     &valuep);
+							    dumpbufp,
+							    dumpbufendp,
+							    entp->a_name,
+							    entp->a_valuelen,
+							    flag,
+							    &valuep);
 			if (dumpbufp > dumpbufendp) {
-				break;		/* won't fit in buffer */
+				break;          /* won't fit in buffer */
 			}
-			if (valuep != NULL) { /* if added to dump buffer */
+			if (valuep != NULL) {   /* if added to dump buffer */
 				endp = dumpbufp;
 				opp->am_attrname = entp->a_name;
 				opp->am_attrvalue = valuep;
@@ -3575,18 +3575,18 @@ dump_extattr_list(drive_t *drivep,
 		rtrvcnt = rtrvix;
 		if (rtrvcnt > 0) {
 			rval = jdm_attr_multi(fshandlep, statp,
-					(void *)contextp->cc_extattrrtrvarrayp,
-					(int)rtrvcnt,
-					0);
+					      (void *)contextp->cc_extattrrtrvarrayp,
+					      (int)rtrvcnt,
+					      0);
 			if (rval) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "could not retrieve %s attributes for "
-				      "%s ino %llu: %s (%d)\n"),
-				      EXTATTR_NAMESPACE(flag),
-				      FILETYPE(statp),
-				      statp->bs_ino,
-				      strerror(errno),
-				      errno);
+					     "could not retrieve %s attributes for "
+					     "%s ino %llu: %s (%d)\n"),
+				     EXTATTR_NAMESPACE(flag),
+				     FILETYPE(statp),
+				     statp->bs_ino,
+				     strerror(errno),
+				     errno);
 				*abortprp = BOOL_TRUE;
 				return RV_OK;
 			}
@@ -3596,23 +3596,23 @@ dump_extattr_list(drive_t *drivep,
 				opp = &contextp->cc_extattrrtrvarrayp[rtrvix];
 				if (opp->am_error) {
 					if (opp->am_error == ENOATTR &&
-					     flag & ATTR_SECURE) {
-				/*
-				 * Security attributes are supported by
-				 * the kernel but jdm_attr_multi() returns
-				 * ENOATTR for every 'user' space attribute
-				 * during the 'security' pass of the extended
-				 * attribute loop (pass==3).  Suppress the
-				 * following error message with a no-op. The
-				 * jdm_attr_multi() problem is fixed in mod
-				 * xfs-linux:xfs-kern:167038a (PV 907903).
-				 */
+					    flag & ATTR_SECURE) {
+						/*
+						 * Security attributes are supported by
+						 * the kernel but jdm_attr_multi() returns
+						 * ENOATTR for every 'user' space attribute
+						 * during the 'security' pass of the extended
+						 * attribute loop (pass==3).  Suppress the
+						 * following error message with a no-op. The
+						 * jdm_attr_multi() problem is fixed in mod
+						 * xfs-linux:xfs-kern:167038a (PV 907903).
+						 */
 						continue;
 					}
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-					     "attr_multi indicates error while "
-					     "retrieving %s attribute [%s] for "
-					     "%s ino %llu: %s (%d)\n"),
+						     "attr_multi indicates error while "
+						     "retrieving %s attribute [%s] for "
+						     "%s ino %llu: %s (%d)\n"),
 					     EXTATTR_NAMESPACE(flag),
 					     opp->am_attrname,
 					     FILETYPE(statp),
@@ -3630,16 +3630,16 @@ dump_extattr_list(drive_t *drivep,
 		 */
 
 		if (dumpbufp <= dumpbufendp)
-			continue;	/* no buffer overflow yet */
+			continue;       /* no buffer overflow yet */
 
 		assert(endp > contextp->cc_extattrdumpbufp);
 		bufsz = (size_t)(endp - contextp->cc_extattrdumpbufp);
 
 		rval = write_buf(contextp->cc_extattrdumpbufp,
-				  bufsz,
-				  (void *)drivep,
-				  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
-				  (wfp_t)drivep->d_opsp->do_write);
+				 bufsz,
+				 (void *)drivep,
+				 (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+				 (wfp_t)drivep->d_opsp->do_write);
 		switch (rval) {
 		case 0:
 			rv = RV_OK;
@@ -3669,41 +3669,41 @@ dump_extattr_list(drive_t *drivep,
 	 * needs to add any addtional attributes.
 	 */
 
-	if (!listp->al_more && hsm_fs_ctxtp) {
+	if (! listp->al_more && hsm_fs_ctxtp) {
 		int hsmcursor = 0;
 		for (;;) {
-			char	*hsmnamep;
-			char	*hsmvaluep;
-			char	*valuep;
-			uint32_t	hsmvaluesz;
+			char *hsmnamep;
+			char *hsmvaluep;
+			char *valuep;
+			uint32_t hsmvaluesz;
 
-			if (!HsmAddNewAttribute(contextp->cc_hsm_f_ctxtp,
+			if (! HsmAddNewAttribute(contextp->cc_hsm_f_ctxtp,
 						hsmcursor,
 						flag,
 						&hsmnamep,
 						&hsmvaluep,
 						&hsmvaluesz)) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      		"HSM could not add new %s attribute "
-					"#%d for %s ino %llu\n"),
-					EXTATTR_NAMESPACE(flag),
-					hsmcursor,
-					FILETYPE(statp),
-			      		statp->bs_ino);
+					     "HSM could not add new %s attribute "
+					     "#%d for %s ino %llu\n"),
+				     EXTATTR_NAMESPACE(flag),
+				     hsmcursor,
+				     FILETYPE(statp),
+				     statp->bs_ino);
 				*abortprp = BOOL_TRUE;
 				return RV_OK;
 			}
 			if (hsmnamep == NULL) {
-				break;		/* No more attributes to add */
+				break;          /* No more attributes to add */
 			}
 
 			dumpbufp = dump_extattr_buildrecord(statp,
-							     dumpbufp,
-							     dumpbufendp,
-							     hsmnamep,
-							     hsmvaluesz,
-							     flag,
-							     &valuep);
+							    dumpbufp,
+							    dumpbufendp,
+							    hsmnamep,
+							    hsmvaluesz,
+							    flag,
+							    &valuep);
 
 			if (dumpbufp < dumpbufendp) { /* if fits in buffer */
 				endp = dumpbufp;
@@ -3716,10 +3716,10 @@ dump_extattr_list(drive_t *drivep,
 			bufsz = (size_t)(endp - contextp->cc_extattrdumpbufp);
 
 			rval = write_buf(contextp->cc_extattrdumpbufp,
-				  bufsz,
-				  (void *)drivep,
-				  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
-				  (wfp_t)drivep->d_opsp->do_write);
+					 bufsz,
+					 (void *)drivep,
+					 (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+					 (wfp_t)drivep->d_opsp->do_write);
 			switch (rval) {
 			case 0:
 				rv = RV_OK;
@@ -3754,10 +3754,10 @@ dump_extattr_list(drive_t *drivep,
 		bufsz = (size_t)(endp - contextp->cc_extattrdumpbufp);
 
 		rval = write_buf(contextp->cc_extattrdumpbufp,
-				  bufsz,
-				  (void *)drivep,
-				  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
-				  (wfp_t)drivep->d_opsp->do_write);
+				 bufsz,
+				 (void *)drivep,
+				 (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+				 (wfp_t)drivep->d_opsp->do_write);
 		switch (rval) {
 		case 0:
 			rv = RV_OK;
@@ -3785,13 +3785,13 @@ dump_extattr_list(drive_t *drivep,
 }
 
 static char *
-dump_extattr_buildrecord(xfs_bstat_t *statp,
-			  char *dumpbufp,
-			  char *dumpbufendp,
-			  char *namesrcp,
-			  uint32_t valuesz,
-			  int flag,
-			  char **valuepp)
+dump_extattr_buildrecord(xfs_bstat_t *	statp,
+			 char *		dumpbufp,
+			 char *		dumpbufendp,
+			 char *		namesrcp,
+			 uint32_t	valuesz,
+			 int		flag,
+			 char **	valuepp)
 {
 	extattrhdr_t *ahdrp = (extattrhdr_t *)dumpbufp;
 	char *namep = dumpbufp + EXTATTRHDR_SZ;
@@ -3812,31 +3812,31 @@ dump_extattr_buildrecord(xfs_bstat_t *statp,
 
 	if (namelen > NAME_MAX) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "%s extended attribute name for %s ino %llu too long: "
-		      "%u, max is %u: skipping\n"),
-		      EXTATTR_NAMESPACE(flag),
-		      FILETYPE(statp),
-		      statp->bs_ino,
-		      namelen,
-		      NAME_MAX);
+			     "%s extended attribute name for %s ino %llu too long: "
+			     "%u, max is %u: skipping\n"),
+		     EXTATTR_NAMESPACE(flag),
+		     FILETYPE(statp),
+		     statp->bs_ino,
+		     namelen,
+		     NAME_MAX);
 		*valuepp = 0;
 		return dumpbufp;
 	}
 
 	if (valuesz > ATTR_MAX_VALUELEN) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "%s extended attribute value for %s ino %llu too long: "
-		      "%u, max is %u: skipping\n"),
-		      EXTATTR_NAMESPACE(flag),
-		      FILETYPE(statp),
-		      statp->bs_ino,
-		      valuesz,
-		      ATTR_MAX_VALUELEN);
+			     "%s extended attribute value for %s ino %llu too long: "
+			     "%u, max is %u: skipping\n"),
+		     EXTATTR_NAMESPACE(flag),
+		     FILETYPE(statp),
+		     statp->bs_ino,
+		     valuesz,
+		     ATTR_MAX_VALUELEN);
 		*valuepp = 0;
 		return dumpbufp;
 	}
 
-	/*DBG*/mlog(MLOG_NITTY,
+	/*DBG*/ mlog(MLOG_NITTY,
 		     "building extattr "
 		     "record sz %u "
 		     "hdrsz %u "
@@ -3853,8 +3853,8 @@ dump_extattr_buildrecord(xfs_bstat_t *statp,
 	assert(EXTATTRHDR_SZ + namesz < UINT16MAX);
 	tmpah.ah_valoff = (uint16_t)(EXTATTRHDR_SZ + namesz);
 	tmpah.ah_flags = (uint16_t)
-		((flag & ATTR_ROOT) ? EXTATTRHDR_FLAGS_ROOT :
-		((flag & ATTR_SECURE) ? EXTATTRHDR_FLAGS_SECURE : 0));
+			 ((flag & ATTR_ROOT) ? EXTATTRHDR_FLAGS_ROOT :
+			  ((flag & ATTR_SECURE) ? EXTATTRHDR_FLAGS_SECURE : 0));
 	tmpah.ah_valsz = valuesz;
 	tmpah.ah_flags |= EXTATTRHDR_FLAGS_CHECKSUM;
 	tmpah.ah_checksum = calc_checksum(&tmpah, EXTATTRHDR_SZ);
@@ -3866,13 +3866,13 @@ dump_extattr_buildrecord(xfs_bstat_t *statp,
 
 /* ARGSUSED */
 static rv_t
-dump_extattrhdr(drive_t *drivep,
-		 context_t *contextp,
-		 xfs_bstat_t *statp,
-		 size_t recsz,
-		 size_t valoff,
-		 ix_t flags,
-		 uint32_t valsz)
+dump_extattrhdr(drive_t *	drivep,
+		context_t *	contextp,
+		xfs_bstat_t *	statp,
+		size_t		recsz,
+		size_t		valoff,
+		ix_t		flags,
+		uint32_t	valsz)
 {
 	extattrhdr_t ahdr;
 	extattrhdr_t tmpahdr;
@@ -3889,10 +3889,10 @@ dump_extattrhdr(drive_t *drivep,
 
 	xlate_extattrhdr(&ahdr, &tmpahdr, 1);
 	rval = write_buf((char *)&tmpahdr,
-			  EXTATTRHDR_SZ,
-			  (void *)drivep,
-			  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
-			  (wfp_t)drivep->d_opsp->do_write);
+			 EXTATTRHDR_SZ,
+			 (void *)drivep,
+			 (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+			 (wfp_t)drivep->d_opsp->do_write);
 	switch (rval) {
 	case 0:
 		rv = RV_OK;
@@ -3923,10 +3923,10 @@ dump_extattrhdr(drive_t *drivep,
  */
 /* ARGSUSED */
 static rv_t
-dump_file(void *arg1,
-	   jdm_fshandle_t *fshandlep,
-	   int fsfd,
-	   xfs_bstat_t *statp)
+dump_file(void *		arg1,
+	  jdm_fshandle_t *	fshandlep,
+	  int			fsfd,
+	  xfs_bstat_t *		statp)
 {
 	ix_t strmix = (ix_t)arg1;
 	context_t *contextp = &sc_contextp[strmix];
@@ -3951,7 +3951,7 @@ dump_file(void *arg1,
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		mlog(MLOG_DEBUG, "skip as no links for ino %llu\n",
-			statp->bs_ino);
+		     statp->bs_ino);
 		return RV_OK;
 	}
 
@@ -3963,7 +3963,7 @@ dump_file(void *arg1,
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		mlog(MLOG_DEBUG, "skip as ino %llu is prior to starpoint\n",
-			statp->bs_ino);
+		     statp->bs_ino);
 		return RV_OK;
 	}
 
@@ -3971,14 +3971,14 @@ dump_file(void *arg1,
 	 * skip if at or beyond next startpoint. return non-zero to
 	 * abort iteration.
 	 */
-	if (! (endptp->sp_flags & STARTPT_FLAGS_END)) {
+	if (!(endptp->sp_flags & STARTPT_FLAGS_END)) {
 		if (endptp->sp_offset == 0) {
 			if (statp->bs_ino >= endptp->sp_ino) {
 				if (statp->bs_ino > contextp->cc_stat_lastino) {
 					contextp->cc_stat_lastino = statp->bs_ino;
 				}
 				mlog(MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
-					statp->bs_ino);
+				     statp->bs_ino);
 				return RV_NOMORE;
 			}
 		} else {
@@ -3987,7 +3987,7 @@ dump_file(void *arg1,
 					contextp->cc_stat_lastino = statp->bs_ino;
 				}
 				mlog(MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
-					statp->bs_ino);
+				     statp->bs_ino);
 				return RV_NOMORE;
 			}
 		}
@@ -4002,23 +4002,23 @@ dump_file(void *arg1,
 	 * skip if not in inomap
 	 */
 	if (state == MAP_INO_UNUSED
-	     ||
-	     state == MAP_DIR_NOCHNG
-	     ||
-	     state == MAP_NDR_NOCHNG) {
+	    ||
+	    state == MAP_DIR_NOCHNG
+	    ||
+	    state == MAP_NDR_NOCHNG) {
 		if (state == MAP_DIR_NOCHNG) {
 			mlog(MLOG_DEBUG,
-			      "inomap inconsistency ino %llu: "
-			      "MAP_DIR_NOCHNG but is non-dir: skipping\n",
-			      statp->bs_ino);
+			     "inomap inconsistency ino %llu: "
+			     "MAP_DIR_NOCHNG but is non-dir: skipping\n",
+			     statp->bs_ino);
 		}
 		if (statp->bs_ino > contextp->cc_stat_lastino) {
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		mlog(MLOG_DEBUG, "skip as ino %llu is not marked as changed in inomap\n",
-			statp->bs_ino);
+		     statp->bs_ino);
 		mlog(MLOG_DEBUG, "ino %llu is in state %d\n",
-			statp->bs_ino, state);
+		     statp->bs_ino, state);
 		return RV_OK;
 	}
 
@@ -4027,14 +4027,14 @@ dump_file(void *arg1,
 	 */
 	if (state == MAP_DIR_CHANGE || state == MAP_DIR_SUPPRT) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "inomap inconsistency ino %llu: "
-		      "%s but is now non-dir: NOT dumping\n"),
-		      statp->bs_ino,
-		      state == MAP_DIR_CHANGE
-		      ?
-		      "map says changed dir"
-		      :
-		      "map says unchanged dir");
+			     "inomap inconsistency ino %llu: "
+			     "%s but is now non-dir: NOT dumping\n"),
+		     statp->bs_ino,
+		     state == MAP_DIR_CHANGE
+		     ?
+		     "map says changed dir"
+		     :
+		     "map says unchanged dir");
 	}
 
 	/*
@@ -4046,9 +4046,9 @@ dump_file(void *arg1,
 	if (hsm_fs_ctxtp) {
 		if (HsmInitFileContext(contextp->cc_hsm_f_ctxtp, statp)) {
 			mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      "inomap inconsistency ino %llu: "
-			      "hsm detected error: NOT dumping\n"),
-			      statp->bs_ino);
+				     "inomap inconsistency ino %llu: "
+				     "hsm detected error: NOT dumping\n"),
+			     statp->bs_ino);
 			if (statp->bs_ino > contextp->cc_stat_lastino) {
 				contextp->cc_stat_lastino = statp->bs_ino;
 			}
@@ -4083,20 +4083,20 @@ dump_file(void *arg1,
 
 			/* quota files are exempt from max size check */
 			if (estimated_size > maxdumpfilesize &&
-			    !is_quota_file(statp->bs_ino)) {
+			    ! is_quota_file(statp->bs_ino)) {
 				mlog(MLOG_DEBUG | MLOG_NOTE,
-				      "ino %llu increased beyond maximum size: "
-				      "NOT dumping\n",
-				      statp->bs_ino);
+				     "ino %llu increased beyond maximum size: "
+				     "NOT dumping\n",
+				     statp->bs_ino);
 				return RV_OK;
 			}
 		}
 		rv = dump_file_reg(drivep,
-				    contextp,
-				    scwhdrp,
-				    fshandlep,
-				    statp,
-				    &file_skipped);
+				   contextp,
+				   scwhdrp,
+				   fshandlep,
+				   statp,
+				   &file_skipped);
 		if (statp->bs_ino > contextp->cc_stat_lastino) {
 			lock();
 			sc_stat_nondirdone++;
@@ -4129,9 +4129,9 @@ dump_file(void *arg1,
 		 * don't know how to dump these
 		 */
 		mlog(MLOG_VERBOSE, _(
-		      "don't know how to dump ino %llu: mode %08x\n"),
-		      statp->bs_ino,
-		      statp->bs_mode);
+			     "don't know how to dump ino %llu: mode %08x\n"),
+		     statp->bs_ino,
+		     statp->bs_mode);
 		if (statp->bs_ino > contextp->cc_stat_lastino) {
 			lock();
 			sc_stat_nondirdone++;
@@ -4139,19 +4139,19 @@ dump_file(void *arg1,
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		return RV_OK;
-	/*
-	 * not yet implemented
-	case S_IFMNT:
-	 */
+		/*
+		 * not yet implemented
+		   case S_IFMNT:
+		 */
 	}
 
 	if (rv == RV_OK
-	     &&
-	     file_skipped == BOOL_FALSE
-	     &&
-	     sc_dumpextattrpr
-	     &&
-	     (statp->bs_xflags & XFS_XFLAG_HASATTR)) {
+	    &&
+	    file_skipped == BOOL_FALSE
+	    &&
+	    sc_dumpextattrpr
+	    &&
+	    (statp->bs_xflags & XFS_XFLAG_HASATTR)) {
 		rv = dump_extattrs(drivep, contextp, fshandlep, statp);
 	}
 
@@ -4166,12 +4166,12 @@ dump_file(void *arg1,
  * operator requested stop.
  */
 static rv_t
-dump_file_reg(drive_t *drivep,
-	       context_t *contextp,
-	       content_inode_hdr_t *scwhdrp,
-	       jdm_fshandle_t *fshandlep,
-	       xfs_bstat_t *statp,
-	       bool_t *file_skippedp)
+dump_file_reg(drive_t *			drivep,
+	      context_t *		contextp,
+	      content_inode_hdr_t *	scwhdrp,
+	      jdm_fshandle_t *		fshandlep,
+	      xfs_bstat_t *		statp,
+	      bool_t *			file_skippedp)
 {
 	startpt_t *startptp = &scwhdrp->cih_startpt;
 	startpt_t *endptp = &scwhdrp->cih_endpt;
@@ -4179,7 +4179,7 @@ dump_file_reg(drive_t *drivep,
 	bool_t cmpltflg;
 	off64_t offset;
 	off64_t stopoffset;
-	bool_t sosig;	/* stop offset is significant */
+	bool_t sosig;   /* stop offset is significant */
 	off64_t maxextentcnt;
 	rv_t rv;
 
@@ -4213,7 +4213,7 @@ dump_file_reg(drive_t *drivep,
 				register time32_t ctime = statp->bs_ctime.tv_sec;
 				register time32_t ltime = max(mtime, ctime);
 				if (ltime < sc_resumebasetime) {
-					if (rp->dr_begin.sp_offset > offset){
+					if (rp->dr_begin.sp_offset > offset) {
 						offset =rp->dr_begin.sp_offset;
 					}
 				}
@@ -4239,14 +4239,14 @@ dump_file_reg(drive_t *drivep,
 	}
 
 	mlog(MLOG_TRACE,
-	      "dumping regular file ino %llu "
-	      "offset %lld "
-	      "to offset %lld "
-	      "(size %lld)\n",
-	      statp->bs_ino,
-	      offset,
-	      sosig ? stopoffset : statp->bs_size,
-	      statp->bs_size);
+	     "dumping regular file ino %llu "
+	     "offset %lld "
+	     "to offset %lld "
+	     "(size %lld)\n",
+	     statp->bs_ino,
+	     offset,
+	     sosig ? stopoffset : statp->bs_size,
+	     statp->bs_size);
 
 	/*
 	 * calculate the maximum extent group size. files larger than this
@@ -4260,15 +4260,15 @@ dump_file_reg(drive_t *drivep,
 	 * pretending the dump succeeded.
 	 */
 	rv = init_extent_group_context(fshandlep,
-					statp,
-					&extent_group_context);
+				       statp,
+				       &extent_group_context);
 	if (rv != RV_OK) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "could not open regular file ino %llu mode 0x%08x: "
-		      "%s: not dumped\n"),
-		      statp->bs_ino,
-		      statp->bs_mode,
-		      strerror(errno));
+			     "could not open regular file ino %llu mode 0x%08x: "
+			     "%s: not dumped\n"),
+		     statp->bs_ino,
+		     statp->bs_mode,
+		     strerror(errno));
 		*file_skippedp = BOOL_TRUE;
 		return RV_OK;
 	}
@@ -4309,7 +4309,7 @@ dump_file_reg(drive_t *drivep,
 		 * spoof EOF if the media file size is getting too big.
 		 * note that the most we can go over is d_recmarksep.
 		 */
-		if (contextp->cc_mfilesz >= drivep->d_recmfilesz){
+		if (contextp->cc_mfilesz >= drivep->d_recmfilesz) {
 			rv = RV_EOF;
 			break;
 		}
@@ -4319,9 +4319,9 @@ dump_file_reg(drive_t *drivep,
 		 */
 		if (cldmgr_stop_requested()) {
 			mlog(MLOG_NORMAL, _(
-			      "dump interrupted prior to ino %llu offset %lld\n"),
-			      statp->bs_ino,
-			      offset);
+				     "dump interrupted prior to ino %llu offset %lld\n"),
+			     statp->bs_ino,
+			     offset);
 			mlog_exit_hint(RV_INTR);
 			rv = RV_INTR;
 			break;
@@ -4331,9 +4331,9 @@ dump_file_reg(drive_t *drivep,
 		 * dump the file header
 		 */
 		mlog(MLOG_DEBUG,
-		      "dumping extent group ino %llu offset %lld\n",
-		      statp->bs_ino,
-		      offset);
+		     "dumping extent group ino %llu offset %lld\n",
+		     statp->bs_ino,
+		     offset);
 		rv = dump_filehdr(drivep, contextp, statp, offset, 0);
 		if (rv != RV_OK) {
 			break;
@@ -4349,15 +4349,15 @@ dump_file_reg(drive_t *drivep,
 		 */
 		bc = 0; /* for lint */
 		rv = dump_extent_group(drivep,
-					contextp,
-					statp,
-					&extent_group_context,
-					maxextentcnt,
-					stopoffset,
-					sosig,
-					&offset,
-					&bc,
-					&cmpltflg);
+				       contextp,
+				       statp,
+				       &extent_group_context,
+				       maxextentcnt,
+				       stopoffset,
+				       sosig,
+				       &offset,
+				       &bc,
+				       &cmpltflg);
 		assert(bc >= 0);
 		bytecnt += bc;
 		if (rv != RV_OK) {
@@ -4377,11 +4377,11 @@ dump_file_reg(drive_t *drivep,
 		 * end of the file.
 		 */
 		rv = dump_extenthdr(drivep,
-				     contextp,
-				     EXTENTHDR_TYPE_LAST,
-				     0,
-				     0,
-				     0);
+				    contextp,
+				    EXTENTHDR_TYPE_LAST,
+				    0,
+				    0,
+				    0);
 		if (rv != RV_OK) {
 			break;
 		}
@@ -4404,18 +4404,18 @@ dump_file_reg(drive_t *drivep,
  * appends a variable-length string after the filehdr_t.
  */
 static rv_t
-dump_file_spec(drive_t *drivep,
-		context_t *contextp,
-		jdm_fshandle_t *fshandlep,
-		xfs_bstat_t *statp)
+dump_file_spec(drive_t *	drivep,
+	       context_t *	contextp,
+	       jdm_fshandle_t * fshandlep,
+	       xfs_bstat_t *	statp)
 {
 	int rval;
 	rv_t rv;
 
 	mlog(MLOG_TRACE,
-	      "dumping special file ino %llu mode 0x%04x\n",
-	      statp->bs_ino,
-	      statp->bs_mode);
+	     "dumping special file ino %llu mode 0x%04x\n",
+	     statp->bs_ino,
+	     statp->bs_mode);
 
 	/*
 	 * set a mark - important to do this now, before deciding
@@ -4454,13 +4454,13 @@ dump_file_spec(drive_t *drivep,
 		 * the bytes.
 		 */
 		nread = jdm_readlink(fshandlep,
-				      statp,
-				      contextp->cc_readlinkbufp,
-				      contextp->cc_readlinkbufsz);
+				     statp,
+				     contextp->cc_readlinkbufp,
+				     contextp->cc_readlinkbufsz);
 		if (nread < 0) {
 			mlog(MLOG_DEBUG,
-			      "could not read symlink ino %llu\n",
-			      statp->bs_ino);
+			     "could not read symlink ino %llu\n",
+			     statp->bs_ino);
 			nread = 0;
 		}
 
@@ -4476,18 +4476,18 @@ dump_file_spec(drive_t *drivep,
 		 */
 		extentsz = ((size_t)nread + 1 + (SYMLINK_ALIGN - 1))
 			   &
-			   ~ (SYMLINK_ALIGN - 1);
+			   ~(SYMLINK_ALIGN - 1);
 		assert(extentsz <= contextp->cc_readlinkbufsz);
 
 		/*
 		 * dump an extent header
 		 */
 		rv = dump_extenthdr(drivep,
-				     contextp,
-				     EXTENTHDR_TYPE_DATA,
-				     0,
-				     0,
-				     (off64_t)extentsz);
+				    contextp,
+				    EXTENTHDR_TYPE_DATA,
+				    0,
+				    0,
+				    (off64_t)extentsz);
 		if (rv != RV_OK) {
 			return rv;
 		}
@@ -4496,10 +4496,10 @@ dump_file_spec(drive_t *drivep,
 		 * dump the link path extent
 		 */
 		rval = write_buf(contextp->cc_readlinkbufp,
-				  extentsz,
-				  (void *)drivep,
-				  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
-				  (wfp_t)drivep->d_opsp->do_write);
+				 extentsz,
+				 (void *)drivep,
+				 (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+				 (wfp_t)drivep->d_opsp->do_write);
 		switch (rval) {
 		case 0:
 			rv = RV_OK;
@@ -4530,9 +4530,9 @@ dump_file_spec(drive_t *drivep,
  * does anything else.
  */
 static rv_t
-init_extent_group_context(jdm_fshandle_t *fshandlep,
-			   xfs_bstat_t *statp,
-			   extent_group_context_t *gcp)
+init_extent_group_context(jdm_fshandle_t *		fshandlep,
+			  xfs_bstat_t *			statp,
+			  extent_group_context_t *	gcp)
 {
 	bool_t isrealtime;
 	int oflags;
@@ -4564,15 +4564,15 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
 	 * after this check but before all reads have completed.
 	 * This change just closes the window a bit.
 	 */
-	if ((statp->bs_mode & S_ISGID) && (! (statp->bs_mode&S_IXOTH)) ) {
+	if ((statp->bs_mode & S_ISGID) && (!(statp->bs_mode&S_IXOTH)) ) {
 		fl.l_type = F_RDLCK;
 		fl.l_whence = SEEK_SET;
 		fl.l_start = (off_t)0;
 		fl.l_len = 0;
 		if ((fcntl(gcp->eg_fd, F_GETLK, &fl)) < 0) {
 			mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      "locking check failed ino %llu\n"),
-			      statp->bs_ino);
+				     "locking check failed ino %llu\n"),
+			     statp->bs_ino);
 			close(gcp->eg_fd);
 			return RV_ERROR;
 		}
@@ -4593,24 +4593,24 @@ cleanup_extent_group_context(extent_group_context_t *gcp)
 }
 
 static rv_t
-dump_extent_group(drive_t *drivep,
-		   context_t *contextp,
-		   xfs_bstat_t *statp,
-		   extent_group_context_t *gcp,
-		   off64_t maxcnt,
-		   off64_t stopoffset,
-		   bool_t sosig,
-		   off64_t *nextoffsetp,
-		   off64_t *bytecntp,
-		   bool_t *cmpltflgp)
+dump_extent_group(drive_t *			drivep,
+		  context_t *			contextp,
+		  xfs_bstat_t *			statp,
+		  extent_group_context_t *	gcp,
+		  off64_t			maxcnt,
+		  off64_t			stopoffset,
+		  bool_t			sosig,
+		  off64_t *			nextoffsetp,
+		  off64_t *			bytecntp,
+		  bool_t *			cmpltflgp)
 {
 	struct dioattr da;
 	drive_ops_t *dop = drivep->d_opsp;
 	bool_t isrealtime = (bool_t)(statp->bs_xflags
-					&
-					XFS_XFLAG_REALTIME);
+				     &
+				     XFS_XFLAG_REALTIME);
 	off64_t nextoffset;
-	off64_t bytecnt;	/* accumulates total bytes sent to media */
+	off64_t bytecnt;        /* accumulates total bytes sent to media */
 	int rval;
 	rv_t rv;
 
@@ -4620,8 +4620,8 @@ dump_extent_group(drive_t *drivep,
 	if (isrealtime) {
 		if ((ioctl(gcp->eg_fd, XFS_IOC_DIOINFO, &da) < 0)) {
 			mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      "dioinfo failed ino %llu\n"),
-			      statp->bs_ino);
+				     "dioinfo failed ino %llu\n"),
+			     statp->bs_ino);
 			da.d_miniosz = PGSZ;
 		}
 	}
@@ -4642,7 +4642,7 @@ dump_extent_group(drive_t *drivep,
 		 */
 		if (sosig && nextoffset >= stopoffset) {
 			mlog(MLOG_NITTY,
-			      "dumped to stop offset\n");
+			     "dumped to stop offset\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4654,7 +4654,7 @@ dump_extent_group(drive_t *drivep,
 		 */
 		if (nextoffset >= statp->bs_size) {
 			mlog(MLOG_NITTY,
-			      "dumped to end of file\n");
+			     "dumped to end of file\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4668,7 +4668,7 @@ dump_extent_group(drive_t *drivep,
 		 */
 		if (bytecnt >= maxcnt) {
 			mlog(MLOG_NITTY,
-			      "reached per-extent group byte count\n");
+			     "reached per-extent group byte count\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_FALSE;
@@ -4688,21 +4688,21 @@ dump_extent_group(drive_t *drivep,
 			 * get a new extent block
 			 */
 			mlog(MLOG_NITTY,
-			      "calling getbmapx for ino %llu\n",
-			      statp->bs_ino);
+			     "calling getbmapx for ino %llu\n",
+			     statp->bs_ino);
 			rval = ioctl(gcp->eg_fd, XFS_IOC_GETBMAPX, gcp->eg_bmap);
 			gcp->eg_gbmcnt++;
 			entrycnt = gcp->eg_bmap[0].bmv_entries;
 			if (entrycnt < 0) { /* workaround for getbmap bug */
 				mlog(MLOG_DEBUG | MLOG_WARNING, _(
-				      "getbmapx %d ino %lld mode 0x%08x "
-				      "offset %lld ix %d "
-				      "returns negative entry count\n"),
-				      gcp->eg_gbmcnt,
-				      statp->bs_ino,
-				      statp->bs_mode,
-				      nextoffset,
-				      gcp->eg_bmapix);
+					     "getbmapx %d ino %lld mode 0x%08x "
+					     "offset %lld ix %d "
+					     "returns negative entry count\n"),
+				     gcp->eg_gbmcnt,
+				     statp->bs_ino,
+				     statp->bs_mode,
+				     nextoffset,
+				     gcp->eg_bmapix);
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE;
@@ -4710,13 +4710,13 @@ dump_extent_group(drive_t *drivep,
 			}
 			if (rval) {
 				mlog(MLOG_NORMAL | MLOG_WARNING, _(
-				      "getbmapx %d ino %lld mode 0x%08x "
-				      "offset %lld failed: %s\n"),
-				      gcp->eg_gbmcnt,
-				      statp->bs_ino,
-				      statp->bs_mode,
-				      nextoffset,
-				      strerror(errno));
+					     "getbmapx %d ino %lld mode 0x%08x "
+					     "offset %lld failed: %s\n"),
+				     gcp->eg_gbmcnt,
+				     statp->bs_ino,
+				     statp->bs_mode,
+				     nextoffset,
+				     strerror(errno));
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE;
@@ -4730,12 +4730,12 @@ dump_extent_group(drive_t *drivep,
 			 */
 
 			if (hsm_fs_ctxtp) {
-				if (!HsmModifyExtentMap(contextp->cc_hsm_f_ctxtp,
-					&gcp->eg_bmap[0])) {
+				if (! HsmModifyExtentMap(contextp->cc_hsm_f_ctxtp,
+							&gcp->eg_bmap[0])) {
 					mlog(MLOG_NORMAL | MLOG_WARNING, _(
-						"hsm detected an extent map "
-						"error in ino %lld, skipping\n"),
-						statp->bs_ino);
+						     "hsm detected an extent map "
+						     "error in ino %lld, skipping\n"),
+					     statp->bs_ino);
 					*nextoffsetp = nextoffset;
 					*bytecntp = bytecnt;
 					*cmpltflgp = BOOL_TRUE;
@@ -4746,7 +4746,7 @@ dump_extent_group(drive_t *drivep,
 
 			if (entrycnt <= 0) {
 				mlog(MLOG_NITTY,
-				      "all extent groups dumped\n");
+				     "all extent groups dumped\n");
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE;
@@ -4755,17 +4755,17 @@ dump_extent_group(drive_t *drivep,
 			gcp->eg_nextbmapp = &gcp->eg_bmap[1];
 			gcp->eg_endbmapp = &gcp->eg_bmap[entrycnt + 1];
 			mlog(MLOG_NITTY,
-			      "getbmapx supplied %d extent entries\n",
-			      entrycnt);
+			     "getbmapx supplied %d extent entries\n",
+			     entrycnt);
 		}
 
 		mlog(MLOG_NITTY,
-		      "bmap entry %d ix %d block %lld offset %lld length %lld\n",
-		      gcp->eg_nextbmapp - &gcp->eg_bmap[0],
-		      gcp->eg_bmapix,
-		      gcp->eg_nextbmapp->bmv_block,
-		      gcp->eg_nextbmapp->bmv_offset,
-		      gcp->eg_nextbmapp->bmv_length);
+		     "bmap entry %d ix %d block %lld offset %lld length %lld\n",
+		     gcp->eg_nextbmapp - &gcp->eg_bmap[0],
+		     gcp->eg_bmapix,
+		     gcp->eg_nextbmapp->bmv_block,
+		     gcp->eg_nextbmapp->bmv_offset,
+		     gcp->eg_nextbmapp->bmv_length);
 
 		/*
 		 * if the next bmap entry represents a hole, go to the next
@@ -4780,24 +4780,24 @@ dump_extent_group(drive_t *drivep,
 			 * entry
 			 */
 			offset = gcp->eg_nextbmapp->bmv_offset
-					* (off64_t)BBSIZE;
-			extsz  = gcp->eg_nextbmapp->bmv_length
-					* (off64_t)BBSIZE;
+				 * (off64_t)BBSIZE;
+			extsz = gcp->eg_nextbmapp->bmv_length
+				* (off64_t)BBSIZE;
 
 			mlog(MLOG_NITTY,
-			      "hole extent offset = %lld size = %lld\n",
-			      offset, extsz);
+			     "hole extent offset = %lld size = %lld\n",
+			     offset, extsz);
 
 			/*
 			 * Encode the hole - dump the extent header
 			 * with the right extent type.
 			 */
 			rv = dump_extenthdr(drivep,
-					     contextp,
-					     EXTENTHDR_TYPE_HOLE,
-					     0,
-					     offset,
-					     extsz);
+					    contextp,
+					    EXTENTHDR_TYPE_HOLE,
+					    0,
+					    offset,
+					    extsz);
 			if (rv != RV_OK) {
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
@@ -4807,8 +4807,8 @@ dump_extent_group(drive_t *drivep,
 			bytecnt += sizeof(extenthdr_t);
 
 			tmpoffset = (gcp->eg_nextbmapp->bmv_offset
-				      +
-				      gcp->eg_nextbmapp->bmv_length)
+				     +
+				     gcp->eg_nextbmapp->bmv_length)
 				    *
 				    (off64_t)BBSIZE;
 			if (tmpoffset > nextoffset) {
@@ -4827,7 +4827,7 @@ dump_extent_group(drive_t *drivep,
 			off64_t tmpoffset;
 
 			mlog(MLOG_NITTY,
-			      "non-positive extent\n");
+			     "non-positive extent\n");
 			tmpoffset = gcp->eg_nextbmapp->bmv_offset
 				    *
 				    (off64_t)BBSIZE;
@@ -4846,10 +4846,10 @@ dump_extent_group(drive_t *drivep,
 		offset = gcp->eg_nextbmapp->bmv_offset * (off64_t)BBSIZE;
 		extsz = gcp->eg_nextbmapp->bmv_length * (off64_t)BBSIZE;
 		mlog(MLOG_NITTY,
-		      "extent offset %lld sz %lld; nextoffset %lld\n",
-		      offset,
-		      extsz,
-		      nextoffset);
+		     "extent offset %lld sz %lld; nextoffset %lld\n",
+		     offset,
+		     extsz,
+		     nextoffset);
 
 		/*
 		 * if the new bmap entry begins below the stop offset
@@ -4859,7 +4859,7 @@ dump_extent_group(drive_t *drivep,
 		if (! sosig || offset < stopoffset) {
 			if (offset + extsz <= nextoffset) {
 				mlog(MLOG_NITTY,
-				      "extent ends before nextoffset\n");
+				     "extent ends before nextoffset\n");
 				gcp->eg_nextbmapp++;
 				gcp->eg_bmapix++;
 				continue;
@@ -4872,7 +4872,7 @@ dump_extent_group(drive_t *drivep,
 		 */
 		if (offset >= statp->bs_size) {
 			mlog(MLOG_NITTY,
-			      "extent beyond end of file\n");
+			     "extent beyond end of file\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4885,7 +4885,7 @@ dump_extent_group(drive_t *drivep,
 		 */
 		if (sosig && offset >= stopoffset) {
 			mlog(MLOG_NITTY,
-			      "extent beyond stop offset\n");
+			     "extent beyond stop offset\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4902,11 +4902,11 @@ dump_extent_group(drive_t *drivep,
 			extsz -= nextoffset - offset;
 			offset = nextoffset;
 			mlog(MLOG_NITTY,
-			      "adjusted bottom of extent to nextoffset: "
-			      "offset %lld, sz %lld; nextoffset %lld\n",
-			      offset,
-			      extsz,
-			      nextoffset);
+			     "adjusted bottom of extent to nextoffset: "
+			     "offset %lld, sz %lld; nextoffset %lld\n",
+			     offset,
+			     extsz,
+			     nextoffset);
 		}
 		assert(extsz > 0);
 
@@ -4927,13 +4927,13 @@ dump_extent_group(drive_t *drivep,
 				&
 				~(off64_t)(iosz - 1);
 			mlog(MLOG_NITTY,
-			      "adjusted top of extent to honor maxcnt "
-			      "(rounded up %d): "
-			      "offset %lld, sz %lld; maxcnt %lld\n",
-			      iosz,
-			      offset,
-			      extsz,
-			      maxcnt);
+			     "adjusted top of extent to honor maxcnt "
+			     "(rounded up %d): "
+			     "offset %lld, sz %lld; maxcnt %lld\n",
+			     iosz,
+			     offset,
+			     extsz,
+			     maxcnt);
 		}
 
 		/*
@@ -4944,16 +4944,16 @@ dump_extent_group(drive_t *drivep,
 		 */
 		if (extsz <= 0) {
 			mlog(MLOG_NITTY,
-			      "adjusted extent size is non-positive: "
-			      "%lld (bs_size %lld)\n",
-			      extsz,
-			      statp->bs_size);
+			     "adjusted extent size is non-positive: "
+			     "%lld (bs_size %lld)\n",
+			     extsz,
+			     statp->bs_size);
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			if (statp->bs_size == 0) {
-			    *cmpltflgp = BOOL_TRUE;
+				*cmpltflgp = BOOL_TRUE;
 			} else {
-			    *cmpltflgp = BOOL_FALSE;
+				*cmpltflgp = BOOL_FALSE;
 			}
 			return RV_OK;
 		}
@@ -4976,13 +4976,13 @@ dump_extent_group(drive_t *drivep,
 				&
 				~(off64_t)(iosz - 1);
 			mlog(MLOG_NITTY,
-			      "adjusted top of extent to match file size "
-			      "(rounded up %d): "
-			      "offset %lld, sz %lld; bs_size %lld\n",
-			      iosz,
-			      offset,
-			      extsz,
-			      statp->bs_size);
+			     "adjusted top of extent to match file size "
+			     "(rounded up %d): "
+			     "offset %lld, sz %lld; bs_size %lld\n",
+			     iosz,
+			     offset,
+			     extsz,
+			     statp->bs_size);
 		}
 
 		/*
@@ -4992,14 +4992,14 @@ dump_extent_group(drive_t *drivep,
 		if (sosig && (extsz > stopoffset - offset)) {
 			extsz = stopoffset - offset;
 			assert(extsz >= 0);
-			assert(! (extsz & (off64_t)(BBSIZE - 1)));
+			assert(!(extsz & (off64_t)(BBSIZE - 1)));
 			mlog(MLOG_NITTY,
-			      "adjusted top of extent "
-			      "to adhere to stop offset: "
-			      "offset %lld, sz %lld; bs_size %lld\n",
-			      offset,
-			      extsz,
-			      statp->bs_size);
+			     "adjusted top of extent "
+			     "to adhere to stop offset: "
+			     "offset %lld, sz %lld; bs_size %lld\n",
+			     offset,
+			     extsz,
+			     statp->bs_size);
 		}
 
 		/*
@@ -5021,14 +5021,14 @@ dump_extent_group(drive_t *drivep,
 			cnt_to_align -= sizeof(extenthdr_t);
 
 			rv = dump_extenthdr(drivep,
-					     contextp,
-					     EXTENTHDR_TYPE_ALIGN,
-					     0,
-					     0,
-					     (off64_t)
-					     ((size_t)cnt_to_align
-					       -
-					       sizeof(extenthdr_t)));
+					    contextp,
+					    EXTENTHDR_TYPE_ALIGN,
+					    0,
+					    0,
+					    (off64_t)
+					    ((size_t)cnt_to_align
+					     -
+					     sizeof(extenthdr_t)));
 			if (rv != RV_OK) {
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
@@ -5057,11 +5057,11 @@ dump_extent_group(drive_t *drivep,
 		 * dump the extent header
 		 */
 		rv = dump_extenthdr(drivep,
-				     contextp,
-				     EXTENTHDR_TYPE_DATA,
-				     0,
-				     offset,
-				     extsz);
+				    contextp,
+				    EXTENTHDR_TYPE_DATA,
+				    0,
+				    offset,
+				    extsz);
 		if (rv != RV_OK) {
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
@@ -5088,14 +5088,14 @@ dump_extent_group(drive_t *drivep,
 				:
 				(size_t)extsz;
 			bufp = (*dop->do_get_write_buf)(drivep,
-							    reqsz,
-							    &actualsz);
+							reqsz,
+							&actualsz);
 			assert(actualsz <= reqsz);
 			new_off = lseek64(gcp->eg_fd, offset, SEEK_SET);
 			if (new_off == (off64_t)(-1)) {
 				mlog(MLOG_NORMAL, _(
-				      "can't lseek ino %llu\n"),
-				      statp->bs_ino);
+					     "can't lseek ino %llu\n"),
+				     statp->bs_ino);
 				nread = 0;
 			} else {
 				nread = read(gcp->eg_fd, bufp, actualsz);
@@ -5104,23 +5104,23 @@ dump_extent_group(drive_t *drivep,
 #ifdef HIDDEN
 				struct statvfs64 s;
 
- 				/* Be quiet if this is a swap file - #510197 */
+				/* Be quiet if this is a swap file - #510197 */
 				if ((fstatvfs64(gcp->eg_fd, &s) < 0) ||
-				     ((s.f_flag & ST_LOCAL) != 0))
-				   mlog(MLOG_NORMAL, _(
-		"can't read ino %llu at offset %d (act=%d req=%d) rt=%d\n"),
-		statp->bs_ino, new_off, actualsz, reqsz, isrealtime);
+				    ((s.f_flag & ST_LOCAL) != 0))
+					mlog(MLOG_NORMAL, _(
+						     "can't read ino %llu at offset %d (act=%d req=%d) rt=%d\n"),
+					     statp->bs_ino, new_off, actualsz, reqsz, isrealtime);
 #endif /* HIDDEN */
 
 				nread = 0;
 			}
 			assert((size_t)nread <= actualsz);
 			mlog(MLOG_NITTY,
-			      "read ino %llu offset %lld sz %d actual %d\n",
-			      statp->bs_ino,
-			      offset,
-			      actualsz,
-			      nread);
+			     "read ino %llu offset %lld sz %d actual %d\n",
+			     statp->bs_ino,
+			     offset,
+			     actualsz,
+			     nread);
 
 			/*
 			 * must return entire buffer supplied by call to
@@ -5130,13 +5130,13 @@ dump_extent_group(drive_t *drivep,
 			 */
 			if ((size_t)nread < actualsz) {
 				memset((void *)(bufp + nread),
-					0,
-					actualsz - (size_t)nread);
+				       0,
+				       actualsz - (size_t)nread);
 			}
 
 			rval = (*dop->do_write)(drivep,
-						    bufp,
-						    actualsz);
+						bufp,
+						actualsz);
 			switch (rval) {
 			case 0:
 				rv = RV_OK;
@@ -5170,8 +5170,8 @@ dump_extent_group(drive_t *drivep,
 			 */
 			if ((size_t)nread < actualsz) {
 				mlog(MLOG_NITTY,
-				      "padding remaind %lld bytes of extent\n",
-				      extsz);
+				     "padding remaind %lld bytes of extent\n",
+				     extsz);
 				while (extsz) {
 					reqsz = extsz > (off64_t)INTGENMAX
 						?
@@ -5179,7 +5179,7 @@ dump_extent_group(drive_t *drivep,
 						:
 						(size_t)extsz;
 					rv = write_pad(drivep,
-							(size_t)reqsz);
+						       (size_t)reqsz);
 					if (rv != RV_OK) {
 						*nextoffsetp = nextoffset;
 						*bytecntp = bytecnt;
@@ -5200,12 +5200,12 @@ dump_extent_group(drive_t *drivep,
 		 * !!! top of the loop.
 		 */
 		if (nextoffset
-		     >=
-		     gcp->eg_nextbmapp->bmv_offset * (off64_t)BBSIZE
-		     +
-		     gcp->eg_nextbmapp->bmv_length * (off64_t)BBSIZE) {
+		    >=
+		    gcp->eg_nextbmapp->bmv_offset * (off64_t)BBSIZE
+		    +
+		    gcp->eg_nextbmapp->bmv_length * (off64_t)BBSIZE) {
 			mlog(MLOG_NITTY,
-			      "advancing to next extent in bmap\n");
+			     "advancing to next extent in bmap\n");
 			gcp->eg_nextbmapp++;
 			gcp->eg_bmapix++;
 		}
@@ -5244,11 +5244,11 @@ copy_xfs_bstat(bstat_t *dst, xfs_bstat_t *src)
 }
 
 static rv_t
-dump_filehdr(drive_t *drivep,
-	      context_t *contextp,
-	      xfs_bstat_t *statp,
-	      off64_t offset,
-	      int flags)
+dump_filehdr(drive_t *		drivep,
+	     context_t *	contextp,
+	     xfs_bstat_t *	statp,
+	     off64_t		offset,
+	     int		flags)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	register filehdr_t *fhdrp = contextp->cc_filehdrp;
@@ -5269,10 +5269,10 @@ dump_filehdr(drive_t *drivep,
 
 	xlate_filehdr(fhdrp, &tmpfhdrp, 1);
 	rval = write_buf((char *)&tmpfhdrp,
-			  sizeof(tmpfhdrp),
-			  (void *)drivep,
-			  (gwbfp_t)dop->do_get_write_buf,
-			  (wfp_t)dop->do_write);
+			 sizeof(tmpfhdrp),
+			 (void *)drivep,
+			 (gwbfp_t)dop->do_get_write_buf,
+			 (wfp_t)dop->do_write);
 
 	switch (rval) {
 	case 0:
@@ -5295,12 +5295,12 @@ dump_filehdr(drive_t *drivep,
 }
 
 static rv_t
-dump_extenthdr(drive_t *drivep,
-		context_t *contextp,
-		int32_t type,
-		int32_t flags,
-		off64_t offset,
-		off64_t sz)
+dump_extenthdr(drive_t *	drivep,
+	       context_t *	contextp,
+	       int32_t		type,
+	       int32_t		flags,
+	       off64_t		offset,
+	       off64_t		sz)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	register extenthdr_t *ehdrp = contextp->cc_extenthdrp;
@@ -5310,27 +5310,27 @@ dump_extenthdr(drive_t *drivep,
 	char typestr[20];
 
 	switch (type)  {
-		case EXTENTHDR_TYPE_LAST:
-			strcpy(typestr, "LAST");
-			break;
-		case EXTENTHDR_TYPE_ALIGN:
-			strcpy(typestr, "ALIGN");
-			break;
-		case EXTENTHDR_TYPE_DATA:
-			strcpy(typestr, "DATA");
-			break;
-		case EXTENTHDR_TYPE_HOLE:
-			strcpy(typestr, "HOLE");
-			break;
-		default:
-			strcpy(typestr, "UNKNOWN");
+	case EXTENTHDR_TYPE_LAST:
+		strcpy(typestr, "LAST");
+		break;
+	case EXTENTHDR_TYPE_ALIGN:
+		strcpy(typestr, "ALIGN");
+		break;
+	case EXTENTHDR_TYPE_DATA:
+		strcpy(typestr, "DATA");
+		break;
+	case EXTENTHDR_TYPE_HOLE:
+		strcpy(typestr, "HOLE");
+		break;
+	default:
+		strcpy(typestr, "UNKNOWN");
 	}
 
 	mlog(MLOG_DEBUG,
-	      "dumping extent type = %s offset = %lld size = %lld\n",
-	      typestr,
-	      offset,
-	       sz);
+	     "dumping extent type = %s offset = %lld size = %lld\n",
+	     typestr,
+	     offset,
+	     sz);
 
 	(void)memset((void *)ehdrp, 0, sizeof(*ehdrp));
 	ehdrp->eh_type = type;
@@ -5341,10 +5341,10 @@ dump_extenthdr(drive_t *drivep,
 
 	xlate_extenthdr(ehdrp, &tmpehdrp, 1);
 	rval = write_buf((char *)&tmpehdrp,
-			  sizeof(tmpehdrp),
-			  (void *)drivep,
-			  (gwbfp_t)dop->do_get_write_buf,
-			  (wfp_t)dop->do_write);
+			 sizeof(tmpehdrp),
+			 (void *)drivep,
+			 (gwbfp_t)dop->do_get_write_buf,
+			 (wfp_t)dop->do_write);
 
 	switch (rval) {
 	case 0:
@@ -5367,13 +5367,13 @@ dump_extenthdr(drive_t *drivep,
 }
 
 static rv_t
-dump_dirent(drive_t *drivep,
-	     context_t *contextp,
-	     xfs_bstat_t *statp,
-	     xfs_ino_t ino,
-	     gen_t gen,
-	     char *name,
-	     size_t namelen)
+dump_dirent(drive_t *		drivep,
+	    context_t *		contextp,
+	    xfs_bstat_t *	statp,
+	    xfs_ino_t		ino,
+	    gen_t		gen,
+	    char *		name,
+	    size_t		namelen)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	char *outbufp;
@@ -5400,12 +5400,12 @@ dump_dirent(drive_t *drivep,
 
 	if (sz > direntbufsz) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "unable to dump "
-		      "directory %llu entry %s (%llu): "
-		      "name too long\n"),
-		      statp->bs_ino,
-		      name,
-		      ino);
+			     "unable to dump "
+			     "directory %llu entry %s (%llu): "
+			     "name too long\n"),
+		     statp->bs_ino,
+		     name,
+		     ino);
 		mlog_exit_hint(RV_INCOMPLETE);
 		return RV_OK;
 	}
@@ -5454,10 +5454,10 @@ dump_dirent(drive_t *drivep,
 	}
 
 	rval = write_buf(outbufp,
-			  sz,
-			  (void *)drivep,
-			  (gwbfp_t)dop->do_get_write_buf,
-			  (wfp_t)dop->do_write);
+			 sz,
+			 (void *)drivep,
+			 (gwbfp_t)dop->do_get_write_buf,
+			 (wfp_t)dop->do_write);
 	free(outbufp);
 	switch (rval) {
 	case 0:
@@ -5480,10 +5480,10 @@ dump_dirent(drive_t *drivep,
 }
 
 static bool_t
-dump_session_inv(drive_t *drivep,
-		  context_t *contextp,
-		  media_hdr_t *mwhdrp,
-		  content_inode_hdr_t *scwhdrp)
+dump_session_inv(drive_t *		drivep,
+		 context_t *		contextp,
+		 media_hdr_t *		mwhdrp,
+		 content_inode_hdr_t *	scwhdrp)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	ix_t strmix = drivep->d_index;
@@ -5502,7 +5502,7 @@ dump_session_inv(drive_t *drivep,
 	}
 
 	mlog(MLOG_VERBOSE, _(
-	      "dumping session inventory\n"));
+		     "dumping session inventory\n"));
 
 	/*
 	 * get a buffer from the inventory manager
@@ -5512,7 +5512,7 @@ dump_session_inv(drive_t *drivep,
 	ok = inv_get_sessioninfo(sc_inv_sestoken, (void *)&inv_sbufp, &inv_sbufsz);
 	if (! ok) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-		      "unable to get session inventory to dump\n"));
+			     "unable to get session inventory to dump\n"));
 		return BOOL_TRUE;
 	}
 	assert(inv_sbufp);
@@ -5536,7 +5536,7 @@ dump_session_inv(drive_t *drivep,
 		rv_t rv;
 
 		mlog(MLOG_VERBOSE, _(
-		      "beginning inventory media file\n"));
+			     "beginning inventory media file\n"));
 
 		partial = BOOL_FALSE;
 		rv = Media_mfile_begin(drivep, contextp, BOOL_FALSE);
@@ -5545,14 +5545,14 @@ dump_session_inv(drive_t *drivep,
 			break;
 		case RV_TIMEOUT:
 			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
-			      "media change timeout: "
-			      "session inventory not dumped\n"));
+				     "media change timeout: "
+				     "session inventory not dumped\n"));
 			mlog_exit_hint(RV_INV);
 			return BOOL_FALSE;
 		case RV_QUIT:
 			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
-			      "media change declined: "
-			      "session inventory not dumped\n"));
+				     "media change declined: "
+				     "session inventory not dumped\n"));
 			mlog_exit_hint(RV_INV);
 			return BOOL_FALSE;
 		case RV_DRIVE:
@@ -5563,20 +5563,20 @@ dump_session_inv(drive_t *drivep,
 		}
 
 		mlog(MLOG_VERBOSE, _(
-		      "media file %u (media %u, file %u)\n"),
-		      mwhdrp->mh_dumpfileix,
-		      mwhdrp->mh_mediaix,
-		      mwhdrp->mh_mediafileix);
+			     "media file %u (media %u, file %u)\n"),
+		     mwhdrp->mh_dumpfileix,
+		     mwhdrp->mh_mediaix,
+		     mwhdrp->mh_mediafileix);
 
 		uuid_copy(mediaid, mwhdrp->mh_mediaid);
 		strcpy(medialabel, mwhdrp->mh_medialabel);
 		mediafileix = (int)mwhdrp->mh_mediafileix;
 
 		rval = write_buf(inv_sbufp,
-				  inv_sbufsz,
-				  (void *)drivep,
-				  (gwbfp_t)dop->do_get_write_buf,
-				  (wfp_t)dop->do_write);
+				 inv_sbufsz,
+				 (void *)drivep,
+				 (gwbfp_t)dop->do_get_write_buf,
+				 (wfp_t)dop->do_write);
 		switch (rval) {
 		case 0:
 			break;
@@ -5591,13 +5591,13 @@ dump_session_inv(drive_t *drivep,
 		}
 
 		mlog(MLOG_VERBOSE, _(
-		      "ending inventory media file\n"));
+			     "ending inventory media file\n"));
 		ncommitted = 0;
 		rv = Media_mfile_end(drivep,
-				      contextp,
-				      mwhdrp,
-				      &ncommitted,
-				      partial);
+				     contextp,
+				     mwhdrp,
+				     &ncommitted,
+				     partial);
 		switch (rv) {
 		case RV_OK:
 			break;
@@ -5610,14 +5610,14 @@ dump_session_inv(drive_t *drivep,
 
 		if (partial) {
 			mlog(MLOG_VERBOSE, _(
-			      "encountered EOM while writing "
-			      "inventory media file size %lld bytes\n"),
-			      ncommitted);
+				     "encountered EOM while writing "
+				     "inventory media file size %lld bytes\n"),
+			     ncommitted);
 			mlog_exit_hint(RV_INV);
 		} else {
 			mlog(MLOG_VERBOSE, _(
-			      "inventory media file size %lld bytes\n"),
-			      ncommitted);
+				     "inventory media file size %lld bytes\n"),
+			     ncommitted);
 		}
 		if (sc_inv_stmtokenp) {
 			inv_stmt = sc_inv_stmtokenp[strmix];
@@ -5627,23 +5627,23 @@ dump_session_inv(drive_t *drivep,
 
 		if (inv_stmt != INV_TOKEN_NULL) {
 			mlog(MLOG_DEBUG,
-			      "giving inventory "
-			      "session dump media file\n");
+			     "giving inventory "
+			     "session dump media file\n");
 			ok = inv_put_mediafile(inv_stmt,
-						&mediaid,
-						medialabel,
-						(uint)mediafileix,
-						(xfs_ino_t)0,
-						(off64_t)0,
-						(xfs_ino_t)0,
-						(off64_t)0,
-						ncommitted,
-						! partial,
-						BOOL_TRUE);
+					       &mediaid,
+					       medialabel,
+					       (uint)mediafileix,
+					       (xfs_ino_t)0,
+					       (off64_t)0,
+					       (xfs_ino_t)0,
+					       (off64_t)0,
+					       ncommitted,
+					       ! partial,
+					       BOOL_TRUE);
 			if (! ok) {
 				mlog(MLOG_NORMAL, _(
-				      "inventory session media file "
-				      "put failed\n"));
+					     "inventory session media file "
+					     "put failed\n"));
 				return BOOL_FALSE;
 			}
 		}
@@ -5668,7 +5668,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 	}
 
 	mlog(MLOG_VERBOSE, _(
-	      "writing stream terminator\n"));
+		     "writing stream terminator\n"));
 
 	/*
 	 * modify the write header to indicate a terminator
@@ -5685,7 +5685,7 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 		rv_t rv;
 
 		mlog(MLOG_VERBOSE, _(
-		      "beginning media stream terminator\n"));
+			     "beginning media stream terminator\n"));
 
 		partial = BOOL_FALSE;
 		rv = Media_mfile_begin(drivep, contextp, BOOL_FALSE);
@@ -5694,13 +5694,13 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 			break;
 		case RV_TIMEOUT:
 			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
-			      "media change timeout: "
-			      "media stream terminator not written\n"));
+				     "media change timeout: "
+				     "media stream terminator not written\n"));
 			return;
 		case RV_QUIT:
 			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
-			      "media change declined: "
-			      "media stream terminator not written\n"));
+				     "media change declined: "
+				     "media stream terminator not written\n"));
 			return;
 		case RV_DRIVE:
 		case RV_ERROR:
@@ -5710,19 +5710,19 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 		}
 
 		mlog(MLOG_VERBOSE, _(
-		      "media file %u (media %u, file %u)\n"),
-		      mwhdrp->mh_dumpfileix,
-		      mwhdrp->mh_mediaix,
-		      mwhdrp->mh_mediafileix);
+			     "media file %u (media %u, file %u)\n"),
+		     mwhdrp->mh_dumpfileix,
+		     mwhdrp->mh_mediaix,
+		     mwhdrp->mh_mediafileix);
 
 		mlog(MLOG_VERBOSE, _(
-		      "ending media stream terminator\n"));
+			     "ending media stream terminator\n"));
 		ncommitted = 0;
 		rv = Media_mfile_end(drivep,
-				      contextp,
-				      mwhdrp,
-				      &ncommitted,
-				      BOOL_FALSE);
+				     contextp,
+				     mwhdrp,
+				     &ncommitted,
+				     BOOL_FALSE);
 		switch (rv) {
 		case RV_OK:
 			break;
@@ -5735,13 +5735,13 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 
 		if (partial) {
 			mlog(MLOG_VERBOSE, _(
-			      "encountered EOM while writing "
-			      "media stream terminator size %lld bytes\n"),
-			      ncommitted);
+				     "encountered EOM while writing "
+				     "media stream terminator size %lld bytes\n"),
+			     ncommitted);
 		} else {
 			mlog(MLOG_VERBOSE, _(
-			      "media stream terminator size %lld bytes\n"),
-			      ncommitted);
+				     "media stream terminator size %lld bytes\n"),
+			     ncommitted);
 		}
 
 		done = ! partial;
@@ -5756,10 +5756,10 @@ write_pad(drive_t *drivep, size_t sz)
 	rv_t rv;
 
 	rval = write_buf(0,
-			  sz,
-			  (void *)drivep,
-			  (gwbfp_t)dop->do_get_write_buf,
-			  (wfp_t)dop->do_write);
+			 sz,
+			 (void *)drivep,
+			 (gwbfp_t)dop->do_get_write_buf,
+			 (wfp_t)dop->do_write);
 
 	switch (rval) {
 	case 0:
@@ -5792,23 +5792,23 @@ inv_cleanup(void)
 		inv_stmtoken_t *inv_stmtp;
 		context_t *contextp;
 		for (strmix = 0,
-		      inv_stmtp = sc_inv_stmtokenp,
-		      contextp = sc_contextp
+		     inv_stmtp = sc_inv_stmtokenp,
+		     contextp = sc_contextp
 		     ;
-		      strmix < drivecnt
+		     strmix < drivecnt
 		     ;
-		      strmix++,
-		      inv_stmtp++,
-		      contextp++) {
+		     strmix++,
+		     inv_stmtp++,
+		     contextp++) {
 			bool_t interrupted;
 			interrupted = ! contextp->cc_completepr;
 			if (*inv_stmtp == INV_TOKEN_NULL) {
 				continue;
 			}
 			mlog(MLOG_DEBUG,
-			      "closing inventory stream %d%s\n",
-			      strmix,
-			      interrupted ? ": interrupted" : "");
+			     "closing inventory stream %d%s\n",
+			     strmix,
+			     interrupted ? ": interrupted" : "");
 			if (interrupted) mlog_exit_hint(RV_INTR);
 			ok = inv_stream_close(*inv_stmtp, interrupted);
 			assert(ok);
@@ -5861,7 +5861,7 @@ Media_mfile_begin(drive_t *drivep, context_t *contextp, bool_t intr_allowed)
 	assert(BES_INIT == 0);
 
 	mlog(MLOG_DEBUG | MLOG_MEDIA,
-	      "Media op: begin media file\n");
+	     "Media op: begin media file\n");
 
 	/*
 	 * the command line-specified media label is good only for the
@@ -5945,18 +5945,18 @@ position:
 		case 0:
 			mlog_lock();
 			mlog(MLOG_VERBOSE | MLOG_NOLOCK | MLOG_MEDIA, _(
-			      "positioned at media file %u: "
-			      "dump %u, "
-			      "stream %u\n"),
-			      mrhdrp->mh_mediafileix,
-			      mrhdrp->mh_dumpmediaix,
-			      drhdrp->dh_driveix);
+				     "positioned at media file %u: "
+				     "dump %u, "
+				     "stream %u\n"),
+			     mrhdrp->mh_mediafileix,
+			     mrhdrp->mh_dumpmediaix,
+			     drhdrp->dh_driveix);
 			mlog(MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
-			      "stream media file %u (%u in object), "
-			      "stream media object %d\n",
-			      mrhdrp->mh_dumpfileix,
-			      mrhdrp->mh_dumpmediafileix,
-			      mrhdrp->mh_mediaix);
+			     "stream media file %u (%u in object), "
+			     "stream media object %d\n",
+			     mrhdrp->mh_dumpfileix,
+			     mrhdrp->mh_dumpmediafileix,
+			     mrhdrp->mh_mediaix);
 			mlog_unlock();
 
 			/*
@@ -5982,9 +5982,9 @@ position:
 			(*dop->do_end_read)(drivep);
 
 			switch (Media_erasechk(drivep,
-						dcaps,
-						intr_allowed,
-						prevmediapresentpr)) {
+					       dcaps,
+					       intr_allowed,
+					       prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -5995,20 +5995,20 @@ position:
 
 			if ((int32_t)mwhdrp->mh_mediaix >= 0) {
 				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "cannot interleave dump streams: "
-				      "must supply a blank media object\n"));
+					     "cannot interleave dump streams: "
+					     "must supply a blank media object\n"));
 				goto changemedia;
 			}
-			if (! (dcaps & DRIVE_CAP_APPEND)) {
+			if (!(dcaps & DRIVE_CAP_APPEND)) {
 				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
-				      "media contains valid xfsdump "
-				      "but does not support append\n"));
+					     "media contains valid xfsdump "
+					     "but does not support append\n"));
 				goto changemedia;
 			}
 			if (MEDIA_TERMINATOR_CHK(mrhdrp)) {
 				int status;
 				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
-				      "stream terminator found\n"));
+					     "stream terminator found\n"));
 				assert(contextp->cc_Media_useterminatorpr);
 				assert(dcaps & DRIVE_CAP_BSF); /* redundant */
 				status = 0;
@@ -6016,8 +6016,8 @@ position:
 				assert(rval == 0);
 				if (status == DRIVE_ERROR_DEVICE) {
 					mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
-					      "encountered media error "
-					      "attempting BSF\n"));
+						     "encountered media error "
+						     "attempting BSF\n"));
 					goto changemedia;
 				}
 				if (mrhdrp->mh_mediafileix == 0) {
@@ -6030,15 +6030,15 @@ position:
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-			      "media contains non-xfsdump data "
-			      "or a corrupt xfsdump media file header "
-			      "at beginning of media\n"));
+				     "media contains non-xfsdump data "
+				     "or a corrupt xfsdump media file header "
+				     "at beginning of media\n"));
 			mlog_exit_hint(RV_CORRUPT);
 
 			switch (Media_erasechk(drivep,
-						dcaps,
-						intr_allowed,
-						prevmediapresentpr)) {
+					       dcaps,
+					       intr_allowed,
+					       prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -6058,14 +6058,14 @@ position:
 				}
 			}
 
-			if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
+			if (!(dcaps & DRIVE_CAP_OVERWRITE)) {
 				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "unable to overwrite\n"));
+					     "unable to overwrite\n"));
 				goto changemedia;
 			} else {
 				int status;
 				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "repositioning to overwrite\n"));
+					     "repositioning to overwrite\n"));
 				assert(dcaps & DRIVE_CAP_BSF);
 				status = 0;
 				rval = (*dop->do_bsf)(drivep, 0, &status);
@@ -6083,8 +6083,8 @@ position:
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				"media may contain data. "
-				"Overwrite option specified\n"));
+				     "media may contain data. "
+				     "Overwrite option specified\n"));
 
 			if (dlog_allowed()) {
 				bool_t ok;
@@ -6111,15 +6111,15 @@ position:
 			return RV_DRIVE;
 		case DRIVE_ERROR_EOD:
 			mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
-			      "at end of data\n"));
+				     "at end of data\n"));
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
 			virginmediapr = BOOL_FALSE;
 
 			switch (Media_erasechk(drivep,
-						dcaps,
-						intr_allowed,
-						prevmediapresentpr)) {
+					       dcaps,
+					       intr_allowed,
+					       prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -6130,9 +6130,9 @@ position:
 
 			if (contextp->cc_Media_useterminatorpr) {
 				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "encountered EOD but expecting a media "
-				      "stream terminator: "
-				      "assuming full media\n"));
+					     "encountered EOD but expecting a media "
+					     "stream terminator: "
+					     "assuming full media\n"));
 				goto changemedia;
 			} else {
 				goto write;
@@ -6142,12 +6142,12 @@ position:
 			mediapresentpr = BOOL_TRUE;
 			virginmediapr = BOOL_FALSE;
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-			      "encountered EOM: media is full\n"));
+				     "encountered EOM: media is full\n"));
 
 			switch (Media_erasechk(drivep,
-						dcaps,
-						intr_allowed,
-						prevmediapresentpr)) {
+					       dcaps,
+					       intr_allowed,
+					       prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -6165,14 +6165,14 @@ position:
 			virginmediapr = BOOL_FALSE;
 
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-			      "encountered corrupt or foreign data: "
-			      "assuming corrupted media\n"));
+				     "encountered corrupt or foreign data: "
+				     "assuming corrupted media\n"));
 			mlog_exit_hint(RV_CORRUPT);
 
 			switch (Media_erasechk(drivep,
-						dcaps,
-						intr_allowed,
-						prevmediapresentpr)) {
+					       dcaps,
+					       intr_allowed,
+					       prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -6183,24 +6183,24 @@ position:
 
 			if (contextp->cc_Media_useterminatorpr) {
 				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "encountered corrupt or foreign data "
-				      "but expecting a media "
-				      "stream terminator: "
-				      "assuming corrupted media\n"));
+					     "encountered corrupt or foreign data "
+					     "but expecting a media "
+					     "stream terminator: "
+					     "assuming corrupted media\n"));
 				mlog_exit_hint(RV_CORRUPT);
 				goto changemedia;
-			} else if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
+			} else if (!(dcaps & DRIVE_CAP_OVERWRITE)) {
 				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "encountered corrupt or foreign data: "
-				      "unable to overwrite: "
-				      "assuming corrupted media\n"));
+					     "encountered corrupt or foreign data: "
+					     "unable to overwrite: "
+					     "assuming corrupted media\n"));
 				mlog_exit_hint(RV_CORRUPT);
 				goto changemedia;
 			} else {
 				int status;
 				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "encountered corrupt or foreign data: "
-				      "repositioning to overwrite\n"));
+					     "encountered corrupt or foreign data: "
+					     "repositioning to overwrite\n"));
 				mlog_exit_hint(RV_CORRUPT);
 				assert(dcaps & DRIVE_CAP_BSF);
 				status = 0;
@@ -6218,8 +6218,8 @@ position:
 		case DRIVE_ERROR_EOF:
 		default:
 			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
-			      "unexpected error from do_begin_read: %d\n"),
-			      rval);
+				     "unexpected error from do_begin_read: %d\n"),
+			     rval);
 			return RV_CORE;
 		}
 	}
@@ -6227,7 +6227,7 @@ position:
 
 erasemedia:
 	mlog(MLOG_VERBOSE | MLOG_WARNING | MLOG_MEDIA, _(
-	      "erasing media\n"));
+		     "erasing media\n"));
 	rval = (*dop->do_erase)(drivep);
 	if (rval) {
 		return RV_DRIVE;
@@ -6242,7 +6242,7 @@ changemedia:
 	/*
 	 * if the drive does not support media change, quit.
 	 */
-	if (! (dcaps & DRIVE_CAP_REMOVABLE)) {
+	if (!(dcaps & DRIVE_CAP_REMOVABLE)) {
 		return RV_ERROR;
 	}
 
@@ -6270,7 +6270,7 @@ changemedia:
 	 * If an alert program has been specified, run it
 	 */
 	if (media_change_alert_program != NULL)
-	   system(media_change_alert_program);
+		system(media_change_alert_program);
 
 	/*
 	 * if media change prompt declined or times out,
@@ -6280,9 +6280,9 @@ changemedia:
 		ix_t thrdix = drivep->d_index;
 		assert(sistr);
 		mlog(MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
-		      "please change media: "
-		      "type %s to confirm media change\n"),
-		      sistr);
+			     "please change media: "
+			     "type %s to confirm media change\n"),
+		     sistr);
 		set_mcflag(thrdix);
 		while (sc_mcflag[thrdix]) {
 			sleep(2);
@@ -6362,13 +6362,13 @@ write:
 	 * do not allow interleaving of media files from different xfsdumps.
 	 */
 	if (mwhdrp->mh_mediaix != 0
-	     &&
-	     mwhdrp->mh_dumpmediafileix == 0
-	     &&
-	     ! virginmediapr) {
+	    &&
+	    mwhdrp->mh_dumpmediafileix == 0
+	    &&
+	    ! virginmediapr) {
 		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-		      "cannot interleave dump streams: must supply a blank "
-		      "media object\n"));
+			     "cannot interleave dump streams: must supply a blank "
+			     "media object\n"));
 		*gwhdrp = saved_gwhdr;
 		goto changemedia;
 	}
@@ -6379,8 +6379,8 @@ write:
 	if (! mediawrittentopr && mwhdrp->mh_dumpfileix != 0) {
 		uuid_copy(mwhdrp->mh_prevmediaid, mwhdrp->mh_mediaid);
 		(void)strncpyterm(mwhdrp->mh_prevmedialabel,
-				     mwhdrp->mh_medialabel,
-				     sizeof(mwhdrp->mh_medialabel));
+				  mwhdrp->mh_medialabel,
+				  sizeof(mwhdrp->mh_medialabel));
 	}
 
 	/*
@@ -6393,42 +6393,42 @@ write:
 			uuid_generate(mwhdrp->mh_mediaid);
 
 			if (! cmdlinemedialabel
-			     &&
-			     ! drivep->d_isnamedpipepr
-			     &&
-			     ! drivep->d_isunnamedpipepr
-			     &&
-			     dlog_allowed()) {
+			    &&
+			    ! drivep->d_isnamedpipepr
+			    &&
+			    ! drivep->d_isunnamedpipepr
+			    &&
+			    dlog_allowed()) {
 				cmdlinemedialabel = Media_prompt_label(drivep,
-							labelbuf,
-							sizeof(labelbuf));
+								       labelbuf,
+								       sizeof(labelbuf));
 				if (intr_allowed && cldmgr_stop_requested()) {
 					return RV_INTR;
 				}
 			}
 			if (cmdlinemedialabel && strlen(cmdlinemedialabel)) {
 				(void)strncpyterm(mwhdrp->mh_medialabel,
-						     cmdlinemedialabel,
-					       sizeof(mwhdrp->mh_medialabel));
+						  cmdlinemedialabel,
+						  sizeof(mwhdrp->mh_medialabel));
 			} else {
 				(void)memset((void *)mwhdrp->mh_medialabel,
-						     0,
-					       sizeof(mwhdrp->mh_medialabel));
+					     0,
+					     sizeof(mwhdrp->mh_medialabel));
 				if (! pipeline) {
 					mlog(MLOG_VERBOSE
-					      |
-					      MLOG_WARNING
-					      |
-					      MLOG_MEDIA, _(
-					      "no media label specified\n"));
+					     |
+					     MLOG_WARNING
+					     |
+					     MLOG_MEDIA, _(
+						     "no media label specified\n"));
 				}
 			}
 		} else {
 			assert(! virginmediapr);
 			uuid_copy(mwhdrp->mh_mediaid, mrhdrp->mh_mediaid);
 			(void)strncpyterm(mwhdrp->mh_medialabel,
-					     mrhdrp->mh_medialabel,
-					     sizeof(mwhdrp->mh_medialabel));
+					  mrhdrp->mh_medialabel,
+					  sizeof(mwhdrp->mh_medialabel));
 		}
 	}
 
@@ -6446,8 +6446,8 @@ write:
 		return RV_OK;
 	case DRIVE_ERROR_EOM:
 		mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
-		      "encountered end of media "
-		      "while attempting to begin new media file\n"));
+			     "encountered end of media "
+			     "while attempting to begin new media file\n"));
 		*gwhdrp = saved_gwhdr;
 		goto changemedia;
 	case DRIVE_ERROR_MEDIA:
@@ -6462,17 +6462,17 @@ write:
 
 /* ARGSUSED */
 static rv_t
-Media_mfile_end(drive_t *drivep,
-		 context_t *contextp,
-		 media_hdr_t *mwhdrp,
-		 off64_t *ncommittedp,
-		 bool_t hit_eom)
+Media_mfile_end(drive_t *	drivep,
+		context_t *	contextp,
+		media_hdr_t *	mwhdrp,
+		off64_t *	ncommittedp,
+		bool_t		hit_eom)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	int rval;
 
 	mlog(MLOG_DEBUG | MLOG_MEDIA,
-	      "Media op: end media file\n");
+	     "Media op: end media file\n");
 
 	assert(contextp->cc_Media_begin_entrystate == BES_INVAL);
 
@@ -6493,8 +6493,8 @@ Media_mfile_end(drive_t *drivep,
 	case DRIVE_ERROR_MEDIA:
 	case DRIVE_ERROR_EOM:
 		mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
-		      "encountered end of media "
-		      "while ending media file\n"));
+			     "encountered end of media "
+			     "while ending media file\n"));
 		mlog_exit_hint(RV_EOM);
 		contextp->cc_Media_begin_entrystate = BES_ENDEOM;
 		return RV_EOM;
@@ -6541,9 +6541,9 @@ retry:
 	 * query: ask if overwrite ok
 	 */
 	sprintf(question,
-		 "overwrite data on media in "
-		 "drive %u?\n",
-		 (unsigned int)drivep->d_index);
+		"overwrite data on media in "
+		"drive %u?\n",
+		(unsigned int)drivep->d_index);
 	querycnt = 0;
 	querystr[querycnt++] = question;
 	assert(querycnt <= QUERYMAX);
@@ -6556,18 +6556,18 @@ retry:
 	sigintix = IXMAX - 1;
 
 	responseix = dlog_multi_query(querystr,
-				       querycnt,
-				       choicestr,
-				       choicecnt,
-				       0,           /* hilitestr */
-				       IXMAX,       /* hiliteix */
-				       0,           /* defaultstr */
-				       doix,        /* defaultix */
-				       DLOG_TIMEOUT_MEDIA,
-				       dontix,		/* timeout ix */
-				       sigintix,	/* sigint ix */
-				       dontix,		/* sighup ix */
-				       dontix);	/* sigquit ix */
+				      querycnt,
+				      choicestr,
+				      choicecnt,
+				      0,        /* hilitestr */
+				      IXMAX,    /* hiliteix */
+				      0,        /* defaultstr */
+				      doix,     /* defaultix */
+				      DLOG_TIMEOUT_MEDIA,
+				      dontix,   /* timeout ix */
+				      sigintix, /* sigint ix */
+				      dontix,   /* sighup ix */
+				      dontix);  /* sigquit ix */
 	ackcnt = 0;
 	if (responseix == doix) {
 		ackstr[ackcnt++] = "media will be overwritten\n";
@@ -6578,7 +6578,7 @@ retry:
 	}
 	assert(ackcnt <= ACKMAX);
 	dlog_multi_ack(ackstr,
-			ackcnt);
+		       ackcnt);
 
 	postamblecnt = 0;
 	fold_init(fold, "end dialog", '-');
@@ -6587,21 +6587,21 @@ retry:
 	postamblestr[postamblecnt++] = "\n\n";
 	assert(postamblecnt <= POSTAMBLEMAX);
 	dlog_end(postamblestr,
-		  postamblecnt);
+		 postamblecnt);
 
 	if (responseix == sigintix) {
 		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		sleep(1); /* to allow main thread to begin dialog */
+		sleep(1);       /* to allow main thread to begin dialog */
 		mlog(MLOG_NORMAL | MLOG_BARE,
-		      ""); /* to block until main thread dialog complete */
-		sleep(1); /* to allow main thread to request children die */
+		     "");       /* to block until main thread dialog complete */
+		sleep(1);       /* to allow main thread to request children die */
 		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
 		mlog(MLOG_DEBUG,
-		      "retrying media overwrite dialog\n");
+		     "retrying media overwrite dialog\n");
 		goto retry;
 	}
 
@@ -6611,9 +6611,9 @@ retry:
 
 static rv_t
 Media_erasechk(drive_t *drivep,
-		int dcaps,
-		bool_t intr_allowed,
-		bool_t prevmediapresentpr)
+	       int	dcaps,
+	       bool_t	intr_allowed,
+	       bool_t	prevmediapresentpr)
 {
 	if (prevmediapresentpr == BOOL_TRUE) {
 		return RV_NOTOK;
@@ -6637,9 +6637,9 @@ Media_erasechk(drive_t *drivep,
 			}
 		} else {
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-			      "drive does not support media erase: "
-			      "ignoring -%c option\n"),
-			      GETOPT_ERASE);
+				     "drive does not support media erase: "
+				     "ignoring -%c option\n"),
+			     GETOPT_ERASE);
 			return RV_NOTOK;
 		}
 	} else {
@@ -6680,12 +6680,12 @@ retry:
 	 * query: ask if overwrite ok
 	 */
 	sprintf(question,
-		 "pre-erase (-%c) option specified "
-		 "and non-blank media encountered:\n"
-		 "please confirm media erase "
-		 "drive %u\n",
-		 GETOPT_ERASE,
-		 (unsigned int)drivep->d_index);
+		"pre-erase (-%c) option specified "
+		"and non-blank media encountered:\n"
+		"please confirm media erase "
+		"drive %u\n",
+		GETOPT_ERASE,
+		(unsigned int)drivep->d_index);
 	querycnt = 0;
 	querystr[querycnt++] = question;
 	assert(querycnt <= QUERYMAX);
@@ -6698,18 +6698,18 @@ retry:
 	sigintix = IXMAX - 1;
 
 	responseix = dlog_multi_query(querystr,
-				       querycnt,
-				       choicestr,
-				       choicecnt,
-				       0,           /* hilitestr */
-				       IXMAX,       /* hiliteix */
-				       0,           /* defaultstr */
-				       doix,        /* defaultix */
-				       DLOG_TIMEOUT_MEDIA,
-				       dontix,		/* timeout ix */
-				       sigintix,	/* sigint ix */
-				       dontix,		/* sighup ix */
-				       dontix);	/* sigquit ix */
+				      querycnt,
+				      choicestr,
+				      choicecnt,
+				      0,        /* hilitestr */
+				      IXMAX,    /* hiliteix */
+				      0,        /* defaultstr */
+				      doix,     /* defaultix */
+				      DLOG_TIMEOUT_MEDIA,
+				      dontix,   /* timeout ix */
+				      sigintix, /* sigint ix */
+				      dontix,   /* sighup ix */
+				      dontix);  /* sigquit ix */
 	ackcnt = 0;
 	if (responseix == doix) {
 		ackstr[ackcnt++] = "media will be erased\n";
@@ -6720,7 +6720,7 @@ retry:
 	}
 	assert(ackcnt <= ACKMAX);
 	dlog_multi_ack(ackstr,
-			ackcnt);
+		       ackcnt);
 
 	postamblecnt = 0;
 	fold_init(fold, "end dialog", '-');
@@ -6729,21 +6729,21 @@ retry:
 	postamblestr[postamblecnt++] = "\n\n";
 	assert(postamblecnt <= POSTAMBLEMAX);
 	dlog_end(postamblestr,
-		  postamblecnt);
+		 postamblecnt);
 
 	if (responseix == sigintix) {
 		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		sleep(1); /* to allow main thread to begin dialog */
+		sleep(1);       /* to allow main thread to begin dialog */
 		mlog(MLOG_NORMAL | MLOG_BARE,
-		      ""); /* to block until main thread dialog complete */
-		sleep(1); /* to allow main thread to request children die */
+		     "");       /* to block until main thread dialog complete */
+		sleep(1);       /* to allow main thread to request children die */
 		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
 		mlog(MLOG_DEBUG,
-		      "retrying media erase dialog\n");
+		     "retrying media erase dialog\n");
 		goto retry;
 	}
 
@@ -6760,9 +6760,9 @@ Media_prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 	 * query: ask for a label
 	 */
 	(*pcb)(pctxp,
-		   "please enter label for media in "
-		   "drive %u",
-		   drivep->d_index);
+	       "please enter label for media in "
+	       "drive %u",
+	       drivep->d_index);
 }
 
 static char *
@@ -6791,15 +6791,15 @@ retry:
 	dlog_begin(preamblestr, preamblecnt);
 
 	responseix = dlog_string_query(Media_prompt_label_cb,
-					(void *)drivep,
-					bufp,
-					bufsz,
-					DLOG_TIMEOUT,
-					timeoutix,/* timeout ix */
-					sigintix, /* sigint ix */
-					abortix,  /* sighup ix */
-					abortix,  /* sigquit ix */
-					okix);   /* ok ix */
+				       (void *)drivep,
+				       bufp,
+				       bufsz,
+				       DLOG_TIMEOUT,
+				       timeoutix,       /* timeout ix */
+				       sigintix,        /* sigint ix */
+				       abortix,         /* sighup ix */
+				       abortix,         /* sigquit ix */
+				       okix);           /* ok ix */
 	ackcnt = 0;
 	if (responseix == okix) {
 		ackstr[ackcnt++] = "media label entered: \"";
@@ -6815,7 +6815,7 @@ retry:
 
 	assert(ackcnt <= ACKMAX);
 	dlog_string_ack(ackstr,
-			 ackcnt);
+			ackcnt);
 
 	postamblecnt = 0;
 	fold_init(fold, "end dialog", '-');
@@ -6824,21 +6824,21 @@ retry:
 	postamblestr[postamblecnt++] = "\n\n";
 	assert(postamblecnt <= POSTAMBLEMAX);
 	dlog_end(postamblestr,
-		  postamblecnt);
+		 postamblecnt);
 
 	if (responseix == sigintix) {
 		if (cldmgr_stop_requested()) {
 			return 0;
 		}
-		sleep(1); /* to allow main thread to begin dialog */
+		sleep(1);       /* to allow main thread to begin dialog */
 		mlog(MLOG_NORMAL | MLOG_BARE,
-		      ""); /* to block until main thread dialog complete */
-		sleep(1); /* to allow main thread to request children die */
+		     "");       /* to block until main thread dialog complete */
+		sleep(1);       /* to allow main thread to request children die */
 		if (cldmgr_stop_requested()) {
 			return 0;
 		}
 		mlog(MLOG_DEBUG,
-		      "retrying media label dialog\n");
+		     "retrying media label dialog\n");
 		goto retry;
 	}
 
@@ -6908,65 +6908,65 @@ is_quota_file(ino_t ino)
 static bool_t
 save_quotas(char *mntpnt, quota_info_t *quotainfo)
 {
-        int             sts = 0;
-        char            buf[1024] = "";
-        int             fd;
-        char            tmp;
-        struct stat     statb;
-
-        mlog(MLOG_VERBOSE, _(
-		"saving %s information for: %s\n"), quotainfo->desc, mntpnt);
-
-        if (unlink(quotainfo->quotapath) == 0) {
-            mlog(MLOG_WARNING, _("overwriting: %s\n"), quotainfo->quotapath);
-        }
-        else {
-            if (errno != ENOENT) {
-                mlog(MLOG_ERROR, _(
-                      "unable to remove %s: %s\n"),
-                      quotainfo->quotapath,
-                      strerror(errno));
-                return BOOL_FALSE;
-            }
-        }
-
-        sprintf(buf,
-		 "%s -x -c 'dump %s %s' %s 2> /dev/null",
-		 REPQUOTA,
-                 quotainfo->repquotaargs,
-                 quotainfo->quotapath,
-                 mntpnt);
-
-        mlog(MLOG_NITTY, "saving quotas: %s\n", buf);
-
-        sts = system(buf);
-        if (sts != 0) {
-            mlog(MLOG_ERROR, _(
-                  "%s failed with exit status: %d\n"), REPQUOTA,
-		  sts == -1 ? -1 : WEXITSTATUS(sts));
-            return BOOL_FALSE;
-        }
-        if ((fd = open(quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
-            mlog(MLOG_ERROR, _(
-                  "open failed %s: %s\n"),
-                  quotainfo->quotapath,
-                  strerror(errno));
-            return BOOL_FALSE;
-        }
-        if (fstat(fd, &statb) < 0) {
-            mlog(MLOG_ERROR, _(
-                  "stat failed %s: %s\n"),
-                  quotainfo->quotapath,
-                  strerror(errno));
-            close(fd);
-            return BOOL_FALSE;
-        }
-        quotainfo->quotaino = statb.st_ino;
-
-        /* open and read dump file to ensure it is in the dump */
-        read(fd, &tmp, 1);
-        close(fd);
-        return BOOL_TRUE;
+	int sts = 0;
+	char buf[1024] = "";
+	int fd;
+	char tmp;
+	struct stat statb;
+
+	mlog(MLOG_VERBOSE, _(
+		     "saving %s information for: %s\n"), quotainfo->desc, mntpnt);
+
+	if (unlink(quotainfo->quotapath) == 0) {
+		mlog(MLOG_WARNING, _("overwriting: %s\n"), quotainfo->quotapath);
+	}
+	else {
+		if (errno != ENOENT) {
+			mlog(MLOG_ERROR, _(
+				     "unable to remove %s: %s\n"),
+			     quotainfo->quotapath,
+			     strerror(errno));
+			return BOOL_FALSE;
+		}
+	}
+
+	sprintf(buf,
+		"%s -x -c 'dump %s %s' %s 2> /dev/null",
+		REPQUOTA,
+		quotainfo->repquotaargs,
+		quotainfo->quotapath,
+		mntpnt);
+
+	mlog(MLOG_NITTY, "saving quotas: %s\n", buf);
+
+	sts = system(buf);
+	if (sts != 0) {
+		mlog(MLOG_ERROR, _(
+			     "%s failed with exit status: %d\n"), REPQUOTA,
+		     sts == -1 ? -1 : WEXITSTATUS(sts));
+		return BOOL_FALSE;
+	}
+	if ((fd = open(quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
+		mlog(MLOG_ERROR, _(
+			     "open failed %s: %s\n"),
+		     quotainfo->quotapath,
+		     strerror(errno));
+		return BOOL_FALSE;
+	}
+	if (fstat(fd, &statb) < 0) {
+		mlog(MLOG_ERROR, _(
+			     "stat failed %s: %s\n"),
+		     quotainfo->quotapath,
+		     strerror(errno));
+		close(fd);
+		return BOOL_FALSE;
+	}
+	quotainfo->quotaino = statb.st_ino;
+
+	/* open and read dump file to ensure it is in the dump */
+	read(fd, &tmp, 1);
+	close(fd);
+	return BOOL_TRUE;
 }
 
 static int
diff --git a/dump/getopt.h b/dump/getopt.h
index 06c9ab0..c2ee88f 100644
--- a/dump/getopt.h
+++ b/dump/getopt.h
@@ -28,59 +28,59 @@
  * facilitating easy changes.
  */
 
-#define GETOPT_CMDSTRING	"ab:c:d:ef:hl:mop:qs:t:v:z:AB:CDEFG:H:I:JKL:M:NO:PRSTUVWY:"
+#define GETOPT_CMDSTRING        "ab:c:d:ef:hl:mop:qs:t:v:z:AB:CDEFG:H:I:JKL:M:NO:PRSTUVWY:"
 
-#define GETOPT_DUMPASOFFLINE	'a'	/* dump DMF dualstate files as offline */
-#define	GETOPT_BLOCKSIZE	'b'	/* blocksize for rmt */
-#define	GETOPT_ALERTPROG	'c'	/* Media Change Alert prog(content.c) */
-#define	GETOPT_FILESZ		'd'	/* Media file size to use in Mb */
-#define GETOPT_EXCLUDEFILES	'e'	/* allow files to be excluded */
-#define	GETOPT_DUMPDEST		'f'	/* dump dest. file (drive.c) */
+#define GETOPT_DUMPASOFFLINE    'a'     /* dump DMF dualstate files as offline */
+#define GETOPT_BLOCKSIZE        'b'     /* blocksize for rmt */
+#define GETOPT_ALERTPROG        'c'     /* Media Change Alert prog(content.c) */
+#define GETOPT_FILESZ           'd'     /* Media file size to use in Mb */
+#define GETOPT_EXCLUDEFILES     'e'     /* allow files to be excluded */
+#define GETOPT_DUMPDEST         'f'     /* dump dest. file (drive.c) */
 /*				'g'	*/
-#define	GETOPT_HELP		'h'	/* display version and usage */
+#define GETOPT_HELP             'h'     /* display version and usage */
 /*				'i'	*/
 /*				'j'	*/
 /*				'k'	*/
-#define	GETOPT_LEVEL		'l'	/* dump level (content_inode.c) */
-#define GETOPT_MINRMT		'm'	/* use minimal rmt protocol */
+#define GETOPT_LEVEL            'l'     /* dump level (content_inode.c) */
+#define GETOPT_MINRMT           'm'     /* use minimal rmt protocol */
 /*				'n'	*/
-#define GETOPT_OVERWRITE	'o'	/* overwrite data on tape */
-#define GETOPT_PROGRESS		'p'	/* interval between progress reports */
-#define	GETOPT_QIC		'q'	/* option to tell dump it's a QIC tape */
+#define GETOPT_OVERWRITE        'o'     /* overwrite data on tape */
+#define GETOPT_PROGRESS         'p'     /* interval between progress reports */
+#define GETOPT_QIC              'q'     /* option to tell dump it's a QIC tape */
 /*				'r'	*/
-#define	GETOPT_SUBTREE		's'	/* subtree dump (content_inode.c) */
-#define GETOPT_DUMPTIME		't'	/* use mtime of file as dump time */
+#define GETOPT_SUBTREE          's'     /* subtree dump (content_inode.c) */
+#define GETOPT_DUMPTIME         't'     /* use mtime of file as dump time */
 /*				'u' */
-#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
+#define GETOPT_VERBOSITY        'v'     /* verbosity level (0 to 4) */
 /*				'w' */
 /*				'x'	   used in irix for xvm snapshot */
 /*				'y' */
-#define GETOPT_MAXDUMPFILESIZE	'z'	/* prune files over specified size */
-#define	GETOPT_NOEXTATTR	'A'	/* do not dump ext. file attributes */
-#define	GETOPT_BASED		'B'	/* specify session to base increment */
-#define GETOPT_RECCHKSUM	'C'	/* use record checksums */
-#define GETOPT_NOUNCHANGEDDIRS	'D'	/* skip unchanged directories */
-#define	GETOPT_ERASE		'E'	/* pre-erase media */
-#define GETOPT_FORCE		'F'	/* don't prompt (getopt.c) */
-#define GETOPT_MINSTACKSZ	'G'	/* minimum stack size (bytes) */
-#define GETOPT_MAXSTACKSZ	'H'	/* maximum stack size (bytes) */
+#define GETOPT_MAXDUMPFILESIZE  'z'     /* prune files over specified size */
+#define GETOPT_NOEXTATTR        'A'     /* do not dump ext. file attributes */
+#define GETOPT_BASED            'B'     /* specify session to base increment */
+#define GETOPT_RECCHKSUM        'C'     /* use record checksums */
+#define GETOPT_NOUNCHANGEDDIRS  'D'     /* skip unchanged directories */
+#define GETOPT_ERASE            'E'     /* pre-erase media */
+#define GETOPT_FORCE            'F'     /* don't prompt (getopt.c) */
+#define GETOPT_MINSTACKSZ       'G'     /* minimum stack size (bytes) */
+#define GETOPT_MAXSTACKSZ       'H'     /* maximum stack size (bytes) */
 #define GETOPT_INVPRINT         'I'     /* just display the inventory */
-#define	GETOPT_NOINVUPDATE	'J'	/* do not update the dump inventory */
-#define GETOPT_FMT2COMPAT	'K'	/* use dump format 2 for compat with old restore */
-#define	GETOPT_DUMPLABEL	'L'	/* dump session label (global.c) */
-#define	GETOPT_MEDIALABEL	'M'	/* media object label (media.c) */
-#define	GETOPT_TIMESTAMP	'N'	/* show timestamps in log msgs */
-#define	GETOPT_OPTFILE		'O'	/* specifycmd line options file */
-#define	GETOPT_RINGPIN		'P'	/* pin down I/O buffer ring */
+#define GETOPT_NOINVUPDATE      'J'     /* do not update the dump inventory */
+#define GETOPT_FMT2COMPAT       'K'     /* use dump format 2 for compat with old restore */
+#define GETOPT_DUMPLABEL        'L'     /* dump session label (global.c) */
+#define GETOPT_MEDIALABEL       'M'     /* media object label (media.c) */
+#define GETOPT_TIMESTAMP        'N'     /* show timestamps in log msgs */
+#define GETOPT_OPTFILE          'O'     /* specifycmd line options file */
+#define GETOPT_RINGPIN          'P'     /* pin down I/O buffer ring */
 /*				'Q'	*/
-#define	GETOPT_RESUME		'R'	/* resume intr dump (content_inode.c) */
-#define	GETOPT_SINGLEMFILE	'S'	/* obsolete - now the default */
-#define	GETOPT_NOTIMEOUTS	'T'	/* don't timeout dialogs */
-#define	GETOPT_UNLOAD		'U'	/* unload media when change needed */
-#define	GETOPT_SHOWLOGSS	'V'	/* show subsystem of log messages */
-#define	GETOPT_SHOWLOGLEVEL	'W'	/* show level of log messages */
+#define GETOPT_RESUME           'R'     /* resume intr dump (content_inode.c) */
+#define GETOPT_SINGLEMFILE      'S'     /* obsolete - now the default */
+#define GETOPT_NOTIMEOUTS       'T'     /* don't timeout dialogs */
+#define GETOPT_UNLOAD           'U'     /* unload media when change needed */
+#define GETOPT_SHOWLOGSS        'V'     /* show subsystem of log messages */
+#define GETOPT_SHOWLOGLEVEL     'W'     /* show level of log messages */
 /*				'X'	*/
-#define	GETOPT_RINGLEN		'Y'	/* specify I/O buffer ring length */
+#define GETOPT_RINGLEN          'Y'     /* specify I/O buffer ring length */
 /*				'Z'	   used on irix for miniroot */
 
 #endif /* GETOPT_H */
diff --git a/dump/inomap.c b/dump/inomap.c
index 240a767..be505ea 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -47,15 +47,15 @@
 
 /* structure definitions used locally ****************************************/
 
-#define BSTATBUFLEN	pgsz
-	/*
-	 * length (in bstat_t's) of buf passed to bigstat_iter
-	 */
+#define BSTATBUFLEN     pgsz
+/*
+ * length (in bstat_t's) of buf passed to bigstat_iter
+ */
 
-#define GETDENTBUFSZ	pgsz
-	/*
-	 * size (in bytes) of buf passed to diriter (when not recursive)
-	 */
+#define GETDENTBUFSZ    pgsz
+/*
+ * size (in bytes) of buf passed to diriter (when not recursive)
+ */
 
 /* declarations of externally defined global symbols *************************/
 
@@ -72,16 +72,16 @@ extern bool_t allowexcludefiles_pr;
  */
 static int
 cb_context(bool_t last,
-			    time32_t,
-			    bool_t,
-			    time32_t,
-			    size_t,
-			    drange_t *,
-			    startpt_t *,
-			    size_t,
-			    int,
-			    bool_t,
-			    bool_t *);
+	   time32_t,
+	   bool_t,
+	   time32_t,
+	   size_t,
+	   drange_t *,
+	   startpt_t *,
+	   size_t,
+	   int,
+	   bool_t,
+	   bool_t *);
 static void cb_context_free(void);
 static int cb_count_inogrp(void *, int, xfs_inogrp_t *);
 static int cb_add_inogrp(void *, int, xfs_inogrp_t *);
@@ -92,15 +92,15 @@ static void cb_accuminit_sz(void);
 static void cb_spinit(void);
 static int
 cb_startpt(void *,
-			    jdm_fshandle_t *,
-			    int,
-			    xfs_bstat_t *);
+	   jdm_fshandle_t *,
+	   int,
+	   xfs_bstat_t *);
 static int
 supprt_prune(void *,
-			      jdm_fshandle_t *,
-			      int,
-			      xfs_bstat_t *,
-			      char *);
+	     jdm_fshandle_t *,
+	     int,
+	     xfs_bstat_t *,
+	     char *);
 static off64_t quantity2offset(jdm_fshandle_t *, xfs_bstat_t *, off64_t);
 static off64_t estimate_dump_space(xfs_bstat_t *);
 
@@ -117,22 +117,22 @@ static void inomap_set_gen(void *, xfs_ino_t, gen_t);
  */
 static int
 subtree_descend_cb(void *,
-				    jdm_fshandle_t *,
-				    int fsfd,
-				    xfs_bstat_t *,
-				    char *);
+		   jdm_fshandle_t *,
+		   int fsfd,
+		   xfs_bstat_t *,
+		   char *);
 static int
 subtreelist_parse_cb(void *,
-				      jdm_fshandle_t *,
-				      int fsfd,
-				      xfs_bstat_t *,
-				      char *);
+		     jdm_fshandle_t *,
+		     int fsfd,
+		     xfs_bstat_t *,
+		     char *);
 static int
 subtreelist_parse(jdm_fshandle_t *,
-				   int,
-				   xfs_bstat_t *,
-				   char *[],
-				   ix_t);
+		  int,
+		  xfs_bstat_t *,
+		  char *[],
+		  ix_t);
 
 /* definition of locally defined global variables ****************************/
 
@@ -154,24 +154,24 @@ static uint64_t inomap_exclude_skipattr = 0;
  */
 /* ARGSUSED */
 bool_t
-inomap_build(jdm_fshandle_t *fshandlep,
-	      int fsfd,
-	      xfs_bstat_t *rootstatp,
-	      bool_t last,
-	      time32_t lasttime,
-	      bool_t resume,
-	      time32_t resumetime,
-	      size_t resumerangecnt,
-	      drange_t *resumerangep,
-	      char *subtreebuf[],
-	      ix_t subtreecnt,
-	      bool_t skip_unchanged_dirs,
-	      startpt_t *startptp,
-	      size_t startptcnt,
-	      ix_t *statphasep,
-	      ix_t *statpassp,
-	      size64_t statcnt,
-	      size64_t *statdonep)
+inomap_build(jdm_fshandle_t *	fshandlep,
+	     int		fsfd,
+	     xfs_bstat_t *	rootstatp,
+	     bool_t		last,
+	     time32_t		lasttime,
+	     bool_t		resume,
+	     time32_t		resumetime,
+	     size_t		resumerangecnt,
+	     drange_t *		resumerangep,
+	     char *		subtreebuf[],
+	     ix_t		subtreecnt,
+	     bool_t		skip_unchanged_dirs,
+	     startpt_t *	startptp,
+	     size_t		startptcnt,
+	     ix_t *		statphasep,
+	     ix_t *		statpassp,
+	     size64_t		statcnt,
+	     size64_t *		statdonep)
 {
 	xfs_bstat_t *bstatbufp;
 	size_t bstatbuflen;
@@ -180,13 +180,13 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	int stat;
 	int rval;
 
-        /*
-         * do a sync so that bulkstat will pick up inode changes
-         * that are currently in the inode cache. this is necessary
-         * for incremental dumps in order to have the dump time
-         * accurately reflect what inodes were included in this dump.
-         * (PV 881455)
-         */
+	/*
+	 * do a sync so that bulkstat will pick up inode changes
+	 * that are currently in the inode cache. this is necessary
+	 * for incremental dumps in order to have the dump time
+	 * accurately reflect what inodes were included in this dump.
+	 * (PV 881455)
+	 */
 	sync();
 
 	/*
@@ -201,9 +201,9 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	 */
 	bstatbuflen = BSTATBUFLEN;
 	bstatbufp = (xfs_bstat_t *)memalign(pgsz,
-					       bstatbuflen
-					       *
-					       sizeof(xfs_bstat_t));
+					    bstatbuflen
+					    *
+					    sizeof(xfs_bstat_t));
 	assert(bstatbufp);
 
 	/*
@@ -220,20 +220,20 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	 * initialize the callback context
 	 */
 	rval = cb_context(last,
-			   lasttime,
-			   resume,
-			   resumetime,
-			   resumerangecnt,
-			   resumerangep,
-			   startptp,
-			   startptcnt,
-			   igrpcnt,
-			   skip_unchanged_dirs,
-			   &pruneneeded);
- 	if (rval) {
- 		free((void *)bstatbufp);
- 		return BOOL_FALSE;
- 	}
+			  lasttime,
+			  resume,
+			  resumetime,
+			  resumerangecnt,
+			  resumerangep,
+			  startptp,
+			  startptcnt,
+			  igrpcnt,
+			  skip_unchanged_dirs,
+			  &pruneneeded);
+	if (rval) {
+		free((void *)bstatbufp);
+		return BOOL_FALSE;
+	}
 
 	/*
 	 * the inode map requires that inodes are added in increasing
@@ -244,11 +244,11 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	 * correct state is set in cb_add.
 	 */
 	rval = inogrp_iter(fsfd, cb_add_inogrp, NULL, &stat);
- 	if (rval || stat) {
+	if (rval || stat) {
 		cb_context_free();
- 		free((void *)bstatbufp);
- 		return BOOL_FALSE;
- 	}
+		free((void *)bstatbufp);
+		return BOOL_FALSE;
+	}
 
 	/*
 	 * construct the ino map, based on the last dump time, resumed
@@ -264,8 +264,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	 * to decide if any pruning can be done.
 	 */
 	mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
-	      "ino map phase 1: "
-	      "constructing initial dump list\n"));
+		     "ino map phase 1: "
+		     "constructing initial dump list\n"));
 
 	*inomap_statdonep = 0;
 	*inomap_statphasep = 1;
@@ -274,23 +274,23 @@ inomap_build(jdm_fshandle_t *fshandlep,
 
 	if (subtreecnt) {
 		rval = subtreelist_parse(fshandlep,
-					  fsfd,
-					  rootstatp,
-					  subtreebuf,
-					  subtreecnt);
+					 fsfd,
+					 rootstatp,
+					 subtreebuf,
+					 subtreecnt);
 	} else {
 		rval = bigstat_iter(fshandlep,
-				     fsfd,
-				     BIGSTAT_ITER_ALL,
-				     (xfs_ino_t)0,
-				     cb_add,
-				     NULL,
-				     NULL,
-				     NULL,
-				     &stat,
-				     preemptchk,
-				     bstatbufp,
-				     bstatbuflen);
+				    fsfd,
+				    BIGSTAT_ITER_ALL,
+				    (xfs_ino_t)0,
+				    cb_add,
+				    NULL,
+				    NULL,
+				    NULL,
+				    &stat,
+				    preemptchk,
+				    bstatbufp,
+				    bstatbuflen);
 	}
 	*inomap_statphasep = 0;
 	if (rval || preemptchk(PREEMPT_FULL)) {
@@ -301,13 +301,13 @@ inomap_build(jdm_fshandle_t *fshandlep,
 
 	if (inomap_exclude_filesize > 0) {
 		mlog(MLOG_NOTE | MLOG_VERBOSE, _(
-		      "pruned %llu files: maximum size exceeded\n"),
-		      inomap_exclude_filesize);
+			     "pruned %llu files: maximum size exceeded\n"),
+		     inomap_exclude_filesize);
 	}
 	if (inomap_exclude_skipattr > 0) {
 		mlog(MLOG_NOTE | MLOG_VERBOSE, _(
-		      "pruned %llu files: skip attribute set\n"),
-		      inomap_exclude_skipattr);
+			     "pruned %llu files: skip attribute set\n"),
+		     inomap_exclude_skipattr);
 	}
 
 	/*
@@ -315,20 +315,20 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	 * no children needing dumping.
 	 */
 	if (pruneneeded) {
-		bool_t	rootdump = BOOL_FALSE;
+		bool_t rootdump = BOOL_FALSE;
 
 		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
-		      "ino map phase 2: "
-		      "pruning unneeded subtrees\n"));
+			     "ino map phase 2: "
+			     "pruning unneeded subtrees\n"));
 		*inomap_statdonep = 0;
 		*inomap_statpassp = 0;
 		*inomap_statphasep = 2;
 
 		(void) supprt_prune(&rootdump,
-				     fshandlep,
-				     fsfd,
-				     rootstatp,
-				     NULL);
+				    fshandlep,
+				    fsfd,
+				    rootstatp,
+				    NULL);
 		*inomap_statphasep = 0;
 
 		if (preemptchk(PREEMPT_FULL)) {
@@ -339,8 +339,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
 
 	} else {
 		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
-		      "ino map phase 2: "
-		      "skipping (no pruning necessary)\n"));
+			     "ino map phase 2: "
+			     "skipping (no pruning necessary)\n"));
 	}
 
 	/*
@@ -353,28 +353,28 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	 */
 	if (startptcnt > 1) {
 		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
-		      "ino map phase 3: "
-		      "identifying stream starting points\n"));
+			     "ino map phase 3: "
+			     "identifying stream starting points\n"));
 	} else {
 		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
-		      "ino map phase 3: "
-		      "skipping (only one dump stream)\n"));
+			     "ino map phase 3: "
+			     "skipping (only one dump stream)\n"));
 	}
 	stat = 0;
 	*inomap_statdonep = 0;
 	*inomap_statphasep = 3;
 	rval = bigstat_iter(fshandlep,
-			     fsfd,
-			     BIGSTAT_ITER_NONDIR,
-			     (xfs_ino_t)0,
-			     cb_startpt,
-			     NULL,
-			     inomap_next_nondir,
-			     inomap_alloc_context(),
-			     &stat,
-			     preemptchk,
-			     bstatbufp,
-			     bstatbuflen);
+			    fsfd,
+			    BIGSTAT_ITER_NONDIR,
+			    (xfs_ino_t)0,
+			    cb_startpt,
+			    NULL,
+			    inomap_next_nondir,
+			    inomap_alloc_context(),
+			    &stat,
+			    preemptchk,
+			    bstatbufp,
+			    bstatbuflen);
 	*inomap_statphasep = 0;
 
 	if (rval) {
@@ -397,18 +397,18 @@ inomap_build(jdm_fshandle_t *fshandlep,
 			}
 			assert(! p->sp_flags);
 			mlog(MLOG_VERBOSE | MLOG_INOMAP,
-			      _("stream %u: ino %llu offset %lld to "),
-			      startptix,
-			      p->sp_ino,
-			      p->sp_offset);
+			     _("stream %u: ino %llu offset %lld to "),
+			     startptix,
+			     p->sp_ino,
+			     p->sp_offset);
 			if (! ep) {
 				mlog(MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
-				      _("end\n"));
+				     _("end\n"));
 			} else {
 				mlog(MLOG_VERBOSE |  MLOG_BARE | MLOG_INOMAP,
-				      _("ino %llu offset %lld\n"),
-				      ep->sp_ino,
-				      ep->sp_offset);
+				     _("ino %llu offset %lld\n"),
+				     ep->sp_ino,
+				     ep->sp_offset);
 			}
 		}
 	}
@@ -416,7 +416,7 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	cb_context_free();
 	free((void *)bstatbufp);
 	mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
-	      "ino map construction complete\n"));
+		     "ino map construction complete\n"));
 	return BOOL_TRUE;
 }
 
@@ -431,8 +431,8 @@ inomap_skip(xfs_ino_t ino)
 	}
 
 	if (oldstate == MAP_DIR_CHANGE
-	     ||
-	     oldstate == MAP_DIR_SUPPRT) {
+	    ||
+	    oldstate == MAP_DIR_SUPPRT) {
 		inomap_set_state(NULL, ino, MAP_DIR_NOCHNG);
 	}
 }
@@ -444,42 +444,42 @@ inomap_skip(xfs_ino_t ino)
  * callback context and operators - inomap_build makes extensive use
  * of iterators. below are the callbacks given to these iterators.
  */
-static bool_t cb_last;		/* set by cb_context() */
-static time32_t cb_lasttime;	/* set by cb_context() */
-static bool_t cb_resume;	/* set by cb_context() */
-static time32_t cb_resumetime;	/* set by cb_context() */
-static size_t cb_resumerangecnt;/* set by cb_context() */
-static drange_t *cb_resumerangep;/* set by cb_context() */
-static void *cb_inomap_contextp;/* set by cb_context() */
-static startpt_t *cb_startptp;	/* set by cb_context() */
-static size_t cb_startptcnt;	/* set by cb_context() */
-static size_t cb_startptix;	/* set by cb_spinit(), incr. by cb_startpt */
-static off64_t cb_datasz;	/* set by cb_context() */
-static off64_t cb_hdrsz;	/* set by cb_context() */
-static off64_t cb_accum;	/* set by cb_context(), cb_spinit() */
-static off64_t cb_incr;		/* set by cb_spinit(), used by cb_startpt() */
-static off64_t cb_target;	/* set by cb_spinit(), used by cb_startpt() */
-static off64_t cb_dircnt;	/* number of dirs CHANGED or PRUNE */
-static off64_t cb_nondircnt;	/* number of non-dirs CHANGED */
-static bool_t *cb_pruneneededp; /* set by cb_context() */
-static bool_t cb_skip_unchanged_dirs;	/* set by cb_context() */
+static bool_t cb_last;                  /* set by cb_context() */
+static time32_t cb_lasttime;            /* set by cb_context() */
+static bool_t cb_resume;                /* set by cb_context() */
+static time32_t cb_resumetime;          /* set by cb_context() */
+static size_t cb_resumerangecnt;        /* set by cb_context() */
+static drange_t *cb_resumerangep;       /* set by cb_context() */
+static void *cb_inomap_contextp;        /* set by cb_context() */
+static startpt_t *cb_startptp;          /* set by cb_context() */
+static size_t cb_startptcnt;            /* set by cb_context() */
+static size_t cb_startptix;             /* set by cb_spinit(), incr. by cb_startpt */
+static off64_t cb_datasz;               /* set by cb_context() */
+static off64_t cb_hdrsz;                /* set by cb_context() */
+static off64_t cb_accum;                /* set by cb_context(), cb_spinit() */
+static off64_t cb_incr;                 /* set by cb_spinit(), used by cb_startpt() */
+static off64_t cb_target;               /* set by cb_spinit(), used by cb_startpt() */
+static off64_t cb_dircnt;               /* number of dirs CHANGED or PRUNE */
+static off64_t cb_nondircnt;            /* number of non-dirs CHANGED */
+static bool_t *cb_pruneneededp;         /* set by cb_context() */
+static bool_t cb_skip_unchanged_dirs;   /* set by cb_context() */
 
 /*
  * cb_context - initializes the call back context for the add and prune
  * phases of inomap_build().
  */
 static int
-cb_context(bool_t last,
-	    time32_t lasttime,
-	    bool_t resume,
-	    time32_t resumetime,
-	    size_t resumerangecnt,
-	    drange_t *resumerangep,
-	    startpt_t *startptp,
-	    size_t startptcnt,
-	    int igrpcnt,
-	    bool_t skip_unchanged_dirs,
-	    bool_t *pruneneededp)
+cb_context(bool_t	last,
+	   time32_t	lasttime,
+	   bool_t	resume,
+	   time32_t	resumetime,
+	   size_t	resumerangecnt,
+	   drange_t *	resumerangep,
+	   startpt_t *	startptp,
+	   size_t	startptcnt,
+	   int		igrpcnt,
+	   bool_t	skip_unchanged_dirs,
+	   bool_t *	pruneneededp)
 {
 	cb_last = last;
 	cb_lasttime = lasttime;
@@ -499,7 +499,7 @@ cb_context(bool_t last,
 		return -1;
 
 	cb_inomap_contextp = inomap_alloc_context();
-	if (!cb_inomap_contextp)
+	if (! cb_inomap_contextp)
 		return -1;
 
 	return 0;
@@ -527,10 +527,10 @@ cb_count_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
  */
 /* ARGSUSED */
 static int
-cb_add(void *arg1,
-	jdm_fshandle_t *fshandlep,
-	int fsfd,
-	xfs_bstat_t *statp)
+cb_add(void *		arg1,
+       jdm_fshandle_t * fshandlep,
+       int		fsfd,
+       xfs_bstat_t *	statp)
 {
 	register time32_t mtime = statp->bs_mtime.tv_sec;
 	register time32_t ctime = statp->bs_ctime.tv_sec;
@@ -589,9 +589,9 @@ cb_add(void *arg1,
 	if (changed) {
 		if (mode == S_IFDIR) {
 			inomap_add(cb_inomap_contextp,
-				    ino,
-				    (gen_t)statp->bs_gen,
-				    MAP_DIR_CHANGE);
+				   ino,
+				   (gen_t)statp->bs_gen,
+				   MAP_DIR_CHANGE);
 			cb_dircnt++;
 		} else {
 			estimated_size = estimate_dump_space(statp);
@@ -601,39 +601,39 @@ cb_add(void *arg1,
 			 * files are exempt from the check.
 			 */
 			if (maxdumpfilesize > 0 &&
-			     estimated_size > maxdumpfilesize &&
-			     !is_quota_file(statp->bs_ino)) {
+			    estimated_size > maxdumpfilesize &&
+			    ! is_quota_file(statp->bs_ino)) {
 				mlog(MLOG_DEBUG | MLOG_EXCLFILES,
-				      "pruned ino %llu, owner %u, estimated size %llu: maximum size exceeded\n",
-				      statp->bs_ino,
-				      statp->bs_uid,
-				      estimated_size);
+				     "pruned ino %llu, owner %u, estimated size %llu: maximum size exceeded\n",
+				     statp->bs_ino,
+				     statp->bs_uid,
+				     estimated_size);
 				inomap_add(cb_inomap_contextp,
-					    ino,
-					    (gen_t)statp->bs_gen,
-					    MAP_NDR_NOCHNG);
+					   ino,
+					   (gen_t)statp->bs_gen,
+					   MAP_NDR_NOCHNG);
 				inomap_exclude_filesize++;
 				return 0;
 			}
 
 			if (allowexcludefiles_pr && statp->bs_xflags & XFS_XFLAG_NODUMP) {
 				mlog(MLOG_DEBUG | MLOG_EXCLFILES,
-				      "pruned ino %llu, owner %u, estimated size %llu: skip flag set\n",
-				      statp->bs_ino,
-				      statp->bs_uid,
-				      estimated_size);
+				     "pruned ino %llu, owner %u, estimated size %llu: skip flag set\n",
+				     statp->bs_ino,
+				     statp->bs_uid,
+				     estimated_size);
 				inomap_add(cb_inomap_contextp,
-					    ino,
-					    (gen_t)statp->bs_gen,
-					    MAP_NDR_NOCHNG);
+					   ino,
+					   (gen_t)statp->bs_gen,
+					   MAP_NDR_NOCHNG);
 				inomap_exclude_skipattr++;
 				return 0;
 			}
 
 			inomap_add(cb_inomap_contextp,
-				    ino,
-				    (gen_t)statp->bs_gen,
-				    MAP_NDR_CHANGE);
+				   ino,
+				   (gen_t)statp->bs_gen,
+				   MAP_NDR_CHANGE);
 			cb_nondircnt++;
 			cb_datasz += estimated_size;
 			cb_hdrsz += (EXTENTHDR_SZ * (statp->bs_extents + 1));
@@ -645,22 +645,22 @@ cb_add(void *arg1,
 		if (mode == S_IFDIR) {
 			if (cb_skip_unchanged_dirs) {
 				inomap_add(cb_inomap_contextp,
-					    ino,
-					    (gen_t)statp->bs_gen,
-					    MAP_DIR_NOCHNG);
+					   ino,
+					   (gen_t)statp->bs_gen,
+					   MAP_DIR_NOCHNG);
 			} else {
 				*cb_pruneneededp = BOOL_TRUE;
 				inomap_add(cb_inomap_contextp,
-					    ino,
-					    (gen_t)statp->bs_gen,
-					    MAP_DIR_SUPPRT);
+					   ino,
+					   (gen_t)statp->bs_gen,
+					   MAP_DIR_SUPPRT);
 				cb_dircnt++;
 			}
 		} else {
 			inomap_add(cb_inomap_contextp,
-				    ino,
-				    (gen_t)statp->bs_gen,
-				    MAP_NDR_NOCHNG);
+				   ino,
+				   (gen_t)statp->bs_gen,
+				   MAP_NDR_NOCHNG);
 		}
 	}
 
@@ -674,17 +674,17 @@ cb_inoinresumerange(xfs_ino_t ino)
 
 	for (streamix = 0; streamix < cb_resumerangecnt; streamix++) {
 		register drange_t *rp = &cb_resumerangep[streamix];
-		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
-		     &&
-		     ino >= rp->dr_begin.sp_ino
-		     &&
-		     ((rp->dr_end.sp_flags & STARTPT_FLAGS_END)
-		       ||
-		       ino < rp->dr_end.sp_ino
-		       ||
-		       (ino == rp->dr_end.sp_ino
-			 &&
-			 rp->dr_end.sp_offset != 0))) {
+		if (!(rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
+		    &&
+		    ino >= rp->dr_begin.sp_ino
+		    &&
+		    ((rp->dr_end.sp_flags & STARTPT_FLAGS_END)
+		     ||
+		     ino < rp->dr_end.sp_ino
+		     ||
+		     (ino == rp->dr_end.sp_ino
+		      &&
+		      rp->dr_end.sp_offset != 0))) {
 			return BOOL_TRUE;
 		}
 	}
@@ -699,11 +699,11 @@ cb_inoresumed(xfs_ino_t ino)
 
 	for (streamix = 0; streamix < cb_resumerangecnt; streamix++) {
 		drange_t *rp = &cb_resumerangep[streamix];
-		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
-		     &&
-		     ino == rp->dr_begin.sp_ino
-		     &&
-		     rp->dr_begin.sp_offset != 0) {
+		if (!(rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
+		    &&
+		    ino == rp->dr_begin.sp_ino
+		    &&
+		    rp->dr_begin.sp_offset != 0) {
 			return BOOL_TRUE;
 		}
 	}
@@ -717,12 +717,12 @@ cb_inoresumed(xfs_ino_t ino)
  * (-> nochng) on the way back up after examining all descendents.
  */
 /* ARGSUSED */
-static bool_t			/* false, used as diriter callback */
-supprt_prune(void *arg1,	/* ancestors marked as changed? */
-	      jdm_fshandle_t *fshandlep,
-	      int fsfd,
-	      xfs_bstat_t *statp,
-	      char *name)
+static bool_t                           /* false, used as diriter callback */
+supprt_prune(void *		arg1,   /* ancestors marked as changed? */
+	     jdm_fshandle_t *	fshandlep,
+	     int		fsfd,
+	     xfs_bstat_t *	statp,
+	     char *		name)
 {
 	static bool_t cbrval = BOOL_FALSE;
 	int state;
@@ -732,33 +732,33 @@ supprt_prune(void *arg1,	/* ancestors marked as changed? */
 
 		state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
 		if (state != MAP_DIR_CHANGE &&
-                     state != MAP_DIR_NOCHNG &&
-		     state != MAP_DIR_SUPPRT) {
+		    state != MAP_DIR_NOCHNG &&
+		    state != MAP_DIR_SUPPRT) {
 			/*
 			 * if file is now a dir then it has
 			 * certainly changed.
 			 */
 			state = MAP_DIR_CHANGE;
 			inomap_set_state(cb_inomap_contextp,
-					  statp->bs_ino,
-					  state);
+					 statp->bs_ino,
+					 state);
 		}
 
 		(void)diriter(fshandlep,
-				 fsfd,
-				 statp,
-				 supprt_prune,
-				 (void *)&changed_below,
-				 &cbrval,
-				 NULL,
-				 0);
+			      fsfd,
+			      statp,
+			      supprt_prune,
+			      (void *)&changed_below,
+			      &cbrval,
+			      NULL,
+			      0);
 
 		if (state == MAP_DIR_SUPPRT) {
 			if (changed_below == BOOL_FALSE) {
 				inomap_set_state(cb_inomap_contextp,
-						  statp->bs_ino,
-						  MAP_DIR_NOCHNG);
-				cb_dircnt--;	/* dump size just changed! */
+						 statp->bs_ino,
+						 MAP_DIR_NOCHNG);
+				cb_dircnt--;    /* dump size just changed! */
 			}
 			else {
 				/* Directory entries back up the hierarchy */
@@ -781,7 +781,7 @@ supprt_prune(void *arg1,	/* ancestors marked as changed? */
 
 	state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
 	if (state != MAP_NDR_CHANGE &&
-	     state != MAP_NDR_NOCHNG) {
+	    state != MAP_NDR_NOCHNG) {
 		/*
 		 * if dir is now a file then it has
 		 * certainly changed.
@@ -829,28 +829,28 @@ cb_spinit(void)
  * or split the file between the old and new streams. in the case of
  * a split decision, always split at a BBSIZE boundary.
  */
-#define TOO_SHY		1000000	/* max accept. accum short of target */
-#define TOO_BOLD	1000000	/* max accept. accum beyond target */
+#define TOO_SHY         1000000 /* max accept. accum short of target */
+#define TOO_BOLD        1000000 /* max accept. accum beyond target */
 
 typedef enum {
-	HOLD,	/* don't change */
-	BUMP,	/* set a new start point and put this file after it */
-	SPLIT,	/* set a new start point and split this file across it */
-	YELL	/* impossible condition; complain */
+	HOLD,   /* don't change */
+	BUMP,   /* set a new start point and put this file after it */
+	SPLIT,  /* set a new start point and split this file across it */
+	YELL    /* impossible condition; complain */
 } action_t;
 
 /* ARGSUSED */
 static int
-cb_startpt(void *arg1,
-	    jdm_fshandle_t *fshandlep,
-	    int fsfd,
-	    xfs_bstat_t *statp)
+cb_startpt(void *		arg1,
+	   jdm_fshandle_t *	fshandlep,
+	   int			fsfd,
+	   xfs_bstat_t *	statp)
 {
 	register int state;
 
 	off64_t estimate;
 	off64_t old_accum = cb_accum;
-	off64_t qty;	/* amount of a SPLIT file to skip */
+	off64_t qty;    /* amount of a SPLIT file to skip */
 	action_t action;
 
 	(*inomap_statdonep)++;
@@ -927,7 +927,7 @@ cb_startpt(void *arg1,
 				action = (action_t)HOLD;
 			} else if (cb_accum - cb_target < TOO_BOLD) {
 				if (cb_accum - cb_target >=
-						      cb_target - old_accum) {
+				    cb_target - old_accum) {
 					action = (action_t)BUMP;
 				} else {
 					action = (action_t)HOLD;
@@ -959,9 +959,9 @@ cb_startpt(void *arg1,
 			      &
 			      ~(off64_t)(BBSIZE - 1);
 			cb_startptp->sp_offset =
-					quantity2offset(fshandlep,
-							 statp,
-							 qty);
+				quantity2offset(fshandlep,
+						statp,
+						qty);
 			cb_startptix++;
 			cb_startptp++;
 			cb_target += cb_incr;
@@ -986,22 +986,22 @@ cb_startpt(void *arg1,
  * define structure for ino to gen mapping.
  */
 struct i2gseg {
-	uint64_t s_valid;
-	gen_t s_gen[INOPERSEG];
+	uint64_t	s_valid;
+	gen_t		s_gen[INOPERSEG];
 };
 typedef struct i2gseg i2gseg_t;
 
 typedef struct seg_addr {
-	int hnkoff;
-	int segoff;
-	int inooff;
+	int	hnkoff;
+	int	segoff;
+	int	inooff;
 } seg_addr_t;
 
 static struct inomap {
-	hnk_t *hnkmap;
-	int hnkmaplen;
-	i2gseg_t *i2gmap;
-	seg_addr_t lastseg;
+	hnk_t *		hnkmap;
+	int		hnkmaplen;
+	i2gseg_t *	i2gmap;
+	seg_addr_t	lastseg;
 } inomap;
 
 static inline void
@@ -1096,8 +1096,8 @@ inomap_init(int igrpcnt)
 	inomap.hnkmaplen = (igrpcnt + SEGPERHNK - 1) / SEGPERHNK;
 	inomap.hnkmap = (hnk_t *)malloc(inomap.hnkmaplen * HNKSZ);
 	inomap.i2gmap = (i2gseg_t *)
-		calloc(inomap.hnkmaplen * SEGPERHNK, sizeof(i2gseg_t));
-	if (!inomap.hnkmap || !inomap.i2gmap)
+			calloc(inomap.hnkmaplen * SEGPERHNK, sizeof(i2gseg_t));
+	if (! inomap.hnkmap || ! inomap.i2gmap)
 		return -1;
 	return 0;
 }
@@ -1117,7 +1117,7 @@ inomap_validaddr(seg_addr_t *addrp)
 		return BOOL_FALSE;
 
 	maxseg = (addrp->hnkoff == inomap.lastseg.hnkoff) ?
-			inomap.lastseg.segoff : SEGPERHNK - 1;
+		 inomap.lastseg.segoff : SEGPERHNK - 1;
 
 	if (addrp->segoff < 0 || addrp->segoff > maxseg)
 		return BOOL_FALSE;
@@ -1175,15 +1175,15 @@ cb_add_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 
 			inomap.hnkmaplen++;
 			inomap.hnkmap = (hnk_t *)
-				realloc(inomap.hnkmap, inomap.hnkmaplen * HNKSZ);
+					realloc(inomap.hnkmap, inomap.hnkmaplen * HNKSZ);
 
 			numsegs = inomap.hnkmaplen * SEGPERHNK;
 			if (numsegs < 0)
 				return -1;
 			inomap.i2gmap = (i2gseg_t *)
-				realloc(inomap.i2gmap, numsegs * sizeof(i2gseg_t));
+					realloc(inomap.i2gmap, numsegs * sizeof(i2gseg_t));
 
-			if (!inomap.hnkmap || !inomap.i2gmap)
+			if (! inomap.hnkmap || ! inomap.i2gmap)
 				return -1;
 
 			/* zero the new portion of the i2gmap */
@@ -1217,10 +1217,10 @@ void *
 inomap_alloc_context(void)
 {
 	void *addr = calloc(1, sizeof(seg_addr_t));
-	if (!addr) {
+	if (! addr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR,
-		      _("failed to allocate inomap context: %s\n"),
-		      strerror(errno));
+		     _("failed to allocate inomap context: %s\n"),
+		     strerror(errno));
 	}
 	return addr;
 }
@@ -1281,11 +1281,11 @@ inomap_find_seg(seg_addr_t *addrp, xfs_ino_t ino)
 	int lower;
 	int upper;
 
-	if (!inomap_validaddr(addrp) ) {
+	if (! inomap_validaddr(addrp) ) {
 		inomap_reset_context(addrp);
 	}
 
-	if (!inomap_find_hnk(addrp, ino) )
+	if (! inomap_find_hnk(addrp, ino) )
 		return BOOL_FALSE;
 
 	/* find the correct segment */
@@ -1317,12 +1317,12 @@ inomap_iter(void *contextp, int statemask)
 	seg_addr_t *addrp = (seg_addr_t *)contextp;
 
 	for (;
-	      addrp->hnkoff <= inomap.lastseg.hnkoff;
-	      addrp->hnkoff++, addrp->segoff = 0, addrp->inooff = 0) {
+	     addrp->hnkoff <= inomap.lastseg.hnkoff;
+	     addrp->hnkoff++, addrp->segoff = 0, addrp->inooff = 0) {
 
 		for (;
-		      addrp->segoff <= inomap_lastseg(addrp->hnkoff);
-		      addrp->segoff++, addrp->inooff = 0) {
+		     addrp->segoff <= inomap_lastseg(addrp->hnkoff);
+		     addrp->segoff++, addrp->inooff = 0) {
 
 			segp = inomap_addr2seg(addrp);
 
@@ -1377,7 +1377,7 @@ inomap_set_state(void *contextp, xfs_ino_t ino, int state)
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (!inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino) )
 		return MAP_INO_UNUSED;
 
 	segp = inomap_addr2seg(addrp);
@@ -1396,7 +1396,7 @@ inomap_get_state(void *contextp, xfs_ino_t ino)
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (!inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino) )
 		return MAP_INO_UNUSED;
 
 	segp = inomap_addr2seg(addrp);
@@ -1414,7 +1414,7 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (!inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino) )
 		return;
 
 	segp = inomap_addr2seg(addrp);
@@ -1435,14 +1435,14 @@ inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen)
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if (!inomap_find_seg(addrp, ino) )
+	if (! inomap_find_seg(addrp, ino) )
 		return 1;
 
 	segp = inomap_addr2seg(addrp);
 	i2gsegp = &inomap.i2gmap[inomap_addr2segix(addrp)];
 
 	relino = ino - segp->base;
-	if (! (i2gsegp->s_valid & ((uint64_t)1 << relino)))
+	if (!(i2gsegp->s_valid & ((uint64_t)1 << relino)))
 		return 1;
 
 	*gen = i2gsegp->s_gen[relino];
@@ -1475,8 +1475,8 @@ inomap_dump(drive_t *drivep)
 	 * use write_buf to dump the hunks
 	 */
 	for (addr.hnkoff = 0;
-	      addr.hnkoff <= inomap.lastseg.hnkoff;
-	      addr.hnkoff++) {
+	     addr.hnkoff <= inomap.lastseg.hnkoff;
+	     addr.hnkoff++) {
 		int rval;
 		rv_t rv;
 		drive_ops_t *dop = drivep->d_opsp;
@@ -1485,10 +1485,10 @@ inomap_dump(drive_t *drivep)
 
 		xlate_hnk(hnkp, &tmphnkp, 1);
 		rval = write_buf((char *)&tmphnkp,
-				  sizeof(tmphnkp),
-				  (void *)drivep,
-				  (gwbfp_t)dop->do_get_write_buf,
-				  (wfp_t)dop->do_write);
+				 sizeof(tmphnkp),
+				 (void *)drivep,
+				 (gwbfp_t)dop->do_get_write_buf,
+				 (wfp_t)dop->do_write);
 		switch (rval) {
 		case 0:
 			rv = RV_OK;
@@ -1517,11 +1517,11 @@ inomap_dump(drive_t *drivep)
 }
 
 static int
-subtreelist_parse(jdm_fshandle_t *fshandlep,
-		   int fsfd,
-		   xfs_bstat_t *rootstatp,
-		   char *subtreebuf[],
-		   ix_t subtreecnt)
+subtreelist_parse(jdm_fshandle_t *	fshandlep,
+		  int			fsfd,
+		  xfs_bstat_t *		rootstatp,
+		  char *		subtreebuf[],
+		  ix_t			subtreecnt)
 {
 	ix_t subtreeix;
 
@@ -1538,19 +1538,19 @@ subtreelist_parse(jdm_fshandle_t *fshandlep,
 		char *currentpath = subtreebuf[subtreeix];
 		assert(*currentpath != '/');
 		(void)diriter(fshandlep,
-				 fsfd,
-				 rootstatp,
-				 subtreelist_parse_cb,
-				 (void *)currentpath,
-				 &cbrval,
-				 NULL,
-				 0);
+			      fsfd,
+			      rootstatp,
+			      subtreelist_parse_cb,
+			      (void *)currentpath,
+			      &cbrval,
+			      NULL,
+			      0);
 		if (cbrval != 1) {
 			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_INOMAP,
-			      "%s: %s\n",
-			      cbrval == 0 ? _("subtree not present")
-					  : _("invalid subtree specified"),
-			      currentpath);
+			     "%s: %s\n",
+			     cbrval == 0 ? _("subtree not present")
+			     : _("invalid subtree specified"),
+			     currentpath);
 			return -1;
 		}
 	}
@@ -1559,11 +1559,11 @@ subtreelist_parse(jdm_fshandle_t *fshandlep,
 }
 
 static int
-subtreelist_parse_cb(void *arg1,
-		      jdm_fshandle_t *fshandlep,
-		      int fsfd,
-		      xfs_bstat_t *statp,
-		      char *name)
+subtreelist_parse_cb(void *		arg1,
+		     jdm_fshandle_t *	fshandlep,
+		     int		fsfd,
+		     xfs_bstat_t *	statp,
+		     char *		name)
 {
 	int cbrval = 0;
 
@@ -1610,20 +1610,20 @@ subtreelist_parse_cb(void *arg1,
 
 		/*
 		 * repair the subpath
-		*/
+		 */
 		*nextslash = '/';
 
 		/*
 		 * peel the first element of the subpath and recurse
-		*/
+		 */
 		(void)diriter(fshandlep,
-				 fsfd,
-				 statp,
-				 subtreelist_parse_cb,
-				 (void *)(nextslash + 1),
-				 &cbrval,
-				 NULL,
-				 0);
+			      fsfd,
+			      statp,
+			      subtreelist_parse_cb,
+			      (void *)(nextslash + 1),
+			      &cbrval,
+			      NULL,
+			      0);
 		return cbrval;
 
 	} else {
@@ -1638,23 +1638,23 @@ subtreelist_parse_cb(void *arg1,
 		}
 
 		(void)diriter(fshandlep,
-				 fsfd,
-				 statp,
-				 subtree_descend_cb,
-				 NULL,
-				 &cbrval,
-				 0,
-				 0);
+			      fsfd,
+			      statp,
+			      subtree_descend_cb,
+			      NULL,
+			      &cbrval,
+			      0,
+			      0);
 		return 1;
 	}
 }
 
 static int
-subtree_descend_cb(void *arg1,
-		    jdm_fshandle_t *fshandlep,
-		    int fsfd,
-		    xfs_bstat_t *statp,
-		    char *name)
+subtree_descend_cb(void *		arg1,
+		   jdm_fshandle_t *	fshandlep,
+		   int			fsfd,
+		   xfs_bstat_t *	statp,
+		   char *		name)
 {
 	int cbrval = 0;
 
@@ -1663,13 +1663,13 @@ subtree_descend_cb(void *arg1,
 	if ((statp->bs_mode & S_IFMT) == S_IFDIR) {
 
 		(void)diriter(fshandlep,
-				 fsfd,
-				 statp,
-				 subtree_descend_cb,
-				 NULL,
-				 &cbrval,
-				 NULL,
-				 0);
+			      fsfd,
+			      statp,
+			      subtree_descend_cb,
+			      NULL,
+			      &cbrval,
+			      NULL,
+			      0);
 	}
 
 	return cbrval;
@@ -1679,7 +1679,7 @@ subtree_descend_cb(void *arg1,
  * uses the extent map to figure the first offset in the file
  * with qty real (non-hole) bytes behind it
  */
-#define BMAP_LEN	512
+#define BMAP_LEN        512
 
 static off64_t
 quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
@@ -1711,9 +1711,9 @@ quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 	fd = jdm_open(fshandlep, statp, O_RDONLY);
 	if (fd < 0) {
 		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
-		      "could not open ino %llu to read extent map: %s\n"),
-		      statp->bs_ino,
-		      strerror(errno));
+			     "could not open ino %llu to read extent map: %s\n"),
+		     statp->bs_ino,
+		     strerror(errno));
 		return 0;
 	}
 
@@ -1724,9 +1724,9 @@ quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 		rval = ioctl(fd, XFS_IOC_GETBMAPX, bmap);
 		if (rval) {
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
-			      "could not read extent map for ino %llu: %s\n"),
-			      statp->bs_ino,
-			      strerror(errno));
+				     "could not read extent map for ino %llu: %s\n"),
+			     statp->bs_ino,
+			     strerror(errno));
 			(void)close(fd);
 			return 0;
 		}
@@ -1767,7 +1767,7 @@ estimate_dump_space(xfs_bstat_t *statp)
 		 * specified and the HSM provided an estimate, then use it.
 		 */
 		if (hsm_fs_ctxtp) {
-			off64_t	bytes;
+			off64_t bytes;
 			int accurate;
 
 			/*
@@ -1790,17 +1790,17 @@ estimate_dump_space(xfs_bstat_t *statp)
 	case S_IFBLK:
 	case S_IFSOCK:
 	case S_IFLNK:
-	/*
-	 * not yet
-	case S_IFUUID:
-	*/
+		/*
+		 * not yet
+		   case S_IFUUID:
+		 */
 		return 0;
 	default:
 		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
-		      "unknown inode type: ino=%llu, mode=0x%04x 0%06o\n"),
-		      statp->bs_ino,
-		      statp->bs_mode,
-		      statp->bs_mode);
+			     "unknown inode type: ino=%llu, mode=0x%04x 0%06o\n"),
+		     statp->bs_ino,
+		     statp->bs_mode,
+		     statp->bs_mode);
 		return 0;
 	}
 }
diff --git a/dump/inomap.h b/dump/inomap.h
index b9619f6..2ae6b71 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -49,24 +49,24 @@ struct xfs_bstat;
  * fall at file boundaries. returns BOOL_FALSE if error encountered (should
  * abort the dump; else returns BOOL_TRUE.
  */
-extern bool_t inomap_build(void *fshandlep,
-			    int fsfd,
-			    struct xfs_bstat *rootstatp,
-			    bool_t last,
-	      		    time32_t lasttime,
-			    bool_t resume,
-	      		    time32_t resumetime,
-			    size_t resumerangecnt,
-			    drange_t *resumerangep,
-			    char *subtreebuf[],
-			    ix_t subtreecnt,
-			    bool_t skip_unchanged_dirs,
-			    startpt_t startptp[],
-	      		    size_t startptcnt,
-			    ix_t *statphasep,
-			    ix_t *statpassp,
-			    size64_t statcnt,
-			    size64_t *statdonep);
+extern bool_t inomap_build(void *		fshandlep,
+			   int			fsfd,
+			   struct xfs_bstat *	rootstatp,
+			   bool_t		last,
+			   time32_t		lasttime,
+			   bool_t		resume,
+			   time32_t		resumetime,
+			   size_t		resumerangecnt,
+			   drange_t *		resumerangep,
+			   char *		subtreebuf[],
+			   ix_t			subtreecnt,
+			   bool_t		skip_unchanged_dirs,
+			   startpt_t		startptp[],
+			   size_t		startptcnt,
+			   ix_t *		statphasep,
+			   ix_t *		statpassp,
+			   size64_t		statcnt,
+			   size64_t *		statdonep);
 
 extern uint64_t inomap_getsz(void);
 
@@ -94,14 +94,14 @@ extern rv_t inomap_dump(drive_t *drivep);
 /*
  * map state values
  */
-#define MAP_INO_UNUSED	0       /* ino not in use by fs */
-#define MAP_DIR_NOCHNG	1       /* dir, ino in use by fs, but not dumped */
-#define MAP_NDR_NOCHNG	2       /* non-dir, ino in use by fs, but not dumped */
-#define MAP_DIR_CHANGE	3       /* dir, changed since last dump */
-#define MAP_NDR_CHANGE	4       /* non-dir, changed since last dump */
-#define MAP_DIR_SUPPRT	5       /* dir, unchanged but needed for hierarchy */
-#define MAP_RESERVED1	6       /* this state currently not used */
-#define MAP_RESERVED2	7       /* this state currently not used */
+#define MAP_INO_UNUSED  0       /* ino not in use by fs */
+#define MAP_DIR_NOCHNG  1       /* dir, ino in use by fs, but not dumped */
+#define MAP_NDR_NOCHNG  2       /* non-dir, ino in use by fs, but not dumped */
+#define MAP_DIR_CHANGE  3       /* dir, changed since last dump */
+#define MAP_NDR_CHANGE  4       /* non-dir, changed since last dump */
+#define MAP_DIR_SUPPRT  5       /* dir, unchanged but needed for hierarchy */
+#define MAP_RESERVED1   6       /* this state currently not used */
+#define MAP_RESERVED2   7       /* this state currently not used */
 
 /*
  * the inomap is implemented as a linked list of chunks. each chunk contains
@@ -110,24 +110,24 @@ extern rv_t inomap_dump(drive_t *drivep);
  * index and manipulate the 3-bit state values.
  */
 struct seg {
-	xfs_ino_t base;
-	uint64_t lobits;
-	uint64_t mebits;
-	uint64_t hibits;
+	xfs_ino_t	base;
+	uint64_t	lobits;
+	uint64_t	mebits;
+	uint64_t	hibits;
 };
 
 typedef struct seg seg_t;
 
-#define INOPERSEG	(sizeof(((seg_t *)0)->lobits) * NBBY)
+#define INOPERSEG       (sizeof(((seg_t *)0)->lobits) * NBBY)
 
-#define HNKSZ		(4 * PGSZ)
-#define SEGPERHNK	((HNKSZ / sizeof(seg_t)) - 1)
+#define HNKSZ           (4 * PGSZ)
+#define SEGPERHNK       ((HNKSZ / sizeof(seg_t)) - 1)
 
 struct hnk {
-	seg_t seg[SEGPERHNK];
-	xfs_ino_t maxino;
-	struct hnk *nextp;		/* no longer used, kept for binary compat */
-	char pad[sizeof(seg_t) - sizeof(xfs_ino_t) - sizeof(struct hnk *)];
+	seg_t		seg[SEGPERHNK];
+	xfs_ino_t	maxino;
+	struct hnk *	nextp;          /* no longer used, kept for binary compat */
+	char		pad[sizeof(seg_t) - sizeof(xfs_ino_t) - sizeof(struct hnk *)];
 };
 
 typedef struct hnk hnk_t;
diff --git a/dump/var.c b/dump/var.c
index a195693..47ec9fa 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -66,14 +66,14 @@ var_create_component(char *path)
 
 	if (rval && errno != EEXIST) {
 		mlog(MLOG_NORMAL, _("unable to create %s: %s\n"),
-		      path, strerror(errno));
+		     path, strerror(errno));
 		return 0;
 	}
 	if (rval == 0) {
 		rval = chown(path, 0, 0);
 		if (rval) {
 			mlog(MLOG_NORMAL, _("unable to chown %s: %s\n"),
-			      path, strerror(errno));
+			     path, strerror(errno));
 		}
 	}
 	return 1;
@@ -91,13 +91,13 @@ var_skip(uuid_t *dumped_fsidp, void (*cb)(xfs_ino_t ino))
 	rval = fs_getid(XFSDUMP_DIRPATH, &fsid);
 	if (rval) {
 #ifdef HIDDEN
-                /* NOTE: this will happen for non-XFS file systems */
-                /*       and is expected, so no msg */
+		/* NOTE: this will happen for non-XFS file systems */
+		/*       and is expected, so no msg */
 		mlog(MLOG_NORMAL, _(
-		      "unable to determine uuid of fs containing %s: "
-		      "%s\n"),
-		      XFSDUMP_DIRPATH,
-		      strerror(errno));
+			     "unable to determine uuid of fs containing %s: "
+			     "%s\n"),
+		     XFSDUMP_DIRPATH,
+		     strerror(errno));
 #endif
 		return;
 	}
@@ -124,15 +124,15 @@ var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
 	rval = lstat64(base, &statbuf);
 	if (rval) {
 		mlog(MLOG_NORMAL, _(
-		      "unable to get status of %s: %s\n"),
-		      base,
-		      strerror(errno));
+			     "unable to get status of %s: %s\n"),
+		     base,
+		     strerror(errno));
 		return;
 	}
 
 	mlog(MLOG_DEBUG,
-	      "excluding %s from dump\n",
-	      base);
+	     "excluding %s from dump\n",
+	     base);
 
 	(*cb)(statbuf.st_ino);
 
@@ -143,8 +143,8 @@ var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
 	dirp = opendir(base);
 	if (! dirp) {
 		mlog(MLOG_NORMAL, _(
-		      "unable to open directory %s\n"),
-		      base);
+			     "unable to open directory %s\n"),
+		     base);
 		return;
 	}
 
@@ -155,12 +155,12 @@ var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
 		 * skip "." and ".."
 		 */
 		if (*(direntp->d_name + 0) == '.'
-		     &&
-		     (*(direntp->d_name + 1) == 0
-		       ||
-		       (*(direntp->d_name + 1) == '.'
-			 &&
-			 *(direntp->d_name + 2) == 0))) {
+		    &&
+		    (*(direntp->d_name + 1) == 0
+		     ||
+		     (*(direntp->d_name + 1) == '.'
+		      &&
+		      *(direntp->d_name + 2) == 0))) {
 			continue;
 		}
 
-- 
2.19.1
