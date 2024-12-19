Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C941AAA0D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636548; cv=none; b=bgYBYrzIZp0ll8OSgG4j3WOXoF408y28/WnB+HYSo6KntudE2SFKpCHbMxpZmHCwr/q6ss42d0S9vlFk7JhHWtPDZdMqRUyzKs8ITXfxXEatR0d8OGM2OKjrHbtJPEomPHe44wQwT+yXDn500zP2SHj5R4VPaB1rMEQLHqN4bFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636548; c=relaxed/simple;
	bh=btFNYgGxjZJesvHa1HZnZ5aBoD4kVJ6xlGRjoeLWD+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iyQll57VJthZHSiHV0OIRo+jOjxCqepBJ/4x758hRMCUIwSeSKkdVEY6S3kQ0LhTQQK80ohN1Nc8gA5lStgw9pmZ5sJ7CtludgTPmmyUX6rKDJ3x0zJMQdP6ma0xQ8v+IghMpukKoORteYZBGHZzaaJCfTFeqyMMDHFkKeIojQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDsgwBwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDsgwBwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACDDC4CECE;
	Thu, 19 Dec 2024 19:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636548;
	bh=btFNYgGxjZJesvHa1HZnZ5aBoD4kVJ6xlGRjoeLWD+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZDsgwBwfyqDZKD0k8tDYgxaz5kjsPz0LdmhJYJVZt5dcAPsxHZ2k1spRK7H3d1PwK
	 1wgzIzY4JuX0nSzThfGQL2qHqux/33NpqUpZ3N8a98OueriXONWPUOAEh2XikZiq7c
	 CdPN3woWAUHzL052Dl4ga+mOOU+7a4Sy5FYS5t5qbagbpnXzwhfkw8gxzUlcHgDQpQ
	 KM1JDYB4SWBFK5HulM+4dzluvWCzIJLOrlQ+MdfNmgRaIWJNgRWK2xVFzyN2lY0SMS
	 mo8ma7egG7b6ku5V5R5Blgq9KuN6080NhByke5R1HOtmG6lPQ/RIv9C5BrtVAvBVG3
	 Tqbh9LDjuBOpA==
Date: Thu, 19 Dec 2024 11:29:07 -0800
Subject: [PATCH 22/37] xfs: cross-reference realtime bitmap to realtime rmapbt
 scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580135.1571512.13618044826898675048.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're checking the realtime rmap btree entries, cross-reference
those entries with the realtime bitmap too.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtrmap.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 7b5f932bcd947f..515c2a9b02cdae 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -142,6 +142,20 @@ xchk_rtrmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Cross-reference with other metadata. */
+STATIC void
+xchk_rtrmapbt_xref(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	xchk_xref_is_used_rt_space(sc,
+			xfs_rgbno_to_rtb(sc->sr.rtg, irec->rm_startblock),
+			irec->rm_blockcount);
+}
+
 /* Scrub a realtime rmapbt record. */
 STATIC int
 xchk_rtrmapbt_rec(
@@ -162,6 +176,7 @@ xchk_rtrmapbt_rec(
 
 	xchk_rtrmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rtrmapbt_check_overlapping(bs, cr, &irec);
+	xchk_rtrmapbt_xref(bs->sc, &irec);
 	return 0;
 }
 

