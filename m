Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D1FC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257E661A01
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhCZAb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:31:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38466 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCZAbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OZ2H066364
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zayGktjTziCYHsvpZ7Y70sIEhUGWYy6e4ZjjVOk6Ba0=;
 b=pbFNNt5nAQXNy5eknmyCBV8pniiBtGS38sGLcsvJ3Wch2+J3kojFUS/1IoYfycd9BLTo
 v1ZVsdw0jJjQXlgAHHzylHcAtLKRQyCA2wSqTQDAR3113hQzty+abxk/e+Ec8wkz3r9N
 Hj4si2PFsr4JjRr79hIJqzDgJBaL3dKy/g63yT0+6dPaBDEFYfBCa3Axmc02T8w1wr+z
 6FMHXbMvrrjrP0fS73y22/56oP76WKkikLkki+SAYfUKXSxqzVcVLrWWQMqMo2DbNoES
 xOF1RPBMG791Vq1JJJ0LmBYU0ukg3DGmzIkqEmutUqgLwzcS4NMrH7vgLwy1Uau0nCvH 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hrh5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6K155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJO8P8SiMgywCEKK4nCAMiAn3ypb6MCEtjAWLa+Vu81ZtSrtnzGGU1YLRols2zXQKCpmaywRhBwxZoTa6s0zSor4vlGmznJGkNsNAtdDnewk1Ohwi9zXZML/4wmY1AXAx7CUys/qFs9htfeDryEXH02lFdbS3PCzU0FKv2DojH2cq0Y7xa6dmVJiXopv2l76yzVWVC72o26wXMqiP/m3BkUx7YGAynUiGliP2DKuz+Wh19GalT12eYZGPO7SFf9ECg/Qmx+PXsOv454N4V/p6tCrxbzdCAq5U+1KnZVWN4b4pObXEhp+NMX7/Nf4RcNeDYz+IQ3vmVuiJUTyoMgxcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zayGktjTziCYHsvpZ7Y70sIEhUGWYy6e4ZjjVOk6Ba0=;
 b=E0lCZFnsiN4yoBh/61itucjXTJLB/9A5AT8KPClgneMgqSlQmSJjitMr/7v/kDd13DVc7e5JHwwJQQ+NhrDdIWZCSxEMs2YysU2rTqlSWpzKzJL1SsZIg/DEvePCIGBaemK3phDC0k86WyXVkEfanvT392PotQFVgiJsahfvUpMicFOSVrJ3BX59k5J1Y6BGIVSMKzVK6zcPddLlFnTFnMPJKqW38FTnvlhWDB8mkCZwZSnSyxClD/eUhv6IMAKue3WeEc9KWd9v3qEuC3SYXQ5/v+pain0MaYlQjHiLYoz+L7wkJ8rG5S9zHjgj6WyKF5hIUeZgftguM7YYA43Oyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zayGktjTziCYHsvpZ7Y70sIEhUGWYy6e4ZjjVOk6Ba0=;
 b=Opml+91oIcxjybuvKWMgAW4DeLC+8qmxXP/JLLTproUEYKnjj8ncIJwW40j1AtFGGBWEnUhHgUqpjgoJnEJk82Mhu56jOzHFrwGJPd4N+tCom423n/Sj3DA7iqN0KA68UoaBxaH6opGdF+A1ZXQk3T3JcPBQYGLVZmDIMy5vCVc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 04/28] xfsprogs: Check for extent overflow when punching a hole
Date:   Thu, 25 Mar 2021 17:31:07 -0700
Message-Id: <20210326003131.32642-5-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d234dcbc-3c2f-44c0-11b7-08d8efee87b9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB275864C11F85D5BFE106A96095619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rlYGzy/j5WiOIcJxrvdZwE1NtjOziLmuGuzggD+x4fcSLQ87WJfY6SOlH9/cU0OzHPpZmuXttVhwNC1UA3DcVbCMsAH/vdkPQwEMJ81erx1x6YJpU1rjGgR0btC4HUqLzQ6VgkRKborR7WQn2BcA2K5mjlBBhTekjC4ZRMmBs5mwd6f6NzZGGJ0oH5RRttCSmp/VwHJ+EKqOyxYGdpIVm5kZMdQe3Gloq3l0IWQR63dtSL34Ue3WZssajWf/XfpAnySkTvJbnu+7Afj5NCYds7fykWugrvjIpTDo5Tx4dk43EoEzrJGJoK2e+aHfcdriVdlhuadhTyOwB1i9HOvtlFYLMDC5gKEalLiXQLaKIigd1jFDpVoz68H5lK96ZW4sSKxfW2TELiMYJciPhC4wYAAnD6e0GhAbYYayIIPPL1srKDgm1hqdGUrKxDmiAJyKgQKxBJmT4+0Nal2X6cwHREYPgbPSEAF4s936z/mdHlw7WAdwJU9hbwmYQSyRvI6k38o1Zm3oA2B9HsbkCM3EDX4q+Y/VDs5QwEjNFK/ywUWsVnGBomDTXHAzjjvncpSaDepMnXgYGKmk8iSFDMw/ddByYjmCO3oNYz/MCK4AEDGOSY/5uNNU8ZuFcWzqhiOsvvLgDj9MH7QSndHvyuiGBCs1opU3gej+IMPBWXXnJU5i5ppd0evEa5sTTvGczib
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GXPegXymgRpVt9zEdTZz9O18OMEgeAxximKdUfhLx5BWWaHipiQL2gkrPVZh?=
 =?us-ascii?Q?EWvywEHt7qSd4qyj8BKPH6712I1122+qVNkVk2Z6J7KFgg/YFE15XBP51eNX?=
 =?us-ascii?Q?ehCpMCvJMxp+oPluE3poNhPT+6kbaWuCO7okq0wvPitnnaU8jHCzHQlG+2oF?=
 =?us-ascii?Q?iea6iMocNP4lSBHRS5dj60gta5TqkmNTMsTqD43KN1ylzjvfflAfVYFv6NZA?=
 =?us-ascii?Q?FHHo0EQrKxmYJQjh0P53ZedIto0S55E/ZHgQffQsWNe0cnueI5uLvM4M80Ln?=
 =?us-ascii?Q?kdLHKMv2sXscAXvkSq5Ad4u/OLDZ3+Qg2U63B1MIF4H6x9YPNZ9wt0UH7YHe?=
 =?us-ascii?Q?K5o3lNK/xlAO8YtmxIQyKDX3Emzi9lSWGMMAraTObxaRgM9YCKtwjCZWgfnV?=
 =?us-ascii?Q?j0OqDdp3vR2MEOm+32KsgcGYE6dm4iK3cmCv03BaCLtiLFVyL2rEkyQi05z6?=
 =?us-ascii?Q?qeFGZSXM/EEhfXjja7kLwWhVKxvlB+VrEpwg/NAk8fqSvGNcFkIdzvtLPEXe?=
 =?us-ascii?Q?SuHfgFhTxlQOV6iC3BesTaTTfqPy4jzVXrG54s4AmkGqxyCWOBACsi7RYNAy?=
 =?us-ascii?Q?TuRUrt5VGSi0iVgkA42Oac+hxFPqygaCSN7dmGkenXgRiiCdqTm20uLcc4f6?=
 =?us-ascii?Q?3nM6rCMXi0DtH0MwyJkNPBy6CNabVr+nwKuHyuUO1iPbfwWoqb24n2NEaiv+?=
 =?us-ascii?Q?4TDH1vYYiJdJd0XIi1L0nBK586sY7TAOu+Zw4cmkc3+TEKxb46gXxLW7eQgc?=
 =?us-ascii?Q?AVj8OnkNLm63k+SzYbZ9TDcy65Re/ucaPDKYhiFf1937FFcroHuhwgxGjRED?=
 =?us-ascii?Q?Nosxx7wSjFvunc3Yie4GxsVsvYeaJK1M4LV8hNXNM9b0qj7Mn2oLFsIBPrSb?=
 =?us-ascii?Q?9PRheMj/mBkeOChlJ/8v1mfTxd2vFlLJUB1j3jlHDHqT3hNyl5cwMeDuFpNK?=
 =?us-ascii?Q?yPWN6xEy+KKSoWx3QbDTHdsrss4cgZ6sSx5F7NS1xJBhwuF6xegY5CoLmPhV?=
 =?us-ascii?Q?Pnoz8MMaMYawBUIBn5oYmk5HiXeGqXFmhM1xlNpajvZJTtWr/9vTWZ3mKybe?=
 =?us-ascii?Q?h/kjFo39wLDzLnTRzZp2wiYc6HMfQawGMJxWx4LK1LogEP7KkzbYNml/HDEF?=
 =?us-ascii?Q?WXTFX5sPjGa9E8+CgvFXPnPStBhVvx9zqRhWEzzsaNnRqxGEYFytPrkglzBZ?=
 =?us-ascii?Q?nlfBSxAfUOdnMr+EdH9KExlG7VSPif7nv8w0SMXZkl/JjTIis1aYYnYMXMpg?=
 =?us-ascii?Q?F1Umi86BOvXOEFjrFcus9YxsfFEsiYgxjVKGKzSP4goqeCeWbz1G7MH/G/3f?=
 =?us-ascii?Q?RddZl6qm5wmNTUGZN+BufRmH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d234dcbc-3c2f-44c0-11b7-08d8efee87b9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:43.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nk1xuU7BLOQhHp6h20MrdXkCy0nXJbkzoyM1udzO9vApsu1QPnV1/8c8SO5/16SVg6Iw1MAsKzUEomq5PDOhMMXX+MR2LSlnch0tamt4kgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: eEDo49qwGnu9kwiHv5H0S2M0WCyr5-rh
X-Proofpoint-ORIG-GUID: eEDo49qwGnu9kwiHv5H0S2M0WCyr5-rh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: 85ef08b5a667615bc7be5058259753dc42a7adcd

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_inode_fork.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 7fc2b12..bcac769 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -41,6 +41,13 @@ struct xfs_ifork {
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
 /*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
+/*
  * Fork handling.
  */
 
-- 
2.7.4

