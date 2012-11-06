Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6EpF63066521 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 08:51:15 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LiQ7bWW2rsd7MFj4 for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 06:53:11 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA6ErB71006964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 09:53:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs_spaceman: updated preallocation support (eofblocks v6)
Date: Tue,  6 Nov 2012 09:55:04 -0500
Message-Id: <1352213704-59959-1-git-send-email-bfoster@redhat.com>
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
Cc: dchinner@redhat.com

This is an update to Dave's patch to xfs_spaceman to support
preallocation trimming. The original patch is here:

http://oss.sgi.com/archives/xfs/2012-10/msg00418.html

The code is updated as follows:

- Update to latest struct xfs_eofblocks (supports v6 of the
  speculative preallocation inode tracking set).
- Support multiple id scan.
- Fix the minimum argument count (no args means a trylock scan).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Dave,

I can also squash this into the original and post a new version if that is
preferred.

Brian

 spaceman/prealloc.c |   68 +++++++++++++++++++++++++++-----------------------
 1 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
index 8af30a6..ba6095d 100644
--- a/spaceman/prealloc.c
+++ b/spaceman/prealloc.c
@@ -31,23 +31,28 @@
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
+	__u64		eof_min_file_size;
+	__u32		pad[25];
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
 int sflag;
-int qid;
+int uid;
+int gid;
+int prid;
 int minlen;
 
 static cmdinfo_t prealloc_cmd;
@@ -68,27 +73,23 @@ prealloc_f(
 	pflag = 0;
 	sflag = 0;
 	minlen = 0;
-	qid = 0;
+	uid = 0;
+	gid = 0;
+	prid = 0;
 
 	while ((c = getopt(argc, argv, "g:m:p:su:")) != EOF) {
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
 			break;
 		case 's':
 			sflag = 1;
@@ -111,15 +112,20 @@ prealloc_f(
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
@@ -136,7 +142,7 @@ prealloc_help(void)
 "\n"
 "Control speculative preallocation\n"
 "\n"
-"Options: [-s] [-ugp id] [-m minlen]\n"
+"Options: [-s] [-u id] [-g id] [-p id] [-m minlen]\n"
 "\n"
 " -s -- synchronous flush - wait for flush to complete\n"
 " -u id -- remove prealloc on files matching user quota id <id>\n"
@@ -153,11 +159,11 @@ prealloc_init(void)
 	prealloc_cmd.name = "prealloc";
 	prealloc_cmd.altname = "prealloc";
 	prealloc_cmd.cfunc = prealloc_f;
-	prealloc_cmd.argmin = 1;
+	prealloc_cmd.argmin = 0;
 	prealloc_cmd.argmax = -1;
-	prealloc_cmd.args = "[-s] [-ugp id] [-m minlen]\n";
+	prealloc_cmd.args = "[-s] [-u id] [-g id] [-p id] [-m minlen]\n";
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
