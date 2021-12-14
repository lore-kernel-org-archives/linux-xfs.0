Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646AEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhLNIud (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:50:33 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20574 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231709AbhLNIud (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:50:33 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7MkId004563;
        Tue, 14 Dec 2021 08:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JRI21QCjDV+vJVKtFKVlGMW6DCaOiQnQBBVcF5nJzqU=;
 b=YsWiyQtsMQR/3/g6lePtonjrvDgqxapU8ZZsW8owHVoUrTBHyCRXGQRGW2y0moyb7GRp
 EUBt6WnY8SePq/Oz+hTuTftgfKUYAeNNoHANlWIaoGXBS/JCWY64dru+QojV/o56RIAy
 ZiEvaVqgFYv9L8ez0v11zPjiuXg6CZ8/BjL8Rmu8Sce99NcOl98r+PduNoM5+cVyYUP5
 h9LOtY4jWD5HsY+WFU49c/TuRPv7gqXQmI5h/Zf2CPV0bN3NjNN7O5E3nxd/EWdPn07M
 94YoWuvVu9UEGehrxajIEUWFc25W6bxHGD7GWsn5DyhZKhPTIB7h4hY4J0w0mGi6Gz+L qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mru63w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8oS16104895;
        Tue, 14 Dec 2021 08:50:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yk5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:50:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfLowsqLGoYMxdKE0ywtSv6FL1wYzBYyZuOKyeg8ytNGCKHHcnUu7lpwbmnN28UNJmeeaL9HNZXuxNLPME9SGfcfPjGOwYh3WfJTG2uVe8+xTEILWbVvk64Qx2pHg8k05fd2gM3a6S9H4SwT0JMTE9bNS4mX0DExTf3X0UDA++O7Qn39imt7BRLM6EH8gIZYHsJlm/hYtgdrxqyRZ1E2UAifEWfjq9BD2SSjVecx/dqoMEzeUeamwJB5A70YVg5hAh+oDvKmXWiOX7Gw/7yRfM3l6HJLCg/J9FfKt1QEYcUgIBgRMlPs7IUC62tGgZ3LLKB9aGCq8MgSV/5PiZYlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRI21QCjDV+vJVKtFKVlGMW6DCaOiQnQBBVcF5nJzqU=;
 b=JhyXdY1kUj90ZMdVzZHhVROfsSB94Zrx91CAKKuotsfcX6X8uYCnCsmX15dm6V5kZVVMSLQzlJ2T1Td9j9ysjGXT6EKPp6mBdTRHOid6aPWCms/7beGiYnbnna4K9L+xmxZB+9nGkK68AJjYhwzEGBWo3PNvxx29SvdlrmkVDMljkDuv0OJm7VPa9ofQJZ4IHI5aZ/L8NZIudHxwr2ibAnsydr8bevJW+axAhqHxAYkrTlQbLmZzt7KJ6puKMDx22p6cuzW2xgKmuZKLsPUtW0iovSA1xoShujB9c6KmWC2ge6r3geEkOBLpmNU/KLDWGdfy1iIa//Cr4T8ht9eA7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRI21QCjDV+vJVKtFKVlGMW6DCaOiQnQBBVcF5nJzqU=;
 b=aJXcVcxX352xtTyPk8d9+kz/r5u5GcAgDirjwmsVWbITnhdcRylvQWyqFCn6J7s1FF/HEfjAQBUHprTWOTpFcAnlqndzyoNnr+jD9m7zILeFJ+MbSWQk+THoQll+98aGWmF/tL/+cNawJtU+AKlekEiijJ56eRYsLHoZJBROdIc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4555.namprd10.prod.outlook.com (2603:10b6:806:115::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:50:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:50:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 20/20] xfsprogs: Define max extent length based on on-disk format definition
Date:   Tue, 14 Dec 2021 14:18:11 +0530
Message-Id: <20211214084811.764481-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e315c867-f874-4220-5fac-08d9bedec268
X-MS-TrafficTypeDiagnostic: SA2PR10MB4555:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45557CCDE1A381374B343ABEF6759@SA2PR10MB4555.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tImxLVNdQ+j99Q23QeqJUNk3ozi/uCPALGn/VL0Qc3z6TLr3bNpU2zHekp7HjMVUz9w/pdq+qvOZdWTqqb/+UzBcv9DZ9nX8iQiyw7VtjVsDLytbseEkBWPoHBqh90vta2GKVL/St8Lmj52c+X1iZ0LMjShgqKVvEsYhTb2bawjpDGJKFznLFZ3BYLvMO2fS57EM+akPZtK9bMgzSjH+A3ngHX3pGMr+vrTfIFdbD+KOgyiutSYGmfUaBNBFkmaDhaMjtwjLmTip1CN7942ZTwPJP6cMg9iNUOZk7Zgoz2cLhlxF8qDAEGfyQhXLBCzypH72n2An0mKq5oIbe4rSB/dVJvn/6Afiv+D3w4GmdES1tmFIWNzXPK6KjYELs/Xh1ugwhhT37mQliWb+UghJz1e9Mgt8bUBZifERJEiMU/9CmwZpq20e15osXRebFs9xKMmnuGcO2YKZ7DlfuAnTec257vlRuDH3neZIgJUBKiIG407XrynAiHj183GsrHxnUacy2l8SZfAxldgY17YiWwnkJlmjYOGUxwsUYEM/XJwV6XZMnayngqlvrnRckAAc+8OGXxYaOmOXFKKe1ZyEwuRTKW9HhqO3kS3haaIPa+MEAu7Y1H3r5WyGVpnTrYddh2VWcOQgvyOQgC6JkqiOI/R0nCFmtkVv2uxika6o+I0eeJKFWUX/TBIV/vBSSckWVmev+9yKsDdAlYyZZoj1mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(52116002)(38350700002)(8676002)(38100700002)(26005)(508600001)(316002)(2616005)(8936002)(36756003)(66476007)(66946007)(1076003)(6506007)(2906002)(6486002)(30864003)(6916009)(86362001)(6666004)(83380400001)(186003)(4326008)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d1MYkEdYChL7yjHbPw+3a4EWZMZ5W3tKCl4t2L08tAS6tSRFHsEl8q1X7Vor?=
 =?us-ascii?Q?9OQOqQE3+rHFxOw1nEhd+3mhDU8Cv2atm0w5GnuS1sVQMAAXGW9XjNXmqXfb?=
 =?us-ascii?Q?/YKozOP9Ctwd13ddZqXgpK6nc8WBOopRzhdnM8NN1C8GLUVYzsML0/W0Wa0p?=
 =?us-ascii?Q?snpeW2KzFxCK5QuJwamzSAdxnvHiYPV0Yw329iDyyf5+xQSg0GpipvtU7ls0?=
 =?us-ascii?Q?Kwk0U0J1goFEQTeB+/WEffVZxm9au4Vp0Tt759XdocvKI9T7Vt3IotCGkoIM?=
 =?us-ascii?Q?Ncq9RWwaJ7tyIjq2bU/WTXH76Wt9jxZTzAFki812i9fDpzxx6bWRYrPhFO9N?=
 =?us-ascii?Q?yDARLteSEihKXlbFIZljpyXfwILYx0aQmPnTcMC9tJAKcIJ6xwFO6j95Iw5L?=
 =?us-ascii?Q?g4iLhGAPO0MohpIDZfeqhCqH72V0sa/sEwtbybcj3lUdBuxmdbhhrhqVLZar?=
 =?us-ascii?Q?3i4zsNEuXDr8NcvF3XXaMmSL9glHDtDI6RTIVJiDJjMMyhbFhOQYIzSrf87L?=
 =?us-ascii?Q?jjkKomvgqi0VU9iynGxdwX8U+5lPrrsGx3WmTld3VBQUG1CKi4NMeR/KhsVh?=
 =?us-ascii?Q?BIEnM0bFf6bx4jdTkw7hRlSpyB8jkP6qGv2iNzIzQBWCLuM/yFAm0VbRsyQz?=
 =?us-ascii?Q?Y5UedEFraj/KZRi8jacsQVZq2rWJWW/IyBnDV4FUpNCX5NL1BjtK3OWk55/v?=
 =?us-ascii?Q?udIl2E8ElRFKjXM8HDmmidr/nR+ONairdxhVD2xyCi+X7iK1IiHZ1V2JAFPx?=
 =?us-ascii?Q?CXIghslX0ZLh68zJtSc+ZWnMd33Ulh6yTzbEwh8QCXmXlr8wHHUMfQIGeNUS?=
 =?us-ascii?Q?eXsFxAPmiclUixwVYE8Oy8n8kEtQ1MWpSYdwnudUnS4S2FVTBeL04t+cR3bA?=
 =?us-ascii?Q?ca5/XzWPrVN01AyaxFu3Aia7+fvuEtZbOZEAiGXHBJnuZcXd/hnc/IQrjuUX?=
 =?us-ascii?Q?D8GbfB8uDHbO301X5jVlegqBko2xk8LS/yDk/+Z7PlhqXJLcsBBKGX13mASF?=
 =?us-ascii?Q?HCrm6f2C19OjeTEIT/etiZxVwvGmKg8XFFcYBue/BmprR8GQxqIxr78SR9hS?=
 =?us-ascii?Q?6c5iZXO97fbRCCEB4cj34l9hitK4ZaiAW28B8cu05ZxVinnPTJ1+5Us72p3r?=
 =?us-ascii?Q?zVXS+KHT+LKw5a3OlxNK/MHxfk62J3Xs7VuA50tU6UlwaZhofAEs+utPxV6w?=
 =?us-ascii?Q?nA08Jcdgc1tskAnsqqteALNyF+uBSq4MOv0ZvT+SEwe6O17k7KL5QLW9LN0E?=
 =?us-ascii?Q?T2VrAJnIsIClJwjzhw3HtDxewRT6pTdb2nGREmIpU3LPEAHpesME+F3Y13XB?=
 =?us-ascii?Q?dD7d137Xt9BeAzZoHMAIXra11FQEe8VqgUMjw0PiuUjwmCIu2e6NbsuWO/Oe?=
 =?us-ascii?Q?ff0/ATUcN/WFie3K9T0GEH8p3mPBHHwfyPWeyfJJtwlfNDlvtKMxBmMrVFRi?=
 =?us-ascii?Q?cnReXsxG74frMmPznMTeowI9qjfX80nKQq1HAC11ko9IqZCL5X4qIgX1DeBi?=
 =?us-ascii?Q?kdpYB4IvJdYivFjnKbbevr6BazHcdWVvgtKAIE+stCvZGICXuco6jjm/PBv3?=
 =?us-ascii?Q?kxiEkgRz29SoWsaKici9cXYFlzHM3trIyo93iVO8W6K3Zl7FkFHlCmS8a+rU?=
 =?us-ascii?Q?wx0Abf1gNdHC6Rie2NoN2cY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e315c867-f874-4220-5fac-08d9bedec268
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:50:20.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pls5xzH7xl1zdrQa0xVmYpKtA9upnn4PkkuSVSMB6s+MSOrYOpPIZEmopTgiJ1wr+5Lp+OlbUNVCaFjRHtFKOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4555
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140050
X-Proofpoint-ORIG-GUID: c3LOYzPjZcXd-gYdG6xKFxxSfu6q5tWC
X-Proofpoint-GUID: c3LOYzPjZcXd-gYdG6xKFxxSfu6q5tWC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum extent length depends on maximum block count that can be stored in
a BMBT record. Hence this commit defines MAXEXTLEN based on
BMBT_BLOCKCOUNT_BITLEN.

While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c           |  2 +-
 libxfs/xfs_bmap.c       | 53 +++++++++++++++++++++--------------------
 libxfs/xfs_format.h     | 23 +++++++++---------
 libxfs/xfs_inode_buf.c  |  4 ++--
 libxfs/xfs_trans_resv.c | 10 ++++----
 mkfs/xfs_mkfs.c         |  6 ++---
 repair/phase4.c         |  2 +-
 7 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 8a9aec75..3ed4d81a 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -20,7 +20,7 @@
 #include "field.h"
 #include "dir2.h"
 
-#define DEFAULT_MAX_EXT_SIZE	MAXEXTLEN
+#define DEFAULT_MAX_EXT_SIZE	XFS_MAX_BMBT_EXTLEN
 
 /* copy all metadata structures to/from a file */
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9dd24678..ac66a33d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -536,7 +536,7 @@ __xfs_bmap_add_free(
 
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
-	ASSERT(len <= MAXEXTLEN);
+	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
@@ -1493,7 +1493,7 @@ xfs_bmap_add_extent_delay_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -1511,13 +1511,13 @@ xfs_bmap_add_extent_delay_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2041,7 +2041,7 @@ xfs_bmap_add_extent_unwritten_real(
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
 	    LEFT.br_state == new->br_state &&
-	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    LEFT.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	/*
@@ -2059,13 +2059,13 @@ xfs_bmap_add_extent_unwritten_real(
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
 	    new->br_state == RIGHT.br_state &&
-	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + RIGHT.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
 		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING) ||
 	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-			<= MAXEXTLEN))
+			<= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2551,15 +2551,15 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= MAXEXTLEN)))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
@@ -2702,17 +2702,17 @@ xfs_bmap_add_extent_hole_real(
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
 	    left.br_startblock + left.br_blockcount == new->br_startblock &&
 	    left.br_state == new->br_state &&
-	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
 	    new->br_startoff + new->br_blockcount == right.br_startoff &&
 	    new->br_startblock + new->br_blockcount == right.br_startblock &&
 	    new->br_state == right.br_state &&
-	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     left.br_blockcount + new->br_blockcount +
-	     right.br_blockcount <= MAXEXTLEN))
+	     right.br_blockcount <= XFS_MAX_BMBT_EXTLEN))
 		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
@@ -2947,15 +2947,15 @@ xfs_bmap_extsize_align(
 
 	/*
 	 * For large extent hint sizes, the aligned extent might be larger than
-	 * MAXEXTLEN. In that case, reduce the size by an extsz so that it pulls
-	 * the length back under MAXEXTLEN. The outer allocation loops handle
+	 * XFS_MAX_BMBT_EXTLEN. In that case, reduce the size by an extsz so that it pulls
+	 * the length back under XFS_MAX_BMBT_EXTLEN. The outer allocation loops handle
 	 * short allocation just fine, so it is safe to do this. We only want to
 	 * do it when we are forced to, though, because it means more allocation
 	 * operations are required.
 	 */
-	while (align_alen > MAXEXTLEN)
+	while (align_alen > XFS_MAX_BMBT_EXTLEN)
 		align_alen -= extsz;
-	ASSERT(align_alen <= MAXEXTLEN);
+	ASSERT(align_alen <= XFS_MAX_BMBT_EXTLEN);
 
 	/*
 	 * If the previous block overlaps with this proposed allocation
@@ -3045,9 +3045,9 @@ xfs_bmap_extsize_align(
 			return -EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
-		/* see MAXEXTLEN handling above */
+		/* see XFS_MAX_BMBT_EXTLEN handling above */
 		ASSERT(orig_end <= align_off + align_alen ||
-		       align_alen + extsz > MAXEXTLEN);
+		       align_alen + extsz > XFS_MAX_BMBT_EXTLEN);
 	}
 
 #ifdef DEBUG
@@ -4012,7 +4012,7 @@ xfs_bmapi_reserve_delalloc(
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
-	alen = XFS_FILBLKS_MIN(len + prealloc, MAXEXTLEN);
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
@@ -4145,7 +4145,7 @@ xfs_bmapi_allocate(
 		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
 			bma->prev.br_startoff = NULLFILEOFF;
 	} else {
-		bma->length = XFS_FILBLKS_MIN(bma->length, MAXEXTLEN);
+		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
 		if (!bma->eof)
 			bma->length = XFS_FILBLKS_MIN(bma->length,
 					bma->got.br_startoff - bma->offset);
@@ -4465,8 +4465,8 @@ xfs_bmapi_write(
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
 			 * check for 32-bit overflows and handle them here.
 			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
+			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
+				bma.length = XFS_MAX_BMBT_EXTLEN;
 			else
 				bma.length = len;
 
@@ -4601,7 +4601,8 @@ xfs_bmapi_convert_delalloc(
 	bma.ip = ip;
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
-	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
+	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
+			XFS_MAX_BMBT_EXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	/*
@@ -4682,7 +4683,7 @@ xfs_bmapi_remap(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
-	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
+	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
@@ -5682,7 +5683,7 @@ xfs_bmse_can_merge(
 	if ((left->br_startoff + left->br_blockcount != startoff) ||
 	    (left->br_startblock + left->br_blockcount != got->br_startblock) ||
 	    (left->br_state != got->br_state) ||
-	    (left->br_blockcount + got->br_blockcount > MAXEXTLEN))
+	    (left->br_blockcount + got->br_blockcount > XFS_MAX_BMBT_EXTLEN))
 		return false;
 
 	return true;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 0ed9d5ac..ac6aa23e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1073,15 +1073,6 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN			((xfs_extlen_t)0x1fffff)	/* 21 bits */
-#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
-#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
-#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
-#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
-
 /*
  * Inode minimum and maximum sizes.
  */
@@ -1810,8 +1801,18 @@ typedef struct xfs_bmdr_block {
 #define BMBT_STARTBLOCK_BITLEN	52
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
-#define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
-#define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
+#define BMBT_STARTOFF_MASK ((1ULL << BMBT_STARTOFF_BITLEN) - 1)
+
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define XFS_MAX_BMBT_EXTLEN		((xfs_extlen_t)(1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
+#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
+#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
+
+#define BMBT_BLOCKCOUNT_MASK	XFS_MAX_BMBT_EXTLEN
 
 /*
  * bmbt records have a file offset (block) field that is 54 bits wide, so this
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index a484e14b..601ca604 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -666,7 +666,7 @@ xfs_inode_validate_extsize(
 	if (extsize_bytes % blocksize_bytes)
 		return __this_address;
 
-	if (extsize > MAXEXTLEN)
+	if (extsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
@@ -723,7 +723,7 @@ xfs_inode_validate_cowextsize(
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
 		return __this_address;
 
-	if (cowextsize > MAXEXTLEN)
+	if (cowextsize > XFS_MAX_BMBT_EXTLEN)
 		return __this_address;
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 4fd2c62b..559879e5 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -198,8 +198,8 @@ xfs_calc_inode_chunk_res(
 /*
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
- * blocks as needed to mark inuse MAXEXTLEN blocks' worth of realtime extents,
- * as well as the realtime summary block.
+ * blocks as needed to mark inuse XFS_MAX_BMBT_EXTLEN blocks' worth of realtime
+ * extents, as well as the realtime summary block.
  */
 static unsigned int
 xfs_rtalloc_log_count(
@@ -209,7 +209,7 @@ xfs_rtalloc_log_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (MAXEXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
@@ -246,7 +246,7 @@ xfs_rtalloc_log_count(
  *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
- *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: ((XFS_MAX_BMBT_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
  *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
  * And the bmap_finish transaction can free bmap blocks in a join (t3):
@@ -298,7 +298,7 @@ xfs_calc_write_reservation(
  *    the agf for each of the ags: 2 * sector size
  *    the agfl for each of the ags: 2 * sector size
  *    the super block to reflect the freed blocks: sector size
- *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
+ *    the realtime bitmap: 2 exts * ((XFS_MAX_BMBT_EXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
  *    worst case split in allocation btrees per extent assuming 2 extents:
  *		2 exts * 2 trees * (2 * max depth - 1) * block size
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6609776f..deb3b070 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2399,7 +2399,7 @@ validate_extsize_hint(
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 
@@ -2422,7 +2422,7 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
 		fprintf(stderr,
 _("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
 				(long long)cli->fsx.fsx_extsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2),
 				mp->m_sb.sb_rextsize);
 		usage();
 	}
@@ -2451,7 +2451,7 @@ validate_cowextsize_hint(
 		fprintf(stderr,
 _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 				(long long)cli->fsx.fsx_cowextsize,
-				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
 }
diff --git a/repair/phase4.c b/repair/phase4.c
index eb043002..8cad2b80 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -372,7 +372,7 @@ phase4(xfs_mount_t *mp)
 			if (rt_start == 0)  {
 				rt_start = bno;
 				rt_len = 1;
-			} else if (rt_len == MAXEXTLEN)  {
+			} else if (rt_len == XFS_MAX_BMBT_EXTLEN)  {
 				/*
 				 * large extent case
 				 */
-- 
2.30.2

