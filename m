Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44469BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GT2dnH8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74B9C433C8;
	Sun, 31 Dec 2023 20:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055913;
	bh=BHCgrktHtu4B+bI4xOEPVnuPt3TAQ/NXl1DRaVMhRcY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GT2dnH8I3OQDrFrfVTleEpTznujuYLAmvliw3GpH8mwCNPOd7vJavA2a3YmciTDCj
	 3KbxlJk0o/RZ7pL0jYnb/OR+UEyfEdTlxhJiVygTyX2Ryv53qs6Lpz0rF9znWJIvLc
	 od1Cwlk3SHOK4Y5Hl12BdUdOgXmMxXkkmWhKGEc/3C1HvN5x6dOR3kv0UBK9IkEPjm
	 yrBPKOJOFebiVK9DrDdo6+e+aTCxw0QAqHo7XrkjKqEoQVHvF8AGr1aAHAsCPyX9AI
	 ehOxgB0cETaiTMnQNnWZpEVwqj/KRWt6KAsCAK60AsyCT7lFBv7kleknQ1yEYyNsw5
	 6AlR24ZYmxS+A==
Date: Sun, 31 Dec 2023 12:51:53 -0800
Subject: [PATCH 13/18] xfs: pass the attr value to put_listent when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841247.1756905.8271659540788084705.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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
index 4a4d45a96dd6c..0204f62298cb5 100644
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
index 37578b369d9b9..c6e259791bc37 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -24,6 +24,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index c86e5952c1378..0eba5c9d21bb8 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -97,6 +97,7 @@ xfs_attr_shortform_list(
 					     sfe->flags,
 					     sfe->nameval,
 					     (int)sfe->namelen,
+					     &sfe->nameval[sfe->namelen],
 					     (int)sfe->valuelen);
 			/*
 			 * Either search callback finished early or
@@ -143,6 +144,7 @@ xfs_attr_shortform_list(
 		sbp->name = sfe->nameval;
 		sbp->namelen = sfe->namelen;
 		/* These are bytes, and both on-disk, don't endian-flip */
+		sbp->value = &sfe->nameval[sfe->namelen],
 		sbp->valuelen = sfe->valuelen;
 		sbp->flags = sfe->flags;
 		sfe = xfs_attr_sf_nextentry(sfe);
@@ -194,6 +196,7 @@ xfs_attr_shortform_list(
 				     sbp->flags,
 				     sbp->name,
 				     sbp->namelen,
+				     sbp->value,
 				     sbp->valuelen);
 		if (context->seen_enough)
 			break;
@@ -481,6 +484,7 @@ xfs_attr3_leaf_list_int(
 	 */
 	for (; i < ichdr.count; entry++, i++) {
 		char *name;
+		void *value;
 		int namelen, valuelen;
 
 		if (be32_to_cpu(entry->hashval) != cursor->hashval) {
@@ -498,6 +502,7 @@ xfs_attr3_leaf_list_int(
 			name_loc = xfs_attr3_leaf_name_local(leaf, i);
 			name = name_loc->nameval;
 			namelen = name_loc->namelen;
+			value = &name_loc->nameval[name_loc->namelen];
 			valuelen = be16_to_cpu(name_loc->valuelen);
 		} else {
 			xfs_attr_leaf_name_remote_t *name_rmt;
@@ -505,6 +510,7 @@ xfs_attr3_leaf_list_int(
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
 			name = name_rmt->name;
 			namelen = name_rmt->namelen;
+			value = NULL;
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
@@ -515,7 +521,7 @@ xfs_attr3_leaf_list_int(
 			return -EFSCORRUPTED;
 		}
 		context->put_listent(context, entry->flags,
-					      name, namelen, valuelen);
+					      name, namelen, value, valuelen);
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index de16dbc9e7ded..968412c0ba59e 100644
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
index 483685dbaaceb..9ae2dbc7da6c2 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -252,6 +252,7 @@ xfs_xattr_put_listent(
 	int		flags,
 	unsigned char	*name,
 	int		namelen,
+	void		*value,
 	int		valuelen)
 {
 	char *prefix;

