Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E54C54EB4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjAXBg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjAXBgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490D91ABE6
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:54 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04h8d020122
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/ZHnu17wX0EAsrcsvCpkMDiXHfRRSu/Q4x3Y74OEdMM=;
 b=wDwkP2LmPnrEmFQ3RunzQcI5aT3QsDhVpApQ/FNLTl812ozzIJm1iwTh10B7OUUrn9yB
 wD2c3+ZKf9zx/7T2WTQfyfvoVizxBvnLD34/h5BHU37OsZi7FuMJknoNDDAJ5bIikcfv
 ecsF3syFYVdGNRyhzYm8X9OYSyele9m3tPazi3MMaDE2NCdmfDnWPRFdOm3en0t26fFq
 hT+8zcdPGQdVWuA4qjyqQhmPIAtgRcPuQFf8tiOwuQkGcVS5/4ZUCFa2zVtfPcLRwBOl
 AIcyCDCwsEHkdPNnq93MtTKzDmfysnUkvEghX7JZMGJekX24YnhDXI4MMO40QZ06gL8k ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybcbj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O0xVZP001093
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gakvsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8Y1rfeZs2R/3lFYgxaQB2KZp0pw5g6uNWs+TPJZesjVcCCWXVKcf8bWFZ3sX4HOHZ8GPQk01438pI+bTWdYbZ6LNzQBDzlGAcgc669AICNTIk1HWF5L4w2oiSdJwQ7yTUpZWO+4WpcJpMricWKKTOyAad9M+yGNL6Xy+xuUu+C/DEGwUpcXT9D8rIk9xIFvs3fo+YscbXxAEN9tOWCjHcIKjN1joZQKMFikzdoqHGXbIJyDM0KEPHG1+ZFgrKUYPsRgBPKkqUMC4gA4yq8zpt5Z23SlQ9LVnl9pjBQphntFJAhjVYU4iIlSES6FyDjMGq0JNmWi2Zg2162fP8sApw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZHnu17wX0EAsrcsvCpkMDiXHfRRSu/Q4x3Y74OEdMM=;
 b=PPRS3Z+ahywsec8QfJjT7GNuuAOW9kyvyY93vTwPFVi1tv2rDEmfoefNSIALVk5i3u4KoinYS4c2VlgFJiD7KkwdBeXBvfixSC9JX/UC4eDCd0DWvtKAjc+IKyv9mriVT3oX18FJzH6ffKDFG8/wYkRlJxkG6GVnfmipe289DdpORetirfHoEgDE9fkIjWCa8Ag/Ge071PS1kRzHN2kCkXMTAu0RC0CIXQ7HC5Nw2TStcw6T9XEVzPBMAs9OdEED0kPYCs1qE/9okGyCv1I3rl6pLvwkgXcaWw1My3RwQB+NDnAG32jnbOvMiw5yDzbeGS4EouN3l+vcfB9+Ux9aug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZHnu17wX0EAsrcsvCpkMDiXHfRRSu/Q4x3Y74OEdMM=;
 b=Ha156mwYkE3CxjxeJCj70HBfCwA0/QjFZAvZAtU0a7QjGvrFePW8HioEMfd1WudFd7dX6PkZeC5iglTINX4x59xekQI3iocYwilgvD4g8LyIGC1H6pNvRfEICd7646yTCSdwLlIXfQNvOFYX3Pg9PEoBuYs/cwXk+yWwJhXFRrc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7074.namprd10.prod.outlook.com (2603:10b6:806:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.8; Tue, 24 Jan
 2023 01:36:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:50 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 17/27] xfs: add parent attributes to symlink
Date:   Mon, 23 Jan 2023 18:36:10 -0700
Message-Id: <20230124013620.1089319-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: d1b58d50-dfa1-4062-d70d-08dafdab76b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yCSJtIBWrY1wetNn+3W5MaQTsIyzgbYHzbCZe9IMqUro5nr1ojrxKiVBfeISIYU90rpTG1dEYezrKkXf0K4EP6K8zLov3iG9f0jHs7xLAIdR4i5Fd3dpFPUQ6iM5m69ZSb1OzueIab0AmbXQ04/TpwBtGIKQxVo6xvl55iQ8bc4Z+avvchqSkguFvvhJvAq+4Jc4Y50nkJJ145Qu8/ygv7ElRZ4h3uw5oX6oo9F5FnBv4ZfEmwLZOjINuPOnTCInM+CKhPfLbTC0QR/OxIFpVDwYlD0uxdaSq+ogkYXJG4cvXj0NxAJqCu0afB4CvEpsRQi32pfvz1ncdXp/H1+u7SZvTiWN5HPt8GuA+QN9XHxRZ+dVyPz/VlTtnC4Lj238gws+XYW7rZSN7+aWKU6L9GPGXepqY3g03OQc3auZEXQj7dzCF1OIAyVi+y4BwC7GO9ibFQKh9bLlIpCL4QzhluUyGacD8TZwGwdTjtK9OxLMVqUaQcW5tX4raxCZSCMycpri07C6ANwMWX1GCuAV8I55L9pdivzRq5ZhQoYpuo2IEytFC0o97odXbauP9dR/GMjFxBDcupD3MEg0mob1vh3mAZ0XjCbnfsidjYvyesDEfkgV1KIJR+rLs65o1SZIKEHEX5kGCmBB3LsIdt3NHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66556008)(66476007)(83380400001)(6916009)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(316002)(2616005)(2906002)(38100700002)(5660300002)(8936002)(6512007)(6486002)(26005)(9686003)(186003)(478600001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cAKI9Hddf0WY5YUEtzP49FnPY5Bdyc9sHubH1ScuguHSQGrWZAgY4bhfrWft?=
 =?us-ascii?Q?X1dSOp7ylTJuUJLrQZW16N3DCub2LzrIOXoqf+eNH11FMKAvAMq8K2IeTIz4?=
 =?us-ascii?Q?oAmtV5WtyPuu+EdbHT+Qkd8ox2m+q4dhNjPeGtKni+E2s8tE6ZTofPdfqpoT?=
 =?us-ascii?Q?rS990upBmp4Dy6+5UrcWmNB34NixfMJGw4EDRphJ1FZztbBDglTQkbD2kbTo?=
 =?us-ascii?Q?vch1m7R336PGob3RNMWmmUw8HwVjXCKZ24zheDnhaSgFRCRsiMs9VzO+ZSUe?=
 =?us-ascii?Q?7ZAtpJoqHoDosvYQWTHFpBW2hmlWcGcKMmvVFBfJInQmWalD8qFIXByPp+AU?=
 =?us-ascii?Q?90W/KM1/TaOvnvpqDUAxPVEt7OTkny3u+th+5C81ffQjpbM9djwCjvzc06Uo?=
 =?us-ascii?Q?98MM/BXBiLZM6DiDs/eg6zsaG63BNTCwVa52552l9j/o2B7H+h/bbRyz/n8b?=
 =?us-ascii?Q?i6feKAuXpN4Gmb9nl8m4YEanjfEs3cfsyp3UqnkgxmQB/ZVY4d2vtqvyx6Td?=
 =?us-ascii?Q?P+30W78SlVllAMru2xXjtZilfhCWh479dNLfajsocq8vfGVTmPnffcyyTwIK?=
 =?us-ascii?Q?8B5lHoaKTFv2PBxGrXaYNQdO22KWiKhoZ0xUrgxMm0t1B1acujYxXRjwi99+?=
 =?us-ascii?Q?yAWqCRQcs+5hPbxIaqVmaiMkAhtZTeN6lkCF2x2ti/rNrqLCeEyIJ8WHT9er?=
 =?us-ascii?Q?Mw3b6gTO8S4pLbJIfEGSdqr0lmsVq5MQrbk2HbO+oaT+0ptAcGBj339mtwXx?=
 =?us-ascii?Q?/S8+p70yXT20rfkeRuyZ3k0ivFmup6Ipaf4NYzn1L2+Cy0i5GwLRhOa2hekN?=
 =?us-ascii?Q?ZW29PyN7P/pWMABhcNzebI/ptyEvOVyg+6YEXFk7Pd3Q4/HJQLpfNQvDb0rA?=
 =?us-ascii?Q?RNxgXYOTkzdvF+9qucd3iS3KP6xKzelXFpPtNCNw3tZlA+uZHDqG3+tyD0XW?=
 =?us-ascii?Q?pPxCRTQ8mw+uXUkivDZw8cX6b5BWrZsYVJk/ES443O+2hc+DnaOJs1i5kgMc?=
 =?us-ascii?Q?dIyGk8GU986f7GUcJUjD2ra8XIo6VQzke3a3ZWqt3pdt1xc3oX8erQi4/IPH?=
 =?us-ascii?Q?UqeCPeRtH+LUD721SrTbVz6v74Gx9aZkKppSHb9FbEuxJVQI1nuql4FNzGBT?=
 =?us-ascii?Q?aTAGWOK+W07A+XDlj/v1dLkn4ySfmQxH87tVfPA4pbKohxfkMIvhziW47mfu?=
 =?us-ascii?Q?7Tb8JnFnlu7EFV7KduP1x9IS30aQEkw0MR0BfAmpg7t8e7Jf7LdMuK88+GTA?=
 =?us-ascii?Q?7VpXOo4Q2QXamjKDVeo6Lq5z+JEFxoMreKz8CLISTHvgeEUiiiwwdTy6esAS?=
 =?us-ascii?Q?tdm5prGw6bHl6oFUlrdn7yNV+eswdaAjpYSDC3UdmiBWuKwQIx5Gw8CvyjMt?=
 =?us-ascii?Q?q6jch9KHvjPFZn9S2NzDp2XTasaW+ToHmGvvTbvQs0DdgVX/YdZ7cxnK8wO4?=
 =?us-ascii?Q?jfBnrmJH4iUmn6tpp0Z0TRu0dytSjYaPZHYcv+k+2u3YltKp8CxWpafLI03c?=
 =?us-ascii?Q?rEzYJesGhCfaPNh7rK19kgIJoK8iBYyQtqkl3XYc7wVcMQt0oq1RV81JAJsg?=
 =?us-ascii?Q?fEGE3eQUc8zi0eqI4XTC9LgPejmd5vqh0YiFiLPWkSwfSMSeOp843qfqQhVR?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DDtH8fekD1Y/Vq5km3IBWbP4mYZjgBMSOQxPOt2CzQSSYGzYOYJ9GADX9zALopDp+cSYX6oYzGAWWtXJ9kVrnXy4uf+Lg9Cm6hJiPs9x1HnH+F8HcO3S0RqJrWWhrspu6aGoZd+idolwrNJHcKthh03EsoIL8mu+Z1Qq4Uex7P0+AVNnnutwUueU2aB/6Azslv/6LPKB7wMJ5Kj0TV8xpLrrDD5/l+yWm3mtGEMBBEuCJD1Yqm/REdtbeg5eBVYJe3U8WOert1joP6OnHXVm1PFnKXh+OHJpo440o2fjlwjAcsw8PxJ78I0Yip87LH3Vvxsa7FoBadte35L8ueWn1kYPw/ePm6JUgm6tWXSkxlIGgTacClld9Jn/GqTrmM904Xal6run0h+v5FI5WxCT74DZa4846r3Kef9E2dptxzynmtE8gLiZNYC5at3ergsalEjAEcPrGj9mqEPMTztPNhTQQJe/L7hpDwlbtrbQkhdmgTu844ElwHJXsKw/+vdLO9W5RzcQ9/lIZ1ePUrYT74/nrll81UufL2d/b+3tJDUC57X+lHoD7a6TLUUjjOqxdVpr++U3xX0Ipf5l5vFGYpWyOMngmBquJ0U8DJVACZ8qxnAOUjUXPZhMtX4Hw/7TlSDi8hJS6jCyEfYoGdbyIKdVIh0uiFZXz4kiM9/t1Tl5yKYWdhtSeJwM7yPMqiipCUwb14qsjIfX6yrqNj/MXtjXNyGfO+ztv45Oxp45UlWexb2dubBCpRz+K9CQXSB3KFXEi4JBT/yMqcS6z5t06g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b58d50-dfa1-4062-d70d-08dafdab76b3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:50.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrhtEfP+QgLtt15s8q27+HDjXCY6tHA4MIk/vwds2W0YYuwyaMPeJWfXiGqL+xUs1svjCSQMpJO98eBD091HSeIUb/oZWxpbAkult5ccJO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240010
X-Proofpoint-GUID: y_SGsDgYE8Hm8WlAFzTX6TBLckQvXiZD
X-Proofpoint-ORIG-GUID: y_SGsDgYE8Hm8WlAFzTX6TBLckQvXiZD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_symlink.c            | 54 ++++++++++++++++++++++++++++-----
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index f72207923ec2..25a55650baf4 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 27a7d7c57015..92d69b3ca28d 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,8 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -142,6 +144,23 @@ xfs_readlink(
 	return error;
 }
 
+static unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_symlink(
 	struct user_namespace	*mnt_userns,
@@ -172,6 +191,8 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t      diroffset;
+	struct xfs_parent_defer *parent = NULL;
 
 	*ipp = NULL;
 
@@ -202,13 +223,21 @@ xfs_symlink(
 
 	/*
 	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
+	 * If there are no parent pointers, then there wont't be any attributes.
+	 * So we get the whole variable part, and do not need to reserve extra
+	 * blocks.  Otherwise, we need to reserve the blocks.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			return error;
+	}
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
@@ -233,7 +262,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -244,8 +273,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -315,12 +343,20 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name,
-			ip->i_ino, resblks, NULL);
+			ip->i_ino, resblks, &diroffset);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, link_name,
+					     diroffset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to
@@ -339,6 +375,7 @@ xfs_symlink(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -362,6 +399,9 @@ xfs_symlink(
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	if (ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+
 	return error;
 }
 
-- 
2.25.1

