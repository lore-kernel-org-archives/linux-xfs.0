Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41BD40D599
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466981; cv=none; b=YIafshepMsGS1z9iKOPgTF+qIX/MiRyVBtY3EdIqjF7bSZ65FUfP2y4PW665SuXQeWKMgQG0sgBsRAUkkOCqSi00cFw+bUpjTa3+SwREB9EONSdsAfsCoON5o0k1gLH+hjC5D4w4SiLuYu1pZxamGbb7CJ1xUYKF78d0Cv49lsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466981; c=relaxed/simple;
	bh=38Giuu3LhrlvWaL5BuRfVMCUMojmo5jD39QFsEOLoyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cj2IJK2Pe8jCtZvT5lh9qt8ceW7uDFndVHDXg88Xyjl01iTxrzfGH+eCN2QkVPZDlWZT0Ame7xcU92/x3oLpW1gmCk/rAeeul3rhAekOl5K8TEd0hOsEtxwENM24ZWrQfz1KJ7Xo86IvjoBSWQhu10Z2h1s9k3jaFgnTo5YCnVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3E/MmOoW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3E/MmOoW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kdstMUMdgT3umFv+MATmTG0+Jl4OvY7YpUAczilYWD0=; b=3E/MmOoWub6lx1OXlOXQ9ahPtU
	/mkH48ib2RwajjMHXuRuTJhSoWPAPyGBmM6tISoWctPFqqcqMwSQoWzOVsk8a2N2nPq3uJxZC52Hu
	BHmJCMFy7brlKLxMhjazJozBGgXsfTygy3sbHLpFkxV6KBbvpfEwZmNTKAsZ+h28P9HfhytID1Q7Z
	LfTHAmLuBzWI+PRuOcCQqOQYFGcKwn1iQpuAV0LWEowvmpIlcAf7rhdKLw7K0zuUPgLX7IvpQ3li4
	SkJt2Q9TawcudUnS0nWiQYs+QcCKXHeu3uhKfzikX2BY+cJIVhlS5l57JKSb5afmDmaTJrrSAtkpq
	wVk8NLEQ==;
Received: from [129.253.192.68] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtpfV-0000000EYKi-0UkD;
	Tue, 11 Aug 2026 16:49:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones
Date: Tue, 11 Aug 2026 10:48:37 -0600
Message-ID: <20260811164912.124416-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260811164912.124416-1-hch@lst.de>
References: <20260811164912.124416-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

In theory we could fail multiple ioends before an open zone was assigned
to them, and the iomap code could merge them.  Check for NULL not only
for the main ioend but also all merged ones on ->io_list to handle this
case.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2a0c54256e93..c80f05507373 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -89,8 +89,10 @@ xfs_ioend_put_open_zones(
 	/*
 	 * Put the open zone for all ioends merged into this one (if any).
 	 */
-	list_for_each_entry(tmp, &ioend->io_list, io_list)
-		xfs_open_zone_put(tmp->io_private);
+	list_for_each_entry(tmp, &ioend->io_list, io_list) {
+		if (tmp->io_private)
+			xfs_open_zone_put(tmp->io_private);
+	}
 
 	/*
 	 * The main ioend might not have an open zone if the submission failed
-- 
2.53.0

