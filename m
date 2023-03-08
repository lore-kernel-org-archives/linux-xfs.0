Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC9CC6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCHWiS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCHWiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E332917E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:10 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwo4Q020813
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=JDJXi73maJu33KCHvW/GLFsjAXAO3XLjG385twvdFTo=;
 b=tV89JiZDwd9Uxo+8kuSVprR9mm1Q/LhL4hy2KKtBvKUW9uyIRiLDhCTJvfousbKfqj4o
 C/dIwa/CRpVLUP29TINNEmyLgzC6V2TtbgKHjvkosJ7T2yUjKOE51vZsuBWwC5hFmPgF
 FoUOKgXrtwgbg1HhSrsTX5EBcX6SRXsJh277iTZXyglBhavSYAQayt/U/Mi/5ywQ+v33
 x6CCiIRsybDPmOGTCIfV0+5Ei2DOFQm/nEpFQRQH/p7oRREYXyqYkduuctzov1KI6aWP
 P77FP6SWIRt4P4dsF4yneOf3qp9/cTSdCrwmM7CKsO2r7CGMpRLeYr47Eaj+N5Gj258C 2w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41811a27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MAF4f036499
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464w1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ve4h0/I0/NgKlk85qR5sEwqo8Xe5kp3G2LZbJpbKb5SRVHmuWNrIuyvdH57Dpxc8aAmJI1g8uGTtGBWLDa/BoFU6Y3u8AbGnS8XMI6bPdtIYPxohB8NqwbY2CanPEPzIl0W2rWTuNoOMs73z8jry9R5rVoeRYims6DziTtZfWVWBVUvUjaelQhaGDjmK66/BpO/Nt1FrO2rHkgO36HtUNgAt04DiU9fbN1I/tuAq85C9uCDrn8witzdFva2pjyWV8g1htPlRqV0luI1aldOJWE++2idSiwLEAkWxr8ggW6uevlT+qbRt8FnriRBf5Rc6VWQdJ9Iu85bgsXuSt5F+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDJXi73maJu33KCHvW/GLFsjAXAO3XLjG385twvdFTo=;
 b=hhZ02xwNy/s6bZUthqfj0qo4H35i39WYjWPHFBZxQPPyAiDDPFI0u5TvCo/6GTdyQ90X8YsInZPamGbF7rCvFC5UZtTXlGs+G2nw0iH69wEJkcp7OFDsX76XwDjgiO1CtOE60q2ksG2mlTG8zb39Nl/gkSbynWd4Hz3iua+nUF/o0oAPyrO/fuu4TRbdG7vgkG2CaCMHLbWWyBJK2MR+E927q3VxkCVu2VQb9BtWLq1jMV4k4ZOlfC3AXYbPta36388FxY1mVelPV+2ol7hkYUT3kM+wncS5qkzLF2gBW1uQJsy/GkDyEEmMR61u/gsIFCPTzpAfiP9LH26EnZTbEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDJXi73maJu33KCHvW/GLFsjAXAO3XLjG385twvdFTo=;
 b=QpFaL6+O9JxijUk7mztDQg9+OPs3Zsce/Dp6p6EHbZthodSSz+cbG7euApG043DA6xcFmEeapbu5yt/RmUoVh92fMVqcv81Z3cLr4y9HI2VALpkQp+mPo/hUNExnJAJRX3f1bX3BNR3KTyz6erAsaRMWFvwl1on1p0k3jMXPhDE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:37:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:37:56 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 00/32] Parent Pointers
Date:   Wed,  8 Mar 2023 15:37:22 -0700
Message-Id: <20230308223754.1455051-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 33692eab-a3d2-4418-6e3b-08db2025c350
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6R/+5z3ZWCKzmlI/9wlsGe384zvBrG7k7bklJLPjksoTIAT/j4K2Mdx5CvfTlZuq+pcioLuXN5CjiLiXglxl2evv03J/H9g3nFOcYMRKRewYpDZR5YK66CpevwzM296B4d/Gj4FVFA+X4n5hv0YC8QFg8f46WTi8NtcLks1hKlucCA2fPNMcjNelR07fqGbi9fRC+POqzKtxJ/BmV4quTf8KZLmAkUciF0zYJrArzBimMYXsWpw54lGpeA2VJJfyILJPdvJ5vMjs66S4TNt35eWb/JgZMp4bKVJRlI+MJAbfrdsMnqi8xL6HI6O6hHJ16wCJRUYvYJBoJsoCxvg+zxY2qWgtoHg/zSE+yIkMa4nuKvMinR7ibg2MPmhOYDjjjDzGWg5agvRg91KTTWMTN6YXtw9N0WL9OSrjk1Wpw3Uca8O4p+2Y5UoiH9qo42HxJZgqpVtg5WR17ImWSa78Cqdytj8VN4i0MFPwdrP5rvPHSxtAUhVGGQBFe72qrxBl3L2q4/rxu9StlI8A35yvn0u1KsRUOzSVG3otcCHQzFzVHMZe3JQnKFIvqMlBpKrzUFMbsrToLkRdpmV+3sphMkHgwhKoVtZ3Kn/sIxSJ8NNquB/0ApU+ePPkZh3WiZWy2PUPsNpAmFiL1B8XGdpG5T8KIElLYnqY8QLn50Sr9CU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(966005)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q370aJBjg82v9rEt6RqQMiYyC2/o+dV78rwSQpfRRaM6htJc1VyVMcs5HN/O?=
 =?us-ascii?Q?w6DDg6u/RhX/bguWN32Y29Ot+uNHXOvRnVhHGoTCPxSUwPcFlmqPKOTYhPAi?=
 =?us-ascii?Q?io6j97M6P9PMbUhi2Ac3b+OyBOwG8geZ2JroYYbuLlTENYjxiG4N5BZpI8Zw?=
 =?us-ascii?Q?Zge168FNOn0j2LvnaVLk9Niy1ngMEVKyLQGr3RID8ZwZsOtX4bLae8nwqLo7?=
 =?us-ascii?Q?6NkeB2POj85NTGdvbjR7PcgGygW8pD0ZyK7Lj/uClXlBK5+5ild78WhK4d+v?=
 =?us-ascii?Q?lJz+puULEYG67KitA51HNeNsHwgqYGcBWaVED92ra2UuCpqtKJ2cT6V9rVcn?=
 =?us-ascii?Q?XTY5mm5QRnJFWAuCzMCsvMNSJMmfMzwiFIuEKsjYA+KgEQrHqbyq5bcn6XaP?=
 =?us-ascii?Q?3L0JagXkGJkiDhdrZV4rVVjzgUSbb5VQNSBE+MjQimd4zx+h9CMJ/JX/33dR?=
 =?us-ascii?Q?7dEM9npLhAdPh8ggECGskODWhtG7lnR4zVSl38H+BpNRvG1kqtOqrOzGr6nu?=
 =?us-ascii?Q?wc59oKoHkC1SgpCp0j1cIInUe4dOtWyJQ4Pqr0YAZbnN4hPCyZ00qn1QSxbF?=
 =?us-ascii?Q?uCxTCoglYI57sayDf3ARi1UPtxyfcMJ16f10eijSX2A5kUiGmnmIKO9O1VBz?=
 =?us-ascii?Q?dqPj8sJd1ckmZO9vdZR7EM0M3CCsUStCBVo3hXh1bVBdQsqXJjpiq7MNzVLx?=
 =?us-ascii?Q?ttjI5JoiUNM+pDAYSQc2DgMtv61Wf3crrZUn4wA6CxcPoZ19HPzf4cTHXwa1?=
 =?us-ascii?Q?z1JC/ToNsom8/7tj2irO9Ljj1C8k4G2glZj7uSuHKgTpI16sAx5uWHaR07n1?=
 =?us-ascii?Q?Y7RTeEYFolDUThpgR1OuLfiYiK+DbLdiq5Zypk5qMqQg8fI+0rT1orl+I73f?=
 =?us-ascii?Q?ftNgkm9nRTpIm3OHHpM8XFzGdtDzuAC9Gb/bZ/sSU+1tDBp9lI5dy642tJCW?=
 =?us-ascii?Q?hUFmaTBNI/vSyRcbit3UYVT38w3N/J+Ymr/0kSGentrnUuYhOIfXvY7g+nqq?=
 =?us-ascii?Q?eeqFg4QU5WtMMo0IfOylshTcGsb/C+d/ns9n1v7E5BX5HbXJDd7PdveHv+h9?=
 =?us-ascii?Q?fhKc9KKQ/5/G355v22vxbEe56yVXceHljPcUZDcn4w9cP/xPXs4Vc1BGYmzU?=
 =?us-ascii?Q?F3BmLsAxjRutbTnUi2XU7SpXoBz19valGAMgzxdKPxlqA/Btpp/+X7xfnsEG?=
 =?us-ascii?Q?nXGddjyBupkucRkrxLFok2jMKLsm8jqCW3/EaIV/Ul73gR2Iejd2dRJaMujl?=
 =?us-ascii?Q?LNbyKuHn5LdWp6hiGq6fyKmvdR7FTrX+7xH2XtlPgcyLLX/MD8EUi28v3Yek?=
 =?us-ascii?Q?+1rvH54rOqy8Km5CfWfJEYhBE+Pi/G+TbI32IMDx3sEaSixSjJQxcsfMxojq?=
 =?us-ascii?Q?IUZlCInIyfPwTaUFoxyyAk6iXv511KRNFOzQ42y03XfNQRu6Js2opCgQ7u8k?=
 =?us-ascii?Q?YThDQdxtlB7Dtga0OP6LC/XLnljMY4sEg6I7MowPZrKfVss2hICviqL5T9i7?=
 =?us-ascii?Q?C3bv/p6f7SvlV/9ed3ztVJvxzuPQho+HHoBZsrKFYScb1E9c0yKAc7mqFSxO?=
 =?us-ascii?Q?y+kaOcCwBL7gZhd6o2B+Fj6aNmuNvU4E0mB92FWBJomzQ2LFKxMNqe4noz+w?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0UICgDa558EQ3LGNNBmc64UXPrEF8sv4logvK/oEqGcgaJ5sJSHxBEinHp0ToPWaYvFq3RWpyzduL5YIhUPu0RQ2QPOo1iUdkLALkIHACYpFBeUTuM6aSb19IR/UlaNr7aDCQoa1HRypdlitHfcpvtTaGzliR6ehmGL7zq1Pget/GEEuwmThf7f8zH+JmaH2YCJ45VM9uesy49xBk9RPJIhcm70xo94Kbi9SbBZ9IECj3ukeqNeOkOtr1nvM19YgKZKWK6tqjVPFL4IQ/PqCIRR4gxWLJeACZ/2gTW4x2zmvzjAwlpvYUgjWg3baJ0kAnoYfLrx1eat41NRgXuN6ExlkC7AsBIiRLPKGcUYbMX2ht3cQUENst/D+oUm7moiJhNEhx8XJBFS2+zgjD+UJHkD07P8E5PecxAc9Kjl2qAUFVp56SHBvE9+O9w7DsijtW3U08GV+V1TVkkL1YXwM1F/dww+QBbavfT6LgtqqrOnQFvo4wLcnP7jH36zIWw7mLDoDPvjGAmMMp1HedJWv3fT3kEJsO71ZS626aqZLoHJRjZ4WY/pj0WQR7I7CwTEvQ7HlOSLl66mQF+D2LraWEK367YgvxYgN5x9w0ygFhEa/FAYbONGeMiZDY8fSPpD3nFB0G1YVC/PbYyrNO/U9NRLbevmggDbi4knCjQX41nUcb1zwsHHfWlNnRXEvNP2gxwccByPOeLKzqadViVONKJAAe+yJHG3Q6t1jkP5Cks48AciArWNxS+e++ba497bddnOmdA8LFJgeQQ6dkOiykw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33692eab-a3d2-4418-6e3b-08db2025c350
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:37:56.7638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epNTjSNwq66izrWCmwgt1VeQEiH0HWmgLhMKwF7mfnyViDTcfCyseg3DLDWJ04bBkVqiQ2H15ZBrCnpyMqWzWAp8sA/aSoJceLozgiwRxXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-ORIG-GUID: _q4B4aS5nb7uTpOoHGF0TyQAfJhvpWnB
X-Proofpoint-GUID: _q4B4aS5nb7uTpOoHGF0TyQAfJhvpWnB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, shrink, nfs handles, verity, or
any other feature that could make use of quickly deriving an inodes path from
the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv10

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v10

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v9:

Reordered patches 2 and 3 to be 6 and 7

xfs: Add xfs_verify_pptr
   moved parent pointer validators to xfs_parent

xfs: Add parent pointer ioctl
   Extra validation checks for fs id
   added missing release for the inode
   use GFP_KERNEL flags for malloc/realloc
   reworked ioctl to use pptr listenty and flex array

NEW
   xfs: don't remove the attr fork when parent pointers are enabled

NEW
   directory lookups should return diroffsets too

NEW
   xfs: move/add parent pointer validators to xfs_parent

Questions comments and feedback appreciated!

Thanks all!
Allison

Allison Henderson (32):
  xfs: Add new name to attri/d
  xfs: Hold inode locks in xfs_ialloc
  xfs: Hold inode locks in xfs_trans_alloc_dir
  xfs: Hold inode locks in xfs_rename
  xfs: Expose init_xattrs in xfs_create_tmpfile
  xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  xfs: Increase XFS_QM_TRANS_MAXDQS to 5
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer xattr format
  xfs: Add xfs_verify_pptr
  xfs: extend transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: add parent attributes to symlink
  xfs: remove parent pointers in unlink
  xfs: Indent xfs_rename
  xfs: Add parent pointers to rename
  xfs: Add parent pointers to xfs_cross_rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Filter XFS_ATTR_PARENT for getfattr
  xfs: pass the attr value to put_listent when possible
  xfs: Add parent pointer ioctl
  xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
  xfs: drop compatibility minimum log size computations for reflink
  xfs: add xfs_trans_mod_sb tracing
  xfs: move/add parent pointer validators to xfs_parent
  xfs: directory lookups should return diroffsets too
  xfs: don't remove the attr fork when parent pointers are enabled

 fs/xfs/Makefile                 |   2 +
 fs/xfs/libxfs/xfs_attr.c        |  34 ++-
 fs/xfs/libxfs/xfs_attr.h        |  18 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   6 +-
 fs/xfs/libxfs/xfs_attr_sf.h     |   1 +
 fs/xfs/libxfs/xfs_da_btree.h    |   3 +
 fs/xfs/libxfs/xfs_da_format.h   |  26 +-
 fs/xfs/libxfs/xfs_defer.c       |  28 +-
 fs/xfs/libxfs/xfs_defer.h       |   8 +-
 fs/xfs/libxfs/xfs_dir2.c        |  21 +-
 fs/xfs/libxfs/xfs_dir2.h        |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |  11 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |  10 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |  10 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |  10 +
 fs/xfs/libxfs/xfs_format.h      |   4 +-
 fs/xfs/libxfs/xfs_fs.h          |  71 +++++
 fs/xfs/libxfs/xfs_log_format.h  |   7 +-
 fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
 fs/xfs/libxfs/xfs_parent.c      | 267 +++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      | 108 ++++++++
 fs/xfs/libxfs/xfs_sb.c          |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c  | 324 +++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_space.h |   8 -
 fs/xfs/scrub/attr.c             |  12 +-
 fs/xfs/xfs_attr_item.c          | 142 ++++++++--
 fs/xfs/xfs_attr_item.h          |   1 +
 fs/xfs/xfs_attr_list.c          |  25 +-
 fs/xfs/xfs_dquot.c              |  38 +++
 fs/xfs/xfs_dquot.h              |   1 +
 fs/xfs/xfs_file.c               |   1 +
 fs/xfs/xfs_inode.c              | 447 +++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h              |   3 +-
 fs/xfs/xfs_ioctl.c              | 190 ++++++++++++--
 fs/xfs/xfs_ioctl.h              |   2 +
 fs/xfs/xfs_iops.c               |   2 +-
 fs/xfs/xfs_ondisk.h             |   4 +
 fs/xfs/xfs_parent_utils.c       | 154 +++++++++++
 fs/xfs/xfs_parent_utils.h       |  20 ++
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_qm.h                 |   2 +-
 fs/xfs/xfs_super.c              |  14 +
 fs/xfs/xfs_symlink.c            |  58 ++++-
 fs/xfs/xfs_trans.c              |  13 +-
 fs/xfs/xfs_trans_dquot.c        |  15 +-
 fs/xfs/xfs_xattr.c              |   8 +-
 fs/xfs/xfs_xattr.h              |   2 +
 47 files changed, 1942 insertions(+), 257 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

