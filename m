Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97D9C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 10:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbiGMKqV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 06:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbiGMKqT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 06:46:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8518EFE525
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 03:46:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DAOG4F009887
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:46:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=b4fLmfsVOLTzYjITmcBQcpfnBM88g0BsFSdq0DSat9U=;
 b=tJoQVMpn4+p4cm1fGr3a7QggD7eyqLEsP1CjrpTbiNRWJllFSGD4670w0pdeq0avSk8G
 Ei2mvJQ/Sc3WYt/8b5A9bVkkriPgf0uyRM73fGTfbN73LmD9WG8SybjCmIf1A5R054Ii
 nb6/rxQY6wBvao+SgVcXt+cSe7SDQq/UxzBIA1fl26kuUGbupwcc4YOQmR9Ibf0e06/g
 iFHfrxGYcPYM2AJ46tlgv3ftG8rUaGQYQ187Ct4s0App9+Zjy50SeBakkpa1gSey8NYz
 /qK/ah2dGDJ+2y9qJjKn6fz18RE2A7GOLfnmfcxiIaIZn4l4NDHW08ut95jVexszRy0X 0Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71rg1qv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:46:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26DAUc1d009632
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:46:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70443cwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:46:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6IKVUQ6hXE/+PUuoIy+7w0i5XCNpqWliH/AzbHOYY0kl1wAvOXfNOCFFkvkBIBrfpSj68JHRPzEr5tNrp3i8tcaJdEEiVrrzvl43KAL3cm6O3BgLDlGB3ZrpX0+RL9I3a8URuRcRzckTpIQbLZr+ioXl35ln4+7e4oD59HmQ4QWJYjDBIMKzpirPV95qNCNWHf27AAvKdxyx3F9bvfjBs/HFyHh3I133P+4mGh4PzDvW6wkyLkvHIbyK0aieswU464rC5Jh+RR+Simu3AvN70l8HImaqkl3h1NYHdhr7j/SX5+PMNFJV+hSfh/PKCXyf9sZdeCXPPTRZ7uPbtIMZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4fLmfsVOLTzYjITmcBQcpfnBM88g0BsFSdq0DSat9U=;
 b=A1HRgp+DbKVZ6bt0umRDSxYnWEYPzqIjlKMWq5wWBpZbwg7s9sC3vR8JMapCbes/aBIk4zDiKZyHkaIXWLyRqiSPDvj6bohjwUZXyZRgJZR5vRRPJJMFYL0yBYulrEU7sP95C1W57/6n5q/UU/tRwG2L/PjXK7h3i3PBmUd5XZ3GKLPuEkJwz+U3AxpotHs71EniJUT/d6i4r/6iPDCSwvLG87inrhGhzxOEDdTqPt+lKFJr0KyZJq0mNI60H61qphsrLNitTLROPaGvKkXCOYVUghNnTfyMlMzebK10EXG7DZY9r7M8f6ABTAToxJ3Cj96pDwlFn0b7uL1PLmT3Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4fLmfsVOLTzYjITmcBQcpfnBM88g0BsFSdq0DSat9U=;
 b=cBv95hcwHNjHPTd+n2x10wUdNHH1MtCgKSVtz/xipuKk6IveemBIPvMwCTclrCOtVDKDKhm4os/G8kBwMAVt0/mKM7DdxTIt7w8n6cqcLWx5GT+jKRobzM574JPVTDgHjbUgbSKWYcQuPTfgB1sE7Tgo5WYpSIiiedzvXnNKaSs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (20.182.117.12) by
 SJ0PR10MB5599.namprd10.prod.outlook.com (13.101.75.170) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.15; Wed, 13 Jul 2022 10:46:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::51b6:5d48:a46b:16f9]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::51b6:5d48:a46b:16f9%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 10:46:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH V2] xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
Date:   Wed, 13 Jul 2022 16:15:51 +0530
Message-Id: <20220713104551.1704084-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220713073057.1098781-1-chandan.babu@oracle.com>
References: <20220713073057.1098781-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXP287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::34) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2baf45c4-3bcb-49db-ecf2-08da64bce6ed
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5599:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UIf6cYj8Um3QR2xxeaDQ7U+P1zCdku2xtilHWkqdXBhB7u8L/Lq9M0el1olOvBfimTV84oYsvk88rHZ4SOiNA55UI7UmgNXW4T7r8tT7XGO9q6i+tptu5ChGdY1hpsqP8HC0nNCYF4Q5VCDRVtPzLgVDlNFbPhy95NhWSo9iD8ZScQZbJcatqDGcp/xsJRKlAYpVQO+4fB0eLnmwZb8OuXjLZNZ2kmxzmTiYfkPMaNduAOMFOIr/f/OtbJZ5glTdfXmRaj/mNqXm23D6wX41k+z9R2Pva08QVMsGdujssWiAII9d/CqEyJ0KVWnEolsOKtkneb2xcoejg3dnnDy2Cq6A2V33KgJUW97Hkj3uo8lgsomBhB5bqro94b16fSoe6Or/ecZSkX++hOCGXIpZNXgRqNjNGMb2vYgyEWWeS5GX6yh0VXbvRtOokMVJUQc8+fDpTQKvSa68vLPVibRIBEgG9jiupFk9Xag75Ym9BPXygF6lS4PBckPPCp0A/DpAUcpBGTfE9GBDa8R/VbBAtyvUu7+jSDqPrbHFJSlWNDkmOmDjGr0yYOb9OudAwq4mX5IxNWcj7ey3dw3h+yjGpfzriGBQ/n1cPaCK0gpXMMilLZnVBA6TiX/o93SaluECc/cuyv+4eEJpIrgxxRCKmlJaTqQ7LKgVUawc/1Qcry6GXVX3+Rlhas2QZHxvf1Vs+eCWhj2Oo6pL287nVZA69+aCw/00YI71hxbdA+7XxMYNIX0bzgwnQsps54jrTYFs5TxwACBm3+91asnLPktcQ1Ld/qdC2u3BuZ9A3ofE+TqBiLkIJFWIDGCYpaAjrW4+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(39860400002)(376002)(366004)(8676002)(66476007)(83380400001)(66946007)(186003)(6486002)(1076003)(316002)(4326008)(478600001)(26005)(86362001)(5660300002)(8936002)(66556008)(38100700002)(6666004)(38350700002)(107886003)(54906003)(41300700001)(6506007)(6916009)(36756003)(6512007)(52116002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1UDwAKjAnCpeebeKDvR36ypg9AfSyUgbMR6jtdXxpLi93nXZCY05lB2g4VSK?=
 =?us-ascii?Q?BbDORIK514Udzcw9w9vx5IM4bneGsMCNr1l35iSJ9bYjL7QJvVBql/drRqaH?=
 =?us-ascii?Q?oflXr49qyKpvxMSLYExfJvznun4OmghHlfla5xsF8VnsTCwHfG7bljkvVrSx?=
 =?us-ascii?Q?IuCN+SH8XfF43HyxpvObo69JB0a2yFE2DKUjyVMzaovxAfNCVGQcMS4hD7II?=
 =?us-ascii?Q?bTRtUlBt4rfBU85unNQvnklsVJvdGx+z9EJxvZuzukg3PoDjRXCyIJNbL6n7?=
 =?us-ascii?Q?zNobxB5lRAxJgaRcJkVxuq69DzVPavfkVzNiwsARfY87XOiuUh2ity9ii1te?=
 =?us-ascii?Q?ecmE81iE8tBRqOFvIi6qGNcyR5LWX4paIMufhV6JRujQ/lbfvfwx0DT1WOUo?=
 =?us-ascii?Q?Qcn81ERRx3LFL73R4MKsFduNMUgCfE/p7K6/3hqgkvgxxYRRyQX6Yu7qYU2x?=
 =?us-ascii?Q?G89Ulb0qEPorzxx7WrZDcNSNDPuSV4WldgVPPcgDAILiaEPJnkk7HxUmKpi2?=
 =?us-ascii?Q?Yrkm6kSJPVyaX93hwfoH8zfY+UUQv0erWBfvzlgB79eLvbUcvKlR7szOS7yb?=
 =?us-ascii?Q?b1zpjkh8Ki/98PT/BYmoVTkbYV4CB5PdFKMkYUr23MpDFuB2P83QqrJLf/gK?=
 =?us-ascii?Q?wI9wUpzn5M4dnhegdaQt+ZN9qFPT0CX80y8rviyCCWTTpUln8Y4/Z2jc5u7/?=
 =?us-ascii?Q?cv54d5SD5dlJoRLebEIi/Tbu0K8fcNb1BVzY3HE2QdsT6yEjTATKuOC5n8cJ?=
 =?us-ascii?Q?qVWXGzGC/vE/YJp6SrvPWYzxwD936ngFXuTfA21lh2DJ9c954MjiRkde2vO9?=
 =?us-ascii?Q?AWuugyuUHpQp47p2HafRd/FQiJIg2OJ8Zo6NbjVUgpmJXMe7ZefNqHOr2KSY?=
 =?us-ascii?Q?960T8zitFk7Mr8FewPSZZ5DUutyKR2Sv8RzavHJEHQ9x8FdiDMPIqks/DYyC?=
 =?us-ascii?Q?kHsomzRtVb24jsbuPVs4IWZgG6G39YaOLIGe3MuSpCQ54mD6i78KubcGLWzR?=
 =?us-ascii?Q?CPDTjBCUhhamdRdEvwnV0VKfk6NUoytYti4OIPCsO2/8ATneyqX6SWVTWqdi?=
 =?us-ascii?Q?KOoB3VH6Rxe2eBFeqGbq/ecwp/LHbVyXMZGhu9vPc9qrpXlsy5UZ5B8FWBD2?=
 =?us-ascii?Q?rA2/imezBSzoUWSoK9Qthqz95NJTL2s9WvcDCl/eUcNtFPccBfb+57ComEo/?=
 =?us-ascii?Q?gI+yEJDCAeJ52OxfoOLNK86ntxD1BwJfx1aK//MPCZYst/kdveHmgssOQymB?=
 =?us-ascii?Q?Z65G1JijTiC73v1hhBwgjID1ljX8A9pcne4Xwc7GdTmRcKapbDhkbkFydbiw?=
 =?us-ascii?Q?rsmkftvqOcPyTwbywIZQZ7z3KFODu+mJ/X4kTt0BGudLNzZZNdSTPwusLdHi?=
 =?us-ascii?Q?4NCi8WM7yexs2vfq2zLqF9bZIhCPHVKOCI9qqvJ2aTemANHHmvjd2JfniWS7?=
 =?us-ascii?Q?+flb7XUKTCrfsVtZPzCgFni84Ubr6mkedOsaaHfSvaqrq2gLmFwUW3W7eoOX?=
 =?us-ascii?Q?1YmVcEH6ETq8KgWMR5LjzCZjB9jTFq4uLEKj8cByXRjVQBYUey7aYqJXvX8i?=
 =?us-ascii?Q?mwURyeGz4SCDIDWjL7K3RduOKLCoM53buAPaUIM1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2baf45c4-3bcb-49db-ecf2-08da64bce6ed
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 10:46:12.0764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCUzBw6/Ww1szi97KHjFnJs4fJRaBQl0xpoYKca0mvtYGrvZhp2yR5CWrs/NJxTI/atRDBszALUnXybblog7dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5599
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-13_02:2022-07-13,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130043
X-Proofpoint-GUID: wfveEnDhSFlWJz9lgga6Oj7_g20teFvf
X-Proofpoint-ORIG-GUID: wfveEnDhSFlWJz9lgga6Oj7_g20teFvf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
even though the filesystem has sufficient number of free blocks.

This occurs if the file offset range on which the write operation is being
performed has a delalloc extent in the cow fork and this delalloc extent
begins much before the Direct IO range.

In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
allocate the blocks mapped by the delalloc extent. The extent thus allocated
may not cover the beginning of file offset range on which the Direct IO write
was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.

The following script reliably recreates the bug described above.

  #!/usr/bin/bash

  device=/dev/loop0
  shortdev=$(basename $device)

  mntpnt=/mnt/
  file1=${mntpnt}/file1
  file2=${mntpnt}/file2
  fragmentedfile=${mntpnt}/fragmentedfile
  punchprog=/root/repos/xfstests-dev/src/punch-alternating

  errortag=/sys/fs/xfs/${shortdev}/errortag/bmap_alloc_minlen_extent

  umount $device > /dev/null 2>&1

  echo "Create FS"
  mkfs.xfs -f -m reflink=1 $device > /dev/null 2>&1
  if [[ $? != 0 ]]; then
  	echo "mkfs failed."
  	exit 1
  fi

  echo "Mount FS"
  mount $device $mntpnt > /dev/null 2>&1
  if [[ $? != 0 ]]; then
  	echo "mount failed."
  	exit 1
  fi

  echo "Create source file"
  xfs_io -f -c "pwrite 0 32M" $file1 > /dev/null 2>&1

  sync

  echo "Create Reflinked file"
  xfs_io -f -c "reflink $file1" $file2 &>/dev/null

  echo "Set cowextsize"
  xfs_io -c "cowextsize 16M" $file1 > /dev/null 2>&1

  echo "Fragment FS"
  xfs_io -f -c "pwrite 0 64M" $fragmentedfile > /dev/null 2>&1
  sync
  $punchprog $fragmentedfile

  echo "Allocate block sized extent from now onwards"
  echo -n 1 > $errortag

  echo "Create 16MiB delalloc extent in CoW fork"
  xfs_io -c "pwrite 0 4k" $file1 > /dev/null 2>&1

  sync

  echo "Direct I/O write at offset 12k"
  xfs_io -d -c "pwrite 12k 8k" $file1

This commit fixes the bug by invoking xfs_bmapi_write() in a loop until disk
blocks are allocated for atleast the starting file offset of the Direct IO
write range.

Fixes: 3c68d44a2b49 ("xfs: allocate direct I/O COW blocks in iomap_begin")
Reported-and-Root-caused-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
Changelog:
    V1 -> V2:
    1. Add Fixes tag.
    
 fs/xfs/xfs_reflink.c | 225 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 187 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e7a7c00d93be..ab7a39244920 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -340,9 +340,41 @@ xfs_find_trim_cow_extent(
 	return 0;
 }
 
-/* Allocate all CoW reservations covering a range of blocks in a file. */
-int
-xfs_reflink_allocate_cow(
+static int
+xfs_reflink_convert_unwritten(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	struct xfs_bmbt_irec	*cmap,
+	bool			convert_now)
+{
+	xfs_fileoff_t		offset_fsb = imap->br_startoff;
+	xfs_filblks_t		count_fsb = imap->br_blockcount;
+	int			error;
+
+	/*
+	 * cmap might larger than imap due to cowextsize hint.
+	 */
+	xfs_trim_extent(cmap, offset_fsb, count_fsb);
+
+	/*
+	 * COW fork extents are supposed to remain unwritten until we're ready
+	 * to initiate a disk write.  For direct I/O we are going to write the
+	 * data and need the conversion, but for buffered writes we're done.
+	 */
+	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
+		return 0;
+
+	trace_xfs_reflink_convert_cow(ip, cmap);
+
+	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	if (!error)
+		cmap->br_state = XFS_EXT_NORM;
+
+	return error;
+}
+
+static int
+xfs_reflink_alloc_cow_unwritten(
 	struct xfs_inode	*ip,
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
@@ -351,33 +383,17 @@ xfs_reflink_allocate_cow(
 	bool			convert_now)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb = imap->br_startoff;
-	xfs_filblks_t		count_fsb = imap->br_blockcount;
 	struct xfs_trans	*tp;
-	int			nimaps, error = 0;
-	bool			found;
 	xfs_filblks_t		resaligned;
-	xfs_extlen_t		resblks = 0;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	if (!ip->i_cowfp) {
-		ASSERT(!xfs_is_reflink_inode(ip));
-		xfs_ifork_init_cow(ip);
-	}
-
-	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
-	if (error || !*shared)
-		return error;
-	if (found)
-		goto convert;
+	xfs_extlen_t		resblks;
+	int			nimaps;
+	int			error;
+	bool			found;
 
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
-	xfs_iunlock(ip, *lockmode);
-	*lockmode = 0;
-
 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
 			false, &tp);
 	if (error)
@@ -385,17 +401,17 @@ xfs_reflink_allocate_cow(
 
 	*lockmode = XFS_ILOCK_EXCL;
 
-	/*
-	 * Check for an overlapping extent again now that we dropped the ilock.
-	 */
 	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
 	if (error || !*shared)
 		goto out_trans_cancel;
+
 	if (found) {
 		xfs_trans_cancel(tp);
 		goto convert;
 	}
 
+	ASSERT(cmap->br_startoff > imap->br_startoff);
+
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
@@ -415,19 +431,9 @@ xfs_reflink_allocate_cow(
 	 */
 	if (nimaps == 0)
 		return -ENOSPC;
+
 convert:
-	xfs_trim_extent(cmap, offset_fsb, count_fsb);
-	/*
-	 * COW fork extents are supposed to remain unwritten until we're ready
-	 * to initiate a disk write.  For direct I/O we are going to write the
-	 * data and need the conversion, but for buffered writes we're done.
-	 */
-	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
-		return 0;
-	trace_xfs_reflink_convert_cow(ip, cmap);
-	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
-	if (!error)
-		cmap->br_state = XFS_EXT_NORM;
+	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 	return error;
 
 out_trans_cancel:
@@ -435,6 +441,149 @@ xfs_reflink_allocate_cow(
 	return error;
 }
 
+static int
+xfs_replace_delalloc_cow_extent(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	struct xfs_bmbt_irec	*cmap,
+	bool			*shared,
+	uint			*lockmode,
+	bool			convert_now)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			nimaps;
+	int			error;
+	bool			found;
+
+	while (1) {
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0,
+				false, &tp);
+		if (error)
+			return error;
+
+		*lockmode = XFS_ILOCK_EXCL;
+
+		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
+						&found);
+		if (error || !*shared)
+			goto out_trans_cancel;
+
+		if (found) {
+			xfs_trans_cancel(tp);
+			goto convert;
+		}
+
+		ASSERT(isnullstartblock(cmap->br_startblock) ||
+			cmap->br_startblock == DELAYSTARTBLOCK);
+
+		/*
+		 * Replace delalloc reservation with an unwritten extent.
+		 */
+		nimaps = 1;
+		error = xfs_bmapi_write(tp, ip, cmap->br_startoff,
+			cmap->br_blockcount,
+			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
+			&nimaps);
+		if (error)
+			goto out_trans_cancel;
+
+		xfs_inode_set_cowblocks_tag(ip);
+		error = xfs_trans_commit(tp);
+		if (error)
+			return error;
+
+		/*
+		 * Allocation succeeded but the requested range was not even partially
+		 * satisfied?  Bail out!
+		 */
+		if (nimaps == 0)
+			return -ENOSPC;
+
+		if (cmap->br_startoff + cmap->br_blockcount > imap->br_startoff)
+			break;
+
+		xfs_iunlock(ip, *lockmode);
+		*lockmode = 0;
+	}
+
+convert:
+	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+
+/* Allocate all CoW reservations covering a range of blocks in a file. */
+int
+xfs_reflink_allocate_cow(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	struct xfs_bmbt_irec	*cmap,
+	bool			*shared,
+	uint			*lockmode,
+	bool			convert_now)
+{
+	int			error;
+	bool			found;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (!ip->i_cowfp) {
+		ASSERT(!xfs_is_reflink_inode(ip));
+		xfs_ifork_init_cow(ip);
+	}
+
+	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
+	if (error || !*shared)
+		return error;
+
+	/*
+	 * We have to deal with one of the following 2 cases,
+	 * 1. No extent in CoW fork and shared extent in Data fork.
+	 * 2. CoW fork has one of the following:
+	 *    - Unwritten/written extent in CoW fork.
+	 *    - Delalloc extent in CoW fork; An extent may or may not be present
+	 *      in the Data fork.
+	 */
+
+	if (found) {
+		/*
+		 * CoW fork has a real extent; Convert it to written if is an
+		 * unwritten extent.
+		 */
+		error = xfs_reflink_convert_unwritten(ip, imap, cmap,
+				convert_now);
+		return error;
+	}
+
+	xfs_iunlock(ip, *lockmode);
+	*lockmode = 0;
+
+	if (cmap->br_startoff > imap->br_startoff) {
+		/*
+		 * CoW fork does not have an extent. Hence, allocate a real
+		 * extent in the CoW fork.
+		 */
+		error = xfs_reflink_alloc_cow_unwritten(ip, imap, cmap, shared,
+				lockmode, convert_now);
+	} else if (isnullstartblock(cmap->br_startblock) ||
+		cmap->br_startblock == DELAYSTARTBLOCK) {
+		/*
+		 * CoW fork has a delalloc extent. Replace it with a real
+		 * extent.
+		 */
+		error = xfs_replace_delalloc_cow_extent(ip, imap, cmap, shared,
+				lockmode, convert_now);
+	} else {
+		ASSERT(0);
+	}
+
+	return error;
+}
+
 /*
  * Cancel CoW reservations for some block range of an inode.
  *
-- 
2.35.1

