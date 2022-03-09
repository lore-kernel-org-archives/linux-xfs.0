Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEF3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbiCITY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237886AbiCITYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:24:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81F6140B9
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 604DC61904
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25DCC340E8;
        Wed,  9 Mar 2022 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853767;
        bh=HkUeI+4DI364thBKHvUNFPausuSekm9sktGG29TzGKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XZNveaXVA8qPFUYy/cHBmt/oh5TqUP/kQZRgwOqqS7JlvgtQ4A72AFnyo/k3PMIZx
         pF/Lruwfjc7In2hBG8L/rOiOZRXSz1J842avX9YuMTIlNtgYbKaxK2mfJjIxicHjAT
         aWEddYOCf90hsGQ8ZQgi1XDv6J2OgzRw31uFcVbtrFgmmKw9ytFqj8NRM5lnhX4aZ+
         abVhbb5sKTEgtOe7u2DTOkUmWokt9gfMlJ+iUUhoMgrDmSsRKwdOqhfQEmIspz591b
         IbnJCevNVg0hROKefrJVZ8H34h5NcuFbL8iZL0EZ3rEb+0U/dIwLJZG09ADMPCFgyY
         KUQZbQj6Wjzsg==
Subject: [PATCH 2/2] xfs: constify xfs_name_dotdot
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Mar 2022 11:22:47 -0800
Message-ID: <164685376731.496011.1567771444928519597.stgit@magnolia>
In-Reply-To: <164685375609.496011.2754821878646256374.stgit@magnolia>
References: <164685375609.496011.2754821878646256374.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The symbol xfs_name_dotdot is a global variable that the xfs codebase
uses here and there to look up directory dotdot entries.  Currently it's
a non-const variable, which means that it's a mutable global variable.
So far nobody's abused this to cause problems, but let's use the
compiler to enforce that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |    6 +++++-
 fs/xfs/libxfs/xfs_dir2.h |    2 +-
 fs/xfs/scrub/parent.c    |    6 ++++--
 fs/xfs/xfs_export.c      |    3 ++-
 4 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index a77d931d65a3..cf9fa07e62d5 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -19,7 +19,11 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
-struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
+const struct xfs_name xfs_name_dotdot = {
+	.name	= (unsigned char *)"..",
+	.len	= 2,
+	.type	= XFS_DIR3_FT_DIR,
+};
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f7e6cc869c13..3120d1da9d68 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -21,7 +21,7 @@ struct xfs_dir2_data_unused;
 struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
-extern struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dotdot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index ab182a5cd0c0..e9549d998cdc 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -131,6 +131,7 @@ xchk_parent_validate(
 	xfs_ino_t		dnum,
 	bool			*try_again)
 {
+	struct xfs_name		dotdot = xfs_name_dotdot;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_inode	*dp = NULL;
 	xfs_nlink_t		expected_nlink;
@@ -230,7 +231,7 @@ xchk_parent_validate(
 	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
 
 	/* Look up '..' to see if the inode changed. */
-	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
+	error = xfs_dir_lookup(sc->tp, sc->ip, &dotdot, &dnum, NULL);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out_rele;
 
@@ -263,6 +264,7 @@ int
 xchk_parent(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_name		dotdot = xfs_name_dotdot;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_ino_t		dnum;
 	bool			try_again;
@@ -293,7 +295,7 @@ xchk_parent(
 	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	/* Look up '..' */
-	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
+	error = xfs_dir_lookup(sc->tp, sc->ip, &dotdot, &dnum, NULL);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;
 	if (!xfs_verify_dir_ino(mp, dnum)) {
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 1064c2342876..8939119191f4 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -206,10 +206,11 @@ STATIC struct dentry *
 xfs_fs_get_parent(
 	struct dentry		*child)
 {
+	struct xfs_name		dotdot = xfs_name_dotdot;
 	int			error;
 	struct xfs_inode	*cip;
 
-	error = xfs_lookup(XFS_I(d_inode(child)), &xfs_name_dotdot, &cip, NULL);
+	error = xfs_lookup(XFS_I(d_inode(child)), &dotdot, &cip, NULL);
 	if (unlikely(error))
 		return ERR_PTR(error);
 

