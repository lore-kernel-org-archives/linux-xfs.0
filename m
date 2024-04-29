Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F354B6FCB
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 07:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714374128; cv=none; b=cG3rKCQ+6xJR2uDv2/J39rAMbvnuErAZWZTjrYXAL4FQkTuxwMPigbpowWQ2tlpqp3/5JqmnemZC7v/hgSzPaJcK2wWH0SP2LbLnQeojEXJeG5sfjN6Mrhy1bwVhDwDaPu5ZBvufDuzCx/D7Zqu9YrLnm992kc1pkPxCkOm9Y9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714374128; c=relaxed/simple;
	bh=B5TP8kPNsGRbC+z50+LyeNTg78Aljvb1DtH/0WT2sD4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FOxT+APe3NcOT7cVMuTixSfm0LbGWDW4nFwbSP7kP0WDazVOvbyfjluOJe+rPjHR/F0LuIC84QyUWkDEwGWRO5CzeBN6CMS0IZKuwesPxBEf8aKpS9kXTm+P2zpkyQVYG8hnjwp4mkTtuKi2JAG6LVAN4sdgDzskVMegMbTS6sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0P8U3HqH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0P8U3HqH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4MlvS6u545BgqbHkR68ZUxRLvjt0HhlRULqeqAuyyt8=; b=0P8U3HqHTdmaxEfEdwIv3YTuqR
	mknIFDd+RdI1mzZP6QZq4bs35E1Y+nz/L7Yiy5jN8UD/jMjntZeJPpbDLOxy+Tgy5V1Imzxzu8usV
	fAoQF4WX0BrBHoIguBscM11w5hp3OsYKymg03NlMOdEIQYn7rFhpaDoWkTa9QJWJR1T5gk2kzjEcQ
	uk1be/BqQMqkT8eb+CzNFWmv0blXvzY9ZNFkIlU252L1qNjA+fq27ftH8DKLRK7tCqJ26KFzwH3IV
	UjgZS/W86/pCJKiS/pTE4iHTiV5Zxejeb4Qkj/MamtO6Hbx/WN+9Ug6UWHeKkSy7QHywC079HzQf2
	OaZ9VvaA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1L1Y-00000001kM1-3nkC;
	Mon, 29 Apr 2024 07:02:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: fix log recovery buffer allocation for the legacy h_size fixup
Date: Mon, 29 Apr 2024 09:01:58 +0200
Message-Id: <20240429070200.1586537-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429070200.1586537-1-hch@lst.de>
References: <20240429070200.1586537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit a70f9fe52daa ("xfs: detect and handle invalid iclog size set by
mkfs") added a fixup for incorrect h_size values used for the initial
umount record in old xfsprogs versions.  But it is not using this fixed
up value to size the log recovery buffer, which can lead to an out of
bounds access when the incorrect h_size does not come from the old mkfs
tool, but a fuzzer.

Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
into account for this calculation.

Fixes: a70f9fe52daa ("xfs: detect and handle invalid iclog size set by mkfs")
Reported-by: Sam Sun <samsun1006219@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b445e8ce4a7d21..bb8957927c3c2e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2999,7 +2999,7 @@ xlog_do_recovery_pass(
 	int			error = 0, h_size, h_len;
 	int			error2 = 0;
 	int			bblks, split_bblks;
-	int			hblks, split_hblks, wrapped_hblks;
+	int			hblks = 1, split_hblks, wrapped_hblks;
 	int			i;
 	struct hlist_head	rhash[XLOG_RHASH_SIZE];
 	LIST_HEAD		(buffer_list);
@@ -3055,14 +3055,22 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		hblks = xlog_logrec_hblks(log, rhead);
-		if (hblks != 1) {
-			kvfree(hbp);
-			hbp = xlog_alloc_buffer(log, hblks);
+		/*
+		 * This open codes xlog_logrec_hblks so that we can reuse the
+		 * fixed up h_size value calculated above.  Without that we'd
+		 * still allocate the buffer based on the incorrect on-disk
+		 * size.
+		 */
+		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
+		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
+			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+			if (hblks > 1) {
+				kvfree(hbp);
+				hbp = xlog_alloc_buffer(log, hblks);
+			}
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-		hblks = 1;
 		hbp = xlog_alloc_buffer(log, 1);
 		h_size = XLOG_BIG_RECORD_BSIZE;
 	}
-- 
2.39.2

