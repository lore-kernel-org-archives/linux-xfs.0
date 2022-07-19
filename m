Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C49FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 22:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiGSWZe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiGSWZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 18:25:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC6242AEF;
        Tue, 19 Jul 2022 15:25:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JKACaA002381;
        Tue, 19 Jul 2022 22:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=uPEVA/Qag/xkctnkS4B/6Sguwq8BfOgzZlWvmXuQzag=;
 b=X+aO4cBMvFn7QHnCcqMzOXhLnWJGebh/jAv5P9h/Ps5mGsDc1IbZo4zghjBdEITcq6sM
 1wKYCLCcd8H7rWuqekJd/O2wHT/Jxgl8EPc9sKVQpb+0Dlm8x2qbQjG5dvHCBxvr43hU
 k6Bc9xGVACu3FtRX+ixz/31ASUVx4NId7bNhv82OdAFxX8L4gCEwoFMwLF1RgtrNVvNV
 AdZhblwLoFflnZgr3Iq00S4fMjPP4TNymBUkyY/hlNoI2YUEmONM5jaqtqxisNe4AetW
 BBQ0uSexHsz2tk3bbzBqi4ikJQKobRf4V3awu9WxTswsW7g6W8XPS+HgPR+yqmidzJPy Dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a7sd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 22:25:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26JKsp8h008087;
        Tue, 19 Jul 2022 22:25:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k3sax7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 22:25:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpBzRFBUw/Hscwc21+ep1MYivOX9/8nDtF3+8CPSw87KmGiIV4yoDoGCTRQyKgQXrSHWICYQkFF9LQFatWGLX7ZLQNVk5LEXEqguYo2Jxoab+qw8mCBHDzvz8cvHqnbJuuUHp1BdtbflkUq5ripPmx9NgDlox1vzWjfmY/eMEZ9JxmKuPAXLnm+6FWbBqTpGZVnV69W0MkWE1p8ArffIoYxb4voTGBCbPsTxFWMG3wj3mmihG4zITJDkQrDs+KTcdHK6lCWbEjuJHSec0Retzn+/U1yuefx+9uOz9haW76oRg7K6fI0WPwDLxEuhQFz2xEa9q0W6cheyp+PZEIKfXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPEVA/Qag/xkctnkS4B/6Sguwq8BfOgzZlWvmXuQzag=;
 b=Q+sbrs3aTogErX9M0tZU/K0iPnUhuNSyWjNjSumVTy+JVUuXJDFuAZrTTLTzCQlgM4XsK4FEBgay7U/9Vlbs7c9hygcuVw83D+mwaFW6Szll7fC44xTxisx9cJLvEtVm1pg322cNxJVwKe3IKrRD6BMV45mAPpU2fC8axnQWdGUsUU/QTaWhbkkBgeQoQTyt/PUXg4FhPJ85njCpJDuEBrYG4wQnlAler178b5Z9vkRy89nzUxNuk0PuOUfPhJoSj3dSuQJ2EdnhEJNHpjRGR4PE2ZqCwiz9gZfgowEXCLjL61WgYBKJ2Z3mSYoLHTn8YrGIlVpogf/kuc/kgN0hMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPEVA/Qag/xkctnkS4B/6Sguwq8BfOgzZlWvmXuQzag=;
 b=qrzPE/rDjIrxd25ES5x9werAqHsuLXi5u9jOusIjo0fOOHyRXkv9MFNGzqWPYsVDZgOZT6JUZ+l1hu0qHBCCxpx/yaRZJ0F+spSmJALVgPxGEQLlfXu8lQGyS5fphRWDRj0kGhX+ZLud8kruWKAzfrFi3PVmVtADPVD7GdqSUOU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MN2PR10MB3342.namprd10.prod.outlook.com (2603:10b6:208:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Tue, 19 Jul
 2022 22:25:27 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::2d1d:1a92:5144:88d4]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::2d1d:1a92:5144:88d4%7]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 22:25:27 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2] xfs/018: fix LARP testing for small block sizes
Date:   Tue, 19 Jul 2022 15:25:20 -0700
Message-Id: <20220719222520.15550-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:806:a7::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 414dbec7-bc73-4083-5874-08da69d5950e
X-MS-TrafficTypeDiagnostic: MN2PR10MB3342:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JIMZbkyMSv7BeTfzGFBYwf2B3i8nK8qkYASQq/1gcNZfMIiPqCK/IiI2uh9bwLIfiTP+Kxj7zEPxM47zw6CfZD2wugfEzjxghJAJP8gM7IEUjM/s/ao954Z+DNvEtlxismsdWeMkfgpKjzMOuYX/q+Isdhm4Bd3bwoQjxb8PvpynPPBiwxQ+78dFIJjqTVtxZ8Fw1kARsEDSAHo2c86IJuMuFrYmNi3LwkGPq7gATZqpZb5WPUAepDR5AkGuovdFJ9xc0MULh7BQNt1GBvGxdT31f2jkl/XN5aKqxVLUouHVhURtA9WrbfL9JZ9g3hW0ZFI9mtnrVMQEbxfXcHh0Es8dQx0SRcavvTMVZQaeIWFiTxcnayrFRcVBBECTsgF2pqfEf10pk/qK2/CzisqVZbRFl/bYaEyXesQzp52xsn84ZBVvAu9eZJ3gr8lNn4gf1Nn2Yd8W4nOzQn5cHeWfaHcEQJO3tnd2F6GreBiykOLS0c++vHZ+DzC/ff5UkIYqj6PuUm5fNX6jxk3In6iMpz7Ob6FbtOJEWCklgAjquMdLOXQTHi7RU511IZ5Qq7RGd+NBGqODetcaD6Vn7GVf/iZhx7ttfCg3hX1179BItVoxxNSnWPrVbIl/1EmG5fP/fBLEMkMTX1gMN3zAxq3cw10ubS1sFXc8sWBDbjkLJxBuHY/j5FdObFZ6M24mVLL5pobWBLYQJn6QjwbmOyQCM3wlQ7SYEkQHM+flpZsxaEwS0L2qAQrYN0Xukebu2YY9maZfGIGaIjr6RNvLOgWuNorti9srGdRK0oUHmMUhaC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(346002)(39860400002)(136003)(6486002)(478600001)(38100700002)(450100002)(316002)(6666004)(6506007)(86362001)(83380400001)(41300700001)(52116002)(1076003)(186003)(2616005)(5660300002)(44832011)(66556008)(6512007)(30864003)(8936002)(66476007)(8676002)(2906002)(36756003)(66946007)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0KPcP3zWNof+bl1ETgiTlegF6+KDrD+xDAYT5tfKChoNR84I4/B4dwK4vUVo?=
 =?us-ascii?Q?ZrpAorhkN1JnyG6+O5eOU0fRRqkXh1oRgftZDseDoB+bffipL5SbyGjALea0?=
 =?us-ascii?Q?CkOP75YusQ20U7UjBTt+bvnLFZ03JSipenDxGOQsxbHJ3A3IUe5a46bx6vah?=
 =?us-ascii?Q?AaxsrCpxei7B3x5tIFupuGaNVQSaxOlRVobNMWFFE3ky+qfj8EjLYbwKjT52?=
 =?us-ascii?Q?6jPjseLTahT4pbdWwA/gH/yQnF2AvM5f+rWleYfIY7REd89ejhhvrbeGG2Ad?=
 =?us-ascii?Q?Nx9Klv+mcIO+mtnX/fKBcijKWs6YIHaZ2EeA+bGii4DTrkhq/LiaQtqGssHF?=
 =?us-ascii?Q?I2h1IxSEhh0CI4r9/9sNJxouNB3WXKIGe19l3By8FfuFTcLGIhDVUOJ+Khnr?=
 =?us-ascii?Q?3CRvD3HOe+/J2J/7sMPZATkqduma2HLATxrWRgJwczmjzNlhGENQNNPUeTdv?=
 =?us-ascii?Q?CrDZwyy1dwkZdOcEqMV0d1Gw8Z2k3aeEhHq8yn2CO7W9pTlOixp3rZ4eG5wZ?=
 =?us-ascii?Q?IOKJFU4fh2Ag991e4JiFPylZA17foUosS96SIVPKy9hVVYN2MEe5VOtOyyR5?=
 =?us-ascii?Q?r8lq+fFIxrEFaFsx6ju0L+00krKlGYTNGHtOX4rc+dH7PjYWuwK89cz/4uxD?=
 =?us-ascii?Q?vsyXjj4XZEqVuAVPKi70R7Ekw+mQwbV9Tx2Xt1hrDy+qYnKwA0O27inkPhEs?=
 =?us-ascii?Q?YTn5pzspB+TIrB0mABBUurhpxn7sLptTaJUavOV3ZZaR6r2cteararcRst+D?=
 =?us-ascii?Q?5sYwNZfniIUnhJfFlnNT/SvccRl+KwyYUSBvkruwlNxmHHgzl0UVa2Pxz5d9?=
 =?us-ascii?Q?KxO6KycgiUgPA11EKfH2r6rJ1Hkp9DhG+0IJIlrlqWC7iHwz1fJJO7po/UAd?=
 =?us-ascii?Q?YW8+vSWfssXgDi+I++pZPYbdNuyHjZRfqU+qwcMu9hPQHni44WvWZW5Hv6zh?=
 =?us-ascii?Q?b94dOd70nt2c9XcXlu84vMBg7K8OJEYT/pllM9iS31k9HjJpGYvxDSYxF/tz?=
 =?us-ascii?Q?lL8MavMCi95TFuvDBfWypcTfcFNGB7VvvqfNKI44Fs1ulFkwnTimLDSlFThm?=
 =?us-ascii?Q?xDzQqrflajjW5LYpYUmrsLPedBzoYBn8+Mb00GsKtQEdCkXYeBodaZi3JIlI?=
 =?us-ascii?Q?MvSc/tnxUOGzJACRwCHpbcetyYQ5p2FZEp9mQtbC9FDdhZYRCvGZHsC+O1IV?=
 =?us-ascii?Q?T1lvb2QTzbNnVcBJMSKYz+HV2pF6lYdqwKdMHB4d4VfRNDv90GgDcX3MORiH?=
 =?us-ascii?Q?iyR6mGyyR3r9kirAkzEUojUkYSx6ipDyNDo7MQg5d6sX2Yu2rJSxruKgLqko?=
 =?us-ascii?Q?dGcwiZTcZQESWOrTEyrLwj5djHfmG1K/Ex2YMMwwIeIq0xjHyRkzEUMAz70S?=
 =?us-ascii?Q?XwQUAsMjvB9NvECxxB/MRmL7ZdMt4VsnucKcwZAdixBuGmBE62wLamVu3wkj?=
 =?us-ascii?Q?sd6FZTu/Z+nt5NKnyv+EhROnygMT0VQMtozZN7MVvlEWRR7UuE6u+uYNlm2n?=
 =?us-ascii?Q?kO74F8MVeEGjG0nnqMCjYUdvzotXYAsdrFOWFDwZndOPvPi/W+e0jj8DQlzL?=
 =?us-ascii?Q?O8nzuvgKd6Ix87AqDZ3vAnNtcPlQESbQbdUhZ5cE+QWFNMsZb1ysNXI2Ugsl?=
 =?us-ascii?Q?L6a7/ue0HgwO1EngubuWotA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 414dbec7-bc73-4083-5874-08da69d5950e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 22:25:27.7761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWRBrnmh/1WqA2MjgLHdhVAOYlPpazGz9ucBvNLSxN7BCDDJKbMcFYjTOMl6jp/v2cHquT3rwbTDS73Rh9ljJJBYGEkZHdWq727c1r6ErFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_09,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190092
X-Proofpoint-ORIG-GUID: l6ffI31WAjxdNVGKpB_0deCqJT6AW8Ft
X-Proofpoint-GUID: l6ffI31WAjxdNVGKpB_0deCqJT6AW8Ft
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Fix this test to work properly when the filesystem block size is less
than 4k.  Tripping the error injection points on shape changes in the
xattr structure must be done dynamically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/018     | 14 +++++++++-----
 tests/xfs/018.out | 47 ++++-------------------------------------------
 2 files changed, 13 insertions(+), 48 deletions(-)

diff --git a/tests/xfs/018 b/tests/xfs/018
index 041a3b24..323279b5 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -47,7 +47,8 @@ test_attr_replay()
 	touch $testfile
 
 	# Verify attr recovery
-	$ATTR_PROG -l $testfile | _filter_scratch
+	$ATTR_PROG -l $testfile >> $seqres.full
+	echo "Checking contents of $attr_name" >> $seqres.full
 	echo -n "$attr_name: "
 	$ATTR_PROG -q -g $attr_name $testfile 2> /dev/null | md5sum;
 
@@ -98,6 +99,9 @@ attr64k="$attr32k$attr32k"
 echo "*** mkfs"
 _scratch_mkfs >/dev/null
 
+blk_sz=$(_scratch_xfs_get_sb_field blocksize)
+multiplier=$(( $blk_sz / 276 )) # 256 + 20 to account for attr name
+
 echo "*** mount FS"
 _scratch_mount
 
@@ -140,12 +144,12 @@ test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
 test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
 
 # extent, inject error on split
-create_test_file extent_file2 3 $attr1k
-test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
+create_test_file extent_file2 $multiplier $attr256
+test_attr_replay extent_file2 "attr_nameXXXX" $attr256 "s" "da_leaf_split"
 
 # extent, inject error on fork transition
-create_test_file extent_file3 3 $attr1k
-test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_node"
+create_test_file extent_file3 $multiplier $attr256
+test_attr_replay extent_file3 "attr_nameXXXX" $attr256 "s" "attr_leaf_to_node"
 
 # extent, remote
 create_test_file extent_file4 1 $attr1k
diff --git a/tests/xfs/018.out b/tests/xfs/018.out
index 022b0ca3..57dc448a 100644
--- a/tests/xfs/018.out
+++ b/tests/xfs/018.out
@@ -4,7 +4,6 @@ QA output created by 018
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
-Attribute "attr_name" has a 65 byte value for SCRATCH_MNT/testdir/empty_file1
 attr_name: cfbe2a33be4601d2b655d099a18378fc  -
 
 attr_remove: Input/output error
@@ -15,7 +14,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
-Attribute "attr_name" has a 1025 byte value for SCRATCH_MNT/testdir/empty_file2
 attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
@@ -26,7 +24,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
-Attribute "attr_name" has a 65536 byte value for SCRATCH_MNT/testdir/empty_file3
 attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
@@ -37,132 +34,96 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
-Attribute "attr_name2" has a 65 byte value for SCRATCH_MNT/testdir/inline_file1
 attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
-Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/inline_file2
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
 attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
-Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/inline_file3
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
 attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
-Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file1
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
 attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
-Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
+Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
-Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 attr_set: Input/output error
-Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
+Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
-Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_nameXXXX: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
-Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/extent_file4
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
 attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
-Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/remote_file1
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
 attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
-Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
 attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
 touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
-Attribute "attr_name1" has a 64 byte value for SCRATCH_MNT/testdir/sf_file
-Attribute "attr_name2" has a 17 byte value for SCRATCH_MNT/testdir/sf_file
 attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
 touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
-Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/leaf_file
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
 attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
 touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
-Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/node_file
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/node_file
 attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 *** done
-- 
2.25.1

