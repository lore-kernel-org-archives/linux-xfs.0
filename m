Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B170C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiB1TxH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754A6CA331
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJHVA010129
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=h5DhRca4zryPXrcoZOXKCc0lz+98mokyw5DgOaFMES8=;
 b=pFuAFC8Py0zMqLBXfaTvGPWiOXKKpypUBsZnJbOGFARpTWtFkqmOTaN67OnMG5XO8JUp
 fxMq7fGg1nDYlCEa/cMM6VysHNaG9eJ+XoHNP2TZZWYTk8ZXYCaPOKBe6dLCSVyEBRpJ
 B3ZeAve+xKDqG018b8DbNLXW11a4SPLhxCKA/R+4+3Z44ppnDTjibSz+GFImAuOjILUb
 +JWpaAwTiEVUSACQD9Wy97az+7az32vi342b/RWqZhtkI3I8j2VPWFdNWZLhIMd4HM+0
 Ri77xvWV42gb03GVDfZpC3kVTIL/5blqQC1iuzFY8n3C28qgUrxhsxTIHJx3kBVgUopB Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJjsZ8061244
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 3ef9aw0y4u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGa21l87B3qv5kVftaJe7yPzj1hs05mL0jDknqzcWgEbluzM2etFu7p8QNfXLMDOK9X96s8nxlakX43R6oOjcsE+x2kzf+hisn6UTKECyr7M3HLeIzt5xqClSi8axI/+4Dupi5Z0TvBAHldPagiEM6at4gvzlB0MnoOytxrqFfgFLuXBI9bOIx4yMMkpyR0Mjx7soGasBLcnw5BsK2UrI4N7jzMwwErRVd6bWvoYvx1MVnYbAzJLzd/UFQCGoW903i1R1AvRlBbUHIF7mJEM9HqSyNI4h4KmLXQTOMnlhN7hb/ImEtjJHaDQ89DUbpLTzVCv45h7edFN5bo1BxPZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5DhRca4zryPXrcoZOXKCc0lz+98mokyw5DgOaFMES8=;
 b=MiHmqDaT3ca5HJvc4SoLVf3TXVReg7sHT2Ag+wzLSjqQkSfPepadRpeBBoMkDp4nE3/NqRj/pNXpcdFDzIobYagqdnwLY6bhCTGlSHW6Hv454PglvHLahoQEC0FyidkNhewxM/4iAAyIjAkoPfSs2WYp9tajAMughWHo8RZcffVNpiGhC459WwtPapt4YdrITrXwN/iH/3mkDhmIByTaDhLitpso0O/dwg0j9IvzVTf/gcsrrvh32Uvpfm86Y58tqoNqDc58W9Bywn/tK5RIrl3/3vM/2nk+4erlie/goJhsLO9fgoliifq5crB+YldYznktiouvxwwX6wFmkya3qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5DhRca4zryPXrcoZOXKCc0lz+98mokyw5DgOaFMES8=;
 b=E1lLuL1jUCLYIkoPofsj+lwJ/9zEw/3RB+czuaSxzpFRmuAyFseHO2yZHu7DuWk28jFoxzE8PP7xHgIEU+6Izv7z72fmRaXduaQCupokKh1B+s2Oe0b5ncAAljX3CaT4nn4fsg4o8z9ZlF2BHvs12pT+IeWYvCaHLDphoqhnTYE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1732.namprd10.prod.outlook.com (2603:10b6:405:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Mon, 28 Feb
 2022 19:52:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:52:00 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 14/15] xfs: add leaf split error tag
Date:   Mon, 28 Feb 2022 12:51:46 -0700
Message-Id: <20220228195147.1913281-15-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 44495aaf-a68b-47bf-f4ff-08d9faf3c827
X-MS-TrafficTypeDiagnostic: BN6PR10MB1732:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1732AEF52255DCB98FD14F7B95019@BN6PR10MB1732.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aVAzk1gKuCbj1TOYESjOI9XkJyADq3d2cmOFdrCIL5cen4o9bsNRq1p6sRPEwAVIzMdbV3huV1CCyt0NDF8Brb89/NyYCdB1mfuny0JDRJ+qSTV+d/+nPFMBzA3m4Ccq96hrUCWbC+c2hGjd6AIdYUoT45SR4MMBTxLBtexNyGSjoiN/mcX0L65bSGhmDqphd4k6wP51C4sDEw9SJnv4LsbynRI20BPLELDb2kOOjP+uJGF3jbGP43mMINOJDNHQr4Fi5f/iogOJiMAqQn1/1LoUATh2DWmhAHWLzU37D0Cp/4Q5LzEHWGuhT0NU5nheuzvUvqEtVQZzk90P7DlxOpV570wFQXmIi7OkCBvLSViOAswCD4goiYvEYi8QELzBFlvL2GWQEMoAthfzyIAsJ+S7956G83rEf7ZhJr4gdeetc3o/m+UfhGB2Xdai5tiOnu8GRC9/P0jjOV46PgxNsOi5g2TVMKWNZzQxLYZvvrLsEcJb6ixp9AFEalgi8CJBaHevsCive+UcR18amvwBHT2DyEcawH6Ab4UYgU3525ooy+JkesrXnIM9f3q45dfc2YnMWqGRJqRo5quFwMhb9CswPUSouivPm5CMmDN0aA7I2u2WNJFea9VvWoQ9/jVDB5rz5T9pTY5TkIWCWmmxUFlSqy5hXByyKei9/Z6K0hERkLDyvkXwormQn7M6vaW+qLRQQMzG73Xt6NO4olmwhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(86362001)(6666004)(1076003)(52116002)(2616005)(6506007)(508600001)(26005)(186003)(83380400001)(6916009)(66556008)(66476007)(8676002)(66946007)(38100700002)(38350700002)(5660300002)(44832011)(8936002)(6512007)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yXTglkpD8hzgD7WofMbtXwJqWfEccRytU1h9Vr33En2Y+Qi58bhKJFFrVdd8?=
 =?us-ascii?Q?jjPM9neKhwyAJakmTKMmq23HVhl4FmIRzbE65kdL+oESUX4lCS9IIXNXyWvB?=
 =?us-ascii?Q?a52T2JNuEWmduJSMv5R4MDWOIlPM+3RkByrg4NJZTdK1CJNP7llic8jnBNdH?=
 =?us-ascii?Q?EfjwJhhowY2lc2/2N3gb5bL2XEmFeeOJmkJ6/p3b+yDyrcRXv5k/rPwJuPBD?=
 =?us-ascii?Q?8+GXk5JMSHlKMx05+dug178MYiahJ9MD5R85W+n/jm8FEGpHj13kkWZ/70yC?=
 =?us-ascii?Q?1bf3FlyUVXm2/4IPOw3aya+HuTsXGGcsR2kjXgYY9GVCbGdr6MrY1XOc26Jc?=
 =?us-ascii?Q?pPpO7KvbK91JzoBqjGheXqDMlIcGHsusZA0Hi7PNJUw5pYM6dfevTRajV4vB?=
 =?us-ascii?Q?sgj98JnB7hFv7DgomcKh+MFTqEPzdIoCp0OQkxok8LgUCb+MdM3hUdhG9I07?=
 =?us-ascii?Q?jajChat7rMbN9a6gMe5piqiUs4GE/vRpY1gaE472CjMYkTJS9p9PIvQ3jn2d?=
 =?us-ascii?Q?FKZgsrIbwAz3YlEGgHESmsf0sDGwopaK5G2NjbRbDacM1GY04xgJJAConIIq?=
 =?us-ascii?Q?7ZPgDAzRcxBDWoOOc5437Xv+niI0hS8TDFNEp+tPnq+SuuTnY+uvBiQOfeLD?=
 =?us-ascii?Q?3IAdRtsHTKV2SWXXwOLJUEDWiQFwcJfiY0Nf6VQylFITwkm3xOYulyxkN7SJ?=
 =?us-ascii?Q?DbP+kNUle7Fe6Esdw6aWMw38bGZrZ/C7vbv7Ww1S4zi0ACvB4PbjZTWBgMZB?=
 =?us-ascii?Q?smeFcV7ZLzQ7f921ithdW23Ypx9sV4CwXVvpYYg6oGQLGuFtf5RHIpBbQHeT?=
 =?us-ascii?Q?9mjGgYyLs+NriOAZ3GwR+YQTN17OieHUfjhwvFH6zW4QdGwfKoDOJJDd0pPZ?=
 =?us-ascii?Q?dR39gCvDnAmc1mjiOuh3dyr+Oez7P4Jifv/2vswb8w/mmS7W/Vfcd8dpNOWa?=
 =?us-ascii?Q?PQTYmQZng/mJaCKEV8vECx2RJsRZx5MLk7KN5r5cyEk3pJlmspiyefJr2VAG?=
 =?us-ascii?Q?/3TLe5yBLqYFy3CKcqMYGOcIcd9IMf6wkkAS2dk0gu5iMnAFk3uaGMD7SADZ?=
 =?us-ascii?Q?Y2i1BPTYnvuBXyAIBfN7pmPbE2oiQa30Hr57ES6bfbQH15ymHW+oUNga3Yz6?=
 =?us-ascii?Q?BCPk2Mt57lWAaFzbQTqHL2F4WTsUvd1gQ3FjUUVlP+D4341SpQceK9AQ5eeK?=
 =?us-ascii?Q?20zp2T2aKyh9HoCYyINP/VCiV5VaNIKN8IrvdeHEgA1Qh2S8bohHRTrrIXk1?=
 =?us-ascii?Q?0xbrvJ0oDKWe3382FlBxC+rWt2+wl8P1VnYAVy30rBca8nO0sMvGAmt1Cdn1?=
 =?us-ascii?Q?RWmKJA918lKVDp1rXvA/UADWRjTLZ2/FfEIirbAIFUl9js5PCSEe+lX342Pa?=
 =?us-ascii?Q?bRbYWlIYhR+ZxdyksPLclAE091B2KqLIomBqlzwBzhOa9ynfsR+wooGGTWUr?=
 =?us-ascii?Q?IGMO8hDZpt92Me0AgtyZYQrNNQEwKqlnYURa9au8YlRRSukna2VY5nu9U0IL?=
 =?us-ascii?Q?U1QLE+QdEbuf0Yuj1ciUM20IezS3/5fe3PkBPeaLzQ7/qpEXkIhR3HYAt7qu?=
 =?us-ascii?Q?pKeIuPyVsgvTsZ1OA+UGFWB3aegT56lDOyG+DU7hD9osq7S+plVxhniHrCLr?=
 =?us-ascii?Q?KGKYcP5/lm0py+/SZg0uinPpCHpghrVQZTH1YQq454VRTyivpOBC+UQBYNmZ?=
 =?us-ascii?Q?yZrpcA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44495aaf-a68b-47bf-f4ff-08d9faf3c827
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:59.3256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUHMNoiwcYmo9NZgN22g+MgtS3/PXbqZOpaqWyr8FyNZgscbI0q/51qr0L5p4bfrVVdIvQNa35SF/MCXl6jAJnnoGNCZUczPgdcd7/XEdF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: _dxmF-_BasnBsg-aEJFSd107OTZhOewN
X-Proofpoint-GUID: _dxmF-_BasnBsg-aEJFSd107OTZhOewN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 4 ++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9dc1ecb9713d..aa74f3fdb571 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_errortag.h"
 
 /*
  * xfs_da_btree.c
@@ -482,6 +483,9 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
+		return -EIO;
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c15d2340220c..6d06a502bbdf 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
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
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 666f4837b1e1..2aa5d4d2b30a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
+	XFS_RANDOM_DA_LEAF_SPLIT,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
+XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
+	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

