Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 139EC7CA4
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 13:38:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDB7030411C
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 11:38:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FwX0oFCNpC5R7yNo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Aug 2016 11:38:47 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 833AC3B72D
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 18:38:47 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-56-109.rdu2.redhat.com
	[10.10.56.109])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7FIcjro018199
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 14:38:47 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 3/3] xfs_quota: additional changes to allow use on ext4
Date: Mon, 15 Aug 2016 13:38:31 -0500
Message-Id: <1471286311-2730-4-git-send-email-billodo@redhat.com>
In-Reply-To: <1471286311-2730-1-git-send-email-billodo@redhat.com>
References: <1471286311-2730-1-git-send-email-billodo@redhat.com>
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

Further changes to allow xfs_quota to be used on foreign filesystem(s)
(e.g. ext4) for project quota testing in xfstests.

Add CMD_FLAG_GENERIC to enable generic xfs_quota commands (help and
quit) when xfs_quota is run on foreign filesystems.

Use CMD_FLAG_FOREIGN_OK on commands suitable for foreign filesystems.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 include/command.h | 1 +
 libxcmd/help.c    | 3 ++-
 libxcmd/quit.c    | 3 ++-
 quota/init.c      | 3 ++-
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/command.h b/include/command.h
index 81d5a4d..1c2898a 100644
--- a/include/command.h
+++ b/include/command.h
@@ -22,6 +22,7 @@
 
 #define CMD_FLAG_GLOBAL		(1<<31)	/* don't iterate "args" */
 #define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
+#define CMD_FLAG_GENERIC	(1<<29) /* command is generic (help, quit) */
 
 typedef int (*cfunc_t)(int argc, char **argv);
 typedef void (*helpfunc_t)(void);
diff --git a/libxcmd/help.c b/libxcmd/help.c
index fad0ab9..be26765 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -88,7 +88,8 @@ help_init(void)
 	help_cmd.cfunc = help_f;
 	help_cmd.argmin = 0;
 	help_cmd.argmax = 1;
-	help_cmd.flags = CMD_FLAG_GLOBAL;
+	help_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK |
+		CMD_FLAG_GENERIC;
 	help_cmd.args = _("[command]");
 	help_cmd.oneline = _("help for one or all commands");
 
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index 0183b8f..2a27c89 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -38,7 +38,8 @@ quit_init(void)
 	quit_cmd.cfunc = quit_f;
 	quit_cmd.argmin = -1;
 	quit_cmd.argmax = -1;
-	quit_cmd.flags = CMD_FLAG_GLOBAL;
+	quit_cmd.flags = CMD_FLAG_GLOBAL | CMD_FLAG_FOREIGN_OK |
+		CMD_FLAG_GENERIC;
 	quit_cmd.oneline = _("exit the program");
 
 	add_command(&quit_cmd);
diff --git a/quota/init.c b/quota/init.c
index c46ce0f..3b2fd61 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -104,7 +104,8 @@ init_check_command(
 	const cmdinfo_t	*ct)
 {
 	if (fs_path &&
-	    !(ct->flags & CMD_FLAG_FOREIGN_OK) &&
+	    !((ct->flags & CMD_FLAG_FOREIGN_OK) && foreign_allowed) &&
+	    !(ct->flags & CMD_FLAG_GENERIC) &&
 	     (fs_path->fs_flags & FS_FOREIGN)) {
 		fprintf(stderr,
 	_("foreign mount active, %s command is for XFS filesystems only\n"),
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
