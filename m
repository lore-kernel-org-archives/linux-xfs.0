Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbfA2Sdv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:33:51 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0869A89AE0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 18:33:51 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3B665D717
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 18:33:50 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/5] xfs: fix [f]inobt magic value verification
Date: Tue, 29 Jan 2019 13:33:45 -0500
Message-Id: <20190129183350.27302-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a first non-rfc version of the finobt magic fixup. There is still
a bit of trepidation over this approach based on the rfcv2 feedback, but
I've not seen a good enough (IMO) alternative that justifies reworking
what I've tested so far. I'm posting this v1 with the caveat that only
the first two patches are required to implement the desired per-inobt
magic value verification logic.

Patches 3-4 include optional conversions of other verifiers and patch 5
is just a typo fixup (which could be folded into any other otherwise
acceptable patch). I separated out patch 3 as an independent patch
because I thought there was more value in the code cleanup (eliminating
~50 lines of cruft) than for the remaining verifiers. I skipped a few
others where the lower level verification seemed a bit more logically
removed from the buffer verifier itself (i.e., dquot, inode).

Note again that this depends on Darrick's scrub ->b_ops fixup [1].

Brian

[1] https://marc.info/?l=linux-xfs&m=154861208322420&w=2

v1:
- Remove endian conversion from helper.
- Drop finobt bad magic mitigation patch.
- Additional verifier magic fixups.
- Add verifier name typo fixup.
rfcv2: https://marc.info/?l=linux-xfs&m=154868884311668&w=2
- Split off finobt verifier into separate patch, assign it
  appropriately.
- Created helpers for xfs_buf_ops magic value verification.
- Added error mitigation patch for problematic finobt blocks.
rfcv1: https://marc.info/?l=linux-xfs&m=154834528212262&w=2

Brian Foster (5):
  xfs: create a separate finobt verifier
  xfs: distinguish between inobt and finobt magic values
  xfs: use verifier magic field in dir2 leaf verifiers
  xfs: miscellaneous verifier magic value fixups
  xfs: fix typo in xfs_inode_buf_ra_ops verifier name

 fs/xfs/libxfs/xfs_ag.c             |  2 +-
 fs/xfs/libxfs/xfs_alloc.c          | 12 +++--
 fs/xfs/libxfs/xfs_attr_leaf.c      | 10 ++--
 fs/xfs/libxfs/xfs_attr_remote.c    |  8 +--
 fs/xfs/libxfs/xfs_bmap_btree.c     | 12 ++---
 fs/xfs/libxfs/xfs_da_btree.c       | 10 ++--
 fs/xfs/libxfs/xfs_dir2_block.c     |  9 ++--
 fs/xfs/libxfs/xfs_dir2_data.c      |  9 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c      | 86 +++++++-----------------------
 fs/xfs/libxfs/xfs_dir2_node.c      | 10 ++--
 fs/xfs/libxfs/xfs_ialloc.c         |  3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 24 +++++----
 fs/xfs/libxfs/xfs_inode_buf.c      |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  3 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  3 +-
 fs/xfs/libxfs/xfs_sb.c             |  4 +-
 fs/xfs/libxfs/xfs_shared.h         |  1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |  3 +-
 fs/xfs/scrub/agheader_repair.c     |  2 +-
 fs/xfs/xfs_buf.h                   | 20 +++++++
 fs/xfs/xfs_log_recover.c           |  6 ++-
 21 files changed, 110 insertions(+), 129 deletions(-)

-- 
2.17.2
