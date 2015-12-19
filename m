Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3DCEB80D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1EA328F8066
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:02 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YBkVTXag9tQWLkAd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:00 -0800 (PST)
Subject: [PATCH 01/53] xfs_io: allow zero-length reflink/dedupe commands
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:57 -0800
Message-ID: <20151219090457.14255.2319.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Since it's convention that calling the reflink/dedupe ioctls with
a zero length means "do this until you hit EOF in the source file",
explicitly permit this as an input.  Fix the ioctl code to handle
this correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/reflink.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)


diff --git a/io/reflink.c b/io/reflink.c
index 5ba1c93..def01be 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -71,7 +71,7 @@ dedupe_ioctl(
 	info->fd = file->fd;
 	info->logical_offset = doffset;
 
-	while (args->length > 0) {
+	while (args->length > 0 || !*ops) {
 		error = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
 		if (error) {
 			perror("XFS_IOC_FILE_EXTENT_SAME");
@@ -85,14 +85,16 @@ dedupe_ioctl(
 			printf(_("Extents did not match.\n"));
 			goto done;
 		}
-		if (info->bytes_deduped == 0 ||
-		    info->bytes_deduped > args->length)
+		if (args->length != 0 &&
+		    (info->bytes_deduped == 0 ||
+		     info->bytes_deduped > args->length))
 			break;
 
 		(*ops)++;
 		args->logical_offset += info->bytes_deduped;
 		info->logical_offset += info->bytes_deduped;
-		args->length -= info->bytes_deduped;
+		if (args->length >= info->bytes_deduped)
+			args->length -= info->bytes_deduped;
 		deduped += info->bytes_deduped;
 	}
 done:
@@ -145,7 +147,7 @@ dedupe_f(
 	}
 	optind++;
 	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
-	if (count < 1) {
+	if (count < 0) {
 		printf(_("non-positive length argument -- %s\n"), argv[optind]);
 		return 0;
 	}
@@ -202,7 +204,11 @@ reflink_ioctl(
 	struct xfs_clone_args	args;
 	int			error;
 
-	if (len) {
+	if (soffset == 0 && doffset == 0 && len == 0) {
+		error = ioctl(file->fd, XFS_IOC_CLONE, fd);
+		if (error)
+			perror("XFS_IOC_CLONE");
+	} else {
 		args.src_fd = fd;
 		args.src_offset = soffset;
 		args.src_length = len;
@@ -210,10 +216,6 @@ reflink_ioctl(
 		error = ioctl(file->fd, XFS_IOC_CLONE_RANGE, &args);
 		if (error)
 			perror("XFS_IOC_CLONE_RANGE");
-	} else {
-		error = ioctl(file->fd, XFS_IOC_CLONE, fd);
-		if (error)
-			perror("XFS_IOC_CLONE");
 	}
 	if (!error)
 		(*ops)++;
@@ -268,7 +270,7 @@ reflink_f(
 	}
 	optind++;
 	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
-	if (count < 1) {
+	if (count < 0) {
 		printf(_("non-positive length argument -- %s\n"), argv[optind]);
 		return 0;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
