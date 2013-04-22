Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E6097F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 12:46:29 -0500 (CDT)
Message-Id: <20130422173205.877894469@sgi.com>
Date: Mon, 22 Apr 2013 12:32:05 -0500
From: rjohnston@sgi.com
Subject: [PATCH V3] xfsprogs: xfs_quota allow user or group names beginning
	with
Content-Disposition: inline;
	filename=V3-xfsprogs-xfs_quota-allow-user-or-group-names-beginning-with-digits.patch
	digits
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
Cc: Eric Sandeen <sandeen@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Dave Chinner <dchinner@redhat.com>

xfs_quota does not properly parse users or groups that begin with a number.
Only call atoi when user or group consists of digits only.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

---

Fresh clone of xfsprogs showed I missed a change in quota_proj_type()
(Thanks Chandra pointing that out)

V2:
	Change 'i=0' to 'i = 0' (sandeen suggestion) 
	Use bool instead of boolean_t (dchinner suggestion)
V3:
	Also change quota_proj_type() to use isdigits_only() (sekharan suggestion)

 include/input.h |    2 ++
 libxcmd/input.c |   13 +++++++++++++
 quota/quota.c   |    6 +++---
 quota/quota.h   |    2 ++
 4 files changed, 20 insertions(+), 3 deletions(-)

Index: b/include/input.h
===================================================================
--- a/include/input.h
+++ b/include/input.h
@@ -22,6 +22,7 @@
 #include <grp.h>
 #include <sys/types.h>
 #include <xfs/project.h>
+#include <stdbool.h>
 
 extern char	**breakline(char *input, int *count);
 extern void	doneline(char *input, char **vec);
@@ -46,6 +47,7 @@ extern void	timestr(struct timeval *tv,
 extern uid_t	uid_from_string(char *user);
 extern gid_t	gid_from_string(char *group);
 extern prid_t	prid_from_string(char *project);
+extern bool	isdigits_only(const char *str);
 
 #define HAVE_FTW_H 1	/* TODO: configure me */
 
Index: b/libxcmd/input.c
===================================================================
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -19,6 +19,7 @@
 #include <xfs/xfs.h>
 #include <xfs/input.h>
 #include <ctype.h>
+#include <stdbool.h>
 
 #if defined(ENABLE_READLINE)
 # include <readline/history.h>
@@ -398,6 +399,18 @@ gid_from_string(
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
Index: b/quota/quota.c
===================================================================
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -224,7 +224,7 @@ quota_user_type(
 	uid_t		id;
 
 	if (name) {
-		if (isdigit(name[0])) {
+		if (isdigits_only(name)) {
 			id = atoi(name);
 			name = getusername(id, flags & NO_LOOKUP_FLAG);
 		} else if ((u = getpwnam(name))) {
@@ -273,7 +273,7 @@ quota_group_type(
 	int		i, ngroups, dofree = 0;
 
 	if (name) {
-		if (isdigit(name[0])) {
+		if (isdigits_only(name)) {
 			gid = atoi(name);
 			name = getgroupname(gid, flags & NO_LOOKUP_FLAG);
 		} else {
@@ -344,7 +344,7 @@ quota_proj_type(
 		return;
 	}
 
-	if (isdigit(name[0])) {
+	if (isdigits_only(name)) {
 		id = atoi(name);
 		name = getprojectname(id, flags & NO_LOOKUP_FLAG);
 	} else if ((p = getprnam(name))) {
Index: b/quota/quota.h
===================================================================
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -19,6 +19,7 @@
 #include <xfs/xqm.h>
 #include <xfs/path.h>
 #include <xfs/project.h>
+#include <stdbool.h>
 
 /*
  * Different forms of XFS quota
@@ -80,4 +81,5 @@ enum {
 extern char *uid_to_name(__uint32_t __uid);
 extern char *gid_to_name(__uint32_t __gid);
 extern char *prid_to_name(__uint32_t __prid);
+extern bool isdigits_only(const char *);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
