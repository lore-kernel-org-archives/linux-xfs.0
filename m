Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbeI2AEr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Sep 2018 20:04:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] iomap: set page dirty after partial delalloc on mkwrite
Date: Fri, 28 Sep 2018 13:39:56 -0400
Message-Id: <20180928173956.42428-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

The iomap page fault mechanism currently dirties the associated page
after the full block range of the page has been allocated. This
leaves the page susceptible to delayed allocations without ever
being set dirty on sub-page block sized filesystems.

For example, consider a page fault on a page with one preexisting
real (non-delalloc) block allocated in the middle of the page. The
first iomap_apply() iteration performs delayed allocation on the
range up to the preexisting block, the next iteration finds the
preexisting block, and the last iteration attempts to perform
delayed allocation on the range after the prexisting block to the
end of the page. If the first allocation succeeds and the final
allocation fails with -ENOSPC, iomap_apply() returns the error and
iomap_page_mkwrite() fails to dirty the page having already
performed partial delayed allocation. This eventually results in the
page being invalidated without ever converting the delayed
allocation to real blocks.

This problem is reliably reproduced by generic/083 on XFS on ppc64
systems (64k page size, 4k block size). It results in leaked
delalloc blocks on inode reclaim, which triggers an assert failure
in xfs_fs_destroy_inode() and filesystem accounting inconsistency.

Move the set_page_dirty() call from iomap_page_mkwrite() to the
actor callback, similar to how the buffer head implementation works.
The actor callback is called iff ->iomap_begin() returns success, so
ensures the page is dirtied as soon as possible after an allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This patch addresses the problem with generic/083, but I'm still in the
process of running broader testing. I wanted to get it on the list for
review in the meantime...

Brian

 fs/iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 74762b1ec233..ec15cf2ec696 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1051,6 +1051,7 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 	} else {
 		WARN_ON_ONCE(!PageUptodate(page));
 		iomap_page_create(inode, page);
+		set_page_dirty(page);
 	}
 
 	return length;
@@ -1090,7 +1091,6 @@ int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
 		length -= ret;
 	}
 
-	set_page_dirty(page);
 	wait_for_stable_page(page);
 	return VM_FAULT_LOCKED;
 out_unlock:
-- 
2.17.1
