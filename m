Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB42C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FahUTl4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF261C433C8;
	Sun, 31 Dec 2023 22:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061029;
	bh=vyo1DG37L2ENd1WKfKan8Zy23wq6vjMXof5X1gUAxK0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FahUTl4pnPLUWS8nrD7xB0w8pv1uDnJ9YZuaNOuXiZ4nTsw6JWHYyTqmu61fHcJ99
	 gE+J6ZkqUvqlOyaEzZdoXXaAq/6DeYaZZZzuDAimImAXeHnlbhZ1ItwKkAuCGg/TDn
	 CCxM5JAxLYTADQiwvO0txX46/fODQ0hr2rBLeaPeQv4osbXt1Sqoyh3+wg/0LUiycQ
	 bV4eYKU8B1t9kEvkeeIhA0cfjn4hjLjN6dEEtsZ4uDAHyU1lP/ABbZgjiiNs17+FmY
	 oc73Ctn0VIZcUfZIDr+s+lC1OkY8MW9u6M5YY2smXYPcauQ/Gz0Qfj/4C2epE/jJ8N
	 bCzFJv+M5KfiQ==
Date: Sun, 31 Dec 2023 14:17:09 -0800
Subject: [PATCH 10/10] xfbtree: let the buffer cache flush dirty buffers to
 the xfile
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992917.1794490.6484979917188877828.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
References: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
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

As a performance optimization, when we're committing xfbtree updates,
let the buffer cache flush the dirty buffers to disk when it's ready
instead of writing everything at every transaction commit.  This is a
bit sketchy but it's an ephemeral tree so we can play fast and loose.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfbtree.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index 3cca7b5494c..c4dd706f4f7 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -699,7 +699,6 @@ xfbtree_trans_commit(
 	struct xfbtree		*xfbt,
 	struct xfs_trans	*tp)
 {
-	LIST_HEAD(buffer_list);
 	struct xfs_log_item	*lip, *n;
 	bool			corrupt = false;
 	bool			tp_dirty = false;
@@ -733,12 +732,16 @@ xfbtree_trans_commit(
 			 * If the buffer fails verification, log the failure
 			 * but continue walking the transaction items so that
 			 * we remove all ephemeral btree buffers.
+			 *
+			 * Since the userspace buffer cache supports marking
+			 * buffers dirty and flushing them later, use this to
+			 * reduce the number of writes to the xfile.
 			 */
 			if (fa) {
 				corrupt = true;
 				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 			} else {
-				xfs_buf_delwri_queue_here(bp, &buffer_list);
+				libxfs_buf_mark_dirty(bp);
 			}
 		}
 
@@ -752,15 +755,9 @@ xfbtree_trans_commit(
 	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
 			(tp_dirty ? XFS_TRANS_DIRTY : 0);
 
-	if (corrupt) {
-		xfs_buf_delwri_cancel(&buffer_list);
+	if (corrupt)
 		return -EFSCORRUPTED;
-	}
-
-	if (list_empty(&buffer_list))
-		return 0;
-
-	return xfs_buf_delwri_submit(&buffer_list);
+	return 0;
 }
 
 /*

