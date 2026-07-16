Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE511388893;
	Thu, 16 Jul 2026 06:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784181999; cv=none; b=tCdp3bnizK4gyNyUkgl+pWU/zhma0cDeZ/mhff9KdA1xqZS57Mm0kkYhMrROBReEYx6NTL161IfPwOo8CTpY0aSS5pu4ai7RgYcd3Nybl2BRBtQfeTlxnzi9BOoRDPGhD4yYXn3dGdEfokTq5qOTGIRRfYe3JxLU0v5wTdZf2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784181999; c=relaxed/simple;
	bh=W7zSiyWq7zLRqlS7n+NqF+e59B8FSWcP8N0IsUPo8bU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+3wz2dxvxN8+6N4eFSO4cpDlS+tDiWQMUbbxeeKpWgEht9P5wlZbVfXPXy54wKMwax2Oqs+CrUeuxEnV5AZ36Esfi9p9xJnZ+bXwwbnw824rIoCYCu1PZvyUCMyGDIr4WyF2oDJvzGql6daDpA1XVzN7gWSQtGjwuAPK+mOPwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIj2vkPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIj2vkPs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 848691F000E9;
	Thu, 16 Jul 2026 06:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784181998;
	bh=h0ZdNN9ZsNMogxoYZrj02b4Khg7MMUrwfDAiOxgQuPs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=lIj2vkPsaA9diJUcm0PA/kRz3+D9VNpV5harmFugLfR5A1rXXMiBO6j8ZG7nFc1nG
	 JqBameOEfaCDgZgPHgL7PwD7GbYRM5zRV8JO+n4Iy/lwvOGWjT8+FDPxble8tBpIYs
	 jmKhmyL5Ld/ESTCGz38AzLiBW0Z0JSl4cu+QdxzyNZ83+AtLQUf8ylXriySa6ztMO5
	 oGGTkviQHA1O1/wCVrIH0FlDRtJRtLCN5xOYfSFtHdMKUPADV4PtAYXapBLDClhEAY
	 Ub5mw2QMzvb+ltME9YLVIEQ0bWSasaUzQXP53lNrs3V7IzMjAveHo2evfqSX4Z/d9q
	 lXByX3LqecXHg==
Date: Wed, 15 Jul 2026 23:06:38 -0700
Subject: [PATCH 2/6] xfs: fix transaction block reservation in xrep_rtbitmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178416797403.2008054.16457221917569138909.stgit@frogsfrogsfrogs>
In-Reply-To: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM pointed out an inconsistency in the block reservation code in
xrep_rtbitmap.  The first is that the reservation computation is not
consistent between the code that sets up the repair and the code that
tries to avoid exceeding the transaction reservation once we know how
big the rtbitmap really must be.  As a result, the logic doesn't work.

In fixing that, a second problem emerges: if we do readjust, we ask for
the entire reservation all over again.  We really only need the delta,
so ask only for that.

Fix all these problems by hoisting the computation to a trivial helper
so that it gets used in both places.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 8defee8dff2b20 ("xfs: online repair of realtime bitmaps for a realtime group")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtbitmap_repair.c |   46 ++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index dc64902d6c25a4..442a17bf972029 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -36,6 +36,24 @@
 
 /* rt bitmap content repairs */
 
+/*
+ * Reserve enough blocks to write out a completely new bitmap file, plus twice
+ * as many blocks as we would need if we can only allocate one block per data
+ * fork mapping.  This should cover the preallocation of the temporary file and
+ * exchanging the extent mappings.
+ *
+ * We cannot use xfs_exchmaps_estimate because we have not yet constructed the
+ * replacement bitmap and therefore do not know how many extents it will use.
+ * By the time we do, we will have a dirty transaction (which we cannot drop
+ * because we cannot drop the rtbitmap ILOCK) and cannot ask for more
+ * reservation.
+ */
+static inline unsigned long long
+xrep_rtbitmap_calc_blocks(struct xfs_mount *mp, unsigned long long blocks)
+{
+	return blocks + (xfs_bmbt_calc_size(mp, blocks) * 2);
+}
+
 /* Set up to repair the realtime bitmap for this group. */
 int
 xrep_setup_rtbitmap(
@@ -56,20 +74,7 @@ xrep_setup_rtbitmap(
 	if (error)
 		return error;
 
-	/*
-	 * Reserve enough blocks to write out a completely new bitmap file,
-	 * plus twice as many blocks as we would need if we can only allocate
-	 * one block per data fork mapping.  This should cover the
-	 * preallocation of the temporary file and exchanging the extent
-	 * mappings.
-	 *
-	 * We cannot use xfs_exchmaps_estimate because we have not yet
-	 * constructed the replacement bitmap and therefore do not know how
-	 * many extents it will use.  By the time we do, we will have a dirty
-	 * transaction (which we cannot drop because we cannot drop the
-	 * rtbitmap ILOCK) and cannot ask for more reservation.
-	 */
-	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
+	blocks = xrep_rtbitmap_calc_blocks(mp, mp->m_sb.sb_rbmblocks);
 	if (blocks > UINT_MAX)
 		return -EOPNOTSUPP;
 
@@ -512,7 +517,7 @@ xrep_rtbitmap(
 	struct xchk_rtbitmap	*rtb = sc->buf;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_group	*xg = rtg_group(sc->sr.rtg);
-	unsigned long long	blocks = 0;
+	unsigned long long	blocks;
 	unsigned int		busy_gen;
 	int			error;
 
@@ -532,15 +537,20 @@ xrep_rtbitmap(
 	 * figure out if we need to adjust the block reservation in the
 	 * transaction.
 	 */
-	blocks = xfs_bmbt_calc_size(mp, rtb->rbmblocks);
+	blocks = xrep_rtbitmap_calc_blocks(mp, rtb->rbmblocks);
 	if (blocks > UINT_MAX)
 		return -EOPNOTSUPP;
 	if (blocks > rtb->resblks) {
-		error = xfs_trans_reserve_more(sc->tp, blocks, 0);
+		uint64_t	delta = blocks - rtb->resblks;
+
+		if (delta > UINT_MAX)
+			return -EOPNOTSUPP;
+
+		error = xfs_trans_reserve_more(sc->tp, delta, 0);
 		if (error)
 			return error;
 
-		rtb->resblks += blocks;
+		rtb->resblks += delta;
 	}
 
 	/* Fix inode core and forks. */

