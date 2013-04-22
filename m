Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 179787F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 08:36:39 -0500 (CDT)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2EA530404E
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 06:36:35 -0700 (PDT)
Message-Id: <20130422133106.892072381@sgi.com>
Date: Mon, 22 Apr 2013 08:31:06 -0500
From: rjohnston@sgi.com
Subject: [V2] xfsprogs: xfs_quota allow user or group names beginning with
	digits
Content-Disposition: inline;
	filename=V2-xfsprogs-xfs_quota-allow-user-or-group-names-beginning-with-digits.patch
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

xfs_quota does not properly parse users or groups that begin with a number.
Only call atoi when user or group consists of digits only.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

---
V2:
	Change 'i=0' to 'i = 0' (sandeen suggestion) 
	Use bool instead of boolean_t (dchinner suggestion)

include/input.h |    1 +
 libxcmd/input.c |   12 ++++++++++++
 quota/quota.c   |    4 ++--
 quota/quota.h   |    1 +
 4 files changed, 16 insertions(+), 2 deletions(-)

Index: xfsprogs/include/input.h
===================================================================
--- xfsprogs.orig/include/input.h	2013-03-22 14:22:09.000000000 -0500
+++ xfsprogs/include/input.h	2013-04-22 08:10:56.000000000 -0500
@@ -22,6 +22,7 @@
 #include <grp.h>
 #include <sys/types.h>
 #include <xfs/project.h>
+#include <stdbool.h>
 
 extern char	**breakline(char *input, int *count);
 extern void	doneline(char *input, char **vec);
@@ -46,6 +47,7 @@
 extern uid_t	uid_from_string(char *user);
 extern gid_t	gid_from_string(char *group);
 extern prid_t	prid_from_string(char *project);
+extern bool	isdigits_only(const char *str);
 
 #define HAVE_FTW_H 1	/* TODO: configure me */
 
Index: xfsprogs/libxcmd/input.c
===================================================================
--- xfsprogs.orig/libxcmd/input.c	2013-03-22 14:22:09.000000000 -0500
+++ xfsprogs/libxcmd/input.c	2013-04-22 08:07:01.000000000 -0500
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/input.h>
 #include <ctype.h>
+#include <stdbool.h>
 
 #if defined(ENABLE_READLINE)
 # include <readline/history.h>
@@ -398,6 +399,18 @@
 	return -1;
 }
 
+bool isdigits_only(
+	const char *str)
+{
+	int i;
+
+	for (i = 0; i < strlen(str); i++) {
+		if (!isdigit(str[i]))
+			return false;
+	}
+	return true;
+}
+
 #define HAVE_FTW_H 1	/* TODO: configure me */
 
 #ifndef HAVE_FTW_H
Index: xfsprogs/quota/quota.c
===================================================================
--- xfsprogs.orig/quota/quota.c	2013-03-22 14:22:09.000000000 -0500
+++ xfsprogs/quota/quota.c	2013-04-22 07:20:52.000000000 -0500
@@ -224,7 +224,7 @@
 	uid_t		id;
 
 	if (name) {
-		if (isdigit(name[0])) {
+		if (isdigits_only(name)) {
 			id = atoi(name);
 			name = getusername(id, flags & NO_LOOKUP_FLAG);
 		} else if ((u = getpwnam(name))) {
@@ -273,7 +273,7 @@
 	int		i, ngroups, dofree = 0;
 
 	if (name) {
-		if (isdigit(name[0])) {
+		if (isdigits_only(name)) {
 			gid = atoi(name);
 			name = getgroupname(gid, flags & NO_LOOKUP_FLAG);
 		} else {
Index: xfsprogs/quota/quota.h
===================================================================
--- xfsprogs.orig/quota/quota.h	2013-03-22 14:22:09.000000000 -0500
+++ xfsprogs/quota/quota.h	2013-04-22 08:12:26.000000000 -0500
@@ -19,6 +19,7 @@
 #include <xfs/xqm.h>
 #include <xfs/path.h>
 #include <xfs/project.h>
+#include <stdbool.h>
 
 /*
  * Different forms of XFS quota
@@ -80,4 +81,5 @@
 extern char *uid_to_name(__uint32_t __uid);
 extern char *gid_to_name(__uint32_t __gid);
 extern char *prid_to_name(__uint32_t __prid);
+extern bool isdigits_only(const char *);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
