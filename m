Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24744FA3744
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJUWaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJUW37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6288C110B2D
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDvHe004539
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=HX5SJCXtMb8fQOnEj3jPfoFdB9zD4KEX9x67gIoECaw=;
 b=0YSO5j3xoYXphH4hq8LbMRHkfDy+F2tahgTycKotSZlzUJZwh+Zmq7PV+Q1UQnUJbdz+
 DskMGvxLdEqM5kDV8Avb4AozEEokoVIiI+VBOb2mzYHmE3swwZA49TAtPt2uGlqKwuaK
 oyaTSdYwibdoYa/m/YwZgN6ikj23KDMCliwZpZPfFJk3ziTrdjG81JlMTA1wYFk7XSJb
 SoyedmHhHmB4w2kr4kR+/+ZkIPzE0tRS0RQKxSuDSHZdyecPdWyzQHAIaPTMdRzL60IV
 s2K1PCtMpOiJ3RQcw7HXQ+U3mzl1FIH9HRpVvQsydNjZF5QLIXy7Gtvku1GxcG3GhnPo AQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0ajbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LL7rdm027463
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2llVcisRbwyJXmF4Er2v8zQ6fNDBAaFkgHO9TOuZsXR1bddj9x+dvOPJy4bm41lejijlddjj1ukSVTfQ9bvw4nZZdmqZdXzgdsg2BaTRTxDaAYXvuu4UzAgxOa187ZAs/lw3jo3PLVQzHJ2m8r7YOgJiH4Qb2rWPP+ySwoHCDhY+qUBDEsXissGlrd9V+9AnpFPLfptJGcuMQooOnhyugEkD0Kngr1yJw5I5vpgKoXxrdPG8Vt0hTR4j/oOt9WATbU+x5rJIFEyc404z1nxsh7tXC3mViDzcNDsIYp2VYrvqGFaWX4KrCRCED6fuce46rvtuAgNYxjTpzl9br3hVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HX5SJCXtMb8fQOnEj3jPfoFdB9zD4KEX9x67gIoECaw=;
 b=bsFFHbYbRaL03vpWl0n9YTGSrHO+RNlwNYDcvrBUuxrjfvGFk/j2wZvHQK5dPNK3sqWh6hLfyCjIZAAyOpkIbb3ZZaSolivydSpeqU1wa5NyCNLn6LHkjuQkwOfvp1nwq6iQx+NYLeEecOMifDfYD0MFqMaHlLYPsv6BwHEoqNbrA8jbB7giLRU/WFydmGjanPz74kcqPSfpuStfC/bH/6X/+PcKcm2YENuZ9eIGxG3PhZEh3lqa8r2aemAQjnyJ+JkrAKzdgV6O5nyUlK3SDxDDvjvNc/Vbx3g+qd3zty/uhDSaSoRSvwot9HyFqbex5BHwAjWb8QC95A95AbB03Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HX5SJCXtMb8fQOnEj3jPfoFdB9zD4KEX9x67gIoECaw=;
 b=PqOBzle8IGihV5uFx4ElF1Yl/oidvWqY31Mj3+wWgIz6NOjU/G9/tbwlSWm6nAaXY5T9ZfRe0uUYdnipmo3Fd06dSMOHiXPDSOa7hT5K9Dtyc/qFnURfnZhQHjqr75ka4hSzhbohcZZrOSzvV2D0iH71j9jvNRmE2wo2Z0Kbiso=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:49 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 08/27] xfs: get directory offset when removing directory name
Date:   Fri, 21 Oct 2022 15:29:17 -0700
Message-Id: <20221021222936.934426-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:a03:255::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 318468ae-3c5a-4adb-1f80-08dab3b3c3f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ASJzGhE6IVht7EmXSu3fX2uMaIhADzXOQWJNjbpl9IQWcilNLGWUdRlrj1B7ETK2vsUNzrR0NPko7lh893M9YmJ1S1670C9r7KmRyvPU24/geRvKsyUydONNKMnsPyJNuaemvWs9hk+iVZ+14ZPDuEh0NcLeuFocdanDx/NKGT3QRy9HQ9KBxwu+AEKDBj9YWhLAhu36Q1HA1bKKQOyWwcRYd/I5mKSAESg0zb+m1o6FzXQa4wI/QCTwS74tEglkZIwVRQn0BOsuL4ccGLBXU1zWnsBfLwdJSBPfYuvf3jA1BRwQXNh9bXm5NXjHE5x869g/b0ldwQR6U4kBRmUGvYvk4imowuaJ8AcZheufkwgV5/svzsRuD4rU8RQzuOznzzNsiNK9+A5MRpd1I+NalZNjtvy7I7YCr3MvUSNyljNFv/dvmMS4NxobhXMYJg+89JurptP+CxzLpUI4KdpDI11dhayDiiT2W0JxhfhnoA3EbxLEqWF8J31fwCE0yGDfyTdIqTi+UGT8ITZt/EOF8u7rg/gd56k3JRUGlGzPYWPsPxzD3e86v8eUd+Z+uFoifuhaOgR7G6Z3dRmsQ9gWcEunV2GrEQ2yhG+SqQiNZS08UMp8tVu/udK0DDongLkmQW1tAQhl1D53TNja8sVPydKsRKxYBAEgv8Y1iTO7EGvMIcyYS6tezotGF0EVjsHySSACspL7ibHATk6ztPQbpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OOT73huxtnsZ6l2TTHNhFMR99dRg4cHqVweO+V1U1hc37jC5kPXp6oqbwXhy?=
 =?us-ascii?Q?BhoxsoH0Kc+VfQj5Q+xrFujL08wYpCupJ4Q374eMHqluCsyZCX34oiV3bAlT?=
 =?us-ascii?Q?HPknhHKDJ8EudXImZ6Fh/scPfDdoTwwVJcCTScB+A4pS555YkxseitHTTksH?=
 =?us-ascii?Q?rK7fwxGtuVYgqj/d+ndKsixwrmPy9bF6trZaZgSALuU6M93Kz6jiurRUfWBG?=
 =?us-ascii?Q?HPIKHYGyI/PZLqqiwPC5Ontn+dvXAI/2/Kk22Y2v/XHHvEpdrcYZzlgBtrc7?=
 =?us-ascii?Q?AXfiOH3L9MiKvFsYbhzvDR7bvI33bj9Es9CsPAuOKthG5/SJVyGU3OfFnYEs?=
 =?us-ascii?Q?eMljF7Z3KnJqHCUvPWsgqFlQ0rQzYs674uRSohOFugpSO3OHUEsrUqxTFYDC?=
 =?us-ascii?Q?VxnTv/peVmAYtI8NgnmCvSkwpsQNTONo7zWV4TUe3HkElEW3Uyyn00HmeDq3?=
 =?us-ascii?Q?zk0Ev5yJLeU+xFeGXDlMOHGv1Jy2LDA4VH1NOYJGtTkn6LPt1MNb7lEHAZlM?=
 =?us-ascii?Q?Avu87uXfAT2j7AyU0YpYcfdz4SFwznIlCFMoEMDDtqj/bdHYCxOmPbNeY5j3?=
 =?us-ascii?Q?lOBgHS5UWba/dn8eK70+0DwzETxUKPfo8V6u1tmLACJXPniZHWR0Nkjp5Bb5?=
 =?us-ascii?Q?g9RBB94aqRJ39AW/LHczmxnQwLX13oKHEZFtEw4rAfHweWQ3tFJA3mpuG+mw?=
 =?us-ascii?Q?OOTbVW3EvorqozRixmgcahXUMwms5rM+khWK3UA3KWzuJD6MjkOo1dPXXE8g?=
 =?us-ascii?Q?K9SNgJk/7wO0lyK2AfuC+YvzVTj7/LSWJAfKieVCRkyXxTVu0ahNTxIyES1x?=
 =?us-ascii?Q?ZdHkPeUiyiWf2lJqQ7qoqJ4+o9B+nhzdFzQCQMxB4tQk+ykBvNIFuzAFX2C2?=
 =?us-ascii?Q?3ED5E6caDvWvawkNpqijd/+WhShVPu6bV3ajVKoDWVZISdyI+HRkf5b5HHh6?=
 =?us-ascii?Q?0I0wHdskA3AtC2ks5iG565U+5L7BGky3/+/Cmore0C4tpO5xGCA9aGc63tvz?=
 =?us-ascii?Q?INwvHIllHS00xqfgTUFwHVdxkqB06JpsGOoB0xi35RcxkFRGLzG8UM2Gz/OO?=
 =?us-ascii?Q?mthuETfWS2BiAEJ0+nZ0msUrl0tJMlWu/LRLZ3Xy+rg/vUNiboQSzx/gITnQ?=
 =?us-ascii?Q?a9RYS+HLaDNpHSTgmeQ1BXUITdZVmVTd9fT31IARe8Tj+CDTTZFKvuCGDfoN?=
 =?us-ascii?Q?27kSR/FfJu0HrPFTkPuMzzciSPkPRueSnrH9h7MCy5WhRbNldLk3KUiJGgOs?=
 =?us-ascii?Q?ZZ4gD3tp3lRS/5SC0U+mdx45Llalo9FUgrPA1ws2xvvPSDyRmxNuIM4xRXld?=
 =?us-ascii?Q?XC0nvPBOMPcVGqQexnOrRjrtE/QyhvsWKKNledbCLHRXO95ApyHuY6eAVZ3L?=
 =?us-ascii?Q?nL2c+UHVDfII5wivgqoD6IaNA04UC7Q+i3zvmBUA0no9XCzS5LkeOJQgptS9?=
 =?us-ascii?Q?zigQs4lSKUFX7uVgku/p4cF/Gj6lP04fFxC0MbbGvJnPeGyzWn9oacRm91dc?=
 =?us-ascii?Q?NEISAJWar2HnxKr6plTEb8NyCFVczsqos7bJ8eb4K8RS74Bi8ZLE3ovAch7U?=
 =?us-ascii?Q?r/cOI0a1h4bHHT35/DhfmWEOSLlMSjR1fxE4+pxyYqzDq1iw4yR9OI5Zpe5K?=
 =?us-ascii?Q?/Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318468ae-3c5a-4adb-1f80-08dab3b3c3f1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:49.6723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORazOsKP4fCTm0h6q9//klHPCEnPLTCoKd9VT3eHL1ykY0k/nQWGQeDPcSQbKqJWsAlv4yAoWbpysu3YnTY21kLlZr9ApGo03JDodudB5RQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: DTU6_3SPTGsJOsj07r37DOn_NPfUev47
X-Proofpoint-GUID: DTU6_3SPTGsJOsj07r37DOn_NPfUev47
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

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
index 69a6561c22cc..891c1f701f53 100644
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
index d96954478696..0c2d7c0af78f 100644
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
index 9ab520b66547..b4a066259d97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
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
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 229bc126b7c8..a0d5761e1fee 100644
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
@@ -3095,7 +3095,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

