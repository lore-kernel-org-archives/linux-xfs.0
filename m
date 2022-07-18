Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6FDCCA481
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiGRUUo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiGRUUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79EB2CCA5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHXfan024556
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=siMQJNZfSeWLQlzG5I8xst4ASguhdOApHe0+h3FuF0U=;
 b=oSiMSzCBhBokcDad/zkAO6bGC3Q7Pd5iFFk/kLKlY11ARLOWB1/xHHykesJN3y+D5R1l
 zV5HWotJNvvY4sAUmQKcffNHvCJZzYuRxS2gGjLDkPBjMYpahGMiizYBwigQDY3mgYI5
 J2vkSSdP0XGoJjrLiZhqc4teIopMKA+K7936/UlNBjSCYekPeovrPbtkzFjGAz7cbMDJ
 5S8L+CQKzYvX+qjyUFgeT+B6n+oCky6ZxY5xKKqyeyDJ+PKLajz7knY45Qy38kMnOj9u
 kw7C8XLUhZpnE3y7OQFVGOqdUXrPmXqS9sjhnM/Ir5S3hyScGeFjSSK0+uq6btidfR2p uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbm42cej3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4tD001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCsWoldUpIbiDMc6zWqWwLZYZUQ+S/gh8+aw1URIsNZOy22QfMPYt4lEpsliCGMf4VyfKBH8FUbTArFe5QsgulTxlo6p2zTskGBmgl/TWthLaflgpdEGKV/kv05d2zzoUey5QgG6Am7Cild0Co//C3XTYMW4pHdd7f7BtlzUargVx+KHCq+/jR5JuCYZwHudE3mdg5C0mTcMN70KtpKvc7uRhhzmW8nanupW25IDg23sLId2/6xtyKs/AjZWm4Gw82xuP7gNvwYQ1v9Q1XdGYMtM4kTVjxyPyfnZF7W0kEnsS2iRmNEiUp/HrOXwyoepZw7oRTgmlt+cC6KZEk6J8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siMQJNZfSeWLQlzG5I8xst4ASguhdOApHe0+h3FuF0U=;
 b=eLZtuY6DaIaBX8T7e/lblJiv15xpGmNWQ9DdtiuSmG+0IFJdE1u8/ic9ZjSfxZf4gAF0cCtH3/v7e/ij87ezeQclSQegi72GuLUZ9fqlSD01oMPkba9z5hSAmIV9FBkuJeXd5jCl/oQ51UyTmhGTfxGNAAb8Qd6pibV5P1MaGgmrX8ZzKLcGV/+rz2vFjrM5ESbR/nQ2yY6PXYJvfDT/TXF4yeIOyO9fzxu7nuezrwIC8gv9e1uM29JgFpDc4dxF3AtucoMsTdlrg6eS9ASmo/XMwSQug24Rs6xcx3IB/s9YsRuXn9aAQGr3Szy/uT8zjrilFV7nYvoh8FSeFQ+9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siMQJNZfSeWLQlzG5I8xst4ASguhdOApHe0+h3FuF0U=;
 b=S6xziLFm6Le7Du/FsNae3uLbk9/q19GCCPlpoB3CN4d++WRKQaSX3YVUWQck9oywpRH8JIKSuw+1KId0a1UJ3zzzX87skOX4qh03tlrl/c7q7nWEQbvUCL92YZY9rOBVl9Qovw/Ug65N021EV0JJYhDBXeRSllHNla/uI9Umau8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 10/18] xfs: Add xfs_verify_pptr
Date:   Mon, 18 Jul 2022 13:20:14 -0700
Message-Id: <20220718202022.6598-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c430d74-8d2c-4507-6b22-08da68faf6bc
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5YOI0PYpIZ8kVeUfTYVl1MJSM4BZ2XHH8uy+yxWeYV+KvUU0SkSuGaO9a1SYl9Ot+K08ZKvPDbWqDNaoMNh22/aaU09pRzIq/9cUbZB85xffu9WZWS8zKB7lJATvoYs4OET+hDI9TxQAAdLrZrDSx8X7tIiN2x+usk1lWpQtP04tK90l248v2hI571UXH38Vm4NQDpatFL+3IKbx1dAot2ZqwnGl6xBYGMyYX6GxF7Rs/G18hoF4NIs1+lzso9GNVnPRTSXgPEsk3PqYeddkbH4n6tYOdmXbq6hceWk+1y9lfw5EXR1md01FvWtoNl1Dl5q3cYRLZfghjZYUR7jiA6D8VdLb29XGTKCWUFcK+U/z+/9C1V/e7qZZXiGsuzbBGcQbCrbw/73J1aYBSSDHt9a3WscLcnDUEpJ+Z3bzWAc3uFg1QWMe13ZVtHmphIcBQ+H4RgUZ2xfj+B05My2U8ktFOgCVQuYYG7kLr6zGCG1lMyjxJ9QN9qPfwVWSaDUoID1e7jvzOP65i2EWyHdbcjMQUsxz3/dUoWysavPbjfbSnR4LjR6LwI0DOPGxQ4Tdl0p33Rl7GuEw6Tl2WtITUizKYuoq5xGfrDvk+8rp0CS6J0fJor05SkGlF09mlm12dcQfusPI+PWdFSnYpRXVWst+Hf1VG9xoVMylrnSZzIkSRzE6O+ZNgF6irCzLcu4xYvK6mUg5lQOH4zdSzoqUnL6By/R2mNWHkXyG9AyMUkYS2Y3ebOoZ2uCiFPob+lJKQLsekALLN42byOaP0rfMrkeI4stXbZ+PZm1PzXWTi2Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f7Urt24pgGHucuNTmgsdsd1bmIVBMDEmSMTX8SWmK0qjG+24KG51OwQySAoE?=
 =?us-ascii?Q?ZUIHPorvGi154jWwvTrrLWEJqXXBXRvuSsruuWmzpOeBOG0M7pXHxSl0cmsi?=
 =?us-ascii?Q?vWoc4nzMKT9T3CHmBdqu+Fd94qXr1mvYBY3oNWocbSPNDE5kZHiASdRnOHk4?=
 =?us-ascii?Q?p2eetfuWS9Tf0IOYxZf/9IZndlP5ArIMJoMzoO+Y+q1EB/O3gYJHJ04LzHTL?=
 =?us-ascii?Q?YdNRONCEZDHyr7E0GxmKSqkumJ4TG0U0QanRVREqRHFWqvcTizUqEEinz9B8?=
 =?us-ascii?Q?vu1s6Ga2vINdM5iw+yCw+hSZV6MdpvNHAu+lNCKMoxxw550CGWOibcLGI+0D?=
 =?us-ascii?Q?x4eckTxI5jCT3xZM8pfAx1N8quArLxqGa5Fr01D0L7Dx+8UqnrTl0D/Q85ic?=
 =?us-ascii?Q?yOwj3L7pyGOBPawXgBvjK4N+Jr7VlEQMAYAUByPc2OUJX02vQFysGN1+oZGi?=
 =?us-ascii?Q?GN8pFs6usLFpu/KPzvO8cQGd8cUe8abxjc10F+bIJRXClv0BQ+i55Ersz6qo?=
 =?us-ascii?Q?iesjeRzSFOrjCROujGgY2vDjIvwOPEjOnTuJsCUi32AP8IXJWJPnxbNXFqGJ?=
 =?us-ascii?Q?RI/88kSVvEx6mxCYgqS3GYCH+UJSC7u+v40tmineZqqrKaHwjxwxN8UDtzcb?=
 =?us-ascii?Q?0KPjS5vqC6KIJDijk68wqyBR5A6HOYtiC8NDpSo770h6mXfL2CduqHx8pHbP?=
 =?us-ascii?Q?6Lal9dfdLGyWfAPucvV/cF/LHZ3uIT1jS29ZPoH8gCadAMiF1dGHdO/qQYIK?=
 =?us-ascii?Q?bDmi5bExMwIrxL+rIdI/avQUEqLdhUqh3VHmRQI0okH2doKEJFrefV0AOIay?=
 =?us-ascii?Q?J2Mbcify4dzqID8zibMyuU5UH1PXyjpstFG68RkjfS21uPP7QkgOxRTL/+Ir?=
 =?us-ascii?Q?6CZXs7SaKqHo+asKYyF8c0X+wIuTQZFQyYeRSzWEA0rdIf0HSgqteSCoyJxV?=
 =?us-ascii?Q?vV2s1T4frruekHQBnHhWc0YmqeyFM/8R50+h6GDcXIC3B3LrcxsSrAmw5PXT?=
 =?us-ascii?Q?pAx4M8lFul6uHLtTArtp1FrusOiptKYBVDwujyakIv0xGUEX2Lx8pT5DcVJr?=
 =?us-ascii?Q?e5OXRCeuAiAZ6pag47ppmBzxZTbECOtBw26xt/1pAPxDu7hAPQ6DaF/QShCF?=
 =?us-ascii?Q?XDbKSZFRpZWCXlczglHhf6BLfRrfQSkqBKgblBRixczuAkANLrz8w7Z772lM?=
 =?us-ascii?Q?1VPOhsU/Er3+SHMRsepOZNhpYwzMEg6NwnCrsN82ew2hQmPoAHRRx5vG6n4J?=
 =?us-ascii?Q?bSxYru8Ri1gfsCeyL6eSG0aIZLoroKMRh4nAnYGJun0lpdBI7JaqHgyEWWix?=
 =?us-ascii?Q?s4ULXldbVsdq08NCLac3QaBGeP5/hUhw6u5ItTty8z1hTvj3ha/Tm0op67i6?=
 =?us-ascii?Q?3aDzsNzDWPVZi6vKvOIHMqyBwiZ6xxvj2/5kA70gDosmM7UumcCn+62kMm8J?=
 =?us-ascii?Q?qd/g6EBs3qWyNgv1lJHE8WhLdsSQGvWjgMVYrAxNYQUYpAhHtjsCuhnazJ+e?=
 =?us-ascii?Q?ofSmjdyBJTSyXQEiF6e2rZJdWEHkyF5fIo61AzHZQly0Lgt1Rj6uO8o0i/ZK?=
 =?us-ascii?Q?JOI5UddEu4zPbfddQQCvj1HcnHWHxXHK8BWlOTYxKZH+3iwq18Xf/8/eL0GI?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c430d74-8d2c-4507-6b22-08da68faf6bc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:31.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Af3XRAuV3HFqicutNhRx9R/QaBQtlxSEWjbjFCFNpz4kQJHh4qB0Llil+c4PNGvoShqk41opcIMDrRKK251gG0SmlTLGvRo0wbNGVPL8REk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-ORIG-GUID: 2euazDK6h3VE08hgwtarARMwvtlQ2cEB
X-Proofpoint-GUID: 2euazDK6h3VE08hgwtarARMwvtlQ2cEB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h |  3 ++-
 fs/xfs/scrub/attr.c      |  2 +-
 fs/xfs/xfs_attr_item.c   |  6 ++++--
 fs/xfs/xfs_attr_list.c   | 17 +++++++++++-----
 5 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8df80d91399b..2ef3262f21e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1567,9 +1567,29 @@ xfs_attr_node_get(
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
+xfs_verify_pptr(struct xfs_mount *mp, struct xfs_parent_name_rec *rec)
+{
+	xfs_ino_t p_ino = (xfs_ino_t)be64_to_cpu(rec->p_ino);
+	xfs_dir2_dataptr_t p_diroffset =
+		(xfs_dir2_dataptr_t)be32_to_cpu(rec->p_diroffset);
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
@@ -1584,6 +1604,23 @@ xfs_attr_namecheck(
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
index 81be9b3e4004..af92cc57e7d8 100644
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
index c13d724a3e13..69856814c066 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -587,7 +587,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -727,7 +728,8 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
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

