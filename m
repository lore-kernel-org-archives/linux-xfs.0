Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D01C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbiGRUUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbiGRUUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4562CCB0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHRCn9023354
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=D1GxUB38aZ6TiBtpDDGVLHcYXZizU6NwdeFGI63+jRM=;
 b=LDsbDjuoNH/C6bqwZC1vizHiU4DP/D8/ZVxBm5QBXzIWwYQAaUzbR9h4cgg8rMvlHpZh
 lVZvw7horHkEuA2X3jFwGVeNwoA/ZuBOQsrlZ6KDkmk61QClrTcncoGxvMyb+NCPAHbZ
 LOwDXDkSkCJHpxlhYYSYsd+2IxJI9ARudT+8duYUrhh1lVGQs2O4AU61LiQ20GAUYC6n
 NHA+a+qE5bvpixgIbSx0PeH4lWKDzlB4ZqCy9ugEwPsJJ/lT9RQRwUB/b5zq5PdlJMqj
 rBeZ4nWFsU2ST64pjHI6UB9TOuB6H9hmRMUCQ68q5aZv7iFvJxaXFSdEthMluUb7tklB Tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtce46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHVRRv007937
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1ekx2da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TziUqsclWyTDqhG2CntruO91/Wz+FtjNXaNRH7yUkATXJmerwoSqvdQ2KRGk2wY+eTZsKBADSbLIHMj56sEjZN/3kZyrP1OLRYHr3kbSL9rlKPft2rgIHDN06oHOlDHmBQ17IlHVhGzNv1tvEQQCdiqNW6j1ULhXXoAOsOHuOhLyGfizXacTxoAsdLWfCyz3YLCFEeRUuYt1pXpK3Ji1JFjcFsQ91Pz38XAMHWReFhi3vQCkMcLtnc1KxMw2BBFW9Ck6VlEL29nV123M5VHW83wVHOyvIPwxPOCqScmg9hCJsgC9A6FgehVpiADLHaYepAFp6NaoriFy+WG/+d+tsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1GxUB38aZ6TiBtpDDGVLHcYXZizU6NwdeFGI63+jRM=;
 b=DerOkNNQK0vF/HBd4rhUt0fo4Ilyc4c+gz0bv7qr89XddAU6gCorMX2wSWkA4VqmEEuUd0mCPWmG/L1zFK1g9CKApvdVOUaqHOaZ6+XrvCtmgWZxVtJxE1BmpjwOEV31Ul5+AjV1TQSktHaOkUMVbgOY97yf2z8k7xN3iIA4/2wUq/94WIXGqQmDJS2oyzkduSqPVj5xIPW0/ns0HhWJG10VfgBZUCEGKcVFQ6qxEmhtMsu+DoYAxLWHXGjiet3uQsweMPGUZtqb5WZ/ho4LT3vmo7nLMv/pEF1+DUlkbPHexDVDHCirs6LYKka0ufaF5Stki+COeoiOfBk7aB/bOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1GxUB38aZ6TiBtpDDGVLHcYXZizU6NwdeFGI63+jRM=;
 b=ltbRKP6AQ0kVdQETv+LFP937vF5tGyq4kxcT1TFhDTiEYAgtys8DBjVxEpKiuZo9p9jiAhz7HtqEQ1plUM1CKAt0bqevN9nq0s93mhRY9S6hfvyuWGq4J5PWI+KCai5aFTlvsnrPalVJwTiXx+Qj2fBDQQ1uFxsq7tvPojsxUTk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Mon, 18 Jul
 2022 20:20:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 12/18] xfs: parent pointer attribute creation
Date:   Mon, 18 Jul 2022 13:20:16 -0700
Message-Id: <20220718202022.6598-13-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b76e9a1f-8e89-490c-977a-08da68faf719
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSuDM45oKW2vB88pzOlqFp8bXueamtbN5sjmrx6AhEEluS0tEJhAIdCxfrxsf8GTIof0C2L+3bYwoMmB+8hqYVobGKgK9UvmUstXjIprR7Zgy2SwVRJrI+nzG5gTFJSAAdpM8qoL3I/ORwTOUp0OttrBecc9+K+vYd7HbjAi2zBfTonW4fv1dNkkys1WpmoEGc5w9fdS0yMjDOpsCu5mx5yzuwNBuB+3hw/E0xAgzDq19C8WabXcGfXJP3aTW2S0EZAvEDAXxOBVo7mQYi7dVHK7pqM85W9oZ53Ey1/HYv616TEjG1ymCeBvevLQRIHMLEBB3U5LmSXv4aWJC8dgG7prWkXoIgilY1jVzwxrbH48N1Qt7oySyjtd2Koh8pzfxD0n6oyj9Yil5w7wcS+TxxBUxg3lWY9MiylOVmzIaH2+2RA13epwNHRVxbTQ98HoPi525C6r6Txa4m2wM9fVMSNnEx7IKK/pYCOONx+eCB7MbOg5q8oRJG2/SZ1v3eTIdXkqdo+G9ckhNC7f5zcaGuUb3y/1eQ1RIq7NgkNiiuQmrHE2QkwM/cdfcMfmRue9jNA/TyI+ETSRRZZ/KQhcOCkvVUicHlr1vLeGKC8/l1cP93K88wI2yBMOTir2HYEeo/90EBkG5H1T1wmoXLhmtLbAxnH7QR1JsBTu7u0fQOkoFFswIP9SsqiS9fZy75P72C3MHJtnd6LIa664PPYZrSauBnZa/RI+z/OeKxT1R+ZkSMA9tswwDqKx5IFxN5QpXGSQuDdHLjJsBn0G9xjZvodXfJGbuudhIqBcsX6Jjno=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(2616005)(1076003)(83380400001)(66946007)(8936002)(186003)(30864003)(5660300002)(2906002)(36756003)(6666004)(44832011)(316002)(6916009)(6506007)(26005)(6512007)(8676002)(86362001)(41300700001)(478600001)(52116002)(6486002)(38100700002)(66556008)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TKBfLe3GDd25o6K3S2+GL+tX5nk34jMF4eeMWdvQirXwfCsXJt7wDwHeZ+hj?=
 =?us-ascii?Q?F3tCT+c9wli4aRpZtmJFqrs9BdqQwXYFCbsWs2kgt+nwO9eNK60hZM3JlVas?=
 =?us-ascii?Q?rMBuZE97FpsDu6SP8oBz3MvBwaBy+pqwnIi2moKmr7O75H8r9Yk3FHj0gWfj?=
 =?us-ascii?Q?kcQ0EdGqgMc9MqPMXlURYb7uLVDaYYfRqzMLCpUcfZt0XpJgX8kgBwglRwNT?=
 =?us-ascii?Q?kzXanpJi/H37bS8u+iEkPT6TMFw0hBE58sNcNPB2fJdYbOwBKp1M3rbWFQZp?=
 =?us-ascii?Q?YTnwjS5Vc06ASK2ZtDb8grAMtJ1PCU9Y8/h5SzcAAAw5ibZjB7w7Q2cqoBXr?=
 =?us-ascii?Q?HEnQsRo2oqvNgd6/ZRP0pp2/oHMpVSfQAXQSagLJwP/5+rpAgqXOZdelwglA?=
 =?us-ascii?Q?7rT1vFvQgFVAh0pcQh3MpTx2GHfKplAD0jWei3HQU8fz/HAuIKGzq3l702np?=
 =?us-ascii?Q?Ojuenlxaro0k5IQVGgNgsvt/LNrP2IQxwEXjPXQL3VYz6XG4zwcO1nuZyBqR?=
 =?us-ascii?Q?nzzX3pv2nXXIy+iIHCZyP9VZdT1But4BosGFqtauB2fOmNxHmFV40c4kmcs2?=
 =?us-ascii?Q?7p5HC297WuxL+VABtexqPW0/RWirIX1hrlae6Tp6JmLmR5Ab20POe/+Wyn7h?=
 =?us-ascii?Q?3tUvGRF0GA6qxPfpD78Tnie86otvpDlG37yq+Wu9rOi2INL1s/NGx9qGZLdK?=
 =?us-ascii?Q?qyYBhZPOumOTHmH5W00pxzTDDMMtevWTpSs76lc/fvoo/SlvzLIMYrPUtR0H?=
 =?us-ascii?Q?Vk0FYxydifUsm/GYoaog9nZ6BY5YpG6YBV5D1KYbbD5qD+z6GSMuirUkiZZs?=
 =?us-ascii?Q?WoB2PYzre1QLPz+5XGoQjVDALdv0imNJ0IqJtLVANXD5N1/IW8oGBJ8B5DxG?=
 =?us-ascii?Q?iRqI4WU6/Pp87I1O6GPkiWrd3WoeewRoezMQfqejCzgD7HOfCh+5mjUISkeB?=
 =?us-ascii?Q?69fqCANcZ0CJaoQD7i908Pjqb8bXn55JgVFzp2JrAnMQdhMhP3w2aIoGPUY/?=
 =?us-ascii?Q?bVXws6CGstidMFc0wvZT34GshOQV5sBm1pGWHMpFasqBPcDlFr79KdD9c4dA?=
 =?us-ascii?Q?xApMofoUIZc08hHkVnFq5MmmyU8DBjLuEPWfiYdprVvlVtaI4MhL8GGazF/N?=
 =?us-ascii?Q?IIAkRsL1UZswgWurbf+dYPC8MQGKqor3N9vrHvjCSinltvkTyIv/+Jw+Rgwo?=
 =?us-ascii?Q?hU4pwltD5HyjzUVqDkWh0r0ATp1c5Rk/Fpawyb+phB26GNLklfS17BeViq/5?=
 =?us-ascii?Q?jlYTGEuYCac7zbI0oAv8Xj3t7kba3AjaebYsOFMDSOFZaqrFMjXvn6dbhPcw?=
 =?us-ascii?Q?dxIcW4GzCReFnJijeyd7kQdVw+sN7MKCj3PDDVcO+iM3Gisgb9yiqucYzOOK?=
 =?us-ascii?Q?AcmViVw91CIq80DWSrgWHox18OCT0Aa2tOVZzfVpxF4U1mGtiJYKQTeEkmQW?=
 =?us-ascii?Q?cPs3C/LzivF25QuPq3XQ5VnZxQRvA1cDDHfiq/ypr+A6Ujihj8w5T2Ms69lh?=
 =?us-ascii?Q?hNuOkLBXc6sBSFxObxuABBi8hpGrRFQP4W1MDXtv3tswVWdDpLZwHmD9Qssu?=
 =?us-ascii?Q?Y3EPlbriMKmHDyihXu7r08cekrOCe2Ihn/P9XYHmKN50bl3f2or4Uf0VdHjP?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b76e9a1f-8e89-490c-977a-08da68faf719
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:32.4358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kgFTeLvR7tKBKyUXQFq7blr/1AkH7a/5aK4YNJJzM+yzqX+EQsEygqOVH8Cm12CDni0vNjzwBdFvt9H6cQcdMgG0l5hopnfftiTtW6kBdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: bjy3yIW8aPutVDVPKff5MJxIaAKc3-ID
X-Proofpoint-ORIG-GUID: bjy3yIW8aPutVDVPKff5MJxIaAKc3-ID
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           fixed some null pointer bugs,
           merged error handling patch,
           remove unnecessary ENOSPC handling in xfs_attr_set_first_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_attr.c   |   4 +-
 fs/xfs/libxfs/xfs_attr.h   |   4 +-
 fs/xfs/libxfs/xfs_parent.c | 134 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  34 ++++++++++
 fs/xfs/xfs_inode.c         |  37 ++++++++--
 fs/xfs/xfs_xattr.c         |   2 +-
 fs/xfs/xfs_xattr.h         |   1 +
 8 files changed, 208 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1131dd01e4fe..caeea8d968ba 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2ef3262f21e8..0a458ea7051f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -880,7 +880,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -898,7 +898,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index af92cc57e7d8..b47417b5172f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..4ab531c77d7d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
+void
+xfs_init_parent_name_irec(
+	struct xfs_parent_name_irec	*irec,
+	struct xfs_parent_name_rec	*rec)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
+int
+xfs_parent_init(
+	xfs_mount_t                     *mp,
+	xfs_inode_t			*ip,
+	struct xfs_name			*target_name,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	if (!parent)
+		return -ENOMEM;
+
+	/* init parent da_args */
+	parent->args.dp = ip;
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	if (target_name) {
+		parent->args.value = (void *)target_name->name;
+		parent->args.valuelen = target_name->len;
+	}
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
+	args->trans = tp;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_add(args);
+}
+
+void
+xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kfree(parent);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..21a350b97ed5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
+		    struct xfs_name *target_name,
+		    struct xfs_parent_defer **parentp);
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode *ip,
+			 struct xfs_parent_defer *parent,
+			 xfs_dir2_dataptr_t diroffset);
+void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 09876ba10a42..ef993c3a8963 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -950,7 +952,7 @@ xfs_bumplink(
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -962,7 +964,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -970,6 +972,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_create(dp, name);
 
@@ -996,6 +1000,12 @@ xfs_create(
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, dp, name, &parent);
+		if (error)
+			goto out_release_dquots;
+	}
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1011,7 +1021,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto drop_incompat;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1021,6 +1031,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs |= xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
@@ -1035,11 +1046,12 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1055,6 +1067,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		parent->args.dp	= ip;
+		error = xfs_parent_defer_add(tp, dp, parent, diroffset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1080,6 +1103,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	return 0;
 
  out_trans_cancel:
@@ -1094,6 +1118,9 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c325a28b89a8..d9067c5f6bd6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..3fd6520a4d69 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,7 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

