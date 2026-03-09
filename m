Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3579F3ED5AB;
	Mon,  9 Mar 2026 19:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084281; cv=none; b=sgO7CviWGAcsHJSVaGjKdLPYvHo49TkxvIWLz4aDte4yBinKHYhWVQ51llIyLDhqXGFoO51W0kVjdRNdHIqg5wcawlxCeNmCT7y+PpEsddQNxCf5CQLqJaHxyUEJKEdy2E2oSSHWYPuhZFMtxi6/4ZNbVxtBbh5scbp0dqb7UJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084281; c=relaxed/simple;
	bh=ogWSMF2PJnhgHUDXKpdHXZ+YvdNJgyOyWZkXlSnS970=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJIhuVae/yJxOlaCMUughN897cMQwB3icoP/LzM1objLsEt/jaW+zO+w0zwkkfrcOJU3JJGvUWWe1uSrl9zO02udz3oZ7bquf8vbaY57llhUSO/0RkIulZQASIFa7WyEqKlKvLrRtWHj5h/Q7UM+1lp0rAmMYifycsRFZSLvgIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ro/9xW5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ro/9xW5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB56BC2BC9E;
	Mon,  9 Mar 2026 19:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084280;
	bh=ogWSMF2PJnhgHUDXKpdHXZ+YvdNJgyOyWZkXlSnS970=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ro/9xW5UENPYp71Y2lpc/kQ08y7PL8D4G1tzfy21/0ccpYWmaZnYVPBqMq7KfHLBJ
	 pRSr9EuVfurF3pvGeJ8mGC9MyLRqkQQ6ROEjmV8TOMR0a29J2/89ee5+zp20xqsWA5
	 0WAgNArwdLEAIW0tvN3FyOQK0kqZ7oibuYCpLQFIF7Vy+EOQk7CRn0Rqx6NbDpi72m
	 R6NpMFqAdfYR+czawOhxqk9HcN4l7b1jm1dIvR1isbZ56bhU9PiWBv+otdUa5osfSK
	 MdIhHMwDLMVH3zp4O9XeaSTUqlZ38ymMD5VjK1e27x4xuj3VsM+qXul7EzlworoWQi
	 /XxGxz67wqRfw==
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
Subject: [PATCH v4 08/25] iomap: obtain fsverity info for read path
Date: Mon,  9 Mar 2026 20:23:23 +0100
Message-ID: <20260309192355.176980-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
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
---
 fs/iomap/buffered-io.c | 7 +++++++
 include/linux/iomap.h  | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 530794dcdd91..a335a18c307f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -9,6 +9,7 @@
 #include <linux/swap.h>
 #include <linux/migrate.h>
 #include <linux/fserror.h>
+#include <linux/fsverity.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -590,6 +591,9 @@ void iomap_read_folio(const struct iomap_ops *ops,
 
 	trace_iomap_readpage(iter.inode, 1);
 
+	if (iter.pos < i_size_read(iter.inode))
+		ctx->vi = fsverity_get_info(iter.inode);
+
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
@@ -656,6 +660,9 @@ void iomap_readahead(const struct iomap_ops *ops,
 
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

