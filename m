Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AF17D2
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301155; cv=none; b=RedLVbtwei9PWR6sO258KNF/Sg2lUZVfmGWx5IdPkovQbgzK8s47BgJiM9dkIP/MxtLitfn5XT9LRv2gQ6TXc1JYrEsE8m5dRGejgTQgtfhEV9N7JR9YaQmhXU8DbiBu6gnt+1RFmKb1YF+U+uXwqof0cf6h7lRfh/brZlrF3uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301155; c=relaxed/simple;
	bh=EjvTX0S3RP+YLnWQDTXnCPlQNTwO6TTE23xp+/AL9no=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HswsbPrcKb7NMBnZ7PEXLBbuN8XULLkum183dOQoMvpBW7Va774Ye8bHJEoYv4ikk0s+of/Abfk/X8JKDZXH5GiMZ8sAjmYqQsFPnQvUyerjQvXwR4OLEbFxyr+PSBEsR9g1vReQncVe7HskcNPyie2LVuSWkEbC4mQouck+/3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2vdCwQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2vdCwQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843DCC32786;
	Tue, 30 Jul 2024 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301155;
	bh=EjvTX0S3RP+YLnWQDTXnCPlQNTwO6TTE23xp+/AL9no=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H2vdCwQlDP0DgkMseCzfBfgQjPY3JCWO228VIKYCSYyDMmihwc0U+cMOnXnd2C/Xm
	 tU9oIxcdpzO58wiKEEionHe/18Fgmg5ZXohudIeZ/0VzByCbXVuo4gurBkAALvkCvy
	 7DFxSBDXoPCbYI0yWvPtbTktLl6UZKFVeUBn7wnDeqMCo7Q+9ibzr1N3zREawSTRip
	 TMaL6SHctEplvoWMBRd3mmkrXyVcyO4C9aF4zNiI3gFHz7Bjuw5+RqWOfKKEAVm666
	 Km2LOp7cg1xgOqHdaztNB00ZrDALUXupngQ346jubFkiTX7KgfWbUs++u4dh86osvJ
	 lX3c1wMyDC7jA==
Date: Mon, 29 Jul 2024 17:59:15 -0700
Subject: [PATCH 1/8] xfs_scrub: fix missing scrub coverage for broken inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845945.1345965.17007008964633102257.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
References: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase3.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index 9a26b9203..b03b55250 100644
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

