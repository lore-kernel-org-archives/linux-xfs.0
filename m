Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7F938DEC
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190327; cv=none; b=t29e0Rvr9BzSLw7sj510ZMEb4MRM77t2Dt0T8rJGM12bFadIwTgMd3n1DxL1w/BmHXc2AqIu+3HCX/oO7TPRUNzBr60/Fv3GzxxxgRpVshwEA47+l5MBIXq/Z9UgV3nXIhlgYt5HfewsLhip1cMXtMtXuLi6AG5FMdQ+EHrwte4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190327; c=relaxed/simple;
	bh=MQuBqFEfDtCBa5NhmQS3Znm1xWk6/QoviB3NNgHkUTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqM9sSVeRN2x72PaiAwZSAbrO0z53aYHc3ptTKXhgu1AhfjnuE3iTeb62CCg0/gySWqRfWy+GmLIipO/VTIMFg/fHrvNfVkGCgSl/a9CAKK7l2cumV2/Jir+r2je8lduzxRthu5o78t7PpREb/6FAclv+DiUp2HiiWLnGya4lmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hqB3GRqB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hqB3GRqB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zOh6h2Gp4AVjW1PAgvFdTmqcnrutzSzreGR3aXuhFOg=; b=hqB3GRqBqQa9xFTdSy3/NBZ2Af
	qiFyMTEVegfNg7XPXUMFavO5ZbvM+z8j292k8Bma0zSd6cHTA2977bJeAYAXC4himtXuuvbqEVn1o
	1YmTj6ErpAE0SVD+SAJ8brjSPKR/Al+1gmN640brfDqRYrKmoIO32YYMtaqc7qgBUdHiQM0ikNoy+
	hGE4gO8cC9raNfkMx6Kkz5bD6wGUGKJ2iIKctrMV70/XSC9FaFlQ73WizP4Dv2x5qxteKwhQJLLPG
	qtWGz0QFE6DhWkEEEtHFwlcqYWogN2s1WQ2hkiZ6nCRRKpGR/4vEuSglFASjXQgJb8gP12a19WURA
	wrPB0CZw==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3Hw-00000001IWc-3eGg;
	Mon, 17 Mar 2025 05:45:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: don't wake zone space waiters without m_zone_info
Date: Mon, 17 Mar 2025 06:44:54 +0100
Message-ID: <20250317054512.1131950-4-hch@lst.de>
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

From: "Darrick J. Wong" <djwong@kernel.org>

xfs_zoned_wake_all checks SB_ACTIVE to make sure it does the right thing
when a shutdown happens during unmount, but it fails to account for the
log recovery special case that sets SB_ACTIVE temporarily.  Add a NULL
check to cover both cases.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[hch: added a commit log and comment]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index fd4c60a050e6..52af234936a2 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -853,13 +853,22 @@ xfs_zone_alloc_and_submit(
 	bio_io_error(&ioend->io_bio);
 }
 
+/*
+ * Wake up all threads waiting for a zoned space allocation when the file system
+ * is shut down.
+ */
 void
 xfs_zoned_wake_all(
 	struct xfs_mount	*mp)
 {
-	if (!(mp->m_super->s_flags & SB_ACTIVE))
-		return; /* can happen during log recovery */
-	wake_up_all(&mp->m_zone_info->zi_zone_wait);
+	/*
+	 * Don't wake up if there is no m_zone_info.  This is complicated by the
+	 * fact that unmount can't atomically clear m_zone_info and thus we need
+	 * to check SB_ACTIVE for that, but mount temporarily enables SB_ACTIVE
+	 * during log recovery so we can't entirely rely on that either.
+	 */
+	if ((mp->m_super->s_flags & SB_ACTIVE) && mp->m_zone_info)
+		wake_up_all(&mp->m_zone_info->zi_zone_wait);
 }
 
 /*
-- 
2.45.2

