Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7648D7F76
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 12:38:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6450E8F804C
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 10:38:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KOpqxfj6SJdqvtBM for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 10:38:07 -0700 (PDT)
Message-ID: <544FD47D.8020409@sandeen.net>
Date: Tue, 28 Oct 2014 12:38:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfsprogs: don't warn about log sunit size if it was
	auto-discovered
References: <544FD3E1.1060000@redhat.com>
In-Reply-To: <544FD3E1.1060000@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>

Today, users doing a bare mkfs on storage with a large default
stripe size may be surprised to get this warning:

 log stripe unit (%d bytes) is too large (maximum is 256KiB
 log stripe unit adjusted to 32KiB

through no fault of their own.  The fallback is appropriate
and harmless, and there's no need to warn about this in the
defaults case.

However, we keep the warning if a large log stripe unit was
specified by the user on the commandline.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a0fed31..66711cb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -946,6 +946,8 @@ main(
 	int			logversion;
 	int			lvflag;
 	int			lsflag;
+	int			lsuflag;
+	int			lsunitflag;
 	int			lsectorlog;
 	int			lsectorsize;
 	int			lslflag;
@@ -1004,7 +1006,7 @@ main(
 	sectorsize = lsectorsize = XFS_MIN_SECTORSIZE;
 	agsize = daflag = dasize = dblocks = 0;
 	ilflag = imflag = ipflag = isflag = 0;
-	liflag = laflag = lsflag = ldflag = lvflag = 0;
+	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = 0;
 	loginternal = 1;
 	logversion = 2;
 	logagno = logblocks = rtblocks = rtextblocks = 0;
@@ -1400,6 +1402,7 @@ main(
 						respec('l', lopts, L_SU);
 					lsu = cvtnum(
 						blocksize, sectorsize, value);
+					lsuflag = 1;
 					break;
 				case L_SUNIT:
 					if (!value || *value == '\0')
@@ -1412,6 +1415,7 @@ main(
 						usage();
 					}
 					lsunit = cvtnum(0, 0, value);
+					lsunitflag = 1;
 					break;
 				case L_NAME:
 				case L_DEV:
@@ -2379,11 +2383,15 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	}
 
 	if (logversion == 2 && (lsunit * blocksize) > 256 * 1024) {
-		fprintf(stderr,
+		/* Warn only if specified on commandline */
+		if (lsuflag || lsunitflag) {
+			fprintf(stderr,
 	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
-			(lsunit * blocksize));
+				(lsunit * blocksize));
+			fprintf(stderr,
+	_("log stripe unit adjusted to 32KiB\n"));
+		}
 		lsunit = (32 * 1024) >> blocklog;
-		fprintf(stderr, _("log stripe unit adjusted to 32KiB\n"));
 	}
 
 	min_logblocks = max_trans_res(crcs_enabled, dirversion,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
