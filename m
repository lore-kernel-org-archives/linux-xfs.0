Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0978215C12D
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 22:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502317; cv=none; b=SjjZ8E3lILVFEnnQ9InXvz8tVvCH2na1b8ACboL/0CDPLaItaq2EbYguMiSacfoQDTvl5BUa3N/Y6wJ9qCCrK3aD1NX0EjG4jGC5uPVKywKzzJLw6gABpsSiX4DzQnew7wuNWVLaNqQVJ584XBb/Qbb+9PngLt1lc9nQ9HPCpMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502317; c=relaxed/simple;
	bh=H7glYCVDwQhMN3DUVURfdfuqISpMGls7A+H8kUeJ8nw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ogz1Wsv1iijd4+2G4znAwK7Me0Rr8kCy2rinxsO2tBLPyzyJBb/8agTvJneGS+ttrbToebhrXlEtnvdlcGZjA7GB0C/8EopKf6FZuidVLTnNncpH/ePh50QNq69/nj2FGnwOEERFTYlXeIXVblwvaurA7tyYILg53aZao8d14oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+Kl4Erh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+Kl4Erh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E23C4AF0E;
	Mon, 12 Aug 2024 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723502316;
	bh=H7glYCVDwQhMN3DUVURfdfuqISpMGls7A+H8kUeJ8nw=;
	h=Date:From:To:Cc:Subject:From;
	b=J+Kl4Erh5cniuK6diFPdTtD5u7Ng05JROSZyFyGCIxlDGWjoKL20FB6cSXkkAHjM1
	 wSrhHa9RHfrYEcejXiTAmAlGFgGqiX5iPX/nylXlffryA2IgEtM+gU7wux8XRR7a+o
	 9pbrsWhLknX60Hv0mC3QifkSpbYme8oRbr7tBhVKa9FJcH/bCYvfOwhaPA4moS37hX
	 yqBV7eg+mCMLo2cs3ZuqeFmc7D+jwFBht2JhexHCTJmxk8jNSNdMmjpLuW9EMnKmkI
	 fSy6CH95fVd7rq52bKOtSVr2XdAlKQrU6jo62FSOxPvQ5qofOGEAUtek5KlJoFP/l+
	 ww3xOHhGSTTqg==
Date: Mon, 12 Aug 2024 15:38:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: dirty buffers should be marked uptodate too
Message-ID: <20240812223836.GB6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
index bd773a7375bc..35be785c435a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -919,7 +919,7 @@ libxfs_buf_mark_dirty(
 	 */
 	bp->b_error = 0;
 	bp->b_flags &= ~LIBXFS_B_STALE;
-	bp->b_flags |= LIBXFS_B_DIRTY;
+	bp->b_flags |= LIBXFS_B_DIRTY | LIBXFS_B_UPTODATE;
 }
 
 /* Prepare a buffer to be sent to the MRU list. */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index b5f6081a16cb..5c896ba1661b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -716,6 +716,7 @@ libxfs_trans_dirty_buf(
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
+	bp->b_flags |= LIBXFS_B_UPTODATE;
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
 }
