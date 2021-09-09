Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16ACC4167D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E02061104
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 17:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242122AbhIIRnX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 13:43:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27506 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242709AbhIIRnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 13:43:06 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189G53nx010988;
        Thu, 9 Sep 2021 17:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=HIO/jFq5tYVUzGBLJznMEzYsruPb2F9wV4IiIv0R0Ao=;
 b=nACBPROs557amhMi7qrzzHzkgVGEnza67f4eT590mtTJHTUrRaj12QTYN7Xr72k7Jprg
 TdrW/ZqmKDf2erLwd7TlN5rO8UyqNQ3uQfr1fozJprFo3jVSZqC5Szo5OXRctBWFZ8DI
 y/Yc0EMCegh/+NMYp8DYqJ3m+9lrq8WgfdaVG2l8MwyPJRdeoufE+INg/MNgENDdkRHy
 KsevqbUKq27RPtwkAtR0SEGgd55WcbXyu+v0KP+amlJBw+/9Don1o+ieTUhVTYkVDe+/
 fTBWF1cWq11kqgbDOfzp/soqTVpRsrR1aamLcWlVTjEGUnzjvNCBO0MBrt1gJOQPFgnw 5Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=HIO/jFq5tYVUzGBLJznMEzYsruPb2F9wV4IiIv0R0Ao=;
 b=Ai5Yv7z0Juy8CvMW+jtM0RoeMHFraQJslPMAOuGSi9keMLbqfFRnNTvdDYRG8fsxc3aY
 x6z9ZDalWNm8aGQDg0acVg5CAy1zLhWql3sXpF5Y/RKzYCoho7QJLKyM9uBVN3GaCkX1
 4oDljyjK44OrWlt+KSQVYeMQKI5JH2tvGkuhRajjAvg2xxRoYGD75dj6+B7/InoUnCFT
 N8CYQRvQe+8ystJTrOq44yc8pGkOVicxzuJrEs0tDSEKt2tmcoX1mezl/F7TOwaEOYGl
 qYpfX7FC8mSvL3w4MrFX/yvdL+nrkpYgwalK7HHjKYV2k/JSra741ssA7BfS9+N/qTLz Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ayfrpsd4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189HQGZ5172333;
        Thu, 9 Sep 2021 17:41:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3030.oracle.com with ESMTP id 3axcpqj267-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 17:41:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0bnCQHCg1VTtSkFEiffIUgZug/tyYPzQfrP1koYyWyTzgKxmjWNn3GpO+Lnzah2uwqRetlklqBmyx65riTJ3iwtJPeptsySM8Th9VW0FYzvQgq6Hlp0LEsgldqgg6kHeuUv75LZMHgvzAHU8tV0d9caosB0RIzxcuh91nXmFwT3ZmqWILPid+UUAeNjQsIp7goXfFzZDqFJQGU2FHnWVfL5Q9OVx5Z5cnNAZxuXGDUCKxiHDF9LENt+kRigcf5VS7kLFmzllr6YV1ySmUtP229Haf6DXwFlC/dO6qDgdMwfM2LsSi2JQ5t9t7aY218hUCaUmo5p7RXMEcqPfPPRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HIO/jFq5tYVUzGBLJznMEzYsruPb2F9wV4IiIv0R0Ao=;
 b=JAiM6Qsp29tapz+bu338UKR7Nv3WuLJf1lNfw/FFpKZF+Kd4niaDadV4VCVYDdNzq3IL4JQ1IPbuEo/OBWDY7y0/YdW4G6uzXAaVw6T718j/aUdFK3RDFLb03mTYPWClffjlwva71L2WhABrxt1A3nD3TUekHQHyw6LP8l7zKyRO4VIaJnN1mcwUya5KwyMpUjMijFi+Ygd8DMyO2Nr7jc3wWpDDTqqXx7Fjqnyz5sDBz7ztVXSJJekfiPxaEVrTC5S+lxb9jTiuGXAd3n5pBOQ1YzADd6xajH3pb00oUNsxFHl09iigs63arvmX37oAMMtGaEofNxLYBjHCXZCEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIO/jFq5tYVUzGBLJznMEzYsruPb2F9wV4IiIv0R0Ao=;
 b=DI+c2Iahj8Tw58SekbR3NYfm43+rkkY7rJD8oEnZNCYTXk4sz1lLUT+1BPbScb7O3Iepa4PKj/7Azy5EXo69T2Vq5eBx7wSU5ciYiS7qcuv/bif7106udPOuE+MzPVKcqjnkxC44lN00FNWlVGtW4jzo3aEhm0kpcZMGBf8pNFo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16)
 by BY5PR10MB4321.namprd10.prod.outlook.com (2603:10b6:a03:202::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 9 Sep
 2021 17:41:52 +0000
Received: from BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64]) by BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::4cf6:23af:2f90:3e64%3]) with mapi id 15.20.4500.017; Thu, 9 Sep 2021
 17:41:52 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 3/3] xfstests: Move *_dump_log routines to common/xfs
Date:   Thu,  9 Sep 2021 17:41:42 +0000
Message-Id: <20210909174142.357719-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210909174142.357719-1-catherine.hoang@oracle.com>
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0349.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::24) To BYAPR10MB2791.namprd10.prod.outlook.com
 (2603:10b6:a03:83::16)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL1PR13CA0349.namprd13.prod.outlook.com (2603:10b6:208:2c6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Thu, 9 Sep 2021 17:41:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffa07cb4-462e-4b38-e79f-08d973b91c07
X-MS-TrafficTypeDiagnostic: BY5PR10MB4321:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43214C32E64E29F20EC50E8D89D59@BY5PR10MB4321.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IeghJq1Aep2jLRCDZ90/intsaQa1yrDpa1fhq+P7Zr1/OmXgegL4RNoYOqNKgCOuiieDMX/9lRqF37NFZAgzxx1xVbGlTx9IcCxhC9NlGPuX8zZx3mLAneg1NkrG/fqeMgcFdnQ+tlBFiQscdYS44LtrIc6tvOopsz8LQeWfx7BIxsY8gzUoPzNsoNmQjYFpUfCpfX/b5hY7lWrLJvwXEFnvxBpTyiZ0YbGlRrcs4ubmy2losMRFcKvqjQtMHyN0iokS9lWpEuTaJylTpD/NF7ZjQxt6Q2sBkKKrIJGmM7w8OCEZIdFwk4MwSeUCObaI3zqRyNew3J2Py5X8LaQFOgM9oHgnBN00hscQGDEsW+VY+HY3vjkhSn6cteu9LPCIpOHws189qZ+mFFt/qtHAxNDrAstOKMqtc4fChMCfzpybedh4BACypPNmxuJFTe7hGVtCMjG2PInF0ZGeFfr16ZWwT1OvJPXksx8+sKkX1NOgK6FIOVJCyZzJ9f/k8oOUr3lhZTZZBf53fpiqxYU+kw3cvFfC4MFn0HZK+qF0qhcYcflRNh5zFFPYx5E4wzF02KY7k/jsLtMSQeMiZbon5ADfcpO99Hm/uLAUS9exRyPbv9Tc4mvUqsvGHRQG0aWULNJIgd9RriGMnd5J+PCYrvIqbhI+FX612cN8I5iHckzg5fL9p9vknuAXgvvTIRIfwzRcfSX8C1quXYqhTyo9dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2791.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(956004)(38100700002)(86362001)(38350700002)(2616005)(6506007)(44832011)(316002)(2906002)(26005)(66556008)(83380400001)(8936002)(6666004)(508600001)(186003)(8676002)(6512007)(1076003)(66476007)(450100002)(52116002)(36756003)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?akkUvuh1/bE9YndcVe+ue8dLnYZGsqcfN6c2yYUJQ9kwuUqXE58E9tKR+9k5?=
 =?us-ascii?Q?jHd6Gb0NWTWU0vp61sJXK2EFFT1Ne/1+dNuvC15XdMS7tsIfdOqeaC0mWLr9?=
 =?us-ascii?Q?9aXa+Yuec3L+6SwcO9dj4rjtf/CUoHGiNCDgNHT2EYrCGGzAkadq+OvL4RYk?=
 =?us-ascii?Q?kC2uXiLXb9fhP0DB8eTELDi2V1q4s/4U1OeQSg970Ei2JbT1iJ6zEGqarTrl?=
 =?us-ascii?Q?s9F02nnEtK/u5Au7tJQBW8wDWwV8g0EwxoUtrW0QGKpNKD4hP3FtHeVtJsVm?=
 =?us-ascii?Q?QEMWvtW0afdhgZOdwe/S92ObiHtOssAKtYM8skmXsr9mtJD1My+hwl79XoFG?=
 =?us-ascii?Q?0mF+toEXqJNkMME/clKPYI+EcpH5mh4GT1B79DH6WLNZ3caKoxzoAiVI1EoN?=
 =?us-ascii?Q?IutO51rAGLjvM5FeE8YnDQkhnnpa20+b3OKui05bqE5hYAbBoRj709HzMfXY?=
 =?us-ascii?Q?4Ox0ZB4owgmmJ8uBF3icgZVacxqD/x0Gu3mJKn+I2exYtK9zcy8rN2M0FHDr?=
 =?us-ascii?Q?bgf0l0FIH446mh1M9PuK7tcd7lTDTCVr7BFtpJND8ICGttp0r8XchIJ0QO8k?=
 =?us-ascii?Q?WB+sQzc71Mv/KeojjapezZ44nLYdwBRZHAhhj14WQYGWMJsJn76HrS8ROnQe?=
 =?us-ascii?Q?OEQUj5/M8QxtbIYyIOzYgvQoLuHa4AQoRO+BfaAwkVO2UzfN5Tyy93IyFlM0?=
 =?us-ascii?Q?aidcoz6AhbrqDkEzRrha7i0Sk4HW/MGySWa5mXvyO1HZksFW5HfQ6TqPmGc0?=
 =?us-ascii?Q?FTvDt/VxDpAD5MAg454KxUxSvN8jzlbPQR59M3raZTKv3s7T9AUNQqMz9PbR?=
 =?us-ascii?Q?TgKTUok5a6sHWYYXNnbxmZzoetzRIvzBb5cZiyKDSbc01CkuqGrbnEQtVAvg?=
 =?us-ascii?Q?Hfe6bDhRUkbU1DDriymbdFHTm+7tgcNKE/8VBkGOvGVNHm/5O4qu2/W4eIOs?=
 =?us-ascii?Q?lqePjxZExfLkrHnwx7TlfoVPvyg29USZPviDGwln9WDKscJ7qVByyVygoooG?=
 =?us-ascii?Q?u09An2K8HjTWPNBG4y6Awa6Yy9rq37zhv1E0NQ1sfpGLhHBnXa/f2LbmAXv+?=
 =?us-ascii?Q?aVdvBwSkNIfXcJu6M4cpND1fQ7jZAYhOv1D2DSd+YgijsEloFeoJHBQhvJ1A?=
 =?us-ascii?Q?RwXglnZuQLmrXgID7AlxdpQUHLcH74XZlugDbGtPl50hIc789omt5ES4YIjL?=
 =?us-ascii?Q?JongCQqlZH6PqxVmTVK3S6Nuvl2CMJXL3tAwm9JeSZq2DQyLDHkrOZ39GiXw?=
 =?us-ascii?Q?KGbBFrhtl2qoFeb8VQ++dbBkEofGwdnd39fJ7u7ZbFe/BRk9e+SgAmL4wFer?=
 =?us-ascii?Q?jaLX7i9oUbJ9p92lIYnL5kma?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa07cb4-462e-4b38-e79f-08d973b91c07
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2791.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 17:41:52.6839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: keCaiJUH06K2frCW99Mol8gQeivLMlN3cA2QveZOubmT5DHt6X8BKMeoWU5Azi+ovowR2SIBfb56C8NwhlEHrMrmaKZ19rZqg8jmo+evRPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4321
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10102 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090107
X-Proofpoint-GUID: U3Zgt4wTbe6nRG6hTtBP_KDGIgQokfUj
X-Proofpoint-ORIG-GUID: U3Zgt4wTbe6nRG6hTtBP_KDGIgQokfUj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move _scratch_remount_dump_log and _test_remount_dump_log from
common/inject to common/xfs. These routines do not inject errors and
should be placed with other xfs common functions.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/inject | 26 --------------------------
 common/xfs    | 26 ++++++++++++++++++++++++++
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
diff --git a/common/xfs b/common/xfs
index bfb1bf1e..cda1f768 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1263,3 +1263,29 @@ _require_scratch_xfs_bigtime()
 		_notrun "bigtime feature not advertised on mount?"
 	_scratch_unmount
 }
+
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
-- 
2.25.1

