Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7EB46D57C;
	Tue, 21 Jul 2026 18:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659443; cv=none; b=V6WjCo054C26itOgwkoM+V78PdjPMILTsbCwYr8fI9Dlg+NxAYkJZ13/QJiSni9fJ5c+PT1sgIHFgqsGklZHF9Q70NoeFnfGJaWqNgqKZNhJtoKqdVxXzgbNTlQT1W6nzbRpabd5I2dX3bd9fFUes1DizMlZVDIADvpAIZEsFi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659443; c=relaxed/simple;
	bh=gNzjl4zWpkZJaicQjAemkaolWXKfIV765MdaOnGpKBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGKHmVN8/RwDnDCph6WanMimt12ZccOlRkRKQdKqg/ynqK4ujkqa1lmEKnariTbz1aGlbjekJop0LjVTR46z7L78a7xXQvaWOSXU/PtmI3Ki7IAspdE7nu0yB+IHyGcoI/zSv3tIehQdJExWp2ZRNwgBQO5oMlA8kiqT7RPt8Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMe2mkBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMe2mkBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622721F000E9;
	Tue, 21 Jul 2026 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659437;
	bh=DLKRiRyzKQ3SHGS6qPdEtB2Y8TKgDvD/nkziuhY4NXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMe2mkBnWGFuqYeb7lWHvOvaYVxLFjGS3sAn6h+9EmIfmhVWtcMhucsC0jHc2d529
	 j2/sInsGGcUaqJfpKlq5hTcsRiWHzCNj+GbIlae0xrQ6969B5Ln5R+rZkCQlQrMNGX
	 igys61mGg/XLwB7iYfcx88CBALLmZF7b8/yamOQQtjyX721nOFS5OOYiqWcOEowzND
	 BSQhGs34ffJMoD95rUlV6BHGZovFZ6qtowm1qGaJtBVlxIw6VTvxMvgUNdQ6DY6Zbq
	 7xlVUougOiosy9dQzY0RNLueBxuGs7H9aymnjFCmyGkaXcGmDhfXUPKq/ufQoWqSwR
	 AZtP2pD6Orc8w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v13 01/23] fsverity: report validation errors through fserror to fsnotify
Date: Tue, 21 Jul 2026 20:40:38 +0200
Message-ID: <20260721184346.416657-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported verification errors to fsnotify through recently added fserror
interface.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/verify.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 4004a1d42875..db8c350234bb 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -9,6 +9,7 @@
 
 #include <linux/bio.h>
 #include <linux/export.h>
+#include <linux/fserror.h>
 
 #define FS_VERITY_MAX_PENDING_BLOCKS 2
 
@@ -205,6 +206,8 @@ static bool verify_data_block(struct fsverity_info *vi,
 		if (memchr_inv(dblock->data, 0, params->block_size)) {
 			fsverity_err(inode,
 				     "FILE CORRUPTED!  Data past EOF is not zeroed");
+			fserror_report_data_lost(inode, data_pos,
+						 params->block_size, GFP_NOFS);
 			return false;
 		}
 		return true;
@@ -312,6 +315,7 @@ static bool verify_data_block(struct fsverity_info *vi,
 		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
 		params->hash_alg->name, hsize,
 		level == 0 ? dblock->real_hash : real_hash);
+	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
-- 
2.54.0

