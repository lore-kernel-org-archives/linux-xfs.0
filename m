Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ED7158D9C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724759440; cv=none; b=Sz4CxVY0YRMMcvimQSKCuO3spXeTWOQXYVftEZzL2DA2gzw2ybjTxURQOxWQ1W9yOV1Iv7qRMavGIzsXYj29Cnhn1Y7YbcAH5969DZ38A1AqhDb1u7KOS6zotXWczwTDkhS+3vDxPgii+KQZH/JFXFh+p1//qXGpobio4XQhN6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724759440; c=relaxed/simple;
	bh=+2TUQlc7Wd0raPiGzks2wtehH6wF3L2xrO3UGSkaRPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfP+nFfCOha8UsnHgsRGVXZk2d23eLIPPKA59VhtusmmQhBQXmHcCe80khqSD6DvNLt/4EfmwIj7nUmEBpdNQJDdZi4++3tKCF2Zmb7Pk+YtgW+ENXrPsX3ZGL7Wj4JB965qzxaqI/JGVfZrwCfdFZn3ZJn7irQ9lm29zHF2hfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVA4DqIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVA4DqIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DB9C515FB;
	Tue, 27 Aug 2024 11:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724759440;
	bh=+2TUQlc7Wd0raPiGzks2wtehH6wF3L2xrO3UGSkaRPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVA4DqIRpYX6NT3wIFprnB1A88XwvHIgWEHcXLFy7o+9ZZ9Wl78PJ9oyoDWhNHEEc
	 9Tf6I2KQcXk+bM/vDHg3xtomJ44DwaFs7KTo0Jx+QZzTillA6/DZXLNXLqX5JaSxsV
	 CjR6ISL2MsXZGwIWMqJK8JLr8q7TOGj3763IxhbYxxsGvThs0bkoPApTqL+kzV1rh1
	 QEzC4BdCOKv/+uzL+tdjOBDZUMVlzElHTftRr5lR+wuRcGMA7BwLi735urf+Pyd9sH
	 mwDxbrqAI2IignRhnS9GlZI+DvccdXunEF7SG7yYiYhWi/EFSewt0Cjz+UNcBeCdWD
	 RZLlsnynCiohA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de,
	hch@infradead.org
Subject: [PATCH 1/3] libhandle: Remove libattr dependency
Date: Tue, 27 Aug 2024 13:50:22 +0200
Message-ID: <20240827115032.406321-2-cem@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827115032.406321-1-cem@kernel.org>
References: <20240827115032.406321-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Aiming torwards removing xfsprogs libattr dependency, getting rid of
libattr_cursor is the first step.

libxfs already has our own definition of xfs_libattr_cursor, so we can
simply use it.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 include/handle.h   |  3 +--
 include/jdm.h      |  5 ++---
 libfrog/fsprops.c  |  8 ++++----
 libhandle/handle.c |  2 +-
 libhandle/jdm.c    | 14 +++++++-------
 scrub/phase5.c     |  2 +-
 6 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/include/handle.h b/include/handle.h
index ba0650051..991bd5d01 100644
--- a/include/handle.h
+++ b/include/handle.h
@@ -11,7 +11,6 @@ extern "C" {
 #endif
 
 struct fsdmidata;
-struct attrlist_cursor;
 struct parent;
 
 extern int  path_to_handle (char *__path, void **__hanp, size_t *__hlen);
@@ -29,7 +28,7 @@ extern int  attr_multi_by_handle (void *__hanp, size_t __hlen, void *__buf,
 				  int __rtrvcnt, int __flags);
 extern int  attr_list_by_handle (void *__hanp, size_t __hlen, void *__buf,
 				 size_t __bufsize, int __flags,
-				 struct attrlist_cursor *__cursor);
+				 struct xfs_attrlist_cursor *__cursor);
 extern int  parents_by_handle(void *__hanp, size_t __hlen,
 			      struct parent *__buf, size_t __bufsize,
 			      unsigned int *__count);
diff --git a/include/jdm.h b/include/jdm.h
index 50c2296b4..669ee75ce 100644
--- a/include/jdm.h
+++ b/include/jdm.h
@@ -12,7 +12,6 @@ typedef void	jdm_filehandle_t;	/* filehandle */
 
 struct xfs_bstat;
 struct xfs_bulkstat;
-struct attrlist_cursor;
 struct parent;
 
 extern jdm_fshandle_t *
@@ -60,11 +59,11 @@ extern intgen_t
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, size_t bufsz, int flags,
-		struct attrlist_cursor *cursor);
+		struct xfs_attrlist_cursor *cursor);
 
 intgen_t jdm_attr_list_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
 		char *bufp, size_t bufsz, int flags,
-		struct attrlist_cursor *cursor);
+		struct xfs_attrlist_cursor *cursor);
 
 extern int
 jdm_parents( jdm_fshandle_t *fshp,
diff --git a/libfrog/fsprops.c b/libfrog/fsprops.c
index 88046b7a0..05a584a56 100644
--- a/libfrog/fsprops.c
+++ b/libfrog/fsprops.c
@@ -68,10 +68,10 @@ fsprops_walk_names(
 	fsprops_name_walk_fn	walk_fn,
 	void			*priv)
 {
-	struct attrlist_cursor	cur = { };
-	char			attrbuf[XFS_XATTR_LIST_MAX];
-	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
-	int			ret;
+	struct xfs_attrlist_cursor	cur = { };
+	char				attrbuf[XFS_XATTR_LIST_MAX];
+	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
+	int				ret;
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
 
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 1e8fe9ac5..a9a9f9534 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -381,7 +381,7 @@ attr_list_by_handle(
 	void		*buf,
 	size_t		bufsize,
 	int		flags,
-	struct attrlist_cursor *cursor)
+	struct		xfs_attrlist_cursor *cursor)
 {
 	int		error, fd;
 	char		*path;
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index e21aff2b2..9ce605ad3 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -221,7 +221,7 @@ int
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, size_t bufsz, int flags,
-		struct attrlist_cursor *cursor)
+		struct xfs_attrlist_cursor *cursor)
 {
 	fshandle_t *fshandlep = ( fshandle_t * )fshp;
 	filehandle_t filehandle;
@@ -240,12 +240,12 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 
 int
 jdm_attr_list_v5(
-	jdm_fshandle_t		*fshp,
-	struct xfs_bulkstat	*statp,
-	char			*bufp,
-	size_t			bufsz,
-	int			flags,
-	struct attrlist_cursor	*cursor)
+	jdm_fshandle_t			*fshp,
+	struct xfs_bulkstat		*statp,
+	char				*bufp,
+	size_t				bufsz,
+	int				flags,
+	struct xfs_attrlist_cursor	*cursor)
 {
 	struct fshandle		*fshandlep = (struct fshandle *)fshp;
 	struct filehandle	filehandle;
diff --git a/scrub/phase5.c b/scrub/phase5.c
index f6c295c64..27fa29be6 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -190,7 +190,7 @@ check_xattr_ns_names(
 	struct xfs_bulkstat		*bstat,
 	const struct attrns_decode	*attr_ns)
 {
-	struct attrlist_cursor		cur;
+	struct xfs_attrlist_cursor	cur;
 	char				attrbuf[XFS_XATTR_LIST_MAX];
 	char				keybuf[XATTR_NAME_MAX + 1];
 	struct attrlist			*attrlist = (struct attrlist *)attrbuf;
-- 
2.46.0

