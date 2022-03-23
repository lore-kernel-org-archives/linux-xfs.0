Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874FFC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245058AbiCWVJJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344477AbiCWVI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:08:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426198CCEE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYYtH020573
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=gNDY65Dm46G32QZ8cR64+91586PESZcQ2QGw01HzapX3hyQorWUse9OLwjyQBY47F5rU
 yUMeExKBwkD68jvKvxTkdD8voMHXoljnO4X36Kz7i7nF13qB5vtJKmlETtBEjedc6Gu0
 8WOGRDHirtR4ig4StoRZ3cAPWv5WRz8trsdQA1cQhiti0E3DU5heR8PST12N8z+ND8dy
 QjlzwlA37Q30IlAeoevegalMQigz089DwMkJqexAnDsYlqr3nqxeq4Cv6e1GJaR7emoR
 X3lE7ZCELnJlV8XI/zDs6lkNatOlAWXOse6xme5Usl99wh4vMXvqGDpeQL5gQvhfraeY FQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcth7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6LdA082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdBzIun5i078H0qzwg5IQGlBPDU6ESCIznW5rXETaesWdtW2pjn8ykTGmXylpnG+oigXZ03SUSCJRvzDK6GyzBcIk5dxHjQ93J7lFeDZyhGwyjvglBRroJuDwA9ixVPzC6C5jgQamSXR9yiDCj92fLlZRPXVmjJHVGcR9WdaGIgZX0KBhtWm1/0bQKfvMjPxomlV6K4YzkMGeeRL0ruFzZSdCohIGoghKqMMwnwW8J8xWGTCi9nXgdJPiwHkzu6K99/lyT5i8jt91wdkLXn6Mv5wYUpZSf/vmLrjzvKtG8KgUQ01J6F2cQbX8dq7Y9iotafszeRGSsP7I4Ml91k6lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=XCxBn52W7BohT8+yRdHjoRWHEG16x838qGoT80aIbwhNIYinAwIkNkh9uV/j8Z3NXYUB8RXoSmmCPo1nPbM/f0mIPmSWDoreCz0iSoPfFqZBU9HtJreEdnhwid6yJ9YYRXSkMETMyYsBraOJy89LcUV7C/5GRLjwABGwJqL5H4rSJZtRAgdiYpx37SfaBhL/8/4YwgAqNdHtUDlRPXaxZszMHSE5aJEA5BYVKwPhxhrImJfY7o+r5sDYY+GRfDy6Xny35GG8GT0U0goT4qobmCWCbxwd6Vs+AJ30VXRZoXjLIsok/4p3WhJJDRxCMiHw+pgdAVVqMlJFKk8aDpXtXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=K/jT09NHmWSTdNiEpOyCIvXKB2psK/dcuFy+qBv4z6116XWqA6H+L6Dx1fvVa2nrH++jrTbsdtpcWZmyHdUevVJ3ovasbHNuFZv5rqnD+FvkfJqag1O8qHoGphzjA3Az0eiMtmWQN1gguKS8rl0fgpZgezcO8pCq+Obh2TnEBcw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 03/15] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Wed, 23 Mar 2022 14:07:03 -0700
Message-Id: <20220323210715.201009-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2dc0cd9-4d27-4f35-e439-08da0d11205d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47442947A6DBBDD4B616018695189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JPlVJFjI9mn8i850Shb5CTe6bEVQ5/pxbKH52hM4FsdM972vQ5j36+6qw7/5FYDlnoiz+bcyEdP9DuPZBpUck2wNdYoVBhmxvJ4M2L0c327h8RGibswrTYl3epXYtq4VKA71B78u5CEQCcJ+/gXo115N3CPWoOhN7AHvTyB2vN25bMJT7ECYGTFXhvW5yYFTIYCrSvXHNaDMnvB/WgIJwsP1Zq+9r9U3adUBj6A3v52epHKaZ9ATf2YSZoYdM4qK7BFFFG/RU+fn7L8xAZ7woJuZQYniCJEBdDBHJHQttvn6EZ2Ac0/vmsC1i6RUcPiXgcRuORwJosoizKBh3iOHX/l5fnb6yTbEmJw9bKSwtIyi+ser7e9IlA+BDvR2GNzJTuYpf1yAMkKYZD8E5t5PhNs8HfpEF17H+BO+VYaouok1QMGKbu/gZtH4gou4Fu6v2km48Izmi733VeoCO0tamaJMPC5zNiH/J/Ms8x5RLgY+HOmsT8rc/9kT8mS5cBCNd7cEFdhZgAsj3YEkfP7FidDIRg2L6jIkF88rxYnPkw2p1luGvqd4Ji0K20J/KeMpDTJxp9yeIkwy5+B/MIjvwPTU/dBnCVFGnh9RpR7wIVa8dCFuZ2kbZK1Ig0MK5vhZFgHOVNZHwsB7MLFta1W7/ULpfGoS3iyULk7UeWIIN3UBBqCnFxrUvGV+pDu/E4TfLAx9U74GQTIA0cqOmR8hOWmKGkz9VXbQE9DO835Oad8U15hJ3DSxLrzwonCI9teAdb3lEfnMKE7o7ATuJXQ1Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s4zI+PxnEwfTejgyz1rJBS5IQXF2CsOlRXUqrY1hSoIWaiUkblHyIP1bGrVH?=
 =?us-ascii?Q?+MWtKDkm7vtgUQabE/blaii7X5zvGYxVT+q9qL1sWPfFjQTrdpIr61a3pUxu?=
 =?us-ascii?Q?BCWvV5Y038FzFWi0jj0Jb3t/LBDDTODgBqAVIbjDbNO6VNOGCaMF6Pl4B29T?=
 =?us-ascii?Q?P6ClefWw+PgMBTfD0u3LEVYTSp/OxMZKSTw3l7w1QvKml8WoxVypTWr5bpM2?=
 =?us-ascii?Q?kUeMpW9gx1SwBxVg3U95drz5HnQi9T9pcKydv6v/f6ZQ7GQ13rBkp4eigmkZ?=
 =?us-ascii?Q?Zv4aDv7eBYosUe/itiJFHqJIqgHCtyXtSvl9+h6WwvgcFw+Q2hCfBDp6aYna?=
 =?us-ascii?Q?gdfr5YOTb99OpNuI8WD6GHmhBAqKAsVWerb1qBm0Pznossb6AboxNOpJ7JKd?=
 =?us-ascii?Q?OY4fFmScXeJ4x6FKVani6kMEQyxKo9L0RPu8gosJ/goR4fkJUcAQOC/ETbmm?=
 =?us-ascii?Q?Q+Avs1UXrHzRvZ4xhDrVqRUfeDokW+lN76uXkZsoHXX/PBx0/qZytdhHQZhU?=
 =?us-ascii?Q?JzTBuG0LpoX+LagDcNSBnxMehQl7/mzKicv6a7ziM97y+5WK90ycG1sn6FsF?=
 =?us-ascii?Q?9WZcXfF3mc/A5cet3kxacaNrdhVZupwHJsqm1Oc4bsf1z4K16SJdePz9eFq9?=
 =?us-ascii?Q?9yhP7PZIsDlYSqKDSO8d3aSRT9x/vd3ql3FD9apg6JMp5KSc7ONI3unHPJHV?=
 =?us-ascii?Q?8anUJyILn2zH6yBMwIrSnSfAwKf5CYaXxLJ2lqRMBf4K2PuRGgK7qMySrzno?=
 =?us-ascii?Q?n9SdXB19q6KFmrKH7gn2SWhT4FPjhk5PZXGdSIOzdzsZlgEmtfukxyvSteEJ?=
 =?us-ascii?Q?rcr7m+s5HRjxnJsFTBiyGN86CW14keVjtLZzhrMcAMZ2c23+yo4XD6yaElRP?=
 =?us-ascii?Q?EbrX/1VORSoRiIPy0/tQoDjAyNfp145if56EaWEYpzMP9X7WdLI7xHceoc1/?=
 =?us-ascii?Q?jpVC1qC4nJzsLd//NHBd4su+D8MIS3AP79EwNGBqAEQ7hEyikUNfrq3Tv3ei?=
 =?us-ascii?Q?NOPBdipwZEzMmgSYzz1UhUfNL9fL0CyuZ851s80O/lcN39gnHvRpvu2meb5O?=
 =?us-ascii?Q?pqZWGm6bFqLfTZkqyngnR5ReIU7MW3AqwPLmrSBMrGQqJQkN31sb8QIUnUIy?=
 =?us-ascii?Q?OiI9NkczDjszac9XHnG3EcN9wiUvAjdb0KxAbZhYJJHbOi1ZYh7+2Xh/ucYz?=
 =?us-ascii?Q?XQafGn/e/1M5w/7E5lqoA0dbeIFQq+2uEoqOT666hjY7YLlpEIcue36Y+pyq?=
 =?us-ascii?Q?IqPmTJXrByy6h0t0YERoRhtrXTxHjt3pFLzSOvvdO4hAw1PNEWvTabJz+tpw?=
 =?us-ascii?Q?ocS+UKYmVMotv2k38brrfqtUxf9X6Is9XzQpXxVX1cqSVnYNLvPj9gIdvNDg?=
 =?us-ascii?Q?8rlTKH4ULwjxhNDmwHY7QjMyALz/Tlfjc26cnqL7sd2HJpYs1l047vwqRtum?=
 =?us-ascii?Q?7a4kweAbvo5QjmamO4vHxGSx/IIvc+2QvTwp9O54sJ1ZbgFNmTCKLQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2dc0cd9-4d27-4f35-e439-08da0d11205d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:23.6069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oo8oOOcyJtIfuSSSA9oXNibnuvTTIqjM2c6ccYZfVlz5itgm1aK4iw9O/IOnCji3kRDBhe6vTR17Vp3Hw+4aX0I+a9yLymkBK8HxnqjjA2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: vVw1PbaXFPi_bM1ZaEXcVRVb1n9DZzNW
X-Proofpoint-ORIG-GUID: vVw1PbaXFPi_bM1ZaEXcVRVb1n9DZzNW
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

