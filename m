Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B244C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiFKJmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiFKJmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DFA95AB
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3C236023987
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Oh4Ue8RTzkIM7UvMMpTVe3n9WalJCkUhcAuvfchCRmQ=;
 b=vwL1Wv3L3vDX1WvlwBV534vPb6LhVTBu3cyeqeCpbiOzzjkk1ULRlSPZwV1iGThU0tGY
 a4DAGjdairMtPPXZtAw281bpbt2WrW4GnCfusm01uw6zTejEjMFSnmycLywnPBuyGaAW
 RZOVpZWBE0Vop1UTM/RlvYMkKuUZ8TkkdXNli3csuZsm7/z0hYwrbajtP9KUOItKguDe
 8QiGSKl3QsSlZaCnDV/4QT2kgXk4NWCi8MoH71N8g6AG17qdChV6Qcvb51y4L3w7H0Ka
 P7brXBbAzq9JPjmWftDELG7Wb3A0PdsGyIxMy81ZK1vR93LnHY9WYeJlUMFjXp2uOgA9 yQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx98aky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQ5025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIg0fjCXcJLFyPIjS0prmkEL3XQWliwb2Vt3afjSfJG6Lzvn/9GUQedLF5RD7VwXr1ZAtrb6Pse5thbG/mR+3Iyy4ndRvjdtnWf6BKsQIg6NIX99GXVPyyeW+aLmTJTkwXmLWbSDReJUojn3FT24bxN/N5dfjP0ZSAl37z2wdgGYa1bPs7zOvPrzMufcrO9qz/tgb9lIQWWqTMT+XfFBvbAxL5B19Z22ofKPC0d6yvPcssdVqa/gguPzWGnYc99Ml3nxpEi+tQfQPYkb4Tj8hah0cikDdjxird5s1PHbqbYHbhFUDZ5haMmQtDaOcliVmMoNDsnv9KwwIU3G+BljWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oh4Ue8RTzkIM7UvMMpTVe3n9WalJCkUhcAuvfchCRmQ=;
 b=jhSggk4b2krWqpowD+YZg4dg/gKT5RiU5FEDqXsKVhGN7vXh8HhD6Cbg5HBdxknGiUawCbIIBTxTbGyQSe0WF91gjbl+biXNBwT6+sYwcAohSnRFyMgvPW/Gb8cWQ9YqUpMc5TaWdBHjGp6TdS/52nshxEyb6OwwPJ5zCmgjtqUL1mbJ1zl1BjrGvLq1N/oFUuidg1VzqmMXoOnAaD+ECMt2whDZY5QDywqjJ2isxOdMGQIKzKjPs8tNYbtP27YuFyMAqsDNfGn0adP4q4XwCnLJ461PGZ1ia66qCfEWcwBnl0KVZYIAtbU28oBiUBAkABmRsompqrkicAms/eqDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oh4Ue8RTzkIM7UvMMpTVe3n9WalJCkUhcAuvfchCRmQ=;
 b=PYUxGa/16vAMtW+ts/oAG4JnkAFCsBuuYL/q/2pth/vPmlF9ORKXAqOOyTijGqnVX7pmhiE/k0gNsIf6DedUqszuMvtdV2Ak3LYx+VXkSTEp2YbPKPCqzlnUARz4ijOhilVIMgiQzJqJAbFlWUDPkhG86Wms9qBaC4xllBobxd8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:06 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 00/17] Return of the Parent Pointers
Date:   Sat, 11 Jun 2022 02:41:43 -0700
Message-Id: <20220611094200.129502-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 836f9d46-4f81-44bf-5c51-08da4b8ea585
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606A1AB78BBC850D6B9B44395A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Celw82IMTgFLAV6KqKux20Z1RxyyeFiZZp//dFic7ZhLSDcVEsL9+tFipiQyKQ2Dx/7WWM1sNdX6CdJw+GLd1Vyvaf7cg/CLqsrfD7cVq0ehJYXQX32lPD8plTm1VXSSuXT6Tfo5DwBQAkSR0edV1OxcnBw8q0237Fb+2+hvIaBCW51GqP7BsoE9kcOYlfviJanujbTnSPuSpJ8X+o3THJ/t3MgSdgSHl1pLXSMnJ3OQo3L8KezbAxaLV4G1MPYI3fAeobzzTSjQioE0Pljqk69hWSzTGVowp9R8BynPbRSGG8m2v9+mrzZgNmCZwW2wWKcoQtME2SmoDlCmFIObalj/+Hil0j9vwwhqFbe9km3YxnEnWz3nV1aMbeNpRYsdmLwjrhX9FvJjDNsfIgZ6jotc65funY5XiEtTx3l76SM3LGB8OYSPU037yeHRYZN24Y6PL1dqg5v+tJiF/HVyyqAt8rfIiLplQKgsAKeDqrkwkCVJcy+28kA6yOoLVAxZoL6X2sFK65h77zq/fGjz+ieI/KVO379Mo4sHMlWQ5J0DJhPXJmzE8rVtRo5OXf7gXrZJRQdOnpcInGmS+nAFzIVLM1plXsakSZUFLIBHZoJDS3Xcm7gu48DkMEFKtb9c0GqlGuWGaTLU76hs0dncqBOO1vkvT31Eu/R7AJi63+m9Ec63DN2yrqY8WVzaqhE3hB50Olkk73LotfoVrgektg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zWHT7e7MxYwnDsf84LqM5MkMCjoVadVJX7m7sfTBg95dcsLpGa9vt8zimOXG?=
 =?us-ascii?Q?zUqnKt8i7h9dxvFrNMzaf2wERGAPzg8pnFevVLntPx7unJgpWQAVD+5+jTIG?=
 =?us-ascii?Q?ado4fFNXz2uXiuL/81jeL2vteTPSXggsKiXSW0teB3GgoxnDXoT6c/xnUrZ1?=
 =?us-ascii?Q?OCvmLJhICj/mZJ2k4ViNi3wCYNBI++cI0I+qcD9XeCI7DzFIrFOjdGEJlpel?=
 =?us-ascii?Q?jIg2oF/oxyNxzBEP+bCvH5cd7Pf/pTyymJPyG0pmQyLIQOfXOa0rg0lmt+LZ?=
 =?us-ascii?Q?1GTVtFjR8vzvtNmUIFQH3mc9mQeSH2qOJ00p14qj0Xsczegg5LW3P19O48VD?=
 =?us-ascii?Q?TRgEpog0sFr4ALRarCGmQBoBAxl3Tp3M/0AP576FedypBl5GNPx9nHXwxpx3?=
 =?us-ascii?Q?b7Nn0aqlwenoaMouc3Hhpwp87/B7j9ToQXvYvNWqhEVzidUPdBnYl9DyaA65?=
 =?us-ascii?Q?g6OkwGIneQuwjqD4X5Ewg3WLrsBq8CnaYvkYnmJPdHohy8LfksidDHYH1FQB?=
 =?us-ascii?Q?W/aw3U2cTeHedr0kqI3EL4Ss2QLcI9lYgLh/chFeWELz0c8s+j9sZo5LcyPE?=
 =?us-ascii?Q?bnf3VShOLvSKfnNvgBpSFnBJfgBAqAHVhZdF0JHBfW2XfCFTVg4nIqGJ/5Pb?=
 =?us-ascii?Q?SaK6SbJBrmKMfcpBZnPuPH9j7MYu5GxHdFWLNz8fVaBb2RvWm7MQFlC3Se0t?=
 =?us-ascii?Q?sw8HmNnFmX1ys2KKe38v+xnhIpf1pxdFQlshOScj1DGGxDC5Nxfb4mmSsWcu?=
 =?us-ascii?Q?ir/IOG/dhK92NIPniWbxGyF4gufUktk9xPJ9ZeiGr0oRqzjPYkv9B7YIudhA?=
 =?us-ascii?Q?A7rUANHXMJQtOPGY7OeKxN7pcURMkjyWvgsP7kM2llTRJbGecvUZcrkwUJFc?=
 =?us-ascii?Q?/yR3K2RpPwKT+pnOF3RO7GDIdWAKfJRzb28q7WAUU+Q08uSHHDnT0nNIUDMn?=
 =?us-ascii?Q?naDtg9L6iD/czb8anXKex0gZ34M9XBYvnTIyO7cMjzXE4rhnLny4e9LpnCJg?=
 =?us-ascii?Q?bM8TC6UnoJcn7sgct5nsRgG4xGWaQ0EgwaguDaxoBwmqNE4lNo1TrzEGhvRQ?=
 =?us-ascii?Q?DNWdOjegkUbyLVeFsXk4JLmA8URcPY8ZDOkZu/Uq1d2hPfH3SKV7ACoEj2wG?=
 =?us-ascii?Q?69AzBkyBbT2Quv6nN5+DtAnpYCpG/QY+dUH1Aokmt04Ah3ZE1y2w3x7tj/lE?=
 =?us-ascii?Q?NtMtIkhQjqxdTOW7Fhi/4nwmCGF+HC413xtcMXlENBtDaQ+RV+uYHIgwyxsc?=
 =?us-ascii?Q?oSwRSHvc02okH6SmMN1QjUlnhenfXzSG/kb2yqc1g76TrhUkk40xoof8+Zkw?=
 =?us-ascii?Q?ImmEFnOXvHAMj2psTAXxI6FVEWQEaG1E9V3aRBrumd814Inefs0Ketse3ZEz?=
 =?us-ascii?Q?MR9tCPrm67gSPql5Dt07zFbJNzSdqQ+MuT/V5KOimgl4x/VDCRNEjw1KBJ8U?=
 =?us-ascii?Q?BVAb/+NSQlobiKpqN/NfQ7ywrIjHptAnvGUaINHqGMvNoktp1U+VEN/X6qXU?=
 =?us-ascii?Q?WvdxoRSsIA6uLELH92B+YfSO6+eFoW+rba7uQBEvDfZVZgMbdUkEbMwVJ2mq?=
 =?us-ascii?Q?mHxTyvlFtKsrzmJmOu3I/XqozKEq8mnSTTpYzP61dcGiXaw0c3KF5PQL99RL?=
 =?us-ascii?Q?WCoJyZlhtQGd+QjrcuR9uCqbYqTcV6ehNmhoxm825Gwdry5G7J9OfsDqd9UE?=
 =?us-ascii?Q?bxMDpFuKIFhwZK9/LB3T9Srq0W5XT4iKVP6EHEImC83ofai00rVXN84vrsA0?=
 =?us-ascii?Q?F0Alj+4rHvjwUBcqAgHIpPykpxAY1AA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 836f9d46-4f81-44bf-5c51-08da4b8ea585
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:06.1859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +GhoBqbURlIvwn40k4KLRBGnIlvx4HfOhcq8fmZxF6dn93di17jmd5lRyRfJE8a9M90+8Rz6jL5nsDUMWiEJQQhfqXVX1Dqlk5mB9WYg+II=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-ORIG-GUID: ASET3AvfOK322h6oD9_X2TcofcCVwffU
X-Proofpoint-GUID: ASET3AvfOK322h6oD9_X2TcofcCVwffU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the latest rebase of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  

It's been quite a while since we've seen parent pointers, so I think I'm just
going to start the versioning back at 1 rather than continue as v30 of the
giant extended set.

Questions comments and feedback appreciated!

Thanks all!
Allison

Allison Henderson (17):
  xfs: Add larp state XFS_DAS_CREATE_FORK
  xfs: Hold inode locks in xfs_ialloc
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer xattr format
  xfs: Add xfs_verify_pptr
  xfs: extent transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: remove parent pointers in unlink
  xfs: Add parent pointers to rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
  xfs: Add parent pointer ioctl

 fs/xfs/Makefile                |   2 +
 fs/xfs/libxfs/xfs_attr.c       |  73 ++++++-
 fs/xfs/libxfs/xfs_attr.h       |   7 +-
 fs/xfs/libxfs/xfs_bmap.c       |   2 +-
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_da_btree.h   |   1 +
 fs/xfs/libxfs/xfs_da_format.h  |  30 ++-
 fs/xfs/libxfs/xfs_defer.h      |   2 +-
 fs/xfs/libxfs/xfs_dir2.c       |  21 +-
 fs/xfs/libxfs/xfs_dir2.h       |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_format.h     |  17 +-
 fs/xfs/libxfs/xfs_fs.h         |  47 ++++
 fs/xfs/libxfs/xfs_log_format.h |   1 +
 fs/xfs/libxfs/xfs_parent.c     |  87 ++++++++
 fs/xfs/libxfs/xfs_parent.h     |  33 +++
 fs/xfs/libxfs/xfs_sb.c         |   2 +
 fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++--
 fs/xfs/libxfs/xfs_trans_resv.h |   1 +
 fs/xfs/scrub/attr.c            |   2 +-
 fs/xfs/xfs_attr_item.c         |  10 +-
 fs/xfs/xfs_attr_list.c         |  17 +-
 fs/xfs/xfs_file.c              |   1 +
 fs/xfs/xfs_inode.c             | 380 ++++++++++++++++++++++++---------
 fs/xfs/xfs_ioctl.c             | 144 +++++++++++--
 fs/xfs/xfs_ioctl.h             |   2 +
 fs/xfs/xfs_ondisk.h            |   4 +
 fs/xfs/xfs_parent_utils.c      | 133 ++++++++++++
 fs/xfs/xfs_parent_utils.h      |  22 ++
 fs/xfs/xfs_qm.c                |   4 +-
 fs/xfs/xfs_super.c             |   4 +
 fs/xfs/xfs_symlink.c           |   6 +-
 fs/xfs/xfs_trans.c             |   7 +-
 fs/xfs/xfs_trans.h             |   2 +-
 fs/xfs/xfs_xattr.c             |   2 +-
 fs/xfs/xfs_xattr.h             |   1 +
 39 files changed, 1029 insertions(+), 180 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

