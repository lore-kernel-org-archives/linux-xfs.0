Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F609C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353164AbiETTBC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353120AbiETTAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CD1D1
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:50 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KFnGhM019283
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ZiMFYPFnmulh5F3212s1VODixNd0cQ7cKYXaG1pevHg=;
 b=z8gC27tOZs9k6xr7Khxp8yR47m6tKPzKdM6QAovolakpddgDbB5fxvnrF7Md9beNoJMb
 7TOqkx23rXxYqDNsxAFmGiSBX+H7CqCdefrSo7JZtadCZOEajGfR0tcjKi6wwaeeOkLE
 LTZKbPSlK/Em/pbX3GVOwv5g/dLD+6CcrWU1xff5F1ksPl7usi+TSxQYiwId90izfjSO
 EDqWm+sqJyhj22N8OeReF1ijNxteGlJ4+gMhTG8QXeNzruMWNWcDk0RDSCqFLdzk9V13
 tdZE8SEMKfRe5iPocue41C8vvpnj9fg7J2p5DtUOBv2yEASU+ewhDzbdVAUBbyIM+xY7 Cw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aaqeku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIoAP8034622
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhj7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsXlXCSVFSfUlGz4WVyPEgOiJrXfByBV8MADJTOeyjfFqf0J9ZaQ+CeuyOaPOSxIx50RC0ABiiO6F9/p6FLqd8dsovV5iwApE+v1y941vsKMSKIMw57YrPn9pJn5TpPQygdyuathsEonVuCkOlPfou+6ERXQOlQQPA9pRmI604pcQn0p1bzPno8WX29E79MYWC9jCYGTYJRRV0ONFpKLKlMJwWgPxH6HLtZ9yFxSFXWPg4PO8nVBXDpCUJ9J6kseIwEliE7Sn3aduOGj0vwqZ2DBBDZElXacxhPbItGqzMoxKhXHB9/aZR6mAhXvlwVeazOqPYQdJLrTxZJdYsh2Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiMFYPFnmulh5F3212s1VODixNd0cQ7cKYXaG1pevHg=;
 b=FwebMSVzsLAvu53gm+zsRUrUxncdwejiDnZa8kMSYs74t824XcyWMF72/gRmBIlqVub8U3rhkqe5zrYMxc/9qDRHCbUQ/VS05bfHh4ayJSjdMx29amOrSLl4oY/g0En+d1vmjbGGkqzcwjqvMXNNpDiT7uJlYAWYqaV/sWjICkLDV0TVF6vy7UrZqrwih/HU3D3xDc3mPEyhKlXofbIW2I0oi/UHFiXHMJs3/W9TJ8oGkQgNOG1JnMq4AnspF+aEspOaxFEPfqXKkqc7LNuUUz29egw42zwRwQu+Ghz7FLFpS0JDP4uSUDMhoN3wTGXEVRJlCnUBxHn3wSehh9+cKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiMFYPFnmulh5F3212s1VODixNd0cQ7cKYXaG1pevHg=;
 b=S1UGeOZLoit677Nj2SVLHjKRs4wXjdOALOpwjJjptstj0RMgfOgRtbPYuWFy5LO+FN+mS9Ll8BULwuEbrRG+2B9+6XiiLk4LRQ13jfN/tFmyeVJsc7zFi8ffagJv+Pv+vo6IQGIqG3Vw0Evn3r6Ix+NqomU/43jZuus44UpNWOc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 14/18] xfsprogs: Add helper function xfs_attr_leaf_addname
Date:   Fri, 20 May 2022 12:00:27 -0700
Message-Id: <20220520190031.2198236-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed29e9bf-4141-4256-cdd1-08da3a930924
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB365822A92B740D55E9AEDBBE95D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8yCD+bZFgeF0v4vWg9le/NThjMe3jVmVrWP1Z5LrO7ncu8Ro2xtAU/3+qk9M4nZB2kPs4sYqgV7mlHQF/hj+nX9RhKqeMwN6QZXWDpbj1b1FnbKJQPiqMwa01ekAtr+QZJUo+lGdVyBUyUdI4YCjTl7jSVA4yjclZiZdHxz3VJE6vhYxw/By79A8oqBTOjQESEzkHatz+/6oczT6rYfGB4NYX7iir9Xf4vIGTB2wMfTMUyEy+IOKa3uZBVEFBhcZY9efy9fV3prtKjXeMGnFurrKxGJ34Hof6mhYTpysvsI0JHdIID2lLv6WMsWLLrHx1/m/CBPAEaJiBskWQ6DoJmo8DkFXZoBc6AP8+KEeheRy0wGNQ39tRNAYns03sWBlKJOB3nVepBRDCzzm+DyW7YUolI8qC6ItsOTedfNbA8zi6Y0M9SslmhifTtadragT9Pi+qQ86WLdeYbxumhEm7eL6j/te2GkZHmQOYeMSiq1/4ANmo63aw9rHgu0FVyrEAonBojVVsvpiBMPOk+hoQ/o0CKf8DMpZAJmFqJbhgmyi4pSjp4SH9kkr5JRd+0Sn5ozJDqTv0jwZ67nUtgMRNSaDW9+20q80giUpz8/VVwVzw/hYjFB4BvoV57H+nnAnI4P831U4fGjy3xXmHAOhkBm7SFJpSSaWoxd64UdMMHtx80pMsSn8PXPxXoGdIDs5rSTjynKrIqsVNVlGk1FrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IvWNvgKmca99mTWyaQhcV9xP/lxs8tghYpfx/qld96B9XHsFptxdEHtY/erz?=
 =?us-ascii?Q?0esFmcJRN7mF3rQiS1RQNXkuztHjDXoWSfsUfGJh0Av69zg/0gg0xJrCIF0h?=
 =?us-ascii?Q?TTuPreJgMCRLUrlmmIoXs2Q4dT3j5/4mL13YREMx7TDOW7RRGWSvDAZ/tMNU?=
 =?us-ascii?Q?8J9TSNkquCoOA4nCpgssPfEit7ZI5B2WiN0YPzrqV7yEu9BeFw8B80G17sac?=
 =?us-ascii?Q?loyaBZm2kHKWm6Fv5+zmvgUaB1WpY03dwEu5l9W38ulHrICLXX2Vo+dZolSw?=
 =?us-ascii?Q?SGWNPICck9ctipAh7gwX6UYCZxJg32wngEJlGzKsr2TMEhcKStMZsHYcUPS0?=
 =?us-ascii?Q?j9naxLoEduQ3Ucfgvw3cuR6TDg1Cqb626V8S/Jh1sfy1stY7EpP1ReaV0zlO?=
 =?us-ascii?Q?wTA11AQ7XvzccVTdg0uLrDak67MStF9e8/V2B3KXndZeZpFeOhrx4Mxg6SZ2?=
 =?us-ascii?Q?cCX8RCPccYf2ojKjdBC47MwRejLKjtKU2LIAU0JQzoQJmfZAWZ03F6mYy/1z?=
 =?us-ascii?Q?oFkfUdFW2bbkdynK1yenjHRX5s08XKJploVDzhYxr+4HgCPPm5XtnL9hJPSe?=
 =?us-ascii?Q?tPIBlJTuF3Db+zXHTA77N4i3C6/bkR6dptQpalfPGjTZER7CXWJhUJn4m5u5?=
 =?us-ascii?Q?MMB+ArXU1uUJUulICn11ptbz/tnzj4ykFZ5e2xZyo+o6xC7e/CzS+OgIYtN8?=
 =?us-ascii?Q?ME55W9zqIVM2DB0VNMdmV4FbeWb8kZ9uZ0sZIlju9F8Ec6Tgi9vu9U7Th+6T?=
 =?us-ascii?Q?4bUpLLe/9nbQeKuQH7CIZjvb2fGKffFfD3bDgbrgfBCGJlSVCjbXhNpdyRvO?=
 =?us-ascii?Q?RD+Kw234MLZOkOQ1noubPs5jV554NvCaV1wODo+Jurd3j0AWQknChY0kscGQ?=
 =?us-ascii?Q?vQ4WkRRYuTc4MFqV/M0bv0kQhFqTvIiljOnC4rJ3PU5+TyUNJhQa/Mym9eOH?=
 =?us-ascii?Q?ycuB8FAHWhT3d/CPYf5/oaBsa1+pomNC9DBE9LMk7QhcSj6gyRIQB3h78YHh?=
 =?us-ascii?Q?0JmP5ImTL87yOT6fg6vnmJNAlgsKsMbQs0m/pPQLydCd2R640tz4mObaGHBh?=
 =?us-ascii?Q?fjOPIW5KFJ7KS868QdRGY/+KHPBCiZxUs+0NPerkpQ/pHMWnTpkv+N/aPB12?=
 =?us-ascii?Q?OaWI5KknhwbqpUKb7vMm87hXv8VuaBB/BrhI7uUrgJoW9QSR3iCQJJ4bCxKM?=
 =?us-ascii?Q?+4zpIuWpBbADuRZMakxjYsXFPzNvms6PjUvziQTPUnkv5Gg+qCbFrDzsbDm1?=
 =?us-ascii?Q?cWI5hQkART125WnqEnHFUnoLNT8z/AxX9BYRC9QkghJWN9KlLO1vXMVh2ofX?=
 =?us-ascii?Q?3rv+wRABq5swYNIy0PbtJgiGjC+i+I8XoZMr2IUN8dKjpaK3XMU7blOEz73Z?=
 =?us-ascii?Q?+lo0TDE5f0/qaWQgctmnKnD3xuMe6b0vtK2IB6yMHrvChZbDlc6KpV79khwO?=
 =?us-ascii?Q?pOgD5iKY4/xSvcV64Ihpl/nL0tFAqDrF13Db5HoA7ahhUuzxQEvhx7k8IOWu?=
 =?us-ascii?Q?/LEPm1GWfFWVjq+7+jkT6cqzByYhzBydeFrxwpyJbhtbTxlDjh9ThenOHRo2?=
 =?us-ascii?Q?6ZZXP7/20WCOvrrElw+8TeEBI6gCY8gKDUWJgFTKfcK1nyMsMgT8ObcH2yc0?=
 =?us-ascii?Q?SEoSI6IhQmRjfAquuRexdOeYD9Ds2ztFaKIbDaucRztCk7Ima0GQoVAbeJ37?=
 =?us-ascii?Q?HJri3y6shvWgcaDwevgjBwHuF9XUK/VlZ44b/YCkg7tXP1+ULvy7kuxw7oia?=
 =?us-ascii?Q?MaRjjtivgywc2Bt8NSrT0QW8dagrOt4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed29e9bf-4141-4256-cdd1-08da3a930924
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:41.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dConMEO1FCEwkED6b0Aq7tvtyI92i+4nf8aVvkRiJrdvLZmIit5nbX/Jewo0sI0Z22i/rPWjaVyJL7oGUgqWgKrXltvicFOoVmbJ74WG2wU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-ORIG-GUID: evI0kXmGu0TKhM9UFU4gLbBVk6ub8xUq
X-Proofpoint-GUID: evI0kXmGu0TKhM9UFU4gLbBVk6ub8xUq
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

