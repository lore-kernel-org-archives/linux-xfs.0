Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45F837D03
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:13:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED33C8F8033
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 16:13:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KAMngGluIGGZYOUj for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 16:13:39 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 94FB6545
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:13:39 -0500 (CDT)
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-16-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4b05741c-cc35-2a38-be92-287c216423be@sandeen.net>
Date: Mon, 2 May 2016 18:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-16-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

Add const to other copy of check_overwrite
Move "no mkfs target" check to a higher, more obvious location
Do not truncate file unless it needs to be grown to full fs (as in
Jan's v2)

Eric Sandeen <sandeen@redhat.com>: move check for no mkfs target
Eric Sandeen <sandeen@redhat.com>: other minor fixes
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ec24884..1643289 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -951,7 +951,7 @@ out_free_probe:
  access are not working!
 static int
 check_overwrite(
-	char		*device)
+	const char	*device)
 {
 	return 1;
 }
@@ -1037,10 +1037,6 @@ check_device_type(
 		usage();
 	}
 
-	if (name == NULL) {
-		usage();
-	}
-
 	if (stat64(name, &statbuf)) {
 		if (errno == ENOENT && *isfile) {
 			if (create)
@@ -2218,6 +2214,11 @@ main(
 	} else
 		dfile = xi.dname;
 
+	if (!dfile) {
+		fprintf(stderr, _("no device name given in argument list\n"));
+		usage();
+	}
+
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
 	 * For RAID4/5/6 we want to align sector size and block size,
@@ -3127,13 +3128,15 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	/*
 	 * If the data area is a file, then grow it out to its final size
-	 * so that the reads for the end of the device in the mount code
-	 * will succeed.
+	 * if needed so that the reads for the end of the device in the mount
+	 * code will succeed.
 	 */
-	if (xi.disfile && ftruncate64(xi.dfd, dblocks * blocksize) < 0) {
-		fprintf(stderr, _("%s: Growing the data section failed\n"),
-			progname);
-		exit(1);
+	if (xi.disfile && xi.dsize * xi.dbsize < dblocks * blocksize) {
+		if (ftruncate64(xi.dfd, dblocks * blocksize) < 0) {
+			fprintf(stderr, _("%s: Growing the data section failed\n"),
+				progname);
+			exit(1);
+		}
 	}
 
 	/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
