Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205CACDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 17:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjJRRj6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjJRRj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 13:39:56 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533C49F;
        Wed, 18 Oct 2023 10:39:54 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c0ecb9a075so49224015ad.2;
        Wed, 18 Oct 2023 10:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697650793; x=1698255593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kObTCpttwRGsJXO+T/tcZq3nvHyuvs5borClzJUYcjo=;
        b=dWIf6iniYVw3XJfX/yp/P6hOR7aPqCoeFu3vF9uP7VNPd15mFAb1jOInTXfwo/Nc0m
         1g8EKpE40ADCv2v1adI9w02fSb9Qb7xqBxA3egCM10kg6l0mf8DeSY/o2amYAuKnKesq
         cwqP0QSViSnIBVkS5mTnHLF4yuSf3DMtzWoxpLhYlFZH8hgV0AI9CPNOVT0e+fhebP6f
         eo4CkiNumNzAT0Y18RhZeHKpMlrN6JdhbfEbym6p/18Zza5o717BZXmVY86TQCjlwDIc
         4cFfY/SBWCeO1frNcz/dl829NKG+HJn+IDgY8NgzoTxwehEc7d19pk5FUBTmioJHOHyi
         88Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697650793; x=1698255593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kObTCpttwRGsJXO+T/tcZq3nvHyuvs5borClzJUYcjo=;
        b=ITdvvow71rBck52pQNw2AWX9R9ScWUZrQhhQoubUZhEmILTvt5WFOvN4ljv1Q2sVtS
         Qyte6/C0iKgTOEfXiEcjl/Ncy/O2Zo5TmNpX9eXbzucm2AJ10zn468fIIbIZo2L2d/J/
         U95+6Esa8nINr0800MCCD/H/9DO1uXXDNS3U8uIk9mRr5afKm/z39ske8Xjjo2CyjJTn
         wy4HrOognrNtlGqtFB3weV6pi4Wia6LcbpXYseb1cBmn7h4enZHFQHtXETrMW1dMLKEO
         2cKFUTdFEumFNDfHkQgFWk+F1gAXDQUojkxQnDWwux7PzYxMTny51tKfGxSKCdJGAr+A
         AdgA==
X-Gm-Message-State: AOJu0YyaRqqN/tmQwom9ecwK962f7C+DyyCXRJ6o/x1iUP04jyJC99fu
        /Rb2kapa4PkmKvgWYLVjjXQ+P8LdN3qNVA==
X-Google-Smtp-Source: AGHT+IHGWc3brrKeq8m+T2qjYBp+b6NRfd6rMxT7Raa+KkypH9RsWP/08hvWVqAEmGdZAAzRgwqF2Q==
X-Received: by 2002:a17:903:120f:b0:1bc:e6a:205f with SMTP id l15-20020a170903120f00b001bc0e6a205fmr47574plh.20.1697650793330;
        Wed, 18 Oct 2023 10:39:53 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:c7ee:164e:dc3a:6a45])
        by smtp.gmail.com with ESMTPSA id h1-20020a170902eec100b001ca4c20003dsm205866plb.69.2023.10.18.10.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:39:52 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, "Darrick J. Wong" <djwong@kernel.org>,
        Ian Kent <raven@themaw.net>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandanbabu@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15] xfs: don't expose internal symlink metadata buffers to the vfs
Date:   Wed, 18 Oct 2023 10:39:45 -0700
Message-ID: <20231018173945.2858151-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 7b7820b83f230036fc48c3e7fb280c48c58adebf ]

Ian Kent reported that for inline symlinks, it's possible for
vfs_readlink to hang on to the target buffer returned by
_vn_get_link_inline long after it's been freed by xfs inode reclaim.
This is a layering violation -- we should never expose XFS internals to
the VFS.

When the symlink has a remote target, we allocate a separate buffer,
copy the internal information, and let the VFS manage the new buffer's
lifetime.  Let's adapt the inline code paths to do this too.  It's
less efficient, but fixes the layering violation and avoids the need to
adapt the if_data lifetime to rcu rules.  Clearly I don't care about
readlink benchmarks.

As a side note, this fixes the minor locking violation where we can
access the inode data fork without taking any locks; proper locking (and
eliminating the possibility of having to switch inode_operations on a
live inode) is essential to online repair coordinating repairs
correctly.

Reported-by: Ian Kent <raven@themaw.net>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Chandan Babu R <chandanbabu@kernel.org>
Acked-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_iops.c    | 34 +---------------------------------
 fs/xfs/xfs_symlink.c | 29 +++++++++++++++++++----------
 2 files changed, 20 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1eb71275e5b0..8696d6551200 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -511,27 +511,6 @@ xfs_vn_get_link(
 	return ERR_PTR(error);
 }
 
-STATIC const char *
-xfs_vn_get_link_inline(
-	struct dentry		*dentry,
-	struct inode		*inode,
-	struct delayed_call	*done)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	char			*link;
-
-	ASSERT(ip->i_df.if_format == XFS_DINODE_FMT_LOCAL);
-
-	/*
-	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
-	 * if_data is junk.
-	 */
-	link = ip->i_df.if_u1.if_data;
-	if (XFS_IS_CORRUPT(ip->i_mount, !link))
-		return ERR_PTR(-EFSCORRUPTED);
-	return link;
-}
-
 static uint32_t
 xfs_stat_blksize(
 	struct xfs_inode	*ip)
@@ -1200,14 +1179,6 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.update_time		= xfs_vn_update_time,
 };
 
-static const struct inode_operations xfs_inline_symlink_inode_operations = {
-	.get_link		= xfs_vn_get_link_inline,
-	.getattr		= xfs_vn_getattr,
-	.setattr		= xfs_vn_setattr,
-	.listxattr		= xfs_vn_listxattr,
-	.update_time		= xfs_vn_update_time,
-};
-
 /* Figure out if this file actually supports DAX. */
 static bool
 xfs_inode_supports_dax(
@@ -1358,10 +1329,7 @@ xfs_setup_iops(
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
-		if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-			inode->i_op = &xfs_inline_symlink_inode_operations;
-		else
-			inode->i_op = &xfs_symlink_inode_operations;
+		inode->i_op = &xfs_symlink_inode_operations;
 		break;
 	default:
 		inode->i_op = &xfs_inode_operations;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a31d2e5d0321..affbedf78160 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
+#include "xfs_error.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -96,17 +97,15 @@ xfs_readlink_bmap_ilocked(
 
 int
 xfs_readlink(
-	struct xfs_inode *ip,
-	char		*link)
+	struct xfs_inode	*ip,
+	char			*link)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	xfs_fsize_t	pathlen;
-	int		error = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fsize_t		pathlen;
+	int			error = -EFSCORRUPTED;
 
 	trace_xfs_readlink(ip);
 
-	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
-
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
@@ -121,12 +120,22 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		error = -EFSCORRUPTED;
 		goto out;
 	}
 
-
-	error = xfs_readlink_bmap_ilocked(ip, link);
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		/*
+		 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED
+		 * if if_data is junk.
+		 */
+		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data))
+			goto out;
+
+		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
+		error = 0;
+	} else {
+		error = xfs_readlink_bmap_ilocked(ip, link);
+	}
 
  out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-- 
2.42.0.655.g421f12c284-goog

