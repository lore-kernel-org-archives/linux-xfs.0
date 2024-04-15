Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39968158DDC
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225418; cv=none; b=PSbrGrH3IGWUhYyk9fZjjZu1ZkrgXquhbr2GOSzRezRGNxdpG+ZdM9SEqtnL4iwYzkqL2fs2lXr1rfau6mi9TaBPIbNHZSu+kptSfIk3SYT2T4ZXPMC4kzC6eqA97v5tAR+KTcqrr/F/tRqGw/hHHbwsBocwHn4sMLebpDgC6dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225418; c=relaxed/simple;
	bh=ZgdE7iYS2LwvQrbO1FG4GTkIZ450w4/P60HjpZHxOzc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxG/fKlb95SMYjHdWSOtrA7YPkOEhjN0WEHPB1U2dSB+pUQZcPTafInsl6VLC/yGdfSx3Wn0p0AUybarrR8rsO0Lcf9VqA4opcvrzQ9Klwt3BehvpYRo2IcXcn/Oh14Ar60MgX9LkdM5rhSTDYTeDy/uRtBLF04c42OKjpiaEWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHKTBxVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHKTBxVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF563C113CC;
	Mon, 15 Apr 2024 23:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225417;
	bh=ZgdE7iYS2LwvQrbO1FG4GTkIZ450w4/P60HjpZHxOzc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MHKTBxVkE7pJ7z5fufyGx6UOhT+/dP8BKH6xUHeL1Bv7hHwYPxWJB4z80XpwiLAW6
	 UD9HN/qmrc7nGBDPd8tH21uvyKbtszjryuq8aM38UDvFrGLf0TG5yRY7VZRNOz8nKC
	 04Jaf1PBYZVia3fLTMG32W0GGWekr0DtuG07/yJOZX3w3DMlIiDRJp8mpxE3sjcT1C
	 yxkMm6VNA6vAIz/BLYxS/Tgsu+qNwyxfdn/4lIX55C5itEDjz5V9wN4AG1fBb/Asov
	 Zgwzch/w0TRaU8EUnaxIp9xuqzRGCj2GiMAvHbm3VRwJCOA1AFGYGsbUkaFLbXQxw/
	 JtDLHUR7gG6cw==
Date: Mon, 15 Apr 2024 16:56:57 -0700
Subject: [PATCH 2/4] docs: update online directory and parent pointer repair
 sections
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322386145.91896.14826186240311168029.stgit@frogsfrogsfrogs>
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

Update the case studies of online directory and parent pointer
reconstruction to reflect what they actually do in the final version.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   55 +++++++++++---------
 1 file changed, 29 insertions(+), 26 deletions(-)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 1e3211d12247..1ea4e59c9cdb 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4576,8 +4576,9 @@ Directory rebuilding uses a :ref:`coordinated inode scan <iscan>` and
 a :ref:`directory entry live update hook <liveupdate>` as follows:
 
 1. Set up a temporary directory for generating the new directory structure,
-   an xfblob for storing entry names, and an xfarray for stashing directory
-   updates.
+   an xfblob for storing entry names, and an xfarray for stashing the fixed
+   size fields involved in a directory update: ``(child inumber, add vs.
+   remove, name cookie, ftype)``.
 
 2. Set up an inode scanner and hook into the directory entry code to receive
    updates on directory operations.
@@ -4586,35 +4587,34 @@ a :ref:`directory entry live update hook <liveupdate>` as follows:
    pointer references the directory of interest.
    If so:
 
-   a. Stash an addname entry for this dirent in the xfarray for later.
+   a. Stash the parent pointer name and an addname entry for this dirent in the
+      xfblob and xfarray, respectively.
 
-   b. When finished scanning that file, flush the stashed updates to the
-      temporary directory.
+   b. When finished scanning that file or the kernel memory consumption exceeds
+      a threshold, flush the stashed updates to the temporary directory.
 
 4. For each live directory update received via the hook, decide if the child
    has already been scanned.
    If so:
 
-   a. Stash an addname or removename entry for this dirent update in the
-      xfarray for later.
+   a. Stash the parent pointer name an addname or removename entry for this
+      dirent update in the xfblob and xfarray for later.
       We cannot write directly to the temporary directory because hook
       functions are not allowed to modify filesystem metadata.
       Instead, we stash updates in the xfarray and rely on the scanner thread
       to apply the stashed updates to the temporary directory.
 
-5. When the scan is complete, atomically exchange the contents of the temporary
+5. When the scan is complete, replay any stashed entries in the xfarray.
+
+6. When the scan is complete, atomically exchange the contents of the temporary
    directory and the directory being repaired.
    The temporary directory now contains the damaged directory structure.
 
-6. Reap the temporary directory.
-
-7. Update the dirent position field of parent pointers as necessary.
-   This may require the queuing of a substantial number of xattr log intent
-   items.
+7. Reap the temporary directory.
 
 The proposed patchset is the
 `parent pointers directory repair
-<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-repair>`_
+<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-fsck>`_
 series.
 
 Case Study: Repairing Parent Pointers
@@ -4624,8 +4624,9 @@ Online reconstruction of a file's parent pointer information works similarly to
 directory reconstruction:
 
 1. Set up a temporary file for generating a new extended attribute structure,
-   an `xfblob<xfblob>` for storing parent pointer names, and an xfarray for
-   stashing parent pointer updates.
+   an xfblob for storing parent pointer names, and an xfarray for stashing the
+   fixed size fields involved in a parent pointer update: ``(parent inumber,
+   parent generation, add vs. remove, name cookie)``.
 
 2. Set up an inode scanner and hook into the directory entry code to receive
    updates on directory operations.
@@ -4634,34 +4635,36 @@ directory reconstruction:
    dirent references the file of interest.
    If so:
 
-   a. Stash an addpptr entry for this parent pointer in the xfblob and xfarray
-      for later.
+   a. Stash the dirent name and an addpptr entry for this parent pointer in the
+      xfblob and xfarray, respectively.
 
-   b. When finished scanning the directory, flush the stashed updates to the
-      temporary directory.
+   b. When finished scanning the directory or the kernel memory consumption
+      exceeds a threshold, flush the stashed updates to the temporary file.
 
 4. For each live directory update received via the hook, decide if the parent
    has already been scanned.
    If so:
 
-   a. Stash an addpptr or removepptr entry for this dirent update in the
-      xfarray for later.
+   a. Stash the dirent name and an addpptr or removepptr entry for this dirent
+      update in the xfblob and xfarray for later.
       We cannot write parent pointers directly to the temporary file because
       hook functions are not allowed to modify filesystem metadata.
       Instead, we stash updates in the xfarray and rely on the scanner thread
       to apply the stashed parent pointer updates to the temporary file.
 
-5. Copy all non-parent pointer extended attributes to the temporary file.
+5. When the scan is complete, replay any stashed entries in the xfarray.
 
-6. When the scan is complete, atomically exchange the mappings of the attribute
+6. Copy all non-parent pointer extended attributes to the temporary file.
+
+7. When the scan is complete, atomically exchange the mappings of the attribute
    forks of the temporary file and the file being repaired.
    The temporary file now contains the damaged extended attribute structure.
 
-7. Reap the temporary file.
+8. Reap the temporary file.
 
 The proposed patchset is the
 `parent pointers repair
-<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-repair>`_
+<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-fsck>`_
 series.
 
 Digression: Offline Checking of Parent Pointers

