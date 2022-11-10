Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A46C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiKJVG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiKJVGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0151358BC3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:24 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b71006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Di06yN/J5gxhRRjbBdXnIYzpKmWO//LWU7suDDP27Hk=;
 b=nXdEzWeoAG2nay4kb3mH/hdLru0dHNVUosd2iL0pBmHB8nGnIttwrIM3NKzJHIKk2UjQ
 C0tyQoc/qY0w/EHDXmhUgIML+wHxXoxL3tMAPufD5sSqVJyppVPWC2xZTdWHtP77T6oC
 1ElZxJqLtab5s3lFszHZ3w+lF6USAsSjYV4ZIXA8T1jVLP9pAxTdHBA623O1Lo5w8E9O
 oCNoB4PSjhErORskkkLIk1moBbrUimQ+iRij3lQAzuqFFV86PQbFH64GoFjAiro6UTNZ
 cpFawSLDkw0U4ZiM0GXoH8wX15zc/kNmDIOf2m9KfRHjnqbHZEhRGnQQFEbImHTun/6/ 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r16a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKhsFf023087
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcysesn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1M4JDryrSYLYNAN4Igfm+jfnafXnWet8gvBRGswvETovOKUwFNNINE6c9Lt4sbfZ7Mk8C4Q/Npii9gCLS9SwmuFIX+w8HzCEbRojfhDFeM2zIN/vRPqSYZ5jySQYziq8wgaahe5Acsob2tCaaE6z8hofwZKUMZrJ2hoVhXN+55KVf5/lMq743CDGmEOYGKABdJaUUfJLE95c8ymal2H9xlSGrzLdeel3cXhoKUcKt29ZiecWqAl3fU22Ua9ZCUmByn0Z6hBZjsqvOOpVedm/uFk34Ncy9u8OgNbFRI3+OSpvH2iuItV7vY7h7CURsahqEV8Ljhm0NvQ7i6whG9g+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Di06yN/J5gxhRRjbBdXnIYzpKmWO//LWU7suDDP27Hk=;
 b=lVrI1vXzdh/abyv3xjmKFoOp422YlGj0KXpPr4BjtT6wlMcRr8+lntt5PS4KhmmRrQAoSknZzPS1s2PefelVk+1im/jf+WyMer0y90e52hgm96BGR3GZXMKk3GQUJGUz1J6yARBcLlZOVednIhROJik2nFHSf02oVBvrpBE4RJUKJXL2YmZuTh+EQouF7VX+FLXyc0TNhxeDsQ3WHDKTPFguZQ2yofQ9xKyCLBZDfIbOSsG6BioQYT6yF0y8cYPW1VD2V4QThVB+4aGCc4fOyXBvVwKu1sqZVLIb8LigM7P43rkgyh8FUQcSphFubiZyJx6j3dHmdHVxzjZPUy+GAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Di06yN/J5gxhRRjbBdXnIYzpKmWO//LWU7suDDP27Hk=;
 b=RCta4PFk/fEwz1wq71QFQpsNxTb2mgKxdW10B5MnZE+utr0B/6KmQPslg0ucOmt0hp1/V5oUi4EOOhgWuZn0ljP7+UzH62UcO1/jRkZfkKbEnq7Abd6oDoyLwqcoqDpMkvrrT8PYzChQgimkSRNjl+4JQeqk7oLbdfVKBXd2Giw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:05:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:53 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 16/25] xfsprogs: Add parent pointers to rename
Date:   Thu, 10 Nov 2022 14:05:18 -0700
Message-Id: <20221110210527.56628-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0039.namprd17.prod.outlook.com
 (2603:10b6:a03:167::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b124d2-81cc-43f1-92fa-08dac35f5a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WU4wBklfVVsgCBpuh3XKWLNGWs+anoVkJfXXABh44cbDyXrX7HEXq8SOly5WSJZkP4HFymv8YbxJSnWYKZNgFsog6z7hQto1WCOcZ9DnuNouPcA5iUFyfFDBsivYrXTtAvjQP/O6anpyPxMjAAmhuNu2pc0DMBH0oksdimi2Aus3wETc/GwQFTfL4nFK20jXQAJITLp4zPgAsCwzoBQFY+s2TYpywUVJ2zeo+Mn0K00TKWOP3cnm4Yy/yWDF9lvIF80PhNYjf8bPQYMpmsYryB1V6z55Ee033+gTqZMoMUmgISeD7ZjCHbpAFGUinxmD6vwbyd2xdS7p4aSQnJrLdQ/qYCe68yPGFc66DoBBXt8P3b7TEY8ZJMwcR2Zg2LngAKrH61ygl6RaiHJKcXYWU3PaTenLKSj4ceZ0F42dMaetl7QZIhCK4xRbiC3EHJtEtVH3SpqgxFi+Oc80+KAxKKr/+8DDcIbxmL654lrU20n1/ni01p/htBBqHUBCVi3YyQmdraxjl2MJYQRt0o3ugndahZkguphJFJm1URsjCTk1V2aDCMvz08bsgBlEHmG3KhgqDxQ3Qtpzg8o29roCJxcc1yJ+om2o1j8uK56MXd10MEYincpJkpR+vfKKx6qoY1R6YggHTMKXwIy7k6DKPmFBK9ZHjFZ35rR4QLh/wClXVpeccUz78lsZu8eD2Z4dMc4uLdpN58MDqxLRHYoJEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8qVzSBT8+lpqpyFYQt4N8H+d81nSDmzUIstEB638O3OINekOuCna/YGC7CF/?=
 =?us-ascii?Q?S2Skxd8M25kajRG03BnpI4rqeef5gZPeK9bF/WSqfq1ruwmffbKwYmO11Io1?=
 =?us-ascii?Q?c01ZV4EbGktYHGJIROsFOXZNOH7oc2HTsFJ0nNcF9DoNmkduJqIB4ZLNtx2Y?=
 =?us-ascii?Q?DquAT3cE1OnlSx8lp8xC/7v9Yd+tnEtz1kXfNQBESEutL1qjoE7FenO31Fls?=
 =?us-ascii?Q?mE41bt6wUsRtu8Oug6t7bCq9sMaoJzXVVNYHRCBg/vs0jM6UjTn/TrRVswB4?=
 =?us-ascii?Q?OUx7eU5wbsFQa9UZsQvz2qBhRsYcaEUVgPULb7iXvRqFc+BkA8mcvUSLEPtw?=
 =?us-ascii?Q?miehTfYQyhv8eaeB9bvzwse4f76VjL2RU7O4BPl2Iw+jDl/PpHbMmJAEuhZV?=
 =?us-ascii?Q?x3N8zcj8KlB4JgAdHFCJFsgbDy8GMj8FdTmadAgNdlYp0zhqDFQUapiklJ7K?=
 =?us-ascii?Q?Kt+NEiv623jGKgbjIBeWm8whDYrvqeznaPuzT80+jfQGUW/DvxN7wzqIVPP2?=
 =?us-ascii?Q?vHfJVCACdf4o29qPaQKRjAeNJJKdFqZhpu5p2QMnpogSqjv00h7PK75pwsPV?=
 =?us-ascii?Q?Bv3PdyMwGj6FG6Jcepgx3r4Xxs0MyDMLhmr8W30bOUv9qPJsZ7CwkOWQDj+W?=
 =?us-ascii?Q?j9N5odhge6BbaywJNnEwXNnmOu/Mk9S+RuOScAt01ChisBN5psAvBeIGP35o?=
 =?us-ascii?Q?z8n19HPjrf3ZNhi2XmclG7ebpqvoaKgJcRNEdo92ZQx4BfteK/UEc1yNgt8k?=
 =?us-ascii?Q?aWhGqCHKihPIC31HEmB+tAKBpUhjSw/iBPDUy/cGRHDuc8y3UXRoGC5tihla?=
 =?us-ascii?Q?QKg6ofgmMcNP36CnK89VTL8D3kpMZM8oLKdI4EgxTAej6qFnWfW13lb00h6y?=
 =?us-ascii?Q?zaTrLTyHiJydCoR2jgREasnX44gl7I94Z/U/60KjnBc0pYg4s7apasFDiZQn?=
 =?us-ascii?Q?dpSo3l3Q88FSS19aNcxkIluTj6+CCafCL5/gqCd0gGW/NE1XLRP8bA8GgqqR?=
 =?us-ascii?Q?hBWpNnFeIqEr2NCGEdcw4bBYLGSli1CFzLKQk6pnSvRoAffANgxdq/6x33R7?=
 =?us-ascii?Q?eC2IjpPVxIFpuSQsS+nWS+Am6u+z+mV8iwnlswkMjld12EhkKpvhH+QD5T5X?=
 =?us-ascii?Q?OfbOz4a2csnkyK5e6CXQwFadnAdDolBBFc2rLky/u2NED09Bb+1acWdsp8ii?=
 =?us-ascii?Q?QMxkYt+ScJRqPLlw9b4vB+CgIHyMdNwpdyEaukgOcqBLb77cLd2RFnKuuVRL?=
 =?us-ascii?Q?JKxI1Ap1W0G8kvVsWP2OMESlO5ZlP3Xlo2d/jE6Bk7Z6k9ftFVZ5G/bkMnev?=
 =?us-ascii?Q?1vuKMYfIY5hKbua4sJW/H1Stu/xMrgEHoVVvkJQxzLv53O2epp+Ezsuu7Zst?=
 =?us-ascii?Q?XUpSKvLa/uKJEFqfq8SzUvA614HYHWqror6Bc30bKki2ONcNzXkVXCgQaMGE?=
 =?us-ascii?Q?ZKzCIgu5qFbqXjPjjtEH941PAJ6f4qrZ7ZST2tg254xL8cWZ+9DqlHTmr244?=
 =?us-ascii?Q?ulbSxOGslJGbB8QGtR3p2m6W/k9h8wUskgWXh/jj5MfZMD5/l98wp2Lgo6q+?=
 =?us-ascii?Q?G3Hff7qJbwbgLnDLBhZDlcFXY4K6RtKRPlVW2bvyNVZTaYZ3kD0gWCiV/Bng?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b124d2-81cc-43f1-92fa-08dac35f5a28
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:52.9045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKlp0xjvvr6ZVDm1Vo1MQRnLIjlxZq6JckGBVVmMM7YZ8mLFuZG/ubLxk6WGb/mgtqorTgzjlm27M4+NXqKSf0idjA8ywTzB4lzSeYKVQUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: D3Bbc88SMjT7cU6yk1Ckh_F5x7mHYcgk
X-Proofpoint-GUID: D3Bbc88SMjT7cU6yk1Ckh_F5x7mHYcgk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Source kernel commit: d00721b30fd1923f6e9e9c1ca6f2a74cfc4ed5d3

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c        |  2 +-
 libxfs/xfs_attr.h        |  1 +
 libxfs/xfs_parent.c      | 31 +++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |  6 ++++++
 libxfs/xfs_trans_space.h |  2 --
 5 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 04cafc5f447b..0cb76f8f37b7 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -921,7 +921,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 033005542b9e..985761264d1f 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 4da2e1b1a1d2..f9513cde3b01 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -143,6 +143,37 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*new_parent,
+	struct xfs_inode	*old_dp,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_dp,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+
+	ASSERT(parent_name != NULL);
+	new_parent->args.value = (void *)parent_name->name;
+	new_parent->args.valuelen = parent_name->len;
+
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 1c506532c624..9021241ad65b 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -12,6 +12,7 @@
  */
 struct xfs_parent_defer {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	old_rec;
 	struct xfs_da_args		args;
 };
 
@@ -27,6 +28,11 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp,
+		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
+		xfs_dir2_dataptr_t old_diroffset, struct xfs_name *parent_name,
+		struct xfs_inode *new_ip, xfs_dir2_dataptr_t new_diroffset,
+		struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 25a55650baf4..ab2a07b70e3e 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -93,8 +93,6 @@
 	XFS_IALLOC_SPACE_RES(mp)
 #define	XFS_REMOVE_SPACE_RES(mp)	\
 	XFS_DIRREMOVE_SPACE_RES(mp)
-#define	XFS_RENAME_SPACE_RES(mp,nl)	\
-	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
-- 
2.25.1

