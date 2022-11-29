Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB36C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbiK2VOH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237102AbiK2VNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BD26CA0C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:21 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIiEpu013743
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=8IKSG9pOpFyYMhuiEo5xsxa3TcHRdxzMMODKoWv0s04=;
 b=s7aYoA4k2++Dp7lRdOTW/Edr2sYKDjh+Gkw/7vJ1DFqMvEZ6U+4pBBENUgpHeOIf6+/Q
 pclb9eQnPJYUfZeZcepwqEbwUidung+u11UHHD/3ARUaXEg80N2LI34MkD2t3GvCLd5W
 en0onOZulOVIXIIRDPXnYASWzBVtyR7V+FIkA1jo+jgmKvRtsF+yDHylrZqedUFU/Kpt
 riRsum42cjo83Cc6z7xOBrYCDaC9z9VCQmtpH8808nLz98nZsoiJX5NWQ7bz8qASy96H
 ktmHDMw+vk09yOjARBoO15DfySO12MNeZSHEC9konLnoBQj3AYQZ3FkcaydT5suxUSE8 Pw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt88bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKUnBb027897
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj1g8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtVxkqHCPcAt6d1+wzdmw4cQJpJMd6gIb/fbOqzu6dllO+vo6Y2FII+Wni3kwLNjSlobStDKQ5ZYRpfMmis04n44D2nQdTMdeNWL1yPQV0Rn1rHvWaH05EOPkCysvDtp3PUEey45TNHJQXcATC+NWokSsFAUMH0GBiD6Y5LC3wsYq3o+2icUiDeJlgNYkglfy+IYhIU9RQpuKH71j962KWl69BETeBNzfvz5XR+RqEm9FHCOFF+zQh9GmyRW9uMklGf74PfC+EpjMhpoBWRLR9CKasK3qP8UMtd6oFhwV/YUbNgBMsM2WWLJQmkprX4JTMutWD2MlC1i+LWdv7IBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8IKSG9pOpFyYMhuiEo5xsxa3TcHRdxzMMODKoWv0s04=;
 b=d6zu5/nzK8Q37M93Z2xDdQRKkw7rvpix7HBARbqeLdSXNP+sGGbIO7T82pjYl1dbdHdilAojQDW6ouUnet8mgvn/HGkMHLVfceJpBQYuOIWZvDf8zhQCmX3OVaCcrqbBk6mdRjE5DdundeXsDslVZGVKNPQMklc9mPE0mtutl5v8yirbbRR9QLhAjiBRd+QKGj7pmpZPRcZ22C0nPWEMJhvDIBlXwheldzxEG1QWz2ae9+mkpk7koJI0n7MFhq0Y5WllWdLtknqX//iwL3/IudmEEblH+h/dNKoqdLzDtdVRgYOnDqMthbJp1ORxcUvFlCZVEAUZQWB4VqDrpTfzJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8IKSG9pOpFyYMhuiEo5xsxa3TcHRdxzMMODKoWv0s04=;
 b=fbeKTbm8jw45gvzaNwZtvmnkyVP4XsAwuT4SfoYTcu91hCRoqsOGJMyA/R6NzKWY14E7LHeK5kkniN5m+p4fu46lAZqmrmqBdOPQ7glFGpvn7c0wnoe7Rz5Y2KEaV08HWeW1eUL64IsWoBFCzy/zFPf5ENPsHPOvYiINmcnsGoA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:13 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 18/27] xfs: remove parent pointers in unlink
Date:   Tue, 29 Nov 2022 14:12:33 -0700
Message-Id: <20221129211242.2689855-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ab16ab5-88da-42ea-fe9a-08dad24e8640
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NoSYAWgy3W4v2/G0A3b07VF8buS5xSEBn+43Hq6+Gh7hj8wuLwJ6qKOJSSmNgCgeCe2OFIC9v+Yb6pJGkfwzWpOHrBObonoVqye0rJjhLhxDRIgJCaqpvK/qn0zMMm/oRUNojWnAFKflebb4IOXa+qPxnVP4zFt7yTRSgCFMqh35ZxEthxeS8JUsns9Ue0Elxs1vNtWW3IGmyEAQrzfb5X+Yyg2+8kix0L/b/5BfmvlZ/oBLi4iLcSL30S0SybkgjxrigliU1lueGBP+Wnt+YLaqr7cTFFwOMWOLp6kuJulHDJ+31C7SchSndADY1+Nhe5MNJj465xWpJpX5icuc+znvw2imAhM4u45N92/FgQ5pf5rMcruyn45jHnjEu0nMN3PCsEApcdYFXcWjlofD4HtWL5E6/k+Qcd4EF54526WWWeR8iIAWh8w0yGL+eyRqL0X+JCYZ0CVA/0FsvLvZ6t2cgq+bq6kZKwHfSMe9tuhnavlsp0JlxOl7EG0uZN937igJziZZzxIlPL+IlBDUbKqoBYTnFXie0c7imicQ2ZeyiyjgQv8Oos8uD6oXQUy615QPHmF8/6cwBvRZly9qg8gQbdyRLAwOeuX8uzCtAsNUFFzZCqh+PWo9B8y6Jbt3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9W2Fd0YKaKN1LUzTwAWcwvge54QJR05vTQg48Mj62B7FvgoEkoi9+pK+wazb?=
 =?us-ascii?Q?tVzhr1sOF4aSqAwwTVoGXkiK216sC3FiZWIGR+HULhrP8cRbc3s1+Bf+4obx?=
 =?us-ascii?Q?YM873Crp3uBExKF0nMRVP0le4r3jprePxmLAqNhuqF2lF4XbqIkjfsmVxcwA?=
 =?us-ascii?Q?cOtt7lWxUCQFPCmmI5DbebSMBWmZ/UevVQrrVwL57CT8jzitCwIFBHViOv6N?=
 =?us-ascii?Q?3kBL3uUIJ7+xY+GIWeaEyQcYjSXKYbH+jHWI6oXr7wMaClw4BYwZlbmjrBKc?=
 =?us-ascii?Q?xjmOjO+ObN4QHWGiCn2LKJBUPG+IQh/bz3a+zoSPUYKrSnahqpYHH4+nsWqR?=
 =?us-ascii?Q?m8Ff4B4W7W3DYRffJkXIiq9Gbuu7raXqLO9VPimoX1LjYPP7l3TMSiJmSN6e?=
 =?us-ascii?Q?QwykrVnpP10ww6gqfcgH25GZGPfwxIjmBHPaY6zYSlBM1BiIVrBvLuWhBqh/?=
 =?us-ascii?Q?Bd6axE/QSXZ+u864J6PYxkT8bbswpnGsFL0IUWoyOkWRdJNGQyYgg3JPF/5u?=
 =?us-ascii?Q?G96SgdsmMeLHetI4+ppy7+LDleI9qkjdZ+tEEKEcvGyVgo/fcnvRCzeFleYB?=
 =?us-ascii?Q?pzwabgSW/umzi/mF0AeDkOQYQAMNC4U2SbrLYWHkQ7PAlxjhXYmhDSxTDuXu?=
 =?us-ascii?Q?IvtgVSxef13xR15XMxP/r97jk6v2/BOND9OK2H8ACWEt2EvbZbfUZDVf610l?=
 =?us-ascii?Q?GwoS8+0Sp0jM9DsoEIxL8Obh2zTerIJHAQ+3uqWWj6ntaWWc9akneZMV15p4?=
 =?us-ascii?Q?g3YOP3dxoIYhjwe2WlcvJgWKMJuBvFWzOrdvujqOYBrqZyq1xXFNZKPPrWyg?=
 =?us-ascii?Q?w5XBgWXouBsXR6uZh2BG8PgIh34HogAbeOzenWF3APhfUltNBib4mg+nmRrp?=
 =?us-ascii?Q?MSy5Xc5RgNKu37FIHK5anKstCZA7fjFLWdV+nn3mhyu0pDcgkPBrpu/NRLuY?=
 =?us-ascii?Q?u14ZLZitPgn70RFy+vae7dzqRRw2+wn+UpPeIQwJ/smcagsF66XCkg1reATH?=
 =?us-ascii?Q?Pp1k4+1ZGN9dXl7DLBHWjihv3vI+FPMolasdG51FD5rYpRjMiWVl0TDy0GWu?=
 =?us-ascii?Q?OgR/WtHrniVQTOMyIy4o2LRoeQQuntfn4cEi30MnuDOSspkJVuKqtb1KmeUm?=
 =?us-ascii?Q?Mck4GXGq7zNo0OGscy1zOrT7si5Z+ODJEBc8ViF1UHG0R+hI7r6FxVHo1KBV?=
 =?us-ascii?Q?5fGMA5hwG+6YgMIoD5IYJxMgtJKIX9AtImjXQJsU3I3vTcllqtE6me2Se5d3?=
 =?us-ascii?Q?Y8ZF0XYlVrJMqRwkV4+/Uj/xoRzcLLuxqdDSOQJCYYg8NgPcqPAVjS6I0cCs?=
 =?us-ascii?Q?vLokP+e6ovaTAhV1fHEidZpoM2WBuoYgDwlceI6UySv/n9K4fSPjjooeY4P9?=
 =?us-ascii?Q?+f7qdWSHq1Y05WAEco5PyO4MG4KKyMht8zbFzSueXVLQZ4oiZEkj42OAjKBn?=
 =?us-ascii?Q?IVFJH0QwboekKVrQN9RrM0mQjLgNN+0cu5sYJybACXk4wYGERDTyzyQYIvSO?=
 =?us-ascii?Q?q0JbWRRKgPvFI5vrGiyC65HpeYrsH/w0RNvSSPRSYU9XVf2toXfloKUTVUHh?=
 =?us-ascii?Q?rD8c7T/W+IP2Pb1JK5Lv9ZAQq8bujt3+o6CAjctEGTY5+GIKod3vJAr7iK1o?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2SpSL/NGlbGZbX7oSD0em1tbWlXHsXJERFnqzdf5JPRm1dzWRDw85zAxrJMcAYMlXjSIR6BoOg/3TfbSOWZ2q+fxaqPcTjQiwsu9LDk7GsC7yrMI0U1OVbGQBymYhvx+s4+SOuVANheVjrt3AxRuYqQ0zgAtLfE6Wl59O+IXFOHR2zWmR7kWeiXPiz5cx2lB125/lpdwlloLQZK8HKqY7FzmLBsdvI9h6FwRXfBOrzLuGgWtAMs9sKARKybvQFhzwzlD5OVMh4DaujTGv++38pVvZjNikaEtu6/DIyN4xoqaoZA5pKZCGeO9LA9js2IFJUSChphcWpDYWmJCwzcLJW8tyjku7cbPpL+9JuXyLPjI6IZYxshuI1g0e/mI1lskxNw6JO9uC42BukyVrDIRpF9nPdOW59wHMQQX2FUpP0fJtDFqZeHbPDVJZMlBR3CpO5hNapFsqEPq1UU9YgE6FkQgRRcrfSQtMRs/7xkpXZtdDBQLys/EnC3RhTuFQNpDn6AcB0CHfolHJ01lrZ4j5+zVKA3CTLp1SMIOqFM4yWM3zYqXuzZm6R0xRDHVZVGJuSOSw25rlJ79prd2wmB/vBEc4EtzntI66aaAv+dykvdlsnf7DPdhIDodNxV0QI82R2R5XkneebadcS0UDkQckdJhwUkLIUcV7CRwgm608QRsybZiMI9gVW1vTuCgXEMfmoifXgmwdGv4m9xvm//8HgDsaN0t0liziNvR60FZA/jD1cvHziYk9Z45S3vHBww50eB1EhWMIesiLXCiCLLUyQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab16ab5-88da-42ea-fe9a-08dad24e8640
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:12.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MZ1Ms5hu4CBRd4H5FwFLUr5GsnAbullIFBWSZSAqNZla8PkBc8JbgUCEHfsk5cXmRhzu2sk3Sn1W6867YpZdqGy5Aq3bDB4nFkLf4HVuPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: 4zEPmIYifffbvrCieUD9xV5elOGYSuJV
X-Proofpoint-GUID: 4zEPmIYifffbvrCieUD9xV5elOGYSuJV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        |  2 +-
 fs/xfs/libxfs/xfs_attr.h        |  1 +
 fs/xfs/libxfs/xfs_parent.c      | 17 +++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  4 +++
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 44 +++++++++++++++++++++++++++------
 6 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f68d41f0f998..a8db44728b11 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -946,7 +946,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0cf23f5117ad..033005542b9e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index cf5ea8ce8bd3..c09f49b7c241 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -125,6 +125,23 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->trans = tp;
+	args->dp = child;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 9b8d0764aad6..1c506532c624 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -27,6 +27,10 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
 void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 25a55650baf4..b5ab6701e7fb 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_REMOVE_SPACE_RES(mp)	\
-	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 86930ee335ff..d98bb3da9e4e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2470,6 +2470,19 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+static unsigned int
+xfs_remove_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret = XFS_DIRREMOVE_SPACE_RES(mp);
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 /*
  * Removing an inode from the namespace involves removing the directory entry
  * and dropping the link count on the inode. Removing the directory entry can
@@ -2499,16 +2512,18 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
+	xfs_dir2_dataptr_t	dir_offset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_remove(dp, name);
 
@@ -2523,6 +2538,12 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2534,12 +2555,12 @@ xfs_remove(
 	 * the directory code can handle a reservationless update and we don't
 	 * want to prevent a user from trying to free space by deleting things.
 	 */
-	resblks = XFS_REMOVE_SPACE_RES(mp);
+	resblks = xfs_remove_space_res(mp, name->len);
 	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto drop_incompat;
 	}
 
 	/*
@@ -2593,12 +2614,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (parent) {
+		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2623,6 +2650,9 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  std_return:
 	return error;
 }
-- 
2.25.1

