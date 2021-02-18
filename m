Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38917C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54E764EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhBRSqB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40722 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGT0Lo155614
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bvbRpUaipwPs9RD8GcYyviomal7AeV+4qbbnioKNnBE=;
 b=sy4C5gzy8DT9dGudLgKsr26qzUixZ2Gfov27CsgUQKT60guJJ4QQ1/EXB4rMv+8N3Dyx
 hQdgOxaSdbJO34eT5kOCdoZhJLYRWW0Q3srbVT2C1o0P/PXNqviYSlOyAsjGr2Wsuxmz
 q7blCNn0qkfUSR6cKVDSSVB+83L2Qda7m0pS9xBZfJ0aNHe5woJxpyRDAdoidLXN+/+A
 VbDGdePXzB+3+VhurmcQT1HuG68UW9tM0j8aL/jRUfiPxlcRPezEwNK7fd68QGo0RMrQ
 /W52X85bVWEe9RlDO1cZsPyfXFO9iq+nyaAL7cI0fPZRvJB0MRwz7jVbOd+FFVZl7Ani Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36p66r6m4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUSZS114925
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 36prbqyww9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjG9qHY0eDRm53GiUqzrdNoXolLFZCUtlx2go7U41VDf2Ck/pwgVr/oU+P/+g4VV9rhA19SK4x6RWP4lSOMfNmSA5r3r+SA/16VpTzOfvx9iKX/exx4TL651HLbTW1oVk5axqgrrVWrqOqfBUDm1kpQEAP1VLU1Kd+cuZDqhfxFzpxFjkKEXfShwJnZsqHEx4ZyCCWXPjs2NQNoDh7R66PzID5vaQy1yeGUlgfSniit25kMGjmHPIDTTSYIbfBR9lgMupv2fVf4ZrUp0XkQiwS5O7kMAnfTvMWVthYR0j7C1EVwpf01jAHlnr+OsmGov/y10ZZUEvX0TkzcZ27acvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvbRpUaipwPs9RD8GcYyviomal7AeV+4qbbnioKNnBE=;
 b=XmhdjSFAPUqDQ2hDCACCZdd2ErJCtPAW+NFH6u1gGzSONXZFYgEVxXy4t6UfvoDi0SPTsTSqLHZl2sfiaV8UFi10s4IuS4EEx6cR+RmiwyzWiaWwfeRtP8lZZEpWd32GRplV60+EH/cGp1fAE2qsqHWzwz1R8hhBbLlqJNOCb5NOuvDgLRFBISHV9J2Fykuh3CtrtSjpeV0nuxd8KHAmlEUYdyxHny2R2gGzZR/w4FnyN3JiqX/bMV3c6tJnoxaq5scTb6GYIFfHgrp3PY3h4UUl05oLecCwxANqHGFA+1qfLBeMLtVEh5abgxx+eg3Gwm33RJf2fqcKOrbSSRU4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvbRpUaipwPs9RD8GcYyviomal7AeV+4qbbnioKNnBE=;
 b=neX8SMypnt/Ua7oVg8BZNJzX7iVZduTp5l1eoq8gB/VzPd1nDcYvJvEfyItCULyMi2efZ4tTC6YOxCALbfLm1ZN8o21OerxIOJ86MaqOU9NMMnURD0o2EMPycm046a/gl1e8vMvx7RTWOk1DFDcvYxRV2cKlr0x8O2z7YFrJ8Lc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 07/37] xfsprogs: Check for extent overflow when renaming dir entries
Date:   Thu, 18 Feb 2021 09:44:42 -0700
Message-Id: <20210218164512.4659-8-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 064c274b-eb2f-4996-47a4-08d8d42c9c59
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4495E9ABB552ADFA5E5261AB95859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40tONnggPDIKrssNSdiF32blswDmXivlJTGe3SpmdQ1u6DzZtk6MioTNepmNm2uAc8B8+mSRhDmVqoXqplZh8Qt1+DcrcMi/YFfD9hz2GUFc3s7ymINJ0fCehd6soAR+Ltd+RP+eclePDFY1NpWXi+812rw9Hs6bZi5OpuEVQu3ffSB+HZIZL7Abh20kSENkzupLWo3DlV86oSQair9Gi4vLCaBY70PuwEKigu/VWJXYuB93eWWVuA6AWX34xJWmd66iHYr+ttu1rGMQ1RzihbVVnnF4VKFdBKYX5eUXfCoUP9dHt+Wi4BovI6CkgPFp6T7e6YMquKrlsJ11e35boTZalpFcdDsB3U8FqMqIfqVTm2B73if3b0lI5C9FCuF5MZ4+hDNHJiyzjdcV1V6keQr5h8vCZp2jObon582PkVuq12na02hRvUat8EoOuLPxw3bD2WNboaCz+Ngg1npWPj4gjJb/pghoyNf2NFHCysFvgZ3DAOL95v/pDfN/RU1fqqGRwVimCnTqTL5TUzH2K8RPUlADHSMWi40kVIPxyXd/P9EdJ1MoZIlyjvWGewifQjo0cyf+uGBvODzwAezNaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(83380400001)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HQMtj5TRZ3aXvfgmEBfj+7YE+uqGChxglK5vyoMak2FSLLzRHYlGnePnSLYo?=
 =?us-ascii?Q?fuHpNLC4E8w/1N/WJNAEIUQLdBQ8zQjsmsPVzRP49GI+LXi+58nHU4xg9CY2?=
 =?us-ascii?Q?VvqEjhZM47OFf4CIc6GpDxkO5438kYTcusrKFsrGZlKivyPLQr3ou5G3wxFE?=
 =?us-ascii?Q?BxxvyQTMAIaUCEQdverGb14zWg4jO41wLieIhZPhKG5HLS5yONL7EhUHVIpi?=
 =?us-ascii?Q?+M3VjkAWWatoZ2toJdWtG3sKWcJxhiU3iJry632EFFrvDb135VV02bbNx9Me?=
 =?us-ascii?Q?N59HNvd3cSDOEWMuISv9s3MnSr8KwE1slWe00umgqXlrNj/BVhN0BB1xgVQU?=
 =?us-ascii?Q?nBu1I59QR5kIBhQH9Yig9uEhnQTEyCMSnGdENhVzbO8YJkZUyq6UY1731j/n?=
 =?us-ascii?Q?QP33G3kEit1BPYCkTInywnpxxv1lagqxCCKuQpDLPEbme0F73GcFKbRkt94R?=
 =?us-ascii?Q?p9aMRIhw0FWZozTv3WD0gWbgTf7WtdelUn1Xt5x/ACKJHaoTIXgkGyZAhwFo?=
 =?us-ascii?Q?wW+sNrHGf3h7GKrUPJqRFInmOS6zwNK8/gqB9Re9U7pRuRWEC9yfAEyWcc4v?=
 =?us-ascii?Q?Qu/5NZ+827IbExIsE6K3Wak/qh3/lGKAsxqYX/1Poqn6HlW7aXoU0CEIvRNw?=
 =?us-ascii?Q?3dRLICV4CUtHIxwDpqLZlsyhmZ/UoFdF3tmMvMW+FyrPRGRywi2xT7DbOfaz?=
 =?us-ascii?Q?JU8SerqJiN+DhIqT6EsBmrJgq54nXZlngBn3+06CVOoKIX5n1HCwJveX+Ubc?=
 =?us-ascii?Q?yHLli3MlMu8Run4da+hLP4c4iKlOK5QQsRJ8KcNmzNMHqwFxlKwxhBgFYjSy?=
 =?us-ascii?Q?5g1ozBqL34PZTbwkX3QOOvi034jWqVbb0pumUA67E/uiGBgej8hN2Z7g7RNf?=
 =?us-ascii?Q?1guPEzc5bOjAYgguq8lEmurB5il5OkgdRWFndAYhTJT37Src4IwjoY+ANYTv?=
 =?us-ascii?Q?oFi59JZy0iAzBhkaMpXJJ7rLMBUj86P3mhtDoyotSBSIJfD7CLmPm/qVs/m9?=
 =?us-ascii?Q?qVovsCITfctZUPKh7qdg5xu+fihpZrhcaW9pt/TMa4/c/3aScm9x8OvDxljd?=
 =?us-ascii?Q?J9VxU1w2z1zmuKHZiLVSyB2YeLxLS8Qm1vfF0KL884WGjyX5lLmmes78kYw+?=
 =?us-ascii?Q?hW0Oi1hos90lQrGeQ72LoqRJpuVoI+YvQHB7Y4GrO3c6etRksmc3N43j8jR/?=
 =?us-ascii?Q?Wndwju0Av26XC+zkEGYVS0eCqMyTFCvXdJNdXufKlz7s4eyZp9tfwzMfOOcn?=
 =?us-ascii?Q?UxcVAEmR5/2Hfz2s7/IZpj41koKF0matNDWGnXGbhvpGro1nNPDlzV7NBgsH?=
 =?us-ascii?Q?f8rsutbSYfxTka4gdQZVRo1y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 064c274b-eb2f-4996-47a4-08d8d42c9c59
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:34.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CYqX3BUARer2Ue3I9vmvtmavgWfVh1YnRKVx8HuPzJpw4Ym/ZEYJRXkYtqRE+r04Gk29oHtmM+SXqj0wL+Saci0JIcQ9a+mcgHkKopmaKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 02092a2f034fdeabab524ae39c2de86ba9ffa15a

A rename operation is essentially a directory entry remove operation
from the perspective of parent directory (i.e. src_dp) of rename's
source. Hence the only place where we check for extent count overflow
for src_dp is in xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real()
returns -ENOSPC when it detects a possible extent count overflow and in
response, the higher layers of directory handling code do the following:
1. Data/Free blocks: XFS lets these blocks linger until a future remove
operation removes them.
2. Dabtree blocks: XFS swaps the blocks with the last block in the Leaf
space and unmaps the last block.

For target_dp, there are two cases depending on whether the destination
directory entry exists or not.

When destination directory entry does not exist (i.e. target_ip ==
NULL), extent count overflow check is performed only when transaction
has a non-zero sized space reservation associated with it.  With a
zero-sized space reservation, XFS allows a rename operation to continue
only when the directory has sufficient free space in its data/leaf/free
space blocks to hold the new entry.

When destination directory entry exists (i.e. target_ip != NULL), all
we need to do is change the inode number associated with the already
existing entry. Hence there is no need to perform an extent count
overflow check.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_bmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e3c6b0b..e9c9f45 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5153,6 +5153,9 @@ xfs_bmap_del_extent_real(
 		 * until a future remove operation. Dabtree blocks would be
 		 * swapped with the last block in the leaf space and then the
 		 * new last block will be unmapped.
+		 *
+		 * The above logic also applies to the source directory entry of
+		 * a rename operation.
 		 */
 		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
 		if (error) {
-- 
2.7.4

