Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A86ABA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPfn6hL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DBAC433C8;
	Sun, 31 Dec 2023 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053208;
	bh=cmaQX08T6CdS6d5cREfRazTUo7cFvsc7f+qIx1KqEj4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FPfn6hL5uc/BOvDM4QV+Y1egYL8KiK4ju+wguO8a+eQBjFf1JUncbqvIOqxvglpXT
	 yq4Zq8legUIsm/5HJtJFQ1evPuBZgT9O73Qr1jJ18iNdw4/l8+TjDD1pKqAGtPjYIY
	 x4XvP8i9FcVda+p2WqiULOhQ46sfKmynP9gJ/+MutwSeNILRtcObTZKoy5pGB1Aryz
	 V8j27vrSuJq+meTn5vrOvhWuROliU+bjrsegWg94uH2H3VsUG8U85d7vO+Clra4zxt
	 wfJnX1rJKeETE6O7P6WsBlIlVouzhtN6RRzxMT2GBxPhcK4CBe8yO3Y3D4NDOHQraf
	 vMQ/QKMFpcJvg==
Date: Sun, 31 Dec 2023 12:06:47 -0800
Subject: [PATCH 2/4] xfs: create a predicate to determine if two xfs_names are
 the same
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827004.1747851.5152428546473219997.stgit@frogsfrogsfrogs>
In-Reply-To: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
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

Create a simple predicate to determine if two xfs_names are the same
objects or have the exact same name.  The comparison is always case
sensitive.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.h |    9 +++++++++
 fs/xfs/scrub/dir.c       |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 7d7cd8d808e4d..ac3c264402dda 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -24,6 +24,15 @@ struct xfs_dir3_icleaf_hdr;
 extern const struct xfs_name	xfs_name_dotdot;
 extern const struct xfs_name	xfs_name_dot;
 
+static inline bool
+xfs_dir2_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	return n1 == n2 || (n1->len == n2->len &&
+			    !memcmp(n1->name, n2->name, n1->len));
+}
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d86ab51af9282..076a310b8eb00 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -93,11 +93,11 @@ xchk_dir_actor(
 		return -ECANCELED;
 	}
 
-	if (!strncmp(".", name->name, name->len)) {
+	if (xfs_dir2_samename(name, &xfs_name_dot)) {
 		/* If this is "." then check that the inum matches the dir. */
 		if (ino != dp->i_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
-	} else if (!strncmp("..", name->name, name->len)) {
+	} else if (xfs_dir2_samename(name, &xfs_name_dotdot)) {
 		/*
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.

