Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLNNEg0082609 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 17:23:14 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5057B8F806F
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 15:23:54 -0800 (PST)
Received: from [128.162.233.117] (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id 1FCE570001C8
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 17:23:54 -0600 (CST)
Message-ID: <4B300389.7020905@sgi.com>
Date: Mon, 21 Dec 2009 17:23:53 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] use time32_t consistently in xfsdump tree
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfsdump stores time_t as 32-bits in its dump and inventory
structures for portability/historical reasons. xfsinvutil
uses time_t directly, leading to some strange results on
systems which have a 64-bit time_t.

The 32-bit time-related functions were factored out into
their own file since they are now used by xfsinvutil, and
their original file (util.c) could not easily be linked
with xfsinvutil due to dependencies on many other
dump/restore modules.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
  .gitignore            |    3 +++
  common/Makefile       |    2 +-
  common/util.c         |   20 --------------------
  common/util.h         |   11 -----------
  dump/Makefile         |    2 ++
  dump/content.c        |    1 +
  inventory/inv_stobj.c |    2 +-
  invutil/Makefile      |    5 ++++-
  invutil/cmenu.c       |    4 ++--
  invutil/cmenu.h       |    2 +-
  invutil/fstab.c       |    2 +-
  invutil/fstab.h       |    2 +-
  invutil/invidx.c      |   32 ++++++--------------------------
  invutil/invidx.h      |    3 +--
  invutil/invutil.c     |   45 +++++++++++++++++++++++++++------------------
  invutil/invutil.h     |   10 +++++-----
  invutil/stobj.c       |    5 +++--
  invutil/stobj.h       |    2 +-
  restore/Makefile      |    2 ++
  restore/content.c     |    4 ++--
  20 files changed, 64 insertions(+), 95 deletions(-)

Index: xfsdump-kernel.org/common/Makefile
===================================================================
--- xfsdump-kernel.org.orig/common/Makefile
+++ xfsdump-kernel.org/common/Makefile
@@ -14,7 +14,7 @@ LSRCFILES = arch_xlate.c arch_xlate.h \
  	main.c media.c media.h media_rmvtape.h mlog.c mlog.h \
  	namreg.c namreg.h openutil.c openutil.h path.c path.h qlock.c qlock.h \
  	rec_hdr.h ring.c ring.h sproc.c sproc.h stream.c \
-	stream.h ts_mtio.h types.h util.c util.h
+	stream.h timeutil.h timeutil.c ts_mtio.h types.h util.c util.h

  default install install-dev :

Index: xfsdump-kernel.org/common/util.c
===================================================================
--- xfsdump-kernel.org.orig/common/util.c
+++ xfsdump-kernel.org/common/util.c
@@ -22,7 +22,6 @@

  #include <sys/stat.h>
  #include <sys/ioctl.h>
-#include <time.h>
  #include <fcntl.h>
  #include <errno.h>
  #include <dirent.h>
@@ -508,25 +507,6 @@ diriter( jdm_fshandle_t *fshandlep,
  	}
  }

-char *
-ctime32(const time32_t *timep)
-{
-   time_t t = (time_t) *timep;
-   return ctime(&t);
-}
-
-char *
-ctimennl( const time32_t *clockp )
-{
-	char *p = ctime32( clockp );
-
-	if ( p && strlen( p ) > 0 ) {
-		p[ strlen( p ) - 1 ] = 0;
-	}
-
-	return p;
-}
-
  int
  cvtnum( int blocksize, char *s )
  {
Index: xfsdump-kernel.org/common/util.h
===================================================================
--- xfsdump-kernel.org.orig/common/util.h
+++ xfsdump-kernel.org/common/util.h
@@ -146,17 +146,6 @@ extern intgen_t diriter( jdm_fshandle_t
  			 size_t usrgdsz );


-
-/* ctimennl - ctime(3C) with newline removed
- */
-extern char *ctimennl( const time32_t *clockp );
-
-/* ctime32 - takes a time32_t instead of a time_t
- */
-extern char *ctime32( const time32_t *timep );
-
-
-
  /* fold_t - a character string made to look like a "fold here"
   */
  #define FOLD_LEN	79
Index: xfsdump-kernel.org/dump/Makefile
===================================================================
--- xfsdump-kernel.org.orig/dump/Makefile
+++ xfsdump-kernel.org/dump/Makefile
@@ -26,6 +26,7 @@ COMMINCL = \
  	qlock.h \
  	ring.h \
  	stream.h \
+	timeutil.h \
  	ts_mtio.h \
  	types.h \
  	util.h \
@@ -66,6 +67,7 @@ COMMON = \
  	path.c \
  	ring.c \
  	stream.c \
+	timeutil.c \
  	util.c \
  	sproc.c

Index: xfsdump-kernel.org/dump/content.c
===================================================================
--- xfsdump-kernel.org.orig/dump/content.c
+++ xfsdump-kernel.org/dump/content.c
@@ -42,6 +42,7 @@
  #include "exit.h"
  #include "types.h"
  #include "path.h"
+#include "timeutil.h"
  #include "util.h"
  #include "lock.h"
  #include "qlock.h"
Index: xfsdump-kernel.org/inventory/inv_stobj.c
===================================================================
--- xfsdump-kernel.org.orig/inventory/inv_stobj.c
+++ xfsdump-kernel.org/inventory/inv_stobj.c
@@ -28,7 +28,7 @@
  #include <sys/mman.h>

  #include "types.h"
-#include "util.h"
+#include "timeutil.h"
  #include "mlog.h"
  #include "inv_priv.h"
  #include "arch_xlate.h"
Index: xfsdump-kernel.org/invutil/Makefile
===================================================================
--- xfsdump-kernel.org.orig/invutil/Makefile
+++ xfsdump-kernel.org/invutil/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
  COMMINCL = \
  	global.h \
  	mlog.h \
-	util.h \
+	timeutil.h \
  	types.h

  INVINCL = \
@@ -18,6 +18,9 @@ INVINCL = \
  INVCOMMON = \
  	inv_files.c

+COMMON = \
+	 timeutil.c
+
  CURSESCOMMON = \
  	cmenu.c \
  	fstab.c \
Index: xfsdump-kernel.org/invutil/invidx.c
===================================================================
--- xfsdump-kernel.org.orig/invutil/invidx.c
+++ xfsdump-kernel.org/invutil/invidx.c
@@ -32,6 +32,7 @@
  #include "list.h"
  #include "invidx.h"
  #include "stobj.h"
+#include "timeutil.h"

  invidx_fileinfo_t *invidx_file;
  int invidx_numfiles;
@@ -418,27 +419,6 @@ delete_stobj_entries(int fd, int deletep
  }

  int
-find_invidx_insert_point(int fd, time_t sh_time)
-{
-    int i;
-    invt_counter_t cnt;
-    invt_entry_t tmpentry;
-
-    lseek(fd, 0, SEEK_SET);
-    read_n_bytes(fd, (char *)&cnt, sizeof(cnt), "invidx file");
-
-    for(i = 0; i < cnt.ic_curnum; i++) {
-	read_n_bytes(fd, (char *)&tmpentry, sizeof(tmpentry), "invidx file");
-	if(tmpentry.ie_timeperiod.tp_start <= sh_time
-	   && tmpentry.ie_timeperiod.tp_end >= sh_time) {
-	    break;
-	}
-    }
-
-    return i;
-}
-
-int
  find_stobj_insert_point(int fd, invt_seshdr_t *hdr)
  {
      int i;
@@ -462,8 +442,8 @@ int
  update_invidx_entry(int fd, char *filename, int stobj_fd)
  {
      int i;
-    time_t start_time;
-    time_t end_time;
+    time32_t start_time;
+    time32_t end_time;
      invt_counter_t cnt;
      invt_seshdr_t hdr;
      invt_sescounter_t sescnt;
@@ -718,11 +698,11 @@ invidx_highlight(WINDOW *win, node_t *cu
      snprintf(txt, sizeof(txt), "path:  %s", invtentry->ie_filename);
      put_info_line(1, txt);

-    snprintf(txt, sizeof(txt), "start: %s", ctime((time_t*)&invtentry->ie_timeperiod.tp_start));
+    snprintf(txt, sizeof(txt), "start: %s", ctime32(&invtentry->ie_timeperiod.tp_start));
      txt[strlen(txt) - 1] = '\0';
      put_info_line(2, txt);

-    snprintf(txt, sizeof(txt), "end:   %s", ctime((time_t*)&invtentry->ie_timeperiod.tp_end));
+    snprintf(txt, sizeof(txt), "end:   %s", ctime32(&invtentry->ie_timeperiod.tp_end));
      txt[strlen(txt) - 1] = '\0';
      put_info_line(3, txt);

@@ -757,7 +737,7 @@ invidx_undelete(WINDOW *win, node_t *cur

  /*ARGSUSED*/
  int
-invidx_prune(char *mountpt, uuid_t *uuidp, time_t prunetime, node_t *node, node_t *list)
+invidx_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list)
  {
      data_t *d;
      invt_entry_t *invidx_entry;
Index: xfsdump-kernel.org/invutil/invutil.c
===================================================================
--- xfsdump-kernel.org.orig/invutil/invutil.c
+++ xfsdump-kernel.org/invutil/invutil.c
@@ -29,6 +29,7 @@
  #include "mlog.h"
  #include "inv_priv.h"
  #include "getopt.h"
+#include "timeutil.h"
  #include "invutil.h"

  char	*g_programName;
@@ -43,7 +44,7 @@ bool_t	redraw_options = BOOL_FALSE;

  #ifndef HAVE_CURSES
  int
-invutil_interactive(char *path, char *mountpt, uuid_t *uuidp, time_t timeSecs)
+invutil_interactive(char *path, char *mountpt, uuid_t *uuidp, time32_t timeSecs)
  {
  	fprintf(stderr, "%s: libcurses support not compiled in, "
  			"interactive mode is unavailable.\n", g_programName);
@@ -161,13 +162,13 @@ main(int argc, char *argv[])

      if (check_option) {
          char *tempstr = "test";
-        time_t temptime = 0;
+        time32_t temptime = 0;
          CheckAndPruneFstab(inventory_path, BOOL_TRUE, tempstr, &uuid,
  		temptime, NULL);
      }
      else if (uuid_option || mntpnt_option) {
          char *dateStr;
-        time_t timeSecs;
+        time32_t timeSecs;

          if (optind != (argc - 1) ) {
              fprintf( stderr, "%s: Date missing for prune option\n",
@@ -189,7 +190,7 @@ main(int argc, char *argv[])
      }
      else if ( interactive_option ) {
          char *dateStr;
-        time_t timeSecs;
+        time32_t timeSecs;

          if (optind != (argc - 1) ) {
  	    timeSecs = 0;
@@ -237,11 +238,12 @@ mntpnt_equal(char *s1, char *s2)
  }


-time_t
+time32_t
  ParseDate(char *strDate)
  {
      struct tm tm;
      time_t date = 0;
+    time32_t date32;
      char **fmt;
      char *templateStr[] = {
          "%m/%d/%Y %I:%M:%S %p",
@@ -304,13 +306,21 @@ ParseDate(char *strDate)
          date = mktime(&tm);
      }

+    /* xfsdump inventory uses time32_t for portability.
+     * make sure the given date did not overflow... */
+    date32 = date;
+    if (date32 != date) {
+        fprintf(stderr, "%s: date out of range: \"%s\"\n", g_programName, strDate);
+        usage();
+    }
+
  #ifdef INV_DEBUG
      printf("INV_DEBUG: the date entered is %s\n", strDate);
      printf("INV_DEBUG: the hour parsed from string is %d\n", tm.tm_hour);
-    printf("INV_DEBUG: the date entered in secs is %ld\n", date);
+    printf("INV_DEBUG: the date entered in secs is %d\n", date32);
  #endif /* INV_DEBUG */

-    return date;
+    return date32;
  }

  char *
@@ -360,7 +370,7 @@ GetFstabFullPath(char *inv_path)

  void
  CheckAndPruneFstab(char *inv_path, bool_t checkonly, char *mountPt,
-	uuid_t *uuidp, time_t prunetime, char *r_mf_label)
+	uuid_t *uuidp, time32_t prunetime, char *r_mf_label)
  {
      char	*fstabname;
      char	*mapaddr;
@@ -502,7 +512,7 @@ CheckAndPruneFstab(char *inv_path, bool_
  int
  CheckAndPruneInvIndexFile( bool_t checkonly,
  			   char *idxFileName,
-			   time_t prunetime,
+			   time32_t prunetime,
  			   char *r_mf_label)
  {
      char	*temp;
@@ -544,8 +554,8 @@ CheckAndPruneInvIndexFile( bool_t checko
  	       "          %s\n", invIndexEntry[i].ie_filename);
  	if (debug) {
  	    printf("          Time:\tbegin  %s\t\tend    %s",
-		   ctime((time_t *)&(invIndexEntry[i].ie_timeperiod.tp_start)),
-		   ctime((time_t *)&(invIndexEntry[i].ie_timeperiod.tp_end)));
+		   ctime32(&(invIndexEntry[i].ie_timeperiod.tp_start)),
+		   ctime32(&(invIndexEntry[i].ie_timeperiod.tp_end)));
  	}

  	if (( access( invIndexEntry[i].ie_filename, R_OK | W_OK ) == -1)  &&
@@ -620,7 +630,7 @@ CheckAndPruneInvIndexFile( bool_t checko
  int
  CheckAndPruneStObjFile( bool_t checkonly,
  			char *StObjFileName,
-			time_t prunetime,
+			time32_t prunetime,
  		        char *r_mf_label)
  {
      char	response[GEN_STRLEN];
@@ -672,7 +682,7 @@ CheckAndPruneStObjFile( bool_t checkonly
  	    printf("            Session %d: %s %s",
  		   sescount++,
  		   StObjses->s_mountpt,
-		   ctime( (time_t *)&StObjhdr->sh_time ));
+		   ctime32(&StObjhdr->sh_time));
  	}
  	if (debug) {
  	    /* Note that the DMF people use some of this debug
@@ -693,7 +703,7 @@ CheckAndPruneStObjFile( bool_t checkonly
  	    if (StObjhdr->sh_pruned)
  		printf("            Pruned Session: %s %s",
  		       StObjses->s_mountpt,
-		       ctime( (time_t *)&StObjhdr->sh_time ));
+		       ctime32(&StObjhdr->sh_time));
  	    printf("\t\tdevice:\t\t%s\n", StObjses->s_devpath);
  	    printf("\t\tsession label:\t\"%s\"\n", StObjses->s_label);
  	    uuid_unparse( StObjses->s_sesid, str );
@@ -733,7 +743,7 @@ CheckAndPruneStObjFile( bool_t checkonly
  	}

  #ifdef INV_DEBUG
-        printf("INV_DEBUG: sh_time = %ld, prunetime = %ld\n",
+        printf("INV_DEBUG: sh_time = %d, prunetime = %d\n",
  	       StObjhdr->sh_time, prunetime);
          printf("INV_DEBUG: checkonly = %d, sh_pruned = %d\n",
                 checkonly, StObjhdr->sh_pruned);
@@ -755,7 +765,7 @@ CheckAndPruneStObjFile( bool_t checkonly
  			"LABEL\t\t:\t%s\n"
  			"TIME OF DUMP\t:\t%s",
                          str, StObjses->s_mountpt, StObjses->s_devpath,
-                        StObjses->s_label, ctime( (time_t *)&StObjhdr->sh_time ));
+                        StObjses->s_label, ctime32(&StObjhdr->sh_time));
  		removeflag = BOOL_TRUE;
  	    }
  	    else {
@@ -764,7 +774,7 @@ CheckAndPruneStObjFile( bool_t checkonly
  		printf("UUID\t\t:\t%s\nMOUNT POINT\t:\t%s\n"
  		       "DEV PATH\t:\t%s\nTIME OF DUMP\t:\t%s",
  		       str, StObjses->s_mountpt, StObjses->s_devpath,
-		       ctime( (time_t *)&StObjhdr->sh_time ));
+		       ctime32(&StObjhdr->sh_time));
  		while ( GotResponse == BOOL_FALSE )
  		{
  		    char *chp;
@@ -1105,4 +1115,3 @@ usage (void)

      exit(1);
  }
-
Index: xfsdump-kernel.org/invutil/stobj.c
===================================================================
--- xfsdump-kernel.org.orig/invutil/stobj.c
+++ xfsdump-kernel.org/invutil/stobj.c
@@ -27,6 +27,7 @@
  #include "getopt.h"

  #include "invutil.h"
+#include "timeutil.h"
  #include "cmenu.h"
  #include "list.h"
  #include "stobj.h"
@@ -184,7 +185,7 @@ stobjsess_highlight(WINDOW *win, node_t
      snprintf(txt, sizeof(txt), "pruned:  %s, flags: %#x, time: %s",
  	    (stobjhdr->sh_pruned == BOOL_TRUE) ? "yes" : "no",
  	    stobjhdr->sh_flag,
-	    ctime((time_t *)&(stobjhdr->sh_time)));
+	    ctime32(&(stobjhdr->sh_time)));
      txt[strlen(txt)-1] = '\0';
      put_info_line(1, txt);

@@ -291,7 +292,7 @@ stobj_select(WINDOW *win, node_t *curren

  /*ARGSUSED*/
  int
-stobj_prune(char *mountpt, uuid_t *uuidp, time_t prunetime, node_t *node, node_t *list)
+stobj_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list)
  {
      data_t *d;
      stobjsess_t *stobj;
Index: xfsdump-kernel.org/restore/Makefile
===================================================================
--- xfsdump-kernel.org.orig/restore/Makefile
+++ xfsdump-kernel.org/restore/Makefile
@@ -27,6 +27,7 @@ COMMINCL = \
  	ring.h \
  	sproc.h \
  	stream.h \
+	timeutil.h \
  	ts_mtio.h \
  	types.h \
  	util.h
@@ -65,6 +66,7 @@ COMMON = \
  	ring.c \
  	sproc.c \
  	stream.c \
+	timeutil.c \
  	util.c

  LOCALS = \
Index: xfsdump-kernel.org/restore/content.c
===================================================================
--- xfsdump-kernel.org.orig/restore/content.c
+++ xfsdump-kernel.org/restore/content.c
@@ -37,6 +37,7 @@
  #include <malloc.h>

  #include "types.h"
+#include "timeutil.h"
  #include "util.h"
  #include "cldmgr.h"
  #include "qlock.h"
@@ -9347,7 +9348,6 @@ display_dump_label( bool_t lockpr,
  	char dump_string_uuid[UUID_STR_LEN + 1];
  	char media_string_uuid[UUID_STR_LEN + 1];
  	char fs_string_uuid[UUID_STR_LEN + 1];
-	time_t gh_timestamp = (time_t)grhdrp->gh_timestamp;

  	ASSERT( scrhdrp->cih_level >= 0 );
  	ASSERT( scrhdrp->cih_level < 10 );
@@ -9376,7 +9376,7 @@ display_dump_label( bool_t lockpr,
  	      crhdrp->ch_fsdevice );
  	mlog( mllevel | MLOG_NOLOCK,
  	      _("session time: %s"),
-	      ctime_r( &gh_timestamp, dateline ));
+	      ctime32_r( &grhdrp->gh_timestamp, dateline ));
  	mlog( mllevel | MLOG_NOLOCK,
  	      _("level: %s%s\n"),
  	      level_string,
Index: xfsdump-kernel.org/.gitignore
===================================================================
--- xfsdump-kernel.org.orig/.gitignore
+++ xfsdump-kernel.org/.gitignore
@@ -85,6 +85,7 @@ dump/rec_hdr.h
  dump/ring.[ch]
  dump/sproc.[ch]
  dump/stream.[ch]
+dump/timeutil.[ch]
  dump/ts_mtio.h
  dump/types.h
  dump/util.[ch]
@@ -94,6 +95,7 @@ invutil/inv_files.c
  invutil/inv_priv.h
  invutil/inventory.h
  invutil/mlog.h
+invutil/timeutil.[ch]
  invutil/types.h
  invutil/util.h

@@ -131,6 +133,7 @@ restore/rec_hdr.h
  restore/ring.[ch]
  restore/sproc.[ch]
  restore/stream.[ch]
+restore/timeutil.[ch]
  restore/ts_mtio.h
  restore/types.h
  restore/util.[ch]
Index: xfsdump-kernel.org/invutil/cmenu.c
===================================================================
--- xfsdump-kernel.org.orig/invutil/cmenu.c
+++ xfsdump-kernel.org/invutil/cmenu.c
@@ -470,7 +470,7 @@ list_undelete(node_t *current, node_t *l
  }

  int
-list_prune(node_t *menulist, char *mountpt, uuid_t *uuidp, time_t prunetime)
+list_prune(node_t *menulist, char *mountpt, uuid_t *uuidp, time32_t prunetime)
  {
      node_t *n;
      data_t *d;
@@ -565,7 +565,7 @@ create_windows()
  }

  int
-invutil_interactive(char *inv_path, char *mountpt, uuid_t *uuidp, time_t timeSecs)
+invutil_interactive(char *inv_path, char *mountpt, uuid_t *uuidp, time32_t timeSecs)
  {
      int		keyc;
      node_t	*menulist;
Index: xfsdump-kernel.org/invutil/cmenu.h
===================================================================
--- xfsdump-kernel.org.orig/invutil/cmenu.h
+++ xfsdump-kernel.org/invutil/cmenu.h
@@ -55,7 +55,7 @@ typedef struct menu_ops_s {
      int (* op_highlight		) (WINDOW *win, node_t *current, node_t *list);
      int (* op_unhighlight	) (WINDOW *win, node_t *current, node_t *list);
      int (* op_commit		) (WINDOW *win, node_t *current, node_t *list);
-    int (* op_prune		) (char *mountpt, uuid_t *uuidp, time_t prunetime, node_t *node, node_t *list);
+    int (* op_prune		) (char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
  } menu_ops_t;

  typedef struct {
Index: xfsdump-kernel.org/invutil/fstab.c
===================================================================
--- xfsdump-kernel.org.orig/invutil/fstab.c
+++ xfsdump-kernel.org/invutil/fstab.c
@@ -172,7 +172,7 @@ fstab_highlight(WINDOW *win, node_t *cur

  /*ARGSUSED*/
  int
-fstab_prune(char *mountpt, uuid_t *uuidp, time_t prunetime, node_t *node, node_t *list)
+fstab_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list)
  {
      data_t		*d;
      invt_fstab_t	*fstabentry;
Index: xfsdump-kernel.org/invutil/fstab.h
===================================================================
--- xfsdump-kernel.org.orig/invutil/fstab.h
+++ xfsdump-kernel.org/invutil/fstab.h
@@ -33,6 +33,6 @@ int find_matching_fstab(int fidx, invt_f
  int fstab_select(WINDOW *win, node_t *current, node_t *list);
  int fstab_highlight(WINDOW *win, node_t *current, node_t *list);
  int fstab_commit(WINDOW *win, node_t *current, node_t *list);
-int fstab_prune(char *mountpt, uuid_t *uuidp, time_t prunetime, node_t *node, node_t *list);
+int fstab_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);

  #endif /* FSTAB_H */
Index: xfsdump-kernel.org/invutil/invidx.h
===================================================================
--- xfsdump-kernel.org.orig/invutil/invidx.h
+++ xfsdump-kernel.org/invutil/invidx.h
@@ -33,7 +33,6 @@ void *remmap_invidx(int fidx, int num);
  int find_matching_stobjfile(char *filename);
  int find_matching_invidxfile(char *filename);
  int find_overlapping_invidx(int fidx, invt_entry_t *inv_entry);
-int find_invidx_insert_point(int fd, time_t sh_time);
  int find_invidx_insert_pos(int fidx, invt_entry_t *inv_entry);
  char *get_inventry_stobjfile(data_t *d);
  node_t *find_invidx_node(node_t *list, int inv_fileidx);
@@ -47,6 +46,6 @@ int invidx_undelete(WINDOW *win, node_t
  int invidx_select(WINDOW *win, node_t *current, node_t *list);
  int invidx_highlight(WINDOW *win, node_t *current, node_t *list);
  int invidx_commit(WINDOW *win, node_t *current, node_t *list);
-int invidx_prune(char *mountpt, uuid_t *uuidp, time_t prunetime, node_t *node, node_t *list);
+int invidx_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);

  #endif /* INVIDX_H */
Index: xfsdump-kernel.org/invutil/invutil.h
===================================================================
--- xfsdump-kernel.org.orig/invutil/invutil.h
+++ xfsdump-kernel.org/invutil/invutil.h
@@ -44,12 +44,12 @@ extern bool_t	wait_for_locks;
  char *	GetFstabFullPath(char *);
  char *	GetNameOfInvIndex (char *, uuid_t);
  char *	GetNameOfStobj (char *inv_path, char *filename);
-void	CheckAndPruneFstab(char *, bool_t, char *, uuid_t *, time_t, char *);
-int	CheckAndPruneInvIndexFile( bool_t, char *, time_t, char *);
-int	CheckAndPruneStObjFile( bool_t, char *, time_t, char *);
+void	CheckAndPruneFstab(char *, bool_t, char *, uuid_t *, time32_t, char *);
+int	CheckAndPruneInvIndexFile( bool_t, char *, time32_t, char *);
+int	CheckAndPruneStObjFile( bool_t, char *, time32_t, char *);
  int	uses_specified_mf_label(
  		invt_seshdr_t *, invt_session_t *, char	*, char *);
-time_t	ParseDate(char *);
+time32_t ParseDate(char *);
  void	usage (void);
  int	open_and_lock(char *, Open_t, uint);
  void	read_n_bytes(int, void *, size_t, char *);
@@ -58,7 +58,7 @@ void *	mmap_n_bytes(int, size_t, bool_t,
  void	ListFstab(void);
  int	ListInvIndexFile( char *);
  int	ListStObjFile(char *);
-int	invutil_interactive(char *, char *, uuid_t *, time_t timeSecs);
+int	invutil_interactive(char *, char *, uuid_t *, time32_t timeSecs);
  int	mntpnt_equal(char *s1, char *s2);

  #endif /* INVUTIL_H */
Index: xfsdump-kernel.org/invutil/stobj.h
===================================================================
--- xfsdump-kernel.org.orig/invutil/stobj.h
+++ xfsdump-kernel.org/invutil/stobj.h
@@ -33,7 +33,7 @@ int stobjstrm_highlight(WINDOW *win, nod
  int stobjmed_highlight(WINDOW *win, node_t *current, node_t *list);
  int stobj_select(WINDOW *win, node_t *current, node_t *list);
  int stobjsess_commit(WINDOW *win, node_t *current, node_t *list);
-int stobj_prune(char *mountpt, uuid_t *uuidp, time_t prunetime, node_t *node, node_t *list);
+int stobj_prune(char *mountpt, uuid_t *uuidp, time32_t prunetime, node_t *node, node_t *list);
  int stobj_undelete(WINDOW *win, node_t *current, node_t *list);
  int stobjmed_commit(WINDOW *win, node_t *current, node_t *list);
  int stobjstrm_commit(WINDOW *win, node_t *current, node_t *list);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
