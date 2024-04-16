Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B832A7483
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231107; cv=none; b=SJitSPGTzvjAqXplSrrH6esJfZRz/OvoiZBr7h9fOY2CuPn6cDO9x/cEcGYymfwoPTak8tLmTNtXyeZJKMwa1sPGbd8oNjkMrmA+tJdyeJMW2zAYSBs4rB0rLIjNKAjK+yeb7CcvSj26Cbet+1CCqntwJ9We8BilD0I/Cm7xm2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231107; c=relaxed/simple;
	bh=IvhkcwwKFPIq+c84KyDEXaFKfyvSEKC3c+W1j9ekkEU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QgWj7zR9CHZSRStq0E289nIt7ngVEl6VW6YP4WP9YDqeINAwzABeUBlH3JOccR7lhDIIw9f6sx4EVeSrmIeqf2YO3CJYXdBvguPLY7nsv9GR68AjiJBb4d8qdCcW00+lu3SzmWow/VnNnORiwBbI9/74oA7ovihE7WYtWf0XVMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WG/d1GQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WG/d1GQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EFDC32783;
	Tue, 16 Apr 2024 01:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231107;
	bh=IvhkcwwKFPIq+c84KyDEXaFKfyvSEKC3c+W1j9ekkEU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WG/d1GQ/RNW9cbVT7rR6IJnNGKaOfj91iNVeqX3apW5PXHXsgQkX7A3xvomPWrVK3
	 wGbEAXjjAEoRQUuxTd3fFlz2cWptVW8qFX9ZxhcW/t2/sj2UbZS/4x8aH1SoHv9ibr
	 ezcg7XZXq/3pvP3AG7r8UoRvdEk8cpRtJV4aUjpLAFy5j3Jq2mVB/z0v1rzVaS40Zp
	 CCDAL69wCkvyLAUEcAJ/H14rtmWzRuQ51DqLhoMJH2Ei1EqsAik7XZKBsdX/8TUr5i
	 z9yPs7wD8U8fgtvdXxO46A6+c1eTyJIqeJaa6E4o6GeCPHSoQiHq0jVP97ZUd8Rv/a
	 uFhFqhnD+jbuw==
Date: Mon, 15 Apr 2024 18:31:46 -0700
Subject: [PATCH 22/31] xfs: pass the attr value to put_listent when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028145.251715.4350752393918280133.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.  This will enable the GETPARENTS ioctl to use
xfs_attr_list as its backend.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h    |    5 +++--
 fs/xfs/libxfs/xfs_attr_sf.h |    1 +
 fs/xfs/xfs_attr_list.c      |    8 +++++++-
 fs/xfs/xfs_ioctl.c          |    1 +
 fs/xfs/xfs_xattr.c          |    1 +
 5 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index d0ed7ea58ab0f..d12583dd7eecb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -47,8 +47,9 @@ struct xfs_attrlist_cursor_kern {
 
 
 /* void; state communicated via *context */
-typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
-			      unsigned char *, int, int);
+typedef void (*put_listent_func_t)(struct xfs_attr_list_context *context,
+		int flags, unsigned char *name, int namelen, void *value,
+		int valuelen);
 
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index bc44222230248..73bdc0e556825 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -16,6 +16,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 9bc4b5322539a..5c947e5ce8b88 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -92,6 +92,7 @@ xfs_attr_shortform_list(
 					     sfe->flags,
 					     sfe->nameval,
 					     (int)sfe->namelen,
+					     &sfe->nameval[sfe->namelen],
 					     (int)sfe->valuelen);
 			/*
 			 * Either search callback finished early or
@@ -138,6 +139,7 @@ xfs_attr_shortform_list(
 		sbp->name = sfe->nameval;
 		sbp->namelen = sfe->namelen;
 		/* These are bytes, and both on-disk, don't endian-flip */
+		sbp->value = &sfe->nameval[sfe->namelen],
 		sbp->valuelen = sfe->valuelen;
 		sbp->flags = sfe->flags;
 		sbp->hash = xfs_attr_hashval(dp->i_mount, sfe->flags,
@@ -192,6 +194,7 @@ xfs_attr_shortform_list(
 				     sbp->flags,
 				     sbp->name,
 				     sbp->namelen,
+				     sbp->value,
 				     sbp->valuelen);
 		if (context->seen_enough)
 			break;
@@ -479,6 +482,7 @@ xfs_attr3_leaf_list_int(
 	 */
 	for (; i < ichdr.count; entry++, i++) {
 		char *name;
+		void *value;
 		int namelen, valuelen;
 
 		if (be32_to_cpu(entry->hashval) != cursor->hashval) {
@@ -496,6 +500,7 @@ xfs_attr3_leaf_list_int(
 			name_loc = xfs_attr3_leaf_name_local(leaf, i);
 			name = name_loc->nameval;
 			namelen = name_loc->namelen;
+			value = &name_loc->nameval[name_loc->namelen];
 			valuelen = be16_to_cpu(name_loc->valuelen);
 		} else {
 			xfs_attr_leaf_name_remote_t *name_rmt;
@@ -503,6 +508,7 @@ xfs_attr3_leaf_list_int(
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
 			name = name_rmt->name;
 			namelen = name_rmt->namelen;
+			value = NULL;
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
@@ -513,7 +519,7 @@ xfs_attr3_leaf_list_int(
 			return -EFSCORRUPTED;
 		}
 		context->put_listent(context, entry->flags,
-					      name, namelen, valuelen);
+					      name, namelen, value, valuelen);
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 66133b4fc20f7..09fdde5ef7b8a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -310,6 +310,7 @@ xfs_ioc_attr_put_listent(
 	int			flags,
 	unsigned char		*name,
 	int			namelen,
+	void			*value,
 	int			valuelen)
 {
 	struct xfs_attrlist	*alist = context->buffer;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c33dfa20f538e..c34d09c998a05 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -222,6 +222,7 @@ xfs_xattr_put_listent(
 	int		flags,
 	unsigned char	*name,
 	int		namelen,
+	void		*value,
 	int		valuelen)
 {
 	char *prefix;

