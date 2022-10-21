Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A58ECDFA1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJUW34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJUW3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35CE28E05
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDaDq029912
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=BpYjsOc7w0IfBN6ePilGLKYy0TC7LHy9fpHc059STLY=;
 b=2HklZsqTihty6p/EgJfxvFzSqY1zvLhQDGtD1BDmOO29HF2xkH5XZ76pYaDGm8fo5FC5
 g3QmlX7ugv5IY93bKPVu63yf6xBm4VkWfesSyObRv24aEFUZgzLW1ZBtCRc4ST+NdvL+
 mrUe2cucsV77XGfwVKaoeDujkgSOvFrb3j5ZbG1a9fijRSch33eaCciLI9fG1yNI6PSi
 ZHvCvIMF7fyBDj+je4DWeNUVtPJIgM2fNRYJhQr85m/OclFbHz6IL1dbW/7vMyFY3ytw
 brF8SPH54++hX4Wsdc6RDESKslE7kQReNVdCvOZ8BEZh3a7D5gVvft32jJjgBchBN+v3 mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3tc1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLUmFw018333
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0uc7et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AM1mNdD8eYFQOiFrBl68rSIFoWlEOayVh97OoEJj2wVv3S42rded7lE0D99JFpmf7yEI6c/BzhxSX5EbcazH9D+WSrXI8evYZpojW6kB3s2Y/kQWTgaR9R/rQTMLSpwp1wRBhuBLHSjfiGQWtG0wFcQMdtjbnfZxHxRy+9qldUuqdecb3X8a0nNvRkCLzQ8q/YohTwfjq9f+fwuyD20ZMokYIWlz1plnJC6vOph34nXf5IUkq0KVrcqLZpGOcWHsdqTGqOaUlHXNz+VmqUBbbtvvoZKIS3GvZaX2tN6/ckNnErstB1JvOXUvzbqR08rY0LsRH+fZGjfLc9eaic7Bgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpYjsOc7w0IfBN6ePilGLKYy0TC7LHy9fpHc059STLY=;
 b=gxawjPZ3hUh3pdOo/bpYJdekiWOQFuO1tqGOnlNRLPfu4hZQqujO7LQhleiQz9usGqsYvqLN2MtY66UbGR+O9EZfBfxZTIfptMvzGxak4kWW+E15yrB6PhTZO0N2AfGuZhWjw9RfQhfWORvXtw112ghsLDC6CYEOj4KkO25N46aC9UOmJA9+qVSpfviievNfR7rm8N08Aaa4RklBkkvRFxvUiABubaebeKyMnGV3dne6LkuWvdfmntS/V+qcmw5uVaJF9pq3E+0EB6fGFUvLorCEgNOd/OPY0JxduotO/Dvjx74KcAvtyQoQM9h05ZoC2vOvV5hq9ImuRuWTFQHqQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpYjsOc7w0IfBN6ePilGLKYy0TC7LHy9fpHc059STLY=;
 b=gpKAqk2pTskUip67JtnSolRUU0z/8P9xqBpxeoBa4FFsOZi2uG07JdNtWHiAAHzlh+hGZwM+eQczTOJcvcSVQZ+Kme2tCN8OH0p+k1Khkmg0dI4sfjpdt5leSJNucPUXl3mGHsF77Z8xkdlA2RX6g/YHLrGjKo+SdBhR7eIwKTw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:42 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 03/27] xfs: Hold inode locks in xfs_ialloc
Date:   Fri, 21 Oct 2022 15:29:12 -0700
Message-Id: <20221021222936.934426-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 6989e7b9-d4ab-4b3d-e71f-08dab3b3bfae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qMEkmkp85h5ibnSxXpFoLhNVvThFJZQvRg2wgc74jU7cSHaVAw3sjUwWJfKsUdchwnodD3xvqhOyAtdDqUxKwFvcSEqrhbMD104bSbluVX/5j2HXUCMcBbFdYO27dpa4mOkbLGOQ/h5Xf80BlRfJ+Fw3KW7zBOk4eSBdT3LH2TiA1QCk9DrIVitbSm/m/APQPkgtLlZTev0relJBxqEzFDh/tSfjUA50lr5+FLohUxXrDPXyZixnA1kZmh5ymYmwM8QsA+QJDXKvpGAzrwk4Tj+ebJM8+lDuCD4bQgwi3WwnoJQj8zExGAhCVK2BqFkJSfKPqam8k2lTOBra4ysL4IB24sVIKaP1x7ocl5gx7SW6MH08giKAcvfzCgvU4Z21qptpD9wGo/mChAmDfaU3+vdtWWHlaMNlv8DHpy0HWJBXvgxpwDA8kbNF1Bnwl5jhtdrx2UJHwrD+kboQ1wHTJSvQ5CWw5H3V5dXXhivpUvJQj6xcNTWT8ET9HMNlVAmxBd62jwccN2lOg1j0j63Mm9vufVi8q9Qlbnw9xeY32c4Tdhw7YL+n2J/lGsST9MiDNB0yDGfVcMILH8SxLNa6TZ1gkyITPer4IZvPF7R50d+Ui44bzcAKSDB6rs02ECXMcBjv83bKCr1ZGNsWEmGV+4k3Xyncy44GV7qjbL1q+0lxbDcMnv8HpAIoOhw+HkLG7SeXIlMH+WGMNdJUtSx8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0DocUniQUaApL+NQAhMqZ51mj1yL98o1Cgiwa8PNQWSu1LuoSUz4wgK7a0W7?=
 =?us-ascii?Q?0CTGu+drsEXZGJqXjxwZoxZeHEIygM3oT6KP61Qy7uqyDy9vsDT+qnWeUaqd?=
 =?us-ascii?Q?cbpcG+Vj2CT9VrSPn5BqwRcQRvHkuXo42GWG5XrcMZKRPG/iaHDbEQP6KRkn?=
 =?us-ascii?Q?LHiVuJziX5npbAhbyYEI8X0+nde+uwFAKPzbJ0VhrpaUIO2BWX8LbNmJM4nY?=
 =?us-ascii?Q?9I4pVlkUHNStW+g1IVBiHE7Nx7n7EcZbfCZq4grKMotEGFFfi4rE2uOTCvVJ?=
 =?us-ascii?Q?LW4liEzTpJUPA3VI7/YRSG6Ele5H3I8I+setJQalbdkn4upG4de5pB0SqTtj?=
 =?us-ascii?Q?03RR2/c8zRCy69BWVYuR1Ss1RPCjxcVumJLzhfNr8owGMDapzl/hJNJ1MBHy?=
 =?us-ascii?Q?lqIFpT7//05yg9+EhG327qVueOYH9FJrqokh4YGH0R/Uwi4Ca6ELpm/8K/7p?=
 =?us-ascii?Q?TXh36nTMOWImPD0/9qOIAfjlWtFKcbBIKYqzj7X7OCSLgCRilMPz3L3ZzytQ?=
 =?us-ascii?Q?iIT2Ne5tAB+6aENGlVKPO3WBOYxuoPjm9r/QcEJmdaHO8PIH2j0PmaXvEiRs?=
 =?us-ascii?Q?nVGRzyFC4+2SdelhXDRwm7W9/t8zM6ReFJjeYzxXcbQ9GS79yCdWDHj4gvfI?=
 =?us-ascii?Q?NAEXWU/oCY6v7uQaYvPgMZTC/mKouTLmdRMGbg78Xzh73nxX8QlTq1Fswr5n?=
 =?us-ascii?Q?ocXV2beiDUJuewENC+z6tjqZUzeYfTDjChIq6mXR9v2cNoH2ThG5/amZ6Os6?=
 =?us-ascii?Q?FtYVWYg/ZOl64/PiYqRlhBPVILHiqCJT1oVUcBu8/rb04HDflibYMw4LpG1b?=
 =?us-ascii?Q?dVXiXPWAwaN/ZDkGCF7iqRMajBttmwmnHLYSrhxcjUd30KE4R0T6t+TUaQNt?=
 =?us-ascii?Q?kRK7Y58PwBmyHIlus3CBBgJpTzob5Em9IGE6EOno9PAOV56ZGMRfqrisC22O?=
 =?us-ascii?Q?5cVOZUs1SOd4j8bpuQHD7O2vaLKq2RwYRFETw8yFbm88v0mJjkpZQk2Ga/5o?=
 =?us-ascii?Q?LG2edpCqM7AqW89jRvx2Na9Npwa3rWLPHlMejHExY26YcILKC06uPJsh8NBE?=
 =?us-ascii?Q?Tlc+WQYqMOJ5VTAefwPpMOC8PI01CGyziBJPBVw4WEFovMqcT0DSWJGsTltf?=
 =?us-ascii?Q?x9XQAfALKANCY6rQH0L3zccQL0CH0dcPT4ULLCugo6vjUN9LidnhJ1hVIO6n?=
 =?us-ascii?Q?daEi1Gh5f40Z7fBCUJenQng90XzrgpsXiPVlGeV0/z0GZKJDC6JsT5MLrew5?=
 =?us-ascii?Q?SNkX4HP7ce7fVGRw7J+ccoWG9GmBNAhg9w4idOvxeC4MgZ3T28Rfus5wEu1T?=
 =?us-ascii?Q?+7djvpdisOR8GQ8+377z3YX8Qhe4UPhrt65iCTuE0D1dE31eZ5iP9f3v6KB7?=
 =?us-ascii?Q?6Q4qksUp2jWPCw8YRSsIsHuYrXMCIIchXbQwdDi834Zs6er4sSUoFKHmic4E?=
 =?us-ascii?Q?aIVMt1a/G1viYNUPXnJvj5OXQ9tWuiIHpo/+JMqmyeZFUZYd4Ly18z+u8Yyh?=
 =?us-ascii?Q?nUHpC20TtdWOle97lzO81hxzgD38oPk+Pvv9yCU154ldCB7Vamglw+kMSKSL?=
 =?us-ascii?Q?LbrFyKk7DL38+1JX7iQBCMKJ5SkntN8t2SXmxSH/pZf5/GAuRQpWy8dZqx2P?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6989e7b9-d4ab-4b3d-e71f-08dab3b3bfae
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:42.4024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhA8Q+NDos4FtCgNUQ51GK9pOcQ7lKUN/S1fTsYese2pBiqVEIrSIHd/avOHnx66Xj9H40Mbw2b+XcQUwPUPGWmlMt+sJbKihEHHE860FX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: rethhbcDUGemJ6t9l9PL5deQ_87DzK9s
X-Proofpoint-GUID: rethhbcDUGemJ6t9l9PL5deQ_87DzK9s
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_ialloc to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   | 6 +++++-
 fs/xfs/xfs_qm.c      | 4 +++-
 fs/xfs/xfs_symlink.c | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5ebbfceb1ada..f21f625b428e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -774,6 +774,8 @@ xfs_inode_inherit_flags2(
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
  */
 int
 xfs_init_new_inode(
@@ -899,7 +901,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1076,6 +1078,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1172,6 +1175,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 18bb4ec4d7c9..96e7b4959721 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -818,8 +818,10 @@ xfs_qm_qino_alloc(
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
-	if (need_alloc)
+	if (need_alloc) {
 		xfs_finish_inode_setup(*ipp);
+		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef..d8e120913036 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -337,6 +337,7 @@ xfs_symlink(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -358,6 +359,8 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
-- 
2.25.1

