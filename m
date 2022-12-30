Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D878C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiLaBNO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiLaBNN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:13:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7F5183B1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D64261D5C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC359C433EF;
        Sat, 31 Dec 2022 01:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449191;
        bh=gaIIH4FwthNbsEIcIkUlpnGzAxXIBfaTnqFsZOlaPHs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NY9iSgAwdgWcuDs5qGW5CzTHCqeMfAnkLgXwj8qb/Pkf5HzHsOP3+6dlGEQ4Ho9aD
         rMfNw/Za5FE8qQ/mEcIhEE6EVLXcYR8mdacl6mkONCdqHPg1YU/4bgbGMCwVFq206A
         fSmAPuNzFODgQ+OPGRoBiEedg4lODKHgsDNAWBQ8iIcw+QKEk8KVX2lYjyNyNB8lcm
         AgEuHr/R7ISuxMkcKOrMbZ+7Qg3M4ZyVmdoR9VyOsZSb5e+5urc8TvJTSm62MuHsZG
         RYxymOivmHL0OGC+XPFnb/lN2Ez1RxmDr2jGH74nH9yw03RyukwRgM0wrZpyqEssd3
         rizsYyIO2t/bg==
Subject: [PATCH 11/23] xfs: enforce metadata inode flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:26 -0800
Message-ID: <167243864610.708110.12688103056705381916.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   73 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.h |    3 ++
 fs/xfs/scrub/common.c         |    7 +++-
 fs/xfs/scrub/inode_repair.c   |   10 ++++++
 fs/xfs/xfs_icache.c           |    2 +
 fs/xfs/xfs_inode.c            |   13 +++++++
 6 files changed, 107 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 454f40b29249..1fb11d0e7eba 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -457,6 +457,73 @@ xfs_dinode_verify_nrext64(
 	return NULL;
 }
 
+/*
+ * Validate all the picky requirements we have for a file that claims to be
+ * filesystem metadata.
+ */
+xfs_failaddr_t
+xfs_dinode_verify_metaflag(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	uint16_t		mode,
+	uint16_t		flags,
+	uint64_t		flags2)
+{
+	if (!xfs_has_metadir(mp))
+		return __this_address;
+
+	/* V5 filesystem only */
+	if (dip->di_version < 3)
+		return __this_address;
+
+	/* V3 inode fields that are always zero */
+	if (dip->di_onlink)
+		return __this_address;
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && dip->di_nrext64_pad)
+		return __this_address;
+	if (!(flags2 & XFS_DIFLAG2_NREXT64) && dip->di_flushiter)
+		return __this_address;
+
+	/* Metadata files can only be directories or regular files */
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		return __this_address;
+
+	/* They must have zero access permissions */
+	if (mode & 0777)
+		return __this_address;
+
+	/* DMAPI event and state masks are zero */
+	if (dip->di_dmevmask || dip->di_dmstate)
+		return __this_address;
+
+	/* User, group, and project IDs must be zero */
+	if (dip->di_uid || dip->di_gid ||
+	    dip->di_projid_lo || dip->di_projid_hi)
+		return __this_address;
+
+	/* Immutable, sync, noatime, nodump, and nodefrag flags must be set */
+	if (!(flags & XFS_DIFLAG_IMMUTABLE))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_SYNC))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NOATIME))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NODUMP))
+		return __this_address;
+	if (!(flags & XFS_DIFLAG_NODEFRAG))
+		return __this_address;
+
+	/* Directories must have nosymlinks flags set */
+	if (S_ISDIR(mode) && !(flags & XFS_DIFLAG_NOSYMLINKS))
+		return __this_address;
+
+	/* dax flags2 must not be set */
+	if (flags2 & XFS_DIFLAG2_DAX)
+		return __this_address;
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -610,6 +677,12 @@ xfs_dinode_verify(
 	    !xfs_has_bigtime(mp))
 		return __this_address;
 
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		fa = xfs_dinode_verify_metaflag(mp, dip, mode, flags, flags2);
+		if (fa)
+			return fa;
+	}
+
 	return NULL;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 585ed5a110af..94d6e7c018e2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -28,6 +28,9 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_metaflag(struct xfs_mount *mp,
+		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
+		uint64_t flags2);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2fbd8aa01ef7..b9c4f335cd8e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -862,7 +862,12 @@ xchk_install_handle_inode(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
+	/*
+	 * Only the directories in the metadata directory tree can be scrubbed
+	 * by handle -- files must be checked through an explicit scrub type.
+	 */
+	if ((xfs_is_metadata_inode(ip) && !S_ISDIR(VFS_I(ip)->i_mode)) ||
+	    VFS_I(ip)->i_generation != sc->sm->sm_gen) {
 		xchk_irele(sc, ip);
 		return -ENOENT;
 	}
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 6c889c21ddec..e9225536dc65 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -400,6 +400,16 @@ xrep_dinode_flags(
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		xfs_failaddr_t	fa;
+
+		fa = xfs_dinode_verify_metaflag(sc->mp, dip, mode, flags,
+				flags2);
+		if (fa)
+			flags2 &= ~XFS_DIFLAG2_METADATA;
+	}
+
 	dip->di_flags = cpu_to_be16(flags);
 	dip->di_flags2 = cpu_to_be64(flags2);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index bccdaf51cd67..fc11ae6eae0b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -931,6 +931,8 @@ xfs_imeta_iget(
 		goto bad_rele;
 	if (xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype)
 		goto bad_rele;
+	if (xfs_has_metadir(mp) && !xfs_is_metadata_inode(ip))
+		goto bad_rele;
 
 	*ipp = ip;
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 83127fed2b10..2c140c6d51e7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -572,8 +572,19 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
+	/*
+	 * Make sure that a corrupt directory cannot accidentally link to a
+	 * metadata file.
+	 */
+	if (XFS_IS_CORRUPT(dp->i_mount, xfs_is_metadata_inode(*ipp))) {
+		error = -EFSCORRUPTED;
+		goto out_irele;
+	}
+
 	return 0;
 
+out_irele:
+	xfs_irele(*ipp);
 out_free_name:
 	if (ci_name)
 		kmem_free(ci_name->name);
@@ -2714,6 +2725,8 @@ void
 xfs_imeta_irele(
 	struct xfs_inode	*ip)
 {
+	ASSERT(!xfs_has_metadir(ip->i_mount) || xfs_is_metadata_inode(ip));
+
 	xfs_irele(ip);
 }
 

