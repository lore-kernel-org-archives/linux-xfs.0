Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A97C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pC7OXByL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB78C433C7;
	Sun, 31 Dec 2023 23:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064688;
	bh=FxPmoMy0C/Oj9ScJla+ZhYTYoc8U2EQEz7eczPui7y0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pC7OXByLrc4d+6bYYAB3se5AtZFm2RqgxQeQWjh/+LJh+T2ARatWDP4ce/b/PKBFz
	 dMyEM2lTC1wg1fYFN8u/CwStPZTF2IYJvLWhsi4QYP5HmLZBLDBfLUBJYx+IQlwx6z
	 jbgJuJEkh27kWRDi9tPGltMkqwSxPOAtYmM649yOMFkh22HISTOLJCnCbochd6kKzL
	 v8FIWmROLwo/czIuiPBi5YkpDIfUatyAlwN4zIPK5gr0O1HPM/LBCxeCPljmIX8PY5
	 5y6zMZIGLFFVOuoXJzujolLpJHZDbM1ClQWCX9QVTwWHqiQPoQnRsLUQLfLyP9m2Ng
	 tm6YZomfGs7UA==
Date: Sun, 31 Dec 2023 15:18:08 -0800
Subject: [PATCH 18/18] xfs_scrub: use parent pointers to report lost file data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405007102.1805510.8160425372208668658.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If parent pointers are enabled, compute the path to the file while we're
doing the fsmap scan and report that, instead of walking the entire
directory tree to print the paths of the (hopefully few) files that lost
data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 63 insertions(+), 12 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 99a32bc7962..66ca57507e9 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -21,6 +21,7 @@
 #include "read_verify.h"
 #include "spacemap.h"
 #include "vfs.h"
+#include "libfrog/bulkstat.h"
 
 /*
  * Phase 6: Verify data file integrity.
@@ -371,6 +372,24 @@ report_dirent_loss(
 	return error;
 }
 
+struct ioerr_filerange {
+	uint64_t		physical;
+	uint64_t		length;
+};
+
+/*
+ * If reverse mapping and parent pointers are enabled, we can map media errors
+ * directly back to a filename and a file position without needing to walk the
+ * directory tree.
+ */
+static inline bool
+can_use_pptrs(
+	const struct scrub_ctx	*ctx)
+{
+	return  (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT) &&
+		(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
+}
+
 /* Use a fsmap to report metadata lost to a media error. */
 static int
 report_ioerr_fsmap(
@@ -379,16 +398,18 @@ report_ioerr_fsmap(
 	void			*arg)
 {
 	const char		*type;
+	struct xfs_bulkstat	bs = { };
 	char			buf[DESCR_BUFSZ];
-	uint64_t		err_physical = *(uint64_t *)arg;
+	struct ioerr_filerange	*fr = arg;
 	uint64_t		err_off;
+	int			ret;
 
 	/* Don't care about unwritten extents. */
 	if (map->fmr_flags & FMR_OF_PREALLOC)
 		return 0;
 
-	if (err_physical > map->fmr_physical)
-		err_off = err_physical - map->fmr_physical;
+	if (fr->physical > map->fmr_physical)
+		err_off = fr->physical - map->fmr_physical;
 	else
 		err_off = 0;
 
@@ -411,23 +432,43 @@ report_ioerr_fsmap(
 		}
 	}
 
+	if (can_use_pptrs(ctx)) {
+		ret = -xfrog_bulkstat_single(&ctx->mnt, map->fmr_owner, 0, &bs);
+		if (ret)
+			str_liberror(ctx, ret,
+					_("bulkstat for media error report"));
+	}
+
 	/* Report extent maps */
 	if (map->fmr_flags & FMR_OF_EXTENT_MAP) {
 		bool		attr = (map->fmr_flags & FMR_OF_ATTR_FORK);
 
 		scrub_render_ino_descr(ctx, buf, DESCR_BUFSZ,
-				map->fmr_owner, 0, " %s",
+				map->fmr_owner, bs.bs_gen, " %s",
 				attr ? _("extended attribute") :
 				       _("file data"));
 		str_corrupt(ctx, buf, _("media error in extent map"));
 	}
 
 	/*
-	 * XXX: If we had a getparent() call we could report IO errors
-	 * efficiently.  Until then, we'll have to scan the dir tree
-	 * to find the bad file's pathname.
+	 * If directory parent pointers are available, use that to find the
+	 * pathname to a file, and report that path as having lost its
+	 * extended attributes, or the precise offset of the lost file data.
 	 */
+	if (!can_use_pptrs(ctx))
+		return 0;
 
+	scrub_render_ino_descr(ctx, buf, DESCR_BUFSZ, map->fmr_owner,
+			bs.bs_gen, NULL);
+
+	if (map->fmr_flags & FMR_OF_ATTR_FORK) {
+		str_corrupt(ctx, buf, _("media error in extended attributes"));
+		return 0;
+	}
+
+	str_unfixable_error(ctx, buf,
+ _("media error at data offset %llu length %llu."),
+			err_off, fr->length);
 	return 0;
 }
 
@@ -442,6 +483,10 @@ report_ioerr(
 	void				*arg)
 {
 	struct fsmap			keys[2];
+	struct ioerr_filerange		fr = {
+		.physical		= start,
+		.length			= length,
+	};
 	struct disk_ioerr_report	*dioerr = arg;
 	dev_t				dev;
 
@@ -457,7 +502,7 @@ report_ioerr(
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
 	return -scrub_iterate_fsmap(dioerr->ctx, keys, report_ioerr_fsmap,
-			&start);
+			&fr);
 }
 
 /* Report all the media errors found on a disk. */
@@ -501,10 +546,16 @@ report_all_media_errors(
 		return ret;
 	}
 
-	/* Scan the directory tree to get file paths. */
-	ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss, vs);
-	if (ret)
-		return ret;
+	/*
+	 * Scan the directory tree to get file paths if we didn't already use
+	 * directory parent pointers to report the loss.
+	 */
+	if (!can_use_pptrs(ctx)) {
+		ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss,
+				vs);
+		if (ret)
+			return ret;
+	}
 
 	/* Scan for unlinked files. */
 	return scrub_scan_all_inodes(ctx, report_inode_loss, vs);

