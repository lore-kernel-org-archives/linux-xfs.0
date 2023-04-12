Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82785C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDLDr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDLDr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E5630E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350A66101C
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91152C433D2;
        Wed, 12 Apr 2023 03:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271244;
        bh=OKTPO4jv7zALxM6IwqIjSlQ9Quq+/5br6hUE+X99lzk=;
        h=Date:Subject:From:To:Cc:From;
        b=vF78qw4OKhta0FjFlK7y/IP7uyRdgvjzsedbfzbp33oFQs/aK08zzx7R2Vh4IctLc
         lJdOtUwb/FtY+9QRA5Yj9r7GVGEK2UvVUUyUIJiQxQIfzEIN1mupNrFg3KMs0zxU1v
         tIpfFa4a/QUOqizJK7M5RNCgv5AXlLImeOpYucQ3tGIexKb32j/PQG9cs+skwnqkb6
         pEIaHUtvMRiXpuE/kp48fCXknftzQU6VlUdH2Y4XrQY46yTgQy3HZArj1v3e++70WG
         AaWk9M08QnSQbDhrgEYJc6orxqk8DVTP/NDw4fyf7AmAytaGOSuNAcr+K34ub6U5hv
         Q7OG8r8iA6lPg==
Date:   Tue, 11 Apr 2023 20:47:24 -0700
Subject: [GIT PULL 10/22] xfs: detect incorrect gaps in refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127094663.417736.1589396657136631142.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 2bea8df0a52b05bc0dddd54e950ae37c83533b03:

xfs: always scrub record/key order of interior records (2023-04-11 19:00:09 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-detect-refcount-gaps-6.4_2023-04-11

for you to fetch changes up to 7ac14fa2bd22e99a06ae16382b394f697cfe2b8a:

xfs: ensure that all metadata and data blocks are not cow staging extents (2023-04-11 19:00:12 -0700)

----------------------------------------------------------------
xfs: detect incorrect gaps in refcount btree [v24.5]

The next few patchsets address a deficiency in scrub that I found while
QAing the refcount btree scrubber.  If there's a gap between refcount
records, we need to cross-reference that gap with the reverse mappings
to ensure that there are no overlapping records in the rmap btree.  If
we find any, then the refcount btree is not consistent.  This is not a
property that is specific to the refcount btree; they all need to have
this sort of keyspace scanning logic to detect inconsistencies.

To do this accurately, we need to be able to scan the keyspace of a
btree (which we already do) to be able to tell the caller if the
keyspace is empty, sparse, or fully covered by records.  The first few
patches add the keyspace scanner to the generic btree code, along with
the ability to mask off parts of btree keys because when we scan the
rmapbt, we only care about space usage, not the owners.

The final patch closes the scanning gap in the refcountbt scanner.

v23.1: create helpers for the key extraction and comparison functions,
improve documentation, and eliminate the ->mask_key indirect
calls

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: refactor converting btree irec to btree key
xfs: refactor ->diff_two_keys callsites
xfs: replace xfs_btree_has_record with a general keyspace scanner
xfs: implement masked btree key comparisons for _has_records scans
xfs: check the reference counts of gaps in the refcount btree
xfs: ensure that all metadata and data blocks are not cow staging extents

fs/xfs/libxfs/xfs_alloc.c          |  11 +-
fs/xfs/libxfs/xfs_alloc.h          |   4 +-
fs/xfs/libxfs/xfs_alloc_btree.c    |  28 ++++-
fs/xfs/libxfs/xfs_bmap_btree.c     |  19 +++-
fs/xfs/libxfs/xfs_btree.c          | 208 +++++++++++++++++++++++++++----------
fs/xfs/libxfs/xfs_btree.h          | 141 ++++++++++++++++++++++++-
fs/xfs/libxfs/xfs_ialloc_btree.c   |  22 +++-
fs/xfs/libxfs/xfs_refcount.c       |  11 +-
fs/xfs/libxfs/xfs_refcount.h       |   4 +-
fs/xfs/libxfs/xfs_refcount_btree.c |  21 +++-
fs/xfs/libxfs/xfs_rmap.c           |  15 ++-
fs/xfs/libxfs/xfs_rmap.h           |   4 +-
fs/xfs/libxfs/xfs_rmap_btree.c     |  61 ++++++++---
fs/xfs/libxfs/xfs_types.h          |  12 +++
fs/xfs/scrub/agheader.c            |   5 +
fs/xfs/scrub/alloc.c               |   7 +-
fs/xfs/scrub/bmap.c                |  11 +-
fs/xfs/scrub/btree.c               |  24 ++---
fs/xfs/scrub/ialloc.c              |   2 +-
fs/xfs/scrub/inode.c               |   1 +
fs/xfs/scrub/refcount.c            | 124 ++++++++++++++++++++--
fs/xfs/scrub/rmap.c                |   6 +-
fs/xfs/scrub/scrub.h               |   2 +
23 files changed, 612 insertions(+), 131 deletions(-)

