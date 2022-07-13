Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5608CC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 07:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiGMHbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 03:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbiGMHba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 03:31:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E146AE4756
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 00:31:28 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D6mVVd009489
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 07:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wLANzv99iGf/JXjCkGa+RfbdTXoaQ+GGE1PYxXzyqn8=;
 b=F17iB+Jg+D9A1vv6pZeFwfWAtnZfkfTMx8RP829kAD3Q2ZQASB4sMDndAt07OF/1yUsc
 /TBeKPtHV7aN/JR4UUPwRu+m069+Iqc+GVP/BemCPBnWPCVemdlAnKm8vUEvGowLzyGH
 JX8YqPRA9wW0+Hhvfgbe+lzCdqoY9nP+7pF5ILxLCFwh4Bw3R7VSf33ZM2w3srH5X746
 ThXf09yg4Qs4VbcbXVJFTMoWgoCbpJSPuTmPrF3Jjq9iVP2jR89wmx67ZeuzN1jUIClF
 7z7pXcgwGII7fRo3zS4m6Qk9xOGM0CKsfwIXN7rFTtckhbWCZLz2h7wffKC4+VadIXx2 QA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sc9fhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 07:31:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26D7AcxQ001664
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 07:31:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7043x3eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 07:31:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0PPjUY0gyA8lAcGL2R2dLywSVPzpJH1G980586DAft021MrMRm54SutmldqY8SOlyAq4TgWLmCpwOYasxnLc8Zpzf3TBUKaH1AeeJ+E4boPFCbWc39IAkZ67Hcf8+Vz7+HMpTkIdocBrHK09xB2Z3wDM+wuuDZNgE8vRhOLdqySjYY4UNWpCFlo1yNoLWhutvrPqSYFl+wt2fUECzrxCDHhtEVpxgXKh5/6+fxiJjjz30k5HpsCTA7Ln6dc/b5S9ytejrNwWK+42CgpybxrMXw2bjZN2qFzWQSHRuPhOuUib9IQaIAv/Me5PpT2NKtU4pa0ubPWeDoYE9UEZhXPog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLANzv99iGf/JXjCkGa+RfbdTXoaQ+GGE1PYxXzyqn8=;
 b=BPDxOuWMfag+81IUpw7y+ecAlTzZcnsMSJkEZy9/bhKWA6NajcOc0p/3mag0YkWfwQjmXmiEcIo3ZZCPxEKz2QdX3t9QygHQjDa3Rwm1T1OBlbYqAug1pLYLs7VfGtcIm347LAN6oac/sZpEMLlVsUXhnzpWthRtY1gOiXJKYjshky4gWT7gD5kIn+jnj+DMtks7cEesqp7U5srDI6J/Q17t/SjEyIp7j5Vm3PEMSlg5Fqc6zAg74AsE5vtVNQrMZOlrqY11yLJFas+Ly0Tr6HqUr2wf9PqypmeBGhbqVhWAZnm6v93he1w8CBmKKqvZ0BAz/lNo0uuJM7LOqp+yVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLANzv99iGf/JXjCkGa+RfbdTXoaQ+GGE1PYxXzyqn8=;
 b=NeO6piKCrcYgHq4Tg6I40o3cttt5iunfRMXEBF6HGWgfhTcsRX0AzF76NJnLMowA3RyaTWJcOPeUyrSKsduj9EGhUL0sXS9UWq6Nc199xFHwxka+ZUnuriq0TE9dbAw7dse3owmadNT5pW6zmIacMVvi0xQg4x3ssXUK2NZegg0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DS7PR10MB5216.namprd10.prod.outlook.com (2603:10b6:5:38e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 07:31:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::51b6:5d48:a46b:16f9]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::51b6:5d48:a46b:16f9%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 07:31:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Wengang Wang <wen.gang.wang@oracle.com>
Subject: [PATCH] xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
Date:   Wed, 13 Jul 2022 13:00:57 +0530
Message-Id: <20220713073057.1098781-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0029.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:262::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 350a854f-db43-4e1a-76d3-08da64a1b107
X-MS-TrafficTypeDiagnostic: DS7PR10MB5216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cjTyeDt5w6o2wvwfGKtM23wISvW92B7I+rTr8CdgMV1lZ/5OWkZNp3ZS9WIPiP6BYMvTuanf4KZ2hDAAaxzjba/0C7regMe+2B8IYHMcfL3DewmP0eUzhbjrS++ZmOvlm4Wu/0TSD0MMNvyFEVpzrp0joMRWJJjJfYcjZje7i0n62iyW/fMZqJjSWsHYIz4d2AuGbJnqe2yYJbY8ERPuO8KDTQkGSi3//0aM7DKNzY6VyK34Lm1vvwe4kgLYEhVht0qNi63PstMfZ+mZmLgI1OfpP/cP4OPIntTV4yLauaTQ5omZ6bF2psB5//gIXCPTMZMnaRtWR5Vrgpb+RGOTVzs8jDqx9lSXyy4I57IWjVXTa8eWN5mdLrCZY26+CUa3eR5YRVwyUEJMO8609Df21BlHOhbMvK2a79QzE/OyT61xyEIQoSbZchUZdSiepUvzZe6pw9CWn+CuXaeCRWMSen1yjGqirdhNHlN5KF8DNtmiIXc34fXXj3+UGkAPAoZCN5sFOjDp7z1F2KNlg1f7O+97cN4hUI17TCeI+VcOsqq35EAno5B33Fe0j/NXk7Kz1fma5iRI8jutwdsKAbc4bJlQ1QjZlj550WItJW8l+Sa8+X7yaqORgyyvXFqqBBaEm96aeuOAxUsUpgNoTA43KNXHosK6yuYT/fWUy8jgukAOTJY0E5VB1+Tr6ViNas7MHD9jBcug6Kokk6cvXno5Wy5wdFXx6v98QFs21vJQy6ZurAMntUf7ZUMHqSvzvsPbTEmGuLKLPeDPrRDK3h5ZH4ODh1ykAZ57dhi5mzxNiQdlDJ54/bB6HwPFp7I3ix0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(366004)(136003)(376002)(6486002)(66476007)(66946007)(1076003)(66556008)(4326008)(8676002)(186003)(107886003)(54906003)(6916009)(478600001)(2616005)(316002)(83380400001)(6666004)(41300700001)(6512007)(38350700002)(38100700002)(2906002)(8936002)(86362001)(36756003)(5660300002)(6506007)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8+Jrx0FCsOHXQ6ARtfhpRpwsS4uorWDFUDhPOeAtbQ3wtRcp7CFU4+sd7Cbf?=
 =?us-ascii?Q?kOhSCK9EIM5p2P7ml7+LydSaLN1Su1Tve4BJVUr67cHWGPrjLk7yTtBsM2Jb?=
 =?us-ascii?Q?NIHESCeuZvgIkIROBPAPlCWFP3ycpzLAkIm3U7zotVT03Z+Hqp8MkepoLZdS?=
 =?us-ascii?Q?O6in621AB0QOVLN1SZu9hYcCcxSqxj4rGNu+WpKnNcX06UvKKtQl5eYkDMtF?=
 =?us-ascii?Q?EgSoumwXEZhOMX/SCa7njH7T8wnqzBW7o4n1Uyyy8sVn+PZZe15r1USQxcbA?=
 =?us-ascii?Q?w6ctPJx+J1DFsaYHrHg0yN8sZjkv/Kjdvw3ED17tJJOsdf/Wvz5mF7+hjOeQ?=
 =?us-ascii?Q?eNtOjDXx1UXeS0VyH3SKtjrcCF7C7oxCqrHBodBeZ3m91wZfoIM/TP5UNYjZ?=
 =?us-ascii?Q?HqFr0KDiNNKR0/GJ3GrD9eYgHBUxXkpoJnxRuBuRRfdj6zTC6QeA8WBQ0zNV?=
 =?us-ascii?Q?9m6KE5XbqUVwVYMxPr7Oc+NHrvyhl1NVjvFsCSyKTm55/WR1fjYulyqQBy2O?=
 =?us-ascii?Q?5DiyNQpg8xlmdxIjp6+uBGDhSyzja1huUhzHhTclQMlKvaihGMp5o6TpIQ5N?=
 =?us-ascii?Q?h8uzKUSEaZNrFl3ir0DS5BZI+ymwuACDsD62KQfmvHKguonYp0v6D74HWyr6?=
 =?us-ascii?Q?9m7cyuFU5Nu8u2Q7sP2Wz3eI9CHgwDDcrlhLZEEIS+X2YsDgntm2pso652Jb?=
 =?us-ascii?Q?wCFjvmvvd8bJBRMfidES2ytwLWoaPQvq7raWD7UWYDqMVumdq3nu4jrVZIW6?=
 =?us-ascii?Q?uIWn0uf6MIQ4xIwB/0IZaBg4TEwPV+OOqGHcvIg8tif2Tq3upXO8zBpZLkv1?=
 =?us-ascii?Q?C/5spazJjaBlMp2fSqGP5gkVhB3w0Hovh144gK0DPj/4yZcBumLLMEnqAvzg?=
 =?us-ascii?Q?btMhVxMSWqmlSlLQdTVgucwGx2nHPuJYKzPlWCWJrEuU398qiKXxKmdWbV51?=
 =?us-ascii?Q?i3CkSSt7vTRVhaKVPtkToZTgpRePtKmuEQNnUn2qnq0ioffaJoBlSYxY3ypX?=
 =?us-ascii?Q?wBdVee4ryiWNZ8pWvmoe5ofoaT2lGeJ68hi0ctw6dbO17w6vmrC1ljQPzqUk?=
 =?us-ascii?Q?/heroIeRh3ZeI2HAdHFB65gpnNJy8ZiYMgXFrfa/rHCl+cbqXwlqY20v3/Vt?=
 =?us-ascii?Q?cg34n5U+4sO/lko932OieyvJAcxurdK/HgRmacc8Sc6vYjmXCVUznD7ZRfEm?=
 =?us-ascii?Q?pgEvzxlhziDPGQ51sQeVm1Dn89Bg0JLYi4IAH9cvyRAU0ylBv9LSVmciCcgN?=
 =?us-ascii?Q?CXpi9gaZxbibAOOqgP5rlZ0iQfogssZI7wEr2IddSm7RU2Lruv4/HChGr70+?=
 =?us-ascii?Q?B8Ibypv1HQ2c2qFsDhFUnmEjD9mEuc6a/+1lay3AhnpWfVM1lybr+67dk7w0?=
 =?us-ascii?Q?APojVFTq0auYGxJWesa4LRtsNiEsiCekPPeR3cBJdvAsX9Fbu0pWQe8L6QQz?=
 =?us-ascii?Q?aP+20mb62LSIgXIBU1w74SyC8uhX2dhno2U4sVVIk8R6t+9/PJAp1pr1DI1e?=
 =?us-ascii?Q?8O55x46MyJwu04RMXBQ5L09mhfPR0akDJehuE23YVSuO3wpk/CCiDZZUVvVp?=
 =?us-ascii?Q?XsJF6gw2XsZxGVBUYenThwCdUnluK8idxoqScJ09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350a854f-db43-4e1a-76d3-08da64a1b107
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 07:31:25.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6ibKQStWN7aZYwLSCkJ1l5XumxJhjEtoGqwXh4frv+IjGiLFt8oG7nDxXuHGMpNR1Kf0OMLE2otXkGG7KIIwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5216
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-13_01:2022-07-13,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130030
X-Proofpoint-GUID: CXDF2ZIWvrz8bP3F50rL9n4Sbhod6Ext
X-Proofpoint-ORIG-GUID: CXDF2ZIWvrz8bP3F50rL9n4Sbhod6Ext
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

Root-caused-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
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

