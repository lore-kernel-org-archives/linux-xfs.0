Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC017C678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCHWjL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCHWjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:39:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B22E29429
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:39:08 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JwkmR018336
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=31bDCUHnTjGX+o3xxPHsVWfh3Ak6A1k/Sp9WFrcda4Y=;
 b=tDAf/bWtr3XcrTfn5UKkPam4G9bFxjTPl450PosI0ZNwratri11bCIopZEIZw6rnBwWj
 69BdFfA2xjAfzT0Lf8qM42QyfgzFil2Iz+F6+0/Ht5Rms3KuhQBayF5cGn+qwkgRp767
 L9y07DmLI+k2o0n70sMrFeX8l1kPTUyzug2sIx+nvBVTnqVvvjKtAEn2DVZZoTjinRf8
 7ttSvEpdN+t4LQWzo8UeJo8C6Qq1mgx5j20KLFSNZHou1jWXlBsAfh21Z51csYc1IDXR
 XfscAEerhtRw3BE6wKlnM4b/ETk8x86XSjywLGWXPNmztz42M5kohhZNsqyJDg6L/9Tc ZA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417chcye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:39:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328Lt6qG036616
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464wsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJXYzpLWRbzQBdH1RhMqDu6dOjvO9IJVs4VAP9ZwG9MU+6IvPW20s7qIc8Gmg6f0evMhY9/QiZbS+HFEqUKXW+GSchGrrQ9e64lNW6BVacIEWSpFHe2GIflxG5frZ+YlfaDoUwZTowvOWNw55u1pGF332Sl4rPlDym3He8Z/Qmh8B2Ei0ZzhX3WgBvM7cBtK3+4Co+2YN/C+UqWE+KfjER4VcPMit5jy/XIuv3WTuMNisbIkYuDMsVAdoMfFlZDyXXS+YUhZ4GucwQmQG/pb/EXsAg+vWn4KHZhe2ud+MaZFOuoM5wQqvdSzoAia6efkKOLK9KE2q1YTU41Zrj+/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31bDCUHnTjGX+o3xxPHsVWfh3Ak6A1k/Sp9WFrcda4Y=;
 b=QKvrvWnsZNuQRMdbwODJVgCX8Q+uEL7Nr1qZ+wmTnI9erJ/7ZzE/bepCrdoVLOrt2LX84dme2zwdcBf0P0SCUy2L8GHVXEzb4SY1GsQONmzwzKpNq+MloH9No/+sSIaidXewx67GxXHPGmbpLiZt3cQvKSlYPyl1KKAdglV1vhMVd4ioURJw941IwVgyRNUO+6fFQeHnlFpsPpQEVoAtmbnAJoapi3th86J09MsnvlNi5cWVKJ6nfzIcTl/KJ9QXNkdwyjTEIzuJDt3SydIIPmU0FaHr/qcTgKeBRBktpuQrcusDfjBWxG1D1OzmY68SUfRoe4GTE9ADDG83DfvHLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31bDCUHnTjGX+o3xxPHsVWfh3Ak6A1k/Sp9WFrcda4Y=;
 b=nvVEjddEtbvNpQVsh39zsVeRpy+dyKxIRyQtwrJZT//wvXh7APQTqWIagUKZAcejG7sh66PX3I1qlLk8k3KEyP5+qosq8U2u39HEu4UwBv4IoQr4dWP3tviXc1m3sD/h6Lt5KjAksAIUVbSlkmQ0B8gaFLlCzzNOSex9S7Mzn9Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 22:38:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:54 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 31/32] xfs: directory lookups should return diroffsets too
Date:   Wed,  8 Mar 2023 15:37:53 -0700
Message-Id: <20230308223754.1455051-32-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:510:23c::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BY5PR10MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf2f96c-a3e8-42cf-04f6-08db2025e5c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVingXgcULB+W/Bjkv8msdZqjp5epjr4iGrnleb9N/Hu58TK5HE1COC9pzKex7k1F0jwEFR8NGhQLYQ6cvPGxP79kOg/V5BEsmlMnblmHqLB78jM31rrQuA9BuQVDe+CVT4hivxXdySvsup7cdsJ3kB8Fgwl36tAgm1Z9mT5hNbavNwrgkKrt2kmjrSNExlt3a9JnVFTx44RZlSHmsrX4Rk97nH7XWvJC8WNbttKq8MZt0tjNN4pEHLrehZpYDK5/O6M8P+dD+tfBsEkhN+3P6LsJKM1yvmoaqANF6ahAMpWWkTAl3EZzmrmvaGTNw/Xc5ZG/GflLPU3omLgOzKw0KD4sh0t9XuQV2xAcMlMUqYVHNCA3ZY/yTBzSNm6mN3qS3cD/xgkGEn4y1xoH8Je7OQeHdI2LqkYIUS1KtzRC5C6ISujUQpn+Fu23whT4+FDhL10SWOd7RlWSTuXcUwbJvbucxclI/kZZ/QW+OCiessQqchsPy3PySg2BMntHE/D+wXY5FMa1V8UEhwN7TBPwljTnkE6mvmKr9DAidubBjHlc8lFF+sKJy9Ov55plkUanVQ7zJYA33ho5hqB4ni9QcDhKXuvSIyT6+pVd0ccETukMBHrjioW9sTmQD6njG8t+bbYWGZCo1csf8UyoqljwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(5660300002)(8936002)(8676002)(66946007)(66556008)(86362001)(66476007)(36756003)(478600001)(83380400001)(316002)(41300700001)(6486002)(6916009)(2906002)(186003)(38100700002)(6512007)(26005)(9686003)(6506007)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jrh26x4fpNaxKfrz0mZKWVVDhbsQYJ6YQ+IeOlAv5fVUpWlVCzavk5r9J020?=
 =?us-ascii?Q?3AhDBTqJkcWY1lsc7UuvXFz7hxT0vRwQNYcof0dHcPkT5haxPnbZSY6VifZv?=
 =?us-ascii?Q?nNQX2l5E5EXKoilXBZKEnHpbbJUqSH28h0zUxBRch0h2YHy4HhzxkPXK+vJE?=
 =?us-ascii?Q?rs5AqZExpL4vzzsa5NcvQszMWE85lvv7bWk2itvoMKoBUFFJMTB3aez4im43?=
 =?us-ascii?Q?OnsCUr1exYgz1ZX/bsMz5Apr3aXKcNRc+cIIzYasx42jdZbsQ6r7T4X+ykVH?=
 =?us-ascii?Q?s2tS2Tf6WScylgq6OcfM9NOQ6QPX88gquVZiKu7UUBNjpdT5mjCpVACqssYv?=
 =?us-ascii?Q?VWym6lcezAOkk97k5W1Ro1wPWg0VwceH0OrYqdqN/IBC1Yg0UrX7420sLF7X?=
 =?us-ascii?Q?SjrP7IvZ3FfZKUQFasoBRF3gV2OFh57cdBQknTA1YRjCKLZubPasI9IOS1l3?=
 =?us-ascii?Q?ts2lYIyy6XVKQDt3n9VCtWisW82Yfdown82miBqv0e8q5i7+Vvf4YiINJa66?=
 =?us-ascii?Q?h0YueEsG0UpkQroRzhElm7RQSXpI39vCLycgth+Y761c3BP0X7xpTfcqPk1f?=
 =?us-ascii?Q?AoEHiP4UHYTIUqHNNG/D0aa6rMnNLnA8w99MPzi4uwJpDHM6CzUc7+0WAYc4?=
 =?us-ascii?Q?UT+QmIIFcZMF6Z5rz46YUZnOiid5wJqP3QJh2clTlPWx5psAU6Ua3zirXkgz?=
 =?us-ascii?Q?ah1ZLEh+NYei6aWipAdoVKSWsJ+FHXFoU3fApg700Qfz7BxkfMX8+15v/Jq3?=
 =?us-ascii?Q?RZ/y3teNuuAYeZFvMviV3LXIH4kyzAgChCLwtJKuDnjDvNI/IwqTqRGvTQTc?=
 =?us-ascii?Q?/KggtkCNgLzLbzOj4GkkDUpI4QwDcqaBMpLODiy8MywNufSVBTBzH8ADQWmK?=
 =?us-ascii?Q?othsNfqDT9r9j9c7UwJsipmahGJXT8jsEx36IPHC7ZFjiV7lDTb0elKns/0D?=
 =?us-ascii?Q?6uUvxjQIAs6qlkaIEBgKP1GX9/89hbW3nRVEBF2a4xS3WugLaXddVSYfrZwC?=
 =?us-ascii?Q?+rCv85fMzmacZLP8sNQnwaddZS2msfPiTIefZ5m1Cx7ldmjYWZgY6yc3cIkI?=
 =?us-ascii?Q?A7/2Qw4zb/cwUuAeqjkdLo2YPU37QsHp2sKfX6IedIfBDQTNqJNq+1dbbcbQ?=
 =?us-ascii?Q?2zqwHZ43prNsQ3OZqaiPGaA0HlazmA0KbkvWsaCaWHPRHzyfOLWOvJAbDusY?=
 =?us-ascii?Q?jzg/WbYRVz7lyzSPibzixL40sxLfzKONTsM6Es8guqFqLMn/+8cw04Z1ghP0?=
 =?us-ascii?Q?guBQr4YGS5sNg7J8qJOmp+3oh3PRymUharjge/7HM60oxALS7m0zop/Ew+Oz?=
 =?us-ascii?Q?y7aMzc4ZkyDRER83B22LvEa1F9y/FsKFbYhMc5e287pxU7KxTnaddeNWU8Xy?=
 =?us-ascii?Q?n98jUzcZ/1fSHqtDBg/Jh5VrkUBcA66nfCO9r3UnEnpsiaa7ODW1phk8qalD?=
 =?us-ascii?Q?5eGGdHY4GHjN3McDnS1qTSgjXHQCNPPpnKYgLSol/2d/2cisyBA9KtQJOx/M?=
 =?us-ascii?Q?gSojexWRjTr7B8yml+zTkxNJ24Id5JD1le5koerig7DkjTpqKU7giYtNTFbs?=
 =?us-ascii?Q?emS2eWzvYzI5IIj1bSwvN6At1olW9hLEvl6qCd6XN427gPGPScFYV1OWQc3n?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dHVQB4jXUXh39hdkqS6gHxdtsByAkL/yKBQJi+OTXr0oiACxb6Qj1DmHJJOTQtgY0ABiLHiBWUj/FCL7cRwVSl2HwZG0HzLRWrrUuG0GQuwkvdiv7mlnv9lkX0kImwcKVo5DApFffKDMyn0f1lha8jvlDHUiCs05EzqR04k0OEL+FXE/mAp8WqckaGX4EMd0oGjhvWNNhMXykKrVpHn4KO7uHtilyEsMoFNQN6QimpLwxhEtxsSDW5e8PMDDuJGqJhTyC0NNH82K59/ShFKh5U9Dfs03pPC1msSMqFIPA5ardKRJnCBEH+XKBJ8ndpzAYdMNlzvr9f1bcFsNEO28y91inU4CmHFj4STqmevPHSRqFWDqbsy5pdGJYbQGpL7hfqkWNcdCk5Lw1RrhdpRPKIkp5y7O1QlMQM/fMVHnHjr1gtr1ZkMHY/+ADeeqixz8KTeSyuYJWopPTbmCzTcnket6IQeXbQymX/2w2PuID2MrHt8Z+Ae0DB8G3YePiWq4r06WLPtxF0+nEF0I30/MmBRI1ECLIRs/ChKXCSrsK/NZ44H2uT/FUrroFnYng7n6IKM9bP0R1moAiWalwFuDhiUVPiGIIQ/q9ffsD21EgXqENNpJNkfadKiqHumZfMGi0mgk/OwbxIxhKYZDHGIuozY7ifarQNKK6mXM7/KqtfRzhprt2Xn4eiCBFnD+14biuf20UBtCMTR8Dmwm60wzR65gvkOgdS8tDzFTHHTLVwPIxm8BTKYy1H7zL2+uOlZI8SwYc1LuCTJnvbeCZ6sfqA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf2f96c-a3e8-42cf-04f6-08db2025e5c5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:54.5392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfyPXhLtGjiLqtZlxy9y/WGJxr3QKS9JqkDXz8bXh+8WRnM21JJzF+BenwGgv4w9q/7XFREVDv+E3LKKE+6zXkVFp7lnC1LHOKB5EDx7k38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: RgONXPrfPN5yvEgytv2oJ4qYlEHCV0xq
X-Proofpoint-ORIG-GUID: RgONXPrfPN5yvEgytv2oJ4qYlEHCV0xq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch is part of the ofsck specific additions for pptrs

Teach the directory lookup functions to return the dir offset of the
dirent that it finds.  Online fsck will use this when checking and
repairing filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 2 ++
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 4 ++++
 4 files changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 0f3a03e87278..24467e1a0d6f 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -749,6 +749,8 @@ xfs_dir2_block_lookup_int(
 		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
+			args->offset = xfs_dir2_byte_to_dataptr(
+					(char *)dep - (char *)hdr);
 			*bpp = bp;
 			*entno = mid;
 			if (cmp == XFS_CMP_EXACT)
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index fe75ffadace9..b7ea73b4f592 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1300,6 +1300,8 @@ xfs_dir2_leaf_lookup_int(
 		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
+			args->offset = xfs_dir2_db_off_to_dataptr(args->geo,
+					newdb, (char *)dep - (char *)dbp->b_addr);
 			*indexp = index;
 			/* case exact match: return the current buffer. */
 			if (cmp == XFS_CMP_EXACT) {
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 53cd0d5d94f7..f8c01e8d885c 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -887,6 +887,8 @@ xfs_dir2_leafn_lookup_for_entry(
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
 			args->filetype = xfs_dir2_data_get_ftype(mp, dep);
+			args->offset = xfs_dir2_db_off_to_dataptr(args->geo,
++					newdb, (char *)dep - (char *)curbp->b_addr);
 			*indexp = index;
 			state->extravalid = 1;
 			state->extrablk.bp = curbp;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 032c65804610..f8670c56c7a6 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -889,6 +889,7 @@ xfs_dir2_sf_lookup(
 		args->inumber = dp->i_ino;
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
+		args->offset = 1;
 		return -EEXIST;
 	}
 	/*
@@ -899,6 +900,7 @@ xfs_dir2_sf_lookup(
 		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
+		args->offset = 2;
 		return -EEXIST;
 	}
 	/*
@@ -917,6 +919,8 @@ xfs_dir2_sf_lookup(
 			args->cmpresult = cmp;
 			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
 			args->filetype = xfs_dir2_sf_get_ftype(mp, sfep);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			if (cmp == XFS_CMP_EXACT)
 				return -EEXIST;
 			ci_sfep = sfep;
-- 
2.25.1

