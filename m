Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53F5C35679
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C24DA20675
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBXD6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:58:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgBXD6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:58:16 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3sjso014914;
        Sun, 23 Feb 2020 22:58:02 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb18u7x75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:02 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3skwA015072;
        Sun, 23 Feb 2020 22:58:01 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb18u7x6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:01 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3tMtw008641;
        Mon, 24 Feb 2020 03:58:00 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 2yaux6c9x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:58:00 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3vxLH66126136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:57:59 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9AA26A054;
        Mon, 24 Feb 2020 03:57:58 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28AC66A047;
        Mon, 24 Feb 2020 03:57:56 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:57:55 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 0/7] Fix log reservation calculation for xattr insert operation
Date:   Mon, 24 Feb 2020 09:30:37 +0530
Message-Id: <20200224040044.30923-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1034 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Log space reservation for xattr insert operation can be divided into two
parts,
1. Mount time
   - Inode
   - Superblock for accounting space allocations
   - AGF for accounting space used by count, block number, rmap and refcnt
     btrees.

2. The remaining log space can only be calculated at run time because,
   - A local xattr can be large enough to cause a double split of the dabtree.
   - The value of the xattr can be large enough to be stored in remote
     blocks. The contents of the remote blocks are not logged.

   The log space reservation could be,
   - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
     number of blocks are required if xattr is large enough to cause another
     split of the dabtree path from root to leaf block.
   - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
     entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
     case of a double split of the dabtree path from root to leaf blocks.
   - Space for logging blocks of count, block number, rmap and refcnt btrees.

At present mount time log reservation includes block count required for a
single split of the dabtree. The dabtree block count is also taken into
account by xfs_attr_calc_size().

Also, AGF log space reservation isn't accounted for.

Due to the reasons mentioned above, log reservation calculation for xattr
insert operation gives an incorrect value.

Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.

This patchset aims to fix this log space reservation calcuation bug.

Patches 1-2 and 4-6 refactor the existing code around
xfs_attr_calc_size(). Patches 3 and 7 change the logic to fix log
reservation calculation.

The patchset can also be obtained from
https://github.com/chandanr/linux/tree/xfs-fix-attr-resv-calc-v4.

Changelog:
V1 -> V2:
1. Use convenience variables to reduce indentation of code.

V2 -> V3:
1. Introduce 'struct xfs_attr_set_resv' to collect various block size
   reservations when inserting an xattr.
2. Add xfs_calc_attr_res() to calculate the total log reservation to
   required when inserting an xattr.

V3 -> V4:
1. Rebase the patchset on top of Christoph's "Clean attr interface"
   patchset.
2. Split the patchset into
   - Patches which refactor the existing calculation in
     xfs_attr_calc_size().
   - One patch which fixes the calculation inside
     xfs_attr_calc_size().
3. Fix indentation issues.
4. Pass attribute geometry pointer to xfs_attr_leaf_newentsize()
   instead of a pointer to 'struct xfs_mount'.

Chandan Rajendra (7):
  xfs: Pass xattr name and value length explicitly to
    xfs_attr_leaf_newentsize
  xfs: xfs_attr_calc_size: Use local variables to track individual space
    components
  xfs: xfs_attr_calc_size: Calculate Bmbt blks only once
  xfs: Introduce struct xfs_attr_set_resv
  xfs: xfs_attr_calc_size: Explicitly pass mp, namelen and valuelen args
  xfs: Make xfs_attr_calc_size() non-static
  xfs: Fix log reservation calculation for xattr insert operation

 fs/xfs/libxfs/xfs_attr.c       | 107 ++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h       |  18 ++++++
 fs/xfs/libxfs/xfs_attr_leaf.c  |  39 ++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.h  |   3 +-
 fs/xfs/libxfs/xfs_log_rlimit.c |  16 ++---
 fs/xfs/libxfs/xfs_trans_resv.c |  50 ++++++++-------
 fs/xfs/libxfs/xfs_trans_resv.h |   2 +
 7 files changed, 140 insertions(+), 95 deletions(-)

-- 
2.19.1

