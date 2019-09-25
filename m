Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF25C4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62B69205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P57qkbBv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbfIYVjb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728660AbfIYVja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPEe061426;
        Wed, 25 Sep 2019 21:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=D0bfWHlVf65w+1YX6Jui47+USP4PbXcvLuVqBKDXx+c=;
 b=P57qkbBvKPNi+/M4JWnFiUALV90Gidejz4sZy9B2sNgfmRlUniES4e3R0UY3BzKwKfsR
 0IoTMeOlwasmU63r63S/7gH8I1ep2JyKovMOmnGYds3CDJTYm5e1K43baP+yhn2M7c4o
 UzxHO/wnn2cKY8sy95DnSuRIgP6QJn9IuEQsv5fKDDFKDGbd9r5OR5IdLCd+ThH8LN05
 Ip+wZqMHcKq/ifGp3LBYYedEvURw6SN9unT3ShL4NOrI9i0Ag9AuJRl6pGmuqRm5wqUi
 9Gfkc8AH4C/O15OcePAXp57ZIR7f2YZ4A44PxjlrlDHpcdoH/MPOVjqQPvz2ZTaXFR5k GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v5b9tyhj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdO7n088820;
        Wed, 25 Sep 2019 21:39:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2v82tkrnnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:23 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLchDl017199;
        Wed, 25 Sep 2019 21:38:43 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:38:43 -0700
Subject: [PATCH 06/18] xfs_scrub: remove moveon from unicode name collision
 helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:38:41 -0700
Message-ID: <156944752169.301514.11044127660029044630.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the unicode name collsion detector code
with a direct integer error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c   |   52 +++++++++++++++++++++++++++++++-------------
 scrub/unicrash.c |   64 ++++++++++++++++++++++++++----------------------------
 scrub/unicrash.h |   24 ++++++++++----------
 3 files changed, 80 insertions(+), 60 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 3ee6df1b..763685fd 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -87,23 +87,32 @@ xfs_scrub_scan_dirents(
 	DIR			*dir;
 	struct dirent		*dentry;
 	bool			moveon = true;
+	int			ret;
 
 	dir = fdopendir(*fd);
 	if (!dir) {
 		str_errno(ctx, descr_render(dsc));
+		moveon = false;
 		goto out;
 	}
 	*fd = -1; /* closedir will close *fd for us */
 
-	moveon = unicrash_dir_init(&uc, ctx, bstat);
-	if (!moveon)
+	ret = unicrash_dir_init(&uc, ctx, bstat);
+	if (ret) {
+		str_liberror(ctx, ret, descr_render(dsc));
+		moveon = false;
 		goto out_unicrash;
+	}
 
 	dentry = readdir(dir);
 	while (dentry) {
-		if (uc)
-			moveon = unicrash_check_dir_name(uc, dsc, dentry);
-		else
+		if (uc) {
+			ret = unicrash_check_dir_name(uc, dsc, dentry);
+			if (ret) {
+				str_liberror(ctx, ret, descr_render(dsc));
+				moveon = false;
+			}
+		} else
 			moveon = xfs_scrub_check_name(ctx, dsc,
 					_("directory"), dentry->d_name);
 		if (!moveon)
@@ -154,9 +163,11 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 	int				i;
 	int				error;
 
-	moveon = unicrash_xattr_init(&uc, ctx, bstat);
-	if (!moveon)
+	error = unicrash_xattr_init(&uc, ctx, bstat);
+	if (error) {
+		str_liberror(ctx, error, descr_render(dsc));
 		return false;
+	}
 
 	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
 	memset(&cur, 0, sizeof(cur));
@@ -169,10 +180,15 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
 			ent = ATTR_ENTRY(attrlist, i);
 			snprintf(keybuf, XATTR_NAME_MAX, "%s.%s", attr_ns->name,
 					ent->a_name);
-			if (uc)
-				moveon = unicrash_check_xattr_name(uc, dsc,
+			if (uc) {
+				error = unicrash_check_xattr_name(uc, dsc,
 						keybuf);
-			else
+				if (error) {
+					str_liberror(ctx, error,
+							descr_render(dsc));
+					moveon = false;
+				}
+			} else
 				moveon = xfs_scrub_check_name(ctx, dsc,
 						_("extended attribute"),
 						keybuf);
@@ -321,9 +337,11 @@ xfs_scrub_fs_label(
 	bool				moveon = true;
 	int				error;
 
-	moveon = unicrash_fs_label_init(&uc, ctx);
-	if (!moveon)
+	error = unicrash_fs_label_init(&uc, ctx);
+	if (error) {
+		str_liberror(ctx, error, descr_render(&dsc));
 		return false;
+	}
 
 	descr_set(&dsc, NULL);
 
@@ -342,9 +360,13 @@ xfs_scrub_fs_label(
 		goto out;
 
 	/* Otherwise check for weirdness. */
-	if (uc)
-		moveon = unicrash_check_fs_label(uc, &dsc, label);
-	else
+	if (uc) {
+		error = unicrash_check_fs_label(uc, &dsc, label);
+		if (error) {
+			str_liberror(ctx, error, descr_render(&dsc));
+			moveon = false;
+		}
+	} else
 		moveon = xfs_scrub_check_name(ctx, &dsc, _("filesystem label"),
 				label);
 	if (!moveon)
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 9b619c02..d5d2cf20 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -145,8 +145,8 @@ is_utf8_locale(void)
 }
 
 /*
- * Generate normalized form and skeleton of the name.
- * If this fails, just forget everything; this is an advisory checker.
+ * Generate normalized form and skeleton of the name.  If this fails, just
+ * forget everything and return false; this is an advisory checker.
  */
 static bool
 name_entry_compute_checknames(
@@ -379,7 +379,7 @@ name_entry_examine(
 }
 
 /* Initialize the collision detector. */
-static bool
+static int
 unicrash_init(
 	struct unicrash		**ucp,
 	struct scrub_ctx	*ctx,
@@ -392,7 +392,7 @@ unicrash_init(
 
 	if (!is_utf8_locale()) {
 		*ucp = NULL;
-		return true;
+		return 0;
 	}
 
 	if (nr_buckets > 65536)
@@ -402,7 +402,7 @@ unicrash_init(
 
 	p = calloc(1, UNICRASH_SZ(nr_buckets));
 	if (!p)
-		return false;
+		return errno;
 	p->ctx = ctx;
 	p->nr_buckets = nr_buckets;
 	p->compare_ino = compare_ino;
@@ -418,12 +418,12 @@ unicrash_init(
 	p->is_only_root_writeable = is_only_root_writeable;
 	*ucp = p;
 
-	return true;
+	return 0;
 out_spoof:
 	uspoof_close(p->spoof);
 out_free:
 	free(p);
-	return false;
+	return ENOMEM;
 }
 
 /*
@@ -441,7 +441,7 @@ is_only_root_writable(
 }
 
 /* Initialize the collision detector for a directory. */
-bool
+int
 unicrash_dir_init(
 	struct unicrash		**ucp,
 	struct scrub_ctx	*ctx,
@@ -456,7 +456,7 @@ unicrash_dir_init(
 }
 
 /* Initialize the collision detector for an extended attribute. */
-bool
+int
 unicrash_xattr_init(
 	struct unicrash		**ucp,
 	struct scrub_ctx	*ctx,
@@ -468,7 +468,7 @@ unicrash_xattr_init(
 }
 
 /* Initialize the collision detector for a filesystem label. */
-bool
+int
 unicrash_fs_label_init(
 	struct unicrash		**ucp,
 	struct scrub_ctx	*ctx)
@@ -608,7 +608,7 @@ _("Unicode name \"%s\" in %s could be confused with \"%s\"."),
  * must be skeletonized according to Unicode TR39 to detect names that
  * could be visually confused with each other.
  */
-static bool
+static void
 unicrash_add(
 	struct unicrash		*uc,
 	struct name_entry	*new_entry,
@@ -633,7 +633,7 @@ unicrash_add(
 		    (uc->compare_ino ? entry->ino != new_entry->ino : true)) {
 			*badflags |= UNICRASH_NOT_UNIQUE;
 			*existing_entry = entry;
-			return true;
+			return;
 		}
 
 		/* Confusable? */
@@ -642,16 +642,14 @@ unicrash_add(
 		    (uc->compare_ino ? entry->ino != new_entry->ino : true)) {
 			*badflags |= UNICRASH_CONFUSABLE;
 			*existing_entry = entry;
-			return true;
+			return;
 		}
 		entry = entry->next;
 	}
-
-	return true;
 }
 
 /* Check a name for unicode normalization problems or collisions. */
-static bool
+static int
 __unicrash_check_name(
 	struct unicrash		*uc,
 	struct descr		*dsc,
@@ -660,67 +658,67 @@ __unicrash_check_name(
 	xfs_ino_t		ino)
 {
 	struct name_entry	*dup_entry = NULL;
-	struct name_entry	*new_entry;
+	struct name_entry	*new_entry = NULL;
 	unsigned int		badflags = 0;
-	bool			moveon;
 
 	/* If we can't create entry data, just skip it. */
 	if (!name_entry_create(uc, name, ino, &new_entry))
-		return true;
+		return 0;
 
 	name_entry_examine(new_entry, &badflags);
-
-	moveon = unicrash_add(uc, new_entry, &badflags, &dup_entry);
-	if (!moveon)
-		return false;
-
+	unicrash_add(uc, new_entry, &badflags, &dup_entry);
 	if (badflags)
 		unicrash_complain(uc, dsc, namedescr, new_entry, badflags,
 				dup_entry);
 
-	return true;
+	return 0;
 }
 
-/* Check a directory entry for unicode normalization problems or collisions. */
-bool
+/*
+ * Check a directory entry for unicode normalization problems or collisions.
+ * If errors occur, this function will log them and return nonzero.
+ */
+int
 unicrash_check_dir_name(
 	struct unicrash		*uc,
 	struct descr		*dsc,
 	struct dirent		*dentry)
 {
 	if (!uc)
-		return true;
+		return 0;
 	return __unicrash_check_name(uc, dsc, _("directory"),
 			dentry->d_name, dentry->d_ino);
 }
 
 /*
  * Check an extended attribute name for unicode normalization problems
- * or collisions.
+ * or collisions.  If errors occur, this function will log them and return
+ * nonzero.
  */
-bool
+int
 unicrash_check_xattr_name(
 	struct unicrash		*uc,
 	struct descr		*dsc,
 	const char		*attrname)
 {
 	if (!uc)
-		return true;
+		return 0;
 	return __unicrash_check_name(uc, dsc, _("extended attribute"),
 			attrname, 0);
 }
 
 /*
  * Check the fs label for unicode normalization problems or misleading bits.
+ * If errors occur, this function will log them and return nonzero.
  */
-bool
+int
 unicrash_check_fs_label(
 	struct unicrash		*uc,
 	struct descr		*dsc,
 	const char		*label)
 {
 	if (!uc)
-		return true;
+		return 0;
 	return __unicrash_check_name(uc, dsc, _("filesystem label"),
 			label, 0);
 }
diff --git a/scrub/unicrash.h b/scrub/unicrash.h
index af96b230..c3a7f385 100644
--- a/scrub/unicrash.h
+++ b/scrub/unicrash.h
@@ -13,26 +13,26 @@ struct unicrash;
 
 struct dirent;
 
-bool unicrash_dir_init(struct unicrash **ucp, struct scrub_ctx *ctx,
+int unicrash_dir_init(struct unicrash **ucp, struct scrub_ctx *ctx,
 		struct xfs_bulkstat *bstat);
-bool unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
+int unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
 		struct xfs_bulkstat *bstat);
-bool unicrash_fs_label_init(struct unicrash **ucp, struct scrub_ctx *ctx);
+int unicrash_fs_label_init(struct unicrash **ucp, struct scrub_ctx *ctx);
 void unicrash_free(struct unicrash *uc);
-bool unicrash_check_dir_name(struct unicrash *uc, struct descr *dsc,
+int unicrash_check_dir_name(struct unicrash *uc, struct descr *dsc,
 		struct dirent *dirent);
-bool unicrash_check_xattr_name(struct unicrash *uc, struct descr *dsc,
+int unicrash_check_xattr_name(struct unicrash *uc, struct descr *dsc,
 		const char *attrname);
-bool unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
+int unicrash_check_fs_label(struct unicrash *uc, struct descr *dsc,
 		const char *label);
 #else
-# define unicrash_dir_init(u, c, b)		(true)
-# define unicrash_xattr_init(u, c, b)		(true)
-# define unicrash_fs_label_init(u, c)		(true)
+# define unicrash_dir_init(u, c, b)		(0)
+# define unicrash_xattr_init(u, c, b)		(0)
+# define unicrash_fs_label_init(u, c)		(0)
 # define unicrash_free(u)			do {(u) = (u);} while (0)
-# define unicrash_check_dir_name(u, d, n)	(true)
-# define unicrash_check_xattr_name(u, d, n)	(true)
-# define unicrash_check_fs_label(u, d, n)	(true)
+# define unicrash_check_dir_name(u, d, n)	(0)
+# define unicrash_check_xattr_name(u, d, n)	(0)
+# define unicrash_check_fs_label(u, d, n)	(0)
 #endif /* HAVE_LIBICU */
 
 #endif /* XFS_SCRUB_UNICRASH_H_ */

