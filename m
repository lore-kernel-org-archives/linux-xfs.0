Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E635CC07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB92C61CD4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGGWYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23100 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhGGWYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:11 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKbZ2024355
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2U0QumCxUuz5lyAtQ6XEUiQsVU0HDB0X71m8NWR/EAw=;
 b=CPITmBrJZo3aZYd+otHgU9jwrsXspY0UubOaUa0S09kvrlWr7iJ8M4lVuEdE4326I/ye
 +aefR9DCbX6A9TL0WcMZbStqCnLAr1U74j6/EsEgEPjgWooCNEmtYzhZG9Y3B1PvJvBX
 FT0RaubLIjzxDMEC9RYf7NbKRNW/yQI0bZXEBiQ7FK4FVCdPAHJM2IV3pq50wcmwcaDu
 fiZp3A0L7CnEZLLMNcJ1g5hFn+pJgO71YPCE6COngXgIkjVpFSx0CCEmvAQBvfSWyrO1
 pxOz26N0E/YqzC+GC0zqnX19DWB6UvGl3HE389KuYEfPD6oXrmG252VBXf53iwcCHijW Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m3mhd4f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKZD4092555
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:28 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by userp3020.oracle.com with ESMTP id 39k1ny0hrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8o+gCUnJw/XdUN5hfWe7lZ6KJkCx83TeAufZBNSDzbKCk+rczZPiPdTgcd6kLRBd3xcNvAMYQpzht+xrep+9wWD4RmqZapNf/tAzYqbW/zo2WYOPe0RIkjLG7O2T7cvKHPhp7XefrLHTszRi+tayzMA2eval3MbF0Won744wzn4dKTAN3oFP0sWm5GdeG6+iWNtJgR4OVMD1UvzYYjtktxu6V9HHdjgbwvPkBRUhG/d4v9lfDg+tikfYyBPkyEXQgD4XSLpEbmRYe4Q+tEK9/ii+mkNDDM8yh5yYOLz1Sw3yV+uftUwCtmlDSm7UkoIG+lZCSIc+f9orHQV9tzikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U0QumCxUuz5lyAtQ6XEUiQsVU0HDB0X71m8NWR/EAw=;
 b=Ii2enByEu5AHpcrR+k/LAuDtmCdI2XjGtRrv/Bm848JRNzwISbJBtKzhexdx4JjPbGy5VQjUHxby8rq5Qd7eyxV1kdOlvHNSkz0pTx3rK6OQVLxp+VV2l6hVkPRb7Ds0WGRdbAjBKoqgzkAehVwQfgBTif4P5PntwfMo9Yua90S2JHzMoA6v9SZmpHnBtkm+9pu77tph1DVSVdlGg9vx3nFVIiSpRwAewtS6lraihsbClJMxNjEQ7KcX4vYQ3yU+Z8eT+W/FtJB6DMU9GHV2XEYFknQ34XyrtxoZRPa4cXHj4z3Wu2PPejU5vzRSl0xCLXvHKU2a4zDm50vRRzf6XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U0QumCxUuz5lyAtQ6XEUiQsVU0HDB0X71m8NWR/EAw=;
 b=QtOhwl6Y3l6ylzE9CUvilPtcVyMras5tOX5dZDu1DmXVDXJli5GYf7GFq+s/hcsZrjxVt68IEK4RCraf2yVC8a+l3fwuUt+Doe9A8/1rA7M0czJPJ733W4VFSSb4p38pzcfPh+/XxZ/TvPuh1WI5eCt27qo22wuaigXquUIBquE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Wed, 7 Jul
 2021 22:21:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 11/13] xfs: Add delattr mount option
Date:   Wed,  7 Jul 2021 15:21:09 -0700
Message-Id: <20210707222111.16339-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac01c611-5922-4f92-b75e-08d941959000
X-MS-TrafficTypeDiagnostic: BY5PR10MB4388:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4388F33FA170FD4A13283146951A9@BY5PR10MB4388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUfUnFjPjZ3jtwjha8/63l6AxUyGhYioLFuEuohXkxPnq7rwJOHfYgGQeL5X/vrjikdwCAxht0a+ryYVamTmT1hpD8ydrU0xTBH/dFvBL+LYulfoe0V0WPECVoVcL9Se662J40WUKN2loN7PgoKdhtslnYv6MVDiGfayhg7jrn4Jb1VcWBjNI4wo9QasgxAjCUpYXohr2IzcJScwefp0g0kpWrBJ7zLMVUzqe8BkCMS5I9onJs14DnjLYAQty1T2y8CQ8t2Bx8v3b1CH15z/3OyUYEu6Z2OxiXKa0oulF//q5DB0N181px95ruSur59H1F0+/MNRC9WWpRyBsfnyqpIGL/QAAov6NEbYmWfmMQ0IbbWQUGbDOJNnLmqa8YZ8SOEOXy3LD9OQMSn9Rdebu9WuyRSaT69Gn7UmMo8uKcFN+PFuvP0C3PfCyowBepOx4HZNRHpv/2p6gijciz4yxMEYMqS9NU69cg5I/QDtimjihUZgOhDeV7hMNGFc1hko4Z+HPkGVG5hJAw9K2QYs7UGvJ3Ng3CZIRa7PH4Y1qiSvFDKodGqJbhAi8AASw3QkVqjRpb4RVDIFgHtvWNdmrficLp/VU3M2T4x+r2pSnYGsqHAzzZBjs3KMa3i/6wNesfox0AZaOJSwCt3HV5HWPvRBjGqtwD+Q22jUsJcPalxX/x5kLJHuYys1fDzVqasRaqkNl/OERWoS62ocx4/9rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(6512007)(44832011)(26005)(5660300002)(66476007)(66946007)(66556008)(6916009)(956004)(478600001)(8676002)(1076003)(186003)(8936002)(83380400001)(52116002)(316002)(36756003)(2616005)(6666004)(38100700002)(6486002)(2906002)(6506007)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J6EsHKQCAYfLvvnppPqU7+YjaXxJLKDCooxUNTppOKuzhoxrW9G+iYrBoMxn?=
 =?us-ascii?Q?KhlbwGT0zFAvNYtsC0Td3dh6vmZz14v11lD0dW5YRZ/5o5/twi6sVPQIKiCX?=
 =?us-ascii?Q?4SFOXbexNq8ajMuIsJQCBLNQ00JzlsEEqdc3X2T/XhRt8Vv+Q1QallYjGbSc?=
 =?us-ascii?Q?WzzlQx9l6v49xta8WmprKk50U4tD6DmDNUFUfgOgk+fNCNO47X1pRcsh0EhK?=
 =?us-ascii?Q?l1t0ADDXPvWMLTVGZVmq/3pddaAGMp/LtO/DLinyWcDDohOqy5XpjLb8+oA2?=
 =?us-ascii?Q?KsmBwRL3xmTTXlZDLx1AhLGRcSZf2ZNyTIqGf+w779nA5kawdAWc5gM3/Xs6?=
 =?us-ascii?Q?+HlYqOB1LQdlUZWpgu5kFppo0OPF6HwLuL+Gu9ZZSKXaBvPosuvcDIZTR9be?=
 =?us-ascii?Q?ZcGBJofckuIp9l/Jdmrh0caqis5kPNFnHbci+8iXv5pwKZbn8sPPjL1pYWN4?=
 =?us-ascii?Q?ZAjhxcO3cRGnhFXhvkguGHX57LTSFLHvRJmTm1LRhTeVaPAjunnvMTLK14c2?=
 =?us-ascii?Q?TM5DVH60IdGmOgMesrdZVg+XtxCQgnGnuFApaev0Tc9kziA5MXhdMRxHh4U4?=
 =?us-ascii?Q?yvi886aZcNZ50QOUkrjEFaR4WItB26+TCHqxEctr4Et6Tt1hJv+v44dRyPBk?=
 =?us-ascii?Q?Ntau80ty+Vy/EY03PylGzHWtTaotE0SA6hpmgbTDOgngoOK4DW51Ku/aTEE2?=
 =?us-ascii?Q?+vULC+PZTHT+yb/DxjQ5J7CjKPBEej0jodkDI5zGFny013pN5saRqsi0ItER?=
 =?us-ascii?Q?un5Hj3kpNKtkjzanTkiRGmWFVSWTZAXl6nkK5Oj8J3lfSuamKNUBGvfB1Mv7?=
 =?us-ascii?Q?T1hcGveGS8BoeeaM8mEguiDBy1YEsCemE/aspKUAtGDNHMm2ZYNbz6KMKCsI?=
 =?us-ascii?Q?B3sUdJV4EvnuxNfJeBAJCd7jVVQDOXki9AK5EWlKKJJQzFFd9V+qufnqd2Nu?=
 =?us-ascii?Q?7ViBNehxFdl2fsThNNGYryeozV0Vh7gyiD6d7E+x/fZWsLOhI/b08MoxI8L+?=
 =?us-ascii?Q?6PENe7Sn7su4Id6E6ZSSZmUuuIFLvxptFToxRK8Gn7JmRWjYPiks3PQ/zle2?=
 =?us-ascii?Q?NIOS7kpJJbS+enPpC8Q+Bb/0SvOv7NjKg7V0w1CjHaEoZhB2rnS1hnLC9O5f?=
 =?us-ascii?Q?FxnBPEZeZY6H+c5PIMbrpfcLj1efDiiTE8NIVoi4MgcHtXOkHI2zfwCNjY+H?=
 =?us-ascii?Q?kG/WX+o0DkKA4JMM6s+JehPz2Uw8UG94czWubPf+dNewkeV+VhNkg70g50Df?=
 =?us-ascii?Q?SVakE9tmwZibQs8IjyF2ZeJqDmWunB55IBcPJ3b1iwTakCy3O7wRt6i64mBy?=
 =?us-ascii?Q?YhgocEcrfMjIQ17QfYgw8m2L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac01c611-5922-4f92-b75e-08d941959000
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:27.3864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yni2dJUlPbRThGNpo+diHAWZ0Bfd2I7ihhgmcLedKiZJV/6Xi/zo+8qzRZdBTL3Gkkg4y8zVsD4kG43Yq+ox7RIet5dy7IKV25mnx45HQho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-GUID: eyu2ZczfPFzxZ_Yre-MiQJXIgDWdBRn4
X-Proofpoint-ORIG-GUID: eyu2ZczfPFzxZ_Yre-MiQJXIgDWdBRn4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a mount option to enable delayed attributes. Eventually
this can be removed when delayed attrs becomes permanent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h | 2 +-
 fs/xfs/xfs_mount.h       | 1 +
 fs/xfs/xfs_super.c       | 6 +++++-
 fs/xfs/xfs_xattr.c       | 2 ++
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 859dbef..5141958 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -30,7 +30,7 @@ struct xfs_attr_list_context;
 
 static inline bool xfs_hasdelattr(struct xfs_mount *mp)
 {
-	return false;
+	return mp->m_flags & XFS_MOUNT_DELATTR;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 66a47f5..2945868 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -257,6 +257,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
 #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
 #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
+#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c30b077..1a7edae 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -94,7 +94,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -139,6 +139,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+	fsparam_flag("delattr",		Opt_delattr),
 	{}
 };
 
@@ -1277,6 +1278,9 @@ xfs_fs_parse_param(
 		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
 		return 0;
 #endif
+	case Opt_delattr:
+		parsing_mp->m_flags |= XFS_MOUNT_DELATTR;
+		return 0;
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
 		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 66b334f..7335423 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -8,6 +8,8 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
-- 
2.7.4

