Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB3DC43460
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DC6B61006
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbhDPJVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239536AbhDPJV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99K0m026179
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ExKY231KY5SLqcqO0g71KGUdpRJMz43PiQUN3zbAM5U=;
 b=hFyttz2hpGW7RcB0Do9Anx81170DypsrWC3RZejtjx78tfMYavu/k0GaBVK0xKL+BTqN
 QZz9U/88Nr4u4c7mUCSu6wqr6g1ge3Skl5knjnBWwi+f0d5R4fpLk2OErWj37+mwsDKU
 loAxRtNM1YF+Ec38wsLIVlusJtixT3C07VUJ8z/DfDFaUsOya/B+V/Wy5MdZVmLnB6F9
 uwuXfCswE7cWGwY+auKvDjY9OsVZAblgybQOt1b5bCfHIRz7G21/x9JKT4VyZv5nRGXl
 3ruiv9QxBmLIBjVyL5qMDZFI2VvISUMFX+8chfuQbGLSYgP5QyJgUEklcIG2tzQiS3er bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnrheq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99eLS182118
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 37unswy7h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOMcAyYdkC0VK2v9qTJdYVLGS1YdR7UIOHQxhYMm2haxdFF0Az2Cqy3BPMmIXS++WkLrIFjOLbwAiA+zVphhLZHS0Jjrh/90cw0nSjM6QHpROCQud1ZufjbdfuSwmsbJULI81l7uAp4FYSRpOvLq/4JyoP330j8Mh6oofjOceRCY6e+jbarGjTXWeB1zNJViZW3aln93d16HS96e6PnGR31nM70g4Zdjty0SN7/be5QJtoIaKfUdLlb95PeHzEdANVh1SiVJyRbWf1c1lLemiiplVcr5c14aFpg0knsqB68wwdfDk13P93W5xB6jNFuKpsrm4tLHNxw4LNqFBE4Dmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExKY231KY5SLqcqO0g71KGUdpRJMz43PiQUN3zbAM5U=;
 b=Koek1ta3XuNb+o7emE7vHMqynYD+tLKR0TRYzKZyVtrRRJ3//Oi274UrbPW5xa9IvXoGkFoiEeUu45QHx9KYr17BXSd32AW4b5z0o1W7Cs1xmrYn67pmlul13sJacBOAx9yhpKm2It8o6ItCgaxnD/HYxU8NQH3sYJz4WkjXhUegY4BQ9EJSd4O74TXhyzIjvx+yo90B48f/78uTv0Bd/P5fhdx/iCf6H4AnfYreUDAc6c/78QWNAzXkT/3RpY74yg7OoZklqMZIQ/73iDCQAXYHst93EhqzY2Rx1/K1J8u98GXRK0qTd8Vz/VH4wbnWeujlxjVfJiqJtZ9XUVEivA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExKY231KY5SLqcqO0g71KGUdpRJMz43PiQUN3zbAM5U=;
 b=LWgClZCNJeLw2+LJwCeJTNpi+SAkdyk8M9nkqEG5p/bbs8CcqtUbQaKkhkHNu3SiHgJLR2RfhWhDTuSxou1B52ScoYmqlleY9NhdmxuL1j5U+L3Ca5XOiyETdNhG26WKMP2u4t5v+7o1e4GcdUIOayX8WbQfhpMFvrTiNJH3p4k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:20:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:20:59 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 05/11] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
Date:   Fri, 16 Apr 2021 02:20:39 -0700
Message-Id: <20210416092045.2215-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f3e3ae0-d295-4ba7-db83-08d900b8f277
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB256758E8FC598FCD106AC131954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AOYbvNYkKt3Jb0kTQhJZvlpx6EBuSs7ng8LMtaQWFd7lJZp8j0CB3QiFHD9HM7O73l5dqWPBp3kUcBLIWXXJ1r5GOQZKMT3dySw7TsouMC07aRavAnY2vwpXoxbcGxLY3Cy9EItBno1biWelSHyerHyc5YyqFPPnG6TUTigje2H+Go0UpMslJ39XnZMFtlZ+bBwBXcBedbvWpNGKJJG/4ZxkwR1Rl1GSpc9NTgMiJzSiDtDQ4IGlHfKWtWo3g4PBtLhugTFoKgiE25i3avysGjDI/czc1FlJ4dvLYLgsz3dJ1ZivYVqwQCagMr0JK3rJx9x3l1S8nsZc4nsPxzB6XwuNy73DuEXR+U8d22Bi24TLULAjMEFFkBAi+0hno8dAXuBDmoFT7/FrsGhmB/TzxVbuFp2pal3Wghvd36qauceptXHjgGeR2ZSIV6tzPsIcscac05gBQG5ZfoIZF6UT+VpBuXKsd56+wH/urjeOk2MjfrkrQjsl3XP968avdGdreXVYMbhkUjIv/f/uS+mIRogylY+8SljOy4wENYtW5PSRxgVA6ijh/JBxm+67Vb00RnbR6ap8wy6fAubXnktOLPgrnDy145xz5yOvvmMZf4WHH89UibF9YfxFI+dSzmCntoufjp/hyz/SE4+MkWNiFojkKGBcRY6QXs4UGMtVLm5WzrTNZWnqgeEIDA4UchdU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EuXZzPG1w5QDccNv/KvRVCO1lUJgI/7lg1lSvPDSDlNMgJ6Smj9Hvp7e0SsS?=
 =?us-ascii?Q?pw2s3yNWWVOEF1qADCsXyrM0LugLKH+2ml3Om0mXKg0d7F6xjofyBrxD0RWN?=
 =?us-ascii?Q?bVFMSU4zgYMNd6EDL21cZQcvvfQdJF10BbzvG0neDTcyTXz+YETbrtVSA9Rb?=
 =?us-ascii?Q?it1EE8+4cjHupflbzueZfXF714mtWR6IS2oJNNqvAmNgAnlEdunlMsw9IGiW?=
 =?us-ascii?Q?0k745shj3a/Bb+lQTl/6lTltDrsybyLQoheY2ky189kc/fVzpul+FOb0GGQF?=
 =?us-ascii?Q?gY6laNdSOns4C1ojx0dKQ7sxpJvseXjHOpMgqVhq2U5ZYwc+Jp4z/p/IkYrN?=
 =?us-ascii?Q?ajTuixCYUBO0+A6N3gmvd25TgBFjJszUUxkGhOMBYz6BqYecVe0h9D3BJMD/?=
 =?us-ascii?Q?CC/t7l8A5fxpJtryomY3aIyT0DAp4bCdvUTaOQYEzh9fDeBApERpwV4wEqqe?=
 =?us-ascii?Q?BUg6RVclrKkv71zHFAs9OTCPcyASC8cKL1zwTu/5SnsvwN+pvNVhQxzbm4go?=
 =?us-ascii?Q?EMo1bmrt4RxrXyVPM1Eh9oWSIMdOgP8tD6qZ9DUzZ6Vy5kl1oA6CHdbnSngp?=
 =?us-ascii?Q?DPj4sgMrep7NMSh2jFXf0+mBNDc244/8+Vg5si3tuvppQwpCXUw7UvXDCTyH?=
 =?us-ascii?Q?vpOoWHw0ymBgp7eGrOdm7iqgm4mitpKognQLx93sK8TwpjHrtUGPH8sj1/nb?=
 =?us-ascii?Q?mOvK6c2Gt1pe1B15D0igt6dJ+1+rozFT9BMz44rNdwrpo9H8vda2k81+HsB6?=
 =?us-ascii?Q?vhtjJUoDY3T7sewIk5Q4Pt6Lmi1lvw0bdHWK+K+UY2XvZuV2rD6zdtT5xEU8?=
 =?us-ascii?Q?76BwJ9hiO0m20+2UTlkOipAGQCkhLQMMHL7coWbeSURfbckihMvQ0V2BuST0?=
 =?us-ascii?Q?OhuEpCv6w6tirRS9WCibIbPQRgznZbwVT979dOAbGOgJJSd2/BPUCzeizwJj?=
 =?us-ascii?Q?NNEMo0zFqjdytKvCsuPwjumnSKuwv4u9r4LYqoP/uwr5P1/qO7rC4PbSlJZu?=
 =?us-ascii?Q?A6EgxKt6h+3kPK6tFq8rvRLEk9fjJTHRNJAmFybYs1yad9O/89RiwJ0ssEf0?=
 =?us-ascii?Q?RPpQduGxcHxet8/z0XE99rxSO9ERBcw7PO70F1jzcgai7jV0H1eh/uI/tJH7?=
 =?us-ascii?Q?Mcs3ix02xpkQPZjbKCrilZuVqYd7aWDGAIJ++hIJ0aZti8bft13l8ht/lxV2?=
 =?us-ascii?Q?n7IpPpM1/zMI2YFPcmFVzCLU+IFjBOUBcPFjzZFOFJ2yMih9Gop2Z9UM+2/R?=
 =?us-ascii?Q?ZGPTIdPTnw0ywmRDJ8pj5mm5HnC1WVmubw3KGSlWjSLfudDKHuKve/WS1WSw?=
 =?us-ascii?Q?94QxCGxyrXBdos6mBt0RD0gq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3e3ae0-d295-4ba7-db83-08d900b8f277
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:20:59.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VujleWWnZyJvSeykEwW+//xtxwBKdN1sJYntmnIIncibVH6TBnfz8c2Ua2kyITB3prk5Fsn3PRFAjf1Jn0axtHVFo6KrYscj82++AEPxQ8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: adGhARD6iqRWI_jDlQiIB6OPnhNPwAfA
X-Proofpoint-GUID: adGhARD6iqRWI_jDlQiIB6OPnhNPwAfA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fff1c6f..d9dfc8d2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1062,6 +1063,25 @@ xfs_attr_node_addname(
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC
+int xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
-- 
2.7.4

