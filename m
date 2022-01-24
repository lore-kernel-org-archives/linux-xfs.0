Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B7EC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240904AbiAXF1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2916 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240863AbiAXF1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:20 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NLDU1a003423
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=RHYaGMHeSImLsIsTAv1eRxGM4x8j9Tct8+gOCS5FzEnBX84F5ced9ybl7o37AgqhAt8L
 qG5dP7/8VegXa2nZT/izX6bmE2k3v7LxEWIewdgOhr+UkDLOGcrYtfaBSxAyiFJND2r9
 YVUYUux1MSA/mGvnn+lUSrFn06ViitNcL19mEbwkyEFCn7agNTrSSkdS+prmwx5OHjIU
 KAMWazQwSHXWBKDgsWWYbJsrcW/WIWA9Viv7n6hCZ8q1B/zYDz21KTMMm1bZFA/wCjH2
 HxzJX/Dt9imrVjQv+wJB9Ts0w8nEIhH8T87M8qAQjXK5CNE/HT67S5gEeFB4pwBojdN0 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3drafub3gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5Qr8M087767
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3dr71up23q-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Chh2nGtSj9CKGfq6jrpWfxI4dhNfZnHu/MDGRYeIZsppmGpZweddaEJc3htbKcCbnSRmcbdevehaTqhewtXHvA60Nug+QiiabOPzqRKNe0rqi7CJ4arTw0neSzN/J2nKU2PjLtdKrnJDmaay6ms5i/0y20cL7wzQlgPAhiChe7z9qP+Q96H7/r/gKyN37pU3JqkMzzGSjcDwmuOQ/b1nWrTYrks2mHWVj/Ru/AeSljpu8HWALGdZV9L8+4trl+UVReyWBc9gfaJUm4UCGMRVQcnRkWbz/bOTEYQCd7FnJ73bZk1ljtCExpLItr5zrhfpLpLxpAUXx0VH6OjToz9Qkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=Thf5HbojRgpjlbj1wM3Ck+4wOqfTPx1CP1uaCEXzkPMyB+alMpHJEUU6O6N8ux2VLys72foX9j1Z5qPvwpym31O/yBdSafCFWeTZ/uDh4nJMROhB7lSI1IJk3wWeJ5hKXRCFqq0Gm//S9dC44KBwVGD4+sz8CgcBnAeRc2F18XetQlaqLyX//kUCu7mNLOT6iy2at7aHbLlN8xld7ScQtcD4a0KMHfU8MxGJ3GJlxtpP+HeBYGLTorK0y/2x25Gdcmk5VmJfinJcNkS+hSC8FJX+qalEZ86EX++gSnEWsbSyBkrChlg+j4N77zg4iz5e+taQ600aSVL1eNl4CE4c8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=HMPUP1dnB1eGyDMACf467MbzZ0nW4okOQfk+9DP9W5PnNeeJgIsIkLJUlpJ9jZn32/OPNNVVwljxCftfBQcXn92vMig9i/BP3ZYWADLLSEaNJcV0C5enQgshvbwnOTlvk01wGdjlCuc5XWYJm3Db01L6NmV3nEkp/+owURt+cq4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Mon, 24 Jan
 2022 05:27:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:17 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 03/12] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Sun, 23 Jan 2022 22:26:59 -0700
Message-Id: <20220124052708.580016-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21eb715f-e11e-443e-437b-08d9defa2f15
X-MS-TrafficTypeDiagnostic: MW5PR10MB5874:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB58745A16517258F2BFB3D28B955E9@MW5PR10MB5874.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxUZHbHKzal9kv7FxcYg6Vw5UOtWuYSasK/vJRsVB9C4++7sLwIgyvDwL2TQm3BK3JXdcsRp6nmZV6Olte8pow2v1IQ33T+Uvg3EEQg2PghUIbi8Wmc2PIIx9HfWuDESD9DmL4CdekpSRc15ipExBRVChpCztitgRN6j1dkNTPcxI4DBK3psF3D9nBqMcUGNLS2WAVYFPNOUIbx2bTATlao8lsZ39H7I2QZgq8Uo6MXxytlYp7hqLAo02m89/CdIQOgG23X9qzSJlTXjfdqXbwyy3YCbzi8bcb4JvLjNBLTCdarKUjRyz+1qWwGND5W0GtmYmjnWM8qMcwRnOX3u8A9y1/zqIpA1GbMjQL7Kaio42VLpf/lO4V4R10blIE6WDCbf7qN8z9YKJSqkYriOu6RXiBLmJMzD7RIzLbNkbaKvf5CfIRRHQa9HBjXf2wfT4hKLgHbLSxGZ2+c7FtbK895UEcBAQo4GFZiDZQM2Im2fBCC5CZNl0oJPpWERZZ1R1uZXBg0D/v6JV9brClicVnnO7fp1bu9z4RZ95X2gknZQmlgGhBLLZz0jJlxv0Zm4rfwnlMGvXj3icSB5cNJLpgAcm8qii5W0Tuy/zns1uDhHih8QmlTFgNBbBy5VpFnA4WAPSeBkXFsQ69yenI2rWrLVKHGapxaFPKXoXnq4imHgRmgdfo1A0UVc490RK/8TBc6e2Luva05aGbskACEiO7xrkpjPTqR793NlNlnGu0KPlI5tSf/82ckMR5CAb5n7VV29k+Sh2TdhvFvfnCCBfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(66476007)(8676002)(6916009)(6506007)(6512007)(66556008)(6486002)(44832011)(1076003)(2906002)(83380400001)(8936002)(38100700002)(38350700002)(2616005)(52116002)(86362001)(508600001)(66946007)(6666004)(316002)(26005)(186003)(36756003)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?McBA0H9L5Mz+HCSF1ID87GZcttoQJQoXgLBf1Zu+j25fbACnWOZOrktTWWNk?=
 =?us-ascii?Q?pkgrrqy9Sw0LSNXnqUr+VbU9H4qIig+mPB/DQuMNQknK+Yn1rGNl65c+rA4D?=
 =?us-ascii?Q?bdXkjZ5Ul4hoGVLox0DyLonEo9dmrmNHLWXpyzXqILUfvlr2Nt767YKtvIha?=
 =?us-ascii?Q?+aKUS3Y1dlSDc919QuBx6il1JbxSPouH+KJ87wXcQJyYbXy/P3Sm1ZNgre4w?=
 =?us-ascii?Q?8gXINKUPxqWRK6K4gt6CsZbl0FcNtIDVDixMDJdg3uf+dBLS0kKFedSgn7e8?=
 =?us-ascii?Q?9D60wE8uMNIFyhzDsuKZg7TEKZLcCHxUviPiuFlI6IA5oEW5UHulksP692Lu?=
 =?us-ascii?Q?HuE+HtNJhxQuo7h6Jno4QpSlgKv3G7MKa8FQuJr6fYj9t3dzKC7NTa/Pgt0n?=
 =?us-ascii?Q?8gE/2/6dask4wpE2BqgKami41XenNmhpQ5dc1o0ufQ3U/P7UAczCEKgR4DDr?=
 =?us-ascii?Q?I+V2JgZi2x9z6lalHv+i6/Z89qplmxYsO34l0jbLXYKVB9iKbEakisV/4QF6?=
 =?us-ascii?Q?Jj8Wg6c6uLbey2Qu+PG7NdyWXhLt5mR1KHLf3aBh1Z9vqL4YRwLr8bFryBd5?=
 =?us-ascii?Q?0A8+cONLutkAYLzL8fYrFpoxkrr95ChL0X3J4qpaDPPRLfrIBMFbek/KHQ+I?=
 =?us-ascii?Q?pZ+wDATaOKJb0EgLqWt56AK4Epv/HM4HV5Sz+p6l5nX/3V1mO+ENNF2dV3Yv?=
 =?us-ascii?Q?uXvjXrXGoZLi32/NfMc14UFCI55QX6ByR6RLWT1P9gTpEK7aKHnm/z0bL4Ei?=
 =?us-ascii?Q?1Dc6Z9gWKXzNoyHJ8UNxbdfRuGCSbJOICUNfIiKcPfMYtgfqw4FQou0dQkPC?=
 =?us-ascii?Q?LiktIZ9uBdXs3MNAnqMNW2OvFowAeB//wraJGBiGa1c2YNPBIL/3S0Qad7MA?=
 =?us-ascii?Q?ILXx7otJp/cPFCgZZPRpsV+vk1g+eEVvqcw7ECwlE5LVeOl3ldZWtkoJnUpG?=
 =?us-ascii?Q?Cr1FvpFWEDjodobgIsAYrt0e7Irw4thdgW2VQjUM9y6Ga0e1pO8eAgXaOESX?=
 =?us-ascii?Q?+i6a8H4teGR+5JsMFZuXUfPSVdQDUipwOR1rHl7nnGtyyObpKKZuyNjPld+c?=
 =?us-ascii?Q?TzHXFgK43Sb0Y/1prKrFDo9EY+ruPm0JyqkeMTTptlBsfW0x0fyc/4uO0Zwc?=
 =?us-ascii?Q?5N7eIay78dJv2APXL4CrR/Mp5p46iBjx+MgLLOjdTFclvrFtQ1KOIY5dNwkG?=
 =?us-ascii?Q?GzmMUB+d48XmUdK931PB5XvphYYqMeNj5Z87dIui5Pdoh4/dIcYJPFsV2kli?=
 =?us-ascii?Q?bNGOZaHDg0F5l2ZJRdiGWa2vmt/u5YOvmbAdXFUmdFNnrTfAcYqPtcYmn9SJ?=
 =?us-ascii?Q?aMT1xEgMqO2djAh0w5iGEP2vNGmWJnoHyAAsCBV2zuhsSk+XS1YX5OE+mgOk?=
 =?us-ascii?Q?ZvFVDAsGldEuwrGBHN8od62v2furkCu+fEVjLrtbU+vp4aVmZa0rYMnICAye?=
 =?us-ascii?Q?/iwZ+xAvxw0Rwx4SoK++NOW1/qLuzq5y6x8xdp7+aB2OLM774JYPKnIKWlIA?=
 =?us-ascii?Q?FCT6LU/wZPI1HeflyFPJqPodDNVQpIK57IsStsj4NxoMjv3zbljY9pO3JlBb?=
 =?us-ascii?Q?scf56p5PV/CG1eGeyfILh/zmCaHAadymXqE5Bn2DLepGbbFPTJN1lh0EJXwC?=
 =?us-ascii?Q?RL1mJ3TS2WD1Gv4XfZWr7cRH+paX5pmGYe9WP5qZ3FHCXogxi312XhDhWzqu?=
 =?us-ascii?Q?omAqrw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21eb715f-e11e-443e-437b-08d9defa2f15
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:16.4467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1q8sA4ZB4ot4vVCEUttkNOwu34MhiZHkC8FZv4Yt9k2mqnT+iMYb1Ssa442rnCUmQcfyhx/RG2RsdX5yGSrvpTP7uGAlT2GYM1HeUQXJOGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: Xs-0z_7Hb4dYJQ2PDtbet7qNGoCVXyRv
X-Proofpoint-GUID: Xs-0z_7Hb4dYJQ2PDtbet7qNGoCVXyRv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that no further blocks need to be added or removed, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23523b802539..23502a24ce41 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -412,6 +412,14 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno &&
+			    !(args->op_flags & XFS_DA_OP_RENAME))
+				return 0;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
-- 
2.25.1

