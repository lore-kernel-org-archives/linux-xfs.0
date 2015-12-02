Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A3CE8002
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:03:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D9E78F8084
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 01:03:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PJlwt8GdnR500idH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 01:03:13 -0800 (PST)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_quota: allow create limit when user or group names
	beginning with digits
Date: Wed,  2 Dec 2015 17:02:35 +0800
Message-Id: <1449046955-8350-1-git-send-email-zlang@redhat.com>
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
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, rjohnston@sgi.com

A normal user or group name allow beginning with digits, but xfs_quota can't
create a limit for that user or group. The reason is 'strtoul' function only
translate digits at the beginning.

There's a commit fd537fc50eeade63bbd2a66105f39d04a011a7f5, it try to fix
"xfsprogs: xfs_quota allow user or group names beginning with digits". But
it doesn't effect 'limit .... 12345678-user' command.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi Eric,

This problem from a bug of ours, I have left message to you, please
help to check my simple patch. Thanks very much.

Hi Rich,

I don't understand why you fix commit fd537fc50eeade63bbd2a66105f39d04a011a7f5,
but didn't fix this. Or is this a feature, not a bug?

I'm not so familiar with xfsprogs code, so if I'm wrong, please tell me;)

Thanks,
Zorro

 libxcmd/input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxcmd/input.c b/libxcmd/input.c
index c505ab3..5a7dce3 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -366,7 +366,7 @@ uid_from_string(
 	char		*sp;
 
 	uid_long = strtoul(user, &sp, 10);
-	if (sp != user) {
+	if (sp != user && *sp == '\0') {
 		if ((uid_long == ULONG_MAX && errno == ERANGE)
 				|| (uid_long > (uid_t)-1))
 			return -1;
@@ -387,7 +387,7 @@ gid_from_string(
 	char		*sp;
 
 	gid_long = strtoul(group, &sp, 10);
-	if (sp != group) {
+	if (sp != group && *sp == '\0') {
 		if ((gid_long == ULONG_MAX && errno == ERANGE)
 				|| (gid_long > (gid_t)-1))
 			return -1;
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
