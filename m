Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78E4C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AADA42073A
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfKOTa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 14:30:57 -0500
Received: from sandeen.net ([63.231.237.45]:58080 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbfKOTa4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Nov 2019 14:30:56 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BE2CBF8BFC
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 13:29:35 -0600 (CST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to c2257e1f / 5.4.0-rc0
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <2807e7c5-bede-3bcf-4f2e-1f0091db5c73@sandeen.net>
Date:   Fri, 15 Nov 2019 13:30:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 5.4.0-rc0.  This is just the
libxfs sync with upstream kernel 5.4.0 libxfs.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

c2257e1f (HEAD -> for-next, tag: v5.4.0-rc0, origin/libxfs-5.4-sync, korg/libxfs-5.4-sync, korg/for-next) xfsprogs: Release v5.4.0-rc0

New Commits:

Brian Foster (4):
      [684b522f] xfs: convert inode to extent format after extent merge due to shift
      [a4d64973] xfs: log the inode on directory sf to block format change
      [6cae47cf] xfs: remove broken error handling on failed attr sf to leaf change
      [420f1cd9] xfs: move local to extent inode logging into bmap helper

Christoph Hellwig (2):
      [2c1931be] xfs: remove the unused XFS_ALLOC_USERDATA flag
      [9e211f67] xfs: add a xfs_valid_startblock helper

Darrick J. Wong (13):
      [355360c9] xfs: fix maxicount division by zero error
      [839ac9c7] xfs: don't return _QUERY_ABORT from xfs_rmap_has_other_keys
      [00e30e05] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
      [291fe07d] xfs: remove unnecessary parameter from xfs_iext_inc_seq
      [cf9e0d76] xfs: remove unnecessary int returns from deferred rmap functions
      [f56865c0] xfs: remove unnecessary int returns from deferred refcount functions
      [19b86b1d] xfs: remove unnecessary int returns from deferred bmap functions
      [197c46f3] xfs: reinitialize rm_flags when unpacking an offset into an rmap irec
      [f5745955] xfs: remove all *_ITER_ABORT values
      [d9b3a30b] xfs: remove all *_ITER_CONTINUE values
      [9d68de72] xfs: define a flags field for the AG geometry ioctl structure
      [00e60c52] xfs: revert 1baa2800e62d ("xfs: remove the unused XFS_ALLOC_USERDATA flag")
      [e64a6c3f] xfs: change the seconds fields in xfs_bulkstat to signed

Dave Chinner (11):
      [26963cf0] xfs: add kmem allocation trace points
      [4c6016fd] xfs: move xfs_dir2_addname()
      [87e5233e] xfs: factor data block addition from xfs_dir2_node_addname_int()
      [98a53915] xfs: factor free block index lookup from xfs_dir2_node_addname_int()
      [441b1102] xfs: speed up directory bestfree block scanning
      [e12c6d3e] xfs: reverse search directory freespace indexes
      [a4a5b906] xfs: make attr lookup returns consistent
      [05f6d9fb] xfs: remove unnecessary indenting from xfs_attr3_leaf_getvalue
      [4592df33] xfs: move remote attr retrieval into xfs_attr3_leaf_getvalue
      [aeeb13ca] xfs: consolidate attribute value copying
      [9a008b20] xfs: allocate xattr buffer on demand

Eric Sandeen (3):
      [5b9af487] xfs: log proper length of superblock
      [5d2726fc] xfs: remove unused flags arg from xfs_get_aghdr_buf()
      [c2257e1f] xfsprogs: Release v5.4.0-rc0

Tetsuo Handa (1):
      [c370dcec] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.

zhengbin (1):
      [11ac487d] xfs: remove excess function parameter description in 'xfs_btree_sblock_v5hdr_verify'


Code Diffstat:

 VERSION                  |   4 +-
 configure.ac             |   2 +-
 debian/changelog         |   6 +
 doc/CHANGES              |   3 +
 include/kmem.h           |   1 +
 include/xfs_mount.h      |   8 -
 libxfs/kmem.c            |   6 +
 libxfs/libxfs_priv.h     |   2 +-
 libxfs/xfs_ag.c          |   5 +-
 libxfs/xfs_alloc.c       |   2 +-
 libxfs/xfs_attr.c        |  79 ++++--
 libxfs/xfs_attr.h        |   6 +-
 libxfs/xfs_attr_leaf.c   | 151 ++++++-----
 libxfs/xfs_attr_remote.c |   2 +
 libxfs/xfs_bmap.c        |  88 +++---
 libxfs/xfs_bmap.h        |  14 +-
 libxfs/xfs_bmap_btree.c  |  16 +-
 libxfs/xfs_btree.c       |  14 +-
 libxfs/xfs_btree.h       |  10 +-
 libxfs/xfs_da_btree.c    |   6 +-
 libxfs/xfs_da_btree.h    |   4 +-
 libxfs/xfs_defer.c       |   2 +-
 libxfs/xfs_dir2.c        |  14 +-
 libxfs/xfs_dir2_block.c  |   4 +-
 libxfs/xfs_dir2_node.c   | 678 ++++++++++++++++++++++-------------------------
 libxfs/xfs_dir2_sf.c     |   8 +-
 libxfs/xfs_fs.h          |  10 +-
 libxfs/xfs_ialloc.c      |   9 +-
 libxfs/xfs_iext_tree.c   |   8 +-
 libxfs/xfs_inode_fork.c  |  16 +-
 libxfs/xfs_refcount.c    |  50 ++--
 libxfs/xfs_refcount.h    |  12 +-
 libxfs/xfs_rmap.c        |  59 +++--
 libxfs/xfs_rmap.h        |  11 +-
 libxfs/xfs_sb.c          |   2 +-
 libxfs/xfs_shared.h      |   6 -
 libxfs/xfs_types.h       |   8 +
 37 files changed, 676 insertions(+), 650 deletions(-)
