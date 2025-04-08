Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF5F18EAB
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 00:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744072231; cv=none; b=h0XHdiwN/54h9fAadnjYaVSY6gUdE2LCDE2exT3Aj+c4QrAh6rELwc81AIIzXLGS3hwpTRlfTxiU00QlfDXjBG4aPKV9gCDDqhIfm31W7KEaMEASjybxuSZ+sjcl3g87J27DX3eoxMXKJ3nMCQG9/SyggTEVwve3PrdukWbNYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744072231; c=relaxed/simple;
	bh=hU+04e47WdLXU6b+KO+L/C3kcfDkVd29MCdcJdf/NAk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nlcio2MEwDhR4MzGiJkN4lqakZhWgeSGcUH6u1SP0YIKJwUpwfTiQDGWBkJapti86U0xCE7Iv1GDml48Yv4LZoPF1UxQpK7ArVVahXIMzueyhuR7Xghm9KItY4w6FG71hERpUpviIbrgv6nrFBA0kbCJI9rrQmMvA9ZoTSTWEt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLaNcOv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLaNcOv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC87C4CEDD;
	Tue,  8 Apr 2025 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744072231;
	bh=hU+04e47WdLXU6b+KO+L/C3kcfDkVd29MCdcJdf/NAk=;
	h=Date:From:To:Cc:Subject:From;
	b=OLaNcOv6txm3OyHRogtYdjm9aKJtTvZyK1iYFieOeZiawcUgvfSxQUIUTfoeeqPD4
	 7/HwYsI4AIx7zDV/bgaUsUrcZxdKbKKrXyQyWjZjniKc5bjp9i0++ylaBQB2PcT6ht
	 gPFbYmYE1ms7Yu/0OZywj6UG450zWZOrGoCD+g8/b0nTS/q06fwHPK5rOvs7rYWieG
	 /+SmcpKd1uABTObzTq7PuDbKKHshEOFU27e2DqY0SRpdyxbC9JA1EIATNvVo1lTEI4
	 q50Kd1DHfuAk+jqIWjLtkqEODv55+XGQS+wugp4Ln+TZBao0e3U86LJ00MOofzZe3E
	 WQ/ospCjm67Pg==
Date: Mon, 7 Apr 2025 17:30:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: compute buffer address correctly in
 xmbuf_map_backing_mem
Message-ID: <20250408003030.GD6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Prior to commit e614a00117bc2d, xmbuf_map_backing_mem relied on
folio_file_page to return the base page for the xmbuf's loff_t in the
xfile, and set b_addr to the page_address of that base page.

Now that folio_file_page has been removed from xmbuf_map_backing_mem, we
always set b_addr to the folio_address of the folio.  This is correct
for the situation where the folio size matches the buffer size, but it's
totally wrong if tmpfs uses large folios.  We need to use
offset_in_folio here.

Found via xfs/801, which demonstrated evidence of corruption of an
in-memory rmap btree block right after initializing an adjacent block.

Fixes: e614a00117bc2d ("xfs: cleanup mapping tmpfs folios into the buffer cache")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf_mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index b4ffd80b7cb632..dcbfa274e06dc6 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -165,7 +165,7 @@ xmbuf_map_backing_mem(
 	folio_set_dirty(folio);
 	folio_unlock(folio);
 
-	bp->b_addr = folio_address(folio);
+	bp->b_addr = folio_address(folio) + offset_in_folio(folio, pos);
 	return 0;
 }
 
