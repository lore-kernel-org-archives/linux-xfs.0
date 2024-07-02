Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD8B66E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882798; cv=none; b=RzBsmXZc2G0IHFO+faR43C+Fa9pvK0Bu+Z0lB0NntGEJkt+P6kXtH++CKI/7+WHMnYrj41QMPqxEcWXCwYMlAYBwAoSxGhqCd9qGi50DDGD9cen8GrTu9CaSrS7BsXZqasIA7AJ/K/cCwQSr2YgHEVl2O4YAHQavqwGn0Iivdr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882798; c=relaxed/simple;
	bh=lXtzBXzTNvbiaFXJdR7M1sBwBTlCLj1ZQZ7U+KmghNk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OtQLugRPuHupPZn4TgfFEmOiKcUvg3+jsn8cnVjf3xN+OqciQz/Rys028VwGO1+M98e1T6tTFnhAI9u41+VxJ1FikOSKLr9pgOroZC1s+wmSvtFRt4kZM5Nhwb0P+OPtj4rSBxulW4A4aBlQCCzjR9SEmnLI4ltXym0pyGGfMCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFZJ/d8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFZJ/d8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E441C116B1;
	Tue,  2 Jul 2024 01:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882798;
	bh=lXtzBXzTNvbiaFXJdR7M1sBwBTlCLj1ZQZ7U+KmghNk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FFZJ/d8Ib7ObY78dEtL/pZN11kX4xgelJL4GGsFafXEorrVijGRicbuQ/uay3PaWa
	 nfa2AuQ9cWY3dj9J+g5kIUKW5XqRLk3LrXndzmRIgBzWj8i6lwZSsC1hH1ulumZYaq
	 He/5k3Biy7j/1RxGaLB35QHoC7q89U9zMz++sT9VtSFtF/lOTIvlSPKRzJ0rHiu7Sy
	 9SaIu7zJ27opJJim9dxxVZcVhV8Cj6Bo3K9r0ulbFZk94NtE3/TodX5x6FgmBgK3DG
	 1uQcHiDDoy4YAGdAPQgGHINh3athlE3cZfrSbs5rMUe2dMUZdPx8S5GhbcyLNbhPVT
	 MOn+GU/a38P4Q==
Date: Mon, 01 Jul 2024 18:13:17 -0700
Subject: [PATCH 10/24] xfs_spaceman: report file paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121217.2009260.18429552066421688989.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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
 spaceman/Makefile       |   16 +++++++++++---
 spaceman/file.c         |    7 ++++++
 spaceman/health.c       |   53 ++++++++++++++++++++++++++++++++++++++---------
 spaceman/space.h        |    3 +++
 5 files changed, 71 insertions(+), 15 deletions(-)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index ece840d7300a..0d299132a788 100644
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
index 1f048d54a4d2..358db9edf5cb 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -6,12 +6,20 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_spaceman
-HFILES = init.h space.h
-CFILES = info.c init.c file.c health.c prealloc.c trim.c
+HFILES = \
+	init.h \
+	space.h
+CFILES = \
+	file.c \
+	health.c \
+	info.c \
+	init.c \
+	prealloc.c \
+	trim.c
 LSRCFILES = xfs_info.sh
 
-LLDLIBS = $(LIBXCMD) $(LIBFROG)
-LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_EDITLINE),yes)
diff --git a/spaceman/file.c b/spaceman/file.c
index eec7ee9f4ba9..850688ace15d 100644
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
index 88b12c0b0ea3..6722babf5888 100644
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
@@ -265,6 +267,38 @@ report_file_health(
 
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
+		ret = handle_to_path(&handle, sizeof(struct xfs_handle), 0,
+				descr, sizeof(descr) - 1);
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
@@ -274,7 +308,6 @@ report_bulkstat_health(
 	xfs_agnumber_t		agno)
 {
 	struct xfs_bulkstat_req	*breq;
-	char			descr[256];
 	uint32_t		i;
 	int			error;
 
@@ -292,13 +325,8 @@ report_bulkstat_health(
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
@@ -308,7 +336,7 @@ report_bulkstat_health(
 	return error;
 }
 
-#define OPT_STRING ("a:cfi:q")
+#define OPT_STRING ("a:cfi:nq")
 
 /* Report on health problems in XFS filesystem. */
 static int
@@ -323,6 +351,7 @@ health_f(
 	int			ret;
 
 	reported = 0;
+	report_paths = false;
 
 	if (file->xfd.fsgeom.version != XFS_FSOP_GEOM_VERSION_V5) {
 		perror("health");
@@ -358,6 +387,9 @@ health_f(
 				return 1;
 			}
 			break;
+		case 'n':
+			report_paths = true;
+			break;
 		case 'q':
 			quiet = true;
 			break;
@@ -445,6 +477,7 @@ health_help(void)
 " -c       -- Report on the health of all inodes.\n"
 " -f       -- Report health of the overall filesystem.\n"
 " -i inum  -- Report health of a given inode number.\n"
+" -n       -- Try to report file names.\n"
 " -q       -- Only report unhealthy metadata.\n"
 " paths    -- Report health of the given file path.\n"
 "\n"));
@@ -456,7 +489,7 @@ static cmdinfo_t health_cmd = {
 	.cfunc = health_f,
 	.argmin = 0,
 	.argmax = -1,
-	.args = "[-a agno] [-c] [-f] [-i inum] [-q] [paths]",
+	.args = "[-a agno] [-c] [-f] [-i inum] [-n] [-q] [paths]",
 	.flags = CMD_FLAG_ONESHOT,
 	.help = health_help,
 };
diff --git a/spaceman/space.h b/spaceman/space.h
index 723209edd998..28fa35a30479 100644
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

