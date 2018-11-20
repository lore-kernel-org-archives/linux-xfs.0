Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33226 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbeKUI2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:28:32 -0500
Subject: [PATCH 04/10] fsx: add five-argument logging function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:57:05 -0800
Message-ID: <154275102589.8611.12239624125210101030.stgit@magnolia>
In-Reply-To: <154275100143.8611.10235098565750994724.stgit@magnolia>
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a five-argument logging function to support new operations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 290b42f6..2372964d 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -51,7 +51,8 @@ enum opflags { FL_NONE = 0, FL_SKIPPED = 1, FL_CLOSE_OPEN = 2, FL_KEEP_SIZE = 4
 
 struct log_entry {
 	int	operation;
-	int	args[3];
+	int	nr_args;
+	int	args[4];
 	enum opflags flags;
 };
 
@@ -278,6 +279,27 @@ static int op_code(const char *name)
 	return -1;
 }
 
+void
+log5(int operation, int arg0, int arg1, int arg2, enum opflags flags)
+{
+	struct log_entry *le;
+
+	le = &oplog[logptr];
+	le->operation = operation;
+	if (closeopen)
+		flags |= FL_CLOSE_OPEN;
+	le->args[0] = arg0;
+	le->args[1] = arg1;
+	le->args[2] = arg2;
+	le->args[3] = file_size;
+	le->nr_args = 4;
+	le->flags = flags;
+	logptr++;
+	logcount++;
+	if (logptr >= LOGSIZE)
+		logptr = 0;
+}
+
 void
 log4(int operation, int arg0, int arg1, enum opflags flags)
 {
@@ -290,6 +312,7 @@ log4(int operation, int arg0, int arg1, enum opflags flags)
 	le->args[0] = arg0;
 	le->args[1] = arg1;
 	le->args[2] = file_size;
+	le->nr_args = 3;
 	le->flags = flags;
 	logptr++;
 	logcount++;
@@ -439,11 +462,13 @@ logdump(void)
 			i = 0;
 
 		if (logopsf) {
+			int j;
+
 			if (lp->flags & FL_SKIPPED)
 				fprintf(logopsf, "skip ");
-			fprintf(logopsf, "%s 0x%x 0x%x 0x%x",
-				op_name(lp->operation),
-				lp->args[0], lp->args[1], lp->args[2]);
+			fprintf(logopsf, "%s", op_name(lp->operation));
+			for (j = 0; j < lp->nr_args; j++)
+				fprintf(logopsf, " 0x%x", lp->args[j]);
 			if (lp->flags & FL_KEEP_SIZE)
 				fprintf(logopsf, " keep_size");
 			if (lp->flags & FL_CLOSE_OPEN)
@@ -1413,6 +1438,15 @@ cleanup(int sig)
 	exit(sig);
 }
 
+static int
+op_args_count(int operation)
+{
+	switch (operation) {
+	default:
+		return 3;
+	}
+}
+
 static int
 read_op(struct log_entry *log_entry)
 {
@@ -1445,7 +1479,8 @@ read_op(struct log_entry *log_entry)
 		log_entry->operation = op_code(str);
 		if (log_entry->operation == -1)
 			goto fail;
-		for (i = 0; i < 3; i++) {
+		log_entry->nr_args = op_args_count(log_entry->operation);
+		for (i = 0; i < log_entry->nr_args; i++) {
 			char *end;
 
 			str = strtok(NULL, " \t\n");
