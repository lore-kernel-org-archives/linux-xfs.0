Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE064BE62
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295236; cv=none; b=I/MgqGGk/GeCbm6u+GN2WQpQRiHYg7DFTUWk4IJU91/fkXAJ8TfbaJl6n/3lfPXEWlOQaBabbdu90NBtaNYPGlwcAuuZhtVSe/5nnv+lcJE6vD1Z7hgFKsj1I+lx7W1BLSor+qshrJGFh5qjN1xHMXam65YTQAdFaPS7ly1paJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295236; c=relaxed/simple;
	bh=UiWgh1lqnx/VJ4SdGYv5FUgo6UNOa4p2+maa+ma+Bew=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJP8Azt7x6obfe/bvJF8X8QN+ipPDOB6tWmms9Qbscflh+Gd4Gzu7BwPtCSJmsj+LnsYDm2RWvnEnjwpb0u4bU9QjqPVmC4O1ZCtorbF/vPyJr9g5GO6xoMVSX87dYpSHPZd3NLD+sFLPhjH1DnaWZxhlHi/NyeG0Th4GhCFk9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNJ5P2GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNJ5P2GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C689C433C7;
	Wed, 13 Mar 2024 02:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295236;
	bh=UiWgh1lqnx/VJ4SdGYv5FUgo6UNOa4p2+maa+ma+Bew=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lNJ5P2GSNPPIPHYJcLDPyfqB5iUG6dN832mhBirLGgfyf1G9nWOHX1jGDYnLdBrcG
	 fxRWqK5SH63QTZyciCZv0QIerjvrUW6ypeUDwJyjfhkI4Ki7vVG4cnjKD9s5hqfSxB
	 m3yDSvUI5nTeEKlOyHNnmk+5A44uQPOvFwlxvF4ACFtxdrYHP6m0zsLOq7UAl45vqY
	 qw0JZ3P/8m8Q0h/dLxAV8G66PdCJIqiIbCzcqExqVa+N3ecAocADMCRglSELI7FAYa
	 gqQ83DKkIsZDCEFZ4RztIjNnSfwZxKhTj9dEiqtJvzK6m92eyZiHpyNg16UT1ENMf5
	 DyYLfBbGnGVdA==
Date: Tue, 12 Mar 2024 19:00:35 -0700
Subject: [PATCH 29/67] xfs: force all buffers to be written during btree bulk
 load
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431612.2061787.14166599748410304997.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: 13ae04d8d45227c2ba51e188daf9fc13d08a1b12

While stress-testing online repair of btrees, I noticed periodic
assertion failures from the buffer cache about buffers with incorrect
DELWRI_Q state.  Looking further, I observed this race between the AIL
trying to write out a btree block and repair zapping a btree block after
the fact:

AIL:    Repair0:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

stale buf X:
clear DELWRI_Q
does not clear b_list
free space X

delwri_submit   # oops

Worse yet, I discovered that running the same repair over and over in a
tight loop can result in a second race that cause data integrity
problems with the repair:

AIL:    Repair0:        Repair1:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

stale buf X:
clear DELWRI_Q
does not clear b_list
free space X

find free space X
get buffer
rewrite buffer
delwri_queue:
set DELWRI_Q
already on a list, do not add

BAD: committed tree root before all blocks written

delwri_submit   # too late now

I traced this to my own misunderstanding of how the delwri lists work,
particularly with regards to the AIL's buffer list.  If a buffer is
logged and committed, the buffer can end up on that AIL buffer list.  If
btree repairs are run twice in rapid succession, it's possible that the
first repair will invalidate the buffer and free it before the next time
the AIL wakes up.  Marking the buffer stale clears DELWRI_Q from the
buffer state without removing the buffer from its delwri list.  The
buffer doesn't know which list it's on, so it cannot know which lock to
take to protect the list for a removal.

If the second repair allocates the same block, it will then recycle the
buffer to start writing the new btree block.  Meanwhile, if the AIL
wakes up and walks the buffer list, it will ignore the buffer because it
can't lock it, and go back to sleep.

When the second repair calls delwri_queue to put the buffer on the
list of buffers to write before committing the new btree, it will set
DELWRI_Q again, but since the buffer hasn't been removed from the AIL's
buffer list, it won't add it to the bulkload buffer's list.

This is incorrect, because the bulkload caller relies on delwri_submit
to ensure that all the buffers have been sent to disk /before/
required for data consistency.

Worse, the AIL won't clear DELWRI_Q from the buffer when it does finally
drop it, so the next thread to walk through the btree will trip over a
debug assertion on that flag.

To fix this, create a new function that waits for the buffer to be
removed from any other delwri lists before adding the buffer to the
caller's delwri list.  By waiting for the buffer to clear both the
delwri list and any potential delwri wait list, we can be sure that
repair will initiate writes of all buffers and report all write errors
back to userspace instead of committing the new structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h         |   11 +++++++++++
 libxfs/xfs_btree_staging.c |    4 +---
 2 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 267ea979656f..259c6a7cf771 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -244,6 +244,17 @@ xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
 	return true;
 }
 
+static inline void
+xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *buffer_list)
+{
+	ASSERT(list_empty(&bp->b_list));
+
+	/* This buffer is uptodate; don't let it get reread. */
+	libxfs_buf_mark_dirty(bp);
+
+	xfs_buf_delwri_queue(bp, buffer_list);
+}
+
 int xfs_buf_delwri_submit(struct list_head *buffer_list);
 void xfs_buf_delwri_cancel(struct list_head *list);
 
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index a6a907916686..baf7f422603e 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -342,9 +342,7 @@ xfs_btree_bload_drop_buf(
 	if (*bpp == NULL)
 		return;
 
-	if (!xfs_buf_delwri_queue(*bpp, buffers_list))
-		ASSERT(0);
-
+	xfs_buf_delwri_queue_here(*bpp, buffers_list);
 	xfs_buf_relse(*bpp);
 	*bpp = NULL;
 }

