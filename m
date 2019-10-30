Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9B5CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 16:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA7F22087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 16:51:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QK9jZjF3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJ3QvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 12:51:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfJ3QvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 12:51:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UGYiVt080016
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 16:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=F7nhxLZF0LMw1DNxoIsyQT+CdMvqHGaCNI7Ct+CISgA=;
 b=QK9jZjF33UVEp34jPL6N3XdcpmoA7yDe4pWQa39VCdV3RDi+Bq0XPz0qJCOGI4bbY8++
 fJhhpcUJDbKZQiPVK6RNG4Qh3rN2ra1MfvO7/bgWHQ4pEReo5/78z+E/0lik4Yo6VM5M
 8qRrY7QOQI4DR4IpuKr0N98GeroC2vXKk5ts5Eu4yrhImXTFfH0GZIvzx7FC921oLqyu
 RFrTLrYQ7mt5BpIN4y6lj6SL2U2dyFcHXvh0vlXSaf5E2eU9PDY9dYGZTjumI9d8q7GG
 mQOW988ffmjNg0BmGAKpog8ne6B0NfzTwOqimsW7g89TXVUjiqTAkGG3f9RNahN84vq/ XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vxwhfnmva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 16:51:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UGXg1F166699
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 16:51:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vxwhwdy8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 16:51:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9UGp5Gw013938
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 16:51:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 09:51:05 -0700
Date:   Wed, 30 Oct 2019 09:51:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 21f55993eb7a
Message-ID: <20191030165104.GK15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300150
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
the next update.  I decided to merge Christoph's mount parsing cleanups
because it looks like the mount api series has some weird bug in it.

The new head of the for-next branch is commit:

21f55993eb7a xfs: merge xfs_showargs into xfs_fs_show_options

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

Christoph Hellwig (41):
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

Darrick J. Wong (6):
      [c84760659dcf] xfs: check attribute leaf block structure
      [16c6e92c7e98] xfs: namecheck attribute names before listing them
      [04df34ac6494] xfs: namecheck directory entry names before listing them
      [c2414ad6e66a] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
      [fec40e220ffc] xfs: refactor xfs_bmap_count_blocks using newer btree helpers
      [e992ae8afded] xfs: refactor xfs_iread_extents to use xfs_btree_visit_blocks

Dave Chinner (2):
      [3f8a4f1d876d] xfs: fix inode fork extent count overflow
      [1c743574de8b] xfs: cap longest free extent to maximum allocatable

Ian Kent (1):
      [8da57c5c000c] xfs: remove the biosize mount option

Jan Kara (1):
      [3dd4d40b4208] xfs: Sanity check flags of Q_XQUOTARM call

kaixuxia (1):
      [3fb21fc8cc04] xfs: remove the duplicated inode log fieldmask set

yu kuai (1):
      [e5e634041bc1] xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS


Code Diffstat:

 fs/compat_ioctl.c               |  31 +-
 fs/ioctl.c                      |  12 +-
 fs/xfs/libxfs/xfs_alloc.c       | 900 +++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_alloc_btree.c |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c   |  85 +++-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   4 +-
 fs/xfs/libxfs/xfs_bmap.c        | 212 ++++------
 fs/xfs/libxfs/xfs_btree.c       |  10 +-
 fs/xfs/libxfs/xfs_btree.h       |  12 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |   2 +-
 fs/xfs/libxfs/xfs_iext_tree.c   |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.h  |  14 +-
 fs/xfs/scrub/bitmap.c           |   3 +-
 fs/xfs/xfs_aops.c               |  43 +-
 fs/xfs/xfs_aops.h               |   3 -
 fs/xfs/xfs_attr_inactive.c      |   6 +-
 fs/xfs/xfs_attr_list.c          |  60 ++-
 fs/xfs/xfs_bmap_util.c          | 209 ++--------
 fs/xfs/xfs_bmap_util.h          |   2 -
 fs/xfs/xfs_buf.c                |  17 +-
 fs/xfs/xfs_buf.h                |   1 -
 fs/xfs/xfs_dir2_readdir.c       |  27 +-
 fs/xfs/xfs_dquot.c              |   6 +-
 fs/xfs/xfs_file.c               |  72 ++--
 fs/xfs/xfs_inode.c              |   7 +-
 fs/xfs/xfs_inode.h              |   7 +
 fs/xfs/xfs_ioctl.c              |  99 +----
 fs/xfs/xfs_ioctl.h              |   1 -
 fs/xfs/xfs_ioctl32.c            |   9 +-
 fs/xfs/xfs_iomap.c              | 708 +++++++++++++++----------------
 fs/xfs/xfs_iomap.h              |   4 +-
 fs/xfs/xfs_iops.c               |  55 ++-
 fs/xfs/xfs_log.c                | 428 ++++++++-----------
 fs/xfs/xfs_log_cil.c            |   2 +-
 fs/xfs/xfs_log_priv.h           |  25 +-
 fs/xfs/xfs_mount.c              |  46 +-
 fs/xfs/xfs_mount.h              |  48 +--
 fs/xfs/xfs_pnfs.c               |   1 +
 fs/xfs/xfs_quotaops.c           |   3 +
 fs/xfs/xfs_reflink.c            | 138 +-----
 fs/xfs/xfs_reflink.h            |   4 +-
 fs/xfs/xfs_rtalloc.c            |   3 +-
 fs/xfs/xfs_super.c              | 107 ++---
 fs/xfs/xfs_super.h              |  10 +
 fs/xfs/xfs_trace.h              |  35 +-
 include/linux/falloc.h          |   3 +
 include/linux/fs.h              |   2 +-
 48 files changed, 1655 insertions(+), 1832 deletions(-)
