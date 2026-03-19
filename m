Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872AF202F71;
	Thu, 19 Mar 2026 17:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939781; cv=none; b=GZXqlXWFqQ1sCLPbxrvvqB2XL+E6aM79p3kmoznqppkwyPEdOiFfmqi7o3KIMSW9VADrhJZ/hvdt+C+vDTeuINAnyIkhC3CKAWr/LxwjANQH0lsU4FkaUrWFpmnqG2tGb30HlZ5amSXFJL36QxLK1AN/ii/UJEwuqUQIM5YD/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939781; c=relaxed/simple;
	bh=gP1sMkE4alGb06aslVUo05UwZR7+5Myev4BiXgKcL9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYcJLwHL5v3SjuifSL03rCcjYnHNS34xa/k0WGiErTiAExH/uKFA19OSAvBdnYhYCmKLUfA7LeFlhx5PB+IZbdmmZSR0gUtwaHjIqUl5tqpmI5T6+QE75XPAZIlxhwkO9ll2YpwiUxkHLF3813ee7hyBQUX1jGuECpAAB3Qj7A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0FThI4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0FThI4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E661CC2BCB0;
	Thu, 19 Mar 2026 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939781;
	bh=gP1sMkE4alGb06aslVUo05UwZR7+5Myev4BiXgKcL9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0FThI4tkK61/VPUW5H8oKb117kHgEAolLW4D2LdSathShqft1Trv1ibO4jv5Wdrk
	 4Dr88SJsLA7yx6nTA+YSzgK4Ub602uac7809wrsMfpzYpBmXVhNJ8douzlGeFmgR6w
	 giY90uDM9KxuNmLIcj2bE95QJ7McHn7UGU5wHA8iXY33AumPrxKa+pvSOA0Srjf458
	 q3x8OWFSsCSY/wsnriiEWlTJZ3AOwsm7b8EFhS3b9bt2RmydkdkpKCg9TyD1S8wxB3
	 eBhtNtR+XQZGmoxBYsh6ARH94s4RPnBd2klVrjWGxwVZoK1KqpKSmvASx9/33/ZlN8
	 7QwAyKPDoft5g==
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
Subject: [PATCH v5 08/25] iomap: obtain fsverity info for read path
Date: Thu, 19 Mar 2026 18:01:55 +0100
Message-ID: <20260319170231.1455553-9-aalbersh@kernel.org>
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

Obtain fsverity info for folios with file data. Filesystem can pass vi
down to ioend and then to fsverity for verification. XFS will use it in
further patch for fsverity integration.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 7 +++++++
 include/linux/iomap.h  | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d17858ffaae..bcfbfbf5cf7c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -9,6 +9,7 @@
 #include <linux/swap.h>
 #include <linux/migrate.h>
 #include <linux/fserror.h>
+#include <linux/fsverity.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -599,6 +600,9 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	trace_iomap_readpage(iter.inode, 1);
 
+	if (iter.pos < i_size_read(iter.inode))
+		ctx->vi = fsverity_get_info(iter.inode);
+
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
@@ -666,6 +670,9 @@ void iomap_readahead(const struct iomap_ops *ops,
 
 	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
 
+	if (iter.pos < i_size_read(iter.inode))
+		ctx->vi = fsverity_get_info(iter.inode);
+
 	while (iomap_iter(&iter, ops) > 0)
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index dc39837b0d45..89e5a7abc012 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -432,6 +432,7 @@ struct iomap_ioend {
 	loff_t			io_offset;	/* offset in the file */
 	sector_t		io_sector;	/* start sector of ioend */
 	void			*io_private;	/* file system private data */
+	struct fsverity_info	*io_vi;		/* fsverity info */
 	struct bio		io_bio;		/* MUST BE LAST! */
 };
 
@@ -506,6 +507,7 @@ struct iomap_read_folio_ctx {
 	struct readahead_control *rac;
 	void			*read_ctx;
 	loff_t			read_ctx_file_offset;
+	struct fsverity_info	*vi;
 };
 
 struct iomap_read_ops {
-- 
2.51.2

