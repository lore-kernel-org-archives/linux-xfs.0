Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20762349CE2;
	Thu,  3 Sep 2026 05:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414683; cv=none; b=BwrsjXjTqRv8iZ5ecNwFoxMJEcyhQYiFZv3ZaPIZDp23llzjfejZz+Jbdu4FgXBG1T66n4V8lWKolTQkgUnWXgOn0gAD1eoB6ATGJIBV0EgUlT3DIjsIzUdaTTcReEF924a7GUIknXP1e3GWKeBcJp8viOPTS5uhjzChpmOBUyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414683; c=relaxed/simple;
	bh=SELk6k0D0oZ+Lw0iR9PLfJKRQyJuJlN6aJ8U0P1y+9o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVWIPSnrU405dGepXdl+kddxTrGZra+yrNRzQZSgodVRO3wwnEQpXgSHvVGgdZbfBNc+SBHg2aULUwF1crk0avsIIQ5A7nRWRGdBgUCR14zHG5YJzCyogqaKwjvfyMkeHqwgQIl8VOjx7aG8i8pT2lqOm8w0i8dw3+e6geksvEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltCPJ7tD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltCPJ7tD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9509A1F000E9;
	Thu,  3 Sep 2026 05:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414681;
	bh=G9+jAysNzUebFfICvZdZVwDV0KhyM/YNtlGsDxBJZLg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ltCPJ7tDy3pndr2lY39aYfi1nNwFVWLqpr8JlO2aTJTuUyP6wiN+V6CjsyabGOcS7
	 caBaJJHi8Vk6am6kOspwMKXq5ypFKWxkXDoy6XV2Qzt9m/G3MQyvPiF1Qf2slEI8fA
	 pifrl/SLfmQ0zGobG0ynK3yWb+QuBUTih+OZGeH6cmJaj+sH7qgAOvkhA1idgqJxk/
	 LshyWTn+YFwXmY8Uo28CIwnH2qS84ozw6dpRfmSaTghatneLnSZPrO57ezMQJi3SSd
	 K2iqY/8hrdKKcUNFTVm14AyFUotx6Ryvl1PRP8HOvla2qPoc9aAG/w4h3k0/SuFB1T
	 ryQVieZifshsg==
Date: Wed, 02 Sep 2026 22:51:21 -0700
Subject: [PATCH 2/6] xfs: use the rtgroup extent count to find rtrefcount gaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178840969871.484660.14165734512664639226.stgit@frogsfrogsfrogs>
In-Reply-To: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed an anachronism from the early days of rtrefcount where the
refcount btree would handle 64-bit block numbers -- we pass rtblocks
into the gap finder, but rtrefcount btrees are sharded by rtgroup now.
This isn't really a problem for us since we're only looking for
overlapping rtrmap records to flag, but let's fix this sillyness.

Also fix some stale comments.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 30f47950dc2eba ("xfs: check reference counts of gaps between rt refcount records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtrefcount.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index de100178f41c70..a024d50cf9d20f 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -428,7 +428,7 @@ static inline void
 xchk_rtrefcountbt_xref_gaps(
 	struct xfs_scrub	*sc,
 	struct xchk_rtrefcbt_records *rrc,
-	xfs_rtblock_t		bno)
+	xfs_rgblock_t		bno)
 {
 	struct xfs_rmap_irec	low;
 	struct xfs_rmap_irec	high;
@@ -538,7 +538,7 @@ xchk_refcount_xref_rmap(
 		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
 }
 
-/* Scrub the refcount btree for some AG. */
+/* Scrub the refcount btree for some rtgroup. */
 int
 xchk_rtrefcountbt(
 	struct xfs_scrub	*sc)
@@ -564,10 +564,10 @@ xchk_rtrefcountbt(
 
 	/*
 	 * Check that all blocks between the last refcount > 1 record and the
-	 * end of the rt volume have at most one reverse mapping.
+	 * end of the rtgroup have at most one reverse mapping.
 	 */
-	xchk_rtrefcountbt_xref_gaps(sc, &rrc, sc->mp->m_sb.sb_rblocks);
-
+	xchk_rtrefcountbt_xref_gaps(sc, &rrc,
+			xfs_rtx_to_rgbno(sc->sr.rtg, sc->mp->m_sb.sb_rgextents));
 	xchk_refcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
 
 	return 0;

