Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9DDC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Feb 2022 03:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiBWDic (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236985AbiBWDib (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 22:38:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AF43983B;
        Tue, 22 Feb 2022 19:38:03 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MMkBwj000678;
        Wed, 23 Feb 2022 03:38:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=t4GYe24hxVlrK2l5RtET00kJYA4yje7EJhGTvMv8gBM=;
 b=lHSfOo712/0Bfg21Qnwy63KuYxXdUxhcz5sgVbiFHgaHv0T1i8rCkqx0U7CEACnwpxbR
 rK7KKdmhPLZ8nMId3VYGnLOrS70VTqGIgMKmEhuuv+KxLrTE+4GUMz5w3Oq9cMym0F9W
 LaDElb6Y71NH5a5Z152potiUAy2NmSL3EskbJkBpnJ03OWu+S8LojFdXBW7Gbuh2aV7n
 dWZaLQ+OLgrZP4rPsfIkTKhkTvAwkmKcYpv7xO90YGbfmUiPfXEqQlqbJ+IiWh/lNiKL
 gpPNhOklMBf/HVhkF9ZMN8nBIUXzi5/npXTxdW4vGWpgNIU/HtQCH8VJoS7x2cDJ46JG 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfat8b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:38:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N3V1VR160907;
        Wed, 23 Feb 2022 03:38:01 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by userp3020.oracle.com with ESMTP id 3eat0nvfss-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kf4CNcMLYNUAIt7c5Iu0Q3qkV2MlJuJ/eOWLkAgEnVjSdEKHrRPcS0vKUZdX8RS4lAgFZD5JDU0KJKIGv1c+l1MfdG86juBAvQxGVDNVIf4K/+pzBn/BJvFtMHIeDCWvNHKbtQRrT+xly6fOaXMCLiRpS2npNPnZ41uvwUNglRvuzQFl0MGX3uc9NvU+Jdjdqm6tCho8IN/fWPvNyStUK3uJbjl7uFTFxaD8XDSUaBqghbetzO1Q1hySNwSJNwh85y/YLGm42f9mMvIE/8mydovhHYt40NbRxHPwMY5Vbs8LoZLj4eIykSaMv2YLLDwVyD2+HsJQUz/aX/taQvLXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4GYe24hxVlrK2l5RtET00kJYA4yje7EJhGTvMv8gBM=;
 b=eDkiNJqidbiDO9vsYL32VzHDy4gmAD8sK3DT7HtWtVqOOjKS0Me6ywrv1s9byIWGRjssHGuR1hmoSs5Jz7B0u0xzya9WLUN4/Coy4b2/YO2YvugrkpWyfA19irboasdKW1/Fb2yI6vodLdKGrYwX0g8dRGQVZ0GuVVjolEurkarWfK4R45dStvR/QcX4fQcsHkJMUnlomD3UzWoXQtUBKaQfz6586mFmB0Veaf1ymXUvhePsUKGzrY+5EKm1OG4Zi3mYQ0570MIe+vWPzNfoaa+CKXJ23z0LluHpkQCqDVB5ijAlV2T7ceuciFClnan4tNMwElXQcGRdYxHdneiF5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4GYe24hxVlrK2l5RtET00kJYA4yje7EJhGTvMv8gBM=;
 b=VH/2xMPJz4iGqi0TSh5X2xgGHXKMNnc/WnBh1T2H+TCqaUYnQuMcssnxpZD0CE22+BTvKBylwsxlEgeG3A1T6osHd8zdvADVf79ETScPtir9y6azEuj7XBEcDYqiqtj15xuWN+uXAA3K23ACmYzuj1h8VRjHJzm/RnXgXtmGq5g=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BYAPR10MB3432.namprd10.prod.outlook.com (2603:10b6:a03:8e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 03:37:59 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::55de:6c2a:59c8:ed1e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::55de:6c2a:59c8:ed1e%8]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 03:37:59 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v7 1/1] xfstests: Add Log Attribute Replay test
Date:   Wed, 23 Feb 2022 03:37:51 +0000
Message-Id: <20220223033751.97913-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223033751.97913-1-catherine.hoang@oracle.com>
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0011.namprd12.prod.outlook.com
 (2603:10b6:806:6f::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 093135f4-0e87-4b1b-d35e-08d9f67de33e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3432:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB34329A83ED563376B3D53807893C9@BYAPR10MB3432.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYx2iKKDFVOAYxgUvsrBTiSA1hUQAiZV4QdMhb0kExQXa/d7MXkUQYSmWo1rpWig4PgVgOha+oBylTvGDgj8DlxiJAu6QlUiMns/5ofDhTu7K0vjOcI5TZ2AyS8BBhgqQj+h9dAN7l3xSuwvb+hWxJb+6MGLF3JuHaIlzU1RipPrCqCK6t6F9+7i7l4PYgPFFLG9oWCGqw+e3YRnbeRXIHA4XQDklMfMkHpKNwqhuJljW5SFBktB1be5oRN0FcH4y4v/T7Hq+MWlQCTPMioYLIKyQWwkX153zWHatIW4g3CZxjVnt50EXr2m9KhKEXD847lrFrYZvJzVT3ZoC/jCoEng+6Kp5bbMGPGYHlG7lYMbz/fwF05kCSFO5Bgi2SVEWwaoLfnG6xg69jWujuJvUiZJM08o5DG9+ro6P2/2HUn5mClhHN8v8ZxsP8MJi/+akGOm8OXc5LeAc80Y3hJxXfaRzhQ6WWLOhcejh3FIwfUOQxkltsuGYkcFBhukp7lxIzrDatNNAGN//2Ns8AaL7EUEgShMgHaUt0zv2jBztNiXp486Fxr/xUj5rsTqVZobFshVG61IGADzWnLxjdhGbzp/dajihokHfzRJJ4sxhqaLgFCZUlS8iehTKxkx8wVSA1UKbrxcLROEHrf8ZvJoE+KdW5SNqagu9vutatC0wVtbYrXSTgevBUWi/eQY5aCfLu78tVwPt7IhjYY+g5RTwUiwHOIIYijACJQCq5ydI48=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(8936002)(86362001)(6486002)(2906002)(83380400001)(6506007)(30864003)(38350700002)(6666004)(2616005)(6512007)(52116002)(38100700002)(26005)(1076003)(186003)(66476007)(8676002)(5660300002)(450100002)(66556008)(36756003)(316002)(44832011)(66946007)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dGYhAucxH0PQ837tic0NpVw4jDmvWyrA4ekIWhEjNHuYuASB2bDOMEVnAXlX?=
 =?us-ascii?Q?K/pKwXJhG9MLpJOeVsddE9a55ClCuZ1Q2ageXJLZKuZ72ptwBJtEVFYPS5Qb?=
 =?us-ascii?Q?hDc9I/cJcfp2/WJ7wGKxJTFCYOvONJvoYVjJcxZzv3tlCMq6RzHDcLNaHN2V?=
 =?us-ascii?Q?YAPvn3hzC/jvmHwmTdgKqkiUwR/nm7/cEh767qSknYbtiAqhDWFgYlkUZF5E?=
 =?us-ascii?Q?keNp6dqVeQWIlc+f3vmIzh+DLofnoaPvQlGUHuzKC5sA93isitMvRCGUX+P8?=
 =?us-ascii?Q?GV/tU/3cKLt1G6vF09/cwoU/ddz5yXioYUyI4wLHrYdtGN04OqxptZoczXgP?=
 =?us-ascii?Q?9wwGKF++Tdsc2Re+KMr48bvs+XDrpilmTmx0LqayM7IPvgG02sbH4hUw9hjE?=
 =?us-ascii?Q?HGyoIqs7dCJkHPWp0yFgQ9Y+qgeUiKdb/Sv5zfi7DDJ9Q3fEwLreybKZ/MyR?=
 =?us-ascii?Q?Pu0FMVq+H2NTJCXs21auKw7t/I2ljMjf4wZ3M77+LMH7lVqACEcD2l5BlPKN?=
 =?us-ascii?Q?owaZqbMOMT76rw5ACxcZhtYl4t2Dq/f/JnPS+SVRrodWf+XXzGXgJmxCw5ik?=
 =?us-ascii?Q?8ZSbJ8graoDM0D87gvUmniGmwC3Dai2gttj1GC/eGI0e+j1vmhfvrAy8p5tv?=
 =?us-ascii?Q?gHpxERhrD4Sz2CoUJg/gdMlsMbIA4hV4iQW95FjamF+zaSAFfQRtcHb+P6Wx?=
 =?us-ascii?Q?AH8/SBS32VcuXKJ2Bvjr29lXKtDAwa1O9tj/3yselFDmDMp9eP64WQMMJnvh?=
 =?us-ascii?Q?Fq1dEmSgOhFO+u9Y6PhQ2hSh4Au7yiZ18knRaNcTPcUokeJP8fcM5MFc3vhN?=
 =?us-ascii?Q?WRmQBDLbs1YdCaFulGPK6b3ySGnBW7yDMMs8W8P5TsHwV2hs7KZef3jPSZpx?=
 =?us-ascii?Q?1RZCNTC8VZL1GuT+lDnCW0dRui3xiqkWXLAAGfanqrlLSHipUn/lRlu707AL?=
 =?us-ascii?Q?d2jyerj+2TdpHohxf2hqGTJry0gXcefjKAR0vP7W97WHr1Fwc1alxJxi/NdF?=
 =?us-ascii?Q?56y0jI1ZCtazCJk8OY4W0GOx47gQo91RDxYX7JhAqmIL/Do4Q8XmAtgKlh4V?=
 =?us-ascii?Q?JpFvU0IopmZm7QxX3NCP/42UMJtKWefpzHAzxPoTweU1Yu0GsGyO+EhaTk14?=
 =?us-ascii?Q?Bymyk8XerRyxwzkDl9BKNF2t6Ic3YdfLfGGyObxtyl3AGBGUShywg2sVQDY2?=
 =?us-ascii?Q?xwO2CW+JxrbUUE+eRHAuhKeS77W+K9KQjeVOhF33fFMoio0TsVvKq3Osmt5j?=
 =?us-ascii?Q?uhqSfJa2hHRAPB0VoKdAdPI2KsXQGLR9oqGFimIX9YbzhLxlCbn1WO/8USb/?=
 =?us-ascii?Q?LmSictZzn9y5AfnukRfFVMD9NPBCj5xeVsamC+49t4+dE0ZwOVbBWDOGYRll?=
 =?us-ascii?Q?v90X2TItRUR6yTSwGdxdXA9z5j6WGGUXmogPXOXk+6t5pq8FSsYt7uhHq7ZJ?=
 =?us-ascii?Q?qOQUYgkeYAciUEkltvV1MeITIX6l4jotlegAjqzLW0kypuTh4IhGusYe/TGi?=
 =?us-ascii?Q?zcj0TeSHFQFFPJzq6lTqTAguMITNhxIFPwCcXknAsO5FBF4OS5iMWMjGnV2d?=
 =?us-ascii?Q?OSHDJ6r8sBpCy7fUSUFAOEs5oTo2g4nLyQjTDcEF0274T6qxzgcNH0/nNkRi?=
 =?us-ascii?Q?uN2jFOachqoYWNhpL1eFW46bsYTU4++lT6kyqLcoMq8mvyetACqSAHEeh8M2?=
 =?us-ascii?Q?BH7lOA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 093135f4-0e87-4b1b-d35e-08d9f67de33e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 03:37:59.5244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RWTFskQYDYwbtC41NfG4XP9LSoDjLZzor4XgmteYYm321PinvGN/LPoX9eCYRTlPN+ojHHGr3eH6T0J394IyiSYFwNkPDcgpI3lvsK/H3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3432
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230017
X-Proofpoint-GUID: WT9TI_UccFAFHIPTnxNul0aOfWelGlNq
X-Proofpoint-ORIG-GUID: WT9TI_UccFAFHIPTnxNul0aOfWelGlNq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds tests to exercise the log attribute error
inject and log replay. These tests aim to cover cases where attributes
are added, removed, and overwritten in each format (shortform, leaf,
node). Error inject is used to replay these operations from the log.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/543     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/543.out | 149 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 325 insertions(+)
 create mode 100755 tests/xfs/543
 create mode 100644 tests/xfs/543.out

diff --git a/tests/xfs/543 b/tests/xfs/543
new file mode 100755
index 00000000..06f16f21
--- /dev/null
+++ b/tests/xfs/543
@@ -0,0 +1,176 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 543
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
+	rm -rf $tmp.* $testdir
+	test -w /sys/fs/xfs/debug/larp && \
+		echo 0 > /sys/fs/xfs/debug/larp
+}
+
+test_attr_replay()
+{
+	testfile=$testdir/$1
+	attr_name=$2
+	attr_value=$3
+	flag=$4
+	error_tag=$5
+
+	# Inject error
+	_scratch_inject_error $error_tag
+
+	# Set attribute
+	echo "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 | \
+			    _filter_scratch
+
+	# FS should be shut down, touch will fail
+	touch $testfile 2>&1 | _filter_scratch
+
+	# Remount to replay log
+	_scratch_remount_dump_log >> $seqres.full
+
+	# FS should be online, touch should succeed
+	touch $testfile
+
+	# Verify attr recovery
+	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 | _filter_scratch
+
+	echo ""
+}
+
+create_test_file()
+{
+	filename=$testdir/$1
+	count=$2
+	attr_value=$3
+
+	touch $filename
+
+	for i in `seq $count`
+	do
+		$ATTR_PROG -s "attr_name$i" -V $attr_value $filename >> \
+			$seqres.full
+	done
+}
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch
+_require_attrs
+_require_xfs_io_error_injection "larp"
+_require_xfs_io_error_injection "da_leaf_split"
+_require_xfs_io_error_injection "attr_leaf_to_node"
+_require_xfs_sysfs debug/larp
+test -w /sys/fs/xfs/debug/larp || _notrun "larp knob not writable"
+
+# turn on log attributes
+echo 1 > /sys/fs/xfs/debug/larp
+
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
+_scratch_mkfs >/dev/null
+
+echo "*** mount FS"
+_scratch_mount
+
+testdir=$SCRATCH_MNT/testdir
+mkdir $testdir
+
+# empty, inline
+create_test_file empty_file1 0
+test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
+test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
+
+# empty, internal
+create_test_file empty_file2 0
+test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
+test_attr_replay empty_file2 "attr_name" $attr1k "r" "larp"
+
+# empty, remote
+create_test_file empty_file3 0
+test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
+test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"
+
+# inline, inline
+create_test_file inline_file1 1 $attr16
+test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
+test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
+
+# inline, internal
+create_test_file inline_file2 1 $attr16
+test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
+test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
+
+# inline, remote
+create_test_file inline_file3 1 $attr16
+test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
+test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
+
+# extent, internal
+create_test_file extent_file1 1 $attr1k
+test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
+test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
+
+# extent, inject error on split
+create_test_file extent_file2 3 $attr1k
+test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
+
+# extent, inject error on fork transition
+create_test_file extent_file3 3 $attr1k
+test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_node"
+
+# extent, remote
+create_test_file extent_file4 1 $attr1k
+test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
+test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
+
+# remote, internal
+create_test_file remote_file1 1 $attr64k
+test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
+test_attr_replay remote_file1 "attr_name2" $attr1k "r" "larp"
+
+# remote, remote
+create_test_file remote_file2 1 $attr64k
+test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
+test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
+
+# replace shortform
+create_test_file sf_file 2 $attr64
+test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
+
+# replace leaf
+create_test_file leaf_file 2 $attr1k
+test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
+
+# replace node
+create_test_file node_file 1 $attr64k
+$ATTR_PROG -s "attr_name2" -V $attr1k $testdir/node_file \
+		>> $seqres.full
+test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/543.out b/tests/xfs/543.out
new file mode 100644
index 00000000..1c74e795
--- /dev/null
+++ b/tests/xfs/543.out
@@ -0,0 +1,149 @@
+QA output created by 543
+*** mkfs
+*** mount FS
+attr_set: Input/output error
+Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
+21d850f99c43cc13abbe34838a8a3c8a  -
+
+attr_remove: Input/output error
+Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
+2ff89c2935debc431745ec791be5421a  -
+
+attr_remove: Input/output error
+Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file2
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
+attr_get: No data available
+Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file2
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
+5d24b314242c52176c98ac4bd685da8b  -
+
+attr_remove: Input/output error
+Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file3
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
+attr_get: No data available
+Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file3
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
+5a7b559a70d8e92b4f3c6f7158eead08  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
+touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
+5717d5e66c70be6bdb00ecbaca0b7749  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
+touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file2
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
+touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
+5c929964efd1b243aa8cceb6524f4810  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
+touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file3
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
+51ccb5cdfc9082060f0f94a8a108fea0  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
+8d530bbe852d8bca83b131d5b3e497f5  -
+
+attr_set: Input/output error
+Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
+5d77c4d3831a35bcbbd6e7677119ce9a  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
+6707ec2431e4dbea20e17da0816520bb  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
+touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file4
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
+767ebca3e4a6d24170857364f2bf2a3c  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
+touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
+touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
+fd84ddec89237e6d34a1703639efaebf  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
+touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file2
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
+touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
+34aaa49662bafb46c76e377454685071  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
+touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
+664e95ec28830ffb367c0950026e0d21  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
+touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
+bb37a78ce26472eeb711e3559933db42  -
+
+*** done
-- 
2.25.1

