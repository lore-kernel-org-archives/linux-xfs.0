Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBD0C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E6821941
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:20:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qxyYI7BI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgIPUUD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:20:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48944 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgIPUT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 16:19:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GGOk6i051386
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 16:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=lMfgt0LgO8i9k+t7+chPj8qq4fEJmAicBkD+zMhl3xk=;
 b=qxyYI7BIT+SX7OZz0c9xHumudjrR/5jU9ZrWAUf40boCV5ZUjylkcdc6cv/kElc+/z7Q
 j/OUPY0cDYmCtQXgSUsKfUYZ590ah+jMrAVKQjeWIdtKZ3bSDWOETyaQAEFahH4tONNL
 JNRGJNStBCqMpxDRuAzAI0EliYBzMi+SSEWwggZ6JKl7Y9OjlqX2yZPffd+po8+4oGkF
 3FRYyngLaQ5xkI1DTDCx6RcokNQeeqUdH6jMm9luU+I7nVaeoijqZL3P21pgqf2tXs0C
 7+cFeEQpq5ppkYLv1DBWN+rl8Maw03bTIjJsWw6eAvxA8TaX3eTbFa+HsLRInQrTaNih 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dntk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 16:30:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GGQ1kX007761
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 16:30:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33khpkpspy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 16:30:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GGUbNn007206
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 16:30:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 16:30:37 +0000
Date:   Wed, 16 Sep 2020 09:30:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next REBASED to fe341eb151ec
Message-ID: <20200916163036.GG7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=2 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

In my fevered rush to put out a 5.10-merge branch last week, I
mistakenly pulled in dave's iunlink series, forgetting that it
introduces an incompat log change and wasn't ready for upstream.  Hence
rebasing to remove that series.  Sorry about that, I'll try to be more
careful in the future, particularly with the post -rc6 update next week.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

fe341eb151ec xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size

New Commits:

Carlos Maiolino (6):
      [771915c4f688] xfs: remove kmem_realloc()
      [8ca79df85b7f] xfs: Remove kmem_zalloc_large()
      [6337c84466c2] xfs: remove typedef xfs_attr_sf_entry_t
      [47e6cc100054] xfs: Remove typedef xfs_attr_shortform_t
      [c418dbc9805d] xfs: Use variable-size array for nameval in xfs_attr_sf_entry
      [e01b7eed5d0a] xfs: Convert xfs_attr_sf macros to inline functions

Christoph Hellwig (15):
      [12e164aa1f9d] xfs: refactor the buf ioend disposition code
      [76b2d3234611] xfs: mark xfs_buf_ioend static
      [23fb5a93c21f] xfs: refactor xfs_buf_ioend
      [664ffb8a429a] xfs: move the buffer retry logic to xfs_buf.c
      [6a7584b1d82b] xfs: fold xfs_buf_ioend_finish into xfs_ioend
      [f58d0ea95611] xfs: refactor xfs_buf_ioerror_fail_without_retry
      [3cc498845a0c] xfs: remove xfs_buf_ioerror_retry
      [844c9358dfda] xfs: lift the XBF_IOEND_FAIL handling into xfs_buf_ioend_disposition
      [70796c6b74c2] xfs: simplify the xfs_buf_ioend_disposition calling convention
      [b840e2ada8af] xfs: use xfs_buf_item_relse in xfs_buf_item_done
      [55b7d7115fcd] xfs: clear the read/write flags later in xfs_buf_ioend
      [22c10589a10b] xfs: remove xlog_recover_iodone
      [cead0b10f557] xfs: simplify xfs_trans_getsb
      [b3f8e08ca815] xfs: remove xfs_getsb
      [26e328759b9b] xfs: reuse _xfs_buf_read for re-reading the superblock

Darrick J. Wong (19):
      [2a39946c9844] xfs: store inode btree block counts in AGI header
      [1ac35f061af0] xfs: use the finobt block counts to speed up mount times
      [1dbbff029f93] xfs: support inode btree blockcounts in online scrub
      [11f744234f05] xfs: support inode btree blockcounts in online repair
      [b896a39faa5a] xfs: enable new inode btree counters feature
      [876fdc7c4f36] xfs: explicitly define inode timestamp range
      [11d8a9190275] xfs: refactor quota expiration timer modification
      [ccc8e771aa7a] xfs: refactor default quota grace period setting code
      [9f99c8fe551a] xfs: refactor quota timestamp coding
      [88947ea0ba71] xfs: move xfs_log_dinode_to_disk to the log recovery code
      [5a0bb066f60f] xfs: redefine xfs_timestamp_t
      [30e05599219f] xfs: redefine xfs_ictimestamp_t
      [f93e5436f0ee] xfs: widen ondisk inode timestamps to deal with y2038+
      [4ea1ff3b4968] xfs: widen ondisk quota expiration timestamps to handle y2038+
      [06dbf82b044c] xfs: trace timestamp limits
      [29887a227131] xfs: enable big timestamps
      [5ffce3cc22a0] xfs: force the log after remapping a synchronous-writes file
      [2a6ca4baed62] xfs: make sure the rt allocator doesn't run off the end
      [fe341eb151ec] xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size

Dave Chinner (1):
      [718ecc50359e] xfs: xfs_iflock is no longer a completion

Zheng Bin (1):
      [0f4ec0f15746] xfs: Remove unneeded semicolon


Code Diffstat:

 fs/xfs/kmem.c                    |  22 ----
 fs/xfs/kmem.h                    |   7 --
 fs/xfs/libxfs/xfs_ag.c           |   5 +
 fs/xfs/libxfs/xfs_attr.c         |  14 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c    |  43 ++++---
 fs/xfs/libxfs/xfs_attr_sf.h      |  29 +++--
 fs/xfs/libxfs/xfs_da_format.h    |   6 +-
 fs/xfs/libxfs/xfs_dquot_buf.c    |  35 ++++++
 fs/xfs/libxfs/xfs_format.h       | 211 +++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_fs.h           |   1 +
 fs/xfs/libxfs/xfs_ialloc.c       |   5 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |  65 +++++++++-
 fs/xfs/libxfs/xfs_iext_tree.c    |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c    | 130 +++++++++----------
 fs/xfs/libxfs/xfs_inode_buf.h    |  15 ++-
 fs/xfs/libxfs/xfs_inode_fork.c   |   8 +-
 fs/xfs/libxfs/xfs_log_format.h   |   7 +-
 fs/xfs/libxfs/xfs_log_recover.h  |   1 -
 fs/xfs/libxfs/xfs_quota_defs.h   |   8 +-
 fs/xfs/libxfs/xfs_sb.c           |   6 +-
 fs/xfs/libxfs/xfs_shared.h       |   3 +
 fs/xfs/libxfs/xfs_trans_inode.c  |  17 ++-
 fs/xfs/scrub/agheader.c          |  30 +++++
 fs/xfs/scrub/agheader_repair.c   |  24 ++++
 fs/xfs/scrub/inode.c             |  31 +++--
 fs/xfs/scrub/symlink.c           |   2 +-
 fs/xfs/xfs_acl.c                 |   2 +-
 fs/xfs/xfs_attr_list.c           |   6 +-
 fs/xfs/xfs_bmap_util.c           |  16 +++
 fs/xfs/xfs_buf.c                 | 208 +++++++++++++++++++++++++-----
 fs/xfs/xfs_buf.h                 |  17 +--
 fs/xfs/xfs_buf_item.c            | 264 ++-------------------------------------
 fs/xfs/xfs_buf_item.h            |  12 ++
 fs/xfs/xfs_buf_item_recover.c    |   2 +-
 fs/xfs/xfs_dquot.c               |  66 ++++++++--
 fs/xfs/xfs_dquot.h               |   3 +
 fs/xfs/xfs_file.c                |  17 ++-
 fs/xfs/xfs_icache.c              |  19 ++-
 fs/xfs/xfs_inode.c               |  83 +++++-------
 fs/xfs/xfs_inode.h               |  38 +-----
 fs/xfs/xfs_inode_item.c          |  61 ++++++---
 fs/xfs/xfs_inode_item.h          |   5 +-
 fs/xfs/xfs_inode_item_recover.c  |  76 +++++++++++
 fs/xfs/xfs_ioctl.c               |   7 +-
 fs/xfs/xfs_log_recover.c         |  60 +++------
 fs/xfs/xfs_mount.c               |  32 ++---
 fs/xfs/xfs_mount.h               |   1 -
 fs/xfs/xfs_ondisk.h              |  38 ++++--
 fs/xfs/xfs_qm.c                  |  13 ++
 fs/xfs/xfs_qm.h                  |   4 +
 fs/xfs/xfs_qm_syscalls.c         |  18 ++-
 fs/xfs/xfs_quota.h               |   8 --
 fs/xfs/xfs_rtalloc.c             |  13 +-
 fs/xfs/xfs_super.c               |  28 +++--
 fs/xfs/xfs_trace.h               |  29 ++++-
 fs/xfs/xfs_trans.c               |   2 +-
 fs/xfs/xfs_trans.h               |   2 +-
 fs/xfs/xfs_trans_buf.c           |  46 +++----
 fs/xfs/xfs_trans_dquot.c         |   6 +
 59 files changed, 1183 insertions(+), 746 deletions(-)
