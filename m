Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA522F12AB
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 06:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763448589; cv=none; b=jkXRZtH1tA+MFAvA47mYE+2b3g6rVY2UgtXPY4pV3zego11hBXBdSEWuF38KZ10BnnKpJ50ZaQIc5DUEK06Kd5cw3fHMr7PKkIzCf/ubF+zqW2GT5it7G7zU48BMfYHvGgpKXO/9KSIi1Wcodd/oGm5DE1wX67SXNxLz+dfKEys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763448589; c=relaxed/simple;
	bh=C3BT7P/7ZynTTooGLf4RwjQgIgu0RodVGyrN87Cb1fE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hbEApqQtfHwD5J4rOBmFmqNnve8D6ui8r7/vldpN1vKYl5dGwm7ediSa/hQEZuMs4NUU9zwvK7H/WjsvFTdq+OiUsAgUHe1YKaE6y6WB2v67Ry+kNCkuFfALojZG7Elo4i/E6xkPRUBmg/1Io5ZV6uZaTdlOhwZNnBtq85dzjFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hsr2/8VD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hsr2/8VD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wLTbaC4/xEW7n9MPUC5hdPGJz+WLAAtaRYvldgEwvDY=; b=Hsr2/8VDMsJxO/fmOSjXchFD6q
	w3jsEKfmKpIFYhsSPjYwzEEejLfTwDmjKLifZl8e3df85LFLyuwpqM9ihc78D5jfcR5KmefhDEMTX
	YHFKg+0GnkIGHi7bx8wMBO9zMbo/vvTkrDU6Dgf6naBAvRjvU81lhtW8g7+ESG3QIuWMZNdO7IoEq
	pjcCKvxil0Uhrw4ZnA4k9zghQrw5XzKYHFjWZ3Tluj2cGneR4GWJfoIejwMKRjW33zHgvh4hE4iBD
	dtgpXaqI3ptfqF/m7T5VS9LW/rQqc7a/nnCK8l/c8F1iODAbZol3ml+/NGWMeXUSpOnWYcGH73P8S
	pyfv9Y3g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLFX6-0000000HVme-3sll;
	Tue, 18 Nov 2025 06:49:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use zi more in xfs_zone_gc_mount
Date: Tue, 18 Nov 2025 07:49:42 +0100
Message-ID: <20251118064942.2365324-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the local variable instead of the extra pointer dereference when
starting the GC thread.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 63afc3caf2b7..dda0bf205bd2 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -1182,16 +1182,16 @@ xfs_zone_gc_mount(
 		goto out_put_gc_zone;
 	}
 
-	mp->m_zone_info->zi_gc_thread = kthread_create(xfs_zoned_gcd, data,
+	zi->zi_gc_thread = kthread_create(xfs_zoned_gcd, data,
 			"xfs-zone-gc/%s", mp->m_super->s_id);
-	if (IS_ERR(mp->m_zone_info->zi_gc_thread)) {
+	if (IS_ERR(zi->zi_gc_thread)) {
 		xfs_warn(mp, "unable to create zone gc thread");
-		error = PTR_ERR(mp->m_zone_info->zi_gc_thread);
+		error = PTR_ERR(zi->zi_gc_thread);
 		goto out_free_gc_data;
 	}
 
 	/* xfs_zone_gc_start will unpark for rw mounts */
-	kthread_park(mp->m_zone_info->zi_gc_thread);
+	kthread_park(zi->zi_gc_thread);
 	return 0;
 
 out_free_gc_data:
-- 
2.47.3

