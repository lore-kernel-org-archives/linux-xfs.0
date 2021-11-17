Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3761C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA72F61B64
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhKQETb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:31 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3418 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233036AbhKQET0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:26 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH48Yqv032056
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Vs2324VHlpiIDxMTcqs5VSxok4tl1SDy12HGHdNmNTg=;
 b=R1xN1Jx8vf5FDXOsaZAL9G9GRI62w/FjrEdWwX5nQhVvMiQhrsgH++vdmkeWA/SUxpWf
 CmTNK3fV8XlUtRUsH4bbt2q1+V94cgW/827tZbEQYu7RozfFKpEuh1AfehBwL3XCrnrP
 eYX75rup0vEDLBwyZ/h0iPkx+t8OHRTvF9K1J1R6dNJX+Ah63XJujCOlQL4qfLU13PS6
 BcMjiHwFhll9js1xOn/gXAApEf5CehiJN48uMH0pHGdQ/1xOC4s5Sf56+iLH0lYFA2h4
 v+6JXNHQrKGlbHDHK7LdAmz8HrG1EvCMuOKAooeRnk075nB4Y/9hT4JsHneCc6m4qB82 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv86es3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKo180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLjjOEwJIysrHjdZbXhxljTLhPfdsdQhVcO7osWmVT4jpBEtXQL4c8ZVjw4ulgdRBaKODlF0tO2J3Pr82IA8qEj8K7Tcd+WDRzjLb2hWDYTwXrpWMLgi2GBRGJLbY/y4PSIGB1vmkvgFcCLHfXKCHFMnZqw7KzWQoCcBJFKcH6Osk4XJ7FIRitSh8xsG/eiR6WupR3fgyKDWfRXXFoild7LYm/Kaq7qHbJDATDaHif6wf/nlBk4N5j0VjIAuwpPdrk9mEM7Sn37PYo7pggLOYaAeKHvTtWLxzSkwl1wPN584xR2SC6y+Gp0dbaDexE1dL+FBOJNthEms1Fl7G6ir5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vs2324VHlpiIDxMTcqs5VSxok4tl1SDy12HGHdNmNTg=;
 b=a+qPnrKc/VzIh836kRNaYqcNilxEIox0kLLZSQMQnwS1uwafrqtBe0YqJ4dbvRbNusaV+r0epFF5x/p9/RL68Z1U+GP2w5k6SvPzYO3oOQYCE43L0j2qB26bww1oVZymVV9dHVwK6IBVOSRtCc7v/37afjNxRAW4hds2AsNBabaqFABd4DVxZCXsc0OvDTjQKhoKDmYCONQMvuIfLAfYp6Jls5zG4gbxUI3CEpbj8tkyOFtwNy8D17/qNgLgvbt1OkCWWltoAtUvaZyw+JLY3gF/PlsCtRMxTDI4c8HNx4CHQa708k41F0no7jaVPoAhKXg86KSz+PAd15C09Nl9bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vs2324VHlpiIDxMTcqs5VSxok4tl1SDy12HGHdNmNTg=;
 b=o5L15lyS9hEsyLd3OVTmng8N7y6SnAaw8pvnPBMSGqmSVa2XnLBNXwoIPKn5uQzTC3ijkVxt5Mui+xxqnVFhtVenQRV7iO1ITsLgIyOfUZ2ESrN9qGVXtXdi+GEhm3qnWS7xjDufpmLGMNziU6px/HPH1Ba2bySww3sSRGzY0KQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 09/14] xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Tue, 16 Nov 2021 21:16:08 -0700
Message-Id: <20211117041613.3050252-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 394d6dbc-39d2-4d04-7737-08d9a981039c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4036DFE9ECAB072193A82BF1959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E7YcazAQbU5PjotEzi2IgFJGN/SoLQ+QKJYa9h0lKWH+80MThyyt6AK4t7VQKcaCPFugI0+nh9WbBQg01qShXgLfK5jG6kZaXta/2R+Q5nNdGwEk0Ahz9FTgwkmpU9YIc+r4eTKzXjogR+1KEwX1BPSVaA5POqUTD+hCJX00I4TZjf06N/oK0uYYzKvel3TImQd02hC8pvr0JV4cMQl0jNvKidah8Hexs0XtuY4AuTToIl+uXRl4IqPx2revvfufBdAWDaHDSVqYwD1Ek2825CxCIOc/ij/SjjsKoJB1eNGnNo7pKviTnGzTaItsixwCHvJFrxrd8DYEG4+uT944E40YSyf9IMZ3fe9NQVqvKstqYyYKdirQgQezwKNf9hNOgI6noE+D0RltimTFGJLn21oIn5e4BDoi5BbIQ/JtTsbFG2NOczg8nZa9XNsx0d/Ma0KvAd5YM2M5Kdp4P3o8tlWjYsO+d8ZWFqNIXjoysd9eDkX9C70czEKpOeDD3WRMKgsJjheF+x/JghtSPrVbOr+ILhcnQu7RKE+A6eYlgM8fTHa4lMQkjYdfD8ElzBW5TMVsAYuBvTORBoS8bxTAwAVYWBaNV0AGumyUuG2mCQidmdMS2h2nxhRML75sufiWhxJ4V2vZjlUOcrUBPYjoPOYwmniJ5AH7ELotS6rk8M75yhxmPuvd3X8G7siwmzm4916LAzMrUUr2M6LMrvYJSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScgiB430Fkt4t+6L6nDel6DBtNTiyQRvZgUiKSXrsoBO1mKUFFyr5oJpnaMA?=
 =?us-ascii?Q?uJstQZAWDFaxpa7avHdKI5K0P0AAhPBO9pTJTnHgywcDbxoxGoCQBTwOrfg+?=
 =?us-ascii?Q?XniwJTjzXvF/JT4GuJ0NpbsoovtNofIRLzXj5bLBjBkqdi/yAstoy/EoJLyN?=
 =?us-ascii?Q?dAy4uqVbbBCKXeQ+wKu3//u34l9UAbTRDFzV5WPiaA2AYpyb0v6NE9dL/Lro?=
 =?us-ascii?Q?7CXErwyOoBO6spfQvGebgKcj0ExjohpA0FXgxj9FwMOihrN3n0BzHfjZHCxh?=
 =?us-ascii?Q?bvKv/I9gAcz7Pc4lgClN3VXAWIzCgcZ1hmhjd0ZFtjdcxItDIGaZ+i2px88A?=
 =?us-ascii?Q?q2iDBSGeRChiPPqVP5kK9CRXAWsd/aEX7bkvijw/TXXf3ZPc+Q+hg9WUfZSp?=
 =?us-ascii?Q?TeVMUlY7FPeSE9CecQYH1oBRML2LgnG4lD0qyW51UxGeVCeCnRelcQATrQzF?=
 =?us-ascii?Q?DjDLrcXNWAfTocQ2cYDgpzzVXWNz+nOh732vYqU3oHNZre6rMXCdxBpgiQ3B?=
 =?us-ascii?Q?vS0tFaxebeSEN9Wv70AKvNIsDoUnLccnTV7XSUVu/4qi7mEPiAlkSWUQFJUR?=
 =?us-ascii?Q?LzHbBSHeQeCDcVFeT+f49zXUp15O5eLpxZoqkkDLyo7G9lIiIzz9ezaLw2U8?=
 =?us-ascii?Q?TMK7DE2KSryOyGlMDC/bigtXONygPpYGl/3reXdAprHWnYPmYrnch5yrY+bX?=
 =?us-ascii?Q?0+PhwqTcJ71l18DW5T+q0jKaiUu2z/hnBu1ZrOIOuE+5NowdBi6vD9dv8ehO?=
 =?us-ascii?Q?WecITC5BNpMdYQ/4ibZWA9giXRtAoOl9WkFhbSvbudY5PrT+ZxZZ9ui6sr/7?=
 =?us-ascii?Q?xqD+COjJLknBq8hVbhw1nclPkuxKOMTJXkGHXz3so/Zxoqge7JmteOoSAf7C?=
 =?us-ascii?Q?lyEmeJliVNlw3BGUgsWY2xnVjJyMbXChnkPzxoHP/sKN6w/pE29cSCVx/ROt?=
 =?us-ascii?Q?P05Vo58kobRO9+r7EuIPeO6RYIVm/XV4Q2LC7p0chz1K9V7Ye7cnC1asyQ65?=
 =?us-ascii?Q?oRHCJC4VLp1RUXQxiWxGA+2JcIejyq2nxAxobXMk5kxqrkwjvYH1wz/cPJIR?=
 =?us-ascii?Q?cNSeGRkmLbt8po53oKFUACNCwSjW09Rn6uXrZUORWJ4U0tuU6IKpdtdzijrC?=
 =?us-ascii?Q?j2zOuwfdRj4pQDMXziMjk9T/a9fx2hID5ipFwu7kiPRihMGEV4bHqUhSehkW?=
 =?us-ascii?Q?novry7ZLT1kg6kVa0H8eLJRosX1PcQOhvazIEzvvcVENd246O34CpIzDtztD?=
 =?us-ascii?Q?0G9lk19bLYvKOFFf9GfGNxWTYDjMQ+CNdmfvt1Rgz4xBxpOpqfyzvNjxPQ7X?=
 =?us-ascii?Q?Dox0ikfem3wU6fdMVzQGHTmd0VltjZ+e76uu58JKmaEw0ryqPEwTlOYXZ0tD?=
 =?us-ascii?Q?kyOpKD4Lku2vTTi4WrjVWDqLA8pHXS1/UqQeK+p8Kg69zWotkZyTL8UpwJlo?=
 =?us-ascii?Q?dGnBkJzouAoP7HADHmxUzm2iqy+DgLfTaW1hIlAy6qSOBiczUqWlpNx8Ikyr?=
 =?us-ascii?Q?9ZWq6O4EtSgc9tTmiu69KsXjqS8bA66tl9n8pUQrzRR0jbziDkON2oCokain?=
 =?us-ascii?Q?zKRAJjwu4evIT5r13c/4DdZp7wctxuaBvmZ5SRWtPukWKQPO1s4gnmad9S+8?=
 =?us-ascii?Q?RSbhtk9ItXdjo/zKWbU9jthV7YcVbTmmsjORGzJMnKxNyWF//J2BaWwt4JMJ?=
 =?us-ascii?Q?Jn+5lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394d6dbc-39d2-4d04-7737-08d9a981039c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:22.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGLT9Rdw/FS4HtgB7iz5mbuEXo2zqKnK/qgWUWlh27UrxCuxh3u6LrREYeFD0kfZCLVjepBrMjcF9OhMTpF3PSpk9u4xPKe57sV6QY9xaZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: k3fUHgZ5TC6ykYnzc8EpeYsP1rj_96Jo
X-Proofpoint-ORIG-GUID: k3fUHgZ5TC6ykYnzc8EpeYsP1rj_96Jo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/libxfs_priv.h |  4 +++
 libxfs/xfs_attr.c    | 69 ++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_attr.h    |  2 ++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 15bae1ffde88..7f6dc14e476f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -609,9 +609,13 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
 
+/* xfs_log.c */
+struct xlog;
 
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
+void xlog_drop_incompat_feat(struct xlog *log);
 #define xfs_log_in_recovery(mp)	(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6306bcf1d1ba..806272017cb1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -725,6 +725,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
+	int			delayed	= xfs_has_larp(mp);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
@@ -781,13 +782,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (delayed) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -805,9 +812,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -816,7 +824,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -838,6 +846,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (delayed)
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -846,6 +857,58 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 26f67cc79082..4c48bd46bb32 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -526,5 +526,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.25.1

