Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF46C43219
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E3A6101A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbhJGA2r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 20:28:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49292 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232398AbhJGA2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 20:28:46 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196NwfdL019759;
        Thu, 7 Oct 2021 00:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=jSmguiHjrsS1h28uCJbJ+KgvbDN0ibjvdlNbPRW8uYQ=;
 b=i36dfPW0mHaw0uuDTGYUBp+ufhsJG6ssaBB+UaErbD2KcMZjvpwK3h601C7HxK5chuRT
 gNSkcEo7ltvcJEAvSVd/UuvBy4iViaHviZvNBLOLqKkayxV6AaZ4FVRwaGLXenltH2UY
 JPbJ1fwFmk+hUhyPnAfsX2SSiB6pdPpzVBQxVbZk209TSDeqm75FLqE1Km9CweehjZeY
 RqWl2zoNRMKWLVnFCLOUiqHoMHvj2AAaR0P9mxVmPymPHL4dImvcGbYqEUwoy7lk3GfN
 TvVakUAKEeeS2BS5+TKpf8fGKgZwbuLVktT7XBcDwOgNONwhT6oxl7r2MmqsbeiQ+WEW wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh2dnqjat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1970AkGE192858;
        Thu, 7 Oct 2021 00:26:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3bf16vya41-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRpi5m1py7kNnlHnWvI2AFfDB7EERa2bEIAUipI8aGseq0yBTUcKVXnfcV/O7OGy9WG8/o7wZpqIsqseupDsOMKZBBRxkTtdPR0iRFH9L9ZS74R3KILlW53xAL9l4MgtgHhtQyUA5XBsifsu+tBjPOHOuZ+M3OWDSmzZ0+2vShNMiJid33MoqGVL2xrWZOXU3rtBHIv7q8r1vIfKAMLU5h8rA+Bc6Q7/lTpt9KS1i5F4A/U4QrZi4X1cnnS3PidIIJHyvamiWZg7AHBMTpW9FUwnl3NHY9vtyfCFsMHMBteNjwnrXxmt3rYLue76YqZtFsOrpS8PCSCudXz/sIsDZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSmguiHjrsS1h28uCJbJ+KgvbDN0ibjvdlNbPRW8uYQ=;
 b=OlfVgiVzMbNTBZUQ0vX6e4Y5q54hLamz4mJcLi7aSLKyx9z9PPAe0htJuNtbFG1YL+rjR4NbWPE++EUCmxuMaQYGeji61OCLaQWlg1JAcdliKHsnQREI05oRjCdOwiCr4IxZ3dim6gnKOFVzLBy+7ztMFrg5+eu53vawjm8LTDLXYtxV3MlS1SG22uy2fGMJuVhFL1Q5dfnCh1v0Xa9pOqPVxOpRWxjqwwvSdL4pKzhuHbldDnlPLvOBzoj5j/x8bfoF0fKRSFAvZZrVAybNW+nV4emDMRb5zslObD9/i9Vfg+nJYldfdCm0gAcqf26luKGVtVRq4SyZ/zESL8EQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSmguiHjrsS1h28uCJbJ+KgvbDN0ibjvdlNbPRW8uYQ=;
 b=tiaNX2Eg8JKPLAHsVvPQloreXaPCQiVfvQip9xYqp5sWQfI1U7hnAEMojyZhNbdhcTEWF6v4UT5ZyoEA0PSEumCD0nBbAKV/ttdOQYjc8X3VypW4LBOCEhKGPo4kmX45nDTcPliOrxcN3TJWGmTnl5uzeUmge2x8KdBYz0t6/wo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DS7PR10MB5118.namprd10.prod.outlook.com (2603:10b6:5:3b0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Thu, 7 Oct 2021 00:26:49 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 00:26:49 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH v2 3/4] common/log: Move *_dump_log routines to common/log
Date:   Thu,  7 Oct 2021 00:26:40 +0000
Message-Id: <20211007002641.714906-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007002641.714906-1-catherine.hoang@oracle.com>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:c0::32) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by MN2PR05CA0019.namprd05.prod.outlook.com (2603:10b6:208:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Thu, 7 Oct 2021 00:26:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41024fb8-6e88-4a68-24e0-08d9892926ed
X-MS-TrafficTypeDiagnostic: DS7PR10MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB5118586478309376056A38DF89B19@DS7PR10MB5118.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6OOi8Y2MVWfMtgsAhaOO/n+tp0xST6b5o2+3uwjACs99Ju0ABcXOyrlU3yk+8onXA0QQpfDb4ZOCZ+D0BI+aVP4NBTEjZplwjl4e1AmGy3U+MqL9ozZ7YtYx0QZIlgWSz92yisaKQkRAp6W/uj3VsEcyWVj4FL157VzJQVOR+8ww0RvkAMSVJLLJrYrFp3S7T7PAYNLWkn4YWZiMpoUZpqXbqSbH5rFVfpjFgnpVxIcpWu9eO78tfhK4xMZZ5UL8Ex1iG0iN3sgqSUc4vn/hMRQhPZhw7617DcL8uQk2wUDnIv1FcnTuPLFx91NNtQKgqz1eqmQTxDvAw93UP8jgERfJESLq0gILLsnkIyTfyTQzKaJPlaeNb1FX9ljFfeeoaJkRhXbI0TVonD8mvqfyZWH0JIazS2ecNYZbNnbAH/bAHIqeyXD1ir45h64WD2qHh/V/2TAOjh6y+r39MOKJsrt0zbnoaAzVmlcIwhzFLv2WqcOKEM+UbBVSKrintTMjfnXCQ6j9l9sOPw8FaT79Hefj/CtyFssJnIC6bwGI5CjARX/8bxfXRq3xd2Kq5upMN9rLd/InjAc1xlbAOq2znaMn7lt8gDUPbym29AgmO/qbmgcioK2v/hxfVdR3rSlnvWQEUjVuS+VecS+OYCijARN52JXUqurmRzceQr8aGY908PPVXiF+W3X6ziJp0nL1GrRDD7l00lGK34ITZ9wG0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(508600001)(6666004)(38350700002)(186003)(2906002)(38100700002)(36756003)(107886003)(5660300002)(44832011)(83380400001)(8676002)(450100002)(316002)(26005)(6506007)(52116002)(66556008)(66946007)(956004)(1076003)(8936002)(4326008)(6486002)(2616005)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?akwWJICo+ILF6C4uVHUmtN3xQzmSFh3zOUEPzWxdSKaCGqnLLIAnceak8giJ?=
 =?us-ascii?Q?+gd6kRW53P45WASJbg+IdjlHDQvcelGEOzW0eFCBSMLBL4z8vmhI3qP59LCE?=
 =?us-ascii?Q?WT+Pd4aBwuqDdkPU4OnVH00Y5MqzO1eSpfTKwx5LCCJNtApLDwUdyhfBc+Rc?=
 =?us-ascii?Q?QZUdPYLqW01McMWXGQO8vSp5keyVcbWs+/JAwcXnyo6/HV6/tEgN4CZf8uYG?=
 =?us-ascii?Q?P6YcMjuRAAX3bqMsnjreNEcrxW7oXBNNj/Bo4oC0pnAWqKJGWaTR5OOwVNrW?=
 =?us-ascii?Q?iWNAskdylQYEUwD6BOOptxT81ZV3Kndb6ObR98FYP/ePAzcTa+YLOSENp+cm?=
 =?us-ascii?Q?96/mx73G9Kyaz5Q39gOC8JOGPNwgLJKZPGPr+BehyIAqkfX/vTV0nW/CxJ1I?=
 =?us-ascii?Q?JN5L2J2zOkj8TShgWK1N/Ghphr3JjodmFEjTzmeriDu8d6Dz8ip11qjy63rU?=
 =?us-ascii?Q?x+ftwhUE/hCs3ppEdzGoPk9XvJwI9EUXDEM4iUb2ko4fzOdrSApGS2q0DoRe?=
 =?us-ascii?Q?YxZtIfEBGYStAL8wXHD0+roB/82kCv3OZVEQj1LlPBKieBx6svuzwIp21leX?=
 =?us-ascii?Q?mBWoDuK3Hx68zfE5KbVi6za+n7DsjTfn7z/cgAiD/vT2X9BBp6MvW9ZaKJeI?=
 =?us-ascii?Q?qg9cZll2h1Q6r6K9JTOgxRemXPEtbPKj3a4RmyGj+bwVN5K4LgZZz7Gdsdct?=
 =?us-ascii?Q?ymp9t33b9ieqrJ5rhjRLnBui3ypxtytr+u5GhDACzG/Z5JGhrm5CwQQ64dJU?=
 =?us-ascii?Q?3mXTpn1CvQaD0Ev3Cs2h92lQd4m3J0k2+CuZhY0e2qo+JUFyLcpX+z6RFVqY?=
 =?us-ascii?Q?WAji8QKAMMlXij5tNt5D84DDc5R30Dns8rWuRUeHUXksYuCq7owmwe5H5b62?=
 =?us-ascii?Q?eIYvX070PUjjrO18tR803lYqAlkSJgIjWOm4fpBKjXOVhpLeX+4mMOwZTi5I?=
 =?us-ascii?Q?GX1X3WWXsub6n3nsb0IzNGOHKQyGmBR4OouC32tHMNrIm1AEGnsPQyiXzZZZ?=
 =?us-ascii?Q?SqgVS2w6l1F6KbdOj/vyOkLTurXANjCOBSHJn50EoCsLJU68/LqZGrhliEXR?=
 =?us-ascii?Q?73oYjDkToE/LaQ1YHjsTVMi+LdFdcYBE2SuKnFMdGPRY4xMZlf3Z4fySLEBI?=
 =?us-ascii?Q?GhV1UIXFZUllcbGTXbgd8omfLPbSi20RtiZNhd77OK3WE9bOD7sOW16sPXAN?=
 =?us-ascii?Q?G8WGvtDSH9aX9hTUYH5ry3T+9WBb6whspRVnD3OJyfzfMk9kFtAslqR/PR3U?=
 =?us-ascii?Q?zsuhR3BnVkDOgMeFtQlXNjOFJIdcgVXg2x0KxxWD+SfneSYMeHdG4BkSAtTB?=
 =?us-ascii?Q?Yw770S6nfI+p333lKX3oGSVQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41024fb8-6e88-4a68-24e0-08d9892926ed
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 00:26:49.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XciglrzYFlLxVcriFUdN+TZkve1pGKc59qbHm+qIfVyeRaxg3tMjMaMvyq6Ll0wPseS0zyFOe0xsj+GAIy2Aezqwa5+WNwGBbNneufij5tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5118
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10129 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=987 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070000
X-Proofpoint-ORIG-GUID: xWc9W--ElLySjNVSSYbJqgRJmDiSXUVL
X-Proofpoint-GUID: xWc9W--ElLySjNVSSYbJqgRJmDiSXUVL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move _scratch_remount_dump_log and _test_remount_dump_log from
common/inject to common/log. These routines do not inject errors and
should be placed with other common log functions.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 common/inject | 26 --------------------------
 common/log    | 26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/common/inject b/common/inject
index b5334d4a..6b590804 100644
--- a/common/inject
+++ b/common/inject
@@ -111,29 +111,3 @@ _scratch_inject_error()
 		_fail "Cannot inject error ${type} value ${value}."
 	fi
 }
-
-# Unmount and remount the scratch device, dumping the log
-_scratch_remount_dump_log()
-{
-	local opts="$1"
-
-	if test -n "$opts"; then
-		opts="-o $opts"
-	fi
-	_scratch_unmount
-	_scratch_dump_log
-	_scratch_mount "$opts"
-}
-
-# Unmount and remount the test device, dumping the log
-_test_remount_dump_log()
-{
-	local opts="$1"
-
-	if test -n "$opts"; then
-		opts="-o $opts"
-	fi
-	_test_unmount
-	_test_dump_log
-	_test_mount "$opts"
-}
diff --git a/common/log b/common/log
index c7921f50..0a9aaa7f 100644
--- a/common/log
+++ b/common/log
@@ -608,5 +608,31 @@ _get_log_configs()
     esac
 }
 
+# Unmount and remount the scratch device, dumping the log
+_scratch_remount_dump_log()
+{
+	local opts="$1"
+
+	if test -n "$opts"; then
+		opts="-o $opts"
+	fi
+	_scratch_unmount
+	_scratch_dump_log
+	_scratch_mount "$opts"
+}
+
+# Unmount and remount the test device, dumping the log
+_test_remount_dump_log()
+{
+	local opts="$1"
+
+	if test -n "$opts"; then
+		opts="-o $opts"
+	fi
+	_test_unmount
+	_test_dump_log
+	_test_mount "$opts"
+}
+
 # make sure this script returns success
 /bin/true
-- 
2.25.1

