Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884C6158DDC
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225433; cv=none; b=sCd+QyC7JikBF/5/9Ak0YkE/+wajInOv8p2Xh1RQp5TLPji7kKy6la20rIkn8NyAQ6j8i3jWrZ4edpj/Fi+UMfcKj269d0UHBcGMR58N9H7jBYTjnlNR9T4e47rl1LmhE5UdmXGQUCrvWzejYYEoJvHFAV0nYt73XdsaGWZQcwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225433; c=relaxed/simple;
	bh=kPtyzUHf+4KGO2V82IX2fPGXxyLJE3fGWQYAD7doXEk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLcisaJIWSTftpeMGpMBCgr40Qo3KjvcLkLcgivD3IENRPDxcNzU9RwuyI52ZOa2pZNaSuYbFlMQTm0QDbuFL7DOMy94gWFf/FyYfywpYdn7sY3oKteRfv9iaWBA64HSKB62/uN+tq6d2VOUyJo33E/eoRZYQsis5LI5PnBOHBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsBlwBSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsBlwBSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588FEC113CC;
	Mon, 15 Apr 2024 23:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225433;
	bh=kPtyzUHf+4KGO2V82IX2fPGXxyLJE3fGWQYAD7doXEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bsBlwBSA0itd/j+C4ag1r8zLoAykQ6IN71Xvrd/lXVLhLv14H0mlUBJ4xMqHX2dsy
	 iykPvwPetV+3C5Op5VL3jjGf7PqOjvPwOR6TIm+6DS/Y61Fv/BjlZUwkd2EjCfT/gs
	 1HjnhxoKcW72rVYrPoiTP4N5gi3X1AQn2JXVEnabtLjODVakA+bS+oGMMYz8F8KvhV
	 qkDIa1TkVWARYBTFN/HyLZEBsUaFtNRP1H+VYgRXp3tOvnZQiDhTrq2y84kndBbjN/
	 ztL/GprAq4mWHQ5BD8E3c1ytNzlu1SHiKi4ZiIL8fGPgnF4aveOGooWiI1UNa4RYDG
	 KvTsyfIcWLHlw==
Date: Mon, 15 Apr 2024 16:57:12 -0700
Subject: [PATCH 3/4] docs: update offline parent pointer repair strategy
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322386162.91896.10339807124129045361.stgit@frogsfrogsfrogs>
In-Reply-To: <171322386102.91896.17539357886365049977.stgit@frogsfrogsfrogs>
References: <171322386102.91896.17539357886365049977.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   81 +++++++++++++++-----
 1 file changed, 60 insertions(+), 21 deletions(-)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 1ea4e59c9cdb..70e3e629d8b3 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4675,26 +4675,56 @@ files are erased long before directory tree connectivity checks are performed.
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
+      name_cookie)`` tuples in a per-AG in-memory slab.  The ``name_hash``
+      referenced in this section is the regular directory entry name hash, not
+      the specialized one used for parent pointer xattrs.
 
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
@@ -4703,28 +4733,37 @@ connectivity checks:
 
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

