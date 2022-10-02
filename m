Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F02C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJBSYL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJBSYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEA025295
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0754C60EDB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62481C433C1;
        Sun,  2 Oct 2022 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735047;
        bh=aldbX97gq4yXFDTwU8YErxRQ6e7QFI1CeC+F81XLm1E=;
        h=Subject:From:To:Cc:Date:From;
        b=mi7s830BSioUektJHN7eI3uY48aP2qNJHDz0XPM+jLEtas3J7IKkFQw75jUuVH8WX
         fczwEUZsgBAgTOGBp0ULs2qilPH8vQWDxpudzfsB0kW6zYhZ52GlPQUPZfn8qpeD8E
         iOgxGAqgNMx+HW+Hmbpvj4lxMWyVbKCzpcn9wDQY+fmnMjpMmLNDlVhaedOfT6+32+
         io5GluOJzYAwNaOIkqsQPvQcHxbD8fVOBknEHMBYq4louxlpYJdNqNpDN1KjRMjYME
         ly+fzqXZmwtiagUMvLhSUNMlknOTXNge0KTcA2aCld6B2mXUgVqzAOlL9beZjBAjsA
         RSUoHP7ZSkAqg==
Subject: [PATCHSET v23.1 0/2] xfs: enhance btree key checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:12 -0700
Message-ID: <166473481246.1084112.5533985608121370791.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series addresses some deficiencies in btree key comparisons that I
noticed while testing online scrub.  The first fixes a bug in the rmap
key comparison that prevents the rmap scrubber from detecting rmap
records for file space allocations with mismatched attr/bmbt flags.
The second patch fixes the scrub btree block checker to ensure that the
keys in the parent block accurately represent the block.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-key-enhancements

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-key-enhancements
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   25 ++++++++++++++------
 fs/xfs/scrub/btree.c           |   49 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 9 deletions(-)

