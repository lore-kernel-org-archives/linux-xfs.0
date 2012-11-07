Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7HuYix166985 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 11:56:34 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nHI7mfxSyNWI2LmA for
	<xfs@oss.sgi.com>; Wed, 07 Nov 2012 09:58:32 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA7HwVSA032134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 12:58:31 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id qA7HwVIZ018207
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 12:58:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 RFC] xfs_spaceman: updated preallocation support (eofblocks
	v7)
Date: Wed,  7 Nov 2012 13:00:23 -0500
Message-Id: <1352311223-55321-1-git-send-email-bfoster@redhat.com>
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

This is an update to Dave's patch to xfs_spaceman to support
preallocation trimming. The original patch is here:

http://oss.sgi.com/archives/xfs/2012-10/msg00418.html

The code is updated as follows:

- Update to latest struct xfs_eofblocks (supports v7 of the
  speculative preallocation inode tracking set).
- Support multiple id scan.
- Hack in the '-a' flag to support "async/trylock" scan.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Dave,

This replaces the v6 version by matching the data structure corrected for
alignment. I removed the argmin change and added the -a flag instead. When I read
your last mail, I don't think this is exactly what you had in mind but your intent
wasn't completely clear to me. I at least want to make sure this is up to date and
functional, so feel free to adjust the -a flag as necessary.

Brian

 spaceman/prealloc.c |   79 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
index 8af30a6..ed8ad0e 100644
--- a/spaceman/prealloc.c
+++ b/spaceman/prealloc.c
@@ -31,23 +31,30 @@
 struct xfs_eofblocks {
 	__u32		eof_version;
 	__u32		eof_flags;
-	__u32		eof_q_id;
-	__u32		eof_q_type;
-	__u32		eof_min_file_size;
-	unsigned char	pad[12];
+	uid_t		eof_uid;
+	gid_t		eof_gid;
+	__u32		eof_prid;
+	__u32		pad32;
+	__u64		eof_min_file_size;
+	__u64		pad64[12];
 };
 
 /* eof_flags values */
-#define XFS_EOF_FLAGS_SYNC		0x01	/* sync/wait mode scan */
-#define XFS_EOF_FLAGS_QUOTA		0x02	/* filter by quota id */
-#define XFS_EOF_FLAGS_MINFILESIZE	0x04	/* filter by min file size */
+#define XFS_EOF_FLAGS_SYNC		(1 << 0) /* sync/wait mode scan */
+#define XFS_EOF_FLAGS_UID		(1 << 1) /* filter by uid */
+#define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
+#define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
+#define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
 #endif
 
 int gflag;
 int uflag;
 int pflag;
+int aflag;
 int sflag;
-int qid;
+int uid;
+int gid;
+int prid;
 int minlen;
 
 static cmdinfo_t prealloc_cmd;
@@ -66,31 +73,35 @@ prealloc_f(
 	uflag = 0;
 	gflag = 0;
 	pflag = 0;
+	aflag = 0;
 	sflag = 0;
 	minlen = 0;
-	qid = 0;
+	uid = 0;
+	gid = 0;
+	prid = 0;
 
-	while ((c = getopt(argc, argv, "g:m:p:su:")) != EOF) {
+	while ((c = getopt(argc, argv, "g:m:p:asu:")) != EOF) {
 		switch (c) {
 		case 'g':
-			if (uflag || pflag)
-				return command_usage(&prealloc_cmd);
 			gflag = 1;
-			qid = atoi(optarg);
+			gid = atoi(optarg);
 			break;
 		case 'u':
-			if (gflag || pflag)
-				return command_usage(&prealloc_cmd);
 			uflag = 1;
-			qid = atoi(optarg);
+			uid = atoi(optarg);
 			break;
 		case 'p':
-			if (uflag || gflag)
-				return command_usage(&prealloc_cmd);
 			pflag = 1;
-			qid = atoi(optarg);
+			prid = atoi(optarg);
+			break;
+		case 'a':
+			if (sflag)
+				return command_usage(&prealloc_cmd);
+			aflag = 1;
 			break;
 		case 's':
+			if (aflag)
+				return command_usage(&prealloc_cmd);
 			sflag = 1;
 			break;
 		case 'm':
@@ -111,15 +122,20 @@ prealloc_f(
 		eofb.eof_flags |= XFS_EOF_FLAGS_MINFILESIZE;
 		eofb.eof_min_file_size = minlen;
 	}
-	if (uflag || gflag || pflag) {
-		eofb.eof_flags |= XFS_EOF_FLAGS_QUOTA;
-		eofb.eof_q_id = qid;
-		if (uflag)
-			eofb.eof_q_type = XQM_USRQUOTA;
-		else if (gflag)
-			eofb.eof_q_type = XQM_GRPQUOTA;
-		else if (pflag)
-			eofb.eof_q_type = XQM_PRJQUOTA;
+
+	if (uflag) {
+		eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+		eofb.eof_uid = uid;
+	}
+
+	if (gflag) {
+		eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+		eofb.eof_gid = gid;
+	}
+
+	if (pflag) {
+		eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+		eofb.eof_prid = prid;
 	}
 
 	if (xfsctl(file->name, file->fd, XFS_IOC_FREE_EOFBLOCKS, &eofb) < 0) {
@@ -136,8 +152,9 @@ prealloc_help(void)
 "\n"
 "Control speculative preallocation\n"
 "\n"
-"Options: [-s] [-ugp id] [-m minlen]\n"
+"Options: [-as] [-u id] [-g id] [-p id] [-m minlen]\n"
 "\n"
+" -a -- asynchronous flush - skip locked or dirty inodes\n"
 " -s -- synchronous flush - wait for flush to complete\n"
 " -u id -- remove prealloc on files matching user quota id <id>\n"
 " -g id -- remove prealloc on files matching group quota id <id>\n"
@@ -155,9 +172,9 @@ prealloc_init(void)
 	prealloc_cmd.cfunc = prealloc_f;
 	prealloc_cmd.argmin = 1;
 	prealloc_cmd.argmax = -1;
-	prealloc_cmd.args = "[-s] [-ugp id] [-m minlen]\n";
+	prealloc_cmd.args = "[-as] [-u id] [-g id] [-p id] [-m minlen]\n";
 	prealloc_cmd.flags = CMD_FLAG_GLOBAL;
-	prealloc_cmd.oneline = _("Control specualtive preallocation");
+	prealloc_cmd.oneline = _("Control speculative preallocation");
 	prealloc_cmd.help = prealloc_help;
 
 	add_command(&prealloc_cmd);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
