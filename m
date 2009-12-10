Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA469Za038077 for <xfs@oss.sgi.com>; Wed, 9 Dec 2009 22:06:10 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93D5ADF1696
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2009 20:06:43 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id PBEHzLhKJfk4EwuX for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2009 20:06:43 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 4C2A7936E39
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2009 22:06:41 -0600 (CST)
Message-ID: <4B2073D1.1040809@sandeen.net>
Date: Wed, 09 Dec 2009 22:06:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_fsr: don't create ag temp subdirs with mode 0777
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This addresses Debian bug #559490 - xfsdump: fsr creates files mode 666

I think that this mode is left over from when xfs_fsr used to
fork into the uid of the file's owner, and so needed somewhere
it was guaranteed to be able to write.

This behavior was removed in commit d51b892411c8d33374a02e20c5888df280811549
(in the xfsdump tree, before xfs_fsr got moved) and so these
wide-open permissions should no longer be needed.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Nathan Scott <nscott@aconex.com>
---

(Note: I already got a review from Nathan, so barring any complaint
I'll push this to the xfsprogs-dev tree soon.)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 253a55d..21f08c3 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1541,7 +1541,7 @@ tmp_init(char *mnt)
 	}
 	for (i=0; i < fsgeom.agcount; i++) {
 		sprintf(buf, "%s/.fsr/ag%d", mnt, i);
-		if (mkdir(buf, 0777) < 0) {
+		if (mkdir(buf, 0700) < 0) {
 			if (errno == EEXIST) {
 				if (dflag)
 					fsrprintf(


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
