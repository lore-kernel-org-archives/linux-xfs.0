Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C3BBA7F73
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 12:38:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DF09304032
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 10:38:17 -0700 (PDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id rmKgzqbLdLiOhEeZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 13 Jul 2014 10:38:14 -0700 (PDT)
Received: by mail-wg0-f43.google.com with SMTP id l18so2374745wgh.2
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 10:38:13 -0700 (PDT)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] Init errno before strto* calls.
Date: Sun, 13 Jul 2014 19:38:08 +0200
Message-Id: <1405273088-7956-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1405107244-14234-1-git-send-email-arekm@maven.pl>
References: <1405107244-14234-1-git-send-email-arekm@maven.pl>
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

Eric Sandeen noted that strtol(3) and friends require errno
initialization. From (fresh) man page:

NOTES
       Since  strtol()  can  legitimately  return  0,  LONG_MAX,
       or LONG_MIN (LLONG_MAX or LLONG_MIN for strtoll()) on both
       success and failure, the calling  program should set errno
       to 0 before the call, and then determine if an error
       occurred by checking  whether  errno  has  a non-zero
       value after the call.

So do it.
---
 libxcmd/input.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libxcmd/input.c b/libxcmd/input.c
index 397a124..711b527 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -153,6 +153,7 @@ cvtnum(
 	char		*sp;
 	int		c;
 
+	errno = 0;
 	i = strtoll(s, &sp, 0);
 	if ((i == LLONG_MIN || i == LLONG_MAX) && errno == ERANGE)
 		return -1LL;
@@ -239,6 +240,7 @@ cvttime(
 	unsigned long	i;
 	char		*sp;
 
+	errno = 0;
 	i = strtoul(s, &sp, 0);
 	if (i == ULONG_MAX && errno == ERANGE)
 		return 0;
@@ -348,6 +350,7 @@ prid_from_string(
 	 * Allow either a full numeric or a valid projectname, even
 	 * if it starts with a digit.
 	 */
+	errno = 0;
 	prid_long = strtoul(project, &sp, 10);
 	if (*project != '\0' && *sp == '\0') {
 		if ((prid_long == ULONG_MAX && errno == ERANGE)
@@ -369,6 +372,7 @@ uid_from_string(
 	unsigned long	uid_long;
 	char		*sp;
 
+	errno = 0;
 	uid_long = strtoul(user, &sp, 10);
 	if (sp != user) {
 		if ((uid_long == ULONG_MAX && errno == ERANGE)
@@ -390,6 +394,7 @@ gid_from_string(
 	unsigned long	gid_long;
 	char		*sp;
 
+	errno = 0;
 	gid_long = strtoul(group, &sp, 10);
 	if (sp != group) {
 		if ((gid_long == ULONG_MAX && errno == ERANGE)
-- 
2.0.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
