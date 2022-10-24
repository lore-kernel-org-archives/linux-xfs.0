Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DB0C3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiJXEzy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJXEzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C327A57DD0
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NLuAXH013432;
        Mon, 24 Oct 2022 04:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KJyZY5/vzClRVrY/YybXfYaQYgDc7YESNQmTZtRz3Os=;
 b=adSZOYCF+5PiSAHIxFdXSIHdTXMzsvzVnkkOLJ9QBCx5gytELeTxIkFSfZdTpoFjRbpX
 1IqRPO/414AiJNlSzEYmmfdvLzGVMxht9IkCxv5UrqjyyEeiLSfzdmDJ9TYsqokkl6Vt
 5TlJn0QjcpLx5FDPkDfPXNhqvFayMqNQiPNA1fggBUNj607/iz089rebRig0fowI9fVw
 PVBlVfvS/EdWkMxcU/qjk0Vx357kANF7MM0Oc/wEqkV3Fd+Go4c2yvQhp/x4v+7F4GnC
 2k/Xr2P/MPYdMi5CZ62bNOi6rFyrRAkJ5KR3bACuWByHcqqdNFPp/ZXovytm8fph+4/1 ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2tnrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O470IG030772;
        Mon, 24 Oct 2022 04:55:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3bn8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKEQHkvk5ikY2a1pZ409DDtOAY4zXub1K3tT58rQvw+PyWLbyZTGCQv+e6IAG/Oz+VScxjCT3emFtk0GiYkFQq/sEveH38uyEfJy8Q11EuaHLofNyg2ZLAkDaLTImsy54R33xG3HP5DIa8G3nCCHH+vITewucsAWPz9bOK9pmtyFOrghGU2rqUDEA13KGXYqQ9liicEoandRfCFMKqjD3MI9f8NM2eKJbu86F7N9Ve1vtA7GPhClxZhQAY4pvK+bh1FAXm/DoCZoURmoZph8XiWPSSwneZRAFLK/CsbKlfhcyO0/qabl/sFqv7BITG7wrYcr6kHqN242jSie8YybzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJyZY5/vzClRVrY/YybXfYaQYgDc7YESNQmTZtRz3Os=;
 b=cN4CGe8b2nP/wnGMIb6eoBQug5/8oxObwLKo+di5WdqzAYRyEiJPQuo8GoXE94bKhgQ+yyZv8tqbs0YQsJoseWEAnpltB4dmc0kt87egvvtayPgYa1jIQz7ywXhQabjwzKZch+jL8EBjPRi72iBiVnyq9nM7kfpXaURQQIC+8ddfsauqkEy8/CI9ExsKCIjsnbforO5pVTIdDqZpGMpr5Rpuvkzo0U2pXa8nkFgr10ZzUBBdRjUY3CUp/qXyWhh5z2Q0Z0bxd40dGGOLMwMDqnjvKvc1tAyDQtM6Agaii3CXlrKawMRPGaynDYfurCZuQyJvpKN7bb9e+8MDUglk4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJyZY5/vzClRVrY/YybXfYaQYgDc7YESNQmTZtRz3Os=;
 b=WFhJtUZ8agPyY0tyJIm0tQ9PTmddNMnb0KaFRaiPvYQnIyFfH1NtBc1xePATLaa+FKHJKiESTkQm/YzPiHQYdJRbL56iGHWJIEpypUqhLR2c5K1RH+j41luPmQWBO+bPbakZYg3kNIMG9D0UiJx6BmTV/7VHSPs+KCQbnu1Kffg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:55:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:55:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 19/26] xfs: factor common AIL item deletion code
Date:   Mon, 24 Oct 2022 10:23:07 +0530
Message-Id: <20221024045314.110453-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: 48412ddf-86d5-4d1b-1088-08dab57c0142
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3gUN4ljLP3MUIRxpKYdxwmyhTV59jAgDKfLE//6ScRq6FnADUAYghMpH3NG9Aq65v4wvtO7yWeZeK9qPwrjIaDr7Zlo40jdc4CO3g1e9HB5YOBPEXH5RPeOTpmrtTgwz7U1PoD6wU8Fgimqu33pkQN0BEqGjRe3mXCxWvW24uNx/GPEJOQHvwcr0MX4P7YqIXBcHCckV4sQnp+tZe9Geo2VYqTjdVpAoYv7PeszT5bgOx/CYio3bevIT6sIBG9Q+pfPx3R+c/XZWYa2hs5jJU64ypGt3ckhQe/4Hhfvn0pYKvz4xdDRopgUOUFsGsAux6oErTuxkJQaYSU6crQMX3tfP37/bsUJXD149d7nqFB9aC1G0RqJ8j8YsHbkfj9MkHya3eP+1hg1cyxRrbDiqtyGBftJO9ZzRbkbH74cfJdRZHliExTqeZ7aKACEFW+KVce6SpbUe5kFp5uZWJVs0tLAlI/XscVceLfZ2meRn5iaU6FlgjZQUCixzp9CAeCwopXmUHEDq7hFb1gGdhkd7KtNyvv0mMHTzaI0shysDNjsod5rKWm5Cpkbcc4gbVeZWCeHIwsSBi+N3cd3yGiPNTZQsw+TPRAWijqxJY94HWt0ogC71FlOoceTfPpS/FSp9197E0XuApB2h95iXHRQcR61wruvqpCcJqtLl9NJing5od0cub7OnoPad8atAanE/zFI8gALMVjtmXS98k/aMwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pOjwxQZNozaOgRLFG/nZubgcFy7TWEBiNy3UkSpwbyXGlkHdme8DKoNJHwZ+?=
 =?us-ascii?Q?y4rFQYDbw3l92KsZ34+cbB0svkkwyNeglMybpbr2XeSsv9a0ssZvFStfvOPI?=
 =?us-ascii?Q?QMEbIhi2OKZ8HlOKzhchQg/9rB+yazu0kPn3rOczDrs7Qkp9cH1B8gYeeQsN?=
 =?us-ascii?Q?iLNmVq9yhpiwfdws6G1x8VTMleLf6L7SCcc6aT4mhEUn7CmDayZaayZUYqkH?=
 =?us-ascii?Q?X8VGnSvlLj8lQKQdYvVBxhmgs8+GG+feitXHh1BfIyZIcHkDjIG4G5T54EC7?=
 =?us-ascii?Q?0iyHV5Q3pbZWiZKRTJPWqvZ1FpYAIPMyJ5WrTXmoZ+ZeJm4Uz4Ra5EGbYQlZ?=
 =?us-ascii?Q?SD17SAiR91TkFghNeLGHWiP/h6Xx95a+FQttaaKtsyarsyDhueRXaXQfgHEJ?=
 =?us-ascii?Q?N07iIVdCnMrp13vYBysDYwKH1v7nV0wSEVqOkjzJhSs7vul2Ls/6a+Jr1AUm?=
 =?us-ascii?Q?B06Kmqgji1jzR9++HoC6Ehlo4KQEf8M17Y7z0eAX5UE5NWT625UJ60c08VTX?=
 =?us-ascii?Q?p3qjm8xWyO79HnJbXpYh5l4zxt88yTr5SCNjHAYGBXFPZZtPm+FLp/ZTKdSk?=
 =?us-ascii?Q?vNxFS/IKyu8zYCkas7PPM/KYyA3j8PWsW3rnp1Hi9D4Ly0Z8ObsccTLePBm1?=
 =?us-ascii?Q?7JY+2pwB0K5HiC4CTDc4TjQjaQc8XPrHcSCv+pzv6aVyVJU/7BPXaHj97kTm?=
 =?us-ascii?Q?Zq4Hch8yv2wSrE/gibBY+Agihjf840Ytdbk03Bpo1zsKbsGMJZpDNGDa+RCt?=
 =?us-ascii?Q?vrpqIPKJ2AlKxVjDUCYJOcNr2xo9eCUP9s7gF+D4Ef9z+QF9Y24yx4MSkfCW?=
 =?us-ascii?Q?xUpAday3pVuSQeQGW+1pFbTvdcbNzOIWLlHMAd5VnTJVndFoKGmfpYXe7IUJ?=
 =?us-ascii?Q?6Z+RpFkyypgAF5r/VjEQBon9R60xxbQxurXb8Vyef5sJU9iBoNEnLXF4JlWj?=
 =?us-ascii?Q?gp55FPM9Eu2ikJffznY8ZCrzPDdB4TouOFyTFb3xHTGhWI0BZ4TJkr2FPnBq?=
 =?us-ascii?Q?BrsPizISQC83GosEbfI4WbF9Zdw4a/WecAEEi9EajkyFvbi5IM7IhCfh0T/9?=
 =?us-ascii?Q?JK2SEyXtnpoDs8Hfmt6UqGD6fpKOhOpi/5T3BbMMfowdIEyLY/Ckj1d3gkUx?=
 =?us-ascii?Q?eGRZKYqSOGOToleMN53xml+JO2/Uif2PPwg/Z9vDVEFZFgV9ITxpejOZDRfU?=
 =?us-ascii?Q?lHxiV4V40csaRUpIFKtZF8BQVi/HlPjcVODZOfdS+yQ6VIYsjLG5KANiJGEr?=
 =?us-ascii?Q?nT5VmEp80CfOpPmoi8xveOqanPr250TgUUcZf3kWV85jRG/Ylh7xVEnJ/ePz?=
 =?us-ascii?Q?XdqMMROpXvUrMjONU0j5gyqTtpwPYY+d+ZfMwRLkcyCY/HPN2h8112ICGMQB?=
 =?us-ascii?Q?6NAWRw1J95CX7SA2NpN6ATriW4FIDcR30OG0/7+n1V2XSzvaLATYaxZ1DCqI?=
 =?us-ascii?Q?qPb74gAao7krzT5RInZVX3olAwvWbbgvuXEkV2WpGtHGCLouff2tcc+DBShJ?=
 =?us-ascii?Q?LKva9FhPlmpqh2M23vbyL7oFluTG/d57AUPQS+ypq47CnSD8K4POE+LQ574J?=
 =?us-ascii?Q?bwYvhlZ2QK84HZDmCbt5IwTqqkmoIJPCl8T20ucNo4N5URM0WMrj9BxpxNMW?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48412ddf-86d5-4d1b-1088-08dab57c0142
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:55:43.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zg8j4LDGgbxTjs/qoQAyQ2frUXMW1tU8TJw2Pqaj5hiiuZkkGHZwImUg6JU5NnKOrc73IWM7jxwkhT+9f+R5rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: gg1jEAd_m8KcjfOpH3kZIjUswC5S5PHK
X-Proofpoint-ORIG-GUID: gg1jEAd_m8KcjfOpH3kZIjUswC5S5PHK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 4165994ac9672d91134675caa6de3645a9ace6c8 upstream.

Factor the common AIL deletion code that does all the wakeups into a
helper so we only have one copy of this somewhat tricky code to
interface with all the wakeups necessary when the LSN of the log
tail changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode_item.c | 12 +----------
 fs/xfs/xfs_trans_ail.c  | 48 ++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans_priv.h |  4 +++-
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 726aa3bfd6e8..a3243a9fa77c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -744,17 +744,7 @@ xfs_iflush_done(
 				xfs_clear_li_failed(blip);
 			}
 		}
-
-		if (mlip_changed) {
-			if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
-				xlog_assign_tail_lsn_locked(ailp->ail_mount);
-			if (list_empty(&ailp->ail_head))
-				wake_up_all(&ailp->ail_empty);
-		}
-		spin_unlock(&ailp->ail_lock);
-
-		if (mlip_changed)
-			xfs_log_space_wake(ailp->ail_mount);
+		xfs_ail_update_finish(ailp, mlip_changed);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 812108f6cc89..effcd0d079b6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -680,6 +680,27 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+void
+xfs_ail_update_finish(
+	struct xfs_ail		*ailp,
+	bool			do_tail_update) __releases(ailp->ail_lock)
+{
+	struct xfs_mount	*mp = ailp->ail_mount;
+
+	if (!do_tail_update) {
+		spin_unlock(&ailp->ail_lock);
+		return;
+	}
+
+	if (!XFS_FORCED_SHUTDOWN(mp))
+		xlog_assign_tail_lsn_locked(mp);
+
+	if (list_empty(&ailp->ail_head))
+		wake_up_all(&ailp->ail_empty);
+	spin_unlock(&ailp->ail_lock);
+	xfs_log_space_wake(mp);
+}
+
 /*
  * xfs_trans_ail_update - bulk AIL insertion operation.
  *
@@ -739,15 +760,7 @@ xfs_trans_ail_update_bulk(
 	if (!list_empty(&tmp))
 		xfs_ail_splice(ailp, cur, &tmp, lsn);
 
-	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
-			xlog_assign_tail_lsn_locked(ailp->ail_mount);
-		spin_unlock(&ailp->ail_lock);
-
-		xfs_log_space_wake(ailp->ail_mount);
-	} else {
-		spin_unlock(&ailp->ail_lock);
-	}
+	xfs_ail_update_finish(ailp, mlip_changed);
 }
 
 bool
@@ -791,10 +804,10 @@ void
 xfs_trans_ail_delete(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip,
-	int			shutdown_type) __releases(ailp->ail_lock)
+	int			shutdown_type)
 {
 	struct xfs_mount	*mp = ailp->ail_mount;
-	bool			mlip_changed;
+	bool			need_update;
 
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
@@ -807,17 +820,8 @@ xfs_trans_ail_delete(
 		return;
 	}
 
-	mlip_changed = xfs_ail_delete_one(ailp, lip);
-	if (mlip_changed) {
-		if (!XFS_FORCED_SHUTDOWN(mp))
-			xlog_assign_tail_lsn_locked(mp);
-		if (list_empty(&ailp->ail_head))
-			wake_up_all(&ailp->ail_empty);
-	}
-
-	spin_unlock(&ailp->ail_lock);
-	if (mlip_changed)
-		xfs_log_space_wake(ailp->ail_mount);
+	need_update = xfs_ail_delete_one(ailp, lip);
+	xfs_ail_update_finish(ailp, need_update);
 }
 
 int
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 2e073c1c4614..64ffa746730e 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -92,8 +92,10 @@ xfs_trans_ail_update(
 }
 
 bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
+void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
+			__releases(ailp->ail_lock);
 void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
-		int shutdown_type) __releases(ailp->ail_lock);
+		int shutdown_type);
 
 static inline void
 xfs_trans_ail_remove(
-- 
2.35.1

