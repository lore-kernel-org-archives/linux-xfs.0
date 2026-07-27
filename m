Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AB7233723;
	Mon, 27 Jul 2026 05:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129968; cv=none; b=LQ3OrxqWFxnqUtztkipo02V9dTjNPGOnUqxIW3E506TaWytxa6JSuB0+9DSZkogqFDXe1pPtXkZIxFYvVd3zCpXsddmQ+bGQEkMe9hN1V0JrQGW3MB8CQdOLEN8FuTRJoteJVxuO60xXC4BnQd/qvqW9f/eQ2gS2M+aeOi8hfQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129968; c=relaxed/simple;
	bh=RudGXOyJAWrF06eJvOmm74QIGMJQzr3jkT5I99Qx7Dw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+zKuGds3E/pm5IEIvINSQd/ZZnzMMBt1GQv0lwawoiSjlV40CbNk+vbC8shjOwNAyxARpVeMJEYUrfKX64kc55gkDus6J4Btc4IJYjxLAqbg7uXCk4zQsKPjZ9isLdAA1rJ0HhBBxXjtyVgho40J2zmfIAe3uDs94tfFRSWUTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9KHVE21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9KHVE21"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AFB671F00A3A;
	Mon, 27 Jul 2026 05:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129966;
	bh=6qaZhylzTYfiT3peL4iXY1Q2Pc2kqLzYKgqbufGEA9c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=H9KHVE21hSZmOcyv5VrwHvTKgUDVjH8q5K5UPgOz7lc0RERYOG4uzDFjReB3oW9XU
	 UnwPPvT3jbvFRR2WunfA2fRxcD/XW3x8+/P4NL5tTDmciwPdBjuACfX8v64qfAqkaD
	 mabXu5rwoI8DdGBKwxePJ63qtj/Y8qWB0L9kMPOQG7E7uiseaHf5kExqtADM2QoQn5
	 4oRJGKKMGNggTTPUxbvgknW8eQ/28um0FOlqbLRQWXYSA8N4e8RisrB/MFtwevAMYV
	 AB00qoZBr9TW9foCHDTi72ll4279rxDENwYOyIFfRe2gCvCuu+Q5uBVmDTlwD7YUDF
	 k5Pqx007thSKQ==
Date: Sun, 26 Jul 2026 22:26:06 -0700
Subject: [PATCH 07/10] xfs: fix allocated inodes that show up in the unlinked
 list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389744.1495075.16740959586821626025.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If an allocated inode shows up in the unlinked list, we need to get it
completely off the list.  Set the corrected next/prev pointers such that
the inode will not look like it should be on an unlinked list at all.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/trace.h           |    1 +
 fs/xfs/scrub/agheader_repair.c |   63 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d5d39d82749e5c..00fbe1b9c2354f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3542,6 +3542,7 @@ DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_ok);
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_allocated);
 
 TRACE_EVENT(xrep_iunlink_relink_next,
 	TP_PROTO(struct xfs_inode *ip, xfs_agino_t next_agino),
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 8514d2d7e3cea3..41de5cf87352b4 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -979,6 +979,13 @@ xrep_agi_calc_from_btrees(
 	return error;
 }
 
+/*
+ * Magic value that means "not unlinked" because xfarrays don't support storing
+ * totally zeroed elements.  There can't be a cluster that starts in daddr 0 so
+ * there can't be an inode #1 either.
+ */
+#define LINKED_AGINO	(0x1)
+
 /*
  * Record a forwards unlinked chain pointer from agino -> next_agino in our
  * staging information.
@@ -1362,6 +1369,35 @@ xrep_iunlink_resolve_bucket(
 			break;
 		}
 
+		if (VFS_I(ip)->i_nlink != 0) {
+			/*
+			 * Inode is linked somewhere!  Blow out both unlinked
+			 * list pointers, advance the list, and pretend we
+			 * didn't see this inode.  Clear it from iunlink_bmp
+			 * because it's linked.
+			 */
+			trace_xrep_iunlink_resolve_allocated(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+
+			error = xrep_iunlink_store_next(ragi, next_agino,
+					NULLAGINO);
+			if (error)
+				return error;
+
+			error = xrep_iunlink_store_prev(ragi, next_agino,
+					LINKED_AGINO);
+			if (error)
+				return error;
+
+			error = xagino_bitmap_clear(&ragi->iunlink_bmp,
+					next_agino, 1);
+			if (error)
+				return error;
+
+			next_agino = ip->i_next_unlinked;
+			continue;
+		}
+
 		if (next_agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
 			/*
 			 * Inode is in the wrong bucket.  Advance the list,
@@ -1540,6 +1576,24 @@ xrep_iunlink_rebuild_buckets(
 			xrep_iunlink_add_lost_inodes, ragi);
 }
 
+static inline void
+set_inode_prev_unlinked(
+	struct xfs_inode	*ip,
+	xfs_agino_t		prev_agino)
+{
+	/*
+	 * Magic value that means "not unlinked" because xfarrays don't support
+	 * storing totally zeroed elements.
+	 */
+	if (prev_agino == LINKED_AGINO)
+		prev_agino = 0;
+
+	if (ip->i_prev_unlinked != prev_agino) {
+		trace_xrep_iunlink_relink_prev(ip, prev_agino);
+		ip->i_prev_unlinked = prev_agino;
+	}
+}
+
 /* Update i_next_iunlinked for the inode @agino. */
 STATIC int
 xrep_iunlink_relink_next(
@@ -1573,8 +1627,7 @@ xrep_iunlink_relink_next(
 		if (error)
 			goto out_rele;
 
-		trace_xrep_iunlink_relink_prev(ip, prev_agino);
-		ip->i_prev_unlinked = prev_agino;
+		set_inode_prev_unlinked(ip, prev_agino);
 	}
 
 	/* Update the forward pointer. */
@@ -1641,11 +1694,7 @@ xrep_iunlink_relink_prev(
 		ip->i_next_unlinked = next_agino;
 	}
 
-	/* Update the backward pointer. */
-	if (ip->i_prev_unlinked != prev_agino) {
-		trace_xrep_iunlink_relink_prev(ip, prev_agino);
-		ip->i_prev_unlinked = prev_agino;
-	}
+	set_inode_prev_unlinked(ip, prev_agino);
 
 out_rele:
 	/*

