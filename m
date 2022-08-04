Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14425C19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbiHDTka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiHDTk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C0560F7
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbRX4015052
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=lFFigxoVg0/7IoW7uvwD7trNiu5Jb2uweF8AW3Az49A=;
 b=z24qkoWSqXZAeoKUFBAEDQGuIyqHsGhqt/w2C6/JuWWhWUKl1CC5WZltM/pDj2Gb4uEb
 WwFlWra77s6DSO3vaggqfVARVYbWPTTsIrKSGZp9IvP8SPsvtcUhGR25BhxdpbbdtDP+
 N4eMKolskthtBDRbfdb7mgKLSWxThX3FXp0B4AgreUfe4kGicpenSd3aFKjYmcBIjiwh
 mKoqG0kt4Fqth65qpWFseA1nOKHOEH7fk/WUzBXBgdCgjFB9taESFkwbL3vDqSEZ+hZE
 Ps4p0DIa/gKmi/EVhewXwWpWcDbVFDiXxhwxZc8E0BXKtyrIVr4xXcuyf6VdMAFuBiVu Yg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cdn3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IEkVk003021
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34n716-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itUHWXyVluJCFo9baWrV/X+h1H7a6QAo4DczjVkMvYw52oXGT0xeZ3KXu3mKmeIjLLLyOkOmAb80jLM8RS7ywZoXzI64MSmo/GZ8ygT8yfScg619TpDTQlaosNxmWDZ4dca6gzhl9SBqfxSQXbuAL/2Ng4/C9CAMwrFqZ1pSSf+ASvpZrNS1GpA77//Y3XcnxuGTAXk+fhtauM2b8a1Kty1QtVjbjyeIUYrmg9MyOjOcNrTffeQAl1tPpD68mRxtJLdVzTSyms1gQ2pIZRsLtzd8+T3ZyvBRJ/usrd2YOUKdLBV8wbxXkzXv6RtAQdCU27+kVh22Gjlz30AQNbBalw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFFigxoVg0/7IoW7uvwD7trNiu5Jb2uweF8AW3Az49A=;
 b=R6YiVdkbfWFf7nL29X4ktTsfHEDOhFBCtEQAe/eXjMAnr8I3i67wGe4BzOncTRVtsExmh76XhRKSkkD2rqwB9NBSuyfRW3OPdfV1oypOhMATDF/4xES1+NfQdGLFqNRdX0HriIqiWSEUlrh7CcEQPBDFLvTpNKbDNsKsStNrbjIS+Kk1tb8ojn+3PUpUmYl8CsC7kjNMRzfVuP/XyZmhCbkNXGQ3rQbCxgqO7oHmS1+NRXpY4c+6kXHJTlQNZ+Ao2Qw6FGCwXx34UiQNCEQRL10c9lRMMqTDAMcdE+LDMILbwzfT1pvMnKKs3OoA3wbT3zwup2JKPMC4fdIXzFCLyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFFigxoVg0/7IoW7uvwD7trNiu5Jb2uweF8AW3Az49A=;
 b=WmpzRrKnQbeb2pMIJ/Ivb7L/KXg7Buhr5ANt1WYyHdDeLfEw7dmndRTbdTw/myJ4DxN3wvYy9rZDDV62pTrFv/I2zTXXruYCOzQ7nL75+FUJekkNA6KtYhe8zeS0QBOHhvxi0FjzDsoR8im08Q4Z/EjSbqzlDzBs6E44HanTqFw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1368.namprd10.prod.outlook.com (2603:10b6:903:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Thu, 4 Aug
 2022 19:40:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
Date:   Thu,  4 Aug 2022 12:39:56 -0700
Message-Id: <20220804194013.99237-2-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4459cce1-fb0d-47c4-2b3d-08da76512b0e
X-MS-TrafficTypeDiagnostic: CY4PR10MB1368:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cOAei94oWjUPVT/nAbxOfl7glJLFA7T0N5z13w4kCTJlnv4El3YwIKA+YYc1ySZVROK7svGvTA01I8Mz2ktqXnsot4PRksc748owgUqLvih3LY/duvywnbNPb1FGGxYyxuV2TQEO68S9UX6hHsnX5y7wVtOjc1Z29gzYUuXwk+BfFfIq5H1yCWOsM41L74fvlo6tfJFyhG/9N32ycohLatsnsN1yebpSV4sH0zfsRWcLkTRR3XlirDqGdaHcqSDtqZVxrlQ/3Tt3u5k156uj92DuKSCeree38f5iyGXCEUjDqJNiTxtT3ICZn9u+B9LQZniZLqsd5Hx+L9sORsKqSGzBERlUFJbNUddZbGAyfGSq4sdLgqCNa4fL33qXpxEpzTwG/eUu2G8Wza+cNw6xC5hbpzLHzt67ctCsx2URuSmKyyN27k7RWxxtLbBjaQzExQPQ7TBrdHrwt5CZPYaGO4OeBMx9lZYwiA/MAWk2KqBHovuY3gvin0ezusrX3i/TZ9J++tvM2Sva0JTYAROSaYcWCiAfVvSUUWP+vuK5Mn76mTOq+Qy4fU4eKpbt/MDf9aKZPQJ8ia5Fc9H0Q+6BsmaxJGeCwpL6IipDNfnb+K8cJSiYwGjHJjTUHMkcjbttxl01yhPZpjCn1baIsxRPWzUSDAnH8MbfdJBLJemyaXAuSyXiaF19bdjdNYfKi94skVDsaMjukTmSL7nZbtl2oG5K5n3WLqFf6QCgPxt2KhEgTHeYvqjZZy/rBb/XFw3PgU3OrSrqXa5fVXlL90utQy89bVlGiuB7ucFOe7boVg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(396003)(39860400002)(376002)(6512007)(6506007)(6486002)(316002)(6916009)(478600001)(41300700001)(52116002)(6666004)(38100700002)(26005)(1076003)(83380400001)(36756003)(44832011)(38350700002)(2906002)(66476007)(66946007)(186003)(8676002)(66556008)(86362001)(8936002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WFB03rTCIvpTPrfhbKtUZjqAabhQC3VAB/14I0aaR/+yZ9gbnn/C5wm9rpHL?=
 =?us-ascii?Q?FdHX+PtCmCMtA9d+q3KbgPSTZkbBIB28Z64h5zCgQmjfO6SpmYK/GltEpvTA?=
 =?us-ascii?Q?+7pYhkHYA6TuSk4RwVHO8B59l/vDY6fttaVvT38xg/Pf6JBAmXmM5xVBlJDz?=
 =?us-ascii?Q?frPBvCFfYuO0CXd54O1dZ/CMt1Y2QpUWvqaduzHX9pUmdOEg+pCO7p7WV94O?=
 =?us-ascii?Q?Z3uhXwjOftuLDS073Z8mL3oqEyOwyuTj8USBHJ1hqRuHqxRWnSxQmDyx74qp?=
 =?us-ascii?Q?xwvTf7erMmmR24y8Ddr7FhWsP6bPnVSkwkZqaK4UpqTPeW7sdgysT8N5/qVo?=
 =?us-ascii?Q?EiM3Euy7J4soYotnc3M1yY4193gxgjQMii++EG8i/Qt6lCG3CZlRm40XfbqE?=
 =?us-ascii?Q?2BZi2FDbqD/ztF0adADdtCkBBss6mK3ufQLwGgvAhUSbqdC8T9Ktui0OUOCU?=
 =?us-ascii?Q?My4BY3hDnukLuCYHBcMlRXRlCf1TwTblVxlwWGWnVOsevKX6SpYnuWAGWyF4?=
 =?us-ascii?Q?cshz0SR3mL/mxtVApC+NRcZ+5gkDTTcnYGPXG7NTOZVqpkxppVRxpz4PtRVK?=
 =?us-ascii?Q?KKZpCTuRB9O+fam94DUglQ2HtXMoZiMrzIiSVerKJKTK77AYyioeLwebQbuY?=
 =?us-ascii?Q?MM7ek4hBYeMxyVVlMyKfVis3DWjn+nP9O0soYm8ViA2YGDK3rTvcQS9k3EvB?=
 =?us-ascii?Q?WvhUG+iQlDT5L1hyfV4F1GJYTLBFquBrvKWMr834gglSQ7vf/OJAeMZESQdW?=
 =?us-ascii?Q?CSzvruwJf8p2C0ZZ5YSCqsRmu9xDuN4lQTaMYYB77d27lRj2HX2tzMGRZ/rO?=
 =?us-ascii?Q?EDcXI+wKtg8v9CEdz6yQx7UETERn+UmkOTYOTm2oYWHgvACum0poEQzrGjYh?=
 =?us-ascii?Q?8V6qWcr8pnXVIcwfw+m/TOXWEZ20oPIfKjzCTU+dL/qtcSRkwkLDjnNZk+WV?=
 =?us-ascii?Q?XeP/3YoCq5smbQsdEuKSXvbt6sQCoQYFFh8+SQfMapt9gUxCc11pSTxNaniZ?=
 =?us-ascii?Q?uiAFi6/AvgNjC3R12hLEs94zmn2R87Zv64cSkDWRUKYE5j5ugboQIrE1UhDm?=
 =?us-ascii?Q?RTDSL8sMC7vWP9NcfLbE32OCktzBY1lctiTxjdxKPB3rB7hMKaVHzBjbKmHn?=
 =?us-ascii?Q?JK9pA3L5VOi1L/dlA0vxPvaUXmBwmlftCJkp1mcSQu1E6BpG/C89DzB9EvE9?=
 =?us-ascii?Q?TUtJ9t2GokH4vPIjUYWfRu2Rtbec0/M0X2eEgzeQwKyN6szoJDvjHyMEKkDi?=
 =?us-ascii?Q?f4JEw7C6RZYCX1K/21ySfv5VECU1aOiiQ3cqFMt1qncqkKq1mmvR6e7n2X2A?=
 =?us-ascii?Q?LTfJGA338DPbgTt2iB+JOL+AQ62P9zYbW64U/X/3oSxUnkzwYRBFr0o74W+p?=
 =?us-ascii?Q?A+oHiHROzBMgKSkXNdPE7LJgnX+8l7lxtX8eW2VC5JKEAA36eNCwcT+Nw/j9?=
 =?us-ascii?Q?jJJCZtqCEUMbeF37FIlKovaOgKVPHgpt+7Q5RazU+JG55jsz7zeqaNRnrNXo?=
 =?us-ascii?Q?VaDN8q71NC3BAF/c7hoA62/vODdcocb1yfcD17/xvcjq4+sErdGb7RwS+WzD?=
 =?us-ascii?Q?hSVXJCVt4xoTx+W3y3e8Nn4DpvfZD3C2AQ0Ol9fohFR05iMxIHqXAiX8tr31?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4459cce1-fb0d-47c4-2b3d-08da76512b0e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:21.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKp3IcXiY6RS5ygatgXJFjlbxmJtwbUsXGifuTWqDWvEjJTVSth/nsCmv/EzChaFUiys+Iiu05/druV72kUhvpHnP7nr1RNWaxtvlyZ6q10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040085
X-Proofpoint-GUID: 1GejFyJw5MWLuPgf0ARz3L0oBGaMguwy
X-Proofpoint-ORIG-GUID: 1GejFyJw5MWLuPgf0ARz3L0oBGaMguwy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recent parent pointer testing has exposed a bug in the underlying
attr replay.  A multi transaction replay currently performs a
single step of the replay, then deferrs the rest if there is more
to do.  This causes race conditions with other attr replays that
might be recovered before the remaining deferred work has had a
chance to finish.  This can lead to interleaved set and remove
operations that may clobber the attribute fork.  Fix this by
deferring all work for any attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5077a7ad5646..c13d724a3e13 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -635,52 +635,33 @@ xfs_attri_item_recover(
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (!xfs_inode_hasattr(args->dp))
-			goto out;
+			return 0;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
 		ASSERT(0);
-		error = -EFSCORRUPTED;
-		goto out;
+		return -EFSCORRUPTED;
 	}
 
 	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
-		goto out;
+		return error;
 
 	args->trans = tp;
 	done_item = xfs_trans_get_attrd(tp, attrip);
+	args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	set_bit(XFS_LI_DIRTY, &done_item->attrd_item.li_flags);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_xattri_finish_update(attr, done_item);
-	if (error == -EAGAIN) {
-		/*
-		 * There's more work to do, so add the intent item to this
-		 * transaction so that we can continue it later.
-		 */
-		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
-		error = xfs_defer_ops_capture_and_commit(tp, capture_list);
-		if (error)
-			goto out_unlock;
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_irele(ip);
-		return 0;
-	}
-	if (error) {
-		xfs_trans_cancel(tp);
-		goto out_unlock;
-	}
-
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
-out_unlock:
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-out:
-	xfs_attr_free_item(attr);
+
 	return error;
 }
 
-- 
2.25.1

