Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A349CC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 18:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7240222240
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 18:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389286AbgLLS7D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Dec 2020 13:59:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45454 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407741AbgLLS7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Dec 2020 13:59:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BCItpXG023539
        for <linux-xfs@vger.kernel.org>; Sat, 12 Dec 2020 18:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=FsXVW0ECJ1oE6j7Tirq1hzSPlDi53fxbY2UmojGQMg8=;
 b=nRjv6yM6eaU52ly2kOH0P+iGvEcL9e+gE6rRS5YzvN0DWW25nVt5D4c6a1o/4WVLsVe3
 yhb0bVqOrYQ+MgKsUcZAslOZf7J/fO4AfMIkd2oLOLFpH/wLeJ2yvXJ/P4Gni+bgGhPW
 mb6cd4NsBYon+UzDZadLGQ1AGWaC+x4th10LEFp2Lut3TEovQGYIWr7eicLWQgj7Yz5D
 TofBEZwAVwErA9/o1jI0Z4+b/Igeknr1uAV8j/BzRakBE/fWu5q5t4pUeRn1gH4FTm6U
 l+eMStPTFDyTNrAqJshw4maa3njshZMNZEGPCkzDfXP6FVucn/27V2GW6qPpq4Miz5NF bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcb1b4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 12 Dec 2020 18:58:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BCIssTn021168
        for <linux-xfs@vger.kernel.org>; Sat, 12 Dec 2020 18:58:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35cn6ha7c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 12 Dec 2020 18:58:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BCIwEbg006518
        for <linux-xfs@vger.kernel.org>; Sat, 12 Dec 2020 18:58:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 10:58:14 -0800
Date:   Sat, 12 Dec 2020 10:58:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 1189686e5440
Message-ID: <20201212185815.GQ1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012120148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012120148
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
the next update.  This pulls in the cleanups for dialloc and a few other
things, so we're done with new stuff for 5.11.

Anyone with new code, please have it ready for review /before/ 5.11-rc4.
The trickle of "new" refactorings that show up after -rc6 adds to my
pre-merge-window stress and I'm not going to be as willing to accept
those in 2021.

The new head of the for-next branch is commit:

1189686e5440 fs/xfs: convert comma to semicolon

New Commits:

Christoph Hellwig (2):
      [26f88363ec78] xfs: remove xfs_vn_setattr_nonsize
      [5d24ec4c7d3c] xfs: open code updating i_mode in xfs_set_acl

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

Dave Chinner (4):
      [aececc9f8dec] xfs: introduce xfs_dialloc_roll()
      [1abcf261016e] xfs: move on-disk inode allocation out of xfs_ialloc()
      [f3bf6e0f1196] xfs: move xfs_dialloc_roll() into xfs_dialloc()
      [8d822dc38ad7] xfs: spilt xfs_dialloc() into 2 functions

Eric Sandeen (1):
      [207ddc0ef4f4] xfs: don't catch dax+reflink inodes as corruption in verifier

Gao Xiang (3):
      [7bc1fea9d36c] xfs: introduce xfs_validate_stripe_geometry()
      [15574ebbff26] xfs: convert noroom, okalloc in xfs_dialloc() to bool
      [3937493c5025] xfs: kill ialloced in xfs_dialloc()

Joseph Qi (1):
      [2e984badbcc0] xfs: remove unneeded return value check for *init_cursor()

Kaixu Xia (6):
      [a9382fa9a9ff] xfs: delete duplicated tp->t_dqinfo null check and allocation
      [04a58620a17c] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
      [b3b29cd1069c] xfs: directly return if the delta equal to zero
      [88269b880a8e] xfs: remove unnecessary null check in xfs_generic_create
      [afbd914776db] xfs: remove the unused XFS_B_FSB_OFFSET macro
      [237d7887ae72] xfs: show the proper user quota options

Zheng Yongjun (1):
      [1189686e5440] fs/xfs: convert comma to semicolon


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c         |  22 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c   |   2 -
 fs/xfs/libxfs/xfs_btree.c        |   2 +-
 fs/xfs/libxfs/xfs_format.h       |  11 +-
 fs/xfs/libxfs/xfs_ialloc.c       | 166 +++++++++++++-------------
 fs/xfs/libxfs/xfs_ialloc.h       |  36 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.c |   5 -
 fs/xfs/libxfs/xfs_inode_buf.c    |   4 -
 fs/xfs/libxfs/xfs_refcount.c     |   9 --
 fs/xfs/libxfs/xfs_rmap.c         |   9 --
 fs/xfs/libxfs/xfs_sb.c           | 104 +++++++++++------
 fs/xfs/libxfs/xfs_sb.h           |   3 +
 fs/xfs/libxfs/xfs_shared.h       |   1 -
 fs/xfs/libxfs/xfs_types.c        |  64 +++++++++++
 fs/xfs/libxfs/xfs_types.h        |   7 ++
 fs/xfs/scrub/agheader_repair.c   |   2 -
 fs/xfs/scrub/bmap.c              |  22 +---
 fs/xfs/scrub/common.c            |  14 ---
 fs/xfs/scrub/dir.c               |  21 +++-
 fs/xfs/scrub/inode.c             |   4 -
 fs/xfs/scrub/parent.c            |  10 +-
 fs/xfs/scrub/rtbitmap.c          |   4 +-
 fs/xfs/xfs_acl.c                 |  40 ++++---
 fs/xfs/xfs_bmap_item.c           |  65 ++++++-----
 fs/xfs/xfs_extfree_item.c        |  23 ++--
 fs/xfs/xfs_inode.c               | 243 +++++++++------------------------------
 fs/xfs/xfs_inode.h               |   6 +-
 fs/xfs/xfs_iops.c                |  41 +++----
 fs/xfs/xfs_iops.h                |   8 --
 fs/xfs/xfs_iwalk.c               |   2 +-
 fs/xfs/xfs_log_recover.c         |   5 +-
 fs/xfs/xfs_qm.c                  |  26 ++---
 fs/xfs/xfs_refcount_item.c       |  52 +++++----
 fs/xfs/xfs_rmap_item.c           |  67 +++++++----
 fs/xfs/xfs_super.c               |  77 ++++++++++---
 fs/xfs/xfs_trace.h               |  18 +++
 fs/xfs/xfs_trans_dquot.c         |  43 ++-----
 37 files changed, 614 insertions(+), 624 deletions(-)
