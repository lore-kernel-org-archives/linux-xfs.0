Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45053BF660
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589867; cv=none; b=T2oIZQfcIeWDJp9ufA7dkSvKCAPLAsweDL0ahHtgOJPaJDhwtSc18s6ExN7hoTAlJxyYgdPgjIVfOrubSLOKwH11RpdlQirWRS5EAhhOcrNKWe/i6E0BU44ltXUlRtpyEv8UFNj+GWyOOvgw/lVgb/CsWg79JHOXpol4hrM0J/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589867; c=relaxed/simple;
	bh=R+arhu2jJB0uRdtvIGUwYMYldjZf7CtuMw8U/cp+zOw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LgXTdM2zB0FblYH0lmrVBymdoaDUeH7/4N6wSHeC2PfapIZtGz8VZYsijLO0kFlLQJsRGtiVeRZTWhcJBaBTqWpf+lCtWgC3w9enUMojgn8F7wcUPHK+cj9FuurRUbg+cI6XWp+VM0t5Ihj9CtqNQ6Af9eniUztw1S6nRjTPIkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QLXMSEKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLXMSEKI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 750081F000FF;
	Fri,  9 Oct 2026 23:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589866;
	bh=CsXB7xN55v3coKunCtq8R1Kw7bkJOp1l7nsJojdq3vE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=QLXMSEKIGq0j3exNCGPMMyTKyXE00HqjykznoJrYfue1UZgZeHlB/xAdSf+YOxqTd
	 eIdXyt3VJVqUk+KRxcHlMXkPdqG3PfGyIBIKZmtQKJOxBN+TG1+NmGAvB4HGp55Z9W
	 srKuQqLk5j/rhmo7ENvUB4GFrco+zpP2FqXqXet+h2617G5Cxqu2FQiBfeqhG193/l
	 8JAmr2AA/4aXxMQ/TZKrHi9oQQWL2qIjLT+Ao/MnPTEOEt7h3JNRWsNstKVUXI+4yz
	 WtmhRWGrayIxgyRb/4oi7nZHw00kwjf0tyQsUg5DEfUAcYEI45rRuuW6xKNPLOjpUD
	 BkMe4iaQEaGZw==
Date: Fri, 09 Oct 2026 16:51:06 -0700
Subject: [PATCH 21/26] xfs: don't leak new_bp if xfs_btree_bload_drop_buf
 fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947753.3719791.1605608413550391558.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: f1930bc578095409c2dcfca6e4e898b24f0f0de6

LOLLM observes that in xfs_btree_bload_prep_block,
xfs_btree_bload_drop_buf can hit an IO error if writing the delwri
buffer list to disk fails.  In this case, we fail to release new_bp,
which means we lose a locked buffer.  Fix that.

Fixes: e069d549705e49 ("xfs: constrain dirty buffers while formatting a staged btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_staging.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 7314dab4bcfbc6..561fd2c2e95055 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -336,8 +336,10 @@ xfs_btree_bload_prep_block(
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
 
 	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
-	if (ret)
+	if (ret) {
+		xfs_buf_relse(new_bp);
 		return ret;
+	}
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);

