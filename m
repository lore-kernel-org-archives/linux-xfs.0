Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152A3A5E87
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244358; cv=none; b=ihpOT6bzMAWpinVdW3UMpk5LW5yXcS5UmtQ2wLrS+AjtvRA+K3hsh0LRWYuPCrgQWlVs8yMqEY+W7Fz5aFGxiPKXJkEek/JJl7aoB2Yl6ZuYMH7k7p4v8ZP7QmcRUdSMG+kOH47+5reY02xvHBcqCyKfHtGRcjLeTnNwjaDVWhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244358; c=relaxed/simple;
	bh=MCs7gKzu5IIOGtf+yP397Z5M7Fzqtnt72yX2CTh+fwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFRYt/n+X3zOvZfNw+O3cGu8m0R0Zc2BJpXiDxFduzyhyt4Dxn8G03KUktoqyv9YkIY85IFZPbJ8Tlyv6EC20+TjQo5//zvFR4ZG9LgoKsJoM+RYyW3XjvDolZC3GWPJbGSsC5WCdrNRbnNs4Y4Sqy7u8udExclek1F+fmz5kCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a1uhpffF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a1uhpffF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KvMi4fn8r/gaVr0NlliGuPY/f0teQ1OmtWbI2A0v9eg=; b=a1uhpffFseJdCI/c8yz4Q6M5pE
	b0UolbXt5RBpeS74KZmNeepzDzdF8unj03QXGqx6rGvmb1bT9xg0HjiTjvm7U5T7s8vOCLilYbJbK
	4C7p59VugKtrwkpS7KG1c7gq8KRqUPJBeGPOSGUf5fGbiMRy/iKa5s5oJaCELU+s1WCYwW5PKwOE8
	lAnN5Gn70gdVwn4STxm5tIXNYyb5joOxAR0M0q2BzYQwgcXGYT4RLfC4biTHpBa75AuXM2TMVyHn1
	sCCXESY54Xum/HADE3cxtts/F0xwnOKVR2wjzm2UFFsvcEoZmacYyh0tjcBWz7+1KrSy+NiNeiquz
	tYCXGAGQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKp-0000000AfGL-0IAF;
	Thu, 24 Sep 2026 10:05:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/32] xfs: add error injection for lazy bounce buffering
Date: Thu, 24 Sep 2026 12:04:00 +0200
Message-ID: <20260924100512.2733748-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 021b211991604298126b47f03abe2ab234048c4c

Add an error injection knob to exercise the lazy bounce buffering
code path, i.e. to inject direct I/O re-read using the bounce buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_errortag.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6de207fed2d8..2dc441da0333 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -75,7 +75,8 @@
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
 #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
 #define XFS_ERRTAG_ZONE_RESET				47
-#define XFS_ERRTAG_MAX					48
+#define XFS_ERRTAG_BOUNCE_REREAD			48
+#define XFS_ERRTAG_MAX					49
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -137,7 +138,8 @@ XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
 XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
 XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
-XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
+XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)  \
+XFS_ERRTAG(BOUNCE_REREAD,	bounce_reread,		XFS_RANDOM_DEFAULT)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.53.0

