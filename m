Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C5007CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 08:40:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1184B8F8033
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 06:40:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qz56OcRQxMfwDiiY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 06:40:13 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 752FDC057FA6
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 13:40:13 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-60-194.rdu2.redhat.com
	[10.10.60.194])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7TDeC8b010745
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 09:40:13 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH] xfsprogs: don't populate fs table with foreign fs paths
	unless foreign_allowed
Date: Mon, 29 Aug 2016 08:40:12 -0500
Message-Id: <1472478012-23627-1-git-send-email-billodo@redhat.com>
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

Commits b20b6c2 and 29647c8 modified xfs_quota for use on
non-XFS filesystems. One modification in fs_initialise_mounts
(paths.c) resulted in an xfstest fail (xfs/261), due to foreign
fs paths entering the fs table.

This patch reverts the behavior in fs_initialise_mounts back
to skip populating the table with foreign paths, unless the
-f flag is thrown in xfs_quota to set foreign_allowed true.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 libxcmd/paths.c | 5 +++++
 quota/init.c    | 1 -
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 4158688..7375c0e 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -34,6 +34,7 @@ extern char *progname;
 int fs_count;
 struct fs_path *fs_table;
 struct fs_path *fs_path;
+bool foreign_allowed = false;	/* foreign filesystems not allowed (default) */
 
 char *mtab_file;
 #define PROC_MOUNTS	"/proc/self/mounts"
@@ -311,6 +312,10 @@ fs_table_initialise_mounts(
 			return errno;
 
 	while ((mnt = getmntent(mtp)) != NULL) {
+		/* don't populate if not XFS, and foreign fs disallowed */
+		if ((strcmp(mnt->mnt_type, "xfs") != 0) &&
+		    !foreign_allowed)
+			continue;
 		if (!realpath(mnt->mnt_dir, rmnt_dir))
 			continue;
 		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
diff --git a/quota/init.c b/quota/init.c
index 44be322..65e4dad 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -24,7 +24,6 @@
 char	*progname;
 int	exitcode;
 int	expert;
-bool	foreign_allowed = false;
 
 static char **projopts;	/* table of project names (cmdline) */
 static int nprojopts;	/* number of entries in name table. */
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
