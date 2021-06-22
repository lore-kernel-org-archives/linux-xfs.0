Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A736EC2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 21:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855626100B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 21:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhFVVLo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 17:11:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18974 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhFVVLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 17:11:44 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MKgtr5030837
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 21:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=GNA7mV4aYR28xWyH5qOpkD0dKnjxxHH+w1hAL/QRFhw=;
 b=tvTqSshGG2exlYFd/LghztK1LGdhurUHiwG8Gr9UplTHWGdnVrerVloOfxw9yaSW6brQ
 szvtkbw4uVLQPSxHiBFSlMsZo/wfJiYd8MX/WQRuOg0m6HxdBHhX4PrJrUKmzKzL2oam
 BLezq+RbEBabvKJAiANdUW9ZVgHeD1JXFc8o7Nmz7OM5WCWtEyAJ8UVhuKYMhAqN57Au
 D4Cl32i6PJvL4G2WlaZMNQbZXmBQhmTvY7mFYnq93TSsdDUeTDiTGzflmnuD9GoClntU
 +Vm7HLTw4SsNyzd78NBCqt8o3JoU7veozSDekcqZ++ryIWUsA3vCgT7p7gM+MgFD3Sjc 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39anpuvg7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 21:09:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15MKfF7p013600
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 21:09:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3995pwyw7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 21:09:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWMnl7bCVKbjc3YKY57aXDBE+43L+rh7nDthhPObPNvUz0yONvQ1CeaIbGrAlxFn9cmJRWLadz4Jc6ALXn/qI4paKjlHyKpkKYC4VmjrGVMDoakqXqxbhWsQ8W/84MOh9cgc9fdKGRoRC+csUuCkU5arKwWOkBOoa3eEQvK87WPle/2tIAgrsaprJajyySCTRDAMCVAEkQZDZndSuplqFFojwU/HOLTS+LsH1tbA3GMpIT1sKJmWXSVT1IZHDrFOsSQsxHMwlLg9+KYMjcawVNkUIA0TNKjKhw81tsoC19bQRACiMTNGN8kM1X2raW33Jfapqtt9vGOq92NNAgi8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNA7mV4aYR28xWyH5qOpkD0dKnjxxHH+w1hAL/QRFhw=;
 b=FNjZee7aSlLzDst89z+5sYy5oKhUNMnxRNywaDa4y/dLFZVstsSfLjNXgVwIe7oQZxqFreZu+VhRXkNsgcN6WN2t53nL1SejvclneQMwmC0BTh385sE+5RaQPuuguqyr8uqz+Dd6Ga0Bx4p5w2IJSKMy0zCfbOlwpFFO9L9y6PWRXZWzbvhs1mLPGf6xFMse9I2f2LJ8BzusEbgwaFwUYUHZmBFZXP54IOBaoKJ5suymZzc7ICCuJxwCniKSUCWekxmMe5QP00nlR8Hw5spxbWZLlQ8Wx3uP5c27VKGNRgVqbuHmKVkafoHsyPV1oCBHo1Am2deHRvMvux3FDNAugg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNA7mV4aYR28xWyH5qOpkD0dKnjxxHH+w1hAL/QRFhw=;
 b=QEGNpKhAokxKfG64YKgIMiGqsoRTJC1FtZyfpo9jiQTJPCX/7QycTRHHYsS4T6Nk06qCPUMaXK0k14ZGWLFRvJvANy1/SiKtc+Px1Mzpb1uNHWgBb9HAKLZAOnGL/+l2TJW5z6UPst8xhW3IYksHr/W+n/h18RbxL1AGkGMkuWI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3190.namprd10.prod.outlook.com (2603:10b6:a03:14d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 22 Jun
 2021 21:09:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 21:09:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Initialize error in xfs_attr_remove_iter
Date:   Tue, 22 Jun 2021 14:08:52 -0700
Message-Id: <20210622210852.9511-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR02CA0049.namprd02.prod.outlook.com (2603:10b6:a03:54::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Tue, 22 Jun 2021 21:09:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf8c3eea-fa22-46ad-f5af-08d935c20296
X-MS-TrafficTypeDiagnostic: BYAPR10MB3190:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31901E8715F90057FE40004C95099@BYAPR10MB3190.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPsFu+tTXfu40md1USY/RTK4nx68wXLzoUeOkM1o95kAV9EAh6T4GpZnd3s+a/uyNGGqraAvrEpThjS83NYml2SEaNp5TCERz4ehOqpNYraVOUXEPbbS5RA8bfRPIRSzhBRlE9r943paY0Gd2oz0fU+SRzDQKmwFy4Yq1xBXXY/N9LF9GjYIes0xHiI+wJmlbWTx4owp4Sg3q987wXRoBeb2jWzDsu07gekAeZEoD8R5JfYk7s9YPbCPTXt2/s0S1UidMwTaDKuG6KcQtZdyROUJuMPanNrFPfJzKgumYg2HsmKYngHDPxGFLnE0AIEybD7jtszvDNfenUicoIiXitpPfTzAlCvJm/XpsbcNBHLNnTZKGMKK2jAD5v8vl0cQfK3DBnmFlOWrkuSQz8xBOjcJU+hrRjAsR2AunrxjhbUd2cEM74202v52f2YSmq8tZznd3ezf2ctwh1cP8zBKb+8o2Y2MhTwf4ZL3RMc+DjyaWWhOYPGCnEhKNbXVi8mjDqJC5aVA07Q9vLw80OCxOQEfdyCHy1In5QfWnYRyO9R14IwaSAsKKnMiqPNdG7YlfkmewrYBbwLQI7/2TjsvvJFmQ8eZC9N4hIsH1rZ/sLZLr4a4jwhdDzApuAknoefngZPXi2lxI4U64MLBkN0ml/Dd4lO1hOt65/Nwgl4thc9+eaNyp5okhn0Q7hUlK3R7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(346002)(396003)(66556008)(66476007)(66946007)(8936002)(6506007)(86362001)(8676002)(26005)(2616005)(44832011)(16526019)(2906002)(956004)(186003)(83380400001)(6486002)(52116002)(5660300002)(36756003)(6666004)(6512007)(4744005)(38350700002)(478600001)(6916009)(1076003)(316002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1KXeCT25ZBHfeul4Z50alEb7xo6OEX1GfueTCeRvGO1QPcbxpO/31f+SGECn?=
 =?us-ascii?Q?8AjXKsIR/WW5nFq2oodkmth+LOeLYOOdkgnI+Hhf12g9JLnUmdzRRVSfSP64?=
 =?us-ascii?Q?NrLX4ssP5moHuTp5aO/SCTw04J8UU0ELKA/H78spKEKOCtsq3uY/0tXBKK0f?=
 =?us-ascii?Q?kvNhBIrGzmdguk7we0YcdgCx1e7+qPw59Zds1eSU2dkQeuMDqJeeuR3kBM7P?=
 =?us-ascii?Q?IjXvQP7k3jl0JTUUzO5Odh43+bYMmgOV0EQehXDDdXcCGMt0eqfn8Jxc8FrH?=
 =?us-ascii?Q?lEQe+JZQxhi/2b95E4yLPq1agMadCcJTwJbtVi2Hl4vWX0yz/AHy54Fs4AVx?=
 =?us-ascii?Q?Is6fW+qTP2Cdyriha760PpsvYGB05Rn7Bc2iq3ZdAvvBSeLlIfmjQPYnBnSF?=
 =?us-ascii?Q?u9lG7ysFc9+5GWaYHX932k/wU5ezFMnZqw2M6xhvZ0aiPNn2DxJFDRpSz8lt?=
 =?us-ascii?Q?Qj7CBwpapGOSoD/OdDutrTlTpnF/WqpzzdGSo6B7h/kkittM2zfiS7KVulTx?=
 =?us-ascii?Q?+aiCxlEYPqeYYBFj+c+vwTeCqgZWe6HH6tZ9Ff6JhWtcWkzSOR6Vrx0L+Rly?=
 =?us-ascii?Q?OoTvHZsfNeyZWu0UAmpxb8t81Vq28w7ANJT8MzOdW5QfOabVoGCdbkrfJ1oK?=
 =?us-ascii?Q?SjNDyYF9IqbDAtOtqx4uvdwrEfqn7/tCh2hP2MbJuHIrVKtDvi353OFV4uqG?=
 =?us-ascii?Q?b2wM6fINy0YCM5g2rkFU030ODyvMGqz69CQyRQHl0GTlXaFscwiHgFDhzBJ8?=
 =?us-ascii?Q?KaxvS+y2ydjOM1NtUyc49mQuhSnPZgtoiUen3i0NUBpC4ocTmfSRjkFOpJ9/?=
 =?us-ascii?Q?GMuFRRQQETvG7OcY6Ukk6qObZTUn1AlMCVbciNm4Jo1tDnIQGOLW846s7VT4?=
 =?us-ascii?Q?RUEqrc2/3i73rvDUN8MymXyfJmonEQZTgkr+Rp35sEpbDQ3t7WeOoOJDpeaB?=
 =?us-ascii?Q?4HYuhMR+h3+Ny0mgHl+2T8qxmwAwmnLy20xQ1otwt7IYcKQqdZUWfxeF8lqC?=
 =?us-ascii?Q?KFN9EfQIbnz1OFsrdB4bZItpRbEtCXBuwxGkbTGlHt5FJHl4o8QLR7qaETza?=
 =?us-ascii?Q?5VeBnoLa+RsmC0bSxbL9M/ODnrQYq2YA9W45YsXh2VoLTAt4Ts5UdIZRQLjl?=
 =?us-ascii?Q?bKT/JWR4DyRQSPEwOjo4S85EO09bu4hmnFRFlurvAevtmBPZg6fGKYc1CHbR?=
 =?us-ascii?Q?OVYX0tFpB4qBYMgqsarX9U4OqaI++rlVRCY19FAO1dBbTfeNGedcV+elTyff?=
 =?us-ascii?Q?NJ0Nri2KLkdLMyBamqH5VpSO2rNhEgMU971Jb6US+tcBAAtMM3qd52ofNdZ5?=
 =?us-ascii?Q?TKSu6ts/i82YxoCctYS95Uyw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8c3eea-fa22-46ad-f5af-08d935c20296
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 21:09:23.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmxqR/5qTw/s1i1EHOMyhqLVdh+4paetxvgLIXMrlw0Hhfq7qrZGCWv4gzMxqEmGamFOC1YGoViHXzb+qolbtg4WphExJDaRehS2NEBv2dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3190
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106220124
X-Proofpoint-GUID: 5Y-kG_LDyFHBMwR54JYgJHrbkfnfXN5s
X-Proofpoint-ORIG-GUID: 5Y-kG_LDyFHBMwR54JYgJHrbkfnfXN5s
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A recent bug report generated a warning that a code path in
xfs_attr_remove_iter could potentially return error uninitialized in the
case of XFS_DAS_RM_SHRINK state.  Fix this by initializing error.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 611dc67..d9d7d51 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1375,7 +1375,7 @@ xfs_attr_remove_iter(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = dac->da_state;
-	int				retval, error;
+	int				retval, error = 0;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
-- 
2.7.4

