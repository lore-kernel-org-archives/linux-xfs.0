Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90783153BE3
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803992; cv=none; b=WVm9b1x3Qn2HUWPGpUH9L5cUNRsb9rYd28HVN5wb+6FjjSkEzUgKENH+J5OzKha2zSCbp3Myr8YCG0CK9JzDG+WIdWXXJ+miO1ux9rv1Nnvr6Ab8J73cns594W4bWSKsgYp9crIAkFiJu9TrS+rZeU4Um0H0x+ffvPkP0ulWsjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803992; c=relaxed/simple;
	bh=K9VpRABzGPOPrZVrFlHG3LAJglKAiWczgDiSdsRXaVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlDm2k1L+R3yMXUAsAX5peGo+5V+pAkwThxV9PZnlYHB3V8brO8/xSfWd8f5v14iQmzN0wrBKR5WEitnIolTz0fS6BvmB/gCCQVqWxqiUeV20u9iVrNLNlWGgAK+K4+zHoKUsrTdh2Erxvs+qbNfsUJgfKFLpzqFGVcAeSf1pGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPoRi2yE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPoRi2yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840D0C116B1;
	Mon, 22 Apr 2024 16:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803992;
	bh=K9VpRABzGPOPrZVrFlHG3LAJglKAiWczgDiSdsRXaVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPoRi2yERV1OgzWasz81i/dhW2J8h2j55DI8lcb57mk3NXnQJNYfQkHkAwXpkRaWp
	 +KW+9u3gLBSwMHDSIQhlAQOGQaCbmY9Xrm0kU/FR7kyHT9GZ8tl0AMbXDiwJ/dTBFL
	 VJd6o0PdMIweVqLzGsBUGoJDhk0HLWRdn/Kw9q/ylVEHD/eWdZ7BjgtLg4O3WFisvy
	 cmuRx05rUIXEZz3nABcz+OBHk/E2Iql6/dXgp/RYlmFV6o7X5lqh4vo0JmW2vnvU0O
	 qfJmOZn1EelyQJb1mtbFYgB+I7MbHsAkSvGpZ6AMz+IaYL4YKS+PCjJOKpJxVE4sSC
	 ZKm6BbnFrkP0A==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 29/67] xfs: force all buffers to be written during btree bulk load
Date: Mon, 22 Apr 2024 18:25:51 +0200
Message-ID: <20240422163832.858420-31-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_io.h         | 11 +++++++++++
 libxfs/xfs_btree_staging.c |  4 +---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 267ea9796..259c6a7cf 100644
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
index a6a907916..baf7f4226 100644
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
-- 
2.44.0

