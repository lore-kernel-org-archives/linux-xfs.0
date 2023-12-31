Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2142BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzmL+DuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF2AC433C7;
	Sun, 31 Dec 2023 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055381;
	bh=omEykhFRDC+59zM4UYnykqrU4uM9EigjUFr44JkJrb8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BzmL+DuY54JKw/N2BwdDNMZ05Nw8ECzy3JgfJcioF/9qs2faRE/aexhEg3bgDT8z3
	 ZmcnNS8jRMXvS9UxsNHRvW3GJYj+iysikVLn73rAsitrtn6DAqJsgnb4hgpvePQiHz
	 xEdzHY/ihvbmeTTGf2OQ6IvXewotuRKpsWKwqO0aMsTwwa1xmb9n1ewOZdxdj4GjG0
	 Gt075Asp8YACLOB37IHZSFKrmM/f+NSFHRB/i0FbFMEwR5gb8rdQsIhSHbR8AyqgrW
	 fzQVi23FyMw6eNe+m8i1iWuluyJw5REMQtRXu2xOa+6mzzydsCGAikM/QAo1LjNzoL
	 9eu/G3jJSNpXA==
Date: Sun, 31 Dec 2023 12:43:01 -0800
Subject: [PATCH 4/4] docs: describe xfs directory tree online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404839541.1756140.14306767364283206225.stgit@frogsfrogsfrogs>
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

I've added a scrubber that checks the directory tree structure and fixes
them; describe this in the design documentation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../filesystems/xfs-online-fsck-design.rst         |  121 ++++++++++++++++++++
 1 file changed, 121 insertions(+)


diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
index 04e445d79f2d4..29e123189d303 100644
--- a/Documentation/filesystems/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs-online-fsck-design.rst
@@ -4780,6 +4780,127 @@ This scan would have to be converted into a multi-pass scan:
 
 This code has not yet been constructed.
 
+.. _dirtree:
+
+Case Study: Directory Tree Structure
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+As mentioned earlier, the filesystem directory tree is supposed to be a
+directed acylic graph structure.
+However, each node in this graph is a separate ``xfs_inode`` object with its
+own locks, which makes validating the tree qualities difficult.
+Fortunately, non-directories are allowed to have multiple parents and cannot
+have children, so only directories need to be scanned.
+Directories typically constitute 5-10% of the files in a filesystem, which
+reduces the amount of work dramatically.
+
+If the directory tree could be frozen, it would be easy to discover cycles and
+disconnected regions by running a depth (or breadth) first search downwards
+from the root directory and marking a bitmap for each directory found.
+At any point in the walk, trying to set an already set bit means there is a
+cycle.
+After the scan completes, XORing the marked inode bitmap with the inode
+allocation bitmap reveals disconnected inodes.
+However, one of online repair's design goals is to avoid locking the entire
+filesystem unless it's absolutely necessary.
+Directory tree updates can move subtrees across the scanner wavefront on a live
+filesystem, so the bitmap algorithm cannot be applied.
+
+Directory parent pointers enable an incremental approach to validation of the
+tree structure.
+Instead of using one thread to scan the entire filesystem, multiple threads can
+walk from individual subdirectories upwards towards the root.
+For this to work, all directory entries and parent pointers must be internally
+consistent, each directory entry must have a parent pointer, and the link
+counts of all directories must be correct.
+Each scanner thread must be able to take the IOLOCK of an alleged parent
+directory while holding the IOLOCK of the child directory to prevent either
+directory from being moved within the tree.
+This was made possible only recently with locking changes in Linux 6.5.
+
+The scanning process uses a dirent hook to detect changes to the directories
+mentioned in the scan data.
+The scan works as follows:
+
+1. For each subdirectory in the filesystem,
+
+   a. For each parent pointer of that subdirectory,
+
+      1. Create a path object for that parent pointer, and mark the
+         subdirectory inode number in the path object's bitmap.
+
+      2. Record the parent pointer name and inode number in a path structure.
+
+      3. If the alleged parent is the subdirectory being scrubbed, the path is
+         a cycle.
+         Mark the path for deletion and repeat step 1a with the next
+         subdirectory parent pointer.
+
+      4. Try to mark the alleged parent inode number in a bitmap in the path
+         object.
+         If the bit is already set, then there is a cycle in the directory
+         tree.
+         Mark the path as a cycle and repeat step 1a with the next subdirectory
+         parent pointer.
+
+      5. Load the alleged parent.
+         If the alleged parent is not a linked directory, abort the scan
+         because the parent pointer information is inconsistent.
+
+      6. For each parent pointer of this alleged ancestor directory,
+
+         a. Record the parent pointer name and inode number in the path object
+            if no parent has been set for that level.
+
+         b. If an ancestor has more than one parent, mark the path as corrupt.
+            Repeat step 1a with the next subdirectory parent pointer.
+
+         c. Repeat steps 1a3-1a6 for the ancestor identified in step 1a6a.
+            This repeats until the directory tree root is reached or no parents
+            are found.
+
+      7. If the walk terminates at the root directory, mark the path as ok.
+
+      8. If the walk terminates without reaching the root, mark the path as
+         disconnected.
+
+2. If the directory entry update hook triggers, check all paths already found
+   by the scan.
+   If the entry matches part of a path, mark that path and the scan stale.
+   When the scanner thread sees that the scan has been marked stale, it deletes
+   all scan data and starts over.
+
+Repairing the directory tree works as follows:
+
+1. Walk each path of the target subdirectory.
+
+   a. Corrupt paths and cycle paths are counted as suspect.
+
+   b. Paths already marked for deletion are counted as bad.
+
+   c. Paths that reached the root are counted as good.
+
+2. If the subdirectory is either the root directory or has zero link count,
+   delete all incoming directory entries in the immediate parents.
+   Repairs are complete.
+
+3. If the subdirectory has exactly one path, set the dotdot entry to the
+   parent and exit.
+
+4. If the subdirectory has at least one good path, delete all the other
+   incoming directory entries in the immediate parents.
+
+5. If the subdirectory has no good paths and more than one suspect path, delete
+   all the other incoming directory entries in the immediate parents.
+
+6. If the subdirectory has zero paths, attach it to the lost and found.
+
+The proposed patches are in the
+`directory tree repair
+<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-directory-tree>`_
+series.
+
+
 .. _orphanage:
 
 The Orphanage

