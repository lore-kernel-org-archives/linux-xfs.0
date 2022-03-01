Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD445C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiCAKlE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiCAKlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5316A90CF2
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:23 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218LYw3018837;
        Tue, 1 Mar 2022 10:40:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=gMG5mEdawI5A3tz9cSfOapDV5y32mNB63ymW07qgV1GdguyLlK50EEdTdSAX2CP+EKFD
 4e+vIUvnxNu21DxtlJFd4E7C8Xf2X7pwyF3VY1OKgvmDqghHyMcu9ZKvCCDQdAxt2Vu/
 J4+PbHIrfh0L4lQA7POpg0zkq2k/HjsF5VaNIlUtfdDHvDNXzDPJg1HO9TEXDZ5ekZPf
 d+Gfcruw4L1vUm3D943nGqnOocc/7dMo+JkUyry2D4Y5YWYibKV6rEVuFGsPTbErnia6
 9DUH6U0qk+OVSXH4bX8I5jCxMbB66i96KVIeOPIvIib5wzTmO3rD4vTVm+Y2vLrESkSl Pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajakk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZGcY042850;
        Tue, 1 Mar 2022 10:40:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 3efa8dp6fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6HusbFjJ+yQ4xW939UxP2uzOkTywjZ2AK0ByZTeyRb+ywJGy4dPIrUjb6y1GtOEEYZrU95iWzBEnQbECdSmIKP2oNXRk/8Or6AWR3tuwavDXTqvmroPy0EISQKCWu1WoQkt+PVkbDENyFO5pOWxvGnmFxtt3UbsZ9SSr3TjeLOCiiNGizU3mmVSmUiSczFPtTaJC+lJ5W58iFZsuQ8QK9oKMf3LJ+Sk1bzb8Q6iSuEPQZSxYKZxwnW1tUv2qMzuxhqodS2szc6AjdXVN3TjAkuXDotKu0UKBhzqjEtBXpPysDPMSgL/tx6lFROcrOBZn+kECXl+n62XCsDPBaukwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=Eko4pS3ZdE+99g4jAdogEDYpYKrnOeefIgtW3+Ll6iYQIlZcWjPqnR5fAwyD470RQW2XP+wNQuS6s5RLUrqRyURWhc6IOuVAyhS8FY9cR80FCmHqVEquWvX/XaZA8t1ZuDFKfXAJEvqbHMxUZ+t7/wY9kOCdW1RMiXYR6jNMcVOcrWjSnHxi797zMRwtDJZWrotsnSWIoWVs7A5k6qv5TXF0LBO8UPs7BbqmeDkq+2rHIkYKWlQGXstgyRppP1JsgzPhOgj9zgjuEISwX+GurccVVbAqNAZlv8nKhZy0BtMgwiqmpjACUii03UeQJ/kXaIGEzBQ10W6ckvKyTM1+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=nC8EisY1q1MbcGrnQfwz2KwH8FdW665fJNWyuYwMxvubkiy1iwiSAN8ULvnFcguK91K3I6Ix9eR0u8iJOqk7bfhvXO1nD8tLPVyNVeREqAyg4jAWQ9oOvAJc4yL3pZjMIxqcpO2KRxjBWgG2Qya50fS5tBQpx8lO/evxqsdm9C4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 07/17] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Tue,  1 Mar 2022 16:09:28 +0530
Message-Id: <20220301103938.1106808-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d7449c0-d4c2-40c2-248e-08d9fb6fdff7
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160E7B23235B1B5FA087939F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U/qT3KLndZXfF/kslQdVg2XzbCDe0p8zwyOBQtO7ahW/KtzRh/6+e4xHGiig9uUctPvfPnbFA6Cnq/h99IfOqUAaAxzyTU7HvjlF3+kEtJMt9IHg652BRT5oAJ8P9Zd11VmDhxHmLcaIz98N0NTw3cfwsTDYwkoiSx2eHGDPd84n2LKtfXc3fDMvMn6BfRd7q1+AwlTTUuX3hdcCgkEINXXOmCEkjxDkzZ5yS36mqGyYEYjcN7H7dxbvthzB9GGvWqnlERoKQTqEl5UXYMn7z1d2SnlJ2TovIBFfa5wCgnRi3WHSwsHvANsKErCEas90o6f5ARxL+7CjdIWdJM1P+Pp/ZF1lUyEdnQCGzJZuyaTqFWKgRUdnhV7xuoTYP8pwKIz05h3iCa8sfaV31Hudv1oPiezzaMCJuyQRrp8AYnsWFOngPH5WoO8syL/x/BUXIMTLoVHgjI+GZZiWqSgMDwl6NVvkRuIi8snlv/kQw/RFtmVvJJuVTAYb2GXiC6V5G5A9dUcc1OLw6he+68ofoYGddTb/8nROjqUcaQX+ML9Z+Y/OVWzDbIMvWaCTec7miDEoB8mYju15NPw/ADeJbWBZLPl/yTDW0RjjGPqbu+HOApavtmXr0aKnveLW8v9PD8Q1xptGtntic4LMmPgdV4vM1sp7KIqTmioyIbwJ24euYX58+eSIfkoXvlptfPH7ay2CGMgxs+FKL5DUnpnOwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fg5Rw9Se/4EiXRoZwxKUwp0z11BGqFl2QniOiX7WrclNDgU+6IF5s0rVhqu1?=
 =?us-ascii?Q?JaEdJx3Ay97tg0tRxPiSDNUdRC9+6y/yAHlRBmlmwH9txge/zM2nF7Gztlyh?=
 =?us-ascii?Q?IpMbEY+A9qPgCDI6EB3ptegWEkjtOd8/wgaBxuZj2sMnPP0/aAWnec894TYC?=
 =?us-ascii?Q?u36xzJSTO3+0zCxglKWnIctYAKQMmRPtelvcah9ZagRIxoLSmBzW8Sb2NmaH?=
 =?us-ascii?Q?XAbuoM9NxSPIXuA4579mj6YB5i0e26K46CrX/TL9rn1rADl2ZqSuwK54peqx?=
 =?us-ascii?Q?nwi7lPrv7ja1rj7eJbqkAZZM0OAz6aGcpSAkdWvy+TJpliZCDkgrMAbymd95?=
 =?us-ascii?Q?HYWHv4B8fmNbzwdg1A+wRLKBYCjNp0bc91sCJTeHwCD3lpqiks/FIbcujNCI?=
 =?us-ascii?Q?zAkmQrSryku7wsajW1qQYvNAq7hrXmBeV4saqs0oe32XL52zxwCyeSMjU3NY?=
 =?us-ascii?Q?nkOPzueGW6YBfux1LCNiFT74z/mxHLjLpPONrW/SfjlCxBjCbeN4yaVqcJFh?=
 =?us-ascii?Q?n0TYeAjY2m030fqBpiGfBu44LChWmwPCUAjWyT9eWy1/Lv2XjSlcPzvxRZY6?=
 =?us-ascii?Q?EAbXk40ONEXoEgxGNNbGjzCPLqOJuKSI54FEjBr2eQeoeoYnKAM0X9iu/U9+?=
 =?us-ascii?Q?L/TB/VjqLNSJwtnFQ/wXL2jLcOdLgcxxohgfMzboOClwKaKn1cPfK/UILjcP?=
 =?us-ascii?Q?tGNYcdfmu8auBXHKil5lDXqYePMwyGT+1BvgK2WlxZo2ALF6w7U/3CwkFjVW?=
 =?us-ascii?Q?A6+X5o4lgk1Ry0yQPoWGHHFjPTE73lElXKuYVunMUwPfpqDLEhya2c+iZB4y?=
 =?us-ascii?Q?FmtDy5WDgNGX7un1WuDqPhC07kmAO8vDJ5x3tWPi6StlJqumvCnHCJWIwH7M?=
 =?us-ascii?Q?17/2GyXItbKUOiYnicb44AojFialfH4qpSHiSboU0sWcq/M+oU7i93mHA/Xg?=
 =?us-ascii?Q?3WNm5+Ci4HxRAkmUvQSfM42wTjZQ/pWGOuQUp1vRKE2q3eooJLAHEIsU8xz5?=
 =?us-ascii?Q?qGD2tJ6j0Kwswv3knH2VPwuLXyvFpTY8Li0kOhcxEoT0Ph7mXg0ndxjQ+hs0?=
 =?us-ascii?Q?eVLzcSdS3cEBCHICxDvVM8lAEvKsqZ81Ap3frJfwvMZoeI4fdoH8K1NM9k2A?=
 =?us-ascii?Q?4UKxMnwFxz17rTIN5uy/x45//dJ2N9sG6JLExI0gXcZnFamI6cFctBVVdqtg?=
 =?us-ascii?Q?kcGD/JvocBK/8gBSKJagu0B5G5Zsn1RAl7vG829+z+5lkkpr2+YjJ07t8haK?=
 =?us-ascii?Q?HAHHD56HvdkdQgNdP8juahZvAlGvH/N4Stf+9eTnki5uCweemTXXf3A7IxWv?=
 =?us-ascii?Q?2uGfKvE3/Kv/IA1UImWIccOd7GY9ItmGd6o58n2t9OMsmTXpcaZ8M/iXyx9b?=
 =?us-ascii?Q?qmLPO/xgnuvdrjyuSTGECiovORwcOnGBFwDEZiYBH6UK9EHJACWIHr42Z+r+?=
 =?us-ascii?Q?wgYr2RzUFU79Y/FTQ1xsZMoxRgNck5AzJR+Yw/ZBvAn4QlPXHIHT/yuYRGCt?=
 =?us-ascii?Q?k6XgEv32HaXJzCHpNHrHcTXFe7Up1m/9IjRdKEehvcA3yWMgiTqLUKUfCmQi?=
 =?us-ascii?Q?HSM6evHj2TQ5YutsB3Axn2n8AW/4xoNpKmqqUbzJX2c4nbsM/xfZobPXPRaD?=
 =?us-ascii?Q?u8DoDS1GUx9FKRfJnmzqTcU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d7449c0-d4c2-40c2-248e-08d9fb6fdff7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:17.0529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2dqfxV2Lq54OERLn+SCzI5ZWW9DhThv99Nz52eWL9rlMXv/whza706Nm4eISO7kqUCCFPCmXUziKCgo79J2nEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: lZtFkg6ALmSQQC9AkzlMby_vJKJRiCfV
X-Proofpoint-GUID: lZtFkg6ALmSQQC9AkzlMby_vJKJRiCfV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 3 +++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e5654b578ec0..7972cbc22608 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..bd632389ae92 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -124,6 +124,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00720a02e761..10941481f7e6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -276,6 +276,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /*
  * Mount features
-- 
2.30.2

