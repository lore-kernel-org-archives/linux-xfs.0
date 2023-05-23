Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57AFC7EE2A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbjEWJBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbjEWJBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C198102
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6Ekg1000590;
        Tue, 23 May 2023 09:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=UsDYO47QK9Kg7k9t55ama0/d3Ve0h35bjE6jzwved5Y=;
 b=lUNpP+yZSh5Ms6CGSYTOFVsFIDLORFdb4SXO6qKZy5GkSFIgLE4LTe0ZXutYLGtoK7In
 632LD1fCK4gZoo9NWcD0vi8Je/+8gSxZH63qJ5TLiStE8xE8k0/pfztxUH5Tg0RCMakk
 H6aWwVKIlfzPjWSv8mUFo3PU1EVDoXFQUcGL19ufzuTArv0+bffBmKhVP1wQRp6zjoWl
 Ic+tR9+mwISXr/4jBVMnwBGHQEmp9CPP0x0mM+UAY0AHve09a2/8RxAI5mCdra4CT+1h
 Nlh56H0pbxzWZYo6SlMieGTfiyIjOsbbRQ9Agf4Z/HUDVfberKF+4JUT9x3ESaQ6tCQW sw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpprtmku4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8dwGD029050;
        Tue, 23 May 2023 09:01:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:17 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrt007681;
        Tue, 23 May 2023 09:01:17 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-17;
        Tue, 23 May 2023 09:01:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 16/24] mdrestore: Define and use struct mdrestore
Date:   Tue, 23 May 2023 14:30:42 +0530
Message-Id: <20230523090050.373545-17-chandan.babu@oracle.com>
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
X-Proofpoint-GUID: IgqKqv7KAyjbfXPxrOUH6kI4cCpaSZc8
X-Proofpoint-ORIG-GUID: IgqKqv7KAyjbfXPxrOUH6kI4cCpaSZc8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit collects all state tracking variables in a new "struct mdrestore"
structure.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 481dd00c2..de9175a08 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -7,9 +7,11 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 
-static int	show_progress = 0;
-static int	show_info = 0;
-static int	progress_since_warning = 0;
+static struct mdrestore {
+	int	show_progress;
+	int	show_info;
+	int	progress_since_warning;
+} mdrestore;
 
 static void
 fatal(const char *msg, ...)
@@ -35,7 +37,7 @@ print_progress(const char *fmt, ...)
 
 	printf("\r%-59s", buf);
 	fflush(stdout);
-	progress_since_warning = 1;
+	mdrestore.progress_since_warning = 1;
 }
 
 /*
@@ -127,7 +129,8 @@ perform_restore(
 	bytes_read = 0;
 
 	for (;;) {
-		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
+		if (mdrestore.show_progress &&
+			(bytes_read & ((1 << 20) - 1)) == 0)
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
@@ -158,7 +161,7 @@ perform_restore(
 		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
 	}
 
-	if (progress_since_warning)
+	if (mdrestore.progress_since_warning)
 		putchar('\n');
 
 	memset(block_buffer, 0, sb.sb_sectsize);
@@ -197,15 +200,19 @@ main(
 	int		is_target_file;
 	struct xfs_metablock	mb;
 
+	mdrestore.show_progress = 0;
+	mdrestore.show_info = 0;
+	mdrestore.progress_since_warning = 0;
+
 	progname = basename(argv[0]);
 
 	while ((c = getopt(argc, argv, "giV")) != EOF) {
 		switch (c) {
 			case 'g':
-				show_progress = 1;
+				mdrestore.show_progress = 1;
 				break;
 			case 'i':
-				show_info = 1;
+				mdrestore.show_info = 1;
 				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
@@ -219,7 +226,7 @@ main(
 		usage();
 
 	/* show_info without a target is ok */
-	if (!show_info && argc - optind != 2)
+	if (!mdrestore.show_info && argc - optind != 2)
 		usage();
 
 	/*
@@ -243,7 +250,7 @@ main(
 	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
 		fatal("specified file is not a metadata dump\n");
 
-	if (show_info) {
+	if (mdrestore.show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
 			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			argv[optind],
-- 
2.39.1

