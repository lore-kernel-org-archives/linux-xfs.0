Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9535A7A2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802045; cv=none; b=NuuBqQl71vUrA3gEqiFUf+4LzBplCfI2WMHs/miy4tMlNYInvKOiQYEssMoJrtxW6efQCrllEAK/jK0zklCkBz/ntguDHgUisdUYG+pZRWng3M5/nmj5RxPsBRFC6UKx0zUteAwgVZaJwGOXwkY5xSnf4+6AGk7KXYhUBEBcT3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802045; c=relaxed/simple;
	bh=eClcKlGyuXmgmkOlQBqAWdCs0lpa8zHsQRIlGbLRFq8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS/0DFJHxq7HVqaGrUhps2t30Zr8ZDl+aZymYK6q+R+e9JKgIH5o7Yoj1lAa/fIbbCn2YhotqOPXoj/xkq9PFY7JQPolS4fwqz7AdhoNzCpCkP9Em+vm4HC02sHdAMLJiKCFVrMhS70DKhXlFj9GWxqnUYnWS8vlZcYCLanDgm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Qj79iU0d; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Qj79iU0d"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e6082eab17so4335257b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802043; x=1711406843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JnpP1GtmUIoAcPmBdqTeygAolN7tFjfhfWABcpsi9+k=;
        b=Qj79iU0d6nV5LNF9F5KAlLELFCTlGV1vuoQYqZt9RUnCbH6TfPXAG0Fz9utigowre3
         r3mOcTRk5p9onkoTmTu6n2itz3gc/KFv2RjweK9Zv7a+5oKPxqLsILoZ0iPFujtOfUic
         fb+LYQoflcBjVSizfuFEZ19II9dcWQGbB3ESQpWFGHSlBnwbvKz2NIbRc4oB5/S9NJLm
         GYdAA9yOrcANH+D2aPr84SIZMzL4Sq4+zRwk05vghIbt6Rc1GcRnB1oyH2OvGBc5arja
         sSzrxPJNC21DQ/gmlCaNBCxbH/n9BW4OBs6advcoJ45GOUf8Vmko6djKhDmoZiYKcG51
         HRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802043; x=1711406843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JnpP1GtmUIoAcPmBdqTeygAolN7tFjfhfWABcpsi9+k=;
        b=N15wZk5HhKdrZFbKgsM8uuZZZB8auHv3IpDjTQvtCucVpAYt26KsIuF4OEj7n7+RcF
         nLCdlug9ycvoLBhtaBBYrSTg9pcfPgw4d3o2jaocxXwre0ZRB5Wl6RiVKXHYviuqUruz
         25FgZ6FeNo4pxaPl+qpwZ6OHGPoALYunPo/dhmmEngfb7augSQXHHC3R5KgiAQu7qJoM
         4PD65ueoZmHSJ8AjzSILurAgOdJjnTr3f8qAjXd/gOwIRabDEqGwEzggAodrHqUTi/S7
         ZX/Fd/mfnwNoHzbc4XpGNjUZ2U4c7nVyW+CGV5WXx9XCLTmOTtNl79zmIn2cFjZ03DTd
         lnPA==
X-Gm-Message-State: AOJu0YwLAn0HKz6aQmIRhCytyy91XW4MJzu+CdVYJt9lkD1dXT88O2db
	mcWwMlUnm8hR6f71cwdbpgNvM3XOB7DVSP5sjhQgFm3b9UCrmXMNigZmERssIZqV7poIjRSYX8J
	k
X-Google-Smtp-Source: AGHT+IH+T/PqIzj0HKphdG6UdHDJLI4K8ZjMp4QUZZs9veIzSdxDoIYx1Q0QUnaZFSszWFeAvv4YwQ==
X-Received: by 2002:a05:6a20:8410:b0:1a1:2d3a:2d19 with SMTP id c16-20020a056a20841000b001a12d3a2d19mr11656853pzd.51.1710802042919;
        Mon, 18 Mar 2024 15:47:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id ca17-20020a056a02069100b005dc9439c56bsm6587667pgb.13.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlF-003o0P-38
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E82u-1zo1
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: kill XBF_UNMAPPED
Date: Tue, 19 Mar 2024 09:45:55 +1100
Message-ID: <20240318224715.3367463-5-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240318224715.3367463-1-david@fromorbit.com>
References: <20240318224715.3367463-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Unmapped buffer access is a pain, so kill it. The switch to large
folios means we rarely pay a vmap penalty for large buffers,
so this functionality is largely unnecessary now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c    |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |  2 +-
 fs/xfs/scrub/inode_repair.c   |  3 +-
 fs/xfs/xfs_buf.c              | 62 ++---------------------------------
 fs/xfs/xfs_buf.h              | 16 ++++++---
 fs/xfs/xfs_buf_item.c         |  2 +-
 fs/xfs/xfs_buf_item_recover.c |  8 +----
 fs/xfs/xfs_inode.c            |  3 +-
 8 files changed, 19 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e5ac3e5430c4..fa27a50f96ac 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -362,7 +362,7 @@ xfs_ialloc_inode_init(
 				(j * M_IGEO(mp)->blocks_per_cluster));
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 				mp->m_bsize * M_IGEO(mp)->blocks_per_cluster,
-				XBF_UNMAPPED, &fbuf);
+				0, &fbuf);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d0dcce462bf4..68989f4bf793 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -136,7 +136,7 @@ xfs_imap_to_bp(
 	int			error;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
+			imap->im_len, 0, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
 				XFS_SICK_AG_INODES);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index eab380e95ef4..7b31f1ad194f 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1309,8 +1309,7 @@ xrep_dinode_core(
 
 	/* Read the inode cluster buffer. */
 	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
-			ri->imap.im_blkno, ri->imap.im_len, XBF_UNMAPPED, &bp,
-			NULL);
+			ri->imap.im_blkno, ri->imap.im_len, 0, &bp, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7d9303497763..2cd3671f3ce3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -239,7 +239,7 @@ _xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -403,9 +403,7 @@ xfs_buf_alloc_folio(
  *
  * The second type of buffer is the multi-folio buffer. These are *always* made
  * up of single page folios so that they can be fed to vmap_ram() to return a
- * contiguous memory region we can access the data through, or mark it as
- * XBF_UNMAPPED and access the data directly through individual folio_address()
- * calls.
+ * contiguous memory region we can access the data through.
  *
  * We don't use high order folios for this second type of buffer (yet) because
  * having variable size folios makes offset-to-folio indexing and iteration of
@@ -486,8 +484,6 @@ _xfs_buf_map_folios(
 	if (bp->b_folio_count == 1) {
 		/* A single folio buffer is always mappable */
 		bp->b_addr = folio_address(bp->b_folios[0]);
-	} else if (flags & XBF_UNMAPPED) {
-		bp->b_addr = NULL;
 	} else {
 		int retried = 0;
 		unsigned nofs_flag;
@@ -1844,60 +1840,6 @@ __xfs_buf_submit(
 	return error;
 }
 
-void *
-xfs_buf_offset(
-	struct xfs_buf		*bp,
-	size_t			offset)
-{
-	struct folio		*folio;
-
-	if (bp->b_addr)
-		return bp->b_addr + offset;
-
-	/* Single folio buffers may use large folios. */
-	if (bp->b_folio_count == 1) {
-		folio = bp->b_folios[0];
-		return folio_address(folio) + offset_in_folio(folio, offset);
-	}
-
-	/* Multi-folio buffers always use PAGE_SIZE folios */
-	folio = bp->b_folios[offset >> PAGE_SHIFT];
-	return folio_address(folio) + (offset & (PAGE_SIZE-1));
-}
-
-void
-xfs_buf_zero(
-	struct xfs_buf		*bp,
-	size_t			boff,
-	size_t			bsize)
-{
-	size_t			bend;
-
-	bend = boff + bsize;
-	while (boff < bend) {
-		struct folio	*folio;
-		int		folio_index, folio_offset, csize;
-
-		/* Single folio buffers may use large folios. */
-		if (bp->b_folio_count == 1) {
-			folio = bp->b_folios[0];
-			folio_offset = offset_in_folio(folio,
-						bp->b_offset + boff);
-		} else {
-			folio_index = (boff + bp->b_offset) >> PAGE_SHIFT;
-			folio_offset = (boff + bp->b_offset) & ~PAGE_MASK;
-			folio = bp->b_folios[folio_index];
-		}
-
-		csize = min_t(size_t, folio_size(folio) - folio_offset,
-				      BBTOB(bp->b_length) - boff);
-		ASSERT((csize + folio_offset) <= folio_size(folio));
-
-		memset(folio_address(folio) + folio_offset, 0, csize);
-		boff += csize;
-	}
-}
-
 /*
  * Log a message about and stale a buffer that a caller has decided is corrupt.
  *
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f059ae3d2755..aef7015cf9f3 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -51,7 +51,6 @@ struct xfs_buf;
 #define XBF_LIVESCAN	 (1u << 28)
 #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
 #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
-#define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
 
 
 typedef unsigned int xfs_buf_flags_t;
@@ -74,8 +73,7 @@ typedef unsigned int xfs_buf_flags_t;
 	/* The following interface flags should never be set */ \
 	{ XBF_LIVESCAN,		"LIVESCAN" }, \
 	{ XBF_INCORE,		"INCORE" }, \
-	{ XBF_TRYLOCK,		"TRYLOCK" }, \
-	{ XBF_UNMAPPED,		"UNMAPPED" }
+	{ XBF_TRYLOCK,		"TRYLOCK" }
 
 /*
  * Internal state flags.
@@ -320,12 +318,20 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
 void xfs_buf_ioend_fail(struct xfs_buf *);
-void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* Buffer Utility Routines */
-extern void *xfs_buf_offset(struct xfs_buf *, size_t);
+static inline void *xfs_buf_offset(struct xfs_buf *bp, size_t offset)
+{
+	return bp->b_addr + offset;
+}
+
+static inline void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize)
+{
+	memset(bp->b_addr + boff, 0, bsize);
+}
+
 extern void xfs_buf_stale(struct xfs_buf *bp);
 
 /* Delayed Write Buffer Routines */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d1407cee48d9..7b66d3fe4ecd 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -69,7 +69,7 @@ xfs_buf_item_straddle(
 {
 	void			*first, *last;
 
-	if (bp->b_folio_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
+	if (bp->b_folio_count == 1)
 		return false;
 
 	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 09e893cf563c..d74bf7bb7794 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -891,7 +891,6 @@ xlog_recover_buf_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	int				error;
-	uint				buf_flags;
 	xfs_lsn_t			lsn;
 
 	/*
@@ -910,13 +909,8 @@ xlog_recover_buf_commit_pass2(
 	}
 
 	trace_xfs_log_recover_buf_recover(log, buf_f);
-
-	buf_flags = 0;
-	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
-		buf_flags |= XBF_UNMAPPED;
-
 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
-			  buf_flags, &bp, NULL);
+			  0, &bp, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ea48774f6b76..e7a724270423 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2405,8 +2405,7 @@ xfs_ifree_cluster(
 		 * to mark all the active inodes on the buffer stale.
 		 */
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
-				mp->m_bsize * igeo->blocks_per_cluster,
-				XBF_UNMAPPED, &bp);
+				mp->m_bsize * igeo->blocks_per_cluster, 0, &bp);
 		if (error)
 			return error;
 
-- 
2.43.0

