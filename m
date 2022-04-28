Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52248C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 19:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351361AbiD1TOs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 15:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351368AbiD1TOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 15:14:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449AA92D01
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 12:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E325FB82E58
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 19:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8F8C385A9;
        Thu, 28 Apr 2022 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651173088;
        bh=6ybWTSQ5G4EuU1g4GKeIZH8y7AVqSWMyvjueaUp7Bdk=;
        h=Date:From:To:Cc:Subject:From;
        b=SvmEfXqoFAWElTKN6ELLjBJjyNQE3H2rCkH1dC40Y+Faqyw/SeYzdv/2bta2onqdg
         G/spSws7ytyhG7M7Wi2rJvHWhsOeW2Gjs4l6ITItJvPsawHX6LMe4GAP+ZFEdZXH/I
         7YD87JGYKiO+OhAzxXJazDb4Vqm3h4CTUG7sYETUJMaELqg7P9ACT0iupCmoQ6gP82
         5Pr2HkoZcZs+2XfRXrs7vpgewdXjqKcUiUkUCHmw1sOV93u7AD4CX8zYNIPTami4XJ
         brjOFM9N7w1l+4hgTQsW8pHkOgvMmHknJGK9u2ZyJvt7sLZHRb24O8PJO8FRrAggYd
         CuqpEuYLrPLAg==
Date:   Thu, 28 Apr 2022 12:11:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: fix reflink inefficiencies
Message-ID: <20220428191128.GP17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes since commit 1edf8056131aca6fe7f98873da8297e6fa279d8c:

  xfs: speed up write operations by using non-overlapped lookups when possible (2022-04-28 10:24:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/reflink-speedups-5.19_2022-04-28

for you to fetch changes up to 6ed7e509d2304519f4f6741670f512a55e9e80fe:

  xfs: rename xfs_*alloc*_log_count to _block_count (2022-04-28 10:25:59 -0700)

----------------------------------------------------------------
xfs: fix reflink inefficiencies

As Dave Chinner has complained about on IRC, there are a couple of
things about reflink that are very inefficient.  First of all, we
limited the size of all bunmapi operations to avoid flooding the log
with defer ops in the worst case, but recent changes to the defer ops
code have solved that problem, so get rid of the bunmapi length clamp.

Second, the log reservations for reflink operations are far far larger
than they need to be.  Shrink them to exactly what we need to handle
each deferred RUI and CUI log item, and no more.  Also reduce logcount
because we don't need 8 rolls per operation.  Introduce a transaction
reservation compatibility layer to avoid changing the minimum log size
calculations.

v2: better document the use of EFIs to track when refcount updates
    should be continued in a new transaction, disentangle the alternate
    log space reservation code

----------------------------------------------------------------
Darrick J. Wong (9):
      xfs: count EFIs when deciding to ask for a continuation of a refcount update
      xfs: stop artificially limiting the length of bunmap calls
      xfs: remove a __xfs_bunmapi call from reflink
      xfs: create shadow transaction reservations for computing minimum log size
      xfs: report "max_resp" used for min log size computation
      xfs: reduce the absurdly large log operation count
      xfs: reduce transaction reservations with reflink
      xfs: rewrite xfs_reflink_end_cow to use intents
      xfs: rename xfs_*alloc*_log_count to _block_count

 fs/xfs/libxfs/xfs_bmap.c       |  22 +----
 fs/xfs/libxfs/xfs_log_rlimit.c |  75 ++++++++++++++-
 fs/xfs/libxfs/xfs_refcount.c   |  14 ++-
 fs/xfs/libxfs/xfs_refcount.h   |  13 ++-
 fs/xfs/libxfs/xfs_trans_resv.c | 214 +++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_trans_resv.h |  16 ++-
 fs/xfs/xfs_reflink.c           |  95 +++++++++++-------
 fs/xfs/xfs_trace.h             |  32 +++++-
 fs/xfs/xfs_trans.c             |   3 -
 9 files changed, 345 insertions(+), 139 deletions(-)
