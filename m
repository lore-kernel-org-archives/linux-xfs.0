Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F53FC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEZC1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZC1F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30067BC
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE90064B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB4FC433D2;
        Fri, 26 May 2023 02:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068023;
        bh=U7z4y8T9+1Rw1IMDc5zOon910TJ8rIpcBRVdZFBHi7w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BoQvKt1tW/c6557+NOd1+6PoTOQIpToFuifUzKLLFbRTB6m0GJfx59eL+N9AkYRzy
         AAIrg9IujDZpLJHpOngAjcyomec535SmldccXfsSGqGgP35LHkqhhsHj3EP3BTAVad
         RUMKJUoHZy4618a/Sfi/OvzBL2H652b2U3DYzAXFJIDzmzhAx0r4CjskfUMLReC5E7
         gLQ3mpJGZ/EcrH1Vpw/34vx7rP3mjziJkx6iXd7fEe99VHe75dvkPiDfsA5HNgbID1
         VK9gpIrJtU0bVoLAKunvCVAY33T0euTrWB4xTuY5QpCs0v+9o1rBma/ob5PgaJyOhP
         VaFnMPk+UBb4Q==
Date:   Thu, 25 May 2023 19:27:02 -0700
Subject: [PATCH 20/30] xfs_spaceman: report file paths
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078160.3749421.15510849733955957305.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

