Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FB8CCA47F
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiFKJmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2A011812
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1i6sQ021605
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=fLaM6kbKWeJC/dicDhwftMRumfVTbGhy0eyW/l0ONOI=;
 b=GVWE+GJ6zTWuivlBysI/pm6wPO4Ma/ox4Thq8X5I4Rxq/d3baQpzdlYWlxsZCgChdrlW
 0pKqqxFuBym1wgNuKC+aJrKRunrg79Oqy6qOUozAY1F0x1TCuEI6UYr+sq4Dg0AJRPLh
 4VySUwfOIflmGVFHAJvXqPSPod3HiiVjeGX7pdpYZmYe6oSydQnpqKB/wVwdfscUwV7Q
 WbYrij+631iIVwjCu+OGhRmw1uN64iFQ6rVixFAR9rUqkmiBGeee5FGt3BmMnL4VE6Ae
 +IIZy4gT45lfgJdZhLJf0jZWPiypYxQfZZ0Jl+VyqhWFK6sW+8RCiJstAvnXaPA16gB2 Ow== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn08c6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQA025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzfjUUfiUd2KqQ5trhEzagwb3dWdwCQhJwfhJg6sWnhLtcDOPxHiilpYB80s6spqk5EJOElxZ/iHT8Yrbl5BMdQI8Xl2519cdoKMFKoJxvnJAPrHonnZFM8xecaDDqC75LQMJ1eKN9Vxk22SWX8otWF1s5bZsZNK+iz38pA0MCuit3yqgUHe0cU8hRnvl0FeZ0vkvHTt97LeQMGhzbgy9wqn+kQQkOL+r1rLTHy2XOHvtlRQinBFR8BfI0ckmXo0F4Pmhh7jqoknL3Nq5uvVRABhk5gaZQ5CEiUD0kS7ljQ646/ZlfNgQ7RQKHNbOcO3eB/kiB36uoKmx/oWRJdk5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLaM6kbKWeJC/dicDhwftMRumfVTbGhy0eyW/l0ONOI=;
 b=i/+sl3U2h/o1jymtgbZurJcHzxQrxUKt9Z2ylY53xxIO+xymDV+bmNNFe9apgGjUaY3knQPvq31ACqomukrH9/IQkwpfBejPHYMNdfYQpSbmdF/EVz/LO1sd6S0V43fB1WPB8PI9G3LBnRjqC182IYEaBO0F6oEkbWkDY9ef6k+629pLr8RsswZcq008GFhN8MysYQZ6iC+zlxcPAh9bzhmV5Y1JtPnmvSvbZVzoD2yFqZlOXXQd6StfKZc2PsiYCoEDtzEOb7KAoX+r5T0uQ7DRu/CB9s8v6IwZNolroUvf++cDl6gZ5yV/LyhpBGGgsYI996x/vjVPP+LjUKM2pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLaM6kbKWeJC/dicDhwftMRumfVTbGhy0eyW/l0ONOI=;
 b=QeyKtMevPdt3lAeiAKtCfJQ/laKsPfALZcueJNtjB6N6Z/jS90i54PhdUAQQ3SLtmZnfgQibMo1wYmVvgv3tbQdVQlKPb73UdS7fKt6cW9itdVwUwDNKoa2P9Y0ijVYwZN0PC4lBU5Y1RRmaon3ceG7vlRDSrXi2Fv/bz6PkQ7w=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 05/17] xfs: get directory offset when replacing a directory name
Date:   Sat, 11 Jun 2022 02:41:48 -0700
Message-Id: <20220611094200.129502-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1babcb1-1fff-4527-f95e-08da4b8ea64f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB460626DB7B8CA363430F330895A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YRIHyNlVdWItExFeqDThU6AkPXZT40i87pnosQbFTuJC12W3eoVD1ShlrNn7Cvlool9H7rc3sLphbAjkeP18NBQS4bgD7OFHThQoMLO1dDd7JoLzl6MyCRKjTacQHMVA4ynG+7JwplEa1K4sz0M/uwRnCCebLGbPQ9I9HYj+vS0qmQdn2PyEtZAhEPvq3ukKwLoVr8FTQTC2G8zJAsQdCZsVtwRs2JQqVCpu/3LrRrYQocwB87wOWmFZdTZrylLJZD1BB8PD9jh2cEM6y1XN2/BExpJpV9HKMEecO95mHx0LjEtAuz+ViFJroeFDp5WlelvWfGbJ0jRVIyeq1mtA7zFmj5wUG6UrduUFYY5g6h/0IyD/Ivc8RjT2R54shEMzVEGLTdyksFTnGmbVFDQyywD/rA9dxbYB49uex8r84GXa1YPNJgzl6R2HVzC09bNXDyG4yHV6ScUskip/azL7OAszUhOorwyJK2WzAtkx1moaVolfBa2WBLV6f1581DrjaCyrtZhZDKwRde/uA+IrACCNe0/8mxINxwD2BzjtVtXpDIu9h7aRffSpmAipWzGGLu9l9/21ccQvlU5KPsNa3qPmLzGxAdk06v1ShHN0gAUjlJgILR69oGcA/0JNz+U6FMazQVk9CTmUSk4k/SwixVPtR0Th6mZWf/TtcDXX3pR9rqiFoAUTbMYxB2ZxDb8gAZD8D8JtQbcKAB/P0WxIBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qxW9njZdVrlSaaRzj4WFEATyiEMpHP3sjbMh660TzSO1ZrXixt9fUucFtuJE?=
 =?us-ascii?Q?+7lpQd9L3ikCbg2Yp0ma1UyuYwAyGgA6WWK7SMIDfgLGoTyu5qUEjxE5BSqG?=
 =?us-ascii?Q?ED0vQ25ZbcET41fDQAppy4Lbr7Hyusjyg2fO3lsq+YEdzYOsKVlwhrGc8cPI?=
 =?us-ascii?Q?ViSV/xGCKIneaBLsFJUPhPRkT8CIAA/EVOa4HiWDVOdFpLtlgnMo12YqaHcg?=
 =?us-ascii?Q?EM0+CCUuajl91Ua4QS3+nwYjwjT/xFYGa6o3rFNnMBZK5v9SUxtyk5xaa3vF?=
 =?us-ascii?Q?IjJYTPX6g8AFCZRy49HmYQl0e3BwohSOqBzFLt2wKhqfP9UK3tuPWZIKK+oj?=
 =?us-ascii?Q?aZNA7XvKXCJ2m04dmoFvC/SPe8cy/QwKPaxeRiII5jzW47wPjuAU8nobf8zD?=
 =?us-ascii?Q?gzimFF4j0j31vJcNk8WRXkj3jkjwzBODtlDrpaLr6i/aunMjZqNke00jdQJr?=
 =?us-ascii?Q?HsYrC+3h+1d6zpwwhsW2MsmfnQRpp/s+qAw9UwE4aGysuWu0kjZJy9b/DGyK?=
 =?us-ascii?Q?4ATmC/1z5bgQkqI6WgVn1pBL0wlnhTaVM03W6XdGytdP++LcuSrdYdCg+JXP?=
 =?us-ascii?Q?bIx4FzCKZYRBXk+F+D6Y+MKsLxquiUWyOmeknGOHMe9PltDU5DGpvcEtJngB?=
 =?us-ascii?Q?pItf4E9bZWtHem/+cGPOjpIWW6gU1MnvGi/IncqzdMvZUDNfPB+n4poAwxWb?=
 =?us-ascii?Q?tGQXVQHHRpU+ooOHkg1MzW/KEt9Ye2oGeVela2IVrS3ezAlHYoJ8N1Aj6i8U?=
 =?us-ascii?Q?RNuO3K3uL8QbLcSQtCiz3EIHsqvcQ4/qKJo1wY7eaod10wNeA8N3MoQhHIlg?=
 =?us-ascii?Q?mX71ntS6/exfA4TFE56gCD7P5PyCFqe90YlE/I00wWkRufWuGGtIG+h9pAm9?=
 =?us-ascii?Q?QWj5YcR/8sDQlnh8x48UK4lIzTSECrGjs/a7IJCQmLfQ6FTlw+UOIRDRDUBp?=
 =?us-ascii?Q?OLxDMGWOkH1nexzdxqsWTt18qAB4fa/uGCiP3BW78E3v4el/pluRBBqbWD91?=
 =?us-ascii?Q?guiYzKAdrjM54SbS7cYGqgFa7KsX3I4/aAtbxUCpG991//HnfB2iHPVFo7x4?=
 =?us-ascii?Q?i6npdnQshOAiqs7OgeLMSAf4zwtIfOFJQXf3iBldV+ou2W9SJ93XU44NNJPT?=
 =?us-ascii?Q?PL2rNf4gOOhPUGjgwVwWesq0MlISKQapEaxf77OHIsRKAPkzdIizVthKaMjW?=
 =?us-ascii?Q?+f3ERNWvRSnijq/ECjETQIz6OSyQrgQ420uQaE19pewVrPeJlF+kg5WgQNwL?=
 =?us-ascii?Q?qUt6tWWubUjlAZ05iW5rCWmNFEo09ENEo4bQLdEjlrNoJ74R+u2p2gCBqi0E?=
 =?us-ascii?Q?5vzT3BwDqG9QECep69mMt9MqehKMw3pWOuPCNlxmqOkdu9wjq2U54/Zlp6Vm?=
 =?us-ascii?Q?YqSRrYmQlZFJsi0VGXRVDHHdUWodFG6KnXNymjbLfryb2DMY08ViJoxkdrSN?=
 =?us-ascii?Q?XnPi+mEPicL9ra3x+g5brOgsBD1hmLhJv/HY7qMNSa91AcZDFz2div5hnPi4?=
 =?us-ascii?Q?FtwbbYs3rfh0DPTAAJGFS17a9kb/Wt7NeewSE+57DIUorHBUR1W6rQz68xLe?=
 =?us-ascii?Q?84IjadqsG0F8pbFDZ7gnc+tttH9L9tUnlWncMVO2OJsXB+CiuEr4GWUVPOn/?=
 =?us-ascii?Q?FURk7NAsmlCGxmS8wxhp7th89v322BNNNWKzeyYru7WMjL/1JkuyY4XgDRTe?=
 =?us-ascii?Q?DzI3+JJEjgUwvqFxUk0mYgkZqHL+eglcwSwOi20t5B4ezipvowmjguriT+Dw?=
 =?us-ascii?Q?wdNFSyuzqcN2/NUG0QFmdD1hR4tStq8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1babcb1-1fff-4527-f95e-08da4b8ea64f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:07.5295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgT2dDCRLCNM9bxLcfZrLJ7XN8y18s8MCNIJXjYAgxp9uC3CwlB2LU3A+Ivng7iBJz+Vs31PtArP/Kr9ngmKIMfHPWPt6qTRymaeBKL0624=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=881
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: 6vQX8N5NWM2l2SfHq32hnYqhUfcJfnm7
X-Proofpoint-ORIG-GUID: 6vQX8N5NWM2l2SfHq32hnYqhUfcJfnm7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           Changed typedefs to raw struct types]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index c3fa1bd1c370..6af2f5a8e627 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c581d3b19bc6..fd943c0c00a0 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 4579e9be5d1a..ee8905d16223 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index c13763c16095..958b9fea64bd 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1518,6 +1518,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 51d42faabb18..1de51eded26b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1109,6 +1109,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0c0c82e5dc59..b2dfd84e1f62 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2817,7 +2817,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				return error;
 		}
@@ -2952,12 +2952,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2971,7 +2971,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2995,7 +2995,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3315,7 +3315,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3349,7 +3349,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3388,7 +3388,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

