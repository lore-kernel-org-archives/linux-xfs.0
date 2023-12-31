Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AF1BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ji92xeu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D0FC433C8;
	Sun, 31 Dec 2023 20:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055366;
	bh=lb3YhD/0+nI8Bit9Z0z1iUBHzfKLFIE2onwgnC76JeI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ji92xeu06WfxtIscRNGt5J09zCN077mhRlDNonvqOIPOZmLVbMAh/Vl9iNOaANAQW
	 I/Xl5nSV5dw2PJRSyKLCMXcfpTBi7LdBP2E0EKsMhDJuFVOpVnByxqM4v1js+pVvrS
	 s2+JSp6leWt5q0LNylUuINKo/JrFnWGKRh/DEGcvWjGqUUJGX8iP9f8GJPewQFHiVQ
	 zypa9XGWcpqCIbFIgQu4syGICXN5cSwN+wktmnLfWqxb03I1jJSaOIVPnj17bDvqMl
	 l/mMJEcOZfjtPCAiE+fZ+eW18ImRtNtinxYalLldtU/6IVBDbt4tAGH49+E5B3ootQ
	 gQRzXVGhGVB0w==
Date: Sun, 31 Dec 2023 12:42:45 -0800
Subject: [PATCH 3/4] docs: update offline parent pointer repair strategy
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404839525.1756140.8535506633322967883.stgit@frogsfrogsfrogs>
In-Reply-To: <170404839471.1756140.4033459504904771587.stgit@frogsfrogsfrogs>
References: <170404839471.1756140.4033459504904771587.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now update how xfs_repair checks and repairs parent pointer info.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../filesystems/xfs-online-fsck-design.rst         |   79 +++++++++++++++-----
 1 file changed, 58 insertions(+), 21 deletions(-)


diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
index f5ba59b335f8e..04e445d79f2d4 100644
--- a/Documentation/filesystems/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs-online-fsck-design.rst
@@ -4672,26 +4672,54 @@ files are erased long before directory tree connectivity checks are performed.
 Parent pointer checks are therefore a second pass to be added to the existing
 connectivity checks:
 
-1. After the set of surviving files has been established (i.e. phase 6),
+1. After the set of surviving files has been established (phase 6),
    walk the surviving directories of each AG in the filesystem.
    This is already performed as part of the connectivity checks.
 
-2. For each directory entry found, record the name in an xfblob, and store
-   ``(child_ag_inum, parent_inum, parent_gen, dirent_pos)`` tuples in a
-   per-AG in-memory slab.
+2. For each directory entry found,
+
+   a. If the name has already been stored in the xfblob, then use that cookie
+      and skip the next step.
+
+   b. Otherwise, record the name in an xfblob, and remember the xfblob cookie.
+      Unique mappings are critical for
+
+      1. Deduplicating names to reduce memory usage, and
+
+      2. Creating a stable sort key for the parent pointer indexes so that the
+         parent pointer validation described below will work.
+
+   c. Store ``(child_ag_inum, parent_inum, parent_gen, name_hash, name_len,
+      name_cookie)`` tuples in a per-AG in-memory slab.
 
 3. For each AG in the filesystem,
 
-   a. Sort the per-AG tuples in order of child_ag_inum, parent_inum, and
-      dirent_pos.
+   a. Sort the per-AG tuple set in order of ``child_ag_inum``, ``parent_inum``,
+      ``name_hash``, and ``name_cookie``.
+      Having a single ``name_cookie`` for each ``name`` is critical for
+      handling the uncommon case of a directory containing multiple hardlinks
+      to the same file where all the names hash to the same value.
 
    b. For each inode in the AG,
 
       1. Scan the inode for parent pointers.
-         Record the names in a per-file xfblob, and store ``(parent_inum,
-         parent_gen, dirent_pos)`` tuples in a per-file slab.
+         For each parent pointer found,
 
-      2. Sort the per-file tuples in order of parent_inum, and dirent_pos.
+         a. Validate the ondisk parent pointer.
+            If validation fails, move on to the next parent pointer in the
+            file.
+
+         b. If the name has already been stored in the xfblob, then use that
+            cookie and skip the next step.
+
+         c. Record the name in a per-file xfblob, and remember the xfblob
+            cookie.
+
+         d. Store ``(parent_inum, parent_gen, name_hash, name_len,
+            name_cookie)`` tuples in a per-file slab.
+
+      2. Sort the per-file tuples in order of ``parent_inum``, ``name_hash``,
+         and ``name_cookie``.
 
       3. Position one slab cursor at the start of the inode's records in the
          per-AG tuple slab.
@@ -4700,28 +4728,37 @@ connectivity checks:
 
       4. Position a second slab cursor at the start of the per-file tuple slab.
 
-      5. Iterate the two cursors in lockstep, comparing the parent_ino and
-         dirent_pos fields of the records under each cursor.
+      5. Iterate the two cursors in lockstep, comparing the ``parent_ino``,
+         ``name_hash``, and ``name_cookie`` fields of the records under each
+         cursor:
 
-         a. Tuples in the per-AG list but not the per-file list are missing and
-            need to be written to the inode.
+         a. If the per-AG cursor is at a lower point in the keyspace than the
+            per-file cursor, then the per-AG cursor points to a missing parent
+            pointer.
+            Add the parent pointer to the inode and advance the per-AG
+            cursor.
 
-         b. Tuples in the per-file list but not the per-AG list are dangling
-            and need to be removed from the inode.
+         b. If the per-file cursor is at a lower point in the keyspace than
+            the per-AG cursor, then the per-file cursor points to a dangling
+            parent pointer.
+            Remove the parent pointer from the inode and advance the per-file
+            cursor.
 
-         c. For tuples in both lists, update the parent_gen and name components
-            of the parent pointer if necessary.
+         c. Otherwise, both cursors point at the same parent pointer.
+            Update the parent_gen component if necessary.
+            Advance both cursors.
 
 4. Move on to examining link counts, as we do today.
 
 The proposed patchset is the
 `offline parent pointers repair
-<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-repair>`_
+<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-fsck>`_
 series.
 
-Rebuilding directories from parent pointers in offline repair is very
-challenging because it currently uses a single-pass scan of the filesystem
-during phase 3 to decide which files are corrupt enough to be zapped.
+Rebuilding directories from parent pointers in offline repair would be very
+challenging because xfs_repair currently uses two single-pass scans of the
+filesystem during phases 3 and 4 to decide which files are corrupt enough to be
+zapped.
 This scan would have to be converted into a multi-pass scan:
 
 1. The first pass of the scan zaps corrupt inodes, forks, and attributes

