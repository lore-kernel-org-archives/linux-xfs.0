Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbeCZT7J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 15:59:09 -0400
Date: Mon, 26 Mar 2018 12:59:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 09/14] xfs_scrub: don't warn about confusing names if
 dir/file only writable by root
Message-ID: <20180326195903.GY4818@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160363583.8288.9124313321960984587.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152160363583.8288.9124313321960984587.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we are scanning the directory entries or attribute names of a
dir/file and the inode can only be written by root, don't warn about
Unicode confusable names by default because the system administrator
presumably made the system like that.  Also don't warn about really
short confusable names because of the high chance of collisions.  If
the caller really wants all the output, they can run in verbose mode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix resource cleanup breakage in unicrash_init
---
 scrub/unicrash.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 8b58269..f60e07f 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -92,6 +92,7 @@ struct unicrash {
 	USpoofChecker		*spoof;
 	const UNormalizer2	*normalizer;
 	bool			compare_ino;
+	bool			is_only_root_writeable;
 	size_t			nr_buckets;
 	struct name_entry	*buckets[0];
 };
@@ -395,7 +396,8 @@ unicrash_init(
 	struct unicrash		**ucp,
 	struct scrub_ctx	*ctx,
 	bool			compare_ino,
-	size_t			nr_buckets)
+	size_t			nr_buckets,
+	bool			is_only_root_writeable)
 {
 	struct unicrash		*p;
 	UErrorCode		uerr = U_ZERO_ERROR;
@@ -425,6 +427,7 @@ unicrash_init(
 	uspoof_setChecks(p->spoof, USPOOF_ALL_CHECKS, &uerr);
 	if (U_FAILURE(uerr))
 		goto out_spoof;
+	p->is_only_root_writeable = is_only_root_writeable;
 	*ucp = p;
 
 	return true;
@@ -435,6 +438,20 @@ unicrash_init(
 	return false;
 }
 
+/*
+ * Is this inode owned by root and not writable by others?  If so, skip
+ * even the informational messages, because this was put in place by the
+ * administrator.
+ */
+static bool
+is_only_root_writable(
+	struct xfs_bstat	*bstat)
+{
+	if (bstat->bs_uid != 0 || bstat->bs_gid != 0)
+		return false;
+	return !(bstat->bs_mode & S_IWOTH);
+}
+
 /* Initialize the collision detector for a directory. */
 bool
 unicrash_dir_init(
@@ -446,7 +463,8 @@ unicrash_dir_init(
 	 * Assume 64 bytes per dentry, clamp buckets between 16 and 64k.
 	 * Same general idea as dir_hash_init in xfs_repair.
 	 */
-	return unicrash_init(ucp, ctx, true, bstat->bs_size / 64);
+	return unicrash_init(ucp, ctx, true, bstat->bs_size / 64,
+			is_only_root_writable(bstat));
 }
 
 /* Initialize the collision detector for an extended attribute. */
@@ -457,7 +475,8 @@ unicrash_xattr_init(
 	struct xfs_bstat	*bstat)
 {
 	/* Assume 16 attributes per extent for lack of a better idea. */
-	return unicrash_init(ucp, ctx, false, 16 * (1 + bstat->bs_aextents));
+	return unicrash_init(ucp, ctx, false, 16 * (1 + bstat->bs_aextents),
+			is_only_root_writable(bstat));
 }
 
 /* Free the crash detector. */
@@ -549,6 +568,15 @@ _("Unicode name \"%s\" in %s contains control characters."),
 	}
 
 	/*
+	 * Skip the informational messages if the inode owning the name is
+	 * only writeable by root, because those files were put there by the
+	 * sysadmin.  Also skip names less than four letters long because
+	 * there's a much higher chance of collisions with short names.
+	 */
+	if (!verbose && (uc->is_only_root_writeable || entry->namelen < 4))
+		goto out;
+
+	/*
 	 * It's not considered good practice (says Unicode) to mix LTR
 	 * characters with RTL characters.  The mere presence of different
 	 * bidirectional characters isn't enough to trip up software, so don't
