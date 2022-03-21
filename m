Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D09C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344395AbiCUFWs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344398AbiCUFWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2465D3B559
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KI41IA027688;
        Mon, 21 Mar 2022 05:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ujKJRbx/iCVEIKKm8fUOqWS9EnqGEZkB3nMmPUTpVaU=;
 b=a7eKOx76t9SeAkHd1Vbj5sjnd7UBRlqBCWsPEoLejoJtjzjjzcrXyD+b6KwXPMzetvQg
 5enrrCkjbC7oswzuwKo6gTsi68SSU7RyC49oloi++9OrtWig6rqC0aDU2CdvnxQdnv8h
 oYpn1ipNjOYVYzGp9LsRpDhPnhSPgvP6g+IZbCyW6dHVggS57RIkwbuUfzgKq9Pux3tq
 c4KJ8fwodoteqDqCNwmDyAjpsiYsXBuTTQzP1M3EfshjH+WYOmkZ618q5W6wcl0QN5SZ
 SxdMWic2XahxFFh44f9QDJLhISoBs9kfJNMi2QuvGn6pY0L3Nl0UxUBfec2UBPQ6SL7l BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1t4t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5LFCd096821;
        Mon, 21 Mar 2022 05:21:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by userp3030.oracle.com with ESMTP id 3ew49r2h3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOBGCJsp7b5bfqBjISeu7GQ9p/2BM0Vmls8pooSd4uXabjCFTVPVbzACCg8klcFecl0Y54mO8RNpIvc1opW4PeRPoKGL9JW42r4Z98GRq45+5r/pTDLRBHfYv4eSC3IHcyVGuTSCP10qsHPzKqKS1Vp4BoDDY3/ky8h9T+rdoT+BtcXPyP4rSUExPVh1o02eq5OI9OKbl1M/Oo/JoIsjCobJcrhe9nTLbQJLAEYo+p+ZXcOLz2kJC2TTvlHKpb7QM0+GZMTUtnmkQPZtxD0tgN0gz6Vx9SobYEcwtgIxeTPwOU+ydRQWOm1HY65DAwdbX3b1CacnHpwu/cps+owMQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujKJRbx/iCVEIKKm8fUOqWS9EnqGEZkB3nMmPUTpVaU=;
 b=UJ8OQi2jbjFSjZM+UQfDIad8javp6Wre49wVA6hFO4RHjwGxbxEgjdKJQoT9+SrJkYaPsDKlUkwqQ192YOkeBmRs8YIxr6PbIoi0GhvqfPGKu/VlX5T55TO+my3dkrKcgP9i0oZ/jnesPMfkOrTohqnMhqZT4FpvwhKGyAyAIhMlI6kynR+EdQMCTVEIXRo4Z+z5RPnsMpVHT1ME4MApJxq/znm4wmdQxW911cOKfZ/hpl3QQhv+Hmaz9H4sXh24T4u+SnlcaQ3LZDXAqe1Fsl60jUA0DsRSw+LDU9L3rjjuNIymF1+bq9wtuk2yaCs/JXyXmVX6FlmbqDziB+ZJpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujKJRbx/iCVEIKKm8fUOqWS9EnqGEZkB3nMmPUTpVaU=;
 b=Q5za43G5+xmWqRO9QM0F+7wQ4oWZEr8dz4CCs14sav0fTV1VawtibsiEuekpCcWENB9cDIh0kzmgX2Oji5xo70gTs/j96HXNV54zRQqZ0LqyTJYm1ISn7d7wjfoZDXAnVU41ehlbaLeSNMTcn7cQ2xNRFFv/sqP5FHoPIfJiFtw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4473.namprd10.prod.outlook.com (2603:10b6:806:11f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 05:21:13 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 15/18] xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Mon, 21 Mar 2022 10:50:24 +0530
Message-Id: <20220321052027.407099-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d24e60bd-ad83-43f2-8974-08da0afa9dcc
X-MS-TrafficTypeDiagnostic: SA2PR10MB4473:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4473D25506ACAFD8B2930603F6169@SA2PR10MB4473.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlZn88XDsAJvhHIsJkvfzRqgXyAKw1IIpK8U2hWi0G8CdOLy/tMcCL8n+677FJOeZQ8mMAQDbSeLNyu7ENgkNU45or7lnkTfHTwrBV+cE622ErEwiAsQehCff7W+RbbDc2gtnquD2zLQKVn6r2ExCvk5Gn7QtwA/HByBdGc3nN+e5q2hRjJKDM/oLa01BSrYjMDMR/odL9ecII5aVpsPzIDwSWL10zB1vKEdW81KE+TMtbNh9Wg8cyna2neSzaDWwUBKg1MlIrBSa52adl4K5vMRJDdma/wgZ/A/erZWmWPXY5uJzJvWEcAGg7vIuhJBSsBuQFDufAoErgSkqytd3uX587F4CAWIYZFEz5ExYQZ3ZusY7bv/ozWoiRSWDzaFtuhfxAgYV0rILcLnJedvcB/jP/qPll8FhqMhunHr5KFXM8UMrsY/a1QhfGYdnnvh4KJfuDXk+hSTaV8v+J8/4hjiWuNF/nP/8w8fffJfyWTu+2E0/qT2+9VYelDHBO6uaqwSdedT380mLaRBd6TC3UNwLjUmcVpQKPZ7o3OJJciYznI0UE6J9WbSnbswcxYajiZEdJ3ldG0RTNPXkav9N0yFydhHzybiUZo1JUeH7gSqO5I1cfPjQ1pKMN5e0+VYDyjxHKsmWQByOSn5T/+xzR7r69UvqA2kFbl56GE7GNmeOzFKEL9YfUw7WQ328V/zlMqMbFRYhrBbZpOGMHVpFbuWTuZH8mcmTCFqnlrZQ0lUCEUN3U+cHAj0R2vBnscY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2906002)(508600001)(83380400001)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(6916009)(86362001)(5660300002)(38100700002)(38350700002)(4744005)(8936002)(186003)(6666004)(36756003)(26005)(6512007)(52116002)(2616005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YbvPWTW+ic5yehnvpG2HznWhulpXPlXPSlXCkM3SL9Nq+ladfrC79pyuMjKD?=
 =?us-ascii?Q?715ZqBMA5qK7lrPs7Qm4JJqW53j9dk3SpSoFsrtAEH/2wg+OwU9UGkTr0Gh5?=
 =?us-ascii?Q?c5nCR5ua/tSopxOzaBqVw1wMdXOmFzHKoP9svorjwxGeS7dj2msLt9BtOCdQ?=
 =?us-ascii?Q?ivMc0i5aUfKkmch50YVjVB0NFCcEDRVeIJoPDhP2MmnQwrgB7X/VNoWgaHTR?=
 =?us-ascii?Q?pYfQuTQxwmQgdfiz3FhQsnVLAST+YZJme5lkunkKi1KlXmDZ5BdBqWarSddC?=
 =?us-ascii?Q?x3knJeK1xuyZ5NbSx5Rro0406NChlp3hikHUlbnHGiwZcZNE58mL6iLCWcQc?=
 =?us-ascii?Q?+AGQ+0YMyRszRi4DbZqIz7/58zD1C+C8a+ICeZQmQbGWY7pj9HnmI2NpgrfC?=
 =?us-ascii?Q?6tZtos6tREdD6keAHlYeam7FkRdOS0VKDdIclws/2hOzbghGQPYSIIv8RoKB?=
 =?us-ascii?Q?iiIiJUMAOakPlnvM+rLt/YB1Qq2ieA6vxA+PAXR/h8dGnpkI1nct98vIIz9K?=
 =?us-ascii?Q?ZzRWsND6eIrvealCpogK3Pv6wbNZXFLUgpFpQ+7hPOMtK71ME3lmMtb3i+sd?=
 =?us-ascii?Q?hjS2HMq6NcxS0vXyFjVOUrkareXZfhE9JBDgOedPSxxrGqKurSu/jNSzXu/F?=
 =?us-ascii?Q?JZV4R8uUZ4VEkdjH//I2GrPfbyO2F4QrOfeHEB/sDr7zggXq9Obx+yEi5IbS?=
 =?us-ascii?Q?Od5zaVmaxrxNCvAi0eDlKtWQArhBDFeDujYLQaY9SGXk/ymYwDoUw7EabfUP?=
 =?us-ascii?Q?yyH5aRG8aH7k3SI9dFl3tWmz2iBPvCZ6lv1Em70Bx7ViUj+wAEG9mb0K8VMg?=
 =?us-ascii?Q?tSwTCTqBcpk8AELuQKOBiTkeuQMEhgUfJkg4I31kCO72ONWPuHwARM3qMdIx?=
 =?us-ascii?Q?wdfz/eEUEijO54dUjThgI5XUYlRwC7+mUZ9wPO01k5uHZk12BTlxCXAjC94f?=
 =?us-ascii?Q?GH9bDWhojE1eA+0U/xW5tOzv8oZE5Y7T3Z5kbdEZKXexvgCs4xFFK3AMPsuW?=
 =?us-ascii?Q?AqGz3rsHUCmwYyy2/kDx3iR+BvYX0JMpXsVT4Raj06bo9XS03ZFc0qVPsvpx?=
 =?us-ascii?Q?OhJovqYmUd9P/X9VafRj02c+JgKoS3QavkSYdlzd4YFPgmVYvD9dpg1Orphu?=
 =?us-ascii?Q?SxGrS7eXO12BEi1RdDFLjF06tKthHOwW1I9Y6aTfthD+qCMHeKg+7J2okb24?=
 =?us-ascii?Q?H2X65Ev5WWYcj/EeH+lDeQEIrJP4Kqv2KrGsb4cb5CDHZGYdPfnatsIvrWeu?=
 =?us-ascii?Q?rqIUoICzg+HgrUTfq2TeJ/meAZ6HTFrCB6kmW72z+Ezd/9eT9wE4sDtpQvzW?=
 =?us-ascii?Q?r3Vjn+ZdkYyAfbZVDIieozNGt3SkyvXgXCDA2Yd1XmHbix+CYnqIMLe5/Rw0?=
 =?us-ascii?Q?3hjujC1ugLWer7xSmQlVkk/e8z+KjQidLnaZH+nCNqUuA+2U341Z2xUcwrdW?=
 =?us-ascii?Q?Waar+9JyvZjNy79I4oHOJtUOh2HCm/258vhL2yM/vY/E7jArTO35TA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24e60bd-ad83-43f2-8974-08da0afa9dcc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:13.5000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2b4QnM5NBrbLkVvJKM7Q66WJPHr8ir3UhaJwgQQuUIOmM/oDEY668//qQ6BDlh+zspgohyXfFvLqSsPFWEPmcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4473
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: k5LQnSE1RJ5Lc3WKvzpqbIL--aszPikU
X-Proofpoint-ORIG-GUID: k5LQnSE1RJ5Lc3WKvzpqbIL--aszPikU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 3a8359cf..0dc16fb5 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

