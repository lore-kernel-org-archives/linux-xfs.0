Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82759158DDC
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225402; cv=none; b=uE3gNZti/7prt9EIMBPEoXoTTgR5X5CbiyYWkWi2GrIIj7ZOpcpCNG9T4zMGuA881O5h3ZiRFG5L97IwR48gssMaXkFt5DGc775U4qulQryQ/cFVFfd/aFD5qOrTHbwm+oYavJXujP5AAm24UF6GEdn+jXSReO8ZRYj9f6ikQhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225402; c=relaxed/simple;
	bh=eYfBjlwEID+HoTgimz7i2QmdR7dqY7MPjD8JKz8dP+I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dPCzzr9PZTKYRBkJ74KBp8frFqQEJDMlrWuNr8dfBupjU4DNF5urCViu5RUJLJAa+1ydYtnQFHjfP/J4Cy5Qimq8TN2KKo9zhyDZo+e4kt7XDg255B4H6a1AnQNXd0sxO4Nk1ZzeOG24zSIHcmOr41jauhK+/wXz8PlI9tpdnpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lm2G5VEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lm2G5VEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BC5C113CC;
	Mon, 15 Apr 2024 23:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225402;
	bh=eYfBjlwEID+HoTgimz7i2QmdR7dqY7MPjD8JKz8dP+I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lm2G5VEb9edM/WapvDLZmU0eFYN+WVeKT7k5r1BJw8U2TgVlvoFxthbUMO7dbOytf
	 VqyAIU08Ntsv+s4CYN71dgV7gBVuHiYfz+T+YtQ5aVdNsAB3pLuH8MCjIB6DO300ST
	 j8kFiF62PEn0dQD9jEXPFVZVAyb1LGIsUCNokm2q9+ohKizf41kZ2Uxe0hrpjY2uGz
	 MWGeCroGejTCUmThagmRo3Mx5EFz8rr3G1rEKvmfCsOqRXrGNvOWYvr601Go283rNA
	 b1+qSDzJervbw/2wbCQy7ngZAOnPhp9/49KEA/GnEJkcXe6IHpwArFZXqxxA/t862Q
	 oThhoIzD5mYrQ==
Date: Mon, 15 Apr 2024 16:56:41 -0700
Subject: [PATCH 1/4] docs: update the parent pointers documentation to the
 final version
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322386129.91896.14510868533818236418.stgit@frogsfrogsfrogs>
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
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've decided on the ondisk format of parent pointers, update
the documentation to reflect that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   94 +++++++++++---------
 1 file changed, 53 insertions(+), 41 deletions(-)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 74a8e42c74bd..1e3211d12247 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4465,10 +4465,10 @@ reconstruction of filesystem space metadata.
 The parent pointer feature, however, makes total directory reconstruction
 possible.
 
-XFS parent pointers include the dirent name and location of the entry within
-the parent directory.
+XFS parent pointers contain the information needed to identify the
+corresponding directory entry in the parent directory.
 In other words, child files use extended attributes to store pointers to
-parents in the form ``(parent_inum, parent_gen, dirent_pos) → (dirent_name)``.
+parents in the form ``(dirent_name) → (parent_inum, parent_gen)``.
 The directory checking process can be strengthened to ensure that the target of
 each dirent also contains a parent pointer pointing back to the dirent.
 Likewise, each parent pointer can be checked by ensuring that the target of
@@ -4476,8 +4476,6 @@ each parent pointer is a directory and that it contains a dirent matching
 the parent pointer.
 Both online and offline repair can use this strategy.
 
-**Note**: The ondisk format of parent pointers is not yet finalized.
-
 +--------------------------------------------------------------------------+
 | **Historical Sidebar**:                                                  |
 +--------------------------------------------------------------------------+
@@ -4519,8 +4517,58 @@ Both online and offline repair can use this strategy.
 | Chandan increased the maximum extent counts of both data and attribute   |
 | forks, thereby ensuring that the extended attribute structure can grow   |
 | to handle the maximum hardlink count of any file.                        |
+|                                                                          |
+| For this second effort, the ondisk parent pointer format as originally   |
+| proposed was ``(parent_inum, parent_gen, dirent_pos) → (dirent_name)``.  |
+| The format was changed during development to eliminate the requirement   |
+| of repair tools needing to to ensure that the ``dirent_pos`` field       |
+| always matched when reconstructing a directory.                          |
+|                                                                          |
+| There were a few other ways to have solved that problem:                 |
+|                                                                          |
+| 1. The field could be designated advisory, since the other three values  |
+|    are sufficient to find the entry in the parent.                       |
+|    However, this makes indexed key lookup impossible while repairs are   |
+|    ongoing.                                                              |
+|                                                                          |
+| 2. We could allow creating directory entries at specified offsets, which |
+|    solves the referential integrity problem but runs the risk that       |
+|    dirent creation will fail due to conflicts with the free space in the |
+|    directory.                                                            |
+|                                                                          |
+|    These conflicts could be resolved by appending the directory entry    |
+|    and amending the xattr code to support updating an xattr key and      |
+|    reindexing the dabtree, though this would have to be performed with   |
+|    the parent directory still locked.                                    |
+|                                                                          |
+| 3. Same as above, but remove the old parent pointer entry and add a new  |
+|    one atomically.                                                       |
+|                                                                          |
+| 4. Change the ondisk xattr format to                                     |
+|    ``(parent_inum, name) → (parent_gen)``, which would provide the attr  |
+|    name uniqueness that we require, without forcing repair code to       |
+|    update the dirent position.                                           |
+|    Unfortunately, this requires changes to the xattr code to support     |
+|    attr names as long as 263 bytes.                                      |
+|                                                                          |
+| 5. Change the ondisk xattr format to ``(parent_inum, hash(name)) →       |
+|    (name, parent_gen)``.                                                 |
+|    If the hash is sufficiently resistant to collisions (e.g. sha256)     |
+|    then this should provide the attr name uniqueness that we require.    |
+|    Names shorter than 247 bytes could be stored directly.                |
+|                                                                          |
+| 6. Change the ondisk xattr format to ``(dirent_name) → (parent_ino,      |
+|    parent_gen)``.  This format doesn't require any of the complicated    |
+|    nested name hashing of the previous suggestions.  However, it was     |
+|    discovered that multiple hardlinks to the same inode with the same    |
+|    filename caused performance problems with hashed xattr lookups, so    |
+|    the parent inumber is now xor'd into the hash index.                  |
+|                                                                          |
+| In the end, it was decided that solution #6 was the most compact and the |
+| most performant.  A new hash function was designed for parent pointers.  |
 +--------------------------------------------------------------------------+
 
+
 Case Study: Repairing Directories with Parent Pointers
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
@@ -4569,42 +4617,6 @@ The proposed patchset is the
 <https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-repair>`_
 series.
 
-**Unresolved Question**: How will repair ensure that the ``dirent_pos`` fields
-match in the reconstructed directory?
-
-*Answer*: There are a few ways to solve this problem:
-
-1. The field could be designated advisory, since the other three values are
-   sufficient to find the entry in the parent.
-   However, this makes indexed key lookup impossible while repairs are ongoing.
-
-2. We could allow creating directory entries at specified offsets, which solves
-   the referential integrity problem but runs the risk that dirent creation
-   will fail due to conflicts with the free space in the directory.
-
-   These conflicts could be resolved by appending the directory entry and
-   amending the xattr code to support updating an xattr key and reindexing the
-   dabtree, though this would have to be performed with the parent directory
-   still locked.
-
-3. Same as above, but remove the old parent pointer entry and add a new one
-   atomically.
-
-4. Change the ondisk xattr format to ``(parent_inum, name) → (parent_gen)``,
-   which would provide the attr name uniqueness that we require, without
-   forcing repair code to update the dirent position.
-   Unfortunately, this requires changes to the xattr code to support attr
-   names as long as 263 bytes.
-
-5. Change the ondisk xattr format to ``(parent_inum, hash(name)) →
-   (name, parent_gen)``.
-   If the hash is sufficiently resistant to collisions (e.g. sha256) then
-   this should provide the attr name uniqueness that we require.
-   Names shorter than 247 bytes could be stored directly.
-
-Discussion is ongoing under the `parent pointers patch deluge
-<https://www.spinics.net/lists/linux-xfs/msg69397.html>`_.
-
 Case Study: Repairing Parent Pointers
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 

