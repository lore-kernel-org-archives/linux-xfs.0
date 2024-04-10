Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E06C391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710787; cv=none; b=gQqVjnf1g58l6jk8U4B/iQfYUcMwAwCRrx/NsoqSASvPev0jxfCoHtkdw9HvLO1lsosoSh6Uec97+wxIKIquNjVrwDxcMvTDRJzK87MWmrbLkLG4RJIatVjpXUNWW7i2WDOobhV+n6KAHxjjSpVZeeobVYOP7YX1BkGT6pmJWlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710787; c=relaxed/simple;
	bh=bowjWDD/QOEvUSxk0hlxVuspKIpC3UPkUWr1Ta3j5io=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+bPoBWPniRa5pgzLZSAt2BuBuMO9lzwXt6O9Tv4CfylJitkcYbrPqPnitPOzO0y5Mb2c05YLay/l1fcKOJ32+s/nMHOkOCDuMaKzLKDSEZfMPfKR1Uvh9VovWFlqJHWgZqNNm2Q4zx6fskLY3puX/H0O2NKZJYbTFWQ3y+CLls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9oS1Bkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9oS1Bkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BDC433F1;
	Wed, 10 Apr 2024 00:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710786;
	bh=bowjWDD/QOEvUSxk0hlxVuspKIpC3UPkUWr1Ta3j5io=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p9oS1Bkv4MMH+lMfNihBSVw0vB4IBQCXFH8uO3kdJdzr0dvFjx3Of/hsZqMVl7i2T
	 +hJcY/Lc1MrqGjaPN8JgDMxgD5w2pXkOKbyzaMSKyfIBe11AUDEVWVwfxg7J2vKuTc
	 UWYY+HGs64VKSYeTp0QWguRJpHXJ2yqHZzB85qs8prhaBr/qgj66M4Go155yKbnQh6
	 1g5aSN5Ua4TbmYro0FBBmK23YxUgK3XZSVJoyOevJ0cHt/PmN/Z9/FNzNq+3LS2tQA
	 BSYQErYe9MwysZy6hYfa1wpBZnTcSuXx9ELeOmDPftsGZqz74rFz+ZzhCa+x/Iebaq
	 dz8FmzHS9nA5Q==
Date: Tue, 09 Apr 2024 17:59:46 -0700
Subject: [PATCH 24/32] xfs: pass the attr value to put_listent when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969957.3631889.6582034396609138645.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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
shortform xattrs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h    |    5 +++--
 fs/xfs/libxfs/xfs_attr_sf.h |    1 +
 fs/xfs/xfs_attr_list.c      |    8 +++++++-
 fs/xfs/xfs_ioctl.c          |    1 +
 fs/xfs/xfs_xattr.c          |    1 +
 5 files changed, 13 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index d63305fc54155..cb5ca37000848 100644
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
index 39bdd1034ffab..d56e5c6876eee 100644
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
index 00b591f6c5ca1..1d57e204c850f 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -214,6 +214,7 @@ xfs_xattr_put_listent(
 	int		flags,
 	unsigned char	*name,
 	int		namelen,
+	void		*value,
 	int		valuelen)
 {
 	char *prefix;

