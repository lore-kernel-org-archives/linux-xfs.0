Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A2233723;
	Mon, 27 Jul 2026 05:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785130014; cv=none; b=sGNveyBFChI1gVT157dgj3xynRgS9mtSr1D1Ad1bb7fXE4AcYl23yybH7QDDQMMKuiXVCFzgbXm0yCeq8sHSoMPiOebxrTC9Idd5JMcjTjW/p9xqYTZjUFBspQ6HIeU9WqGTZACWJXxZtI1XOub0MW5qQhUtOXdwXOTDojLfMpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785130014; c=relaxed/simple;
	bh=m/48bjWjoJ57z4L2W9/1qU6jHqMwSR8/4xq85agRmdg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jBW7IoDpOIS+Uv8z65e5olr0yraHJTCGl7A2/Q9AzzR6rPFC6qkRka/3oyNXC4USDYfq2Ka04vAhPij+2DldHMU/QQYxBKmUKppIMlLlofLL/N7Iwgdp3S/s5Qk4SRWCwwa9okSt+S0v5nMeaHCC4FEcvLEKh5fzuQPOkkLJ83w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEQbPxr1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEQbPxr1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 421711F000E9;
	Mon, 27 Jul 2026 05:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785130013;
	bh=OjUBvKAIJa54O8Iqgil76GB64OSvKaHlgQwjdiX49wA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=lEQbPxr1CPK8j7tpaLxHWuSxjBG7u8R4kq3S7gEa/2c2OyRrCm91j4rf4h4waPn/2
	 +QB/ycbzhwCmXpsqqzXcGZy2bB9kZyWrOgBwUYRvgrzjArGvRFCeX3yWdz3Om/VFVo
	 ZiUFIfypATvE/Wm1wyR5zqGd+5F1IsvPGH6u7aeBqpJIZIPTFzsuLktEoaRW6LMNnO
	 bvlSbjaJz7iz12V/tNyrzdSZ3SL3pYfvahmzxIp+d/y1jCCWPypURtmxOZua4OeT4o
	 nGXdXhxQc8Eg1GvJi/swu65kXdGkFXDRAuMADoRFpcbNdyU+OxJYlssHdeahPv8O7y
	 FQhx6k1fUSTAg==
Date: Sun, 26 Jul 2026 22:26:52 -0700
Subject: [PATCH 10/10] xfs: don't ignore runtime errors in
 xrep_iunlink_reload_next
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389808.1495075.18295643958709747985.stgit@frogsfrogsfrogs>
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

LOLLM complained that this function ignores runtime errors being
returned by xrep_iunlink_store_*.  Rework the function signature so that
we can return runtime errors to abort the repair.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader_repair.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 4f1f235349c5a3..2104512f1ee19a 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1041,31 +1041,40 @@ xrep_iunlink_next(
  * the chain or if we should stop walking the chain due to corruption; or a
  * per-AG inode number.
  */
-STATIC xfs_agino_t
+STATIC int
 xrep_iunlink_reload_next(
 	struct xrep_agi		*ragi,
 	xfs_agino_t		prev_agino,
-	xfs_agino_t		agino)
+	xfs_agino_t		agino,
+	xfs_agino_t		*next_agino)
 {
 	struct xfs_scrub	*sc = ragi->sc;
 	struct xfs_inode	*ip;
-	xfs_agino_t		ret = NULLAGINO;
 	int			error;
 
+	*next_agino = NULLAGINO;
+
 	error = xchk_iget(ragi->sc, xfs_agino_to_ino(sc->sa.pag, agino), &ip);
 	if (error)
-		return ret;
+		return 0;
 
 	trace_xrep_iunlink_reload_next(ip, prev_agino);
 
 	/* If this is a linked inode, stop processing the chain. */
 	if (VFS_I(ip)->i_nlink != 0) {
-		xrep_iunlink_store_next(ragi, agino, NULLAGINO);
+		error = xrep_iunlink_store_next(ragi, agino, NULLAGINO);
+		if (error)
+			return error;
+
+		error = xrep_iunlink_store_prev(ragi, agino, LINKED_AGINO);
+		if (error)
+			return error;
+
 		goto rele;
 	}
 
 	ip->i_prev_unlinked = prev_agino;
-	ret = ip->i_next_unlinked;
+	*next_agino = ip->i_next_unlinked;
 
 	/*
 	 * Drop the inode reference that we just took.  We hold the AGI, so
@@ -1074,7 +1083,7 @@ xrep_iunlink_reload_next(
 	 */
 rele:
 	xchk_irele(sc, ip);
-	return ret;
+	return 0;
 }
 
 /*
@@ -1114,9 +1123,12 @@ xrep_iunlink_walk_ondisk_bucket(
 			break;
 
 		next_agino = xrep_iunlink_next(sc, agino);
-		if (!next_agino)
-			next_agino = xrep_iunlink_reload_next(ragi, prev_agino,
-					agino);
+		if (!next_agino) {
+			error = xrep_iunlink_reload_next(ragi, prev_agino,
+					agino, &next_agino);
+			if (error)
+				break;
+		}
 
 		error = xagino_bitmap_set(&seen, agino, 1);
 		if (error)

