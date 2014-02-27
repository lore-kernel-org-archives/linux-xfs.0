Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36DC229DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:13:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 099DE304066
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:13:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UmJMOoPMihVsnsnV for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 17:13:26 -0800 (PST)
Message-ID: <530E9135.2020807@sandeen.net>
Date: Wed, 26 Feb 2014 19:13:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs_logprint: Don't error out after split items lose
	context
References: <530E8E17.1090901@redhat.com>
In-Reply-To: <530E8E17.1090901@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

xfs_logprint recognizes a "left over region from split log item"
but then expects the *next* op to be a valid start to a new
item.  The problem is, we can split i.e. an xfs_inode_log_format
item, skip over it, and then land on the xfs_icdinode_t
data which follows it - this doesn't have a valid log item
magic (XFS_LI_*) and we error out.  This results in something
like:

  xfs_logprint: unknown log operation type (494e)

Fix this by recognizing that we've skipped over an item and
lost the context we're in, so just continue skipping over
op headers until we find the next valid start to a log item.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index cf9d59d..7070fa3 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -874,7 +874,7 @@ xlog_print_record(
 	int			bad_hdr_warn)
 {
     xfs_caddr_t		buf, ptr;
-    int			read_len, skip;
+    int			read_len, skip, lost_context = 0;
     int			ret, n, i, j, k;
 
     if (print_no_print)
@@ -995,7 +995,10 @@ xlog_print_record(
 	if (xlog_print_find_tid(be32_to_cpu(op_head->oh_tid),
 				op_head->oh_flags & XLOG_WAS_CONT_TRANS)) {
 	    printf(_("Left over region from split log item\n"));
+	    /* Skip this leftover bit */
 	    ptr += be32_to_cpu(op_head->oh_len);
+	    /* We've lost context; don't complain if next one looks bad too */
+	    lost_context = 1;
 	    continue;
 	}
 
@@ -1050,7 +1053,7 @@ xlog_print_record(
 			break;
 		    }
 		    default: {
-			if (bad_hdr_warn) {
+			if (bad_hdr_warn && !lost_context) {
 				fprintf(stderr,
 			_("%s: unknown log operation type (%x)\n"),
 					progname, *(unsigned short *)ptr);
@@ -1064,6 +1067,7 @@ xlog_print_record(
 			}
 			skip = 0;
 			ptr += be32_to_cpu(op_head->oh_len);
+			lost_context = 0;
 		    }
 		} /* switch */
 	    } /* else */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
