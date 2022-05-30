Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907DEC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 03:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiE3DkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 May 2022 23:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiE3DkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 May 2022 23:40:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3A9719F3
        for <linux-xfs@vger.kernel.org>; Sun, 29 May 2022 20:40:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U1XbaJ026549;
        Mon, 30 May 2022 03:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oNVCP9mIkE3iz3cDQDVN5veQyEWmS5/8hFqAzLKjV34=;
 b=yteV0phrKxv+njI6XwEIVtIpbVq6Y0+6NkIEVWwRQnBGPefZ4ehxTQDqarxmd/Sit1vU
 Y1kEYzd8suV+BVlbo2xePenBGShCEHZNZKUwkbbrnBRbf5V3k5v1hw6d8wPQH2xXPScV
 pxHH1wiQodxmQTRmi/VJ4BKmRQTX0gMwrWhmgRWon5I6tdaqWCh5knhT4px7OVOEWYcs
 KTl14uZDhGOSiiSxb4uXXQnEmG5nE/nSFcmpz7VSXtE/JaAtg5zPiQE74bDgYwrVUHjA
 X94NneCW01IfDWui+xkovywiGMQ9xuq64cdUeC232d26izZatRDN9GUmZtHgfm6ZYxk1 BA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbgwm1n6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 03:40:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24U3Zo6R019190;
        Mon, 30 May 2022 03:40:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hqah50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 03:40:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpUir8GHxDzOeF+fu4LKyEwd2booCXTJcQthXRicR+Q5MkjNZcVwninlE2stmU83RrnTt/YvtndNZzNkfI4JiayE6VZ/vqmPnik+lcBX8jQxRIUYClwCtuCd52HqXva9jBzFQFaonwE13F3VXByK0bcO6Du+4FpMznz8qOqTpcAom4y/IL3DvCGALRRtmk1nIYxR1wZz2egIo3aQES1+yTge7V+7ZZB6rOW6dTkrxYvlcCzDS0mw2V5MlO3Ct4g3zVXzjF4aTEZK7dPuKgxnZBT8lLMi1rrJoseBTtvi9dOBNIBpvpLQn6j2q1HgWtRkXzSX9HmY4UX6tv2ktG5xow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNVCP9mIkE3iz3cDQDVN5veQyEWmS5/8hFqAzLKjV34=;
 b=YF4IDHcdg8q9ankOWw1wLllPLULnEmdL8nAaJqvV+xao1I0kQqrZU/AgVhF8u3KmuLcvZcwIjuGpOY0LpV6T+iyjCkyeremRBjl9W6myRYz8v5TbK9ykqQVy5PW7cYu3y2lhLTmApUKwszrcpSJ89aVP4JoGhCpXJWPz1xzw8cYMhMR+y5KAA2gfn2SjMfuyWZx2hj9uZkAAIuXn85y82YGDULwHvYpQ7yjxi3+PUS8hDLDtC39PKFEKKy8eZ9X3oZaJgf/eZ02yq5eEksboHg9CvwOPmZ/pmL0/nZPWqj7ILuEaSJwGi9JNqtu/QIw6uNw4L7Jm7aB8Ze0kC5Pz0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNVCP9mIkE3iz3cDQDVN5veQyEWmS5/8hFqAzLKjV34=;
 b=lm4dGX0B/NmQaDx0BsN36U8KGHP3NrWwN2mn09GLNdv60lRGlqgjmMKrEYs27mhsmLtC2ar4SpV/ULKIuUgLfelB5x9MmK3ngGuBGH7EgQViormac+sXuqK+YnbW9EQfTjPcC8jVXFgbf+clLKEVT5jB8e3OJJA/YNZdX6SGiH0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Mon, 30 May
 2022 03:40:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 03:40:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, sandeen@sandeen.net,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH V2] xfs_repair: Search for conflicts in certain inode tree when processing uncertain inodes
Date:   Mon, 30 May 2022 09:09:47 +0530
Message-Id: <20220530033947.167843-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::36)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c899cd2-551c-455a-b61f-08da41ee15c2
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5872C15CAFB46EEC16446512F6DD9@PH0PR10MB5872.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwudUWrUywEfByER6gh5MtaTTIzR7lZ2lpvE6K2NYq9lFmbPgdrDUqy14Zu6959ogFXYy5uZFVJyJA2xgF+83UtBd0BsyswoFvS5gk08uvVYkVe+40y+aLek5DNB19gOH0e6NGpxuqF0HSE0SBUFgpMCGfli4j4JCeZCTcC/O3ORjE2mgMK1OAA+dcEF3YsIJL56pU/xC5cH1EZzFZMs7qj8IukOFNxqCkIxILWxDLimrUU27e21MuIp3QnSb9CkQ3hVIBr4prkN76mWhgbMUK2elUkhY19KqZOAg3Uj1YigZNVlF1jyJlRQTUMhtp7hrhCxKns6NQ+hseBk+IwB+iPLxIC9eKo54mlKcaD0YUKOOVbHfFUlUjy6ygHnxgNgmUMgAqlYLUq2pfLTutwEd6C72kNpJZaQZudxmClqUolvvHEud9eDaEo6r2CfhS56k4ViBBpRefi96/PWKmwrz1RcNeK/Sn1IH7W0TnHxKO+4fmAzz9OgQL5c0B1rF83osxU669U5xcjh0zu/ZavNRE4xI9bEeLXjx4sSp7Wxnx/MNISrF1HBcDzjQsJRckSaWi2Wo4pYGRZSTFgCMaEgkj6IDUnhPImbrgf/u1O1AzlhxpgCvPkWvbpzHA1T5K0DhTBqkWzRWttz6g67Nc8OcyP6/ajYRoHglbV76DL74UeVzBVHRfOyW3uY2Kt/BfqxePJLi3/kOueMiU7sbcssCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(316002)(6916009)(54906003)(83380400001)(66556008)(66476007)(8676002)(66946007)(38350700002)(4326008)(1076003)(2616005)(38100700002)(6486002)(186003)(508600001)(86362001)(8936002)(26005)(6512007)(5660300002)(6666004)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LqVB2VZrnNncQgs8wPCC/ltw30oML7kzYhctaQxSsvg+M9wMMXTYYOFobQrc?=
 =?us-ascii?Q?3fsZzw0A6g50U6CnEh2g2Es6TZ0HDr9bgAodXelmtE0g7y9EaZV6zVxLsvR4?=
 =?us-ascii?Q?C5dSDksnns5i1csBUk+O6ZNVBQBozh+B8daAsdwE5+/nx7/rnVnIAWvXA1VY?=
 =?us-ascii?Q?MQEk04EW+kmm2MpzozlyvWXfAHqZW4ohtSwEGyqCK086HCY9ndlm+N/CfzMk?=
 =?us-ascii?Q?v4KKD6aTlbBDXRury4O+qfPT7Gl73YWxCBAa+QDN53LX3K3eJ05GhQV0Dj0/?=
 =?us-ascii?Q?jW6NlCSlnbZp5D7larKp8vvg/0t8oTno+oUmlZgrCkfpuqCet8idFoXOpJfE?=
 =?us-ascii?Q?oUf+V5yw8+wUwYbuy7CDjUs8aJOUQps4t0RkublCcegKL1mYX5STxNRd+gr8?=
 =?us-ascii?Q?qCuDSICv/7LXaUkF0dJN8nehMRq3soObMQC7JI1hsag10SUdbDI2PZuvqPEA?=
 =?us-ascii?Q?WWGMnLi6YXcyLVea2x33k0BrLP0cpGHbStiH1b5p314uarsCq4ljpvKKvyQz?=
 =?us-ascii?Q?CmOr3Wybx0tzvIz5FJSMGxOcTtl5oFxD2VDMT1zER8pcuTMUUem8hqyJ3DYW?=
 =?us-ascii?Q?CfZOV1hZCZdgzMFOWjIXVIaXTXQdnSqt18bOKrvDy+at8588Z9d18lsHWfs+?=
 =?us-ascii?Q?AaFqKxJd3vqhGCxsPe+0+W9rLaXKsHw6AoSbJLIh6MhaNCaFQI3zjhGdCYBI?=
 =?us-ascii?Q?Cto+tc46vl3/iCRuIitFJhRvuXyPjdyUQom18bps5PcCG3aF/s7hrsYaazcc?=
 =?us-ascii?Q?m1940ddgZ5HSZgM7uWOtfdoo6gIN1gvsfbEHishjnKnCALB6dO4JZiRT0Cbl?=
 =?us-ascii?Q?vcuYO2MAtKT5QD3HAGWE22NrseSDhUKpa4rjxaH6xszOMJOj40y86QPyc9XM?=
 =?us-ascii?Q?h5nkggJlKpL+5VHJ1Ay/XlEVfrFCJ/YO4SAjAYbGSWE45AluAp5J83rX7Az7?=
 =?us-ascii?Q?i2MdtqgcwsFseSUMtes0GjG8GGuzf0NFRNYP7PYxJ1o4CuYCRsPazkIvClHm?=
 =?us-ascii?Q?TqiC+tNuD/XE4HFMima/SH7GzftD+pnFvNFPm6p+EBr6TH8PyKrmo/hfQ1Y6?=
 =?us-ascii?Q?UCUfA+pa00xNKBX4VglqeAH2+Q2GgfdT1qCIbdl7KKTjFqHrdrRiXwC5vQkf?=
 =?us-ascii?Q?3GwEpXwZz9pnOFFqatdlmIKel5jKgSqmiLawf/Ub6mHMnWebhnb779gP8gid?=
 =?us-ascii?Q?HfkhKcFa9VCnbHNTBtN/DFSa5UNV0hf9d8unqi9wGQFZi67NagTmw9elU8F5?=
 =?us-ascii?Q?0TTQEE+4Cqtlbl3QzdVWN2eVrKr9il+dWWNGbQXaWsg7OAPOt783nPkJUOma?=
 =?us-ascii?Q?jBTujAlsWpj6UUmlW8DfM7C7FbFMgWTRikByx/Urb1xN6ohWvyuFd9VewvvY?=
 =?us-ascii?Q?pCZkXHq/yZMupjPujPMHv+OAB3NMqksg07r/iPQv9Lri92K2o0vee0MFfkNC?=
 =?us-ascii?Q?A50euuSbwZkYhC1DNjMPwJYWovOyVWlfj+5oUWn2gE+7Imm1xZvphKWLO8XP?=
 =?us-ascii?Q?VfK8z+StiHYbwz7cwD9jbTXvVRKa0CM7vYpLQRYBhaBeEarNcLJ2kwczwUkG?=
 =?us-ascii?Q?OPaxpwqim3ssBz+J/ugebwvqfUuVYvOJMkCupwtDpYfaKjpClxYYdZUHWxtb?=
 =?us-ascii?Q?DxxHxWEH8A6ILZr8Hxk4OsZiHZNfbGAzQK1AnGmrji1JRV8pD6MEuWx0t7Pc?=
 =?us-ascii?Q?hz45sLNdIZfBMB9cDBlTOfkHUIVKCeRNuDeGTvhfsBUBQgqKUo3zdzgOXSro?=
 =?us-ascii?Q?pAz/3sF36A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c899cd2-551c-455a-b61f-08da41ee15c2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 03:40:05.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvGzaEoBUFcBcEoUIiBGqbVAfH2HEVjVasp0rtnxpUQtB44qwqbwwv36CJPhXgEQae04JPvg3W0WllkhTkdiMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_01:2022-05-27,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300018
X-Proofpoint-GUID: suf9OO4ooCgXsuV_1aSQWDEEWAxy_B2U
X-Proofpoint-ORIG-GUID: suf9OO4ooCgXsuV_1aSQWDEEWAxy_B2U
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following are the list of steps executed by phase 3 w.r.t processing inode
chunks obtained from the uncertain inode chunk tree:

1. For each inode chunk in the uncertain inode chunk tree
   1.1. Verify inodes in the chunk.
   1.2. If most of the inodes in the chunk are found to be valid,
        1.2.1. If there are no overlapping inode chunks in the uncertain inode
               chunk tree.
               1.2.1.1. Add inode chunk to certain inode tree.
   1.3. Remove inode chunk from uncertain inode chunk tree.

The check in 1.2.1 is bound to fail since the inode chunk being processed was
obtained from the uncertain inode chunk tree and it continues to be there
until step 1.3 is executed.

This patch changes step 1.2.1 to check for overlapping inode chunks in the
certain inode chunk tree, since adding the new inode chunk can cause
overlapping entries to be introduced.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 repair/dino_chunks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 11b0eb5f..80c52a43 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		/*
 		 * ok, put the record into the tree, if no conflict.
 		 */
-		if (find_uncertain_inode_rec(agno,
-				XFS_AGB_TO_AGINO(mp, start_agbno)))
+		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))
 			return(0);
 
 		start_agino = XFS_AGB_TO_AGINO(mp, start_agbno);
-- 
2.35.1

