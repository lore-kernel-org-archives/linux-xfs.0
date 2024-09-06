Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58371CBE8D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 11:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725622793; cv=none; b=HUXv93j7P3Rd2a9XoI9nlZm5ydf8qobDaJ11RIsUaet1Aal2VydOp3JGSoPi4JHi0S2iHG68kbo4XDZOBkhrI4TkI5zLzy9Cfsthgud4+BVCejLhZzXhkMCPXw9ppJXS/FWFZ761P7eQBAiQl8qm+dPj1Fs9fFnsw2gaZkaM5IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725622793; c=relaxed/simple;
	bh=y3mNa3KrpTR6LzsLZnZ8+Hv6BakhgRMsHG9+YwBD7tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yi09n8yNeMYlV1zXESvY63fKZbuLJm9DW474YM3396eSB0l0Ob4s0a4cJCR9NdQ5aIyHNjQ/GG/bMkXjBlD08JFoUy+6rtuMFHuLXFiitB7RuwjTFjdifUCRXvjNBCplzWiDC+LV2FgR/c3o0zU3uiZUlVjCsQbSWSAEyG2Y9r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnFbGY95; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnFbGY95"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725622790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZqAksm7lAakcihKVsgu3MrhQnkwRLProVURVGQh9ZQ=;
	b=JnFbGY95C0nbLw6wXaHjqouYRww3b2tbZy6u3QXEdFz3cpjWgiDLoStLjeHWz4esKx3vsQ
	D3/FpoWWwF1rwOaKTeS+lVevBJLQerluX3enx0SWqq99N4M37ALgNoYTcA7uehCdHbMFdB
	4qJS0cIqzJ7OSRZETGf5ButcO4FKaag=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-OYkmajudPdm0aX1_BmySkg-1; Fri,
 06 Sep 2024 07:39:49 -0400
X-MC-Unique: OYkmajudPdm0aX1_BmySkg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E42B41955D59;
	Fri,  6 Sep 2024 11:39:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.69])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BCA91956086;
	Fri,  6 Sep 2024 11:39:46 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Darrick Wong <djwong@kernel.org>
Subject: [PATCH 2/1] xfs: don't free cowblocks from under dirty pagecache on unshare
Date: Fri,  6 Sep 2024 07:40:51 -0400
Message-ID: <20240906114051.120743-1-bfoster@redhat.com>
In-Reply-To: <20240903124713.23289-1-bfoster@redhat.com>
References: <20240903124713.23289-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

fallocate unshare mode explicitly breaks extent sharing. When a
command completes, it checks the data fork for any remaining shared
extents to determine whether the reflink inode flag and COW fork
preallocation can be removed. This logic doesn't consider in-core
pagecache and I/O state, however, which means we can unsafely remove
COW fork blocks that are still needed under certain conditions.

For example, consider the following command sequence:

xfs_io -fc "pwrite 0 1k" -c "reflink <file> 0 256k 1k" \
	-c "pwrite 0 32k" -c "funshare 0 1k" <file>

This allocates a data block at offset 0, shares it, and then
overwrites it with a larger buffered write. The overwrite triggers
COW fork preallocation, 32 blocks by default, which maps the entire
32k write to delalloc in the COW fork. All but the shared block at
offset 0 remains hole mapped in the data fork. The unshare command
redirties and flushes the folio at offset 0, removing the only
shared extent from the inode. Since the inode no longer maps shared
extents, unshare purges the COW fork before the remaining 28k may
have written back.

This leaves dirty pagecache backed by holes, which writeback quietly
skips, thus leaving clean, non-zeroed pagecache over holes in the
file. To verify, fiemap shows holes in the first 32k of the file and
reads return different data across a remount:

$ xfs_io -c "fiemap -v" <file>
<file>:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   ...
   1: [8..511]:        hole               504
   ...
$ xfs_io -c "pread -v 4k 8" <file>
00001000:  cd cd cd cd cd cd cd cd  ........
$ umount <mnt>; mount <dev> <mnt>
$ xfs_io -c "pread -v 4k 8" <file>
00001000:  00 00 00 00 00 00 00 00  ........

To avoid this problem, make unshare follow the same rules used for
background cowblock scanning and never purge the COW fork for inodes
with dirty pagecache or in-flight I/O.

Fixes: 46afb0628b ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's another COW issue I came across via some unshare testing. A quick
hack to enable unshare in fsx uncovered it. I'll follow up with a proper
patch for that.

I'm sending this as a 2/1 here just to reflect patch order in my local
tree. Also note that I haven't explicitly tested the fixes commit, but a
quick test to switch back to the old full flush behavior on latest
master also makes the problem go away, so I suspect that's where the
regression was introduced.

Brian

 fs/xfs/xfs_icache.c  |  8 +-------
 fs/xfs/xfs_reflink.c |  3 +++
 fs/xfs/xfs_reflink.h | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 900a6277d931..a1b34e6ccfe2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1278,13 +1278,7 @@ xfs_prep_free_cowblocks(
 	 */
 	if (!sync && inode_is_open_for_write(VFS_I(ip)))
 		return false;
-	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
-	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
-	    atomic_read(&VFS_I(ip)->i_dio_count))
-		return false;
-
-	return true;
+	return xfs_can_free_cowblocks(ip);
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fde6ec8092f..5bf6682e701b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1595,6 +1595,9 @@ xfs_reflink_clear_inode_flag(
 
 	ASSERT(xfs_is_reflink_inode(ip));
 
+	if (!xfs_can_free_cowblocks(ip))
+		return 0;
+
 	error = xfs_reflink_inode_has_shared_extents(*tpp, ip, &needs_flag);
 	if (error || needs_flag)
 		return error;
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index fb55e4ce49fa..4a58e4533671 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -6,6 +6,25 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+/*
+ * Check whether it is safe to free COW fork blocks from an inode. It is unsafe
+ * to do so when an inode has dirty cache or I/O in-flight, even if no shared
+ * extents exist in the data fork, because outstanding I/O may target blocks
+ * that were speculatively allocated to the COW fork.
+ */
+static inline bool
+xfs_can_free_cowblocks(struct xfs_inode *ip)
+{
+	struct inode *inode = VFS_I(ip);
+
+	if ((inode->i_state & I_DIRTY_PAGES) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
+	    atomic_read(&inode->i_dio_count))
+		return false;
+	return true;
+}
+
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
-- 
2.45.0

