Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9166314A0A8
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190324; cv=none; b=rrDIvxOPAn4pzABmNzIk00U+tsBpBxAP9Jaj0rwJtH/Q2+64yh+1628ISD1NInBQp76y0bZTC1ev2+MwaEgXS/IHyi35+hRUz9lXeSTgOwl8TPCW/NzBPRLclZllXW+7ndqP4U1Zw0D0aBgRVLlao7Teu8navqor+c1UJX/RSas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190324; c=relaxed/simple;
	bh=A8DgtxxmqnXEEsr9PV2V4eoL2O3PIA8+G3AhLpAJcR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tstnP18K+Ba/H187Kz3Rl2imfMejTHZ4h8CxwDDYzTByGDwBmlPMmlUDND8XzEIog+15OmlnmnohduX+IKnYF5C51MoagixTTNjd6LKGuF6MGcGZPF9GabJWSvcYObo5COgFSGRvhRbpC39yAwWiUD6xAiNr2xMxrQXFt+XcvZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vt+rlsep; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vt+rlsep"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=swsQsqynUt7owVwtkE3+UTvvqHKPqFOmeljnUkiOzW8=; b=Vt+rlsep2gLVS9HUWoQKEqLUz2
	yQfcDyzY1BDHB2RMiFvWe+768SytCO2omtlwU4PvELx1sxqiC0RqQOJlAlnJsIlV0n+o/m0epj+Ey
	T/ga/r5m2b15qfT4UVsghXc3vxG1wjjo+mbd4QOqr3iZqZLwXTnfk1iB0PlOi3OXM35cuO84qc+yC
	mDqDY/dNHh89nMEciD8JipGnExsbVAIaLtmGAUwkfqGltu8XkfJ00A9W8dAnRhE8EE2u0MLD49DHK
	vcG4o9tnfu3neqD9SfP881oJjgjW7sIegp8lRAC3Ts40DbTABP2+2b/wiDqT2HxDS0Ye0c/HTJT7A
	wFb2L7Og==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3Ht-00000001IWI-1eet;
	Mon, 17 Mar 2025 05:45:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: don't increment m_generation for all errors in xfs_growfs_data
Date: Mon, 17 Mar 2025 06:44:53 +0100
Message-ID: <20250317054512.1131950-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250317054512.1131950-1-hch@lst.de>
References: <20250317054512.1131950-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_growfs_data needs to increment m_generation as soon as the primary
superblock has been updated.  As the update of the secondary superblocks
was part of xfs_growfs_data_private that mean the incremented had to be
done unconditionally once that was called.  Later, commit 83a7f86e39ff
("xfs: separate secondary sb update in growfs") split the secondary
superblock update into a separate helper, so now the increment on error
can be limited to failed calls to xfs_update_secondary_sbs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index d7658b7dcdbd..b6f3d7abdae5 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -311,20 +311,20 @@ xfs_growfs_data(
 	/* we can't grow the data section when an internal RT section exists */
 	if (in->newblocks != mp->m_sb.sb_dblocks && mp->m_sb.sb_rtstart) {
 		error = -EINVAL;
-		goto out_error;
+		goto out_unlock;
 	}
 
 	/* update imaxpct separately to the physical grow of the filesystem */
 	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
 		error = xfs_growfs_imaxpct(mp, in->imaxpct);
 		if (error)
-			goto out_error;
+			goto out_unlock;
 	}
 
 	if (in->newblocks != mp->m_sb.sb_dblocks) {
 		error = xfs_growfs_data_private(mp, in);
 		if (error)
-			goto out_error;
+			goto out_unlock;
 	}
 
 	/* Post growfs calculations needed to reflect new state in operations */
@@ -338,13 +338,12 @@ xfs_growfs_data(
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
 
-out_error:
 	/*
-	 * Increment the generation unconditionally, the error could be from
-	 * updating the secondary superblocks, in which case the new size
-	 * is live already.
+	 * Increment the generation unconditionally, after trying to update the
+	 * secondary superblocks, as the new size is live already at this point.
 	 */
 	mp->m_generation++;
+out_unlock:
 	mutex_unlock(&mp->m_growlock);
 	return error;
 }
-- 
2.45.2

