Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD9757F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 15:00:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 898278F8068
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 13:00:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SfDBcDnwvZDTgOaa for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 13:00:13 -0700 (PDT)
Message-ID: <551070CC.9040309@sandeen.net>
Date: Mon, 23 Mar 2015 15:00:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 01/13 V2] xfs_db: Allow writes of corrupted data by optionally
	skipping write verifiers
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-2-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

Being able to write corrupt data is handy if we wish to test
repair against specific types of corruptions.

Add a "-c" option to the write command which allows this by removing
the write verifier.

Note that this also skips CRC updates; it's not currently possible
to write invalid data with a valid CRC; CRC recalculation is
intertwined with validation.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix whitespace, remove "if (argc)", and test for
iocur_top->bp->b_ops before attempting to deref it.

diff --git a/db/io.c b/db/io.c
index 7f1b76a..c5898f1 100644
--- a/db/io.c
+++ b/db/io.c
@@ -457,6 +457,13 @@ write_cur_bbs(void)
 }
 
 void
+xfs_dummy_verify(
+	struct xfs_buf *bp)
+{
+	return;
+}
+
+void
 write_cur(void)
 {
 	if (iocur_sp < 0) {
diff --git a/db/io.h b/db/io.h
index 71082e6..31d96b4 100644
--- a/db/io.h
+++ b/db/io.h
@@ -63,6 +63,7 @@ extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
 			bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *t);
+extern void	xfs_dummy_verify(struct xfs_buf *bp);
 
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good
diff --git a/db/write.c b/db/write.c
index a0f14f4..655b618 100644
--- a/db/write.c
+++ b/db/write.c
@@ -38,7 +38,7 @@ static int	write_f(int argc, char **argv);
 static void     write_help(void);
 
 static const cmdinfo_t	write_cmd =
-	{ "write", NULL, write_f, 0, -1, 0, N_("[field or value]..."),
+	{ "write", NULL, write_f, 0, -1, 0, N_("[-c] [field or value]..."),
 	  N_("write value to disk"), write_help };
 
 void
@@ -79,6 +79,7 @@ write_help(void)
 "  String mode: 'write \"This_is_a_filename\" - write null terminated string.\n"
 "\n"
 " In data mode type 'write' by itself for a list of specific commands.\n\n"
+" Specifying the -c option will allow writes of invalid (corrupt) data.\n\n"
 ));
 
 }
@@ -90,6 +91,10 @@ write_f(
 {
 	pfunc_t	pf;
 	extern char *progname;
+	int c;
+	int corrupt = 0;		/* Allow write of corrupt data; skip verification */
+	struct xfs_buf_ops nowrite_ops;
+	const struct xfs_buf_ops *stashed_ops = NULL;
 
 	if (x.isreadonly & LIBXFS_ISREADONLY) {
 		dbprintf(_("%s started in read only mode, writing disabled\n"),
@@ -109,12 +114,34 @@ write_f(
 		return 0;
 	}
 
-	/* move past the "write" command */
-	argc--;
-	argv++;
+	while ((c = getopt(argc, argv, "c")) != EOF) {
+		switch (c) {
+		case 'c':
+			corrupt = 1;
+			break;
+		default:
+			dbprintf(_("bad option for write command\n"));
+			return 0;
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+
+	if (iocur_top->bp->b_ops && corrupt) {
+		/* Temporarily remove write verifier to write bad data */
+		stashed_ops = iocur_top->bp->b_ops;
+		nowrite_ops.verify_read = stashed_ops->verify_read;
+		nowrite_ops.verify_write = xfs_dummy_verify;
+		iocur_top->bp->b_ops = &nowrite_ops;
+		dbprintf(_("Allowing write of corrupted data\n"));
+	}
 
 	(*pf)(DB_WRITE, cur_typ->fields, argc, argv);
 
+	if (stashed_ops)
+		iocur_top->bp->b_ops = stashed_ops;
+
 	return 0;
 }
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 4d8d4ff..d527230 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -711,7 +711,7 @@ and
 bits respectively, and their string equivalent reported
 (but no modifications are made).
 .TP
-.BI "write [" "field value" "] ..."
+.BI "write [\-c] [" "field value" "] ..."
 Write a value to disk.
 Specific fields can be set in structures (struct mode),
 or a block can be set to data values (data mode),
@@ -729,6 +729,12 @@ contents of the block can be shifted or rotated left or right, or filled
 with a sequence, a constant value, or a random value. In this mode
 .B write
 with no arguments gives more information on the allowed commands.
+.RS 1.0i
+.TP 0.4i
+.B \-c
+Skip write verifiers and CRC recalculation; allows invalid data to be written
+to disk.
+.RE
 .SH TYPES
 This section gives the fields in each structure type and their meanings.
 Note that some types of block cover multiple actual structures,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
