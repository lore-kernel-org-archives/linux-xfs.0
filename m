Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42910387
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710036; cv=none; b=g7U0j9AY8JWYa8nmL5T/YKXFht+n+MMs5H48j7vyLU6dLIQwaDQqD4whQFdja+um0GdQelH8IW8pJiKRCo2WFj3LxiJnHAkqz2h1EkF8nqN5IgwOkCswkLR34ezuP0Sxvx9+ArbqD3LoADFROQIUjUkiZrAt8CIbvoFNmizxLvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710036; c=relaxed/simple;
	bh=2x1jxf3SYyYde24kWXsAKADu9B+pkZTSxSQYHtmKU9Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjPxCH4v8FMTn0MV75q2ZdQ9pMQ/Q5INPx+oz27yT/xidRipR279y9q6NaCpc8gGe+Mu+sSyzA7+qtcy0cVLiQLjMlmQxW7fGx6eVgMpoPmAJyatkZ7tkcwBmhZVNj7lcpP6vTx5KPqNgIkT0fA2trUJ9ArSzEyiIhYs19ERQUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/6lvKyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/6lvKyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C90C433C7;
	Wed, 10 Apr 2024 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710035;
	bh=2x1jxf3SYyYde24kWXsAKADu9B+pkZTSxSQYHtmKU9Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t/6lvKyLwdvL/DllFzHFqFx7Up2sfN6+vEe1b0DrwWuRxC5I7+/eoIinYHgniwy6U
	 IxvBsTvjjvFXLr9EWODZf9w0R5BN5TCBWt4pgzck/dsTaYagshphnt+MGqRSY68h1N
	 e6NzZ+fNzsiSdu0F4YL5lOWy6HlsGvSG4zfQ4eTOrsz+wZD93fE+mpI62sXDgFPpCc
	 35DHHeINPRG7Kg4KqwSbERjcL8/1TN1QHC6P09McAeol6v737nFpSIdXJ9UlbXjeJp
	 JrvOhFaLS82Y9qpXjvfymHsAGM8s8TQhB4gGdgC+xm8TOs5YQZXQOtDYEpkEsutOk9
	 s/Dbed66vJoEA==
Date: Tue, 09 Apr 2024 17:47:15 -0700
Subject: [PATCH 3/4] docs: update offline parent pointer repair strategy
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270967515.3631017.5330745726828504817.stgit@frogsfrogsfrogs>
In-Reply-To: <171270967457.3631017.1709831303627611754.stgit@frogsfrogsfrogs>
References: <171270967457.3631017.1709831303627611754.stgit@frogsfrogsfrogs>
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
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   81 +++++++++++++++-----
 1 file changed, 60 insertions(+), 21 deletions(-)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 1ea4e59c9cdbd..70e3e629d8b3f 100644
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

