Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79CF3DB62D;
	Thu, 19 Mar 2026 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939770; cv=none; b=Phe0+WU+/t4vOJmmpKJuzI6gQ2FOiK5PA90OP9DgC7nsXmOQMAGwltVo4ON40TDmkFw5Bj2gFTJTL/n34Dsauy4qHHmlWjhcuiUqSlq4Ra+CjTvQCOctgxRPyZZTrGWKvmSdSSXsfhgHaedm6DXMnPumRfgtUCkQm/mV19kzSlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939770; c=relaxed/simple;
	bh=243Psy4aTxTkRvGQCs3mF2qAJ/K0xtW/ydhm17iP0yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1rNF6FWa5QwsyiliXgeo2RX5S411l3RDqcMuEfJkQOlh82bbl+5ipZ/w9XgdNsrIl1Fix7bMZTjNHCSsK0JYY1dy28Yxedh5Jnf0aj5QxNqQjesrwsVV2mm8EQbmZ15WjnuI9TOjfhIBeIDpjQpKcjD9qEgUewHWBC9hdxnKKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aw3buszN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aw3buszN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709FFC19424;
	Thu, 19 Mar 2026 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939770;
	bh=243Psy4aTxTkRvGQCs3mF2qAJ/K0xtW/ydhm17iP0yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aw3buszNn1Vs0ZA598ldjdI1sDtkmLPvnxtjy19g37dxZmn/KCO1JIoHxtjYkFojP
	 ik7mLeyOMatCbNKnEWt1/aEsRIAsDadjIoVGyZuFpUkpMBO4PCDCbpJQKNEkwlmcj+
	 dYSRSsyFpsUayDt9E+R7sDuSf/Kg0uWeunegeCiF/0WUSw+/pMLWqfznzcLX7tLnPM
	 egQXseH/9j5YQQn4LJ/qnk/Xh7TsVhvjzOncAq6ClxPKRTkEU0GeC5+wbUxwV8Dm2+
	 Si12/CGsxgpAw7EchzQQ3+qP1O8t5nLyTl/+GKC1tloz7r8T6YgMsqtkPkppBvcAGb
	 JUOQJ2usppDnQ==
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
Subject: [PATCH v5 04/25] fsverity: introduce fsverity_folio_zero_hash()
Date: Thu, 19 Mar 2026 18:01:51 +0100
Message-ID: <20260319170231.1455553-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Helper to pre-fill folio with hashes of empty blocks. This will be used
by iomap to synthesize blocks full of zero hashes on the fly.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/verity/pagecache.c    | 22 ++++++++++++++++++++++
 include/linux/fsverity.h |  8 ++++++++
 2 files changed, 30 insertions(+)

diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
index 1819314ecaa3..1d94bf73f38c 100644
--- a/fs/verity/pagecache.c
+++ b/fs/verity/pagecache.c
@@ -2,6 +2,7 @@
 /*
  * Copyright 2019 Google LLC
  */
+#include "fsverity_private.h"
 
 #include <linux/export.h>
 #include <linux/fsverity.h>
@@ -56,3 +57,24 @@ void generic_readahead_merkle_tree(struct inode *inode, pgoff_t index,
 		folio_put(folio);
 }
 EXPORT_SYMBOL_GPL(generic_readahead_merkle_tree);
+
+/**
+ * fsverity_folio_zero_hash() - fill folio with hashes of zero data block
+ * @folio:	folio to fill
+ * @poff:	offset in the folio to start
+ * @plen:	length of the range to fill with hashes
+ * @vi:		fsverity info
+ */
+void fsverity_folio_zero_hash(struct folio *folio, size_t poff, size_t plen,
+			      struct fsverity_info *vi)
+{
+	size_t offset = poff;
+
+	WARN_ON_ONCE(!IS_ALIGNED(poff, vi->tree_params.digest_size));
+	WARN_ON_ONCE(!IS_ALIGNED(plen, vi->tree_params.digest_size));
+
+	for (; offset < (poff + plen); offset += vi->tree_params.digest_size)
+		memcpy_to_folio(folio, offset, vi->tree_params.zero_digest,
+				vi->tree_params.digest_size);
+}
+EXPORT_SYMBOL_GPL(fsverity_folio_zero_hash);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 8ba7806b225e..35bb76093de5 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -202,6 +202,8 @@ bool fsverity_verify_blocks(struct fsverity_info *vi, struct folio *folio,
 			    size_t len, size_t offset);
 void fsverity_verify_bio(struct fsverity_info *vi, struct bio *bio);
 void fsverity_enqueue_verify_work(struct work_struct *work);
+void fsverity_folio_zero_hash(struct folio *folio, size_t poff, size_t plen,
+			      struct fsverity_info *vi);
 
 #else /* !CONFIG_FS_VERITY */
 
@@ -288,6 +290,12 @@ static inline int fsverity_ensure_verity_info(struct inode *inode)
 	return -EOPNOTSUPP;
 }
 
+static inline void fsverity_folio_zero_hash(struct folio *folio, size_t poff,
+		size_t plen, struct fsverity_info *vi)
+{
+	WARN_ON_ONCE(1);
+}
+
 #endif	/* !CONFIG_FS_VERITY */
 
 static inline bool fsverity_verify_folio(struct fsverity_info *vi,
-- 
2.51.2

