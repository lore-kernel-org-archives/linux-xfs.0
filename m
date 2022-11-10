Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB35C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiKJVFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKJVFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E2D7679
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:51 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL32KR003559
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=LY2usPrVONXyKe6jy28eJcjMv4eVCJzM3cZMl+XrCjU=;
 b=l1Wc4V6ThUX9VUdTu4JR3aX0Qrl1K6+gJIaLuu8JBSYKbELmuGCa8xDGlDxwDre4Rn4o
 wPmTunPJ0TYPxwoB4yIF17yyN98JFXzCrYKLs/flhW5hJteHaaJuN1Vf22LR/0y/qll2
 J2XhliJ3cT6KH+3IGgCagecz52tLrAtSuO1WhSgzZyaiMuiXErIv2F1GTWhQ5ycgKpRY
 a2NAlflR5bM9QH4WlgVBj4fcrlZjk0v+qyWDTSglJc29yNiTOhMOFP/RzJFWIOJxQ7wH
 rail9c+OBb7YdBmxVLRctQjr81dePAds/sA0ifyoGkNp9KVPeuaqh9bLSYhYcmnyw6dk ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vcg09a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKaOfP038098
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4fmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jggBOXsM6fDN8a0u2qhXSDk0Fp7tG7uWn+QDSRqFLmkGbKvzie0q9vEBH9lFDOyqo6DXY66XL6Lu3cxolp3faR4ttgOvZLabpB0FoacHvbSFISVEchwa67m2FPPgr2SOTHP0Q4WEah1UXN/KeSKIOAkcwlZJfbGEMW9p6nXHwOLsYSjibmdhHEhw9s7gnP0MOmN19vVZnF7ZesWgO6f4Z2m9XgbABLc1I7ARYpkl1x+R80g8qrxcbyNU+HrDhy5kvdstFRlH76odjifoYQESlIwFzNrW9rzD58+8vy500fr8MjO5d1oGKgQbnBu9wyO9nYFIVLcjYfrMd5Uz0YnPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LY2usPrVONXyKe6jy28eJcjMv4eVCJzM3cZMl+XrCjU=;
 b=ij4iGpBq0phO330FpfGkjXuZHzCk59hvtaZf6WH/rW84tU4fZS6tfTpw1KlskBnkjrCtRiiRs1YRftsJaVRtQkaOREy3b9V4RbSlQ5wryWppwx0FuF2LHhpDuAblH4DjhCpPYDq+0L6RQ8SC7P42DcXxdKHn8J/Pq/U/8KyRG1har+xIIJKtXqfOucyWbuBA1aGPBxzwtRFX3s5LPZxrXySViRu/qK8f7sGFc19CAYXKtn2+wRThjfTQx8Lp2D3V9MeU5m7W6KB7zmw9zPBdubTjHPCbQI4QkHt4Cc72ImUzjSF+HDlyKONrta97npPcKWBexUN8uccekB4pIzQOtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LY2usPrVONXyKe6jy28eJcjMv4eVCJzM3cZMl+XrCjU=;
 b=cHETvDU6wx0OMbKDskmhTKkRJ9jeZ9ZZwBMGR8lDhXlwXeYBewaQG781YrkBomjBRx/WfznXfP7Uc5Vm0f3+OI4PtS4IqzxKCe0aJ8jnTULxJLTP0FaJutT+PBX51uOkPtny2Rgv7wJtKgLSeg3ehKQmAupbXwhjO9UtXffYQqk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:05:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:48 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 13/25] xfsprogs: add parent attributes to symlink
Date:   Thu, 10 Nov 2022 14:05:15 -0700
Message-Id: <20221110210527.56628-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:a03:255::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c21b16c-c146-4f51-af10-08dac35f5753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjGkYSGg17/a+6iPKxq8Tqnc4g/oh8K3cBjTMB5v+NEu683+oVBOu7EQ+Nmmyb/Wjvco23YG+prRsuCT0TmprzpojGQ55AWQiQAx9PEo+PcR9CY/qIyPjYD/h9CV9kvxTEqj9zuo2EXTEFKsLBNnDR/7a37EFO23YCaR/sw1WNnhwJDrk9Mn69nqpmcDnNptO/pRK8gnbPBe26Ghun/ha0JNd5wqF4r9ZRiLzUVtFOBkyFz8liWPq6TByM4ftu5sPf0EeyJfS8m7APaRX5yrqFf39gQM7hXTenFrUKTYUI7OfJp491FUAO357UBJgqcu8ZtxDdW9igC1j9j5BvMAr3cCvjdJPpFuOH3EUc4Aff4f12rLsf5/LuodYDQemIAS25bAZNoX93fNjWnDHHHV97bUtvNWG+Gwhgb3yZGIvUXd/Mtqz4iZUFz/ZTtLwS2CQaAhzt5gPX2fq8lBDapVaxnfrhpkqatLDDaeyb51Hwfq2Vel6nbPOzW4U7FN/0D3wOO/VayKB2v5dORfd9dmWa2E8pPT8anEDIcMwm9RUMsMoRZ+RBJiV4g/odEeRm2yim0I3sg4xIsKYBC/OF+pBlInkIRfpgSOCZqRx7gw7hUM+b8iZfX++CBwki/CNGGY25POBNXyHNemNs3xviGGuSV268iUGPkDsoalRk0G29n4FoBLpQeg0Nl6l7BVbO8N6hvaKw57OaGTYtYLzz0crw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(4744005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hAFba3mdhhg8uerPt/BiO3LEVhNd0yaGfKzP3U33egNtE17y4Q4Dkm4x3AUZ?=
 =?us-ascii?Q?K/w3GrW9rvWml+6PqC7GVOzMOACFbD2rg//grK5QLa+VJKarA+CNf21ByD9/?=
 =?us-ascii?Q?YO9T8NCT803mPHf5kEeQBnM5xUth9/H8NEeeZJj9WC6/TAjhiu0bSke7JuXL?=
 =?us-ascii?Q?3I4sXlt52HUjuOfew0c9FJnk9pPcxNtdM2hCoW4aiek6jVmm3dGtAhfwhDQS?=
 =?us-ascii?Q?/QNhtPY6g1DI18p3EbxgmoElA2awsFohmJeN5VN+tFHLcCMMB356z2ahDupU?=
 =?us-ascii?Q?l0C+Ukk/3FKlnUYa+qN5K/53j44te9rgDyzx0DfXAmmT5j4gSrziFDdWLP7p?=
 =?us-ascii?Q?Kdop0u5ytr9vNeZFSCBZUSn+HkoAN5JTNlmH3UKd/4rnROaPoG+TZde+s5Q6?=
 =?us-ascii?Q?M9tprSKq/zeJLSg3LR7rJJZzpmTgaxroxSAfanLs2yfXNItBKdo4S1ThOVv4?=
 =?us-ascii?Q?QrH3x8jxeXlwuJnq8JE4pJN7j6YnS+oRfb/2MJJP3BJlpdvIRs5Fm574WwAe?=
 =?us-ascii?Q?7MOG20HVh6/KTL4RyFMof6nfs1qGYOSmuIjuwNY3jyOWUnFk4512HTLDKple?=
 =?us-ascii?Q?KNH5VvRag5sR38PnVk5DPTUf8QE8vtpOJynhBHgni6rwN+VmX8CiVdmkqryo?=
 =?us-ascii?Q?ibCzJT66kddRhOkXX1L9H/T1xX9H3FBks06pzHWmIA+YJid42tfi4evhfWZB?=
 =?us-ascii?Q?yCaCIpotXs2QUFGU2S2IaQNZUtzw/10L8+D7zGqHpF5rplKP0VxN2fJtdLv4?=
 =?us-ascii?Q?VxeNVR4KxO0ZnQQ9vtiXRf7MoQ/anpUgizmzqGQLkJ+t1sTdiJeuWYdXOpoz?=
 =?us-ascii?Q?QdtM4JytEfdQAd8E2F+wqML3eq2fITEu0wrAHF/E96BQihLHIjWFImkUvUBP?=
 =?us-ascii?Q?PkX2e1YbAlc2GaZP8HaO7fzmrR9oROA6+GkjflNsZYFxfYLNRp7sca3R0Stj?=
 =?us-ascii?Q?LpqRIHCEYSRmiqjJf4Rv6c+NeZnegVaK4C+pJSzy09K78kqL50jjLcHW020b?=
 =?us-ascii?Q?4pp3B7K2znRltKhh+f3psrLS0Ml2HaHTVLwasZH74cAvpHFq/epgotSv8p/n?=
 =?us-ascii?Q?WnqmXO5NGQ87OYLqfFMDPUXBdNrOICHXP4Z6qzaqAds5iDkOdV4TxwMtq/qM?=
 =?us-ascii?Q?zr7uke4pV0hbkjHJpQI7fI87l6nBjxe+6XhMJdC1FiV0CtuAxrc/tfdS/qC2?=
 =?us-ascii?Q?1V2pgtxE7w8RMx6A/aU2U7YUMNoZqR+B66rsgqWvmK1AZKuU6TLwSSjgd7UH?=
 =?us-ascii?Q?6eO8Fmb9RTOI7uAPVMlK61XCv9sIp/ez4M1EDhith4NUWubgFBMNBQ6O9XcC?=
 =?us-ascii?Q?KJEahJ5zPXu59gvQS92yitwkBy0RvgUaC/BC+WOksqgaFmzkrnIPhSu6GIf3?=
 =?us-ascii?Q?6d3ewyBacM0WBXVSL3wGubPY0eNCsTeU6nY6l5Zc7fcaj+22XCMMlBws7tf9?=
 =?us-ascii?Q?G9KaDgfhph/22xk5dB7qYloeiszjPPDMMn5DPHQlR5qAy36QE9KRBqJZ66Ql?=
 =?us-ascii?Q?fXxtQMSgf++qYdPm6gbUQk5PypwneOM2slQezHis+/xFl+FLtFNtkd/ZqFZa?=
 =?us-ascii?Q?dc4MiPOcVZxPCw6/yr4/fccxamQDpBvC9ncbAjJDefPbgZLBRHVkonjKL9PD?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c21b16c-c146-4f51-af10-08dac35f5753
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:48.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plOxcpBmzecSYRJ2Ur4gleDV/kFaSSIanxt5hEM1Tfv9GIKHlToyWv4nLSrE27imHBwKAmQqL1doPiZNTzEvnAsfpsRkMg4wAG4er6z2tW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: C42btKS6_5mTduYBMWwYrsRmhNY9Th77
X-Proofpoint-ORIG-GUID: C42btKS6_5mTduYBMWwYrsRmhNY9Th77
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_trans_space.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index f72207923ec2..25a55650baf4 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
-- 
2.25.1

