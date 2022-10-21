Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DEDC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJUWaP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJUWaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BD322C818
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:11 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDtFQ004534
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=PZ3WZTFhEalopcRJPpTULhUWyTPBm2CjF6AbP8n1PlE=;
 b=tXqOLVsDAqcSi0PLB6YfLtBoH+cTEcSfscY+4cB90w3dObVZRoXyMzItFUcG9bbjrlc9
 3H+Nqb0VJm+IZ4gqh74Ox0OTQUn15TyH2nDkngxQg/pnbSx7Y2awrilwMhQLascU12No
 6vvM/PZiFxMXx3ttWEV4eYMLETTVmEIsrE4oE5mbP2/APs520meLZH12ZPf4DzQFR1Yc
 0E8aamChgN/9w1rZAPC60RvTnO9EmQtu+eY04IzWFB2icBTeKxxNrtp5iwA2tlYOVTY3
 dS7KP0IR8frFhDQmM02+eJiNy59i550g+lnRWGGGVjPzU4RY1URUo7dEvxGhxXG2lOxB Sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0ajcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLOYIv038657
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr3n280-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8F60H9OhoTd7Ewj/YBhH9qNDkwZoqV1qM+wVacX3MsZnpYyGrbCd/uAvSuIZkrehpiL9aakpVrdOFmlRHhZenGzmPiaV9idjCzlQUZ3THj6jBhIeaPLC5TPYi2QsIxSGkwy2E/ILbnlMFj9KbwqkGJ0y3HntkgwNICGapjC/0/rXSrrBfZY1rTJfxpcj0mq4bl+OXk1Awn7gbLgsL0Ias8CCOxYvnZuvwYxe+iI400nf+t7tgcbV4JnSGy9kgK4wQ49o3DH67oW0qpC1vJU04yBhITw9ixOW4SDqPWsKunFwrMIOi/8BrDMHOQ+6ApCwa+TKnasEEWluCcWQS9P3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZ3WZTFhEalopcRJPpTULhUWyTPBm2CjF6AbP8n1PlE=;
 b=Q3FYHoU4gnVXf2zb1xfUfzrH2wgwDEdhatRprjyd1YzcUmtHvJuRlnq+aSWm6cOogA/g2t0/6EwFzn/DKR3n9bdtCUvbJtEx7K+AZHaRXuMIipNbbebW1cNCY+M93wo6o+sak/RfjPlfEWDoM2WmoO0HpJBV/gj1m86UvHS4vUY5qX1bQAOvDjBMdvjSMQ0Hw8kuw6BBQK2MGjefJ0UhbabwTN7R3rjoLRP6PzT/aOUEiGkoR0AKgRc4B7/N2AjSOVB7wYqyvJnzcPGVUJgYDAv35R8zZL3VrDbad4kTclo4+B+3MYnXkjXY/cXtU7/E5BrAQj/HMhBm59ACEbMmrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZ3WZTFhEalopcRJPpTULhUWyTPBm2CjF6AbP8n1PlE=;
 b=WhNF/lyY6ZWoh/D6gltrPYhnz9lkU/If2XDlW+qRXO8GuN0zZxuHtw8A8Wmj0PYK8E7Q8N4rzgPL8m+lKvi39twEB9jNcGBdSFZ6pgjzgOFNGA88+GVOtRu2G83Tzy1JW4YSEmXC3jDWmI8VJ8xGn+uFJkOd053QF7UIGW4bIcE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:07 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 18/27] xfs: remove parent pointers in unlink
Date:   Fri, 21 Oct 2022 15:29:27 -0700
Message-Id: <20221021222936.934426-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:217::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ff1e38-696e-40c5-5397-08dab3b3ce81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4X+TajCJD++Q4/tzK0alK/TUwX+FY9bGivrBJGJLt673F+zfH5IthA49lh70Qn8aUkQO7ExlDrnGbMdyOIgSjKb4kylEy3ESfxN7XEferIXiKjh/LGS7oYno6fvlaD2pzl9CW6t4IihP04tPcpoer9RmHwJ1lXjJbp0Ndw+xPut0MwbsFyQl6TUzyWolhY2JSY5WFzLNiCJQYYEFPQBsj7moxsj7pCAr7qDo9wz5NJ4FejISVU6q2hHU/59VP2Ym4Sj+T40WXEijnwYoxB1sqDimi1r1NFyOuV9Yp1mNq9Wpfwu6seF0fdeu7DQotS7S3F1nKB/QHPqCZR94IjR3v3oA04pkP0WSZo69dRHRZjXIXb+qTqVSaD/x8K/XVEpRFLERYbZPV3A+aJqx5khNLoibKtRdxw1K493z9fiPZyB2l5Ez2deqpofEOdFjiXM5E03BLPqTqi9oW9uBWxJkETJyQKbTBZ+pL2tLi+/cTYmQsV43/IviZD0iOfAL45cJpMSRP+Acwk5tqFkYQb5H0xSOMTRQY8AV7WRM2VO1iuAVLB5LeHCUNy37FOto3to4Kwuuc26oHsgVcIV22N6D39AUTXMPTBBaPMxjXkuahi2HjuG7t5EkHR7xJjqAq8TANzwRW90sq9L3YJofP4FtBs0m6AxP/ODdL7C0CeZ9Ax/iNvNcgQKlUYerZf25w43CEwyth7YfuGndYQLoHvvRcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WBrGLt3pIeZpo20BNvpD2ofLe3owZRacYinmH9HroSLrJeR8iiR+NNDRJhGT?=
 =?us-ascii?Q?H6+T49Lb1r7VD/YrKk+mYk8FFKZb5U0ArMFdQJ9cVE7gE2NSXUDMSfxtFFAO?=
 =?us-ascii?Q?U+xxFoGXv9SXEIu6+0FMj2kqZllIists59h9+v1nYuSrftYx1PBSz7pfwV6g?=
 =?us-ascii?Q?d7MeLkQkQdIKvTz3JP1kjNF82fyqHJ+tObIipSUFdT/G5XoSoGbUcLpIeLU1?=
 =?us-ascii?Q?TtH9tNWKVdH+S3BEkDs9htxoHnW1LPzCtdP6XZ2Iupjl4Sr6k7qaTm4Xsdvd?=
 =?us-ascii?Q?UsCtUMbfXBpWKudxJ9AMLKBhUK/8xXNBRUMOxqDFmUFdCUFGqar+xpthlrMQ?=
 =?us-ascii?Q?GO0xo5u/nLlJjyQ9RbPh50xA8AUDuezldC6+ajM+KTmMGpIxUeG7bIxN2+UD?=
 =?us-ascii?Q?ABQOPzw7+8hpbd1ivhddlVHQtTDfHwdYwiT0OfDrDypLpvuot5g45R2hnoDN?=
 =?us-ascii?Q?TriNdg9dZAJq072VbqJ9ZZfkb4TM2eS03LlOnhkhZLIZPCL0SFRee70i9T6K?=
 =?us-ascii?Q?gMiEynH0ePCmTUTXDc3slCReGPwYndJQCXjNtkZYs5Z31N3GDzEkc+jmz5s6?=
 =?us-ascii?Q?LsOUOFN44zNEU0sR5F+ahnn4kTZmox6VROSBCLjl7a/gK4KvO9z3S86p5RtE?=
 =?us-ascii?Q?Bsgc7AruPpaHfQOgckQ8H4eJUnxB6EE9R+lfL1NTxJA9pQhUDvdK3ofV8bUH?=
 =?us-ascii?Q?WPyeE+dFCP8r+87ewygCnD1B6mEdWsc2I0wybwYOKcpKVN+GCftdskSpIJr/?=
 =?us-ascii?Q?oC0P8I/XerO9GrxLy/YBoSlGTTGspUVS+fCm42/DPs0Kczdzb966gh7W9l0C?=
 =?us-ascii?Q?j12EhoSSCJWGTLKlH5bsFsBFzrrbpLMc4NS8Ik/qoYQ/dB9jnCWiwJOjdq/6?=
 =?us-ascii?Q?B22e5ih2lH2zzUEW6mhYu4rgEn0IEXFA4OpVYSPCoMtkHen6DNbAiLBikVBr?=
 =?us-ascii?Q?r9vwQKYNgKFAdNwTWcmlIwmQOI1FRMOOyWGvDq/T16ISUJPiR/XXRu6KTA9W?=
 =?us-ascii?Q?HUgV3REgRZeTIIs9E0ooWrASvONfBfMGMZJg0Yt44eZjxplJxTf6LcB7X/90?=
 =?us-ascii?Q?9FuM9I8rG5i/sq6EWVWKhcA8bgL9CfvLAANzCtGwlVaq8kykf2T5dWXHA2f8?=
 =?us-ascii?Q?Cz5l6Er1FONQ/+n5tNzZ0PyAy4ImoAkeSYbQSGhDlawX4QX7MGikJBs40FbF?=
 =?us-ascii?Q?Sk/T7xBAaZppsDCf4mQ9B+HWTqxHzj7QPwEwGqopFoH9SGnh+X/TFi8Tg1Jh?=
 =?us-ascii?Q?P0SdYSSLajOv/B3n+AU68SiLbikkaJTgB4iF/TZeVLn9sttzvwegFq5tn5dh?=
 =?us-ascii?Q?PThFCZZlJ8gcC/za9sJlW9SP0vaKbuQ1dYpPUbaBeq6EqalQSiMWMk+zjCwC?=
 =?us-ascii?Q?I9XsuxvrdYxNiIjoAAQrgxJCKmZtCFwPDR4d/FtAc/RzGjmUryvTcmw7hjCr?=
 =?us-ascii?Q?MUlAaYuufGs2AFlcEsAnMSS8jC7IaLXoHudVmHU0GVtLRbmF1L/8hXxn2rib?=
 =?us-ascii?Q?dyNpMsg6attxRo0UP0s7iAv7/AQIOMzDDg7ctaCAOfZwJxCBySKcRRWEdx91?=
 =?us-ascii?Q?9rs6w3eporOQ5pr4tLFrUufrHsTIV7BDVzRe/+ACiSIQ6YkXvJr3B3ITpDi/?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ff1e38-696e-40c5-5397-08dab3b3ce81
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:07.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5iGJBXKRMIoODiLy5iNxC9+jYxn4vN34l4ch6RrDxyqX6jgQid9OlV6U7INOjgMk0LV0yZ+iAyhiCHJUNm3YdiS0qb55H4E75WRSPel3BYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: a8aBx3v9iLPc6H4OzQyiKVYtnRmLzU9f
X-Proofpoint-GUID: a8aBx3v9iLPc6H4OzQyiKVYtnRmLzU9f
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   |  2 +-
 fs/xfs/libxfs/xfs_attr.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 17 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  4 ++++
 fs/xfs/xfs_inode.c         | 44 ++++++++++++++++++++++++++++++++------
 5 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 805aaa5639d2..e967728d1ee7 100644
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f2e7da1befa4..83cc52c2bcf1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2472,6 +2472,19 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+unsigned int
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
@@ -2501,16 +2514,18 @@ xfs_iunpin_wait(
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
 
@@ -2525,6 +2540,12 @@ xfs_remove(
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
@@ -2536,12 +2557,12 @@ xfs_remove(
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
@@ -2595,12 +2616,18 @@ xfs_remove(
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
@@ -2625,6 +2652,9 @@ xfs_remove(
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

