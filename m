Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbeKJAMx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:53 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88AF52D7E0
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:32:02 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 16/24] xfsdump: (style) curly brackets should wrap with one space
Date: Fri,  9 Nov 2018 15:29:56 +0100
Message-Id: <20181109143004.24963-17-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add a space where it is missing "{foo}", and remove it where are
too many "{   foo   }".

Created by this script:

#!/usr/bin/env bash
# there should be a single space inside of curly brackets
# add where missing "{foo}" and remove where too many "{   foo   }"

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/{\s*\(\S\)/{ \1/g" \
    -e "s/\(\S\)\s*}/\1 }/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/content_inode.h  |  4 ++--
 common/drive_minrmt.c   |  2 +-
 common/drive_scsitape.c |  2 +-
 common/main.c           | 50 ++++++++++++++++++++---------------------
 common/mlog.c           | 22 +++++++++---------
 common/stream.c         |  2 +-
 common/ts_mtio.h        |  4 ++--
 dump/content.c          |  4 ++--
 dump/inomap.c           |  2 +-
 include/swab.h          |  6 ++---
 inventory/inv_files.c   |  2 +-
 inventory/inv_oref.h    | 12 +++++-----
 invutil/cmenu.c         | 22 +++++++++---------
 invutil/invutil.c       |  2 +-
 librmt/rmtioctl.c       |  4 ++--
 librmt/rmtopen.c        |  8 +++----
 restore/content.c       |  8 +++----
 restore/mmap.c          |  2 +-
 restore/tree.c          | 18 +++++++--------
 19 files changed, 88 insertions(+), 88 deletions(-)

diff --git a/common/content_inode.h b/common/content_inode.h
index cd8bf8e..915629f 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -149,7 +149,7 @@ typedef struct content_inode_hdr content_inode_hdr_t;
  */
 #define TIMESTRUCT_SZ	8
 
-struct timestruct {			/*		     bytes accum */
+struct timestruct { /*		     bytes accum */
 	int32_t		tv_sec;		/* seconds		 4     4 */
 	int32_t		tv_nsec;	/* and nanoseconds	 4     8 */
 };
@@ -166,7 +166,7 @@ typedef struct timestruct timestruct_t;
 #define BSTAT_SZ	128
 #define MODE_SZ		4
 
-struct bstat {				/*		     bytes accum */
+struct bstat { /*		     bytes accum */
 	xfs_ino_t	bs_ino;		/* inode number		 8     8 */
 	uint32_t	bs_mode;	/* type and mode	 4     c */
 	uint32_t	bs_nlink;	/* number of links	 4    10 */
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index c10d4f4..0006a7e 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -3337,7 +3337,7 @@ prepare_drive(drive_t *drivep)
 
 	/*
 	 * determine tape capabilities. this will set the drivep->d_capabilities
-	 * and contextp->dc_{...}blksz and dc_isQICpr, as well as recommended
+	 * and contextp->dc_{ ... }blksz and dc_isQICpr, as well as recommended
 	 * mark separation and media file size.
 	 */
 	ok = get_tpcaps(drivep);
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index b74641c..9e4d33e 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -4251,7 +4251,7 @@ retry:
 
 	/*
 	 * determine tape capabilities. this will set the drivep->d_capabilities
-	 * and contextp->dc_{...}blksz and dc_isQICpr, as well as recommended
+	 * and contextp->dc_{ ... }blksz and dc_isQICpr, as well as recommended
 	 * mark separation and media file size.
 	 */
 	ok = get_tpcaps(drivep);
diff --git a/common/main.c b/common/main.c
index 0e7cc51..f560c82 100644
--- a/common/main.c
+++ b/common/main.c
@@ -987,7 +987,7 @@ usage(void)
 	ULO(_("<use QIC tape settings>"),		GETOPT_QIC);
 	ULO(_("<subtree> ..."),				GETOPT_SUBTREE);
 	ULO(_("<file> (use file mtime for dump time"),	GETOPT_DUMPTIME);
-	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
+	ULO(_("<verbosity { silent, verbose, trace }>"),	GETOPT_VERBOSITY);
 	ULO(_("<maximum file size>"),			GETOPT_MAXDUMPFILESIZE);
 	ULO(_("(don't dump extended file attributes)"),	GETOPT_NOEXTATTR);
 	ULO(_("<base dump session id>"),		GETOPT_BASED);
@@ -1040,7 +1040,7 @@ usage(void)
 	ULO(_("(cumulative restore)"),			GETOPT_CUMULATIVE);
 	ULO(_("<subtree> ..."),				GETOPT_SUBTREE);
 	ULO(_("(contents only)"),			GETOPT_TOC);
-	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
+	ULO(_("<verbosity { silent, verbose, trace }>"),	GETOPT_VERBOSITY);
 	ULO(_("(use small tree window)"),		GETOPT_SMALLWINDOW);
 	ULO(_("(don't restore extended file attributes)"), GETOPT_NOEXTATTR);
 	ULO(_("(restore root dir owner/permissions)"),	GETOPT_ROOTPERM);
@@ -2330,33 +2330,33 @@ struct sig_printmap {
 typedef struct sig_printmap sig_printmap_t;
 
 static sig_printmap_t sig_printmap[] = {
-	{SIGHUP,	"SIGHUP"},
-	{SIGINT,	"SIGINT"},
-	{SIGQUIT,	"SIGQUIT"},
-	{SIGILL,	"SIGILL"},
-	{SIGABRT,	"SIGABRT"},
-	{SIGFPE,	"SIGFPE"},
-	{SIGBUS,	"SIGBUS"},
-	{SIGSEGV,	"SIGSEGV"},
+	{ SIGHUP,	"SIGHUP" },
+	{ SIGINT,	"SIGINT" },
+	{ SIGQUIT,	"SIGQUIT" },
+	{ SIGILL,	"SIGILL" },
+	{ SIGABRT,	"SIGABRT" },
+	{ SIGFPE,	"SIGFPE" },
+	{ SIGBUS,	"SIGBUS" },
+	{ SIGSEGV,	"SIGSEGV" },
 #ifdef SIGSYS
-	{SIGSYS,	"SIGSYS"},
+	{ SIGSYS,	"SIGSYS" },
 #endif
-	{SIGPIPE,	"SIGPIPE"},
-	{SIGALRM,	"SIGALRM"},
-	{SIGTERM,	"SIGTERM"},
-	{SIGUSR1,	"SIGUSR1"},
-	{SIGUSR2,	"SIGUSR2"},
-	{SIGCHLD,	"SIGCHLD"},
-	{SIGPWR,	"SIGPWR"},
-	{SIGURG,	"SIGURG"},
-	{SIGPOLL,	"SIGPOLL"},
-	{SIGXCPU,	"SIGXCPU"},
-	{SIGXFSZ,	"SIGXFSZ"},
+	{ SIGPIPE,	"SIGPIPE" },
+	{ SIGALRM,	"SIGALRM" },
+	{ SIGTERM,	"SIGTERM" },
+	{ SIGUSR1,	"SIGUSR1" },
+	{ SIGUSR2,	"SIGUSR2" },
+	{ SIGCHLD,	"SIGCHLD" },
+	{ SIGPWR,	"SIGPWR" },
+	{ SIGURG,	"SIGURG" },
+	{ SIGPOLL,	"SIGPOLL" },
+	{ SIGXCPU,	"SIGXCPU" },
+	{ SIGXFSZ,	"SIGXFSZ" },
 #if HIDDEN
-	{SIGRTMIN,	"SIGRTMIN"},
-	{SIGRTMAX,	"SIGRTMAX"},
+	{ SIGRTMIN,	"SIGRTMIN" },
+	{ SIGRTMAX,	"SIGRTMAX" },
 #endif
-	{0,		"???"}
+	{ 0,		"???" }
 };
 
 static char *
diff --git a/common/mlog.c b/common/mlog.c
index 5feeafe..b79aad1 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -103,17 +103,17 @@ char *mlog_ss_names[MLOG_SS_CNT] = {
 };
 
 static mlog_sym_t mlog_sym[] = {
-	{"0",		MLOG_SILENT},
-	{"1",		MLOG_VERBOSE},
-	{"2",		MLOG_TRACE},
-	{"3",		MLOG_DEBUG},
-	{"4",		MLOG_NITTY},
-	{"5",		MLOG_NITTY + 1},
-	{"silent",	MLOG_SILENT},
-	{"verbose",	MLOG_VERBOSE},
-	{"trace",	MLOG_TRACE},
-	{"debug",	MLOG_DEBUG},
-	{"nitty",	MLOG_NITTY}
+	{ "0",		MLOG_SILENT },
+	{ "1",		MLOG_VERBOSE },
+	{ "2",		MLOG_TRACE },
+	{ "3",		MLOG_DEBUG },
+	{ "4",		MLOG_NITTY },
+	{ "5",		MLOG_NITTY + 1 },
+	{ "silent",	MLOG_SILENT },
+	{ "verbose",	MLOG_VERBOSE },
+	{ "trace",	MLOG_TRACE },
+	{ "debug",	MLOG_DEBUG },
+	{ "nitty",	MLOG_NITTY }
 };
 
 static qlockh_t mlog_qlockh;
diff --git a/common/stream.c b/common/stream.c
index 0bc6a34..42d87cb 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -208,7 +208,7 @@ stream_getix(pthread_t tid)
 	spm_t *p;							\
 	pthread_t mytid = pthread_self();				\
 									\
-	if (!pthread_equal(mytid, (tid))) {				\
+	if (!pthread_equal(mytid, (tid))) { \
 		mlog(MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,		\
 		      "stream_set_" #field_name "(): "			\
 		      "foreign stream (tid %lu) "			\
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index 8736bf2..07b1932 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -667,7 +667,7 @@ struct mt_fpmsg {
 	int		mm_mlen;
 	union {
 		char	mm_msg[MT_FPMSG_MAX_MSGLEN];	/* Generic format */
-		struct {			/* Format for IBM 3590 type*/
+		struct { /* Format for IBM 3590 type*/
 			char   display_type;	/* Display Type: Set to 0x80 */
 			char   msg_type:3,      /* Message type: 0x00 = General
 						 * Status message */
@@ -684,7 +684,7 @@ struct mt_fpmsg {
 			char   msg1[8];	        /* message 1 */
 			char   msg2[8];	        /* message 2 */
 		} ibm3590;
-		struct {		/* Format for Fujitsu Diana 1, 2, 3 */
+		struct { /* Format for Fujitsu Diana 1, 2, 3 */
 			char   display_mode:3,
 		               display_len:1,
 		               flash:1,
diff --git a/dump/content.c b/dump/content.c
index fe52a70..7890eb9 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -3553,7 +3553,7 @@ dump_extattr_list(drive_t *drivep,
 			if (dumpbufp > dumpbufendp) {
 				break;		/* won't fit in buffer */
 			}
-			if (valuep != NULL) {	/* if added to dump buffer */
+			if (valuep != NULL) { /* if added to dump buffer */
 				endp = dumpbufp;
 				opp->am_attrname = entp->a_name;
 				opp->am_attrvalue = valuep;
@@ -3705,7 +3705,7 @@ dump_extattr_list(drive_t *drivep,
 							     flag,
 							     &valuep);
 
-			if (dumpbufp < dumpbufendp) {	/* if fits in buffer */
+			if (dumpbufp < dumpbufendp) { /* if fits in buffer */
 				endp = dumpbufp;
 				(void)memcpy(valuep, hsmvaluep, hsmvaluesz);
 				hsmcursor++;
diff --git a/dump/inomap.c b/dump/inomap.c
index 7280ad4..240a767 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -775,7 +775,7 @@ supprt_prune(void *arg1,	/* ancestors marked as changed? */
 		return cbrval;
 	}
 
-	if (*(bool_t *)arg1 == BOOL_TRUE) {	/* shortcut, sibling changed */
+	if (*(bool_t *)arg1 == BOOL_TRUE) { /* shortcut, sibling changed */
 		return cbrval;
 	}
 
diff --git a/include/swab.h b/include/swab.h
index ce183bf..ae43b89 100644
--- a/include/swab.h
+++ b/include/swab.h
@@ -119,7 +119,7 @@ static __inline__ __u16 __swab16p(__u16 *x)
 }
 static __inline__ void __swab16s(__u16 *addr)
 {
-	(__extension__ ({__arch__swab16s(addr);}));
+	(__extension__ ({ __arch__swab16s(addr); }));
 }
 
 static __inline__ __u32 __fswab32(__u32 x)
@@ -132,7 +132,7 @@ static __inline__ __u32 __swab32p(__u32 *x)
 }
 static __inline__ void __swab32s(__u32 *addr)
 {
-	(__extension__ ({__arch__swab32s(addr);}));
+	(__extension__ ({ __arch__swab32s(addr); }));
 }
 
 static __inline__ __u64 __fswab64(__u64 x)
@@ -151,7 +151,7 @@ static __inline__ __u64 __swab64p(__u64 *x)
 }
 static __inline__ void __swab64s(__u64 *addr)
 {
-	(__extension__ ({__arch__swab64s(addr);}));
+	(__extension__ ({ __arch__swab64s(addr); }));
 }
 
 #endif /* SWAB_H */
diff --git a/inventory/inv_files.c b/inventory/inv_files.c
index ebc8035..a07fe28 100644
--- a/inventory/inv_files.c
+++ b/inventory/inv_files.c
@@ -92,7 +92,7 @@ inv_setup_base(void)
 		    new_sbuf.st_dev == old_sbuf.st_dev) {
 			old_exists = 0;	/* both the same, pretend */
 		}
-		else {	/* die! */
+		else { /* die! */
 			return 0;
 		}
 	}
diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
index d54c0df..ab29b7a 100644
--- a/inventory/inv_oref.h
+++ b/inventory/inv_oref.h
@@ -172,35 +172,35 @@ typedef struct invt_oref {
 	  (oref)->type |= INVT_RES_ENTRIES; }
 
 #define OREF_SET_HDRS(oref, hdrs) \
-        {  assert ((oref)->type & INVT_OTYPE_STOBJ); \
+        { assert ((oref)->type & INVT_OTYPE_STOBJ); \
 	   assert ((oref)->type & INVT_RES_COUNTERS); \
 	   (oref)->eu_hdr = hdrs; \
 	   (oref)->type |= INVT_STOBJ_RES_HDRS; }
 
 #define OREF_SET_SESSIONS(oref, ses) \
-        {  assert ((oref)->type & INVT_OTYPE_STOBJ); \
+        { assert ((oref)->type & INVT_OTYPE_STOBJ); \
 	   assert ((oref)->type & INVT_RES_COUNTERS); \
 	   (oref)->eu_ses = ses; \
 	   (oref)->type |= INVT_STOBJ_RES_SESSIONS; }
 
 #define OREF_SET_STRMS(oref, strms) \
-        {  assert ((oref)->type & INVT_OTYPE_STOBJ); \
+        { assert ((oref)->type & INVT_OTYPE_STOBJ); \
 	   assert ((oref)->type & INVT_RES_COUNTERS); \
 	   (oref)->eu_strm = strms; \
 	   (oref)->type |= INVT_STOBJ_RES_STRMS; }
 
 #define OREF_SET_CHILD(oref, stobjref) \
-        {  assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
+        { assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
 	   (oref)->ku_child = stobjref; \
 	   (oref)->type |= INVT_RES_CHILD; }
 
 #define OREF_SET_PARENT(oref, invidxref) \
-        {  assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
+        { assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
 	   (oref)->ku_parent = invidxref; \
 	   (oref)->type |= INVT_RES_PARENT; }
 
 #define OREF_UNRESOLVE_CHILD(oref) \
-        {  assert (OREF_ISRESOLVED(oref, INVT_RES_CHILD)); \
+        { assert (OREF_ISRESOLVED(oref, INVT_RES_CHILD)); \
 	   close((oref)->ku_child->fd); \
 	   OREF_DESTROY((oref)->ku_child); \
 	   (oref)->ku_child = 0; \
diff --git a/invutil/cmenu.c b/invutil/cmenu.c
index a1704ed..a9ca301 100644
--- a/invutil/cmenu.c
+++ b/invutil/cmenu.c
@@ -43,17 +43,17 @@ WINDOW	*mainmenu;
 WINDOW	*infowin;
 
 menukey_t keyv[] = {
-    {'+',	"| +:       Expand           |",	menu_expand	},
-    {'-',	"| -:       Collapse         |",	menu_collapse	},
-    {'*',	"| *:       Expand Tree      |",	menu_expandall	},
-    {'%',	"| %:       Collapse Tree    |",	menu_collapseall},
-    {'d',	"| d:       Delete           |",	menu_delete	},
-    {'u',	"| u:       Undelete         |",	menu_undelete	},
-    {'i',	"| i:       Import Inventory |",	menu_import	},
-    {'x',	"| x:       Commit & Exit    |",	menu_commit	},
-    {'q',	"| q:       Quit             |",	menu_quit	},
-    {' ',	"| <space>: Select           |",	menu_select	},
-    {KEY_ENTER,	NULL,					menu_select	},
+    { '+',	"| +:       Expand           |",	menu_expand },
+    { '-',	"| -:       Collapse         |",	menu_collapse },
+    { '*',	"| *:       Expand Tree      |",	menu_expandall },
+    { '%',	"| %:       Collapse Tree    |",	menu_collapseall },
+    { 'd',	"| d:       Delete           |",	menu_delete },
+    { 'u',	"| u:       Undelete         |",	menu_undelete },
+    { 'i',	"| i:       Import Inventory |",	menu_import },
+    { 'x',	"| x:       Commit & Exit    |",	menu_commit },
+    { 'q',	"| q:       Quit             |",	menu_quit },
+    { ' ',	"| <space>: Select           |",	menu_select },
+    { KEY_ENTER,	NULL,					menu_select },
 };
 
 /*ARGSUSED*/
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 774602d..15555af 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -358,7 +358,7 @@ ParseDate(char *strDate)
         "%B %d",
         "%m%d%H",
         "%m%d",
-        0};
+        0 };
 
     for (fmt = &templateStr[0]; *fmt != NULL; fmt++) {
         memset (&tm, 0, sizeof (struct tm)); /* ensure fields init'ed */
diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
index 3e7a7ed..f74e595 100644
--- a/librmt/rmtioctl.c
+++ b/librmt/rmtioctl.c
@@ -104,8 +104,8 @@ struct linux64_mtget
 #define STD_MTOFFL  6       /* rewind and put the drive offline */
 
 #define MT_MAX 40 /* encompass potential range of mt_op values */
-static int mtop_irixmap[MT_MAX] = {-1};
-static int mtop_stdmap[MT_MAX] = {-1};
+static int mtop_irixmap[MT_MAX] = { -1 };
+static int mtop_stdmap[MT_MAX] = { -1 };
 
 static void
 init_mtop_map(void)
diff --git a/librmt/rmtopen.c b/librmt/rmtopen.c
index ea6e218..bdea8cc 100644
--- a/librmt/rmtopen.c
+++ b/librmt/rmtopen.c
@@ -39,9 +39,9 @@
 
 static int _rmt_open(char *, int, int);
 
-int _rmt_Ctp[MAXUNIT][2] = { {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1} };
-int _rmt_Ptc[MAXUNIT][2] = { {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1} };
-int _rmt_host[MAXUNIT] = { -1, -1, -1, -1};
+int _rmt_Ctp[MAXUNIT][2] = { {-1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
+int _rmt_Ptc[MAXUNIT][2] = { {-1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } };
+int _rmt_host[MAXUNIT] = { -1, -1, -1, -1 };
 
 struct uname_table
 {
@@ -50,7 +50,7 @@ struct uname_table
 };
 
 struct uname_table uname_table[] =
-{ {UNAME_LINUX, "Linux"}, {UNAME_IRIX, "IRIX"}, {0, 0} };
+{ {UNAME_LINUX, "Linux" }, { UNAME_IRIX, "IRIX" }, { 0, 0 } };
 
 
 /*
diff --git a/restore/content.c b/restore/content.c
index a97d9e3..dec3e44 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -2462,7 +2462,7 @@ content_stream_restore(ix_t thrdix)
 			unlock();
 #if DEBUG_DUMPSTREAMS
 			{
-			    static int count[STREAM_MAX] = {0};
+			    static int count[STREAM_MAX] = { 0 };
 			    int streamix = stream_getix(pthread_self());
 			    if (++(count[streamix]) == 30) {
 				mlog(MLOG_TRACE,
@@ -2637,7 +2637,7 @@ content_stream_restore(ix_t thrdix)
 			unlock();
 #if DEBUG_DUMPSTREAMS
 			{
-			static int count[STREAM_MAX] = {0};
+			static int count[STREAM_MAX] = { 0 };
 			int streamix = stream_getix(pthread_self());
 			    if (++(count[streamix]) == 30) {
 				mlog(MLOG_NORMAL,
@@ -3876,7 +3876,7 @@ finalize(char *path1, char *path2)
 		/*
 		 * restore directory attributes
 		 */
-		if (! persp->s.dirattrdonepr) {;
+		if (! persp->s.dirattrdonepr) { ;
 			ok = tree_setattr(path1);
 			if (! ok) {
 				return RV_INTR;
@@ -3887,7 +3887,7 @@ finalize(char *path1, char *path2)
 		/*
 		 * remove orphanage if empty
 		 */
-		if (! persp->s.orphdeltriedpr) {;
+		if (! persp->s.orphdeltriedpr) { ;
 			ok = tree_delorph();
 			if (! ok) {
 				return RV_INTR;
diff --git a/restore/mmap.c b/restore/mmap.c
index 0407740..96711e7 100644
--- a/restore/mmap.c
+++ b/restore/mmap.c
@@ -33,7 +33,7 @@ mmap_autogrow(size_t len, int fd, off_t offset)
     char nul_buffer[] = "";
 
     /* prealloc file if it is an empty file */
-    if (fstat(fd, &buf) == -1) {;
+    if (fstat(fd, &buf) == -1) { ;
 	return (void*)MAP_FAILED;
     }
     if (buf.st_size < offset+len) {
diff --git a/restore/tree.c b/restore/tree.c
index d2637ce..e5abcd9 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -4969,15 +4969,15 @@ struct escape_table {
 typedef struct escape_table escape_table_t;
 
 static escape_table_t escape_table[] = {
- {	'n',	'\n' },
- {	't',	'\t' },
- {	'v',	'\v' },
- {	'b',	'\b' },
- {	'r',	'\r' },
- {	'f',	'\f' },
- {	'f',	'\f' },
- {	'a',	'\a' },
- {	'\\',	'\\' }
+ { 'n',	'\n' },
+ { 't',	'\t' },
+ { 'v',	'\v' },
+ { 'b',	'\b' },
+ { 'r',	'\r' },
+ { 'f',	'\f' },
+ { 'f',	'\f' },
+ { 'a',	'\a' },
+ { '\\',	'\\' }
 };
 
 static void shrink(char *s, size_t cnt);
-- 
2.19.1
