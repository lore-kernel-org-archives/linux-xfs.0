Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7711CEAD6
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881071; cv=none; b=sIVNKCEpwb66oMILd+lfSKtqo/1KsttqF6rOZ5Wh45xjO80YGlg9oKCCrSk1H/xotaXoCvkmvzs07132Nhy7yCPnkyIuBCp81URTnoYX7nqyaL8uz3IW+ABuASqjwv5PSzJ1WI1IZmwAToA1zgUUF3S0dk4cTV5EfzdvJZ9b5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881071; c=relaxed/simple;
	bh=g/fdodwYfi9LHgPzpiOp1cwbkpzdtJvF9OMMGdCS9Tg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=au5mIhRQoIZ1MlEUvAAMXfVANrdNVRHZSb6HzMPN7/5yedSMjp5Dk7sd0WDB2POOHMZsXa+V0ngVDnGoHPlT2JG8LqnTPI3afLPu3AoqN76MThawyFdsd8+yo3suny3Il+7nqabPGg+QL0DcdlmMYY/Se+A9fh/7nOAG+IYJnFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7/5aTRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7/5aTRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0009C4CEDD;
	Thu,  6 Feb 2025 22:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881070;
	bh=g/fdodwYfi9LHgPzpiOp1cwbkpzdtJvF9OMMGdCS9Tg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o7/5aTRFbmeroAXUDnwp/eu9NI2HZVD1g+DomWMTd6BR7DtAgKO1AjkOnZMkyT++v
	 fn7/9l2kmE24STD++FwdRAy8tiUL9DzChCF6d2wtLaupf/7KN7dL0m+rnz0V0CWF5c
	 I5lbrhXZXcd2NudAcAy5QqnnQnlCB1SniJrN77mrEziycjwDAkKQQLP0h1HiipOnhU
	 oX2l5KF6VxvzJGy3RAwtpDCIQF/eQc2+yzL97U83/yzpzsLIhKEypy+o/Y4ejyt588
	 3c5mRS1JBg077U3VfHev8SsCRpEhpqmkVd1l499MMMzFHBH2c4lMj4hgiCysTkw2zp
	 cCJoa9Rz+v8Hw==
Date: Thu, 06 Feb 2025 14:31:10 -0800
Subject: [PATCH 02/17] libxfs: mark xmbuf_{un,}map_page static
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086090.2738568.18394123905353895033.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Not used outside of buf_mem.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/buf_mem.c |   97 +++++++++++++++++++++++++++---------------------------
 libxfs/buf_mem.h |    3 --
 2 files changed, 49 insertions(+), 51 deletions(-)


diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index 16cb038ba10e2a..77396fa95b4138 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -85,6 +85,55 @@ xmbuf_libinit(void)
 		xmbuf_max_mappings = 1024;
 }
 
+/* Directly map a memfd page into the buffer cache. */
+static int
+xmbuf_map_page(
+	struct xfs_buf		*bp)
+{
+	struct xfile		*xfile = bp->b_target->bt_xfile;
+	void			*p;
+	loff_t			pos;
+
+	pos = xfile->partition_pos + BBTOB(xfs_buf_daddr(bp));
+	p = mmap(NULL, BBTOB(bp->b_length), PROT_READ | PROT_WRITE, MAP_SHARED,
+			xfile->fcb->fd, pos);
+	if (p == MAP_FAILED) {
+		if (errno == ENOMEM && !xmbuf_unmap_early) {
+#ifdef DEBUG
+			fprintf(stderr, "xmbuf could not make mappings!\n");
+#endif
+			xmbuf_unmap_early = true;
+		}
+		return errno;
+	}
+
+	if (!xmbuf_unmap_early &&
+	    atomic_inc_return(&xmbuf_mappings) > xmbuf_max_mappings) {
+#ifdef DEBUG
+		fprintf(stderr, _("xmbuf hit too many mappings (%ld)!\n",
+					xmbuf_max_mappings);
+#endif
+		xmbuf_unmap_early = true;
+	}
+
+	bp->b_addr = p;
+	bp->b_flags |= LIBXFS_B_UPTODATE | LIBXFS_B_UNCHECKED;
+	bp->b_error = 0;
+	return 0;
+}
+
+/* Unmap a memfd page that was mapped into the buffer cache. */
+static void
+xmbuf_unmap_page(
+	struct xfs_buf		*bp)
+{
+	if (!xmbuf_unmap_early)
+		atomic_dec(&xmbuf_mappings);
+	munmap(bp->b_addr, BBTOB(bp->b_length));
+	bp->b_addr = NULL;
+}
+
+
 /* Allocate a new cache node (aka a xfs_buf) */
 static struct cache_node *
 xmbuf_cache_alloc(
@@ -280,54 +329,6 @@ xmbuf_free(
 	kfree(btp);
 }
 
-/* Directly map a memfd page into the buffer cache. */
-int
-xmbuf_map_page(
-	struct xfs_buf		*bp)
-{
-	struct xfile		*xfile = bp->b_target->bt_xfile;
-	void			*p;
-	loff_t			pos;
-
-	pos = xfile->partition_pos + BBTOB(xfs_buf_daddr(bp));
-	p = mmap(NULL, BBTOB(bp->b_length), PROT_READ | PROT_WRITE, MAP_SHARED,
-			xfile->fcb->fd, pos);
-	if (p == MAP_FAILED) {
-		if (errno == ENOMEM && !xmbuf_unmap_early) {
-#ifdef DEBUG
-			fprintf(stderr, "xmbuf could not make mappings!\n");
-#endif
-			xmbuf_unmap_early = true;
-		}
-		return errno;
-	}
-
-	if (!xmbuf_unmap_early &&
-	    atomic_inc_return(&xmbuf_mappings) > xmbuf_max_mappings) {
-#ifdef DEBUG
-		fprintf(stderr, _("xmbuf hit too many mappings (%ld)!\n",
-					xmbuf_max_mappings);
-#endif
-		xmbuf_unmap_early = true;
-	}
-
-	bp->b_addr = p;
-	bp->b_flags |= LIBXFS_B_UPTODATE | LIBXFS_B_UNCHECKED;
-	bp->b_error = 0;
-	return 0;
-}
-
-/* Unmap a memfd page that was mapped into the buffer cache. */
-void
-xmbuf_unmap_page(
-	struct xfs_buf		*bp)
-{
-	if (!xmbuf_unmap_early)
-		atomic_dec(&xmbuf_mappings);
-	munmap(bp->b_addr, BBTOB(bp->b_length));
-	bp->b_addr = NULL;
-}
-
 /* Is this a valid daddr within the buftarg? */
 bool
 xmbuf_verify_daddr(
diff --git a/libxfs/buf_mem.h b/libxfs/buf_mem.h
index f19bc6fd700b9a..6e4b2d3503b853 100644
--- a/libxfs/buf_mem.h
+++ b/libxfs/buf_mem.h
@@ -20,9 +20,6 @@ int xmbuf_alloc(struct xfs_mount *mp, const char *descr,
 		unsigned long long maxpos, struct xfs_buftarg **btpp);
 void xmbuf_free(struct xfs_buftarg *btp);
 
-int xmbuf_map_page(struct xfs_buf *bp);
-void xmbuf_unmap_page(struct xfs_buf *bp);
-
 bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
 void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
 int xmbuf_finalize(struct xfs_buf *bp);

