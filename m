Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D5319048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990375; cv=none; b=Qv9Yl8wJSUK+4IJSM8jQj/Z1XGvmLgj3UNzqLKkro8z7wfmDF7bestkTPL+8a8YEg9BvXXe4gTuSRQyB+wf3fOPVV81Ll8cds3Aqr9vJbJ5ZYhhhpXTCSd2J9XyiEXLRp0lsxcOYyK1AQFxXzij7COE2pe/NEi3HXEapi7FQWnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990375; c=relaxed/simple;
	bh=8GziOFrpJtbtbGbmS4wIvJOHzjFxAwwKRHrXlIc7FNw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOaA8SkPIV6kWCNLneupeTVdxssHfGu+6x4adjdjBcZmmkSmRoyyqfvegPl82/faSe+BvLMESrriXaVcIN/blMpHKMP4RMW75A1mKapM+C0PF0wF8JEPh7B/9rDE6ymE9UuyszV9hbHm/dFxExksGMPOSbKO0Z+Dfp/ydvKS5Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1mULql+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1mULql+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1290C4CED3;
	Mon, 23 Dec 2024 21:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990375;
	bh=8GziOFrpJtbtbGbmS4wIvJOHzjFxAwwKRHrXlIc7FNw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E1mULql+nHdPuaKpv3APsGPTAr7zF1aEz/lPImhzJeQ3KHHLMIX4Qt9NEaMFYOGTg
	 CDJ2EUvdWrWKvfhfe6z7mIpj3NoisGJCPXYD1jO9O1pRWor0uXtJAlacvXHUIBlGQ4
	 Y3bj8ZNJw/bOXkAJQZ1HC92IFW5s/svF8nvRLP3V5FbpBqNKY+BQO00UAYrMU04cLq
	 utxQcAIg9xIzq3kNwOJCtX3nkIbBr8hhBP6wHqOjUYwI1Wnc1mbVWeJqFqGALoRXT5
	 NidjtBGCX/APq3WlVAcA/6OtJ8hhC95qMbTh5HuNd4SeyvLoGvtt9HOwoODi21N5z1
	 gkRWsdEZHJdxQ==
Date: Mon, 23 Dec 2024 13:46:14 -0800
Subject: [PATCH 35/36] xfs: record health problems with the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940478.2293042.4634685472282933113.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: be42fc1393d66024eb6415c92f45fab5d1878c3e

Make a report to the health monitoring subsystem any time we encounter
something in the metadata directory tree that looks like corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h      |    1 +
 libxfs/xfs_health.h  |    4 +++-
 libxfs/xfs_metadir.c |   13 ++++++++++---
 3 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 499bea4ea8067f..b05e6fb1470351 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -198,6 +198,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
+#define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 13301420a2f670..f90e8dfc050000 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -62,6 +62,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
+#define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -105,7 +106,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
-				 XFS_SICK_FS_NLINKS)
+				 XFS_SICK_FS_NLINKS | \
+				 XFS_SICK_FS_METADIR)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index b52abf12d20511..b5f05925e73a4e 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -27,6 +27,7 @@
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_parent.h"
+#include "xfs_health.h"
 
 /*
  * Metadata Directory Tree
@@ -93,8 +94,10 @@ xfs_metadir_lookup(
 	};
 	int			error;
 
-	if (!S_ISDIR(VFS_I(dp)->i_mode))
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
@@ -102,10 +105,14 @@ xfs_metadir_lookup(
 	if (error)
 		return error;
 
-	if (!xfs_verify_ino(mp, args.inumber))
+	if (!xfs_verify_ino(mp, args.inumber)) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
-	if (xname->type != XFS_DIR3_FT_UNKNOWN && xname->type != args.filetype)
+	}
+	if (xname->type != XFS_DIR3_FT_UNKNOWN && xname->type != args.filetype) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	trace_xfs_metadir_lookup(dp, xname, args.inumber);
 	*ino = args.inumber;

