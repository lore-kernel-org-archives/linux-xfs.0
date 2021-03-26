Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6FCC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBF761A41
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCZAVl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCZAVN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52AB8619FC;
        Fri, 26 Mar 2021 00:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718073;
        bh=rpNGpWYofOXFOB8JX4Ubmfg//97yGPhiPxxPOCUaxMA=;
        h=Subject:From:To:Cc:Date:From;
        b=jLxGxmDK61WdvLabW+As+hnm/Wrm53rs1BRYmFO5EatF2D5w4jz699pnfzaTY2a/N
         AUZtqzW4SzoV6cvFFIMQLOSkKietZdQtIbmwe4qLTM+MkTDycIib4zNEFNiw2ammDx
         Ef6yLyX+6YUzssrUoXvK02JkrEpey65IROF0n5yocPKbhqc942rlc9/J5tQELUVmZd
         gObX3d1uEidKUczoyrgBzRmxzuf8Q8LTDUTePLSEeemX/bLpIQzwwco5F5BDYaletd
         7KpWrDcY08AKgXfXDBuUbQ9H2yH0AZPIyEPQb9tKd3aBb6ypYle1FnzWFQafhjzcpL
         Akfs2beX5dXxQ==
Subject: [PATCHSET v3 0/6] xfs: clean up incore inode walk functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:13 -0700
Message-ID: <161671807287.621936.13471099564526590235.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series reduces the number of indirect function calls when we want
to iterate the incore inode radix tree, and reduces the number of
arguments that must be passed to the walk function.

I made a few observations about incore inode radix tree walks -- the one
caller (blockgc) that cares about radix tree tags is internal to
xfs_icache.c, and there's a 1:1 mapping between that tag and the
iterator function.  Furthermore, the only other caller (quotaoff) is the
only caller to supply a nonzero flags argument, it never specifies a
radix tree tag, and it only walks inodes that have VFS state.

The first patch moves quotaoff to walk the vfs inode list to drop all
attached dquots, which frees us to remove the iter_flags argument and
the indirect function calls from xfs_inode_walk.

Next, we merge the code that walks reclaimable inodes into
xfs_inode_walk and refactor all the code that sets and clears the radix
tree tags in the perag structure and the perag tree itself.

This series is a prerequisite for the next patchset, since deferred
inode inactivation will add another inode radix tree tag and iterator
function to go with it.

v2: walk the vfs inode list when running quotaoff instead of the radix
    tree, then rework the (now completely internal) inode walk function
    to take the tag as the main parameter.
v3: merge the reclaim loop into xfs_inode_walk, then consolidate the
    radix tree tagging functions

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-walk-cleanups-5.13
---
 fs/xfs/libxfs/xfs_sb.c   |    2 
 fs/xfs/libxfs/xfs_sb.h   |    4 
 fs/xfs/xfs_icache.c      |  377 ++++++++++++++++++----------------------------
 fs/xfs/xfs_icache.h      |   18 +-
 fs/xfs/xfs_qm_syscalls.c |   56 ++++---
 fs/xfs/xfs_super.c       |    2 
 fs/xfs/xfs_trace.h       |    6 -
 7 files changed, 194 insertions(+), 271 deletions(-)

