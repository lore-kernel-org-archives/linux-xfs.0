Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7640FC6FA91
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiIVFpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiIVFpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2665967177
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3DwSb022580
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=BpYjsOc7w0IfBN6ePilGLKYy0TC7LHy9fpHc059STLY=;
 b=R6wzTdzseo01qlw9BiI7h6u3WXi8w2NGRLrqi4aMHVcxET9xtT1985YWZk4hRlRQZOCx
 yt0T7iQ05jNgyUx9ikHLOTgVGBBScImr9r0MT2XnndneyLbONGIaNDZd1aiPRy2bhR7X
 iOVICBbRO2lAt77rxE2ZfYdmxtCs1MbZjPEhHaK4AVNSx7KRO0PZCrcXw4dfqN9aBOF1
 s67CG+Ne5kJXeSc466AArDH+Vs3/Qrr8h2VtvdHvfaWoV7AFZ0AUPaxd1YNK5EMQMyH1
 0VlnGOf+5loQpW0llrdLQUK96q+2dlwnizHp7Nk8vOuc0wu8xfRqeDGtkqA5CzpHwDR0 +A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stmkre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M241Dr034049
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39fmuhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH95YQTE3lfkVo+UU4ynu+64uxMt1oXDJg5bpEyBMzAYdQcqKoBpHUGN36kUGMt05LtvHo4dwEUo/pDZWfR235ksHAsAP+NbUInaeHJdxoScbg7ayoWKOjEtGC3tgaoHUTO/7KpDWGLijfvQ7JIamhX2wugulwXLHi/K9k5npbGBCmVKr2m7J/fvdjqO3QlRH1JT49/TgWfSjKKBGObg/vi+MTY/cCLecmYzFsBA69pAfB/78iHiMJVp8oU7DYLiK4UyevqAsW58WQJx+VQjXOEHsG+cVrZ3+an9RBOUtH0OgBbCpROm+p9NRBgxtsEZ+rpWHSearbjZQ0DHrzYBnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpYjsOc7w0IfBN6ePilGLKYy0TC7LHy9fpHc059STLY=;
 b=j5qCZB/8+txkpvbpT9wI0MwyHnLm+V9B1Re1/r15j5SUaktgCTSKFsONjP6TzJvFTu334zCAqRKgGWKqMB/HLzaCJIaxbwyDTiiJgq820mRibhpzQifrtweDssge2DN4COECed4Slj3aNopNeodSA6sfCavBgxgOew2xHcapK8cqtUAzfSBr4ikpIsmf+uFKb65jmFJIr18H2RQ9A2OCtVBFSSCmq+gcoGFAOUCA7llGcpagzhEY3MNH81BvrkGQP3nwUy8ZOCm4WonX1zqyVQX7JyahrYW/hXXKrj6F8cWitie84OhcxA/6PVd5Rclxcie7V1/dXwTuaQEWc8M2Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpYjsOc7w0IfBN6ePilGLKYy0TC7LHy9fpHc059STLY=;
 b=XcNWoxH5a60dd8HquSIwepgNCznXxW5EgvH7FT56KuSo2I7meQxMYpTUrr0U771AftC6zacY7GZb7ULo2lPV2QhP19vLl+M1MsQw80D1c2Uwx7Db+SuHIYw0AOP3FD2tu6juoY7RZmSfqWMFJPWZNd62U49NNSqXoltiRI4obX8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6627.namprd10.prod.outlook.com (2603:10b6:510:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 05:45:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:06 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 03/26] xfs: Hold inode locks in xfs_ialloc
Date:   Wed, 21 Sep 2022 22:44:35 -0700
Message-Id: <20220922054458.40826-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0261.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH7PR10MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: 526a6608-0e47-44bb-a74d-08da9c5d9a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRL/6tSK7dq9EsDaxs5Slg7TPQ1+FmxVu7UAeRiVHgVWrQyZ0z9DVtOEl+gFe5oKAxFe2Ohq0aY4IZ6YSUDUOzL3y+UtfvM7c6sIbW8vFSiVYmAVL6LFYn6iFaZQLyxOK5Bk/img+PeSK9ZsATGGvAH3ZLIuyBvf2moYzdZeDTu12Gs4eNpjeYFggFIbxNZGJNR/1L93UfWcmVdQDcaTQdfTnZRA2variyUlpZDsg+3kj0+K0P47BNdUWrpuen+YO4dLT8VKjYc7bjEv5d2QQLXphRKR1z4pu4dPAwPOplOUFLD5lE+7DnwinhDe26RRxc99b5nVUIu/TmkPwbddBlrz4lu1KlAnDQxGr+Amx8O8GYU3wrnS8N0XrbawuI0PVEKG+tTVouDkWE0eRt7+QiK8seqM6TnxcqoJWIr5Cq2g33t3woQ0UF5X6YaqB+IZSpOk1UqmcY7CAkKb17iMYJbT/Ksjwxhod0K1oC1JCMdz/Rd7b3TqazOqyNiKgIhOxAzlIcuX6obMwfvzcg68uQALajCzNi2ZOphK7CJ49vJ3RaP0oO+o2hvwP+u3eBz6/UMJtBueglI8byikzAiS54VuR1NQ1QAoIOVJNuWldJnEeTJA7V0Bam4fKaa+mTywloB05euhaYrRLLW7gkgE+GIsuru9N60mK79usaZbHBinZfVbSIwM0SrlcJmhCZwRyupwcexFl4bUjWUZAfVtJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(316002)(83380400001)(38100700002)(66946007)(36756003)(66476007)(86362001)(2906002)(66556008)(8676002)(6486002)(478600001)(6512007)(26005)(2616005)(6916009)(186003)(6666004)(1076003)(41300700001)(5660300002)(8936002)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fvgYD4mKxYu/OsXATIkpsRMmJOE7MGgrDbEw2EvmMNkaorvCNumk+xDM7KNs?=
 =?us-ascii?Q?mj9zslZE/wbPcpE/GiIVSMUrA/ReHzImxbeNTjbwdsUc9RaUcgPbI4QESo/P?=
 =?us-ascii?Q?W37KHN2olSB73NiA7twG22plqQfr1bUo8tadwO2P1Au/m+xbExw0smtUefiP?=
 =?us-ascii?Q?DnCq1VgJYGQc/x2iAJYTkB15JiVoAHvX5v53eQZLgzx0czVLiMt5AeNlENYO?=
 =?us-ascii?Q?njdDOHDCjuOB1V0anyxOeT/jNdQIYwp925amnDIy7BfUOTTatxva100AkyMF?=
 =?us-ascii?Q?sOvjt8brnJGks+FfLtiDU/jBvaYxp7M3WsH5QpufnK0BmF6kZrML9oESE/gw?=
 =?us-ascii?Q?e9RzLvZB6haP3r48jWwHCiHvX8pezaxcJVW2ku4uQKQ4Ttmz6JS/AqYlHwmq?=
 =?us-ascii?Q?p2xrJbwvQC1US6R/Ur4tL0Hi16qv1R+wwnPnvAG4N+95AT9QrXc9/DwI1vDs?=
 =?us-ascii?Q?H9Vsm36SSF54IuS0wVKGZGHKn1vE7nkfOIAiwiK+5PJEKB4KO4/Qbhf4chQr?=
 =?us-ascii?Q?rQukhcRya+/I081WmxBAvJGLq/UkVk6zXfBU4jSQMT7S7BH+nii7P1MouYVj?=
 =?us-ascii?Q?xcTESQdLPbDCYnbEL/w3PdC+kNbFwOXMHijDWir2k9qca/vPWLxA/wBNIVx9?=
 =?us-ascii?Q?2fbYkQMCUsUEqJ3OvxHxyONHkCf0VS74WuOyomDbsFEmGNmpOzAvVzkAKVnV?=
 =?us-ascii?Q?07Qt1IMFf+aNANdDtnfSFPJDe0eQyKlNdu5dlnSBoe6hPXMhEoTmZUZyR2zk?=
 =?us-ascii?Q?d9LCAXoZrS8v5Fax1sO/oLIbtzBtunEqnV0OH5KTPZP9tdQpRjVZrgLkQOad?=
 =?us-ascii?Q?yNa43o907C5AMpfLL6mStobqAVKUYMf0eg8sqXPKN7nyD+BXj3l3dE4C14mG?=
 =?us-ascii?Q?xV6wRCW+WuzbNthiY1QGXDcZsoEh/wbO+Pwzd1qCJgXBib66R5Hk8EjUkgWm?=
 =?us-ascii?Q?hxT6A3dVeBSyi1LwzyaqdqRlN2YsuRHaMj5HZ7SkNgn/mH2FZ888YkHqRshy?=
 =?us-ascii?Q?5HzEnA3KlXd1m/y10BJw76AvvK3NyQ/lKoKWUQC3oxZhPa8gbogo6ZDGb531?=
 =?us-ascii?Q?OIv8/07kZ01lj4MqPnz7Ob5EH1cB0YKt8YeP5E4maGfPs7B091RIruSiSwc1?=
 =?us-ascii?Q?6P2drkTe4uW3Ayw9F8j4kacch4X//LJaF6W8Z15SRa57PoKHMjTVci6EENDX?=
 =?us-ascii?Q?sS11r93jPTmKkGFaEH+V02YZcl8EWzjROxq8DjN1D1ZzCkLIJbVkGN95GEVs?=
 =?us-ascii?Q?FNFtIj+61Df/1h2FPPf8AOebiyvX0Dbt5qozkTHbnfg5ynJ+tlNT47TICQnf?=
 =?us-ascii?Q?UqpmUlx1xH5u1vyOh91T8Gvy0Lw6aj5WnkzGrmnOO4aJJMj6Yd0yHVsJXDoZ?=
 =?us-ascii?Q?yxHfZVcDnB9Y4FfmCXqzFfZMxQKCd0XjjTtzKuw1NbyVqZRM7LhpIcCim/Ps?=
 =?us-ascii?Q?Wt6tRFVAJxjzMovEVr7Ent3HeBxgdAufmZwgb1iZmwxAJuhDiax/tshq/491?=
 =?us-ascii?Q?TnWm4eP0B2deidXL6nwhp034eyQ+WXg/6c3yyGFMjsy8ybGoqzkoue7go/he?=
 =?us-ascii?Q?DOv+VQlWbZfCgxzVOMjrq01U0sBHSSw3AIdGHwkZ2EJsUQKMXJhQ4GRSJapS?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526a6608-0e47-44bb-a74d-08da9c5d9a1f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:05.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfPLgzRT4MgwraRRQTQ4bIf2Z+GxQKv18TbwQSRktWOZN35cRidtDqFOt59qrlE5P4wxWwBGjjFrQPaSwUylR0Azmae7zFd0DlngYgVgy4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: lcLdqaF9p5qLth657nwrupbIeA8cgQ8K
X-Proofpoint-ORIG-GUID: lcLdqaF9p5qLth657nwrupbIeA8cgQ8K
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

