Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNFKJaf245499 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 09:20:20 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66C0DAC01A
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 07:21:00 -0800 (PST)
Date: Wed, 23 Dec 2009 09:20:59 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: Re: [PATCH] improve xfsinvutil man page and argument processing
Message-ID: <20091223152057.GA21306@sgi.com>
References: <4B300507.1070502@sgi.com> <20091223133321.GA10982@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091223133321.GA10982@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Dec 23, 2009 at 08:33:21AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 21, 2009 at 05:30:15PM -0600, Bill Kendall wrote:
> > xfsinvtuil's man page is not clear about which options
> > may be used together. The argument processing was
> > not very complete either. Document and enforce the
> > following:
> 
> Looks good,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reposting to fix whitespace issues introduced by mailer.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---

Index: xfsdump-kernel.org/invutil/invutil.c
===================================================================
--- xfsdump-kernel.org.orig/invutil/invutil.c
+++ xfsdump-kernel.org/invutil/invutil.c
@@ -76,10 +76,23 @@ main(int argc, char *argv[])
 	    debug = BOOL_TRUE;
 	    break;
 	case GETOPT_INTERACTIVE:
+	    if (force) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_FORCE,
+			 c );
+		usage();
+	    }
 	    interactive_option = BOOL_TRUE;
 	    break;
-	case GETOPT_NONINTERACTIVE:
-	    interactive_option = BOOL_FALSE;
+	case GETOPT_NONINTERACTIVE: /* obsoleted by -F */
+	    if (interactive_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_INTERACTIVE,
+			 c );
+		usage();
+	    }
 	    force = BOOL_TRUE;
 	    break;
 	case GETOPT_UUID:
@@ -90,6 +103,13 @@ main(int argc, char *argv[])
 			 c );
 		usage();
 	    }
+	    if (mntpnt_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_PRUNEMNT,
+			 c );
+		usage();
+	    }
 	    uuid_option = BOOL_TRUE;
 	    uuid_parse(optarg, uuid);
 	    break;
@@ -104,13 +124,6 @@ main(int argc, char *argv[])
 			 c );
 		usage();
 	    }
-	    if (r_mf_label) {
-		fprintf( stderr, "%s: may not specify both -%c and -%c\n", 
-			 g_programName,
-			 GETOPT_PRUNEMEDIALABEL,
-			 c );
-		usage();
-	    }
 	    if (uuid_option) {
 		fprintf( stderr, "%s: may not specify both -%c and -%c\n", 
 			 g_programName,
@@ -121,6 +134,13 @@ main(int argc, char *argv[])
 	    check_option = BOOL_TRUE;
 	    break;
 	case GETOPT_FORCE:
+	    if (interactive_option) {
+		fprintf( stderr, "%s: may not specify both -%c and -%c\n",
+			 g_programName,
+			 GETOPT_INTERACTIVE,
+			 c );
+		usage();
+	    }
 	    force = BOOL_TRUE;
 	    break;
 	case GETOPT_PRUNEMNT:
@@ -131,17 +151,17 @@ main(int argc, char *argv[])
 			 c );
 		usage();
 	    }
-	    mntpnt_option = BOOL_TRUE;
-	    mntPoint = optarg;
-	    break;
-	case GETOPT_PRUNEMEDIALABEL:
-	    if (check_option) {
+	    if (uuid_option) {
 		fprintf( stderr, "%s: may not specify both -%c and -%c\n", 
 			 g_programName,
-			 GETOPT_CHECKPRUNEFSTAB,
+			 GETOPT_UUID,
 			 c );
 		usage();
 	    }
+	    mntpnt_option = BOOL_TRUE;
+	    mntPoint = optarg;
+	    break;
+	case GETOPT_PRUNEMEDIALABEL:
 	    r_mf_label = optarg;
 	    break;
 	default:
@@ -150,6 +170,31 @@ main(int argc, char *argv[])
 	}
     }
 
+    if (r_mf_label != NULL && !(mntpnt_option || uuid_option)) {
+	    fprintf( stderr, "%s: -%c requires either -%c or -%c\n",
+			 g_programName,
+			 GETOPT_PRUNEMEDIALABEL,
+			 GETOPT_PRUNEMNT,
+			 GETOPT_UUID );
+	    usage();
+    }
+
+    /* date string only passed for -u and -M */
+    if (uuid_option || mntpnt_option) {
+	    if (optind != (argc - 1)) {
+		    fprintf(stderr, "%s: Date missing for -%c option\n",
+		    	 g_programName,
+			 uuid_option ? GETOPT_UUID : GETOPT_PRUNEMNT);
+		    usage();
+	    }
+    } else {
+	    if (optind != argc) {
+		    fprintf(stderr, "%s: Extra arguments specified\n",
+		    	 g_programName);
+		    usage();
+	    }
+    }
+
     /* sanity check the inventory database directory, setup global paths
      */
     if (!inv_setup_base()) {
@@ -167,16 +212,7 @@ main(int argc, char *argv[])
 		temptime, NULL);
     }
     else if (uuid_option || mntpnt_option) {
-        char *dateStr;
-        time32_t timeSecs;
-
-        if (optind != (argc - 1) ) {
-            fprintf( stderr, "%s: Date missing for prune option\n", 
-		     g_programName );
-            usage();
-        }
-        dateStr = argv[optind];
-        timeSecs = ParseDate(dateStr);
+        time32_t timeSecs = ParseDate(argv[optind]);
 
 	if (interactive_option) {
 	    invutil_interactive(inventory_path, mntPoint, &uuid, timeSecs);
@@ -189,18 +225,7 @@ main(int argc, char *argv[])
 	}
     }
     else if ( interactive_option ) {
-        char *dateStr;
-        time32_t timeSecs;
-
-        if (optind != (argc - 1) ) {
-	    timeSecs = 0;
-        }
-	else {
-	    dateStr = argv[optind];
-	    timeSecs = ParseDate(dateStr);
-	}
-
-	invutil_interactive(inventory_path, NULL, NULL, timeSecs);
+	invutil_interactive(inventory_path, mntPoint, &uuid, 0);
 	printf("\n");
     }
     else {
@@ -293,14 +318,15 @@ ParseDate(char *strDate)
 #endif
 
     if (*fmt == NULL || (date = mktime(&tm)) < 0) {
-        fprintf(stderr, "%s: bad date, \"%s\" for -M option\n",
-                g_programName, strDate );
+        fprintf(stderr, "%s: bad date, \"%s\"\n", g_programName, strDate );
         usage(); 
     }
 
     /* HACK to ensure tm_isdst is set BEFORE calling mktime(3) */ 
     if (tm.tm_isdst) {
         int dst = tm.tm_isdst;
+        memset (&tm, 0, sizeof (struct tm));
+        tm.tm_isdst = dst;
         (void)strptime(strDate, *fmt, &tm); 
         tm.tm_isdst = dst;
         date = mktime(&tm);
@@ -1074,44 +1100,19 @@ mmap_n_bytes(int fd, size_t count, bool_
     return temp;
 }
 
-/* ULO and ULN are taken from dump/common/main.c */
-
-#define ULO( f, o )	fprintf( stderr,		\
-				 "%*s[ -%c " f " ]\n",	\
-				 ps,			\
-				 ns,			\
-				 o ),			\
-			ps = pfxsz
-
-#define ULN( f )	fprintf( stderr,		\
-				 "%*s[ " f " ]\n",	\
-				 ps,			\
-				 ns ),			\
-			ps = pfxsz
-
 void
 usage (void)
 {
     int pfxsz;
-    int ps = 0;
-    char *ns = "";
 
     fprintf(stderr, "%s: %s\n", g_programName, g_programVersion);
-    pfxsz = fprintf(stderr, "Usage: %s ", g_programName);
-
-#ifdef REVEAL
-    ULO( "(output debug information)", GETOPT_DEBUG );
-#endif /* REVEAL */
-    ULO( "(interactive)", GETOPT_INTERACTIVE );
-    ULO( "<uuid> (prune uuid)", GETOPT_UUID );
-#ifdef REVEAL
-    ULO( "(wait for locks)", GETOPT_WAITFORLOCKS );
-#endif /* REVEAL */
-    ULO( "(don't prompt)", GETOPT_FORCE );
-    ULO( "<mountpoint> (prune mountpoint)", GETOPT_PRUNEMNT );
-    ULO( "<medialabel> (prune specific media)", GETOPT_PRUNEMEDIALABEL );
-    ULO( "(check inventory inconsistencies)", GETOPT_CHECKPRUNEFSTAB );
-    ULN( "<mm/dd/yyyy> (date for mountpoint and uuid prune)" );
+    pfxsz = fprintf(stderr, "Usage: \n");
+    fprintf(stderr, "%*s%s [-F|-i] [-m media_label] -M mount_point mm/dd/yyyy\n",
+		    pfxsz, "", g_programName);
+    fprintf(stderr, "%*s%s [-F|-i] [-m media_label] -u UUID mm/dd/yyyy\n",
+		    pfxsz, "", g_programName);
+    fprintf(stderr, "%*s%s -i\n", pfxsz, "", g_programName);
+    fprintf(stderr, "%*s%s -C\n", pfxsz, "", g_programName);
 
     exit(1);
 }
Index: xfsdump-kernel.org/invutil/getopt.h
===================================================================
--- xfsdump-kernel.org.orig/invutil/getopt.h
+++ xfsdump-kernel.org/invutil/getopt.h
@@ -22,7 +22,7 @@
 
 #define GETOPT_DEBUG		'd'	/* debug */
 #define GETOPT_INTERACTIVE	'i'	/* interactive mode */
-#define GETOPT_NONINTERACTIVE	'n'	/* non interactive mode (default) */
+#define GETOPT_NONINTERACTIVE	'n'	/* non interactive mode - obsoleted by -F */
 #define GETOPT_UUID		'u'	/* prune uuid */
 #define GETOPT_WAITFORLOCKS	'w'	/* wait for locks */
 #define GETOPT_CHECKPRUNEFSTAB	'C'	/* check and prune fstab */
Index: xfsdump-kernel.org/man/man8/xfsinvutil.8
===================================================================
--- xfsdump-kernel.org.orig/man/man8/xfsinvutil.8
+++ xfsdump-kernel.org/man/man8/xfsinvutil.8
@@ -3,8 +3,8 @@
 xfsinvutil \- \&xfsdump inventory database checking and pruning utility
 .SH SYNOPSIS
 .nf
-\f3xfsinvutil\f1 [\-F|\-i] [\-u \f2UUID\f1] [\-M \f2mount_point\f1]
-		 [\-m \f2media_label\f1] \f2mm/dd/yyyy\f1
+\f3xfsinvutil\f1 [\-F|\-i] [\-m \f2media_label\f1] \-M \f2mount_point\f1 \f2mm/dd/yyyy\f1
+\f3xfsinvutil\f1 [\-F|\-i] [\-m \f2media_label\f1] \-u \f2UUID\f1 \f2mm/dd/yyyy\f1
 \f3xfsinvutil\f1 \-i
 \f3xfsinvutil\f1 \-C
 .fi
@@ -20,37 +20,12 @@ dump session,
 stream, and
 media file.
 .P
-Over time, this database may grow too large as
-.I xfsdump (8)
-and
-.IR xfsrestore (8)
-do not remove entries from the inventory. The database may also develop
-inconsistencies for various reasons such as operator errors etc., 
-that may cause
-.I xfsdump
-or
-.I xfsrestore
-to print error or warning messages.
-.P
 .I xfsinvutil 
-is an utility to check this inventory database for consistency,
+is a utility to check this inventory database for consistency,
 to remove entries of dump sessions which may no longer be of
 relevance, and to browse the contents of the inventory.
 .P
-.I xfsinvutil
-may be used in three different modes.  In the first mode
-.I xfsinvutil
-steps over each dump session recorded in the inventory and prompts for
-a yes or no response to whether each session should be pruned.  The
-second is a batch mode in which
-.I xfsinvutil
-will prune every entry matching the supplied criteria.  The third mode
-allows the user to browse the inventory in detail, to delete or
-undelete records at will and also to import inventories from other
-hosts.
-.P
 The following command line options are available:
-.P
 .TP 5
 \f3\-F\f1
 Don't prompt the operator.  When
@@ -63,38 +38,23 @@ entry. With this option the deletion is 
 \f3\-i\f1
 Interactive mode.  Causes
 .I xfsinvutil
-to run in a mode that will allow the operator to browse the contents of
-the inventory. Please refer to the
+to run in a mode that will allow the operator to browse and modify the
+contents of the inventory. Please refer to the
 .B "Interactive Mode"
 section below for more information.
 .TP 5
 \f3\-M\f1 \f2mount_point mm/dd/yyyy\f1
-Specifies the mount point and cut-off date of inventory entries to
-be selected for pruning.  
-.I xfsinvutil
-prompts the operator when a dump session in the inventory is
-identified by the mount point and was created prior to the specified
-date.
-The operator can then select specific dump sessions for removal from
-the inventory database.
-This prompt will not happen if the \f3\-n\f1 option is used; it will
-be assumed that the pruning is wanted.
-.I xfsinvutil 
-also performs consistency checks on other inventory database entries when
-invoked with this option. 
-.RS
-.PP
-The \f2mountpoint\f1 must match the mount point as specified in
-the inventory shown using
-.I xfsdump
-with the \f3\-I\f1 option.
-This includes the host name and the mount path.
-.RE
-.TP 5
-\f3\-u\f1 \f2UUID\f1
-Specifies the filesystem universally unique identifier (UUID) of
-inventory entries to be selected for pruning.  This option is
-equivalent to the \f3\-M\f1 option.
+Prunes dump sessions identified by the given mount point which were
+created prior to the specified date. Optionally \f3\-m\f1 may be
+be specified to further limit the matching dump sessions by media
+label.
+.I xfsinvutil
+will prompt the operator prior to pruning a dump session unless
+the \f3\-F\f1 or \f3\-i\f1 options are given.
+.TP 5
+\f3\-u\f1 \f2UUID mm/dd/yyyy\f1
+Like \f3\-M\f1, except the matching filesystem is specified
+using its universally unique identifier (UUID) instead of its mount point.
 .TP 5
 \f3\-m\f1 \f2media_label\f1
 If specified, only sessions with at least one media file whose label
@@ -104,12 +64,6 @@ in addition to those imposed by the date
 references to media which may have been overwritten or lost. Note that
 this option does not apply to sessions with no media files.
 .TP 5
-.B \-n
-With this option, 
-.I xfsinvutil 
-will not ask any confirmation questions regarding sessions to prune.
-(It is the "Nike" option).
-.TP 5
 .B \-C
 With this option, 
 .I xfsinvutil 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
