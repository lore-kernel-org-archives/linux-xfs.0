Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9828C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245600AbiCUFT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbiCUFTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:19:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E115733E3C
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KIsrE7027768;
        Mon, 21 Mar 2022 05:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=J6KX/tNnOC7riNJxBwdY33hOhJ/s/RGBFlPrfwzXQGk=;
 b=slCISZeK4r4eRqRKqz9EkSlul/Y/0Y8OMpU91i0nH3mhXk9lzUkjypnOTvzZ4omsK/1I
 xobr2zktHZJ9zJtf7Cvdcfyz19ps7PDkuHpzB6PA6t2IqW51qmiAmTpQ72KWJwvuvvLl
 w8jOduke+HWWWclNq3GIQyUr8EVDiASfFIAeTuxpNPBrfw4cllfXCi9oRqoB+zZzyAUa
 tAYzji97UXHWnnB7dcoPbMhKBR+STy/FBMhbZN++wcMJCiIWqt847DWzeJMLckTYC48/
 +cyyQcASONankfqbCRocc2a0EF5ZtiBAwexojT5IT3luzsmQLw1QeboUfRGT+kgsD9nQ vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1t4qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5G1ee058037;
        Mon, 21 Mar 2022 05:18:22 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 3exawgev08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPLy96c+4xZ3jUiPQpmfFCvVYE55fOIohk9rFsdAMD/wPb73grSFCTlyO5KbFBuXdGojef9l9+aQ/sdFAcBcfdYbIoMxYRGpFJuWIKjfiV3hQqLomwzobhfi6qFV9v/sDsUU2KEot0Xk+OnQmshAsQ3r9hZtJljSIprFKCnFkgTue83n9A49KQ8MQgYzyEW4g76D9z2EnO/ECU7Vfxr33dF/4AV8d/OYe4wQirwcg2KPL7tjwW0jLHTtmlof4AqhOoTjHoYVFBK1RROnFxWrpvWnYiUtiW7QhbWngTirV6Ml2Jz5fsHvQIr019n8s1VpUbbc4umtVohQGUSP335qoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6KX/tNnOC7riNJxBwdY33hOhJ/s/RGBFlPrfwzXQGk=;
 b=Z7TAOdCWXnD9j7AJTyZG/kqYqqT0cSIbE01CiVQffKrjbaU0Ugl+Zcw1cj51sOSTwElo026Fep87r7ixt8h5bPjGyZOTYFCno+12arpqG2tgoRhs40iugIxa680WnPVy2kyp4HslK8ADdJfSJbimtst6QOweCRZBonbxXBC0QY93/o2oQ+W9U8yD4J51oMFfMXKu0XOctpWpEMHjyKUQEE+5F8oWuuqQQYEl0Oo4lZk9y0GfqxwTSQrPKEyQQY4IHiBrzKCT4pOjexAPFe4Me5saxt/wVWYUxN/iDvSt/AO43CPKMz9jCqeq9hwqK+sTyR6IMDNhqFG+Yks+hcRg+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6KX/tNnOC7riNJxBwdY33hOhJ/s/RGBFlPrfwzXQGk=;
 b=rvQuCnGCBlf/lZocY1HbpG/mHekFf8qkTUmkEaRLvWXDVKgdamuVQY7b09P8CzM8GlspS2E6AzEyen7t6LN3W/fuKIRh3aUlHr5Qjyw9PnUPLVIDhg/iwbOElhDSrS/T3jFzXTZ9bB4p4JqYaCcKSdM4mq/TCOPjbnM+Hjt181Y=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 04/19] xfs: Use xfs_extnum_t instead of basic data types
Date:   Mon, 21 Mar 2022 10:47:35 +0530
Message-Id: <20220321051750.400056-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d43f775-26d8-4441-1c6e-08da0afa3689
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55376B9003E1C388B48B4FEBF6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYuW+rriXF0LrhKuRnPHGof2+zO6h/IeTpXYCiG213j7Kdw1s+6ZmOkCeVzrhVLodNsp6YuTTPfp7muFDwi9KgL7+1ANjifL6jV+3GuW31aQw/ctF0qD5zvykKljnTp1xmcau/NQlDhwLYmL6tCcsHL9+rBc8PEH+G/fPoB3j4mn906E/ncA6Z2MIsDWoYZa2QII+Mwy8v3VRop8RNnL9m/1vCpW3lisme8jlH+N4THa1cexSFIdLeM3upz28f9aQy1UFWQNYCCydqQY9AIxsNw+Ii7eRnqf2hx5y3C03Jr9fuv10I22EG6pXFYNlDH0oWdEPEblC5KV5P5XyWm7TusPriUqMPuKKXCp5ApsKrx8GSiC3zKM0a/MaQDSEJawEarwHTcvpY7K6X0tj0VZU0HvAYpLjPtInpxJa8+nEFWXxcmYCUokrciGqYGUM4+bGkwgaLuGNOKfxZrEYce21fxNR0r8/ZrCpKzHcmrFzvZNBiZjK+2DNiD/NMmNOdYnloGP8BfNurtnzPVT1JJF11ChwT9YOPSFQOCSjFUxfvzp+sxrODW815DX/3gXUyHJcQDkI9To//pkUNeiEGAp5AUsUvatwofPNewbU3rUMseDTsMc1kEBCZvp65GinOMbEG2mSpjAWk0qNYLIda+gKfARCY8Uw3EEYU5GaBmbo879RsswQBbNciEpOYM9Ls4H5/YSfLF8vOxQ5nm1FalSww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(54906003)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FAQRSPC3eHX99Y456KD2++IGEM22kElNNJWCqhdgC14VqeEr5t2wRQPhaOPc?=
 =?us-ascii?Q?gTWNwUCVhrd02mXHpOng+nBZrd9n/7i6mcpD1ae0gFZ3W7Cb2APif2je70ip?=
 =?us-ascii?Q?wT8jthdlh/QFXpjRhq2b0Hk7jvMl6Txm4Vw7cxiyJ22yVZ9nCCTph2nIupzx?=
 =?us-ascii?Q?A1LlTxNTmTLHbyiWD3rIupAW7PegJL3qCpnUKnI2cCR1dEc5y4JlKe3GW3HQ?=
 =?us-ascii?Q?1m/NY4IZcyvfAlF8odMlxNbw49VGervF0PrusUqQahSkbSdfCYvfbS9xuEJ4?=
 =?us-ascii?Q?SphQK6iq2oja2mA6FGCveZr7c9szMFQyjRl7QkMjVj9VaEM0NA52W8+9Uu4m?=
 =?us-ascii?Q?zuIzkEDmWHAcPjSLQqN1a+Gz35Im1EGj+kLVbKjJu37J2lglxCdrIiMBwOL3?=
 =?us-ascii?Q?H9ho/JLXy1y5TW3f8RGDTfDjlXqPYt3cUjVDWE6kT4F3d44MYeNSqgoPgvY8?=
 =?us-ascii?Q?rL5xcDKjih2Yq2rLCR2Y1LOxzODz3LCt9d+vsQt0/loSuiMzGUg4Ic2mSWf4?=
 =?us-ascii?Q?RaED7bYFqcxbzHzvmuVSuX1fBf4iccrG3pMx2SB8oX9gF0HqBX5UyMHgwjVo?=
 =?us-ascii?Q?8Pm6/4ASOUtyjs0z37NB9TUOg0xeWY1+CleW5899BA9JXHQxx/amcjX0+hVk?=
 =?us-ascii?Q?oRmD95rEfvhJkvJlOeVBMhBAE4v1kRRdAM836y+0Ayn1Abvz1ic27snPeG67?=
 =?us-ascii?Q?iCBbZhnuDk4iVpYDi9PHEm3Avt6UgkIdYAMUA6OuYrPvdAYcO7ARxIkFmMc8?=
 =?us-ascii?Q?eGRc5xoaQSn+n0kdWllQkBGI/sIMcF8rH94PIWAaGuc87D4eMk/C9MIS9IFp?=
 =?us-ascii?Q?nsHgPEsYUejMyRUjyqui5FM60+EQ4mJATpIl4fFu53YrcMoo5dUVQLuZqCP6?=
 =?us-ascii?Q?GwcpIkCclmioK8ZWXXZdRNzo+7uX+uqP/MGJyOnjq3fh3PXuS2/D5usCfQLL?=
 =?us-ascii?Q?hD4Xjo95yF8JyAeLkc5RvbiL+CyDZKyalu/Y58Wv+uEkwhYBR3iXrRxizAzI?=
 =?us-ascii?Q?eSRSw30eqw9kLwzAt6eFiP2+GvU7QUQrb8a7+vuGdZSJOcjiG+te1BpOxRXG?=
 =?us-ascii?Q?+kevBgBRuNS+eFxHyhfFfYGm+b+eSyeRGKQ6kxUESJ7ddcm16m7UBNbRHOmf?=
 =?us-ascii?Q?PHdHm7etF7D3ZjPttOuGNHmhEV0BjE37aVXKcK1vzTbkN2/otB9ypZZt33N1?=
 =?us-ascii?Q?/wL0wgeYOGZwpBnZJhE9+NDuGi+buafNF6SjuIIx2XrolQxuqsyejqrpzrPx?=
 =?us-ascii?Q?HDZAFvDcSNI4jEyCfG57MLMGNa451/EJJvPovaz8M9XTIpd/G+tpLISKypSk?=
 =?us-ascii?Q?6JIuFT20HTerpNZH+vxpU/CgtIY3OY6V8kVJ85i9GEcSMDJnk+8P6U8IDIQb?=
 =?us-ascii?Q?Dy60wqxdtP1gLM3G7OAA/miJxxe6Fk/l5eF/aST6EYptPWGjfpzACrAvrHq1?=
 =?us-ascii?Q?XTQjMtKEUU2dAMJ1q2y0Y69zcGpdrGC0ZaBMN10nFEX1bVewjpmPuw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d43f775-26d8-4441-1c6e-08da0afa3689
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:20.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drI6rAFwFFuhBlQRSdQpaImCbqjPFi3HhtUHgTRlgm7lBkVVZNKp9PcjkB7rx77Dzccxs+OXz0kAABYUaMDVaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: EcIPNmDJwotpH8S5-g4svKH0YLl1FhFx
X-Proofpoint-ORIG-GUID: EcIPNmDJwotpH8S5-g4svKH0YLl1FhFx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a713bc7242a4..cc15981b1793 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -54,7 +54,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b1c37a82ddce..7cad307840b3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,7 +336,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e136c29a0ec1..a17c4d87520a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index eac15af7b08c..87925761e174 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -232,7 +232,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..3153db29de40 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2169,7 +2169,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

