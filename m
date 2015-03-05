Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEC337F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 15:26:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E8B3AC001
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 13:26:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LxPW597X8PGspnB7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 13:26:36 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t25LQYtm029987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 5 Mar 2015 16:26:35 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t25LQWRF020151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 5 Mar 2015 16:26:34 -0500
Message-ID: <54F8CA08.303@redhat.com>
Date: Thu, 05 Mar 2015 15:26:32 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_db: Allow writes of corrupted data by optionally skipping
	write verifiers
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
To: xfs-oss <xfs@oss.sgi.com>

Being able to write corrupt data is handy if we wish to test
repair against specific types of corruptions.

Add a "-c" option to the write command which allows this.

Note that this also skips CRC updates; it's not currently possible
to write invalid data with a valid CRC; CRC recalculation is
intertwined with validation.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/crc.c b/db/crc.c
index ad46c3f..861086a 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -58,13 +58,6 @@ crc_help(void)
 
 }
 
-void
-xfs_dummy_verify(
-	struct xfs_buf *bp)
-{
-	return;
-}
-
 static int
 crc_f(
 	int		argc,
diff --git a/db/crc.h b/db/crc.h
index 80ecec3..9f44615 100644
--- a/db/crc.h
+++ b/db/crc.h
@@ -20,4 +20,3 @@ struct field;
 
 extern void	crc_init(void);
 extern void	crc_struct(const field_t *fields, int argc, char **argv);
-extern void	xfs_dummy_verify(struct xfs_buf *bp);
diff --git a/db/io.c b/db/io.c
index eb3daa1..2d18d56 100644
--- a/db/io.c
+++ b/db/io.c
@@ -458,6 +458,13 @@ write_cur_bbs(void)
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
 	int skip_crc = (iocur_top->bp->b_ops->verify_write == xfs_dummy_verify);
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
index a0f14f4..a01c25a 100644
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
@@ -90,6 +91,9 @@ write_f(
 {
 	pfunc_t	pf;
 	extern char *progname;
+	int c;
+	int corrupt = 0;		/* Allow write of corrupt data; skip verification */
+	const struct xfs_buf_ops *stashed_ops = NULL; 
 
 	if (x.isreadonly & LIBXFS_ISREADONLY) {
 		dbprintf(_("%s started in read only mode, writing disabled\n"),
@@ -109,12 +113,36 @@ write_f(
 		return 0;
 	}
 
-	/* move past the "write" command */
-	argc--;
-	argv++;
+	if (argc) while ((c = getopt(argc, argv, "c")) != EOF) {
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
+	if (corrupt) {
+		struct xfs_buf_ops nowrite_ops;
+
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
index 0764832..46a1f39 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -728,7 +728,7 @@ and
 bits respectively, and their string equivalent reported
 (but no modifications are made).
 .TP
-.BI "write [" "field value" "] ..."
+.BI "write [\-c] [" "field value" "] ..."
 Write a value to disk.
 Specific fields can be set in structures (struct mode),
 or a block can be set to data values (data mode),
@@ -746,6 +746,12 @@ contents of the block can be shifted or rotated left or right, or filled
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
