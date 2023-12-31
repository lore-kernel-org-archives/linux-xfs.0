Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54928C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPr94Wty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CCAC433C8;
	Sun, 31 Dec 2023 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064235;
	bh=U7z4y8T9+1Rw1IMDc5zOon910TJ8rIpcBRVdZFBHi7w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UPr94WtylMmFH2PLAI+Gmf42B3A2fwMncEkUDrCxzwBZGUso80L/uh8Dsm8gL5npU
	 Mi/tz0THNZBKdp8Ed+DX/SaN9lA4lxgOkP+nIjn5dYDevYM4IAlnWQ//wP2OOOlPn3
	 J9o2xJ9EQYB0tHPyY3FFeXcb5WSOsW33B4cW8fPxcjXjWNTsoEur6sdgbYrFOUcMOP
	 GZkDufuyWIL19VyKfAUOpnm3+p8390UVucy20miCZmNqarPA0gJ73sxqiatSscyFlq
	 TgUBGvoCj4kxZRKtFfvoe6JXizhdtSv/xESBD1Qg31c6UEAieZUWHK4B6t2NPIfjbP
	 WDGYt5ZyVoKaQ==
Date: Sun, 31 Dec 2023 15:10:34 -0800
Subject: [PATCH 21/32] xfs_spaceman: report file paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006381.1804688.3715768524309031421.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the health command to report file paths when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_spaceman.8 |    7 +++++-
 spaceman/Makefile       |    4 ++--
 spaceman/file.c         |    7 ++++++
 spaceman/health.c       |   53 ++++++++++++++++++++++++++++++++++++++---------
 spaceman/space.h        |    3 +++
 5 files changed, 61 insertions(+), 13 deletions(-)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index ece840d7300..0d299132a78 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -91,7 +91,7 @@ The output will have the same format that
 .BR "xfs_info" "(8)"
 prints when querying a filesystem.
 .TP
-.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-q ] [ paths ]"
+.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-n ] [ \-q ] [ paths ]"
 Reports the health of the given group of filesystem metadata.
 .RS 1.0i
 .PD 0
@@ -111,6 +111,11 @@ Report on the health of metadata that affect the entire filesystem.
 .B \-i inum
 Report on the health of a specific inode.
 .TP
+.B \-n
+When reporting on the health of a file, try to report the full file path,
+if possible.
+This option is disabled by default to minimize runtime.
+.TP
 .B \-q
 Report only unhealthy metadata.
 .TP
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 1f048d54a4d..d6fccc361cf 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -10,8 +10,8 @@ HFILES = init.h space.h
 CFILES = info.c init.c file.c health.c prealloc.c trim.c
 LSRCFILES = xfs_info.sh
 
-LLDLIBS = $(LIBXCMD) $(LIBFROG)
-LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_EDITLINE),yes)
diff --git a/spaceman/file.c b/spaceman/file.c
index eec7ee9f4ba..850688ace15 100644
--- a/spaceman/file.c
+++ b/spaceman/file.c
@@ -14,6 +14,7 @@
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
 #include "space.h"
+#include "handle.h"
 
 static cmdinfo_t print_cmd;
 
@@ -106,6 +107,12 @@ addfile(
 	file->name = filename;
 	memcpy(&file->xfd, xfd, sizeof(struct xfs_fd));
 	memcpy(&file->fs_path, fs_path, sizeof(file->fs_path));
+
+	/* Try to capture a fs handle for reporting paths. */
+	file->fshandle = NULL;
+	file->fshandle_len = 0;
+	path_to_fshandle(filename, &file->fshandle, &file->fshandle_len);
+
 	return 0;
 }
 
diff --git a/spaceman/health.c b/spaceman/health.c
index 12fb67bab28..ab5bc074988 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -13,11 +13,13 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
 #include "space.h"
+#include "libfrog/getparents.h"
 
 static cmdinfo_t health_cmd;
 static unsigned long long reported;
 static bool comprehensive;
 static bool quiet;
+static bool report_paths;
 
 static bool has_realtime(const struct xfs_fsop_geom *g)
 {
@@ -269,6 +271,38 @@ report_file_health(
 
 #define BULKSTAT_NR		(128)
 
+static void
+report_inode(
+	const struct xfs_bulkstat	*bs)
+{
+	char				descr[PATH_MAX];
+	int				ret;
+
+	if (report_paths && file->fshandle &&
+	    (file->xfd.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT)) {
+		struct xfs_handle handle;
+
+		memcpy(&handle.ha_fsid, file->fshandle, sizeof(handle.ha_fsid));
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+				sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_ino = bs->bs_ino;
+		handle.ha_fid.fid_gen = bs->bs_gen;
+
+		ret = handle_to_path(&handle, sizeof(struct xfs_handle), descr,
+				sizeof(descr) - 1);
+		if (ret)
+			goto report_inum;
+
+		goto report_status;
+	}
+
+report_inum:
+	snprintf(descr, sizeof(descr) - 1, _("inode %"PRIu64), bs->bs_ino);
+report_status:
+	report_sick(descr, inode_flags, bs->bs_sick, bs->bs_checked);
+}
+
 /*
  * Report on all files' health for a given @agno.  If @agno is NULLAGNUMBER,
  * report on all files in the filesystem.
@@ -278,7 +312,6 @@ report_bulkstat_health(
 	xfs_agnumber_t		agno)
 {
 	struct xfs_bulkstat_req	*breq;
-	char			descr[256];
 	uint32_t		i;
 	int			error;
 
@@ -296,13 +329,8 @@ report_bulkstat_health(
 		error = -xfrog_bulkstat(&file->xfd, breq);
 		if (error)
 			break;
-		for (i = 0; i < breq->hdr.ocount; i++) {
-			snprintf(descr, sizeof(descr) - 1, _("inode %"PRIu64),
-					breq->bulkstat[i].bs_ino);
-			report_sick(descr, inode_flags,
-					breq->bulkstat[i].bs_sick,
-					breq->bulkstat[i].bs_checked);
-		}
+		for (i = 0; i < breq->hdr.ocount; i++)
+			report_inode(&breq->bulkstat[i]);
 	} while (breq->hdr.ocount > 0);
 
 	if (error)
@@ -312,7 +340,7 @@ report_bulkstat_health(
 	return error;
 }
 
-#define OPT_STRING ("a:cfi:q")
+#define OPT_STRING ("a:cfi:nq")
 
 /* Report on health problems in XFS filesystem. */
 static int
@@ -327,6 +355,7 @@ health_f(
 	int			ret;
 
 	reported = 0;
+	report_paths = false;
 
 	if (file->xfd.fsgeom.version != XFS_FSOP_GEOM_VERSION_V5) {
 		perror("health");
@@ -362,6 +391,9 @@ health_f(
 				return 1;
 			}
 			break;
+		case 'n':
+			report_paths = true;
+			break;
 		case 'q':
 			quiet = true;
 			break;
@@ -449,6 +481,7 @@ health_help(void)
 " -c       -- Report on the health of all inodes.\n"
 " -f       -- Report health of the overall filesystem.\n"
 " -i inum  -- Report health of a given inode number.\n"
+" -n       -- Try to report file names.\n"
 " -q       -- Only report unhealthy metadata.\n"
 " paths    -- Report health of the given file path.\n"
 "\n"));
@@ -460,7 +493,7 @@ static cmdinfo_t health_cmd = {
 	.cfunc = health_f,
 	.argmin = 0,
 	.argmax = -1,
-	.args = "[-a agno] [-c] [-f] [-i inum] [-q] [paths]",
+	.args = "[-a agno] [-c] [-f] [-i inum] [-n] [-q] [paths]",
 	.flags = CMD_FLAG_ONESHOT,
 	.help = health_help,
 };
diff --git a/spaceman/space.h b/spaceman/space.h
index 723209edd99..28fa35a3047 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -10,6 +10,9 @@ struct fileio {
 	struct xfs_fd	xfd;		/* XFS runtime support context */
 	struct fs_path	fs_path;	/* XFS path information */
 	char		*name;		/* file name at time of open */
+
+	void		*fshandle;
+	size_t		fshandle_len;
 };
 
 extern struct fileio	*filetable;	/* open file table */

