Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79652C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 05:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244009AbiEYFhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 01:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241450AbiEYFhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 01:37:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A4433347
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:37:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P0K0QY018266;
        Wed, 25 May 2022 05:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gST9qa3/vgR28wAMbGSMCc2nMCrVHKknFKslyevj0lI=;
 b=dpqDaUiJDoNp9t/cPDjgSmfsXrAssdfVtioP25IuQsUipbkCSwOq27uJdzYJD2H7q07k
 PCD3Q5ovRsxV3bQCmRKo1GbJvxpvszdVqNPaY+OJJOu54LVTuo5cdK6LeGzkjdInzSlo
 ghDPQ8s3rEwhuf3nBvocSnLkQfj9iWxNXL2dUy8vJBbjSKlTE9P9S3f1p4KD7M3RIGA7
 FYUmpoJjBpVJLPOo0+UaR76FklYZbK2pWUIGWCozFcCl5Zey2La5O0JCIzcSsZZCq/6R
 m0HC1ox0U/N+Jr5+chLoDe8aLWmwvdHcteNJuW+5ReujpbSuPzgcaipemD/iz10GmUZP yg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tas47q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:37:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24P5a5IU034921;
        Wed, 25 May 2022 05:37:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wux659-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvQtbpNMVIMGcEsk7Tw8nNLSebzpqGvQgMJ7fAXNTIBi6OMjig4I4wTozOytNMqwrxEgw1K5W9zQjJeyOTWTBigEU9R2MMbdY2Uafw1TCpzGgKlGjEDUGdvMwZN6BVEDUWCGB1pjhCibfHS+nfj193aGpbAyDgmp//ciWNYnQkSkc26gNnzsH2Uyww2EZGwdqomVqBgXYANQpXHks7fFrQdXQYITcdA0fgQfVIORzOckFoXg8rbBeCxBBoX7rgpnAVNEHOHOgXqXgSCVWRFCUR+KXAw3ua+kz/5x/8lzAlQTZzBQxX22gi1qzgqDMEIq8mBKzlrrcuGUIeX96ykYuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gST9qa3/vgR28wAMbGSMCc2nMCrVHKknFKslyevj0lI=;
 b=SaZkSobNrW3cKv7JM+Ie+1GMtTIMHQf53r5ZQ8r0nhh8Rnr6p2sFuQ8SUuagaCvEfCrfCd2sNyKx/2z6TP7qZ2qFBik8q/buiWsmb6m69FEjXAeLn44qScx2ycZkZwhJX/vapUjRW0Yk8HMH6qIg8SZsWCQrLUdPeCLWMezaLqetMEg2b6EI4+6ES4q90Qs8+GTYVJohjV812lueODy698iM9lX7zk7HTKyVNADJ2Mgpk6OhW4APOnkz407wSLUkAzV0Xwi6z1bW8On+L8FDjLlvnO8VDqqmcllDwKqGx7ch5u9BtDJmbb5ismZosLzkQI0gLK7LzhsDK5w88+pYUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gST9qa3/vgR28wAMbGSMCc2nMCrVHKknFKslyevj0lI=;
 b=LdF+9DtZmvtXLOT/7IZwDie6vWWk/uDse2IgvDwnYI2WfybwZZX9AF/djOOlCQWt06RiNUR1O02ZCzXJhV0sXj8YJOMmuDHaNBdMx97eFZ/KiVPC9eEWftDH6hhVhUeDNAJmIfT2E3IRUv/LX4jcFZVJTvfLKu3gmwvf+IErpAg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 05:37:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 05:37:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, david@fromorbit.com,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 4/5] mkfs: Add option to create filesystem with large extent counters
Date:   Wed, 25 May 2022 11:06:29 +0530
Message-Id: <20220525053630.734938-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220525053630.734938-1-chandan.babu@oracle.com>
References: <20220525053630.734938-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbb046f9-0f10-4460-54bc-08da3e1096f1
X-MS-TrafficTypeDiagnostic: BLAPR10MB4817:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB48176E23FBF5EFAF8ADB8814F6D69@BLAPR10MB4817.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/LDSp+jmuyweKJoux/GPIZ7IfjjvqpvsQ7UglF9Gz7F2p3f+iQZoOWlqIKqEc7MuaAHRKHi4f/awmqY7mMYfIspA6MdWns+7XcAWljyzvCgz8Vvm4ndDA65rogE5lnTOtx6mYq2zj0bG+KFUkkEhbBH6i8Pn3IDhBEqyOAQrAekdr+dTHfnyHLTac2fl8RXkkpTLzKsPRpEUPdLUuHs0At8koXOeUBivmgol3geGZ9w5pt5NvUdlmyzkoNxz+0EHE9LDE21jUyH92WBqC2NO46sqMeNNmgXl+dx2Ch2UCA2A8n9/FNMRZjLkv1F4OvzwVtcZjDIXHMh+U6DQGlI81te+RMhPAbZRIx+M8F1UguPqnYxk4scvXBJeBaVBZvhW9QhksMsIhA2luwKl13WnF8XEL2n8axc5cM3OBrB+wuEql/I5w0HyNkVJqT8hxR7XSqLNa1iyuwP3oQfZVx80fIgPnBmom1fR4A+b6k75bYR1MoRudMs+39+psnUUzTMDM1d+y548xBoFo/5xWyL+Rf5Fmxcd2eGoWPiXxFRSM9vrrv/fM7+SgjnVqhzpsePlXOggqF3/D9hAKQ89qQEy2bn5t28W3bGrQeo8lgoGjOo8synGocl6cg1hXNl2+whARQx+8Xwq3aaaSodhOuLrcBtoj2xO5ZIBoBfUjAP6wGJaZMMb6jiMlB1ktS0PKgwSCUJZRvp11WSfdRXiwvSaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66946007)(66556008)(6512007)(4326008)(8676002)(66476007)(83380400001)(8936002)(508600001)(6486002)(6506007)(1076003)(316002)(38100700002)(6666004)(52116002)(86362001)(6916009)(186003)(54906003)(36756003)(2906002)(26005)(38350700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Te39vUcPDStVN99kd3PNCBjKuF8Dhd7qfsQvvvZRcwT35VxTEX49jDlnxCPN?=
 =?us-ascii?Q?aw5U7nWVg4KGzQn9mTdXLdkYGN55zaXjCHiHS7407Wr/jsKy70e+gO+7Z0KV?=
 =?us-ascii?Q?kQb9EacHZ84dgHYcGSYhK/KRD5aRWX+wHi+4ZLlOkmTXtizHfRZL7YQaIR1q?=
 =?us-ascii?Q?Iq+LoFAEj7rYKsj347jc+cvXGbNtGHhLrWplBvFsXEIuDpp/48GmVQCj5SJ8?=
 =?us-ascii?Q?Y4MzDQ4zv9aFwEc3jAF71/CJUSRw7BuKO7rCUhT+731qTUUsgMKRoFWivk5Z?=
 =?us-ascii?Q?Kg8dCCYRMxYNfwXepnx/pVrmAMFizJZM3F/H99mmPRrIjJmFiac2zwXEA5d9?=
 =?us-ascii?Q?OTZV2eYKKe6sP3UyflqBrL5g6B/nzKh2dseSuHjujopgoGLoVKOAoYCyHS1e?=
 =?us-ascii?Q?4DlUTHG6lQDK60z9byn4fd5qM0HTdlgpTp/VLD9T72RjaJMhHS2HWZw6dagk?=
 =?us-ascii?Q?XZ5duFP30jyAB+3/KchlD5cvYAza1BMHpOayldj5JuqMJdj4P2hP3z8rBkVA?=
 =?us-ascii?Q?Nx3D1wspqmJQZg8XGFa19ftIoxkA17AJ1jkdt7XvLxi6BA4XoxzPOHMbIZZJ?=
 =?us-ascii?Q?Bq0l8qxuxGG+Cob1sDBZ80l+3gz4lpuQG70xhq+OO2t5XRd7LjWYm5zJbzOR?=
 =?us-ascii?Q?76blNfq2IPTogdMQJ/L4iZY2JH4GyVrDu7KG4YggYnEKw7BHAxBi5jI9RitF?=
 =?us-ascii?Q?0qx1SGnoHbUlV7nlcCvHz9Xb9I+jiLcpu3ZleQM06Vik9TK5y4gXmN3u4xS4?=
 =?us-ascii?Q?Xaa1lD9lCurtAoxgzvjLhWROUyCz77XTbxoUiCThVp+dC9j0HXwx8YqIM73u?=
 =?us-ascii?Q?mNijCldf54Slei8PH+YlQwAZWpuwGFxRNI+KcsxsQ86sN7orjCKoYrDWcMsn?=
 =?us-ascii?Q?UxLE9UtrxRHzKrnrLyVWYOdMzML0jdLDE0RmW/bVACFsWohpIJtO0GSVCxEg?=
 =?us-ascii?Q?soBAzwLPAgaIcLzchE8YZrvWNryzB+GHPAluQ1eH65JHLLgXlIzGbelbPqgn?=
 =?us-ascii?Q?dfvIkL/r5298W621arZoipUIAj5RtOaZ5cjzh2b6xauVE34R287mtVjU4xTs?=
 =?us-ascii?Q?Blx/j19NAp2kNwknF7KBWrZ5gNGjCwDT8lxFVtc7WqjsxjevE50w++x2zGnD?=
 =?us-ascii?Q?YKLueKGVroE1+sUwLLPkEfNOv8nSmwbGPW73wlgFrAb9L2MXLp4YU19SqqvH?=
 =?us-ascii?Q?Zmg32FSgNdbfsB+XMNicm/ZAld3pdojtLHYnxwVgOjMOfr9lU/o2kiEAUDJo?=
 =?us-ascii?Q?Q+nIu4M+C9uAcxn5CsDKk8Z1B/xnEtlfQtXEIcXdRXqzkViFUItrs+RJhNv/?=
 =?us-ascii?Q?7B/BMON1j0eBJnMPEW0elHXByeYKWoBedAc7G/BeNNHUzcMCZGImhd0/1+6r?=
 =?us-ascii?Q?MViXg6liCPnntxIF7lA3vMu0zhr3D+GIM7xzDw0vEHfu/xTQpauRGYonK9da?=
 =?us-ascii?Q?oHGBXi9A0s289PHwtLQNPjUdj2RN0hNLRvoY7Fh0COS0q4aY0TXrGRKPTBlq?=
 =?us-ascii?Q?UMNQ+G4ZkNlWsH68NNidU0JTujvLi+PHR1avQgeZbK0gJbdy959eR85MayO5?=
 =?us-ascii?Q?KG4Uvq6QsfSKwXhy0NlVaLfQnb4TkUy5FpxgVLArtKV4DTBpILKdvc+D1PSo?=
 =?us-ascii?Q?p56hQt9kDIqMozVZNh9264fFti3jKeNEuHO+eKMwK1MN7fyvKVM2mpXViXCP?=
 =?us-ascii?Q?bshMO7nLLGffGIyMNpA920AlIgf4kBLsIRdjKw0pUfkIyPQNK9Tet/l9GZJh?=
 =?us-ascii?Q?n6uUZLzbh4/VgrYCZv2E5WTN/hUAtsA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb046f9-0f10-4460-54bc-08da3e1096f1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 05:37:00.1017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCd+mbbsoJdaXqmZgtXewiHirbjkUvYlWFT4GcM7UMfzfH60D8YR7UyFd+NvjlYDvIADUEgq4Vj3pHtoWf1clg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_01:2022-05-23,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250029
X-Proofpoint-GUID: N7hPYSTEyS654dF2bJS_aeATictS7tH3
X-Proofpoint-ORIG-GUID: N7hPYSTEyS654dF2bJS_aeATictS7tH3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Enabling nrext64 option on mkfs.xfs command line extends the maximum values of
inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag
on the superblock preventing older kernels from mounting such a filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/mkfs.xfs.8.in |  7 +++++++
 mkfs/lts_4.19.conf     |  1 +
 mkfs/lts_5.10.conf     |  1 +
 mkfs/lts_5.15.conf     |  1 +
 mkfs/lts_5.4.conf      |  1 +
 mkfs/xfs_mkfs.c        | 23 +++++++++++++++++++++++
 6 files changed, 34 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 7b7e4f48..1d8c55f0 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -640,6 +640,13 @@ space over time such that no free extents are large enough to
 accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
+.TP
+.BI nrext64[= value]
+Extend maximum values of inode data and attr fork extent counters from 2^31 -
+1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
+omitted, 1 is assumed. This feature is disabled by default. This feature is
+only available for filesystems formatted with -m crc=1.
+.TP
 .RE
 .PP
 .PD 0
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index d21fcb7e..751be45e 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2018.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index ac00960e..a1c991ce 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2020.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index 32082958..d751f4c4 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2021.
 
 [metadata]
+nrext64=0
 bigtime=1
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index dd60b9f1..7e8a0ff0 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2019.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8c9ef6fd..52f25e53 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -87,6 +87,7 @@ enum {
 	I_ATTR,
 	I_PROJID32BIT,
 	I_SPINODES,
+	I_NREXT64,
 	I_MAX_OPTS,
 };
 
@@ -441,6 +442,7 @@ static struct opt_params iopts = {
 		[I_ATTR] = "attr",
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
+		[I_NREXT64] = "nrext64",
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
@@ -489,6 +491,12 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_NREXT64,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		}
 	},
 };
 
@@ -813,6 +821,7 @@ struct sb_feat_args {
 	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
 	bool	nodalign;
 	bool	nortalign;
+	bool	nrext64;
 };
 
 struct cli_params {
@@ -1603,6 +1612,9 @@ inode_opts_parser(
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, opts, subopt);
 		break;
+	case I_NREXT64:
+		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2180,6 +2192,14 @@ _("timestamps later than 2038 not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.bigtime = false;
+
+		if (cli->sb_feat.nrext64 &&
+		    cli_opt_set(&iopts, I_NREXT64)) {
+			fprintf(stderr,
+_("64 bit extent count not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.nrext64 = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3172,6 +3192,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
 
+	if (fp->nrext64)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
 }
 
 /*
@@ -3937,6 +3959,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,
+			.nrext64 = false,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.
-- 
2.35.1

