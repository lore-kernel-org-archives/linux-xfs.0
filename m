Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628DAC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiERAM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiERAMq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A54D4992C
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:45 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKZMlE008024
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ZiMFYPFnmulh5F3212s1VODixNd0cQ7cKYXaG1pevHg=;
 b=eOW/M8KSoUVGSe8m4m9nWNzyKmNU5K7pZwflhOdyOTy7AmDfLwPM4UO+GKExZ3HBN3RA
 e795SdEQuRLksQiXWYp+Rhqb6uDMI8vcYRgxFSkXmDleMt/6yd22B6nj+QY4iXvPaDZ9
 6Yf/uinIjGqsJ0u5t8QKg8hFUc/8CLfwmIEo6RMWXE+iYhK4Lhw+LqavOFBo0Pi4BcAC
 VZtkRIi8bVD3CU13lJ3qX1x59Qo7iFl6j8ZKaJfrnq+QhiRiDdapxqloRG+I0nnAl1Sl
 uIexdsUUE8NoZ3CyWjPK7NhmGCjOxkyGWn2jaXaxnqCDR7mM2B5wOmKxZEQMXE4NlN2f Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc7m37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BXpg017045
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3ebar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pbqg1EypPB6KqUIuBdpR2Yfx3O94qcAC6b1zdajDZD7gaRwIPnI7QpRBchNFtouazmvDbPiGcOfZOy3Ua1ovdg3141RiCtWkT0BxyfBZDEYiRkrRxM/+10lOe0Kz72B6vn+s8SxTc11/GyuXiT9syJxF/chpyr9b7aNDiSmxXk8Ji1BcaS9FQyaapBbQs3ZD4RJNHcEEnR33rD8MniptSofS0PV4EEmR1S50anRuh052Qq2KzEhPabd9GCuWnGTsvGvkE8/IJTtaEXwhrnEdgAr0jhKNZLzQOuy6JXXXEcVDlocY/jPiCLCYBLj8k0om0zblw6nSEoR7dN1sLFxHkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiMFYPFnmulh5F3212s1VODixNd0cQ7cKYXaG1pevHg=;
 b=SeSGQRJ6j1TXuGDNi8HAiINFs+LTfkFWCke2fW3nM2u2jbGZ7qpVt3zQfWSASnVJ9+Fkn/szkfT9cgXBQoy3obbFTSVQQa87q7+IrDpnS1DydDxNR7iWqy8KmWhOX2bKjf8CU4IuHawWw4H7YvC5rOVoT4hhMDuKjxcL9PJ5nTV58dsXxmlWMhMFSz6zGHxjM7JSRsXLon59H6vMWWgHnJypZiqg8RNdwoSIxW6cRYhZROIeibmVI69+AbNmOOQIL83YUy21oJeTbgTZlKALr+56DsLzHwc8EQttMbDyl8OSzLQCrDFMu9lMa1nqMTJFh/PxbhcNHjfOnJG5nzlk1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiMFYPFnmulh5F3212s1VODixNd0cQ7cKYXaG1pevHg=;
 b=bbhoN10BYGs9tWknQv2Ulx3JImfMiOOelR6nzutLTEw0EnrsApb0OgomOk2LJnDJ3YQrsIZTHk3FDEVHcAcMec9QVjQWjWRvjhAb8LiRqFLPNsaOoP2Ox7zVmI3/enM3PpGtNmRe7xK2j+Tuvx6beN8iEzC/n2DUveHdS4ZRV38=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/18] xfsprogs: Add helper function xfs_attr_leaf_addname
Date:   Tue, 17 May 2022 17:12:23 -0700
Message-Id: <20220518001227.1779324-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4285b8fe-c086-4740-856d-08da38631f37
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528F04425A6FF81A8B8297795D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVpSKUrGREMpOBBQPf6FFgqQLNAQAyHU3Bct+4aMh9cm3Ke96Cq2LykdyC4QAgj6PUbF06Cfw6asU2HBYl+8BmwLIKfEqUd8eeNIo/06GceCyHodlCcM/E3iTX0TjzC8NRno62Z3gbsTVoREEznbdBKgJd2Pka9oRdFmcI8kjaPj+7ry7Ge1ppr0bBrfxhVsSluFDZPhWUSW+g5UHjsQJyoYoSXc0bcS4N3EhfOOaqXd7JUv+MhzdH3+xT088T8+9iDwVMzJlfPOaftfq3YvQmI/KbZLVF84p6JfAhR3oAi6B9wENdpNRWbl3eLJQcYUGijaaOu6RjyhBdVroftmhBH+l/XI45h+2ufRdMPjVIDq9XRkyqnjurYhL9kGZv9C7QbrhIXl8VD6/DP6UjONtKe8hATdd6MzqAFnps5gCjj2r14+TMSkiwPEiD2YM8LtYn+X8Al/rlp/Ib5xXGzNaECI8VyhmLaEg0HVzW4Gt1O0Y60JrxZ/AXK8rrDLPrdtLhARvNYo6h4tVAFtpnorygpq1YX5JGifK3zkwIxvzqgTxZK88Adwk2O5GxOk+uAIqPwvIl1WShEgExRXsT4x9Vugr+ox9Y6K1ZBD65F0ST8tAIBl8FXv9+4EssEHSHBZEHRwqMgUInmwwMvrwtzlbINmdnvXdeK0C77gNz7UoF7yjZ2zimc2KQ/D4PlaZ/t2H5qsPbRIUBv/+KiLyu3UUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5IhbZq+wU2D4nEf4pXiwPv6AVUSmmKLFGXjY+CejcYIQ4+gwUa52Fn1vyS7B?=
 =?us-ascii?Q?2LoDlpUeMiBG9V77AAreQCAbZNs9mFJmvNifSF8YOSY7o6c9XoFHfpUv50VZ?=
 =?us-ascii?Q?vjioV/ErUJ10kOs/ZCt9DFu6jj9SiIbhMBiitwqvwYPVQO2SxEuVm+1IDlWf?=
 =?us-ascii?Q?N59gGaKi2SLB0LA9F2GBpksS7oV3jbXpS+zOwlqey63qD6XmcNXwiG2qmHqi?=
 =?us-ascii?Q?eq97PpCDv3tsvLjcKO2GvVTCz4xqM+6adKcq7ICD427/RaqXqmhCoQO2yaH2?=
 =?us-ascii?Q?XqVojTkL8DDS8i/Hek3y51bbL45baC7vtOpqrCFTYg5FTWDW5QwbbV5AnA/t?=
 =?us-ascii?Q?tmBlg6fTuSHP3+gsBmyJaDVCDZmaa8px0vsxKctuGAkRHoj+gtS92c8fduoN?=
 =?us-ascii?Q?XXmePYwG0VQ4509yJWjePOsdEozkigvzOmp3QoQKjtxRFt8HB04lF9VPeG2C?=
 =?us-ascii?Q?gjgUbHndmHmlagteRt8U7B4hWFPQ7qH1riVteioccVBVeeFsPkj9nRPaxGHx?=
 =?us-ascii?Q?JW3hxvFmrSu4T+Qpbra+Odof47diqLcMR1CaCRqPNuSePliX5YHJHqTwWNUj?=
 =?us-ascii?Q?KFXKqbqYr5rFtjsEcnhpvvsBilNcBtXjKwYojYUgh1EokXhqN7ZuZjBbGzHU?=
 =?us-ascii?Q?bGncA+kiKt/zuy82ehp3Wk85f1ba4blejbIqmqStKqSBxk5epCXqV4kc/8Yq?=
 =?us-ascii?Q?e5Ata73UXdQ71oi2t9CLAfZ8dXVLgIsPhj8RK8CwIX7+4yVwOLwl5XGI/yCn?=
 =?us-ascii?Q?uCvXPkBfXO9z6ksmQo1ITodI1vD6OEih0kPUxnMLQc3IqjW9H7u3yhlxpF2W?=
 =?us-ascii?Q?boIyiZkL+tdWtqk6w1dbyLituQ4fKokrhfArkYlh5n2YK2zATxdN/hzpIRiF?=
 =?us-ascii?Q?PWfSvOckxXKjKtjjj/c6n1vKNFXEQSv0wdC87irUYj4u7l1Jz8MNGcl1haMB?=
 =?us-ascii?Q?SEizM6fqH2zoax7QwCCe+mhhohutdcIA7luWCpun5bPPn7J4lijcsrSIN/5o?=
 =?us-ascii?Q?uLJkmtVg808IsOy1JcbDErPEDHs6cHQm2z07FMD3IHf3sX082wW8pLysla/b?=
 =?us-ascii?Q?Mmxmo6f2nRFPHYIGin1vh4xMQ8FkavJyvBmDkyN4m1sI1VI3vZJMolKrYsiu?=
 =?us-ascii?Q?BvYOQOk+Ft8RipxZq/AtmWTMRcyKNviEiXnRfX/g6oe69l1rgphUSAMS9iKD?=
 =?us-ascii?Q?4k+YsMg/A2Is9gLVNRilWLovA4VoJiZF/HD08j2N0XQHimAWnSm1VDakk6Zt?=
 =?us-ascii?Q?3NCQUMxwbtJDQXpLIs600X60qtw8aZLGbCuBDsZN3BRK/1Z2Blhhbtwg7pBp?=
 =?us-ascii?Q?I+c/1pgkhbFhva/tDa5lGXYC9aBXTEYUnvcmm6u7bnCUrrXvOPdnzKq0Uc6c?=
 =?us-ascii?Q?e2VabQkSycKQtksMSG7n9jvLFM4DGc6DgfB/imT1jhy9xPHU229jjp7o2nFj?=
 =?us-ascii?Q?C5Gtpy6gwcvTOf09ecXmv28CiEmLC9BSph0oDLYXhfbBmFPHGSS320i2AKOe?=
 =?us-ascii?Q?sjOdQd9KK0VYiQNYIZ73TxpNm54QxTiLTxnyr06oSW4Wm9UsqoDzADGJlnel?=
 =?us-ascii?Q?3VLYVgyY4sr4KAZ36GTa6EZuRylLA6veGKyFLOknswk+Ga6o9wYouAdZBl8M?=
 =?us-ascii?Q?Be3fxRKLRKrIxhP+1h6H6bdzFHpSx+3xDW1Gy6tCSvcPlo4Vsj9DYnRxNv4U?=
 =?us-ascii?Q?1Y9PNenhrNdqnQFKjGe0fNxbLQbfwx0Dghsg3nztEU+nlON0Lp01asiNwdy2?=
 =?us-ascii?Q?MO7ici4n0IxOfL0Q44qVHlvYF9Dzx88=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4285b8fe-c086-4740-856d-08da38631f37
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:40.5183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0H/7fuAqwNQ/c7NCdebCjFXRkKjMtVhtfwxa89OFZhFRBVGcTiqyYCF6mkVuktXnR39SQDQ0qjRlKISUFkPrLAWB8clOR/7fJEr3UANzQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: JJuk4n5PUp3zqLEdLYGnEh4Suv8Ya3OJ
X-Proofpoint-ORIG-GUID: JJuk4n5PUp3zqLEdLYGnEh4Suv8Ya3OJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: cd1549d6df22e4f72903dbb169202203d429bcff

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/xfs_trace.h |   1 +
 libxfs/xfs_attr.c   | 110 ++++++++++++++++++++++++--------------------
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 79743f0457e4..4261a6655067 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -41,6 +41,7 @@
 
 #define trace_xfs_attr_sf_addname_return(...)	((void) 0)
 #define trace_xfs_attr_set_iter_return(...)	((void) 0)
+#define trace_xfs_attr_leaf_addname_return(a,b)	((void) 0)
 #define trace_xfs_attr_node_addname_return(...)	((void) 0)
 #define trace_xfs_attr_remove_iter_return(...)	((void) 0)
 #define trace_xfs_attr_rmtval_remove_return(...) ((void) 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0cfcae5e2993..6833b6e87f3d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -281,6 +281,65 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		}
+
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno &&
+		    !(args->op_flags & XFS_DA_OP_RENAME))
+			return 0;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -316,57 +375,8 @@ xfs_attr_set_iter(
 			attr->xattri_leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args,
-						      attr->xattri_leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno &&
-			    !(args->op_flags & XFS_DA_OP_RENAME))
-				return 0;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
-- 
2.25.1

