Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0A4C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 623D760F4C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhJGA2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 20:28:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47220 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232398AbhJGA2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 20:28:44 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196NwfdJ019759;
        Thu, 7 Oct 2021 00:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=u1PT8DASiNugaQHTAdveoXLxryponcwOL4FG9bLGq0s=;
 b=kKbAIEtRDL0IG/r13mHOxmBPVdxG0W06bCrKvLu4w6sKyd1dUuSudFe3Z6qiO8Fokpgr
 ghm2bwePwY8xBpY0+5EPhJoGlKbEi9tepj+SW0UFt0w6wTVJp7td3alSmJ2XN3Tt7fdp
 tED/4Bjlg85Sa3w5tLP9pUG3ZZejMxorkKOAXcrXKSNEiriZNZzKw3YlXsf5I6RyTyrc
 70IFiXErI9Az+OGUHxcxeGpbENhvR3RfoRLXmDIJAlrCEjv381gLwfiKk4/uGpuA6tQ7
 Lj3K4DfaGupw3VobMfmwhdRKELAdjXa4U9lcSs6LPVO9XZG9RYrW4bFDJtPAdnDU5wk6 rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh2dnqjam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1970AkGC192858;
        Thu, 7 Oct 2021 00:26:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3bf16vya41-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wegl5Z2Y+vPFpXI07VnMUNZJlBTIZOwnYAmlByVZRKC3T04rJZILYlxjmGg7B6KmLxMEJ6u1qcehAI95xu5b28xF0uIUUfX9P8ifbxRznxjM1U6ymn4eZUP9zK/d2zJto8A5VbcNXD8TK1rSCWYEVChCqFqRFdK/qiOJEVSwe7iOEKijgOXasJ25J32tpBGW0/DNizMOCSdPxRpAErqQ3CGdoVLbrjqfRXFqEbrQFJH4ZkzESkP94NNhwUKrZhItkjqMKh6tiFEaDMKl1yAhPikU+MdCsmd5cTACA5ANYNis/IRxLB7/o37/n8iavg2XTxSrDvfjSxGiX4u0e0Q6+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1PT8DASiNugaQHTAdveoXLxryponcwOL4FG9bLGq0s=;
 b=Iuu5egQt05Oh3Z/JS3UbRQbqJvsHs4hGAFRzNMNlbYheDpRTqvvxRhkLU8lFbZy/vgxa78u4MVhahHTvmfuUShPYbTLBhRLYQvVNOcYUjM+CEr4cosa+f/gHv5U8fKhU9P/StMTupEYugLXI5sUc7bVSL0ZpTk2hz0dK0xRRqb/zX4AeLjDtF3apmts32DDqVuMXQmnejLWW+/9DQjbdUAH5vOQ9ka1zKBr8b+rYZ3ankDpU1Jdr4uADBqvTii/LoFwMwAVWs3a/WE2uhzZxr0LXDZJ4B0q9Drp0Ed3oPNg504c2dg0z6ZAZTefE+qGFOjqXKnNdOTWmMr+IY3wBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1PT8DASiNugaQHTAdveoXLxryponcwOL4FG9bLGq0s=;
 b=ZvjAjeZAmLwmvkQi4wVHIoSiUR5Z1fsFpI5tGpfZZlNcGsok4FRq+BI4A04ucL6qFetF2P88hdrdkbVbUNNbnZD2BO4JyENzimqmH4iQdVDFZy1qJrMYiAA5A7e2ZAfeQ4IjFqdpMzjTEU1qjJtyKj1n7bfkcW/Gzrcwa5t9hwA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DS7PR10MB5118.namprd10.prod.outlook.com (2603:10b6:5:3b0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Thu, 7 Oct 2021 00:26:48 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 00:26:48 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH v2 1/4] xfstests: Rename _scratch_inject_logprint to _scratch_remount_dump_log
Date:   Thu,  7 Oct 2021 00:26:38 +0000
Message-Id: <20211007002641.714906-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007002641.714906-1-catherine.hoang@oracle.com>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:c0::32) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by MN2PR05CA0019.namprd05.prod.outlook.com (2603:10b6:208:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Thu, 7 Oct 2021 00:26:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e78e443-f326-4a60-e1e8-08d98929264a
X-MS-TrafficTypeDiagnostic: DS7PR10MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB5118EF73A1867E5C44B1630689B19@DS7PR10MB5118.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: daRuYYJ9a264nVQLz1p2bZuEu5RI1k+yeifUbsYm4In+ehBbisXgAKB8aZFD/Fd/blYZC2p/pbNI8RRWMNGi9vmMyumSkOeVcsBjz7/RrDHQdEigvpjgMIXRVvMe8+/XLNxHyhIOTRkMbIoSadfhC09IvWHuCBdjUaSC3wxmTU9zR+iAJZGh1lBijxDE8Eddz/UurvyUN9GLQPSmoGJU8zUtVDa40eJaXb2IodeWjp7bB9cb3zV41cxsPq4HCkLC11cjhAiWPCortKgigJ2tmvTABF1Un2VJd80CL5jB7TJThW8OjJnQb/XC3k+XHhmH49vei1A3EaxboVyc9QhevtOrB/Mq3sBMLRypgAc1S7E0CBJVpNnCqmA4hkaYHZ3R3AVMA4TyA827GymDW1lhP4BHPJeiUGdup0Wkw7EEfjxYBEJWJEAujiCXFcUAlZVpqYPDX1f7poj8s+Zd8XDzqbwqnNwjznB/+elE7IysKa+Wbj8k3bXjY/95RHRuzRBKmgLeIt2syX0L1YLer3dauS2KkUJy5xYOkjGZvpWtygNDPoo2LNcu8wjYWiCc/6vjQiROJSI+WBTEIQ8j+9zuQbtnlNmNBFs8Anh202Mynadp1J0agqhaG2dNhujmZZinZUHHVzATnX1Ks8HO2PIGomACemxG3v4MdU7O5MFu98KEE819Sl5yGUjOW35pRyH1HsHoQMeuOh6zpzgzEMRbDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(508600001)(6666004)(38350700002)(186003)(2906002)(38100700002)(36756003)(107886003)(5660300002)(44832011)(83380400001)(8676002)(450100002)(316002)(26005)(6506007)(52116002)(66556008)(66946007)(956004)(1076003)(8936002)(4326008)(6486002)(2616005)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VIE79adoNWjIwuyvNot9EHcwNucqgVS+6fLA1VVjXo0qxDutV3vCouCiUOW9?=
 =?us-ascii?Q?tGIwm7S39k7Jc7BTnDJFHWvdzARbFjEClEjBlN280wYwTNwgM15NuH9Mj8er?=
 =?us-ascii?Q?eTDS7RC5eQLhEhpO3JA10jbdBHqAkYIjqk87gsIYVnacbOkDIdMJJsLBUYiG?=
 =?us-ascii?Q?u8qBiC4f01W4pKX13g1qzaZYijLGlr3X4Iv1i7hT67c79+dU0Vnc461nKH0F?=
 =?us-ascii?Q?pn0xI9wGWZxgWLSOX9NgbywH3UnM1kJ3V1EwuCc2UB81y6ruuW+9IsXFS7Hj?=
 =?us-ascii?Q?wtS66PKKqbqF2l8YYLN69RRMcxoyNNoUz4feEhHYmVPzA/vQv7Kqrb3cVp34?=
 =?us-ascii?Q?Zfy7DircYvzCreRQ/qF3KUtIPibVbs7uXCJYY/Z8Y0jqpfeUQ8oo3ql+FzFi?=
 =?us-ascii?Q?YCB2b+aZuamt4JeLx/IRzYD18xmygFgweHL9EMMLtbfRvc/CAGlPMCBoR89j?=
 =?us-ascii?Q?TGwEsAOlrMANOdt3ZZ1XHl4yOyo2AUUqE/zZUcjWms+PI4rSEZZYVXtxDxUp?=
 =?us-ascii?Q?QCH9Hg/69wWoSrZEKrTKj4vxCUqJnd6kB985sxPY5PVUxZ3Jci9lOnPQSjvZ?=
 =?us-ascii?Q?SIXBsNdmKIUYeb/9SUOoPmB1nYSrmDdBd2ziYT2rx2kHtj4pFeMJIAyiXwqL?=
 =?us-ascii?Q?LEVFcNoFOXTSgzlYoxV+xopjVMDnN+OLGC85xKuUQdjHFLHnCE5koeYHDUnP?=
 =?us-ascii?Q?OdGgG3j9RFBhXhoA232uyKKfLTWR0+FZv5L1JInLGdRLcT5OWqM8ESakZENE?=
 =?us-ascii?Q?59jw+XYU2+lmKI1dh/lf+nyFZqEZhzRCt1wbx+Symp2gdcGYvlAsQPJv2DVe?=
 =?us-ascii?Q?9dgyQvuEsHVl0bMWdOjjnrQ0Nc8JBCTUx6z9ArrG0gwlJWAK9GnESB0y1Irg?=
 =?us-ascii?Q?3vZ8POFRjtNEgty/cl37kzkSHjDhz0KCHEaoXgsS3bO/gB8ugrqIvVceqvAc?=
 =?us-ascii?Q?uXC92EGuq1+sqKsFziZAHbUNGyDsZTxLiIf35W5SC2WjHh3o3pxYiuUnRn25?=
 =?us-ascii?Q?rE3GMtajRwB2GWS8fgK5RmqQ6Fz5h89GCnaPMCT0sDs1hYoetlFX5JzMjqIm?=
 =?us-ascii?Q?ZCAf10UmUDpg2CfawXXNpI5KizSLUtS+AVWNFPQkv91DOrkUgBBBCfm9ZVRc?=
 =?us-ascii?Q?slz5eS3NBd+0X/DW1IeAW3QiOUjHn7XMa0OZsO50a7cVSr7dCkn7atTWk7Ku?=
 =?us-ascii?Q?Ky/3y3AiSUDg5yBuoQmzLIzgdp0N9UPk5Gqkr1+BDJTVu5D9+HVbjMJRBs7m?=
 =?us-ascii?Q?jSUk6NzfdkNKRWCnpRxyUMB1N5yNKAKnpQexq248PKdNM9XrfDtFaOG7+4NT?=
 =?us-ascii?Q?vWya9fiod7nPTiWWyFs5M2QT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e78e443-f326-4a60-e1e8-08d98929264a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 00:26:48.0860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3ygwUesXa+9z+qZigwnll0kCi79DTZYoztekWC0HdvqoBFtyOnonOp3aRnMCBBLbfXFbfEHrATY95t/Zo7u10TqGomYEPOonnOc6GUDFio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5118
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10129 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070000
X-Proofpoint-ORIG-GUID: 7MQm9tgOFGmQFohhc-70RbddKm9voebj
X-Proofpoint-GUID: 7MQm9tgOFGmQFohhc-70RbddKm9voebj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename _scratch_inject_logprint to _scratch_remount_dump_log to better
describe what this function does. _scratch_remount_dump_log unmounts
and remounts the scratch device, dumping the log.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 common/inject | 2 +-
 tests/xfs/312 | 2 +-
 tests/xfs/313 | 2 +-
 tests/xfs/314 | 2 +-
 tests/xfs/315 | 2 +-
 tests/xfs/316 | 2 +-
 tests/xfs/317 | 2 +-
 tests/xfs/318 | 2 +-
 tests/xfs/319 | 2 +-
 tests/xfs/320 | 2 +-
 tests/xfs/321 | 2 +-
 tests/xfs/322 | 2 +-
 tests/xfs/323 | 2 +-
 tests/xfs/324 | 2 +-
 tests/xfs/325 | 2 +-
 tests/xfs/326 | 2 +-
 tests/xfs/329 | 2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/common/inject b/common/inject
index 984ec209..3b731df7 100644
--- a/common/inject
+++ b/common/inject
@@ -113,7 +113,7 @@ _scratch_inject_error()
 }
 
 # Unmount and remount the scratch device, dumping the log
-_scratch_inject_logprint()
+_scratch_remount_dump_log()
 {
 	local opts="$1"
 
diff --git a/tests/xfs/312 b/tests/xfs/312
index 1fcf26ab..94f868fe 100755
--- a/tests/xfs/312
+++ b/tests/xfs/312
@@ -63,7 +63,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/313 b/tests/xfs/313
index 6d2f9fac..9c7cf5b9 100755
--- a/tests/xfs/313
+++ b/tests/xfs/313
@@ -63,7 +63,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/314 b/tests/xfs/314
index 5165393e..9ac311d0 100755
--- a/tests/xfs/314
+++ b/tests/xfs/314
@@ -64,7 +64,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/315 b/tests/xfs/315
index 958a8c99..105515ab 100755
--- a/tests/xfs/315
+++ b/tests/xfs/315
@@ -61,7 +61,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/316 b/tests/xfs/316
index cf0c5adc..f0af19d2 100755
--- a/tests/xfs/316
+++ b/tests/xfs/316
@@ -61,7 +61,7 @@ echo "CoW all the blocks"
 $XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $((blks * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/317 b/tests/xfs/317
index 7eef67af..1ca2672d 100755
--- a/tests/xfs/317
+++ b/tests/xfs/317
@@ -54,7 +54,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "Check files"
 md5sum $SCRATCH_MNT/file0 | _filter_scratch
diff --git a/tests/xfs/318 b/tests/xfs/318
index d822e89a..38c7aa60 100755
--- a/tests/xfs/318
+++ b/tests/xfs/318
@@ -60,7 +60,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "Check files"
 md5sum $SCRATCH_MNT/file1 2>&1 | _filter_scratch
diff --git a/tests/xfs/319 b/tests/xfs/319
index 0f61c119..d64651fb 100755
--- a/tests/xfs/319
+++ b/tests/xfs/319
@@ -57,7 +57,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/320 b/tests/xfs/320
index f65f3ad1..d22d76d9 100755
--- a/tests/xfs/320
+++ b/tests/xfs/320
@@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "Check files"
 md5sum $SCRATCH_MNT/file1 | _filter_scratch
diff --git a/tests/xfs/321 b/tests/xfs/321
index daff4449..06a34347 100755
--- a/tests/xfs/321
+++ b/tests/xfs/321
@@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "Check files"
 md5sum $SCRATCH_MNT/file1 | _filter_scratch
diff --git a/tests/xfs/322 b/tests/xfs/322
index f36e54d8..89a2f741 100755
--- a/tests/xfs/322
+++ b/tests/xfs/322
@@ -56,7 +56,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "Check files"
 md5sum $SCRATCH_MNT/file1 | _filter_scratch
diff --git a/tests/xfs/323 b/tests/xfs/323
index f66a8ebf..66737da0 100755
--- a/tests/xfs/323
+++ b/tests/xfs/323
@@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/324 b/tests/xfs/324
index ca2f25ac..9909db62 100755
--- a/tests/xfs/324
+++ b/tests/xfs/324
@@ -61,7 +61,7 @@ echo "Reflink all the blocks"
 _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file4
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/325 b/tests/xfs/325
index 3b98fd50..5b26b2b3 100755
--- a/tests/xfs/325
+++ b/tests/xfs/325
@@ -59,7 +59,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/326 b/tests/xfs/326
index bf5db08a..8b95a18a 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -71,7 +71,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log"
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 
 echo "FS should be online, touch should succeed"
 touch $SCRATCH_MNT/goodfs
diff --git a/tests/xfs/329 b/tests/xfs/329
index e57f6f7f..e9a30d05 100755
--- a/tests/xfs/329
+++ b/tests/xfs/329
@@ -52,7 +52,7 @@ echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
 
 echo "Remount to replay log" | tee /dev/ttyprintk
-_scratch_inject_logprint >> $seqres.full
+_scratch_remount_dump_log >> $seqres.full
 new_nextents=$(_count_extents $testdir/file1)
 
 echo "Check extent count" | tee /dev/ttyprintk
-- 
2.25.1

