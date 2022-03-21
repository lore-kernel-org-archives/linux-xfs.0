Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD97C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiCUFUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344380AbiCUFUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5321A344C9
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KKn1SM008844;
        Mon, 21 Mar 2022 05:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=O5UuIdNLay71rXjjG3acKgzgS7KnpvIaVigQl/yuA74=;
 b=LL5ULXSt2BUSL3tJRZuSJ7lwKnVn2GXYYdteEqfmmlF5af/oDTHvchpMby3kuT3gYu/S
 YaFE4al61k1498+qJrOuWJaU5/4s3hUIybWV4FAxUs+z00rYqd6wVbSbyYik0lkcaTkH
 f4yqrVr3MGf+sXL3BdXDCTyfkdv1yUM4pGIcr9B2pEIN2Q9m2X3lAUHy9oRCeUmsWdU8
 xj6SKsB/ctYV8jmpKfbX5cnO68VZEp7JfPIfupEh8VpFOYMD4D9uQDs4EK/q5J9wnogx
 Ia4MQFG/ZF4h+SqTycy8IK0gac8Xi/9kvrwRB5XMothcri8tbQjvLjBoVPhitiyx4Bqb pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt22v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5GSxg155914;
        Mon, 21 Mar 2022 05:18:30 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3020.oracle.com with ESMTP id 3ew70096ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8tc53X1Q6dheN+nQIE4wvJvMjuJF7dNajlPz5Auep/M6Wl1EUIaJnbXqpO5G9BmgcIuUhRf6rTkS3YDDQg991F7ufJUqF+P5qyCSegIEJKDxFiQ6NCLEqn/SgrcprYoIdLC00EbpjnumoOZ5mU+kQ/KIwWLBnIZw/t69REGAJ+cs29xWkzaW8iGchqDWHHP7O+64tsUT4oj3algYCUrVwUEj6lDBBr0OPGRkIAisd3iSbsML7eWdATCLlgvmrojoer/wYIOZqwGBCjkOv8wQ2ORJQ/DkfVGkj+qP+NBrEdbTtSVpECyJ8X4Ec5Ka1oADLk+jbOTq5pdPPhQyPz22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5UuIdNLay71rXjjG3acKgzgS7KnpvIaVigQl/yuA74=;
 b=XT9f19n3aGybAwuR8wOV/3bk3Lpq619iqSZXr3zDTTtpEcloaNpK0N7WU58YpL02l6scdO9oH/0D7Hb1Lieli4jOvfL0t6VntPAIyuauwdahFYT3AZx6bcSYn1KSn6oUETjpjnHgwCRlm8IiN5ieqZTs54Ah6xXxAAF9R0r5catpOuIMpjiWp4D0pAGqvbtjgIOaSytnbtHm2KWQBl8pV6XF/hYBS/t802KTrAEbF12OaASxRtgtcExOskGTYzg0P7Z31oYlRcXYgbSVmBYwUSE2luYTG4POM2osJ9A7pV6wb6VmtESgrZVSH+dvZn4320C8AdSblpeXJSE8PhshJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5UuIdNLay71rXjjG3acKgzgS7KnpvIaVigQl/yuA74=;
 b=RAGLQAyxDetF2T8u8OoM+ZIceOKFFllhZoTZ/B5LaafH7zLMzfgVax2ITBigL2GmDNBKfHQarD5rj2Sh2dtaCRxqiMbdE8wN1FT9P5Z4GT6tm1q+xwAeGMhkbIcS5kytR1waykCX0n5LaazdQpASZjSXSOinm9LtLoZB02Rfzn8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:28 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 08/19] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Mon, 21 Mar 2022 10:47:39 +0530
Message-Id: <20220321051750.400056-9-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: a8957fbc-c692-499f-7a3d-08da0afa3ba8
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5537910E1358E9C4C717EEB2F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9fKxmf+gQLJOQ3YM3MX8Qn6oNyYv9ul6iuZumLopVr7Q9HPgzDe7BPK6nJwvC7oxaXEVQjGUOfAaZ/E91RqAk6ENrpw52LFPUO8fvy542LQ7c0BnU5UCbUWsl3LggrR85vc4K1Wcb5b3/gzL6WT1ST4D2rk2GSrOdumEetrytXbCUiKkIxtLA5mjWMqpxwwhiOHvXyWaxl4JpO4WXRRZ25uorx9PWN+bVGNwgMIiDeUVJLrnu9WdnL7215+uqajR6EVAruzL+XTkQe1Q+Q0M+yvVowWddPjHRkVSFx3nxjSwiYlx1iKXdSrDXrIdzkT0ZVoZZntXp5zn1SlLkye7QMM/FCrZ3vkQfm3p200TLtfSa3SabSXEFIpqAtlE8Lzy8QtNUgl1W9rRIsz4z64uqFYo/+NMcS8tVuuzsTUjE2vBFxrECulpcXvMIvtFDeXCkmHSiphw0hBJpkr0UX5XG17oetPiG6NTjC8VmVgxD1mxaDmwmQ6uyPFj1vEZ6FG+R3H5PdvB/E+CSCeteqvucMetAIWOsDk0QthD/Yk1mI3KykKKV22kPKLR7Wrgi6LRmQ5sVnTRBM6r3IHoL5646uvsMVuEGEt0sea5rryuxbq1iAc6/UDEkuiDKNbD/10RpjCZGi1sleD1h8G2kXr4zVQM7hcgVJOI9gr21UMbXZPmJA0uuDbPsNAkkJhZSuFCEhaISisLAp1rnv07zKdmfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/xRauiJ/p8OwM8ETgUGdORqhG1RLRDEKhlSwD24B7T753KeMIjcr+tY8I98K?=
 =?us-ascii?Q?NW/ryK7ZchYcuDbVc0rmHchOvIPC1ZvZuc+R49UoRo+ydQNB2g0q4C6H253c?=
 =?us-ascii?Q?8rYH41s4KB2CK57sYL38KoAcjtXofQFS3nNzkD1ieI5kx1bbHlCUPau4+8ti?=
 =?us-ascii?Q?uKaozx+K/ZqvzA9wvl+o79yThdkjM4RIGn8hWvu4KoJeW3u6v3WieyELrfPP?=
 =?us-ascii?Q?w9aFnbJwkjumjV4zjTkrgKs3mFepX0e5zm634n74in4EJXTJYt6y3mePCLPp?=
 =?us-ascii?Q?F/QMWxTonbonCt94p3hxTN/mM1AUGY0Xj/u5M4HbJrnvcKV7oaAvblSNA2+2?=
 =?us-ascii?Q?WZSnaueMeZhBWi6p4Cgf6mwQV+HwgtQlrXzg8oJnbJ53zPqEXh5t3uWw15TD?=
 =?us-ascii?Q?Re2WHv9KIaMP66lSZHPMxxiylY9OjgRwnxPm9Frkzyj9lo5sr9XDb56MzTjU?=
 =?us-ascii?Q?CToLZiLYUArSkt2kPpJlGeLpjfm6gpqSuw40ofelhPAdTPnqM28KL3itVJJO?=
 =?us-ascii?Q?shcyo2kipNocPUBGcO5FsX+rqO2re8egiiKhxez0yDisu5cqh5t6ArZw/I+A?=
 =?us-ascii?Q?wjtGsoWOD+gDlzDXYxEeWGuzODtXycSDprdVTOeMzQtcW+WjpgRvffaA5BjP?=
 =?us-ascii?Q?0S+hBZ81bMNqEkvLCxN9jFNS/g6Sjv8DpDSV6XOdMbp0tbFzybWhXiGni09P?=
 =?us-ascii?Q?DT89EDo84WyrY5TiMGJmNorR0s4ZM1/XYBJNolotFRAC4nNOM6Q/bKEwEnu2?=
 =?us-ascii?Q?X3VpJ1X1+yoFfrKgiTXCbBM/VeeZfIHioedb5GM2tQBjifDO+ZeZfsYusCZl?=
 =?us-ascii?Q?8f/SttHsiNfByhyIpCXEnPLnL44aZ4VMvn/SlUv2tyFEa4IJ8KABSvrMmh8F?=
 =?us-ascii?Q?NP6XEQNn93l7/JXd6YBpBa9LqjN6Nf8e5jl+roGcHlDHQOZvLapRDwe0GQzr?=
 =?us-ascii?Q?l/DrpQxanwlATyiNBE++PvFGrLa/luNGzSTVkuVhPpr3O+LQivUxdDhGc1Ca?=
 =?us-ascii?Q?/vEwbfshIs1kvgpmAGncSGQtsz3SF5zDjOalMLUVT0XxQMnGRv28gwNLamnL?=
 =?us-ascii?Q?PTBGia6zbwVq4lnhBhiB0FyjBRFesZkdAeNFe9z4fNwZjI5mSVkn4ttPV4ys?=
 =?us-ascii?Q?Lcl+i2JmnzK7yu7Z7JKtBrcxgBdF/lIZlp1Tt063adu+6zO6HSyUPihWQtNy?=
 =?us-ascii?Q?IF0zsqfEoPRWWKI8NaGKpBtv4nDFt6knVHXsDhQmkrl70JJS8vzFx9Km/kYd?=
 =?us-ascii?Q?etCF2WfQ+AYqvXnNGof9r5bvD0h4+ryl9yczMX9+IYWpWx0amJnMhP2gQmEI?=
 =?us-ascii?Q?7w2tQy+yRQl6pvW0/ryFbQtqTYbuXbTzw0Rs6B5eSUf+tdESmxmu+WGlP99b?=
 =?us-ascii?Q?nKV6CqJCfNrk43Exl9480v5rNk0E0EyPn4gJWlyAwumgnBo6onKA1l82lyCB?=
 =?us-ascii?Q?xYCkjEu7nH6ZHASvzHR2Mmo3gwypgP4c/RDWm0w4+zIwu8tkbvg53A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8957fbc-c692-499f-7a3d-08da0afa3ba8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:28.7376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7u6YRpkyhKyhQtkxAsKeL7XerHM9T0d13uQk0m1NNEKF9C3aFn5NqSiQbt9qhoIq/w3k+7aIebnArNFpwpEmnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: xze09vKpku7tUlS1D36kfCs1BSl5uV3e
X-Proofpoint-ORIG-GUID: xze09vKpku7tUlS1D36kfCs1BSl5uV3e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 3 +++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b5e9256d6d32..64ff0c310696 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..bd632389ae92 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -124,6 +124,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00720a02e761..a008e8f983d8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -276,6 +276,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(large_extent_counts, NREXT64)
 
 /*
  * Mount features
-- 
2.30.2

