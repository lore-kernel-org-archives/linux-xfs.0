Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbeJELAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:14 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 15/15] libfrog: change project entity variable scope
Date: Thu,  4 Oct 2018 23:03:16 -0500
Message-Id: <1538712196-13625-16-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

The global "p" got shadowed in some other functions, and it was a bit hard
to keep track of what's what.  Change the scope of some of the project
entity retrieval function variables to make the behavior more clear.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libfrog/projects.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libfrog/projects.c b/libfrog/projects.c
index d4dda3f..91bc78f 100644
--- a/libfrog/projects.c
+++ b/libfrog/projects.c
@@ -15,12 +15,8 @@ char *projid_file;
 char *projects_file;
 
 static FILE *projects;
-static fs_project_t p;
-static char projects_buffer[512];
 
 static FILE *project_paths;
-static fs_project_path_t pp;
-static char project_paths_buffer[1024];
 
 void
 setprfiles(void)
@@ -64,8 +60,10 @@ endprpathent(void)
 fs_project_t *
 getprent(void)
 {
-	char	*idstart, *idend;
-	size_t	size = sizeof(projects_buffer) - 1;
+	static		fs_project_t p;
+	static char	projects_buffer[512];
+	char		*idstart, *idend;
+	size_t		size = sizeof(projects_buffer) - 1;
 
 	if (!projects)
 		return NULL;
@@ -125,6 +123,8 @@ getprprid(
 fs_project_path_t *
 getprpathent(void)
 {
+	static 		fs_project_path_t pp;
+	static char	project_paths_buffer[1024];
 	char		*nmstart, *nmend;
 	size_t		size = sizeof(project_paths_buffer) - 1;
 
-- 
1.8.3.1
