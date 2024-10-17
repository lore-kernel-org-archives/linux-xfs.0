Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500701FC7E9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191321; cv=none; b=D7GtvXfCdPfDTa5wKW14hN9bprNDtFF+IXrXQsZzrpoJwH94s+FR/OR/Go1oATiYNGQtDydsnKiBcX1ytAAeWaA3sArYrDsQAyG9VfkDS6XpeU0Zp59GtnzsirNGNg7UE5jtAVtSrkRDmZJuSfZJ27XRIj6hDSg6dkjexRj0RBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191321; c=relaxed/simple;
	bh=3Qp4OurMB4UwkMxWlh3urnqxeA2xiii1ZE1DSc9tI8Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HB3Ba4NIUeLMv7StgioJVTBY+lLXiBduENH8Y0h/9lu7/Z6tuD5cPOCt4tQ3RPTF8qc/+IvmjiV55/bOM9m2m/zxvcGKjhfLn5TGMmbLBJCN3/ghghLges/GDsTBpek7JsWcGgpKQsy3IKrKvNr12LqiihD6I7Gg4QYxXStQH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFQt1Cu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFQt1Cu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0946C4CECD;
	Thu, 17 Oct 2024 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191320;
	bh=3Qp4OurMB4UwkMxWlh3urnqxeA2xiii1ZE1DSc9tI8Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lFQt1Cu8MhMMtclE6/aeql2SeNjpL5/CTHnjISTPOEkujTQ9AXPQgEkUHpY7hfp9n
	 Z/zV2OX8p6CRmiyZIFj4wuNvl693z8lyP35K4Dw/Jv3RD1siXUijJe8XS1p3AO/TCD
	 goofUtVEZ13ChjfgKL3iGwEStgL2ZRruJfLM/Hqdajzj36ZwGh4oz+mpLDT+D3VoKr
	 jpfa145nATW6nqTLQ+UpTyRws9dPnGjKY9WoIV6yFCN+wucomRpyK0tC5JD+m5RN4M
	 FamojL0dEIkJTwnypVQewhTmwIlUhhtaOgxVdQyeehQvY+UTMn90tV8lYXQk3C9bpI
	 cnFVqB9vjHfiQ==
Date: Thu, 17 Oct 2024 11:55:20 -0700
Subject: [PATCH 04/29] xfs: standardize EXPERIMENTAL warning generation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069514.3451313.9614601838519113907.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Refactor the open-coded warnings about EXPERIMENTAL feature use into a
standard helper before we go adding more experimental features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |    3 +--
 fs/xfs/xfs_fsops.c   |    4 +---
 fs/xfs/xfs_message.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_message.h |   18 ++++++++++++------
 fs/xfs/xfs_mount.h   |    6 ++++++
 fs/xfs/xfs_super.c   |   10 +++-------
 fs/xfs/xfs_xattr.c   |    3 +--
 7 files changed, 67 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4cbcf7a86dbec5..8a5c3af4cfda38 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -605,8 +605,7 @@ xfs_scrub_metadata(
 	if (error)
 		goto out;
 
-	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_SCRUB,
- "EXPERIMENTAL online scrub feature in use. Use at your own risk!");
+	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SCRUB);
 
 	sc = kzalloc(sizeof(struct xfs_scrub), XCHK_GFP_FLAGS);
 	if (!sc) {
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 82812a458cf10f..28dde215c89953 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -162,9 +162,7 @@ xfs_growfs_data_private(
 		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
 				delta, last_pag, &lastag_extended);
 	} else {
-		xfs_warn_mount(mp, XFS_OPSTATE_WARNED_SHRINK,
-	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
-
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_SHRINK);
 		error = xfs_ag_shrink_space(last_pag, &tp, -delta);
 	}
 	xfs_perag_put(last_pag);
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 8f495cc23903b2..a3324f3c90c658 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -131,3 +131,46 @@ xfs_buf_alert_ratelimited(
 	__xfs_printk(KERN_ALERT, mp, &vaf);
 	va_end(args);
 }
+
+void
+xfs_warn_experimental(
+	struct xfs_mount		*mp,
+	enum xfs_experimental_feat	feat)
+{
+	static const struct {
+		const char		*name;
+		long			opstate;
+	} features[] = {
+		[XFS_EXPERIMENTAL_SCRUB] = {
+			.opstate	= XFS_OPSTATE_WARNED_SCRUB,
+			.name		= "online scrub",
+		},
+		[XFS_EXPERIMENTAL_SHRINK] = {
+			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
+			.name		= "online shrink",
+		},
+		[XFS_EXPERIMENTAL_LARP] = {
+			.opstate	= XFS_OPSTATE_WARNED_LARP,
+			.name		= "logged extended attributes",
+		},
+		[XFS_EXPERIMENTAL_LBS] = {
+			.opstate	= XFS_OPSTATE_WARNED_LBS,
+			.name		= "large block size",
+		},
+		[XFS_EXPERIMENTAL_EXCHRANGE] = {
+			.opstate	= XFS_OPSTATE_WARNED_EXCHRANGE,
+			.name		= "exchange range",
+		},
+		[XFS_EXPERIMENTAL_PPTR] = {
+			.opstate	= XFS_OPSTATE_WARNED_PPTR,
+			.name		= "parent pointer",
+		},
+	};
+	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
+	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
+
+	if (xfs_should_warn(mp, features[feat].opstate))
+		xfs_warn(mp,
+ "EXPERIMENTAL %s feature enabled.  Use at your own risk!",
+				features[feat].name);
+}
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index cc323775a12c31..6eb3369be090db 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -75,12 +75,6 @@ do {									\
 #define xfs_debug_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
-#define xfs_warn_mount(mp, warntag, fmt, ...)				\
-do {									\
-	if (xfs_should_warn((mp), (warntag)))				\
-		xfs_warn((mp), (fmt), ##__VA_ARGS__);			\
-} while (0)
-
 #define xfs_warn_once(dev, fmt, ...)				\
 	xfs_printk_once(xfs_warn, dev, fmt, ##__VA_ARGS__)
 #define xfs_notice_once(dev, fmt, ...)				\
@@ -96,4 +90,16 @@ extern void xfs_hex_dump(const void *p, int length);
 void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 			       const char *fmt, ...);
 
+enum xfs_experimental_feat {
+	XFS_EXPERIMENTAL_SCRUB,
+	XFS_EXPERIMENTAL_SHRINK,
+	XFS_EXPERIMENTAL_LARP,
+	XFS_EXPERIMENTAL_LBS,
+	XFS_EXPERIMENTAL_EXCHRANGE,
+	XFS_EXPERIMENTAL_PPTR,
+
+	XFS_EXPERIMENTAL_MAX,
+};
+void xfs_warn_experimental(struct xfs_mount *mp, enum xfs_experimental_feat f);
+
 #endif	/* __XFS_MESSAGE_H */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1b698878f40cb1..1abe369b31a0b7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -479,6 +479,12 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
 /* Filesystem can use logged extended attributes */
 #define XFS_OPSTATE_USE_LARP		12
+/* Kernel has logged a warning about blocksize > pagesize on this fs. */
+#define XFS_OPSTATE_WARNED_LBS		13
+/* Kernel has logged a warning about exchange-range being used on this fs. */
+#define XFS_OPSTATE_WARNED_EXCHRANGE	14
+/* Kernel has logged a warning about parent pointers being used on this fs. */
+#define XFS_OPSTATE_WARNED_PPTR		15
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 457c2d70968d9a..b7091728791bf5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1657,9 +1657,7 @@ xfs_fs_fill_super(
 			goto out_free_sb;
 		}
 
-		xfs_warn(mp,
-"EXPERIMENTAL: V5 Filesystem with Large Block Size (%d bytes) enabled.",
-			mp->m_sb.sb_blocksize);
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_LBS);
 	}
 
 	/* Ensure this filesystem fits in the page cache limits */
@@ -1755,12 +1753,10 @@ xfs_fs_fill_super(
 	}
 
 	if (xfs_has_exchange_range(mp))
-		xfs_warn(mp,
-	"EXPERIMENTAL exchange-range feature enabled. Use at your own risk!");
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_EXCHRANGE);
 
 	if (xfs_has_parent(mp))
-		xfs_warn(mp,
-	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PPTR);
 
 	error = xfs_mountfs(mp);
 	if (error)
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index eaf849260bd672..0f641a9091ecbf 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -51,8 +51,7 @@ xfs_attr_grab_log_assist(
 		return error;
 	xfs_set_using_logged_xattrs(mp);
 
-	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_LARP,
- "EXPERIMENTAL logged extended attributes feature in use. Use at your own risk!");
+	xfs_warn_experimental(mp, XFS_EXPERIMENTAL_LARP);
 
 	return 0;
 }

