Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED77CCA481
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbiFFMlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237513AbiFFMli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:41:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7854E2629FF;
        Mon,  6 Jun 2022 05:41:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256CJJ6U006786;
        Mon, 6 Jun 2022 12:41:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qEp1cS1211Yqfw8vVivFjIL16Z1PtVt29e9phsV0jO4=;
 b=f70ZRLPce8Wzb9Dkh+MfOW+b1djNThfFX1NC0nGS3MSZrK25JyndShF5182L0VPjjwEB
 toPziSr7hWmTPLhwfkqlsSLCkRhH/921ehWX7hJ1pQdOilc4YxHkccoPdPctzcp5jUOG
 YqQngy5t1I36U9JJAGHVAMuYzoL0O6oh6/v6haXC6N4cMC/nteXnEQwJqP7WaXFjkUdW
 3Z9GEmp8MXhrzkTJEgs90NnP3MT0E1IzFt4NcguwsliIB8pBRq2+SNYLsz0GcEnGGi+w
 zDNF3viwcC0aMksggTJUZVIN8Hl4zAha3USzJ6HjbgmS+MsDT2Wj+RGDYJjpYv5D+8Zx bw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxmsdtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256CeORk014033;
        Mon, 6 Jun 2022 12:41:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu1f0mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:41:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcJtV6pdTR32wQ6K8X+hkjcDXxhgsK5wA2sOLNAqxBVmj+yU4QGreCWEqeEpD+uve/eYUqMY2NR2O7QImuGQcr30HBlQK2XSiQFBQZRHP2wJZdqVW4A1RIeysVxjvpNhQJRBgTZK+jNdPLNuYu/zh6jSZeLk4uEPbz1lIxaRX/H/fmnqOc+SRy66bN65PkY9riYGLEpgfNYatsaMrqGDp53Jwpd1AyOyw4yGByCsbPgpTsB8LsQlQrqgghmccqq3AZMUjDUxHKl6B5XpSh65o7CternwUE0E50ay2nhTJ+UJRC7MnQz7tF6S6JBgk3yb8ZxyrIOKSgYcHu51fWrTmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEp1cS1211Yqfw8vVivFjIL16Z1PtVt29e9phsV0jO4=;
 b=hJrS9W1AYt84+//GFGljMCGa0iLmKJDidukVbim4gaSg8+ElkU+OfIIYdyAOUV904BhXnEPm/0HfbkQs37QdScnerhTPQDbT1G7aGM8QXWJrLB72TXk9fQ/au04IBffl5ZGe0IEQaJEHWyXbPr1saOmyaAQ1Yy/CjT3+woe62zFcYEVuzMvyiK4LN00VuaKj+Hzmy0cH3iLxrSDCtA7QoDWV33VNW+I+gbwb4INE1z+Y6gTKE88ei1yny6frSme9X0eH+U4VvtaOp7V/gS7xv3ZmwlaB/L5M+0XHMpXGoDJexnDxksqUm44qyIjEEFxB+gbXSYarB63giBPeBpj2SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEp1cS1211Yqfw8vVivFjIL16Z1PtVt29e9phsV0jO4=;
 b=bKZxS4jvW+pJokMrkvxm47pvHsCroI/e3seyRlMRVnwAOcgG1k5OpfxK6vx88/PRc+SXxKjzzX69L8NukmnAtmEIZHhwGpuCzCxjgvs3vyOAizOi1IPgEeTpruf5F2sTED3Igjred1c+o33NAt3PcZXpn6oypNeTBiaVcR/s5es=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO1PR10MB4706.namprd10.prod.outlook.com (2603:10b6:303:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 12:41:28 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 12:41:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs/547: Verify that the correct inode extent counters are updated with/without nrext64
Date:   Mon,  6 Jun 2022 18:11:00 +0530
Message-Id: <20220606124101.263872-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606124101.263872-1-chandan.babu@oracle.com>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::18)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 533d3e12-8adb-4529-c7c0-08da47b9e041
X-MS-TrafficTypeDiagnostic: CO1PR10MB4706:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4706473CA3F8F2516FEDA701F6A29@CO1PR10MB4706.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +k3/iF2qu9zfDjYKk04Rp6p9Je6W1Bxr5QEXtOsjJGboctdCjIalhA/vsTBoVRBV2yExLuIzzOe5iT7WhECrFFZ46PH1qUFwQFRerthP8k38rL+YDtIUSg8dzv0f0C4VFcgCEz+u9+ys0GBnwKq+I7q2ju0whbIj8DXjetDi9b3MOva23fB0TkJH6B906D/sSYrgV7aMFSmI696nzegPAB7tit+xSxaQySZHaPycfB+1jN+BBWwdfwceGXy2ipdfnjN0k9aNqYKtPOngaOzIKz5Cn2eeW7jUN6Xnfy1rZzdG900uXS0E8bO7GIFd8ubcNZQRQEOXHZawX65x2gTdAepMS0nb2qLM6jRzVP73hhaP8fjs1Uxexpk6wgMrIUkGLcmfwu9y1H2iFZ+fUaUAw4WuL302Dhshnu/aecA98Eb1/a1Sb7X38y14zjMWAreLezH8mv9rU0ipY32Py0SfA6R00bTX29dfZsN3kv0Pjr88K23ZWvXUlByRlekbY/K+uO3xfqtNbqtEjgPLQiN+GrMisxgSAm28jbbWVnd7eqIAbtUr62UruOxiV2xKja1uwWxVwSoLFvSh/P0m7y4pfJ6NaV2fHOxofabqFXaYO+MUHYlsj1TaWXnraeb2Vh56YMvXuqPl3NcxguWEjXyVha78FF9mpPu55VZc05r3HNbyElOocFMdEoih3fYj5ThDClX1MYfhnaC4S0NrWiKdBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(316002)(86362001)(36756003)(2906002)(5660300002)(66946007)(66556008)(66476007)(8936002)(2616005)(15650500001)(26005)(1076003)(186003)(508600001)(6486002)(52116002)(6666004)(6506007)(38100700002)(6512007)(38350700002)(6916009)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wWltN6F2n0JwlLLdRbp2WrvwgulXTQFC84YlqzRGY9amMKIlvn5VZuYk6mK?=
 =?us-ascii?Q?Jdoz8LTfKb83HZ9qmLGky0XipV762JlcLSzDC7Hq+7Fq6yHWTlP/egOnPt3R?=
 =?us-ascii?Q?ddtDoAUyBcCzkFpMwyOq/67SgUjflN6uJmM0dSDLcsUd7arCufJo2bEY0INx?=
 =?us-ascii?Q?MdtEV4GvJJ12/pIqiYOEz6uKg0lcosGvAIdi/782AwytJOmDVUPdL8m2X16i?=
 =?us-ascii?Q?1n2vXDCC5sJoBfaVnDBl+vp7xBu9sPM9zosKXlPzBfoxI42U2ryXxHCNp0Xi?=
 =?us-ascii?Q?uJLRO8LacHzibanqSJB3j6HA9WqiM7E5NOIcC7a29P0/kaW8LHhIOGHSPmdt?=
 =?us-ascii?Q?BR6fy2u5cVGlxL5i1Rsfe1432k8N/v55pzn61bKLK2329Bqshe8XNR7VwiyG?=
 =?us-ascii?Q?4a3nEsxU1+Y8atzLkRj14jFrBq56ZbQhx9jhnQWDIgLEiaFdljqPCgn491dC?=
 =?us-ascii?Q?6McngyJSiUfqjL+aOywfMF/IyV26aZ0IT1wuv/3mQWcmnCHESF7g8GXNbAI1?=
 =?us-ascii?Q?4kwh3N2e7vGgT38NIJQkU8mDwdczbYfcfME/THJodmbXaYW2UHEtw6XWF4B9?=
 =?us-ascii?Q?qxZrSirSPOx5sy2u1xu0UgJoVB/0B9i7rtlBXPymKOBzTA90VqD0uG29A+9J?=
 =?us-ascii?Q?eZZYOxm3ZSSWDiJzn0NHLnJ+AnRDhnZ4XrIH+HdO27JEWWnqwNVSwnCYjnWL?=
 =?us-ascii?Q?aZnkHYKm5kxAetdAImXQi5Q692spxGLksbKJ1yplUp2+yIdxsADKkyvu2zgt?=
 =?us-ascii?Q?xHML9CCTjxmFa6hVK+ghtYbLK6qx5ZG+LXoWQWyqSQrTtkTYGU+W2zIW73Ck?=
 =?us-ascii?Q?RBjYc8zcx0MCjhiCbcSFpa4soCI1LeuoHGVeyTUUqb6do0aS0gbzjqxnXmdI?=
 =?us-ascii?Q?koVpCUiVmfQlxFBUCtTMj+JhitHBTebbcGqe9kGJWVPEMoe1/vU/1YFMzKXE?=
 =?us-ascii?Q?Rjmi0sSc/h3oNBpXrx8Pe/7CjB9Lns5tpgYI3CatTtbyLro0VJoM1V12A+uy?=
 =?us-ascii?Q?F6JDODn/ul2hJOAfhQfD26QltV03q7IjzowsDNCKnFHDBFPeSVdgetzkk8/q?=
 =?us-ascii?Q?fOcHjE7+WawW86vxvP9f3vZyBpVVZSd8w5ueLyacewBA63BBGFhM4UPzlmJB?=
 =?us-ascii?Q?iLH0x7uVHZ7kt0vFBAgpG8nw7pCdQmJ/+4eECEhvUGFFwCdsaw/3hRTdhH8w?=
 =?us-ascii?Q?mr/GSVoYnCrHSEKoHl1FcuMDzWg+fkZu4ET+lHY0L7/mU0BCPAHEeiMXgWix?=
 =?us-ascii?Q?SAoHgp3cgljOQdkX8H3ryLtOhhxfdZAfraCjTgn0wwweopERfj+WtKff6Wal?=
 =?us-ascii?Q?ghbdSLYnjxSsL5fjC53Fq82udbsphx6Je/0frIg1jJQSO3Yfs6JBWonNINys?=
 =?us-ascii?Q?bpDBDRyxy+winkHkVz7hWjM+j35jxQyik9NMRIbgk2VziNIHt0vJmL3wAqtp?=
 =?us-ascii?Q?/3sMexvTU0Xqpw5IKnMpH3T3+t3ZrSi9/iKLR1XAZZr/nia1p42k5HgFd5DB?=
 =?us-ascii?Q?dyxsj3+3XaWC0K0GrHbfGlGF+hpgV9JB484GP7/SUbYrI3AOptehGsXAu5+i?=
 =?us-ascii?Q?LGI/dYRoXP/SEtb1M0KiuKJi9RXFeuGijlDwydEL4Xgoe7cfiUgD4TSKYcrt?=
 =?us-ascii?Q?zYvkWuqcT+61FoOKRfCJbTCjNsnto31vMJVefDyg7oaz3BtEs4EzZElzP8VM?=
 =?us-ascii?Q?ljNlkR2U9x3rgLw+tw42dKv05dyzdUxTjdLwJjkC2VKXzhd6lSHbewfPob3N?=
 =?us-ascii?Q?vYVpQxIz5ZGfsz4n7Zfj667w6XUDpkc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533d3e12-8adb-4529-c7c0-08da47b9e041
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 12:41:28.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjP7sO1IuT/Kt8KabwDV4uN2FGtE8pqQU/CJDn2Jp3gW7+zgcaQevIwM6stgnpRxaB1NsUo+3k30pZDlsGbMjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060058
X-Proofpoint-GUID: CLUYqYlDMHp3ec2-BCmMByUqfhMEOvrT
X-Proofpoint-ORIG-GUID: CLUYqYlDMHp3ec2-BCmMByUqfhMEOvrT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new test to verify if the correct inode extent counter
fields are updated with/without nrext64 mkfs option.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/547     | 91 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/547.out | 13 +++++++
 2 files changed, 104 insertions(+)
 create mode 100755 tests/xfs/547
 create mode 100644 tests/xfs/547.out

diff --git a/tests/xfs/547 b/tests/xfs/547
new file mode 100755
index 00000000..d5137ca7
--- /dev/null
+++ b/tests/xfs/547
@@ -0,0 +1,91 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 547
+#
+# Verify that correct inode extent count fields are populated with and without
+# nrext64 feature.
+#
+. ./common/preamble
+_begin_fstest auto quick metadata
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/inject
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_scratch_xfs_nrext64
+_require_attrs
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+for nrext64 in 0 1; do
+	echo "* Verify extent counter fields with nrext64=${nrext64} option"
+
+	_scratch_mkfs -i nrext64=${nrext64} -d size=$((512 * 1024 * 1024)) \
+		      >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+	testfile=$SCRATCH_MNT/testfile
+
+	nr_blks=20
+
+	echo "Add blocks to test file's data fork"
+	$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
+		     >> $seqres.full
+	$here/src/punch-alternating $testfile
+
+	echo "Consume free space"
+	fillerdir=$SCRATCH_MNT/fillerdir
+	nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+	nr_free_blks=$((nr_free_blks * 90 / 100))
+
+	_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
+		 >> $seqres.full 2>&1
+
+	echo "Create fragmented filesystem"
+	for dentry in $(ls -1 $fillerdir/); do
+		$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
+	done
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	_scratch_inject_error bmap_alloc_minlen_extent 1
+
+	echo "Add blocks to test file's attr fork"
+	attr_len=255
+	nr_attrs=$((nr_blks * bsize / attr_len))
+	for i in $(seq 1 $nr_attrs); do
+		attr="$(printf "trusted.%0247d" $i)"
+		$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c '%i' $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
+	acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
+
+	if (( $dcnt != 10 )); then
+		echo "Invalid data fork extent count: $dextcnt"
+		exit 1
+	fi
+
+	if (( $acnt < 10 )); then
+		echo "Invalid attr fork extent count: $aextcnt"
+		exit 1
+	fi
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/547.out b/tests/xfs/547.out
new file mode 100644
index 00000000..49fcc3c2
--- /dev/null
+++ b/tests/xfs/547.out
@@ -0,0 +1,13 @@
+QA output created by 547
+* Verify extent counter fields with nrext64=0 option
+Add blocks to test file's data fork
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Add blocks to test file's attr fork
+* Verify extent counter fields with nrext64=1 option
+Add blocks to test file's data fork
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Add blocks to test file's attr fork
-- 
2.35.1

