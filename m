Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA350C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjKFNNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjKFNNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F2C136
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:44 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1xBB006667;
        Mon, 6 Nov 2023 13:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=GtfiDGiHWQhg/lFBykhY49xpmv51EHtbMSF0OyQcM3s=;
 b=qsSBIzLiz+5fFrWU+k3DXu1TrRQoJi7bPeZbiXiFVyq1fJ+R4e4o0QbhMwHsOdMJLEs0
 HgoKkWdVIMMnANPqLTVKZT/jB6iNEhml55k3NPn55kRupZiyz88cA009GWsfVn6tLPEN
 35vfLp60eLQ6UebteQ4NKzJzeAwBQw3uoqqMWWy4XU+0B6J51cngE6MXpAGfiE+b9oT8
 b1lyEA4MMaqGzXRhaWfjwLI12H6h8W9UveD/MJ3zcfKteWOjNPFXeeghz9rtBfKXh0M0
 iJQL/ILy9NzyYZFzhNukpyvnCTa3DkHF2gJ+rxADXxyL+MPpOc2t+5WH75r880rDAoIW PA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcb09w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CaunF024808;
        Mon, 6 Nov 2023 13:13:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdba9fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRLy/7Aknkt3tLGQpnbVD9L37+3tTrWaBiEQsaQflejsp+OQQMlug2BY7k2CT8vaXanr1bUUt4gaLklwYQ4+b1s8uFbF6Cn5zD7amzrXcz4V77lk9zJY1E8HA6LcvjMxbCdxvDno/cPvIIBGX5ARJFDSFhGNiS3Mgy/0QmMD4S3dhTOLepLoXcqwbK3frN33hspq24n4VTzBrqf6SHqFOgkGOVQx4QZJHVYikbO40fGosdrd3Mak6akkNylyuwokdlTqiVu2mODuLQeZRV/ITIMVLEbadscFnt6Kr3xiYf8cM1g34ARcMFbnAXtdmp6wohtWvae5WFxLqLFDRKGtGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtfiDGiHWQhg/lFBykhY49xpmv51EHtbMSF0OyQcM3s=;
 b=kS04tjH7/tgOCkDyhlf6kUKBY4PzshWN+/cNsU+6KMgUvCVXeHqLYPhP6pIEPLOaKGneQmtGEmlwOxiWPjrA+kPYwq6OCsaPSd7GzZElfIcSa1iSveAyXBObW5tmAU2xlxx/gl8te+4sO8X53ELpDx1988koUCCC8QaqBTC7HGaai5KbMz9ME/vupfzobIOSMC5vz9qj35xPUZ1HVGTKLWep7tCqBHRJWHUrxKBJ7ZyXENHDTVHE2hc3suCVXdeznNNuNR7yD+Ehk7RelCFtfbT1Rv0mwK0vVI4063eFwTtYRf4NEdEogUB3+bmTPc2Ge/7Y+bQWtOIiYKcFBhhswg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtfiDGiHWQhg/lFBykhY49xpmv51EHtbMSF0OyQcM3s=;
 b=c4sWlNdoLTgm7W+wezbqXc7fghk8py+n4HYwMktQ+6Q6JUyFQHw3aUyqqT2hQfkdvFs4oGp/LryWwTna5T87nsIjrjB4E4QTVtTd6+a65/SaR9UctxJLpQed7SZIWmDx1gWmMUnCsb3lHDg02L+TIXS9fzFLQbp9fXIPFAkPlRE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BN0PR10MB5127.namprd10.prod.outlook.com (2603:10b6:408:124::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:13:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:13:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 20/21] mdrestore: Define mdrestore ops for v2 format
Date:   Mon,  6 Nov 2023 18:40:53 +0530
Message-Id: <20231106131054.143419-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BN0PR10MB5127:EE_
X-MS-Office365-Filtering-Correlation-Id: 05016bc5-6452-4cdd-8b32-08dbdeca1bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SkQUcOR0qPsO2fliA65iw5QTSJ9pPcEyo7piGAWcQaxfsfLPQ2T8klet29wWye+N6zQLblrmx1D9IBxwtqAKnSeAMOKhb9No52Z/OhQDhXsu9AYKyiTtEC3mRNyH5pdQJwVjhpz46ESzx250JmfsBRkDofj+ucGMuk9o/PfCIN7CuSAq5Z5JI24hLgeU2qDXic9ccqeCIkbIhPhSoCjFaAI9/+x6LeJUUTcgPNyg7OUfUfuk3ySPX2DRcAT0SNaMuu+F3Az9p0/yGYKApPQH5RJAO6srS2RF3nmQ4/MykQmokccbr6ezZkauQxkGNdondfkQYMwRbuOjOWdxs45/aqibyUhbI4fei+zcwlD6ev3CWqFgjmFbbj6VMP8ge4pTlcjqE0B+fLJfrbpZO/LduYCvHF3z+5O4IMR+fl/gIAQTRlAl+mgi0Ds+mTrYt07c4I6Q8i+IGYd7WXNrH/zZL4i1IXdrlLjruSHTkpqJHLr6iRHiDRfrCjLM6ZeErYHRdynS9E0ow7QjwWfNTgfNVQLohm4Ovx9RWTBLwM92+bHI6rOcX1feGB6TxpOf8mc8u6td32hKCsPXW6VtaIsyRAYNLXmGjORX8bhf4dKaRup+xpomeDHpcAI4JNO96ySr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(64100799003)(1800799009)(186009)(451199024)(478600001)(41300700001)(6512007)(6506007)(2616005)(6486002)(6666004)(83380400001)(8676002)(8936002)(2906002)(1076003)(5660300002)(66946007)(26005)(316002)(6916009)(66476007)(66556008)(38100700002)(4326008)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C4t92JS2R1MPQq5Z5sp74tOPh0USvo13IgkIUlDk3kO3fLetPrOIQ6/v5Cbe?=
 =?us-ascii?Q?SkPX4/QCS7zTX4/mTL3twQdg3uqk9Q+NlW6QAR3dtJrR/eVjEIDacEjM/Tjw?=
 =?us-ascii?Q?4rFLP2MvqESYQEITtnpN8e3OALd8qfZhDtQmTvXEBBYfVeqCT1k2/v+WjDwh?=
 =?us-ascii?Q?x7ZLgOpqVuz5aGieRUqnvCYutP0bHoXlV/43kkhrMV3jEPOSQttuRzaelLM6?=
 =?us-ascii?Q?yQRVqvd/4uGWahY5tVojFstEQPKFczEKI+wpBVXuYwbfQRbAaH0kM6pPQ8S3?=
 =?us-ascii?Q?k5g08iAWOpkEpVeywzOo0VBn9WThWeWeP4VIx96nXV6ivTNC5X/wM7Tx6Ogu?=
 =?us-ascii?Q?G+deprNibB2tiujMCv3ROj+BG/za7WIgjfbE+8APtyHQDQRjRU2HDcaf2SeG?=
 =?us-ascii?Q?D+3YcpWIj7OI3mzS1GZGXQ4vb/K7AucQCse7puUPjQ4guUN0pXpUZR33Zl6D?=
 =?us-ascii?Q?wk218jFXsZuuf7/Ulb6ESupRG9wbhn9ZIfDLBE0fh4G3SgfpaCiR++p1cyz9?=
 =?us-ascii?Q?kJhMUUkiwfcfK3GLnkZFgyriZqgAIdgtqz+B78aXY6GgLC0igmgB+/2psf22?=
 =?us-ascii?Q?ZfE8XBbYVnKsXzPuTSkxXgYnbRtW9ZpsPDpd9i4DIod3xkrzNz0B+u/Qa33k?=
 =?us-ascii?Q?oFtYVUCSRFMQgTbmRImT9z4myr/fqxpmfTkEvUdmS9yrvLqP+k7SVriSIa3N?=
 =?us-ascii?Q?+GL9zMCkG5BpYNdd9ElebqdQiE3pr/DjkdSuX+7Prbdyy6g6+JXvuXFyTPYR?=
 =?us-ascii?Q?jGnat2n5/QFHdollGo6BnzxNqj19eSZvGCxNxx4Bl3V9qGzUvNwYDLwdDpjZ?=
 =?us-ascii?Q?PhIVQ8+OlISEr2y3guxQjA+u5iP+IGlact4qbrAvmngcWnxnx5nOqKQyCpjz?=
 =?us-ascii?Q?XEGRo8mR1YR931CfDgdEqw1j5BBmuMunabShY60F/PDe/IGwbUtz4/RjA/bm?=
 =?us-ascii?Q?ZaYiDnxvS1hyTq4IxKg+kMtdSJL+JzIs1XIcerrhxrmJEeIKZhw//NkRADMy?=
 =?us-ascii?Q?nsl5MCwD6tTYdRZpynW8ynasKeVDN3OFw/D7di4HLqOitdPRHX7VLSAOBR8v?=
 =?us-ascii?Q?voTh568yX9uLmeOpXLbGSRNoTNbwzdmoHD/7L+ZZEK+5K6rs1ugVPFiUHScd?=
 =?us-ascii?Q?chv35KSmHP44ggFCLoEcmajE8Uqs6F0giFAzrn0Fny6qkx567BUGGdJHHw94?=
 =?us-ascii?Q?cnSpMUBrVySrCleyFoybtR3/aVGCLLCw8MIavihNeiKJOwV8uo3rMdxnmqvm?=
 =?us-ascii?Q?WZnYi5lc904pZSNww9WH/zBTjhhAtjpzJKipKdC/AiK0jV0CXGShickokv0Q?=
 =?us-ascii?Q?V4BqP5+rm8XmESxYGPB8J1MSXWiUp+cb+qbT8EGg8Smk35/+jrCxcouX1fNW?=
 =?us-ascii?Q?k04KgVww06Ha/IGMZR81Pviu7VJE0e+jevyKaIH9n96uGfPaJnYRN0LVme/3?=
 =?us-ascii?Q?rTHBlZoEdat6DvtkyJweGDtCsBoNIHzJAz687DPfQ3AvlZU6C2xXAtje441a?=
 =?us-ascii?Q?sh74ak/xFVlZ5MBdY5sk6rdn0mVBP+kBw3uALWcgtPu9sIQntRqFK9YBpCmD?=
 =?us-ascii?Q?KwZZddZRbe5rwB/RBLIeHTMtJYUIDbEPeOfVNYNpAdKveU0WrkcjGIJOLzy7?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OR44VUlzBDRu1Tl7ROJpHKSxL9iNrI9NUxDJ7orFyy6gFV6Y79WtiGeGMoDNdeKRADuGm465NLuO7adKdTsM+ILYyvNqAm4iRguwNYrxqsaGMzYfVJmlB6lEBhIQy0jZUuuZx1SQtJ8e8/H6HbfDf6EP9jIQW3uXQyObnQzbZQF3+ouskMdQDEQ7ldIOVy1DsofBNihp/0Q5aTmnT31Lmr6jeU25SR1VzaNqA4w1Wk4d1meHd66LfvpdrmpZbjibN1AeREMWx3SSnnLsmyRphPAR6pWBq2pZWixJ3ncHAad45jEKCeV6HHIYwpFdf2qVeIytZAzRPlmdsXBJ7wPkD8yRSAqdEweEYII4oRbGHZ48Oq+C8tb9fv5mA50alOLkydj3A66Cd4PRzw/mykrDjZ42mWSRzLzAhyx4gf+pLF8+FsC6L6/KEOt++7e4E3Q3dUIu6LaPr/gBcFfKVXoJCKN6WodM2DBTXxUZG4RaI4haDKqeQ0qo10TGa8gDv1CtTzTeMz1iUbQtNPJ9xdkJKsVj3GbYb+8zy1n9K1wYvglPlrd0GbSrBeOpccpZH9e1nEPmNbpz3w2wddjRsBF7bvNadj9ZX8TgzqZHxRWhAaDRNeF5mUdp+yG7wvjus4EftpJPSNxrGoTJ3C0RNd/ltCcNCHzF59UujrWhzJ9sv6L1fh/Sk9AQ81YBnW61v6ks2rbw/iEXHLDZ+0d7XYzbei254K80OUWZfs7lNC/Xa/UTJxmRS/2xn3xacBI9iGvhVG5Gl6PH7NlH+DA7Kp2ZlnfGt9tHwKR/x+bHGvkFsVI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05016bc5-6452-4cdd-8b32-08dbdeca1bde
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:13:03.8168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7UhgKbMoAqwIJMGlDowM1nStkh7fmk5hKQR9jMlL7MrzgjoICflqL1ziMqqR8w7r47FEY/MAX7KqGybxUDNTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5127
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060107
X-Proofpoint-GUID: CMzpI9nxrXFOoldnMHfVg2J9h9GGfVRU
X-Proofpoint-ORIG-GUID: CMzpI9nxrXFOoldnMHfVg2J9h9GGfVRU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to restore metadump stored in v2 format.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 240 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 228 insertions(+), 12 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 0fdbfce7..105a2f9e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -9,15 +9,17 @@
 #include <libfrog/platform.h>
 
 union mdrestore_headers {
-	__be32			magic;
-	struct xfs_metablock	v1;
+	__be32				magic;
+	struct xfs_metablock		v1;
+	struct xfs_metadump_header	v2;
 };
 
 struct mdrestore_ops {
 	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
 	void (*show_info)(union mdrestore_headers *header, const char *md_file);
 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
-			int ddev_fd, bool is_target_file);
+			int ddev_fd, bool is_data_target_file, int logdev_fd,
+			bool is_log_target_file);
 };
 
 static struct mdrestore {
@@ -25,6 +27,7 @@ static struct mdrestore {
 	bool			show_progress;
 	bool			show_info;
 	bool			progress_since_warning;
+	bool			external_log;
 } mdrestore;
 
 static void
@@ -144,7 +147,9 @@ restore_v1(
 	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	bool			is_target_file)
+	bool			is_data_target_file,
+	int			logdev_fd,
+	bool			is_log_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -197,7 +202,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
 			sb.sb_blocksize);
 
 	bytes_read = 0;
@@ -258,6 +263,199 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
 	.restore	= restore_v1,
 };
 
+static void
+read_header_v2(
+	union mdrestore_headers		*h,
+	FILE				*md_fp)
+{
+	bool				want_external_log;
+
+	if (fread((uint8_t *)&(h->v2) + sizeof(h->v2.xmh_magic),
+			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	if (h->v2.xmh_incompat_flags != 0)
+		fatal("Metadump header has unknown incompat flags set");
+
+	if (h->v2.xmh_reserved != 0)
+		fatal("Metadump header's reserved field has a non-zero value");
+
+	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
+			XFS_MD2_COMPAT_EXTERNALLOG);
+
+	if (want_external_log && !mdrestore.external_log)
+		fatal("External Log device is required\n");
+}
+
+static void
+show_info_v2(
+	union mdrestore_headers	*h,
+	const char		*md_file)
+{
+	uint32_t		compat_flags;
+
+	compat_flags = be32_to_cpu(h->v2.xmh_compat_flags);
+
+	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
+		md_file,
+		compat_flags & XFS_MD2_COMPAT_OBFUSCATED ? "":"not ",
+		compat_flags & XFS_MD2_COMPAT_DIRTYLOG ? "dirty":"clean",
+		compat_flags & XFS_MD2_COMPAT_EXTERNALLOG ? "":"not ",
+		compat_flags & XFS_MD2_COMPAT_FULLBLOCKS ? "full":"zeroed");
+}
+
+#define MDR_IO_BUF_SIZE (8 * 1024 * 1024)
+
+static void
+restore_meta_extent(
+	FILE		*md_fp,
+	int		dev_fd,
+	char		*device,
+	void		*buf,
+	uint64_t	offset,
+	int		len)
+{
+	int		io_size;
+
+	io_size = min(len, MDR_IO_BUF_SIZE);
+
+	do {
+		if (fread(buf, io_size, 1, md_fp) != 1)
+			fatal("error reading from metadump file\n");
+		if (pwrite(dev_fd, buf, io_size, offset) < 0)
+			fatal("error writing to %s device at offset %llu: %s\n",
+				device, offset, strerror(errno));
+		len -= io_size;
+		offset += io_size;
+
+		io_size = min(len, io_size);
+	} while (len);
+}
+
+static void
+restore_v2(
+	union mdrestore_headers	*h,
+	FILE			*md_fp,
+	int			ddev_fd,
+	bool			is_data_target_file,
+	int			logdev_fd,
+	bool			is_log_target_file)
+{
+	struct xfs_sb		sb;
+	struct xfs_meta_extent	xme;
+	char			*block_buffer;
+	int64_t			bytes_read;
+	uint64_t		offset;
+	int			len;
+
+	block_buffer = malloc(MDR_IO_BUF_SIZE);
+	if (block_buffer == NULL)
+		fatal("Unable to allocate input buffer memory\n");
+
+	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
+	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
+			XME_ADDR_DATA_DEVICE)
+		fatal("Invalid superblock disk address/length\n");
+
+	len = BBTOB(be32_to_cpu(xme.xme_len));
+
+	if (fread(block_buffer, len, 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
+
+	if (sb.sb_magicnum != XFS_SB_MAGIC)
+		fatal("bad magic number for primary superblock\n");
+
+	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
+
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
+
+	if (sb.sb_logstart == 0) {
+		ASSERT(mdrestore.external_log == true);
+		verify_device_size(logdev_fd, is_log_target_file, sb.sb_logblocks,
+				sb.sb_blocksize);
+	}
+
+	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	bytes_read = len;
+
+	do {
+		char *device;
+		int fd;
+
+		if (fread(&xme, sizeof(xme), 1, md_fp) != 1) {
+			if (feof(md_fp))
+				break;
+			fatal("error reading from metadump file\n");
+		}
+
+		offset = BBTOB(be64_to_cpu(xme.xme_addr) & XME_ADDR_DADDR_MASK);
+		switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
+		case XME_ADDR_DATA_DEVICE:
+			device = "data";
+			fd = ddev_fd;
+			break;
+		case XME_ADDR_LOG_DEVICE:
+			device = "log";
+			fd = logdev_fd;
+			break;
+		default:
+			fatal("Invalid device found in metadump\n");
+			break;
+		}
+
+		len = BBTOB(be32_to_cpu(xme.xme_len));
+
+		restore_meta_extent(md_fp, fd, device, block_buffer, offset,
+				len);
+
+		bytes_read += len;
+
+		if (mdrestore.show_progress) {
+			static int64_t mb_read;
+			int64_t mb_now = bytes_read >> 20;
+
+			if (mb_now != mb_read) {
+				print_progress("%lld MB read", mb_now);
+				mb_read = mb_now;
+			}
+		}
+	} while (1);
+
+	if (mdrestore.progress_since_warning)
+		putchar('\n');
+
+	memset(block_buffer, 0, sb.sb_sectsize);
+	sb.sb_inprogress = 0;
+	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
+	if (xfs_sb_version_hascrc(&sb)) {
+		xfs_update_cksum(block_buffer, sb.sb_sectsize,
+				offsetof(struct xfs_sb, sb_crc));
+	}
+
+	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	free(block_buffer);
+
+	return;
+}
+
+static struct mdrestore_ops mdrestore_ops_v2 = {
+	.read_header	= read_header_v2,
+	.show_info	= show_info_v2,
+	.restore	= restore_v2,
+};
+
 static void
 usage(void)
 {
@@ -270,15 +468,19 @@ main(
 	int			argc,
 	char			**argv)
 {
-	union mdrestore_headers headers;
+	union mdrestore_headers	headers;
 	FILE			*src_f;
-	int			dst_fd;
+	char			*logdev = NULL;
+	int			data_dev_fd;
+	int			log_dev_fd;
 	int			c;
-	bool			is_target_file;
+	bool			is_data_dev_file;
+	bool			is_log_dev_file;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
 	mdrestore.progress_since_warning = false;
+	mdrestore.external_log = false;
 
 	progname = basename(argv[0]);
 
@@ -328,6 +530,11 @@ main(
 	case XFS_MD_MAGIC_V1:
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
+
+	case XFS_MD_MAGIC_V2:
+		mdrestore.mdrops = &mdrestore_ops_v2;
+		break;
+
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
@@ -344,12 +551,21 @@ main(
 
 	optind++;
 
-	/* check and open target */
-	dst_fd = open_device(argv[optind], &is_target_file);
+	/* check and open data device */
+	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
+
+	log_dev_fd = -1;
+	if (mdrestore.external_log)
+		/* check and open log device */
+		log_dev_fd = open_device(logdev, &is_log_dev_file);
+
+	mdrestore.mdrops->restore(&headers, src_f, data_dev_fd,
+			is_data_dev_file, log_dev_fd, is_log_dev_file);
 
-	mdrestore.mdrops->restore(&headers, src_f, dst_fd, is_target_file);
+	close(data_dev_fd);
+	if (mdrestore.external_log)
+		close(log_dev_fd);
 
-	close(dst_fd);
 	if (src_f != stdin)
 		fclose(src_f);
 
-- 
2.39.1

