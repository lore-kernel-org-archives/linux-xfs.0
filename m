Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82EMQls073424 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 09:22:26 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: remove redundant error code mapping
Date: Fri,  2 Sep 2011 09:22:18 -0500
Message-Id: <1314973338-20520-1-git-send-email-wkendall@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently there is both an exit_strings array and an exit_codestring()
function for mapping an exit code to a string. They are very similar
except the latter prefaces every string with "EXIT_" and the former
uses "SUCCESS" instead of "NORMAL", and cannot handle an invalid exit
code. exit_codestring() is not currently used in active code (it's for
multi-stream), so its values can be changed to allow the exit_strings
array to be removed.
---
 common/exit.h |   10 +++++-----
 common/mlog.c |   14 ++------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/common/exit.h b/common/exit.h
index ef01684..f7e4878 100644
--- a/common/exit.h
+++ b/common/exit.h
@@ -29,12 +29,12 @@ static inline const char *
 exit_codestring( intgen_t code )
 {
 	switch ( code ) {
-	case EXIT_NORMAL:    return "EXIT_NORMAL";
-	case EXIT_ERROR:     return "EXIT_ERROR";
-	case EXIT_INTERRUPT: return "EXIT_INTERRUPT";
-	case EXIT_FAULT:     return "EXIT_FAULT";
+	case EXIT_NORMAL:    return "SUCCESS";
+	case EXIT_ERROR:     return "ERROR";
+	case EXIT_INTERRUPT: return "INTERRUPT";
+	case EXIT_FAULT:     return "FAULT";
 	}
-	return "???";
+	return "UNKNOWN";
 }
 
 #endif /* EXIT_H */
diff --git a/common/mlog.c b/common/mlog.c
index 55cb5cd..2265895 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -457,11 +457,6 @@ mlog_va( intgen_t levelarg, char *fmt, va_list args )
 	}
 }
 
-
-static const char *exit_strings[] =
-	{ "SUCCESS", "ERROR", "INTERRUPT", "", "FAULT" };
-
-
 /*
  * Map RV codes to actual error messages.
  */
@@ -584,7 +579,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 	      "%s: %d: mlog_exit called: "
 	      "exit_code: %s return: %s (%s)\n",
 	      file, line,
-	      exit_strings[exit_code],
+	      exit_codestring(exit_code),
 	      rvp->rv_string, rvp->rv_desc);
 
 	if (rv < 0 || rv >= _RV_NUM) {
@@ -780,12 +775,7 @@ mlog_exit_flush(void)
 	if (interrupt) status_str = "INTERRUPT";
 	else if (quit) status_str = "QUIT";
 	else if (incomplete) status_str = "INCOMPLETE";
-#ifdef NDEBUG
-	/* We should never get here, but if we do make sure we don't die
-	   horribly when not running debug. */
-	else if (! VALID_EXIT_CODE(mlog_main_exit_code)) status_str = "UNKNOWN";
-#endif /* NDEBUG */
-	else status_str = exit_strings[mlog_main_exit_code];
+	else status_str = exit_codestring(mlog_main_exit_code);
 
 	/* now print the overall state of the dump/restore */
 	fprintf(mlog_fp, "%s: %s Status: %s\n", progname, PROGSTR_CAPS, status_str);
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
