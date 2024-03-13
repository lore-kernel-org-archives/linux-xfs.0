Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B838C1E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294783; cv=none; b=KAsSAIfOg9xMO2UNAMK+RwqNXKF9gCaDFstFcp29gesBMGSls5M/vuvjffx2UNFLlg2AizrvjT8MKIC8Zt2MfrHzTO2Fj2pRfNvkeUfUG3JaeSIfrYBxmvhfT/tBJyPXUbBLdaezadnoWxtpKlM+CUhrp7WX7rANdmxiSQX1vnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294783; c=relaxed/simple;
	bh=L/NO9Vk4YMFpjvTGqhxAWqxB3Iq9qBhzPtqLXAgJOws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kddnT1nMRiYTTRT9Wjao6ufNBSP7okiptl5KxCQ+z0ulFLN4dUY5HT4FoCXAXClw38jAtsIZj/f3YY8yNBmAY98qWGy8weqRWWCQPQUzCAVVk59Rjs+OgRJygu+4mCGMW6sj7t+FswTAxMUpA6ed9PxhcnzYgs3CqAwEyw1+1ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVZ7FDHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVZ7FDHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E31C433C7;
	Wed, 13 Mar 2024 01:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294783;
	bh=L/NO9Vk4YMFpjvTGqhxAWqxB3Iq9qBhzPtqLXAgJOws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IVZ7FDHIc2kZP8lyxdGkTWM6VZI0BAoTO9ot3QXDR7JttluciIby356B+eXbiwu25
	 y0EAEdv1QQjitY/Pc9/9CLqlx0hjXCWp7w3ASKjrMquDVhFCIl96IW+LQzEhmKclRL
	 esNSqwTFWi1WZo95qqI36VzUWLBqRwbHQOLQHaGKk7K11gQULgH+0w/9nJjXAEuePZ
	 pMS6mT225ouFtVwKTdz1MSM6jZZByXqm5lTCZisZdj36/kcrOOt7zEM9Pr7aPXVwI7
	 MQkrC8vnDkbrbu7Y7EEI/hAAl8/QqSnXIdYcbDYdNMqgGQkTP9xXdj4lc5PfGjvLbo
	 K8NsEOXtGB7fw==
Date: Tue, 12 Mar 2024 18:53:02 -0700
Subject: [PATCH 13/13] xfs_{db,repair}: use m_blockwsize instead of
 sb_blocksize for rt blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430743.2061422.9896530952028500488.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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

In preparation to add block headers to rt bitmap and summary blocks,
convert all the relevant calculations in the userspace tools to use the
per-block word count instead of the raw blocksize.  This is key to
adding this support outside of libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c      |    4 ++--
 repair/phase6.c |    4 ++--
 repair/rt.c     |    9 +++++----
 3 files changed, 9 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 103ea4022c3b..2f2fbc7cbd81 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3630,7 +3630,7 @@ process_rtbitmap(
 	int		t;
 	xfs_rtword_t	*words;
 
-	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	bitsperblock = mp->m_blockwsize << XFS_NBWORDLOG;
 	words = malloc(mp->m_blockwsize << XFS_WORDLOG);
 	if (!words) {
 		dbprintf(_("could not allocate rtwords buffer\n"));
@@ -3749,7 +3749,7 @@ process_rtsummary(
 
 		args.sumbp = iocur_top->bp;
 		ondisk = xfs_rsumblock_infoptr(&args, 0);
-		memcpy(sfile, ondisk, mp->m_sb.sb_blocksize);
+		memcpy(sfile, ondisk, mp->m_blockwsize << XFS_WORDLOG);
 		pop_cur();
 		sfile += mp->m_blockwsize;
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index 0818ee1a1501..fcb26d594b10 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -626,7 +626,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 
 		args.rbmbp = bp;
 		ondisk = xfs_rbmblock_wordptr(&args, 0);
-		memcpy(ondisk, bmp, mp->m_sb.sb_blocksize);
+		memcpy(ondisk, bmp, mp->m_blockwsize << XFS_WORDLOG);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
@@ -705,7 +705,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 
 		args.sumbp = bp;
 		ondisk = xfs_rsumblock_infoptr(&args, 0);
-		memcpy(ondisk, smp, mp->m_sb.sb_blocksize);
+		memcpy(ondisk, smp, mp->m_blockwsize << XFS_WORDLOG);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
diff --git a/repair/rt.c b/repair/rt.c
index 9aff5a0d3d58..e49487829af2 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -25,8 +25,9 @@ rtinit(xfs_mount_t *mp)
 		return;
 
 	/*
-	 * realtime init -- blockmap initialization is
-	 * handled by incore_init()
+	 * Allocate buffers for formatting the collected rt free space
+	 * information.  The rtbitmap buffer must be large enough to compare
+	 * against any unused bytes in the last block of the file.
 	 */
 	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
 	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
@@ -87,7 +88,7 @@ generate_rtinfo(
 
 	ASSERT(mp->m_rbmip == NULL);
 
-	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	bitsperblock = mp->m_blockwsize << XFS_NBWORDLOG;
 	extno = start_ext = 0;
 	bmbno = in_extent = start_bmbno = 0;
 
@@ -199,7 +200,7 @@ check_rtfile_contents(
 			break;
 		}
 
-		if (memcmp(bp->b_addr, buf, mp->m_sb.sb_blocksize))
+		if (memcmp(bp->b_addr, buf, mp->m_blockwsize << XFS_WORDLOG))
 			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
 					filename, (unsigned long long)bno);
 

