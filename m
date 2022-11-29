Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD137C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiK2VOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbiK2VNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F162D740
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATIiRcC005604
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=NxhGYX/mfpkUJTmx5z6UcIMMEwSYzkNYvmjOus9d3dQ=;
 b=xvZ/uhhz8fV6IQeHLmdM4cdYiq8lFgBmDZ9oolyRk9vtftrU0HFS3h1AFFeDniBtwoci
 s3hqDBqtMgyyW1QybYshuaDZPq9s0ET1Z/mv55q7tQqitryOG6VXaVmCcNJUpbZc3M5F
 TLOg9/W9KlDzFVAmWMuWO7gC7qTYVpOJCFXUXjgKPc4ddoNqPt/7tCqEVcJmQUphHicz
 nbII2CtlhxqlCpm7QEJH761CPYfXspFKzN2fqi5Z/gkBcC3gsUHLzceyKbqyGxZiG28K
 1LSACo3nPRsnF4AuhxL/0KYO3qjHO0ILEQEPI9BTC7oo1noaXw3yuUlGLzymNgMU0YvT CQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2r9fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKUnBX027897
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m4a2hj1g8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQCABYdGhaSYFU/PU1WSHwKETgXUIIXn2/yexRFiXbkhdlbvUzsC5xnWPNMa0ouUk1epDYs0vvXBE96zQG+6JH+dUuKYTGW708ZZ1ihJRQ8lqLYyrJ0FbaAJUFw6Eg9hABizAcnf1Y2sEehbvfE6yMvoovVdIF45ozYSykxPAZpAUXVHtHGJY9hfv6zoKBkeGHquLG8Qr9xfJjAMGyKiavHpg+ZCq6b5S8UQsnjV00+uGVadMRe93HBnC3qOCg+lRTHvyAv0d9KAebW9M3ifZuAsUApkKJTCu7sPALP/blmuoEjvj0oVbUgDp8b/XeCKjIR9rJkrastSACxWVvaJNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxhGYX/mfpkUJTmx5z6UcIMMEwSYzkNYvmjOus9d3dQ=;
 b=GEn95CoVA9M+DpGEmtO8ZbjlP63F03XOhOZ2kBzmwalE06DGVA612HM6vU5rH4oz5G1XFuVA3h431hIVrwvOyf2DHpNdJIlZ2WcdIXny3TxwidqG19JPK6GCmpxgS24K8CV/zf7mX2ri3uzxymAA6f5MbMspYGJQkHf/3k16JkAtgtu0CV2LcDgXjXhNxMMwr1ZiF64Lfvj0InkYhCFaYZ3yti1NpE2aohKiYFLUzeq2WGVG7hXugNdPR5b5Ivm4LdLaP6KWJg/g+u+0bzHvlN5vUPhFOXH19BsQkA14i2GrHMMCXisNJErFQhx+ayr1GYNhjY+X6v+Oa6K8A1JVEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxhGYX/mfpkUJTmx5z6UcIMMEwSYzkNYvmjOus9d3dQ=;
 b=EUs1wjhREoZ9G4qfGxCPSTuWIcWP90Yn8pXd7dFJfTP7uc6h+tW3fb1Xk2kJ+5vddIz6YCEGhrmAcTO9osnp43IfYeLrp+pASgCoUF7gemdF+zCrejd6rbzZYopo7Edbodx4e+Oj52HzfoQTAGY0cIgtGeqTBrQet1bCXqdMCsM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:13:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:08 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 15/27] xfs: parent pointer attribute creation
Date:   Tue, 29 Nov 2022 14:12:30 -0700
Message-Id: <20221129211242.2689855-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 60137e25-ad34-4ccb-51ec-08dad24e83c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8j6w62FqEo75ESqFWctKbLIyTf0p47wuhpLgEdGkQO4MZOsnDZPgMZ9HyuznImU65lMFWAm/Wp29q5mCdapLW53hQQTGJxgEiGqRE5sSL0I4flsc/vTk/avhKuDMrpyDA4YLufyPVIsc1EE5B77Kc9nzPglC8yAvK+ePdsTRshHv2FB8QqckrJGOAXZe7IBEd+gsWD3ETgiHXohlg7ra2VI6kP5HoJf3SeDnIAOtz2RNR6HKWcyqFTt9Et6kbSPoTtC2EFVyCY8ADXje+t/YlH4K2Xclbp3OiErlVo7v2FqiTX0ErexQXxaPo+UwOlcScSjNadsNvXmMghnaPQw+bV8TwAZU24SYpvCv2UvCs6jqfMaK0niy+JYwQbB8Wqtask8Bw7cMfXUeNzyFx+V6HFxrDVKGWNJIGpnFb1tskiPDqqcF2iuUe3djrmHImeStXNj1X7TxerQGTDCoVoK/GeagMU0DEnCijzjet3tRGyowtoDWpSPyWyBSJFAMD63KrIj9ViBvq8l8GOtWAB8Ta1LWbO8qKy2i1MqrDWDraD06jHQjhy0nwADb5yYCetKVk3H1/3Emr5gczekuqsW5QPxGCvoq66gp4QowNCiGvT26D1KjhGlx1LwxcIM6M9ci
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(8676002)(2906002)(36756003)(86362001)(66556008)(30864003)(5660300002)(41300700001)(8936002)(6506007)(66476007)(6666004)(83380400001)(6512007)(26005)(1076003)(9686003)(186003)(2616005)(316002)(6916009)(66946007)(6486002)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kam6OYNNN4AuypeJ5FseN8Fx2530dJERsaVcWs6F040LpTZVuDaR6N2mXKkQ?=
 =?us-ascii?Q?sq3pUy8GHVZHdVXLVP89Zqz4tCxtzK1D4dCW3gZwL69WzpV6E4ZMNwuDrnqh?=
 =?us-ascii?Q?f4QhOg0Z3ndxG55hYiBmz7Tlzhw+0wTJRLsuZp/K64dhvqLeLMjTPvM+ue+5?=
 =?us-ascii?Q?Ry/AmDgoJwrqgbxdZjME5sw+tTmYomcDafyNQfQ4brNZ4ydgcB4LJ5DNYMqu?=
 =?us-ascii?Q?/WoUCybR4B/MQygNlFNKOQ1jx/mar5AiCYpFd0BI8qYHpledoE5eK9y247aR?=
 =?us-ascii?Q?AonHyn4nNWiMkX9+6tj0e9/1Zv0zdvfLBSLCLHWNl4VGyn5RJUHxv2UMU1xT?=
 =?us-ascii?Q?USdHjHU29+dQ3cxXslaQKH46JfYeG9EmZBF3a7jB4JlYSsMlS3S9yHgBSpjQ?=
 =?us-ascii?Q?zxd8yItknbuPqoznnuy77OhjdLiVCUf9DnhKizRWvDVRGy/0yOjqhqVpn1JA?=
 =?us-ascii?Q?QurvGNJ/PU2XDPIvWxtQuOqQ/xCF3e8uEiTiEIvyvN/H3MKRo/jKXKkNez5W?=
 =?us-ascii?Q?dSAE5DX6x06Qdt9lwFDJywkvD2XE5dP/4Vt6qUW773NvHGPWPuBOFtYqgiIF?=
 =?us-ascii?Q?BRIKGlzY7Bc9MBusulxKE1iRX/skZvx/MxwDFd5NapHjcxLzCJ2u0RiDferK?=
 =?us-ascii?Q?H2BFevtWP6w3u5ED1GVBh/8gLwbktvfjrhwEB49MtuISngzD5yrf6uInoXQq?=
 =?us-ascii?Q?gXEknwzmh6iG4W3s8U8G1/PyX6cq4hQYQ9dKnW9GlkzwrleJ/jHhKf6LkQ8w?=
 =?us-ascii?Q?wmHHqNBMR0hVE38XKC475e45UtenTkV9FQ1mxtkvcpMwwqyisrb9PWgMWqiv?=
 =?us-ascii?Q?XdrxtfZaETyZPslWY59zHmZZfdy6gONpjaVXQ1doZB7rlesmxZ8flkeZBIuW?=
 =?us-ascii?Q?KAcgcBdUgWElhXD1lDgsXISMfIXiJBI1t+nq+8CmSqgJRor9LJsvzxWCVU2c?=
 =?us-ascii?Q?01ovTIDojRSnCoNUr1vlTi7eb3VhtetVdGAjfEEnbWnWaAGgxPQGK4iI9B6Y?=
 =?us-ascii?Q?PibKLckvK02Tn/6b5p6rpSxNk+9n8rIZrXcMsbt/6UYNnaotauVBECVWWdhC?=
 =?us-ascii?Q?zlnw18iR6SkSAtlVCe5s0CwAHkS6XoXP6w9WQfpF7N1gTTN022tExPKqyFtC?=
 =?us-ascii?Q?Nugh60AvrMQMw3Ohc5EphglZL66t6XrZKMenqrrzxIVEbEgLg1OQ3D5kB9CE?=
 =?us-ascii?Q?ovH3yMRegh4AehlTu7exjcWbuHWHZZjOb/wBFgCLE6xXguTunGJkOJ9GwKwr?=
 =?us-ascii?Q?TrzKR9j/01g2CzRaqhccO6zmbl/UmBK/0gtOXlbn4lMEPS6VF7UmN3B9d+ru?=
 =?us-ascii?Q?PocaSeOBZL6tjyskCGT0P7QG8Xf5kqnZkNST2jildL8gPwHZJIAq5VUQQXAL?=
 =?us-ascii?Q?VEePamZyHHv+LSTqGIDV7BNYoO/pS/ZfmrQBltD702guhE2z0xtQ+rEIrmyw?=
 =?us-ascii?Q?0f7kqlHf4F8lxpbRJWHAdSDAZG8PeNxYi9fQb90wih/8S5R+BNh3itgWuO3i?=
 =?us-ascii?Q?V84uUIlryByR80Mq0NIgrQdIucAC/KB4ijLkbrRJLYtMS2xZVXxdXRJQg0Nk?=
 =?us-ascii?Q?gPKF+M+f59xmEAAqA+odRKOUyrp1FE4iI/tfUed0aU+WuTvLnbwrtQ+dvZaK?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Iv9Q6xPyz4UvZglg3gt6KhV78JkAlUJ6owEMYv4AyZz+jaLNLQojarmJQIWATx+E/v0NTJLkzAsyJJxfh4suL/cru4GdZf+pk753NrtF5Gw7IDyV8im93c5XnTJKtPCx4I/eRasRucuiX8TAXqFGzGzLPlek4kyIFmELm8Yuw/VWnlZp6SB0COJai0LoEu07bE4GyufTOab8lRe+9Mcce2zk2dtT5ClqvQ63Bn4AqrBVC1im9uYOF8Ohpn0A5ZYlxinzZjqy1U/p+RtyBQyXPLVllGJNo8uZoBaIrgZeS2XoHIvknsYSTvufgn20vlwo1XQra9jRa7XgIcHOot/a36fkYg4QLEK3FvKYsQxhx+tOztcnVbtwTy1tg5YcQpchvzhwvMLFBwzL3uhDr25i4y9vs2kbTYd+PjR2XCYEhJKURQQUjpqnhhsslpEG3snRT9Vz+cNAicOfOdoFLerfi8jDawHHKmxGZiWcMvJE7vlLAlyeZbG7y0pA2ocvIhIWfdFUY5pNVQb2jtlyAKSuyj8uCBZJ0qECf5FQT2UvR9U+wjbpufh+FWQsxdulhkZ3HOFIKIMtpQdJg9fxwc3ZEdWgtPzQPp+Ty7jSZpA+N6KBwt6ZOuhAzrZMFs2RI7gIi22CIineWtFWuLcgbeyw69E6KkzpwVj02capDqATYyCMMD3pFjTZcn+J5QM+jqodbR9lR7yKa4ONkEle9nogpAqsVCa3AlerzQqylgHQSpq5AoZfHz1D0gSXQblGFkDxuBez3fCoM0UUG7rUQLuNrg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60137e25-ad34-4ccb-51ec-08dad24e83c6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:08.7846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3EpEaLj8EFcLEEfL/tz76m7IgEtKTBrBsIzzIejE/Eiu35GIvW2+IV1K0J1EeHHRKcowFx0X/+976EjEXBGw8AaMbbVU2+lNLgcmqOc5E8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-GUID: wq8P4SrMWo9i4uMEgapszPHrUU_5HFB7
X-Proofpoint-ORIG-GUID: wq8P4SrMWo9i4uMEgapszPHrUU_5HFB7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_attr.c   |   4 +-
 fs/xfs/libxfs/xfs_attr.h   |   4 +-
 fs/xfs/libxfs/xfs_parent.c | 149 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  34 +++++++++
 fs/xfs/xfs_inode.c         |  63 ++++++++++++++--
 fs/xfs/xfs_xattr.c         |   2 +-
 fs/xfs/xfs_xattr.h         |   1 +
 8 files changed, 247 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..e2b2cf50ffcf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 711022742e34..f68d41f0f998 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -886,7 +886,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -904,7 +904,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b79dae788cfb..0cf23f5117ad 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..cf5ea8ce8bd3
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+#include "xfs_trans_space.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
+void
+xfs_init_parent_name_irec(
+	struct xfs_parent_name_irec	*irec,
+	struct xfs_parent_name_rec	*rec)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
+int
+xfs_parent_init(
+	struct xfs_mount		*mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	if (!parent)
+		return -ENOMEM;
+
+	/* init parent da_args */
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	struct xfs_name		*parent_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		parent->args.value = (void *)parent_name->name;
+		parent->args.valuelen = parent_name->len;
+	}
+
+	return xfs_attr_defer_add(args);
+}
+
+void
+xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kfree(parent);
+}
+
+unsigned int
+xfs_pptr_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	/*
+	 * Pptrs are always the first attr in an attr tree, and never larger
+	 * than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..9b8d0764aad6
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+			 struct xfs_inode *dp, struct xfs_name *parent_name,
+			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
+unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
+				     unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6bb5889a71f3..27b9b2a3d8ff 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -946,10 +948,32 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+static unsigned int
+xfs_create_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
+static unsigned int
+xfs_mkdir_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	return xfs_create_space_res(mp, namelen);
+}
+
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -961,7 +985,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -969,6 +993,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_create(dp, name);
 
@@ -988,13 +1014,19 @@ xfs_create(
 		return error;
 
 	if (is_dir) {
-		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
+		resblks = xfs_mkdir_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_mkdir;
 	} else {
-		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+		resblks = xfs_create_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto out_release_dquots;
+	}
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1010,7 +1042,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto drop_incompat;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1020,6 +1052,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs = init_xattrs || xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
@@ -1034,11 +1067,12 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1054,6 +1088,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
+					     ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1079,6 +1124,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	return 0;
 
  out_trans_cancel:
@@ -1093,6 +1139,9 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c325a28b89a8..d9067c5f6bd6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..3fd6520a4d69 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,7 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

