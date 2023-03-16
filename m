Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EE5C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCPTRZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCPTRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:17:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1D9AF699
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11D0A620EB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E96AC4339C;
        Thu, 16 Mar 2023 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994240;
        bh=hlnsQo+C+RPpGBeLzYLGxz5NmY8CZcgbE0GShO8d/PI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KMqEnOf1XPdFUEo/qgR+zQTWw3EYb+XQdZH0F9E0MA4B4kZU6D605TdjO5qV66rfI
         2CHIPf9tBYbD9Ay5A4HjCO8th9Ek4PVQgWKMsVs/lUPQIVQ7l8SUhQ7AepsJzRBjZB
         UskDOOwFwhROlFv9qMjaE0WyNd8IieCleeXHaP0UojG89dXzE6b/Ps664Oqner4L3M
         /RcZ3w3O3TBqk7AS2TjAvzhJAvIeCSy5gF+vseGVeJjOX+j8QNHvOa8paHX4RBbglT
         Lh8RGBwt3a5wXQspfnGKHyBhtLjdKI4Dlz4ejOsRr/qJ4a8RngBevfb6iW4DINjJdX
         FLnJg6ym6IzUQ==
Date:   Thu, 16 Mar 2023 12:17:19 -0700
Subject: [PATCHSET v10r1d2 0/7] xfs: bug fixes for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains the accumulated bug fixes from Darrick to make
fstests pass and online repair work.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-bugfixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-bugfixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-bugfixes
---
 fs/xfs/libxfs/xfs_da_format.h |   11 ++++++
 fs/xfs/libxfs/xfs_fs.h        |   69 +++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_parent.c    |   47 ++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_parent.h    |   24 ++++++-------
 fs/xfs/xfs_inode.c            |   16 ++++-----
 fs/xfs/xfs_ioctl.c            |   47 ++++++++++++-------------
 fs/xfs/xfs_ondisk.h           |    4 +-
 fs/xfs/xfs_parent_utils.c     |   61 +++++++++++++++++----------------
 fs/xfs/xfs_parent_utils.h     |    8 ++--
 fs/xfs/xfs_symlink.c          |    2 +
 fs/xfs/xfs_trace.c            |    1 +
 fs/xfs/xfs_trace.h            |   76 ++++++++++++++++++++++++++++++++++++++++-
 12 files changed, 238 insertions(+), 128 deletions(-)

