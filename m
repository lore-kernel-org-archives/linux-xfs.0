Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC69BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zj0DAVOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CD6C433C8;
	Sun, 31 Dec 2023 20:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055334;
	bh=4BU3PmoSsnUtaVJ5Hwf0NJxgyA32fJwEUDNQWEQBQtY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zj0DAVOaifqeAAnvVrmK0ZaZ8p8aiUTC4eT0zLOIPVXWEW/ZeWYxAwXwY0FbOKKP2
	 LoCCYNWr+zMlGECUnQk6XkTPFZ1wWUelUGQ4LK7sD1Yfb4IQiGq4EJgULeGnrI+JS+
	 qTKE5TvNEbpalFmWNzJwqFLJygxaVxhPj9mqpzjjUC6kD5u9vzqoqUX+g216UDRKiu
	 4ZsjBcsUS938XH0CvTRS41gTi8O5DBX+6v5q0MDZq/wK3QPyTqVWad7PIHfVe4WB4T
	 /LhgwL6s4CEDUri4qTjp0aeLcRC4LfjN4JbFV6scNBWvHj2Z/I6L/f4pAR5jrb0whm
	 G9s2XzSrHt21g==
Date: Sun, 31 Dec 2023 12:42:14 -0800
Subject: [PATCH 1/4] docs: update the parent pointers documentation to the
 final version
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404839494.1756140.2227622227607708094.stgit@frogsfrogsfrogs>
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
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've decided on the ondisk format of parent pointers, update
the documentation to reflect that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../filesystems/xfs-online-fsck-design.rst         |   91 +++++++++++---------
 1 file changed, 50 insertions(+), 41 deletions(-)


diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
index 827fcd49fe6d5..8fb0fc30f3fa4 100644
--- a/Documentation/filesystems/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs-online-fsck-design.rst
@@ -4464,10 +4464,11 @@ reconstruction of filesystem space metadata.
 The parent pointer feature, however, makes total directory reconstruction
 possible.
 
-XFS parent pointers include the dirent name and location of the entry within
-the parent directory.
+XFS parent pointers contain the information needed to identify the
+corresponding directory entry in the parent directory.
 In other words, child files use extended attributes to store pointers to
-parents in the form ``(parent_inum, parent_gen, dirent_pos) → (dirent_name)``.
+parents in the form ``(parent_inum, parent_gen, dirent_name_hash) →
+(dirent_name)``.
 The directory checking process can be strengthened to ensure that the target of
 each dirent also contains a parent pointer pointing back to the dirent.
 Likewise, each parent pointer can be checked by ensuring that the target of
@@ -4475,8 +4476,6 @@ each parent pointer is a directory and that it contains a dirent matching
 the parent pointer.
 Both online and offline repair can use this strategy.
 
-**Note**: The ondisk format of parent pointers is not yet finalized.
-
 +--------------------------------------------------------------------------+
 | **Historical Sidebar**:                                                  |
 +--------------------------------------------------------------------------+
@@ -4518,8 +4517,54 @@ Both online and offline repair can use this strategy.
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
+| In the end, it was decided that the hash collisions of #5 were not a     |
+| serious issue because the directory/attr btree can handle multiple       |
+| identical extended attribute keys.                                       |
+| Reusing the dirent name hash instead of sha256 is much faster and would  |
+| result in a more compact ondisk format.                                  |
 +--------------------------------------------------------------------------+
 
+
 Case Study: Repairing Directories with Parent Pointers
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
@@ -4568,42 +4613,6 @@ The proposed patchset is the
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
 

