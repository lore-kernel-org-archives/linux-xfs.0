Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B661029E09
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 07:21:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50C5DAC00A
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 05:21:09 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id wYBt0nRnTAQFqNMb (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 05:21:07 -0700 (PDT)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] xfsprogs: avoid use of si_tid in struct xlog_split_item
Date: Sun, 26 Jul 2015 08:20:53 -0400
Message-Id: <1437913255-7524-5-git-send-email-tytso@mit.edu>
In-Reply-To: <1437913255-7524-1-git-send-email-tytso@mit.edu>
References: <1437913255-7524-1-git-send-email-tytso@mit.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org

In Android's bionic libc (as well as the Linux kernel's
include/uapi/asm-generic/siginfo.h), si_tid is a #define to provide
backwards compatibility for the timerid in the siginfo structure.
This breaks the compile of logprint/log_misc.c.  Change this to be
si_xtid in order to avoid a namespace collision

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 logprint/log_misc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c9286c6..c0a5c97 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -76,7 +76,7 @@ char *trans_type[] = {
 typedef struct xlog_split_item {
 	struct xlog_split_item	*si_next;
 	struct xlog_split_item	*si_prev;
-	xlog_tid_t		si_tid;
+	xlog_tid_t		si_xtid;
 	int			si_skip;
 } xlog_split_item_t;
 
@@ -161,7 +161,7 @@ xlog_print_add_to_trans(xlog_tid_t	tid,
     xlog_split_item_t *item;
 
     item	  = (xlog_split_item_t *)calloc(sizeof(xlog_split_item_t), 1);
-    item->si_tid  = tid;
+    item->si_xtid  = tid;
     item->si_skip = skip;
     item->si_next = split_list;
     item->si_prev = NULL;
@@ -183,7 +183,7 @@ xlog_print_find_tid(xlog_tid_t tid, uint was_cont)
 	    return 0;
     }
     while (listp) {
-	if (listp->si_tid == tid)
+	if (listp->si_xtid == tid)
 	    break;
 	listp = listp->si_next;
     }
-- 
2.3.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
