Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4A6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 15:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiF2PxD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 11:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiF2Pwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 11:52:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2369523BCE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 08:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC98DB82564
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D18FC341C8
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656517972;
        bh=iRMuCm1ij80cruYp0pw9eJJQW6z64kiueO7j10DIenY=;
        h=Date:From:To:Subject:From;
        b=ExJnFsZppeQ6MMTTXO987chMsK+B7nJx3QtNZwDkXQsbhUOD6noOrbH+R+Mi0kzyr
         qAPzPBKYDPJ3kBsqMPwugLSKhtkuDq4rIaCd+tXujJNfKw/QhUgWzvgVaj0PqHeIWa
         8N78h5bBtuAeIUh4wYejxeXImxcvwjIrhvuuTwpTxZbjy/k/E84KQuGoiicLH5BVhD
         BfZTf43cfEuCI7PvBZ8Ko3Pq42RDW3mnNMrCgHZyvOeJatu9aiAdHh11RxUiB79J9z
         U5nT76fUpgMun0hw8+pdvj7vmWKWOIZkj0oAIQsO8z7TxQweOiAH9Jg2YPBNVM/DDj
         wzF4MF1Skjppw==
Date:   Wed, 29 Jun 2022 08:52:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8944c6fb8add
Message-ID: <Yrx1VOjVJriO+Iv0@magnolia>
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
the next update.  With willy's fix seeming to resolve the generic/522
corruptions, I think this will be the last push to 5.19, and I can begin
examining patches for 5.20.

The new head of the for-next branch is commit:

8944c6fb8add xfs: dont treat rt extents beyond EOF as eofblocks to be cleared

9 new commits:

Darrick J. Wong (5):
      [b822ea17fd15] xfs: always free xattri_leaf_bp when cancelling a deferred op
      [f94e08b602d4] xfs: clean up the end of xfs_attri_item_recover
      [7be3bd8856fb] xfs: empty xattr leaf header blocks are not corruption
      [e53bcffad032] xfs: don't hold xattr leaf buffers across transaction rolls
      [8944c6fb8add] xfs: dont treat rt extents beyond EOF as eofblocks to be cleared

Dave Chinner (2):
      [7cf2b0f9611b] xfs: bound maximum wait time for inodegc work
      [5e672cd69f0a] xfs: introduce xfs_inodegc_push()

Kaixu Xia (2):
      [ca76a761ea24] xfs: factor out the common lock flags assert
      [82af88063961] xfs: use invalidate_lock to check the state of mmap_lock

Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c      | 38 ++++++-------------------
 fs/xfs/libxfs/xfs_attr.h      |  5 ----
 fs/xfs/libxfs/xfs_attr_leaf.c | 35 ++++++++++++-----------
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 +-
 fs/xfs/xfs_attr_item.c        | 27 ++++++++++--------
 fs/xfs/xfs_bmap_util.c        |  2 ++
 fs/xfs/xfs_icache.c           | 56 ++++++++++++++++++++++++-------------
 fs/xfs/xfs_icache.h           |  1 +
 fs/xfs/xfs_inode.c            | 64 +++++++++++++++++--------------------------
 fs/xfs/xfs_mount.h            |  2 +-
 fs/xfs/xfs_qm_syscalls.c      |  9 ++++--
 fs/xfs/xfs_super.c            |  9 ++++--
 fs/xfs/xfs_trace.h            |  1 +
 13 files changed, 123 insertions(+), 129 deletions(-)
