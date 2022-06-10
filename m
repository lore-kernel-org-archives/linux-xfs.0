Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F1ACCA481
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jun 2022 08:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346869AbiFJIwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 04:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348467AbiFJIwN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 04:52:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B283203D1C;
        Fri, 10 Jun 2022 01:52:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A8DZ0s013054;
        Fri, 10 Jun 2022 08:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JUKVcP0vWUX05863LP3pbwkNm4BCLg11Ok/fvxH2ejE=;
 b=kv+Ws6k5FW8oJ5EsqVNuDRoHgZ32do1a8EgNTpX1N6iXYGG5+xnXm63dcuAwcx14laoJ
 4eTjtIi23QAMBbzY2on0LZXMAuepR+u4j2I7O1wsFPdHO61mBbd1B0hPpDDZXr9zRZK0
 yVaZ8tVbVJIpOyxransts6xhSx+u7qXSNjGaT95JfQ2IwVvk3ZmtfICk2lbcw72DmS3W
 4218wFbCqCSS+2Rn4RV6K+mG6IE1p5ku/R6vKXvkfEofKQdTyHC8e1H85S/M8vALMBi2
 oRhkLewtngE2lrVGucVcxhMWMqD5z8vfzyC3UgrqMpZhtkWMOmxRH2mcFy5h45VClib+ yQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ggvxn36bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A8oRZA023935;
        Fri, 10 Jun 2022 08:52:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu65bt0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4bOa/jPjH+WzMcMPJr9qkDqbGYVCJ1fC3fcj0DejL2AS+qBZohvBuDqnYovPUyw4X8ZpUujtj+Ro1Rp2l0gMeRsky4vomXfIkrQarAqaYXbgY3zAUrix/iD522m0yikfJx5VswU76NxZVI1blPiaA3rtOHS8ba+ODpZ1WQA1ihQuZ0f+UReKKQPYZLEAOxq6kWm4FAoyRv+kiTqinLXq6r4CyjofeyBNf6RincfMmUe/t0ojEHLH4ZglZxy55P8d+T1ee8gTsjje0ekdXq80jTXZ1m53JgmmM3qW/U1byNir9nhth6ilwz8Q0Y3lSFv55iNNQ9eKNYySAwyQDHoqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUKVcP0vWUX05863LP3pbwkNm4BCLg11Ok/fvxH2ejE=;
 b=hPhjB6hQGHgPZFcL/WyKTojNPL4pC0iJoUP1df+QNXkFdBufyb4fJ68rA8ekAgVXKMx0G2iGj8/FJCKF0BKHzuSX03xPu4/4VXaHY28IhSR3JV7Ikor2+rpqMnUl3RbD1XO8yoGeQ5mTD6xTteIWNVad3lmroifwmdcuiT06lVQdmQv80D4GegxwX1chPmmTQA+VfIPhSMYMncnntQQMN0W9yWH6wkX2y1XAKLVOEXC1IZKCDF+1gOYmNg53hQTHVb3Gy9ncYXj1b8ZWqM6HGDKMBrS5iLxTv1wn6Gp9su6yhBHwsVjoH6S0EUyyxmMg5vKr1U6eLc5sbUbo4XXCGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUKVcP0vWUX05863LP3pbwkNm4BCLg11Ok/fvxH2ejE=;
 b=FAIqT3+hUh9SrxJ04TiO1lKsSDDAStdyfwEGV9nN1CiJorZ6ZvlvjNt3DgZ23GcHHivfowSTPBFGh4CM+JPkvef3rnwsTvCyYUzXqlJHPxwf7RRFrvQj52z4hy+soUGZKKryYd2CONZMqJ/bCip3A8SqaElWlkA1ruqaFFUDTjM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MWHPR10MB1965.namprd10.prod.outlook.com (2603:10b6:300:10c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 08:52:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::ec25:bdae:c65c:b24a%7]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:52:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        david@fromorbit.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH V2 3/4] xfs: Verify that the correct inode extent counters are updated with/without nrext64
Date:   Fri, 10 Jun 2022 14:21:34 +0530
Message-Id: <20220610085135.725400-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610085135.725400-1-chandan.babu@oracle.com>
References: <20220610085135.725400-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0229.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::25) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: addeae5a-6314-406c-a6ba-08da4abe7bd1
X-MS-TrafficTypeDiagnostic: MWHPR10MB1965:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB196587DDC035F013DC72059BF6A69@MWHPR10MB1965.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4ehz7PaK1Tu27oGAaXsc1OOTz7kefb8RjrE5lOdXDbA6/smggOi6wYMRJvSUe76mEWMRZA3PH+0Ea6I3KMr/hDhpukqXmaLNwtFOULOd9ZFf9T26pwnvXQ6qQH2e5VNO94J0ansbOYeXAFtzkKvyTodnXTYlqe40g23YzggdpvMYUcj/jRM66MqCb7O6ICTsBSojI8tiNBnVHJzuRRWSpftTZY6tzInSPMfJVl0epwpiPn5mAyEuIbAkfCOYCiq+5g0wGqnWclnBHLrAEWz7IPrA7b6rNTPvgYw+KqoGnlVb8KtUo/hbPuxtusmUq7Qo/bKa/mcbUD0SrPrJNhnhTDz4ZnbaiuYtcoQTJaOQ9dM5SLoz3lfiP2Ok7eB/gU0taoFYQNnyvZRRIINol3o4a7tIzVDtlDcuj7E/vda/slUVEVqFYYAZeQp9ClV55ShKXrJ5MLe/f1kjrLrRyCLktgX+lrH7w+lKX1QYzl2e8z+Ba2P+CS8Isx1fje71Xte+OlHkHF5PNLpYoRuuv1clsst2UStDjdEzPRV8VNdI34jAsu34qLyBwd8cKMdbU/mZ6bOCYuMILlslPskhMWQ9gKmehx8S18WeswjIZRbW+LY3ktg5vNC3PUG3XPz3XC8yoRA58TQ8MGwiBoVHYJRSUVRJa+LdNxKyfj0aaIKCqTNQcBvUuTtZhK7TYISn5Awg76gy68vrL9ulBvYapYSZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(15650500001)(6506007)(6486002)(508600001)(86362001)(52116002)(26005)(6512007)(6666004)(1076003)(186003)(2906002)(83380400001)(66556008)(8936002)(5660300002)(66946007)(36756003)(316002)(38350700002)(6916009)(38100700002)(4326008)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WbWEa9DKe3sml7Urxnvdm3MeUeRNRbezb57fA7wNjLChGsHe1khTVLL8PQSG?=
 =?us-ascii?Q?qCQwNiwwKZaRJ5qTanPEJP/PYWEYAZhYebP5EKhPRCccaMNd7ydF71ANfp2B?=
 =?us-ascii?Q?RAKF85zyBaFHandQ5+Jyo9ppmajgNrcu7wQMfYpkfiJsYFleKOWZOiMkNkL6?=
 =?us-ascii?Q?1HgCsU4RVPLn4eFxSoLX6j3wuYn0mHiuQeDYm6qUQNqRXbUYoTvqh40F6AOZ?=
 =?us-ascii?Q?sPcrQESQvIymvymr4S5Gmnc1DFXleqBksHOQ2bmw9makuhzi9BciohflAPG2?=
 =?us-ascii?Q?TzFYWhta6AvOonIx4WRih1CjTSFDKCUQAN0uL9wGm1ZiQLhuHFoPPp7RJXvh?=
 =?us-ascii?Q?N7tHyWNu7GepXPdz64icSPRl8HxqlecvXdSE4mQlIAySHu8LQ7c0a+WtWh8B?=
 =?us-ascii?Q?g/V/jwGhhiqQja1XD0tw6dyDY3MR6s2iL+nkXsERAvMvQO6KMfhnZ1IZciBh?=
 =?us-ascii?Q?aoBYrTtAJlUPH+Xj1Dy5C5jAExcRCqyp0p1TBG3YLANY4/ilf11AKdIBOfrQ?=
 =?us-ascii?Q?bcsUVE+KJuCpwoc/gxDLZEwVrinfciE/tUZFiRBwz56lRnH38OxtpYsWZz3x?=
 =?us-ascii?Q?/umnnORM3pgDGq8coJyHgnIgDQQNbbVUKT7ZVHC8ovdiCWc6D6FSBikvCSS+?=
 =?us-ascii?Q?1FG/nxOR94nOMwpMycEIsj3QLlThgumreyxGhOBhmzy13fwP2XgoaN+tJqXt?=
 =?us-ascii?Q?yLXia119UdBzjUXUgSwLJO6kIshdeMIcaixDIjBgnzxvMd1MEyilN7crYkPG?=
 =?us-ascii?Q?X3ZvKDwIetA2iODCVJfmy35FtzHRPz/Nw/Srk8uyNCR0JR26/ux7ZQ7Dl0jW?=
 =?us-ascii?Q?UgG5ppPVDKvGPl/SOL6/zODqj0lLYwfdbsCN56I5hkt2CvbEyr8q/5lo8Qzl?=
 =?us-ascii?Q?xE/MxFVuFWzacqo2ENtgCziscnimF1mQdZCW15j7d8+LhNWzKwnDn1Yan/Gm?=
 =?us-ascii?Q?o6xHXR4jG1rKGDvF8EGmADOR7T89OHZb8vQ8oapRvh1iovqjGNzzC8h56brA?=
 =?us-ascii?Q?ksn7V3Qzl68i5ut+mUeK1FqcKdPfq6LN5WIQsuvEXuLQW2/JC5F8hi4HAej2?=
 =?us-ascii?Q?zPG0FcEknzQshqWLjBTEkJktq0IXYKtWfc2TNcmIBKDqbGWpBbY9xlyzt63I?=
 =?us-ascii?Q?gF0fjEiFSsAlecbQdvQqX+FqUzklkuChNqXugBNN4Lm90Rb9LTCcJmwOQjFJ?=
 =?us-ascii?Q?MC0fEeRWHPgxq9gRBpoO2HENmzU5mkKdF9LsMUoYxjmFPsFHKBh+Ce0vSn5F?=
 =?us-ascii?Q?jDmHjYu/ZHBkcUcLi1ZXE+mx+CeuX8+VPH4FcXocmz42c1snqmPfxqSckGjo?=
 =?us-ascii?Q?7XOcd0X9WrUoId2baDDPMZjLV03ZtDbXFhfOYFOt52cOpqVE6KPmMV/LMFi2?=
 =?us-ascii?Q?wu29R1TCQhNO1lOqIhMyDbnV1C89dwy2Jq1FwQRBXwMzA6AN8/jz46wJGCyi?=
 =?us-ascii?Q?GBbxdRbq+RqnISwuUQvV87ZHSIeBo1BNr1uE4EP5Vl9XEuS3h7vYAlkaPZDc?=
 =?us-ascii?Q?rs1ofVPqRFkmlckwCO17tiQOVmRypJndI1yU82rrJGSFl7QhmyviZYaSlFCo?=
 =?us-ascii?Q?F5I3jdgGHmqVNcSjVDKpbkxTkkb+PzUvb3FT/D1vvKhPWsp25wjgVZiL3C6l?=
 =?us-ascii?Q?1uR3foSO7Fp3srLqdtFFgl6xrGCTtl6yA1arvGtrtHtTlnRbt4TDn3GGSlsI?=
 =?us-ascii?Q?e8GgFqwt4f+UU+0n3Kro871qUcty+VlMIsEVpLSGbpKY7kfnJ8PIl6x0BH89?=
 =?us-ascii?Q?dLkgKgqyJs0/ydP4N6O4IB0jnv+sxuA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: addeae5a-6314-406c-a6ba-08da4abe7bd1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:52:01.0113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIFBH1RTQIKads5j/Sbpwv2o8XiOqKAi+J5jsD6wnpLafR9RIOpSUr130E9hqbCXq2nDn0F7f1b0Tef41kguDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1965
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100032
X-Proofpoint-GUID: KOvLs8cofNTEvqOqYlKHcAEocujDjaqI
X-Proofpoint-ORIG-GUID: KOvLs8cofNTEvqOqYlKHcAEocujDjaqI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new test to verify if the correct inode extent counter
fields are updated with/without nrext64 mkfs option.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

