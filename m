Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782846;
	b=37NKzXR59DM7RmsSJt4TQA6sEidWWbRehZdZzlPEN8RcHKb5l40jGzSaiNAC6cFDqAig
	 1bCWfUoSRHaUiZDcfgTuK9u1glX4hnI7DBAf2fR2FTMsbLZoqwpsQaWXGmCWJQ4BD8hEq
	 SVjEfN/q/wrO2P2tOYPnt2SUM5QxP5uS29S+YSv5dqi1+MVP2yzEy60Zr8AD2jos0d8ID
	 zFnrw482w/llXdemn1eJi8+G4T+5U6v0oyHSCW7ZzfIEbh43b7KuFrCNcNJgYnaMbUQQ2
	 nHNrd77u5T/pksf3QppqoauXfceKDvLr8ELjii9mRnJ5YzNgNqACPGnGld5YY2DaarA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782846;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=kpdVZahl6P9jTDZhMcfh1LJ2h/oCYtHlsr4iA4dWRRA=;
	b=n9gUlNQyDrImucU8NF5k77P1crWu7m1yqMcXIy4YvGIKQ5zVQw0JWpj7fDfk1mQnLCQt
	 hbu7iDrTRZIvx0zxbAuwhzujC/uwZAZTv6uRihH9tI6OsoWhgMvzxJyiChj6UcMuQnTIP
	 ArRN6iTIfCNUjf3tW/Lg4RTpLujO64Z4xMYwgiCa6dQdcu4t12GLyD3iZ3GgbnAeyYiVW
	 2EE5H9sLCjWC356KRX7fj/hh9iTuKu12dLZnuIJ2aYutpQh7YhzLnhP9rOixfem/FOjtl
	 hLNSKj1Z8n6QKZee9Ja6Ly6LrhlsO+W6Fma1lE1zaR6bf1skhK1gIcanoQVO8b7v94Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=KoTiMiEM;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B182606A33C;
	Wed,  4 Nov 2026 09:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B182606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=KoTiMiEM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kpdVZahl6P9jTDZhMcfh1LJ2h/oCYtHlsr4iA4dWRRA=; b=KoTiMiEMdGV6jPzjR8STnNl93Q
	dSUtCrc5s7BSNud3SJW/24mWKgQ+ZBXIREpbpygJl0wMRN+j7pnqwhMdsVQUOmAu6bQ0jGQhSFXZ3
	KevNmba5bNIHQo3Man+KsBHecO0G4RHMv+lBPjYMlT56sXAWuPV8ftjef3EForWeGL0Ylbs63goNl
	MBxjlAg5rP501OrEnsSB6vIxsf9ReqvJ5DBGU+M8apQLpJhUs1j8OWTZGzuhcLw+DGpKEqmAwSAI+
	pcU+99S4ZmhGxcMZW8sP8QOJcbmWznJTXiLbnmUrJ3QtyVk2YnNAojKWAOPsomh02tOxCvFNTxlWT
	u9FLpnkg==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWrM-00000004obC-3i7p;
	Wed, 04 Nov 2026 09:00:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 25/25] xfs: add a RT checksum log item
Date: Wed,  4 Nov 2026 09:57:29 +0100
Message-ID: <20261104085929.317544-26-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use a one-shot log item to log RT checksum log items instead of the
buffer log item, and just update the buffer as an ordered buffer.

This reduces the amount of reallocs of the shadow buffers compared
to the buffer item, with the downside of needing more code and creating
more overhead for lots of small non-data integrity writes.

Still needs full benchmarking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_log_format.h  |  12 +-
 fs/xfs/libxfs/xfs_log_recover.h |   1 +
 fs/xfs/libxfs/xfs_ondisk.h      |   1 +
 fs/xfs/libxfs/xfs_trans_resv.c  |   9 +-
 fs/xfs/xfs_log.h                |   3 +-
 fs/xfs/xfs_log_recover.c        |   3 +
 fs/xfs/xfs_rtcsum.c             |   4 +-
 fs/xfs/xfs_rtcsum.h             |   7 +
 fs/xfs/xfs_rtcsum_item.c        | 218 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c              |   7 +
 11 files changed, 259 insertions(+), 7 deletions(-)
 create mode 100644 fs/xfs/xfs_rtcsum_item.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0d57bf0701ec..1891fc3edf39 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -143,6 +143,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
 				   xfs_rtcsum.o \
+				   xfs_rtcsum_item.o \
 				   xfs_zone_alloc.o \
 				   xfs_zone_gc.o \
 				   xfs_zone_info.o \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index c6f0edb4bf0a..ae6476a01b11 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -249,6 +249,7 @@ struct xfs_trans_header {
 #define	XFS_LI_RUD_RT		0x124d	/* realtime rmap update done */
 #define	XFS_LI_CUI_RT		0x124e	/* realtime refcount update intent */
 #define	XFS_LI_CUD_RT		0x124f	/* realtime refcount update done */
+#define	XFS_LI_RTCSUM		0x1250	/* realtime checksum update */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -274,7 +275,8 @@ struct xfs_trans_header {
 	{ XFS_LI_RUI_RT,	"XFS_LI_RUI_RT" }, \
 	{ XFS_LI_RUD_RT,	"XFS_LI_RUD_RT" }, \
 	{ XFS_LI_CUI_RT,	"XFS_LI_CUI_RT" }, \
-	{ XFS_LI_CUD_RT,	"XFS_LI_CUD_RT" }
+	{ XFS_LI_CUD_RT,	"XFS_LI_CUD_RT" }, \
+	{ XFS_LI_RTCSUM,	"XFS_LI_RTCSUM" }
 
 /*
  * Inode Log Item Format definitions.
@@ -1082,4 +1084,12 @@ struct xfs_attrd_log_format {
 	uint64_t	alfd_alf_id;	/* id of corresponding attri */
 };
 
+#define XFS_RTCSUM_NR_VECS 1
+struct xfs_rtcsum_log_format {
+	uint16_t	rlf_type;	/* type of log format structure */
+	uint16_t	rlf_size;	/* size of log format structure */
+	uint32_t	rlf_buf_offset;	/* offset into the rtcsum buf */
+	uint64_t	rlf_buf_daddr;	/* daddr of the rtcsum buf */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 9e712e62369c..67ec495f2ff3 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -83,6 +83,7 @@ extern const struct xlog_recover_item_ops xlog_rtrui_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtrud_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtcui_item_ops;
 extern const struct xlog_recover_item_ops xlog_rtcud_item_ops;
+extern const struct xlog_recover_item_ops xlog_rtcsum_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 17ab9366b3b9..cbfdd865a00b 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -163,6 +163,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rui_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtcsum_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		512);
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 25f7581ea90c..f9c811db0761 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1248,10 +1248,13 @@ xfs_calc_csum_reservation(
 	unsigned int		csum_len)
 {
 	unsigned int		payload_size = xfs_rtcsum_payload_size(mp);
+	unsigned int		nbufs =
+		howmany(csum_len + payload_size, payload_size);
 
-	return xfs_calc_buf_res(
-			howmany(csum_len + payload_size, payload_size),
-			mp->m_rtcsum_bsize);
+	return nbufs * (sizeof(struct xlog_op_header) +
+			sizeof(struct xfs_rtcsum_log_format) +
+			sizeof(struct xlog_op_header) +
+			payload_size);
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index f715695e8fcb..ff6df9d51046 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -44,7 +44,8 @@ struct xfs_cil_ctx;
 #define XLOG_REG_TYPE_XMD_FORMAT	32
 #define XLOG_REG_TYPE_ATTR_NEWNAME	33
 #define XLOG_REG_TYPE_ATTR_NEWVALUE	34
-#define XLOG_REG_TYPE_MAX		34
+#define XLOG_REG_TYPE_RTCSUM_FORMAT	35
+#define XLOG_REG_TYPE_MAX		36
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 457617979668..d812ee5e6752 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1825,6 +1825,9 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_rtrud_item_ops,
 	&xlog_rtcui_item_ops,
 	&xlog_rtcud_item_ops,
+#ifdef CONFIG_XFS_RT
+	&xlog_rtcsum_item_ops,
+#endif
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_rtcsum.c b/fs/xfs/xfs_rtcsum.c
index 93e9792207c6..c6daa32c71c7 100644
--- a/fs/xfs/xfs_rtcsum.c
+++ b/fs/xfs/xfs_rtcsum.c
@@ -237,8 +237,8 @@ xfs_rtcsum_log_one(
 		xfs_rtcsum_len_to_extlen(mp, mp->m_rtcsum_bsize - boff));
 	len = xfs_extlen_to_rtcsum_len(mp, *nr);
 	memcpy(bp->b_addr + boff, csum, len);
-
-	xfs_trans_log_buf(tp, bp, boff, boff + len - 1);
+	xfs_trans_ordered_buf(tp, bp);
+	xfs_rtcsum_item_log(tp, xfs_buf_daddr(bp), boff, *nr, csum);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rtcsum.h b/fs/xfs/xfs_rtcsum.h
index bd16f5a99451..6cab812c9d9b 100644
--- a/fs/xfs/xfs_rtcsum.h
+++ b/fs/xfs/xfs_rtcsum.h
@@ -15,9 +15,16 @@ int xfs_rtcsum_read_async(struct xfs_mount *mp, xfs_rtblock_t fsbno,
 int xfs_rtcsum_log(struct xfs_open_zone *oz, xfs_daddr_t daddr,
 		unsigned int data_len, const void *csum);
 
+void xfs_rtcsum_item_log(struct xfs_trans *tp, xfs_daddr_t buf_daddr,
+		unsigned int buf_offset, xfs_extlen_t count,
+		const void *csum_buf);
+
 int xfs_rtcsum_open_zone(struct xfs_open_zone *oz);
 void xfs_rtcsum_free_zone(struct xfs_open_zone *oz);
 
 int xfs_rtcsum_mount(struct xfs_mount *mp);
 
+int __init xfs_rtcsum_init(void);
+void xfs_rtcsum_exit(void);
+
 #endif /* _XFS_RTCSUM_H */
diff --git a/fs/xfs/xfs_rtcsum_item.c b/fs/xfs/xfs_rtcsum_item.c
new file mode 100644
index 000000000000..feee39846d32
--- /dev/null
+++ b/fs/xfs/xfs_rtcsum_item.c
@@ -0,0 +1,218 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Christoph Hellwig.
+ */
+#include "xfs_platform.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_rtcsum.h"
+
+struct xfs_rtcsum_item {
+	struct xfs_log_item		ri_item;
+	struct xfs_rtcsum_log_format	ri_format;
+
+	/*
+	 * ri_csum_buf is used to pass the callers csum buffer to
+	 * xfs_rtcsum_item_format, and is not valid after transaction
+	 * commit.
+	 */
+	const void			*ri_csum_buf;
+	xfs_extlen_t			ri_count;
+};
+
+static struct kmem_cache *xfs_rtcsum_item_cache;
+
+static inline struct xfs_rtcsum_item *RTCSUM_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_rtcsum_item, ri_item);
+}
+
+static inline unsigned int
+xfs_rtcsum_item_buf_size(
+	struct xfs_rtcsum_item	*rip)
+{
+	return xfs_extlen_to_rtcsum_len(rip->ri_item.li_log->l_mp,
+			rip->ri_count);
+}
+
+static void
+xfs_rtcsum_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	*nvecs += XFS_RTCSUM_NR_VECS;
+	*nbytes += sizeof(struct xfs_rtcsum_log_format);
+	*nbytes += xfs_rtcsum_item_buf_size(RTCSUM_ITEM(lip));
+}
+
+/*
+ * Format both the log format and the array of checksums into the same
+ * region to reduce the overhead for small writes.
+ */
+static void
+xfs_rtcsum_item_format(
+	struct xfs_log_item	*lip,
+	struct xlog_format_buf	*lfb)
+{
+	struct xfs_rtcsum_item	*rip = RTCSUM_ITEM(lip);
+	void			*dst, *p;
+
+	dst = p = xlog_format_start(lfb, XLOG_REG_TYPE_RTCSUM_FORMAT);
+	memcpy(p, &rip->ri_format, sizeof(rip->ri_format));
+	p += sizeof(rip->ri_format);
+	memcpy(p, rip->ri_csum_buf, xfs_rtcsum_item_buf_size(rip));
+	p += xfs_rtcsum_item_buf_size(rip);
+	xlog_format_commit(lfb, p - dst);
+}
+
+static void
+xfs_rtcsum_item_release(
+	struct xfs_log_item	*lip)
+{
+	kvfree(RTCSUM_ITEM(lip)->ri_item.li_lv_shadow);
+	kmem_cache_free(xfs_rtcsum_item_cache, RTCSUM_ITEM(lip));
+}
+
+static const struct xfs_item_ops xfs_rtcsum_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.iop_size	= xfs_rtcsum_item_size,
+	.iop_format	= xfs_rtcsum_item_format,
+	.iop_release	= xfs_rtcsum_item_release,
+};
+
+void
+xfs_rtcsum_item_log(
+	struct xfs_trans	*tp,
+	xfs_daddr_t		buf_daddr,
+	unsigned int		buf_offset,
+	xfs_extlen_t		count,
+	const void		*csum_buf)
+{
+	struct xfs_rtcsum_item	*rip;
+
+	rip = kmem_cache_zalloc(xfs_rtcsum_item_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
+	xfs_log_item_init(tp->t_mountp, &rip->ri_item, XFS_LI_RTCSUM,
+			  &xfs_rtcsum_item_ops);
+	rip->ri_count = count;
+	rip->ri_csum_buf = csum_buf;
+	rip->ri_format.rlf_type = XFS_LI_RTCSUM;
+	rip->ri_format.rlf_size = XFS_RTCSUM_NR_VECS;
+	rip->ri_format.rlf_buf_daddr = buf_daddr;
+	rip->ri_format.rlf_buf_offset = buf_offset;
+
+	xfs_trans_add_item(tp, &rip->ri_item);
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &rip->ri_item.li_flags);
+}
+
+/*
+ * Checksum buffers must be recovered before inode items can reference the data
+ * covered by the checksums.
+ */
+static enum xlog_recover_reorder
+xlog_recover_rtcsum_reorder(
+	struct xlog_recover_item	*item)
+{
+	return XLOG_REORDER_BUFFER_LIST;
+}
+
+static void
+xlog_recover_rtcsum_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_rtcsum_log_format	*rlf = item->ri_buf[0].iov_base;
+
+	xlog_buf_readahead(log, rlf->rlf_buf_daddr,
+			BTOBB(log->l_mp->m_rtcsum_bsize), NULL);
+}
+
+static int
+xlog_recover_rtcsum_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_rtcsum_log_format	*rlf = item->ri_buf[0].iov_base;
+	void				*csum = rlf + 1;
+	unsigned int			buf_len;
+	struct xfs_buf			*bp;
+	int				error;
+
+	if (rlf->rlf_type != XFS_LI_RTCSUM) {
+		xfs_warn(mp, "%s: bad type", __func__);
+		return -EINVAL;
+	}
+	if (rlf->rlf_size != XFS_RTCSUM_NR_VECS) {
+		xfs_warn(mp, "%s: bad number of iovecs: %u",
+			__func__, rlf->rlf_size);
+		return -EINVAL;
+	}
+
+	if (item->ri_buf[0].iov_len < sizeof(*rlf)) {
+		xfs_warn(mp, "%s: bad len: %zu",
+			__func__, item->ri_buf[0].iov_len);
+		return -EINVAL;
+	}
+
+	buf_len = item->ri_buf[0].iov_len - sizeof(*rlf);
+	if (buf_len == 0 ||
+	    buf_len % (1u << mp->m_rtcsum_shift) ||
+	    buf_len > mp->m_rtcsum_bsize) {
+		xfs_warn(mp, "%s: bad rtcsum buf size: %u",
+			__func__, buf_len);
+		return -EINVAL;
+	}
+
+	if (rlf->rlf_buf_offset > mp->m_rtcsum_bsize ||
+	    rlf->rlf_buf_offset > mp->m_rtcsum_bsize - buf_len) {
+		xfs_warn(mp, "%s: bad rtcsum buf offset: %u",
+			__func__, buf_len);
+		return -EINVAL;
+	}
+
+	error = xfs_buf_read(mp->m_ddev_targp, rlf->rlf_buf_daddr,
+			BTOBB(mp->m_rtcsum_bsize), 0, &bp, &xfs_rtcsum_buf_ops);
+	if (error)
+		return error;
+	memcpy(bp->b_addr + rlf->rlf_buf_offset, csum, buf_len);
+	xfs_buf_set_uptodate(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
+	xfs_buf_relse(bp);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_rtcsum_item_ops = {
+	.item_type		= XFS_LI_RTCSUM,
+	.reorder		= xlog_recover_rtcsum_reorder,
+	.ra_pass2		= xlog_recover_rtcsum_ra_pass2,
+	.commit_pass2		= xlog_recover_rtcsum_commit_pass2,
+};
+
+int __init xfs_rtcsum_init(void)
+{
+	xfs_rtcsum_item_cache = kmem_cache_create("xfs_rtcsum_item",
+			sizeof(struct xfs_rtcsum_item), 0, 0, NULL);
+	if (!xfs_rtcsum_item_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void xfs_rtcsum_exit(void)
+{
+	kmem_cache_destroy(xfs_rtcsum_item_cache);
+}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fc99167938e5..960f1e9693f6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2530,8 +2530,13 @@ xfs_init_caches(void)
 	if (!xfs_parent_args_cache)
 		goto out_destroy_xmi_cache;
 
+	if (IS_ENABLED(CONFIG_XFS_RT) && xfs_rtcsum_init() < 0)
+		goto out_destroy_parent_args_cache;
+
 	return 0;
 
+ out_destroy_parent_args_cache:
+	kmem_cache_destroy(xfs_parent_args_cache);
  out_destroy_xmi_cache:
 	kmem_cache_destroy(xfs_xmi_cache);
  out_destroy_xmd_cache:
@@ -2594,6 +2599,8 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	if (IS_ENABLED(CONFIG_XFS_RT))
+		xfs_rtcsum_exit();
 	kmem_cache_destroy(xfs_parent_args_cache);
 	kmem_cache_destroy(xfs_xmd_cache);
 	kmem_cache_destroy(xfs_xmi_cache);
-- 
2.53.0

