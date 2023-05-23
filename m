Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECB4C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbjEWJBb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbjEWJB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B681FF
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EfMb031379;
        Tue, 23 May 2023 09:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=v/411W+AiNZBeY1UvLwKA3UpDZKjNd31N64sJAYu6Ng=;
 b=tLbMzbrGaeJ8YAHG8nP5veJuDflEmJQLQ/eNf0gS9ZaJwq2oRhv4JieeSTEMjUT8kgyB
 55ZEvVp5HvJ1vZib6KJEX3UE/REATTQfl301dXlVqDeoWgxGrE8w0fyxv5TEUJ3nAang
 cW64AdC2QhVLW4LPvw4J3xjnl5bxniHAyKwK+tZ0GEtdULVvQpYSWeV7Fqot2phoJMjr
 BfMt5fW5m9TFLgTxaP2YTK99FvBVHXt2jaAgQYf07/ePOjF/Dgswk1uOY3ar+N3SK+vU
 dx23LZyiXjKv709PSLpb35Dlzzc4LBSu1vGqUi8TfI2TNrUCcXsAzM8nrhB4eKYOCPfw 0g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3mmn4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6tBgb029028;
        Tue, 23 May 2023 09:01:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xws9007681;
        Tue, 23 May 2023 09:01:23 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-24;
        Tue, 23 May 2023 09:01:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 23/24] mdrestore: Add support for passing log device as an argument
Date:   Tue, 23 May 2023 14:30:49 +0530
Message-Id: <20230523090050.373545-24-chandan.babu@oracle.com>
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
X-Proofpoint-ORIG-GUID: eRxvOlX4l_lnLJOKQ7mFfPCqg-deQnpS
X-Proofpoint-GUID: eRxvOlX4l_lnLJOKQ7mFfPCqg-deQnpS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

metadump v2 format allows dumping metadata from external log devices. This
commit allows passing the device file to which log data must be restored from
the corresponding metadump file.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 9e06d37dc..f5eff62ef 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -427,7 +427,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+		progname);
 	exit(1);
 }
 
@@ -453,7 +454,7 @@ main(
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "giV")) != EOF) {
+	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
 		switch (c) {
 			case 'g':
 				mdrestore.show_progress = 1;
@@ -461,6 +462,9 @@ main(
 			case 'i':
 				mdrestore.show_info = 1;
 				break;
+			case 'l':
+				logdev = optarg;
+				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
@@ -493,6 +497,8 @@ main(
 	}
 
 	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
+		if (logdev != NULL)
+			usage();
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		header = &mb;
 	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {
-- 
2.39.1

