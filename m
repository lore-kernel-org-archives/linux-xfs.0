Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C80C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8712C64EC0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhBRSpI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35654 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTiDf040357
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7iRM33BsY/NjjvjomNMIp1CjUrXUdg14KDJF+JczEBg=;
 b=X32/mp/o4GVby8BTxZTd5JhWJtSZUs0Vq3YrrPQFw5RMCk+f6Jx74Fks3SKR85K8ZBmB
 loe9NqWcH1yQjnS/xLz540F0ECUrkRE8tveLliuR+vG9Mrip+oBmJmsbTdMQBs4aRCe4
 IrxOHPST6CHcfCF6Ki+/UE+j/UQSF+gaZDNWciEzoCdUSC2RGy1Fu/gJ82g0OfxeuTUA
 4xPP7asgkuqWt137AsTSkMJdrzIWsFaJFS4Qnw1oMnON0l2NCVIqD4RKoT+FMjoPPSTf
 xgSDRhMPh2iNNUZWnwrGw8mFnSK1y7cQpNihf/m9kwijRhmK7XTBRUGveEcToY1BMara iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCaG032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKz3FIfbnaSxQNblGOjbBL42BQGQcKmEKuEyJc+JjDxFFwM6hfunsvdsV6DTHfknVVi8vKJ2NZ65g/25oEgoOO9Z31SJRM2JU+1VyTMhJ77B/tpkxmfw0vJFO5c2l7M/jDYJJ8vUvZfbxTc0DVwbxjhb3wZbUgbhSXboVKpIAves3UuD5g7+YrS/CDq+FQyZqG6RfI8eDGMM99wqxA/jSJDvA+bAG8D/1oxC/d2BD1ErWpZNXkALvR9w/Tr5nNhX1XDPPcQjTH1eOMMfomZ0UpT03McD+k7P7s6dDU3ZkuY60hnQn6/xgsJEXBUWKVtIuDP3HA7N9Ss68lrVFIy7gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iRM33BsY/NjjvjomNMIp1CjUrXUdg14KDJF+JczEBg=;
 b=mKMwRkv2ioCVh+a4AN56DsmijcOkGyOPHccpuK8huLErQcms93FnYDlUxP7OPdon4YWU+UNLLuSY1bMmxPN+LhYp1fTbsELlM0zyFyCsFhpOTiK3KO4WIY13GkVI4LIoBQ3H+/rbLP0MMVXkZE8N0B6Yo7lEp9FQE9n9tZuRuziarjbzwo+BAylBggXNX3uB7yXzDBo5e6JWxdh4bsWLoVH06v9iL0yEeO8vyCtB6pARl3nNDVOfpXmN11VkR+uhKlW6hu3OyJlFs8CZEuUoW2W4DgYQ3CNda1PbcvHQNxF5tcL/Jug5snti8FNJYf8bHMJOtU+R/QHqbjtEcKiuvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iRM33BsY/NjjvjomNMIp1CjUrXUdg14KDJF+JczEBg=;
 b=mpIVLX083CCx3uyH8CsDjaMVrryUHNYdxK6/6FRknk3lBa3ZNj+fgIpemkZjogcflg9NEmj9w/O2eBuKDKwIWg5h1UCXUHiAdhTRklpchykZbVhUZeEcAjJ2ifpy6eOJFJKnCV0cu2zml2PPszAzybxm0Ey521hC1P2SmxwxRmY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 17/37] libxfs: expose inobtcount in xfs geometry
Date:   Thu, 18 Feb 2021 09:44:52 -0700
Message-Id: <20210218164512.4659-18-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16ff7c0e-73cd-4d41-f5dc-08d8d42c9f3e
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB429078EBAC1F63DA78F57C6495859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:534;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMWzmCOSdRMchdPSRc/8Vk47EecXBWaemJnr2HqIOooL2Xm0gwettOi6ahArKOTUZqs7zoz1oc0sfl4RWm5CSNbC2ZHZTp9WEcrPgr50lYluVb8rI8ykJHqoOi9pA2hgc9Qok4Y9ZKXY1y/AP6KZDnZzNAuSMp2b/CcBUAi+EHQNabPSpV8uxVUKEWTMvjRb4+ZgCuiwhdXS/LZhuJCXA+RrWUztO4m2rNCVMB2OsD+dS+4fjvNkTOCe/QHFZTIB4Eh4VbiLmINJTmqo8O/E5UMEoeUPI2Xrdy/Qw6TmwvFm3i8mtROUov4ESHaNJU0BvZyonbjtdwIqB5ygOzJ0G0W/5DXZxQ/4vbMf1yiR/q4J9keVamxVMzgTNCvEIp0FiEsAjr44Wb84+IWd4A/iGK4++d/8xUe40dJ0LdeGG7/0xSLK2Hda6A2C3OWKJLLJYxgIxZnpnwsvk69Eu861xwua5t/DM8pxY3J5dDz5UqNRyoXd68I+W3WRNtomrwvRn7nNby/c0UHAVOSlcNnZmCmSI9/fj4P0CrC4LCBX3hVo3WENR/q94ZHzMZ+s/iX38KZnRnWaINanODxCreqkFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FM4BPqxsmDK1xaTvacYgGJZVVaIcmcw20YeslDYE43rhGp1ZlMgw1RzszMMh?=
 =?us-ascii?Q?V4gFRdvGaTdb3Xt5n/q7242ZPoVLG2mLrb3Tyd+V0rX4O3eTsdFKFJPeRVS2?=
 =?us-ascii?Q?B6llwRq+8v5YAPivDwIbtauqX2YUN6KHy8iE+fgJa5ly/KRItQx6bUlvJvnY?=
 =?us-ascii?Q?j7Ra3blpVTTxghVvNPWtYxU7WoV645258hQ+id4yH6LOQfFv9+x9sWcpr9sy?=
 =?us-ascii?Q?abfUDoI2eNycbtr9UZu2wT7P8XJn6XoDugIVmmEFSR6B5UFEtZ0gfCcRUtm0?=
 =?us-ascii?Q?EnZWL05cHItN2giEVv2LzWUYPC2M+W6KQr+iU+E6C1O15CfBKYtNKcn+wO+H?=
 =?us-ascii?Q?w4nuz+lVKaYFr8AcjEpfgDHjCEPTMc3j9LLwiX1mk6DcER2wgfAT5H2Hfd9U?=
 =?us-ascii?Q?Z419GfVIxT5AZ7lhxWDLifBsAMXcbUjYwYm951GRHlWm7NzzcJ69ZRWGB+/b?=
 =?us-ascii?Q?ueLSM9a9Lz7wpRnWvC4KHqfPtO/hxQgh09s8c6a2mTLHhXRzcw2cNyfCCc4j?=
 =?us-ascii?Q?lypJy9TavZP/hfrW9HVBje532IXp4a4eh6xaOn6bE9V+yRzdr9BvYADcGXsP?=
 =?us-ascii?Q?VBkcrEdnS0vrDjvzP3W8FzQQz8LSa9B1k4udbLRUjMBDDVkbFAnDaLuPzM78?=
 =?us-ascii?Q?CJsqLQ7N2E9EKAhJS+PJ9NhfDYeBH/6xX9LXZl0NOLnnMHXKjw438bzTYbAK?=
 =?us-ascii?Q?IH0Fv3JdetJONGsQBME8Cvdo2preaFtHblMLAjodrUy0RK9nxwpE2vOH0kGV?=
 =?us-ascii?Q?wEyMF5NW6VIOhCIH/mBlcZyqOAWDiW+70NXk8mXYKQ+zEpgV/7+TddMaqRew?=
 =?us-ascii?Q?8A84/MyjoobVusMlhpiZHyvKrJcZsHnyTWKuHRPAXPQDiHuTDvPjHxbefeC0?=
 =?us-ascii?Q?kHKIrW0n62OW93BDcfeQWkQFkssE+MX0p8iWwFvZ/ck549GvSIngM2wbCTML?=
 =?us-ascii?Q?1WwS766hLh6xXM9D0GZ2so/iHvB7B5F9zgf2zXrOJzGtXLqPK3i5clCukNP+?=
 =?us-ascii?Q?buJ0g9l2jyX8AXhoOOy9b4PycOZH7k+VPC8vSwD9gHdaLlcM4UqE46i8eTr5?=
 =?us-ascii?Q?tJLqOJrI0lJoM1JaoSZToUuQHdzd16S36MWPa83jVDwWEysjq43+AltpKYMW?=
 =?us-ascii?Q?7M9/NX2e6grnUEQYjamvKmN521U/uHcSPGZLqCLbr7+5x8FaSI5KaPVdRFW0?=
 =?us-ascii?Q?ZdAVhKSNr+AFwXKNkaKYDBq2RxIO2gMysaHvWLmZw9uejwjY1o6ljzRj5+Wx?=
 =?us-ascii?Q?ozxPxtrSH5Z9evZp3gOFLWlY3n4+FHm5HP+VOyRc9aBXkSycVPLdE4S/rQuk?=
 =?us-ascii?Q?B1orp/5rkszeAmoB6g9lgNI0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ff7c0e-73cd-4d41-f5dc-08d8d42c9f3e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:38.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20WzsUiS5NAuC4OEDwJKiphuX1DZZQIu3HYhIPsFsb5M6P2Zp1Tou6kFmRZdtnZA9jcRK/0QMtK4cWLLQbPXOQDMwtIVtx7RoaNhEOTFP7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zorro Lang <zlang@redhat.com>

Source kernel commit: bc41fa5321f93ecbabec177f888451cfc17ad66d

As xfs supports the feature of inode btree block counters now, expose
this feature flag in xfs geometry, for userspace can check if the
inobtcnt is enabled or not.

Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_fs.h | 1 +
 libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2a2e3cf..6fad140 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
+#define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f105d2e..8037b36 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1135,6 +1135,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
 	if (xfs_sb_version_hasbigtime(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
+	if (xfs_sb_version_hasinobtcounts(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
-- 
2.7.4

