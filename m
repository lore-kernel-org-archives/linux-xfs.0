Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E0AC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbiK2VNt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbiK2VNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB6F2E9D5
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIwPwl022628
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=pHvsBmy9b2wGY6LBu3eMtvMZlQmCbDfIrWj58opP3JAUrdDVSHUYU5fSlfy+rZI5qENV
 Nbj/O+AOX9Fhpy/wrcOjWBJl1uZN+HUxdPNbsEwIC8+aoaV43W4CVnDJkAD7KMo4Py94
 CSLjyve3aHQmjt1ee8UdPGF1c/fVebC+R2SFEDdPAZvbP/UTbMVdgO4ULhFKJ0B5VLCN
 3Ee/rzPkaRBhYdOdliabX9JNBdt194ddISxZjz/RUUwBKZYf6opFMpB9fKJP402zT1m3
 Hs6tWr+Zxvt4PUYNzDbyhYUv2oceUwPcLvuiLqTA7z6wO4/b7id56PpNLkc39+A4vsHQ kg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397fg5gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKlGuV028131
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3987w8v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKwAURW63y3d9owJ0RcLjzhFgiUwvkr6wWSFYYZEGgjs8hX9lFpld9F+xawQvGdI/JwrIfOROpzxfR3Nrrb4SPtSH6VrEmRH7a368M32Swlh4zwOSF4zLVg9jWl9HajtWsvZGFgmQVMxPtrciPBhP3Mfu3AExbu+C5q/qTTKa2nOFfoLVLc+5MAXM3n/DRr8jitn+kWFBVp35iPRV7v2GzLs95JXhn+JD+IANzOPTaHx6RkwjbaaDwb2+RcpVrUj/ov1be972/KKb+XCYXzIgvz1U/hDhKLEh0fo7TjXFsLEMtLNWp8uSmYlMdtxo53OXNfZ24HiTl9P4TOyvHLyvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=SA8knV546VEnXlUO46wM4t1V9ve2B09e8GNu7bG354qVnmTwZxlG7QysgrILN68sHvNMZFoFFFIhzgAvEmbhjdNLNjiwYFR/u7RGGCFGrJLwjjW1GAprAaERdck77OJpO8fMJ7IxUa4t0bI6e/qLYOQj5U72qTpskUKGi6vj3EeCSwVNH19zS9Xqgyc01cAE/3780OpgOFzWDVNKEcN2Flpyg3vShUVC6DO87agzAS7bbKNGjBPj+UYk39USlhyaCU4EBWs117XovctyZqNl66IAyJfnd7VCdgb8FHbsX4UOcr4HbpuvmUtvEXWHkJXnCnSsrvOhu4iLMEZfv7uPXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=hsFVzOI/OKJuM1dDAYvhmem/sRxSZ6F4nvtsNatzRG0EVf2+Sry7umSypjp9aSgA5j9GqODdPms9onLuqjFbYimTI7+RGytdQgHBSgCoph48U1Tyrp0M6qAmAoewK0caQSEOTyIkHOkGg0PCSv8E1WLoXEcuH2qh7ziWQDH/Gdw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:02 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 11/27] xfs: add parent pointer support to attribute code
Date:   Tue, 29 Nov 2022 14:12:26 -0700
Message-Id: <20221129211242.2689855-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0103.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::44) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: d72e9465-d68c-448d-c393-08dad24e802d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUwbuYME9aG85hoV83QsmN5LCpCou6EqxUOvUGQmrMZvzd+1ZvIqh7LOH6Ic5sykqCeGCiIpAuC0vOCQ7HfxfO0cippZ//J2prI772UJKGYEwjDfd/eSVJDz8vcr6mvLiTEZ4FoXL/O5AB+Kycsf3IAg2dGYIRLt1Oj1jfnnzPd/p7YuPmT9bnsQq6fd1n2XUKR3FJjjePNbPBJrJR81VjoWr9q2u6upo/OaJznG0xe+hAi7j+x3ifK+7sHTovR6ME2vdC7VgSddjR2hdSy/QWPU9+Js1geSgSkdl9CuSdyNmXZSMkP5FqD2G3BpMsWzbsPfFa/aiNYNyD9n7vjfZvAkpJUHRJj8bWuzDJnJEuBhDALw2WHQ43Guu+rZtETHkYjp5T6oNhzXMKWPmUX3vQN8dH7QIqUtOFynbW0ATpjgcaPG2z6IsXiy3fX6OJI526QlAY7Rq8OMbh3dnQdNDRYu+lRsPgtuMvvT53Rma4jttb+s7W2JwTk4O6N71bQ08fZP3HAdBuR0ITDdUWBDTbbuo6+sf7Uoh5zjT7E+c9aVRIWkROxlCFd6EGNsW3gcLLJYn9az2Fn9o6mngwB2YMJfLJa5JJmVuOYhM4gAARbft0maWc4Cqot1y3BAHNnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gN2YavGnAwrSrbwXtehHEfe/febpMt/50HDj39Gx2DC+K8tb7CDxHFXYt5DU?=
 =?us-ascii?Q?YIZHtAvkZf0m7UGZo8hf9A4mKwfqpMvlL84ZosDEPJIIJwLtJz58HI7oDlj8?=
 =?us-ascii?Q?fmHSKGJbDoRsybY7z4+13BtjEOeaU9gUTpqHntIj6pyEBnd0I4muDuUzAVcc?=
 =?us-ascii?Q?dLMzSRRZoSDSLUCUy6/4hYyp8JYsMprVRPmjdl38RPZlMKiBqQPhu4ommyFQ?=
 =?us-ascii?Q?QhLbpg77BdJUN0igs1mUJco02kO4QUV29WUFbrIhHImhEa4EMsxppbssfYEC?=
 =?us-ascii?Q?nnRDsvLitR1XuWCbdOepgLC7ZneC6BannnqdNCkRembna+7pj2TY0xnGgNMT?=
 =?us-ascii?Q?CSbdpWaUHtMaRjHYfNw9soEeqrQLPb8JN7Jp0Tg0VAbVNJNl+R98PFVxhvBc?=
 =?us-ascii?Q?e2XmK27IRVHTO4mAfLVxUd+3fIJ2TTozEtCv/NzytJ5qdJ5qEd5bDt0RmUzq?=
 =?us-ascii?Q?E5F6byLfM+bPBGs7DWVWvP9Tt+KujSZqhJtI9zXAwAqYNxMZIOuFiO79V+5f?=
 =?us-ascii?Q?GqX9DgT4zZf+yAUxniQSVd2t+9cVkf+2AZyBfoIS3GpbYHNPNnMZSwV8AfiD?=
 =?us-ascii?Q?W6WU+PT+ZQ6HTEhDGBtQ5QZbhntSSKYu4hwQbfw4+fOdDq8KLb21IrxRXiuR?=
 =?us-ascii?Q?up4pT/I2njCL/cn6UEYS80W9n1EfYIzL6yR2rtMUYsX7npoDp8dJGesAqBw4?=
 =?us-ascii?Q?BX3Q3kh1XR/QAT8V7Ls9YcZbYVqIiYbKKa5PN0EOBXaKBpK7te1Vt54ziT6n?=
 =?us-ascii?Q?Rh2U8wx5oD7RY91j6Ph0Ksgwzvd5hSm7rWj6OdqUJZmGo44CUy8VDeSbIeMX?=
 =?us-ascii?Q?Likvk+e/Vy68jGFyou4TmjBcygKK7HUMn2/5WKiqyAZWRa/7D/h+MV3Fgnxi?=
 =?us-ascii?Q?+iHwDUpTtf9N8oqiUXOEWljQuIseGd3+trtYmM4kYj8AAGi5sdQgoE5XLMK1?=
 =?us-ascii?Q?JgqgKUCSd3ybSJ9MzkwwsmityrmP7h5XGf1JIWF6HofUmCl5c3fPNqugJDaY?=
 =?us-ascii?Q?pXHwLfatpyi/sqaiEaIlLkMJAGqNFvbdXsPKSbOBQmkVUFFhjiSYXbi8GYzC?=
 =?us-ascii?Q?UsQHLKALj/377UL5AF/ov21oRejFjrMqXODki70fJnAJKDJclByRkTXDVkOe?=
 =?us-ascii?Q?Q+vPJscI8aXWFr/78iYzMWDP+baC0nYsD/UnqsH+edFrxQE5odmkVSX6y9HR?=
 =?us-ascii?Q?SpzxVr45ej86VI0MSvjc5lGKJPkgtPT4GfmaTqesvbZPczyXKl1FVXeXQ9en?=
 =?us-ascii?Q?HqEZ8cd0PhZ3P3tm7JV59MaA7oa8nEPH+pXYetlCh/K6V+60fDdDg3xfLtHb?=
 =?us-ascii?Q?U1qX0zzpmhSFoiW6mLyH+s6OJPXjrTTL9LkKQahbzL7sZLo2NVxlffw7Rl0w?=
 =?us-ascii?Q?ifn67F8hF4Qlddj+JX7sqdyMB1HNtnFkJOU19d/+qYDd7GM9IV7U7RU85XsI?=
 =?us-ascii?Q?khMjllxTV3Mvzzxsrqud/WBf74Z7yDL4tqJxTdJ6O0r35IWcC4d7ErAqlIt5?=
 =?us-ascii?Q?lTMQmM6ehqjU0wBgvboG4Mkn3nQhXa2oo9fHyEVVtyu3MZixlWOHHoZI6+Hv?=
 =?us-ascii?Q?b/wLQfnXQbEgxRCatlP2axowWFl1xzydEjQsOq/PLw7mtj4nZJMdUagdmtP4?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NIgNAjjeXUGuM+82Ipw81XYy2flMvCDH++d2Hc+h0WzGvwOQ+cDbQ8wxSB1JyyYZaiw1HlRc+izDhICkz9Hkq5mhY0JQptHkULX0+Ov8MXPVpLREqksXWi7/M6x31LdTUy5GVndGfqS7n7uni9HtxSHnT8fhSfZWjH8EzwptPd2o6XWPHEgia7nze3jOKiTPkY++lav/B+Cnbq8gaMjMht/Tr/Wt8OhDzPMQ3gzVciYFLqKYMh+HRGlOxVBgaflqKmzliqI709liqRzMLWZUyuXQj9kns5/kkA72FqHi0EPQNOHOeUq+KdzUEZi5O0unMjcev0eF7EV98EDcgJloUXSAbA83HO/de7h6dcDMD5NPjTL2ctLFz9eD++ecDO1eNeUseZmiK/B1LpqVWmM9iZYfGycP1cJo1BmodGPh8YYo7NsjclKhZgujKCBGgXgsChswI3j+gYO5y+vHZr7dMZSKFHHrhDvl6zsLN5tNwJUyx8IusdLXA2xLEY/gFM3MSZhGvaEdeBPOHyJrP1ij7sYP656lZJRZcBEN3CLWYFr3t8c2bsqfqZAuTzO8x8+KTtztymBzCnPTXOQFk17sQ4+gyIf5b4JlnNlMhl+wGwiG45Bagg5zhvlsuXKN9Zbpe4+5Lj2ZcvXlVSYVrYAlE9u6vEPkzDDCyIkoL/X30C4pvjLy1YnXfwL/G00g+X7fq4wZfOft+yBL8Q+RyLQ7VEJD5rcXczVLJ17FqTjJLEmSUFU9eiZljEZTZZVhhnmq8zN+U8NCPOf53OPKj9tO8Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72e9465-d68c-448d-c393-08dad24e802d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:02.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHQjwLNO2WjjscNOKwGTyM1QVP8X5Acf4O3aiI2pPG76N15i01OyNMmqiUBLuchAneYY+yuyJP3vaZyYGeO9Ncf0W2M+DfjBbI3l1UDaa4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: uJz9KpQVUpat-FUdmXL40qPVeEFDaIG8
X-Proofpoint-GUID: uJz9KpQVUpat-FUdmXL40qPVeEFDaIG8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b1dbed7655e8..101823772bf9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -976,11 +976,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..3dc03968bba6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index ae9c99762a24..727b5a858028 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -967,6 +967,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
-- 
2.25.1

