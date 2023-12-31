Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F695C147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZk0YVC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAC8C433C8;
	Sun, 31 Dec 2023 22:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062312;
	bh=KC9ELear0CoIIqddJbwKJUL6S58Vzr5a9kpJ0rhL3+o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pZk0YVC22yi1UN7bj04gvSecChNxTXvP0WC2oY7mEJTvgU6w78eAcrGO1bJnxmj68
	 YKK26vjiTKBD45EcMQA+LrGRQeOU5uwA6RV9VU9w0dFQz0G2/r810KzLjutveHFeBF
	 PTPmngAeuMLNPsdFIcicnF7THKaIZI44heK0xcS3qsmyOOUy/dK5KRXxa+X0bcs9kl
	 lvm2tFnAb3CGABFpMYE/+3VFhC4mHrD85CNFhPctX5/8Akix5aoQog0979ht2yG96K
	 Xq1EGiJQJxdZu7gtEyzp1b1OwY6qqK3ozJI7T2FDjnO7QCxt6v91bpLk/2xaCoAp2j
	 pThV84gG/Up2A==
Date: Sun, 31 Dec 2023 14:38:31 -0800
Subject: [PATCH 1/8] xfs_scrub: fix missing scrub coverage for broken inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999048.1797544.5322672088708731038.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

If INUMBERS says that an inode is allocated, but BULKSTAT skips over the
inode and BULKSTAT_SINGLE errors out when loading the inumber, there are
two possibilities: One, we're racing with ifree; or two, the inode is
corrupt and iget failed.

When this happens, the scrub_scan_all_inodes code will insert a dummy
bulkstat record with all fields zeroed except bs_ino and bs_blksize.
Hence the use of i_mode switches in phase3 to schedule file content
scrubbing are not entirely correct -- bs_mode==0 means "type unknown",
which ought to mean "schedule all scrubbers".

Unfortunately, the current code doesn't do that, so instead we schedule
no content scrubs.  If the broken file was actually a directory, we fail
to check the directory contents for further corruptions.

Found by using fuzzing with xfs/385 and core.format = 0.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index 9a26b92036c..b03b55250a3 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -166,16 +166,29 @@ scrub_inode(
 	if (error)
 		goto out;
 
-	if (S_ISLNK(bstat->bs_mode)) {
+	/*
+	 * Check file data contents, e.g. symlink and directory entries.
+	 *
+	 * Note: bs_mode==0 occurs when inumbers says an inode is allocated,
+	 * bulkstat skips the inode, and bulkstat_single errors out when
+	 * loading the inode.  This could be due to racing with ifree, but it
+	 * could be a corrupt inode.  Either way, schedule all the data fork
+	 * content scrubbers.  Better to have them return -ENOENT than miss
+	 * some coverage.
+	 */
+	if (S_ISLNK(bstat->bs_mode) || !bstat->bs_mode) {
 		/* Check symlink contents. */
 		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_SYMLINK,
 				&alist);
-	} else if (S_ISDIR(bstat->bs_mode)) {
+		if (error)
+			goto out;
+	}
+	if (S_ISDIR(bstat->bs_mode) || !bstat->bs_mode) {
 		/* Check the directory entries. */
 		error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_DIR, &alist);
+		if (error)
+			goto out;
 	}
-	if (error)
-		goto out;
 
 	/* Check all the extended attributes. */
 	error = scrub_file(ctx, fd, bstat, XFS_SCRUB_TYPE_XATTR, &alist);

