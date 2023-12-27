Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA46384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeL4Kz7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D007EC433C9;
	Mon,  1 Jan 2024 00:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068331;
	bh=J/Mc5H/lWHPrgqeVao/5YNyfX9MunT6tNZXRv9pM3dc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AeL4Kz7lVRJgcC47VpRaxVzq3yY2RjQvxakXQS5Y0kW8aXApFELeyP4CG4Uob93rJ
	 CuiX6+Ubcp5RyxE1RvttvGOHS1pNqUJDCvnznABewYJODCKAWFGdYjrnzxn19+2o5r
	 iMJZv0Hg1+qa4fUvfDTj9NuRtj/dzkrL0s2Iyfd7jumsuK/0GlzgQjBA1+aEmF3Eso
	 NGSYkA7+l0uwrOEi6dxkFZ3vjb2WoihITe+kf6OMwmKXah/DUF2apExbIAAjU9/yGu
	 Yr4fbXcjRED2mJMzSlsOVSOkFE4mkCTtQYau//mShDkcQmMQHF+gGdMO7Na+my/z+P
	 7XZFCsYb8azbA==
Date: Sun, 31 Dec 2023 16:18:51 +9900
Subject: [PATCH 32/47] libxfs: dirty buffers should be marked uptodate too
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015739.1815505.4360949566104494215.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

I started fuzz-testing the realtime rmap feature with a very large
number of realtime allocation groups.  There were so many rt groups that
repair had to rebuild /realtime in the metadata directory tree, and that
directory was big enough to spur the creation of a block format
directory.

Unfortunately, repair then walks both directory trees to look for
unconnceted files.  This part of phase 6 emits CRC errors on the newly
created buffers for the /realtime directory, declares the directory to
be garbage, and moves all the rt rmap inodes to /lost+found, resulting
in a corrupt fs.

Poking around in gdb, I noticed that the buffer contents were indeed
zero, and that UPTODATE was not set.  This was very strange, until I
added a watch on bp->b_flags to watch for accesses.  It turns out that
xfs_repair's prefetch code will _get a buffer and zero the contents if
UPTODATE is not set.

The directory tree code in libxfs will also _get a buffer, initialize
it, and log it to the coordinating transaction, which in this case is
the transactions used to reconnect the rmap btree inodes to /realtime.
At no point does any of that code ever set UPTODATE on the buffer, which
is why prefetch zaps the contents.

Hence change both buffer dirtying functions to set UPTODATE, since a
dirty buffer is by definition at least as recent as whatever's on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/rdwr.c  |    2 +-
 libxfs/trans.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 17abced06c9..a3b30510926 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -959,7 +959,7 @@ libxfs_buf_mark_dirty(
 	 */
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
-	bp->b_flags |= LIBXFS_B_DIRTY;
+	bp->b_flags |= LIBXFS_B_DIRTY | LIBXFS_B_UPTODATE;
 }
 
 /* Prepare a buffer to be sent to the MRU list. */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index aab9923d9ad..3c5d6383e8c 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -716,6 +716,7 @@ libxfs_trans_dirty_buf(
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
+	bp->b_flags |= LIBXFS_B_UPTODATE;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
 }

