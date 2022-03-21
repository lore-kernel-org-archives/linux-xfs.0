Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6961FC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242077AbiCUFUH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344382AbiCUFUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BA333E3C
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KK9IaV008859;
        Mon, 21 Mar 2022 05:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=BhSIiPEEwtL8Rzw7W29dd4C6M6oyqjkml1CYmlzuPEI=;
 b=ieW3F2jEGTgj3POEmh3hdTFnXbk3nAK5NFM1I3mgNO+SM+LUTygw0yMUdTrsaqfULHFr
 68i4djexEXEF9cdqGzVDfKb+zzi+2ta/9AYQR4LonlYJLzFDXWMj0BsgbtEc3Woi3wpQ
 84QAX/wFuVldS6qE1ipu4Q2ald/IJ/HPlS0fhJKczLGiWn1ex6CAQytxuU0jZBNmd8Hs
 ZmiWlmI89ZkHpGlSDaMboR5gMvUHDWcH60G0dJFnVB2H7UF6k83allYzeF0l/bkmtFNz
 zJjRHg/mN6hgYsHsn1Z9pZZS48P1S++CX/TQeRRwRIyrQaBXTk1laUGaEaqOl00x7R8f 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt22vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5GKMC155839;
        Mon, 21 Mar 2022 05:18:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by aserp3020.oracle.com with ESMTP id 3ew70096m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONuLO8CoyAvsyA/wGLrdba7M89r83ql1c2tUdZh6WbdiFjya3Y0auYPehfiU1ECwmQl6ovm1ZtaDcF37B6Loc+kQzBbbae9m454AWJVoPefOR27c1osCcD5LXqjdD8zyMIQMCitj8A/qzTacgV32YtVrJL+2cjsfoCJio44QexgZ/770pTC9eSE5E41MEXjyHJhyuz25ohxPi7JkRru1eM/Mx3ujNFMQt8B25SaIPO5fvPV17MVg7EB96jx8bzfiBIGm9ccp99FWiKHHzpd5YvgE5UFemA38IPZCcyRPe26CeLpMwIVfdlto7vRwyFUU8pn1w4pCWE59Kz63mFgiwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhSIiPEEwtL8Rzw7W29dd4C6M6oyqjkml1CYmlzuPEI=;
 b=IBiBEKGT3oIdbc1SHuK1Wot620kQeap9FmA3wHvldcB94OZ0x9zwHnimmE2oiwK1uPjLTwtcGMy/beWZ9asZqi/bt6n5/RRFICHBZBOkkwWf50v5CsM9TLVHBfvutiVObVj8tiVQRf4l5GoFo0hJ/kK6K4g+OXswZaTME0991lKwpQN6TYy+B9+zeeDU5sqwbPrOvkygvGyCvsHJGeytKrkYwmlYy6pJGHPLMK+OAjpjVYtexy7t8DJkbW1zBbAEl2h11VXfXGa9oeQ2moIZ45HxJ4sKqzcQ2LiYnYxY4v6jV8QfYPgn1zGizkyra/B/zYvB53XgORpDKZAbv/uObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhSIiPEEwtL8Rzw7W29dd4C6M6oyqjkml1CYmlzuPEI=;
 b=zY3yICV4GpUAFZ0c94QXaFsUC2yd7AYBrue6BMOezb2m2NOYg/TKfZ2NgsZv83kEuHrUJijnzcJHHfCqDXrWyvdtbJ3PTT+OMIUn1+eCfdO+EJlqJhS4BmK4jW+/7r+r2uuAWCfBJ6IYFSVuR+xDBr63QA2PS86bNZ5vgabe8CM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:35 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 11/19] xfs: Use uint64_t to count maximum blocks that can be used by BMBT
Date:   Mon, 21 Mar 2022 10:47:42 +0530
Message-Id: <20220321051750.400056-12-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fe6dbc2a-403d-420c-3346-08da0afa3fbf
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55373A6AD0286707C5DD61E8F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T13BFKvwQC+0v2OcRuXenVrwox1Y/0XteZYD5MFQEMdGWRsVVKQLCywibmZHPZXTMQqx8T3fW8mYFga8nndaSBvxOj3vQ6aWqNmhE8b5MjiXi7DKX5Sk5aerzq+sxFP2YIlSngluFim7/oiw01PMBILnncXGA3eHkuG4nJCgwRWyEnkaCStNVguB1XzRy77mFJJ3o1Cr5Tdcc8ySOeeJGk6O8rjpV/mmX0smrbftad1nLZSHhXo5d91X9uHwtJkR0yIyC4ELVBchWWuWLYtTWo44zXz1eEx2hXLNJSPXdMbj/Of6LbS712vsjb6/VV/omrc6uGtNOe4zF9JGoKfayFVt4lO6wLukXgQGhYqGDUQHI8t77a6Tt1E6DBRz46GtfOCyeeNQXrDJ3a5kPDPNUTZOwh0hOljwG7TgM3A01HQwWUsbtLG6Moy8SRZk2zaYKgd0UMfR6OK5k8Tx8S3GYqkLXRhoaK1ZBduhymH07zS3Kuy/OS94YoHkHYSkx02xvj4So4rlHwoWeOXxGcmuaVesXV8x06zk2ivi6ASvACtRjn/Y9SK9OPszZ6ArQS3INCo4wrqPE9GlNAUIQsaWkOfPNfd7/6qKlPUglDeleWgepS2oU2UJlG2LbOtLFWwze2iW2I1LHQfrhDEVQghyKgtXtdu6x9+d3PN5pvBsWsS93HKHqBCHh/u53FuUh6btj26x83ei09yiLrwQpMV89Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d0jqFeMNq6vY4X0DpW2vfePA5ODR2iAyUpMGjz0x2/8xneTcfQcrLb2HOyjQ?=
 =?us-ascii?Q?SJSB9t+xBwEIqfTNbhJGH9Gl4UDJt1zxRRzbTfA2yGYxBCoiiD+8g7dvVUhK?=
 =?us-ascii?Q?G3JpSBJ3PTHQMqx30rLQKi0TX7qjScPjTXlZrXPnySQQ597msDbc+AqapsfV?=
 =?us-ascii?Q?L9B1UHzb5ZGWK1LuI5UK1lvpt/YeCbKA8zvygzp5CO7QteV/kIyMvqhXNV41?=
 =?us-ascii?Q?Wc6DLK7ruSW+MKCoFG1GmTJu1dB+o18nOJwNcW5N3W0fMQnZDk1fadAdVq9b?=
 =?us-ascii?Q?gDfBocPoT/gD/71vVSc99Jk4Wnxw6UP6LIKTrmhq2B4Xyj3O9CsPbB38Pe9x?=
 =?us-ascii?Q?p+/oc2Ls4B8ylBVQkUtZiP5jGxc228AwQXYjdyAfnkS+VU6r64oh2Qd/U7ew?=
 =?us-ascii?Q?e8nF6BcJQWn5qp3ygvpWshQks74NsR+7PAFvNTtruNCx2K1GGUzJ8VlSPMQn?=
 =?us-ascii?Q?mHXEBy2xIJ9JtyYKGutqkbw6tZyDFU3SkkPa6PuSsd2k0DSUM65LvNjqQ9d5?=
 =?us-ascii?Q?YunB4umQjrJwfnIpJVpjYIGsxsIxn0XUHndIaBLZnFnRDDLBUV35N3FugOJG?=
 =?us-ascii?Q?W+ClyHbID190P4oeBltGEZo/A8xxBG+f8dkEv2vegVrRDkOwIpo1YrOn6FGt?=
 =?us-ascii?Q?L17aNBYd7whMh1X00V01boIdkBo1bd6SA2k/hHku7kPgv5YQgJ/D+mLCgkNj?=
 =?us-ascii?Q?BRQwwGYq+WwoqMOjivyIQRj4aQrUquW05GkPmDveu7g6QFhTpJbH7OhW+oLX?=
 =?us-ascii?Q?+PjddUG5xwg20EX+CcgXgjmnZxIh5uN6byq9626cHc7vPO0uYAdCwb9yP8Tf?=
 =?us-ascii?Q?BXffruBGAfVh09jPqJCA5BZqMX5m01ZMV0xKSiNMTLleExjYfZGILfoqSEMv?=
 =?us-ascii?Q?7GcIsh8lB9RcTK5l3uGC4A6O3oOT8jf7j5rfOGeHxwoUM3yEjd+PgHQfppH9?=
 =?us-ascii?Q?wKk/JzI9qMUZl3tfdP0bDgmVN0+7aEDeB/PVEtOfXs/q7M6hxuoVtNTUJBZa?=
 =?us-ascii?Q?Cz/Hzqd+TNHsrZmTAGu0QmqFT0YS/4+xuHBPbZCN77Y6T7lAAAA7Y167SY95?=
 =?us-ascii?Q?HU/2riljtNgyWNVPQ8+zKF1WOxKqBJGY5ud4YuL32tcq+mEKFVMkt/wpieXY?=
 =?us-ascii?Q?rYkH76F0rGyMFU41DzYRJtxiauEvwsf9LihZMV0KrxuN2OqxaSYE0+CZC/CR?=
 =?us-ascii?Q?tF51pltHH9lzY5Mv3Nv7IABy0XWLEfyq2k2Xk9jBDo3E73oqdZt7flhPkOM6?=
 =?us-ascii?Q?KT7o2ti/OfW3BKOOF2U7g2KNYhycyW8HQz/GIB1pSO+VXnexmH3y/0xpJy69?=
 =?us-ascii?Q?WcHg7ZTPB8s2Uu448XjuwStcfBN4c7Rjk55/7K/jU1NjboKehAhGqJLgKlT9?=
 =?us-ascii?Q?8cisDNmdLZSlHuO27dUTWCGI/M3IkVvJEi0F5BBTplRfbvyLBc5XfBoDzKLW?=
 =?us-ascii?Q?QR7wIzG1JA/0e7N47Y4e8Jjew8YMhKhoOt6NBYTCHLdFaI7FvXmKTw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe6dbc2a-403d-420c-3346-08da0afa3fbf
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:35.4724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5sWV5LpaHd0gHJwPed0EsfQKOsCiCI1YClsevxqvapCZzEvwZnt+qW84K4M02crQu6ZrNZyLOuRAjnl3KkOGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: CiKuUjANb6TidcTU7F4f6AOj7uyt0DYq
X-Proofpoint-ORIG-GUID: CiKuUjANb6TidcTU7F4f6AOj7uyt0DYq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9f38e33d6ce2..b317226fb4ba 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
-	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
+	uint64_t	maxblocks;	/* max blocks at this level */
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	int		level;		/* btree level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

