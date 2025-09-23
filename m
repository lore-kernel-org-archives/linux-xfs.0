Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F101928369A
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 17:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758647429; cv=none; b=O/eUFvOa6aDH7TOtujUr2bn1dxuzRpp/lYIEbIlTpqvyEgnz0hHC9YkscrWWl4uxka0RvJWNd3CczAC5dQH60G2NsS4mk+VJA2BWiIKb/ppsjJHv7CiP8Yo/k5Sn35wvRjLZdAr115daOoOPhv27hhGlwk01QcRVfhYtMuc0OAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758647429; c=relaxed/simple;
	bh=FYkYHHY7VqUJroT+t82OfKyt86o46J25oal1XEg5P08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZQoMdWljhwWn+prFHy1fme+cFEMEaNDZLRngzXKgjKYBfM3hX65C10HRRcs+mZjEwNEGJsUVQhYoLs6rfdQ1u8PemB7pcGQjjeZA3Wkxga719+OitHksP8uhi8UcUJDfuTrM7ic2RULjTD+bzVTJRGBPgDpCio49EFpZXOL7N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tFg6aKMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tFg6aKMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8C2C4CEF5;
	Tue, 23 Sep 2025 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758647428;
	bh=FYkYHHY7VqUJroT+t82OfKyt86o46J25oal1XEg5P08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tFg6aKMnvQXkGjdkf/wzWmKCNPTtyBuvMAca8xdAvIYhEqg8NxYBKZkTGXVIyhgCh
	 Gayog50xD7ASARRE5VZPxd786K89ZbCPzYIluJ1VV+6WiLoP5Bk9rAFr0mjXLMwyLa
	 9fqCch3T25KzADbM1whrvd/voK6JZVGBA6uKPSf6S9gEdddk9aq01aWVOSDiNDV3wM
	 +xNNm+bKqS48BX7Ab70WV4BZXZtmUY95gKk5xaayVB408YjfJ0Jh3DwSeIjsGo6AWY
	 Ac5/yRXbf+PjM6L0SKCjilZC/hoiBYXFSojIcjppGA0hwasjLCi7bLUIMrGC3vWTXe
	 MVKNgN8CN/c2A==
Date: Tue, 23 Sep 2025 10:10:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 2/2] libfrog: pass mode to xfrog_file_setattr
Message-ID: <20250923171027.GU8096@frogsfrogsfrogs>
References: <20250923170857.GS8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923170857.GS8096@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

xfs/633 crashes rdump_fileattrs_path passes a NULL struct stat pointer
and then the fallback code dereferences it to get the file mode.
Instead, let's just pass the stat mode directly to it, because that's
the only piece of information that it needs.

Fixes: 128ac4dadbd633 ("xfs_db: use file_setattr to copy attributes on special files with rdump")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/file_attr.h |    9 ++-------
 db/rdump.c          |    4 ++--
 io/attr.c           |    4 ++--
 libfrog/file_attr.c |    4 ++--
 quota/project.c     |    6 ++++--
 5 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/libfrog/file_attr.h b/libfrog/file_attr.h
index df9b6181d52cf9..2a1c0d42d0a771 100644
--- a/libfrog/file_attr.h
+++ b/libfrog/file_attr.h
@@ -24,12 +24,7 @@ xfrog_file_getattr(
 	struct file_attr	*fa,
 	const unsigned int	at_flags);
 
-int
-xfrog_file_setattr(
-	const int		dfd,
-	const char		*path,
-	const struct stat	*stat,
-	struct file_attr	*fa,
-	const unsigned int	at_flags);
+int xfrog_file_setattr(const int dfd, const char *path, const mode_t mode,
+		struct file_attr *fa, const unsigned int at_flags);
 
 #endif /* __LIBFROG_FILE_ATTR_H__ */
diff --git a/db/rdump.c b/db/rdump.c
index 84ca3156d60598..26f9babad62be1 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -188,8 +188,8 @@ rdump_fileattrs_path(
 			return 1;
 	}
 
-	ret = xfrog_file_setattr(destdir->fd, pbuf->path, NULL, &fa,
-			AT_SYMLINK_NOFOLLOW);
+	ret = xfrog_file_setattr(destdir->fd, pbuf->path, VFS_I(ip)->i_mode,
+			&fa, AT_SYMLINK_NOFOLLOW);
 	if (ret) {
 		if (errno == EOPNOTSUPP || errno == EPERM || errno == ENOTTY)
 			lost_mask |= LOST_FSXATTR;
diff --git a/io/attr.c b/io/attr.c
index 022ca5f1df1b7c..9563ff74e44777 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -261,7 +261,7 @@ chattr_callback(
 
 	attr.fa_xflags |= orflags;
 	attr.fa_xflags &= ~andflags;
-	error = xfrog_file_setattr(AT_FDCWD, path, stat, &attr,
+	error = xfrog_file_setattr(AT_FDCWD, path, stat->st_mode, &attr,
 				   AT_SYMLINK_NOFOLLOW);
 	if (error) {
 		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
@@ -357,7 +357,7 @@ chattr_f(
 
 	attr.fa_xflags |= orflags;
 	attr.fa_xflags &= ~andflags;
-	error = xfrog_file_setattr(AT_FDCWD, name, &st, &attr,
+	error = xfrog_file_setattr(AT_FDCWD, name, st.st_mode, &attr,
 				   AT_SYMLINK_NOFOLLOW);
 	if (error) {
 		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
index bb51ac6eb2ef95..c2cbcb4e14659c 100644
--- a/libfrog/file_attr.c
+++ b/libfrog/file_attr.c
@@ -85,7 +85,7 @@ int
 xfrog_file_setattr(
 	const int		dfd,
 	const char		*path,
-	const struct stat	*stat,
+	const mode_t		mode,
 	struct file_attr	*fa,
 	const unsigned int	at_flags)
 {
@@ -103,7 +103,7 @@ xfrog_file_setattr(
 		return error;
 #endif
 
-	if (SPECIAL_FILE(stat->st_mode)) {
+	if (SPECIAL_FILE(mode)) {
 		errno = EOPNOTSUPP;
 		return -1;
 	}
diff --git a/quota/project.c b/quota/project.c
index 5832e1474e2549..33449e01ef4dbb 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -157,7 +157,8 @@ clear_project(
 	fa.fa_projid = 0;
 	fa.fa_xflags &= ~FS_XFLAG_PROJINHERIT;
 
-	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	error = xfrog_file_setattr(dfd, path, stat->st_mode, &fa,
+			AT_SYMLINK_NOFOLLOW);
 	if (error) {
 		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
 			progname, path, strerror(errno));
@@ -205,7 +206,8 @@ setup_project(
 	if (S_ISDIR(stat->st_mode))
 		fa.fa_xflags |= FS_XFLAG_PROJINHERIT;
 
-	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
+	error = xfrog_file_setattr(dfd, path, stat->st_mode, &fa,
+			AT_SYMLINK_NOFOLLOW);
 	if (error) {
 		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
 			progname, path, strerror(errno));
