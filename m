Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1B0C6FA91
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiIVFpd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIVFpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEF4857DA
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E6iT022056
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=5AweqyAZ0GLulUAUJwA3rdfsXeDrY0vBwoCjRMTWk0s=;
 b=IY9Bs3y3h92rwpZhzaqN1q2l988Pb8cV4u92JL6cqHllYJHsPNOallT24qWw9nfESqsw
 97+KT6P/b6nxUh08GeVN5bsAyLXdBeJfvPLgFP5tUvtmzkxLEjfhgM5WGtecmN2Yn8MW
 y9uxUmwfUKSVnNpcRBT62dXtHkGEjAauP4obVy+kUFsHdsni/QK1xNa8bvuXBEK4k82B
 D+cwq4x4BaIi8bC1kumGn10q+4l3BNApfsngj+af91NEOqVBER+BUnkHA7dLm+pvmd3T
 HLl2tBA4jqbiycsGSwY3M5tBb0UILU1HvKhx0s3zQTsdu9/RoXwYNhiVnwX6FfVduk3O kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M5e6Cb034206
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39fmur1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVIkLEeV9LJfz5CKVf6T/KYQ9imWkblUpvf28Xy0r/yF+bq0JRZeLPgVLJUajm4+kPzYDQd/LzctqDof/APZqf25P3C+uzbeAj6ThZGI8LkA/qwyoLt971B6uYlfkilulxXQh4PdkMZNTn2vH76QqmnOez74fedSIMc2eQxfYNt1v5aLHGahkmK5l1qoXY57/iJuWQ3KKQjE97l7WX56wMl8HOwfgBsoq0o/YHGqzUB7/1PpP02ET6alob0qn0ry1nMt1bqWF/J50c+ZW/bXpU2WoRrY5UI04vCutXL3wc6Rh6ES2TfznDDoeswuX5FxvrQCTuwRjzMF0R50r1r7uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AweqyAZ0GLulUAUJwA3rdfsXeDrY0vBwoCjRMTWk0s=;
 b=OGx+qq3BpcbFzdlBD1i1HbQVi/DsWAqCVXMx7bZD5XErdQuxjhkTq90PP71ogrmFMZInJTlJjXwgfrryzA2hIxLUklWmrVGqNCdHMT6jBO8bPRip5i3WjanEMaMfqrB7iYy+322Wh9dtyyzI43MDswO6mMu4cRuCxfD/pYXi+j2BJz7S9HyKgvdBNCn37SfqmoYCcdgIkdCLhL4fuMbRnYkSslfkpEdCL5BbpHmpecAVGhqTuhHRwvUN09lemtHY3I9dU0qTDF7+EkZ0ZXcvpb5jkyk8PZWT/0lES3k3VPq8ZClP1hJCyfRZi5I50YefpGLqOpkr0Xr3dCsR1xFlCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AweqyAZ0GLulUAUJwA3rdfsXeDrY0vBwoCjRMTWk0s=;
 b=NTGcRVgAA+ytYdVQBzusYVd3RvbFXh+YHZEoO0kBBqLCsZihR0yRpM8ZUuxQ5xrOa+x+pq3X6q35WjrUVvDQ6RkLJGpXv8w0m4GYNc7KWHoYZHa+W4LXaVtixtrdHtjwH1GabwK50KnDMts5UMmevR08F6a8A/qsbM0s+AOwiHs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:18 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 12/26] xfs: Add xfs_verify_pptr
Date:   Wed, 21 Sep 2022 22:44:44 -0700
Message-Id: <20220922054458.40826-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 16a31fb1-2a1a-4410-b508-08da9c5da16f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e9ag49bpMjZ9PhXBUP8ziYx9IMhl9ZLF7Hm4tIxtPYapXUlLC3ODuyNcwC2IBtKV9X/dzJ0Y/TjliqB6y/+ACq7OjLDkDA32mrcgLQkkFkdiivqwfzymm08ABlJcijYDJGex5aTocFkK0ILg+pBE8El0v12KSAn3NPZgYP9Tk7at1F6h4fhOXLEt+UWqyvkAWVZgOAFflgESVRBN9hvsenzqrMldoGhDLPPXehFUZ7kvONPIOImbcCK2d2EppoPCqAYGEVYsN8EdXUh1HWUNeDgnss9jPQ73GHlSHT2kbeAfUa7AUZCCM0mRvT4PymSyeCepM6RfYIEAA60c3mc+ABB6m3synyoXbAvZkDHJ+IgHBiS+re5RxRzNJqlcVGmzMmOguhxgBplALSfbULxFBbxdnM9r24QCZH6wSeec2XVspB0j++3wYcZPqmL15tVxUtVuphvY9Vr2jZqWMyLGLjuag0+Mfj+7beMg5uNc5L6mqCh+fNcgyjhWodXOC5/7aGHiXJ3vo1ViSGrww41CxDyfMRy+c+5FZQpSwJ3R8NG9x4raz1HMnl/vGPOs6wedgj0lyVQhR49whgKmGzTGankwWEgrSpQ5rYGkQhmN4GkkupbgT4/NfWIR3FdGyNLk8ndXbg0337tmvWn3Dm7hSyA0XagKFU5RumTsTIPL0dWST+Njz2EBQAknBXl3ijQhlW2rBbyHMo92l9wC72h0nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fetnRZ9PpjvJs8Vf6rE6t9qrtf8nGqNP1ruIUNYkq0hsztpXg5rwOPPQfLw9?=
 =?us-ascii?Q?w4PFzsJwTg4S3+N+ZLR89zI+0sXCllH39xpcb5SSb6AyadFoRpVMgum43t48?=
 =?us-ascii?Q?So2SgUqq8oOM3aZn6Cxhm2L8dam5eJaO2eB8o1KEgqveikB1vx8GqduaeGLe?=
 =?us-ascii?Q?3F1BcxzOGXCi5AdJBQ4kfskmO2rig89L3HqLOnmbXSMi7AY+hFHXAWNWSYm4?=
 =?us-ascii?Q?JkN/IZJsU+7V+itPXhLsmM+QUcTauNhPdhGY9nKWYkH1Z3wjokwHOzelU8Ch?=
 =?us-ascii?Q?ItbO1HdB0JbRCKoV+EElFyiJVUBBU5PcUQKfTHIJW61UVm/ITPqfppglbuB/?=
 =?us-ascii?Q?zU8WwteoQakcEYtKf1KpKLnquztEcaZA43ouO/wRxuuc2rA0IJBv1NNP6i9m?=
 =?us-ascii?Q?Zvm2305x0c8qwytVaShh9/oF6/PIVuip2iS4ZNas+wCLpJUXnV4xmTmm0T8k?=
 =?us-ascii?Q?U+JDg4RbHRB5+6Wwor6P9v0O5M1ndEBmVt60bo7FnbOlf0mOQUmzK+jNckgq?=
 =?us-ascii?Q?N5FRZgMonnswYbsOMgdTBIAta2qjO3eCgOnzM4JHLiwbpY9EuMGL6x/Ueqvm?=
 =?us-ascii?Q?2x5JsB9IA0OSZajKIrN/QHNFPjsYe8qCCu10AIAP7P74SmO4abkbGZ/yO83f?=
 =?us-ascii?Q?2ZuTbqBmDGRnq+6ZGitWp+o9Oslkrvj2AqOwgxah8i2tZ9zvsRgjv3IEVz/t?=
 =?us-ascii?Q?ThbnP9w3YGBjrtQQoOMuzT46s+cTOYmgD0Xj+bViLwlk2KWgc1Qmy6QZJa9m?=
 =?us-ascii?Q?e3yF31SjHADFzvdZ2rd+E+iUy29A5hevnusI784G+1tSTtGBNfiW2D104ZV3?=
 =?us-ascii?Q?VWF9ZKqcr2BPpLZgWi04O0lS9K6wvOmydukLFZRFBd8L0Z/6TMCak1ZQc1WG?=
 =?us-ascii?Q?F5gowDD0PzjT2GADA/VlXNWoWoEHnGyBuae7gdm1jPWWRRAta8woiQGoXBac?=
 =?us-ascii?Q?DduCXIKR/OE99JuyaYuTIgsKFa4R7tn1MsRYUkPDpw2zl1k4NdyP7PHwsG1X?=
 =?us-ascii?Q?R5LNyMvIjuEgU+cHbS/+wfzlDLPTGNbv/wmO+QLVigHmluM+MxTxxnTRiV+3?=
 =?us-ascii?Q?X1OINdziS/KxzYLWNW5oIOmkElp2maHHbVEO3wfVkOCDLYnYoN0YXVa74k/1?=
 =?us-ascii?Q?QTtO05kL/ZcGRlA2g3X+iF6djwOvlgRhoy6LO3X56fmCrxPDKaB9mFlo3JDt?=
 =?us-ascii?Q?aa/GbjSX3Hqq5krOOPgiouGAK/eQ4V+MjBO+1uYqwlWs7kAuwN1oXZJv/JXz?=
 =?us-ascii?Q?PDLuh0VgR+pEoOdMvHhrTKvdyBzarEMfDxdl3LSJOwFZh+1SFQ7MqzPrBjpO?=
 =?us-ascii?Q?ru7seb+H1VGGHpYAAOLDHFjNavg5rH9fy19anVF0xBfAJvVweqd2pRbTCxNb?=
 =?us-ascii?Q?ZQhjbF4GnYAqiHevecQkEHSb3/BcJYa5eIE39IeKn9xT9JpVpiGxCcsLXZzO?=
 =?us-ascii?Q?7+njdPRClqsxGgEhWOnWsd44UovBLxAxM3/4sy06OMLMcmtj63NMYGDme1JB?=
 =?us-ascii?Q?jw9bcYpVhBUCBdqLK9gAJnJK8UAMyPUos7V3lYkCukj8u8kQgqS8Ai5HTlVy?=
 =?us-ascii?Q?wExV8zXUvhHbJyBI+d4U8uZqct61RkFqrDA5k5OtMieTMLyJRRhRDZqLFFBP?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a31fb1-2a1a-4410-b508-08da9c5da16f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:18.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQBWzEDgfmuESsmNuXP1dw8GSbuxdhjAzJGWV97TeZ9VtepIkqjYfceB9Nzbie9vhg/QI3g3KN8/QkCv/PkaIxC5f0tdPRUlw64WtelWhVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: m3T7j6Nwheh2HBwGIX1l7H1Dnjxohg6c
X-Proofpoint-ORIG-GUID: m3T7j6Nwheh2HBwGIX1l7H1Dnjxohg6c
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 47 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h |  3 ++-
 fs/xfs/scrub/attr.c      |  2 +-
 fs/xfs/xfs_attr_item.c   | 11 ++++++----
 fs/xfs/xfs_attr_list.c   | 17 ++++++++++-----
 5 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 101823772bf9..0c9589261990 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1577,9 +1577,33 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount		*mp,
+	struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t			p_ino;
+	xfs_dir2_dataptr_t		p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1594,6 +1618,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e81f3f48560..b79dae788cfb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index b6f0c9f3f124..d3e75c077fab 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -128,7 +128,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9414ee94829c..6448b44ffc1a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -611,7 +611,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -808,7 +809,8 @@ xlog_recover_attri_commit_pass2(
 	attr_name = item->ri_buf[i].i_addr;
 	i++;
 
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
@@ -817,8 +819,9 @@ xlog_recover_attri_commit_pass2(
 		attr_nname = item->ri_buf[i].i_addr;
 		i++;
 
-		if (!xfs_attr_namecheck(attr_nname,
-				attri_formatp->alfi_nname_len)) {
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
 			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 			return -EFSCORRUPTED;
 		}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..a51f7f13a352 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -82,8 +86,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -174,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

