Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60C6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiLaAWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbiLaAVx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:21:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0732A1E3FB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5181B81E7C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B6BC433D2;
        Sat, 31 Dec 2022 00:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446109;
        bh=+9lcWJz+lQJaSyRDLxcZVTu1yMluLChCQdu0hwIlZ1E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pne01/PEcCUYwtR9p/e/FnxPmWsxUix13XI/Af7WToVb1RGKe7A4MXNrYMY+G12WB
         K0kq2vMp3EI4nwgy/0uGDUBVVyG+g8m2vjUIr1drRxfPbkHZI/HVnaY2e+fKpMHojD
         E71An+PUiBCBZyQW+rv9LzpZRmKOwkaGWs6MrkCdIyaKYv3iAGKOmny2+DWFFEwowG
         yY7I7+OgF4y6V6BblNClG8GhK1xwLQOdTc/wEJEwWJDgA/j5pfbkVR6CdfrHtEdDpW
         dcFHCKAp4XSuH/aZ3wdu+6GC9zM7p8YjbqFjPFzX6oQOZVIgbla+cWmpayFXqipn7z
         nySNloavYAYaA==
Subject: [PATCH 12/19] libhandle: add support for bulkstat v5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868097.713817.8244937216014325507.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add support to libhandle for generating file handles with bulkstat v5
structures.  xfs_fsr will need this to be able to interface with the new
vfs range swap ioctl, and other client programs will probably want this
over time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/jdm.h   |   24 +++++++++++
 libhandle/jdm.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)


diff --git a/include/jdm.h b/include/jdm.h
index c57fcae7fca..445737a6b5f 100644
--- a/include/jdm.h
+++ b/include/jdm.h
@@ -11,6 +11,7 @@ typedef void	jdm_fshandle_t;		/* filesystem handle */
 typedef void	jdm_filehandle_t;	/* filehandle */
 
 struct xfs_bstat;
+struct xfs_bulkstat;
 struct attrlist_cursor;
 struct parent;
 
@@ -23,6 +24,9 @@ jdm_new_filehandle( jdm_filehandle_t **handlep,	/* new filehandle */
 		    jdm_fshandle_t *fshandlep,	/* filesystem filehandle */
 		    struct xfs_bstat *sp);	/* bulkstat info */
 
+extern void jdm_new_filehandle_v5(jdm_filehandle_t **handlep, size_t *hlen,
+		jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp);
+
 extern void
 jdm_delete_filehandle( jdm_filehandle_t *handlep,/* filehandle to delete */
 		       size_t hlen);		/* filehandle size */
@@ -32,35 +36,55 @@ jdm_open( jdm_fshandle_t *fshandlep,
 	  struct xfs_bstat *sp,
 	  intgen_t oflags);
 
+extern intgen_t jdm_open_v5(jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp,
+		intgen_t oflags);
+
 extern intgen_t
 jdm_readlink( jdm_fshandle_t *fshandlep,
 	      struct xfs_bstat *sp,
 	      char *bufp,
 	      size_t bufsz);
 
+extern intgen_t jdm_readlink_v5(jdm_fshandle_t *fshandlep,
+		struct xfs_bulkstat *sp, char *bufp, size_t bufsz);
+
 extern intgen_t
 jdm_attr_multi(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, int rtrvcnt, int flags);
 
+extern intgen_t jdm_attr_multi_v5(jdm_fshandle_t *fshp,
+		struct xfs_bulkstat *statp, char *bufp, int rtrvcnt,
+		int flags);
+
 extern intgen_t
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, size_t bufsz, int flags,
 		struct attrlist_cursor *cursor);
 
+extern intgen_t jdm_attr_list_v5(jdm_fshandle_t *fshp,
+		struct xfs_bulkstat *statp, char *bufp, size_t bufsz, int
+		flags, struct attrlist_cursor *cursor);
+
 extern int
 jdm_parents( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		struct parent *bufp, size_t bufsz,
 		unsigned int *count);
 
+extern int jdm_parents_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		struct parent *bufp, size_t bufsz, unsigned int *count);
+
 extern int
 jdm_parentpaths( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		struct parent *bufp, size_t bufsz,
 		unsigned int *count);
 
+extern int jdm_parentpaths_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		struct parent *bufp, size_t bufsz, unsigned int *count);
+
 /* macro for determining the size of a structure member */
 #define sizeofmember( t, m )	sizeof( ( ( t * )0 )->m )
 
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 07b0c60985e..e21aff2b2c1 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -41,6 +41,19 @@ jdm_fill_filehandle( filehandle_t *handlep,
 	handlep->fh_ino = statp->bs_ino;
 }
 
+static void
+jdm_fill_filehandle_v5(
+	struct filehandle	*handlep,
+	struct fshandle		*fshandlep,
+	struct xfs_bulkstat	*statp)
+{
+	handlep->fh_fshandle = *fshandlep;
+	handlep->fh_sz_following = FILEHANDLE_SZ_FOLLOWING;
+	memset(handlep->fh_pad, 0, FILEHANDLE_SZ_PAD);
+	handlep->fh_gen = statp->bs_gen;
+	handlep->fh_ino = statp->bs_ino;
+}
+
 jdm_fshandle_t *
 jdm_getfshandle( char *mntpnt )
 {
@@ -90,6 +103,22 @@ jdm_new_filehandle( jdm_filehandle_t **handlep,
 		jdm_fill_filehandle(*handlep, (fshandle_t *) fshandlep, statp);
 }
 
+void
+jdm_new_filehandle_v5(
+	jdm_filehandle_t	**handlep,
+	size_t			*hlen,
+	jdm_fshandle_t		*fshandlep,
+	struct xfs_bulkstat	*statp)
+{
+	/* allocate and fill filehandle */
+	*hlen = sizeof(filehandle_t);
+	*handlep = (filehandle_t *) malloc(*hlen);
+	if (!*handlep)
+		return;
+
+	jdm_fill_filehandle_v5(*handlep, (struct fshandle *)fshandlep, statp);
+}
+
 /* ARGSUSED */
 void
 jdm_delete_filehandle( jdm_filehandle_t *handlep, size_t hlen )
@@ -111,6 +140,19 @@ jdm_open( jdm_fshandle_t *fshp, struct xfs_bstat *statp, intgen_t oflags )
 	return fd;
 }
 
+intgen_t
+jdm_open_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	intgen_t		oflags)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return open_by_fshandle(&filehandle, sizeof(filehandle), oflags);
+}
+
 intgen_t
 jdm_readlink( jdm_fshandle_t *fshp,
 	      struct xfs_bstat *statp,
@@ -128,6 +170,20 @@ jdm_readlink( jdm_fshandle_t *fshp,
 	return rval;
 }
 
+intgen_t
+jdm_readlink_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	size_t			bufsz)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return readlink_by_handle(&filehandle, sizeof(filehandle), bufp, bufsz);
+}
+
 int
 jdm_attr_multi(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -145,6 +201,22 @@ jdm_attr_multi(	jdm_fshandle_t *fshp,
 	return rval;
 }
 
+int
+jdm_attr_multi_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	int			rtrvcnt,
+	int			flags)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return attr_multi_by_handle(&filehandle, sizeof(filehandle), bufp,
+			rtrvcnt, flags);
+}
+
 int
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -166,6 +238,27 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	return rval;
 }
 
+int
+jdm_attr_list_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	size_t			bufsz,
+	int			flags,
+	struct attrlist_cursor	*cursor)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	/* prevent needless EINVAL from the kernel */
+	if (bufsz > XFS_XATTR_LIST_MAX)
+		bufsz = XFS_XATTR_LIST_MAX;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return attr_list_by_handle(&filehandle, sizeof(filehandle), bufp,
+			bufsz, flags, cursor);
+}
+
 int
 jdm_parents( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -176,6 +269,18 @@ jdm_parents( jdm_fshandle_t *fshp,
 	return -1;
 }
 
+int
+jdm_parents_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	struct parent		*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	errno = EOPNOTSUPP;
+	return -1;
+}
+
 int
 jdm_parentpaths( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -185,3 +290,15 @@ jdm_parentpaths( jdm_fshandle_t *fshp,
 	errno = EOPNOTSUPP;
 	return -1;
 }
+
+int
+jdm_parentpaths_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	struct parent		*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	errno = EOPNOTSUPP;
+	return -1;
+}

