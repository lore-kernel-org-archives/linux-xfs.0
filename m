Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18AAC678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjCHWis (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCHWin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A687618A7
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:37 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxtST028433
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kO6CRlVBmkNsneDN2MF1zdUusIW4+1OKlw9LuQ9pwt8=;
 b=Q30/Qv9n6Gd3aAaso3Txl36h4NNihwwpMCf3Ako526EBn6ygn3Ec1PBt4Ezo9z/nxz4B
 Q0sw5WuKRJbJTMQ5sD11WP/CYPUkE7Z+LE5KLHSuoD1r1a0h19vkkA221qriKM1lvWjz
 x3HrYS5wSdSui/OCgvi/vFuxUCxN5B5KnxLUFbWeJqRB2uK6tAjzSAYzgX2ve6mWi8bU
 Z9Z9FNTe6VfPXlzvCiVum01BEIkAo1YgvG+xHEQptQvsPMrko3qVV19fQBexCLltVViG
 FKDyVtp2J6FVFWs+mGBkOF0uZ3eLrgFjYP6Kupw3Cjs9Alqou/Zs6h3DAAWazsxj+wVO Ow== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y1efg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LXpgI021719
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dx2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AD4kXgHFRUPzBIrbQOLOm4B2ho8ffCsv/G3wwfcZs6M++GN+nXI00Hegq/ffxc/6bnMzUhURhdUYV5cJM8cgN2DUfVRXayO9jKMurByLNMP1/0kvMLou7aIRMwOCHz9k0hl4Pzd5EHudzUyOup4DPLl88Q+JnB9IqKxG+oHnYCpfFsX1Q3sfmt0IetOZFyyyqC2ywC/B8PlsBVfj37bj579vEM0jDTDJ3wMvP0MJx3nSD0Ys1GEq/RudX5xDpAoHGU+8cVax9fVJqNcjIeUczr/XrGtQvP8G7hNPZ/avMnYfVtCSxRd1JRwQIEE2+Pf/6A/D5tLJmT6knPg1wbHZRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kO6CRlVBmkNsneDN2MF1zdUusIW4+1OKlw9LuQ9pwt8=;
 b=B7oul88Nbg2QfiGy7GT1lDbqJqfQEwhE3vHahoKIqVIQo5ccLxlPwBG32e6/YNsc1UlB7nIleVxkOgaS+7y0+hYCmqEFVTfQ/uW40qDG98spC1Bp9sLov9WDjwT/egYIDaCVH69Ys9qkEAcy+Czr5htO2xVRpo9U7xzruAUIMG4nhSteqMImE+yEqbsZzbtHFtavdH3dzrrnn+9P6P3RBg19Ri9Pt8pHFzxntYHdYKcNR7tl5IDkMU9CInoUvf4MmzvE+46II+YkkWw6M0SvYuMy3uhblK85YKTddgKQvy61Npa3AvKCdI/aHhIB9bTxkRIL0CPRn+N69C3B9FgC0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kO6CRlVBmkNsneDN2MF1zdUusIW4+1OKlw9LuQ9pwt8=;
 b=vkUcFrpRMABbd4AFCMa5yI4QZ/L3XE7J5K7JOKVaIWr4wop/aJBe593shhSwuDW2B1zvNUHAdCtq9yzbbWh/fxxYpxNtbGT9TxgGvQYAEf8CphO09Zm6AA4lUb5r2qkMSfW3wTA6ZyYBSWrsr3UVZF8jAJdzXpZArge4f+gHD+w=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:34 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 21/32] xfs: Add parent pointers to xfs_cross_rename
Date:   Wed,  8 Mar 2023 15:37:43 -0700
Message-Id: <20230308223754.1455051-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0009.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f63da65-4812-486f-e9da-08db2025d9ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L/FJw5ZZjaELTzmUKNJ0aLndL6ZcNkX3pmJ5ajVbZ6KiJ+fFtlTRmwWdFBJgA032DJzR7HEC+ZOfl+M/1eJ27BXMwftLLKTwRlL+yo8bDA3Z5rnkMEu4d9V8CuvOl7UUFU0AcNbBUqcNBOV4dCAMckTwNhCOsjLgXHy6S/XbpqOpWCr9ZtXKjQFmRJhG01zS2suWBCJrG5wLMV6ZOkiihfq1KdpsL7nmxEryelddeWgoVlylQtfclkmU2FuP9+CFFmdEaT5S6v558En5ldOImgpvMLGyUgNxpdA9RN1LmmDWZG8rR6xJpHdTc9li7/wwkKTQlyA7aPH29h7whsMqcRpEbQo1jMBOdhdAbGd7XAr8TypizJio80Tlntn5dSI1WhJOC48qXVqXsIeo9ojDPLo/oo+XL/fJVz1QFaYDsRN9+TjJaximr1H45T5ZzxM9IT0rtSV9euSSoMfkWEfLvHQ4vRlr8cKG2FOfDaPCgkwJJpqjIqRPiwKPpoJUFCN46ASvzn+KOEoUq9MDGr3o6BiWv3JDw47YTDawQbyfTUz8Ak/VajQgEnZQZUtez/Ee0Sb+OlGSUo2tUkwasSsHW3fGym5pEIraGXcefQVx1zsXZAKybA+CDTz9ELQlU2785JMQMQyrUYTvRxPU8wO8Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?20pc8TQJ9M/4zTs+IA9za+yp7x01eMGdehogl+Fqi5IczRoplwHZoTAMatGs?=
 =?us-ascii?Q?1odY160OUt6wWTqdZTjLtCXHnYvDNPbCEvNXeUtmFBFcZMVWRj48a/zhP3ar?=
 =?us-ascii?Q?jOr44JDOT/CtXzQi5bYT7Rm3XCmzjvFp41pEPhpNrAW31THRmOeHjB/A7A9T?=
 =?us-ascii?Q?ymyG9R3TGtIaBG7K8xuKziRE9Wc3heNQEW/sxJuX1NejvCBM+76lfw8d72tW?=
 =?us-ascii?Q?GaBSchrdh+Drf2JtHo4P03enhqDhvFpyOsgd2Gm2x7fcesf18+zGi+t45u/I?=
 =?us-ascii?Q?ZKbBaML+5I4RdUYjwrarvJsu4dvYgtMCkt3wh56OzsbcbfW4rNXfQ7uXYva7?=
 =?us-ascii?Q?8t9mmQi1FMvVddLdaHh0aOlzF9pbqKg7qVq8BXSGgtve79KkGoX3R50RFllK?=
 =?us-ascii?Q?zKPN2AjrPj0PCR/ZhmwEkNQZoEDgfvSHc3uAZ7NskPrY4D0Xy+eRtkR7BLY2?=
 =?us-ascii?Q?/oykGwiJHx9+nRroHe1Exl+Tdivt+KmCo0E8ocaR6U+WLitv7e3148n0ydxL?=
 =?us-ascii?Q?OhGraqViDtHqjZhK2WF2dz3P51KVivA2CeNY8xFMlh4Fd4iiGOLW9AIPkKYq?=
 =?us-ascii?Q?XKT2UCZmO5NloLfy4ZuUWn0UEZnoffT7aV44KixJHPqesFoGfbsElIcxaG7s?=
 =?us-ascii?Q?SkJVfy9uhVDJdzaiZx+0aalhCBB0vQnrKDCPBSbqtFWzEwYAXHjfEp7YZYOA?=
 =?us-ascii?Q?XbXyrvn+r09vTr+6YXTpFoZiUC6bMvD+XRgQ2eg2SrU9jH609G79jQeTWUdQ?=
 =?us-ascii?Q?09Sal7tX5Qbk103cv3PXiQvsuN/o9vQJlC/uq5YPdHTI+kq5XoMdryGF3XLn?=
 =?us-ascii?Q?tbyhXDjKNz1LHIMng7zgvgVteovqLwmORVZQGHsf+xSfmwWKypFGBKQqRhyN?=
 =?us-ascii?Q?/ONIOBKj/PrNLp6Q7Qe8CqQ/F1D2rMNV+GnryyHFwzNdM6SKS6LCO2dtTIce?=
 =?us-ascii?Q?2zahqgqsocYPVdRYkny+QfXd8euQXi9Eu9L3wRsgLxzg9RDAtm7pBAhGzZ2G?=
 =?us-ascii?Q?C7cgrfxr8j5hRVyI2dUye+LvOoB7ZP2kTOJ+PdiJNFrjPvq+SdxzMEgbwd8s?=
 =?us-ascii?Q?wpKj1+E35+yTXWMXIxUiXfbwSrJ8EYmVA7L8Oy6zewgts8u1luGjYOZ8rx1J?=
 =?us-ascii?Q?rTyKbHF29IPeh+AZzO4DtlXmNAJFF/Ddv+S3chCTF/0Kw3sRcpPI7Z7BN7Bf?=
 =?us-ascii?Q?QlTiU0VHFCrCgPLcWL3Lxo7UaDyDVN1sb6HJFb5TgPq4qYIup/YCi080qHtv?=
 =?us-ascii?Q?zdNJIyuiclIX5D6jHzOAm6uH1uPX9/t6O5RADL84IlanFqruRW0+tQTha/s8?=
 =?us-ascii?Q?Hr+GnngZ7wPW8AALMMHKEUxE1tkk71LCz2eg+u2D7KkAYemBgLsPpfFkLuk0?=
 =?us-ascii?Q?7svHs8h+mP+kT75kfQtZ3IMS0JEk2dBdST6c4Qw+4dkeLJWUl3ZxB+hsY4P/?=
 =?us-ascii?Q?YBWMdwc0PDCbjq8Ae0u0a7mUNM7VrUyehLke3nAMvoNEpl5juoOvQ75XCka0?=
 =?us-ascii?Q?hoMAtmz5sMRev7ORM5BXKJngtqMiC20SasEVDT5oaAbMN1YYjldPmgMejTy9?=
 =?us-ascii?Q?adIgxj4UOeQlHINNcmeD30LvkM9Wky/7C7xuueHBgFAfYfKLP+9ScYv1A6LF?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3hlblLWSpyzKgv1Qj0EtfnN8UP/smO6cIRAuCvO9zk7EMsJfV501DlA0uDLjc6QeweLiOgspEGFGOf672zGt0f4/UqZxINofV32A0GH0nzJYZLo1sCzxOhDQOssDIgdqdBOlWuH6psAvGram6OqB3Nqkg1XjT53f3G3zzzvzLA6bQ7vDHI8f8ulEfEq91ytDV7t759e3/SKKxcJ8qU757vEoUUv0Os0W9O2oNK+zDC8T/X8hjsNbgcZl88+OfN6d1EF2YNI7IuWVaMz1r4PULv8yefcMEhZP6OI8O2lle0R1gjsxH1pedltsjo8nb5yTggVuYovFjJCEvtoEJPao6opiLAOEdctikpQC8nf9SVrMPrVD+kL/vbSt4fJBhMJMLb50cTN6zeoEOBqyEnONAYkKX5kAOqDumuXIEcCgY7a/6OYVEZALwU4WYd210Yzzb001uNufHS00tDNzA+5oHxkJapTL6RfNUgXDw4jpU2Bg2U3ZS9JJkUK95C17huovl68HyeRfVuk4k4vuBNlQQNTfZDqSG+Z73HMUizMAQmR3jXbtLlB6yeBbOUdk6gGThwFI4aBZKHfr6We4Uxv22CoKx99iXFyAXSUQZSXAivW9GVvdeTzkPzwkb/LRFk44fA1tHwAkHcrqFWJTfE2gSNt9T2UrMf9RxCBRBwAfOhtlRy4thpA1kWlWVTWXhmJPfud4XHFWb/AY8OjppQYCxMOw09XdcM3qW4EEWpjOaWzHvl7hAQfukbdjCt8JYbl43TV0LrL6QfrptoWIHUT0sw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f63da65-4812-486f-e9da-08db2025d9ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:34.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7FT/HbpaJ6VQt8TwXUcvnrQKSPoo9EhrAXzg6c8zDjV2UmMA3yCtJXKSCwAUHL59pLsQxl1cv2cuJP61vo1aOOG7CWHHAd2PXvK2O8LUzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: _w2QZPwUA2AxCtQTOVPKaf3hdC8duLw1
X-Proofpoint-ORIG-GUID: _w2QZPwUA2AxCtQTOVPKaf3hdC8duLw1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f069556c8dfa..20193ebd3a99 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2749,27 +2749,31 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_parent_defer		*ip1_pptr,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	struct xfs_parent_defer		*ip2_pptr,
+	int				spaceres)
+{
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
+	int				new_diroffset, old_diroffset;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, &old_diroffset);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, &new_diroffset);
 	if (error)
 		goto out_trans_abort;
 
@@ -2830,6 +2834,18 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_defer_replace(tp, ip1_pptr, dp1,
+				old_diroffset, name2, dp2, new_diroffset, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_defer_replace(tp, ip2_pptr, dp2,
+				new_diroffset, name1, dp1, old_diroffset, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2844,6 +2860,7 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -3060,8 +3077,8 @@ xfs_rename(
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
+				src_ip_pptr, target_dp, target_name, target_ip,
+				tgt_ip_pptr, spaceres);
 		goto out_unlock;
 	}
 
-- 
2.25.1

