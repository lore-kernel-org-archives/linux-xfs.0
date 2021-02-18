Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563C7C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23CA564EBB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhBRSsE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbhBRQzU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGsCM3016439
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TELCJEd5uF4UJyWKbbgm1G25QdqvA8g0LgxTzE2sca8=;
 b=aHC5Wlz/uedod3waR8TYJt+b8ejKuKIuKSHHDFRqKzfKukiyG6nvRIGLBzrnUUVak3Qs
 x+rm/e0ZwXuXVAsX6vL7JTEWBEbPftOIca0L0ztpx0aDB800iloGJkaFbAJU9ZNKo5RU
 y78E5tWvLHvgYvIYKePGGjqmlakWOIBd0+tTBret4Iul9AZgIWTWoyzCJcpNX5bYla6K
 /LxZwo95uWsXTRCfhzTvm24SjqcX3bDasm218mOt/vBrj0KoeErv5iAtZ+Zp7h8soKH9
 NLIpPPDhcDGeRy/EHXzz2sSkzfanrY87OCMt0wDR0oRYGWlg2puna9fgzFQmSlqpg2bj lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnpj6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoALM119728
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36prq0qeh7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWDuDTKWXHM+bmVN+f7t3nERXKydM4B/FiUsJqNEvui4sxa9Zy/AANpz9IKk2fgVTUWEX56n8qXVI0SJ4M6FcPZmAPFA2MqUm2uWRc917Tb6/XYKPuKI3wC21M/UOpJWrH2li501UBua8fU19MNqwJ2vukM7dr/YRH8ZE8pqw+gPYYbsiEWE2LRam1P5V2VpBA1qVHgHamSbmn2y9KFZVgPVhpPrtnFrFIYXOnyVkvary2ny0o4S6+dxF8s75zRyMxhucTNFa554s487iknIlDA37866sj5ob8IB7ELy8QEdPdgw34UZ+KOCYplntCjSb3ww5hLcDLZmR6Ld4LPByw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TELCJEd5uF4UJyWKbbgm1G25QdqvA8g0LgxTzE2sca8=;
 b=bknS2//qqs8EYnJ711paYBJULxWsjUfbcsNKgTiVn0fjTLhuioEZOS7VMTLyDMNnP+iWGR++lHXVQ9+tCFMqXSK7QmZrjI42FIffAy3hr2AyMRj8IzHURzrNY9hCaooNcO6yVo226GQWbjOM2YznRsuw+3TosCv42od05nq/xR9Nn0+P8hI0ir5RrIbuYi/WTp7JGRc5M1sSZwQR1ixU6+QiIJ579GywjnN9LTA/KNEE9q8v7bVrdGPoe8dIzawnkGykOp72V7FnBXAYGE1TAt7C2M+9o878s7aCCyi6lX2YnyA16bkL117cO+/pv+GEKnjbOt/yoCQJHhrXyxo3mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TELCJEd5uF4UJyWKbbgm1G25QdqvA8g0LgxTzE2sca8=;
 b=PFVjmMBlg2MiwTMgTPgdwrkeKyHog11Z2VpQNxLYlsP9cbWJhitsRP2ziiqiwkKxb0Fj0xIF7WK1KmNAb0wBe5DBvVfyTMNdXFRKw64UIXtB6SkIHXhbyLA8jEg/ISHyZ/CuHIoItBsh4SZn/ErYgcB3z+e2tnE66STfOEFQMDs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3605.namprd10.prod.outlook.com (2603:10b6:a03:129::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:54:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 21/22] xfs: Add delattr mount option
Date:   Thu, 18 Feb 2021 09:53:47 -0700
Message-Id: <20210218165348.4754-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc07a81f-a513-4b91-8a7c-08d8d42dd1af
X-MS-TrafficTypeDiagnostic: BYAPR10MB3605:
X-Microsoft-Antispam-PRVS: <BYAPR10MB36056A52331DA85AE5F5434195859@BYAPR10MB3605.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8D+lQbCRwXecMeMK9RA7cR3aLB/CFtrSMqCcHpSMQiexV5mXs3TsmOSTdp97m7Zf9K/VKoTRuj27MZGmthqHlOCnUdYVAS8xFnWK5YaQcj2oQngfMaEH8ACpQ0x78zSRf3IhLME88O4HcF0ipRVKcaBzJpT8JukQ5hrls0pHdZfostaxDBAcWd8yMjPw4ogFJmcMtU7M3Fc+q1xO+eMqgO+50zbiVTFIfP2Qv/NhS3D8eD5TUpW73ctoRLxH0RLBelD21sH3JvivZqi8uuYiuF7f4IZ5ZT+2ImN8eWyjKnHTueEge5jEbAh2l+6Izr8JPFiWfReevsb9Ln1JPuHIE8hH4s9NDt5EFo8VvunPsvaoJhA9VuhTZGkaHSFxnyXz9urkxIq+wgozJnQ0O11xON6yzlUqlwCURFHoU1BTBShApODaPAQCwI5/qa+qAOrUzfeK48xHYSq8hQEp/xZ/k50jHy0CNrpZEI9B2bQvkiwO+fJ+iGnevkypWgJ3YBqNs7XZ3WzvwW4o0J9wn7jQFbk/O2PeU+OZkDJqSwKR4X7fpyy6NNeIK3XJFHtI9qQw0d91mMctYLv09nVOc7isPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(376002)(396003)(5660300002)(52116002)(8936002)(6916009)(69590400012)(1076003)(478600001)(956004)(6512007)(26005)(16526019)(6486002)(186003)(2906002)(6506007)(2616005)(36756003)(83380400001)(66946007)(86362001)(44832011)(6666004)(66476007)(66556008)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tWQIfYcxrFoI91bb4CidTog3MndqO1PP9E2OcoWAZ/1ymLPayq6r9GD6yE38?=
 =?us-ascii?Q?qlqW4K90AvVFdCGUcR5oaxx4Lmyl9LPaeHBTOBZxtFi8t0M1FHkwsCK95nXz?=
 =?us-ascii?Q?+38RhNRBeI/fcZXzNqYuuGHhWTmWmgcoeyIyEMm0L72LGcCGST14HVuLUThs?=
 =?us-ascii?Q?ft9Xbe3RZ8iHYJRX616ou3c6AMNQLxeQ70dJPfO14vOEkeUZ0DVON7op52EF?=
 =?us-ascii?Q?pTIvqacn9faSm8qcg9KjxKSJPD2FxEbVP1DyEC2G2IdcV6ZMZL0Nth+NAcjq?=
 =?us-ascii?Q?CofnHS47UmscSwOHISIPYtukVnlscMe8or0mzyP5eU4W2BatBjc4YwbWnYeb?=
 =?us-ascii?Q?H/ChZWXv4Ac5s3RzPVYiL87jAXS37NqvnEJJZ51gS5IoYePtgBshrppHS4ki?=
 =?us-ascii?Q?oBF04XE52HB6UwAsAivOM5XOmiZY7q8NmfLOoLO++sHz0bjRC+5eoth0zaSy?=
 =?us-ascii?Q?YwWUOmzHZqgZOtsLcWiBrdCoXKamAs2V3F36/uXZoHOVpVFJ8LLg6Mag9gqu?=
 =?us-ascii?Q?r5o2aqLktmBC0Dv+LfJptVOfT6WNIWnOR84VJz1TiTuHlR0tU/Y2lCFZy6x1?=
 =?us-ascii?Q?wAQsIfZPlkcXMxfrt7Wibt+6oEZXA1wnMwzQ4H+KccRBGoPukIejOkcHSFMm?=
 =?us-ascii?Q?ZHa53FEolj8/wt5OEFVUjvkTst1i3UpMBWT9CTVpH+82SnpNduvrI07SipDK?=
 =?us-ascii?Q?HInm5wnJM/+3hTuNMK19cfuZcVu1iknWD3jH8N0SrX/fVMI5hVJf6CosMy5/?=
 =?us-ascii?Q?yJ3iFb5Df/9Mp6BKcp9UeQkGhIrY6TNfx7CpFNcKH7IZ4eP4Lr/dVPMR0piv?=
 =?us-ascii?Q?2H+48AOFmat6Pl3HL46F4PRYdkgNlQd9D0SjK/kDzYuFlHtRTdfkg29Zhl/p?=
 =?us-ascii?Q?zFdCTComeWPTtP/eSW7CyuHBIlMDwsADmpd2HSrcc7WZ0AZhmTTC+6LPWEZN?=
 =?us-ascii?Q?2ImdI5FpK2bNeaI3sH7kUp1BEwc+5q/VV9gtKaqKPTdHWAo45cGqFfG0tFnq?=
 =?us-ascii?Q?8XP03Sze/pGZhRSzDaWHMPKNXzpprwszVHNqWC2cvscUZF4L9RZPFZjk8Lm0?=
 =?us-ascii?Q?NLO9Trg2LMEHuULDwZ4vjNwyAWyHICL/cCJpbr1CyB/k6d2pDV3lkdlLlDD5?=
 =?us-ascii?Q?lzLNdktoWOq9mLKSPprt29gzYxapLC/cA12NhFfq0Dbn/g0YpGhDmtTVRQj9?=
 =?us-ascii?Q?WHMISMFrA03k2qh8bb6Iyzi4OsLGE4RD915kqvPagYD/1lt9K8nmK0c5Y1PQ?=
 =?us-ascii?Q?G3bkXFdWW/UzJnaBBqvuY49R0uP81yWkJYt0ZX04a2kuSDl42JA1cKudGQV0?=
 =?us-ascii?Q?T2x4svH1jsO/eEhEQPBg0LZa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc07a81f-a513-4b91-8a7c-08d8d42dd1af
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:13.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5/crIclyxwRlWRvWfuxnGp4gVa3HzLoC9QYmHQDOAqbyg/YJ5NRuw6apwGdVhaSp5PfqDCSQck+8vJO1O0cdg8GEwhSUlf24AMjmnkPeyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3605
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180143
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
index f82c0b1..35f3a53 100644
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
index 659ad95..57cd914 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -250,6 +250,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
 #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
 #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
+#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 21b1d03..f6b08f9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -93,7 +93,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -138,6 +138,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+	fsparam_flag("delattr",		Opt_delattr),
 	{}
 };
 
@@ -1263,6 +1264,9 @@ xfs_fs_parse_param(
 		xfs_mount_set_dax_mode(mp, result.uint_32);
 		return 0;
 #endif
+	case Opt_delattr:
+		mp->m_flags |= XFS_MOUNT_DELATTR;
+		return 0;
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
 		xfs_warn(mp, "%s mount option is deprecated.", param->key);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 9b0c790..8ec61df 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -8,6 +8,8 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
 #include "xfs_da_btree.h"
-- 
2.7.4

