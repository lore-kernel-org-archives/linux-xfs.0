Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322D1C4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiLRKDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiLRKD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B6D65ED
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:24 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI4nAa6000922
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=NpH4bpq1+Xtrh+QaIMamKKsgi1Pxmb/bjgghbSXttIs=;
 b=gt2hqGIOxiJHne1ND7d07QVHb6izLvIcNnDcz7U1DUSqS9Cbn4SpNKz2N4Bvi1fV+amR
 fkoa08DGEHkpWFjnNbDXAe4nhUTPuDbQrV/A92L0KKBRcNSa6zK3qCkdJ108WIMRC0g7
 gIRzv+OagCGcg9FnVlEQ8AVK3JNElzJ3ema+C1NquVQcxq1yJWmWy+t2xQvkF8qwAdpY
 bsoky9OuYGcbMXMoX/hmd+G60I0sr9mIGKNKbcgJgOqacMHM2LqvkpAjeyhI2RC2tQtL
 1SPmeSGai6L3l+0ZGU6YBlbJQwWPFAPLrS0yJUf/1hhkHtguKg2ce/lEvk+FpV/g+msI Cw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm19a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI6Ek2N012691
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472cfse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoAQsoiaiOxFoDrQul64u0FhwQlACapOj144MRXRAMdEtLizuX9NkaWE0mpUGZR5sMTMzs9VBwSwMDnXEHko6Mq8dbnlcAQ2Ci/AJ5bARZDKLBUr8x/LirAK5WRasO/oLqcZzbck7Z4pHTQtlZvaJM2QoZN03r9ACE+SOAonkRlu83dgdsjwqrAe0gjmqngGWo8Vyj7ndX0bzpf97EbhnRRvWjzzBMwH/wvQ4nC2z2LiGsvNFvKNaaozUKL/AyEZIR90O9enx06GEk8d+DGjguXzHCtSsFy+Ej8z63bgLpeSFus3irzAS7CYA4bTBJe+n/Xsl+4dMb0Dr7sZRV+mqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpH4bpq1+Xtrh+QaIMamKKsgi1Pxmb/bjgghbSXttIs=;
 b=ksjcMfgNwiS4WjeneZ+txk+hY13SIXEf9+mXGvNI7gy0duyc+ma9UGCRPpxWalZrmZSQCvp/+BoAxXfCNgijL8msHqSTXRxcrqkxPDFl9sjVfe5DRAMUwoXgwO8KMwEDdVRy3eo2XVeebEK5ZOCzG3pcdVv2oUVf3ZqdBP0IAZxJ2iM7+Oc/JAKxUz5udJYbj3j/nS9BCmlyZSVtqZvgMLjglCPZfycOyG1Xl/YsDWAr6XQTfSr/EIeYNpaHQsAq8WXseUPioH0SlWwDxb0sm2agFd9LHo+54ki4uW671W2Kd7Xe8GP68cNGcuUsEPQ4DBtzZs4RZvftwovOHL1stA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpH4bpq1+Xtrh+QaIMamKKsgi1Pxmb/bjgghbSXttIs=;
 b=vY1WEKUd3DUBKGDQmSkO8gsoK701dLNx09jke4z+kWkhyQNbhaXqEPybAmClJ+JaovBEq73KnZ6txm1KJz3Gr1B5+Q7fdl9pdDhX6Ok/GF+brraeZueHL65WZHMFeqIf3DjgIBZ2+VGSAypxMGtoBGn5RijGIWWhkFhQIopzjJo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:20 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 08/27] xfs: get directory offset when adding directory name
Date:   Sun, 18 Dec 2022 03:02:47 -0700
Message-Id: <20221218100306.76408-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:a03:331::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 06138a40-b373-4913-ecd2-08dae0df17c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQ0zMgcMM5ze7mhrEhkP3LQ5vrCKEj7QATdYVfqe5flZHF9igBO54CMI4KtDY3BNX9cmEuJVEgVZTRtgh9AVpzPT1z+yNwptDIu1hR4fbCV12oUQXkJfsSZ7ax+SIqkwNzKmtlXwu/F8JX65SYg4e9w6IeklEbxcKBdbcdpNqJBJp/mIC9h/qlu4YRIb1DXy+fVD9YUMvoiRUm80DTCEyO0+FgnEqdwEz3/Vg8uJDPH8ScSpyOTbJDHzP7xJeFQBlHElWFtw/TCboqu0otE8zwfgoVlYZnnxrP1OBXx3V1Ozf4ftWAGYTtjH0eRvYoUceMEHb5BHc1qGXnzmrMXJA8sCFFCtkKb6nt/oJdhJP7O4QL4YUZyrsx6QZ3uKlXOL7fBrx3+3xHmnG3wEonOnBfeWY9acIruhjm9uoGz8PYwyY5kgchIBmfJOLE8u3QbeMpUmvMT1nqhogXACvNsP/QhRMi/i2vPesR1Xytvaj83VneSGK+3ff3ucgMjvTpQuJHzwOpXvXaNrnMynGeAuXeyuJeG15T35ztNYzLVU59XVXSnH20p6qsU9Hl9lPOQ6Faygr6LOJZ9eENNK1hBgit97sIg5sMTHwRW9N3ldmyydFRlOcaL5WejnytLlUv24
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dvarplOT2wUbqmIaRiM589qQdV7O325R73QnBFW36xSFAJKJGb5QwyzZgn+P?=
 =?us-ascii?Q?Yq3HSUEdxxw/XGYTHIme0nXRuqdo5C7T9XpzWpNnPiG2yp9H4uKb8710nv0M?=
 =?us-ascii?Q?A5qSQrlUT6cFgAkZBSSTUlDQS3jgzxxLGsFtUwYDceBibzLLBcX3ZP2HbGFP?=
 =?us-ascii?Q?EaREbt6s4yF0FLuiWEGAuOFuCX4i21CpalPH9mDXpTHQpj0tBeD6yBP1A3sl?=
 =?us-ascii?Q?MP9hI/I3gHKe43O0tR/ntZj3/Wus5l3RhIPJSkFGl1colzG+R+n0cjma1t7y?=
 =?us-ascii?Q?XNWJa5sHO30KUHOzfop+aS6RQn8NbfPKwGVvH7f1mu44H7iZij9jdYHD/7md?=
 =?us-ascii?Q?aQ9VU1EhJ9UD3QZtLu/I4KkeQNnTJQ0WvtNA0cCLW/nhay04wasKjLu7iHdR?=
 =?us-ascii?Q?6yS4GcCPGU3pKz1P8ZellW9B11IgT/GqMiHLf3qirFcviCLZK7Ug3vp1Y8Tk?=
 =?us-ascii?Q?X6ABDmf1cvpgRY5lJ7qj0fYnUzbc9D+xXZs8nuRMat3N6Ss4EVImKdX9SObB?=
 =?us-ascii?Q?65qf+LN3hX+suCB3bgdhosaHnU0j+g3gGvqxff3/UqITqgkfAT6TQVk+3x7K?=
 =?us-ascii?Q?Z61VO0mCIkcHEm9ttZnH98HKSHI1rXJjBZnyuU5cFK+VQxfMMTaYHsN7NQft?=
 =?us-ascii?Q?KVnqrkYMjqTMHG7PqNTRdQlg2bsExDIu002YaTgxx1PRev2EF4O+R3kcz5UX?=
 =?us-ascii?Q?BZLuX4z/93+joSNEz5J/6y6UTt2wlv2J6dSXx6ybwORTrg059fRIhgCnuTkX?=
 =?us-ascii?Q?wit26cMbtkS6CBWy1yo73vU938mwcarxUaAOY2JKdYvMsd1+617lPl8G/BiR?=
 =?us-ascii?Q?lTBw5cBLu21058dabB+/p/WsnSTKsfrdI+mScwc+SnezMdsgQYydvQohbiPM?=
 =?us-ascii?Q?RfaodrmWrdq1vOCAohyuVcPyhikWfMJVtv9QiO24VjySyztOSQdya0vpjh16?=
 =?us-ascii?Q?+3xYd5E+iuCqz2jH2EBiaUn3nfNSqj1yCS9qMvgK9aayCEcoEJ9bQ9L+rrqB?=
 =?us-ascii?Q?tk/lNbbO0EmSsDy4rDz+YW/uGnqY70d/7j/sY0D5AizDHsCgchawEbytsZM/?=
 =?us-ascii?Q?SlMX3kJsCrsIbYNSeLEDFpJR0eGxmfPZZM0NRn1F3jkyaxXn4MWjtjHdxF0X?=
 =?us-ascii?Q?pTdont/j7q2uvkwgFTeGwmAHAsrtxCVskXUBuNQiyLZ4+J573KEIlYuqMU/h?=
 =?us-ascii?Q?+ld+PCQ1P81RjviJgr8Dr6qd0t53DzqZS1GnEBMLMajiw53uf1PaVAe7+yrE?=
 =?us-ascii?Q?j2bLrE8i4MHWwf3Swsvd32qmvuUNoH/BuILVusgkwkjPdrEn1dhPY63wGWp4?=
 =?us-ascii?Q?HVP8dVQIMAYgyHwEb2Vnslj1e/v7M5dNEBL+hMVouYkWLqGdDw3ftBnUPVFP?=
 =?us-ascii?Q?BVgInQZ7jXybvFFf4HcRFs8yOnY7PB5S2/ZXVILvj65zikaE/6Nbuyx/1scG?=
 =?us-ascii?Q?Uk6ohMqJ/+p9WYwGEuvdAxUV/RXBdCjeFcirM0Q+myoU8m6gSu8sDmoUBX1E?=
 =?us-ascii?Q?iz8zRWHkl4L7vL/TJVS77OR7iIu7PU8qoJl3W1T862KzFc9CB34wLE6JPell?=
 =?us-ascii?Q?Fyb3NRAhRToAiAAcA5vMjestEIovzkIqCT30ShU3Hdj5eqFvaqW3XtgneT0s?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06138a40-b373-4913-ecd2-08dae0df17c1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:20.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BaBQb+OzVnV8P7ppuM0ArJsbzN6hAMXrRsoFGG80akSmLAC5O8YAqo5fi6sBARy7Pn6jNC/gVHvsjEto6hG5DB9cuC9i8lgde1uENZfsIlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-GUID: exlN40hOpkDVqcCHFKFPGZaHwkFrkwJX
X-Proofpoint-ORIG-GUID: exlN40hOpkDVqcCHFKFPGZaHwkFrkwJX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..69a6561c22cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..d96954478696 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d..9ab520b66547 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d38..44bc4ba3da8a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ffe945335bf5..29ebd4e2e279 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1264,7 +1264,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3000,7 +3000,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

