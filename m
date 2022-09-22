Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD46C6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIVFpl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiIVFpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89480857DA
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E7kd022075
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ch3YrRsxTJT0UL6UhmM/Uvd2+mahkdHfP9EFGQ0Hc6Y=;
 b=wtb7UUfzwoZ6CNc+BdIjmfY5BloBuiaoJ0B0DovAY6z+B3dNUfbRwaF0+qc20L8zvqgY
 cRNc9zUoRfXX6lLG2NJ1mXUcKFainnCl4F0DrFje7zBJM+NWpyvCXRAqAJNTxXXmju61
 4neC7JNK5AW6FYP58QO+vd0o6g6lU6Mrb03ukeZkHd/Hh2sm5T5RRKMdfzA1MmJPwqu1
 3jfOKQqnh7JcadxLZyiaNeMh0PcCqeDdmrSYSH948h24uafci1J5MqLuqwv7mBErXJmP
 Iimv+ED2Mh1X4k7In6kZQxMwbzHcVUYy40WyyD1p8OIJJZiE4+VBW5WCijHuUtzp2C/a ig== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M59ZJR032487
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d46yc7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCP8hYsEaqIIy5iyS3M6Wg6tJm+5PiqbxV4WAqV2lEpVha9qKA5+TpVLsu2fNaLk0xRyiKqqWKkkJ5XoOrPU2oMh/xrKaAfdrDNlMwt7JFezjWxdvsItNGR31gpqKneAlx4NvmODrXcqvFBq0i+pUHvTMdJdCc2uuEhmd9TwZnoEioUEGbVYmeFE0xy4TiXSv83js7R4rW4PHrvt6i0FHGgUIlNhm+wtguc8CeqxqwNnoTjv6SDZVGyDm3Esxa93fehI+lEnUczbhKa7Ez2sGDZhuKogYI+bTyoc8m33der0V+OaMqZQX370MdEy+RuWmbPQwzEbuFH+QPThWraVUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ch3YrRsxTJT0UL6UhmM/Uvd2+mahkdHfP9EFGQ0Hc6Y=;
 b=nkQnBG/Ge3XoMZND+9iJbf6dOzG9McxNcBFjRxn/dF+H2vEtYaH2PAerLrSe/JE/ioGaAv7rHvYQuEaFmFV4yUhRgUiXgAxWbjXtNaFwg43o258W98lnHWAk1a9DhdELvoQbKn8uO4lWRb7hJlwzrk96aCsnpPEPgTxvycWOrd72ctbeI9fMg9fuUJWjYEc3H7whNj0wT8Q9SXsgekzucfBF9twg5T/HTia+74mA87JKdQnLKbeNK+IG4XoWv4OLjlNCWRmSb6ps9oSB8rhViXa4R/OQM4Et7+a7HrqwEptOXplIfbmaYjU69bOpvQcUP8immcuDkdoWdrNuanfi8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ch3YrRsxTJT0UL6UhmM/Uvd2+mahkdHfP9EFGQ0Hc6Y=;
 b=RSTrT8Okc1ZLhUmg/zUSZudSFAfu+gL3+9f6+QEmsy1DNxXHsuVjPHpwSHZkCuelzOxJnC2ddCX0XN7zeKA6S9SDwXtaXgUhTQTp8QSLAtuW61hx8GOUnMMigKaW0AakQn3MZGepshjA8VdJhz6eGr0bC2t2ol0saUsQ6iKVDMM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:29 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 20/26] xfs: Add parent pointers to rename
Date:   Wed, 21 Sep 2022 22:44:52 -0700
Message-Id: <20220922054458.40826-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:a03:180::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: caf0ff86-34bd-46ab-dbe1-08da9c5da80a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SX2vd6pfgptiYDKfQ7nQCBsBBWs1QZ0PxnHaUMe6gC7yxH0jx1A6k8IDjTCS/Z+j7OMTqS2zYTtPxJVJqn5oa1k9ElgVmuxa6Fqmzk/UnnNiMZeMFtS4toa1B3fRS3wlT+WyKUrPJOuVH3WTAzXFMacc7vCkWb2RH90k5oMcUy3g1O+8mZytHICiq3o1auy5ojGyUXkdkRxdmF0bN3UkzfrAhmzTMhwWIeIXBCMiaNsNwp1IIZVCoe/9WbM9w1EGut5a+Pkzi2EE/v3u2u0qcIeunxi5sHTYLeURLAHM4z4WBhWQCb4yUfd/1r065IN2ZFaSmepMzbRZFYcCW2GA3Nf2wnU13B3cyO2146jov7nrngzwXeYLjK7sdhmhfaXNYy4kSzaDCk4r05pbMKvVinLbcne78u132BQ0GjJTC+qmHR63c3hKU0dqCYiV5vjSSmE8bvjo8XAdgaatx97dbl4bnLuhMWwjxcnFuzfCr2qZujljk6nZwVQgrYbai8Ndv/abq2t0EjPiXoVuit0bj87t1uecnDkmVVKln9124Y0WLOGC9n7Tnw1Tht4Ig6IlogZfZYCo9ka0YsXuLgSyJpJrC8FvhKqO3DMGT6IeDls1wvpLjV4LSXp47BaQucMB38DpFlV1tl4ZqeQZxHKBkTYxgtPgc+WZihCR5l0xBNCVT/1sDDjTlzIkcD6t9c0i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?abRyPtLNuFGaGsFq8aBxqOvJbnWWvsHyeh2y4DdCHBHYpsxNYfd3S0hHEHnW?=
 =?us-ascii?Q?lyeqIvQ4Xmwu9yLRwmXC8CinHuzBzvzE73V+J+JNbBwNPXgG23wME648u7Xw?=
 =?us-ascii?Q?JzDtunksuYQ4AFXaNiallN5/Y6K8bG3fDYRe+KMzxvpVDZqUnGt+IW88X/4e?=
 =?us-ascii?Q?nra+sH+V8FyRHDmmlKISlYlylJbXuCfzuWuNASuugVB8fttZRdUTdMXCGUy2?=
 =?us-ascii?Q?24+/gl+6nCr5/U82Ljw2DIQIy442qD7S8zQyrES/kfvmb10C2ovCDC7f5edL?=
 =?us-ascii?Q?RWbmaifX76tDC+micrPfVr+F8tztbeNDBYjCudDBdZOHh3LnD9N2hkiLK6rz?=
 =?us-ascii?Q?jBb5t+GfueXb27iCtXhPodII2W7V6WmrIxqLTQliZOpWzIFSVVb9m3OsW+sS?=
 =?us-ascii?Q?abMpGgup2vc7gwksHpaUSN2BVrO+hS7xAXQDkrfc6CQ4SSVrwXVW1zZh/Fe5?=
 =?us-ascii?Q?41tUe2iKD90His+ivBzr6zjm86kexjpNg5J9EsU9O69VOITtwP43e6HAqyaC?=
 =?us-ascii?Q?5TS9P2MFmj51OMGvfSL9KIGPQMAQlbXxDBC9eMSTJ3wyaHXoh+7P7NSjuH9T?=
 =?us-ascii?Q?gf9Ow3QWu2LAe0kTtSL+mbzfLqpTeABGqj/07ROTaZNLgREXW0FdYS8hEsuw?=
 =?us-ascii?Q?16FJ6hkzXcux8n8kn2oRYTOFHEh+ajY686zou/0DQ7McDB5VnvMn0p4cvo6T?=
 =?us-ascii?Q?kdDw1ThQ+2BQ9QmQ95gdqz/0JdBNaOb/7CmB1Mq/FGSOhRrNsTQqHrg0Hlc0?=
 =?us-ascii?Q?ALEu+/me6YizUmeCgYVXmf7lPBrPLNG8uxFIIjuB7pZlQ8qqGRoobiVQtlUD?=
 =?us-ascii?Q?2M/DnbrB0bnwXNIkMe6bOuUZi+KzuqgptGkLxOrNBzl8o1j4D1EweLVSi+Ib?=
 =?us-ascii?Q?9crRUKKdsz4FcwS6lg1tVUvqRQ7M+kovwVe+O1vTXc0SfBnQieGHbwpri9g2?=
 =?us-ascii?Q?BpEEHbJfiek+TRcW5x7gfxMXX6INiu+eyXtf/57EcDtiLAOJSbXyKoE/BlxW?=
 =?us-ascii?Q?Q5dMjMX5k2oHFJvLnXimBxp1F7DwhfuHmeE8Lb3vvL+70vpkM2b2zqOrKsLd?=
 =?us-ascii?Q?IENfChi+BZqVkHr4C4/gTpKOeUXS7CAXV+mFoDAzpBNCglIE6JH0bWrb6WZh?=
 =?us-ascii?Q?Pqghdv/J3dNfUhn62Z6Kiegspi7hzUI9ufDMzezr5I0eAXGYZOgW3w95fQnO?=
 =?us-ascii?Q?8N24EIqBc6buDLcsmgGA5rpEOwG5kbfHjYSJ8ppq0hbR6+N5QKyuhIdJ01eW?=
 =?us-ascii?Q?Wpe+8RcBj2D1efgpn6ekJ4c5XtIOrb534aRsQ2V+/EhG9Wxi8kJY9HD8HrQM?=
 =?us-ascii?Q?P+0bBKD0LEZ1TWpLxAzf6PRAfwPyQpxzJdADn/tUC6Vg28pWMYwQWrFY15mw?=
 =?us-ascii?Q?imTB3FbZt5QjLrBZo1KAd8zA2/DymZ0W6gHCh9EFDEcXc5UqJ5HJDSS/IT1q?=
 =?us-ascii?Q?wJHArIZ9PPpT0UtTM6CK/CsuJqmqwz6wDNPZYsKOWHjTyh6qfom2OPgaytW6?=
 =?us-ascii?Q?HcseBIYyc1o9Rk13/c3aXqPZa+Oj8gzxPux5aBaQsUcd5kIcQrTDQE/A6Pyu?=
 =?us-ascii?Q?M2RAF5hKVx9HmgcHKgbJJ+ZcB6vBiTDr+bJHGeo3Z1AFePv6bchKnHbSpjNn?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf0ff86-34bd-46ab-dbe1-08da9c5da80a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:29.2771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzNnexuTGViDX1kx7ezEamoSXyD0e2W3Y+kdIM1c6qXSES6OEQe+MLM3N+rntFccPLOvBJP1sfn3MdAeNmIupiTi1HeTnvp0NqcY+4ft+Gc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: G8RyCCaizRESfuQWYRILTNXX3pewnSr2
X-Proofpoint-ORIG-GUID: G8RyCCaizRESfuQWYRILTNXX3pewnSr2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   |  2 +-
 fs/xfs/libxfs/xfs_attr.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 31 +++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  7 ++++
 fs/xfs/xfs_inode.c         | 69 +++++++++++++++++++++++++++++++++++---
 5 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e967728d1ee7..3f9bd8401f33 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -923,7 +923,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 033005542b9e..985761264d1f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 378fa227b87f..7db1570e1841 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -141,6 +141,37 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*old_ip,
+	struct xfs_parent_defer	*old_parent,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_ip,
+	struct xfs_parent_defer	*new_parent,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&old_parent->rec, old_ip, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_ip, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&old_parent->rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		new_parent->args.value = (void *)parent_name->name;
+		new_parent->args.valuelen = parent_name->len;
+	}
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 79d3fabb5e56..b2ed4f373799 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -27,6 +27,13 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp, struct xfs_inode *old_ip,
+			 struct xfs_parent_defer *old_parent,
+			 xfs_dir2_dataptr_t old_diroffset,
+			 struct xfs_name *parent_name, struct xfs_inode *new_ip,
+			 struct xfs_parent_defer *new_parent,
+			 xfs_dir2_dataptr_t new_diroffset,
+			 struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4a8399d35b17..3a2bec4ba228 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2912,6 +2912,12 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*old_parent_ptr = NULL;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*target_parent_ptr = NULL;
+	struct xfs_parent_defer		*wip_parent_ptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2925,7 +2931,8 @@ xfs_rename(
 	 */
 	if (flags & RENAME_WHITEOUT) {
 		error = xfs_rename_alloc_whiteout(mnt_userns, src_name,
-						  target_dp, false, &wip);
+						  target_dp, xfs_has_parent(mp),
+						  &wip);
 		if (error)
 			return error;
 
@@ -2935,6 +2942,24 @@ xfs_rename(
 
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &old_parent_ptr);
+		if (error)
+			goto out_release_wip;
+		error = xfs_parent_init(mp, &new_parent_ptr);
+		if (error)
+			goto out_release_wip;
+		if (wip) {
+			error = xfs_parent_init(mp, &wip_parent_ptr);
+			if (error)
+				goto out_release_wip;
+		}
+		if (target_ip != NULL) {
+			error = xfs_parent_init(mp, &target_parent_ptr);
+			if (error)
+				goto out_release_wip;
+		}
+	}
 
 retry:
 	nospace_error = 0;
@@ -3110,7 +3135,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3131,7 +3156,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3204,14 +3229,39 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+	if (new_parent_ptr) {
+		if (wip) {
+			error = xfs_parent_defer_add(tp, wip_parent_ptr,
+						     src_dp, src_name,
+						     old_diroffset, wip);
+			if (error)
+				goto out_trans_cancel;
+		}
+
+		error = xfs_parent_defer_replace(tp, src_dp, old_parent_ptr,
+						 old_diroffset, target_name,
+						 target_dp, new_parent_ptr,
+						 new_diroffset, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (target_parent_ptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						target_parent_ptr,
+						new_diroffset, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3234,6 +3284,15 @@ xfs_rename(
 			i--;
 	}
 out_release_wip:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
+	if (old_parent_ptr)
+		xfs_parent_cancel(mp, old_parent_ptr);
+	if (target_parent_ptr)
+		xfs_parent_cancel(mp, target_parent_ptr);
+	if (wip_parent_ptr)
+		xfs_parent_cancel(mp, wip_parent_ptr);
+
 	if (wip)
 		xfs_irele(wip);
 	if (error == -ENOSPC && nospace_error)
-- 
2.25.1

