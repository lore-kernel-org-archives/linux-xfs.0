Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43839C4320E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 22:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 272EB610A2
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 22:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344607AbhIAWLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 18:11:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44686 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344881AbhIAWL3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 18:11:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 181M6kBT004466;
        Wed, 1 Sep 2021 22:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=1/QxVcyJIVFvXXdx6X7zm9muhzXK0zjb86ie4vZksuw=;
 b=woussWWwXN+zTXq0Z4apjZce3ytEK9rGvtb8at/aSuFTj3HszxxyAk2EE2vgBpGKqt0j
 AUCn0uPPqDBnYWTdEnrNPF+eNBiIei9b8piXwC1aPhUqGy5rCZHMzlcnS5vBpvXX+ZgZ
 V13tQ9Gp1vK7VYz4KPrZ1vkX9YFiTqsvhVW0nqrlmOxEY3NgjCL3jKhPZvnhbib7yCn8
 r6nlDEcl3gIeBiFjyGrhGic1ymaybVcAtiMV6phag2GUWBQFoYuKN8EXWtmACl63tcm2
 dRPO+Y9smjyx3DohhgIS9BLM+OB9OlhXQrZHBq519TA7+Pfo0F+z/zkwt0SriFmkDQ9M Tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=1/QxVcyJIVFvXXdx6X7zm9muhzXK0zjb86ie4vZksuw=;
 b=XnGaorz/Bhda/aeBaTISPNZUjxbwo4YJWv6Nmusqlm32IEcqeda1Zpd9xOYq28HSTBud
 Y1oSjnAMSOGiEvgsE9XLcf6Gc2pUUETrKjy6l1hhJPt1hKbhESW4HRRtzfn6OaJdsMcs
 /FKnVBRWp62r2BGmZ1kir3tDbAlPKpqr7p8WUna5aFdPONthSgy4l1BoIRM10WaTnZmN
 GlEd+AtLDUaVbGrdkOQZZCPUzhbYXHRyjWQj9SGol3HMOJ0EjlBxvPLZVpr0PDUtaCSZ
 /jID/Le4HA+l3ztFdEGxUst6B2IBTfj6Rpy+DMK06/PnVkOQOCYs2syu1sOqOw2yde65 MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw18q79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 22:10:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 181MAS1H044096;
        Wed, 1 Sep 2021 22:10:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3ate04u7q9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 22:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIXh4fGeDSVLboukIgPd6GFE6DRG2rEIZQrNwNXZpYyCoN8gXeFvN8xs0PdVhr6OUbWnmN3NMzWvOh+6WxkDfO7zHMBeo/y+KGQiEsjrNfY1henCT90X9sRwoXo7X3+MWX+/v09/DkdAv0i8EXLMRqPNsMmRZVKx2nKPIb+WPOhoJSOh4sWMS7P1hyzAYQPjRA/8pFmUoTLhFT5yJV8A5qNQ1PzMBBVrZUxqjGgWLYgtu+jIf8lgkUF1R+aVFmnWokoaQVJRmENt72zx0DjbMYpH8iHSJAiryK8GOo6rk1+TJpoXlgWjerCpF7tmp3w0tJU1mipQjJT35guhEXlA1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1/QxVcyJIVFvXXdx6X7zm9muhzXK0zjb86ie4vZksuw=;
 b=izak2vZhiwVpEXyysveNLXWS68Y+ndpV2pSOZgC55rQ0ZcBDVqzE7/PyIvQXQy0lAGw2A0nvaUAsBhbkU8HyaT28ZQj0ZPm1Jo3kAjHgXD3FChpQ/oCrr2qeiQeOiGixTXBLftRx/ecqJGKnqqsgKXFHyFWHRd79GTf4AeEwlRUlJIYX7oMnRDYgkBghqBEY31Tx7He907ABReZmisgDeMF6CtU/WauEIXpBNpAeM3+X7OetlKntXOEE4Xib38UkCYTzXYlix7dbgT8zuO2sCyCHkeu7MBPzH22IH6L2nebjmZsdh1mrrBZX6lOoCXjRtL7SLM0b6WuewWLh1abc2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/QxVcyJIVFvXXdx6X7zm9muhzXK0zjb86ie4vZksuw=;
 b=psIHIxmEuUdjUJOJi00+dwJcmB8u4JSew9dWyiDQXGQvP45qt44CaPfQHWShZBvSvB2kS+fKgCg3lAiZaR3QwKxAbew5UdMcMbSxar2hT3OVo705Q4F3i2Vz17ZfY7XjIFPHeTuX3OU1WvGQODji5clOf1LB4woys+o8eCrCGRc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB3211.namprd10.prod.outlook.com (2603:10b6:5:1a6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.17; Wed, 1 Sep 2021 22:10:14 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4457.024; Wed, 1 Sep 2021
 22:10:14 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 1/1] xfstests: Add Log Attribute Replay test
Date:   Wed,  1 Sep 2021 22:10:06 +0000
Message-Id: <20210901221006.125888-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210901221006.125888-1-catherine.hoang@oracle.com>
References: <20210901221006.125888-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0069.namprd11.prod.outlook.com
 (2603:10b6:806:d2::14) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by SA0PR11CA0069.namprd11.prod.outlook.com (2603:10b6:806:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 22:10:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a10362c9-0760-42c2-24cb-08d96d954618
X-MS-TrafficTypeDiagnostic: DM6PR10MB3211:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3211F10DD7E27F3601F23D2189CD9@DM6PR10MB3211.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDfvluDXHnVdEotTMg46F/9GOonkVXUHy7PWFGp6u0MDoeyOVliZr2kVPwBWWY0r7Z+WkNwwE4Ym0yAXi6ImeN2fdvjAY49E99l4NAgqr4xWU6vS898wsf0sSaASWqMaYAk8HXz0hTr19N+xuwdkqCn42haH/cHHIzlba3ajpy4LFJ4xOxdW7kye0hs6gQiuJev6Ur4ooGfRL9arlOjz/7PhdES79yR40z00qMUdKijUHTK7rNq5NRGL7QmilFzP5Ndatf2MHC96ybSPUbycL4p9nQM2jgMynayCdT2gP+mhs5jO79riyLXqrqPzXHVt/98ZOhV41dhaUgeesANjd0zgD3oyNTnA++1IUBQ2xBfpBSgJYDkIlJu2Dbrm7Pbglt16THzMtrogVSyMxu7xkIeVPUpqwmfN1+vKPQKliPtwRSM29IC/y3nyawInMCoPOSL71ie+JUbcxb66Y4dv23f1Hi9laJi25E6f7VRYxFZ8O5lVoEzVxuFXU+LRvlsqfZFcS+zfQljYdefPHFyMxcW2PWSfS8Gpm5zNVvdv/inFcgUyTm3aPPLG3J1LN1qSPFT9MFoK8pB+WkDbqI8eQBk8N+hxLRH2mI8BNWIPHhX4/pL9MirHOfJW9fH3/k9hL/LZN1u7voY2fJjz1m8qLJQrZKtFQWqrEu4CGNS9IImg1/DECZTF4BZTgvt2SLUtLeTx3JpacN69vDW3CNMXcqU+eE+xODvlygwZ72NhQBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(366004)(39860400002)(346002)(6486002)(956004)(38100700002)(38350700002)(6512007)(44832011)(316002)(2616005)(86362001)(66476007)(83380400001)(5660300002)(478600001)(36756003)(6506007)(6666004)(2906002)(8676002)(66946007)(186003)(26005)(66556008)(450100002)(8936002)(1076003)(52116002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8wRUmxjGvWBx0f0pLSegqZ+fFm/haNI64Hl4KTkfzjJDtuRPcEyteeB81N3v?=
 =?us-ascii?Q?8Z3zDWzRB3Fe6PjS+Ba3tgtIECtlB43P7MndaxVm4WtFCY+regEYLh4Wgu5U?=
 =?us-ascii?Q?xEQS8G5sactldxaEprSobJBpaoOhgNjIossEzvgUynvHxqXB6HeHlsul+97m?=
 =?us-ascii?Q?BvS9TlcMKjn6O5yzvnY5i25w+WuKQjCdRh255e0Pv8xy+lF4vJ9+QjJYkk1g?=
 =?us-ascii?Q?VbVfbSA725ejO9CXuask8AfqeeDdwWC6XlizWGz/qSLBeTRzzgYYO3b0RKXD?=
 =?us-ascii?Q?TDY3CV8o60KNmkX2WZwQ7gP0FKoQ2n8B1yvKm7QcYFOAGckxgMsgU1/SMYCI?=
 =?us-ascii?Q?Fxd5df+3CIMNWpCVU97fnuY/lySgjW0tfBg/GQxQI/lmtXq8m7CtK1VAmcuB?=
 =?us-ascii?Q?gA9NRXx8SvYPYDZVhtUqZ8Vc11VxmFxv168DvWvh1NzcOhBWh6iWxrgv2D/w?=
 =?us-ascii?Q?V5EbFOXPB7UyGiUF4DmK9f7Cb2F1Ei2DGfpRo5jZZc1HtIZGQdqrHcF+KGFP?=
 =?us-ascii?Q?ZERyJC16L/doLZM4nTPOzFC29XoF/atKVsiOnA/p0Fr2IMd10iQmsDOWw1Uk?=
 =?us-ascii?Q?Dx131MK9yBSPuD1cJy2mumt/feuKagEvWvLBeDF8ncjpoCaoZFzNeSbiGIop?=
 =?us-ascii?Q?3ybchjJ1HlMcCiYoR20v3wAlX281s9ai0dF1MxXGGS/8+17YPitpZ6e90FH4?=
 =?us-ascii?Q?4nw0uiXULy+XJzOFVq8ThTh5I3iaU/vY26d3Z6yK72Oh5WWxFqXAmAsGHbKB?=
 =?us-ascii?Q?6X6hPSl1u87P+GVLQ3JlMu45M+ZqD+wHN7mHnE7b51emLwTvvLG+0cn5seOp?=
 =?us-ascii?Q?pbKxERr+gtVFhI8kvRF3Lqsfdj9Fh6MqsXY7RW+38cAJAr82bFtz9+g3DQdP?=
 =?us-ascii?Q?tt2b4NM/rh0/P9qWg+an74mg41lkyAbjIJcpFn25WZLzOHuFuETnqW5LQl5I?=
 =?us-ascii?Q?IL4iLZ4EYQavm/G7d0o8hKeiKsrjLgIGjl4wSdQd7TAI5DncBf4lCiayoBMn?=
 =?us-ascii?Q?94Z2LNLoQ2wU3JrTllGAEkRQ7nd8Z3y0B9kU8xcRMxyo7oEY+qVB3ji3Iu9l?=
 =?us-ascii?Q?yrjembG+uNGOTkssTRCVqTQi3/GYoFs2xz2NHzJmdg7ahlhb4mawyjg9ZHaq?=
 =?us-ascii?Q?+NLZiMJ9eLB10o90FrgRAzgsYncy2FaifJTnYzSvJK1jJwTXTGYHAZdNULKA?=
 =?us-ascii?Q?tAZ+XnvL5pLhVF+Rg7GHfpIem2un/o5CSgTVOvYQGPAb15iVztXTuPLngIt+?=
 =?us-ascii?Q?uZ8xdf5UveEgyv99WcWw+YQvqy3PpLAlrptbEAk0J+7VsfQwEps9+Kt13nID?=
 =?us-ascii?Q?/gB+Po1KvDjh+L9U5YRsnf2M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a10362c9-0760-42c2-24cb-08d96d954618
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 22:10:14.4687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/VrUvs5HlhgeTLxpfAQc09F9ZV7I+XrF2/Ml97ze3D++1HAGd05wLr2h2SvS08NCm097RO0kU+sxt03andbfD5nd7jxHH/ixPqRQ8AOQSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3211
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109010130
X-Proofpoint-GUID: FQdbybkcVU_5s_i4cAkjJfS6yiir99rj
X-Proofpoint-ORIG-GUID: FQdbybkcVU_5s_i4cAkjJfS6yiir99rj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a test to exercise the log attribute error
inject and log replay.  Attributes are added in increaseing
sizes up to 64k, and the error inject is used to replay them
from the log

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
V2: Updated attr sizes
   Added attr16k test
   Removed rm -f $seqres.full
   Added filtering for SCRATCH_MNT
---
 tests/xfs/540     | 101 ++++++++++++++++++++++++++++
 tests/xfs/540.out | 168 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 269 insertions(+)
 create mode 100755 tests/xfs/540
 create mode 100755 tests/xfs/540.out

diff --git a/tests/xfs/540 b/tests/xfs/540
new file mode 100755
index 00000000..b2fdc153
--- /dev/null
+++ b/tests/xfs/540
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 540
+#
+# Log attribute replay test
+#
+. ./common/preamble
+_begin_fstest auto quick attr
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/attr
+. ./common/inject
+
+_cleanup()
+{
+	echo "*** unmount"
+	_scratch_unmount 2>/dev/null
+	rm -f $tmp.*
+	echo 0 > /sys/fs/xfs/debug/larp
+}
+
+_test_attr_replay()
+{
+	attr_name=$1
+	attr_value=$2
+	touch $testfile.1
+
+	echo "Inject error"
+	_scratch_inject_error "larp"
+
+	echo "Set attribute"
+	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 2>&1 | \
+			    _filter_scratch
+
+	echo "FS should be shut down, touch will fail"
+	touch $testfile.1 2>&1 | _filter_scratch
+
+	echo "Remount to replay log"
+	_scratch_inject_logprint >> $seqres.full
+
+	echo "FS should be online, touch should succeed"
+	touch $testfile.1
+
+	echo "Verify attr recovery"
+	_getfattr --absolute-names $testfile.1 | _filter_scratch
+	$ATTR_PROG -g $attr_name $testfile.1 | md5sum
+
+	echo ""
+}
+
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch
+_require_attrs
+_require_xfs_io_error_injection "larp"
+_require_xfs_sysfs debug/larp
+
+# turn on log attributes
+echo 1 > /sys/fs/xfs/debug/larp
+
+_scratch_unmount >/dev/null 2>&1
+
+#attributes of increaseing sizes
+attr16="0123456789ABCDEF"
+attr64="$attr16$attr16$attr16$attr16"
+attr256="$attr64$attr64$attr64$attr64"
+attr1k="$attr256$attr256$attr256$attr256"
+attr4k="$attr1k$attr1k$attr1k$attr1k"
+attr8k="$attr4k$attr4k"
+attr16k="$attr8k$attr8k"
+attr32k="$attr16k$attr16k"
+attr64k="$attr32k$attr32k"
+
+echo "*** mkfs"
+_scratch_mkfs_xfs >/dev/null
+
+echo "*** mount FS"
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+echo "*** make test file 1"
+
+_test_attr_replay "attr_name1" $attr16
+_test_attr_replay "attr_name2" $attr64
+_test_attr_replay "attr_name3" $attr256
+_test_attr_replay "attr_name4" $attr1k
+_test_attr_replay "attr_name5" $attr4k
+_test_attr_replay "attr_name6" $attr8k
+_test_attr_replay "attr_name7" $attr16k
+_test_attr_replay "attr_name8" $attr32k
+_test_attr_replay "attr_name9" $attr64k
+
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/540.out b/tests/xfs/540.out
new file mode 100755
index 00000000..e5f39ccf
--- /dev/null
+++ b/tests/xfs/540.out
@@ -0,0 +1,168 @@
+QA output created by 540
+*** mkfs
+*** mount FS
+*** make test file 1
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name1" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+
+5a5e91e29ed5e8aa7a30547754b9e1ee  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+
+1d61ccb38292dc01ebe9ea93bbd2564f  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name3" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+
+f513471cb87436a3df3fb930d5babb9f  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name4" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+
+0bc08fada39bf76dc83c856ee2a7d7d5  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name5" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+
+258b2457eed1ce94e61168c734948198  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name6" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+
+507b6ac60f89d347160ddc1be73193ad  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name7" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+user.attr_name7
+
+a856751ea45e3c121b7b4f1fa423defc  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name8" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+user.attr_name7
+user.attr_name8
+
+150bffbd81292b5f239923f6a54c0c1a  -
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name9" for SCRATCH_MNT/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+user.attr_name7
+user.attr_name8
+user.attr_name9
+
+29133253befceb131c3b736f2687cff9  -
+
+*** done
+*** unmount
-- 
2.25.1

