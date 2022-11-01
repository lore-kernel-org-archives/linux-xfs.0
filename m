Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9C6C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 16:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiKAQ7R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 12:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiKAQ7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 12:59:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471DB260D
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 09:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D566561689
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 16:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38882C433C1
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667321948;
        bh=Y/L3G/g+V7cdA2NGXSjSo5o2Im5K5phNmETFBC5gYvA=;
        h=Date:From:To:Subject:From;
        b=hQkWCqZ5XDg+lrMBHP14G7q1gqRZcfn4K+mPs20eDfvqQDDsxODbwk+I1Z5XOvStC
         PdjSt5yj9as02L7Pf4su/R//xILKKR3dMFbAU4kuWtN8Ciro3CdWd8d+VCpS82krZV
         HNS/qtYleT0lNeSh/j3wViq5mrAe2UNZNzPQSlyGexYtP9yKcEQRuMmO3Ig4Wx4ZNA
         LwwMSm75yxthKECzyznr5MCx433nPJYzTAkeYHwBUwhxBFzIL9a3YOR4ItkSJ9aszK
         7TouTqi80HVOlX3fwA3i52NYqWvK9rM81J0BZb9fJXIi4OHyeqINGl0anhSl3AeABE
         TUVGPk96YC9Lg==
Date:   Tue, 1 Nov 2022 09:59:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4eb559dd1567
Message-ID: <Y2FQW0KZTUOsAkyr@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
the next update.  The for-next branch now contains all the stability
fixes that I am aware of and have completed review.

The new head of the for-next branch is commit:

4eb559dd1567 Merge tag 'refcount-cow-domain-6.1_2022-10-31' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.1-fixesA

14 new commits:

Darrick J. Wong (14):
      [f850995f60e4] xfs: make sure aglen never goes negative in xfs_refcount_adjust_extents
      [b65e08f83b11] xfs: create a predicate to verify per-AG extents
      [8edbe0cf8b4b] xfs: check deferred refcount op continuation parameters
      [9e7e2436c159] xfs: move _irec structs to xfs_types.h
      [5a8c345ca8b9] xfs: refactor refcount record usage in xchk_refcountbt_rec
      [9a50ee4f8db6] xfs: track cow/shared record domains explicitly in xfs_refcount_irec
      [571423a162cd] xfs: report refcount domain in tracepoints
      [f492135df0aa] xfs: refactor domain and refcount checking
      [68d0f389179a] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
      [f62ac3e0ac33] xfs: check record domain when accessing refcount records
      [f1fdc8207840] xfs: fix agblocks check in the cow leftover recovery function
      [c1ccf967bf96] xfs: fix uninitialized list head in struct xfs_refcount_recovery
      [8b972158afca] xfs: rename XFS_REFC_COW_START to _COWFLAG
      [4eb559dd1567] Merge tag 'refcount-cow-domain-6.1_2022-10-31' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.1-fixesA

Code Diffstat:

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
