Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F03AC64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCHWiW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCHWiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7351962301
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:18 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwo4S020813
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/+M/2pVy95P3FvfxzBaUksYhRBWZtbJ9UxEofJ5atrs=;
 b=uIo+fY1E55J+MiD6hwCThPxS3pj7cz9t8uqgF+PLrdu3yLAwaEcdL3rNxPGCv2C7i2tL
 6nZMs6t9lIeVRQObmQeY6MTn5YpUFx1h0Bm377JgxwYT0gTsEPszDYAIBgbRBvdFrPuW
 wFfPJ0nqoB91GqBYIYgYyt5LLQWAjHsyLTX9ftHalRKV+aC34PA31hpU49N0HP6bH4Ll
 rhObHVL0SQKgQob+cor4UZ1e7WLoq42b6pZ9r94M4XkyjQBuFa8YxwPDXsi5+YOfdW9f
 8HuhkWzOknI6kO4f34PTDmJCexzuNF5KAVtmFjSXAmGUuUt4TRB+cbjwbgmlVT6t/TaC 4Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41811a2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LVM0h015688
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6femx3av-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1uNxTb9Cm+Cs4a9KeqJVcxhusmYx33SC5cIbWPs3L+2Nmg8cDPt5ER8DvlcRjXLtqOhfL5lM9qs8hvFizL8h9d0aaiYEQH6BdCMVEaEDRPtSLtKayNtlxkKYhReX9vI0e/JlwvGDDSH3p9I+bQTO7JOk2TvepwVT5VEgtbXiBeDu8FCxLZrI7FRR2fotI+vErCYeiXjQCjaNMqDCxdxdoAgCSTP/YP1BDnpl9wOQT+m/jYLEDOOPrzj0LfMhQ0dJAXonbzrW9ZURO02/nWVdPJKh+1XY0PqNQu4fIEPfN9n8uAdZf+uvcPET/CeyPhr2GmXF+K5ELw196414G+iUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+M/2pVy95P3FvfxzBaUksYhRBWZtbJ9UxEofJ5atrs=;
 b=fXHbK48N8nbGv89mbVBGTt57Hh2qvl8xlkGLKq2Y05XvpaQMC0ofV2ZTZP9Uk40sIit5JXmjVHJkqqk3CpdOwR21lr1P2Fa1YvnWMfko0JGH5MnIFiCfGZ7RocIffSODmGhbjBkvv4gDgCbjcaKKwmq4NZVQEzW63K78AC6OTln5fpLZbwYNzMm0BrYqCVLHmBSj+T1i9r9h6KwFAv6uZX74tcJTSpkf3DTr0oI5DAeUbh2ZZUmy71oRFmGx2J0GUbVAtzWIVIolNprIaQLGLHbR0AtB5ZMzmkBD0GLxnqVrrRUDf/2oPUtalpeR4vg5Rsid92R11p+aQKv+A2Tcng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+M/2pVy95P3FvfxzBaUksYhRBWZtbJ9UxEofJ5atrs=;
 b=adrW427pmhCGvivf7683YZXryV2aWW4QxBoox4Q1knF2Q6qRsP2EmPdPkxL1SpBy9gPbgfA24mO7vLHzOm5HjvGIZizZBM8doPPRkgC45d2n4qRdy3EomSEFPXWmZ4wuqI2M6Hr37YErr7JzTXH4IC0yQlBn4Y78J5GE3+RIrac=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5708.namprd10.prod.outlook.com (2603:10b6:510:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 22:38:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:07 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 06/32] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Wed,  8 Mar 2023 15:37:28 -0700
Message-Id: <20230308223754.1455051-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6bfa87-c710-4029-4959-08db2025c9b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTFiTvKvqTvjSVuQ2+o1xrqxf/OCFPSQKXQwo78d+LVYEWCxV9JlkwghJRIOO+cIpYulsJpvHucIRZ5CANME5I1I8CfQ0YCDedKYZxNzBqKIJ4z+HXOIg31rsoz1zArze236LLfiX9s0UXURDvN51bPm6Ju6FKuQgfmUYtzA66jgqgbcChKl0IiIYaeqm9iUvdN//dXfXzbsX1WzjClrVNNjznEDtEjnCiHUM4O4k/93C8b0k0ZNXTG78k13tQo8MAmE1uTfgvI5tKBAuJAk1P5uPPDvfzDlwCRT6BX79nYZ7IXrGaGU8r0+K46LwGezUE6H+z5w3nYyjTbOFNhbG44lpbINHXLYEUIXzM8ZGJsFQdz6hIPzu2uPMOb/WXQgSqshwWNNRklk3S1ae+vIjwZwoN/y5ACRD3IX46Kwphngu4sBdqDwgo43PVPn1mGZYXzJGhSHxfuQhatDXYiLjGeXCcVLWQsTwmuVWKZHBnf7ZSnNGz5ZtkNmAGIMZmGo/pHJ7s68xmGsISMs/efieMZgUNqrhXPOjee7lmUMjxpxhh4u7BfIiAxPp5zfgx/7osT9DWoi7eTXb4V9Edp/GOi4ZOok7u5LWjXfXiH3CBR3LgppDptUN6g4q+1iJC/v0HY/cWz8iDibOWXo1V3kJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6506007)(186003)(9686003)(1076003)(2616005)(6916009)(6512007)(8936002)(66476007)(66946007)(2906002)(66556008)(41300700001)(8676002)(86362001)(5660300002)(26005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DAkjJBqz85uXkoFzn+gYq8OzQv94WUFHOPDbiGXdGVpxrMpFWdDlU4S+wAQK?=
 =?us-ascii?Q?WVB2BGnnYTshRMxQS4ejmIfI0Q5XLir3Qg1HI6CgsIMRRzTPkIczY0zIoZo0?=
 =?us-ascii?Q?//q9rqK56QLUGnlvPEaq1CZQXZ986bytYp9cbB16RPgnx2ZfGO+lvuHXWpxZ?=
 =?us-ascii?Q?/3qqqN3vml+OzVZIyGZbmWdfdYdXXRkl6n45HoF0gmqYSKykSmb40WEYYMtv?=
 =?us-ascii?Q?yw4CedjITwWu6ZmfR/DHzTtrVRUuSGsxsSzrcx/mnWOSGfM03fKCg0ECJHhY?=
 =?us-ascii?Q?w5MIa5nPIiUrNuraa8tQ6J/AnbipyoHx9eRzEpBITj0Ssz+2W+Y03ZJG9jyH?=
 =?us-ascii?Q?6QNQUbuSwsdYZbPenWQ4Kc1YnLLIUJBVuox36fKmTy/3mO9ScNUjPU8Un1Ah?=
 =?us-ascii?Q?hXZUimR1gJicdivY1l+1sg1tdsyHEwSmZlRlmfo9AJ0zQzO4XeEvBAlrjcHa?=
 =?us-ascii?Q?EaaciflwP1a4BkS42AEMIl1U4QYFcdEahKUMUIs6zRFuHpiIr8hSO/Q2i1FT?=
 =?us-ascii?Q?ZWHjFQtf/YuicbkvGkhuV8O4W5YSWIy3mxafOxAkjMkw0+b9SGj3K3DOkwuL?=
 =?us-ascii?Q?oqK8BDnwscC+k6zsFUtU0z/dXc/DS64K3ZIbzSN22/T2egGb0bh6OHpiMpkO?=
 =?us-ascii?Q?z9CXfW1fgOhFg/hsVSuWrBDHr8zGkuws3k4z5qIkWCB/kgsZTv6+cM6A/NTe?=
 =?us-ascii?Q?g06MB9Nxb6c5DxrAzOE+0tKTuaA0DoNCzRArFBhl0k6jvGE1Tv9/u0G/J9Ak?=
 =?us-ascii?Q?TazCL75ugE2hRaajPBjcnS+GKOvKoI1FDsS4aJO/btzVvS74gHpmlljsmdCZ?=
 =?us-ascii?Q?Om+byrK1/B7OvcZUAb7/eCVpb6V8MN8Gnko2Ma8RLV3Pt5Y1uvtLbezC1bZs?=
 =?us-ascii?Q?UewMFNaVIrnb5ZvwTwz/MXAYRE1opDCkBA9Z/fvvEKlOA5WTTtaLJhmJJIWt?=
 =?us-ascii?Q?/WeH4vPwQtVhCY/G0bNc9PLPJQSZi2Wf+6cfY/wuTNyVodKTqm0V9tysWXXr?=
 =?us-ascii?Q?l/NzmcyIYQ7dllIfG3OoG7TtDnSbiB546YSLwHAxkvhSgaPUOyf4G6zyJeIE?=
 =?us-ascii?Q?ODeUrassBg/HWp1vS9XkrQ0PtegtOX+KDSiVB2aXW85PLpspUBmzBz8FMUd+?=
 =?us-ascii?Q?MhhfKHwAjj8KG0sZ5NCONJqlQoalhpkznwHH2h5mSfjED2VvSCegx+52ZM81?=
 =?us-ascii?Q?fwpu7QoqL5NRlCuiG8t5Od4VT4VBw5/AT+bJxj8uU9j8HjtpZ0+3dbEwHvmm?=
 =?us-ascii?Q?jF5oPm9DJbh/bKNDL4WI7DFm1va0f8xnDmoXCOKsLjDjlFiYoZt9mRiF+IPu?=
 =?us-ascii?Q?hZSGLoy1+UyJn4oQXMnNr3j0wlmYF6pkEbxUhfUl5T/fmgd2xumhhDWs1ght?=
 =?us-ascii?Q?OFNaypqU/s8LKRFOuvfkMarcXgegEC9dOxsMu1VVyGLJU7cBTtY6OVnsTDP+?=
 =?us-ascii?Q?pdd4HdpLruGxORNvQIpR2OBfFYRl5FHpQzvddTnJTQiD/lCWEahAXV2XWxh0?=
 =?us-ascii?Q?Vu0C9/WSO5cWFuOOHz59k8+9A8YQY41Wn1rmzvkWd0GkS2eIRiXA31arphF0?=
 =?us-ascii?Q?HIqA1kb1PW1i64KUyJZ+TXFyHsEdUCml1sOtiBW43ypbW7N24ttmmoVlPUFQ?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UL9sakSdjGLuL9cMo37COv0eejg8UoORc2aYaOaTt8Od0rrBRCjACffIgu/St382ZLI6lD+EZQKGpPxDqCEkUGmTzRr1j+Od1diIj++CXguzVqYZ6NNWvckrbWC1k8ZqGTeeLFx+sf/p06/XRfprAe0y7jUV2e4o/Y1QN+U/CklDw7AJQrUGi9cx/ck+/F7hYM6rMAtDyOjev2dcdD4Ci44AGVrUtK7Sej2fXo5DvA162qIh5JHj00ClhZ0hUQv3oG54EvWlVKPKqrFzYT5B8Zt1gJRMo/X1mXnzVS7Bje9IIUSEBDzkSXyRFEwLJ7Co7V+QtYbPHOslSslJJVhc5dVMQ1KwMi1PMGSDKlBceEG5pcvbcnOBjFK2DImyRxy5krtzerMKCWx7pO4ZfAFXZERjIfrm9ucSutYKWdeV+C2sI7B3e9wTj9rH2KwSg9vIejM+tvVdfTPi7doXl+Uy3oj0GOSDy6p6MsTY6KxgulKxksk1Gh9JsCke3zBIsFs+b41pPGhp+CdCXoWJCLA3AR73R9fCmmanhvl7TVtn8wsnuHbqCfrG1OawfsN2cQPbqg8U0Uz/QfL/EFF/Agj4i0QWExqY2QoSkaslQsOy0xAQvXCIKpNi1UL/ur9qkpYmrbikUXxLW3sh03yi57PDQM3xJiCq8voYQh1agmE0mn3eLLhGEySjGnr8TSPbpnXbhNDdhlqcirDKPm6Xth3BeBL6oWGSNmmDNEHzuC9r54t6Sq15/pP49iyw2RWTrI6Uon63xVtrChWCKQkohXN2wQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6bfa87-c710-4029-4959-08db2025c9b9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:07.5017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Uta8mY1W8qO5vCgEGM8zO96pwBKweBhJdD0eQ3ISDl1AqtUVlEOWOhKNRIMbROKnA6+jLvWBmI7BdJmELRVbcIshVDtsEDoVpSTeiWegUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-ORIG-GUID: jpf00oR_Uu2FVXgzWzZ5uMEwSwWVLqSB
X-Proofpoint-GUID: jpf00oR_Uu2FVXgzWzZ5uMEwSwWVLqSB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8aa8a8e17a5e..166ad86ac938 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 112fb5767233..ee09aefa6088 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

