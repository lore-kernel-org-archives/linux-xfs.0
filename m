Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61357233723;
	Mon, 27 Jul 2026 05:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129983; cv=none; b=KYe7TOwNSBpiOCJIIrkCyfd8SjQM2LomxKsKAbjf3WZUxwfIOP78iYnDkDnPxcq/ECcj9LCN1W4Pc61h1VPEGvdHuJIF1XGfNWI0NhIrLAuyAF4uKaju6so/P44b2DXjK09DIulqWuUbmxu2xeabLYAtmWUVZM7tcI8Arlzv8Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129983; c=relaxed/simple;
	bh=gRRYeJd+38DY5Z+1iUXJzmJYeE+iYnHBg2AWy+kncgc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQe/1ADfk5AjTh42RN+0MsyUQ3WH3jM19vS2Pr1uQ7DzeqGk6jD4ReHv4tPgPA03BGee5/ClmgX2xDYIyUfB7aI/wrbo+DHTX9Aia9lU77+8sMV7UnwxUstpTOtMydvVnjpVPQBt1FIJaooQjFoO/H+mqiPHuFGfSecDuDKPGLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9FMZ0Gi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9FMZ0Gi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 386C11F000E9;
	Mon, 27 Jul 2026 05:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129982;
	bh=JG31LrUM+EfwyHgFoJ2oI5m86vnb08sASEohXaV3MY8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=C9FMZ0GiJAg8njOUX+wJbotRRFQ+9X4TeHv4pY62MQLj9WPXb/01Qt62e6lwRB341
	 ClQ/pLT9FQ8h/wDZG7ZA/DlQMroL6yeQ9xjfhNWd7rZZ6h2gVBjK5bt+5ZfnVlN/g4
	 k/DUfQoFGIy4VyNBgKlK0j5/Ry5ueugQ66k0faZTlxpJRK6WGTBsJujX1/CQTu38zx
	 bDLkUOEV39gRsNbuuS82DAYbeNPrXP/JPGsH0gZNuTFJAhA3xoB5swjfgCDeghF0cz
	 G0U58GNrHSTt337StlJzqKiHD0paGlxXa0PDBKXvJmfbAIEJjzkHTFvNc5IxN+VrbY
	 8DuArwy0mYI1A==
Date: Sun, 26 Jul 2026 22:26:21 -0700
Subject: [PATCH 08/10] xfs: fix another iunlink infinite loop bug in online
 fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389765.1495075.12826241332710084937.stgit@frogsfrogsfrogs>
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

xrep_iunlink_resolve_bucket is supposed to reconstruct as much of the
incore prev and next unlinked list pointers based on what it finds on
disk and in memory before we move on to relinking the truly lost inodes
back into the unlinked list.  However, it's still vulnerable to infinite
loops that come in via the next_unlinked pointers.

Fix this problem by remembering which inodes we've already seen and
checking new agino pointers against that.  If a bit is already set,
either this is a loop or the inode has nonzero link count.  We'll deal
with the second case in a subsequent patch.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h           |    1 +
 fs/xfs/scrub/agheader_repair.c |   37 ++++++++++++++++++++++++++++---------
 2 files changed, 29 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 00fbe1b9c2354f..14aa0ec1f09e4a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3538,6 +3538,7 @@ DEFINE_EVENT(xrep_iunlink_resolve_class, name, \
 	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket, \
 		 xfs_agino_t prev_agino, xfs_agino_t next_agino), \
 	TP_ARGS(pag, bucket, prev_agino, next_agino))
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_infinite_loop);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 41de5cf87352b4..65b9a8befce99b 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1348,15 +1348,32 @@ xrep_iunlink_resolve_bucket(
 	struct xrep_agi		*ragi,
 	unsigned int		bucket)
 {
+	struct xagino_bitmap	seen;
 	struct xfs_scrub	*sc = ragi->sc;
 	struct xfs_inode	*ip;
 	xfs_agino_t		prev_agino = NULLAGINO;
 	xfs_agino_t		next_agino = ragi->iunlink_heads[bucket];
 	int			error = 0;
 
+	xagino_bitmap_init(&seen);
+
 	while (next_agino != NULLAGINO) {
+		unsigned int len = 1;
+
 		if (xchk_should_terminate(ragi->sc, &error))
-			return error;
+			goto out_bitmap;
+
+		/* Inode already seen?  We're stuck in a loop */
+		if (xagino_bitmap_test(&seen, next_agino, &len)) {
+			trace_xrep_iunlink_resolve_infinite_loop(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+			next_agino = NULLAGINO;
+			break;
+		}
+
+		error = xagino_bitmap_set(&seen, next_agino, 1);
+		if (error)
+			goto out_bitmap;
 
 		/* Find the next inode in the chain. */
 		ip = xfs_iunlink_lookup(sc->sa.pag, next_agino);
@@ -1382,17 +1399,17 @@ xrep_iunlink_resolve_bucket(
 			error = xrep_iunlink_store_next(ragi, next_agino,
 					NULLAGINO);
 			if (error)
-				return error;
+				goto out_bitmap;
 
 			error = xrep_iunlink_store_prev(ragi, next_agino,
 					LINKED_AGINO);
 			if (error)
-				return error;
+				goto out_bitmap;
 
 			error = xagino_bitmap_clear(&ragi->iunlink_bmp,
 					next_agino, 1);
 			if (error)
-				return error;
+				goto out_bitmap;
 
 			next_agino = ip->i_next_unlinked;
 			continue;
@@ -1433,20 +1450,20 @@ xrep_iunlink_resolve_bucket(
 		 */
 		error = xagino_bitmap_clear(&ragi->iunlink_bmp, next_agino, 1);
 		if (error)
-			return error;
+			goto out_bitmap;
 
 		/* Remember the previous inode's next pointer. */
 		if (prev_agino != NULLAGINO) {
 			error = xrep_iunlink_store_next(ragi, prev_agino,
 					next_agino);
 			if (error)
-				return error;
+				goto out_bitmap;
 		}
 
 		/* Remember this inode's previous pointer. */
 		error = xrep_iunlink_store_prev(ragi, next_agino, prev_agino);
 		if (error)
-			return error;
+			goto out_bitmap;
 
 		/* Advance the list and remember this inode. */
 		prev_agino = next_agino;
@@ -1457,10 +1474,12 @@ xrep_iunlink_resolve_bucket(
 	if (prev_agino != NULLAGINO) {
 		error = xrep_iunlink_store_next(ragi, prev_agino, next_agino);
 		if (error)
-			return error;
+			goto out_bitmap;
 	}
 
-	return 0;
+out_bitmap:
+	xagino_bitmap_destroy(&seen);
+	return error;
 }
 
 /* Reinsert this unlinked inode into the head of the staged bucket list. */

