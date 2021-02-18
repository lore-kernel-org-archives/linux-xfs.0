Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B36C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABDBC64ECE
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhBRSo4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:44:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60366 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhBRQqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:46:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUZ3Y059604
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PAMUuACTRGIujAa2Ft+VkOaXt1vGoXhu1Bn3MNi2w48=;
 b=lF/CTyml1kAKwDQJLpl/XzDBH1EEN22yZiX9Uu7EqyIq4zyTCuGv7F+EkkFRyQ/2NhS+
 CH2J8GVkOA/m9cu7eJjzPy1ChdG+eE+iFV0rGSTPUp7LWYLqnyA8fCLnZZyJA5/i80Ta
 1R40nmgvOU+MhKpSHbziomWoGS9LfFTiNyodcgwhT/N6+An1h/bD1AMvJSR3TUs4Oqn8
 B8/itokGf3KSfblE3Cc97SI9nbxVSj2eRHSRpXL/RMPnT7Z4b280eXdWje0pBLQbJqV1
 FC6VKWABK4SUf67+O2aSlIlEKp1gYSsLHzAd42fPy4yspyK10lYRL51vlHenI9cE+zNL Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bersd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUHT4067740
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36prp1rjuh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlCXH2kRCT/SH0YNZvQj/YnN0XcHrZlxXPrL6D2ZhdbAb2X1s899neyINS4aW/shXr7moxlYhqZfBI3MFzmFnrUbVSFC+0FogrMcy6uQh+JXeNCxfm3KrTDmqm05Wpw7BUyXEfI9n44QMuTjHwOfEEGVgaBwGNlwWIhoXPBRP/O7LJ3cbm9TlywXF2tXRLicD9yqd9f5bFoaKWLXE5gYNSMqvlV+VTPFrHhKuz335bSFI+P8HI2RDqThOCi4Ad+7vmgESJecl8xtZ+jvDmG26QFg8WIFxu0aZQwCOYUErYrCQZS+6w3ezEdXcApx6D2mZk25Tmem6KtodLmiUuaqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAMUuACTRGIujAa2Ft+VkOaXt1vGoXhu1Bn3MNi2w48=;
 b=TsQMROj+wJKjCrxe7ZXlS3phCxfkbeOygPrO/lOCrTDBqnR6BP3L2cGnro5m6m7JTDV7qN4TwKX+O7M70pRrCWc+c0aFHseflYkOYa2Y3SAD466YkhZPmSJe9qzKfVRWJRba9KTG/iHB7cbn9de3vHlMi3f4UTgr/Q5txOsUDecJBCmn/JsrQS3/mgBlpBD01AYy5hgDrK9yU9KaPWDYfNriT2No2MoUYcotdpvxDlfGA5zmmdCh1ekWatWOEZEQBsS2R8R2luSEuU+Nx/OZ1j7kqLEw4kPA+Q/mN+RJ5b4gApVcwkp4NeWJ598bI0mTBcXEkcB/vQP5Ju2+PUvOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAMUuACTRGIujAa2Ft+VkOaXt1vGoXhu1Bn3MNi2w48=;
 b=f1S3vJS03iX7tjOIFWJwdDmTEYnJ0bsALymCw9++k31QfUy2NjgLfayx6iegG97jI71PUuP213cnWqS1IUoZLQ/mo0RP9NOvwCvIKAIHkEeoNxuvzSa6kNAhg1bcapkJUlyvkoMmnqsk4FIuX/T5PVAB/iPSYvueuoB+lpp9LB8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3461.namprd10.prod.outlook.com (2603:10b6:a03:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 18 Feb
 2021 16:45:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:30 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 01/37] xfsprogs: fix an ABBA deadlock in xfs_rename
Date:   Thu, 18 Feb 2021 09:44:36 -0700
Message-Id: <20210218164512.4659-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcfe9b26-b75d-4563-2055-08d8d42c99f4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3461924F4100EF3DDEB5BBE195859@BYAPR10MB3461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8d5OTtu+SoaGr9zQd4XgxqgLj+eGvM3UAHb7rp/4haW/4QS/3XE+Q/JBDrZCn7NJUBnMixCwaQ2o+YDZkBrL46WfWZe4Zkm4e+IXSkV3u5OH5061aK3xonMyG9aLocMyvCxDMGKbURw3yTuK805G0wMrUuOvpSf7yvEsIq6aOWhZk55yFRCyx6dHEekOIC7ODb5G32MV1nZ9IXHziqUc7oDH+jGaZoi3n9zCItdQVHZiqJMYwx+g06m/3Ic3Gy59J8iKgZtHhQzWMsh5XECRtGGzgMSjxjh+tk+nNrODZSYZN7h5OPcP48CNwgZwrafa9X21tmb8mRV7ZJmGhx1BDG63jEa/gJFpe+Zf+J3XNoOwfrIx2RUrgQQvqVkpl4M1F/OP3EnhBk1Fc5HGiSHvfy7fS2rHzKSNZOjyKj/FE7CWMnisDK+Ogy/JRisleMrkesRNX84/DFNbABUszsYCyuXV9lEWY243JL53Y7XTGlVT+ALJJ8HoeQYSLUcurCnoiyFFG909mHdmBBpq1PVCOG5MhZT9yNFLxNXJGhvhz8EAvUdJq9w9TqUEdK2v7Ww0kVXw10JMcNysQCrNSVbBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(8936002)(66476007)(1076003)(69590400012)(6666004)(66556008)(2906002)(86362001)(316002)(26005)(6486002)(52116002)(16526019)(8676002)(6512007)(186003)(36756003)(5660300002)(83380400001)(956004)(2616005)(6916009)(66946007)(44832011)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1wapOv9HxuPYy8FSathlSR8bdVRAAYtHWSV88WqI297GnX3UXpC/KHTwFhed?=
 =?us-ascii?Q?nr8rlSXqB/SyrDsC1AZh4UVk9PEU6qbFO+ZmMXnS9PQW8Fell6hN05lOKj32?=
 =?us-ascii?Q?PqThr74GpbVW+p4gj8VDHAD08lIIudeYQwN0GXm16rI0J+ReFkNPQmOuJIVS?=
 =?us-ascii?Q?X950ptfZg4vOkkMpTTnezUcVqZmo++EgXaEC8PxRuIvmDlpeRDAnuc8IY676?=
 =?us-ascii?Q?969hj9DR8tMT2tvu1yrEXR5OdBgb59liwCprQI6K7P8ANBymYLZJ9UDTa+2g?=
 =?us-ascii?Q?xg6gqth3Q0I2462uKMBDeghe/DyTKAApEfgoZpcZkJtVehqFouKygtO9nwhC?=
 =?us-ascii?Q?9LYAxGRBcUwnP8eGnalFoUPj8hfpBVTwXQekqRkWk+IRfSx4Y8FzT/i0OiRg?=
 =?us-ascii?Q?o2RjExI7+3QOGX3x9n+8bOF/8WNHu56uF4SHzSpIkg9IbXnqy2bwePSkb+3M?=
 =?us-ascii?Q?k8id5RIUxsVGFUE584krYQ8T1XsJ3FuM10/32SGFUyTqVSaK4n7vD8FjsCgk?=
 =?us-ascii?Q?4ygXGIwzlNJe9vqB18vaHKAkeGIgCaD+TYaNDnSs6meELIN0vSQwjZHUHDFH?=
 =?us-ascii?Q?5OXemRfuLGilZLsasFpRtx2soOtkNrN9z8yohplLHBLGnS/mt7VBxJJTX37r?=
 =?us-ascii?Q?zzPvCAkw0wlpNTDKw4P9crBv17GBG3e84c3LB5zk031tmGVo0ZVAlKYs8Qwi?=
 =?us-ascii?Q?CdaP/6O6TfArsu2h56FujhRsTNtkmcAiIaaS7Tn/69k7mpQk7P6cXVkgc6D5?=
 =?us-ascii?Q?lBOSjJVRanY9tsQNoocneGJM5n2tUrudnQaXEVQFhSgOXc1V0GxKgw6Ltahs?=
 =?us-ascii?Q?oqZKk0X1Y4P3kkAYbqZxz0vdwG5lfjZJEazs0j3Y+beFNUz7bhNUKRdtXaSr?=
 =?us-ascii?Q?koVUHAEfkfV1y/HRR0pJ419zuJ2fNvz/5BvnH8UmVQUHyJ0G0Tx2bbKLfjuQ?=
 =?us-ascii?Q?nmIoHlMbBHlQ+033yh/170m1fkMS9gYQ+un2aO6/vWCqITCvea8NZ2wS2bR9?=
 =?us-ascii?Q?6mF/NvK81AQl3g1IwPvSNhUwSr6iPVrd6+g1Oa33hJ/pHsR9XOX/ieWT9HBZ?=
 =?us-ascii?Q?OXk9QpChblrjZTT46wGsQw9ud/ZGSmTFYtPLe8GBz6OGsBlifV1/oHIhYdgl?=
 =?us-ascii?Q?FgAJkD11OKXPV1OUoqHnZTgzwRG7E8iC8nu6Ma0exmcjynPQop8sdiQPSEcZ?=
 =?us-ascii?Q?6ih26AUFoHeboVsDyyeApfG9H5zxvPSjkYSD9xkbdON7wEwWT6ixuiRPoQjD?=
 =?us-ascii?Q?toJBqe0vXlu8lAEwTnPbyj0fkexK9S9k1tXeF26iG3YTjvJrT/ADj9AogBz9?=
 =?us-ascii?Q?Mknnac/Y7MMyUVP6Tsv9Cvsd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfe9b26-b75d-4563-2055-08d8d42c99f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:30.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyfEsLAlJ4CUgDQ24sKFQT0HaY9rMbU2fXCgsbfAb/6/24+1iQ5FnOu9i928+DJwTxYLdsLjQ15N/7eslXKQx68xEgdeWJcdVjOimC4qwbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3461
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: 6da1b4b1ab36d80a3994fd4811c8381de10af604

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in order of increasing AG number per the locking rules.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_dir2.h    | 2 --
 libxfs/xfs_dir2_sf.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index e553786..d03e609 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
-extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
-				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index fbbb638..e5a8e0c 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
 /*
  * Check whether the sf dir replace operation need more blocks.
  */
-bool
+static bool
 xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
-- 
2.7.4

