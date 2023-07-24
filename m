Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD5EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjGXEid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGXEic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC36B122
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMVe93023475;
        Mon, 24 Jul 2023 04:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=PI+4zVp8Y+5j2ubtG1k9L4tcOO3YVJv6N9XwKiKJugi4rwAoDM3wfFjB+uZMYOMMYcMT
 2zM19upB+VR/BxoCyKTvT3Q2Bw7vBxKwDjQmkxDwLRpOLAI+oKxyEFvdAurlDBRcYMAs
 Wf8iAihzK9k1daf4nSLdGgtgy2+UnDJkHG4y5YAkv/oZ65y+eRi71V4WxjPdQFf7o0TL
 eLV5zIswHS4uVdiBKEPqvjd1v1lciuKdqybCtSLCRjLSk1F8QEwW9LH/u3ch+OwwrV75
 Flzz1RQ2Bh75DvqgRarBLch7a3FONxJDmreM+VXUu7GdqqY+3uzVTkAbUh2NK5JAIuUb gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdsv9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1qTRH003866;
        Mon, 24 Jul 2023 04:38:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2x9f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adpzdKvmCNvJ5T4Y8SkQCCydAD37QO4dKfEcexjvJ62diDm5mIS3o/wv4VqEc0OFXY7lyM3I9dG11vmNZkjBkahFv7KLQGfQ9cevinEUIBfmBQ1M8Jpa+FC7sGXDEHfw2YwVD7ImfxzSfFWPO8EfSt38c4ySONRr2JsLq0QEws0v++v5wd505XMjCXMozTQ2RKFhx5Ofxs5gy8YfrpuptEHmO8KB2By0ZxpkpsI+BAtJtuVhm7kQ/bt/uMi2OEjYT7f2HmuiCE6JT4kJsPHKSKbBXKPe7LN1/Faj87uCDhr6Qz4BvkDfRah5ikHiVnvm6i2q9kNlBv7a1MZ4+H6rbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=CqaaUQ60glc/upvSIHLiIufynYKhrtb8H8p3KlVXjWnMipCXj79zTcQTfIajGbmMVQh+/LrsjV8xG4tr+wY3GqxoyYruK6YWzUWE4FEQOW2Xw/S7CUm/Q1rhk1s+/JiWeEv75bB33EP/jOv134ICIv4BiOSU9bw+1yl9LjzOtTRbVsXaagg6c5qDW6EHs5EA7YIBtkhy2vsENjba/SjYLbMUwpmymXMHNVx2TczOKzwzZBCh2S2l2JNi5uEGp9IINqa5fRf+MzEfcqszQbeU3iPCbuPntj+PfaCFkxpiNaiVtk4cUzH2pLT8A7lHmMi2j6aAbv57+2ls2rxt3LQ+Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=bQrAQ1HrmiS4KI60DYyHuN9YuuZoUhZTcrYUTrJqs5o0sb1Z0HRd3Xk4F+ZSSryyki/Xl/jEv4zJR/7F8DOto/XJDO8ajk2CTsxClUb3EtSzl0vpnXxHIkVASrWN4aNgBdVmExyhOdRF2gdGiVlKeaEEUSdqQw31+l+k9m1Kwto=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:38:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:38:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 16/23] mdrestore: Detect metadump v1 magic before reading the header
Date:   Mon, 24 Jul 2023 10:05:20 +0530
Message-Id: <20230724043527.238600-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 57f858d6-b8a1-4945-625f-08db8bffc9a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GIjFjt/+EeFbRwPwbsoW3t16LbYw1VZi61j7/8XEbeCitBZiyXorUa8vMly4mfg5NEHm+GOo9TpTAjz2ylIPUirgYv2XpaZOxXVyI633/AV3/tlOUpPZzv7KoRL2ujqj2LkeVhVDR8aSvwxBrR6dZ6lopr6ADFuB7WGJMfvVZqrUm/37Sl4Zz6Zhuw6zZh1kOzDvECL5xBBKYoMOmE9POF5hOgeo7YafR/o4RM85CTluT1DLPy/WMkmzgsTpVLOodksxyTNBQlET2xq+oqP9Q0BURGnfaDIyRBQw3lmOd0DUJ4er7jJhQLgz/sv2LR/0eI/ejh6c/CS4IjOslX4rRyvSSD48CXJRPm9GtmVoysF1qefKmv/CVdnY7aXjD0N5MVwzglp10e3tKtLwDh0pyaMoPfH4DUKiewN6gYopx7qmJRa6kxpbG0Us4HgY/im7zbao+wdr2IX9vHlz6JarvUJjjYMU9bSnCPK4vzeqkvE8/p82gccH1hRHjyxRdYa7n4j8xdk5MNXMROimX4Tr1amy6HM/yqCoCTBL/vHdHcxMrhttCkImDzqDC0YLyWPi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZPacmsMQql/QTaJaUx+JWu74RKjiHoM0DbA4CMQfyBs5SflssuLI5gQsBcd4?=
 =?us-ascii?Q?mCVXCgXCs69RqZ288gUApByK6FLHt9U4g4PVJVTWQXKVs+cSiumL0LxnkbII?=
 =?us-ascii?Q?2TDKWHUP4lmHb18jEtUXr2D3uOqWD+Svuvzg7RROKMIrYKCXvU13R82UKsNJ?=
 =?us-ascii?Q?NSKK/9v45GQio+BZaphp4BwiagpCgcjRm7m0sSf5OL6oijroCjmMuCkUQhZ6?=
 =?us-ascii?Q?dP7es+ICmgU5GbvM5I8WqkTmWHVEWag6il6l9ZxGXwuAnhmS3mIx+GVoFsa9?=
 =?us-ascii?Q?ODbzkbtjitBGupDkD8WOD0nw3PKoj+IByOk8FGCWepO46a7diBUSb83SoWYT?=
 =?us-ascii?Q?/XOJFI4Bvf5nDMlML3q0DfhV5fAKH7BAxYPPhLntWrvts7YiUqcBgdjcFYhD?=
 =?us-ascii?Q?hZ7gs2IcVEEuskprdaqdLvDIl4Vkm4ue6zbcc9FiswfEQVat09JsjR+ulJg8?=
 =?us-ascii?Q?MdzCioem5invK/eKZgGDwSwSZk3cqgtq5wxnXJbtRKcktBPL+mAjxFQ1GU7m?=
 =?us-ascii?Q?dfrDDQAySDrv56UtXAC74oZxftoQziLjv86gSEodxu/0P1Wgh903lM3I8NjB?=
 =?us-ascii?Q?Di9cBI7/Z8Hjipx8erijhL8AvTazQENNALcuCPDwvNqc3ZuXERkS3BspNk0b?=
 =?us-ascii?Q?2Zh13oxwzoufHdlpYhIaxh9b7th1+KrXI2R27jEsXxWlKQ3jvM/7YhIcPzlC?=
 =?us-ascii?Q?axFYmb5hsH8Ik1DGck1ywQiPF3G5cmlhSOre2uQ8MxiIsK6QcRWkrYrkrhwG?=
 =?us-ascii?Q?YRdN+3dWnHGZIuAUkHxorZCrJsUTRQkkdtE/rtso5WaqFucxmn9agz6TG43e?=
 =?us-ascii?Q?Y3IvHbyfPBDinfIOkYJKuvsFrrJgPwRwebrMf874L5vH1Qx8arW2lIIGV6WF?=
 =?us-ascii?Q?MnJqOhJgR4OA4YvciWPqXClSsgIGHRUl11+VwWmE7e19ha4E70shQtJeFKHb?=
 =?us-ascii?Q?jcm2hGauMsbAZEoctuOJGK05PTZ2enW11Xy7iLf4LM8YypdnIlQO2mmbpbTo?=
 =?us-ascii?Q?xiTSY7d83yk6r4BmVXIhIeLoTemvyHVyOsARKnQX5uCYGnQY12Zek7Ivnx7U?=
 =?us-ascii?Q?Qn1Pgr6I44bqw1usRA4TSI/mL3FrrREKLJmk13HMfOfjHYaoeKHQ5zef9lf6?=
 =?us-ascii?Q?IRXUAHGrWJfMgrW/cyljDIgBNFGq3c0No3wDzrdYJo+PVY371lthmvX2Pvr7?=
 =?us-ascii?Q?ocFM2d/2APDufazvlFx0Sl4nqI2BCFLRLbJjG2VurJD9MUM5hjUvs3tiTN+p?=
 =?us-ascii?Q?I3mHuraUV3D2YErG6+ZTV859/ta4mvnQ5ggoNgJjPjn6PUy+pn+1YQBsZIU+?=
 =?us-ascii?Q?NoP8dvN099aRb9wqJKfiJBKT0vJ3f28waqIc3NR3QDOQ99/jaRHXe5I22hme?=
 =?us-ascii?Q?0eBM7TjKLc52jw+IoOyE+MJ4iPCrCE0otuBR8EziAeZ1pMd1UHg0HOx/0lmR?=
 =?us-ascii?Q?LshOOhcen90TVyh9SspOy1YPdrfN34fcguqb/OTifp9asgD/D4X6EoTN2kao?=
 =?us-ascii?Q?L93OKH1slF7mAOiiDlrYQPRKzNBn8qxdRkI9oH/h7hGvBqYpclYPJxeEqldV?=
 =?us-ascii?Q?Vfjycw7jUt1C+OQKqpd08mHEXYiT7ehtDfyR/2qSvRjfXruEl8dA34lP8phC?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +6/rrl6uQAGouwmsCusK6mzIBujm4OpfrbHMVilDd/OGEO+M7qdsaKa66Gq1ACG+VSLqFFk1X9fnF0LV6AP4p7icVi38gQR1GKUqgciWTTdmyabQPqmcQcOP9st4ggMYi/SUWwTWa1sh3Zpdh1ceipUsUUP8ZJmu49B357ua6T3Z/UlhG7+mSmYfwbskBqAY0FyCglPpCI/npn32uvyzABHxR6VJQBoTtC4EfmZnqx86/WTRtY1rtTYq5SALMuwB2wGOx0DE2SR1vNngExFqWzPhBLEywJtLj6Nf55eTe64qFXzSvHDpqgRq1M7vF+w/Fyxbhu7nPk6ub7qx7dLui+0JnAs6iXPEBIu1VHTY0Wv6JwuyNRcrZre2uA8+6X4lQOu9NdO9NXmWAWExYRtA5uwlCLIOr6+LILRHpvO/xnFZxEQ+U58qizGor45VZZi9xuGdQ2xrBzso5r7tpsmh8Tgpmh1DzODtwRo7/byuo0IPTaUVTkZvhHapAkeK414b2Wnr55OSULQTU8HQdb6T1GqrKh5VBTQLWbyuxNvITIhK+1XyFT9x52tuOLoh/PkWkYd0J2CdyoQchV9zPLlAiYgk5Ffr7Cw0sxzL5KhSWW3rY58XfbnBovXtiMnbeN/iH/QGYLWOv8kb87RyAB3OF6sYe+MBXPYxeNiG8LQMOzgmZw18jngz8f2kP5f/0B3ce40ZewGDsZSZ3Gca4MysRb+ZZOTQ008XfjS/VsV2EkQDLrRG24oWdQfUTfybEbwck2/p+NHoEv1QbuMiIIYJlqaUMhTjt0tStKn1f5cU1Zg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f858d6-b8a1-4945-625f-08db8bffc9a0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:38:12.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1jF5mv3uftqrE9k40BGScOao1k4jsAzjSGWrqsSfj1VaoJLeL5haIg33HPMFXhHN/6T1jQdAsGi6P3/77/7fsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240042
X-Proofpoint-ORIG-GUID: QXsIvsoPAG6OLMuGBc0_5m_l1qSgpNOq
X-Proofpoint-GUID: QXsIvsoPAG6OLMuGBc0_5m_l1qSgpNOq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to support both v1 and v2 versions of metadump, mdrestore will have
to detect the format in which the metadump file has been stored on the disk
and then read the ondisk structures accordingly. In a step in that direction,
this commit splits the work of reading the metadump header from disk into two
parts,
1. Read the first 4 bytes containing the metadump magic code.
2. Read the remaining part of the header.

A future commit will take appropriate action based on the value of the magic
code.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 97cb4e35..ffa8274f 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -198,6 +198,7 @@ main(
 	int		open_flags;
 	struct stat	statbuf;
 	int		is_target_file;
+	uint32_t	magic;
 	struct xfs_metablock	mb;
 
 	mdrestore.show_progress = false;
@@ -245,10 +246,21 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
-		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
+	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
+		fatal("Unable to read metadump magic from metadump file\n");
+
+	switch (be32_to_cpu(magic)) {
+	case XFS_MD_MAGIC_V1:
+		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
+		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
+				sizeof(mb) - sizeof(mb.mb_magic), 1,
+				src_f) != 1)
+			fatal("error reading from metadump file\n");
+		break;
+	default:
 		fatal("specified file is not a metadata dump\n");
+		break;
+	}
 
 	if (mdrestore.show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
-- 
2.39.1

