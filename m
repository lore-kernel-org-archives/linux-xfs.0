Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408751118C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 04:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714450085; cv=none; b=KIpC3wzMepBYTXCE/Top0qZ+Y4pQ7PdLH8hC9JAbR09OjIY2wnyp0lkZ5K3EZiLX9vR6loCfT5KHAKA77pq/O6r+hzx9d9VR/4ttqlbZcAOsg3A70wR0Y2/bRuGBPcVnqQKYMfTUhYlCA8G+DJp6HlPUpYJ7EMH/9XbSmOf2GvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714450085; c=relaxed/simple;
	bh=gGQi+1RAvKuBkT6jRui7YMS1cjLZXFlXEM4KuMBv7Ks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RmOm45ATnIUdOIhR4WCxw0eET7677HZ2UPD+y1S3DKJE9EJM4g0uKdv8ez/ggf9r2Z+Ua/fG+PTYlZr1fSnpVg4l8sx7KJG6nL3HhL9Tq8HxvX3dB4W3W4KUU4MlgkZpWpN0UqGA7z6IBNZclVHhf9CCMWaA0LGd5hvcj4dz1wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZpY5sWsR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZpY5sWsR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Gm2a3kQFLFqr1MysZOQ6Ye9GJp5D2HpQ2e3DOS2g+5o=; b=ZpY5sWsRIt7AvnsuJkBEaklflK
	H5ZXeFuqVkDjXjTJhmnzklbUWNYSy1OSWWqD0TtAicJmweZ8vx1eM/kIvbrpZVkCwx2gbvjggQayh
	EP9d4mfEfs2+mCOvJyKjyIMc8s6bzHGbyIavEd8pbjUa+jHLT98TT1Zs9qN5wr8RJLK8T0bgGuRlm
	n8InciTRJPgL518rZ2HIRPEfRVfyzYbCHc6vxA1uGxWSB8+ZE8DxN0KSKhmj1gg/BhG8F24Fh8WwW
	QtCNHD3a2oC7Y98QOFlnVmAqdnkzG0cYoWDQy/kpwuRRqcYOxorEjvZWGoAjgKmvYHgSWsfRxWODZ
	/ZVD3JLQ==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1emf-0000000501M-43c4;
	Tue, 30 Apr 2024 04:08:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: fix log recovery buffer allocation for the legacy h_size fixup
Date: Tue, 30 Apr 2024 06:07:55 +0200
Message-Id: <20240430040757.1653768-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430040757.1653768-1-hch@lst.de>
References: <20240430040757.1653768-1-hch@lst.de>
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
umount record in old xfsprogs versions.  Later commit 0c771b99d6c9
("xfs: clean up calculation of LR header blocks") cleaned up the log
reover buffer calculation, but stoped using the fixed up h_size value
to size the log recovery buffer, which can lead to an out of bounds
access when the incorrect h_size does not come from the old mkfs
tool, but a fuzzer.

Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
into account for this calculation.

Fixes: 0c771b99d6c9 ("xfs: clean up calculation of LR header blocks")
Reported-by: Sam Sun <samsun1006219@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

