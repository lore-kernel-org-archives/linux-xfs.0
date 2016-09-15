Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbcIOP37 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Sep 2016 11:29:59 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v2 3/3] xfs_quota: add case for foreign fs, disabled regardless of foreign_allowed
Date: Thu, 15 Sep 2016 10:29:46 -0500
Message-Id: <1473953386-10242-4-git-send-email-billodo@redhat.com>
In-Reply-To: <1473953386-10242-1-git-send-email-billodo@redhat.com>
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
 <1473953386-10242-1-git-send-email-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Some commands are disallowed for foreign filesystems,
regardless of whether or not the -f flag is thrown.
Add a case for this condition and improve commenting
and output messaging accordingly in init_check_command.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 quota/init.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/quota/init.c b/quota/init.c
index 2c18c8b..7d69663 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -112,21 +112,28 @@ init_check_command(
 	if (!fs_path)
 		return 1;
 
-	/* Always run commands that we are told to skip here */
+	/* Always run commands that are valid for all fs types. */
 	if (ct->flags & CMD_ALL_FSTYPES)
 		return 1;
 
-	/* if it's an XFS filesystem, always run the command */
+	/* If it's an XFS filesystem, always run the command. */
 	if (!(fs_path->fs_flags & FS_FOREIGN))
 		return 1;
 
-	/* If the user specified foreign filesysetms are ok, run it */
+	/* If the user specified foreign filesystems are ok (-f), run cmd. */
 	if (foreign_allowed &&
 	    (ct->flags & CMD_FLAG_FOREIGN_OK))
 		return 1;
 
-	/* foreign filesystem and it's not a valid command! */
-	fprintf(stderr, _("%s command is for XFS filesystems only\n"),
+	/* If cmd not allowed on foreign fs, regardless of -f flag, skip it. */
+	if (!(ct->flags & CMD_FLAG_FOREIGN_OK)) {
+		fprintf(stderr, _("%s: command is for XFS filesystems only\n"),
+			ct->name);
+		return 0;
+	}
+
+	/* foreign fs, but cmd only allowed via -f flag. Skip it. */
+	fprintf(stderr, _("%s: foreign filesystem. Use -f to enable.\n"),
 		ct->name);
 	return 0;
 }
-- 
2.7.4

