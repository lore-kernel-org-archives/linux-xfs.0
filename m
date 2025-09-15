Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E8728980A
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943218; cv=none; b=ZPojC2+1oOlSWXgtuNJ5K2sloSJrcTFMXZO/3zypq66gvZXSUyfKjBFTdvBvQUCp6Sghuyl5qjcIq/5tFTEJi+sjkYPk/aOinwEPfMMFNRLLPAG7Atp6EKhM/hE0anqKdv8+/pNeS/8SbNVR8eAeI6PnMwpJO7+AV0kEBam/DrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943218; c=relaxed/simple;
	bh=PjSEuy9+FTv7TNVc02pSmm/ADcmpyWRBOOeMzc6bMwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9K9ZPfTexZpRrFjJzznTjfHSNOxekRljFVpzWXLwANsCpUZ6JebIYoVdTm7TvuZ1g5YrQxJHdHAmLspTcRGQReK1bPnXBXkvNilQ6hOUdU3j/v4opJ33qa7kKM92xu+l36QX1UGM+SCwlvGsEnYasOfAuOevouF/3g0h1Et3Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lxvWH6fH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lxvWH6fH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=A5JE9OSJjaeOR0PJEDJXfPgP9Q3JeVv7f/U2kg2Y118=; b=lxvWH6fHvNL2te6PLYc4ZS8rko
	G/vHXsGZG5Lywu5hWpFdMAzGs55jxte3xuLvthiEIManRXsD6G9bAKBVsO3u7d2ejxIHhJnxxeugZ
	RNpBrI3NlARX0YeiHITW9AkfiSeWedp6TZVDHifrRm2Crj4acgx7dgYim6bB/Qt4cQwRoZUP7LI2M
	JLkHdBmVvO9HJcsrqZC99ZZleunk2KT73SDo6whlaF1cqJJVsGFyA/H9jUTNWTBfI4iUmSJep6xD4
	8UfGAifk1SBa1IqoQtFnB1PGIVfXnW3gXfydCeuXIUlrqcU+5qiRv3g1wp10zWTfj4mysQ9drtkcK
	/jjFIjVg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Kq-00000004L1g-3CZF;
	Mon, 15 Sep 2025 13:33:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs_io: use the XFS_ERRTAG macro to generate injection targets
Date: Mon, 15 Sep 2025 06:33:17 -0700
Message-ID: <20250915133336.161352-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915133336.161352-1-hch@lst.de>
References: <20250915133336.161352-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the new magic macro table provided by libxfs to autogenerate
the list of valid error injection targets.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io/inject.c | 108 +++++++++++++++++-----------------------------------
 1 file changed, 35 insertions(+), 73 deletions(-)

diff --git a/io/inject.c b/io/inject.c
index 7b9a76406cc5..99186c081230 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -12,89 +12,49 @@
 
 static cmdinfo_t inject_cmd;
 
+#define ARRAY_SIZE(x)		(sizeof(x) / sizeof((x)[0]))
+#define __stringify_1(x...)	#x
+#define __stringify(x...)	__stringify_1(x)
+
+#define XFS_ERRTAG(_tag, _name, _default) \
+        [XFS_ERRTAG_##_tag]	=  __stringify(_name),
+#include "xfs_errortag.h"
+static const char *tag_names[] = { XFS_ERRTAGS };
+#undef XFS_ERRTAG
+
+/* Search for a name */
 static int
-error_tag(char *name)
+error_tag(
+	char		*name)
 {
-	static struct {
-		int	tag;
-		char	*name;
-	} *e, eflags[] = {
-		{ XFS_ERRTAG_NOERROR,			"noerror" },
-		{ XFS_ERRTAG_IFLUSH_1,			"iflush1" },
-		{ XFS_ERRTAG_IFLUSH_2,			"iflush2" },
-		{ XFS_ERRTAG_IFLUSH_3,			"iflush3" },
-		{ XFS_ERRTAG_IFLUSH_4,			"iflush4" },
-		{ XFS_ERRTAG_IFLUSH_5,			"iflush5" },
-		{ XFS_ERRTAG_IFLUSH_6,			"iflush6" },
-		{ XFS_ERRTAG_DA_READ_BUF,		"dareadbuf" },
-		{ XFS_ERRTAG_BTREE_CHECK_LBLOCK,	"btree_chk_lblk" },
-		{ XFS_ERRTAG_BTREE_CHECK_SBLOCK,	"btree_chk_sblk" },
-		{ XFS_ERRTAG_ALLOC_READ_AGF,		"readagf" },
-		{ XFS_ERRTAG_IALLOC_READ_AGI,		"readagi" },
-		{ XFS_ERRTAG_ITOBP_INOTOBP,		"itobp" },
-		{ XFS_ERRTAG_IUNLINK,			"iunlink" },
-		{ XFS_ERRTAG_IUNLINK_REMOVE,		"iunlinkrm" },
-		{ XFS_ERRTAG_DIR_INO_VALIDATE,		"dirinovalid" },
-		{ XFS_ERRTAG_BULKSTAT_READ_CHUNK,	"bulkstat" },
-		{ XFS_ERRTAG_IODONE_IOERR,		"logiodone" },
-		{ XFS_ERRTAG_STRATREAD_IOERR,		"stratread" },
-		{ XFS_ERRTAG_STRATCMPL_IOERR,		"stratcmpl" },
-		{ XFS_ERRTAG_DIOWRITE_IOERR,		"diowrite" },
-		{ XFS_ERRTAG_BMAPIFORMAT,		"bmapifmt" },
-		{ XFS_ERRTAG_FREE_EXTENT,		"free_extent" },
-		{ XFS_ERRTAG_RMAP_FINISH_ONE,		"rmap_finish_one" },
-		{ XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE,	"refcount_continue_update" },
-		{ XFS_ERRTAG_REFCOUNT_FINISH_ONE,	"refcount_finish_one" },
-		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
-		{ XFS_ERRTAG_AG_RESV_CRITICAL,		"ag_resv_critical" },
-		{ XFS_ERRTAG_DROP_WRITES,		"drop_writes" },
-		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
-		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
-		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
-		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
-		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
-		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
-		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
-		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
-		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
-		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
-		{ XFS_ERRTAG_LARP,			"larp" },
-		{ XFS_ERRTAG_DA_LEAF_SPLIT,		"da_leaf_split" },
-		{ XFS_ERRTAG_ATTR_LEAF_TO_NODE,		"attr_leaf_to_node" },
-		{ XFS_ERRTAG_WB_DELAY_MS,		"wb_delay_ms" },
-		{ XFS_ERRTAG_WRITE_DELAY_MS,		"write_delay_ms" },
-		{ XFS_ERRTAG_EXCHMAPS_FINISH_ONE,	"exchmaps_finish_one" },
-		{ XFS_ERRTAG_METAFILE_RESV_CRITICAL,	"metafile_resv_crit" },
-		{ XFS_ERRTAG_MAX,			NULL }
-	};
-	int	count;
+	unsigned int	i;
 
-	/*
-	 * If this fails make sure every tag is defined in the array above,
-	 * see xfs_errortag_attrs in kernelspace.
-	 */
-	BUILD_BUG_ON(sizeof(eflags) != (XFS_ERRTAG_MAX + 1) * sizeof(*e));
+	for (i = 0; i < ARRAY_SIZE(tag_names); i++)
+		if (tag_names[i] && strcmp(name, tag_names[i]) == 0)
+			return i;
+	return -1;
+}
 
-	/* Search for a name */
-	if (name) {
-		for (e = eflags; e->name; e++)
-			if (strcmp(name, e->name) == 0)
-				return e->tag;
-		return -1;
-	}
+/* Dump all the names */
+static void
+list_tags(void)
+{
+	unsigned int	count = 0, i;
 
-	/* Dump all the names */
 	fputs("tags: [ ", stdout);
-	for (count = 0, e = eflags; e->name; e++, count++) {
-		if (count) {
+	for (i = 0; i < ARRAY_SIZE(tag_names); i++) {
+		if (count > 0) {
 			fputs(", ", stdout);
 			if (!(count % 5))
 				fputs("\n\t", stdout);
 		}
-		fputs(e->name, stdout);
+		if (tag_names[i]) {
+			fputs(tag_names[i], stdout);
+			count++;
+		}
+
 	}
 	fputs(" ]\n", stdout);
-	return 0;
 }
 
 static void
@@ -121,8 +81,10 @@ inject_f(
 	xfs_error_injection_t	error;
 	int			command = XFS_IOC_ERROR_INJECTION;
 
-	if (argc == 1)
-		return error_tag(NULL);
+	if (argc == 1) {
+		list_tags();
+		return 0;
+	}
 
 	while (--argc > 0) {
 		error.fd = file->fd;
-- 
2.47.2

