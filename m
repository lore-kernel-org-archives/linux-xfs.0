Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334E5C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 08:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjKHIdJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 03:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjKHIdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 03:33:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9575F1712
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 00:33:05 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A88RPxK020698;
        Wed, 8 Nov 2023 08:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=1sWPsHf4B64Pr/t52OZHeWWJQP3zpANECsn1YdJIY1E=;
 b=UZvWeool5cG7P/Yw6SbzZl5ZpxxwIa3HDVLPsbtzSHDcE55qiZOG2fz7UH21ibmw2hG4
 djQrzTT9R7a/KaJY5XA3LEaNj8c+4C7KDHxZ59WtXI3q/WB+Jlr6Ua8FS6L3IEQPpdlH
 M99BJPSDkeWB7kqyn0pSUet1lED0QO9WUFjo6CIU5X+FRx/Y/LsSvCy9sIdwJuPqt431
 c+ovVNk1qzGEPv4hp+OlULbGZEP/CnjGzKXBgnoPzRHf51JY1Ln4CwyVDN/Ea/HWQWWo
 ACYO1reM6Nw9UyM2l/gBL7cmAU1XxtMzoOQw9VBNt4ckKb8emMsj6AM6xELOF1ZGrSv1 uA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w220y6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 08:33:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A88EJxJ000392;
        Wed, 8 Nov 2023 08:32:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1vw432-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 08:32:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N61O9LA4T77yGAQpss0smO9xjGUeCRXYkoGOZGS7A83xpAetVfaL0wQMtJ7cIjYTJY++somn7Xr+D7kUOyVg+xMf7F7pVBlzHB01mO++FByd2NWGD3xH0oO2PxDzPwwQ6TDmCuqIKi4xugOiPUQRzsJ56uODiVoZozJOHpwWVSi4+5gU20+ma8v53szAioRSynuwJ3gUjcwrVbL2Rm/EhHQ5puTp5nA2fc8/DCJuazZ5ckw6WfPY+3QFu2ZxP/BOUEF9gfJFcZsAuFazLn43CoEKW0nPB1JEROQ5/x9IL1ryadntBFEew4oZKgOd3PLnnRvXGJN1VutzTmxHIUdW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sWPsHf4B64Pr/t52OZHeWWJQP3zpANECsn1YdJIY1E=;
 b=NWgGoaFNKrE2nqkQ7ZgIiRn6KdF9qaJSR6habgixajUPDSnEMylL/yK8R5Z0GqnyRwerCMkglJsLsqIM8U9ZVRTDa9ZOwhXCMOZ8zVz+mjbsjXrb5/PsjdOrJ1iqFmKErizpG+Ne5nwR9GWtNktfygHX621IpA2D/kjEl6kMNbebFerxKo+RHXKVRXsJbbBFlyK6S6QqpsNze3P5I6yGVC/9t7PHKee5FjZBleJOu5sbSmQt0Mf60jFKOBAFy4x7fju8J6oC7bOZOs4ry+pskmZepxR5Y1dXxm2MA2dDJlGoTjaOfRgPMrbDjSL8UvwJAT0Y7YlA0F/12I97GxIVWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sWPsHf4B64Pr/t52OZHeWWJQP3zpANECsn1YdJIY1E=;
 b=U/6Em6VQGBWfn0fJ3UpbHDYLu91YnOjuHvA2Q+NWK4B9oU/S/yYDdvCviQoZvvUUhsglX5C3nWIQH1lz+8fceuMQE6oGBRAKROuVcELpllH6/w6DJ6GJCTlLb7nYD+LW3mRKuh/6sEw8nX3Dc7M4Gw4WIm8p8kfV7PeJDJHI8aQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by DM4PR10MB6088.namprd10.prod.outlook.com (2603:10b6:8:8a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.33; Wed, 8 Nov 2023 08:32:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Wed, 8 Nov 2023
 08:32:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 1/2] metadump.asciidoc: Add description for version v1's mb_info field
Date:   Wed,  8 Nov 2023 14:02:27 +0530
Message-Id: <20231108083228.1278837-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231108083228.1278837-1-chandan.babu@oracle.com>
References: <20231108083228.1278837-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0231.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 7afa743c-499a-45cb-5c3f-08dbe0354f30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDDnAFj/Jl5RddOEOT0pybZ7D/npKuNcG1qtJqj31rXBcnU0lhBURKR/FQKhiWREbQtkTlHE3SIlsyRAt6ZsLMZLZk+2fKwbvcpHqoCwELDzY8r4dX1r4wPJuijEYZfFKm5SfL/yi4jU2dVP08D+wJtHHSYSFhOqXl7dTYcKvCI3M5yY3k/dKx/zi6OoM5hs2ttamMk5rfGeh9EHYs2r6UORnKd4pndKTKrzfwT/GsmqtgyA/fdqM/dm01HsaKD7+9SdQguWaBMCAtsAwauOyE6tOAnOW5x1rWCClWIXt7NlthiPuvkex7Gx6U8pJd1DTpMR/00L12c+o7legL6Ow9NI1A6rBRlqxOAPmk2g9+ufN4fA+Jl6Jy8e+BqE3BYPy0Vb1d1QJcZkU3vsmBChjx42zf+QSsgnShtch0kmldGJz8C6+gdM+GDxS5Cdq61HmHkd29W/i3aaqO4Ktz4Hw/oZSnnAPLwfsTzVG4WjDMdl2pT2VnKxYdSA7+8beeke2+h9Drf4ertHSCa9BCetJ6P2l3ZThWVELsBrzM0WF4A8nWmlsCh6GNn56BBf994q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(5660300002)(6512007)(41300700001)(6666004)(8676002)(4326008)(8936002)(2906002)(83380400001)(38100700002)(6916009)(6506007)(26005)(478600001)(316002)(6486002)(66556008)(66476007)(66946007)(2616005)(1076003)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W1GFG8sMcl3I3ynaUvOJHD8TbSFhSwT+KECymnQmgU2jZJUqYQ6xMr6Y3ndy?=
 =?us-ascii?Q?mNuVHRGrxm0JwvlRkVU4pyFCmM0t+8vIRS3wIrBSUqX6bpZAcDsM2KmMfSoh?=
 =?us-ascii?Q?zNQjpETTQdRrZmJPqCAhBhAqHVCx4XuCOXSFjCOv5YZ6sUNSbsl1rYjdVnqm?=
 =?us-ascii?Q?tlVMFoBKWZMAvNNlFeFEBHiRsur/oz7ijGInlzquG3G3ArRzbAEIxgcRGpRT?=
 =?us-ascii?Q?8fGFEkJun58crjzAJFvZtpOZ3JPpXpqz8Oftaslg8OG+sUAIP6Jdo9tB/adC?=
 =?us-ascii?Q?8W9Cno4PY02iIr3rWlgifhC5hLM48eDk3cbPgTvwJW3Iu5fVwVOu/mQknPEy?=
 =?us-ascii?Q?oiAkztG9JYbzXFK2222fkPq+kq0o96LlKwFLj31HZQinaxq5xNZmA9x/UkOe?=
 =?us-ascii?Q?piDcR93lF9W7Lha2u9u/Q2ojW+eERAFL6MF+xbUZ8+f88FVgEvCY0Or1nIQp?=
 =?us-ascii?Q?zRXeBQ45sEAA3di9upSaCNRPHrU8bZivjLii9MQJ3AFtn7WpJXuPmWWNTC0e?=
 =?us-ascii?Q?1wQ61LHL7Dszgbg945GgdGWfcRoJ51ESLmh5pI1GeJI4v3YtZfZqfUwmtGx7?=
 =?us-ascii?Q?c2TIPdYoJcC+13W7f6S5sIzoZAZL9okMiwFjkirFhAVG8rlbaxYxRcMxqg+e?=
 =?us-ascii?Q?l6LvfnJn4CwSw4kZ9myqdUdR+prV4bdRPQ6kO1xiyvAB7k5IyWoqHglf6N25?=
 =?us-ascii?Q?yvsBhuva0+CgO/WFOlOIjRy43CO6Di3o0p3uJdTbBelRs6pn/m8PrtTy2w9e?=
 =?us-ascii?Q?1Y1LbmtahSBIqA4SrRd6N+0g+r/Ugp15umcu6F6omfxc3boeW6ymg9EnRq6Y?=
 =?us-ascii?Q?Uip8TKp15rifdN+eEnrCHqBhCZu4/lMx0zuizzPWkLXEHWwCHeL+5tM93uQn?=
 =?us-ascii?Q?uZnA+J4i7xT2J2eXu2Gt219g6gGmxTKv/q6uP48V/Z2PDNmPEpQZC5dwx+2i?=
 =?us-ascii?Q?VySyIxrb7mqFNI+W44FUeD+MnxzTSSNpbqFrqhIlocLDAV8EHt/GB5aQ5YWd?=
 =?us-ascii?Q?4adZvadyQFCZ/q7JrH5WgiyXI2fFAmNqNlJZfliIvsSvjgb5vV3Eo2RQYxHz?=
 =?us-ascii?Q?6qd66Zcno09sKPUckoO9cpF5BW8vYiCUBxXKrFzFfUEXvCNxuVKtg4t6EJEW?=
 =?us-ascii?Q?/ry2JV9oSr1oXZBC0SmFlTqYRhv094yv+Si7ZhBr9yhyCvFUJpBjs2D9qI3O?=
 =?us-ascii?Q?ZS5fS2CYdz4ij4QLzKTz1S4RS+9o9Tn9Ptan/Ni7W0bm1z8AyFaxoXlltlnY?=
 =?us-ascii?Q?zc7kYyzIXm0W8cA/HYX5q5snOMWXlGeU9KExD7Yk9tZpWu/tfLDupGr1RjkJ?=
 =?us-ascii?Q?mo96KU7xLJKNacn4YZxL4D5Siun0qmcZD21JP+i6hEbNpBa1epFVtCwqa/gG?=
 =?us-ascii?Q?o4MEFtGpUESE1O4mAS+RvZnK/S3MiR/dsSIOg0904Pwh1060+XXKAOCitUxN?=
 =?us-ascii?Q?oBhvk5NitDFmGfFitp/DAFWztbQsNffrh+D2bNJGFaIR7R5YLl2JiSd5ccKI?=
 =?us-ascii?Q?NNv0gjhlB91bPY/MOelNulEGX88MecUsK0M1jQ0YNfkGZJyj4Cl8cGLWavQD?=
 =?us-ascii?Q?3r9St160UwQD0U9gvFpsWBffqMr1I5fX6QTwEr+U?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: u0B/8v+sEMrAeHFn2rGgusQ9uQbU/FbfulOta2UkV2VmVZMQ5mC6vnxENqS+YO1hWN6tXGEVpvFH6dqYnLbekKxbfS2QtQFKwuq5JbQDuP+GKXYFzRy9CnNeN3qu9uR/khGE8kwI6AJ/cx92fotTzUMdihZtmIx113axHE/k/NvOxiio0e43Dzio77pWn2Wetsp4WG9BSzAJrN7WurSOhQ8FhGn04b/aaoCYyCCN6M/rSHyhio+AV2GpMDRAOq4GW8W8LP1V31QqpW0MkO79X2NKXYrmYV5TufFNSBhtj/iNqfpbnkiIvf1xoIHlwNWcTeneKE+omi5/FcBGsllnzU9PtV+LI+tSuGEoSgpdzniGkiSYqiNDqdRXmn1nOh91vulJsz9Uo9nn9TWqSUjcSi7rgUQx64LPaqbapuLtG/APLfkrvEgAmlAlBrliXrAPb4uJAIa+cJz+jGk3iLlt3jnb/5Rg8YjA85ljhalGhzIqgzF/bC1q771qCKN9Sn2KTqZfRehpS8nTHteRbKqdZ+/HtN5oNMWPl2IUZZlK/bYQTvwgkpvuG6WiwtrKTwbsf4zvIXUTcINNZ7vXNauJ6IDXF0M07KgHImwjcgO1hq5B3ue8UIgnsHHnCxcZh+sQ7FfAu/T0YUCZW+lWYfS6XSgyoYqJk7f5JTQLplLcmqldZEwvgdRG4rHcGMNDP0+M5FCvmBgzYOAKSlDUWsFTdYKPmpkyjU58rvJ+5XlrhoOuSpazzcS3W9KcBKvJu/tf5LO7o/RcKKAx63VP86yBz9JwRs6xzg6nhW9j0xxNRqw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afa743c-499a-45cb-5c3f-08dbe0354f30
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 08:32:57.1412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wariIB+CVtx/Pt3ys2llStEjkjQ6PZUH+eUJVmQYHkNs2RBrYOM7/DgMhO567PUq9PrKd9Nj4jsL6BYrsq7cIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080070
X-Proofpoint-GUID: lFTa1PzGFMccL-TFKhfrIudvqKO6z7BE
X-Proofpoint-ORIG-GUID: lFTa1PzGFMccL-TFKhfrIudvqKO6z7BE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mb_reserved has been replaced with mb_info in upstream xfsprogs. This commit
adds description for valid bits of mb_info field.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 .../metadump.asciidoc                         | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
index 2bddb77..2f35b7e 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -21,7 +21,7 @@ struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
 	uint8_t		mb_blocklog;
-	uint8_t		mb_reserved;
+	uint8_t		mb_info;
 	__be64		mb_daddr[];
 };
 ----
@@ -37,8 +37,25 @@ Number of blocks indexed by this record.  This value must not exceed +(1
 The log size of a metadump block.  This size of a metadump block 512
 bytes, so this value should be 9.
 
-*mb_reserved*::
-Reserved.  Should be zero.
+*mb_info*::
+Flags describing a metadata dump.
+
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_METADUMP_INFO_FLAGS+ |
+The remaining bits in this field are valid.
+
+| +XFS_METADUMP_OBFUSCATED+ |
+File names and extended attributes have been obfuscated.
+
+| +XFS_METADUMP_FULLBLOCKS+ |
+Metadata blocks have been copied in full i.e. stale bytes have not
+been zeroed out.
+
+| +XFS_METADUMP_DIRTYLOG+ |
+Log was dirty.
+|=====
 
 *mb_daddr*::
 An array of disk addresses.  Each of the +mb_count+ blocks (of size +(1
-- 
2.39.1

