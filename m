Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5F3C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjDKDgx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKDgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E25172B
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJes5f001978;
        Tue, 11 Apr 2023 03:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=NoRaA7w2ijWQPdS07DPF50vtxbKfLkzVgDAYDzA1lkY=;
 b=l+hlAaXkZndC9pZflKdZAHyXWC0WmM2uKuZfVt2pqdpA2Y1AlpBaZy2lj0J2FkASpDTT
 0aN3RJt7vrUMXpYkHsyg+L7yv7nc2gB6ZFm4GWrV6vUcPiEkCh/GVGFZyZqj02nm/NaQ
 y4kP8K3WTYmht21ks1SoYqgItE6NnAb301wUSjNCq1f2CS4YwpTWsjcQijTtTsJT1nrG
 rcuLG2jGGXyxi6y1CmSTcxqUtgh7mo7Dz16l4wBGWpJTQZZEI+gO67fB9kgTWf1gJApw
 wfliwAlDH2uqpGOkFP3WNh1TmSpS89uAJ5tnnJB5IQgP53VmbMFKMznMTBnnq1x+atcK JA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc4a8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B2uVDA001761;
        Tue, 11 Apr 2023 03:36:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe69ack-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASWCuo78xMJapzkCmtcCsvMsDbVg1CaShkCyzk35x8L8zC6ZzYbyHVZKDyRcQ47Jd/spFQ+UXdlfcqT3xlWXeI5wq9LHHb2J9UNc2n+c/v58DiOy0xbOJz02gPbH/iTbHLsSiWoYO3k4R0phzs0ej3s3PvOe45OgFKKsVPZt4iVFGoz4e7Q12o358TDBY7Tew/+cu839rtN9s9r6Ts1OghUc01nfSQa2T4/6VJsKgCzVClhiZ+WeGIncG1eaaggFYLmHsoJYJqedrMzJZMF5PbOsD8Ncw49ICRwBAuhzWzvbcq3GioG55kkSYLcOTJhpAzG5/J/L9nRmwncj5R0EwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoRaA7w2ijWQPdS07DPF50vtxbKfLkzVgDAYDzA1lkY=;
 b=O/COgID3hY8S+hXZfH/oGngOlTxdjNL+G5QdHG6iMQSDy86BGw0GURzGhCrEbgXP3fumbltC/Tt3aFsapKAlvaxYrxQzu0iBt6wGj/0LuxDDb41gAyGZhCmwr6cbz08Vf1YBXPzolORAa2LPzZK77KA8/f0bJKl2A8g/G9ExOY/wiopyIM90kXUGPK+jJbtoWShcpF5AraPWIgniDmTJCNhTGw49Aj2IRpc354sAIelmlxodk/nsYJVmWaR0kbAhcE2AZLx0W4wTw/sJP0a9N3fxNM7MWRm39153WKhCwM1pwbw8LKW85IWQtAhlfwcv0zKkee68Md1WDq93lULU4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NoRaA7w2ijWQPdS07DPF50vtxbKfLkzVgDAYDzA1lkY=;
 b=LxzPPUswJB5AoUwpPJwSI65typGEqJekz6CEEpyLPb7xswMBtIai6yaQX1xCCSXMpS2/BJQgauY8WgMj1VCu57J8fHOCwsTDYH+2M2WXQ6+F78HKuawbmxUI0y7XaeWtt3MEnX/L5qMFVabk7Nz53H/41nkmA8+qBVIxUYTEiGc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 10/17] xfs: remove the di_version field from struct icdinode
Date:   Tue, 11 Apr 2023 09:05:07 +0530
Message-Id: <20230411033514.58024-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b8f7692-f1a8-4391-afb5-08db3a3df812
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCoOHSZJlpgwUGvyM4HpYuojxpZoUCZnS7OWlfj38yv/mFCyX839c6V8FGKDYCZoFfSmK+oGifzi5IWQgdfiZQInkRdKgki02639bdK0tuI5iktuaIp1Gzv5mEZrZ2CEpEbJfqkAoWWV/MzXdgraqHwmhTmnefM9xuhQ2bDJbYeM5a4b+gTFhpjqzZRw4HQhoS+VxeRW+qhqdez58fBwqHu8nTgbxm3kFY9x+mUghWTDKLF69/vda8zHMJAFBYba9wyAMrcnL3M2ZcTWIpgx3fETLkJuWFGTuO9myQjxd5OzDpFJvoJ2kniAwR+fQD/onhuhFsv1lH4mFS11Z98ruhWdhJWJc6vqOYekcPVzIKTbxySX3QxA9S6RgOFOeiXdRWwMKmadgQQEhKL8V+TU2eZYogicxRdJEKjv/6j+RKl3yepDw4G2I2CkLmfUccCx31+n+jHbISNQhhgOpi48clvx02SxGwbrJS4lw6MpyktP8fB9u2ir9qK4tcM3P50eaY2WAa51fs3fc2VsnDB4qoUrPuoFgcJe4zU2Q6X8W/wgWNvyTBvdRiJiugNLFj9x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(30864003)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oEZTkfyFMljWtR2XzeZqzqYn6vd4kbrdO6eDjUDXDi/Pwa1bDqOWImiYLF4S?=
 =?us-ascii?Q?49yHcWHqqU25mMFre85DWYc//KqJn2lAOBbvYutmlB+ZMZy4cu6bOIU9JEPo?=
 =?us-ascii?Q?dKP/NgbwbtyG3NUlMM6VrCDB7j3iBgjRD/C0NhM79FETKq9F01tUEJO6PL4A?=
 =?us-ascii?Q?dWDuFGSnoNb6QNPOtl85VucDEDCEBztjxDN1KZwSbYT4Tzjo1nRRzijgPd+L?=
 =?us-ascii?Q?oiU0P78TfoN/q08crJgFtIGcDoIA2qmcXSoZWm1makQpH3BWc44Ft/hy+hf7?=
 =?us-ascii?Q?HEb3BUAiOnzMqgdN83O7/kKKCLk+leC2EqJ2AaYlMKpA0gd/CxG5Xv+beuUr?=
 =?us-ascii?Q?fPz5aDAtZD5GvuAS1Pfui8cOJRYdUAcWN2ItaWVb5JJMUVATMPm5RqYe4q3a?=
 =?us-ascii?Q?ZJMIGq2rYK8Mz1F3dMWmojTeQi0JrWyoMwTyFXVVdv7nRNspYwXWNwlDq6vB?=
 =?us-ascii?Q?2HKHXzXVI4mCOWvi9nqJ5A6SBDLRPX0GVIDDCtarCnIkY1EJwiy+r7ypmnjJ?=
 =?us-ascii?Q?4pGzI1S8vP69iEiKyLD2MPzoChUfSNpU8HVkFdfYiFxKqxjhGXQSg+wRL33E?=
 =?us-ascii?Q?1sl8zBj3g77WQRUP5DEAvg/Ycc1dpYl9TLMCsfNDoNqHTKRRfj0ea5QpmS9c?=
 =?us-ascii?Q?F84AHpnxgF5sXojNJFYk4a0wRlLOpXyWxORGVuofdBdG3dd1UTNamp3hf1R0?=
 =?us-ascii?Q?PKDYA7CIqXknm0w9m0yh2iaasCdr/QcsI4jtGbUg+5APzpQ6uZ+5hvitu5y8?=
 =?us-ascii?Q?l4wzu9Ywc0txaWdoL2TRuGp1MhB+MUyEaL0jB6gb6azyJ2ub+83hkZPUGoS3?=
 =?us-ascii?Q?7Idke3gvqUbbMsZywatr/dkNbHXqSq3KIl/grvNS8CGpppCWmbKVRnH+qwU9?=
 =?us-ascii?Q?mfru+KR6+D1ICCm0/aD9OQSN1bZKZc07dKOGiqqKw/PywGosRVcmdUO50+0b?=
 =?us-ascii?Q?AXtpzoayy5anto4DXvIR4pxwqUuWpFZQrncJVFnLtmZlT8vxWcQfm5isRhdf?=
 =?us-ascii?Q?RdqNL0yhMqpYwNefknLdiTtQi6sK+BE0ftUdz2YUGrQp637fHpHpRYDQPFJq?=
 =?us-ascii?Q?B3bz2BhgO3JVZSUSPC0pwCc3m8BRbghg1qpEcXMhlHMHAwVU2sqm0m7KZYLN?=
 =?us-ascii?Q?YpfMdAtU1r30If1mpn6r+/a3ftYjAhYtKlBx/qszhbaDqiulT9aL9LaGj3iD?=
 =?us-ascii?Q?qTlTW9Ewt6IVoj33TPo6M+Wehtq/a2LBLIhbstjMaWN3w3UmZGy555k3wQ+P?=
 =?us-ascii?Q?k+UceGgzjGvc0ZnVmL+JkaywdJzCE8bfAeBnieK4eGJjxaoHkjBNk3eB3Y6W?=
 =?us-ascii?Q?b7SWUFOuH3/gqpYCEyuYvv7NB6lZ7hS0e2ywOB6Fffs2Hz6tgRDKSFxpRjFd?=
 =?us-ascii?Q?W5sW2532uQKLvD3STjKw9SyQL2uGBMgymH1jdy3XW+CQjXLEFDgRTGJ53UHn?=
 =?us-ascii?Q?E7oMtiH/VyV0vsD6YxCaTmMsiTak1wMmlthSg60KarSNkUWunwTOEjj+AL/J?=
 =?us-ascii?Q?C3+Jc48Wic04tGWuxCGI/VPUyVF+isCcoSAQB6b/ilHEASfyXPS439bkpow5?=
 =?us-ascii?Q?4P9/jq9RYwPg7R6b0ddsjqdInX///GqlotpXG0LNAIR7QgXJQmX+6PSKjekA?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FMMUIekJr1clDZ3jTJs7AuvbIyS/xJ3HapXIrZesQs9lIvvhqYZL9tUIQC98j2KYgjJfN5MtS5Z7ec/yP5iUNfpG+M3qnt6zjHJGcJitomssrCx0oHjO2ef3bIJOVeO3ildjS4jJpEJpGX55WBLpDogeJDvqFMkASKg+9xCZ7om96cXR2NEAcLRBwnIwnEjuD4xoOwXmxhz09vnvKSxN2ZaIoR55uaGwXFP14YbFAEBfBdTHFuxG44FvumMdQ/lrKY4FtI6H+IFbTONENJpVYlld9Oz8i2C32/nDzT3SacE1SD11cncnpTri575rszXhfwjH0Dbj8EA1ltISw2BEaPgvViawIdOKknmFIK3C1pINa5DnQ39lHubgvytkYkKaes8acOpVik/o2bFK5m72+T09f/fc7g6r1nbslGi5dLt4N+awYtsGM95gRWMvYJErn3YmS2bTccCJME2xGTQ/UFbdyPho1nFCuMxfowoe7nVvxyLLEDunSkcOJkvcTBYfQ6Opr/v0E/pQxM6yTp+nhjigczuu2v9uKl6T+2i8MbRIz+JzGtKGhcDkiecJEpbTy0XnAHAXUPadtS6RTyed/tW4K8oxhw4vzx128tL/qeJc4B/tHYNBgkTgnAxbPqUdwVqcKGBOwx3OXpGLcdZfEf48EPA4jotYHCyejMlmckKKhDC81vx8Z7oVc3OYY8WDhpfNpBEoL+wSIFQCAW68V3VY8i3RLBHS4q1dXg4MppR7z8t30W8r4hKpy8jpPyDgVTP6N4pI8oXO6iokg1jfS0l2xb2oPRaCMApESJX8TXiZ34jqhivavaGwGCA7tLDq
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8f7692-f1a8-4391-afb5-08db3a3df812
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:43.5177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2NEqwGXtY8Ti374KYUfwgVJDZ8+GCd26KFHE6cZul/91VbfH5thJoeE00/pC308h1GD1vp7Jf2N6I0kK/NS3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: 6ggIIYPb6TWdHQFm4k96zzdEJ7BC4W-N
X-Proofpoint-ORIG-GUID: 6ggIIYPb6TWdHQFm4k96zzdEJ7BC4W-N
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 6471e9c5e7a109a952be8e3e80b8d9e262af239d upstream.

We know the version is 3 if on a v5 file system.   For earlier file
systems formats we always upgrade the remaining v1 inodes to v2 and
thus only use v2 inodes.  Use the xfs_sb_version_has_large_dinode
helper to check if we deal with small or large dinodes, and thus
remove the need for the di_version field in struct icdinode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 16 ++++++----------
 fs/xfs/libxfs/xfs_inode_buf.h |  1 -
 fs/xfs/xfs_bmap_util.c        | 16 ++++++++--------
 fs/xfs/xfs_inode.c            | 16 ++--------------
 fs/xfs/xfs_inode_item.c       |  8 +++-----
 fs/xfs/xfs_ioctl.c            |  5 ++---
 fs/xfs/xfs_iops.c             |  2 +-
 fs/xfs/xfs_itable.c           |  2 +-
 fs/xfs/xfs_log_recover.c      |  2 +-
 9 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3505691a17e2..962e95dcdbff 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -194,16 +194,14 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
+	 * They will also be unconditionally written back to disk as v2 inodes.
 	 */
-	to->di_version = from->di_version;
-	if (to->di_version == 1) {
+	if (unlikely(from->di_version == 1)) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
 		to->di_projid = 0;
-		to->di_version = 2;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
@@ -241,7 +239,7 @@ xfs_inode_from_disk(
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
-	if (to->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
@@ -263,7 +261,6 @@ xfs_inode_to_disk(
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
 
-	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
 	to->di_gid = cpu_to_be32(i_gid_read(inode));
@@ -292,7 +289,8 @@ xfs_inode_to_disk(
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
 
-	if (from->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
@@ -304,6 +302,7 @@ xfs_inode_to_disk(
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
 }
@@ -623,7 +622,6 @@ xfs_iread(
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
 		VFS_I(ip)->i_generation = prandom_u32();
-		ip->i_d.di_version = 3;
 		return 0;
 	}
 
@@ -665,7 +663,6 @@ xfs_iread(
 		 * Partial initialisation of the in-core inode. Just the bits
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
-		ip->i_d.di_version = dip->di_version;
 		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
@@ -679,7 +676,6 @@ xfs_iread(
 		VFS_I(ip)->i_mode = 0;
 	}
 
-	ASSERT(ip->i_d.di_version >= 2);
 	ip->i_delayed_blks = 0;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index f1b73ecb1d82..80b574579a21 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
 	uint32_t	di_projid;	/* owner's project id */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5eab15dde4e6..2462dabb5ab8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1624,12 +1624,12 @@ xfs_swap_extent_forks(
 	 * event of a crash. Set the owner change log flags now and leave the
 	 * bmbt scan as the last step.
 	 */
-	if (ip->i_d.di_version == 3 &&
-	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
-		(*target_log_flags) |= XFS_ILOG_DOWNER;
-	if (tip->i_d.di_version == 3 &&
-	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
-		(*src_log_flags) |= XFS_ILOG_DOWNER;
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+			(*target_log_flags) |= XFS_ILOG_DOWNER;
+		if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+			(*src_log_flags) |= XFS_ILOG_DOWNER;
+	}
 
 	/*
 	 * Swap the data forks of the inodes
@@ -1664,7 +1664,7 @@ xfs_swap_extent_forks(
 		(*src_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(ip->i_d.di_version < 3 ||
+		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
 		       (*src_log_flags & XFS_ILOG_DOWNER));
 		(*src_log_flags) |= XFS_ILOG_DBROOT;
 		break;
@@ -1676,7 +1676,7 @@ xfs_swap_extent_forks(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		(*target_log_flags) |= XFS_ILOG_DBROOT;
-		ASSERT(tip->i_d.di_version < 3 ||
+		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
 		       (*target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cb44bdf1c22e..6bc565c186ca 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -795,15 +795,6 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-
-	/*
-	 * We always convert v1 inodes to v2 now - we only support filesystems
-	 * with >= v2 inode capability, so there is no reason for ever leaving
-	 * an inode in v1 format.
-	 */
-	if (ip->i_d.di_version == 1)
-		ip->i_d.di_version = 2;
-
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
 	inode->i_uid = current_fsuid();
@@ -841,7 +832,7 @@ xfs_ialloc(
 	ip->i_d.di_dmstate = 0;
 	ip->i_d.di_flags = 0;
 
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
@@ -849,7 +840,6 @@ xfs_ialloc(
 		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
 	}
 
-
 	flags = XFS_ILOG_CORE;
 	switch (mode & S_IFMT) {
 	case S_IFIFO:
@@ -1110,7 +1100,6 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT(ip->i_d.di_version > 1);
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
@@ -3822,7 +3811,6 @@ xfs_iflush_int(
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip != NULL && iip->ili_fields != 0);
-	ASSERT(ip->i_d.di_version > 1);
 
 	/* set *dip = inode's place in the buffer */
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
@@ -3883,7 +3871,7 @@ xfs_iflush_int(
 	 * backwards compatibility with old kernels that predate logging all
 	 * inode changes.
 	 */
-	if (ip->i_d.di_version < 3)
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 		ip->i_d.di_flushiter++;
 
 	/* Check the inline fork data before we write out. */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 2f9954555597..83bf96b6cf5d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -305,8 +305,6 @@ xfs_inode_to_log_dinode(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = XFS_DINODE_MAGIC;
-
-	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = i_uid_read(inode);
 	to->di_gid = i_gid_read(inode);
@@ -339,7 +337,8 @@ xfs_inode_to_log_dinode(
 	/* log a dummy value to ensure log structure is fully initialised */
 	to->di_next_unlinked = NULLAGINO;
 
-	if (from->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
@@ -351,6 +350,7 @@ xfs_inode_to_log_dinode(
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_version = 2;
 		to->di_flushiter = from->di_flushiter;
 	}
 }
@@ -395,8 +395,6 @@ xfs_inode_item_format(
 	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_inode_log_format *ilf;
 
-	ASSERT(ip->i_d.di_version > 1);
-
 	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
 	ilf->ilf_type = XFS_LI_INODE;
 	ilf->ilf_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 597190134aba..e7356e527260 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1299,7 +1299,7 @@ xfs_ioctl_setattr_xflags(
 
 	/* diflags2 only valid for v3 inodes. */
 	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-	if (di_flags2 && ip->i_d.di_version < 3)
+	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
 		return -EINVAL;
 
 	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
@@ -1638,7 +1638,6 @@ xfs_ioctl_setattr(
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
-		ASSERT(ip->i_d.di_version > 1);
 		ip->i_d.di_projid = fa->fsx_projid;
 	}
 
@@ -1651,7 +1650,7 @@ xfs_ioctl_setattr(
 		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_d.di_extsize = 0;
-	if (ip->i_d.di_version == 3 &&
+	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
 		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
 				mp->m_sb.sb_blocklog;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 757f6f898e85..a7efc8896e5e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -517,7 +517,7 @@ xfs_vn_getattr(
 	stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
 
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
 			stat->btime.tv_sec = ip->i_d.di_crtime.t_sec;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 1c683a01e465..42e93779374c 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -110,7 +110,7 @@ xfs_bulkstat_one_int(
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
-	if (dic->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
 			buf->bs_cowextsize_blks = dic->di_cowextsize;
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 884e0c6689bf..84f6c8628db5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2879,8 +2879,8 @@ xfs_recover_inode_owner_change(
 		return -ENOMEM;
 
 	/* instantiate the inode */
+	ASSERT(dip->di_version >= 3);
 	xfs_inode_from_disk(ip, dip);
-	ASSERT(ip->i_d.di_version >= 3);
 
 	error = xfs_iformat_fork(ip, dip);
 	if (error)
-- 
2.39.1

