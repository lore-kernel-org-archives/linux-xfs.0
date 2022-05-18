Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BBCC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiERANA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiERAMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1804992C
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKSZdl023116
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=t7bssHZx9Z6E8wnFxnD/ZpgLELuc5ltv8xxX5g22hbc=;
 b=iMsVCTMSt4FiI2bCdLLV8VmD8y9yfD6HXAge66EFLiF1FVmdkKYOkxr4ivI7/m1Px9BC
 x6PN7EqiZbpy6WOVjdC7KXoXZL8EMOHh27puiWEmB6sa3iE2I8n7owl76hsdD8PF8wQg
 KIZzUJv83U26WmN/U2IrwJDzBbP3zcnxGcUud3iX8SMgMR6J1pWsB91eIE3640/bMW1v
 MMNJtd6kHc/VVyBIM7rr6jnBSxUvoVG6gx1BWPp6/eigZnTiWglYXSykRibcaqUkk+xN
 a59AJhae9IzeQ5csiPLkKZMS5eZQdTx7WH8+UfnerVTJHh/jb65+rM5VYgCe1uLo5N51 HA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ss4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0BXpj017045
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3ebar-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqCxKk/ukkh+MhFE3bOCLXvYdpEmVi8xq1qT++wbYDEfBa3TakBacF2VLF5RKHIm66AazzQ3i6NRBRVSEf+7QNyr6Qc8xBCjJs2HgBXzkGUY18JBERbFIYc2vKdwQa4mOATyL03BnU28l5UNAAAVDHyGK4G03LGJmbBBtAO77jKERuO0+Gou3H+0BGB9PomDqvA3VBY7q++0I8zFB85XSQG2upfvkQ9IxXZx6QEcAWVOAf+DRWzGA8kUWeQGGvjFDgYbOdpj2KoTNgcmFd/A7dhjUEhsbtHFORpXRYHwvQew9G0D7CLAGTQHAg7a1ZfTuWmcqGAX9wn10SKoXZV2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7bssHZx9Z6E8wnFxnD/ZpgLELuc5ltv8xxX5g22hbc=;
 b=jbqS8T4PHGwURegSAwKImqO/6eeqeMRK9M1hTSLPieO1JU+BiOOAwGjlK2XV58vYNfhNWPVQ4LI7z96jmNmbLRFvqc6nk1ODenag4M3TwBgxFlw0cBasawxFToqmfei1/h25DIHdHZzHHf5L82IKIBZq9Ej35iXsD5fUINEfeI7e6NQR2x+vbesFpSvVGahl0esU2542d1bIrf/PkrNoEao7d0WWRLeUR0uCgvoJOToYO7y7Igi802D0yG1oZDnDUMQYz2eFjQYC3lIqIzZEA8h8PCZTcHdV7lF8rNk1ZD/V+RVeX/O6+xDQgLGglqbZ6U771h0K1qmeOclRge9Y7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7bssHZx9Z6E8wnFxnD/ZpgLELuc5ltv8xxX5g22hbc=;
 b=hc8bqPU/zQrEYypEzYY5IUNDc3LQX6hcxwlCvtzwSlFa4IMMIPA+BRAaIllaHgwU4ljeGRxR03Bzi2X7v6O14spYM/Dv5V6KifdWo/8wogZMdIcvFDBBo4XT6lehBA2+pY1OrFhkHdNYV+zUUQeQtYsSGM8RA2Wkj/n4y3fJfTo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/18] xfsprogs: add leaf split error tag
Date:   Tue, 17 May 2022 17:12:25 -0700
Message-Id: <20220518001227.1779324-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6cfcd6d-3048-4977-e118-08da38631fcd
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15283BC9A2B04F36C0B5FD9695D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0X3qLOiuuxb6cjFWTe0XaBqlFluGxL32NVXti5/b3uBCZzah1MMlvEhHzQ0J+QUlxJHKFY6pgIQ0K2kZnOepYXPLmcgzYt4UD9jyT/at9EJCuYjF6ohAIxLZ74v6EFoIF0+AFq55ln7k56VsRKMyEyaRxmOpoEhV4rrOU051yqhmTJS2bW1+QpKkzo8cSzZXxPZul3844Pre5j9YeIhTKKKrjx8fCb62jwl2qWXAHbg7EKYQINozVTNQnTmSdWPPwYL9WpkkY8IS6UEH2QM2ikBiwcDplRV9o+PtKi3jHrz6HG6zKeon0p3c7igEQHtANY6r/WNkgP495jdUXWM4SIcYphGQzVzfass/l1+GlcErh67bkD0cB6YC9qZRM+gY6aXH+94tNxJdELIrP3w7p7IxJ0Yw0cFzHcD87/qfszFwI660VWsWe1I8hj3xQwaFWQ3urOGu7bx8096CUX3i0zNRZF1GkY8ZdtETbAxXXNmmlqQNafx0FJqVwPvixZaqJERm6rupoY02jz7rBPc06S2Fma/rTPDmXo/S32sf+lSG2WWvDvyTJMRxexd8rA+ZdBWDF07G301Bt0JcPojfcNO6kRndOyzE1RioMGjmTKhYFx9vNRnWM5KLAnO2zzZdKebGQ2G+RyLxtr1A1wYSHgU1S8y51qZ0gEwOR8t5K/TjFilj1kYbcuzG8403pHKbYya9dYlYAEcJ8KjuFZswqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iz4uhZYfhhbniYUBz8LiNmEiuDMHEXXd6lkuMi9B9ldKFs6X9VVHTcjTydH5?=
 =?us-ascii?Q?rHmK/gMDBejZYtHu3oq9qrCHKX12Mu5UvvrLt/lhIykxrp3HcwdMGkno/ySv?=
 =?us-ascii?Q?4KM4Q6Xi4YyarksjZemoEx5lJ859olR5XQLbz6h50HBpfBZwonnAAVRFu/Rh?=
 =?us-ascii?Q?E1wqGa1xUYHRsQFrudaB+yn6uSzogEZrbdlt8Zaiqs7qDb3kfyGkgD+3ixKK?=
 =?us-ascii?Q?69ETxEN5IJwM7rYEImwp3UYGUs/QSB93YqZZQPkvRLNp9rQujS7OQ3r5DVG8?=
 =?us-ascii?Q?7AxzMu1VsSMk1UvhDSM8E6Sp61KHeuIVOF+0kCagFoZtrh9gt1vcwJOtJqvI?=
 =?us-ascii?Q?JME8yMFLFcl2CmOw0yJxB/luio1zwJrjZiLvNUDth6fswdTIAEPNNtFR4+0U?=
 =?us-ascii?Q?zL9svpTWWBXf34e2iLTBUzAxnoMMAuTst0E1ArpSQT71aWJRWpRm4V0l/e1A?=
 =?us-ascii?Q?UkGRUciq6yU2uz4udYqhV0e2JW/yvad2cTXksMK6+Gz+ofUDIJRr6VFNipTm?=
 =?us-ascii?Q?NObU3JMHLJoEnAe9fYoaOTIghTAsVork8cQ61OV8Jswjl2MNflpl1Q+ZQBbo?=
 =?us-ascii?Q?FjDPb/EYWNEQ8P7v0QpEFah1W8YpKfiLseaDp8zxF0udNsY4GQGjD/ovpPK1?=
 =?us-ascii?Q?yy9EOaAVpizkGNFgUIBdR7be7tE944D1oOdfzfTqvMlfE0fj8z0qsxeKRq0u?=
 =?us-ascii?Q?Pyj4ZWKZsYKZdHaDdA/02pS0h6uGosZgYYMnMBbJ7xWktUxyG2Zg/Vi7JiSu?=
 =?us-ascii?Q?9+keUFZX2gmfQgvX//BkHpsX/E1j+W8h9w1cOw/UIAGRmy1BSoa7Gl7SHvXT?=
 =?us-ascii?Q?V5+BLrsuroN2quOB2DJfMdaGLXGvUs8y0ZeRzVBmAbp4QngXVZNzxbNTaMpm?=
 =?us-ascii?Q?BHujyij02eMFtcshmW+Ot2l2id33AjLiHztfVdaFEntqZFkNgM+1ewbxV3SV?=
 =?us-ascii?Q?BxGllmRVTDuytIkRo+W9p8jFVbPUG0FKnOvjvjNQlM7gTZrpqgcrPayn2ZSD?=
 =?us-ascii?Q?dsb5XtkAaeK9SF5b7ZX+VzFVGU7qCPw+WNHqjDhHx9WmuhWVvYGwayNiFb4A?=
 =?us-ascii?Q?zTqxU03ftYoEhBhkmg8T2IaUtaDYbBWSafXIhD6lQGI2nVA7/htrwF70r6g7?=
 =?us-ascii?Q?pMG+QY97Qx1mUDWT8lE459Rc4BGc2Oz/MeY/ehJTMHM0QcrV9aod1Y/X9LvB?=
 =?us-ascii?Q?pY/yofaTlkhuT5jHS+WBmjRKwPWweRBNKnwlgQBZRd2+eHstm7o6mmt3ygve?=
 =?us-ascii?Q?ZODyLd1HnVpz9fJ5VBJxofPpJk6i0KPa1qtdjA7TrUJd8q791I5bHOHuS3Ef?=
 =?us-ascii?Q?X0tODNnZy9w/r+rZqQE+gcqTnyBBQTsqHO7rqwmeW9SWFFa77vOwsk3FNDzG?=
 =?us-ascii?Q?6hccf8Vwz/E1lotRRw3vjJOIlXKUUqGJBoURBTBv+Emhh5QYJdIOFl9jxZ0X?=
 =?us-ascii?Q?V01LA5h57Cpm0TseRfiB0ooDnpQba8WGjv79JtP7ur7qi2Xa26vjMTyrb3+p?=
 =?us-ascii?Q?RxjUvrAPzi+TYBk7nhi3c6iexMb7L3u5h+wsXeV6cvfbTiqfJSoD7jE3XnZL?=
 =?us-ascii?Q?tAv39uIO48M8IB0c1wcJWR0dHn1+XOZbhtrSc7GZW6tc00FB/6ZHuRX+YOC6?=
 =?us-ascii?Q?hV3U7zkvV6w6OnFHGs6GZbfgh6Gt+rJfDgfbE6rC6uxYdMblAYJa4pvwb1j7?=
 =?us-ascii?Q?4ywwJdzgDcWXUi/IQNRSXMAFJpTnGZso2AQHVIseS4qeV17eINQZG2XI/K+O?=
 =?us-ascii?Q?6LFxhXhhz0Odvoal4HVyLNt5wGirVuU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6cfcd6d-3048-4977-e118-08da38631fcd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:41.4568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+5G0dIaTy6SF9cZsgIpdBs9ojNXXp+VFdWvPuNsvuqkb1N+6wXlblj9hxX0ZPX9IcgLyIR1gR4X+/tjUzBCHlIjIDfgPCALJH6yIO//7fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: JbWqO-b8KWycAK-eIK8MTRItrXoxf3mF
X-Proofpoint-ORIG-GUID: JbWqO-b8KWycAK-eIK8MTRItrXoxf3mF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: c3b948be34702a0a81f10662c4040e500a90eb54

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_da_btree.c | 3 +++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 43b51db5b9cc..a7ad4df44503 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -59,6 +59,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
+		{ XFS_ERRTAG_DA_LEAF_SPLIT,		"da_leaf_split" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 1f39c108782d..7ecbc6812725 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -479,6 +479,9 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
+		return -EIO;
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index c15d2340220c..6d06a502bbdf 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_DA_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_DA_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

