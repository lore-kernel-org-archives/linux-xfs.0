Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 013237CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 17:12:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A9F228F8039
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 15:12:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YNA5pzSXEi8mZXo0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 15:12:46 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 56A3F3B3C2
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 22:12:46 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-62-210.rdu2.redhat.com
	[10.10.62.210])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7NMCipe003014
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 18:12:46 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v4 2/2] xfs_quota: additional changes to allow use on ext4
Date: Tue, 23 Aug 2016 17:12:32 -0500
Message-Id: <1471990352-31852-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1471990352-31852-1-git-send-email-billodo@redhat.com>
References: <1471990352-31852-1-git-send-email-billodo@redhat.com>
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

Add CMD_SKIP_CHECK to enable "generic" xfs_quota commands (help and
quit) when xfs_quota is run on foreign filesystems.
Use CMD_FLAG_FOREIGN_OK on commands suitable for foreign filesystems.
Refactor init_check_command in quota/init.c for clarity.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 libxcmd/help.c |  3 ++-
 libxcmd/quit.c |  3 ++-
 quota/init.c   | 29 ++++++++++++++++++++---------
 quota/init.h   |  2 ++
 4 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/libxcmd/help.c b/libxcmd/help.c
index fad0ab9..bb03eb9 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -18,6 +18,7 @@
 
 #include "platform_defs.h"
 #include "command.h"
+#include "../quota/init.h"
 
 static cmdinfo_t help_cmd;
 static void help_onecmd(const char *cmd, const cmdinfo_t *ct);
@@ -88,7 +89,7 @@ help_init(void)
 	help_cmd.cfunc = help_f;
 	help_cmd.argmin = 0;
 	help_cmd.argmax = 1;
-	help_cmd.flags = CMD_FLAG_GLOBAL;
+	help_cmd.flags = CMD_FLAG_GLOBAL | CMD_SKIP_CHECK;
 	help_cmd.args = _("[command]");
 	help_cmd.oneline = _("help for one or all commands");
 
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index 0183b8f..aa1f1fb 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -18,6 +18,7 @@
 
 #include "platform_defs.h"
 #include "command.h"
+#include "../quota/init.h"
 
 static cmdinfo_t quit_cmd;
 
@@ -38,7 +39,7 @@ quit_init(void)
 	quit_cmd.cfunc = quit_f;
 	quit_cmd.argmin = -1;
 	quit_cmd.argmax = -1;
-	quit_cmd.flags = CMD_FLAG_GLOBAL;
+	quit_cmd.flags = CMD_FLAG_GLOBAL | CMD_SKIP_CHECK;
 	quit_cmd.oneline = _("exit the program");
 
 	add_command(&quit_cmd);
diff --git a/quota/init.c b/quota/init.c
index 137cd68..2a1681d 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -109,15 +109,26 @@ static int
 init_check_command(
 	const cmdinfo_t	*ct)
 {
-	if (fs_path &&
-	    !(ct->flags & CMD_FLAG_FOREIGN_OK) &&
-	     (fs_path->fs_flags & FS_FOREIGN)) {
-		fprintf(stderr,
-	_("foreign mount active, %s command is for XFS filesystems only\n"),
-			ct->name);
-		return 0;
-	}
-	return 1;
+	if (!fs_path)
+		return 1;
+
+	/* Always run commands that we are told to skip here */
+	if (ct->flags & CMD_SKIP_CHECK)
+		return 1;
+
+	/* if it's an XFS filesystem, always run the command */
+	if (!(fs_path->fs_flags & FS_FOREIGN))
+		return 1;
+
+	/* If the user specified foreign filesysetms are ok, run it */
+	if (foreign_allowed &&
+	    (ct->flags & CMD_FLAG_FOREIGN_OK))
+		return 1;
+
+	/* foreign filesystem and it's not a valid command! */
+	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
+		ct->name);
+	return 0;
 }
 
 static void
diff --git a/quota/init.h b/quota/init.h
index 6879855..2a93a71 100644
--- a/quota/init.h
+++ b/quota/init.h
@@ -31,3 +31,5 @@ extern void	report_init(void);
 extern void	state_init(void);
 
 extern void init_cvtnum(unsigned int *, unsigned int *);
+
+#define CMD_SKIP_CHECK	(1<<0) /* command is always available */
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
