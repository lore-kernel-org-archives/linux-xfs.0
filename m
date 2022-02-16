Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9286C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245509AbiBPBhj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245497AbiBPBhh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6660119C30
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:26 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMrfZV024709
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=GEdyLq51yUIWLhjcxd2S96YwGcwH27cCrxkOwcqpPppnKUAW1lDS9P4fDiaaFAsc1Xbf
 9G+0Gssqj5jqGtRdxvk6EkCgyOxuFx4M/GMFt9or9rrtJ5Ey3BMvKdwyxfd8ooDSu9kS
 v8/spBvCswZxoTZDKYxnuIgedYeiLHKJlENPreoK4nOlwlJBByZmxa+i01VXjEO9NUET
 mjp8OtTCRWR6o4JQxgaPo962c+gjXkFbnrUrrcqBRwuhtYElKNx+LrSsgN5gfrtNG1xO
 vsQINTBOnxta0CzvKlpxQJqRgtsBbZM6EIyOFNofzb90qAJGUw//ELNRE1VXJX4Y+Glw 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncar779-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQCb138909
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2rq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjxI67Bu6YvRlKqjYWSAlA77WPIyjsBN6R/euCbHiOPSsmvvhMbJIvXlwAYMsIqPqLTe16ijOobBd54uA3T77KrkXjYbg/JYTmypTDHcb47goXi6+uldyYuOGlUyKPQQbEUYEta7HCMbbtbLsCLn13wb8/RGppDRAl+Bk64xPgPN6RwbfNcVUC391RMB4Kv5P3A7q7ND/GdERIkqMKo/DK/Gasn3XSLaysIT/Sj82OkIbSpNQ0y1YnK0Sni/vi/FK4mLzYV4ov43QouL5z1l8ei3tiWeE+KguqvmTvK9nucHblViyGhTGYEA5gOx9/5PinKG6tiVh7NEtIRPV7B4VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=m0WuxsoHRr+Ne74der1agH0U6gEoapTuvb6e2raHP4kOvaz5HY3vj6zbVKCyHNmXhCOBfKdg/DdsJZBbadfwGcewKtwFCXWpHLyuPeVFWOqm9Mc3VtUe/RnF9S/9U+SblK0LsgOQqxqqCA9Lv6NCSQy5uPN5SUIm4NMY/IyVzq60Qpg/e6MJYZa9CTpF/GA39JvncIk32wUWf6gJwISDf78socNKqx1mgcPOZyhjh7Hpdx1wL1gVohSbvqmRDIQFGjsrfquzO4T4dVqc6nbUsxA5zn4dJ3qmdCW7gfXM8v89gkRUYKQwUsQIQD2VTBDzOIjbsqAGPYlIscjDslVLHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=H5yo6mI7ohLGNw4VDvk73XAhDsYEkQdjGUteqP5N/RkSa9urbRJEf6pM5wMq20RIZiff0QZ1+dnwat0190CNbpxbKye7vsGEjpslowAaOLtftmNb3RzQgVUTk1p5nvFc2TzsDAR8fqx2W91exS7Nm3FQ3LgtbebphsqkvsBUpnc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1283.namprd10.prod.outlook.com (2603:10b6:404:45::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 01:37:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 03/15] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Tue, 15 Feb 2022 18:37:01 -0700
Message-Id: <20220216013713.1191082-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebfca70b-cefe-41ca-4bf2-08d9f0ecdfee
X-MS-TrafficTypeDiagnostic: BN6PR10MB1283:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12833EFE11D46E938D50FC8F95359@BN6PR10MB1283.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +b+K3g3FRctBC3LI1+JpvwvLCDt44dMIxAYFuL1/UVGxuIdf0lzh5jzJKu2H0NORQm70VQmz5V6jpFALbqRKT/Br+oVVenR72XKdls6gekJ1+wjm7dxP+ZYQ15rSC6VXSCk5MOr7TSB3/0ABGEhVFBjda5vaPqv37K80bwrlW9Y/BC/qCHgCF1nVddt1HURRRJk7ZCmZLF+YK+Tbam3Qs8kAdXJ0h4/NcmEA0YsetzJ1gYG63IY4fT+gYa+78ceZR1Es9oeQfGR/vob+e9IsXySJ06+PvPYXVhpImPy7qDoOJk3VH4RNCi82iZZmKynNo6ZxrfmGphuWz1S1IXn9ur7vMFlqtEtBihNlB4FrHtnjXMOsTf8nR5itscu/1l+7s+IiF58Xwn7f0h8iednkLIrOXO7sMb7LTqSFXkiWm5z0E/pHVYb2rvi11PnW3Hooza5s7U9e+/F3GmmqibF8cQpsVc3mT95ZYpW4jJ9zqYboxD+0d8cy7tosPEhGFqdTkPgiZGHg/IP+hfmUENb1TWhpo6cIZhzxCx1iS8PdtnUdvx6CmTc2p5zx/z6G5PN+GtDk/QINCl2Myfl7CG528Lpc0K/rRP51rDPBDB9GSWu3aeM1b0WZESXU5NURMlhhWBk4z/4jVfgEvcdXdWf9xB+axrPJF9o+7j+jt0KZ1ifDXdThiLk1WTJy4UJboqAdt9PU+cAe3dGHSb8Kcfy3xxnwuRJMsUdqo8KJDK6jD4LewXtjQX738Xpl4MqU+M6E0hrFEh+rjGdGh2sZ6JyvgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(8676002)(6506007)(66476007)(52116002)(83380400001)(86362001)(6666004)(66946007)(66556008)(6512007)(36756003)(38350700002)(38100700002)(2616005)(26005)(508600001)(6916009)(2906002)(5660300002)(316002)(1076003)(186003)(6486002)(44832011)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4c7eksnINU1qQnNc0Oh8kmLjVjxytPHMZ/3TKEswtbh7c39HvpU98msm4Toj?=
 =?us-ascii?Q?8r0rWU9kfxSL6W8s4HNFZJCN+owpTNZk3jttLFZf0nfrrE/d5kTrfZEtAhQD?=
 =?us-ascii?Q?1zllxzV2Dm0UnmkYxMYlEv3fAl5aXYhFTrur8o3lQo/vzoB0KEUAPnd/KOgd?=
 =?us-ascii?Q?K1O5IDeYCa9m2tKu6ywWXHvf6WKPlpC7ObYWHpNuoZi8/9MOce4HIcTqKqte?=
 =?us-ascii?Q?xzueySu87sP5hNebd3wY3oHQg0T4t4FjkX4rKS9pIs6ve6UBwm0bt1jln9hg?=
 =?us-ascii?Q?m4tqRjQdinyvz7dBnl+PqQFFgphK6gPMmdqEd/Dp8Q9rSDReq7LZz7kz9gnh?=
 =?us-ascii?Q?y7oQGKVNauc8ITsEt435k4cesZNTFd0X9pSutw64tSclwvKCGUzqlDE6i2/S?=
 =?us-ascii?Q?B664TeuCtEO6/Y68mafbk9AdoG0TAZR+bbhCS1G88C4u33ANmUWIXn4TAadm?=
 =?us-ascii?Q?T9IrR3EgUXcWqzPiSKkpoOVmbNXHWL+FkH/fAuG7R3VRJmkClln9Fr7YQPVl?=
 =?us-ascii?Q?dtpp1n9OwYetIs90l1dICjSBQNy+4RqlagobTX6mHoHmzNkkNYrqkIEu/Ild?=
 =?us-ascii?Q?KzOQWEiwusMjOVrINCH4/qb2soAzAsP7gcUL/za/ro59MPpKPSXTcq2C293L?=
 =?us-ascii?Q?iXesdhqcBfyAldzFzvJRa4hd+sRDh+omUxIaUoV1XiAYj5K+ff1YzvH8x0P8?=
 =?us-ascii?Q?kY2xxIt4wc8ymQH62A9zEKMjCe/UT6A4admISNktYm91j/cL5nqOQwPcqVyq?=
 =?us-ascii?Q?a5TdrdQzDL8cKoc3LlB+5dX9bigMEWQnVFI7vIb0y4s96di6Qm1io9qIgnh2?=
 =?us-ascii?Q?zbariv0BJ4Wud47+17llELs06PhZSKUV97SHVoThAHl/5qhZE/XCHpVkOrZp?=
 =?us-ascii?Q?7YMGA07prMmMadtcBXix3GucLfz5CxSYlYXwwWb35Mp2DU1HwvoKoGXUod3T?=
 =?us-ascii?Q?NiOdvsX2gtxgERDlmdMwteKGP/oxjKE0Upx3HwffP52W9B5yo/qO41VMvQBG?=
 =?us-ascii?Q?VJXWmkrXPjox+GQKO10SMC34szj2L+m83AYU4X9epyPVb8HNu7nn8db0jtVX?=
 =?us-ascii?Q?t3pQ8DLgUHelwvOPfkzyD91xTL5fykV/R8w6O9STjO3otxe0QLAWkuy5Jvy8?=
 =?us-ascii?Q?PljK8K9wuQDZ5aq9qZ6R2rfkr6ysZbDboAk2mjFvGgH+XiBE4a8Z2HeGzHMr?=
 =?us-ascii?Q?IZegz6I/gTzyyI/dLpaMGgSjMnuwFtMROcs8LB4273SITrvzlpAh30DKIcwv?=
 =?us-ascii?Q?Q/NHb4HD8XvakvxWH39llWbvZUXPaX0C1C0SW+phQh1Gbx30BPVHnKVz9C5u?=
 =?us-ascii?Q?ZJ6sr3jvCoFZKOCxDqnHnjnjJ4HPZIh5li7hNptU2W/BCGd2u/YbtM2+Z9be?=
 =?us-ascii?Q?mC8XI0cmNdUgc+vCUShSRnC/FcD2iHjk5FfHpWX6tq0QoOQbTP6CCsVDN8B+?=
 =?us-ascii?Q?+QaYAopGnsI/wirBP/s6i3xl0um33LoThvRDkT46zZjfL9I5SPqQ4fBMaSMX?=
 =?us-ascii?Q?l56NnTUNt9fg7RskOA0OdIIOeW8vj3qC3P6rjdFdyfDs72enBtjFH637TIeU?=
 =?us-ascii?Q?Kzn3dTAqLSrEWEN2mPcgff6OnLao1b42geka3+LqUyzmowcXcQq6H//MuR84?=
 =?us-ascii?Q?n4QTG6OEgD1GD6vdooNqFk4i3jT4N4LzbvpMAag6GUhDEuLvCY/DgjUOhJS+?=
 =?us-ascii?Q?XyGWcA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebfca70b-cefe-41ca-4bf2-08d9f0ecdfee
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:21.0144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCk3BgtCIPY/XS/YTb6AcriuiHIQ/zO+4plRl7+1KF35MFsRWToJ2lj6jafjNEil3/Pv5voIHoM4euIrJbM2nNtvJRNqoNGjuN42XPno4fM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1283
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: 6F8ZJbmDvThTNZmYgCTg2-wUF0kH7nsw
X-Proofpoint-GUID: 6F8ZJbmDvThTNZmYgCTg2-wUF0kH7nsw
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

