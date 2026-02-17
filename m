Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA2429D297;
	Tue, 17 Feb 2026 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370444; cv=none; b=kxTXSnB7PNudSLC6vATRsOeOA4UxyDUsEqNoeKWok6F2mb58A92FPSnyD/Y0mRahIS4m2xJLvAUY2q2QtCItGbFIVtYr2VIEaCu9CtIGi9plyrr30oYUJmAir7AIM7tJZBpPHdtslX+v7FNiWLgbp2yfq8BtAr7k+qc3y05tPEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370444; c=relaxed/simple;
	bh=jZK7lITWkRsRC3JRkfCPUm4SwwXn/X8PRXk8r36Yftg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOaZcKbhu0FRxEoIV/FosCrHZ6BZZp8djWQeQd1nLYFByWSq+m8igjqdKv0maK6V6YqbaHkY3bG7q15G7MABrVln+VzuSKRnulSPpr6DRZzkb6RWfmOsFPzpPw8tW+Ig/60npVU2kunGM5D7BnW9Sv1DLi8o0uafKm0oSi+LmJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0Oh80Oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0Oh80Oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF36C19421;
	Tue, 17 Feb 2026 23:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370444;
	bh=jZK7lITWkRsRC3JRkfCPUm4SwwXn/X8PRXk8r36Yftg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0Oh80Oe/M0WU9Shg5NEFaaPZiUy4BVfSnOlkgQ4SQ0cJci8dtawK0X45Ki69l7s/
	 CyGpZovAYETfMvO2ObEo44Ars7OpCi1x2rxkT5XmLsSqb3XK5DVrBsMGNlfIn449T5
	 b/NTkKT1wyrbA65CkSkgSoBSQvWDMVnVkdP95MykCmeOXAdxz3PHqmpkjYU5VsacUh
	 RbXJicixV2GD64Wr66dR9lgJgU+XwvGryUKxyrmAt9RbdPMutpHxkCshWlJiUIVbNK
	 uj54K+BXGJ+xVrR7WwJvLq6T1aw4uIX1OkXQ7Sv+NGGPMQ9t6xwpbvI7LG09znlPL0
	 hVcWHhOvd0y7A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 05/35] fsverity: introduce fsverity_folio_zero_hash()
Date: Wed, 18 Feb 2026 00:19:05 +0100
Message-ID: <20260217231937.1183679-6-aalbersh@kernel.org>
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

Helper to pre-fill folio with hashes of empty blocks. This will be used
by XFS to synthesize blocks full of zero hashes on the fly.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/pagecache.c    | 22 ++++++++++++++++++++++
 include/linux/fsverity.h |  9 +++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
index 73f03b48d42d..7642a7a09dfb 100644
--- a/fs/verity/pagecache.c
+++ b/fs/verity/pagecache.c
@@ -2,6 +2,7 @@
 /*
  * Copyright 2019 Google LLC
  */
+#include "fsverity_private.h"
 
 #include <linux/export.h>
 #include <linux/fsverity.h>
@@ -62,3 +63,24 @@ loff_t fsverity_metadata_offset(const struct inode *inode)
 	return roundup(i_size_read(inode), mapping_max_folio_size_supported());
 }
 EXPORT_SYMBOL_GPL(fsverity_metadata_offset);
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
index 278c6340849f..addee462dcc2 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -215,6 +215,8 @@ bool fsverity_verify_blocks(struct fsverity_info *vi, struct folio *folio,
 void fsverity_verify_bio(struct fsverity_info *vi, struct bio *bio);
 void fsverity_enqueue_verify_work(struct work_struct *work);
 loff_t fsverity_metadata_offset(const struct inode *inode);
+void fsverity_folio_zero_hash(struct folio *folio, size_t poff, size_t plen,
+			      struct fsverity_info *vi);
 
 #else /* !CONFIG_FS_VERITY */
 
@@ -302,6 +304,13 @@ static inline loff_t fsverity_metadata_offset(const struct inode *inode)
 	return ULLONG_MAX;
 }
 
+static inline void fsverity_folio_zero_hash(struct folio *folio, size_t poff,
+					    size_t plen,
+					    struct fsverity_info *vi)
+{
+	WARN_ON_ONCE(1);
+}
+
 #endif	/* !CONFIG_FS_VERITY */
 
 static inline bool fsverity_verify_folio(struct fsverity_info *vi,
-- 
2.51.2

