Return-Path: <xfs-bounces@oss.sgi.com>
Received: from lnx-rjohnston2.americas.sgi.com
	(lnx-rjohnston2.americas.sgi.com [128.162.233.55])
	by oss.sgi.com (Postfix) with ESMTP id C447B7F53
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 06:03:17 -0500 (CDT)
Received: from lnx-rjohnston2.americas.sgi.com (localhost [127.0.0.1])
	by lnx-rjohnston2.americas.sgi.com (8.14.4/8.14.4/Debian-2ubuntu2) with
	ESMTP id r3IB3MIs028466
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 06:03:22 -0500
Message-Id: <20130417183323.465181485@sgi.com>
Date: Wed, 17 Apr 2013 13:32:53 -0500
From: rjohnston@sgi.com
Subject: [PATCH] xfsprogs: xfs_quota allow user or group names beginning with
	digits
Content-Disposition: inline;
	filename=xfsprogs-xfs_quota-allow-user-or-group-names-beginning-with-digits.patch
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

---
 include/input.h |    1 +
 libxcmd/input.c |   12 ++++++++++++
 quota/quota.c   |    4 ++--
 quota/quota.h   |    1 +
 4 files changed, 16 insertions(+), 2 deletions(-)

Index: b/include/input.h
===================================================================
--- a/include/input.h
+++ b/include/input.h
@@ -46,6 +46,7 @@ extern void	timestr(struct timeval *tv,
 extern uid_t	uid_from_string(char *user);
 extern gid_t	gid_from_string(char *group);
 extern prid_t	prid_from_string(char *project);
+extern boolean_t isdigits_only(const char *str);
 
 #define HAVE_FTW_H 1	/* TODO: configure me */
 
Index: b/libxcmd/input.c
===================================================================
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -398,6 +398,18 @@ gid_from_string(
 	return -1;
 }
 
+boolean_t isdigits_only(
+	const char *str)
+{
+	int i;
+
+	for (i=0; i < strlen(str); i++) {
+		if (!isdigit(str[i]))
+			return B_FALSE;
+	}
+	return B_TRUE;
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
Index: b/quota/quota.h
===================================================================
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -80,4 +80,5 @@ enum {
 extern char *uid_to_name(__uint32_t __uid);
 extern char *gid_to_name(__uint32_t __gid);
 extern char *prid_to_name(__uint32_t __prid);
+extern boolean_t isdigits_only(const char *);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
