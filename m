Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB450C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 18:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbiDNSv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 14:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240002AbiDNSvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 14:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D14738B7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 11:49:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0931DB82A3F
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 18:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F3DC385A1;
        Thu, 14 Apr 2022 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649962160;
        bh=NsGF4DHDJJS/KDYJzQzfoBss6NoqBexw0KFRgVWZI/8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pw4ebxp9yOM0od6+BiewbwEd2ck5HcM1eIPmSdU5xriTvFEoBzeAFtMnTN6OidR3q
         1XLHd6LGhPilQ9YUJvL35n8tqN9hDfJqdfySl84NORXrG/pWuxaNdaXc3IHlrl8mun
         RNI/FpddmmD+3aU8QT13G1Hakz177o0Iz4pE+0N8xJ8OsdvHWXEYUikzJWJ16rC/zO
         E+IObWS3AbUOpOeqSKaUa8UwRMSP+7R/WuEk/uiWMQVDaH8rq1Zx8XvhlklHp8sT28
         jDkv2b/MAuEVUItOcr2xd0f8ILVUMdWZkN7NHqpi+Lmw09SQOdNexmdu1LzPzdXIjG
         e9C4ihwe/GprA==
Subject: [PATCH 4/4] mkfs: don't trample the gid set in the protofile
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 11:49:20 -0700
Message-ID: <164996216024.226891.9018863209797667675.stgit@magnolia>
In-Reply-To: <164996213753.226891.14458233911347178679.stgit@magnolia>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Catherine's recent changes to xfs/019 exposed a bug in how libxfs
handles setgid bits.  mkfs reads the desired gid in from the protofile,
but if the parent directory is setgid, it will override the user's
setting and (re)set the child's gid to the parent's gid.  Overriding
user settings is (probably) not the desired mode of operation, so create
a flag to struct cred to force the gid in the protofile.

It looks like this has been broken since ~2005.

Cc: Catherine Hoang <catherine.hoang@oracle.com>
Fixes: 9f064b7e ("Provide mkfs options to easily exercise all inheritable attributes, esp. the extsize allocator hint. Merge of master-melb:xfs-cmds:24370a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h |   11 +++++++----
 libxfs/util.c       |    3 ++-
 mkfs/proto.c        |    3 ++-
 3 files changed, 11 insertions(+), 6 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 08a62d83..db9faa57 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -164,10 +164,13 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
-typedef struct cred {
-	uid_t	cr_uid;
-	gid_t	cr_gid;
-} cred_t;
+/* Always set the child's GID to this value, even if the parent is setgid. */
+#define CRED_FORCE_GID	(1U << 0)
+struct cred {
+	uid_t		cr_uid;
+	gid_t		cr_gid;
+	unsigned int	cr_flags;
+};
 
 extern int	libxfs_dir_ialloc (struct xfs_trans **, struct xfs_inode *,
 				mode_t, nlink_t, xfs_dev_t, struct cred *,
diff --git a/libxfs/util.c b/libxfs/util.c
index 9f1ca907..655a7bd3 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -271,7 +271,8 @@ libxfs_init_new_inode(
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
+		if (!(cr->cr_flags & CRED_FORCE_GID))
+			VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
 			VFS_I(ip)->i_mode |= S_ISGID;
 	}
diff --git a/mkfs/proto.c b/mkfs/proto.c
index ef130ed6..127d87dd 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -378,7 +378,7 @@ parseproto(
 	xfs_trans_t	*tp;
 	int		val;
 	int		isroot = 0;
-	cred_t		creds;
+	struct cred	creds;
 	char		*value;
 	struct xfs_name	xname;
 
@@ -446,6 +446,7 @@ parseproto(
 	mode |= val;
 	creds.cr_uid = (int)getnum(getstr(pp), 0, 0, false);
 	creds.cr_gid = (int)getnum(getstr(pp), 0, 0, false);
+	creds.cr_flags = CRED_FORCE_GID;
 	xname.name = (unsigned char *)name;
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;

