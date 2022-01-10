Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE02C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbiAJVaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:30:00 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44538 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345255AbiAJV3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:29:51 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJm2co026237
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=bdBnVpZZfPyS2x+WAhoa/2aLGiPuSxicqPRY6ZzvN+0=;
 b=x0b1aPWPbIeIAyJK09apSjipzdywP5ISJ5sfRgpDyhAO1gsl8WkcC7HCDuJeMwHfSKeb
 vl0b71BxROvhZbLoa9Thqa3LHCmm3+eL0LEtKjErfBaqvmvCBDoxfRKFQU/Af+O1DHbZ
 Bo9dEL4QBmt7beGofvdfQmmQXFhBg5JOVACjJSs1S2iudot8ZiftJjAC6YE4EgFq/OQ0
 cbLpSZmiLEj/uDLg6m68122u+hhugsnMEYz07xvqGI2cHDcUXN0fPKAHRZcrPeAnEV0R
 Wyp6jEdZgGqGMOtRFbFEgSiWa5u8CBuipBDR/zDG/IZpw79orgQZUWoLNiI2H3tWURnu mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgp7nh88k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALPp5s155517
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3020.oracle.com with ESMTP id 3df42kktuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFnRUbTcCUqGAjseKB3g8cI77FvYr9xUhKV/DEi+hvJ0MB4yAC/yqAI4FJVM95b0eB4jexVOpAKsqov52GY/kXhVnhCYxZwIdfAa1m46dCfkTSm9ULcrHUAcUky+2psRRhymq4/49QwgqeOh8AN4AYUaDTz8qmbzVgc81uemDQoj2wownwglAojJVnE7SsmgnZ98yxyl/GcOpWEd3PBBbKAF8ifcOd+VIloLWce0BjZv/Em/Qdz6KO7EqmD3NnMXdpRQNR++iKTk7StMFMAIqnlec5CIs/2yNpKUM8n6y1RCdBaVauq/I9ZDE8eewD/002kpw5Zf5ozmDwQxGaVEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdBnVpZZfPyS2x+WAhoa/2aLGiPuSxicqPRY6ZzvN+0=;
 b=I9URs1zBPAtTz+CLDqm6qO4LN+6vBLjP2QkANumz0ky+nGLIADmkQTzYSLMFzRgIhyrjxYRW+0F/La4N2SGZ91x6oNw/f7QsnSdf3MpZp58jjDVNJ30/HIlP4pEe2ws5FThTdV9Ry3lODU04xUD8wFrf0II6dOA4O4eF0MMplf3KzkaI+/Yb60M++5mQe/REv1aRH6x87lhZBRGF8eSi8U9hg9xwdG+Dx6mcl7a69gJSwYT8otTY9itdUTK4y2iF6VBKsVqojMIXil20SBePVQ3Ev8y5L3fh9gvMvH/+iFrsQsWBmy7SFf7FMRZ+CUxvQUArhNNyQPcPOiJYiuNO1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdBnVpZZfPyS2x+WAhoa/2aLGiPuSxicqPRY6ZzvN+0=;
 b=fPih+EBy7wp3fjyNmT62m3hgurKvbFobooj4262i3UTVgeU+0Ph+VDhB9Hu8Out24XWdZBup52rRjv5V7O9aVLm8rN/5RxO3x4ajRObxAUHN3n1hxceZy7O++opSFrIIi8/hmYYAmrs6R8RuoVF0+3eJzZUKR7e42Hh+FeU02Co=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR10MB1484.namprd10.prod.outlook.com (2603:10b6:3:12::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 21:29:47 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:29:47 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 1/2] xfsprogs: add leaf split error tag
Date:   Mon, 10 Jan 2022 21:29:39 +0000
Message-Id: <20220110212940.359823-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110212940.359823-1-catherine.hoang@oracle.com>
References: <20220110212940.359823-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:805:f2::42) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b952b80d-f77d-4d90-a954-08d9d48053a6
X-MS-TrafficTypeDiagnostic: DM5PR10MB1484:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB148408ED993DE6C221591F7489509@DM5PR10MB1484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNbgiIqiyfSenuMDdSA8b828OLMTBhNSx9OJTde3jAz5supB7p0eS2BvdXGURIa/MgAch+TNax8grKrSSUn+0+4R9XjGXv476rEa2Gt61Qcy31By3MRsSmZik+h+VKyGhvnXub2lG0KR50ASnBcOal13SQiZEFtNDPnC4eVqIneJXJIzMdW3L1L3cYif6jvOpXmaBgcpJg3UmAVQvHe0hm/Om+YioATbmP0GW7SX0IOEAgG3t9rWdCmuFx1GU1AG+f64ZDavpSNF1M1qe4MMe6JwsmqDJypWfmv9AVxldBa4M1HVdgNZC0XM0e7nDdbuZjNojhDwNEiYAd5+usnTwtF7JpEIt/gyKseRMIOZLni6E9HgC+HLJU+oW1Y7LsfXFw1JvquWFKkB0V5SDUVnHsn5bnLAQc3pqcdYm8dxKqacx0qiynV9zk794CJGAJiYksdiYlLWEtO1JAcJ2pQX5rAgpeJkVQX+12h8BeySkV9aXjwHCXvwjlblFPCn70I7djB4GB5CJRZHqdqdAp3FY3Lu1F4YayfVrIkf3nzxizpSe25rVhPWzKP4ejSHU5GNpoVhvB/EeKOC7sX4TzS62eGCicy3yl/u8KRxVx12AGUTsycrcyaor/b2SRHXN56mngxZlsOSr56oRLioFIRlTCPpaLyNcEfPp/WZVoWKdWwg1He1THYfR/cyLMYayQIfEFFviYitq/5Veju/MW4RyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(508600001)(6916009)(66476007)(2906002)(6486002)(66556008)(66946007)(26005)(8936002)(38100700002)(186003)(38350700002)(52116002)(6506007)(6666004)(83380400001)(316002)(36756003)(2616005)(44832011)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S69E6Gr7a9dBUH/vnCGCLIplshuBa4fjOSS8+zBEO4dqbm0WrHcEuqM1yVh+?=
 =?us-ascii?Q?dFNGbz+h6VDoX97j0q45DgVmmr5Tic4lOotwRGo0cJed411CIdVXFWXfDiiG?=
 =?us-ascii?Q?w0r+zy6wEY0ppiKu9iyqcATJUgTTLHu8+UTRKbILNQpP7gM7zam61ffe/GSM?=
 =?us-ascii?Q?9qG84hL4dcfgpShZ5evnC2+XF1elNR3Pc8dbAhfCU4RMLA5O4qA/sg2EAWX9?=
 =?us-ascii?Q?rr4h/q/w1RFXFS3x9T3t9B+/+PhdM1U2HPP5/K6CO2/hCgwqy4Qaj0qAhVFp?=
 =?us-ascii?Q?8xUYQHHPWhEfL9CYIgAbfYso28WYAQYyS21PKk3/UzqhBgvJlWX6f81gcRaj?=
 =?us-ascii?Q?7qnM+Gph86IRpwF0GSllfnLtyTiH0JbPN6DnP4vEfh2Afo6x1UkLsezEZPHl?=
 =?us-ascii?Q?vO32aHZKT5QHv6DhIs1mIHmI3jR3wq5TKdouN6ldpyZDwmDjn2ePMkO9osoI?=
 =?us-ascii?Q?Wus+OT/cDeNozk+4alWtrGoS+oZFubr0GLE/TsEAMBKGKSzBI4dK7l5xR4yS?=
 =?us-ascii?Q?7QExSs44hegrLvqnZANuRXNsiG2gJxGtm9G9QclV12+oV1Tp3NIbWETxPf9B?=
 =?us-ascii?Q?ID6nl+GwR3v/nE5VfpoqPhSfEnS/dbx4dYAtdvf8bS4S59m5duYjP/GP9FSc?=
 =?us-ascii?Q?xJfxBXkQNq5mYDCW0427Qg8po8XRrnE8yRQipilq81YhtW3agm0ejXMIYoYw?=
 =?us-ascii?Q?AqskIrVrAJy/SgT3rTNuzcHROEjUdRjfwn/RJyLjFVYb61y7F6CIGuqkRvYN?=
 =?us-ascii?Q?Kx/RwY/pBtuSt1ghThOnOr9u3aQ6J2Clqor200bRy8LwuLYriyqJHf1UAUtQ?=
 =?us-ascii?Q?hingzGYLLYjLvRpj6egv+iFzISM+mgsp/UJUuiG1fc29oDz+yP21/KuWQVSc?=
 =?us-ascii?Q?PXOIXsee3o2RayMgj2C9sem1rySTVUeGFDZSpBsdRkwe6R4L9vn49CYOAPhi?=
 =?us-ascii?Q?7HbPGVSClJcpkFABm/Qv/fWupjndpKIu5w49Z8N1reJ1hz6kAgqo0uRtx+KP?=
 =?us-ascii?Q?c2tUS4HJu7G8raM8oix30TnD9CPnBVp8SE1/M5KvrvxBcjaVRp+Ex/jXxwFD?=
 =?us-ascii?Q?mDG54vzNmLELhrF3m7hW7xhJlYn2stJdQVDe+CI3IdHkQQf+KseE7OQO1X3w?=
 =?us-ascii?Q?Qr6bC6Jz9x0p9NpuV+cnqTpH/ohTYrHk8y2hishqPYBhL04tIvvArFJ30x6/?=
 =?us-ascii?Q?D3kkIlWmvZ7GPyxjap0RfvyYgs9jwU/A6Pn0OA2No/B8FqvTa0xjhYG4qKvw?=
 =?us-ascii?Q?VEj8yTod/GJ0TAxMHE46y06/NQ776rOP5Krs1nGS8dup6oRqWAEwEpYPSEfo?=
 =?us-ascii?Q?ImWoCqx2mQg2H+0s65YCh2y8TCH6RhhXQrdHwFZOoqoK5g3tODMH0pKlERew?=
 =?us-ascii?Q?Ce/BwuxqLVVzdOPvYyit0zbkWo05ALWOyMnlOPGrXdM4gaklpyGbKBIhRkRj?=
 =?us-ascii?Q?sYJnQNHhHzsDaE6ZTKVAZElKwwak6ww03UOpcHAdoze91wbInhWA+umglVmW?=
 =?us-ascii?Q?Bw+6X4lXW09GKE7d90ds9hJjCJTk7HiuWu38b2rIXlipD86uqao1aVnC/AM2?=
 =?us-ascii?Q?3hOAlqwckFyJUys0PYDolfra0/Ny2qs4rekrgx4neJg75x93sHetwxhUzwXP?=
 =?us-ascii?Q?8FUNOpXff5IOBVZO5/bZ/KBrWBe+xSeCkni6rhPQhpqba1D7kWmc99yXJAoq?=
 =?us-ascii?Q?sVyM4w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b952b80d-f77d-4d90-a954-08d9d48053a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:29:47.5678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ipJur7dLR4QYadBrNrhMcc8z1/bToYBGPuVSKrm40tyQvjsIP+fyQJ417W0sqj95OZwpUToU91aAF+knPUEaiF2Cz9xeI5PdRtYt3Xy/zY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100142
X-Proofpoint-GUID: U2kfMfOVXpc0tGOhX3_WDdgRCya5GS_C
X-Proofpoint-ORIG-GUID: U2kfMfOVXpc0tGOhX3_WDdgRCya5GS_C
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_da_btree.c | 4 ++++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 43b51db5..51f3e2da 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -59,6 +59,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
+		{ XFS_ERRTAG_LARP_LEAF_SPLIT,		"larp_leaf_split" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f4e1fe80..e17354f3 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -479,6 +479,10 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LARP_LEAF_SPLIT)) {
+		return -EIO;
+	}
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index c15d2340..970f3a3f 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_LARP_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_LARP_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

