Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C40327CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 14:57:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84F64304062
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 12:57:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AbM0qv0a3gekFz8F (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Sep 2016 12:57:52 -0700 (PDT)
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v3 3/3] xfs_quota: add case for foreign fs,
	disabled regardless of foreign_allowed
Date: Thu, 15 Sep 2016 14:57:49 -0500
Message-Id: <1473969469-27354-1-git-send-email-billodo@redhat.com>
In-Reply-To: <1473953386-10242-4-git-send-email-billodo@redhat.com>
References: <1473953386-10242-4-git-send-email-billodo@redhat.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Some commands are disallowed for foreign filesystems,
regardless of whether or not the -f flag is thrown.
Add a case for this condition and improve commenting
and output messaging accordingly in init_check_command.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
history:
v3: clarify foreign filesystem user output message.
v2: no change
v1: http://www.spinics.net/lists/linux-xfs/msg00685.html

 quota/init.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/quota/init.c b/quota/init.c
index 2c18c8b..3bebbb8 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -112,21 +112,29 @@ init_check_command(
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
+	fprintf(stderr,
+		_("%s: foreign filesystem. Invoke xfs_quota with -f to enable.\n"),
 		ct->name);
 	return 0;
 }
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
