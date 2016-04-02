Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 381557CA3
	for <xfs@oss.sgi.com>; Sat,  2 Apr 2016 10:59:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADC5CAC002
	for <xfs@oss.sgi.com>; Sat,  2 Apr 2016 08:59:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BPJcZxUblRvib2Nv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 02 Apr 2016 08:59:34 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 10B323E1
	for <xfs@oss.sgi.com>; Sat,  2 Apr 2016 15:59:34 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_quota: allow create limit when user or group names
	beginning with digits
Date: Sat,  2 Apr 2016 23:59:30 +0800
Message-Id: <1459612770-18908-1-git-send-email-zlang@redhat.com>
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
To: dchinner@redhat.com
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

A normal user or group name allow beginning with digits, but xfs_quota
can't create a limit for that user or group. The reason is 'strtoul'
function only translate digits at the beginning, it will ignore
letters after digits.

There's a commit fd537fc50eeade63bbd2a66105f39d04a011a7f5, it try to
fix "xfsprogs: xfs_quota allow user or group names beginning with
digits". But it doesn't effect 'limit' command, so a command likes:

  xfs_quota 'limit .... 12345678-user' xxxx

will try to create limit for username="12345678", not "12345678-user".

This patch will fix this problem, and a test case xfs/138 in xfstests
is used to reproduce this bug.

Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---

Hi Dave,

I just found there's a missed patch in my local xfsprogs repo, it has
been reviewed for a long:

http://oss.sgi.com/archives/xfs/2015-12/msg00134.html

And the reproducer about this bug has been merged into xfstests for
several months, but I don't know why we can't merge this patch. Would
you please check it?

Due to long time has passed, so I rewrite this patch and re-send it
again now. If anything wrong in this patch, please let me know:)

Thanks very much,
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
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
