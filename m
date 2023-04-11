Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69718C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 01:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDKBGl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 21:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDKBGk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 21:06:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F201998
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 18:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71ECF61857
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 01:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0A8C433D2;
        Tue, 11 Apr 2023 01:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681175198;
        bh=xm0MIDMfQUfD8ouQPcthGahrdjhWqZw5jhsz3m095IY=;
        h=Date:From:To:Cc:Subject:From;
        b=dRjUeUwQMb2/V1SnvuydKpKq6JLk5ay4tim3Cji8cPeve/lvS1ngK9TvRYGB2PKMk
         6j3MnIcWufMF/AC30qRmYo27FK+rYMrDIHjY0v7EbLqCfjzyV0EHlt853Pj8umOlDH
         yRKN6mox3Q1FFKTeKVI+ArtHZqPUAwPvSfhg6lpWZDqYBi+cUJsr5ihHKVPfv0oziU
         plq42gnBv5T7/4vbOKaYLtBEaaZXsN0eyjjPE0Izu09AODH/l4S5harIb2AZHV5a0S
         +DBoFjUXdX39VdI9r90ivX8lIfPvhrO5wCc0fva2tgBOsh3QbxgHlfrU5Gi6EK9t9Q
         W6cBvtJNRMSIg==
Date:   Mon, 10 Apr 2023 18:06:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: _{attr,data}_map_shared should take ILOCK_EXCL until
 iread_extents is completely done
Message-ID: <20230411010638.GF360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While fuzzing the data fork extent count on a btree-format directory
with xfs/375, I observed the following (excerpted) splat:

XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
------------[ cut here ]------------
WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The cause of this is a race condition in xfs_ilock_data_map_shared,
which performs an unlocked access to the data fork to guess which lock
mode it needs:

Thread 0                          Thread 1

xfs_need_iread_extents
<observe no iext tree>
xfs_ilock(..., ILOCK_EXCL)
xfs_iread_extents
<observe no iext tree>
<check ILOCK_EXCL>
<load bmbt extents into iext>
<notice iext size doesn't
 match nextents>
                                  xfs_need_iread_extents
                                  <observe iext tree>
                                  xfs_ilock(..., ILOCK_SHARED)
<tear down iext tree>
xfs_iunlock(..., ILOCK_EXCL)
                                  xfs_iread_extents
                                  <observe no iext tree>
                                  <check ILOCK_EXCL>
                                  *BOOM*

Fix this race by adding a flag to the xfs_ifork structure to indicate
that we have not yet read in the extent records and changing the
predicate to look at the flag state, not if_height.  The memory barrier
ensures that the flag will not be set until the very end of the
function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |    2 ++
 fs/xfs/libxfs/xfs_inode_fork.c |    2 ++
 fs/xfs/libxfs/xfs_inode_fork.h |    3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 34de6e6898c4..5f96e7ce7b4a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1171,6 +1171,8 @@ xfs_iread_extents(
 		goto out;
 	}
 	ASSERT(ir.loaded == xfs_iext_count(ifp));
+	smp_mb();
+	ifp->if_needextents = 0;
 	return 0;
 out:
 	xfs_iext_destroy(ifp);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 6b21760184d9..eadae924dc42 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -174,6 +174,8 @@ xfs_iformat_btree(
 	int			level;
 
 	ifp = xfs_ifork_ptr(ip, whichfork);
+	ifp->if_needextents = 1;
+
 	dfp = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	size = XFS_BMAP_BROOT_SPACE(mp, dfp);
 	nrecs = be16_to_cpu(dfp->bb_numrecs);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index d3943d6ad0b9..e69c78c35c96 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -24,6 +24,7 @@ struct xfs_ifork {
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
+	int8_t			if_needextents;	/* extents have not been read */
 };
 
 /*
@@ -262,7 +263,7 @@ int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
 {
-	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_height == 0;
+	return ifp->if_format == XFS_DINODE_FMT_BTREE && ifp->if_needextents;
 }
 
 #endif	/* __XFS_INODE_FORK_H__ */
