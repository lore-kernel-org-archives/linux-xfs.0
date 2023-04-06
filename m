Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29699C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbjDFTYy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240517AbjDFTYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B9B5FC8
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:24:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0DC64ADB
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1785C433D2;
        Thu,  6 Apr 2023 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809090;
        bh=z+mzQQ6AtDbwh6r+HtecAWnsWIdCOpz03egW6+sywv0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JuSDpHou2Xg239H5pxbW9GgZStWy16d2Bws5elYsuwa/0O/E8ZAsRQJeLiR5OD69+
         TaJ47z/Px7j8Q1iU71y4GzWhngiSiAv2oJzzcEaCv8T1eLsHRuqxh01GZ/2D/4HndH
         Ov3zzJ84OMRmpSm0cOcQgCexW7JoAdTs67ZifkQzmhSuOwZsFTsZTSzYunDTv6pYOR
         Q5OA2BBwTCNRgikeP7/WqzL8nmRAb2YGkEBNbrU0/L3DIl0BDjTW4fWA8nx0BUnW7h
         yRbstXIUOqCUk6grhxSCiZgi+Rw7KNCXgQ4ayF/mTwsAxdsKFsPXRcVFAhCNzABx+T
         eHaMNs49IGynw==
Date:   Thu, 06 Apr 2023 12:24:49 -0700
Subject: [PATCH 17/23] xfs: pass the attr value to put_listent when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824899.615225.6044012124948666336.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h    |    5 +++--
 fs/xfs/libxfs/xfs_attr_sf.h |    1 +
 fs/xfs/scrub/attr.c         |    8 ++++++++
 fs/xfs/xfs_attr_list.c      |    8 +++++++-
 fs/xfs/xfs_ioctl.c          |    1 +
 fs/xfs/xfs_xattr.c          |    1 +
 6 files changed, 21 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3ad1f12a511a..0185d29d5109 100644
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
index 37578b369d9b..c6e259791bc3 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -24,6 +24,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 2a79a13cb600..00682006d0d3 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -109,6 +109,7 @@ xchk_xattr_listent(
 	int				flags,
 	unsigned char			*name,
 	int				namelen,
+	void				*value,
 	int				valuelen)
 {
 	struct xchk_xattr		*sx;
@@ -134,6 +135,13 @@ xchk_xattr_listent(
 		return;
 	}
 
+	/*
+	 * Shortform and local attrs don't require external lookups to retrieve
+	 * the value, so there's nothing else to check here.
+	 */
+	if (value)
+		return;
+
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a51f7f13a352..8e3891b96736 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -94,6 +94,7 @@ xfs_attr_shortform_list(
 					     sfe->flags,
 					     sfe->nameval,
 					     (int)sfe->namelen,
+					     &sfe->nameval[sfe->namelen],
 					     (int)sfe->valuelen);
 			/*
 			 * Either search callback finished early or
@@ -139,6 +140,7 @@ xfs_attr_shortform_list(
 		sbp->name = sfe->nameval;
 		sbp->namelen = sfe->namelen;
 		/* These are bytes, and both on-disk, don't endian-flip */
+		sbp->value = &sfe->nameval[sfe->namelen],
 		sbp->valuelen = sfe->valuelen;
 		sbp->flags = sfe->flags;
 		sfe = xfs_attr_sf_nextentry(sfe);
@@ -189,6 +191,7 @@ xfs_attr_shortform_list(
 				     sbp->flags,
 				     sbp->name,
 				     sbp->namelen,
+				     sbp->value,
 				     sbp->valuelen);
 		if (context->seen_enough)
 			break;
@@ -443,6 +446,7 @@ xfs_attr3_leaf_list_int(
 	 */
 	for (; i < ichdr.count; entry++, i++) {
 		char *name;
+		void *value;
 		int namelen, valuelen;
 
 		if (be32_to_cpu(entry->hashval) != cursor->hashval) {
@@ -460,6 +464,7 @@ xfs_attr3_leaf_list_int(
 			name_loc = xfs_attr3_leaf_name_local(leaf, i);
 			name = name_loc->nameval;
 			namelen = name_loc->namelen;
+			value = &name_loc->nameval[name_loc->namelen];
 			valuelen = be16_to_cpu(name_loc->valuelen);
 		} else {
 			xfs_attr_leaf_name_remote_t *name_rmt;
@@ -467,6 +472,7 @@ xfs_attr3_leaf_list_int(
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
 			name = name_rmt->name;
 			namelen = name_rmt->namelen;
+			value = NULL;
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
@@ -475,7 +481,7 @@ xfs_attr3_leaf_list_int(
 						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
-					      name, namelen, valuelen);
+					      name, namelen, value, valuelen);
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 59987b95201c..9abf47efd076 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -307,6 +307,7 @@ xfs_ioc_attr_put_listent(
 	int			flags,
 	unsigned char		*name,
 	int			namelen,
+	void			*value,
 	int			valuelen)
 {
 	struct xfs_attrlist	*alist = context->buffer;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c0c27c0edb33..46de0e2bfc46 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -232,6 +232,7 @@ xfs_xattr_put_listent(
 	int		flags,
 	unsigned char	*name,
 	int		namelen,
+	void		*value,
 	int		valuelen)
 {
 	char *prefix;

