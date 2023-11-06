Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD97C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjKFNNI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjKFNNC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4AF100
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:12:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1uw3024922;
        Mon, 6 Nov 2023 13:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=JszUE3hDIwu+ktwFgTaUEwNT/MEZ3xigHTSeM3YS8Mc=;
 b=RBr7v5TlgHoc3yqFHJjrO0eG0cAU0WPNPajt0H/9Aub/Ckq5G1izLCrgXL5XFWxeijzE
 atCzILitbK/XlLNM/6hPrX5Od0/L0zMl6PESKC8eFvwdCbsGxPCsewMINifrjQzdzomG
 QEEFxE8eN+6gm73nXYhXgbwn4I7vuRiS2YeRIBhSW5nHqjXHrorX+tnS+yX8Kg6iPQVB
 z9ZdOX9ZSa7Mz75w94/M3x+Wh2XOK8of540IVSuHlChIVUW1PnpTt9PMJqE2Jnsi6NtG
 c2GfE3th+6VNyQy4VoDig7tnDo45TJ5w6nHYr2gh+W+KNv1u6mTR7wpS3N9wcyCGQqWq dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdty71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CH7Dn030442;
        Mon, 6 Nov 2023 13:12:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tcks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFSz0T5w5LtfPn1SAKmE0wEtnJu9+vhIYNqUaQfxp5tpq1oTkRLBep4fnFzVxFZlJlyu4pnruvMjHr+fKX9UnGpA6SfBLvxzGk7U2neyx6GPAP7NqV+shAMxHj6SAOss11/c0HE0pKdcwIsNIUHbA+HGLzTXq7Sm5+NxZtUrWR5FFzRP+ceujOh5h8ZGu8AhF/uoRkSUXVPuGigFGAaAcYX191iwd1jd0iVHPesesmSE6vIMol0mE0yQrnGs6qeYXpH0h+RVSKDlz/JF6UEbqC8bbOZ0sno96jiXz0iJiBe5IyA3aM3KFkpjbddL3vA0AT8R4f0DKf45wLC/HVw7Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JszUE3hDIwu+ktwFgTaUEwNT/MEZ3xigHTSeM3YS8Mc=;
 b=NtTkMxYfpNrfnRRY+1eaFMm54j5yf2LAvnEdkLl2ekwuqXtRvNmxgk78nv91Y9cPwjoiRSnI/4W/6P6dXOcDbbNxwswwrFPM51ODIrY+ads05omK/PfdpfgZGiAC445CAtb+h3Ccg5SxAHMWdCJWTLkHtRk0lRGnJSIKurwAxZgcyqP6OK80JsPXEkhzx0HEhrbXx/1AiJWYD1ndDsE94PkrPdopmGeFrAVG6fGD+gAuF4p6jYUAU1EEY9bh7dkVFeTpboGPRUB94+qjoGIuE561/TobtjzwFLHpyOY7/2MSIh+U26ru7SwnQumY4jEKOE5yEFUnVE+aWMLiwhvs/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JszUE3hDIwu+ktwFgTaUEwNT/MEZ3xigHTSeM3YS8Mc=;
 b=bX6Z5f3MexMwkLn1/UdPExfHo/RXk9RJGpuMaJqGpz+ZfqWGGAYCoi65sLSa7yaDB1vZ9BnpbffE5gBgxtTaAeKvahCcuhzSNS+GHXBGcJHq7mpX5j2hF2FLKX+Xnnjcbjj6/DtVpoIAWgRK55w6GvV2eHpXXjvXAO8BtSTUnzo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BN0PR10MB5127.namprd10.prod.outlook.com (2603:10b6:408:124::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:52 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanbabu@kernel.org>, chandan.babu@oracle.com,
        djwong@kernel.org, cem@kernel.org
Subject: [PATCH V4 18/21] mdrestore: Introduce mdrestore v1 operations
Date:   Mon,  6 Nov 2023 18:40:51 +0530
Message-Id: <20231106131054.143419-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:196::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BN0PR10MB5127:EE_
X-MS-Office365-Filtering-Correlation-Id: c7eaccec-7689-4600-89cc-08dbdeca1527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cOFGDojM5TMGCtuQjpCILf6zKn/pRCdP3vUPEWDTGvAtIU6LgVfv0xlWwCvJdZVbdu1ssyYSymYIvYpjic4AYSQtJJwZ0VpZOPkCsqyqbBujsdZ8urZMLZX+RG51PtnELt4TJ9S7kdFV6s7nenr/PxkokiFn3TfoldHuIAzz/5PpKwbMi/d/C6hZDHp6NcGGMSrh8laSPU8no2Hnu8JHNFCyuxOK3AWIW+oSa3bhyou+lI3lBdzXctyDXUQn7OSBsbgauPqU1qMTf1IIgzyLY+ks+EyTZ2Bi9zzOxNUcqXwugcBDekCcsBeAiU6IgHwaPzJjqhClosmRG8E0mHZtZFZLVXX1hHbN9TWrIBR5z9lBu8yNY+iZ9MCA3i2PpFdjWIQ4KOUvhcmC/+Hdkipgc67SK+mxUpqqSLg7XuFzdgXRKIZUivf8ChHlQZxsPEnN+XjUaRC6UW8sSvtFvHScnh1htURdNnsjAm0oeBAYNRC5GAkzNUI8U76WkwK3fOopwGwsBOCeXOa2dgyoJMzc8ORVy4WAFhvUYdl8vuQ5mpH0+QWKmLsCUXLdHqs1SlSG1PZnAPOaPlgx5NS4noq9b0PoKduW+3KNoBmffZ1OWJ7xMC4jqAEq4wH3hsQIY003
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(64100799003)(1800799009)(186009)(451199024)(478600001)(41300700001)(6512007)(6506007)(2616005)(6486002)(83380400001)(8676002)(8936002)(2906002)(1076003)(5660300002)(66946007)(26005)(316002)(6916009)(66476007)(66556008)(38100700002)(4326008)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YC9sPEmsr8qZIyR2sgSibFGazORkhKVvgEzxP6/08EfLLAnmBdOBzdwFE8vs?=
 =?us-ascii?Q?SK/yeCH7/I1hG1cEGX25s3p6MQLsX9w0wY9ghkBrZ0p0fPr/GGq3J5srQTsI?=
 =?us-ascii?Q?knosew0y/5PAuW/C8lvh2Z+ljAAJ2H19/ubaRCxeC118UdIKKGgPEroV6ssE?=
 =?us-ascii?Q?PTnE/dzscNSJXWa1924hngST1KjUPnf3DdCNgTmgDtpMrdrRF0zIg7WwzXTK?=
 =?us-ascii?Q?KhrykTWEqR68pmDIKsWk2I0Zyn38wIdPLcI20XmFtMn+PcA4f9f4ENHdoQtd?=
 =?us-ascii?Q?PZirjrQZhVGe1bq+8HhTbqe14LExz91hwmMRriRLD1+YJ6A9l9GoDeddmkE/?=
 =?us-ascii?Q?hdjvDp/1DR0n2YddydRrxg8uxbozjuhI8dOU/AK+BJL3ZR4N43QO/hnjtwJV?=
 =?us-ascii?Q?lIlG1vz3aNuFuqAbKSIAeULIAAbXAMsX8r6z2jD4oqH2cjzEJAF+MeG3TFhW?=
 =?us-ascii?Q?T0+xplycRx4jECBwWmOT20Uk6h1t57Sql+3ti6ZkJ8w0thbeDcHMcTYBYKpj?=
 =?us-ascii?Q?XBCr65gJeNYfcRV1P0eDiOw2DOrVrusZRmVJ7OI0ZujZhD//GwfpEq+aruBl?=
 =?us-ascii?Q?aCLhvl7r7/gOQz4p6l/SefrKH++0HIRJ+O85i+X9IVwODEEzLBRP0HUjF5FR?=
 =?us-ascii?Q?OcoFRoWO7qS76MTFNbAXYByVsvIrb1tnLsc/sMvvQhA2WwKYadWoAjdoJS4O?=
 =?us-ascii?Q?kYs3anrJl0yd8Pf4MD1xmPgdxPPQIppFd6SagncB4fP6eR+WVtMCk9PnaNeL?=
 =?us-ascii?Q?TxVwqffIfX3kDILAsdggFCddvyZcSyTsr25pGccB+wYqWP+SRDyIHieHaGVj?=
 =?us-ascii?Q?OwfDOtAISxS9A/reoYg+REzVc/Yc55BBz6rudj9cXDlsa1zqx7Riy9kOtJ5z?=
 =?us-ascii?Q?jPyp3NdiDcToi0tClvswMd+T+hCmTjzHxSanoxAG+zjyh/EMUzO0q3z9tdsX?=
 =?us-ascii?Q?WZdOqPOVujmDclfuFf99kkpv01LH6mpT9horufigXb9djzEuzRNpOjVz0krq?=
 =?us-ascii?Q?/xLTrZsMH7c92lllp0Zy5YXm6r7t5NJD6eiZTxDhcc0qFPmrASTVMHzgO4hp?=
 =?us-ascii?Q?2rlFmrr0FpSEeiM28NDFRSSzKfMVZ6xrp6UlBcNppDKeG6NVzLzMJPm6SRZb?=
 =?us-ascii?Q?shOpg/lfueT/O9KQxLPRIDmB/HqRLSyAVeFcto6R8QcHyvHnOTGMhLBEdhnN?=
 =?us-ascii?Q?2/kVUIsB7jWbvFAW7biU6NIl2euOA6oRfj2jwNhJZU0kdBo/A8a1DHVd+EU4?=
 =?us-ascii?Q?5GEABn1d+kET+9W8VLR/Fqewn1Ma0P8AmDBFFfbzOl/RmTz29cqrFT6W7hpB?=
 =?us-ascii?Q?UtfxABbAK8UMiULCQORgvhhRBKANma5oPSyQCPL6Qg9Rki55xD3bFtUfObB3?=
 =?us-ascii?Q?BdE1/Y+/gPFgl1vhdbNSpkbVDs7hMWFw5vXc0f61eG3FsDqaXtzTuq8a5WX5?=
 =?us-ascii?Q?ygBb4dIjLNZzXWSy8RyKZPBbEVR9M8QJPZ4Fwr6PaYmeWV96nvgkH2MGr6jG?=
 =?us-ascii?Q?CQgun4wGUkj7yuVgcPwiy7v3xJGnrWPiQLUqz5AbdnyofJSRYpiB7nuHDS6+?=
 =?us-ascii?Q?YWlDQpwj3HYLGwB/B+xjlPSmAEFsaLlUqMy258KRe/T5Eb5i3WrbAGN2g3+s?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5iBHkbkhfWTgj3mGn2fjURbo6s2W14fbCyepra1krNVJynWwClW7Th0iJlPHgjMJtfNKySpOX3eYsalKpcdXonUSRTEgmMz1RccwQ6phi7Qnb6hvTEEcrg8Djfk3n2aY5DvRipZzuVfCEpJ4ArEkWu/O1xCVheO/DQaGc4QWTFLaz5kDV/j+UWjfyqOwY8qPoZ2/1MrBC1OT/lnivF2/VO7xYLxdpalu62impIiqAKgEdrCXyO8krt9h6IEnYHvGiE1ruxyKLUjayBr5mtu/T3W3asTGcmEHneAgi5kScsIa19EF9nv71szN3cVVvkCwtmfjEG80b96OOs92e58LKbM8ncm+ZiuP4E/ONLb5MmYikuFTOm/2blKIPAWZWIZo9SDply5WOaHiZ0srfP+r5BPBhMStZ5dYdp+FtAq9FIg9haXBbGQKUmIeFeqNy3KE9aZAGg1YRJqQ8qVt8QWRJptgCp5GSShyjiKiIJNHNGSWCQQlwXNy72fhLGH3spYVB3FofgMdCK8qQ+UXtWMHw+CQlJijBUALIP9Y4WhaHwNlv9Bj4PIxQQeNhzacry0YsXAhB3pMpWgkRZ0oxV4tmlDxKEIiJGxObeB7UGnsUh+7NUD36eACgMkI/DTGWxdjxpjc1Il2RCZxM6cqnwAe06wQvoqE2fsMbtOu5Asiq2uzJCE7CxsZPyHsLqYsp66iZKYqnqSmw0uFHJPPgND5aHItjjvX5OqwnRDDpMjWe1KA8pTNay7r0EKm4XR4fPujpIWsszkPJ14BYJWg+GA24Kb0vjSgEy//FK5CBvN+e0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7eaccec-7689-4600-89cc-08dbdeca1527
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:52.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUicWUG+VeiVJr4ByDUg3Bxx/dKCYo0lpObZvKY/8yK3bA7I8ZFUI3pHZLmkQskIRYInH1wt2OwC0A6PDo4mwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5127
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: l0c9bzUAYAYKKOv3GlRIy3b1F4cmJExM
X-Proofpoint-GUID: l0c9bzUAYAYKKOv3GlRIy3b1F4cmJExM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanbabu@kernel.org>

In order to indicate the version of metadump files that they can work with,
this commit renames read_header(), show_info() and restore() functions to
read_header_v1(), show_info_v1() and restore_v1() respectively.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 51 +++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 40de0d1e..b247a4bf 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -13,10 +13,18 @@ union mdrestore_headers {
 	struct xfs_metablock	v1;
 };
 
+struct mdrestore_ops {
+	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
+	void (*show_info)(union mdrestore_headers *header, const char *md_file);
+	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
+			int ddev_fd, bool is_target_file);
+};
+
 static struct mdrestore {
-	bool	show_progress;
-	bool	show_info;
-	bool	progress_since_warning;
+	struct mdrestore_ops	*mdrops;
+	bool			show_progress;
+	bool			show_info;
+	bool			progress_since_warning;
 } mdrestore;
 
 static void
@@ -82,7 +90,7 @@ open_device(
 }
 
 static void
-read_header(
+read_header_v1(
 	union mdrestore_headers	*h,
 	FILE			*md_fp)
 {
@@ -92,7 +100,7 @@ read_header(
 }
 
 static void
-show_info(
+show_info_v1(
 	union mdrestore_headers	*h,
 	const char		*md_file)
 {
@@ -107,22 +115,12 @@ show_info(
 	}
 }
 
-/*
- * restore() -- do the actual work to restore the metadump
- *
- * @src_f: A FILE pointer to the source metadump
- * @dst_fd: the file descriptor for the target file
- * @is_target_file: designates whether the target is a regular file
- * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
- *
- * src_f should be positioned just past a read the previously validated metablock
- */
 static void
-restore(
+restore_v1(
 	union mdrestore_headers *h,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file)
+	bool			is_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -245,6 +243,12 @@ restore(
 	free(metablock);
 }
 
+static struct mdrestore_ops mdrestore_ops_v1 = {
+	.read_header	= read_header_v1,
+	.show_info	= show_info_v1,
+	.restore	= restore_v1,
+};
+
 static void
 usage(void)
 {
@@ -294,9 +298,9 @@ main(
 
 	/*
 	 * open source and test if this really is a dump. The first metadump
-	 * block will be passed to restore() which will continue to read the
-	 * file from this point. This avoids rewind the stream, which causes
-	 * restore to fail when source was being read from stdin.
+	 * block will be passed to mdrestore_ops->restore() which will continue
+	 * to read the file from this point. This avoids rewind the stream,
+	 * which causes restore to fail when source was being read from stdin.
  	 */
 	if (strcmp(argv[optind], "-") == 0) {
 		src_f = stdin;
@@ -313,16 +317,17 @@ main(
 
 	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
+		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
-	read_header(&headers, src_f);
+	mdrestore.mdrops->read_header(&headers, src_f);
 
 	if (mdrestore.show_info) {
-		show_info(&headers, argv[optind]);
+		mdrestore.mdrops->show_info(&headers, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -333,7 +338,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(&headers, src_f, dst_fd, is_target_file);
+	mdrestore.mdrops->restore(&headers, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

