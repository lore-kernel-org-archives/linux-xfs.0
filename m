Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542F2C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 20:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344161AbhLJUZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 15:25:30 -0500
Received: from sandeen.net ([63.231.237.45]:43506 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344186AbhLJUZ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Dec 2021 15:25:29 -0500
Received: by sandeen.net (Postfix, from userid 500)
        id A33DA4507A5; Fri, 10 Dec 2021 14:21:40 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs_quota: don't exit on fs_table_insert_project_path failure
Date:   Fri, 10 Dec 2021 14:21:36 -0600
Message-Id: <1639167697-15392-4-git-send-email-sandeen@sandeen.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

If "project -p" fails in fs_table_insert_project_path, it
calls exit() today which is quite unfriendly. Return an error
and return to the command prompt as expected.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libfrog/paths.c | 7 +++----
 libfrog/paths.h | 2 +-
 quota/project.c | 4 +++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/libfrog/paths.c b/libfrog/paths.c
index d679376..6c0fee2 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -546,7 +546,7 @@ out_error:
 		progname, strerror(error));
 }
 
-void
+int
 fs_table_insert_project_path(
 	char		*dir,
 	prid_t		prid)
@@ -561,9 +561,8 @@ fs_table_insert_project_path(
 	else
 		error = ENOENT;
 
-	if (error) {
+	if (error)
 		fprintf(stderr, _("%s: cannot setup path for project dir %s: %s\n"),
 				progname, dir, strerror(error));
-		exit(1);
-	}
+	return error;
 }
diff --git a/libfrog/paths.h b/libfrog/paths.h
index c08e373..f20a2c3 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -40,7 +40,7 @@ extern char *mtab_file;
 extern void fs_table_initialise(int, char *[], int, char *[]);
 extern void fs_table_destroy(void);
 
-extern void fs_table_insert_project_path(char *__dir, uint __projid);
+extern int fs_table_insert_project_path(char *__dir, uint __projid);
 
 
 extern fs_path_t *fs_table_lookup(const char *__dir, uint __flags);
diff --git a/quota/project.c b/quota/project.c
index 03ae10d..bed0dc5 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -281,7 +281,9 @@ project_f(
 			break;
 		case 'p':
 			ispath = 1;
-			fs_table_insert_project_path(optarg, -1);
+			/* fs_table_insert_project_path prints the failure */
+			if (fs_table_insert_project_path(optarg, -1))
+				return 0;
 			break;
 		case 's':
 			type = SETUP_PROJECT;
-- 
1.8.3.1

