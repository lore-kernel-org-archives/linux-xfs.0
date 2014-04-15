Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 540A27F52
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 03:25:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CFA78F8033
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 01:25:11 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Qo2QI2lVwlZeTFfc for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 01:25:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WZyfv-0003WN-7h
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WZyfv-0008Pp-6q
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] db: verify buffer on type change
Date: Tue, 15 Apr 2014 18:24:54 +1000
Message-Id: <1397550301-31883-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1397550301-31883-1-git-send-email-david@fromorbit.com>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Currently when the type command is run, we simply change the type
associated with the buffer, but don't verify it. This results in
unchecked CRCs being displayed. Hence when changing the type, run
the verifier associated with the type to determine if the buffer
contents is valid or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c   | 25 +++++++++++++++++++++++++
 db/io.h   |  1 +
 db/type.c |  9 +++++----
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/db/io.c b/db/io.c
index 387f171..1a75394 100644
--- a/db/io.c
+++ b/db/io.c
@@ -552,6 +552,31 @@ set_cur(
 		ring_add();
 }
 
+void
+set_iocur_type(
+	const typ_t	*t)
+{
+	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
+	struct xfs_buf	*bp = iocur_top->bp;
+
+	iocur_top->typ = t;
+
+	/* verify the buffer if the type has one. */
+	if (!bp)
+		return;
+	if (!ops) {
+		bp->b_ops = NULL;
+		bp->b_flags |= LIBXFS_B_UNCHECKED;
+		return;
+	}
+	if (!(bp->b_flags & LIBXFS_B_UPTODATE))
+		return;
+	bp->b_error = 0;
+	bp->b_ops = ops;
+	bp->b_ops->verify_read(bp);
+	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
+}
+
 static void
 stack_help(void)
 {
diff --git a/db/io.h b/db/io.h
index 7875119..71082e6 100644
--- a/db/io.h
+++ b/db/io.h
@@ -62,6 +62,7 @@ extern void     write_cur(void);
 extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
 			bbmap_t *bbmap);
 extern void     ring_add(void);
+extern void	set_iocur_type(const struct typ *t);
 
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good
diff --git a/db/type.c b/db/type.c
index 04d0d56..b29f2a4 100644
--- a/db/type.c
+++ b/db/type.c
@@ -162,10 +162,11 @@ type_f(
 		if (tt == NULL) {
 			dbprintf(_("no such type %s\n"), argv[1]);
 		} else {
-			if (iocur_top->typ == NULL) {
-			    dbprintf(_("no current object\n"));
-			} else {
-			    iocur_top->typ = cur_typ = tt;
+			if (iocur_top->typ == NULL)
+				dbprintf(_("no current object\n"));
+			else {
+				cur_typ = tt;
+				set_iocur_type(tt);
 			}
 		}
 	}
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
