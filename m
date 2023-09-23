Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC7ECE7A88
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Sep 2023 00:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjIWAjI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Sep 2023 20:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjIWAjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2023 20:39:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC44FB9;
        Fri, 22 Sep 2023 17:39:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAA4C433C7;
        Sat, 23 Sep 2023 00:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695429542;
        bh=cz6lC+ULzRTo4+1tQ8EBRSczQYrUTRgTwy7GRspglN8=;
        h=Date:From:To:Cc:Subject:From;
        b=r4XpZ8a7eS4CkjYNJWjxSZ7G2gQNY9eX5M48eTxwrkyiYcP+Hf3rxXEICqSFUCwdf
         UaJs1QdIJyT9zv7LDH/De5I7XxWqXLXZqLk4ZQSMBkbmLjTnI0WQSlMmw4Eew4aLy4
         1BtwHYgqYu2RudRpJjpdx99X9KYoizeejm6pKS+XvvNLCPLSJEjx1HV21Yj0j7XiW4
         sdNkQvdw5c6mnsCYRVOr1ydm5WNntbIEyq7n3wxPZhyvmcm8fMjncCCWQlVwrMfpql
         W2MGMe0oW1JUbiHm0KauIqSlYqLg5uJb46efo+CnSTo053FHqVPKF8C6JtVsTVMVNy
         0kBB23N70UiRg==
Date:   Fri, 22 Sep 2023 17:39:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     dlemoal@kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
        willy@infradead.org,
        syzbot+4a08ffdf3667b36650a1@syzkaller.appspotmail.com
Subject: [GIT PULL] iomap: fix unshare data corruption bug
Message-ID: <169542943249.26581.2290117144266358331.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for iomap for 6.6-rc3.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0bb80ecc33a8fb5a682236443c1e740d5c917d1d:

Linux 6.6-rc1 (2023-09-10 16:28:41 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.6-fixes-2

for you to fetch changes up to a5f31a5028d1e88e97c3b6cdc3e3bf2da085e232:

iomap: convert iomap_unshare_iter to use large folios (2023-09-19 09:05:35 -0700)

----------------------------------------------------------------
Fixes for 6.6-rc3:

* Return EIO on bad inputs to iomap_to_bh instead of BUGging, to deal
less poorly with block device io racing with block device resizing.
* Fix a stale page data exposure bug introduced in 6.6-rc1 when
unsharing a file range that is not in the page cache.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
iomap: handle error conditions more gracefully in iomap_to_bh

Darrick J. Wong (2):
iomap: don't skip reading in !uptodate folios when unsharing a range
iomap: convert iomap_unshare_iter to use large folios

fs/buffer.c            | 25 ++++++++++++++-----------
fs/iomap/buffered-io.c | 30 ++++++++++++++++++------------
2 files changed, 32 insertions(+), 23 deletions(-)
