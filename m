Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D86EC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiB1Tws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiB1Twm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CDBCA0E3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:51:58 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJIAs010136
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=a4n5szR4ar5CW6cUfu8a6RCOic85ieRG4y4Jem+qoro=;
 b=VecvcJeRPty4Mv4Tefsk27VUdDESlThyhZKnz8iGvKLMnq+yU/VDvKyUvCTqNROREMxu
 VIy618bsErQq399XJzUJUWqUtXXkzsvCnrR0G9QXdEHO0RrUKviNPx86Q/q5UIyZcLax
 fd2fyKbUZg7k1/m9flZnUWQzKPLrW1djvcC5Xd5+DjXv1JYIaiCdeb+ljG+Vu9G1xvoD
 PvUN3AYDxMTJyAK3invLrgSRlZ3c5nD0QwHw7aErXtljJtSkpiJfdJmsHPPSi0q44vVg
 9Ms4wWXlI6t/bdYOBYt2sSHxbUgk4QzkjpjPOpN7lyXhZ8LAznCpBuB52hktqDISbnuf jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJklth076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqrxm56YpSCw7KhpvmlSrJyRyime/IyraO+GawB4tiVRU5f6JMqeVEE792jj2s5DyXRJtLuwsfG+UVNCB+SoN0zkEPJlatekqgNgTNVZ+9xys6pRBmjhByFdKvzC/rARzp1ugO3tm9S94nhX5D5N6FVqVqNQpf+QKCNGPSIStkIhu0BGs8lI9/WAI6znQ2sCL72B/F21nr4V2/FUlejGPsBBs7h5nUEpXXMW79DZmZO15oXAfWV6n67OTAG2JcZvI3zCt7u7TNmc25PL7p/jo/QJiWLZGm2FP71LwV0fE5a8QJpv2IfMLxFYbJAupBZp/l7b5ZsBXWBYAXGzs3gmjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4n5szR4ar5CW6cUfu8a6RCOic85ieRG4y4Jem+qoro=;
 b=bJIAgPEILYG5WR3p/uX0YmHSR3Fmywv/UkJaPyJFExIwGyKXEJEn2Q+kIXrihF00vwxysB049yczVpVjZvq53bJWk7TAHw5OKD3KuLPTKIN/JI+Cs4Zdjg11MmZc6IaDJn94bdITEgDqkI6mMKsGtFiJ9Yq5Kv4Fr6MQRJy1l1wzPxhZpdPmetb7NGF+qwVnvZtvPvoKhorEjOG8Bq/y22kn41ty7Bis9/FVQxRbBw6u+gM2TR+ymvYutsYEPTkqQ1ZTldbdPgvjXta1OEDrI0US1k8pWSZO5UeMwfvcpsQmrMf5w4p+W/sXtiPrHnISG09T7hzmsodE/2hgEwyieA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4n5szR4ar5CW6cUfu8a6RCOic85ieRG4y4Jem+qoro=;
 b=XfR3ldcTh021ejp4ZuhJAvucnX+YTQjHhFJ9BIA1K/lxR4qv718sFhjOzQoLbQZ+ovu2cH/malxQsevIRCn4GTxNTuPgGJ39U7iqLJ+aP1LOcHS6wuBP+2PDS5feUHImXi902IN3Y4F9pSH8kvcK8skOwSeTioSpHLlCr/2l9O0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:54 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 01/15] xfs: Fix double unlock in defer capture code
Date:   Mon, 28 Feb 2022 12:51:33 -0700
Message-Id: <20220228195147.1913281-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f799dcb-aa8a-4693-4db6-08d9faf3c4ed
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB561251A034B4930E1D7C887B95019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXJVqubbD/T0EbIrvh+8R7XuLBVsgI8bhFoSChKOCOs1k4A/oOH2iaUlwQveQ0SpBScVOghOWOGL+ojW1R3anBoBzRgWM1GT8MSdyXqLd0Ly7YuPDQZvD2XL/XcO4r//VXsSoFzutyahB60grCKtZkNeT1cF12zdfhdKpges4hXuyxc5CCZvbKv7lnwNzcjN4V3yQ/yKvArejA8SYtRgOPzTyHxdWx/7kpcDwsyE+oPKqCJDmyXZuXzXTlS7VH0SglaEmIWU6eqiBlvIKUcM5mwgwBVhNTWGX5APSj/Tb9SoKqGphapHhgS4ATqi6GL2FrG+sDhdhf3jVoUa8opj/ED5BdYPF4Yd0FvBLHhukjwWBl7CPXHditTc3rZLpXoIj39YtzAVrQxPIwhZTgO/m0tcy8tJnJnHttzb5rxhLFoGDWFH6cDlp//DScHtyA9W72KuVbiFH6ryt7fMMKZY47xSp4Qa99/mtL7f5A4+MFNlY2JHtFLci5EM6inwafK8NzE8uPrEgRLSAN2O8d0P93kJRROqtu54I0KkdQJ0Rdrd9S+VP1IwmazYPptD7bD1HpKKIgz1da2swbzm3fQtfz2xWq9+9osWWsNNjaa89tlsr6JQbZPGlmvYbTYOCa+jMYR/xBT2w3OqVqDnhenPWwEddu2cEXq2bnvI2pfyKfuePFfA2GHF8tIkiJnQ1rhkke3OJ2SDrq28eNvLH47Lbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MsCpR+vC8fXgYJJCi0oz+NT4aXmV3irI4dPxqnyJ2VhoCCFr/gfGHbdVE6QH?=
 =?us-ascii?Q?4TkyprTsAVjAMMLTj8IlWi8vu7awQpihpWPgWMrADccsbJ6Wx1nqb3epkKso?=
 =?us-ascii?Q?6kyJWrdShwGqLZ3r0Yxwy1s6iTVJKZd+pbRrkvZkeSWyKHrAqWYsRHgMY5ol?=
 =?us-ascii?Q?cXHTtnt+1X1wj382XuV/MzA0GxhdUyepaJszpE7IfrGoSmhiIBH8htAgDc5R?=
 =?us-ascii?Q?5WurfuVavd1av4hWgNhjPctXrksDr9eCRkDJdgnATKnZ+8yzVDFKF72yhg7F?=
 =?us-ascii?Q?mkeBjDpGiHyZHUFCheJ7af/sC7TxpJCZnPL2xEmptkB3YYnRLUj4KZHkq620?=
 =?us-ascii?Q?ozDGHbq65MpL8ZQk8Wq6ACCI7V2QAqDX7GsmHdUVQjlY5LJfSjvabot0zJ6e?=
 =?us-ascii?Q?lPryOM0DfkQq9EoosTwDOL95IKmg7LwmuQTCKuh66FmQMsmwnni+VnLHnfop?=
 =?us-ascii?Q?rLsdgsXx2AFpwTfdXl+ZSt2xextpk9HaDr3orREChkMYsqzMoLf11HC2o4V2?=
 =?us-ascii?Q?9Zu1nqDHkbF8mJfPUxXsfpl8OVFwwGu5pAQhl4B6sdepl0Ze4OSBzMpBpxDu?=
 =?us-ascii?Q?55ldrj/JdJsaqwpuuQ2tNsR9vp6G4Lvrk9oOZApInAh79vZIe3zl8Hho/lZA?=
 =?us-ascii?Q?JhEr/XqelcA3VxGvH1CbPhKh7JFVFLCw2Colj0HtJR9qJA5LYXeX+X+EsknN?=
 =?us-ascii?Q?M9+zijQqqPJHmbowCfq0Rd5LNbtBkU7g6C71e7slAnFMFMmhFD4sos2VL+68?=
 =?us-ascii?Q?TlcCGeEWvkw/5J7/AwGaV0QF+L/RBb/3wSqhq2es1KbUekzozYmlRf/hAn9P?=
 =?us-ascii?Q?3vHZMs5qffG0qSXSjAJGdsFND0nIEFJ0Zswx4LIi6lyni2hMY6xY5MNTNApS?=
 =?us-ascii?Q?IDD0PkfMWzxPipezj7zqnaqAzTYEMRIR60d97Fn1cs07kRhPS41G8ifG6asw?=
 =?us-ascii?Q?My3xV2HzhM2SmywFqj3iQcXajrw5PTN4Lee0rHpFY4bGLeHj2scMAhtwTUYj?=
 =?us-ascii?Q?dZAJ/6JV3S0ZyaIXV7WflDCjLZ7gP2+Of3F/dBYK5o5bSXcrlmgu5DIK2L+j?=
 =?us-ascii?Q?i2ltmRXNc6T458jL/+m3Wp7hYgaHRWtOflu1Sx2jA5yiQfeSEOYpnzjT9u4Q?=
 =?us-ascii?Q?CDQMJJVglHlxRvzModk14M5TREFgbyLqaNMY7a+E4Kt6y06STdIZAkOtpFRK?=
 =?us-ascii?Q?9XHDoaUU/Z0eoU4DJoijyQSq9UCORinNU5pUSr2Z+7qYQnBP7lSU4lcZYOWQ?=
 =?us-ascii?Q?6qF9srahtNV6dphmQPOgfSb+R5nVfUHRqCFkkXsN3bE362D4BqoW8qrWPpVF?=
 =?us-ascii?Q?QEXcTFxFyYJTorgGjdgV+8Ir7sFm0wVO5qVvyRw+OiFMtxxpiVo26tU4Bqrb?=
 =?us-ascii?Q?yfMu6ZhqFwdygEfcXYXLiOnx0WD3SvZB+w3g3odrCWsEz/kzlW+9XwGcrPtx?=
 =?us-ascii?Q?g/WPsc0Pa2RjORQb20xSquqVL5xx0cY7xzljrU1dvhboxgnEqqTg6V+LDt1C?=
 =?us-ascii?Q?TaM+nSYVoN9U+qrWBB5md8F2g4v9THSFqbPAPAv+iPlUWenLF6MJZioii8l+?=
 =?us-ascii?Q?DX8niHlvPLrRxNsfVLLRwr+omdqzHqgGkzDdMoZxqhDI1T6cY0/Z4VDFN4bw?=
 =?us-ascii?Q?aYOlZF0J2KjuFenxwiv4spsoM01aE4QGa76oY79/5v9MVjRvqDSk+ot6DWo4?=
 =?us-ascii?Q?NJPknw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f799dcb-aa8a-4693-4db6-08d9faf3c4ed
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:53.9393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1gvDD2i8/3/cahtene6rLJzOfILcnT9XF3j0s88WoIvHMUsg+VOVMlIUTXvIMIlcUikZsvv8/H9UiB89Xu9L/+/g4IgM7pKlE1DI5va9wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: nbrzWTG-X6iGE2VwEEAkEXLWAiRxNBME
X-Proofpoint-GUID: nbrzWTG-X6iGE2VwEEAkEXLWAiRxNBME
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new deferred attr patch set uncovered a double unlock in the
recent port of the defer ops capture and continue code.  During log
recovery, we're allowed to hold buffers to a transaction that's being
used to replay an intent item.  When we capture the resources as part
of scheduling a continuation of an intent chain, we call xfs_buf_hold
to retain our reference to the buffer beyond the transaction commit,
but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
This means that xfs_defer_ops_continue needs to relock the buffers
before xfs_defer_restore_resources joins then tothe new transaction.

Additionally, the buffers should not be passed back via the dres
structure since they need to remain locked unlike the inodes.  So
simply set dr_bufs to zero after populating the dres structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0805ade2d300..6dac8d6b8c21 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
+#include "xfs_buf.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -774,17 +775,25 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
+	unsigned int			i;
+
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
-	/* Lock and join the captured inode to the new transaction. */
+	/* Lock the captured resources to the new transaction. */
 	if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
 		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		xfs_buf_lock(dfc->dfc_held.dr_bp[i]);
+
+	/* Join the captured resources to the new transaction. */
 	xfs_defer_restore_resources(tp, &dfc->dfc_held);
 	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
+	dres->dr_bufs = 0;
 
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
-- 
2.25.1

