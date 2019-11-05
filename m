Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19CBC5DF60
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 17:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C6B2087E
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 17:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ivjaY4vG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfKERJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 12:09:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbfKERJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 12:09:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5H9JxO137541
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 17:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=h9fUXOCjVBVsskpG6vzUluW4BSE1jkco0LMrS8BptZc=;
 b=ivjaY4vGr+EAjdNMemDwHrHe9Spcp1fT+SMyxZNYxrKYuCSe20eWEEYKegBt3herzGPo
 uNJJI0QDuSl0dVInmFTjDJTZCnOsV1yB8d6Mi+GeLb0QyOvmU2hMU3Yr4gxXBBlGe2f8
 tNqKLR5FG00LeiJfN0SQ4uCFRsHEI2mYaLmn/SQzmt6EdT5IT2PbfaSorwrGnpIe7bU4
 Wgtg592Y0X4Zu/j7T6mLnaw4XOuG1OMNf3NMan5DssLqIvPs0hkkQKLwF8XSdgKZuLWK
 kqcxPllEUpxePYZKYKmBo8RKptCGbaHqvajc9Z2cKOC1BxwjXkwgGTrJRtns/Ud69dix Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w11rq02d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 17:09:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5H8in7029257
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 17:09:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w333vjr04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 17:09:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA5H9nKv013980
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 17:09:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 09:09:49 -0800
Date:   Tue, 5 Nov 2019 09:09:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9842b56cd406
Message-ID: <20191105170948.GD4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050142
Sender: linux-xfs-owner@vger.kernel.org
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
the next update.

The new head of the for-next branch is commit:

9842b56cd406 xfs: make the assertion message functions take a mount parameter

New Commits:

Ben Dooks (Codethink) (1):
      [1aa6300638e7] xfs: add mising include of xfs_pnfs.h for missing declarations

Brian Foster (12):
      [f6b428a46d60] xfs: track active state of allocation btree cursors
      [f5e7dbea1e3e] xfs: introduce allocation cursor data structure
      [d6d3aff20377] xfs: track allocation busy state in allocation cursor
      [c62321a2a0ea] xfs: track best extent from cntbt lastblock scan in alloc cursor
      [396bbf3c657e] xfs: refactor cntbt lastblock scan best extent logic into helper
      [fec0afdaf498] xfs: reuse best extent tracking logic for bnobt scan
      [4a65b7c2c72c] xfs: refactor allocation tree fixup code
      [78d7aabdeea3] xfs: refactor and reuse best extent scanning logic
      [0e26d5ca4a40] xfs: refactor near mode alloc bnobt scan into separate function
      [d29688257fd4] xfs: factor out tree fixup logic into helper
      [dc8e69bd7218] xfs: optimize near mode bnobt scans with concurrent cntbt lookups
      [da781e64b28c] xfs: don't set bmapi total block req where minleft is

Christoph Hellwig (50):
      [bdb2ed2dbdc2] xfs: ignore extent size hints for always COW inodes
      [cd95cb962b7d] xfs: pass the correct flag to xlog_write_iclog
      [2c68a1dfbd8e] xfs: remove the unused ic_io_size field from xlog_in_core
      [390aab0a1640] xfs: move the locking from xlog_state_finish_copy to the callers
      [df732b29c807] xfs: call xlog_state_release_iclog with l_icloglock held
      [032cc34ed517] xfs: remove dead ifdef XFSERRORDEBUG code
      [fe9c0e77acc5] xfs: remove the unused XLOG_STATE_ALL and XLOG_STATE_UNUSED flags
      [1858bb0bec61] xfs: turn ic_state into an enum
      [4b29ab04ab0d] xfs: remove the XLOG_STATE_DO_CALLBACK state
      [0d45e3a20822] xfs: also call xfs_file_iomap_end_delalloc for zeroing operations
      [dd26b84640cc] xfs: remove xfs_reflink_dirty_extents
      [ffb375a8cf20] xfs: pass two imaps to xfs_reflink_allocate_cow
      [ae36b53c6c60] xfs: refactor xfs_file_iomap_begin_delay
      [36adcbace24e] xfs: fill out the srcmap in iomap_begin
      [43568226a4a3] xfs: factor out a helper to calculate the end_fsb
      [690c2a38878e] xfs: split out a new set of read-only iomap ops
      [a526c85c2236] xfs: move xfs_file_iomap_begin_delay around
      [f150b4234397] xfs: split the iomap ops for buffered vs direct writes
      [12dfb58af61d] xfs: rename the whichfork variable in xfs_buffered_write_iomap_begin
      [5c5b6f7585d2] xfs: cleanup xfs_direct_write_iomap_begin
      [1e190f8e8098] xfs: improve the IOMAP_NOWAIT check for COW inodes
      [25a409572b5f] xfs: mark xfs_buf_free static
      [30fa529e3b2e] xfs: add a xfs_inode_buftarg helper
      [f9acc19c8cbe] xfs: use xfs_inode_buftarg in xfs_file_dio_aio_write
      [c7d68318c9ae] xfs: use xfs_inode_buftarg in xfs_file_ioctl
      [9afe1d5c14e0] xfs: don't implement XFS_IOC_RESVSP / XFS_IOC_RESVSP64
      [837a6e7f5cdb] fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers
      [7a42c70ea0dd] xfs: disable xfs_ioc_space for always COW inodes
      [360c09c01c5a] xfs: consolidate preallocation in xfs_file_fallocate
      [2123ef851083] xfs: simplify setting bio flags
      [69e8575dee42] xfs: remove the dsunit and dswidth variables in
      [dd2d535e3fb2] xfs: cleanup calculating the stat optimal I/O size
      [b5ad616c3edf] xfs: don't use a different allocsice for -o wsync
      [3cd1d18b0d40] xfs: remove the m_readio_* fields in struct xfs_mount
      [5da8a07c79e8] xfs: rename the m_writeio_* fields in struct xfs_mount
      [2fcddee8cd8f] xfs: simplify parsing of allocsize mount option
      [3274d0080100] xfs: rename the XFS_MOUNT_DFLT_IOSIZE option to
      [7c6b94b1b526] xfs: reverse the polarity of XFS_MOUNT_COMPAT_IOSIZE
      [aa58d4455a11] xfs: clean up printing the allocsize option in
      [1775c506a31e] xfs: clean up printing inode32/64 in xfs_showargs
      [21f55993eb7a] xfs: merge xfs_showargs into xfs_fs_show_options
      [ae7e403fa5bb] xfs: simplify xfs_iomap_eof_align_last_fsb
      [49bbf8c76156] xfs: mark xfs_eof_alignment static
      [57c49444d7cc] xfs: remove the extsize argument to xfs_eof_alignment
      [88cdb7147b21] xfs: slightly tweak an assert in xfs_fs_map_blocks
      [307cdb54b80e] xfs: don't log the inode in xfs_fs_map_blocks if it
      [e696663a97e8] xfs: simplify the xfs_iomap_write_direct calling
      [be6cacbeea8c] xfs: refactor xfs_bmapi_allocate
      [fd638f1de1f3] xfs: move extent zeroing to xfs_bmapi_allocate
      [c34d570d1586] xfs: cleanup use of the XFS_ALLOC_ flags

Darrick J. Wong (12):
      [c84760659dcf] xfs: check attribute leaf block structure
      [16c6e92c7e98] xfs: namecheck attribute names before listing them
      [04df34ac6494] xfs: namecheck directory entry names before listing them
      [c2414ad6e66a] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
      [fec40e220ffc] xfs: refactor xfs_bmap_count_blocks using newer btree helpers
      [e992ae8afded] xfs: refactor xfs_iread_extents to use xfs_btree_visit_blocks
      [e91ec882af21] xfs: relax shortform directory size checks
      [d243b89a611e] xfs: constify the buffer pointer arguments to error functions
      [a5155b870d68] xfs: always log corruption errors
      [ee4fb16cbec9] xfs: decrease indenting problems in xfs_dabuf_map
      [110f09cb705a] xfs: add missing assert in xfs_fsmap_owner_from_rmap
      [9842b56cd406] xfs: make the assertion message functions take a mount parameter

Dave Chinner (3):
      [3f8a4f1d876d] xfs: fix inode fork extent count overflow
      [1c743574de8b] xfs: cap longest free extent to maximum allocatable
      [249bd9087a52] xfs: properly serialise fallocate against AIO+DIO

Ian Kent (18):
      [8da57c5c000c] xfs: remove the biosize mount option
      [f676c7508667] xfs: remove unused struct xfs_mount field m_fsname_len
      [e1d3d2188546] xfs: use super s_id instead of struct xfs_mount m_fsname
      [3d9d60d9addf] xfs: dont use XFS_IS_QUOTA_RUNNING() for option check
      [7b77b46a6137] xfs: use kmem functions for struct xfs_mount
      [a943f372c22b] xfs: merge freeing of mp names and mp
      [82332b6da226] xfs: add xfs_remount_rw() helper
      [2c6eba31775b] xfs: add xfs_remount_ro() helper
      [c0a6791667f8] xfs: refactor suffix_kstrtoint()
      [846410ccd104] xfs: avoid redundant checks when options is empty
      [48a06e1b5773] xfs: refactor xfs_parseags()
      [9a861816a026] xfs: move xfs_parseargs() validation to a helper
      [7c89fcb2783d] xfs: dont set sb in xfs_mount_alloc()
      [73e5fff98b64] xfs: switch to use the new mount-api
      [63cd1e9b026e] xfs: move xfs_fc_reconfigure() above xfs_fc_free()
      [2f8d66b3cd79] xfs: move xfs_fc_get_tree() above xfs_fc_reconfigure()
      [8757c38f2cf6] xfs: move xfs_fc_parse_param() above xfs_fc_get_tree()
      [50f8300904b1] xfs: fold xfs_mount-alloc() into xfs_init_fs_context()

Jan Kara (1):
      [3dd4d40b4208] xfs: Sanity check flags of Q_XQUOTARM call

kaixuxia (1):
      [3fb21fc8cc04] xfs: remove the duplicated inode log fieldmask set

yu kuai (1):
      [e5e634041bc1] xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS


Code Diffstat:

 fs/compat_ioctl.c               |   31 +-
 fs/ioctl.c                      |   12 +-
 fs/xfs/libxfs/xfs_alloc.c       |  924 ++++++++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h       |   16 +-
 fs/xfs/libxfs/xfs_alloc_btree.c |    1 +
 fs/xfs/libxfs/xfs_attr_leaf.c   |   97 ++-
 fs/xfs/libxfs/xfs_attr_leaf.h   |    4 +-
 fs/xfs/libxfs/xfs_bmap.c        |  320 +++++-----
 fs/xfs/libxfs/xfs_btree.c       |   15 +-
 fs/xfs/libxfs/xfs_btree.h       |   12 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   62 +-
 fs/xfs/libxfs/xfs_dir2.c        |    4 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |    8 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    4 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |   12 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |   34 +-
 fs/xfs/libxfs/xfs_iext_tree.c   |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   14 +-
 fs/xfs/libxfs/xfs_inode_fork.h  |   14 +-
 fs/xfs/libxfs/xfs_refcount.c    |    4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c    |    6 +-
 fs/xfs/scrub/bitmap.c           |    3 +-
 fs/xfs/xfs_acl.c                |   15 +-
 fs/xfs/xfs_aops.c               |   43 +-
 fs/xfs/xfs_aops.h               |    3 -
 fs/xfs/xfs_attr_inactive.c      |   10 +-
 fs/xfs/xfs_attr_list.c          |   65 +-
 fs/xfs/xfs_bmap_item.c          |    3 +-
 fs/xfs/xfs_bmap_util.c          |  247 +-------
 fs/xfs/xfs_bmap_util.h          |    4 -
 fs/xfs/xfs_buf.c                |   17 +-
 fs/xfs/xfs_buf.h                |    1 -
 fs/xfs/xfs_dir2_readdir.c       |   27 +-
 fs/xfs/xfs_dquot.c              |    6 +-
 fs/xfs/xfs_error.c              |   29 +-
 fs/xfs/xfs_error.h              |    7 +-
 fs/xfs/xfs_extent_busy.c        |    2 +-
 fs/xfs/xfs_extfree_item.c       |    3 +-
 fs/xfs/xfs_file.c               |  102 ++-
 fs/xfs/xfs_filestream.c         |    2 +-
 fs/xfs/xfs_fsmap.c              |    1 +
 fs/xfs/xfs_inode.c              |   22 +-
 fs/xfs/xfs_inode.h              |    7 +
 fs/xfs/xfs_inode_item.c         |    5 +-
 fs/xfs/xfs_ioctl.c              |  100 +--
 fs/xfs/xfs_ioctl.h              |    1 -
 fs/xfs/xfs_ioctl32.c            |    9 +-
 fs/xfs/xfs_iomap.c              |  853 +++++++++++++-------------
 fs/xfs/xfs_iomap.h              |   11 +-
 fs/xfs/xfs_iops.c               |   65 +-
 fs/xfs/xfs_linux.h              |    6 +-
 fs/xfs/xfs_log.c                |  430 ++++++-------
 fs/xfs/xfs_log_cil.c            |    2 +-
 fs/xfs/xfs_log_priv.h           |   25 +-
 fs/xfs/xfs_log_recover.c        |   23 +-
 fs/xfs/xfs_message.c            |   22 +-
 fs/xfs/xfs_message.h            |    6 +-
 fs/xfs/xfs_mount.c              |   51 +-
 fs/xfs/xfs_mount.h              |   50 +-
 fs/xfs/xfs_pnfs.c               |   56 +-
 fs/xfs/xfs_qm.c                 |   13 +-
 fs/xfs/xfs_quotaops.c           |    3 +
 fs/xfs/xfs_refcount_item.c      |    3 +-
 fs/xfs/xfs_reflink.c            |  138 +----
 fs/xfs/xfs_reflink.h            |    4 +-
 fs/xfs/xfs_rmap_item.c          |    7 +-
 fs/xfs/xfs_rtalloc.c            |    3 +-
 fs/xfs/xfs_super.c              | 1293 +++++++++++++++++++--------------------
 fs/xfs/xfs_super.h              |   10 +
 fs/xfs/xfs_trace.h              |   35 +-
 fs/xfs/xfs_trans_ail.c          |    2 +-
 include/linux/falloc.h          |    3 +
 include/linux/fs.h              |    2 +-
 73 files changed, 2652 insertions(+), 2794 deletions(-)
