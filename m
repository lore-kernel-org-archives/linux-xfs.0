Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2C9C4743F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8CB16120F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhFGF3y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 01:29:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56690 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGF3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 01:29:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575PK10165338
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9oy4iuErDo/7ws3+56O+cjNmEjSSIJdXWWmfsVT2OPM=;
 b=S3Pc+CDAdsPTOMe0TZgOVQqWlqduPRnPOxFuYy6EPjzsI54OwuZ6jRCGeBZ/EOlUB953
 fABPIlbLGPnjlXh+qTBQYyBV2JQ+ZmMSN5oAMF5TXhkmt4vGk0bdaf8OgDB/TklFrU9c
 oDbQNC66h4j3A5a69e/VkwYSnOg9zTBWcX0JjsFGHCiS9J7IFWoplgQqWWNQseiyzBmT
 dL7rFJXpTaNCWrMApPkn7UPzz6ffyIyWmBlWKN68QK7RAT9wmMlpivriPmc8YQh1IZGQ
 T2ewmFX0vaodeShEr387rhyjmuQSk70mkgtiIVILeLD4LAtgKBruWEWNiYeG9DJ56qJ7 Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3900ps1ttv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575PmCk178624
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:02 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3906snnq3j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrLXjA3/+cus5wWg8RczVEuLFcsuhp9TM5xtQYU18cYdTIeAi1zeZO0xccBtpnKNgnhGHkE5XdJcYo2OI1nA2lnS5aBK3IsEbjbEkmyaxgZx2UDuL8lLL5DgHb1+dG9WXSVlJeAdzqeDgpTK1gYM/R0J2Re5sz901F6nxXeUwOf6OzrR2ROaULgu8WSgbqoqV2pKHgVE39cD3pLpCONXvwLNMjhJ+KDZHy2HBYPZ+fLYPbHbYpHrjPbZRSlosfWSbyi1bvvVKw/JJX85SHaAjrvw5yN7fW/2tmk9neoZN0/tf66FjRxfimFXL6VqWYXqDDG7+G7gTcIEjVTP+DYVTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oy4iuErDo/7ws3+56O+cjNmEjSSIJdXWWmfsVT2OPM=;
 b=R1yAUs6WDKWE8GzBXjV1pAKmRXqQS40hXRmtuobvnSBooP9etRgBF3HrIIK6bhpUNSDjKBAAwWhSg5AFT4llqxVPYqJYdMDiStguhi3Q2U4IkxU/N+2lR7qdoIY0V9+Mt1OJArktyTd7N82tyb6ltX9zWolLRelhD02qeahz8DefanmPGbTbC7jGvi8Y332L9eKgqNJ/RXGx7PWyrzvETaiTgKLrPDAhYrrjVITzxdzW/MbZSYexaJzNeIL3du+hGf/fxfZmjZ+90XgoW2/prWsZlMIsl+WV7t5QPvkY7rvKFt+TpX/IZ0dfXFHHOySuEW6i10MOgxudr5Jb0xT09Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oy4iuErDo/7ws3+56O+cjNmEjSSIJdXWWmfsVT2OPM=;
 b=UK2bPiyn3YvTcA4eVfD8WGtHQH2Q6RqnwcDCZiQvW/a/L/zqMgPPbXLaDq6/eXuxIQJ4EvgHSTtFRX5JHzx6d68HAgXKlLwsjd8zoWuzlb4/w/aGWNREvOg6HUQMGQN4HnkC74plE7pKwjuEakLofQJ5v6ZELHtKr4WnHXFSrTA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4687.namprd10.prod.outlook.com (2603:10b6:a03:2d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 05:27:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 05:27:59 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 12/14] xfs: Clean up xfs_attr_node_addname_clear_incomplete
Date:   Sun,  6 Jun 2021 22:27:45 -0700
Message-Id: <20210607052747.31422-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210607052747.31422-1-allison.henderson@oracle.com>
References: <20210607052747.31422-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:a03:100::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR08CA0019.namprd08.prod.outlook.com (2603:10b6:a03:100::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Mon, 7 Jun 2021 05:27:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 040a602a-4f97-46e3-930a-08d929750368
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4687:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4687BC5D52E3391B02ACFF3B95389@SJ0PR10MB4687.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SzoSBUZzuVQVjJZCtUFSkLEQxa0f2/HyOwwIRl+rbfUge5/lCNdxzk9+aM+Y0sfFptnF5PvPezZa434s4jLqf2tKMgifweyPUvBvk8/R6mCsSNcfPyc/I6r0tZpKYjXdVk3sykAS+YpM9JCbPEQ2OWlu5d9b10TAjI+AckZ3JEhwULOo/EqytAdi50R/qrsXSG3Pb95mtjKKVrnxQxtMS0oj/+zOLH2uUUy7S+3QSIHGQE+HH6NPyvPz7k2WQI4oScuX5yzFvsvtvzKk1KwMwt/SHvb2BpJGjtmvzjuTEt/CFYXJq3hSU9CusW8UJnuCUgBpRCiKDZhd5HkxPVGPdEr352SD1Lq1AsoC/5bXRKT6qGH6EsGzH2kQjDlZwc3/VerCxrwoee3W44cpP+LuxC/PCWaZvucGEPUp5NnmKiNTXgciHi0v5gvRCySMTl+ka3DgQq6OpAAVdYr2a4a3mZ1ER2fjH5FBPAH1Dkg6RpgL9OKF0Qrm0ysBgNYhe6SF/6V9ZtRZ+j350X8+DFSXnse0e+el/n/GqBEjYjbz1aJQqQErz00iX4juk/ZclLaeXAys03T1kAFHEKO7CMXnhvOMcMtGDHgyhSMms30JJjoJ7mvWaJJaAMOrBQC1IVODcqW79EpVXEJAzLNRStRGJgqmeyq54kB525lzvUwURuiEjWQ63oVBQW5+dXMJ+dGt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(396003)(366004)(186003)(16526019)(1076003)(316002)(6512007)(6666004)(8676002)(8936002)(38350700002)(6486002)(26005)(83380400001)(44832011)(66476007)(66556008)(66946007)(36756003)(86362001)(5660300002)(956004)(52116002)(478600001)(38100700002)(6916009)(2616005)(2906002)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ydMvzu+qsVA7ExcCX88+BOV+iO2YJrbinD2zfm2MFO5vQ30+ICYCsURT1TWT?=
 =?us-ascii?Q?yrC4uynhNk3al0zKDY2lbHL5LiHFIBfO0hZ+AJuzSD99XWZx20llNypsmNmM?=
 =?us-ascii?Q?TqncreLZRoYjAbZCEYv+HEIwwxdV71V3GND4a5YFsQSwaj3F/gpLws/9SVjc?=
 =?us-ascii?Q?79fssHLWS3Q3uHTk3oP/rDRlVp+OdWHfhA2YdcTJE9CXdlGQJrVrlLe44Ef5?=
 =?us-ascii?Q?foI1SgcuMoIJ62rezwfiVNYE7gpAIM+S3ocFTbEoeou0wye5ckq5Wx4tX0T/?=
 =?us-ascii?Q?tge927Rsi+3on3ZdCDXgJVW5ipRf0TIlKlkURq/C7DcITJkQ+2VGdEMJXxqW?=
 =?us-ascii?Q?KJt3XJxJfAMkgWWQOooZ14vxJMzfdKxUiiv1b/NqCT9/W+ICp1h7HUE6Pg11?=
 =?us-ascii?Q?bx1ky1J/sajQSb67h3XgF+XjqvrD5pGBymhX8Qdoxg56QMfevBay2lW/tMFU?=
 =?us-ascii?Q?ESKYSrc8zGTBoWJRfiFoYHs+sJm2HKNps4QLrFx4h5rpoklakoRTNcgFQkju?=
 =?us-ascii?Q?7FQ7QClCP/ewkK3oxzIsWBzSF41+Cj/96XmKHB6gRDVnHCyyv6lPIp5dOL6f?=
 =?us-ascii?Q?y9IEtpH0FhC3vOMYTbdW7p8VSYPnlphz7M3EekierwVorsYDmBLI9O/QJKYM?=
 =?us-ascii?Q?s4yqFQ7OH/VJmAUpZyKzjy7NrsA06vhCOKcIdavjYfnhPaI99OKgqe0y/uRa?=
 =?us-ascii?Q?dA1tBQpg56R0/aSY57o6xHtE+U1SiK/ANKAsp2Exc8hNEr+Is4+YkXwQ+iN5?=
 =?us-ascii?Q?Ues4+NauSSIgT9ew+iGnQy9SL53LCZ8ecEQmpdD6IIf5b8lg2xgSuRJ4ySgb?=
 =?us-ascii?Q?gwP53+CA8ieotHyQi7I+lTLLMU9fSQsBcHtittjaT6h67hIhEw485dggmC8R?=
 =?us-ascii?Q?owQKgZ6MJ3luJHIwPO4RTnpzkLTYQ0Jpl+ytW0YmV4qZUASQVbiizf1q1Owr?=
 =?us-ascii?Q?j2E2s7LbVkoHwK1TLcAMgFqL/fTWcfVRiFWZOLijZ27pdBWe0AyfLEndWV33?=
 =?us-ascii?Q?f4PRuR0mWhXMavxsWfYY/OY/d3kxrjmmJrkGjU5ifWC5ILa5obyftMim3mk1?=
 =?us-ascii?Q?guQAz1d9TPWcmWMdsLsNVk1gu0EZb0+bDm8+rgaIapQerhH+6EOIVQYmBJ+M?=
 =?us-ascii?Q?vbLQraKjcnMIoIb1p/SyxS5OpOCmCl55tJJ12P3c8qHBxiQtkQmYgZQ3UL6l?=
 =?us-ascii?Q?hH2gJFJfwlcXTCNxDECPurBSzyqPhRZITzOxJ+GpmdjlLDTvgdTf4o3peWgZ?=
 =?us-ascii?Q?M0PeJqBU7WfihylLKHXfn10cTm3KkaCqatiEgmsWIyqrrEo/dZNpaN2qGN35?=
 =?us-ascii?Q?S1gB7qMph/0vI5BTtXXQTJ7V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040a602a-4f97-46e3-930a-08d929750368
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 05:27:59.5838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKg6E5JPrtPyJYGUJWgAG1W1G/fzphLU5AlIDxM0rSqVr2o7z06QlN6CpEGqRHjAFHNaqofD7sQ6Z9YEwO6cjxxpgF3IcCgebJqu9UxRbg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4687
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
X-Proofpoint-GUID: jssUNFz6-mp7rGCzgu4xYoWdqNbuuZx3
X-Proofpoint-ORIG-GUID: jssUNFz6-mp7rGCzgu4xYoWdqNbuuZx3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can use the helper function xfs_attr_node_remove_name to reduce
duplicate code in this function

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index df20537..2387a41 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -63,6 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
+STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
+				     struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -1207,7 +1209,6 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
-	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1222,13 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[state->path.active-1];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	error = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	error = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

