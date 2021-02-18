Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD77C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 408D264EB4
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhBRSpV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTgkg040328
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ps/fKlwvvhXS8EiYS4hPANWhJ4FP/hAgCAKy2ydTz+s=;
 b=aAwaWHV2wy5a3MGFaCyZq7DHqdeXwCcBxENaIDfkZLb57Un0BvO0SXB65IBhJ7oTjH9b
 VEWh+SgiEq+8n8FnxWXcqZ2ld2JEIm6ADRv/FTbirEFWCbMxnhpBj4T2EXv+k+odAzmd
 1uH0Cj6+UKcVoYpyNhARP8xP0hVlIRGb7Dml3tCfNO8gezijbAilIOc5NrWVAv3srYQ8
 6QrKcxGZRvBBATD+zrqxCIV3hpAP3O3YEaFFqDmbWixDR5pQMgfXI3IumN9n+kXM6Mvc
 1kYtIii56bf7c9ZjD5LyfkkPACsNzskQcig8+McHBYGdqwamHjni19Tca4+TtFEeuaEh lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCa9032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMg3mGOoLsvWlc+AXL11/ShSgOyeU30SFwajQaC6BYTQvDk/qAneKe/xta7BoA/Xfa3L88rm/B4BXVvUgmw5ztX2L0tI8GSoH/PtR+5Wc6ZRT1IoPQJjkJHfkwxjZpOF7YFiua9luZ6pXNTKlEQg40d25TLfCSA6EwyXjV2JuVhp2HG92xzi9k1unjr7a8j3OlYg4p2xKOPQyPoU9ZG8RQgg0sQBr1qMI9VVbcPqqEBHYZBMII0VI1aV8RX7tBbJ0j24kQUlxek8DbPap9ISn+/WM+WDjnqgUqWZQapZwmyFfNxT4hXFs+SEadrZcIAURHmen4Kxa/wekP0+IfPBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps/fKlwvvhXS8EiYS4hPANWhJ4FP/hAgCAKy2ydTz+s=;
 b=Z4IikIbUykm9EMaVVYiMRigMuWY203c0HWMls04poIMOqIVU6h93pSMYh6Bq4qrajyFxq6BHBoYpd2x32IKWZ2InhwO8095HibxqfoWjUZqExOMvs3Dxpw0N+qPdER7W/ibjkMyuPmVFMEc00aFTLmVLzwPPDukyuyJa9QVbiDKHpA8TDx6EVjBAytyxYGKIx089i200R5/ThUnumwACNkarWdLQQ6R8bWhGdDB3ds6bwvJeSEsq7gpwBeZuoRP5C0UL1HEfBSuI6Q9OybAOw0P7wMlqADQxEKXXlh+154oyOliRAPToOv7Kv1YH4M1s7IU/KMDTaEWPsdbIeERtbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps/fKlwvvhXS8EiYS4hPANWhJ4FP/hAgCAKy2ydTz+s=;
 b=RmBn7UtiqhaZmNhZMODWqAXbQs5Y588trOsUSC4R7iwmsLvg8D04SvsbxgvLJLWGqV9mvTnIdTIRhIoR/nC81CS43NNUe8SyVVGV/RILpTK8wdJ+WSzeXPHwuAd7j4udGR7rRDCe+kzHuyPMKxgSvhbMO1HB6RCofJCVwznRKp0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:36 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 11/37] xfsprogs: Check for extent overflow when swapping extents
Date:   Thu, 18 Feb 2021 09:44:46 -0700
Message-Id: <20210218164512.4659-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8a13f60-583f-4a5a-f13c-08d8d42c9d72
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB42906679043DFC2F9E57317595859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUnwaF510S+QaDIoWXfl2doyh6MpJsMNpX645R85HW8Jb9898i70kyiX1fKzPc1gm7MNLGT3os4+pbAkWeiMe65AmPe3fEKPyl0Jp7IvwlW3rR/rVyO/b2tzlm5vVKJdsoy+hmpG8qQpZkc5LPdvOmtBdGfjlYtjM9ZnlO6QNLtDvroLUzr8SVBApof2nFebiRyYZ9faCJvbWl5KS/+4+0uyIxbm/T5FQeqd20gjA4f3BLvK0QCQnGeH6Ng5KsBPw8o9ChnkWwhs/Y/xWnAzZp6Ug0+Y0DPISqZr2h+ilWM2euje61V5r9FZLKaF6bS2mbTBxdFc4qxX3XGs8ptMmGu26uxCiqwhw2TOypaHScQCITeGVQcmEaqW/+fdTKayKUuapDJt3VixYBbYW4KUT4K3bJeZbUxJAhvJOshaYbJUFI0p+dvN3k1mWXNlXBy553wCmuqEtsfxoruqS72dMaeY4PDzUK+3zgpAxLCBmg1mZP+Mqw7eptlRTkiZ1zBspK0+xDWLeC7ZRUqoIAhjsn2HVrY6cMrFY5POm0jD94V1gj8gC+1I17qNi91VS2Xl7HQlek5IDjS5ebDaMUfZ2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HIVtDh1xJAplMTnZI8gAh/3OAfMeeAicacLmEoOQXJsGT2dnzz7N8K3QrXOD?=
 =?us-ascii?Q?9VpuFrf5akkXNk5uxjaDI2fumXxaOzCZpRDZT+KKZYkZr6j/k9KGminmI3vO?=
 =?us-ascii?Q?BepwLmor8j2edVJt6aLbjRw1eCbQbbrbeU+W7gxSClwiB7tx1T3uN8S8TEEo?=
 =?us-ascii?Q?ws6yr9YpmjhGWEQqDIWt5PEWX4sEVIJn+bjITEdSnO45EvXK4byWmFvEWYDB?=
 =?us-ascii?Q?7stJNEHZWFXhaqfy0PJadMuMr0uaByV+W/dHoRqWuWdJDeolj79ytw5DSRbP?=
 =?us-ascii?Q?WrtUdY39WLOAmKDlyF3wpumm3M9qYiTCv37oDBGdnHiOjmUmqvdfU+ZPAEM2?=
 =?us-ascii?Q?plvUNGchgFA2W/TrLhY4UH/0TF+p+P6yj7MtCdxbUeEkamNm8jCMrFu7rwU7?=
 =?us-ascii?Q?ABtm81wVJ3a2Q9JCVh+6vHOVvkAVWYSYGQ8HmvSoAyME1PZNH5zXxk+bBJmF?=
 =?us-ascii?Q?Of4YQUb0Z9COLQwWH3wqWe8ThbZDpxVfs4fzs2xI6KW9wLZ5dHCN0DINboAi?=
 =?us-ascii?Q?ejYOxJdKRNKNUU57mjJ+FAZKwofZSyA4nEXkG8Ukml3Sz3nlq4B9aHxbswEc?=
 =?us-ascii?Q?I4pMkuVKJ5hrp9XJ7lgvUu4LoDA9LAe13xdAGAzpFmxO0cQ2h+Nb8O/DD1jN?=
 =?us-ascii?Q?HsIKDSqcxxbwNqIUtP/YWfLT2ZEPu0jNQXQ0aDWYYlIC3tcJTRR7WiH8IND+?=
 =?us-ascii?Q?OdidPXE8vFNfGahvfgGCt6hCcWwcUW3JbEMVzKTGhHrkKLv+kTbfTRlElhVF?=
 =?us-ascii?Q?cuzUHGBejDiSG6J8oDga7S8gVLjjKPGN1L/8SdqcU2XXwO+v90tlx50sV3M3?=
 =?us-ascii?Q?3rOEqUXiY4xcITiXg0Ha/x1lcTxoiMNJ2EuMrWKAmf6Jp6IZzO5xVi/1OLj7?=
 =?us-ascii?Q?9vHGypfK05WkhqZk6fxfzYM2oAn+ASqW5fpqt4G6s4uv/DaHaY56uL+lpTuQ?=
 =?us-ascii?Q?mDMlQ0kd31VPPdynP4POYIDeWWVtDw5fu77nj7jglj2XrepT4e0ZQtvHw/JS?=
 =?us-ascii?Q?euJQeHPBG93OaqhZ9QdCfRfZDm7YxumsadID/nxVIds/8Y4LjLPzWLFCqzxO?=
 =?us-ascii?Q?uaBu2YB8wcGQK08mf0GwEsiJwJTDXn7Yy3COhLIYcb0+56n2LVC7rObw4vLh?=
 =?us-ascii?Q?JbrF7bBqb20MTF5vbp5D2U/HDkjCaioGNjN3xFjusXEf1ziLH7EAPItDxe3c?=
 =?us-ascii?Q?Tf1WqSQ1MHUbvwov0S1Rao04IZ2ysWpRvDL2AzthwJBk8fbktRMD7az/ZbDK?=
 =?us-ascii?Q?San3Yb1I6ybQc+928Cfq48bIagRKA7NpdobI/ClNCxUDP5rpChEsvFZvsK1I?=
 =?us-ascii?Q?4QX44kezHiI0X+DLLrqQeaD1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a13f60-583f-4a5a-f13c-08d8d42c9d72
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:35.9544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCHgRKtbcuOlf+fTfcF54cWjgOk/vi1439tzM8V9wSOeoOQ2Gk50ZOu8J9ARQyesDM6/T3bSlJ6BhQmdLP9Kv/FOR+gWFXK3PkDcvvtH1iw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: bcc561f21f115437a010307420fc43d91be91c66

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index c8f279e..9e2137c 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -89,6 +89,13 @@ struct xfs_ifork {
 #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
 /*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

