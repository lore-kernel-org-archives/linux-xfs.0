Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C08CC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 11:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiFKLLT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 07:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiFKLLS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 07:11:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435F625E0;
        Sat, 11 Jun 2022 04:11:18 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3vwus029675;
        Sat, 11 Jun 2022 11:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=H2VIIw3vfVmlLGiHA49NgaWkWHM5/2h+hSqGYvvRmPc=;
 b=c4G0iyY1EhWphDsVxcUn2ecX6p7Hly81c7AMsncyHS5Co7qDNrijnoWnd70w5bckLf+B
 +bJu35k+8xS8U/08qfIC1uvSQFxKNC3GGsgsq2uhai/mfpQ0F+yO8l7gd4OpeHMrW+1U
 OtVIMqFgfD9ZtBUXnBx/29cOD9/fsynKCusQu1xUQ8KatWgVzw1OJHdpGxxj/OhSJ8y/
 kJRV8uylfFR1f2Fw6p3YAmwNI+/zLAp4xBADJSMboBehT6a83UhKUCprKa7Yilm+WBUT
 XoYmhgObOV6McoFtI+6bt7tqXTm7Jpo0RvYxqeCjL2S6rDJRcOTNHbQ/Z1q3SSXRNgEI lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkt8bvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25BBAipM012639;
        Sat, 11 Jun 2022 11:11:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0q4mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Jun 2022 11:11:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8ZPbULZn/CnAdWsonsbX0SmEA5EjJk+vaxGr+4qEAmymfSEMjwEnAxaDTC9kcnebniX3fwYg2CcMVNNiNxq87SqMSpSGpbnu+MEr0SIQNIwiT6Fyeot1WSEv1vFm7wDsnWB4i5DVdqiXeqLtlF2EmpbHb8AbvU4IzA3deH5lKgQelVlsAfIcHeoCfjjv2h0lClVcd6g3k2eNsP8l/a/A0zDhvY3va4TfHBCiMJByzy86jLxeSpBDhjoRSSE3G7i1OWFZmTSFF2SJ11pdCkxE3Yx1M7dZ/CauisX7X1mKS3DB8OXJI/J+lmsgO9nL9HwVoYPakdLIewwefD8sBXt1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2VIIw3vfVmlLGiHA49NgaWkWHM5/2h+hSqGYvvRmPc=;
 b=OXEO8o6Oc/oy7uNMUFQKZFCq6vikRfPUvcVt4ZWxTkRt+prz1+gpq6c4hsvR+Ew+2KWjan7a/aClACmQXYdAwuE5huIfxY2QR97OTf/UqHnVsz/hQXAOfGwKywtWHn7j7AS+Uh2kDrwCxfdSNJ3uvj99541VRa3CjF1BbJB6Za/p+UefvDp5d5IKqsMVwSzU9x4+NIzV8o++sml49698RYIDcQ52rX5LGY+/8o5rqaI4SZL4s+NczW6DC7xJ2G2XdSol2fJ5FKDg1V56He0bpeyo/U80iJ68KdNC5PDWNm6eJGn+1R6Qy89q9PObAth5PZP0k3zHM166/55ajWc2xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2VIIw3vfVmlLGiHA49NgaWkWHM5/2h+hSqGYvvRmPc=;
 b=Z99Np6jFG17C5FnNcjrNFf92HiRZUtHeMLvvaOuJCeVQMhUVFpffRqud4xDHscaZApbG0X5E7eBRgd5/qr157xxNu/y9/kaitbV1U/C4hFbs8yOZsW/y8r8j6VLw0xlbJu0ECk+V/Z9KH8U3FVYDhRIAjwR3lZSm+0iBA9vxS4U=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3313.namprd10.prod.outlook.com (2603:10b6:408:c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Sat, 11 Jun
 2022 11:11:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 11:11:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V3 3/4] xfs: Verify that the correct inode extent counters are updated with/without nrext64
Date:   Sat, 11 Jun 2022 16:40:36 +0530
Message-Id: <20220611111037.433134-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611111037.433134-1-chandan.babu@oracle.com>
References: <20220611111037.433134-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0014.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 394e393c-1a05-4dec-9563-08da4b9b1719
X-MS-TrafficTypeDiagnostic: BN8PR10MB3313:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB331336C735F78A660AAFF39AF6A99@BN8PR10MB3313.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7yZK3F1+Z+OtvGVu2sQtkRMKaDqBSsauIO4KoGWJa/yUgJn96KA5DdHJ+SQllO357BxMyk6ghVGU0xsC6HdBJQ57GJCw9EP+FeZqw06rMHNW8y9UczkUDTYrrS4JMHv+p+HT/EGot8TQmQ/ChnbMvy0e0ej5yWNFSA4bOQu32+kmidA6FUZFPDL0636feO2Oh6D5U2Y1cAcXhBxWnAh/rwKd3tFs8e7lYq4ehLNkQnsb1iUmmZZF9ShEdfU2ER3Pvzl5JJSABZ92l0ODxllctdaNuOKnk8AFWH7c71uQ7uOfL7tOQlxzbzI3iqgw3qVGquSkSBqExAwJyVmQdAm+q/yeQsw2bExjoUU3m3gnttcAUkC0m4Hxy5XEfa8DQ/nYCBpPP9RdMaIpF3KIcFGSF1Or2BIsPrN9vgPRS16h7xRv2lpCCDN+If7LdMD09XEYOYtgUV6N7ecLUVsdyHhqh9eiTsqDjItd5kPhDisSO3MWg/a8uyG6zBcKXxczIPTwtA1yTeJ221uzqUxbhrPN8tUJZnIrl3eF005k9pDVjKDY1hJIt70v2r5TweuCYXzLqbbv8yXUdHz8PsQ3hXMiHlJTuf98vIFdDTriM+v9lXtctyv6vzSMymPKhUO5GA/J7yi38uvDNtBNjtHio3yWO8wdhFIkRttUypAzJ0/Uk5Vk9CcrzTMAt+v/3c6Rfh64nDHP1yBAHHSTO4+MfsVdhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(186003)(2906002)(1076003)(83380400001)(6916009)(15650500001)(2616005)(36756003)(26005)(66556008)(8936002)(6666004)(508600001)(8676002)(4326008)(66946007)(66476007)(6512007)(5660300002)(6506007)(52116002)(6486002)(38100700002)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1OffKz+FROy1JFCl/kOfuCt+JTki50szruUVUqaPWioSIMgWa5uBNXLU8aGl?=
 =?us-ascii?Q?bVbfRPpQpZ/k/yGqOvpxS0JNn/r9Cl1XkkbnS5J4KZR3V8bNAg9FNbqT1NO1?=
 =?us-ascii?Q?HPnUoF+IDbdM7FTbCaH6d54GaLhXPQy+82us+FO8NcZvOzreGFlfqezcWVUi?=
 =?us-ascii?Q?Dn44lnzkTTDbWffwlNdGsBp62oI1gefUSPfTG1+527fn6m1Zdt+Hzx3kRMOl?=
 =?us-ascii?Q?z3k+ZSqXupf3s9UNxI+dds61ASEpUzp1YUjvBMf+9u3NNRYhRtU3kuRw9MW6?=
 =?us-ascii?Q?XmbPD3zc5jqhxYKKsNHRJrdp3z1TQLcJd8l31POPNt0ym/K3IwlQMCNpkfcS?=
 =?us-ascii?Q?U1rUs+PIhHRBUYZr8plmnmTEDLaPHqxJNf3NNBNGKmzMBN1hwYIhDGqdk5Qj?=
 =?us-ascii?Q?vjrH/eLNP48jcLK6SW4Y/lL3AcAVwXTDnuI06c4pPJKYPRw8Rln1mXTRB311?=
 =?us-ascii?Q?tXqO0XrCju0F4nmglX/zxXx2XGg+h5RJoTLsEWYgP9EvFMRKI2SUrgPoKaXQ?=
 =?us-ascii?Q?GitWOZUc4Ike9S5BXmSeaEhen6dUINpCoDQXkXTg189LMWNY71pKhUj+J0go?=
 =?us-ascii?Q?KyH1WH1aaqpWBhog6xaGNTc4lFKDLoEXsXWM93evlS0fMCtuEAW2qvJp+9fQ?=
 =?us-ascii?Q?u0DQ8UM/Oq+4RIfQ575qH2BtdlCnG8sqpz+Ed4DjX749xlGjdUdQobmvKTpp?=
 =?us-ascii?Q?ZnZN4H1creOpOMZTRJyWo8tXqrrsgViSvjvy8AdFjJGvfVIrzQRzDN1V48nm?=
 =?us-ascii?Q?nYehtzQMZPR1NuOYJsr8EzvQ75B+/VaJ25eHrZlIq3ldFheXg9jBw8NfvIgQ?=
 =?us-ascii?Q?GzXfjwl3d6naUvGHMkyY9XnDs30almmUrhgsVXb+e6frnDqqYrqPp+6el14J?=
 =?us-ascii?Q?jTN88aHwIgbMsN+fklEKe7+XUCTz2mX/nKBxy2aslX0ovkQzzGMozGnxFL2F?=
 =?us-ascii?Q?lVdIYP61aznvgIxj63c3QEKEnROUhCMKGyTlVDOgsX8RA1pTcQrGXXlNOTzP?=
 =?us-ascii?Q?hJCrWrNPEdN9IJx7w0VYkBsZbedth0qQsX6U1qzQhbEHV7/BUxDDprk0Swi6?=
 =?us-ascii?Q?0eOTmjI5lIJGHA4femjhWILmtl+whWFqRzymkagqOV5vgz0hhv3OR0Om9ygr?=
 =?us-ascii?Q?82IS9WBmcitBzYth9XBUn9Ggm4vOV7t+wj1gWTn+NlV6cfKIhDYvjQrceGsV?=
 =?us-ascii?Q?06YzaSV6z++m1YCJLvdcXpZLzuvPn3jIF/L1ExlUdqo+TQf+zYLxQ6UQusvm?=
 =?us-ascii?Q?AVkOPz9LAOid57lpCrBLOs7cX7TGEiQ/u09asdb9tPjGICHQGMn4pP38d8St?=
 =?us-ascii?Q?XvuCyzKnLysJvBQINyGrKDMc8X2yDK5fsAm6jH/CN54ZwevCwOJalGp6pdv1?=
 =?us-ascii?Q?P5aXUxL0mZIeYHGz6vKOsZYIvDLb354hqYueSXjk8mtHQ4gtQt5X7ofWffzA?=
 =?us-ascii?Q?rJMoVa1yvxHKn/LpMT3qna/1QnBAwKAxpQp+sbl27ddjfOAwrqSQNiAYT8hN?=
 =?us-ascii?Q?x0e8jp0lmIA6dXp/b+oI6Cf3UGoIyL2U2iv89H1KVZ2/xNy+pgsU5bHe+i+P?=
 =?us-ascii?Q?mp9/QHwjEQP/sloB2/eXboPxYuQyUUPF+CWaF1YYEny5/stZ9oNgDs8kakxv?=
 =?us-ascii?Q?OjjOs5Q+7/tgMgEf8IX36SolaDcZkYl+xhZ/rPRF8LyJ8yMmnePGD6X40Bxr?=
 =?us-ascii?Q?axEeLCqv83k1Ozbf9VYSqpAnK6CEDbO3S+YlxQQsiOCUbB+E08ougIEbsziC?=
 =?us-ascii?Q?TCXEedPDpZHHWbXEfsU7kKxvwpE9uV4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394e393c-1a05-4dec-9563-08da4b9b1719
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 11:11:10.7930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsUkuQUDomk1L+T59zzpIOXpaMJNRFAaVY4Na2ztDHBKLud6TVx6UHae2HrgUfC+gfpHffQ0IhtwHvqDRfk9Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3313
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_05:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110046
X-Proofpoint-GUID: fauko6Vg9NnmB203JAf2PbRjfDOw_6lY
X-Proofpoint-ORIG-GUID: fauko6Vg9NnmB203JAf2PbRjfDOw_6lY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new test to verify if the correct inode extent counter
fields are updated with/without nrext64 mkfs option.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/547     | 92 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/547.out | 13 +++++++
 2 files changed, 105 insertions(+)
 create mode 100755 tests/xfs/547
 create mode 100644 tests/xfs/547.out

diff --git a/tests/xfs/547 b/tests/xfs/547
new file mode 100755
index 00000000..9d4216ca
--- /dev/null
+++ b/tests/xfs/547
@@ -0,0 +1,92 @@
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
+_require_xfs_nrext64
+_require_attrs
+_require_xfs_debug
+_require_xfs_db_command path
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
+	_scratch_unmount >> $seqres.full
+
+	dcnt=$(_scratch_xfs_get_metadata_field core.nextents \
+					       "path /$(basename $testfile)")
+	acnt=$(_scratch_xfs_get_metadata_field core.naextents \
+					       "path /$(basename $testfile)")
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

