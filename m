Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB5CC7EE29
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbjEWJB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbjEWJBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED09100
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6F2r7000880;
        Tue, 23 May 2023 09:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=1SvyFrvXMkutq3oTOiS4kl3JHWz6LSpseg8obJbTAyg=;
 b=V1Ez4uivoG4z4UPJXrsAlxDLBPpwmgb/KqTXtd2MEw82fQVmlwdKZYp9PxoU0yx7EzoB
 Mxhc/9D+UzehKr69gSVf3w07huWUtTflpl9pdlp3i38ZWYP7fxhBsKt05fa9PP671jX4
 hezbRJWkhvgHDmqVzS3Moz5CBWVYcAJF0Z4HFMyIOuysDgNcv2XQwBcDEKWJwNOYfGC8
 n5201KW7wWc+KsYtk8eUz6S34Sf2HFTwWy4pxso2HQpCnFzm7USoo5tCnOPsobqx6I2w
 E7Xfgs1UDfDk+XQcflOunZ6YWNENsi255y9wZELNYod+CB8DKFOGwbBa8C6MTd7v0jkI 1A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpprtmku6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8rh3N028933;
        Tue, 23 May 2023 09:01:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:18 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrv007681;
        Tue, 23 May 2023 09:01:17 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-18;
        Tue, 23 May 2023 09:01:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 17/24] mdrestore: Add open_device(), read_header() and show_info() functions
Date:   Tue, 23 May 2023 14:30:43 +0530
Message-Id: <20230523090050.373545-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-GUID: EBsJ8mQ-VKiAT95LJjtUNRbtUIC9iTiq
X-Proofpoint-ORIG-GUID: EBsJ8mQ-VKiAT95LJjtUNRbtUIC9iTiq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with opening the target device,
reading metadump header information and printing information about the
metadump into their respective functions.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 114 +++++++++++++++++++++++---------------
 1 file changed, 68 insertions(+), 46 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index de9175a08..8c847c5a3 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -40,8 +40,67 @@ print_progress(const char *fmt, ...)
 	mdrestore.progress_since_warning = 1;
 }
 
+extern int	platform_check_ismounted(char *, char *, struct stat *, int);
+
+static int
+open_device(
+	char		*path,
+	bool		*is_file)
+{
+	struct stat	statbuf;
+	int		open_flags;
+	int		fd;
+
+	open_flags = O_RDWR;
+	*is_file = false;
+
+	if (stat(path, &statbuf) < 0)  {
+		/* ok, assume it's a file and create it */
+		open_flags |= O_CREAT;
+		*is_file = true;
+	} else if (S_ISREG(statbuf.st_mode))  {
+		open_flags |= O_TRUNC;
+		*is_file = true;
+	} else  {
+		/*
+		 * check to make sure a filesystem isn't mounted on the device
+		 */
+		if (platform_check_ismounted(path, NULL, &statbuf, 0))
+			fatal("a filesystem is mounted on target device \"%s\","
+				" cannot restore to a mounted filesystem.\n",
+				path);
+	}
+
+	fd = open(path, open_flags, 0644);
+	if (fd < 0)
+		fatal("couldn't open \"%s\"\n", path);
+
+	return fd;
+}
+
+static void read_header(struct xfs_metablock *mb, FILE *src_f)
+{
+	if (fread(mb, sizeof(*mb), 1, src_f) != 1)
+		fatal("error reading from metadump file\n");
+	if (mb->mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
+		fatal("specified file is not a metadata dump\n");
+}
+
+static void show_info(struct xfs_metablock *mb, const char *mdfile)
+{
+	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
+		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
+			mdfile,
+			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
+			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
+			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
+	} else {
+		printf("%s: no informational flags present\n", mdfile);
+	}
+}
+
 /*
- * perform_restore() -- do the actual work to restore the metadump
+ * restore() -- do the actual work to restore the metadump
  *
  * @src_f: A FILE pointer to the source metadump
  * @dst_fd: the file descriptor for the target file
@@ -51,7 +110,7 @@ print_progress(const char *fmt, ...)
  * src_f should be positioned just past a read the previously validated metablock
  */
 static void
-perform_restore(
+restore(
 	FILE			*src_f,
 	int			dst_fd,
 	int			is_target_file,
@@ -185,8 +244,6 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
-
 int
 main(
 	int 		argc,
@@ -195,9 +252,7 @@ main(
 	FILE		*src_f;
 	int		dst_fd;
 	int		c;
-	int		open_flags;
-	struct stat	statbuf;
-	int		is_target_file;
+	bool		is_target_file;
 	struct xfs_metablock	mb;
 
 	mdrestore.show_progress = 0;
@@ -230,8 +285,8 @@ main(
 		usage();
 
 	/*
-	 * open source and test if this really is a dump. The first metadump block
-	 * will be passed to perform_restore() which will continue to read the
+	 * open source and test if this really is a dump. The first metadump
+	 * block will be passed to restore() which will continue to read the
 	 * file from this point. This avoids rewind the stream, which causes
 	 * restore to fail when source was being read from stdin.
  	 */
@@ -245,22 +300,10 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
-		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
-		fatal("specified file is not a metadata dump\n");
+	read_header(&mb, src_f);
 
 	if (mdrestore.show_info) {
-		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
-			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
-			argv[optind],
-			mb.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
-			mb.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
-			mb.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
-		} else {
-			printf("%s: no informational flags present\n",
-				argv[optind]);
-		}
+		show_info(&mb, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -269,30 +312,9 @@ main(
 	optind++;
 
 	/* check and open target */
-	open_flags = O_RDWR;
-	is_target_file = 0;
-	if (stat(argv[optind], &statbuf) < 0)  {
-		/* ok, assume it's a file and create it */
-		open_flags |= O_CREAT;
-		is_target_file = 1;
-	} else if (S_ISREG(statbuf.st_mode))  {
-		open_flags |= O_TRUNC;
-		is_target_file = 1;
-	} else  {
-		/*
-		 * check to make sure a filesystem isn't mounted on the device
-		 */
-		if (platform_check_ismounted(argv[optind], NULL, &statbuf, 0))
-			fatal("a filesystem is mounted on target device \"%s\","
-				" cannot restore to a mounted filesystem.\n",
-				argv[optind]);
-	}
-
-	dst_fd = open(argv[optind], open_flags, 0644);
-	if (dst_fd < 0)
-		fatal("couldn't open target \"%s\"\n", argv[optind]);
+	dst_fd = open_device(argv[optind], &is_target_file);
 
-	perform_restore(src_f, dst_fd, is_target_file, &mb);
+	restore(src_f, dst_fd, is_target_file, &mb);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

