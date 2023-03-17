Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BECDC74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 10:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjCQKxh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 06:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCQKxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 06:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9456AD00
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 03:53:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E03062274
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 10:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FC8C433D2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 10:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679050413;
        bh=uY1Y4WKHaNRYpSi0x78GIL/6TpKPELiDugd0i5fehqA=;
        h=Date:From:To:Subject:From;
        b=JIenCJUYHdMlSeo8hH8+kv3w1RWVbHLILnuJQ8j+qhJjXS6JgBVy1LfzZkiJfH5Jk
         kSgslbead1diZjHvI4+HQ95ANflWbG/VjfhH3iOoYwaW1B7WomF2JMYiqS4VYsA5Bc
         HglYLqApyQzwUs0Tf7lKExLGPMPzMQTg59PfCvGPe4EaOfD7ChzD2NuIcOCJ0fLiBs
         As+gJE4fGUnGp+dHqUGUgJXeNsxHhxNQpf+L0T5Q0GQnCA+kkdfZFbUhbzLb36Q8Db
         FqArwoapDd972PWCsGd4KLIMAChAcPReza9ssATNh5XwXdwSYS8sfCmwpLHW5bOi72
         gy9SWo8k5LidQ==
Date:   Fri, 17 Mar 2023 11:53:29 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to a68dabd45
Message-ID: <20230317105329.cp3r7tjquk3svkwx@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

This contains a libxfs-sync with Linux 6.2.

This should become xfsprogs-6.2 which I plan to release next week, unless
something critical come along.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, or you have any other question, please
let me know.

The new head of the for-next branch is commit:

a68dabd45f3591456ecf7e35f6a6077db79f6bc6

15 new commits:

Darrick J. Wong (11):
      [c3fce4f9b] mkfs: check dirent names when reading protofile
      [fb22e1b1b] mkfs: use suboption processing for -p
      [e0aeb0581] mkfs: substitute slashes with spaces in protofiles
      [b7b81f336] xfs_repair: fix incorrect dabtree hashval comparison
      [4f82f9218] xfs_db: fix complaints about unsigned char casting
      [9061d756b] xfs: add debug knob to slow down writeback for fun
      [fb084f350] xfs: add debug knob to slow down write for fun
      [d1dca9f6b] xfs: hoist refcount record merge predicates
      [b445624f0] xfs: estimate post-merge refcounts correctly
      [88765eda1] xfs: invalidate xfs_bufs when allocating cow extents
      [a68dabd45] xfs: fix off-by-one error in xfs_btree_space_to_height

Dave Chinner (2):
      [1dcdf5051] xfs: use iomap_valid method to detect stale cached iomaps
      [d712be6a9] xfs: drop write error injection is unfixable, remove it

Guo Xuenan (1):
      [f5ef81288] xfs: get rid of assert from xfs_btree_islastblock

Jason A. Donenfeld (1):
      [9a046f967] treewide: use get_random_u32_below() instead of deprecated function

Code Diffstat:

 db/namei.c             |   4 +-
 io/inject.c            |   2 +
 libxfs/libxfs_priv.h   |   2 +-
 libxfs/xfs_alloc.c     |   2 +-
 libxfs/xfs_bmap.c      |   8 ++-
 libxfs/xfs_btree.c     |   7 ++-
 libxfs/xfs_btree.h     |   1 -
 libxfs/xfs_errortag.h  |  18 +++---
 libxfs/xfs_ialloc.c    |   2 +-
 libxfs/xfs_refcount.c  | 146 +++++++++++++++++++++++++++++++++++++++++++------
 man/man8/mkfs.xfs.8.in |  32 +++++++++--
 mkfs/proto.c           |  37 ++++++++++++-
 mkfs/proto.h           |   3 +-
 mkfs/xfs_mkfs.c        |  72 +++++++++++++++++++++---
 repair/da_util.c       |   2 +-
 15 files changed, 288 insertions(+), 50 deletions(-)

-- 
Carlos Maiolino
