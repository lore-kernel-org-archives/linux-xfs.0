Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B240C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 17:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347990AbiC3RVS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 13:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348094AbiC3RVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 13:21:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0D5BD3A
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 10:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B5BACE1E9A
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 17:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9A8C340EC
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648660767;
        bh=mLFAuXFyvua50VsnziSxgdmYPEjlqlloKWQFeqESs3A=;
        h=Date:From:To:Subject:From;
        b=NPz5zy6n/jiBOicBdltClA8nz6Pa4M+HQsZ5nXQxqNlYBYMYhUBC0/y0m7X9OmVp/
         jro0fs4VRGR7GxoFDjs5FySERab8kdJLrZuBbNEo61fqJOsVPwe1rd5AvFS8xpASGE
         UY8hIAPR3A9/8TdZ4ja/N/Jn8Lb+akhpA1FwspxU/1ey2Kezr7cfb99nL70NVfPxYT
         J9K0FMmFUKQZVLLW047xR1EGjB+MfoCnPtNtHr8+1NWvyR7BmrQMDypWQ9vnKphEvL
         hoMUJoo8wgRaiNoBznXMmmNJFoteVujJwj8bhrR0d4/ilg7/4WEPJ6etSW9FiZy6Il
         JN38zspEewaxA==
Date:   Wed, 30 Mar 2022 10:19:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 919edbadebe1
Message-ID: <20220330171926.GJ27690@magnolia>
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
the next update.  These are all bug fixes that we've been working on for
the past couple of weeks.

A reminder: Dave Chinner will be taking over as XFS maintainer for one
release cycle, starting from the day 5.18-rc1 drops until 5.19-rc1 is
tagged so that I can focus on starting a massive design review for the
(feature complete after five years) online repair feature.

The new head of the for-next branch is commit:

919edbadebe1 xfs: drop async cache flushes from CIL commits.

14 new commits:

Darrick J. Wong (6):
      [93defd5a15dd] xfs: document the XFS_ALLOC_AGFL_RESERVE constant
      [c8c568259772] xfs: don't include bnobt blocks when reserving free block pool
      [15f04fdc75aa] xfs: remove infinite loop when reserving free block pool
      [0baa2657dc4d] xfs: always succeed at setting the reserve pool size
      [82be38bcf8a2] xfs: fix overfilling of reserve pool
      [85bcfa26f9a3] xfs: don't report reserved bnobt space as available

Dave Chinner (8):
      [d2d7c0473586] xfs: aborting inodes on shutdown may need buffer lock
      [ab9c81ef321f] xfs: shutdown in intent recovery has non-intent items in the AIL
      [cd6f79d1fb32] xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks
      [b5f17bec1213] xfs: log shutdown triggers should only shut down the log
      [41e636218358] xfs: xfs_do_force_shutdown needs to block racing shutdowns
      [3c4cb76bce43] xfs: xfs_trans_commit() path must check for log shutdown
      [5652ef31705f] xfs: shutdown during log recovery needs to mark the log shutdown
      [919edbadebe1] xfs: drop async cache flushes from CIL commits.

Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c |  28 ++++++--
 fs/xfs/libxfs/xfs_alloc.h |   1 -
 fs/xfs/xfs_bio_io.c       |  35 ----------
 fs/xfs/xfs_fsops.c        |  60 ++++++++---------
 fs/xfs/xfs_icache.c       |   2 +-
 fs/xfs/xfs_inode.c        |   2 +-
 fs/xfs/xfs_inode_item.c   | 164 +++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode_item.h   |   1 +
 fs/xfs/xfs_linux.h        |   2 -
 fs/xfs/xfs_log.c          | 109 ++++++++++++++++--------------
 fs/xfs/xfs_log_cil.c      |  46 +++++--------
 fs/xfs/xfs_log_priv.h     |  14 +++-
 fs/xfs/xfs_log_recover.c  |  56 ++++++----------
 fs/xfs/xfs_mount.c        |   3 +-
 fs/xfs/xfs_mount.h        |  15 +++++
 fs/xfs/xfs_super.c        |   3 +-
 fs/xfs/xfs_trans.c        |  48 +++++++++-----
 fs/xfs/xfs_trans_ail.c    |   8 +--
 18 files changed, 348 insertions(+), 249 deletions(-)
