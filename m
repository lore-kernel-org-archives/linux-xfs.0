Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22277C07E9E
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 045D361CD6
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGGWYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19212 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhGGWYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:08 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKQM4012937
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZWd08JaMJC9qZTrChNcoZ0PURokiytfQUuxrS4rywQ8=;
 b=BvWEyXOWF3fXjZPd4U7vL/Qr/IPH1dlTojhIdmsStjvahfmfGq6YmJXtrn4yetSX/vSh
 n696qlHuSWwJZqrZ4c7kSaUyMLVUdzjGBDIg/0WlrkzeidXjkyaqcP3UxE4xeGVHwyus
 SUBI13Z1fl2xeOBIoLho2jUONzK2T0RaqnKSdkkB4UsDi46uFVMbFcJ9MseS2v/j9DP7
 YEOmJedOg5ROa5XJn/bNBiqGmBz7bhVpV5sdx5l9MSHkZPQk6aVqzWUOajWAhPJjZWmE
 QQpDSAKVLzL961KTbDaDyKUaN/7I2GNrCzV1+3S5bV7Qv7JqYIAkJpj8Gykwgh6mLt0B /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nbsxs6rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSc092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrV622d8QIKcLmuTFE4Dfzrp2Zum3SVUFSrFESvt/q88YDEuUWSJ8dbFzx4mM2SeFjoVSXnj5sf90soxmdRYzb3Qdl8m8MK9TA7SrQwRi/CvSZBqbVbNt63po9s8URbPvCv9kakEeensvuJS6G6oqydgXIYKqNP0iI+uiIx6igp1QKKdii6mnvmu6e1JOtqT78ROFl0QE8d/lqNgMl4+KdafG2OONNkgZFOSnn2L5vN9KavBbUG2xvUaLVV2C2SG1xnZV8E3yheEtRx/ftzGVyEjyBRI31eBA3pS9mSU9BIl6P4zSHaLlE2TB9sX2rGqRHXwuDtTF/d7Cce8oWQ5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWd08JaMJC9qZTrChNcoZ0PURokiytfQUuxrS4rywQ8=;
 b=LOXxJXSMaeiBlXEkM4o4HNavQ8vWC22oMMMZf9rT6crggyF68qPu1w4n75vfQc3zkGGF7TjiLWFSflPZefn6TkEy4CSclqiHS6uAf8JYFe3icajpFXBMH6fQ7iZcF3P/a7GupdLARDyDX1tzT58XVTCfOuKizpe/lcDuc4C7l0vnPpT5+9f8CO7W7HCAyN4NfFYjlJAur6guH9Rvu3FjeEhEMlbMgcuJBDlI4w9OR1D8QJ19KmIn7sMgQiXNh5Nd8OnEkolvyNy1zeRDcclfuoVjpP9OVFsEG2ev+CuTuco7PhK1OR2Kn6xrzQ/NzFdsgUKnHZadoJYhS1tGPWa0XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWd08JaMJC9qZTrChNcoZ0PURokiytfQUuxrS4rywQ8=;
 b=aDjGNyuE7nBv0i+uF+aBe+ZOcs+SkhPCskGny4CQeWnZBHDVos91Qp79Vha70hjDfagLLHpFn9x8XrlX3OWgePN84oXiMiyCIRRGrZ1NKbQqGcn+x6stTRIv0iC30lEfzSJbw06eRtGPAS/DXcs8G0Siu254w+HgPsBHaztnOfo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 02/13] xfs: Add state machine tracepoints
Date:   Wed,  7 Jul 2021 15:21:00 -0700
Message-Id: <20210707222111.16339-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1656e24e-26e7-4cfa-d023-08d941958dab
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2760CF0E9E302AF726618807951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ymJZuMhdW3ko5w6RT5pslbZ2WFao+912orhRubPVKjvbzeevLM0pQ9mdDvNAnKQHcDZOz4I+PTAi+nDWqcEPiv0hpJFMfUow7WujQxlWrulzMCb+7e5mGW/gBi26r05z7R+AeCOHEHPXhHs22dXUElPdJUAx+uuiqI3oR6DNcaMZH+QG2F+S8a1cAHbf45qAPe/BxGpZ4c9S+2IlRKoaJpFkTEubaC+kSXw905IpyjPaPquKB91s24Qus69PIeE4fE6qKVXNOSli+WDfGxadlrBmPzTvv3Goa12JRy5iFLsn4g3QH/WCuDu65zmhzWmHSlSC9SO9NCOBeVgSBuG0q84aE3xWXyJNm8BUU3cEooLYbfY2F1eojpqUvXfNrNqtI3TWEThSn6GUJFOo9A5eNPbt5TxBRBZHjl1BRDG9ugjIkd1eafN8YdotuTX0lsZoMWJACI17ACxnzBFs1MknH7yCz7w+U6kQNCfp4+5vv166cRpLGW3ywi5f7/+ry93+j4/9Y9Ww/ba2/PlWAousmWyeMCZXWsQQhCkj7y35H3On715mXCKrNlfcwNtGs0oZqNeDvcz7/eUUq2ZZCMqkFHQcp0jZsU1a7YyXBrO6XndCvkWYf8aNfwAypnQcVu5CdYi+oYitTnnwaSOfkJwpLD8I3jHVKoNj7JHa50RbMd1I1FzoJ6zhu0wXaay0ZYyTZDwNCp2oVNpJDv/ZnnyKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pVmNwW9bj0VB8SJOEsMzYwCWeUNmNCnCpE42LgykMG5LZy4/2JnrsmF4c4th?=
 =?us-ascii?Q?cOXfwjvpSuXGOaYSv+d3hUP4AU5fRo+WGawQcg9loUuwxKjDsevFR493D6LV?=
 =?us-ascii?Q?CjcZmFhTpUMv0iAQuApFP/n3uNVxXrOTuYrj3hAvZeUT12iVxNbEpLdo/Q4c?=
 =?us-ascii?Q?xbqvo48uPD6So9/Peku3h/SbL1dNCu6ZTpbA2PktKClv2yLC+h7ZjF9s7Xcc?=
 =?us-ascii?Q?eP/HbzOaN+u4RoO1c0bQLnTfqH9d4eNtYpyBaUVHVFyM60rvW15Id+z/XczT?=
 =?us-ascii?Q?i+XGD0RDT7lLYbEdW0Z4ONqeq8knok9o1KFHV7oHD2nFyvSGBMYY0WQ4LL0T?=
 =?us-ascii?Q?fFIJv/tKSAG1ATjfIlzJZeXUziyVqUqFUcwCGf+JeeInjZKw7BHDgJwDB9ai?=
 =?us-ascii?Q?9Wb+hnSSg0IsgZubMv7Bc8lsQFwIwI+qoWNvKAWQMbGd/j1gI6WCppEON8LR?=
 =?us-ascii?Q?e9+5F6RAyc6a1w1KRTgY8wk3UXdJi1C7Mks1O7/LTHuh3r+u1rp1VKt/FKjT?=
 =?us-ascii?Q?6WLKvUnCqYqfQTPc7GVqLZgZ3523p5h3FnDYZHQvVhdYDL+tXMT2RY8mosgI?=
 =?us-ascii?Q?FWlr6OKH7B7E6MakYQBL//RNqhLJhnG5IGw6SgM5GaWgtHieGtt5oU+rySXi?=
 =?us-ascii?Q?RD2hn6/jPy2vy1LhPuxMuPFrWGVfH80miRarPIf/bq0+Rd3+kJn54jCT3MXu?=
 =?us-ascii?Q?9WzYq5naptjTanWaxynm9Nu0AxCe4KJyE93g8jfDoRJNnlde34FHbhOfK55C?=
 =?us-ascii?Q?c6T6y6ovzkMcQ4Z1tgE+tHEQJMXbLZvZNInyLRyFKlecK0oyNcu26oLBbjTR?=
 =?us-ascii?Q?QLjMbqHEmY7rcdGkafRpm1g3RMEINj5QKl9X2XFeUAiZVEJnqiA6qIaQ5pj2?=
 =?us-ascii?Q?rxxvXXH6zv8mnVXM3dP4RCGLjtVOOM5KyGJT2PG/D52L8E/BUff2CpTc02aV?=
 =?us-ascii?Q?QNSDjMGQTj6zm1eZOY7bRdnhfqnPm223sGXVxn2f/L8nkwVsYMuQIWi9A4eX?=
 =?us-ascii?Q?LeUV+ykcaLbyOg1oLfE+WWUrHa/WsCozHSypX7eKAeE029OfpEaD3fp5lmhe?=
 =?us-ascii?Q?/r9DzNllE+NDFhbwq7OfzSNVAsbBFwEovNKAxE140muuDzvOanThWlLdkIYe?=
 =?us-ascii?Q?KdeuuSXwvsNhBolzPG+so6RSVEFAyRV0gaoXV0C3rZx4CQ/wcdKz6pWFKaLK?=
 =?us-ascii?Q?XE5vwwaxncdfcUzQAmfj0+Y+T+zOVTLZpQfkblz4cBRA0vi1gKN+8tFVjkjl?=
 =?us-ascii?Q?5z7oKp+kKl0AHCIDdhkXfldqjGqIq0ftrhsUYK9xLoHsHE04DTdFUG2mRmKD?=
 =?us-ascii?Q?Cp9ZWjDya5XWWnEFXf6a4jZk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1656e24e-26e7-4cfa-d023-08d941958dab
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:23.4347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fx0kuvgKuSRCUtf/97VJkJLAp1H4kJeTJqJ+ysVkMH+eLBV3GdTBJfeXUvaa7a9WtI0rn8Q4/DH+wmxJY3/NL6KW9QX1mH9JlotJSE2idBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-ORIG-GUID: y0LE6JRU3pUOvNMy-5r9QeOH4t2BiFU0
X-Proofpoint-GUID: y0LE6JRU3pUOvNMy-5r9QeOH4t2BiFU0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a quick patch to add a new xfs_attr_*_return tracepoints.  We
use these to track when ever a new state is set or -EAGAIN is returned

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c        | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr_remote.c |  1 +
 fs/xfs/xfs_trace.h              | 24 ++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5e81389..cb6eac1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -335,6 +335,7 @@ xfs_attr_sf_addname(
 	 * the attr fork to leaf format and will restart with the leaf
 	 * add.
 	 */
+	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
 	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
@@ -394,6 +395,8 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				dac->flags |= XFS_DAC_DEFER_FINISH;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
@@ -418,6 +421,7 @@ xfs_attr_set_iter(
 
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
+		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -445,6 +449,8 @@ xfs_attr_set_iter(
 			error = xfs_attr_rmtval_set_blk(dac);
 			if (error)
 				return error;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -479,6 +485,7 @@ xfs_attr_set_iter(
 		 * series.
 		 */
 		dac->dela_state = XFS_DAS_FLIP_LFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
@@ -496,6 +503,9 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 			if (error)
 				return error;
 
@@ -549,6 +559,8 @@ xfs_attr_set_iter(
 				error = xfs_attr_rmtval_set_blk(dac);
 				if (error)
 					return error;
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -584,6 +596,7 @@ xfs_attr_set_iter(
 		 * series
 		 */
 		dac->dela_state = XFS_DAS_FLIP_NFLAG;
+		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 
 	case XFS_DAS_FLIP_NFLAG:
@@ -603,6 +616,10 @@ xfs_attr_set_iter(
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
 			error = __xfs_attr_rmtval_remove(dac);
+			if (error == -EAGAIN)
+				trace_xfs_attr_set_iter_return(
+					dac->dela_state, args->dp);
+
 			if (error)
 				return error;
 
@@ -1183,6 +1200,8 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			dac->flags |= XFS_DAC_DEFER_FINISH;
+			trace_xfs_attr_node_addname_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1429,10 +1448,13 @@ xfs_attr_remove_iter(
 			 * blocks are removed.
 			 */
 			error = __xfs_attr_rmtval_remove(dac);
-			if (error == -EAGAIN)
+			if (error == -EAGAIN) {
+				trace_xfs_attr_remove_iter_return(
+						dac->dela_state, args->dp);
 				return error;
-			else if (error)
+			} else if (error) {
 				goto out;
+			}
 
 			/*
 			 * Refill the state structure with buffers (the prior
@@ -1473,6 +1495,8 @@ xfs_attr_remove_iter(
 
 			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
+			trace_xfs_attr_remove_iter_return(
+					dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 0c8bee3..70f880d 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -696,6 +696,7 @@ __xfs_attr_rmtval_remove(
 	 */
 	if (!done) {
 		dac->flags |= XFS_DAC_DEFER_FINISH;
+		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9d8d60..f9840dd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3987,6 +3987,30 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
 DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
 DEFINE_ICLOG_EVENT(xlog_iclog_write);
 
+DECLARE_EVENT_CLASS(xfs_das_state_class,
+	TP_PROTO(int das, struct xfs_inode *ip),
+	TP_ARGS(das, ip),
+	TP_STRUCT__entry(
+		__field(int, das)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->das = das;
+		__entry->ino = ip->i_ino;
+	),
+	TP_printk("state change %d ino 0x%llx",
+		  __entry->das, __entry->ino)
+)
+
+#define DEFINE_DAS_STATE_EVENT(name) \
+DEFINE_EVENT(xfs_das_state_class, name, \
+	TP_PROTO(int das, struct xfs_inode *ip), \
+	TP_ARGS(das, ip))
+DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.7.4

