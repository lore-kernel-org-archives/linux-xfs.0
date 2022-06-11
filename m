Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475E3CCA47A
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiFKJmX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C865ED
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3vwxd029669
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=U7SPMCwKHSsRGhNwGUyDPIr4gLNJ2Fg+yiB2e0BZL1k=;
 b=P2NUJlIe5C6Pqz7OR8ikWuKpNzpW8NyPFCyFZBMyWFRPrPMKtAlFt5Rhi8e1x75YdtPa
 0tLwC5b7D33O9dVt6o8xoc28zCbL2IbQXVzkcGDthVu04T19YCwnN284P2YsylW37Uuo
 BLnJznYMTixfItoaYZaWlJYQqjyQuBNGM2i4WQ3Zk3byrpRtOJmcNCurkv/lIu5bKelq
 JSJpOXZU2nz3NQyJjOHdhRnF3nF3KvVlR8tClVuaXx0t/vcZEkA3zBcz/XOM1SngDR7y
 lEK/cZsH5VroYyVAELinoueyk98BdAmUxHhUy1+b8v0EYlY2VALLxW8mIJd2KQw+spSI jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkt89wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQ9025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:11 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPxvZa5uRUG4Yi9UcTXR5NbgDSGaH4/o3XEyg2rT1xyU9Jjm5VBe6+46GfzPqFnQiAu9ODLMhqo/DNlCyzdjEQ7L9S49fajjG3SeanEw21Z/76lCin65bKxyEDExcf/lhnYD/6FiysuIrsNkrDjCD+sp5bncM87Hel0q3GJ6ni9n46mMyAF+ewvyPywXXl5OSaqRqfAC5aOAyQWyDw43nwaHAP2DA2Khyl7fOM6AJW08yYfq+wFVpDxoZew+MkfhPBWOj0e51OJKHY3slFoOobNzCYIerrttKk7/R73uWBampo321BQISiHr8dTZPWPvKpEgLG8N8v/7kJxxR+U3Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7SPMCwKHSsRGhNwGUyDPIr4gLNJ2Fg+yiB2e0BZL1k=;
 b=dBAJ8ymgPVYmqVMvUvcMzQVpjl6ePGwB+JKYWGfdI+8LBIbz4cWbFByupxK08WcV1/GDOOIKlSn6zK0H5YdH2H6L+9KXumdyt7+Og4lKieWeTnpiBGFmICmtm5CLHO2g1EkcYU/JIWuo+VQs76ajK9NhbBJmIfGYCQNDWWj1GUBdAkjbQXLEyVhe5Wag3SiEHL+y8i2kLS7kHXt7eImJef4Xl7c7/SPuXsBH2xGz8Udi8SzawRENvnJpVFCIcf2RZ9bMbKPhiDOdyL3Va4jQf+INBrqUQjNphz/RP6ENpLz66A+SW91/uXVdZkMWO8mbcg5VTAi7lGe1Eyd8wZ5kUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7SPMCwKHSsRGhNwGUyDPIr4gLNJ2Fg+yiB2e0BZL1k=;
 b=djUqp3VD8oec3GoiGOTcTE/JkGr3WUCF2IcOAmrQfDVPaSZJk73e5jyc6Bqb9LvI4fXV3iJqdNaJspO5v0rIqxDBWnkUcnUeC/EMC7F6JoJmsviXGa8IDE1Zi/YJovh43jmP64yTkwB9JPpjzbutSYqHcxz5MVo7GD/ALiN+UMY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 04/17] xfs: get directory offset when removing directory name
Date:   Sat, 11 Jun 2022 02:41:47 -0700
Message-Id: <20220611094200.129502-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b74aa884-cdb1-4ddd-13b6-08da4b8ea625
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606AE17401CC74832F4CF0695A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBelfC7YBee0jtcL+zF//Lqadt3iNjIGVh3lQBvX+ZFcaJ1mKbv6+Cq2StgnIwA8XJN+/CqCzTd/8NsBWQZVgA4xqvew4wjazAIU05Q4CDneMNcwEVnCorUs80QiqBr/z5vbVtFXo2iBiHK+HwtwWAr4843VPJKXHPKbMAVTX+LpYueus+Yc1O9yweV3UfCKkb6mhN2UM0MM4bzIupsUDMtjmCDqJaXGvJMcnYqqJ9p7dNwyB1KpbyCyvIOajENdNna5wcZe7DnIcB/MZXtkiy3PMwXx4cheHpagohlBBI5ijQRCQt8IYF4RS6Dk5QkSDqQbHuE2WV5NfrGaDGPBy386QViSzOzoJESjWO8vRbkX2Kf+amMRB3avd+IxSzGlydyKoVk6fdHO0zo/eX+kNt1I/K8en+VZELjJTqmGy99fbnmIE1c0EYw6Cr0vyiI8oeyRJcp+Q9ggbo+X6XyLycP1dwFTpWyi9LudScTAEjnPM1VAk4i9hPk+shoDZlFXM77ciAuALXMd0sVnftBxl/eJKAUHlrEPrK/DrEt1UJ1mS8Or0Vxkuel8Rf1SIXQU1BP8HGwXpFqV49PKEgcXWwHQeQI/AfUoSdMPxgxlaDPMyBIS8iSXVN/5H2/S/n4H111rEzKQHoCD5MYoZFI8YJ8I4LvU655AmChIUSHc+WUZCcvVViXdKVnqeE2PG7lMt2VAQLZ4tLtQ6kKnsXTjBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tUCQK7ovqwYEwgeRmLHLrAiirIt8Ucv3L5lcxpTYFMej+ERHj7j/8r0/hQEH?=
 =?us-ascii?Q?bV838i5HcQvW6hsw3rr7A6wmwZHSQZmYGGPJOVhmErAPn6hf5VmnnXiZ+c1R?=
 =?us-ascii?Q?RLH2ZjOX8GOrD/mF8D1/YW1cyRu3Iuc2nKApF40WFRMTMCqkxSrsbTjEzVlD?=
 =?us-ascii?Q?3NB/2mSqSIkI116D9dAlO6EC2nK0SbBuQymDOKS344iAYCag3PhM2EjxZ2Ai?=
 =?us-ascii?Q?KJf8rC77DbBkC03YuAlL0OogF0FeG3qr5Kp2YVpk1JmhFOtQwPUsQU3093w6?=
 =?us-ascii?Q?HTQ/GLSsuM9wI7hOBJl6w7uKSriVuwzL0g4rdJcPJ6pugCl1Fg6NcU1nmlbM?=
 =?us-ascii?Q?CR/ShqUKq359yKji1mr7X5t1yyvkdfyetGlWsNBVza4ZJWj2akt7bbfGvEV6?=
 =?us-ascii?Q?TUqrHqI6n73SB4GSSOOXknAQfre+CpqpzMoqoJswWyn+rvwAj6qZujLPT+76?=
 =?us-ascii?Q?YFRaPQXzaBYh6VRZAPoxGp/cMykaQsiU3p3CRYPUfC606PdFjdJL/zkt7GWC?=
 =?us-ascii?Q?LcYfUfB2o0syJPTW1MlWseDhUztgVyjGRUMr5wMpmn3SSD2iXojvId85GlzU?=
 =?us-ascii?Q?0iKWRnJX3KCHykG6RuM9Rvk4gTfcjiljllnw0ORqK8/M+GKPDTZsSYrCKfA9?=
 =?us-ascii?Q?ymIFZ1lLh6pQ7AxiCd74cy7VkNaze5EJ61QhqI4QYMVS6iF1fkipamSZI+tI?=
 =?us-ascii?Q?kUMS1kiFXmzLoh4TjdRNthTTOHq4/L3SDgiynLE/5jx1aG+pycM0nG6wlX13?=
 =?us-ascii?Q?nwnWhfmPgcgiWNUCf5p2TIKxNAPv6EhekKKBxgg7xOkdoo1Ar+wzVa3e+Efo?=
 =?us-ascii?Q?5PE6XXpF6imMGnezu6fLoJo7DiDW8kU6YhM32DYmhWeANlSfAILeoCre6ZNM?=
 =?us-ascii?Q?Tk1M7HxodSSBLEe+wDW+njSRw9+iMi8U+GhCbV+ssI8hpbgFR5eHDIpQEUv2?=
 =?us-ascii?Q?UR9cPj2jcEyx0RQPpNtor8qRl/u00ZVskmVdeBqZ0ao5GwMTtLzu1ixpHIKz?=
 =?us-ascii?Q?wmklr31s2o/fH5D+vCX9haE4huaPfGeZvrF63Ld6IMXpeqU6pkF44wGQFE05?=
 =?us-ascii?Q?a7Osk28c4YG5wzbG/syugaYsvHIkX+L9+I4zNbdNfP/90N7Xf3hXJVqPJXpj?=
 =?us-ascii?Q?7DeZ1MrqHxaVvAZczbjbkazjh77LzEgTfEI1HhsnMLbdQ9N+yxcJRl0gowbt?=
 =?us-ascii?Q?rixO2qbWXvckqJx4fdBzvGbBj28yA7yQ3xgyTHXu0+PUWhm/AmRzwYML+zBy?=
 =?us-ascii?Q?BGyGdpqMbrvzTSe9+pfyL6b2Ey5bvFMCGjp6Ryo37qbYDcKKQBMDbeG0pKLS?=
 =?us-ascii?Q?P6b+ffg4ffyvjnnDQPJUSpFbFKloAZU6ZmYTlgJ7IFFUTBYPGmrppnFEAkir?=
 =?us-ascii?Q?OeIrAYZFMgzolGshzdmLnoXfJEx2LC3/qPWBj7O/VAaI4oyOJtPX5CPWcCr4?=
 =?us-ascii?Q?kGJSFDYdNg56PvD3yGhz1NOBL1jSyRvy9i6SPG3elBEXhC04loVflND08Zea?=
 =?us-ascii?Q?BSduVvurxIz/1mk1qboxfQ8hxMvV4G1Sx/JLlIfmzFa6O1pWk0HdBHqhN1Fq?=
 =?us-ascii?Q?mqKql77pwcGKS4jKFubvl94rLAN++1x8BGNU6IvANf07TzwxgXYAAuAD5wmw?=
 =?us-ascii?Q?bKl9vM77jeYh7WYE3+K0u7dkQ9ODq1MPG0+g2D/28dw3lI5GUOIKuRnYJalT?=
 =?us-ascii?Q?d0vizQ2AqPin6gBYtKexiA+gHTLrQTIuwvmOhYt4NBCOQ/sb6sdfRRKJddkq?=
 =?us-ascii?Q?BmRPz45UtHlyi9B+uXmuRRJzwOQjpko=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74aa884-cdb1-4ddd-13b6-08da4b8ea625
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:07.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /y4J59HHR5nwPTOzr/8i9hBxK5wDnux+41nvxmHC+qsL1Jbxwla629UCA+Mpzr1Ievd/4ELYjuQ2G1id1cDNx/FMuQ46HTYZyYiHLKSwnfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=976
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: bKbctz9plu8ETBnxQWWX0l0N78i5Jmiy
X-Proofpoint-ORIG-GUID: bKbctz9plu8ETBnxQWWX0l0N78i5Jmiy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           Changed typedefs to raw struct types]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index f7f7fa79593f..c3fa1bd1c370 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 4d1c2570b833..c581d3b19bc6 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 85869f604960..4579e9be5d1a 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index bd0c2f963545..c13763c16095 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1381,9 +1381,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index c6c06e8ab54b..51d42faabb18 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -971,6 +971,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05be02f6f62b..0c0c82e5dc59 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2836,7 +2836,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3391,7 +3391,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

