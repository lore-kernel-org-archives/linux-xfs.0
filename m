Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E676637C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710052; cv=none; b=CwvCKuH9dpSQinNqeZhI4KyyhV2gXicRJMIjhTPKRdWRvyTPbH/xMREhFM+nS9aLe/OtX5RIJ7K9S/lzJwBBmgjirPjpW5v4qYs6DOI2Kefog1waG8MLpoS4GrYUMP689/hDfoKNk8Co26GdDN49QHhzz1QroK7FKMnblWCVX7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710052; c=relaxed/simple;
	bh=zQibxg6BKExJaRVKtPFQgezsT+jAW3a4r9JYPPwiRqc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsiPzWAmiMS1HBwyoAAUDi7lAbrfIwuXgqklz/xJ7+XkDxbXrb42FKDSBUYpfeZwuxziEmEJKQLaYK3MedP6AXZ1BcQT4uaTHhCzsaQbI5Vnk3jwe2aI+jheu/957LYzQ3KvFgR1xgzj5kZELQvCe83Aa90oGTUTnebwgejCelk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1fNU0Mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1fNU0Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676F1C433C7;
	Wed, 10 Apr 2024 00:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710051;
	bh=zQibxg6BKExJaRVKtPFQgezsT+jAW3a4r9JYPPwiRqc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z1fNU0MzqSgY7sjTWudx2IEglajal3jrgYVOozaHNrd2mHPS+n0lZRR8CUv/7JRF7
	 0KFtF5nnnVQx0k4H/EA853EknBM/MUBUfnZl75xF5HAlCIIy0IyK/P6cgIh4iOBYHk
	 y1beXAcaupml/2zqWazY0tb4bosEFXKDzwA5MuI6u99xXUO6qNphIginxLatHGDjjF
	 2d7GYRnEkBg4uvluTp1EJbsMIgZ4gOGSdVWRRsowKQplWZ1IMAxeCvaQMkN3J02b4Z
	 AHy59coa4gDOKd2tmqmI09nZZY+vPHy94WoVP1H22KGP4B4Wv3gzocbzbPJFlNa8fv
	 aO6FdfUIJ0a4A==
Date: Tue, 09 Apr 2024 17:47:30 -0700
Subject: [PATCH 4/4] docs: describe xfs directory tree online fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270967532.3631017.5046025491953457287.stgit@frogsfrogsfrogs>
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

I've added a scrubber that checks the directory tree structure and fixes
them; describe this in the design documentation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |  124 ++++++++++++++++++++
 1 file changed, 124 insertions(+)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 70e3e629d8b3f..12aa638408304 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4785,6 +4785,130 @@ This scan would have to be converted into a multi-pass scan:
 
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
+This is not possible since the VFS does not take the IOLOCK of a child
+subdirectory when moving that subdirectory, so instead the scanner stabilizes
+the parent -> child relationship by taking the ILOCKs and installing a dirent
+update hook to detect changes.
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

