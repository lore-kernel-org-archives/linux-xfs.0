Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C927158525
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824334; cv=none; b=XCscFTN75cRHZdcTSeX9fWoYNOM5dULKl9eHrNu7YL/6OOVB7ksod0Alqm/Jm5UcYSJP4W5sN5fDFLYklHjwx3afcfznFl8X9l0THiVQNgSWUf0RC5mAoKJGAJL8IU7WIJIuP+joD4hB97rmUKRBJ9bWn0AJO8fKJNJOnKtTZf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824334; c=relaxed/simple;
	bh=BOBI+As4yM/XwLyHo5XpvDkCwHOk/jMYQOnQfntEqQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXzsDz29yJ0HwMMpY5tFMiOgH0q/1ejUD622fVqOZMiH5ufvWeVRyXYcrMAcVPLbugVGyqkc+I9bsX/Z02VztNU8iy3M0NVheRG07/zAvz5WYwRk78U4QePRHT0EJtT1Cp2S4rcKoXea4EX5FYbsKTzxK41Rg/vU1W4SWcbwXLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y7SEJH6F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y7SEJH6F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=trsh479Ao3E0xOR0HWKdjDVOMLKJ14E5WPppPS+m7c8=; b=Y7SEJH6FUWxpG8RPKeN/EsaaU1
	WiiW46FVWJHuXvIghBYqKSYh17yVE7+ZgMp76DpuFsWk5YBDCJR3dokLI5Z49ZqvtvYhuLIxGmI8W
	xw6pxaNSp8TLMU9MqkOMMnBKLR0rvAITbHVAI7YvOU6lr4tPFzxaaSSwWWdXrBc+tM+/z02+PSoWb
	rUneCrSMSs6fytYG3OcEvxEygeP6MOcXZvDIo0evp2yUnC2S4dCOD1/Pg149kbLV2qVIhG+2DBfFP
	GZnLZ6YTNR79cHLXv9EOYwHL1guIQaZ7hY8wkLD4s89ttnJi31myga1/KJ8S9Qb1B8lQ+96QFr2cj
	ZDNJ/maw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdk-00000005Q8F-2K0t;
	Thu, 06 Feb 2025 06:45:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/43] xfs: reflow xfs_dec_freecounter
Date: Thu,  6 Feb 2025 07:44:24 +0100
Message-ID: <20250206064511.2323878-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Let the successful allocation be the main path through the function
with exception handling in branches to make the code easier to
follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 26793d4f2707..65123f4ffc2a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1329,28 +1329,29 @@ xfs_dec_freecounter(
 	set_aside = xfs_freecounter_unavailable(mp, ctr);
 	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
 	if (__percpu_counter_compare(counter, set_aside,
-				     XFS_FDBLOCKS_BATCH) >= 0) {
-		/* we had space! */
-		return 0;
-	}
-
-	/*
-	 * lock up the sb for dipping into reserves before releasing the space
-	 * that took us to ENOSPC.
-	 */
-	spin_lock(&mp->m_sb_lock);
-	percpu_counter_add(counter, delta);
-	if (!rsvd)
-		goto fdblocks_enospc;
+			XFS_FDBLOCKS_BATCH) < 0) {
+		/*
+		 * Lock up the sb for dipping into reserves before releasing the
+		 * space that took us to ENOSPC.
+		 */
+		spin_lock(&mp->m_sb_lock);
+		percpu_counter_add(counter, delta);
+		if (!rsvd)
+			goto fdblocks_enospc;
+
+		lcounter = (long long)mp->m_resblks[ctr].avail - delta;
+		if (lcounter < 0) {
+			xfs_warn_once(mp,
+"Reserve blocks depleted! Consider increasing reserve pool size.");
+			goto fdblocks_enospc;
+		}
 
-	lcounter = (long long)mp->m_resblks[ctr].avail - delta;
-	if (lcounter >= 0) {
 		mp->m_resblks[ctr].avail = lcounter;
 		spin_unlock(&mp->m_sb_lock);
-		return 0;
 	}
-	xfs_warn_once(mp,
-"Reserve blocks depleted! Consider increasing reserve pool size.");
+
+	/* we had space! */
+	return 0;
 
 fdblocks_enospc:
 	spin_unlock(&mp->m_sb_lock);
-- 
2.45.2

