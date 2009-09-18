Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8I46pxd006264 for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 23:06:51 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C59B31144E07
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 21:08:04 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id NcP0WYmmdsDQ0mU8 for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2009 21:08:04 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id CE67DAAE393
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 23:08:03 -0500 (CDT)
Message-ID: <4AB307AD.9010904@sandeen.net>
Date: Thu, 17 Sep 2009 23:08:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_fsr: fix test for short write
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Clang found this one too, as a dead nested assignment.

The point is to see if we write all the bytes; but the initial
assignment is backwards.  It's safe in the end, because if they
weren't already equal anyway, we'd have exited prior to this, but
it's worth fixing up for clarity.

Signed-of-by: Eric Sandeen <sandeen@sandeen.net>
---

clang record:
http://sandeen.net/clang/xfsprogs/2009-09-09-1/report-xOZEHP.html#EndPath

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 9f2bf24..253a55d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1190,7 +1190,7 @@ packfile(char *fname, char *tname, int fd,
 			}
 			if (nfrags) {
 				/* Do a matching write to the tmp file */
-				wc = wc_b4;
+				wc_b4 = wc;
 				if (((wc = write(ffd, fbuf, wc)) != wc_b4)) {
 					fsrprintf(_("bad write of %d bytes "	
 						"to %s: %s\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
