Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5440CCE7B1F
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjI2JzE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjI2JzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:55:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457F21A4
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK8wVk013176;
        Fri, 29 Sep 2023 09:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=0EXGAwtJi+K8NzvaNF8jSTvf7tBf9mrTNKhAfRmctNU=;
 b=vrR+pKBEusQWYrhtgSREVzJ7sSdbtmubUbU0Jms/0D7xGkk0ZVN8NebwwprBCLDp1UN/
 wm8ZuZsKHJxkvifhv0CRDOMudTJjICRWsGzhSXdk27cXmYzp/6H+4CJ369yiEveWZIgB
 TEI0KBazOIhC3l2OSdU7DkQ3hZTboyJ+GlCDC47dQTFimdJjL1QzvJFwE723i86Inlhq
 yGhBfmvk2+jCACdHIxifIH3aSaRFJ2AqN6DVLP6MJ+mrQoUivr0BRAmpeMLCOq5H2UuV
 QqqyPPSwl0JRwU8EZxE+LsTNcN70R9DXrfmklLYc/PCMvSkqKugSdGxOxKPHPXWMnzyM sA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qmupceh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T80Vob008498;
        Fri, 29 Sep 2023 09:54:25 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfb6wvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cD7HBm+eT/fSUTV1l6aUVdWlfryTUvcuqgUCfelu1PFUhioha+hFVwKOsK7hbcCA3ZygrxuYDX82FfPGVNmSLvfan8+OZAyGrvPaBcn62RAFuyqEqZFNOY3z3jC8rw5RHYK0+rkYhrcXcD6K+w0cHxlmTay535yUsNTrYPv99ziRS1iLCZiNmI5zbhJYfAlxn0NE+4St+7WoU7t9iWHcWb88wZIiooEygvO9yfbMIOZ+SOWklNjSpsZo/47Rhe8e3XoAZUaEJawm73SlOiSYd47hr2mT7XTCuMarSzuqhzNhD1nfKF04KUSLz5y3DBR/BUvfUnqexOb1OxFpHy5LUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EXGAwtJi+K8NzvaNF8jSTvf7tBf9mrTNKhAfRmctNU=;
 b=LASvJsdj2AQtwQaqrfzepMJdelPOaQD5+Lic0oBJkbDR4WJci6Inv5eNTBfeN10cQoQi0n5Pa/5rhlEdvLocYBireXUhCqtYjfCRo40Ys1jdmgLZjdVrazMZ2ObWeQU50r7qDrmzI31sY1XG2ZqTbqXt8Q9cB5Wq1b8eJSy7XVWbFiVhK3P1wiNz3blexmZHNE0YPEWTScSVh+O5oquOgTdwZVXuyNd9x02YlNgBxBIq5lgqqP9zXyMsPlwEnHmeJBWBycfgbU0NmgDWm7JogDlzmKiqND7Fls3rIoIG4FtLx33ICF57LclMjM6i0yKarcDfZeolHtb0c4/bB7suSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EXGAwtJi+K8NzvaNF8jSTvf7tBf9mrTNKhAfRmctNU=;
 b=t5DfyOBm2dyr4RSLCleYsUiqF19pkZmL1uPGyKZMpEOLeC9w678UcpcIlAVr3clZU4wBMGOJgjj08Y7TDGnmbZ7RLEC/omQ3jEInoXog3JWGb6KWjEdwMusUJCZe4U4XZ0hHbIaStaxkzXtvs84Ja4Iyf7onMFtn6IiQ4ir6Q5c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:23 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 7/7] mkfs: enable the new force-align feature
Date:   Fri, 29 Sep 2023 09:53:42 +0000
Message-Id: <20230929095342.2976587-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230929095342.2976587-1-john.g.garry@oracle.com>
References: <20230929095342.2976587-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:510:4::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: 511b04bf-c3dc-4e65-93bf-08dbc0d20f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1litEo6m7xnZkQ/Wfg47XGaJob5vgz7H5tWROu0xdb7W5dSp6SZ2/uGUT1YGMtUXnJFysz34C4CwUOrTlzaRVwKiNWo4T4TCqZrAIFCwq0em1Zm74e/MtTCXAGhtiuzghkmOFUl9u5oLNRMw72NJN4LSL1qk3xKI2qn+fuhb0smmwXgRk3MnXjeMFFurdsVuSqqqZmxK2RF2uQESstiaNyvRH8y7Z71SiDoCEJhEJzj9XDJLNkJn55YBGm/ooscOj8Xph01Rk+J7spgvOJDMN3+mo/y0qljQsSxU1m1Hy8CvnhHTBU8i66hGRogHULuWJH2SrV2y/TgP+uPdrElq/GxB4f93TwE1rn80qc6LMYyZSoud/oV1603Jb+o/rjfiBOke1g6DswNV4hqA52qcQ307NlxNQE5Kjw1BeFLgb3Yy4HCfJ767gnYPGlpxta5C9UWCerY7GBQI4mtlPMPp9Lq3R6irEeUKuIBOZdwisQT/HmOd2JcLCmRJKdz+tp8G/PZSPUm7yOVFnBBaP5di9W8bcGkMkDFDXN6EWY0IqPqKKW/5IL/qfTdPbwyXrgiOC6mZqs836pWlC8C+jcLmrZdCY2v2V7IiudSG5/bBio=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(103116003)(2906002)(6486002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rvMMr0yzmDrcUBfHif68JxJokxBXekzAians4Rf4pZrpL2BV6+DTypmBiqUy?=
 =?us-ascii?Q?Gbf/szVfk76AXvfcszaBw4mAbKx9/x0N6MBgpSE0F7BbrMvp41Ie46CBMd9y?=
 =?us-ascii?Q?kkwsOyxvc0qNvKDvU2grJJ0x8NBrwGnKCHEX8H3X2knRHypnXcn1RZIZxPE+?=
 =?us-ascii?Q?FD0D3Mq1Ym3WjQNJjW0suH/fpx+uS/XIj4SohqQk+tT5Iv4FrF2wP3pqfaSF?=
 =?us-ascii?Q?pUOd5C0jUBHn489ewUY0puBAGPVilgyrgUUllpy2mSF0TpjpSeRzOIf/MGAV?=
 =?us-ascii?Q?LWqDA7URCK/x/8dDcjpjZD8H/U0kD3oBuvBjDKehnyM1O73v6DG1nSebTya1?=
 =?us-ascii?Q?0AbeG5gYllCf9ECbgT6DK59bWVg5tzu9DCk+TPUHAazUX0DoTlNt8Odz7LsV?=
 =?us-ascii?Q?Kh2hmJrgl0YCwhc2nfpD8j3TbYwiApTIlmYG/sQGmYcXXRnuTwef+Yi/trTX?=
 =?us-ascii?Q?0CwOVE/ddF65OvS1xsm0JWRhmkCahAKfrnjlNnW6G6PtlinAS5X/H0PEaEL/?=
 =?us-ascii?Q?useBX9lSlce70PjiQV/cwF0Vg9AfQw3BkEc+n88cfV1U6SmaHXkmqh95cacD?=
 =?us-ascii?Q?wBbYSGSvn3TD+TJo7HP9C8+NK1jv/K4LVAfjzgsJx+WIzhwSoBlMRAT68DFo?=
 =?us-ascii?Q?XmbMUKElNSLuUCmnprW7SCTka5MTkZ0pkQMUckRiItugh4ayCx/QVHHUQxSl?=
 =?us-ascii?Q?c3MLeSEA4JFQsxDaEclhZbhNpW75HiEdwWrU3Jw/MVQlMQB1eRxnaRI/4oy8?=
 =?us-ascii?Q?gIpAgcuNSfNGURtx79RfFphb/yOw+Y20OTYFDoFFTE6aLaw+HR805FWCGERl?=
 =?us-ascii?Q?FwE7vbKUO0nWeT/icR3B6wes5TIWbMsP70AE3/gycDGSQh0isjCMB7goaYuo?=
 =?us-ascii?Q?WgiA3T1jmFw5dWFZcEGnbO2fXHfbcD+UD0p5B/lpenq5aFl1MtSsA8DjKsXv?=
 =?us-ascii?Q?swITCKnRsf5A//cpYw+OUpBTOXjC1JWQZzbBD6WOuvT3uVIKagvSiPbT4pqn?=
 =?us-ascii?Q?y8jhs7EArkfQp8Oee/vfHCZrk4iFA7Zq+nHbHAHT7xXRe6SG53yEcFkcrkLd?=
 =?us-ascii?Q?xf92ZK3gdOyC7efjxMXfOXs+pFyNR2ZhppMlz3PhPpoxA+XzyTo+aZimGMNK?=
 =?us-ascii?Q?ZQepIoiVixsvU9hN8sDHXgtYqUhVQm615AqSYZQYpl9fKPYsXd/UGbcoHTaj?=
 =?us-ascii?Q?3SjQGtfmMAo8FpA5MK9QwLNuZ15akAektBuOmM9iCnNRQ5/wf0ZW+P9IoMaW?=
 =?us-ascii?Q?SSj8huaAbu91+j/rmLjVAcaD5NaQQ4cecLCtt4qCGsXLciDxqXi0gBaGCLNj?=
 =?us-ascii?Q?IrigtbM7t/YCS4ISJKWT9QBma6CM4/BWzRqrZ+tqMrI/xw+tFvoHW6VqykWL?=
 =?us-ascii?Q?gcVie27tVMuOpnTvnGf6Rhx1aSJop2pd9nlc8NZTdLI8l4Tan77xSYrNsfqZ?=
 =?us-ascii?Q?I3dJ2e57dtzqoJmedQEMeNsN1B2HfbG6ZWUC1hLPpamryxVGa/nZW9n8cWMc?=
 =?us-ascii?Q?x8pnF/J32aSoZGdoxsnkCK2p4e2Br36XUx0EC7nLt2cbSRwPNKpoxL3Yq286?=
 =?us-ascii?Q?xNzgJDQkwW3/Qgch74DSwasV5Rje69hUQ8sewj5MvDGCmhSI8yT7BPv0BmDA?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /SRwafBA6wGy7oaVZGdDZzRHqySuME61vi23IVP21GhbDwek3hrrTOdSKYLKqlWT1/YXq6jB1S/tfJjDWVqxzUVO9qVr4GUdo0iukegvdEgSrKysYHpbZv5PptqdNzH28iZmo7nBpKnGVuqfOk1U7+8gkhMSU/gyvSL6JcFmgIL4sZ71tM/aAMFyWmtom63BG7ofDWDTPZ7BLe4Kq1iBczBInBwu7N0tFXSsSzHgENw5zu8NwbUhCsdQ+dwM9Am3boJkHoerfkbivltn3UFNJFlfF8rK/+bydo3jJhSfZSTkrqCwBbUFRESNGwfqLcfoCG6320AIiyClddQpIqDQZej23MqNS3q7aeYcDmL3B1DghCWjhWGcevi21ZiKWCrinFlFpRkdVn9X9/2E7suaF9WF/XoXauEk/RVJ7exS86fLlh2lB/qkOFeZTGIJree9Eq4gg2VO5BlHL5+E7RcozgLGePF5/hlZ0cVFGRT8BWUeGGzEuV2Ut+7LNM9nrxQVm12lYkIWXCmPHuONWHe7NWHAuxiKNIo4Q2+UsfEzcxp+sJa6kPjfSYACI82DZWEhO1SDiP3sAv6zLG7Yt6O/nGHyEmfZihKWau4ODZhhdyevAT2i4pZVSi/Cc2TUC+/OgQ3mNA+k9OjgTYslkvuTRPNvp2L26JJ6gFWf6B8MicP1piKrfDCERduHJ9l08zveG6WUZqqgNfX+PR4lOQyjyOvPOHPnLtb9hFGsuqHr1XW/OBpHNNRJTmMaldYfwUEq4yh32Orx95wirr6orDd1t6doU37OOv/rI93cVg74WkoWk8Y/WPIHA94n00M5ceZZrvZB7L0Z5rXi3sfW5o8sCA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 511b04bf-c3dc-4e65-93bf-08dbc0d20f0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:23.2866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3UsIfnDNZCAB0SzflXGkKQxWA0JOwhwRBNohTGbo9c7OnFSZTX3MDxIh/uyC7tZPuD3kMsP6p1ZUk/BsAwArA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290085
X-Proofpoint-GUID: IJf6ADORO9m11xzeoi-z16k-7MCvJ5-D
X-Proofpoint-ORIG-GUID: IJf6ADORO9m11xzeoi-z16k-7MCvJ5-D
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Make it so that we can create filesystems with the forcealign feature
turned on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
#jpg: set .forcealign = true in SB
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 libxfs/xfs_format.h    |   3 +-
 man/man8/mkfs.xfs.8.in |  14 +++++
 mkfs/xfs_mkfs.c        | 127 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 139 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d718b73f48ca..afb843b14074 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -358,7 +358,8 @@ xfs_sb_has_compat_feature(
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
 		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_FORCEALIGN)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 9742482dcee9..b86ee4794206 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -657,6 +657,20 @@ Extend maximum values of inode data and attr fork extent counters from 2^31 -
 omitted, 1 is assumed. This feature is disabled by default. This feature is
 only available for filesystems formatted with -m crc=1.
 .TP
+.BI forcealign[= value]
+If
+.B value
+is 1, mark the root directory so that all file data extent allocations will be
+aligned to the extent size hint.
+These allocations will be mapped into the file range at offsets that are
+aligned to the extent size hint.
+The
+.B extszinherit
+option must be specified.
+The
+.B cowextsize
+option must not be specified.
+This feature is only available for filesystems formatted with -m crc=1.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bffe0b7ea8b0..292d0cbad31a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -90,6 +90,7 @@ enum {
 	I_PROJID32BIT,
 	I_SPINODES,
 	I_NREXT64,
+	I_FORCEALIGN,
 	I_MAX_OPTS,
 };
 
@@ -467,6 +468,7 @@ static struct opt_params iopts = {
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
 		[I_NREXT64] = "nrext64",
+		[I_FORCEALIGN] = "forcealign",
 		[I_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -521,7 +523,13 @@ static struct opt_params iopts = {
 		  .minval = 0,
 		  .maxval = 1,
 		  .defaultval = 1,
-		}
+		},
+		{ .index = I_FORCEALIGN,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -874,6 +882,7 @@ struct sb_feat_args {
 	bool	nodalign;
 	bool	nortalign;
 	bool	nrext64;
+	bool	forcealign;		/* XFS_SB_FEAT_RO_COMPAT_FORCEALIGN */
 };
 
 struct cli_params {
@@ -1008,7 +1017,8 @@ usage( void )
 			    sectsize=num,extsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
-			    projid32bit=0|1,sparse=0|1,nrext64=0|1]\n\
+			    projid32bit=0|1,sparse=0|1,nrext64=0|1],\n\
+			    forcealign=0|1\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
@@ -1674,6 +1684,17 @@ inode_opts_parser(
 	case I_NREXT64:
 		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
 		break;
+	case I_FORCEALIGN:
+		long long	val = getnum(value, opts, subopt);
+
+		if (val == 1) {
+			cli->sb_feat.forcealign = true;
+			cli->fsx.fsx_xflags |= FS_XFLAG_FORCEALIGN;
+		} else {
+			cli->sb_feat.forcealign = false;
+			cli->fsx.fsx_xflags &= ~FS_XFLAG_FORCEALIGN;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2329,6 +2350,13 @@ _("64 bit extent count not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.nrext64 = false;
+
+		if (cli->sb_feat.forcealign) {
+			fprintf(stderr,
+_("forced file data alignment not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.forcealign = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -2363,6 +2391,13 @@ _("cowextsize not supported without reflink support\n"));
 		usage();
 	}
 
+	if ((cli->fsx.fsx_xflags & FS_XFLAG_FORCEALIGN) &&
+	    (cli->fsx.fsx_cowextsize > 0 || cli->fsx.fsx_extsize == 0)) {
+		fprintf(stderr,
+_("forcealign requires a nonzero extent size hint and no cow extent size hint\n"));
+		usage();
+	}
+
 	/*
 	 * Copy features across to config structure now.
 	 */
@@ -2612,6 +2647,34 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 	}
 }
 
+/* Validate the incoming forcealign flag. */
+static void
+validate_forcealign(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	if (!(cli->fsx.fsx_xflags & FS_XFLAG_FORCEALIGN))
+		return;
+
+	if (cli->fsx.fsx_cowextsize != 0) {
+		fprintf(stderr,
+_("cannot set CoW extent size hint when forcealign is set.\n"));
+		usage();
+	}
+
+	if (cli->fsx.fsx_extsize == 0) {
+		fprintf(stderr,
+_("cannot set forcealign without an extent size hint.\n"));
+		usage();
+	}
+
+	if (cli->fsx.fsx_xflags & (FS_XFLAG_REALTIME | FS_XFLAG_RTINHERIT)) {
+		fprintf(stderr,
+_("cannot set forcealign and realtime flags.\n"));
+		usage();
+	}
+}
+
 /* Complain if this filesystem is not a supported configuration. */
 static void
 validate_supported(
@@ -3155,11 +3218,63 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
  */
 static void
 align_ag_geometry(
-	struct mkfs_params	*cfg)
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
 {
 	uint64_t	tmp_agsize;
 	int		dsunit = cfg->dsunit;
 
+	/*
+	 * If the sysadmin wants to force all file data space mappings to be
+	 * aligned to the extszinherit value, then we need the AGs to be
+	 * aligned to the same value.  Skip these checks if the extent size
+	 * hint is zero; the extszinherit validation will fail the format
+	 * later.
+	 */
+	if (cli->sb_feat.forcealign && cli->fsx.fsx_extsize != 0) {
+		/* Perfect alignment; we're done. */
+		if (cfg->agsize % cli->fsx.fsx_extsize == 0)
+			goto validate;
+
+		/*
+		 * Round up to file extent size boundary.  Make sure that
+		 * agsize is still larger than XFS_AG_MIN_BLOCKS(blocklog).
+		 */
+		tmp_agsize = ((cfg->agsize + cli->fsx.fsx_extsize - 1) /
+				cli->fsx.fsx_extsize) * cli->fsx.fsx_extsize;
+
+		/*
+		 * Round down to file extent size boundary if rounding up
+		 * created an AG size that is larger than the AG max.
+		 */
+		if (tmp_agsize > XFS_AG_MAX_BLOCKS(cfg->blocklog))
+			tmp_agsize = (cfg->agsize / cli->fsx.fsx_extsize) *
+							cli->fsx.fsx_extsize;
+
+		if (tmp_agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog) &&
+		    tmp_agsize > XFS_AG_MAX_BLOCKS(cfg->blocklog)) {
+			/*
+			 * Set the agsize to the invalid value so the following
+			 * validation of the ag will fail and print a nice error
+			 * and exit.
+			 */
+			cfg->agsize = tmp_agsize;
+			goto validate;
+		}
+
+		/* Update geometry to be file extent size aligned */
+		cfg->agsize = tmp_agsize;
+		if (!cli_opt_set(&dopts, D_AGCOUNT))
+			cfg->agcount = cfg->dblocks / cfg->agsize +
+					(cfg->dblocks % cfg->agsize != 0);
+
+		if (cli_opt_set(&dopts, D_AGSIZE))
+			fprintf(stderr,
+_("agsize rounded to %lld, extszhint = %d\n"),
+				(long long)cfg->agsize, cli->fsx.fsx_extsize);
+		goto validate;
+	}
+
 	if (!dsunit)
 		goto validate;
 
@@ -3380,6 +3495,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
 	if (fp->inobtcnt)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	if (fp->forcealign)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FORCEALIGN;
 	if (fp->bigtime)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
 
@@ -4184,6 +4301,7 @@ main(
 			.nortalign = false,
 			.bigtime = true,
 			.nrext64 = false,
+			.forcealign = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.
@@ -4334,7 +4452,7 @@ main(
 	 * aligns to device geometry correctly.
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli);
-	align_ag_geometry(&cfg);
+	align_ag_geometry(&cfg, &cli);
 
 	calculate_imaxpct(&cfg, &cli);
 
@@ -4357,6 +4475,7 @@ main(
 	/* Validate the extent size hints now that @mp is fully set up. */
 	validate_extsize_hint(mp, &cli);
 	validate_cowextsize_hint(mp, &cli);
+	validate_forcealign(mp, &cli);
 
 	validate_supported(mp, &cli);
 
-- 
2.34.1

