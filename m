Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E4CC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7493661501
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhKQEQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17210 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233000AbhKQEQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:56 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH48UCN032014
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=IjPCCIe3uLXXNy4Lw8Jv2YglFcF7EEtek0sXCKNYw/U=;
 b=0QlH/rLM3pvW1wdkrhmMPTtEa3/PTa7uq3kYWAv/0gmkr1wpzDzYBO4otoOZhOtVGUUg
 8spl8TEZ1D6XKIzUdoh3ssu92/gVdKRY5KYQz3LbabCnOFavNc5IusRxZtZFXw8myZHP
 dXeOGZEuNbf0UODEG8zL9i8BNIajFK3VxukqVOOADisSVnrZXD7OHLZtpfuS5FY1WzPk
 MPMNYY0cTNCNnaUrl6JSZjPA68fXMPvX463uoDFVk2zSQJrXyHWR8dymcL8hKahsDm4s
 wLUr/dqmJ4miZoRJNlY7kxNdv8i/hVTGwpiYSV/aHFl7Loh5/VFZWcMLNckshTivnBcV Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv86em0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEJb180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3ca2fx68vt-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrjGT02bb/aP8XmMpb4k0lKVAwLcIyG/1+vHIVfBbiHYSoi0nR2OsGvxKhPdHdye8rd39bqho1mwU4LShYtFpoIzB2/N5YNUHMY3JSnwa167w7M5fhB7qal/BKi2EARbcJje5MnLms7eQ4Bzq1i1CEu7VDSh2N3LQpgbe83uDHd3PnviNFJQHTfgFj5FemAWRUDAbTSHH9bedEH8Km0XxN1odkoFK3pnKbF3V5026i4G6wVZsIUNb7m59e1ZtPgv5lYmvZlvoY3FCheY/u6UokgQOHANKftu+nWzMhLTNpa07zV4KHujmmsT1CdSgBOV7dh+G1dfnMTendqzZKvQLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjPCCIe3uLXXNy4Lw8Jv2YglFcF7EEtek0sXCKNYw/U=;
 b=lN6i8vxhcDcTHmdKHdgYzniIpxs5H4exRZQi383puc7L1ZqOBBKWty6hl9m9xqfKS6muxwKovdeyEgSHO/oyQ/BWSwjxGUhiCYA2C7nm+vL1qtYm5j4rerotH5g/rGf40u8zf3cpTXjmxUwR9fpVomnHwuw+XJ4p0oBNxoAtEOuLfC/JsA/RQTUqAkkJbEH9uswzEnUa9rVPrgFXlVPzhtPW6EuVjTagBH4snADIidsT4tcYl6IyYfQFljH654l6DHaV9TvvwBGVJnW/dC3TIls93ZCTkrjtWn+JkObIXUEKLHrq7tWQdM4AytvZKciReGOMWe/3rxiAWklYCAREsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjPCCIe3uLXXNy4Lw8Jv2YglFcF7EEtek0sXCKNYw/U=;
 b=Q7yHqtoLU2F6lJTWk0hOTgiql8DZjN3vC/D5bbbbfHbsPHlBZSL2AC4OuiGtImrd4pFylwjEH+6MZ0kf9JWpjCQn9M2HTu0oA3HOvQ4i2jaogsCJS4ETLAkmzPQVIawD2HIxCL3hd5Psk+h45mSPfzvGy9nIALhPV+fom60YQPM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:13:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:52 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 12/12] xfs: Add helper function xfs_attr_leaf_addname
Date:   Tue, 16 Nov 2021 21:13:43 -0700
Message-Id: <20211117041343.3050202-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d4b8675-160b-41fc-1700-08d9a980aa28
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3921F8E01A44ED4C2700E99A959A9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFedu3n483nhyaxynjwRIC3KH0NQXr2B753p/+ZTP1yNLHGpqVUS4uHS+44Vo9dBzawNc+kcqiCDgHyRpdInZUEdzC7DfdAmgfwi8k1TrgcoDb2CQpWAFcuwwQLb3W6u90r4Zhii7USwB/5Th8AlP2mqmJVpWk9WtgPt+0FIkstZV6rCMbeVKG8iQi0rLlNga0m+0lnmiuiv+CREYokSVAAg8yTcxIm0xU2CSR1Nwg/zm1L8/UdZ5YN9NfikFgETIp1TpzdyaEeKtd/btxMre+6r94yEdbs4uORuSPOIuZx5Bb0Qh2YDnDIy12gGczMdZHpz30ia74cyy3+CgB3skHt6pzHjQgvpCtT5gKHxBAdRpUCBYQVnKiOHBMuWnTgJPexjJbhUUgr8p7nXVwFsFRRCCQdJupedjnJ3Is7alJtyCEweLRyhOAMXBeHIoq49Ri4ISJdPjxh9oUBS18qVXeMEX4RYglpMykENsA117h76xr0a9RNyPsTdjvrwwvBAHF/Gf7l8Usuxu0UwRgLPvRt570h3HyDYs1Lf1By1PUYCKYaVTI+Q8mknwvuo7A3CDkNL54OKwXaI84FtSWcMBJfoPBTP7kk7BTXqN3W9WDmJQz+xOLWaCiDi+APmrTgIMlbiyTYbMYUBCork0rTi19CvAo5OxIluZMQ27UdVYNgi8yrijzCHh5O3jF6eLO7PlGudPuD/iipTsEjesfYLjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38350700002)(6506007)(2616005)(86362001)(6512007)(5660300002)(8676002)(2906002)(36756003)(83380400001)(508600001)(52116002)(186003)(66946007)(38100700002)(6486002)(316002)(6666004)(44832011)(66556008)(1076003)(66476007)(6916009)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fuP7ELRK3LbACIfujbTcTaEf2Uxt6omWzOm+6F1ixrPi0i7q0EKM5teJIXpq?=
 =?us-ascii?Q?j5zdvVReb+XQUeEul/FQaLqJhPlqqZJ6RZuOA/afbrx+MqDYbF86WS5R6BEE?=
 =?us-ascii?Q?kfY4OUP0JBB07PKgUhVeAJCN+D/uberWdeJC46xmIAVUqPRdYrur+SXKrBU+?=
 =?us-ascii?Q?buRm5JqWCVJAae6P41qJQaHxBuYtE3M/o69pzyWPdaGr8H1Xp2Yhq2jborVQ?=
 =?us-ascii?Q?mpvsFenoGCoh1JCSwTlSBBFIG+wM4myJmjRsQhRWaYkX1ecK398XghrmKIpw?=
 =?us-ascii?Q?stC7dSjnjT2pU9iJvkK1NW1gijvxE0WRuVGqcjT+7xNoZJ7qk4oGWeEc+LTZ?=
 =?us-ascii?Q?nSs2C5ATsZ8Fd4Reu0UaoTSU4frEEWK2qH0YpkEJicJqM4toC1/g0mTzH88B?=
 =?us-ascii?Q?Qp5/MtPSWG700UgBn8DMBJcpsvsBrbf6bGP7k4UpXUQYHMLRsou1dpbOmL57?=
 =?us-ascii?Q?WUWlPbScJXOabjw1Uj3OVbYLngHeCBBrZWq5ptTCXikhPjQtCTdWsqRiNjED?=
 =?us-ascii?Q?fNh9vTIeePe36KYTfwb9lQrKbErymV6H+bgSbDJSQ2vBes0TMsc1GN9FRWwf?=
 =?us-ascii?Q?PwE7zwTz68/le+VpEIWn3l+P/jmw2Bx2Dj1ZzkYwf4uNd+1mRPrxs53dxze+?=
 =?us-ascii?Q?ujg7LPnXz0zVDORZfiSy5kWIGnNndbgFrZ2wQQv1FQe/l6HLdrtII8HYco2R?=
 =?us-ascii?Q?UqDig/uyaNLx818bPKPt01r+4kMskfaeAZ0Qqmi9kJ7fkq6iFj4ql8vE7uLM?=
 =?us-ascii?Q?/M2w4gLazQcNNyDHgDrZBMnG5qPmmur0aL0YAQTrKg6E5caMfW+kcElsDXxi?=
 =?us-ascii?Q?ykGsEark7ypL3rSx2aTj4gMAI39jk9qB+LKqAif6LQesavWMxueNRzebquJq?=
 =?us-ascii?Q?kVgJ6v7VVYbqjbWQQ82G0CIs/H2CAGEaC24ciIPG1it4iQlCkiYxuMhwr627?=
 =?us-ascii?Q?PJfNAhENi8xh/XCmhoNJKl/nYetquqn8c2mvrf2rYsE4bvIvZk1BTsS8PeaL?=
 =?us-ascii?Q?wiOcgzs+lpwktG9tNHej3x7hPGfotu39aUowkQvZaI+B4wV5b4DF92pmxg4c?=
 =?us-ascii?Q?llrLw7UM7/ILXRinrTlii2FcllUCROElT4NqpEy3WzhunCUacwwrp+/wpJSg?=
 =?us-ascii?Q?mOm1qhQB2Rtf2pLCIzdrLn+6lR8niccWnrkd2Cuio6pkTTMWP1xnuWRvaOCm?=
 =?us-ascii?Q?Ms3xzBaGEqFv9+pILMacJHI7JTrEJJ+/WGZmB3yDSlLQOnRmkTKZIr5bmYlP?=
 =?us-ascii?Q?PnZg0UDwlCG1zfv6GVpEd1IXEn/LdQuOv7wYLiGz7kCNirZlLmPO19NkXezU?=
 =?us-ascii?Q?qzuW8V5pYBwG5V9sZOH4B1mTDJHRay1pS0pVkDbksEf62OKc9RG/IV0geEIB?=
 =?us-ascii?Q?meoKwV+ECMrNzWZhx1I5qSslemIs9wQCnDFTWzQKOWiGlWh33t77x2BeTwqm?=
 =?us-ascii?Q?dKR1AsqGx5dB4B0cjr5/OBQ3pPyMgXbJ6dfCmU42XslL8w+MQsjtWpChzG3m?=
 =?us-ascii?Q?lvjGN2LZ+Vted7nemHoksNKiuiRVw3dbeMZ3szBmIAsIkxznMIwz2AW0k7Eu?=
 =?us-ascii?Q?zjdrx6LF+5tekH2yCrfAf/K8lbJt/hXnReiOv842muHgC7Nrxo1T7ERN4WpE?=
 =?us-ascii?Q?KJcSXYc99jBJhGOByjdTIlmF16ZYLDsQVhHtgbZqCfOCJPmATyhZ683KR5Sc?=
 =?us-ascii?Q?RXSdNg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4b8675-160b-41fc-1700-08d9a980aa28
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:52.6413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gLUoGHoNiznlmGhyWyKZFpUatehPSkOQTXWo5e4rdkB3hs4Ivkhxs0JTMBNQ+9sFZOthnGMYsHJPLZkKtNKn2Ca2kERngy52GSwMU4EVmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: 5MpfiuHRlEOaxRnjgxGxYUp-hywWZVrO
X-Proofpoint-ORIG-GUID: 5MpfiuHRlEOaxRnjgxGxYUp-hywWZVrO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6a04c7e5933d..e49284325d04 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -284,6 +284,65 @@ xfs_attr_sf_addname(
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
@@ -319,57 +378,8 @@ xfs_attr_set_iter(
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
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..aa80f02b4459 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4132,6 +4132,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
 	TP_ARGS(das, ip))
 DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
-- 
2.25.1

