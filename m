Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F399C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 16:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiKAQ4t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 12:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKAQ4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 12:56:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0701D0C3
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 09:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBA1661662
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 16:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3863FC433C1
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 16:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667321806;
        bh=Mny3aAVTjBuhZIf/pENzz+J5lsWCWGo1HnjU2UV4rUc=;
        h=Date:From:To:Subject:From;
        b=cO4ogK7qyFOMK2c8oW5hvJJgC5SGAgQIDLLtd5oqcphIG8Ipo2UocQlf0o2sgficM
         rr109LQm8pskNw1Mp8OUZuXcgsKsvlPSgzWI4bN6iFznMLg4QqE20xtrBXuq/Q9Qw1
         IYFjsQ5nr29/xPUkvOyQgdX0CJxl02onUjufGAJ6bon5Ma8Ixf1RjgSxiXhRJ+V+Vd
         bT+dmvWCJE3FeowKhVOT9oQGwx7TquAmPQ5zTAs+/RjiATKTZ5/PKntcqpZx9tNBW3
         QBqvBccCKDPGqjHXcdywV8/dJM6zxlXt3vpwiYxuryKZapNLAC0msEQCn9Lr2MM+2K
         dtx1w0EaGpeQA==
Date:   Tue, 1 Nov 2022 09:56:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULL] xfs: improve runtime refcountbt corruption detection
Message-ID: <Y2FPzdfej3wtvBc5@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi me,

Please pull the final versions of the refcountbt infinite loop bugfixes
into for-next.

--D

The following changes since commit 950f0d50ee7138d7e631aefea8528d485426eda6:

  xfs: dump corrupt recovered log intent items to dmesg consistently (2022-10-31 08:58:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/refcount-cow-domain-6.1_2022-10-31

for you to fetch changes up to 8b972158afcaa66c538c3ee1d394f096fcd238a8:

  xfs: rename XFS_REFC_COW_START to _COWFLAG (2022-10-31 08:58:22 -0700)

----------------------------------------------------------------
xfs: improve runtime refcountbt corruption detection

Fuzz testing of the refcount btree demonstrated a weakness in validation
of refcount btree records during normal runtime.  The idea of using the
upper bit of the rc_startblock field to separate the refcount records
into one group for shared space and another for CoW staging extents was
added at the last minute.  The incore struct left this bit encoded in
the upper bit of the startblock field, which makes it all too easy for
arithmetic operations to overflow if we don't detect the cowflag
properly.

When I ran a norepair fuzz tester, I was able to crash the kernel on one
of these accidental overflows by fuzzing a key record in a node block,
which broke lookups.  To fix the problem, make the domain (shared/cow) a
separate field in the incore record.

Unfortunately, a customer also hit this once in production.  Due to bugs
in the kernel running on the VM host, writes to the disk image would
occasionally be lost.  Given sufficient memory pressure on the VM guest,
a refcountbt xfs_buf could be reclaimed and later reloaded from the
stale copy on the virtual disk.  The stale disk contents were a refcount
btree leaf block full of records for the wrong domain, and this caused
an infinite loop in the guest VM.

v2: actually include the refcount adjust loop invariant checking patch;
    move the deferred refcount continuation checks earlier in the series;
    break up the megapatch into smaller pieces; fix an uninitialized list
    error.
v3: in the continuation check patch, verify the per-ag extent before
    converting it to a fsblock

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (13):
      xfs: make sure aglen never goes negative in xfs_refcount_adjust_extents
      xfs: create a predicate to verify per-AG extents
      xfs: check deferred refcount op continuation parameters
      xfs: move _irec structs to xfs_types.h
      xfs: refactor refcount record usage in xchk_refcountbt_rec
      xfs: track cow/shared record domains explicitly in xfs_refcount_irec
      xfs: report refcount domain in tracepoints
      xfs: refactor domain and refcount checking
      xfs: remove XFS_FIND_RCEXT_SHARED and _COW
      xfs: check record domain when accessing refcount records
      xfs: fix agblocks check in the cow leftover recovery function
      xfs: fix uninitialized list head in struct xfs_refcount_recovery
      xfs: rename XFS_REFC_COW_START to _COWFLAG

 fs/xfs/libxfs/xfs_ag.h             |  15 ++
 fs/xfs/libxfs/xfs_alloc.c          |   6 +-
 fs/xfs/libxfs/xfs_format.h         |  22 +--
 fs/xfs/libxfs/xfs_refcount.c       | 286 ++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_refcount.h       |  40 +++++-
 fs/xfs/libxfs/xfs_refcount_btree.c |  15 +-
 fs/xfs/libxfs/xfs_rmap.c           |   9 +-
 fs/xfs/libxfs/xfs_types.h          |  30 ++++
 fs/xfs/scrub/alloc.c               |   4 +-
 fs/xfs/scrub/ialloc.c              |   5 +-
 fs/xfs/scrub/refcount.c            |  72 ++++------
 fs/xfs/xfs_trace.h                 |  48 +++++--
 12 files changed, 368 insertions(+), 184 deletions(-)
