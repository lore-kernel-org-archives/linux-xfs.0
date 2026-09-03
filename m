Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73324495503
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435709; cv=none; b=jvGvY4ksTdotLbcuCa/MwDrlpoPKxafWjkc//2qQnqt6Yg8rrv07IK/gRc2jP8KkTIXLxeEETIcWK36bQiST8yDg1JPg6q76bPpk90UmLaM4h0geUw+JCwpPFlLFLf9jTo/73TOhqYj6K7n9Qh5SAgyyTYVg+WwHSA+I1cmT5dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435709; c=relaxed/simple;
	bh=1ijvOQT229YNunusqUrbqrJhBllUQ2zOqWtFzTK2u7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjxQjnQkdsy4vGOLWkFKlxThGuifD1/Pd01OitY5Ptu/6iyUwB9NAuMM3oy+uI8TZ+VQX4SvXOUr17MQp/TmVCbRiadq6mdS54W0JqSUL8M/IcHbNJO4Ak54lIKB8hQx4v4vNJOrlmujG6+PoFkYaN2focsDgHX0ap0JjLLx8Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wrl0u2fC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wrl0u2fC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0FC1F00A3A;
	Thu,  3 Sep 2026 11:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435697;
	bh=L7ViIRq60PSbcv/JoFAAfK6Rs85nCBvzFQ7bmbrMrCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wrl0u2fCkgw8GlnEcdRKrXk3nTTpXVWfAcKDyBfzlVEDtooNxanLzgpQbi1S1uFiG
	 0rKjVxjDOrXiI/7CvzKRWHMif0Ai6o7LDXI1xvd3hgbpPP/BbaDLoO21+BRncnJNaL
	 oxIiS1cNe+tmhQ7V9y92+VGrohPdykrRSMUNIxNsgsMk9NcPpNvCifAT2B1xsRYcYK
	 VJh3MchHq34QPsxzmLHL8RPtipwYTbnB2INh3/z6oeS20dwRvoA9YQST+vaOJF72iX
	 zB4j9O0urvATQBq+gz92qc8hFTHCz7dI3uq6Lux87ElZ/OEfqIMJsVVwbrTeRMAC/a
	 eiG7SG7Z5aSTg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 15/23] xfs: fix pointer arithmetic error on 32-bit systems
Date: Thu,  3 Sep 2026 13:39:57 +0200
Message-ID: <20260903114022.570210-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 84eec3f7fc73144d1a230c9e8ad92721e37dcaab

The translation of the old XFS_BMBT_KEY_ADDR macro into a static
function is not correct on 32-bit systems because the sizeof() argument
went from being a xfs_bmbt_key_t (i.e. a struct) to a (struct
xfs_bmbt_key *) (i.e. a pointer to the same struct).  On 64-bit systems
this turns out ok because they are the same size, but on 32-bit systems
this is catastrophic because they are not the same size.  So far there
have been no complaints, most likely because the xfs developers urge
against running it on 32-bit systems.  But this needs fixing asap.

Fixes: 79124b37400635 ("xfs: replace shouty XFS_BM{BT,DR} macros")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap_btree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index b238d559ab03..e0c870beaf67 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -89,7 +89,7 @@ xfs_bmbt_key_addr(
 {
 	return (struct xfs_bmbt_key *)
 		((char *)block + xfs_bmbt_block_len(mp) +
-		 (index - 1) * sizeof(struct xfs_bmbt_key *));
+		 (index - 1) * sizeof(struct xfs_bmbt_key));
 }
 
 static inline xfs_bmbt_ptr_t *
-- 
2.55.0

