Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B9A78F26;
	Tue, 21 Jul 2026 03:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604244; cv=none; b=UnRdNWWGT1qm9YmtzyTqrfxk89eW4wDwEurtspggHndglcum4AH2BAlEyue34QmLFXVAxto4t4PhRFy2tw0QrI+sZuOBd3ie1h203n6JIYSRkuEMuDyhLRvQYaegULWPKCSh7xMJAIKlJFbC0yRBdvbXa8k2xRrYtXKVIItly54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604244; c=relaxed/simple;
	bh=4EotqG0FvaRuuv/yR1qPJ+6ZOVTR/XvVleW4ZjaOzqk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UlsDKDiPAivH1eFjxYGnQ5vnsIOJR4FDOOQIPlYzjc3o8FlPWugXncEsKIfS4R9Icw9cphfsTwTZcbjG7CTiApIcMYIqxihgXUlWa+tvD9yYVyliZCvHtX8aQRQLOM6i6FiCYs8zmbQ5KhTKrp0CQymcrVFeDOOkCq8ey2AgS38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wo3Rl5Pn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wo3Rl5Pn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9774D1F000E9;
	Tue, 21 Jul 2026 03:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604242;
	bh=VMBYuAvhnCq0b5OrVh2RI3rlJmPHzcUJjHmEDck/aL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Wo3Rl5PnM+DcKrT7AmnIBhJSAS6QZz8ydwTYzXT2N17SFnyM2y40cz/IpWo3Iu7FZ
	 kFnKci0JDnL1ErRTiK/z1c6GNEEIADVUvPaJJgx/dA7g4/fJFg4lf53LTO3LQoddWD
	 p4mPNKXTEbqAb/bjpl2mcY6Zzf9rndW1Jkggq7SFkjnJn5LFF8H+wTNnYVdAbWFsdG
	 IwRMYV71K5W+719S34rD5KqWm9UIZqgBOemygs5BI4RTPUgMJMEwUqEis2kwbhpYbl
	 jtU2TtcAMmBBDquxAELUJdob/j7Bgpzz5LdPNHSYv/sWCCUcEIaR+cjjMzOOc4PXKS
	 jiM+3eTlh2xxw==
Date: Mon, 20 Jul 2026 20:24:02 -0700
Subject: [PATCH 2/5] xfs: fix transaction block reservation in xrep_rtbitmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419128.830618.9531393554567720123.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
References: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

