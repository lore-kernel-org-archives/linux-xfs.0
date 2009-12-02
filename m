Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2IPtU2027809 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 12:25:55 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 259411DA363B
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 10:26:25 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id fME2mNNR6vTQ5XjA for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 10:26:25 -0800 (PST)
Received: from liberator.sandeen.net (sandeen.net [209.173.210.139])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 5AF22A7DC10
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 12:26:25 -0600 (CST)
Message-ID: <4B16B14A.40709@sandeen.net>
Date: Wed, 02 Dec 2009 12:26:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_io: don't assign cvtnum() return to unsigned var
References: <4B16AFCA.5040302@sandeen.net>
In-Reply-To: <4B16AFCA.5040302@sandeen.net>
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

(whoops meant to include 2 fixes in that)

cvtnum() returns -1LL for unparseable values, but if we
assign to a signed var, we can't test it:

There are problems in mincore & madvise.

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



diff --git a/io/madvise.c b/io/madvise.c
index 694cd41..cd16a4c 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -52,7 +52,7 @@ madvise_f(
 	int		argc,
 	char		**argv)
 {
-	off64_t		offset;
+	off64_t		offset, llength;
 	size_t		length;
 	void		*start;
 	int		advise = MADV_NORMAL, c;
@@ -89,12 +89,17 @@ madvise_f(
 			return 0;
 		}
 		optind++;
-		length = cvtnum(blocksize, sectsize, argv[optind]);
-		if (length < 0) {
+		llength = cvtnum(blocksize, sectsize, argv[optind]);
+		if (llength < 0) {
 			printf(_("non-numeric length argument -- %s\n"),
 				argv[optind]);
 			return 0;
-		}
+		} else if (llength > (size_t)llength) {
+			printf(_("length argument too large -- %lld\n"),
+				llength);
+			return 0;
+		} else
+			length = (size_t)llength;
 	} else {
 		return command_usage(&madvise_cmd);
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
