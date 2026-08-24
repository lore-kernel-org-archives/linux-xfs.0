Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE627AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572002; cv=none; b=rhNTQyEeEqW6VTYCAjAGaaT3dr4p7uHYKmEU8lmbCI3VH82y9/lLCpgeP6+J+aSy6BnQHZjLbaxepXvQHoMtk6meOtnlYeR8T4FWo0i5u+m4kyleQQA1UlQCv5Xp6tRgBa2gKYA6ne4BeZcYCLqln6WgcvJ3sx4iBxSAK9dXz6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572002; c=relaxed/simple;
	bh=1ijvOQT229YNunusqUrbqrJhBllUQ2zOqWtFzTK2u7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADdUCN9HLZNNu7EJeGvwH2cc5WL5gZhkJ89X8di+aFq+RkmKu9lnmqRM7Q9Bw6qUHhAAYH+10tAnWAnuNjUJwHb6Bew0GVfQ+/0PDjifAvqzTmypvAzREY4FkBi+okRX0WhORhfn3r9sddVSf2EvRzs5gPWjmKdNwHPiMMrnQ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRS50VCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRS50VCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B34B1F00A3A;
	Mon, 24 Aug 2026 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572001;
	bh=L7ViIRq60PSbcv/JoFAAfK6Rs85nCBvzFQ7bmbrMrCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRS50VCK9wOFXAa/55JwiXFFF+hDVIrqM3mDEmxnCp5oBtsHpwhZ5CAwdhaKy4BcK
	 b5Kxh4ChSW54k0bsd18aEmMb8y2cD/YxU7u2We2czqWxqBRi5Ku+cr8QYb7UyU48Ff
	 f+GKO8CqM/cZY0Qw+jVofrwD4AMQaA4EATU3r18/3moAuKXvTnoSOOUL6P1Xogdsd2
	 eFlQpVBauqHcrgfvV5vtOAWXFYHXvDzEC7fo+mjIsWYk6cbw+IVNUFJgM/aeeS9XRx
	 TLCKIp+MUoqHeBciLNmRGSLbMKikE+qKQqgRlcLUnD9gwTu3pSyMv0KCpf0q1HwsDH
	 hgiLAzz1BrrVg==
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
Subject: [PATCH 14/21] xfs: fix pointer arithmetic error on 32-bit systems
Date: Mon, 24 Aug 2026 12:40:12 +0200
Message-ID: <20260824104022.420566-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
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

