Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pldpMi1P"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008CF98
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nxrcCbQGpjtzcd0/TdGR8FeUFnPfJhNHIyoQhjRIp3s=; b=pldpMi1PCNA87xwS+W98I5Gfg4
	y5VxldM6+4kD7NkTeJK3kkLdNK09LlRUq7kPNsBKp+5sJPeTYi5wFkBaQghm+iSPPiUIuqHaJRtiQ
	7rs2yBJcGoTxhbzUzufYft4WwxSgmURrANMktyFUl4ymogZm53iRScQuFRkicIHyv5yIGp0+w4QI1
	TAZDdeMKXItuwK3y7TSBDCjpF5lAGN0TgM30i29tEScAUjZCqCU3pn6frV7BOBurOXvFK8FIlOOFo
	+KQsK6YX2MXaIncB4ahIMA4i8C4p4yRdTQr55G8w9Ok4APou5MZrZjbDjD1t8p8eR5TjgMB7/ml1Q
	Ucfg7ZIQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIL-005t50-0n;
	Mon, 11 Dec 2023 16:38:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/23] libxlog: remove the global libxfs_xinit x structure
Date: Mon, 11 Dec 2023 17:37:28 +0100
Message-Id: <20231211163742.837427-10-hch@lst.de>
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

There is no need to export a libxfs_xinit with the somewhat unsuitable
name x from libxlog.  Move it into the tools linking against libxlog
that actually need it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/init.c           | 1 +
 include/libxlog.h   | 3 ---
 libxlog/util.c      | 1 -
 logprint/logprint.c | 1 +
 repair/globals.h    | 2 ++
 repair/init.c       | 2 ++
 6 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/db/init.c b/db/init.c
index 18d9dfdd9..eceaf576c 100644
--- a/db/init.c
+++ b/db/init.c
@@ -27,6 +27,7 @@ static struct xfs_mount	xmount;
 struct xfs_mount	*mp;
 static struct xlog	xlog;
 xfs_agnumber_t		cur_agno = NULLAGNUMBER;
+libxfs_init_t		x;
 
 static void
 usage(void)
diff --git a/include/libxlog.h b/include/libxlog.h
index 57f39e4e8..3948c0b8d 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -68,9 +68,6 @@ extern int	print_exit;
 extern int	print_skip_uuid;
 extern int	print_record_header;
 
-/* libxfs parameters */
-extern libxfs_init_t	x;
-
 void xlog_init(struct xfs_mount *mp, struct xlog *log);
 int xlog_is_dirty(struct xfs_mount *mp, struct xlog *log);
 
diff --git a/libxlog/util.c b/libxlog/util.c
index d1377c2e2..6e21f1a89 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -10,7 +10,6 @@
 int print_exit;
 int print_skip_uuid;
 int print_record_header;
-libxfs_init_t x;
 
 void
 xlog_init(
diff --git a/logprint/logprint.c b/logprint/logprint.c
index bcdb6b359..1a096fa79 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -25,6 +25,7 @@ int	print_overwrite;
 int     print_no_data;
 int     print_no_print;
 static int	print_operation = OP_PRINT;
+static struct libxfs_xinit x;
 
 static void
 usage(void)
diff --git a/repair/globals.h b/repair/globals.h
index b65e4a2d0..f2952d8b4 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -169,4 +169,6 @@ extern int		thread_count;
 /* If nonzero, simulate failure after this phase. */
 extern int		fail_after_phase;
 
+extern libxfs_init_t	x;
+
 #endif /* _XFS_REPAIR_GLOBAL_H */
diff --git a/repair/init.c b/repair/init.c
index 6d019b393..6e3548b32 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -18,6 +18,8 @@
 #include "libfrog/dahashselftest.h"
 #include <sys/resource.h>
 
+struct libxfs_xinit	x;
+
 static void
 ts_create(void)
 {
-- 
2.39.2

