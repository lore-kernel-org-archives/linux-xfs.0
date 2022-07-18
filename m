Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC5CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiGRUUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiGRUUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AF02CDC9
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHcQ6h008091
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=LUZkL35OSOOKzsUX1V7Tkl0+WtsSIHmQwtm1icpP/n0=;
 b=FU/yF1Bs4Yu349E7yA+frTXGVgLzLVMz1xdet5FzP9o9WdZEim5xwy2K1d2wNiN+JeLv
 NGXJei/RgwzwGmwwHqiXJkfvEZOUYhj+nRj5TAoar4X2MjBSgA6mB7iBjvL5tEL8wTft
 IAMqrpVdx73ryKiSa+O6TYQwzALYwIztESdfYXQwWqVjPR91/ol42kvHmQqvhWvzQGaO
 g6fYzQEAI0OS4fvz2+SxHGLu4QwlHIYdeifPlJ0vwu+9cQrinXg0UEMn73jL9EL/pJvI
 uIS1dFJVBKvfJJLn946v/98NpTGu8nmdMZj9Gq9jNpPEyT18zeH7jxVXwotaSjzR3WPg Dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4cva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4t9001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drBNbjWL6F0L59CYXm2huaqVXFRvRKZLuKBp6jF/rlq9PGiOxPVyTYZtbCBF4/PX+nluDajcApifOsnHAa4b+fRIs3Lw2SiPJlQdOy6+YcPXs+yACKvcm8JEzs9Ani5NGV5M3gfn4ZIZuADDvFYoggPsK2yMyT9ogka+Vgd7t4woyO2YQnf3JT7ZiLp/tIFZYOsZk7l2cHzSzIIzMv9yqG0497rr9SatBzxVEe6cZcLjuwpqnH4gcuv9gn5JjSn48v9/TXE2TEYHQudH/wIr4VOsXrvgou5UxFwdjSMUqHsEcQOxe2t5tSsglILe88ySrrryIX/E5qSWBhmXfl5d3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUZkL35OSOOKzsUX1V7Tkl0+WtsSIHmQwtm1icpP/n0=;
 b=UkK+DKlbePOhnSyGRgbQp8wtmt2w3HZhW3L+Ivx3JF1tODOvBefk6tVRMNiSaUsazntd2e2yxAxf3X1P9g0oJRJ9EaBx8xBWyoPuR2/r9DCqofysdvuUuC2XsHvASS8l4ksxipCgufHwnd9l5YOnWJarNz7gFPaxukvyYsEU3Hr+SseCls0+/GjpibFAw6+Vzk+HZUhdQV6UzW19PWGapPpVskFtxmsCIPFGWQs3Mn7D3tdsJm5H/FXJaV+pXQSBbnlz4l1FkK9z3nLe/kCeQgPdK2JKnMrm2ZbY5R76GGZ0qZ7MmqvGVt0EKQ96gjqZ2hLbIyW0fzKOsb47TLVpuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUZkL35OSOOKzsUX1V7Tkl0+WtsSIHmQwtm1icpP/n0=;
 b=jv3AL/8tx7bDKaWBpOxxuizqp+aDiLRg3+JmmCkVy8VzEEWvRu5TB94NQTxi/3iOB8dcLj3cRQhV52v+X4/nfdqnsQJ7NlRtYHLkdck7jP1A+o1Tsnkt/DzyHvNSjmHFTIjB7/FKGGbe+v6gBS6duMIa4vhKd7/hHrwCDelyeSU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 06/18] xfs: get directory offset when removing directory name
Date:   Mon, 18 Jul 2022 13:20:10 -0700
Message-Id: <20220718202022.6598-7-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 27cdb371-8c66-4d4f-7356-08da68faf60e
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XeLtlkzExm95oo0mTTolWzzFne60l/1JNJf8lgOO2uhm2HQx6c7CvhKC8MdcXmkfN4q5MOoC8Gzj6sCIHokl6XuwFs8j3B071PhXp1gF2Xue4Ats0+R1ZYr1U9u6mZMfOdjic7pt8SamHEBlNmk4G4dTx8zK+ECUbUNfnJNlhIaUEY+h0dBrf8GFDPx6lSVAZynZMZxSadkgrsqG5wjVPZt4hx+GcLpLngBjH53K4CUbRClvdLpKkIHiBfz1zmBKcxyUeUMvpdNSU3kl/KqeLBJTdiDJhXylWzqKwaMiIHkKMzQw8kWf5ZhxgbU1dKS8uiGkNn9ZBKls3DboX74j75pewt8u2K41ABLcYFY92wvSiNZPaUZ6efnLX0cNVuZ6L0qMs6yyV+0cuK42xVff+Y5wt0DvgVYTKP1YB6XPL/dTwB0I6hgSnTeTeDMDOSTxr7AO4609RyB/DjoXAoRt+v1ki10uJwVva+ISc8oddfQkinTZ/HEuraKiykn3k3xBgAepYYeEx+e1iRN753kUBg4jTiKkqrfEzcT5K/dixB4kOY1NdO7Zn48K0vLVnWikP5KL5IbTKpaP3K+a4+Rpt3EbgUhLQYyEcJH9bhuKlTRgoVLoITMLrJ8lvH6bl5KNfmyI2MBbaPcUuvYkIQa9EFUg2jeC5r80tBo6Loi46Hruow/gCz8ww3mBCzc9vUmcwWU28jTlVP+Q5YUsknVWZT+az+JOvDvoo90TFWUD4nmIwVHjthWnRN9/tyhO7R22V2qmy3oT5a6zZoOrOz/ceAgtPgxAMsp7fXatpJ6x/DY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5FASkKWgfboqwzqwHW9nwZUE6nSuno11zMtSAtZQzk9wW+l+O6A9yC3NybpE?=
 =?us-ascii?Q?QCBE1D5X3ZZ7JcIQjNF9HTmeCuD1DWYgjbi6HT2W8vrEJaDbfA9hTxKRFFE0?=
 =?us-ascii?Q?dWhmZ0NRkf4wZlis5JIXGBuvQG4r+cfiLiWG5WypVZLqvsO6fntR3urVrbMK?=
 =?us-ascii?Q?Bat/p5bkYjaymygKVXkw+0NdXOXf/oav1NDyyvO2Qc5FLiSzM8urALVYAhyk?=
 =?us-ascii?Q?s10sN4icnNcaJNeHNX76k811K1ySveYRiyXEzdWjq9vG/g5O+Et69nYv783y?=
 =?us-ascii?Q?rZANVa6eGvzZvw0eJOsOj5rhx9pGk50V8bE2DArAsvwElXHOUpwNTx3o8RkE?=
 =?us-ascii?Q?WIpZFlE/aBIcWERMPN1+/h7kGeCi7T+6+KbJs3KknWTbPOobIE95vdURZWAq?=
 =?us-ascii?Q?dDjFeO3SyqIKH3E5uGFOBWgM03m+XiBgrpDyW9RTIpEA4+VNptS/SIOa9T5I?=
 =?us-ascii?Q?w+kSk/9R5XReqkZptTdgu1fYCgeZN5pLn0VBujWXWjIP6lqmfQ2ka22Fu/GT?=
 =?us-ascii?Q?qp0Ds47izI8MuevffAnXzwEeJrqFqfr8KeuRyzy/XH+VFUfovSDrBQdB2lYq?=
 =?us-ascii?Q?z4WD/EfbhX6wD+8Xok3SumgnUp/g2UPuS9OUbtnL0R4Xmp0PFQpNr6iSMdOY?=
 =?us-ascii?Q?zt/Ogq25yh+o/JGDTyTAemAlQqWVMiB3RaX34n7MeYjFdWVaDxkegQ/pLqkP?=
 =?us-ascii?Q?ABNVJGhzsTsCf4JoobjVmw7hU08Xey+GId4gfCW+XuPYCPE7mS97MAfkSjVs?=
 =?us-ascii?Q?StVWGowJHQ/hcDcGvoXSWEUB/CcYeql4/aZvq74C7Lvml5BmVTDDKTgepW15?=
 =?us-ascii?Q?ub6dTfERHXJu5A1p9eLeBS9q4k+FVLgvS9n8UncbdWe1SnsCTTXBXF9iUI7W?=
 =?us-ascii?Q?qCSB+O8zsO94Q2jGAhxAIl1TXGPPoR4wc6WbrYeh+fsP3OHRIJlM4OR98akh?=
 =?us-ascii?Q?HZDPsgwkHBULR4uJKikGjFnoQRT/tvslVL4eP1EFYAS7QtoyGnKwM+HY172v?=
 =?us-ascii?Q?TePIrVEKzulxxMu7Av6r91Gnt6U9fuQJW1ourr7m7xrxqgsA5zuSlBI2BNCx?=
 =?us-ascii?Q?hB1z7F5sNDbXGQTpg4qwbNXgbn0XmB92f4p5Trh9jwpA+pAr16iix2F1n2VY?=
 =?us-ascii?Q?eNP2wXkHWVr2pvXF09wz+jJd7ZCKailY4mlfKv1TiheY1w1x/U5HMz7n/Cec?=
 =?us-ascii?Q?xkxSgUEj6UDtfOnIFs9PTAgj6xOEOZew11qD0G4B7mIcmag4kzUet/rWdiN4?=
 =?us-ascii?Q?8GmOjGzpYARW4C8IdRaucw8FVvIisxhceByDSSuNsM0hSHi77u92ClHpsHMj?=
 =?us-ascii?Q?CKVL58t/XX5Dr/qudvVy7XyCzpBOmbmdFxEbBZrkiBEO65oSbw99/gHiOO9v?=
 =?us-ascii?Q?jQS+9+qYJAJHfbTfkEHC3pskvVPTKdHkZeOBTdqWf3JuaouWPNCazkLlbYYz?=
 =?us-ascii?Q?IVW5mNdN9jiGRAh29NuL0zttj0MsH3N05vYtJ5sQZ6JV9JtuojV+1SHYHYkb?=
 =?us-ascii?Q?sA0Dvp3sHRx7F07tvXhnFwyjGnsI8GbE9ePreJochngiB8sVAj1hg/iHnaGn?=
 =?us-ascii?Q?DGMdbRiSaSbcs7MLq9p4/7pUx5s7HV7v/98CXvzPcG78l8GiVFCLfY3dyY/o?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27cdb371-8c66-4d4f-7356-08da68faf60e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:30.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Za02+ElImU7dJ1kI8xeR7TzN4Ncpev4v+KvvGpHkRX/QguWYeTG4GSdq7pXj41MpZnqE9s16pDjmMKuF6IEAsf7fMP6bN48o60g7fQ379oY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: 5Dc5O_GBVnj6rCaN607WcPDmNGSVyGDS
X-Proofpoint-ORIG-GUID: 5Dc5O_GBVnj6rCaN607WcPDmNGSVyGDS
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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
index c0629c2cdecc..e62ec568f42d 100644
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
index 70aeab9d2a12..d36f3f1491da 100644
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
index 541235b37d69..2dc1d8d52228 100644
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
index 08550f579551..ce888f844053 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2506,7 +2506,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3080,7 +3080,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

