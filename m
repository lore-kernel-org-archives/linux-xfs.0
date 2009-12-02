Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2IJVDw027402 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 12:19:31 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7694012DC69D
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 10:20:02 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id AeHm2kbEUIibJuPX for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 10:20:02 -0800 (PST)
Received: from liberator.sandeen.net (sandeen.net [209.173.210.139])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 9301FA7DC13
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 12:20:01 -0600 (CST)
Message-ID: <4B16AFCA.5040302@sandeen.net>
Date: Wed, 02 Dec 2009 12:19:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: don't assign cvtnum() return to unsigned var
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

cvtnum() returns -1LL for unparseable values, but if we
assign to a signed var, we can't test it:

xfs_io> mincore 0 xxx
range (0:0) is beyond mapping (0:1048576)

Use a temporary signed var so we can detect the error:

xfs_io> mincore 0 xxx
non-numeric length argument -- xxx

and also test whether it may overflow a size_t.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/io/mincore.c b/io/mincore.c
index f863f84..d534540 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -30,7 +30,7 @@ mincore_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off64_t		offset, llength;
 	size_t		length;
 	size_t		blocksize, sectsize;
 	void		*start;
@@ -49,12 +49,17 @@ mincore_f(
 				argv[1]);
 			return 0;
 		}
-		length = cvtnum(blocksize, sectsize, argv[2]);
-		if (length < 0) {
+		llength = cvtnum(blocksize, sectsize, argv[2]);
+		if (llength < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[2]);
 			return 0;
-		}
+		} else if (llength > (size_t)llength) {
+			printf(_("length argument too large -- %lld\n"),
+				llength);
+			return 0;
+		} else
+			length = (size_t)llength;
 	} else {
 		return command_usage(&mincore_cmd);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
