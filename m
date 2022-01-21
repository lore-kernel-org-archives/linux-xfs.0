Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722CDC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348510AbiAUFVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:00 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62434 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234083AbiAUFUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:51 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04F6E016439;
        Fri, 21 Jan 2022 05:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=sQdrDts9NMaxLdvDSYtURgqoR4Ox9mvNpJPCLdOvNuM=;
 b=tarPOXwTsdT3aQ1GIuOzzDUOeZ+8NE273/jZmq0suyaUHJLTpRV8RyyR5m9iLK4D6F0w
 2F/T6Ub8Zn9SUexSDrKkJ1u0TkFWt3JMCh7SMBlC8welEYnjchijPBmG5dtQYfnQPIWH
 BO4fARyz98+xmr3YO2gF+x8IjShRCE9FK0nN0CPpfUaQzjLXYaC2W7dqIuszaEN/t0m/
 6oZM2C0x/FIeEeN88Y17VlLY9NnqDK7Y5/tV4CQU7fRhcq7YtDt+uxYzw0CEvmdXBkbQ
 ym/uDdK1sIAl/Kdr1o172iNgb9pX5UNDdLoTtn0z75MO6Q5QMHHa1CrzrHqGUA2TNylJ bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KWS4007091;
        Fri, 21 Jan 2022 05:20:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh0xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lE/nLXsKedJxAqRyHK08zZeQ1WFVppNTTazJ/CXp0y9bANfkVSm/8F3L6xZJZ4mLvx6D1TehZ5xqAwLc1sfEnvhv2fZq1p2yDS04oO5aclzUfIo5w0iUAFCsvohsTxkWzn1cLzVoZUO+H4XpVMORccE4KOvEvc+rrc0zk+Ll1dZ+f0Pw/dgO8Enq9cGNAWAETzE7/eM7q+Bf4Gm9uJ0ztv8YQ0J6tsjgh5H+k74U1nxu1lk8Fe6FSkZ7vZF7r4jWxwDlYomW8W0hdz1lMWPfcigSMAZZZZsl0sZy+BLiQJ3RnUypaZxmxk5GHFZs8A3lfwZbe97KisJo/vWrniouNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQdrDts9NMaxLdvDSYtURgqoR4Ox9mvNpJPCLdOvNuM=;
 b=cPEiKO8IoDpLwXejepsjZLi8LKAGQHR+nrtxFK0aSrGrPDLBkXUqIvV8qpAuI7KMb8Xk5xf4B/X5K+Ona1bieO1t5OWrvs4RfvRUzJwvTAS8m+a+8gx4Ul9/apg9t2RJeisnK94NEA+191UtH1hZf+VYrlSd3VT10tY51pVmNRTL9/ltLRlMO/kYpigbbFVrEHZdKqeABwWF+90hC0LpetQoZ7YfpL3oOGvEvn4zkPvGMsLZZq2DFm9qQuWYPvmSnC0wn0dtsFtHo/5YfqIJUV4y4VEGa/efERVkIkT6BRYpq2HUBCVUb+y4wxD4VC5haakzuNczIwW2eUcX21mYpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQdrDts9NMaxLdvDSYtURgqoR4Ox9mvNpJPCLdOvNuM=;
 b=xmzuyQB3+R/V3DZdNd2Jnra4jQm5z4mbORDOGDOL0LS2zv+UzViL3lXixMO7vQA5kJufyV+R4hfFMXMslTCLIgpwyYoHhHE+BYsBT7V2MaOOZXOK27qWWk2DKcIYulpmJ67nAQFtWPibsoJ9ZYtUbPXCJ5F6qVyCHhIbLhsCLiQ=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:46 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 04/20] xfsprogs: Use xfs_extnum_t instead of basic data types
Date:   Fri, 21 Jan 2022 10:50:03 +0530
Message-Id: <20220121052019.224605-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f348292-2809-4abd-852b-08d9dc9dc789
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB12872E35AD982A344E1686BCF65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:77;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7cB8bdvvgvlBq5XEkknAmO11m3mztNgQt83Q5FdjSsba0MsfDaaBdcnBh8W/SifLnF19u1SJOwrc0LZp7XXnr6as4zWnj5zJSiyadMHdXmhqa7gUzM03QoGyPEv19kHWnG+iYvdWaWv/DwbrDIjEDjvQJAiP3bgGRdZBqSSlShNr9+Io7iP+l/ss7RDqeg2iilmzIK6fIa+jZxM2VRyLZ5T2wJXzx1QkYEYIpYV27s8ls6HZMZXnr7nxb4jiNc+n9id6PmWp1Vk5BZ6iUrV8RcM4qL/JK7rsyRo5NpIVGrrsD0MVaOyROAtUgjRnPliUACXdbTPKtBPzninXjeFsDa5ua+U4n849sZbX3PpqidLN7dKNsrQEGsojM8CkISPCbGovwZ7+OH3myeLyjR5dVFCGBkeB2USeIa9SZKOTE9DTnFdTJoMIf2TRqY8xgJudgSxoNKbnAoOkV4pMwO68CMpbR9rj8XlE6Mz0fwIn9Pt/qAPW+HD41aRfizJYV2CeSdJtINL84KYYv39MK7x+L7V8EmcySKDX82Mic69RfrLSP1oBpE7T08llF3FpPkJDM13hor540ZuCvkRhKmD75hQZ1XhwQEK6ekGA2J53tkOiIv6zGUV+iXzE2QmCec/WB2BI9p6gsbGcxAo+YbLtgq/6HPWGtNKSJ8qGn8zrkQ5NPysndFX9oyG1v2sGknCC2Xe9kYgC6ZVCkG9IlsZNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DgrMUj3EgfsxukBBU6gSkX8dHdjYyyXygOwcX7R68hJ7Wopf4J/9Ps4ohYOs?=
 =?us-ascii?Q?2OutofPoANS4lV2OxtCEOHTShtjtjOr2AIoPOFmKtmZl1LuhX4+tewrEBxxs?=
 =?us-ascii?Q?D+gEUPULuTztIRPS3yavGDEIYZtjCaZXMTt7fujbX/V901noQLREMZbBEVOG?=
 =?us-ascii?Q?DvIgmGu/tHCHzmW61f6ufWEkFerS4q926Q/BZkLyFf1p3jKHWN6lQADiXCiN?=
 =?us-ascii?Q?qbNaMDqaQKrL44gZCVp5dofOoodRDZ3jItlxC2GpLbb/IW6931Mq4vjNaeUm?=
 =?us-ascii?Q?G3DToJjtYhlmZyO22SqndoE/rQk2VM9Dpd86/G0eU/eE38No/X3LGYOnk6V8?=
 =?us-ascii?Q?En0Lw8oeJZsgNNV+O30Q1/I9pdwthTIBLF3y/vZp4ZPrVwvNrtKUXmF7YHIt?=
 =?us-ascii?Q?zMnq9lzmzYJ0h9TdAvoEaiyx1yhrZ5JMc+eVoTM5r2A2P9VPb/kc7ftWzUr/?=
 =?us-ascii?Q?qR/vruembHgOjYIm5UtoHBVlPvqTMjuB2+veJeiXPWdxCp/sqb9i82Ye5MKP?=
 =?us-ascii?Q?qpd5iHlpxw1aVvNHWkWyB1KJC9tzD0dbj5SBoFpTsJgkt4hH6grMLq5kggKg?=
 =?us-ascii?Q?kOKDwDdq9a54p11KiqpyigqBZsZlgS5Lc8JB8JZQgYc/7UK6Ky2f8al5EhkM?=
 =?us-ascii?Q?DVySjxiQ+UtI3CbA0ExnM9T1+SgLhwloW4zVCh/tSF4FAMUNzY8w9h7a57p+?=
 =?us-ascii?Q?XeC9Hje7Tdh8WXVRMO3deVywOsUNoV/3MGxvBZi7lyxw9xAttsmYwgEkLh10?=
 =?us-ascii?Q?Is8lMNXYLaav+3Y2F5eDhqGAyYEqsU6ZTvoK3L/djnVZFudBHQh0TyEQ7KN9?=
 =?us-ascii?Q?AeuYcvXgOMCbIafa/mnUG71UEMtIh4jetxi/GRXVoikD/C9lAFiipsnAfGnX?=
 =?us-ascii?Q?oQcbxqu3dU64pFBNGv76bidJa53VwaZ8QiXN563O7sK9jrDSuSs+nEJgReNl?=
 =?us-ascii?Q?QSL1r71RQMFj0pP8zlrX9onUOKm5YxNIdMgFmKzOX9b4AbbDErsqklEjJrSx?=
 =?us-ascii?Q?Ufh/njdmrEQuA5B8Gw0bo51KA1V1NrJ8YiDVoDT9QIXGVxmeeQvPxZCj/PUU?=
 =?us-ascii?Q?slrDxt9oz7ECnIn/+wJE+ty0BGqM2W6SCQKgpCE/11Z5SS+D5MyR5eTp8BmH?=
 =?us-ascii?Q?++lK5SmudUweGFTr2q4DzEygq+0yJCM0k9GcEo6QskofGUbuqRa6f/VR/6rH?=
 =?us-ascii?Q?H6ti5vAPCImOpK9XwK1AYpCNPougLgakRNXrC2vSDvrlgDP2PQQrmKYEbLfM?=
 =?us-ascii?Q?RnSNwsR2fLzwAsa9OmVeOepTKp9KLVlYatBszUL3yNKo9IDgwHQcE9lRhd3r?=
 =?us-ascii?Q?BufaZnONLlkrIZ2uLIjHlWBv5jWGyXhpFBnYk+m+drmZY5urELISiaEDksdf?=
 =?us-ascii?Q?zWo7/KuH4UymLzrrDP/ouqCemFYGzEu9OwuN1pP8cVR8KSXvAlq2tRPT1JdX?=
 =?us-ascii?Q?TMlQTktbPAsBL8RfTeHGOXistiqr7azUiH/F6qkXketCmXS8ekNzMftgLS/s?=
 =?us-ascii?Q?qKFC4U/0dByUhwbbhsDxGr+F1L3gvg4VDXhwWTfg60iUol6i4VAj6/g+7nfd?=
 =?us-ascii?Q?UK3tTcl+N+hE5v6pQA1aGxXZ883AEsK3KY3vVNgNIRLb83I4JQYAwtVXaL9K?=
 =?us-ascii?Q?JBH85wlU/709lEgButgry1A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f348292-2809-4abd-852b-08d9dc9dc789
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:46.7946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /wq8ZEJNlyLO7jm4JaNeZLDae75kbTZNa8qWsNQA/3df7b49gEkJqgGMenK1EMle9vEPWa4j7lhn9OCdx2/dOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210038
X-Proofpoint-GUID: X-uH_aPiQ3nLk9CEMfnTLfgwkXgbW7XV
X-Proofpoint-ORIG-GUID: X-uH_aPiQ3nLk9CEMfnTLfgwkXgbW7XV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               | 2 +-
 db/frag.c               | 2 +-
 libxfs/xfs_bmap.c       | 2 +-
 libxfs/xfs_inode_buf.c  | 2 +-
 libxfs/xfs_inode_fork.c | 2 +-
 repair/dinode.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 43300456..8fa623bc 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -47,7 +47,7 @@ bmap(
 	int			n;
 	int			nex;
 	xfs_fsblock_t		nextbno;
-	int			nextents;
+	xfs_extnum_t		nextents;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
diff --git a/db/frag.c b/db/frag.c
index ea81b349..f30415f6 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -273,7 +273,7 @@ process_fork(
 	int		whichfork)
 {
 	extmap_t	*extmap;
-	int		nex;
+	xfs_extnum_t	nex;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (!nex)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d6c672d2..8da8aaab 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -47,7 +47,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 855f1b3d..b15a0166 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,7 +333,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 625d8173..4d908a7a 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/repair/dinode.c b/repair/dinode.c
index 1c5e71ec..e0b654ab 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -932,7 +932,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
-	int32_t			numrecs;
+	xfs_extnum_t		numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-- 
2.30.2

