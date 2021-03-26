Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3653AC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0532861A47
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCZAcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhCZAbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0P2eZ040604
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bvbRpUaipwPs9RD8GcYyviomal7AeV+4qbbnioKNnBE=;
 b=0gSz40OXN/9ZQWI8VOxjLS/zwNEQU2gqy0oioHQwtxLJ8IFwf4sz97TLcPwzuUoT/Tgv
 0GLErwwMSeNSkjlqms8svEmqNn6HCoPyc+YNjNjct3Opodgy5pArNxgXtWRy1wPQcN6N
 IukgmX7h3veRYy9PWFqfnVO+L4rpJ+/Y6+AG5o0DHJwTd5IIyK8PpdnuyHcYsOS+ei0T
 ZBzYtVW+1fIMvN+v0kT0kXFNh7c9oaHM845FXT3S6LSKyuydi/Mc4uWMc8s0wnfhOtyZ
 QTmuzsL/s2svzvkFM0JGFO6670bMtOeYp3s3z5t7ZQs3ewAuxTYZ45Qu/at/ApCV/a4Q Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37h13rrh89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6O155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9dIS54hFYtg1LgtgjxOCzDF2mJ/RfBHuznArPWzzZX1vgHnhK+yA2Up0uQNvL2+RqMwnc/ZKu7X7ysoG81+Rq0kp/RK+kMEytxnoYh4YbxiMSUJE+mGHqAfaCdGyDlBEGjV2aEz3pnmb1PFAQYglICWAskSlXmdczOIy9EuYkyIS0D76oNXn0eOxr3HzYZElqBooueC6IqRAAE6fbg9fZnlwADPr551wP1459Ri8J+TJn69Atmu6aJgGIEFEacZGP1lLUiEA0DFeF5vJd8X4vpRusOjJYJI1Bezq4Mg8LdSqN0NMqerJe0uQ8PUzhx9sItMbxFNMaiY4R8fEwg5kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvbRpUaipwPs9RD8GcYyviomal7AeV+4qbbnioKNnBE=;
 b=kRRVw4Q+M9e/ggfq1nrxP8X8QLTN4ryb8E6jU0c/XTT1PJL0GQxow+Tz2lRlhthohw9fggx63jVUB5P4SB7J7AWDhbOTR09G/HDKYOtjbptUo6/skPrzUVcK05wmneWKUvnKA+CafthWa4ERd7KWElP7PyKVF8n7rJW2HVVGHW1GW6YtG73v6pJclq56TZFHKTVIas6rtHAy6tEm4sXRtwwonElRIWg1SP/3bPcA7JKR7b5af/mdfTETUsHqSJrAMX67InVExuUxU9/I3AvIvsoPI6GeT5PwL9nhlAncuzy76TI6TbuUUi7lKhLPlyuLCI0si6oq8JtiO8Jvtt+k1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvbRpUaipwPs9RD8GcYyviomal7AeV+4qbbnioKNnBE=;
 b=rM0SapY2pU4RbhfyVHm97yNcmOWHJWo5cGThbs9+Jh50JUjedh29S+twrSjwwKCQbpLNigLqucC7uBcOWoIPpaZq4Mu3sg65RLbYAr6GEG0rklsMUYeJ3y+cpPPzTc91ClocFJMzwuF89ig8ADFrxx89GBT3dEiDEENOfht3acA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 07/28] xfsprogs: Check for extent overflow when renaming dir entries
Date:   Thu, 25 Mar 2021 17:31:10 -0700
Message-Id: <20210326003131.32642-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0838928b-12d7-443f-14b2-08d8efee885c
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2758DEDC449BA67B66BFD42695619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBMCXNnEuYJ4Jxx5B9sb9XKcJ4WIxAAWSKTjbv9zyxhTv/zbeAZTDysz3DDTWqpWRygdZo22Cfe7qQsfRmGXAjfYzg5D6pjbudqtBPtHZn+gfRiDYiUgGow7vnOyuQCKsVj6mXe1+5Twu7741mJqnfPtn8buqr7wMAyzVwEsHroXOB5WcQAp5ADG8F1rY1ZLKKTz0nBmsZptmteL9zME1Ou0xEIy0g9VPdZBBGwag5aqERJSOI+yYNaWeVSX9Zj1bF2bdeE02/nUTAW3FNNsOKWUTOh0uU241D5GAiLnxTY73r3rM7vw2fwdMNX4InAoLtPDSVQcExica/KO06YY84sw7wE5/U5USeGEVDUoNdFssiqAbffwVBvxdrFSz4gB2PXN8FIBAo+rPXbM5nPbivGcxwoDzmhYK5ooTHbPhuqU/P1a5+dJPj0nrBuq3IjUZVVHUCiPfVqUFR2UW6pEptUHIiYlEV8U2Sd/YhKsf5h+quHRss53+A7S/64Jt1KtSK5p7xpBUR3r8JQ7TEMGj4/arUvYawjBvOS3YlvvVSBS+8dkQPkCE5krS2+/7n4blkAzK7bgI38jgyu4BaBKUfVQjVdU/AtiSUPRYEQWxbSObrtHlmzHewpEUtczsrRkmBTPEGe0abCxvkOIjUKiuvWxYKII1j/p3iliCTThGL4x5KDe5WRmidtCfWLInRLJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IXIJCE0ORfpWHx6+7TICCCtoghiumFY4LtsaCvdF58MsKsydCVsLFH5U/XFv?=
 =?us-ascii?Q?lE864ArAlppO1wBcavhT6EUL/vHFHoO25sZNYaOIZ5wMbiPUjYJ+1L2iQ5vt?=
 =?us-ascii?Q?NIFWk3URgfG2LMZ13WypZLD7i0mvYesNm+6BXKv7WJW0/fk5wdC2qqKivBtg?=
 =?us-ascii?Q?9R5MdrDW1whk9jhqI66go4+3t8ye22NnoGMiv4bV+vCAHD+Mcmu7RtsPjF0t?=
 =?us-ascii?Q?03BwPJKzbd+Iov9XEePohRXtSqqiE0i1p6UMXDRPqhoA0TfigP/XqDEEep/z?=
 =?us-ascii?Q?F6XEIVy2zx1jZVsZohsadRbZNGEA4BWnEnIwcMr9Udo1qpiqb2o2NqYzoltA?=
 =?us-ascii?Q?Q32P7SwhPT09KGW7KpEGOZJNez/GcpsqQQ7liJbxCLQFh9YxIM4noK+caRAy?=
 =?us-ascii?Q?a4l+Emwhm+1NnMNlKj1unU5bAqeeX2OtrKqB1vrqSNjLxkVbq5vt76XNRWCq?=
 =?us-ascii?Q?eiHVx3mXQhulO2ZjBv/y21oXMv+SDwQYvwnKjOLEIxgTVPAKykjwzV0jEKM9?=
 =?us-ascii?Q?BOiw/hUoHEUdhXKSCma1ik6Nqsfa5gifwrf1Vyquax8zfm6LnQYWPphQsaug?=
 =?us-ascii?Q?dAM65XsqJMyZLBJqdWBKJBVLpXGXNaKUYRYFn+y9pO7lM6cYBWcH+grd5Jc/?=
 =?us-ascii?Q?mJUh2qM4CkE9jEmPJcbXeGT+UZoP8bKkCTc7bypvvq0XO0zYsq4T6YHFjiPX?=
 =?us-ascii?Q?pASUkd9LUTAbxwp49sIcLuVm112escG6TeFbSGsVDnVOc1kFkYodo9gxKrg1?=
 =?us-ascii?Q?HTevxnO9BrAoDHlFzMvwu78E7WS7bJARYfwiZlQgzy7vsH7JtB9yHhTvc0hg?=
 =?us-ascii?Q?LcVqBUtAzMhFb7m0kVKu5meB7NQQLMEkvD6Pb4hzBD38nFCYeLMu37F4jO7Q?=
 =?us-ascii?Q?408aYXSl7fxxWV2Ox8RWlkM932LbeDM87rQw/X75qwEEgA9C4j+9qdMrgPDd?=
 =?us-ascii?Q?ggfm8yVHTKJxh/0K5pc7rpPFmr3YF05Wis+nurgoMuwLjyZFVO14gchN3jwV?=
 =?us-ascii?Q?zwqvlHjLPi3i11VrlYnKddjAP5dma/eYmIbTMh9630Q/2vsR6SKE4zoDZ0hR?=
 =?us-ascii?Q?tzC8YSbtHcA41FsBij3yLOGUbTzH56nz7ksvEqV+y0MFNP9CUEiV23yMSPtm?=
 =?us-ascii?Q?3lT+6lZPQqL6nbJxV5F/LtMAYsRtxAEE3iA+XWOFwF/MhBEnhulZo/8WV9V3?=
 =?us-ascii?Q?h9yqSXeX5KUGzpyxH1EOjVEh86n/IrIAHHZQiIAW8lFqKmISavW12P8omYnW?=
 =?us-ascii?Q?uDkEplXS6g3wfkD0m8lbCn0HR+0rJw9SLfAaYIfVm4NfnHTUwEsI3JZQjq88?=
 =?us-ascii?Q?MU4U2Ymp1uDtWz9L4+eHCH2T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0838928b-12d7-443f-14b2-08d8efee885c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:44.3250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AbGTVWE8vxMB4e72sSN7Zg9pGu+AojCp6lsha3B4Yl/KpRhhH2jl4AjcfCrJiIeQ4+SiJu0GQ+UAuEfewcNC1qdk6RDrTgTZvkq0KxkNaY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: rFpOEKOxKA7fRVFScZm_47XH8vAeQqLM
X-Proofpoint-GUID: rFpOEKOxKA7fRVFScZm_47XH8vAeQqLM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
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

