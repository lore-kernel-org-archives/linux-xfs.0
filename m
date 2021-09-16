Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8870EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A8F61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbhIPKKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53356 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:22 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xtCH010930;
        Thu, 16 Sep 2021 10:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=pFuY12ZSZm1WifEazwI7LP7lQwsKPVc2TZfmXjeuH8Q=;
 b=AswEsCtj01nAh5pXInPCoJV/rtbZ18cmgIbmb36btkt/+ek6bJRvGoj16n27J9Q1+1d+
 dyguCAuubF+VwmJVhwUb7NyhiWvTQTYl3MNc2dn9sm/pJC+NDVvWBVFRDUGLWtdKhZyP
 eydTx4SZR9NYd2ynGc4kxCfK4qGaQmecbC9OsZHZhzJzd/P3cTJX77W8orxfRh2zXAfI
 xep7sOeG8xqLd+kGm+f9lGRY+cqqJ3nika+JVu0zCjbYlMORD2gahuZTRV+jqkqSeewQ
 7zJf9SV28TnTrGYbYefY6xunewHwWwMn0CGBF7GD1whc8iLg+nebHzueDzS3gTvDun11 6w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pFuY12ZSZm1WifEazwI7LP7lQwsKPVc2TZfmXjeuH8Q=;
 b=XNL5MhgaeLc762LYQnUgUIjR9VwnhLlxUrUlpvH1NvVrEfnX7uCtqbRN8w3dyDbwavkU
 +ewduIt5EBQaZNrEYzB3RFTL0CWldg16/MrEinEuoxwGLIVmSoudp+fbwLXIdIiBKHaa
 LJtnYBvdk53nx0jK7NwYa3w6hrIQywjgo1DVvvO5238xIwJB6xG+5D9SntM71qS9/v87
 BBTjtwxu/6tMZebagYINsikyBsQ1ks8uM985p5PlPBI2sLsgrbp+Id8sYE0vOl4oKw02
 LsFm5l4q9Py6xEbMeDRH3UfcZBZo95H4LQqiUf6ggUxC1RR13iEtLOCEICl/FsIp+0fu pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjvdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5GU6030687;
        Thu, 16 Sep 2021 10:09:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3b0hjxyd8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TP9/t++QtrOagDDhpdWxg7DNhuTv5MKKI3litG9rAoQaAFqZ9bCLBawJC0rBLR2HFsAanVHqW9sXvG1x4rrTmhAdm6tcmlgKVlNvPDEAqsmlSeEdwjcl1HaoUC6FSQ04DF6l8UpKoE9FlTGbLgsBqiJ9HWBQDExLqYC246VzP6+I8CkW3Ly9vOJKxuTTvaqpBjk2GtKRDipY7tZk6OqhkQauE9qjEHULwVz4tleXKKbhsJpuiT50jiCnPLYh3O8N6gOMSUvslfgcZHViR5Z33M5SYz6rCYh+2658CZJGxWfUXc9jcib/i0Tq6DzHFwXFOU1nWVbJurp60RwJrGRw2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pFuY12ZSZm1WifEazwI7LP7lQwsKPVc2TZfmXjeuH8Q=;
 b=Yu4nV7NSyRWRD1BHraJEmHstd7mg9vZLK3c+PfEzjjdDaJDaRFtbk3XHILPOXnNN901v2GF7fHPKicTiGhSA6xuMIugE1EpsfSkj3apvhjKgdKhs7ZYWrwgoCZXzJL3mxIYGSa7FJb+ebfhUtnpY9m31ZAUopYLeCThenDaarRll5YNrn91jdwPRFTXgZPoKPHpaUJFyb8mJDMS8mzrBPZWu67PgzQAVMVDZRdQKJzafVmCVfG9aBs9Q8//OgmsLfRYz2iQzWMaXiuW/n8F/jt0Og7IUkj1z7N5SZjagpMlsn/7bwTsyMiZEpgIr41Ki+45hcK+YpPPS3qS7dzmTsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFuY12ZSZm1WifEazwI7LP7lQwsKPVc2TZfmXjeuH8Q=;
 b=riDkdluDV5oQXV505etMikIQE4KwOPKv6PPsTpNHr8cIWFTiSdo58E5nYcEmgq8mzj6gjKlp8QBcrW5YBMxR/BQDR/vrUDyAqK8yzRL1qYOWohNu9wN0qjB6sFvkCOYJcGaPKe4jllFkrr/cBgGUILqbNpPeF2Hw2i/0YRulV7c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:08:58 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:08:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 04/16] xfsprogs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
Date:   Thu, 16 Sep 2021 15:38:10 +0530
Message-Id: <20210916100822.176306-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:08:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79b216fc-20b9-4dc1-7f7b-08d978f9ffba
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748D46DC9D7CD78C2CF8C01F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQ307f6zXQWoszaWWY0flZn+0PR/e61zbfanS6mFdZqWcv83TRjCpcUdA76NVOfhoPlp0Xz4a5kPaBmCL/Eh7thvmY5erozzY7yhSHLd2noLVO8/Q3gosvLgPkfrwt2bJeXIGvGDqLVSZoVbu7CRO536t9vxtKdtt+GugEWrjiKQI77qa08PlpRyYIFAzcUU+cEk74zXHhuaiS7xA971eJN7mTDn3NUxtRercE4mlP9tSI5a4JWDIm67XoX52xxZX3hHdarNmNilbizSSQxN3v/vLHufryq/UNX97WYTYawe5YqhUoLc/jDoLnm/I4Vd8xz047KZ1T9ggw307CJNrw7yPudHQfNZZ75x4owarVXl4cmCElqieApXDmRJN1Gw4ZfcrlPTduKP5tjvPev25RLoq+qDg9wSK6jcdMOj7RNzpv84lhqsGw+qqmgseofvNe05f4nZT5LjUtJICaFnel26mY5+aX6tYKuYYjetzMOpJHSGVGj/GhGPSF7uSA/VTmBU0pnX5R3bAaYnV0yZIINVLvnYacHqk0jt48Izhd+JWN/D2Y8Ws02GBo8JsiEuknzp55fdHxsyE5ZR0wc6cn/U4mE5HB7RcwCmJH0k6ISmUkOy2oKDG6ckNZFQtJfHMj+b2sNE6RJqzrBIjE7eqpUXnYywscaBaKzIA494c7/f5Ir5kMuCPfSKXHwuLJDV1buuiTofXs8N1gTUSE3onA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(6666004)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HpxSsWsBOkV2CRyLpEkQq/p7XJGg1Wk2BwNv0u9aSE9nR5Olc9CEtUsQimTS?=
 =?us-ascii?Q?aMKuiTKZTjT4O08hGHBQfFo06jjORe5CAItZu0mc9Eu+akkCSmDm/6+Hrxwr?=
 =?us-ascii?Q?PY8AGxFKWXNRX2KTNgCduZkD+ucgCLqNwxvEaNGPBh8W9FEsfY7Hygtjm/hl?=
 =?us-ascii?Q?dM2HB9ZMC+Y7sd5d9mZnF/ZySbYG4DOUlznZ96/JFG7oVGB9bsc33TIhWgmk?=
 =?us-ascii?Q?h9KUEq9urXFXpJQSvXC2eEUZGm/1rSPP6yB6RUxNqIUiAbjXSvyZjul9gWiF?=
 =?us-ascii?Q?NOqklnBrPQAdXwly/cRvOWhdM8IfTqtG2W2OS+6fVUYvgEq+lDL8vvYDXQQs?=
 =?us-ascii?Q?qH9OvFb5Ol9H9mbUVgbL6RWA7sEwYbzncGeGgaacInnbkKYfXP/WECA+N46q?=
 =?us-ascii?Q?BY6iqxlX9vNOmdwdv1d6PR3ChTgTK595m+jbsylvGd9J0OD2iaW6hW+lgPBp?=
 =?us-ascii?Q?GWxApvXjxCV9T4ivQ3UzdcaveWpI4FR52FITw5lk3WyLvTr77aqDGfDRtpCk?=
 =?us-ascii?Q?A4cLJnLo1b0Bz0yzHJqxzWySYmCpBKQyGTgXKtCNRSDh7U3fjC5SQe6Ih281?=
 =?us-ascii?Q?aCeedDiwPUIj/yuLY8HDbPgBlugsC8pzb9XWzKd0lYzpRu8CTwjJxk6zMZcJ?=
 =?us-ascii?Q?jnv4FaY++9Rnfa4JgdOGq5+OxJ9eU0Kj8yF2BcKMKhLoSotUnUh7hAQR95nM?=
 =?us-ascii?Q?8NQKrqxDZezJHELkHrTHCtrDbEHdYV/ny4pXco4Q/kG0/KVfYJyd+ZEv8CN+?=
 =?us-ascii?Q?9H2R5eIT1qeHbweekrVchU3qzcU0WryYY5mEmaTMWgfHpNVfpr89uwMGhHqI?=
 =?us-ascii?Q?DBcLxVSGAufV0FJCQOEBZP1+mojYtW+i0tE9gAfZ5GxDdcKybo8wtpA3AVDl?=
 =?us-ascii?Q?kaDkaTgWy305bdRwY6O8ARyezHnITPVjRxlnSSNsZ4aw42u1SQ2bERvVeS4e?=
 =?us-ascii?Q?x+8ZvjwByXPIx4nZGi8QzJwO0NNlWK/NwkNtmTz3HRCrZdT0S5DxMlD0bbeJ?=
 =?us-ascii?Q?vdbJl1JeXtVv9C+GV51Mv1dZGCpeknJAMAa5CaaoP3UMCYJVQRUcr79hX8L4?=
 =?us-ascii?Q?moLBoGDOXx3Lk6np8yL4ZSPpREv0niky5RPM4vEi8uMUEtWc2VJDDNmy/T8G?=
 =?us-ascii?Q?wFV5oEUmbUauRnXbnbcF6xPP59loIY4X4EeuApADIU+rVScxTTGuanCQftG7?=
 =?us-ascii?Q?Ea315NTuwR/Bt+OCVUX24QuGOa4PbM9X+RTrPNfxTQv64dvV6mz469vTFpWr?=
 =?us-ascii?Q?r0AknJjFdLZO9OsSTZnTzuJVvr62WDUGs38Gf7Kg3RJCBx6JBVgQYSKKK1Ho?=
 =?us-ascii?Q?VHXos9s99M0Gocg7IiDBZgSt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b216fc-20b9-4dc1-7f7b-08d978f9ffba
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:08:58.5653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wlj/WcUrP61liGwXteGZimfiJtKl2A+wVcgPu3T1hGebilALIC3W/GYeia0Uc0WRc+yqsne0zVi3qEbw3ljYaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: SamdsFuKXI_Y5zdoUBni4tXEb1gmBx5F
X-Proofpoint-ORIG-GUID: SamdsFuKXI_Y5zdoUBni4tXEb1gmBx5F
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for introducing larger extent count limits, this commit renames
existing extent count limits based on their signedness and width.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h     | 8 ++++----
 libxfs/xfs_inode_fork.h | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index bef1727b..65ad15fc 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -873,11 +873,11 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for extlen, disk inode's extent counters.
  */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define	MAXEXTLEN		((xfs_extlen_t)0x1fffff) /* 21 bits */
+#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff) /* Signed 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff) /* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 6ba38c15..e8fe5b47 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -137,9 +137,9 @@ static inline xfs_extnum_t xfs_iext_max_nextents(struct xfs_mount *mp,
 		int whichfork)
 {
 	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+		return XFS_IFORK_EXTCNT_MAXS32;
 
-	return MAXAEXTNUM;
+	return XFS_IFORK_EXTCNT_MAXS16;
 }
 
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
-- 
2.30.2

