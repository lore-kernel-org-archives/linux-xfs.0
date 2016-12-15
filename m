Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35245 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757941AbcLOOIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 09:08:00 -0500
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 8/9] Revert "ext4: avoid deadlocks in the writeback path by using sb_getblk_gfp"
Date: Thu, 15 Dec 2016 15:07:14 +0100
Message-Id: <20161215140715.12732-9-mhocko@kernel.org>
In-Reply-To: <20161215140715.12732-1-mhocko@kernel.org>
References: <20161215140715.12732-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

From: Michal Hocko <mhocko@suse.com>

This reverts commit c45653c341f5c8a0ce19c8f0ad4678640849cb86 because
sb_getblk_gfp is not really needed as
sb_getblk
  __getblk_gfp
    __getblk_slow
      grow_buffers
        grow_dev_page
	  gfp_mask = mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS) | gfp

so __GFP_FS is cleared unconditionally and therefore the above commit
didn't have any real effect in fact.

This patch should not introduce any functional change. The main point
of this change is to reduce explicit GFP_NOFS usage inside ext4 code to
make the review of the remaining usage easier.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/ext4/extents.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b1f8416923ab..ef815eb72389 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -518,7 +518,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
 	struct buffer_head		*bh;
 	int				err;
 
-	bh = sb_getblk_gfp(inode->i_sb, pblk, __GFP_MOVABLE | GFP_NOFS);
+	bh = sb_getblk(inode->i_sb, pblk);
 	if (unlikely(!bh))
 		return ERR_PTR(-ENOMEM);
 
@@ -1096,7 +1096,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		err = -EFSCORRUPTED;
 		goto cleanup;
 	}
-	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
+	bh = sb_getblk(inode->i_sb, newblock);
 	if (unlikely(!bh)) {
 		err = -ENOMEM;
 		goto cleanup;
@@ -1290,7 +1290,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	if (newblock == 0)
 		return err;
 
-	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
+	bh = sb_getblk(inode->i_sb, newblock);
 	if (unlikely(!bh))
 		return -ENOMEM;
 	lock_buffer(bh);
-- 
2.10.2

