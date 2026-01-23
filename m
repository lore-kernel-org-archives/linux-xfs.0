Received: from n169-113.mail.139.com (n169-113.mail.139.com [120.232.169.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B832F6935;
	Fri, 23 Jan 2026 06:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769149990; cv=none; b=j6u2hNuGaQOegZQMjdEiEB7ysiDbwNRF7f4dWiL15NWCDeYJI0ZuxZ+b/Uuypqa9Go90fFH8lGNfrqJanXnMnjuavb0QKYqAWnebi4FPrVTn2/e4/RWFfL9JaMUcL8zxiGgz3v/Xzqx0dHW02OC5UUN8GoaQIxj9xVeTWg02LC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769149990; c=relaxed/simple;
	bh=hLyvoGo1gxEneRFAtCzpUF9dDEGT2F0SoHECw/cULd4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cf7PB3/4vKHDQY0PQpDZYWkl0iICVdXRh+JfoIHq/StR0PH54IdWEB8g8kZlw1KXeJBc/Z913axMF568jEEz6YQIlHdif5dmr5otA5uAK3Jblf8o0I6yYKwSpPr3yPpwOosE/CREv/bxfYccMkX4qL+tpiqUkXb7F46fM/CVwRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=IUf5e5JP; arc=none smtp.client-ip=120.232.169.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="IUf5e5JP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=IUf5e5JPhXpUBIpobMAI9DisxIqHpqeCbXtRtRMCjYtMFYhYoTFKrTo5tV1x2Kd/gu3DFzc6c4xkE
	 ke3YcfxuONzIeUvsQbV/dFBau3qu4NYf8bosGPLoflYkMnuHJvD9+pNk7TpR1vhJ7urcQ2ZvrdgQc1
	 Y0J+7xgiDCSgcdLg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-31-12045 (RichMail) with SMTP id 2f0d6973161f90b-0091b;
	Fri, 23 Jan 2026 14:33:04 +0800 (CST)
X-RM-TRANSID:2f0d6973161f90b-0091b
From: Rajani Kantha <681739313@139.com>
To: gregkh@linuxfoundation.org,
	ritesh.list@gmail.com,
	stable@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	patches@lists.linux.dev,
	willy@infradead.org
Subject: [PATCH 6.1.y] iomap: Fix possible overflow condition in iomap_write_delalloc_scan
Date: Fri, 23 Jan 2026 14:33:00 +0800
Message-Id: <20260123063300.3820420-1-681739313@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>

[ Upstream commit eee2d2e6ea5550118170dbd5bb1316ceb38455fb ]

folio_next_index() returns an unsigned long value which left shifted
by PAGE_SHIFT could possibly cause an overflow on 32-bit system. Instead
use folio_pos(folio) + folio_size(folio), which does this correctly.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 70e246f7e8fe..e4f58d1e12d4 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -903,7 +903,7 @@ static int iomap_write_delalloc_scan(struct inode *inode,
 			 * the end of this data range, not the end of the folio.
 			 */
 			*punch_start_byte = min_t(loff_t, end_byte,
-					folio_next_index(folio) << PAGE_SHIFT);
+					folio_pos(folio) + folio_size(folio));
 		}
 
 		/* move offset to start of next folio in range */
-- 
2.34.1


