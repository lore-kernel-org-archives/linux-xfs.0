Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D8BC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbjEWJB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbjEWJBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E146FF
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:23 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6Ef9X032465;
        Tue, 23 May 2023 09:01:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=vVYfWCBntFnE2W/QIo75dbdfeZ0DEBLjOePuT1zGYjA=;
 b=ZJWITo2NeHkPtv2Xp1Qbrylpq/gA1XaGAt0eCzQ2jQuU/si7MpBtKZuHwSxGwnZro3GR
 gODPnFK9r4yTaoPWK+TMLJonv85AdnyRrwXRD0LtlVZpCkR27wZelHBaz1PxhLYrXaNt
 8NzUD1Jzcl1R705iBc5FL3HgMEnwq0SNuQg6Zuyz8ThFZrGSIAsfDbz9cW3FWodJ1yLJ
 II7GDMeMVIZjG5ddy2lLLqygdBeGjuIkkku4yb4xmPVJZ2mCdf/QjPOe5wwi/xpVi5Os
 XTJlNVbgwUEA7lKap0PPFvU4UnDkRMPdleGACLer7nVGYUNCrS3zZYcT9k06aYkw5f4z vQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp5bmmdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8rh3S028933;
        Tue, 23 May 2023 09:01:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xws3007681;
        Tue, 23 May 2023 09:01:20 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-21;
        Tue, 23 May 2023 09:01:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 20/24] mdrestore: Detect metadump version from metadump image
Date:   Tue, 23 May 2023 14:30:46 +0530
Message-Id: <20230523090050.373545-21-chandan.babu@oracle.com>
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
X-Proofpoint-GUID: Q9dLgGKxEbO6_bZuzZU7zBI_RHyGklBc
X-Proofpoint-ORIG-GUID: Q9dLgGKxEbO6_bZuzZU7zBI_RHyGklBc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 5ec1a47b0..52081a6ca 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,7 +8,7 @@
 #include "xfs_metadump.h"
 
 struct mdrestore_ops {
-	void (*read_header)(void *header, FILE *mdfp);
+	int (*read_header)(void *header, FILE *mdfp);
 	void (*show_info)(void *header, const char *mdfile);
 	void (*restore)(void *header, FILE *mdfp, int data_fd,
 			bool is_target_file);
@@ -86,7 +86,7 @@ open_device(
 	return fd;
 }
 
-static void
+static int
 read_header_v1(
 	void			*header,
 	FILE			*mdfp)
@@ -96,7 +96,9 @@ read_header_v1(
 	if (fread(mb, sizeof(*mb), 1, mdfp) != 1)
 		fatal("error reading from metadump file\n");
 	if (mb->mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
-		fatal("specified file is not a metadata dump\n");
+		return -1;
+
+	return 0;
 }
 
 static void
@@ -316,9 +318,10 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	mdrestore.mdrops = &mdrestore_ops_v1;
-
-	mdrestore.mdrops->read_header(&mb, src_f);
+	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0)
+		mdrestore.mdrops = &mdrestore_ops_v1;
+	else
+		fatal("Invalid metadump format\n");
 
 	if (mdrestore.show_info) {
 		mdrestore.mdrops->show_info(&mb, argv[optind]);
-- 
2.39.1

