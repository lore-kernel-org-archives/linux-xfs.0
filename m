Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F0AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiERAMs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiERAMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055614992C
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKSZdj023116
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=FZIT+Ft1J+BSRlt7nBwmOtqiPhJlZ5Nj+OU0DTQAVVc=;
 b=FBu0VounEIhaFVtWUfzXqJi5luUpW5FJhlvsZe5MP7wozLPJtZG2LCE69iTPnPzXmVv/
 Fu2nmZBa/Kze1jFrTtdYZX2n75UWZUTo9ZEw1nffn5DFqy75zNNntWutouoSmtlYm3tk
 O6RO8uIRXbUJKGE992hKFn8Ck6msHpLBl+JB2MRI5cJj807fgaEgApuqJvOimaiEeVhj
 6mvZ6GmEcYrayvuNxtAgD0QMVRXQrmTrg73+DXVHCx0c7JswhpALH9z/nqr7O9tBL5T6
 5xxQ/AsiZ0gTpSY5Zjvx5kGGXjyLhIACPbOD52LeZ7qq+WvG7QMATkA60G3SwuIvq3Uf PQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s7ss0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1O9021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqWdaU4L/sVvANB7/9oFvq8E3QlSqn0BzaBpTg8RxyuzG/5+pTbwbw/4J/9yaLHpKDW2vdSfuYUPF2WRFma4fwSOjlxi1CUkR0DzFRPJlR/umN0Gk9eTs98652N3BIrGCBLI6YS1EuzqsCGnIVMN/B82ELnSHZnCnxc3CCs7XFhPgHH5U7YMkDwre3ZYhv5gaW9bqUd9fFjxqp6MGmV3SLI6n+FLkgMjXtHpol2ePW6N7JsCKSHpo5aCgpKB6Y+Cdw33dnKqq1Mr5SBfFgwY0alLzOr/fQS8NS0V1mvGMdovabu8ZM05RHkaGkLZ2mYqB7nqQbvKmwKB8all/Sd8zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZIT+Ft1J+BSRlt7nBwmOtqiPhJlZ5Nj+OU0DTQAVVc=;
 b=J8UoWZB1fd9wi/uVkbp3docJotJav4zucLxxh5+rOihppt+7lRCZa5WdLGfdq8QQaqOy1Qz8wQxTNI2fue7XCGAEyf+aldNCQPIv0s9bJSFlQFi+Ryjs/JC/EUtLzXuGUh/ny4iuIlLp4kX00SZIVAp9KAaB+K2skvv0HDZBbQ/S/7Tk6TNlUlK+OZ5jkFYMzNQfwn/g7BKe5yWNhbJcU+NPd/QMQspiFkk6GK0ndw6K1DmkbNUVOGDlqXvoZHFBdzl9ef3a3e5chwG4FdhSNfyJIAC1tJhI+s9XgXaeuN6dXr09+rlUM2PujtNMvr3HKL/1ELEPIjgok0v+yAfQ+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZIT+Ft1J+BSRlt7nBwmOtqiPhJlZ5Nj+OU0DTQAVVc=;
 b=EBR57ocXiW+ANWRNAnXylIlLDvDaEGLf/sDdSQRmn1riq51uzmG+EjuFQCVn9khM26fv6vMn1C9DqxLZCzgSAkciBHKg0/aC7PO7VmbgQz9rx7N71WD+auDDdoXD2iAYNjEOY/+xmCLJ89kX6CFfgdwaSp5X8SYR3l37OYQ7BK4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/18] xfsprogs: tag transactions that contain intent done items
Date:   Tue, 17 May 2022 17:12:13 -0700
Message-Id: <20220518001227.1779324-5-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d8769838-1a6d-484b-af50-08da38631c5d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528E99B9ABAA2B6298EBCB395D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6l2TmNdBXKeEAQhWe+N+gdLVv4fjmSbgBceMZUHWNhIXhcJkMmv27agStLLPRyAutFOPAZafctOGbyxsLB3IpPQDTgJldxGnBmtPW+NR68oy1Duj9kBcCVBKoeIFM1aLbc6OlLAek4umjCtO77HpQxWkJ0gt6ri2PP79qnnRPyhNOVWDJddtUC9S1Eof1OFTuW14FzkKPeEX04aAYL0OlD//kyNYAEaUMWsHIxNikLXaWRUd9LIu6Sg6jAcdkus9Ow/Lw0bBxa0AuWtP8f7Lh6pb429mXkmhL6bxZm9/GB8zIefWg50FI9om/UkeH2utKeOqBegHBizzVHTUm7eyWBTnrWwP060EW6Ks4xE5xcU52n914ZNqoodmPVBI6fLPgJcVclmwMawEJUhoW47zfrwZMJcFfrTpgt4osm2CCqlcJZyenR53Ox0BzZ/x3BW57tNJIqKehOrYePv43JxMA1xTRTYhOQWZNt5zlFolakZcYOBJk89q4nelTHSy/rUmwWhRRVPTFuJDf+uFJOYe4Y5u6DjTHl7OEdEzQVTIaU6MsOKU5rdmAXdh5fa3Cy6u3Sm63n8T/MOuFzuYnUQ+ggsTdkgkRl+mE4LL2DRaxLylg3kAcx85wA8I5Zh0bK/QA58NOmRIphuhmyC9ZvD+peKCdinfzqjqpXsBvnAHQoK3EWhDGnF6TWLbLbnO+6vlHHVRIrzED3T5MgwA8M1Tvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQDBrnligxgHXM1Z7b0vz07qgp05jB9+WVps3aLsxXGKhQg/V12nGwpUqb+q?=
 =?us-ascii?Q?hav5ATga/0qremI27kbGxxdbErMfNKVDSpaa8V8XM6w3jDFfDmg0ns3PnpNU?=
 =?us-ascii?Q?CDnQvk1YQmukTxgxUpOU1HuTxyILgApd/wfrDtywNOU1XpHR7rJwB8zNQkws?=
 =?us-ascii?Q?YIg9ODW8OCbihcBrt4wP+Ve0D3wIu96D//vmab99dHShCAmEHLVeRFe6nGML?=
 =?us-ascii?Q?WKCBZDSjF87ZXwPE6EVl0/z7YsE08Mt3A6woXOSdz5PnfmzRgxfZz4+kCgjL?=
 =?us-ascii?Q?fOwIwIS12VpdX0Q1vD45aRoinXPxc+G2CPuQbc6L8eC4nSeFncbZ9YUXGVC4?=
 =?us-ascii?Q?tCem0PB9R7CClAWrsBLH4DoizJf9MzmxWtwFZGof7Vui33/HXzT7LhOxGyiw?=
 =?us-ascii?Q?BTDnyDMoTRZRZZs0cL+0FFg7k2BFnq2VctJydOUE3Fv2zuO7KEwE/8FKuDFY?=
 =?us-ascii?Q?el/gcKfTbjAUerheb6zoN4M/nEz+Caw9MGDXTOcEi0rkFqWa3IBTp2R+Dw/p?=
 =?us-ascii?Q?6nnk1ofRxvJG6CvWkFgAg/YHQdmwCQ4qPWH8iSVgsKNaJIJSA+N0GyIYlnBC?=
 =?us-ascii?Q?QEVxWvkbvFXYFDE+0HrXX7JQkd+RTYnPgW1zr252sGw3qtlkVxY327pD5rsy?=
 =?us-ascii?Q?frJujaeGNKcz3Al/gzOXh1qUjlLqsH0e73Xq0sXALZ3tVbM0zfCNMZ7VSf6f?=
 =?us-ascii?Q?3I36nTh/UF7DDiTzp5uIYNfrraDlo4OxWF6N/HcCjNJe0WKTrhCSGN5cBIiC?=
 =?us-ascii?Q?7ugFlIFYJkmUy8h/H4RRSBU1c0775AA3d4gMwiDiKrTEyrt3Nv4oPIOqLSTu?=
 =?us-ascii?Q?Bfdc/aSp+kbvDbhecbr5QmneKphFg146D3b0OAeXjV8QsFxbeUjmlZqd80Fg?=
 =?us-ascii?Q?IMdwHDTexmnHr2/dzc9n4DU9k19+xZEo6fYdd9FClwC8sgL0GUkRZRXZdh3B?=
 =?us-ascii?Q?kZv5I3m9r9r9T8toBfQIcCViYhlE4KMA9o/B4hKeM4sNhwfzJ1yMDi0bitwA?=
 =?us-ascii?Q?ivrjJhRKfoHov0CykTSqJc9RZin5zKDISTUxFHy9NUEKqk+6lY4SAbdlv13y?=
 =?us-ascii?Q?sLyMbP7pqgjZEplQEQE3Rhkkk19fdxBmGufcqiDD78iosV60RLIrPLmby/Y+?=
 =?us-ascii?Q?hpTt7M3mNYvwZv1qDMcnWlVMnJ81nht0epwUYm1o0JLA4Z2e/TPYKiAvgd9m?=
 =?us-ascii?Q?w6gxuOKEUSR0PXoFDhxGZd0BrFOreEEHKVJjCs1063AKWRJYTUnJ2MxE32qe?=
 =?us-ascii?Q?g61gKpaX252Zts7M/f7+RJ1Yz0Tal3bw/n6ouMr9t3FNTenyLWvPj0O17cP+?=
 =?us-ascii?Q?sKgShwCCXYVBSCNxLymN8D0qc7bM4kByW4upoZG2jKAaTDy6JYuceX89DCbT?=
 =?us-ascii?Q?NJ1g0XQNowDZrAwXYXUFp5fc+y6CPqt//Iil1mX7PaLEJPYoxRYkhA4OqtUz?=
 =?us-ascii?Q?CyheXGHCdMFc28W6XjMs4aTX3siQ7EEwPy3Qy+Pnq7ljHzTN12N6QHSHmpLS?=
 =?us-ascii?Q?+dgXapgtCkCZDPd3hs4VwNK62EbvxgtUd6NQ0pjm2RZASVKC+NGfQbh9SLWv?=
 =?us-ascii?Q?B7Ag70DLPjbyeRj1NVnili59mh4e/T4eaewWs/+VwBROwAg/nrIIPp6/TUyf?=
 =?us-ascii?Q?mkWUWdBbf5ul2b7AoeMCfRGk5TVZ1bqfHf1ig18aV5unIMPAvRA3GTMAjOpi?=
 =?us-ascii?Q?A2TYXchXfJQN/cSB8OqrIMaBMFV9MQbrIoMqi9jZLpeGyx6O9xN3efKGCtUJ?=
 =?us-ascii?Q?okastCfoLztig7iWbfM4k9FrE+1+TIE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8769838-1a6d-484b-af50-08da38631c5d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:35.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r6Vwia1iIXAm735djCRU4ECi7puj6hP7LnyX5O+/mdW60utrK7HZrZEeUxWKdo8hsbzmJBhl5RZcpSa0qwxxD6VU6gxsT9pAybflupaIayI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: 4AB8uHA3NYuxtAeTFZBx1uP2xk3OlS7C
X-Proofpoint-ORIG-GUID: 4AB8uHA3NYuxtAeTFZBx1uP2xk3OlS7C
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: bb7b1c9c5dd3d24db3f296e365570fd50c8ca80c

Intent whiteouts will require extra work to be done during
transaction commit if the transaction contains an intent done item.

To determine if a transaction contains an intent done item, we want
to avoid having to walk all the items in the transaction to check if
they are intent done items. Hence when we add an intent done item to
a transaction, tag the transaction to indicate that it contains such
an item.

We don't tag the transaction when the defer ops is relogging an
intent to move it forward in the log. Whiteouts will never apply to
these cases, so we don't need to bother looking for them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_shared.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 25c4cab58851..c4381388c0c1 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -54,13 +54,23 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /*
  * Values for t_flags.
  */
-#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
-#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
-#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
-#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
-#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
+/* Transaction needs to be logged */
+#define XFS_TRANS_DIRTY			(1u << 0)
+/* Superblock is dirty and needs to be logged */
+#define XFS_TRANS_SB_DIRTY		(1u << 1)
+/* Transaction took a permanent log reservation */
+#define XFS_TRANS_PERM_LOG_RES		(1u << 2)
+/* Synchronous transaction commit needed */
+#define XFS_TRANS_SYNC			(1u << 3)
+/* Transaction can use reserve block pool */
+#define XFS_TRANS_RESERVE		(1u << 4)
+/* Transaction should avoid VFS level superblock write accounting */
+#define XFS_TRANS_NO_WRITECOUNT		(1u << 5)
+/* Transaction has freed blocks returned to it's reservation */
+#define XFS_TRANS_RES_FDBLKS		(1u << 6)
+/* Transaction contains an intent done log item */
+#define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
+
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
-- 
2.25.1

