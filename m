Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA6CC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBC661B5F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhKQET1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64174 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230227AbhKQETX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:23 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2QFrr023608
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=7AsPKC7mqMIy6JBM6hOFZS3MelfI6sElPzqVMDIRjvw=;
 b=am9pwYhx4p5xyzLfDEX84cM694UFMtfWBT1CkA48RWIBgNd/HwK2dC6UcRUTbjc1y0F0
 Yhl6nU3tcaSYverrX3Oeoe5Fq7aVIy7Zobh3S+FeoGIM8dsaPIvhILQD2sP/r0pPJhGv
 Vev6BbZPCmWX1tVs6lYTV406GRPkSQQyVYzkvnY5+lbhd3Ar7eY8sM7gcA4U+KbU4+NQ
 qNSKBr5Msg0Do42H6yeDN7H1zJFMS3Ejyl2ENgxChFUO8kuZ39B3D0OW7zY1J0inZq+I
 pPbIXcDqxKie7FB4MmHBw8aPL4P/d6/0BKIHt0A4PiWdGsWS+v70duTULykArSfsZcNM iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbfjxwws6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKk180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vd+8c9HyxAY5h0ybWSO0yc/y5/LH+hDTaTJQuo8PlseiidCdFn6yGQfUkHeYxhOVOXBVBBHH38RRiaKpdBbwiojUs/7WtMQneEVXHxSGVSUnITyDnHvM0ItfkjatqWDRRV7UYjGBYZpj9YQHuEEBM7+4JBWJ+4t2/CxopoMbRs+GAxcJwZw5uTQxSFSURjCB3GLcNFYqrTb5NX4b2teWSJud1w9oplMnZW1UAXlV2V3OIxx8Kedbwo/YJPBAWf4H38gOrHSk6RUTGeRlWxX+PbUiKjF5vknO4WI0HqBfCabswxFcWoBmHRyk8o47Y7a79mjwznHsAoFBxJ5ra8SsYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AsPKC7mqMIy6JBM6hOFZS3MelfI6sElPzqVMDIRjvw=;
 b=QLrV2RVNzpO2F8Q0EhYCSJWTH6ZtPz3IccKDTjR6aGuOYoyc5IoYDHRcb45BxgU76aNOlZTl+X9+1i/lFml3gA7kQOPhzp7saI+kEjKDkLTOuqHoHo+kbcyyyHs6PssiMHiubhx/guza4YC8i7o6DKfynlDzfmzZo4rRfZIPhKgKH5YvNwQnTf2MgpbuGcr2TPnPqTnxF89LkKdsj5vtfqBgjOnm5J8TKLj5PylxZqXfYjFOiEQEQJEj6Fnb3WrXf/nJ98mTpGakizGCJcmAn9fM+oypbahvCMGn3acQyTZylzb5rhSEGhVajzsS+kf507xGDG9xCwtDbzTFXjswGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AsPKC7mqMIy6JBM6hOFZS3MelfI6sElPzqVMDIRjvw=;
 b=fg+aZK1CiLPjLj5dHwexEqn6LnoZ6Yy/xbwDL6aEzSPhHoRXaIgcDLa/UtpU0aV5r3zmfbGYNjlO4jr4xldpUfnvaTAWi09mpwrfPXZjWfAv4VpLE0Ty6h/265AU9JcmCXZeHWeGZitNrHIrPjebW4mnfCiIQvU/CmT4jjLttwo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 05/14] xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Tue, 16 Nov 2021 21:16:04 -0700
Message-Id: <20211117041613.3050252-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75b9fa93-2990-4395-e724-08d9a98102d5
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4036A9B605D88EEF4040A5EE959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJDdGnBux1NWLy0B0CQIj1iyDR9NyZRs5pY4HCgahTwESXBVDiOLDYbbT6VFCbx4rpdxF0rOEN4DX7tIivtV0TOzfnSjT1DxH+0BX/lIAjl+4Tocd4t94IpyfCHRl2pDxKKLrcbvAbue0uHNXCLaus9Et5ZX32ufiA+daFAISnG+PZOE2XFwUmeiXEbuyIq+oGLqJIexP+j2zv/DjGru9/q5xAgOCE28Yre1sGaBVyCAtwmG/xwobQclRYbVfak0OSFhql6IoMFO61u8DS/o23FoezJn14TmthAAcbVEimjkkk1UuOP6+C/FaXS3O9x7yiDtTxx+TGfjBJcABfTVHSEX3mwt8IqjFkP/RG49Z9wGPHh8KkduOLSJw+0dTeJcDtAwI2ivqNvhJMzTi1ahDgoPQb8vAZnN/dOd5IdwD/qWlPXxtcB1ODirdw2dgTQMU18PiSAQnAvugXYkKuhsHef9DB3qxF2uK6EbxSjjP+BiJIOZyC2focBu7j4vECZNec/mAX5wV3Hnzmdb1AQX0YVYpyyu0MAWQLaSmWACYdc/6hGJSZY+Q/5qMxvphZPnDb8TmWKnciYHFYsm0YMS2SHqY3aHuNehlf/1lXWs8qocy9whvYhiKLHpaKEZkuy4JK8l966fErpnee/C2sObkrQXIK4+lN1xj3zJHvuEsptYudMZCiQ/o0PE6MbouR9tZdocA9Bwa8e8cLZM1WnRnbZ1KP1w8sroVl81JReFFxERwpjXdpWiv3Vbdpgd9KYkQ1qj2nrPBT0Gk83NWrtfv0T5fKVMp7N+FlkXUAZ0VRA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U86xGFLeVUxkmtgJBO9wZ5m6sOvCH5WtcxGYROxTNLEprm6Jod4PXLjGFlDn?=
 =?us-ascii?Q?5LsAO0gw43yWNmCV/KhucKpEfgT6aqjwqvcu8Qw5ns+TGp9lvOsEAscYdvnf?=
 =?us-ascii?Q?xq7JEtM3rf34gkdpVylddTuD/cOxVPFAMaT4N1hKym6Ts88qYj6OnIPuGUgU?=
 =?us-ascii?Q?0UIfMZQhZjfrhjG9XsM1qjxcHK17mJzZrqQ0MS3EZzxZSMhFppe+adZcXHhm?=
 =?us-ascii?Q?NX15+ShAaFRHqbOyKteYkBVBguLZiI6U25NJimMaetGDsQjXWPdoHuy46OX5?=
 =?us-ascii?Q?galFkqBmXj6dwkN0gZEUX+Cw4vV/4mG8R+5hrUYfBbUrGU/buxXA0k5W7IvV?=
 =?us-ascii?Q?Z2hQBXW1WrqBJ6I2MdL/g/rpDsfD+rIgu/lhmrZ6FJ0bLy0+lGwEthAzvoNB?=
 =?us-ascii?Q?yPGpWtMTTO4HjsBhtKvp36X2W25VpOBIPGtBm94xrNPaRobhrFb8QuJJYqHf?=
 =?us-ascii?Q?WJkesnxDnoR1cmyUeGzirE9yMkaqncNCPFoLhr7L+1/UEVLjP2zUFbLFqbb4?=
 =?us-ascii?Q?lf6tHtaGxLMY2arcA4028w2yn5E3eyMXR17jH6SlKhypYKR9e+FtoWaZB1S0?=
 =?us-ascii?Q?3bpLneyVQ2Ue4r7HTtDGjd7r1dCOKk/5zdsiXfaQN4XXUgqTR1v1GPaSjLqN?=
 =?us-ascii?Q?H/n78eRhtuXUq9wVaQ6IJGd6pf7LrUJsbdj9E6jytIPGmDZNw/CXysf5gv5W?=
 =?us-ascii?Q?PYF61JlS3s90h4QLQve/y3nqPchqGhZWqcr0VZlrYPwZkcaIPmq8bFfbAIeQ?=
 =?us-ascii?Q?Ujh8ZiIeqKZhRYWBMk1WZfsGni5erma7es6fV8zUOtFAkCGR28wZ2YAv2w2p?=
 =?us-ascii?Q?svNrIPdin26gLWGQwOKuuaYoiEZGyrk55suGpdjuJhcNJ+/9alZH6SzFS9kt?=
 =?us-ascii?Q?zQc7vyLXlLnUJen3Dk9omttPsTbublifZk5pKwHMQwrcw1vnMrVqBf0eOW+f?=
 =?us-ascii?Q?YFVW4QDbmEFz0tCyNAtcTu1yZLqNUYrk7pjCx6DIbYLCEb5ceriaKQiz2Mn1?=
 =?us-ascii?Q?Oso5ahvow78HAZJlRqdjlrzz/kmpeMJ7oCjbVaretjhedyYMMIMydhrgYZrv?=
 =?us-ascii?Q?0RuZmVs9OalK1CQXRGtS5LW40TIUHjv8gEWuquiedAAhMAsD9u6nrZ2r2qTS?=
 =?us-ascii?Q?BdPeA4X80nZ9xQjMYQSdN5Rud4Ds9AX5LwwDGr/vc34no0RlyAukKsd8fvGk?=
 =?us-ascii?Q?hVY7aUqUZnrNrjGJID4DvPK+FD2YoK3BesxS5h7dBSEZ//5gXrMcm9hOqhOl?=
 =?us-ascii?Q?rjz9ZBFJtsWlbhF65vZgBC2QNi3ZNCXo7osNvI0RBssCYiDcFdpRUe2k+5Nk?=
 =?us-ascii?Q?oWVDUdQUw2BJlXeO9O0MgQ6B06wkh44vynVziyKNEU3+RwvrqNR3MXRtsqWN?=
 =?us-ascii?Q?aeENCtPKT8Qpgbo1jvp3k6xQLJ3ToMPCshTxYarWVyITB8JN7wpRII5o1DPe?=
 =?us-ascii?Q?fg13Mb6Y+dW4pYQEuP3Z8kps0B51gL4GDvU+ozyGBrXrLT28d3hLutWsCfwJ?=
 =?us-ascii?Q?ZMMpwaXElyUNnnv9WSI+DhM7N0P/Fvnb6DQ62u4sf72ZSfLcmQd4qhkqAJdU?=
 =?us-ascii?Q?lt5yl+UoGLBs96XQoCay0WB9FMotWcviCYL/V/c943I5hxyuv8RPYpnozCKG?=
 =?us-ascii?Q?JLgLUfeIqLYim48waWH0jFyxasWNG3QrPvbGxm18GQ8h/5M1YmqIidMapv0G?=
 =?us-ascii?Q?Ap9CKA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b9fa93-2990-4395-e724-08d9a98102d5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:21.4169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6ifUd91PYcvTJfgkM7L/l+787tNwCnFQ92OgBemlI0i9kRHVaJSeaWBq0gPlN/d67Yn8M3sUSiOgR/v4G7NvMiu5Ql6MO6x+hCrcI8bcAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: 8TYG2JtycQiiSzgSJjiT0DbQB0pxmIH1
X-Proofpoint-GUID: 8TYG2JtycQiiSzgSJjiT0DbQB0pxmIH1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: df21062113850c5aaeaa38b5194ee4c64767fb7a

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
 libxfs/xfs_attr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2957fd030423..53f4d546ed6e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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

