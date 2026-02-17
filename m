Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07003221FCF;
	Tue, 17 Feb 2026 23:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370455; cv=none; b=qJVDebJ+hQtSALPziRbXrSWeqA9xyi1OvzUF/HPibh9OqZfE/NA50w1tX1yx/PsAjC9whhyigyHGgEPAaBek8OUJG1NeBkG/BtL3c17E7P2pfkwk6BVlgHq9S185iEk257Z0zDdXhtshn8gpqKLhXacJCsK9ukO68Y1vRNswhmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370455; c=relaxed/simple;
	bh=6tc+JA4sk6Y4Lf3d99eMzGIQ3UpFh1RjotdPAIOmhQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYqT8LylJhrIPpKWWzvrXusQtEAyLM0qsZ3NFGBx2jxOcXTKmSuH2pqaCSsvbE7E0g/vpCwci60XXROmwoSTNp1rUreudkk213M3gQnyyhnny+WA+Ge45UJjy2qx6yInUF6/tyqyYHEKzII2QdmCxJDjo0M8E+s82wIHRV1ip2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npxuw6PN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npxuw6PN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413DCC4CEF7;
	Tue, 17 Feb 2026 23:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370454;
	bh=6tc+JA4sk6Y4Lf3d99eMzGIQ3UpFh1RjotdPAIOmhQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npxuw6PNS64pZniKtEX8ceCpTpPCwbduip2dvqvYoIEUECS0c0VkcU6AUX0ti80g2
	 1OtdMuFDojHaqrWkf9VHif4B9Ef+Yhhc5n++DZkBPvT459LlsOpDjRxq7b09hYjnGf
	 XzSPDjtN6Y2hdkigAUBg1FMD1e6Ve643up9xm+Yzn9jBmn9G6oo9amM0r3TwWZU99r
	 dz5xweVXfDaotGFTdB3TyGDkIG6R7/TZxbb0eC1h2BLcbvcmvEyuXvwKZcBE1Is7qS
	 AtNdBdf7FKDG2yMOKlWczaSgYcGBdnDj/P9WDArxkGdObawELGT9i84A54KmtV+T/4
	 X4KZjElhPAehQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 10/35] iomap: issue readahead for fsverity merkle tree
Date: Wed, 18 Feb 2026 00:19:10 +0100
Message-ID: <20260217231937.1183679-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Issue reading of fsverity merkle tree on the fsverity inodes. This way
metadata will be available at I/O completion time.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index cd74a15411cf..bd3ab4e6b2bf 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -570,8 +570,12 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	trace_iomap_readpage(iter.inode, 1);
 
-	if (fsverity_active(iter.inode))
+	if (fsverity_active(iter.inode)) {
 		ctx->vi = fsverity_get_info(iter.inode);
+		if (iter.pos < fsverity_metadata_offset(iter.inode))
+			fsverity_readahead(ctx->vi, folio->index,
+					   folio_nr_pages(folio));
+	}
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_read_folio_iter(&iter, ctx,
-- 
2.51.2

