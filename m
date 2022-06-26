Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D7AC43334
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 21:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiFZV7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 17:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZV7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 17:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C4D2DC5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 14:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6169DB80D37
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 21:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15842C34114
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 21:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656280739;
        bh=OPTQy3Z68oRgNMEWL2N8/9LOyKstqrw7Bdr+S4JKnVI=;
        h=Date:From:To:Subject:From;
        b=sH/hKvKGr7ihVPeVwUj8wPOMaZNfn+hiVA5+Rm9j+Cw6nUUvC6u1DFAtmxqu9W9PI
         Hi45S23h6m77nebgfLR/5j6JwI0LkdjlDF11iuU7R/xIK3QVICCjpNKK+/WTM+EMoL
         7XGBwwYOjjzAjW/xsYbUgO0Bco0UUgiee81nEi0dPhvIVeh7VWhhv1zrOFEoqP+XqK
         IaOlPhe1I8InmckbChCYI3Gc8fSZ1h286GD8Yo7nx37FmoPpWjnKbuz5L0W1br3uNs
         Il68i6Q6kLHNL42wonscXYU2+Xm4JBny6nGXS2Zp/B5IoZpmsJ+iSnncgeckyEVFiu
         BfRzbmR/RlTEg==
Date:   Sun, 26 Jun 2022 14:58:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to f94e08b602d4
Message-ID: <YrjWoqrD9b71b00+@magnolia>
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
the next update.

I'm /still/ trying to fix all the new problems I've observed since -rc1
dropped -- I will send shortly three more patches to fix a regression in
log recovery and a realtime hang; and I've still not been able to
diagnose why generic/522 fails after 20-25 minutes now that multipage
folios have been turned on.

The new head of the for-next branch is commit:

f94e08b602d4 xfs: clean up the end of xfs_attri_item_recover

6 new commits:

Darrick J. Wong (2):
      [b822ea17fd15] xfs: always free xattri_leaf_bp when cancelling a deferred op
      [f94e08b602d4] xfs: clean up the end of xfs_attri_item_recover

Dave Chinner (2):
      [7cf2b0f9611b] xfs: bound maximum wait time for inodegc work
      [5e672cd69f0a] xfs: introduce xfs_inodegc_push()

Kaixu Xia (2):
      [ca76a761ea24] xfs: factor out the common lock flags assert
      [82af88063961] xfs: use invalidate_lock to check the state of mmap_lock

Code Diffstat:

 fs/xfs/xfs_attr_item.c   | 43 +++++++++++++++++++++++++-------
 fs/xfs/xfs_icache.c      | 56 ++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_icache.h      |  1 +
 fs/xfs/xfs_inode.c       | 64 +++++++++++++++++++-----------------------------
 fs/xfs/xfs_mount.h       |  2 +-
 fs/xfs/xfs_qm_syscalls.c |  9 ++++---
 fs/xfs/xfs_super.c       |  9 ++++---
 fs/xfs/xfs_trace.h       |  1 +
 8 files changed, 111 insertions(+), 74 deletions(-)
