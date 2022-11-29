Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242BBC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbiK2VOL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiK2VNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809A723BE9
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIa4fV017353
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=iBWgTidIg243fVrCpW4A4ODifWUh8GXxnsTSYeGREiE=;
 b=jR6tL4tA+fbW3pm384H3vsitVHLHmIBAN7/J24rm1PdptDAWaDHIr3xzVpGiPNAU5d3C
 CFlydUQO0lPv1GYlKKGWzhYctfL++97jodybRGXg58N5kaAgNvp88EvdOX8MVpQsuEv2
 unwSF8gfDMh34RtNyftjhqj0XYtkpId2Zinl9YTlUqx7jAmW60CQPQ63RUO+ErFzGz1W
 VWWVqUfq8C9ebyXJPpWhOowpiQ4YKHM3UXjq3E8S4GjClEPq61GCy1167E5TrUk7yquX
 5wyrGH7FOTpfwoWpFDlACf03Ctbg6jTs+sIy6efo1JsPJz6Q5fTH7lH2I+QHe+m6Q8xL mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xht7c88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATJs8dc019327
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398e6hwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqdA6q8prlVemtQ9u0xGH5dEkfZ06/PdR0l2vm2O7GGboVNhe9bjLRKNlc8NDoWE3eLIT09BOsFbwsfbEaLpeA3dHujjcP/9dM6mVfM7YI36/ZeFyRw5CE4gRgVcuqdfDeTl/VIxct3KeeWhG7FTi1n18x/+jq7e0NoPBOb7KB8tdP4EGuAzlAaq/QOePHYbsdwR+P+H8FNJwUGnton/H/Sb9oerUACgJ33jnBlxlJhRM+onzzE7Bqtn7mZIz7q79QOnqhEPY9X+LH7m2M01MsB1dfa4OFRrBbyv67qX9xtK8tpWQlJvz03Zd3NRq+WdIC7mumTLHmckxQ66zcu2BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBWgTidIg243fVrCpW4A4ODifWUh8GXxnsTSYeGREiE=;
 b=GdxIpgg/+BZ5uYXFSoJbfNb8rgV8Lav7wQOjY9R9h25J+qrd2W/kM2QDHpOzKMaG83aHkiytmdBIsXXt7My1ptjJwdORwVuE42ALq9PXV+S4Z9nKzex2twFTsTyQsmtiteY5UzE9zartd2vFKABtYvSICrseajg9QiBTSc9V9DjQz6sHl0TAO2IKuND4pPTcn9wj8Q/pbFhdvdirRb8Hz0XmHxx/499/DmqlRuLLV1vixnfyzGiBpXDXusYL27FXhMBc14FOxuUnEh3PQ5Yf1h7ccdOORIAtgm3jx8H3CxpEP99xqnHE5CLcWhtVscsVcoHq4AdDg5gxAMy3d4aIhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBWgTidIg243fVrCpW4A4ODifWUh8GXxnsTSYeGREiE=;
 b=jLPaeXyFW6gnGYUhi7vLMUGFXU+zglUCxyN6yJf9WclQUuzjhT9JrpwcACYEXMD7zdj5PV4sHJ6P6+OoQ9Knur5Kk79QbDUEdfBeuXM9+Di6zJDlrkzpmvirdnhNWhwKZYkZQFKQ3iw0fRV/RI6Npm7saTlMyb/FP2VZ/MR4ZOE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:13:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:20 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 23/27] xfs: Add helper function xfs_attr_list_context_init
Date:   Tue, 29 Nov 2022 14:12:38 -0700
Message-Id: <20221129211242.2689855-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0279.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 46dcc2b5-82e0-47f9-ca44-08dad24e8ad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EYUus++Q1xMvdSeItkVKMWdSUrx/sEJO25tlfx/oDjFQBTVgYyOEDSVlTNlNxErcO1MRnQbxKJglx42JQfNF1peGzwm72PIEBcWUSt2NOt639YCccYtyIjAPzWhHhGw4sv9jmgd468FJhdX0FXeCIv8t5a+kIUZuiNVxbhZl9i3GSRcnoFUgj1EK6BchxjyOfnLFDU5xNMhnEDYU6ESozZkiAaPf/yiZ1Xa/USYVLOJgiEOdPT5phlLnrFr9RLqGRoPtnQYiudLAJkSM1ESROjUfaQCZIJJXgoMXRG6SONDtI5385RxAKuiB1ML5Hj7yxhyHWPVUlBvN7wRO8RDpgj9hRS/KiVX4LSAle1UNxWu7A59ZoXi1JRPfu8HrrZ4KPQNFNUuCZOW62AsV3hgvnHzLzOQ5YjnrU83BVZNqfNFnbt8n0zG2Z5P1yP+IFttDTLeo3j08V4a1iPnpMkx8CBvWPmhqhCk6qlJD8x4awiJ87+B30lZiLstM+/jVRj+JQ864WPMCbHFTqfxxGtzN/HkHBUf14iwLZ/Q23VBQMbkVBfU897YNZqrWWfcz8bCYW//nEYL2H/os/HrsLMHaMuKV8S9a0JYdRWotuxydZ9zrbbiLGgVO/71QpoJnYLU4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w4GJSMN2klGiy3zavhE1IquIbf4Qsau/VO9/Ayjkd4+oD/E5+XkQajqPoakr?=
 =?us-ascii?Q?EzIu9YINNzaNOd4yeR+0jpMUKhO4bHtcjJTRbi5XcIuMobhXHZpG/d6ZrAM6?=
 =?us-ascii?Q?KajBxOfRlGP66G5P3StMz0Yn1PLbPw4udFV6yi9P6lOZaxQbb2vKH1+PVQtO?=
 =?us-ascii?Q?nNVXnALHP1EZ6GvBuePVulV+oJ4KhCGAKUS2xM5844llz1BL266RHRMVDWu/?=
 =?us-ascii?Q?TINLg21HffUFrHxEPDaM7HsZ9Fzb59AcZ8CRuOYIIsBESLDE75I4bxTPMrhT?=
 =?us-ascii?Q?PdE1Guhl5v9yoUWtM+CTQxFuAzU2inVOUeAWx2xkS3a1ND5/UeK0AB+yvTdT?=
 =?us-ascii?Q?L2H00LrlE6Svlg8EfYj1Jbb8MrrtVgGXUHq2xRzAv5i+yIUxhfNfDJDLfk9U?=
 =?us-ascii?Q?xvG0OsqdtByRFwYoK8OO9vAgAo9BU6T/1miHkOrkvTGxKM0Mbpp0Jl3wbbC6?=
 =?us-ascii?Q?RZaRsLff/4hiNE/pkV+Qv/r43yvcnbo8dqJyIuAtUxgUazlg+A5S7tOHOMBU?=
 =?us-ascii?Q?Shf59crWB/7AD4Kr2s1SdI3QRV2+9uQk50c2gwnkb10SBGsA5V3q9PT+0wiN?=
 =?us-ascii?Q?o5zoWAJS/27/RpO1lW+8k5uxfQg0rzig1iQYYF5uJaG/UWFFuflAAPIVgLM/?=
 =?us-ascii?Q?3nEuJuEiXwy/AFKUFPR8BTgc3g+kShdKRyfTJYelIa3Lw2DxBX+RRBs+/0Wh?=
 =?us-ascii?Q?FzD7aYmW5VHXmdmTq7IWLcsvEzc8qcVGjmmor7C99JuBpL/M5xp/ATXo0q2T?=
 =?us-ascii?Q?HmqgAyBRnyypEjo34XAVG0vGTgNFFUuzfHVOzc4sviZ/o6u0TbudXzvedzM7?=
 =?us-ascii?Q?7C3mCrIgaHI++uPnBK/WoLzijRNw2Vvv4K5NLQW0SDuEuRqAJjr2GF1Si9Ya?=
 =?us-ascii?Q?LvZhxubxmIpW01Ldf2M9nzlN/Eqyht61xocqel5O08zN9dJOK+d4GLPfMxNP?=
 =?us-ascii?Q?9Yvah5Kp48B/dfv8JD8WKHBcvLkrBwy/4A+UoJP0xTyFFx1fJoZJa5pLK2gO?=
 =?us-ascii?Q?Pc0+BTX+tZlryk8Jie3Wh4hqkZBQu81ctJox7dhhYRQ06dR1i9ePLSUY4Kxp?=
 =?us-ascii?Q?Ugd4XKNfTSa9FtqvC8u16ienkCGhnkuxNxpAoFnHIlc8H/0HFTcS9ihgrOOD?=
 =?us-ascii?Q?CxMMvfwDk3p2LDF3oN5dhppML4fQJW763PlcEMSuYA3xZVpQdQNS6+ttP195?=
 =?us-ascii?Q?Fd6xt734rFCxmiH99IL12jf23VB/k5UOZn2+BUyHuvlCbWee3BpXUCMeaIIT?=
 =?us-ascii?Q?ZrH9wN276f+I4TgPOeoaxNjVLhytsxH+w8aynz02O7jjjI0IdrjTjRZAwzwV?=
 =?us-ascii?Q?6bqAhtjFdDl2UtIsGzU9sJ63/+YwR1kEHNTtNDZ2gHVT/PIqVOzIZUFqcN8q?=
 =?us-ascii?Q?87a7STQO7pvNtMGPlwjysKxZ0zFSovXpiYprMnSsm55aa8XA8K39K6Er3UpA?=
 =?us-ascii?Q?Hpxja6CEeeaZjPYNJJbWHllfqy7pGd+s4n6rqYD4dcIg+3o2FG3k1Rs0gbKh?=
 =?us-ascii?Q?zu+6LN0sK3C+G1YL/vAR6RoAJ3tWvX48qoIp+7VAGObER9k795NRNfmsETa9?=
 =?us-ascii?Q?eZBj4D2twTS35wuEMmvfryOZkTxOiDazXFulf3pVH/dyZhdx7alRfBOlqT2P?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: p0G8MU8cT4rz0PcW97ARHWcMfzitwAdzcqs2bB+cTNXfMAlL7CLBRgxu/05mCeRLmv2mr4n7cTWaSETqHeESDegLXPLCu/MuyuekrZyS8fDaWLz5wy8HjnIuxHI0mLgOpzuv0gEWxObJQzpg94Rd+mLs1hX48LbZc3KP21xZsEMbPXdTYLzQinhO83e1aZz72MpEaypTxSna7POloQj+5usEhvVBpqpqa/nLDbzJE/YIitI7ZiDQ1ZVEW/f3I45x0tPrlaFaC0DZJSRKqasremshBhKohoE+kELrEUdRU4jBBkxEKCXOaWVKhcbHQ38utvrm2McNfsYpVTOsxQTGe4lQziDtN0TwR6MygD1QMfqLNNd0gPn6t5zISh3N4SwcStMmADEH1S1ShodI9zUougrpky+2xKpFUELJyGLuO3+vEb+/trus15S7Q/ekUPOQXkg68xoLeqKTM7ZmMSsyIfUQaJ5ylxjX095zYqC5etThs+QuVZm8ESJETEapUzZGPfnKv7SVfYHxvF+0GcNrxWT3VDwKIRztl6uwkIw1tAo2rjgzZAtYqo9Ag74C6kUubTbcZh884KLwN/mR0/G5VCdJ7k9npEhVjX5LHvHYAyqdGM+ozhvvdgHKxUfsaZZsrUoLQdoVg2JUzJ0eenZkkAL648WazgRoyz9luIcAbHhbQFP59RSdDVUbT1wLZIz2FbLQFjqCJCtaKItCly7E9SJH7hAJkYSASrhV1KvPiYaAYojzmi/6WtzNxc1Pzip4bOB14IipMObniMDDoyVqMA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46dcc2b5-82e0-47f9-ca44-08dad24e8ad1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:20.5726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /RISTHX6A2p9t4vqkyr3bmyE0VjwQiWwHOoymaa4eUhRwM4MT/wGuoOGD+1vLQg1L85QD0Jz156G9tdJH+1fwt7yScZSi7oLXgxK6tmRvbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: 3lY7ZGIW6YmPB9kXaUNFup8X7aKhxHP1
X-Proofpoint-ORIG-GUID: 3lY7ZGIW6YmPB9kXaUNFup8X7aKhxHP1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e462d39c840e..242165580e68 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..5b600d3f7981 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

