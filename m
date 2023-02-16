Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03546C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBPUsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBPUsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:48:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F8F4C3C5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:48:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80CAEB82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC17C433D2;
        Thu, 16 Feb 2023 20:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580499;
        bh=MrrrzlwG88p1IOR3pvSvT9LzzpyZ+rhUWCqizw4i1rU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=D+M7gV/2MAH1/RywJSRYrE29I3OgXMRDhrrgPpyxjJod8c3qAWH+2eLvdickbHXHh
         lZeTsnaM0/pL0XrCMu5h61kWXJrxl5Nv5xixzgRPEK/qdD+PTWACItkZAV+aDDsUZH
         +X6UgJx0ovlDwF+rk8AqIlFh6vrHXzid+IRF+iN5ua+YQjzGLtTzRFWWf8SFxE5TTS
         vnJ0GtO0Zc1rwJZjwV2lTTPdV/KokUMxujWMeAsLjPI0xiPAJcDjd93Ip8AhMZCj6+
         E/ekRC/NkfwkUjSGIhpbHRsxiR9VkOSFVf1Vw3uD7zeddTwZds7vT1LA3T1swoVl4n
         YIBp7E8S3uHzA==
Date:   Thu, 16 Feb 2023 12:48:18 -0800
Subject: [PATCH 2/7] xfs: pass diroffset back from xchk_dir_lookup
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874496.3474898.6926525132054977375.stgit@magnolia>
In-Reply-To: <167657874461.3474898.12919390014293805981.stgit@magnolia>
References: <167657874461.3474898.12919390014293805981.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass directory offsets back from xchk_dir_lookup so that we can compare
things in scrub.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c     |    2 +-
 fs/xfs/scrub/readdir.c |   12 ++++++++++--
 fs/xfs/scrub/readdir.h |    3 ++-
 3 files changed, 13 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 46080134b408..06783e4b95ad 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -105,7 +105,7 @@ xchk_dir_actor(
 	}
 
 	/* Verify that we can look up this name by hash. */
-	error = xchk_dir_lookup(sc, dp, name, &lookup_ino);
+	error = xchk_dir_lookup(sc, dp, name, &lookup_ino, NULL);
 	/* ENOENT means the hash lookup failed and the dir is corrupt */
 	if (error == -ENOENT)
 		error = -EFSCORRUPTED;
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 7d1695e98cc6..0a53438975c3 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -314,7 +314,8 @@ xchk_dir_lookup(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
-	xfs_ino_t		*ino)
+	xfs_ino_t		*ino,
+	xfs_dir2_dataptr_t	*diroffsetp)
 {
 	struct xfs_da_args	args = {
 		.dp		= dp,
@@ -326,10 +327,14 @@ xchk_dir_lookup(
 		.hashval	= xfs_dir2_hashname(dp->i_mount, name),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
+		.offset		= XFS_DIR2_NULL_DATAPTR,
 	};
 	bool			isblock, isleaf;
 	int			error;
 
+	if (diroffsetp)
+		*diroffsetp = XFS_DIR2_NULL_DATAPTR;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
@@ -369,7 +374,10 @@ xchk_dir_lookup(
 out_check_rval:
 	if (error == -EEXIST)
 		error = 0;
-	if (!error)
+	if (!error) {
 		*ino = args.inumber;
+		if (diroffsetp)
+			*diroffsetp = args.offset;
+	}
 	return error;
 }
diff --git a/fs/xfs/scrub/readdir.h b/fs/xfs/scrub/readdir.h
index 7272f3bd28b4..1a18bb59adb2 100644
--- a/fs/xfs/scrub/readdir.h
+++ b/fs/xfs/scrub/readdir.h
@@ -14,6 +14,7 @@ int xchk_dir_walk(struct xfs_scrub *sc, struct xfs_inode *dp,
 		xchk_dirent_fn dirent_fn, void *priv);
 
 int xchk_dir_lookup(struct xfs_scrub *sc, struct xfs_inode *dp,
-		const struct xfs_name *name, xfs_ino_t *ino);
+		const struct xfs_name *name, xfs_ino_t *ino,
+		xfs_dir2_dataptr_t *diroffsetp);
 
 #endif /* __XFS_SCRUB_READDIR_H__ */

