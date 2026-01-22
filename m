Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373233EB1B;
	Thu, 22 Jan 2026 03:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769053121; cv=none; b=XbjA7buMEAXoxi7yxFKMpP3hsjWmrcydLAO2qh/K/pG/LoOLy7WL91vktscbvnTADKR8dEUZxb4DGsJACrFTEfFCyZCpsiLVmPvse0WJyiGxo+pQMuFCTBLjheloHaNboOqcq82eRfaDR4K4oOgve0ywtSxsI5yKrGsHG2uX//E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769053121; c=relaxed/simple;
	bh=hLyvoGo1gxEneRFAtCzpUF9dDEGT2F0SoHECw/cULd4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EXQMl4ZgBxe4i8Ev8KY3FPRB6Lcvhlz67+6XAS1Top+sMJzYVRdbH/kjhlXaoWhOP2fXhFaK0OAC4PNb6dh3Of/zQiqUFfC3SLQSbByxjRf+YU/USipRBDOGrYPj5xqzUn+lD4T6kJT7NmlhXRsPsmr4tzEQK2JGNQis2w9XtH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=ubmemy2n; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="ubmemy2n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ubmemy2neeeHN7c/fCsdqss9I/X9GSwELUxY9v+yBtgY+qCxfvJki7CljUjgt8mIRNjaW+NJg4ZxC
	 QBajVpH5ldoDWfg25vzKolv4T4P0HnXsvdXIr7VfUucSwEenz4WiZuG2s+mufnqVcihWV6FPeIe1Z5
	 LKq5lz+I1IxE8ZLE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-40-12054 (RichMail) with SMTP id 2f1669719baad48-03d9d;
	Thu, 22 Jan 2026 11:38:21 +0800 (CST)
X-RM-TRANSID:2f1669719baad48-03d9d
From: Rajani Kantha <681739313@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	ritesh.list@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	djwong@kernel.org,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 6.6.y] iomap: Fix possible overflow condition in iomap_write_delalloc_scan
Date: Thu, 22 Jan 2026 11:38:26 +0800
Message-Id: <20260122033826.3110454-1-681739313@139.com>
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


