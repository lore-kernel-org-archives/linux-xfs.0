Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35367206279
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528364; cv=none; b=kCssQlY+qm8GNNpl87Qwp0dnYAmSvDg7Q+3fACyBJ/P/2cAPPH9lqUYN1ovrndRkwFrEal0aH9N6V+JI5rgQZ/qVt0jRimOxwxDTwptVtRRrqACpW56P2+X8Og3L2a6E5mwXVJ8vXKAhy1kAZ3EaGkjrEZ3cwZ9SNwNbo2RFWk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528364; c=relaxed/simple;
	bh=8GziOFrpJtbtbGbmS4wIvJOHzjFxAwwKRHrXlIc7FNw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ib66CdxRUWXRtZsX/jpAFe0Jny8jibdPoNA4PH65sm5DA3gzKA870pWDCaMC9EAqlpxmbT8HI8ErI+UOyiCh0wSmwNX4sJ6z5tCpY9v5Dm+Lr4gHlRGYybX14WBORSwDrxJVOJNVfR75/pUGMu1E4pEVdD0oe5+hyvlZyKy9BNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDt0Kq6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDt0Kq6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B000CC4CED1;
	Fri,  6 Dec 2024 23:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528363;
	bh=8GziOFrpJtbtbGbmS4wIvJOHzjFxAwwKRHrXlIc7FNw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QDt0Kq6sc71of09ojYX8pCUuR87wuNSZTtqXwV/GaajHMCS+LchTTwsOZaOYIRhAR
	 AXMXynquhMQs9UA/TaHfNotYNZqdrmkbnlRQxJYD2TL8F8uuLq8EAoxEmQM0MC61R4
	 +SZ3xUzaWcQ8c5pTggkqMofcNJcFCpP6pt6rLHjjPmWf4pj4B7sSkqBoJ3QlI7QItL
	 JFNdNr2X46U10XXaFl048Iqh/oWtOdexhs4ErKaZVPGaXGGnbDpPZm4UDm6tWfdQrW
	 mMCrqtif3IhdJEptMCHJ7mA8Uz9limVDpNhLpVaFL4BjjdbqEixfMB8yqfYsU81ncW
	 nsCe52uYbNNXQ==
Date: Fri, 06 Dec 2024 15:39:23 -0800
Subject: [PATCH 35/36] xfs: record health problems with the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747410.121772.11231744611869127789.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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

