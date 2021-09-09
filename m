Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB60C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C0D61132
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242269AbhIIRnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 13:43:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50170 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242746AbhIIRnF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 13:43:05 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189FP4dv016559;
        Thu, 9 Sep 2021 17:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=mTlIcwtBpMyJww31eheea88S6OPEz1/i7BchCMUGOuc=;
 b=NFZslMbb58VaZ32rRgNCjf11cGae56Qn5H//cfrXONbOhALRKSKTHYX1qYJYmdGFmgkr
 LsKndZsB8SpP1887KPM9iMuPaHEcz6gnz4BLddbwpYMGMcLYabXp9I9T9CKIZGePM8zC
 Esa+EIKBhQtAKiEm9PEb6pEWCeL6MNQK3+VLTXMQmqKUCi+0uTKL53X0C4S6h8mWZsDJ
 phsz2TkFBc5FTGHaJ9BvIiUQ+ccVwFS3Jza9NvQrv0J5HyztOkY0j6BRmeJAw0DHLC9U
 yUwRCjRqsIEqKffW+jCwLUD77CGLzONkhwh9LMpXfszh2eVEbZA4Megdr/M+qYnIUxqE MA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=mTlIcwtBpMyJww31eheea88S6OPEz1/i7BchCMUGOuc=;
 b=vG/zcBu2uPzuAuCU6LVKQEZn/lICwv9ZRBxNXxDR78PTe3DAdGXBn+NALlS6W87+70Ka
 H7qqeRLGUoq9Czsxd7spbpoZLpr8Jh8SMGod+f2jwZaS2gn6+Y2/K3BgLt2DpjIurlWQ
 E9pMjrAiaGm3F+wU7s9MAx7+lpw00rHXoiOezvPRn6f64qVTplgc4c7FArAF6b/vR/Sw
 zNrk8iLE6Szp7Z2GpgQjvEHhElBrGcaHRMyr70c44mGwjnPP3WO/lVvNJLvfTY2Zyjyd
 YHrMwNpLnVuRSvwk4VJkiKv0gpsp3bECmo6eeHWEuueHULBDCkVMC/20LUzeZU6LYV1T fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ayf8a9hph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189HQqdQ102240;
        Thu, 9 Sep 2021 17:41:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3axst5sdxj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqSuUPAMF03xBVVcgtWgpO+P6czptRrUg7ZiQ4FqkYv32IFEtXFAevEVTsDdY0duMUBSR6eVa1EI4UQ3IfuZC7lO7X6BnElgZFhz7srMJMAaKH/mSjkityKOnv5hcJ5IQAlPkxOJBf7iRP8H7f/SUAIGPlhT73C1NTAQ7Kvwlpqbcrz0J92jZaiuSw977y7CgFERdoIjotwJ6ioSrjYLsd1sJeO/Eu58LLAR5xlTKkmCSca5whxP4mg6LSDzYM0opwBT5/lMLPL1t8UoIIzGB6gkaxANmI0d9ZNPrDd840HjJwnq3XF3Y6JCp1dLC0Av51eB9XjuWI9ITgqpG0rY7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mTlIcwtBpMyJww31eheea88S6OPEz1/i7BchCMUGOuc=;
 b=fru5RLy8HB484actu7g8NoujYMW+pT+u5hXS1YN+TmgnOF53q9Rnck1EpH6vrwTJMSRYymrrFzwB76Uur8jBYQJj5FXljIXFJ1eoWFM9foDQcfMH86RMidYWzlg4IhMGgoAFR30h1uV8QpbwCn7w9+prp+FsHn0Q3hMLtNgrNhW+o5llEN2LtIKsfBlyvK8ltj1fdyh9+s0ghSLrzerCgjFX3dnxTZWsb1aRJEQ2uc7M+ias8YbSs0SC65FCGWX6nZCuzdN3H6ADfPk3YhAXrGqKWEuetCS4W5WAmahgh9I1zRs1SudPHGnPg8jJF/c9GLwQtk1zQacg5Y8O1CkPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTlIcwtBpMyJww31eheea88S6OPEz1/i7BchCMUGOuc=;
 b=BMA6yxwSGsnrdQz5riRenAI2cR64uyra7JwpD6XA3j4s7Alg4eZqXp+i99LyJX2NC2wE0gBhJbrfNf9bp1LGv/OAGAmMKfJjXs+ss4prjEpFW/mb8hoqmS+8vf0llYw+SYVvUz2Q+CH4Lxe4PEd4fY5sW5vKRP3d1M6v6E7dZuQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16)
 by BY5PR10MB4321.namprd10.prod.outlook.com (2603:10b6:a03:202::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 9 Sep
 2021 17:41:51 +0000
Received: from BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64]) by BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64%3]) with mapi id 15.20.4500.017; Thu, 9 Sep 2021
 17:41:51 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 1/3] xfstests: Rename _scratch_inject_logprint to _scratch_remount_dump_log
Date:   Thu,  9 Sep 2021 17:41:40 +0000
Message-Id: <20210909174142.357719-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210909174142.357719-1-catherine.hoang@oracle.com>
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0349.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::24) To BYAPR10MB2791.namprd10.prod.outlook.com
 (2603:10b6:a03:83::16)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL1PR13CA0349.namprd13.prod.outlook.com (2603:10b6:208:2c6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Thu, 9 Sep 2021 17:41:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea4fea95-3b7d-405c-3a6f-08d973b91b46
X-MS-TrafficTypeDiagnostic: BY5PR10MB4321:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43218FA0E13B05AB176A55C989D59@BY5PR10MB4321.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6ZY6r+WjTmIcuuv0QPJSi9Jc60RdynDscAse5PeZ4+M7vpQeCzTnUZITG4+vzPjGabxDQBS6wzmD5vX1oZ6Cn4oGxMZooPUTfCqBz1Ym1pskgZDef0p9d76NoHjXQ02AHaqVieDtRDSkMpbL9cMO69MLpqQ5q4jWM58GLv1RrtPHwmDZY5UmQceQldBIXNaiw/5qjrO7l67wHdOe0Jox/xAjnRNeT37I2vLo86M0ZFEjXuidD/tPRMmh7BbfBwbBYNGUxUjB554vd8ogRy1pX03gKh2l+rT01xEJoHmJ7YoULQuABVkt0MmX3viHGCE5MfwUGGWpunvK1gd5mobVKhDbqyZpkIyi1Z0JUWD3zhAaZBPYqWPcTAW9ftyTSNZHjLSPYBel6Joeldn5WmEl/Q5TDM+fgfZpsfaYSYIQUtz8dO5I8af7tlIhTil6cEcn3CynAdlm81L0Z5pGu8rRx9udNXmv9/VsOQsf9Cy4dWQAE4DS87xyEgAUcrXu33LXJwXRX6nFJZmiats5J1n/adU1WGwpuhd5Z5aUwMf6m8VbyQ1nokTR8zgCsfD05dGpGYFtUYJV1ZF4QoIiNVb+nz4skGGb4MqpsR9Cdd4IshnqmwfLUxusFIQ7CRl8zRTes+cvCZL4tXyXrYJ2wVzIYf1qbXKuTK3A7XfvPTDAE90960TGk0Is1AaFhY2/9sMwGO59lwy3U1tRVmKTNlBXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2791.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(956004)(38100700002)(86362001)(38350700002)(2616005)(6506007)(44832011)(316002)(2906002)(26005)(66556008)(83380400001)(8936002)(6666004)(508600001)(186003)(8676002)(6512007)(1076003)(66476007)(450100002)(52116002)(36756003)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EN+9N8sZGGrWfmHrw6vl9VXTKHy93+WczvFqtR+8Hg7FI4h4Bd8LSQ0za4ga?=
 =?us-ascii?Q?gS1Ev3lA9qVfbYvJoK4vg3I+h/xeLjTm4XUDA0Q7G8lDCYB5DBmiL8mW6kes?=
 =?us-ascii?Q?CCGeaJVfnxtojWOfXgbrHzJ5FE4nZARQ3eDa6k+MCDGWMaPzCO4dE7x9eJiS?=
 =?us-ascii?Q?353GAulSRq4np6hATK0FZ5AfO+S0K5OKvZrx5l1jrfG1NQK2l1qscdLfN0Ys?=
 =?us-ascii?Q?74+3r8j1f2LyJiYb+L9JRE7O2UeTexAAPSao2ecK5w1FZrvoK8C4nfX7E7cK?=
 =?us-ascii?Q?F87zNqgiKMoD/KjWqAOM03k7mBEoiLMQ8oNdWUZYKyM7r5nS+hNDjyta+lGF?=
 =?us-ascii?Q?xfl3+/xgFW8fYIf7UBuT55Cgm3al+CJ5jqUpqe3TYfDSkIZYl5fc6+BH1MMS?=
 =?us-ascii?Q?eGCNYSJOKBIpSS7LneR5RWd6HqgGwJR7z0Jdr91QCEnMO26gTMj7NFATlUSz?=
 =?us-ascii?Q?z9Xy4vVxYRcVJ6LuzCR9d1s457aohqtT7aXqOqIdy7+1VmZQNjRnGMrvZuUA?=
 =?us-ascii?Q?0S7MVSFcmTopoTvKD98a3WG2L3vrfu/f9uYfoPscy+q1C6Yrs0ndUOwxEDR7?=
 =?us-ascii?Q?E+hxLkLK/Sii3MD/97vUwa0wznbojaoHxN/7THNPuE+gYd7jY6IbXIskDY3G?=
 =?us-ascii?Q?L8JAAuQ+QFLBwWYV+vpC586eEfYyiVSy9Fc38uAe4rE4ItgYafGSOhZ0m/+I?=
 =?us-ascii?Q?QUSEQmugYgnF5GVGUFILrY+t2F0vwMmzaE1ZwpFEc+3KmVQeJDTeZifsXPK3?=
 =?us-ascii?Q?c0M0hfBCzvcHjQG0on/CrnVHmBnfCIQlmyNsL0S/U8BehzHkVqWgv1w4GjSt?=
 =?us-ascii?Q?YB4BWb/ohPh+Y+YsvP847NATDvk7ikPFAZw6oHBXN5V0UrKrMnfSuHkRVBL4?=
 =?us-ascii?Q?u/2Pyue2ZtAbs1WSrYbs97EEDsti7PGNc4SKoLAJgiiHkd2MwPTDu+tkXy6L?=
 =?us-ascii?Q?uSbQ2FwvGF29T6BaD9eX/w6UmTMRhK2R1ETmrrqOLWVpaWhIrtJigH8hwbsK?=
 =?us-ascii?Q?NYQYa+UXms6darlbSlgKwQ19vPpU6VJSxsB6I+Y7vAcUv5bxMMeA9WLgpvQs?=
 =?us-ascii?Q?Mo0rcx0nE5+yTOQrGmLVzFtaxp8y/DL3kl/qA/1UQdDXX1ZEOLrpFiXbRVfg?=
 =?us-ascii?Q?HkxAG1WVtOOEc4QJxnYHk1nbVHZG8++vGC1/MVr6zmcYkvAV97u7DEk84Ai9?=
 =?us-ascii?Q?ix6WF5sSBMdnBVuH3s/MLuysfbNv7fFlC0E4U9FP4+h4EADVMBArIXLmjyS8?=
 =?us-ascii?Q?GjmlTwTKKT4tpjsdDHGndRJMX5TulmLM+EN+5aVqV66HuJp8qlL0/Keo5ubY?=
 =?us-ascii?Q?i+HgLdNY3ff7vlyHLpk8BDui?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4fea95-3b7d-405c-3a6f-08d973b91b46
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2791.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 17:41:51.4576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Du86DIYTWRP+o0IX/8ErQMKc3zsYJQLy4HgFmIIlqD0RonYtwCmox644GD36lln/ZHWIfiRg0PnRkj2X/c0wLDNVRq9n4Qq3535n8+sWN1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4321
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090107
X-Proofpoint-ORIG-GUID: g7DgtlLoAd8yzEpOD2p0lIpfCkQ_uIq_
X-Proofpoint-GUID: g7DgtlLoAd8yzEpOD2p0lIpfCkQ_uIq_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename _scratch_inject_logprint to _scratch_remount_dump_log to better
describe what this function does. _scratch_remount_dump_log unmounts
and remounts the scratch device, dumping the log.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
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

