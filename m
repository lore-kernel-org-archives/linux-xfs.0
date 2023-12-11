Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GqUFkB6k"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83FC95
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BZ7hB4JDE8U95MW6mQ0Xj/9LuQAZT+9aat/HkrPyt0g=; b=GqUFkB6kVZsjvO95uwGitDjosy
	KJ0QlAgD4lGoTMl6o43V3hN1csinWngr/dapgNxkggJ6cohq5AmYAnkR47p3tSzQvsjdl+4wqYBs1
	xkhhNsMsOX1tcItTN6X0o8EsHGMR7ImimK3UGeTgHjFeqAiFSO8J8c1HHtNYi8t6DRYDT4g1xFW2e
	nJIXSn825+zEOoiOfR0IaN08mg3j8LgV0pyPsITgNU39s4LrjA2mvnZwOnl2WzCyOck/epmUMYwkB
	NCr2ySMQl6Pi5Vv8n8ChrgD8IWYEb3ekznW26uRvc66OiZ7hO/mRuoGYHeK7oze9U4G94hDnRzoyu
	XuU8Q3fw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIC-005syr-0c;
	Mon, 11 Dec 2023 16:38:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/23] libxlog: remove the verbose argument to xlog_is_dirty
Date: Mon, 11 Dec 2023 17:37:25 +0100
Message-Id: <20231211163742.837427-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No caller passes a non-zero verbose argument to xlog_is_dirty.
Remove the argument the code keyed off by it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c   | 2 +-
 db/metadump.c     | 4 ++--
 db/sb.c           | 2 +-
 include/libxlog.h | 3 +--
 libxlog/util.c    | 8 +-------
 5 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 66728f199..4bd473a04 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -784,7 +784,7 @@ main(int argc, char **argv)
 	 */
 	memset(&xlog, 0, sizeof(struct xlog));
 	mp->m_log = &xlog;
-	c = xlog_is_dirty(mp, mp->m_log, &xargs, 0);
+	c = xlog_is_dirty(mp, mp->m_log, &xargs);
 	if (!duplicate) {
 		if (c == 1) {
 			do_log(_(
diff --git a/db/metadump.c b/db/metadump.c
index f9c82148e..e57b024cd 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2615,7 +2615,7 @@ copy_log(void)
 	if (!metadump.obfuscate && !metadump.zero_stale_data)
 		goto done;
 
-	dirty = xlog_is_dirty(mp, &log, &x, 0);
+	dirty = xlog_is_dirty(mp, &log, &x);
 
 	switch (dirty) {
 	case 0:
@@ -2945,7 +2945,7 @@ metadump_f(
 		if (iocur_top->data) {	/* best effort */
 			struct xlog	log;
 
-			if (xlog_is_dirty(mp, &log, &x, 0))
+			if (xlog_is_dirty(mp, &log, &x))
 				metadump.dirty_log = true;
 		}
 		pop_cur();
diff --git a/db/sb.c b/db/sb.c
index 2d508c26a..a3a4a758f 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -235,7 +235,7 @@ sb_logcheck(void)
 
 	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
 
-	dirty = xlog_is_dirty(mp, mp->m_log, &x, 0);
+	dirty = xlog_is_dirty(mp, mp->m_log, &x);
 	if (dirty == -1) {
 		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
 		return 0;
diff --git a/include/libxlog.h b/include/libxlog.h
index 3ade7ffaf..a598a7b3c 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -71,9 +71,8 @@ extern int	print_record_header;
 /* libxfs parameters */
 extern libxfs_init_t	x;
 
+int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log, libxfs_init_t *x);
 
-extern int xlog_is_dirty(struct xfs_mount *, struct xlog *, libxfs_init_t *,
-			 int);
 extern struct xfs_buf *xlog_get_bp(struct xlog *, int);
 extern int	xlog_bread(struct xlog *log, xfs_daddr_t blk_no, int nbblks,
 				struct xfs_buf *bp, char **offset);
diff --git a/libxlog/util.c b/libxlog/util.c
index ad60036f8..1022e3378 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -19,8 +19,7 @@ int
 xlog_is_dirty(
 	struct xfs_mount	*mp,
 	struct xlog		*log,
-	libxfs_init_t		*x,
-	int			verbose)
+	libxfs_init_t		*x)
 {
 	int			error;
 	xfs_daddr_t		head_blk, tail_blk;
@@ -58,11 +57,6 @@ xlog_is_dirty(
 		return -1;
 	}
 
-	if (verbose)
-		xlog_warn(
-	_("%s: head block %" PRId64 " tail block %" PRId64 "\n"),
-			__func__, head_blk, tail_blk);
-
 	if (head_blk != tail_blk)
 		return 1;
 
-- 
2.39.2

