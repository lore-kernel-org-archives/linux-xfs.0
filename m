Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AB5C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3769A23C8F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 17:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgLIRzj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:55:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgLIRzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 12:55:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HnLFp181499
        for <linux-xfs@vger.kernel.org>; Wed, 9 Dec 2020 17:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=MRGVW4v3wu+srA5eCxpbrmJLFvpSbrkiTEHop2lMGtM=;
 b=AhHps+gvf7gr0C8eOyCAcDoAPoKGQ5e1JudNnyklF4lDfdy88WD4PF/wzM2yD7dNAttO
 mNpjZS9jDZRe1B02LdRKzMcElirZMeQMHVTP+wWyikkkaJ1UqIem00c1G8JvY2EY2dty
 AAbQ5CKSAbuw4pcLN+omBqcCXaMWgRhDV2OF8m3xggCJkcJfrMFQ1FzFxlaIinP2oZZR
 dXlKmBxGR4b2yy8RKZYOMWp3OSecHDnh8MUW3TEIc0etHa7AbQ+BVwcALV0ytMY5oCJl
 ry+MPoXH8S1QoQmqSFR9EDi2DSnjnA/mYx4heT+P+llXKufSEBvfl8+MHbcbwfvbJYkg TQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m9hr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 17:54:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HokMk035355
        for <linux-xfs@vger.kernel.org>; Wed, 9 Dec 2020 17:54:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kyv1seq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 17:54:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HsvLa008584
        for <linux-xfs@vger.kernel.org>; Wed, 9 Dec 2020 17:54:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:54:56 -0800
Date:   Wed, 9 Dec 2020 09:54:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 207ddc0ef4f4
Message-ID: <20201209175455.GJ1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=7 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=7 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Though really, this is the last day to merge things
for for-next before the merge window opens, so please, bug fixes only.
I'll probably slip in Gao's refactoring tomorrow since I /think/ the
only thing different is a comment??

The new head of the for-next branch is commit:

207ddc0ef4f4 xfs: don't catch dax+reflink inodes as corruption in verifier

New Commits:

Darrick J. Wong (21):
      [3945ae03d822] xfs: move kernel-specific superblock validation out of libxfs
      [80c720b8eb1c] xfs: define a new "needrepair" feature
      [96f65bad7c31] xfs: enable the needsrepair feature
      [bc525cf455da] xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover
      [67d8679bd391] xfs: improve the code that checks recovered bmap intent items
      [dda7ba65bf03] xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover
      [c447ad62dc90] xfs: improve the code that checks recovered rmap intent items
      [ed64f8343aaf] xfs: hoist recovered refcount intent checks out of xfs_cui_item_recover
      [0d79781a1aa6] xfs: improve the code that checks recovered refcount intent items
      [3c15df3de0e2] xfs: hoist recovered extent-free intent checks out of xfs_efi_item_recover
      [7396c7fbe07e] xfs: improve the code that checks recovered extent-free intent items
      [da5de110296c] xfs: validate feature support when recovering rmap/refcount intents
      [6337032689fa] xfs: trace log intent item recovery failures
      [acf104c2331c] xfs: detect overflows in bmbt records
      [da531cc46ef1] xfs: fix parent pointer scrubber bailing out on unallocated inodes
      [4b80ac64450f] xfs: scrub should mark a directory corrupt if any entries cannot be iget'd
      [67457eb0d225] xfs: refactor data device extent validation
      [18695ad42514] xfs: refactor realtime volume extent validation
      [33005fd0a537] xfs: refactor file range validation
      [1e5c39dfd3a4] xfs: rename xfs_fc_* back to xfs_fs_*
      [a5336d6bb2d0] xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks

Eric Sandeen (1):
      [207ddc0ef4f4] xfs: don't catch dax+reflink inodes as corruption in verifier

Gao Xiang (1):
      [7bc1fea9d36c] xfs: introduce xfs_validate_stripe_geometry()

Joseph Qi (1):
      [2e984badbcc0] xfs: remove unneeded return value check for *init_cursor()

Kaixu Xia (6):
      [a9382fa9a9ff] xfs: delete duplicated tp->t_dqinfo null check and allocation
      [04a58620a17c] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
      [b3b29cd1069c] xfs: directly return if the delta equal to zero
      [88269b880a8e] xfs: remove unnecessary null check in xfs_generic_create
      [afbd914776db] xfs: remove the unused XFS_B_FSB_OFFSET macro
      [237d7887ae72] xfs: show the proper user quota options


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c         |  22 +++------
 fs/xfs/libxfs/xfs_bmap_btree.c   |   2 -
 fs/xfs/libxfs/xfs_format.h       |  11 ++++-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   5 --
 fs/xfs/libxfs/xfs_inode_buf.c    |   4 --
 fs/xfs/libxfs/xfs_refcount.c     |   9 ----
 fs/xfs/libxfs/xfs_rmap.c         |   9 ----
 fs/xfs/libxfs/xfs_sb.c           | 104 +++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_sb.h           |   3 ++
 fs/xfs/libxfs/xfs_shared.h       |   1 -
 fs/xfs/libxfs/xfs_types.c        |  64 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h        |   7 +++
 fs/xfs/scrub/agheader_repair.c   |   2 -
 fs/xfs/scrub/bmap.c              |  22 +++------
 fs/xfs/scrub/common.c            |  14 ------
 fs/xfs/scrub/dir.c               |  21 ++++++--
 fs/xfs/scrub/inode.c             |   4 --
 fs/xfs/scrub/parent.c            |  10 ++--
 fs/xfs/scrub/rtbitmap.c          |   4 +-
 fs/xfs/xfs_bmap_item.c           |  65 ++++++++++++++----------
 fs/xfs/xfs_extfree_item.c        |  23 ++++++---
 fs/xfs/xfs_inode.c               |  10 +---
 fs/xfs/xfs_iops.c                |   6 +--
 fs/xfs/xfs_iwalk.c               |   2 +-
 fs/xfs/xfs_log_recover.c         |   5 +-
 fs/xfs/xfs_refcount_item.c       |  52 ++++++++++++--------
 fs/xfs/xfs_rmap_item.c           |  67 +++++++++++++++----------
 fs/xfs/xfs_super.c               |  77 ++++++++++++++++++++++-------
 fs/xfs/xfs_trace.h               |  18 +++++++
 fs/xfs/xfs_trans_dquot.c         |  43 +++++-----------
 30 files changed, 410 insertions(+), 276 deletions(-)
