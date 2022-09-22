Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CC7C6FA91
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIVFps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiIVFpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A627C32B
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E6WB022062
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=dCjUvP+Bk52VIlrNc2syuNuAcr0TiUYXuhpVrmfhkAM=;
 b=GW2mH+duIH3iFpnhc28culdWHkSml1epZSXMLijXqMUo5QHUGhuWZulWOFJYslD/DjO6
 DKqstfxvsKo4RxEysW65KH38OneBWTWXnCgCk1h/KMavItz6lsWDPzIEq+tPfnLPUASy
 vRaksUYk6sL9+U+7f6Iq9tuHdb5iDJ+f4HaIw1u4YFexDTLkaRPtlGbhLgF6srlW1uj4
 BlAg2ss8YDDChCney5sDVNe4+2byBnywGASQQZbqwek2QlRi38py86HU1PVVtF5GCS/Q
 zSKFGtUXSlXEiN3MKEkNFcW4nVDU32OECP9sG9f6X+dONlLccptmdGdgr5X5zxFqYGya 6w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M21fvD013584
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39n7euk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0fvns48k6k3HSW58MEDnfD9jkTI3DphMy33SxKLCy3kZoMjjdhESp1dZM456aRotGrRhVoTpF4FCT4pzIX/f7caJnBCSdVt/6WrNVksYSgdD+gORlG+WJaR9jOwvZbMiH+SZcZPstBzDzgNUYtcyyN/qJQEfQDTUVJgHm+grF0mHeV2GIxHu8CWGy3IReWz4G7ohujaGWtfXD0DJ/IIY9LMM+7/oItp+WGkbJtq0dPtZqzHAEbzs9C8yMVp8G4CSFpNj02DKo4U0FCEK/jYNYw/Xg6G1xrJNqb6XtVWFy355s5n03B86hzWRGSEegZOMIdLrFjdwP5P2vpasM/kzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCjUvP+Bk52VIlrNc2syuNuAcr0TiUYXuhpVrmfhkAM=;
 b=jRV6vEIJVtRMHCDIxAMNOT2RlrLQ2UPRzxvn6/CcRIQU1D4YuefSeUEH5hkaCAu4USvXgncQ1+f8wxm2KVA1652/P4KZmOSYBpjRyJ1JVJuXReeRsF23Nd35yHFqzLquFmJTcOD+NHFIs4rZQ1j/1W2WxsQN7D/Vwcw7sXJNjSXaIHDKdJLOmPFRR2AqwvK9Xn79Wsz/MBVC253utEvfUDLs8UQCIKSjoQQYBZdZ5HZx3TNorhiLi7bX+2fhTOYU3f+nwBoOa35sazKpgXsyIkVmsIdc1A2u51FKlyBajp7NQjK/O034NbET945KN/Pqnjx6/2chKTbJwxCwyTZCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCjUvP+Bk52VIlrNc2syuNuAcr0TiUYXuhpVrmfhkAM=;
 b=C90e1MefaHmH+uedRnvBCSKB3ui4Z6qWXJM2u4aAZIPUPKJ6Ct3RWMUv/9+nWcjze1XHtG8IfhgooDuqlS3KngAw/pklDvCtzRRLehkQiaZxeArSzTwFNIYU3doCtZpaOeegEJCmFK98U4Pu/fI5byYP+SEGmb4vkHvDMrxE7HQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5952.namprd10.prod.outlook.com (2603:10b6:8:9f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Thu, 22 Sep 2022 05:45:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:37 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 26/26] xfs: drop compatibility minimum log size computations for reflink
Date:   Wed, 21 Sep 2022 22:44:58 -0700
Message-Id: <20220922054458.40826-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:254::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: 05385964-153b-42bf-f9fa-08da9c5dad0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7TJK0jX7s2ncSG+nuh6XWhLBVYdWtBNIETTmYXvVDRYwZokwo6CJf8b1r9hitGLEd5PkNXLuP1zvSrSjRjz8MJLb/3Fcog9nyYUxb3+NwUWvsRHkj9yvLdwuVzoznMlb8+lo+wqCDWGpf1da6q1eQ/o1dgl0bRD3dIAGaxYX8pSh8MlahOczkFY3rYl5nSlnmAkbl0AtXdJaAKNNbZqlNc8bhFBb2XkX48aX2Rr9iQISEH7+OvQHktqgdlf8t0dNDnD3vQNl/9SIxMkWyAWONpb3+0dmVpKw4E115Z5dIwFpoI5DaHLN6VlM6Tz/LjYhG6vZoF7l52aZxm/pgPRRSexb/drAT+gWozNDPmllh/gCQ+D3Qdxn8VUz3ECm/vaE+IxkflqwrKf46G7xYt6zZVUCv6CtjJU3mH27g431a/lMzn3S+VvBpJup1Jvr6k5j3PAGO14hMsWWYfjQBILL2OrABJ4nUtMOoiZkjfven4dSGWHuT/ts1bDrCR8DCmWUkPrzLwDT7oRsqvRlQeL2wh1no/5SKs+xLWnibTiy0l0D0AFuCkNzBhZwaU0QrEd0OvRejhbXSrRFGYfgwYm3A7oEjvmvM07b32OsimDbU77M9GOFhlvCWPkZw2bcQo2BO9pLo2KLCNn6goGa7TMl5agtWG8pHCEM19XjUpH4wIl/hB0zQNQoDBdn+M+OvW3y24pW/EknKDBP3EBzy87TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(6506007)(8936002)(26005)(6512007)(5660300002)(6486002)(316002)(36756003)(86362001)(478600001)(6916009)(66946007)(6666004)(41300700001)(66556008)(66476007)(8676002)(9686003)(38100700002)(83380400001)(1076003)(186003)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rxbj3ZfZ6tQ+9mIXpE2/28U737X6yJJcpZp79ko+IhepkrgVIZHoz5752e8B?=
 =?us-ascii?Q?OKclMN0B58mIIQENN0CnLg5qmNZFFUIZojTWYwC6M77FBo4oHyOiADjbVSQT?=
 =?us-ascii?Q?qoSd8Dn+0RhuCKAUYLUP1I3vzrJ74h6xUyZmgEgjezSbdcocfvGX5tPNZqHu?=
 =?us-ascii?Q?l1EGZ8OAiMbFnpb+lQCc1AX69v7OGU46Cyzi73hNlbLkAj1Z9eJqaJV2GIA4?=
 =?us-ascii?Q?/D/WKCEr6AUnrqhMAynNKjuIiGxnjsLvytl6CZiYscIsnAXUSmGOkmhF29QS?=
 =?us-ascii?Q?bM9cMnrs7lax8GfKT3nj3qm54+l/lr7JRBm1rbAdiKxG61LI8stzjznFo+lB?=
 =?us-ascii?Q?mTWveybI5xHB51zZJY24p4T6gBh0bAI6DiHzsXmJuVIutJaKM0hqahz8btXC?=
 =?us-ascii?Q?FUBZUL/IOXG674q1aaWhSu1RuWaJejjbiIe3C8Zk/osWr3FJi7x3FC6tsq76?=
 =?us-ascii?Q?+EAJ1JyGwFMOhd5EA5JO1Ym4wl4kvXu82FM5tST7eGSQDZDr/rw4Tl/X+wFi?=
 =?us-ascii?Q?xtE8EDDDSisOef4uHTjxYeVvPpxWnywtUdr0q24mJI420a8QMLQh7u95qkUM?=
 =?us-ascii?Q?lMaynBOJPQtkInqwzC2KWsYQyUmA/vziswLBqkJEEZ9msnOl8temFOHAzSXx?=
 =?us-ascii?Q?wkODGnUtHDTTyAxUCmyU0TulCYLLXxbuPUgqpK59zDlp4Nq8uiCbFLFFB6or?=
 =?us-ascii?Q?qR7amJGEDGvmFgo+noIoLvL8HT5JlEsMb94v3VC1btizcgOGeyMyIVgINcEc?=
 =?us-ascii?Q?2BMutOhOf6EHO+ijQ8Xr0AjnRfOGWjKGnhvKpszZpP4p5XNZE6UDznDL5Els?=
 =?us-ascii?Q?dBnXNH1vQx7DThDW40E0TrlOV3bYfY+nMZYokysh7zbfUGPuS17BojTtJ6dA?=
 =?us-ascii?Q?zOeSdpI8bZfJXD64zUVVS1YSkDmG/Yo+9+UhUY04ssV+I0o/sxF+btvLlht1?=
 =?us-ascii?Q?iyoy0tek2sBr2f/AWjd+thM8SzDwmBRedevOVmZrj51HOms6LUoMhzaZ6w19?=
 =?us-ascii?Q?yII+Rce67NEwbFTUhVqpDiKUHJ7paq7+MWDYWIOzu+GHhnLN149N6zxaLZuU?=
 =?us-ascii?Q?yfPwJ5IKYKwqxXkNUZLt49+TjTdGtdtVYnks808INHYlWzRzrgXvxKM152vO?=
 =?us-ascii?Q?77eegESBboXXBGE1jJcb/MM7wfYhHgbFHqrN6HIe9mX6dAIAcGHFgOAOIyOG?=
 =?us-ascii?Q?4Yw2s0JY7ZJ+mW6BXAFiqSj1UMXGQaxtxZqEY5QLezkODOoxFWjYIlxisE1q?=
 =?us-ascii?Q?46GVItbo43AF4dRiRXTTiTp+XlkMw8pZtp9DYYfrQ+eyfdXevBNL45avHJeT?=
 =?us-ascii?Q?9pUqlGAzPB92pqbqd5wz1yRkY4I2G17scAbxZR8rk3IhbkpOY5J2+zyoV48k?=
 =?us-ascii?Q?CaO4XR1wHcDdGjL4mqUFWtchvZqEyqTr8y4r5vEcGGLnmRCl0ZQWAScoV+Es?=
 =?us-ascii?Q?WckI8OzOjTgESuQkOJv5wePhj6NqnySN4Lsjhen9wmMkrtpNF6vZJUmGVCTl?=
 =?us-ascii?Q?/zo0HXhS3HNUpWmy6m6zXrdhutohsE8yIcsTyLyfWpFtZbW9hWwvv5+z/Sp6?=
 =?us-ascii?Q?L+f/N7X7V29T+4loV9NaSaKDFp+y6eH7msEjLBx3nKsA+lx2ANEJIvIXhUg8?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05385964-153b-42bf-f9fa-08da9c5dad0f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:37.6211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlQty87woAwvM4i0Tcnj0Mdmy6EN7J2J7Dum0EM9yNZBkV6pbu9mnlyA+kqF7Ar25QXRPtmVmw+AhuSyslhYGbtxRxXyabp46SKnOSdwdcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5952
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: PCa-ikCG2whrxb35LrdA64kzQ0SGsGr8
X-Proofpoint-ORIG-GUID: PCa-ikCG2whrxb35LrdA64kzQ0SGsGr8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to
-- 
2.25.1

