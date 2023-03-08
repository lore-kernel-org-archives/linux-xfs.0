Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64ADCC678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCHWjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCHWjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:39:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686D229429
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:39:01 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxuSj028471
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=S0UDWEZEQ7wjM3PnNrAw+hb3UMPHndWMzynBWAS+RKc=;
 b=k7NX7zEz+4kHm+A6DIAOMtPFvbBkvGwOMhK1ZeNWMF51V4+lcmbXq8NqpKCvixJsmhLK
 9NVZ/XM6FDMEq3ScRvj7cv4KukzrBfu6+/RZ1D5QzHVgvbc5tZaD7fu4ZSztnrJ3U2pI
 VvRpGh452RI2VX4tRJtyG+VFp4I68xW8wwt1rvIOtCgAJ0TguUFObVYwgbvR/tvG2VtW
 LRwEusNSL7sGR74+0wl73bX/JsqnUZCCqUipEx7vgcPkCfcz7ZFiuXnmJ2ULBWzAeCNU
 VTF2mBtrNFJFc9RAVZDIsFfYTY87xdsLG4QBSF8Ai/8pP6s3tLZCmjQr4Ie91sdZ55wD 9A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y1eg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:39:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MC0No020848
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fu8mybg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbmJfT63OCHazW+WFYUw8ioRcKv/kppKS1k6GxiLC9pI1goYx7GjCJgS7aYuiwS5GG4MRddQB51/7RcGM2hIzYe0kF0qWsfcHy9G1S4U8Jis9+7TwU1VPrjHsfej4xpYw5v9D8j+O7gDJMjBaUnsMqK9t0TymXzVd7P4RlSjqQmO2XH/0HEqaqEBFuIfW1yp/vyTlXWbNNg7i4y9lmZeeJwwUNZzu7T3/bt88QcrOgUb5Wl7KVzJeVL4wjtvBti9bHSAx1SPMpQzotkVEDXlcBUXf5/wL+7476hXCCoOCMQE5ijMbvN9snqOEDE8v/dRleIiBh6r0MxqcuP7iiyBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0UDWEZEQ7wjM3PnNrAw+hb3UMPHndWMzynBWAS+RKc=;
 b=TPcNyoCX8HYNzuk5y4Ah6LA2SMPHiXEWa44UlLKqIFw+Kq4avXuJP49s7W87D6Cu2YOSkcaYqkKkX6MfhhO8iFsTNl/uetvf/dSCc5LzyPgv+QkrtWXOE0k/1wLnPGDLMwcrwBHFmFS4VUwx5iWjM8HkA0pEABASEc+SqabBq/ZjBSC2ET2IpQ1/99E01/lKAFAQRNO7nEvwBecbcbI3BvAkuP9bSDllAvKR5vauW1pvfeKaeLQEZRk8K0fT5iVuzF8DPdhZXZkTdaGvwFr0KFDBUBSMeWGIdhTcii5zfROmehqhUeJ0zukXPuwZDwg07OKtkQFJJ0TO9ZuXSqvgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0UDWEZEQ7wjM3PnNrAw+hb3UMPHndWMzynBWAS+RKc=;
 b=zOQh70bhyNN4bAqRanNiGC6hfW6FHzrXq6EjYvwF8NQFgNzQVWNVR+Jb93IHYUhGrZlhfqWe1hfWknKKJm0g59xWu5Lf5naTP4SdjdosigtXMkquGq3YQcfwBMDK4P3tEbSFj5QYmn4qmILurB1olRo00eR9uiWV0gyrVE5z1gI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:56 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 32/32] xfs: don't remove the attr fork when parent pointers are enabled
Date:   Wed,  8 Mar 2023 15:37:54 -0700
Message-Id: <20230308223754.1455051-33-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: b3439cb3-7485-48f4-8d37-08db2025e6f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qgHhHQK3o0HhzD39MrVeRRUcomGQnZuYQDnHwdVO8VUf0pUHlt1p0obikGTiOvOHjrocSAEexAtiZDp7Yd6FULZ8zpKb/IDiAnJkB28RJHvNyfDvqH5N3mtX22sgpoFFbmqBdPYuN7TuOOWtBOLVWwU4wf6u6bmHoVBHsQMeUA64ss4hiKV9rqcq4sZJuH+TWuTrI9gizMGvE/HxVs40QpeVUe8qGV65xLBy3i4+x4APk5JOQvoHBtQP/wfRR1pqKZYo2MmBuk21GjhlDskAWtUkONVezqN4LOJ6FCDvhl0BJeiHdP2nMUAh1bsgOtvsIgNkvyMiWtfebihPXUWlXBGooaKtbRkgft/T1e1LWFRK49CpyvPmsRiIGoWcLSTMFi45OSOSbU5DoGoKIuzFo2KFSVAColJd4HgG9svDrjQ5iPwNnAFpPteM7oAzXqonCojBnkeeVbB7mCiRlFJjNpqA0OZAI866Uy9k1Qt3hq/hjYx5S1h5vePST+Mkfw1VmElKGiam9ZY1Wg/BNxJxZ2G6RXWWvIn3YfnRJOvZyqSum+LyLnwfN1ov8pjdPQ4NgZhXRE4yPTc6BB1DB0PuSJNvnP7TMo4mTnPXC9C07cMKonI26nVB0QcKkqTq0wkAyyEIB8S/J1bm/7OYQXYVag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZsYm45P1eKUdhjhuMrnLBypWMPlJL43k5/lkvmS1n0Bz1D5EjYHyBCufgc4i?=
 =?us-ascii?Q?xynAJ4I2wC+ty3/tx3pOEH9i4E/8TfiQf1gxgE7PnuINPKk6BLj9yRAFMolz?=
 =?us-ascii?Q?M58BPBGsaH4gtxagLJ61ps2BqMoztJVtWhVuycwfolTh9TX4+eQmVNnxgxWD?=
 =?us-ascii?Q?UZ7wOctkLT5a7Vb1qDfflqdberISOdma0CkpufCQTXj6ETEOE+9FUAu+zBPI?=
 =?us-ascii?Q?nHOuhx+d4mVSNCz8YvZQG4ZnzkSgLuEMlfAyNVw7oWr9N414rkz5tsecvH4/?=
 =?us-ascii?Q?7eeRmuLAcbOCQ9537Vf2VrYb33m2tgKsqSrYmQ1RAkEh2FKLY7KEQUctDqRp?=
 =?us-ascii?Q?l42CJLGDENIzRyvSAUBWdCk8Qw+bewIVlqrOFEQGSSPEYX9ZzOfVI9Y95aKu?=
 =?us-ascii?Q?kMnplMoFBGUBACe7Q9bYOO6xONmEndUJ3dzxuMXf4rMGaAnFYl9Zdc+Arvl3?=
 =?us-ascii?Q?2FpLRSWzb30oY856qb2T2XZPG66R/dRJt18TjM8kOeu1JLhN0G20eByYzW8D?=
 =?us-ascii?Q?zFjOeRBjG+zv6KnWH3JrroaXZn31w5ND/m7rz9IxCkAXqSlyD+47owAbCL0f?=
 =?us-ascii?Q?CA2o4pu8rsA6/PqamYVsab1GHndJ0f6oAUBilwGsieRh+B3uLMSOgGWjWKmz?=
 =?us-ascii?Q?OHCI/jZmuA63MYhf7mxEpIgCWJNbBFoIFkFq41gV003PSqWinANPNVjDRoyF?=
 =?us-ascii?Q?KCSZ7y5H1R3jX/Z3vg1saSxnZwQatmdzVn48J483iAsN6EHVjIS/sdOZOTst?=
 =?us-ascii?Q?WiGsH818FwnOtd5JDlAnPqBn9GArQDCYTv0rfZ9tEUcgpbClFghBdR1CY0DB?=
 =?us-ascii?Q?93ixHREWnJDcT5WaiUPUzGe0ae6ZW3887QQm8Y8aApOJfoMAXruH6l3gdc/s?=
 =?us-ascii?Q?sRPHjmGTyCS2FKtkOQKXDbYBGD7m14Wb9koyuwIy+Tj1SO+Kk3TL92gzFHk/?=
 =?us-ascii?Q?5Ecc8rX1Wn9Sg5skHvQogLXx71DkpnGITRDEvI9ey5YFP+FW2YATA4ZLvRf4?=
 =?us-ascii?Q?mGeoV35FYYrT5ldST2upmRElkZsdP4rMAcBYeLAqDYqWhSnAFk3FGofz4ea5?=
 =?us-ascii?Q?MpIz+VBYJYQisv+CtE5Mavmj7Q5sZlwFlVKeYTOSYZgI3y55Pu22kL5tOIup?=
 =?us-ascii?Q?IlItMQLgUBcr8z7ATNeSjK5luc4KeeVG1DlcjwjXbernTmt3cB7yZ50VyXY5?=
 =?us-ascii?Q?p/qqLkFpZLaLvjkwNqqkeSOJShszzewCOQI2vTGBsjndDojAKENHlzqRNxCB?=
 =?us-ascii?Q?5mv7RzpAkjYAucscXPMAjsxsie3U1J7f/sBCb6M2d/qP/P7Q2NExfiPogon5?=
 =?us-ascii?Q?/BzXgO87oBUtL8xGzeniaFWQ8KBK10MPWkjDTxOJaJrwOhwjWUwgcoPGX9F8?=
 =?us-ascii?Q?R9K2DhQ20czBKoCFSYdqBFSYDcZCPLx3gT17hPzrCG94oDR+VaavNog0B3QD?=
 =?us-ascii?Q?+uy6SBn9crmEZcvDYcMmVWd5GS3yLpOzHBno154SuVyTLBQp6sJrDqzoPgpB?=
 =?us-ascii?Q?NjnoVUxoa1JhwWmVI256E6sXowNl5ujRgk0dX3LqRlhfgXboaA475hLHR9t8?=
 =?us-ascii?Q?G9ikRe3yIItoKUmDEjheO2Mq/8O6mYYNpQv8oKbz5sUpNm46RnpS2CFTlArp?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6X+oaoehp5tKqCW/XgtGhYciMESX3GHgSmsgBQbMyqiEWt9+v+S6cQ5CtbpMRPFR4opkIpo0+tuA7cAlOhDlP2GPLVEsa90lyF85nubeW9B0JAJQGkUvqy3QpyHkOXT90mHG15MZyI93mVHeK6Qc08KWmNe2zekQXnlJEa3dlW4q23+uwqyxIAHnn9wamv5dApk9+kd29q88IZpZdYXYHbrE00eOXShTST88R6YQGzTKBJ2C0bRy1inqlQQlAuHN1tanRy+HgmunTHFAb6d8V78YS2YCJ98qihUce9xxzMDbUKqwIRymEVigakMargNz+GIOsm1dJK2ABUnX+oi+nOziyPd/dNdrjFstZn7j7u3phkpFqfV5Vqi7jrALwgsh0VfRs0NkrXgR52wYVZ0+fVKzSp/Vec+5gtSHpH8Ghl3aZFPbsX3cyUrDSWP86NcDYAIUViFE4kK6Mq7AyneNqsjhNh7DvPA30xe/puNisEJuILI+NiNxEwE/Gr3b1T1EYw3es+BnXp3MY7mSuYMWla6JFuyE9dSjDyZt7HXUAHKa9ypjKf0W4c1kgKdcTmlBuTzGMzTGFgsAZkqFd94kcqwtoi9YWv8dvBZ4BCr9rOaRXUEa77YVko5J8njRhTL8hmvy55CzOFzNTQBHj23qfNHTJqkYJlfLIWgJhPnqFPRekFgV9HxOh8XK8dUD2KSSX4YRTFm1bVRfzzrdrzavbKMzv8NA3FFkxFMlOrFdWI+JFNYqRMKKgEtSa/zm1f/hKzX8L7Ueei/tD6HqUnklNQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3439cb3-7485-48f4-8d37-08db2025e6f1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:56.4931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSdo5ytjV7UQxeJPbnhqfKOz3zjaGCtRSQRkqL68d4uKh2rZg5LKV+eEUjlcxdbWrER62wYcnnnN2egEdPoLOej+mH2yhYi5GoIpZDp+6PU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080190
X-Proofpoint-GUID: SyPi1FH1FqkYuUyvMLvLTyPqAx0ONQ4r
X-Proofpoint-ORIG-GUID: SyPi1FH1FqkYuUyvMLvLTyPqAx0ONQ4r
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

When an inode is removed, it may also cause the attribute fork to be
removed if it is the last attribute. This transaction gets flushed to
the log, but if the system goes down before we could inactivate the symlink,
the log recovery tries to inactivate this inode (since it is on the unlinked
list) but the verifier trips over the remote value and leaks it.

Hence we ended up with a file in this odd state on a "clean" mount.  The
"obvious" fix is to prohibit erasure of the attr fork to avoid tripping
over the verifiers when pptrs are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index beee51ad75ce..e6c4c8b52a55 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -854,7 +854,8 @@ xfs_attr_sf_removename(
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -863,7 +864,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}
-- 
2.25.1

