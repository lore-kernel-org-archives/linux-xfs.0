Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBD8BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cP0/0OCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA55C433C7;
	Sun, 31 Dec 2023 20:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055350;
	bh=GjP/OI7KVJG80amlTIgiLbalpoispiGGu3uj6hkzYyU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cP0/0OCuJ6ynCutnKprvNWFENsRQcyWjGUHkHuEwMCNtj+bLzQXn0RmA/k7uBxtUS
	 5fFWvZSgVmNHToSv2O7QFswrq053pvEprxSvSdEn8BtV8tDLY+CXi9ALbm+9fq9FIl
	 hRs+YgblZM/+qjQ1ynwIDtywIQrC85PMYmVYhBZvKkNDx+8invozYUa3M1f0Ez28PS
	 MLyKb/lXl97uR96qHSjigc0FEIWbH10WVNSKVSQA1JlDy1nXXMxUm6coHs+xHx53au
	 3VI/M9oQ9ks3f9bktClyVJ3YwFj646AmgJvYhAhvNr/7+tZCsojpvA3rN4F2gB9rtP
	 cpYwRKrwYVf7w==
Date: Sun, 31 Dec 2023 12:42:29 -0800
Subject: [PATCH 2/4] docs: update online directory and parent pointer repair
 sections
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404839510.1756140.12621480111001198603.stgit@frogsfrogsfrogs>
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

Update the case studies of online directory and parent pointer
reconstruction to reflect what they actually do in the final version.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../filesystems/xfs-online-fsck-design.rst         |   58 +++++++++++---------
 1 file changed, 31 insertions(+), 27 deletions(-)


diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
index 8fb0fc30f3fa4..f5ba59b335f8e 100644
--- a/Documentation/filesystems/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs-online-fsck-design.rst
@@ -4572,8 +4572,9 @@ Directory rebuilding uses a :ref:`coordinated inode scan <iscan>` and
 a :ref:`directory entry live update hook <liveupdate>` as follows:
 
 1. Set up a temporary directory for generating the new directory structure,
-   an xfblob for storing entry names, and an xfarray for stashing directory
-   updates.
+   an xfblob for storing entry names, and an xfarray for stashing the fixed
+   size fields involved in a directory update: ``(child inumber, add vs.
+   remove, name cookie, ftype)``.
 
 2. Set up an inode scanner and hook into the directory entry code to receive
    updates on directory operations.
@@ -4582,35 +4583,34 @@ a :ref:`directory entry live update hook <liveupdate>` as follows:
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
 
-5. When the scan is complete, atomically swap the contents of the temporary
-   directory and the directory being repaired.
+5. When the scan is complete, replay any stashed entries in the xfarray.
+
+6. Atomically swap the contents of the temporary directory and the directory
+   being repaired.
    The temporary directory now contains the damaged directory structure.
 
 6. Reap the temporary directory.
 
-7. Update the dirent position field of parent pointers as necessary.
-   This may require the queuing of a substantial number of xattr log intent
-   items.
-
 The proposed patchset is the
 `parent pointers directory repair
-<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-repair>`_
+<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-fsck>`_
 series.
 
 Case Study: Repairing Parent Pointers
@@ -4620,8 +4620,9 @@ Online reconstruction of a file's parent pointer information works similarly to
 directory reconstruction:
 
 1. Set up a temporary file for generating a new extended attribute structure,
-   an `xfblob<xfblob>` for storing parent pointer names, and an xfarray for
-   stashing parent pointer updates.
+   an xfblob for storing parent pointer names, and an xfarray for stashing the
+   fixed size fields involved in a parent pointer update: ``(parent inumber,
+   parent generation, add vs. remove, name cookie)``.
 
 2. Set up an inode scanner and hook into the directory entry code to receive
    updates on directory operations.
@@ -4630,34 +4631,37 @@ directory reconstruction:
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
 
-6. When the scan is complete, atomically swap the attribute fork of the
-   temporary file and the file being repaired.
-   The temporary file now contains the damaged extended attribute structure.
+6. Copy all non-parent pointer extended attributes to the temporary file.
+
+7. Atomically swap the attribute fork of the temporary file and the file being
+   repaired.
+   The temporary file now contains the old extended attribute structure
+   containing the damaged parent pointers.
 
 7. Reap the temporary file.
 
 The proposed patchset is the
 `parent pointers repair
-<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-repair>`_
+<https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-fsck>`_
 series.
 
 Digression: Offline Checking of Parent Pointers

