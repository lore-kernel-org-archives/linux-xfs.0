Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB7EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiBXNFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiBXNE7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8F737B591
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:29 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYKTm000941;
        Thu, 24 Feb 2022 13:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OVPwax96ToO0SjPGa+LWZoYm7AYQ1hXnJPj4S/mPhFE=;
 b=L0VOZOqUE3L+3nIpG0z6P1L/l9t2b1YhHyDKL5fW/dpkRvHMNvtQXnZVhWYlBQ/kzrcg
 973yBnh3ofpxnaOa9Oy2G7GAF69hsfzyLrEUoE+ifGY/UGwCI52gZEVoGWFFXOr7khZp
 ysBaSEG5+1GnufS3tBCkt7fTo6kY2zHLPBQVkjiw7vAdVfnaGfGk5Db8HdLoZ2Z1TWNo
 0ghgyNJSLV8yMRPNpMSEXR8GaZN9tydzYTyAPq8lZ5p4BXVMXx+GTToQy9lHJlCCK81q
 M82ydGmncmARGm9vuxXkWLv3/nTLnsNm+D3A/413UryW7DOshaiebTqbBgYEApZXOAC5 eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqabu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1gju039583;
        Thu, 24 Feb 2022 13:04:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3030.oracle.com with ESMTP id 3eannxdf6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbTlfvnD9yX7QyZM5P+oNFTjpjNcjcwVONLVQLFwCjzJ9PlaH1yu1KBJE1D/ICa0m+bZaNunhHsww/k4H1jWdk/dEjmaxQ+POyz+QKRpMC9K0aLiWrwUgetcvon+rSQR3kVKCJ7nVyLh5Tr0UW/BTDlSZAYxrO4fFXTXY5kQb56Z0ohZjIbHoOepxnQ00SLoXiXywtHvkaivdJwr9uj9BQOYdheGlQA9rHlzJKZ4el3krbjSlzfrauXQj7HtX1w6vGw8wHvCuJErUv05bKnF8z6pK4GC5UZQR4Xz14EIGoS1KMAqa9HuLwdOZCiiVwHjyoUMnIGv2MAArkEToJVLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVPwax96ToO0SjPGa+LWZoYm7AYQ1hXnJPj4S/mPhFE=;
 b=efOuu8HQLRfKHfuMtXO0CjF1DqzV0bXuf9ZnGXo/lMRlGCk46Sr/A7GqQk4nhmx3TkAHXbdKZx7xDSFrnGyCnZFu037+ZUHBAbsOssWk/Ck9Fli/pOXDzrQtww1+saKN4Q5S1befQFZolZA72k/i4oZe7zdlcf8JCYOxdhE3U6saKP5CWCGhNZm4jYBKIvOJuDiv0hQvQtEicYTuLbuMrWLZvzuYQQH0txNRwKySS/wozADcbIPj1oN9grDNVkGueekrfXvmVhVCPGy9P18dFxNwPZU52zWPEa+rZzVnPSEC21iRfegx+8PX0z7x7pq9hONP96xD9zBGcC98UacITA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVPwax96ToO0SjPGa+LWZoYm7AYQ1hXnJPj4S/mPhFE=;
 b=0IF9TRkBzxoKNq+YrhIA2Ql61O8D8UHcVSdtHMMFGB9JHcl0jwpiQtN4FVyampY8NVDGKaucFNe9tkF1/MxvHfpYTTyHDXxS9h4eW3hnSAiqisNDZYymouX0O0m1P5iPbk7zcaiX2XP1pBQOpp5GBjr7RRjlVoW/8qygFAjVGME=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:04:22 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 11/19] xfsprogs: Use xfs_rfsblock_t to count maximum blocks that can be used by BMBT
Date:   Thu, 24 Feb 2022 18:33:32 +0530
Message-Id: <20220224130340.1349556-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4d7b1f5-8c58-45fb-1106-08d9f7962d16
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2172051FC095FFC08786BDE6F63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtEpWgoG0ig7pvPsSI4+8ucdYHcjR5UfQtB/mpyNK+kBsom0AjpCIZA3YTRUBuQSMF9stwz3xK8lR1P2MN0P+wvP6Xag5cI7/G0nVfGqNxqynDIEsHaBKTk86EenNF0XaNLE9F6Xln0K8rwFyj6d54ZJqWAphAcLH9OOFTIwDyvi87bU/j2HQUbOWQjfNz7zKTI8u30ugPRiRE+bTtJybupUmdNl9TvirrBdVbKpCOJeaAWflxn8l2DB9rpmLRnsqbK+9WYlG4qtR8e/GAClbAfJPN2/Ik4MjnksIxMQe+XF7hJsN5GgLnfmZhOjyBQywQdzWXmLWF6BPR+dz8V0CR6VMk7bb1/l6lhynK3BV1oW6Irkk4EyOfqL3Yp/AobxnD6mQt0VK6phyLl0L425fUBVrYv0B0cf4DI5uz81UCBxk1ZlTINl5QdcynmyTI24bujFkd1lxeCAQH1rY+g25O3bp/maVV0U14jRnRDMijFKKRZBkOxW/zF0FLnEvy8H14nbLf7JVY/ntNarrq/tR3xw3dX54GnIEI6BRBDgO5a7loVdVAxlvrkZB5LOacOCfxVuZnirmZUBENZQRcpvFVISRZ2hRVw7YaLRBhsaGJMKown4Z22X3pnDaTaHVg6zbLxbZc5lQKAq7qklR1PUDj8ojrgTSbVHdWlvDYcCrEsRSMPz+GYmxNpyUAHdt0chxwa0gbULtDUzqyKyPuHhLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6666004)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MKOc5WiObvMWenyWvsUisjKp64ZkTfOIa5lYJW4FtTU0lfLfds0Y0neFwQE8?=
 =?us-ascii?Q?l0vUc0eOHSMqdgdqRA6vR0O9fsdUZBzCHthudmu+Od5iPUB/ZPLixc9DyQiG?=
 =?us-ascii?Q?uHUcIuXAIJ0lppPsUwwHOMeoDUCC+0bp0o+/XCDes48+pZmekWW8acyGn4dD?=
 =?us-ascii?Q?1RBKeBK5LuatM8GFbk5ETGcM7AEDCOMTYQW5W3ZpcJ61FraL5e91EqZz9Rw3?=
 =?us-ascii?Q?3x+XCr0LoFwK3ecvj3dsMvR0AGeI7Ae7f2xIkP89Q/fgG7AbKRr5LoPleezQ?=
 =?us-ascii?Q?C7ol+O8BC1ujqF0Jbkp2HrVMvbyLNb7XT+ARsWkPLdNIEsuOCgdGB3gDVhB0?=
 =?us-ascii?Q?V2xDpsL+gueDKZoX3THb20GVVJriWhj3mcmnySa1sK6FiBFzOR3xFi7VNqmV?=
 =?us-ascii?Q?AczEfV9nxJPo06MDXsl2H/nlFl7EyxVykOOIZOWvkEN3MXhYPcpbrcW7uFfL?=
 =?us-ascii?Q?JqH1HCV/ZSxgQSEEhlwikNQeO9NhO7csh6GqrE9VwSInY+9X82iT7MDZF/SR?=
 =?us-ascii?Q?gBuY9rnpQ0dpJjRpyoFFdhO13dq5GrnuYc73OEUrri+VpLf3lBeH/lQMtZ2W?=
 =?us-ascii?Q?HyokXexI+b2EuW1WCarmf7Axdxn3Wj5vCnVXDKGxJ88e8QHfEg1bFxMWER8u?=
 =?us-ascii?Q?08ntPg/LaOMFsCQiC8dJeKxuZ2Ed/bpKZrUIAHZdpbDKIHFy9armIQ9DvyqK?=
 =?us-ascii?Q?uPR0BpyJZfAOBn/4Y2kSGndu5x+8ZRHUbXCPG7FZqfHBG+Ys1BjS3w3+VIXp?=
 =?us-ascii?Q?PaX1FP+loA/zQvJvzAN67i4Fbbr7fV3WF8ba8B11RCfD+nb9AHz+k5njt4K8?=
 =?us-ascii?Q?5Tupfc1IQo9kyKerNy9e3ZdlhT4IuGTIATBrlNn7p6Cefviev/kQkJRGHkFN?=
 =?us-ascii?Q?l6p+obkUIX8LFbb4pmKHNXrwSzeE9IR/I6nVexdL/mzoqTKsBBHAPycQOgct?=
 =?us-ascii?Q?97jgolzKlZCcGmzrzxBgZAotV5jQ2eu4JAmMeFXYQglGWznalE9RyhS7lgil?=
 =?us-ascii?Q?uIUTJcVWRLBzIX923lOd/NFYyvNcva7C8BDDgOaoa7SlO00FyKsIiAtFR3ZU?=
 =?us-ascii?Q?8PVpfTQ1vyFUpsGYLUD//wS2Ip+4ITAOiXKLAU7yMYwCWtYGnjfCICON9HgN?=
 =?us-ascii?Q?9DgO+pCIxzf4ytg8MgO5TA3rxud4J1PwFNhHNERNowyNU76XO9C5VOWoxZW4?=
 =?us-ascii?Q?PxKtWJGx/Int81H2oZIEq9KICE2aQhF0N3G7RDSpcQOzw96OukV2un32AUnp?=
 =?us-ascii?Q?+1HoKr78WAs9cXOnvlhEUENHZjqyfWueuISRxvMjRXmCeihCQloXWOJjVUWr?=
 =?us-ascii?Q?IlpHj6GmX3+Cpxz3WI6p5m9DZ3Ys1ttFm6hU9XPjX/mUSjbxctJ9YysghBIs?=
 =?us-ascii?Q?Cy9Hf4gzRhgWp+GjEjQq7+bi/BEmbK169eZ43x2OwkAwhOHoT4476WxlpuUy?=
 =?us-ascii?Q?y3taY0eNpaPTa5lKuZdNyQyTaozGf7ecBzUxqxu3QBHsvAMQINuOU8jkDw3q?=
 =?us-ascii?Q?leE+RlkrCIZF3fMRUxzLi6EOeijAKq/XYyuqr3lakVgJ2ihI+GkVQDkkeo/g?=
 =?us-ascii?Q?PVP9KfBOdk0fsqCLq/BlHMA6tzyjZbHNyJAKZaYl4L2UHD2y7hhdbqKqYx+H?=
 =?us-ascii?Q?6banouu6C4fM+mnnHZxourE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d7b1f5-8c58-45fb-1106-08d9f7962d16
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:22.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: df4AlzPeUH5sVp9wRPMhp+aRrpb/tllzZT4SgkJkivObNDvs6xE5bD07VXKfV0QMe1sd8KeuqriXZOci6mOfUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: Ac_Xp5KkTyNwXi42Q2zzIShWqCR-oPCD
X-Proofpoint-ORIG-GUID: Ac_Xp5KkTyNwXi42Q2zzIShWqCR-oPCD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 42694956..51e9b6ce 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -46,8 +46,8 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -81,7 +81,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

