Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56208 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 18/18] libfrog: change project entity variable scope to local/static
Date: Wed, 10 Oct 2018 15:01:22 -0500
Message-Id: <1539201682-22198-19-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The project quota code used a global variable "p" for getprent() and
getprpathent(), presumably to keep the interface analogous to getpwent()
etc.  However, other functions had their own local "p" which led to shadow
variable warnings from sparse.

Rather than a global, make it a static variable within the project
functions.  Same behavior, same interface, less confusion, and retains an
interface similar that of getpwent etc.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
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
