Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0FC29A1
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 03:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733889281; cv=none; b=t8DqW0Kb4sdHmu7g3x8URg8wxYxkZdQ7LpeUarlD5nYRS6tf3LlIqwUgBqn3inIXUuXbL5ofP9aKC41pLHKuPrJUUPYDNJA+EIr7qeIK+R1+bXRNOa8wjTrFjPSXwf4LL0gDnNx5/plAnpqTjSvlI5dnzQ7mmrrr0r3xzqHH6pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733889281; c=relaxed/simple;
	bh=Re3G9vtNttWNP2ZawaYcVtVBejpeMAzYpwew5pnefIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EPvcWcGlo+F+7476+CQt/AgD4B4BBcE/RhPU1wnygftyms+rMq/1mzV7Qp7dvFaYotG3AUWs2z/8jiyr1BMaVliznD32/PUHk3D7rYS+Q2OqKIe5LppzmfNqnslB29c8XlNgHQAeGpwGYZHM0nsmwVy4v8CE8kxB8iJB/vVZAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z7Iywrwp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z7Iywrwp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HYrhnytZtebNr79494Iayn9IBv3qLsK2zYhO3TZowNo=; b=Z7IywrwpURQdHND2ygOALNtYCS
	FbippDZ8EF8PHgpzW/SivaIDYRo+Y8uCo7MjT0JcCG7sJOvMLbww/EHtcGxZmzDHT3lMldEPOmY1r
	QSrCaTVsaOnqqP7EryDkThI8+T4ofp54TngbjYYdarMCPh0xwm3Vze+c6MpiTvH4ZwJ7+blN1q2Jc
	sFNb59dsX3HoC6cVMMKyHhG6W3Yf6JysQIrZiGkHtqMJ9cc9VV75vuH4E8hZ7+Nw5NMDmuaF3i3ci
	jxC9aBzdGXmhbeKGhdgMvY06+ZqXPJk2HwYovZ21ITJHR8ELuWAuPsdDf8+YYTSrWlJWkFgYs1jy+
	1Z0Lx2bA==;
Received: from 2a02-8389-2341-5b80-4491-cb0c-6ce7-8d5e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:4491:cb0c:6ce7:8d5e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLDo5-0000000DhxT-0Dq0;
	Wed, 11 Dec 2024 03:54:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] xfs: fix !quota build
Date: Wed, 11 Dec 2024 04:54:32 +0100
Message-ID: <20241211035433.1321051-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fix the !quota stub for xfs_trans_apply_dquot_deltas.

Fixes: 03d23e3ebeb7 ("xfs: don't lose solo dquot update transactions")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_quota.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index b864ed597877..d7565462af3d 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -173,7 +173,7 @@ static inline void xfs_trans_mod_dquot_byino(struct xfs_trans *tp,
 		struct xfs_inode *ip, uint field, int64_t delta)
 {
 }
-#define xfs_trans_apply_dquot_deltas(tp, a)
+#define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp, a)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
 		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
-- 
2.45.2

