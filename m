Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C307C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiCWVJK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344869AbiCWVJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8278CD83
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYFfC019841
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=kGezlg8gqla7EuQSkZGImy4A/03G3+dEO9hVIn8OwbY=;
 b=bYJBkEE6ObpanA14c2c1eeOT950JgiNF6/z7mfeNh0C8PfD2enmFXQ2fuPrHuHjP1arG
 G+B6AgGNg/sMF5gvkO/QZkgmkTw6nuPLxaFQ79ANal2JNsyTn5Vx4Uky/UP1EDZ5M87Z
 6e5YPX4VLKJcHTv4jrWCu8mA63jw/8wpJgxj9IugXRIJIjHo5lwQX5GtJxjjdsfYQb4E
 tF0FTSFKtlfff/qQSPy1p9VhOjSQX4emCL+8lFZzTjl/lh1TdkhRRN8lD1fvb4ScOwFc
 w9lRLuuT9haFYDu+8xwINWC2hDVHaBdp92xsdmAJPPwGgC8USnwlfvFsdLT4kNrDp7Bl bQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcth7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6LdB082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmksIEka6DAOCThJUwVOo4+ZDcyBPZO7AIdTuwxw36H2WPYdjZr8j04lEga2VfhBfbiBWhsVYQcl6DW5MKtljgrDt82pIWqgvWtUG9fiTRPg4gVWSN0ZxcFDvp9Dxpv0TwuFK498884N2vmpNaydo2eMo/l8nLc5lc0/2U1DdxRkPW7Pon1woEWeU52xW8blY7RQGN0fdS6sioqgZqWUZ/xU5IweS1k76OCqzj1FTGI1EL/MsghPMTkmTDkHbj0KxD++kUlVO3zArtz2ib5qBhrUr3AF/vck5O5gCcGBVQcWw1L9lk6zQct55EmMU8YgRoGIkKix2TMynkPST/r2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGezlg8gqla7EuQSkZGImy4A/03G3+dEO9hVIn8OwbY=;
 b=FEL1JjdTPVptnjVxRyhHqwRuno0QUQfjNwTVjbEq7oM29MGVfDDksp6GSHwCq51+PvgAbpnEo8Rg3/MdGM4mkID6tWxkRTU3mNYbEubD3WpG4BN/kqYH/X3rvJA+buaQL3YQJb4gQAuih5UdW9lT5lDbu8sgPzM7Ccc5CCFuM0LO/HMLGYAKIXv4jprr0S4fKCkWz3IESh5VNgvZArvjzqB0GY+5uKXiUQ8DwJV7waDWdsi4kxOlFRrHPIWFasR+qHg9w9/WyLQycMHVrG97knevJTU4hNvXdc8hL650FNBKMQQIDekFXbZ7+kVDliWmNndBaExm2PSpBlmbrPCrKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGezlg8gqla7EuQSkZGImy4A/03G3+dEO9hVIn8OwbY=;
 b=JNdwbVGpUmYj21X/1AMKgKJ6d5ZWqNYQKxPkO3OvleilXvsw/J/ZhVrgw8s3W2u5Tc0AKbYPVmF0ccDnrZbXKSiCaFooXsQa0wk5txVxfB5gf7pnMwLMRqTSmLCz/hlfWRsPqHKc70QEuuvVynF+CDFccvi8eNmmy2EMn1XOZSs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 04/15] xfs: Set up infrastructure for log attribute replay
Date:   Wed, 23 Mar 2022 14:07:04 -0700
Message-Id: <20220323210715.201009-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fb9415a-fd6d-485f-e9b6-08da0d11209b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744E364C15D896575B0986795189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5567dAhLIzi1Unrf0vPQAyhGCq3vF3OAlC9/2Jjkr6y2z7nY2m82cSJHSe9D9WbQ+ntS3zNElN1CRmK3BHXCaiUeNkvHsArcPcgvM9J9kzH9cc0U1YwRH8IDbkgx/x2KSGJeSbVj1sGMXG3rv2SrTwJy4pdKxoMCNLDzOsxEKtOkmN3KyhgCzWU0QXCKchSQwhLHgHXZeTvvJ0ZTxZVC1eYVdAuCgAAaLmIP1h4Yq7oBsv0DYXaNLKadzVZPLSzL3HRsdVx+y41e/MmMGawWeApdV3BzLf7XVSZ+X/wKeYq5L1MN2/0M/3Ro1NLbHIb+bYgLJXUQ6HMrqMwyYmYghhfpIqTTTI6l8eximQwOscW/I8zIXX/5A5MV+W8+mnH897PjGpoSMH/vqRcoLujdaGkX1TC03ZPA5D2mrWHj/AXQG8/D4hRQm9xB5rV2SqNcO34FlJPzjbZBT5Ac8+fCQTGTW8vQsoE8ErqiD8W1j9ytC3KpaDkRSjLjeHx8/0JGhB9zYTkh6TBJg8U3aWCqpqlAnMMDaGP7a38qpGkZC+v/1CYDsCC0sbdRvo3kKcIz1tg+vlM4d3IAiUNsjMwnIH0Dzo94CVcYEMM++dW26bupLp6Qy7DlHRb9IdT90JnhgTAUkbC5MGotL/vvF33oCI/8j/iOZQ5yOwPWjh2+bfGjV682hI+eF7yISQWh7QpZbFpMjXL4YPlMZpM8iEF5Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(30864003)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oI7+suMhBakMXeY0Fdo0ymcx26ChL0fUmPJZ87FoId288QlCYNlRJPpM8zgv?=
 =?us-ascii?Q?+6OHVYOpbfEFRGuEtt1XMOzDHiBniNinmugkiOOJki4JD27FNwjUxL/kOJkB?=
 =?us-ascii?Q?khXvK3FO/AKvo5VRW7fSeC5DSZSvltV8+BEGbCnzA36pWi1XEztRbJJX8KpU?=
 =?us-ascii?Q?JEzarnk+xKPYeIWbPRvJzFaha4iF2Ja3+JCyKzLLMaFy5B5VMtvNI8DAiGdE?=
 =?us-ascii?Q?Y9iObqGWNTKbfmVVsEdjIAZN+IWFD0uWs0OgqNbsIdaHyQXLj+5Uu7wq/Q26?=
 =?us-ascii?Q?/FKzQcfUQWu+9PRHMaY+ouuaxELa1m28itQitd605gX6MhiPfCrVKI6JIKIP?=
 =?us-ascii?Q?2ndvUqWGSEMYgoRJm9MhgW+vEtNkvaPV+cai9EjoWQDw5NhK4zGejDLoNzG4?=
 =?us-ascii?Q?k9Ayba1CWp0UrjDIfIVl4uLRJS5CbTVXfBgVaIsWgPkPKS2Yyp/AaXo6740R?=
 =?us-ascii?Q?Ua5SXcdT1J31KroSCqAsqkTSCpBfgiZRw1+5lT15moAvWNwpnu0mMRfVBZx7?=
 =?us-ascii?Q?NYvNLs4Pn5yI7+KtK1giMd301/9jJBzk9PDRBm4wmgta4ejJWGfuhPzKZTRM?=
 =?us-ascii?Q?99xBIp0OzlHhT+2NxavuJb4jD4vFuvEg0lm3rF+sST+x32sGLGm1fhOAOP1u?=
 =?us-ascii?Q?X2Z9PI0hzKoovhxQIFe2PvJbZ7f/JUdnHxk8kMkjaZTjHggtC9JaYVtX5CDt?=
 =?us-ascii?Q?j7kODOo48xte5TOc7Z35E/+I0c+nZs/93z/Arf7ZMCwhGcFsAmVd5bogvznk?=
 =?us-ascii?Q?I5sxcHU5+lAQ2Sz3jZwcPswyXwqG6xRZaLp5L8vmlXWhZMkhZUSe4XQJD0EG?=
 =?us-ascii?Q?kVtO3Woob1cTGilFgckTUY9QGHNcYjBIjxd/zrUTefsctJw97yQH50zCN6vc?=
 =?us-ascii?Q?3T/QACc58vac+MOP+1m7g/j/e6ceKSf89uYul+zGI4/V09OuW1ZTupoGmmni?=
 =?us-ascii?Q?ksGrgCu4o+uyutkxhEczmK2sKvItFW4ctzmu3yyjfuTuoznbBtCl6Jvf0+WK?=
 =?us-ascii?Q?YVUGoWkBN5eBr8DPeB8QNNuW5dtGBdiSxaL68xDCwzyzTbQTvv3s+wCEk3PW?=
 =?us-ascii?Q?FOFX6I2oC7nUrGlKv1F3yEy9vSBMWPDIUmwE4ldiYt1xP13E1j1Lhb1GAn0m?=
 =?us-ascii?Q?JLQnFO7VTh8Lhu/4mYny5AlU9grfJzu2MSmRdMnpEPDn9chkP78QVab0yQRg?=
 =?us-ascii?Q?SPc5n7hFF67282NGZyvIumua3UIEvBd8KezRmwTPMsQb8R8/K4jQXSIBu9HN?=
 =?us-ascii?Q?aNEw3JICIYYO/M2akEaK895AmapQo5F2f5FLGSJGVSnEalG1xCzE+l0Cl7U9?=
 =?us-ascii?Q?fENRxnqcVYv/wMkjVTE/tAyRPb0G5tNpVK9lle6UCt0lnlLjdHQI0+jEuXmB?=
 =?us-ascii?Q?+ucVKlByUzNmjiq3rwCVe2gvSyJbW35aR7NvMKxaGaj5ConBMOo1KNkX79Ac?=
 =?us-ascii?Q?+mfX0081glUiOeCu6/gkiZolGt90iIoffU0XpWsmnvkbfp12v0e+kA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb9415a-fd6d-485f-e9b6-08da0d11209b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:24.1068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xjbl1n4w2TQaaakIV+aM/soyrydzJLQBkAnlOHR02LnbJvmnr5nDMXfOmYhggYUCY6xbG26wX4cGe8GNRWNtNFrAMdSO9FgbP0Q5qFBvTSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: XiUYrVgwhKFmV1WSehZ9i86DAavZjkbA
X-Proofpoint-ORIG-GUID: XiUYrVgwhKFmV1WSehZ9i86DAavZjkbA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently attributes are modified directly across one or more
transactions. But they are not logged or replayed in the event of an
error. The goal of log attr replay is to enable logging and replaying
of attribute operations using the existing delayed operations
infrastructure.  This will later enable the attributes to become part of
larger multi part operations that also must first be recorded to the
log.  This is mostly of interest in the scheme of parent pointers which
would need to maintain an attribute containing parent inode information
any time an inode is moved, created, or removed.  Parent pointers would
then be of interest to any feature that would need to quickly derive an
inode path from the mount point. Online scrub, nfs lookups and fs grow
or shrink operations are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item will log an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name, value,
flags, inode, and an op_flag that indicates if the operations is a set
or remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        |  42 ++-
 fs/xfs/libxfs/xfs_attr.h        |  38 +++
 fs/xfs/libxfs/xfs_defer.c       |  10 +-
 fs/xfs/libxfs/xfs_defer.h       |   2 +
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_attr_item.c          | 456 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  46 ++++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |   4 +
 fs/xfs/xfs_log.h                |  11 +
 fs/xfs/xfs_log_recover.c        |   2 +
 fs/xfs/xfs_ondisk.h             |   2 +
 17 files changed, 661 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 04611a1068b4..b056cfc6398e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_buf_item_recover.o \
 				   xfs_dquot_item_recover.o \
 				   xfs_extfree_item.o \
+				   xfs_attr_item.o \
 				   xfs_icreate_item.o \
 				   xfs_inode_item.o \
 				   xfs_inode_item_recover.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23502a24ce41..21594f814685 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -24,6 +24,10 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_attr_item.h"
+
+struct kmem_cache		*xfs_attri_cache;
+struct kmem_cache		*xfs_attrd_cache;
 
 /*
  * xfs_attr.c
@@ -61,8 +65,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-			     struct xfs_buf **leaf_bp);
 STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
 				    struct xfs_da_state *state);
 
@@ -166,7 +168,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
@@ -837,6 +839,40 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+int __init
+xfs_attri_init_cache(void)
+{
+	xfs_attri_cache = kmem_cache_create("xfs_attri",
+					    sizeof(struct xfs_attri_log_item),
+					    0, 0, NULL);
+
+	return xfs_attri_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_attri_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_attri_cache);
+	xfs_attri_cache = NULL;
+}
+
+int __init
+xfs_attrd_init_cache(void)
+{
+	xfs_attrd_cache = kmem_cache_create("xfs_attrd",
+					    sizeof(struct xfs_attrd_log_item),
+					    0, 0, NULL);
+
+	return xfs_attrd_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_attrd_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_attrd_cache);
+	xfs_attrd_cache = NULL;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 5e71f719bdd5..80b6f28b0d1a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -28,6 +28,11 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
+static inline bool xfs_has_larp(struct xfs_mount *mp)
+{
+	return false;
+}
+
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -461,6 +466,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/*
+	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
+	 */
+	struct xfs_buf		*leaf_bp;
+
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
@@ -474,6 +484,23 @@ struct xfs_delattr_context {
 	enum xfs_delattr_state  dela_state;
 };
 
+/*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_delattr_context	xattri_dac;
+
+	/*
+	 * Indicates if the attr operation is a set or a remove
+	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
+	 */
+	unsigned int			xattri_op_flags;
+
+	/* used to log this item to an intent */
+	struct list_head		xattri_list;
+};
+
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -490,10 +517,21 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+		      struct xfs_buf **leaf_bp);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+
+extern struct kmem_cache	*xfs_attri_cache;
+extern struct kmem_cache	*xfs_attrd_cache;
+
+int __init xfs_attri_init_cache(void);
+void xfs_attri_destroy_cache(void);
+int __init xfs_attrd_init_cache(void);
+void xfs_attrd_destroy_cache(void);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5b3f3a7f1f65..91adfb01c848 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -23,6 +23,7 @@
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
 #include "xfs_buf.h"
+#include "xfs_attr.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -870,7 +871,12 @@ xfs_defer_init_item_caches(void)
 	error = xfs_extfree_intent_init_cache();
 	if (error)
 		goto err;
-
+	error = xfs_attri_init_cache();
+	if (error)
+		goto err;
+	error = xfs_attrd_init_cache();
+	if (error)
+		goto err;
 	return 0;
 err:
 	xfs_defer_destroy_item_caches();
@@ -881,6 +887,8 @@ xfs_defer_init_item_caches(void)
 void
 xfs_defer_destroy_item_caches(void)
 {
+	xfs_attri_destroy_cache();
+	xfs_attrd_destroy_cache();
 	xfs_extfree_intent_destroy_cache();
 	xfs_bmap_intent_destroy_cache();
 	xfs_refcount_intent_destroy_cache();
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7bb8a31ad65b..fcd23e5cf1ee 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -63,6 +63,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
+
 
 /*
  * Deferred operation item relogging limits.
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b322db523d65..3301c369e815 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -114,7 +114,12 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		30
+
 
 /*
  * Flags to log operation header
@@ -237,6 +242,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
+#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -252,7 +259,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -869,4 +878,35 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+/*
+ * Flags for deferred attribute operations.
+ * Upper bits are flags, lower byte is type code
+ */
+#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
+
+/*
+ * This is the structure used to lay out an attr log item in the
+ * log.
+ */
+struct xfs_attri_log_format {
+	uint16_t	alfi_type;	/* attri log item type */
+	uint16_t	alfi_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfi_id;	/* attri identifier */
+	uint64_t	alfi_ino;	/* the inode for this attr operation */
+	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t	alfi_name_len;	/* attr name length */
+	uint32_t	alfi_value_len;	/* attr value length */
+	uint32_t	alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attri */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index ff69a0000817..32e216255cb0 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops xlog_rui_item_ops;
 extern const struct xlog_recover_item_ops xlog_rud_item_ops;
 extern const struct xlog_recover_item_ops xlog_cui_item_ops;
 extern const struct xlog_recover_item_ops xlog_cud_item_ops;
+extern const struct xlog_recover_item_ops xlog_attri_item_ops;
+extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index bf1f3607d0b6..97b54ac3075f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -23,6 +23,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
new file mode 100644
index 000000000000..394ef4497553
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.c
@@ -0,0 +1,456 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Allison Henderson <allison.henderson@oracle.com>
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
+#include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_attr_item.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_trans_space.h"
+#include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+
+static const struct xfs_item_ops xfs_attri_item_ops;
+static const struct xfs_item_ops xfs_attrd_item_ops;
+
+static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attri_log_item, attri_item);
+}
+
+STATIC void
+xfs_attri_item_free(
+	struct xfs_attri_log_item	*attrip)
+{
+	kmem_free(attrip->attri_item.li_lv_shadow);
+	kmem_free(attrip);
+}
+
+/*
+ * Freeing the attrip requires that we remove it from the AIL if it has already
+ * been placed there. However, the ATTRI may not yet have been placed in the
+ * AIL when called by xfs_attri_release() from ATTRD processing due to the
+ * ordering of committed vs unpin operations in bulk insert operations. Hence
+ * the reference count to ensure only the last caller frees the ATTRI.
+ */
+STATIC void
+xfs_attri_release(
+	struct xfs_attri_log_item	*attrip)
+{
+	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
+	if (atomic_dec_and_test(&attrip->attri_refcount)) {
+		xfs_trans_ail_delete(&attrip->attri_item,
+				     SHUTDOWN_LOG_IO_ERROR);
+		xfs_attri_item_free(attrip);
+	}
+}
+
+STATIC void
+xfs_attri_item_size(
+	struct xfs_log_item		*lip,
+	int				*nvecs,
+	int				*nbytes)
+{
+	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
+
+	*nvecs += 2;
+	*nbytes += sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(attrip->attri_name_len);
+
+	if (!attrip->attri_value_len)
+		return;
+
+	*nvecs += 1;
+	*nbytes += xlog_calc_iovec_len(attrip->attri_value_len);
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attri log
+ * item. We use  1 iovec for the attri_format_item, 1 for the name, and
+ * another for the value if it is present
+ */
+STATIC void
+xfs_attri_item_format(
+	struct xfs_log_item		*lip,
+	struct xfs_log_vec		*lv)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_log_iovec		*vecp = NULL;
+
+	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
+	attrip->attri_format.alfi_size = 1;
+
+	/*
+	 * This size accounting must be done before copying the attrip into the
+	 * iovec.  If we do it after, the wrong size will be recorded to the log
+	 * and we trip across assertion checks for bad region sizes later during
+	 * the log recovery.
+	 */
+
+	ASSERT(attrip->attri_name_len > 0);
+	attrip->attri_format.alfi_size++;
+
+	if (attrip->attri_value_len > 0)
+		attrip->attri_format.alfi_size++;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
+			&attrip->attri_format,
+			sizeof(struct xfs_attri_log_format));
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
+			attrip->attri_name,
+			xlog_calc_iovec_len(attrip->attri_name_len));
+	if (attrip->attri_value_len > 0)
+		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
+				attrip->attri_value,
+				xlog_calc_iovec_len(attrip->attri_value_len));
+}
+
+/*
+ * The unpin operation is the last place an ATTRI is manipulated in the log. It
+ * is either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the ATTRI transaction has been successfully committed to make
+ * it this far. Therefore, we expect whoever committed the ATTRI to either
+ * construct and commit the ATTRD or drop the ATTRD's reference in the event of
+ * error. Simply drop the log's ATTRI reference now that the log is done with
+ * it.
+ */
+STATIC void
+xfs_attri_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+
+STATIC void
+xfs_attri_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+/*
+ * Allocate and initialize an attri item.  Caller may allocate an additional
+ * trailing buffer for name and value
+ */
+STATIC struct xfs_attri_log_item *
+xfs_attri_init(
+	struct xfs_mount		*mp,
+	uint32_t			name_len,
+	uint32_t			value_len)
+
+{
+	struct xfs_attri_log_item	*attrip;
+	uint32_t			name_vec_len = 0;
+	uint32_t			value_vec_len = 0;
+	uint32_t			buffer_size;
+
+	if (name_len)
+		name_vec_len = xlog_calc_iovec_len(name_len);
+	if (value_len)
+		value_vec_len = xlog_calc_iovec_len(value_len);
+
+	buffer_size = name_vec_len + value_vec_len;
+
+	if (buffer_size) {
+		attrip = kmem_zalloc(sizeof(struct xfs_attri_log_item) +
+				    buffer_size, KM_NOFS);
+		if (attrip == NULL)
+			return NULL;
+	} else {
+		attrip = kmem_cache_zalloc(xfs_attri_cache,
+					  GFP_NOFS | __GFP_NOFAIL);
+	}
+
+	attrip->attri_name_len = name_len;
+	if (name_len)
+		attrip->attri_name = ((char *)attrip) +
+				sizeof(struct xfs_attri_log_item);
+	else
+		attrip->attri_name = NULL;
+
+	attrip->attri_value_len = value_len;
+	if (value_len)
+		attrip->attri_value = ((char *)attrip) +
+				sizeof(struct xfs_attri_log_item) +
+				name_vec_len;
+	else
+		attrip->attri_value = NULL;
+
+	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
+			  &xfs_attri_item_ops);
+	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
+	atomic_set(&attrip->attri_refcount, 2);
+
+	return attrip;
+}
+
+/*
+ * Copy an attr format buffer from the given buf, and into the destination attr
+ * format structure.
+ */
+STATIC int
+xfs_attri_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_attri_log_format	*dst_attr_fmt)
+{
+	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
+	size_t				len;
+
+	len = sizeof(struct xfs_attri_log_format);
+	if (buf->i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+		return -EFSCORRUPTED;
+	}
+
+	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
+	return 0;
+}
+
+static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
+}
+
+STATIC void
+xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
+{
+	kmem_free(attrdp->attrd_item.li_lv_shadow);
+	kmem_free(attrdp);
+}
+
+STATIC void
+xfs_attrd_item_size(
+	struct xfs_log_item		*lip,
+	int				*nvecs,
+	int				*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_attrd_log_format);
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attrd log item. We use
+ * only 1 iovec for the attrd_format, and we point that at the attr_log_format
+ * structure embedded in the attrd item.
+ */
+STATIC void
+xfs_attrd_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+	struct xfs_log_iovec		*vecp = NULL;
+
+	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
+	attrdp->attrd_format.alfd_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
+			&attrdp->attrd_format,
+			sizeof(struct xfs_attrd_log_format));
+}
+
+/*
+ * The ATTRD is either committed or aborted if the transaction is canceled. If
+ * the transaction is canceled, drop our reference to the ATTRI and free the
+ * ATTRD.
+ */
+STATIC void
+xfs_attrd_item_release(
+	struct xfs_log_item		*lip)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+
+	xfs_attri_release(attrdp->attrd_attrip);
+	xfs_attrd_item_free(attrdp);
+}
+
+STATIC xfs_lsn_t
+xfs_attri_item_committed(
+	struct xfs_log_item		*lip,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+
+	/*
+	 * The attrip refers to xfs_attr_item memory to log the name and value
+	 * with the intent item. This already occurred when the intent was
+	 * committed so these fields are no longer accessed. Clear them out of
+	 * caution since we're about to free the xfs_attr_item.
+	 */
+	attrip->attri_name = NULL;
+	attrip->attri_value = NULL;
+
+	/*
+	 * The ATTRI is logged only once and cannot be moved in the log, so
+	 * simply return the lsn at which it's been logged.
+	 */
+	return lsn;
+}
+
+STATIC bool
+xfs_attri_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
+}
+
+/* Is this recovered ATTRI format ok? */
+static inline bool
+xfs_attri_validate(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_format	*attrp)
+{
+	unsigned int			op = attrp->alfi_op_flags &
+					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+
+	if (attrp->__pad != 0)
+		return false;
+
+	/* alfi_op_flags should be either a set or remove */
+	if (op != XFS_ATTR_OP_FLAGS_SET && op != XFS_ATTR_OP_FLAGS_REMOVE)
+		return false;
+
+	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+		return false;
+
+	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_name_len == 0))
+		return false;
+
+	return xfs_verify_ino(mp, attrp->alfi_ino);
+}
+
+STATIC int
+xlog_recover_attri_commit_pass2(
+	struct xlog                     *log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item        *item,
+	xfs_lsn_t                       lsn)
+{
+	int                             error;
+	struct xfs_mount                *mp = log->l_mp;
+	struct xfs_attri_log_item       *attrip;
+	struct xfs_attri_log_format     *attri_formatp;
+	int				region = 0;
+
+	attri_formatp = item->ri_buf[region].i_addr;
+
+	/* Validate xfs_attri_log_format */
+	if (!xfs_attri_validate(mp, attri_formatp)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	/* memory alloc failure will cause replay to abort */
+	attrip = xfs_attri_init(mp, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_value_len);
+	if (attrip == NULL)
+		return -ENOMEM;
+
+	error = xfs_attri_copy_format(&item->ri_buf[region],
+				      &attrip->attri_format);
+	if (error)
+		goto out;
+
+	region++;
+	memcpy(attrip->attri_name, item->ri_buf[region].i_addr,
+	       attrip->attri_name_len);
+
+	if (!xfs_attr_namecheck(attrip->attri_name, attrip->attri_name_len)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	if (attrip->attri_value_len > 0) {
+		region++;
+		memcpy(attrip->attri_value, item->ri_buf[region].i_addr,
+		       attrip->attri_value_len);
+	}
+
+	/*
+	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
+	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
+	 * directly and drop the ATTRI reference. Note that
+	 * xfs_trans_ail_update() drops the AIL lock.
+	 */
+	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
+	xfs_attri_release(attrip);
+	return 0;
+out:
+	xfs_attri_item_free(attrip);
+	return error;
+}
+
+/*
+ * This routine is called when an ATTRD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
+ * it was still in the log. To do this it searches the AIL for the ATTRI with
+ * an id equal to that in the ATTRD format structure. If we find it we drop
+ * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_attrd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_attrd_log_format	*attrd_formatp;
+
+	attrd_formatp = item->ri_buf[0].i_addr;
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+		return -EFSCORRUPTED;
+	}
+
+	xlog_recover_release_intent(log, XFS_LI_ATTRI,
+				    attrd_formatp->alfd_alf_id);
+	return 0;
+}
+
+static const struct xfs_item_ops xfs_attri_item_ops = {
+	.iop_size	= xfs_attri_item_size,
+	.iop_format	= xfs_attri_item_format,
+	.iop_unpin	= xfs_attri_item_unpin,
+	.iop_committed	= xfs_attri_item_committed,
+	.iop_release    = xfs_attri_item_release,
+	.iop_match	= xfs_attri_item_match,
+};
+
+const struct xlog_recover_item_ops xlog_attri_item_ops = {
+	.item_type	= XFS_LI_ATTRI,
+	.commit_pass2	= xlog_recover_attri_commit_pass2,
+};
+
+static const struct xfs_item_ops xfs_attrd_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.iop_size	= xfs_attrd_item_size,
+	.iop_format	= xfs_attrd_item_format,
+	.iop_release    = xfs_attrd_item_release,
+};
+
+const struct xlog_recover_item_ops xlog_attrd_item_ops = {
+	.item_type	= XFS_LI_ATTRD,
+	.commit_pass2	= xlog_recover_attrd_commit_pass2,
+};
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
new file mode 100644
index 000000000000..c3b779f82adb
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Allison Henderson <allison.henderson@oracle.com>
+ */
+#ifndef	__XFS_ATTR_ITEM_H__
+#define	__XFS_ATTR_ITEM_H__
+
+/* kernel only ATTRI/ATTRD definitions */
+
+struct xfs_mount;
+struct kmem_zone;
+
+/*
+ * This is the "attr intention" log item.  It is used to log the fact that some
+ * extended attribute operations need to be processed.  An operation is
+ * currently either a set or remove.  Set or remove operations are described by
+ * the xfs_attr_item which may be logged to this intent.
+ *
+ * During a normal attr operation, name and value point to the name and value
+ * fields of the caller's xfs_da_args structure.  During a recovery, the name
+ * and value buffers are copied from the log, and stored in a trailing buffer
+ * attached to the xfs_attr_item until they are committed.  They are freed when
+ * the xfs_attr_item itself is freed when the work is done.
+ */
+struct xfs_attri_log_item {
+	struct xfs_log_item		attri_item;
+	atomic_t			attri_refcount;
+	int				attri_name_len;
+	int				attri_value_len;
+	void				*attri_name;
+	void				*attri_value;
+	struct xfs_attri_log_format	attri_format;
+};
+
+/*
+ * This is the "attr done" log item.  It is used to log the fact that some attrs
+ * earlier mentioned in an attri item have been freed.
+ */
+struct xfs_attrd_log_item {
+	struct xfs_log_item		attrd_item;
+	struct xfs_attri_log_item	*attrd_attrip;
+	struct xfs_attrd_log_format	attrd_format;
+};
+
+#endif	/* __XFS_ATTR_ITEM_H__ */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 2d1e5134cebe..90a14e85e76d 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -15,6 +15,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_attr_sf.h"
 #include "xfs_attr_leaf.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 004ed2a251e8..618a46a1d5fb 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -17,6 +17,8 @@
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
 #include "xfs_rtalloc.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b34e8e4344a8..dbf8acb03c6d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -13,6 +13,8 @@
 #include "xfs_inode.h"
 #include "xfs_acl.h"
 #include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5010ce712a3e..0b346162d851 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2156,6 +2156,10 @@ xlog_print_tic_res(
 	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
 	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
 	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
+	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
+	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
+	    REG_TYPE_STR(ATTR_NAME, "attr name"),
+	    REG_TYPE_STR(ATTR_VALUE, "attr value"),
 	};
 	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
 #undef REG_TYPE_STR
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index dc1b77b92fc1..fd945eb66c32 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -21,6 +21,17 @@ struct xfs_log_vec {
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
+/*
+ * Calculate the log iovec length for a given user buffer length. Intended to be
+ * used by ->iop_size implementations when sizing buffers of arbitrary
+ * alignments.
+ */
+static inline int
+xlog_calc_iovec_len(int len)
+{
+	return roundup(len, sizeof(int32_t));
+}
+
 static inline void *
 xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 		uint type)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 96c997ed2ec8..f1edb315e341 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1800,6 +1800,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_cud_item_ops,
 	&xlog_bui_item_ops,
 	&xlog_bud_item_ops,
+	&xlog_attri_item_ops,
+	&xlog_attrd_item_ops,
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 25991923c1a8..758702b9495f 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
-- 
2.25.1

