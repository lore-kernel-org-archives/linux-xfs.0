Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAFEC25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiHDTkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbiHDTk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3445B7660
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbeAC021081
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=4tYTG1i3xl4YL9FHaKHjO/ZrgsZjMgjGS4H8bMNkzko=;
 b=2DykWC+rLzpsXF36AXf8yHznn6WAwNbKz4UTYSGnmW18t0oO2Zmb8ob9nIkkwdF1Xv0I
 /vRt7QqgrxSwByof1PVGz88OL7tFJyRAZ7wng8Tm+uLYsHLoT1fiv3KhktQm6GBPdewx
 frPjDjNkr50ypzbEHIOYNgzwHUaZGwZd4BmlXuVj0y9HHk2iHAGzxcf3fDomTLGAvq5U
 G0sVtKLDvgYGDCFYRntlWJ40MgPCh1E7qXX3Ssh0Ffw4NQeaBKrLKKqfaEwZANNMdNJf
 HlfC2qulcL42LtbMzqHwLklTMkz3noQ+sjMi2JkHOfmwHLJp8l3WMtI0e640UKCJZ+IZ QQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu815xrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IEkVn003021
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34n716-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCIIyr0KS3tk6D5EM17tCxvnGPRObOHFtQnRsy8hZa2lLUpvXHqP4+0XfFjW56Agsyi7ZCiz1GEd+f7cebXRTzONOpWdcWr9JbJv8MpSaOE8B7lTJdVzLZi/lZKjqhDrnJ1mJwqL1CSdcp++K2Fd1T5Noo77pXbOeet0Ri3PU5SDTl6ljwFO1co6ORtsaVcnXhOl29E/vBXkrzY/xZtkMkPW12evBuC0r1RcjI1LYUIwL7tOqqn92dcqJuCs5bQyi1kpPuIngStRR+RWJc9cfh1rKC0gO55pIo2ypVrkCHMKs8zBG4jDWjKlT9xiNAxgIjYG5i9Pyxrt7MGgY2768Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tYTG1i3xl4YL9FHaKHjO/ZrgsZjMgjGS4H8bMNkzko=;
 b=EU1CqN2a1biRxV8/4PrNcePrP1QwZxEpdNCa/7qFOd0TAEMLrujpC+q7bBOfDE93s5pYrefxo5BVv87ux0YE0Vsp+WMVx4y7v/O4SzE2ZoBVOyAIAfHvMTpPdl4Tm/MnYO4/y9gipL0kpvxxoQJ/KIy12ZPJGkmy6sLTlWhhYYuihsH2gco9RDPRwZrP5ZA5i/z6jMTMRGAovewifLgQn/bk4dgZ53Fl0GGjKvL1Su9lV1iZpOZSHwOQJ/ByqdQH68S3YukA1YTV6cLSnxcNxrhB0bSQfFPEfFrygVTzHxANbV100wfPdUJiud6v99S1Va+npW5petrlVhjYYMPQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tYTG1i3xl4YL9FHaKHjO/ZrgsZjMgjGS4H8bMNkzko=;
 b=Ql+RYcAl8yx4HrvdO/12HEgzOIG2EiH0X0fQ1oehOK2vaJMgB3Wx8Z9BccWz6Z3bQUwq8pwuBfnghihiMizVkXim6g5ykPMgkpMP5/SJ53p6a4Kfsxcfzb0pdVHPRGHka0tJiVFe0WYfmaAcU0FsKnCXL8msOjxAcXFqc9BDj5Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1368.namprd10.prod.outlook.com (2603:10b6:903:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Thu, 4 Aug
 2022 19:40:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 03/18] xfs: Hold inode locks in xfs_ialloc
Date:   Thu,  4 Aug 2022 12:39:58 -0700
Message-Id: <20220804194013.99237-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77afdf75-a1e0-4395-8a03-08da76512b66
X-MS-TrafficTypeDiagnostic: CY4PR10MB1368:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/X4QOyg2BZR9FzCUadaFbJl02GkaCmYcOqrp8FgeiFRLrRcyjrbqnrY3tyP5hMwrS8vziF1RthcAAmsLPC3kqHLHLQstJRmPSCfDr+Kc5L6YSOVJM/DIoygGETye+Maa6l/F1AsymbZh3CK124q0KRNxm0IVnOfr87iGDkYJ6/PWFuLuJPkO4GnpVvzMaTJ9zZ5xRzfVeHSYWG729lht1kKTDHCoDk5/6aNhe5TCVTBWLconvMbfkUlWGO620DTIrSxQ6L5WKsjbAaKBXVkxN+7ua8TmpNyUVQRrxdIOlVyAaUE4VV7qcgGAsfK/qBvBhmjxTH2wWOd3wHO1Fwl9MRZGkyZ5wPeK1Ho3kHWe/MNDoUOzawZpkhnVBdKUlElWNolodb78nfbG/mO3HesnzM9wFFCRv6BTKXZU1PVg8lXCP2IkS2u+veehHtkAbY8lnyAKNO0/EIbXgzamzROs8fP2FNC2vdukz0fUTw/2QwR0/zEfOBrm0xbUOktmFurWODVgEWfUfN6AnA1sn6Q22ZUxRTfssM/ZKiDZQTFqsy4s/sZZDbUJyzpXHprfR/QOmrPj71vdNJfqwid+6aDqud0Yq8cbaQ6pMHYBUWai3akHcSsDBdT3pMIBarGEWn20u9gaynksJF2f2ibXjD/dKCLrW2s1oTAQNgPjJmY8jotdnAufYieU59++xF0nTHLBaOfEHqe2aJ1cWIBIlHR6DEQj5yHQiXQoP3x+HlE8hcUYEwYbPrubSO4zehaRwd9wkije++jjDqTEkxIJEfjxSLkeQdlT8w+XHsj4wix2Ss=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(396003)(39860400002)(376002)(6512007)(6506007)(6486002)(316002)(6916009)(478600001)(41300700001)(52116002)(6666004)(38100700002)(26005)(1076003)(83380400001)(36756003)(44832011)(38350700002)(2906002)(66476007)(66946007)(186003)(8676002)(66556008)(86362001)(8936002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n0R+AHGiI2TZiX2J2bc3Rf6TL9Ef9MtJXIWgp5Po7koHE7UvDrxpl5bpOP5h?=
 =?us-ascii?Q?voXKdyjzg+Mo1nkzEsvOC2MMHpWfqZskS9c3dH/eATrzocwmIqyuZ2jB9ttH?=
 =?us-ascii?Q?GmgI0MGToLghPtZw28A67hEJYQQ218JFSh9MIOOQxGQQVBoA+N7lmeQoQ/Rw?=
 =?us-ascii?Q?gL+KnlypfSiDqb/xe4YG8QipL7bnQ2FnFWIvvXCInszGasBurS/OXumWR4zs?=
 =?us-ascii?Q?ZApgkmU/VXF2mCF6GmlmA/s/5AlDCITJKC5ezbe7BwYIRMZAe2vW5l/ajzQj?=
 =?us-ascii?Q?FqvPSM6Nm07gsgaefOsk3TR2y6FT/eaKBWodogRQpr3OB03F9eLsjyUpORKs?=
 =?us-ascii?Q?Kzk5lof8U6t//m9EBfA7mzcUe9iiq8lkEk7XYlpFmfQZftQ6d1k5jl6r60ZA?=
 =?us-ascii?Q?/r9ggmp12jZMMs1dutb71yUfQGpHQ24IVfyUTUCW1vGad4iZkW0Sp7yZvDt1?=
 =?us-ascii?Q?ZXY3hWtdWpB08i1TnTUnUs2De8Prv179gNlHOg8bVCJ8g4OO1PJNfx0hxzUB?=
 =?us-ascii?Q?c2Vbzxf2Y8abzPfNBNENulZnj4bPWAJf3Y0TKYBCj9VOJTL4V0fEOz3jXw/q?=
 =?us-ascii?Q?CTMj76PdsQ2RJAhtryOBqEbMc6NKTq5wwbJbTvsShRAzrTXzczU/+Ju622Bu?=
 =?us-ascii?Q?M8AK9eRFs4lgS/uzLKwhQRUdj6I0gRbLv0EP3BkYmDOB2+hxEWr8iTb8MCyJ?=
 =?us-ascii?Q?66/6PwgrU48KHTc3IpL/B60kKETNCWu/wf3UCUSpOWgIwKdV+4fbj1uurxE0?=
 =?us-ascii?Q?JbHJuxb3ULCLlu/2YtRchWQIN+jrOrSyLo08RUGv3eZJ2/26aG229aLLD0Ls?=
 =?us-ascii?Q?i+CIqpyE5y1Nj+yBwnEVihYhG1/+l+jfVFtY4ykI+fhzXuht21+hL89ujEt5?=
 =?us-ascii?Q?p2M8owJwWaG0Mr55m/gXW7p4roxpUq1nhzUioj+klioX1H7ZR7ZA+YZnxnbx?=
 =?us-ascii?Q?2Uh3GEo/37VCFk5nLYfnF9m3fHnBisBdCjPxc8H8j/ZOdt57RldoYILyldBp?=
 =?us-ascii?Q?l96dXVONSQLEE7pIbXrnRi/Lcbi/d9g1hUY9W5l4HZZuxEwj2dbjPOwJYMpU?=
 =?us-ascii?Q?V+4ppKEEDsEG9moH+ho26En9hs7HD5ElthnqaKhohh9u5meqZYGSCSEO9+rg?=
 =?us-ascii?Q?xgpXOYWfVUGyd2Z6adYpMnyvJP6o1OUcaj+PPg+KVWklzVCpm2DF3GTFs8b0?=
 =?us-ascii?Q?yYuvZuWa+vwa6fseYmTzvBYmUxsoyKo0aPOeXZwdTsPnwRcOKUVJxVKDjq02?=
 =?us-ascii?Q?Y7afj04GxNRj5HUXjLzzrvPlgxYEERI5u0iyRdIf18tf1PG5fFtmseyDrb8f?=
 =?us-ascii?Q?/gXrwqo5XX74z7doTBQdVxF7fLik1bPxv/tKNOtwGp4nwsVjrHTpZUL++JZo?=
 =?us-ascii?Q?2tPpsM0vC/5AsRcI8sDKDGxO2iAF/916+JvTVYGj5HelQTxvXFToO0C6UM+m?=
 =?us-ascii?Q?MfBwc56VuvYK0fbtiGrRG5NZncHweNQlLQe1TGZBUyf6AHaxxTnrtJOE55UW?=
 =?us-ascii?Q?TuICyh48Ovp9MbZ6VXMaHU9ex8VS/PT+HLz4itKXqfV+tQMEwsA7p7ihm7m2?=
 =?us-ascii?Q?vnFb4V76/az5mbRIUtBRAwUJfUU5FwjVW3lsskS9kgCR05MtIaEjyW4PxLR3?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77afdf75-a1e0-4395-8a03-08da76512b66
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:22.0321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKNDl7Oa5rxKkX33JOJMmV1e1MuHX6fKqI9mJnEGjT8p1HsvFIidIwR8uWg1SM7UrhJs556pa1nmZk4UfexsRDoPpPcVei2oLE1qEEklp/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: rRhxxC5_UXyvlLJTxOQ30L3ArJ_WlunF
X-Proofpoint-GUID: rRhxxC5_UXyvlLJTxOQ30L3ArJ_WlunF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index cfdcca95594f..cce5fe7c048e 100644
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
@@ -900,7 +902,7 @@ xfs_init_new_inode(
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
@@ -1077,6 +1079,7 @@ xfs_create(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1173,6 +1176,7 @@ xfs_create_tmpfile(
 	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 57dd3b722265..5582c44f12ab 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -817,8 +817,10 @@ xfs_qm_qino_alloc(
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

