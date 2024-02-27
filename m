Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0C18836
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000905; cv=none; b=YI4E4GWPCV6dbCKfKOyRqcDwHGVgPa0pkm5YNCYf4e5C1xTv4iSXssC3kFEfvAiGTYySVoRlcxY04BNw+YHJzrhertpkAa9fsjZURYtMtrqeagf5lQee4NOmnYF2cEojIRAfmkV+ZArvLxcfVsuYDaBMPlDTTTCwE6OXtuTw0eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000905; c=relaxed/simple;
	bh=LOMqt3F5/M1UH00aMeA2YkVnmfq6sGXEoy06kYBVoEs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8ofJQSOpt1KuDSHmZaHVJ5n2VvrGgAxya4gCasTQ1amtcczgIRE0ZayRI/ZTeyeKHT+7tEdRzheeVbPg+IpAih+o8uIvpjy1UrdXbUNWdFxqJnHNCS/9n1HGBgtDa+efMyk9/kb3UlKS0+UgErhTAl4xEysN+8ZG7Bde39GJ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahzLZJdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahzLZJdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A98C433C7;
	Tue, 27 Feb 2024 02:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000905;
	bh=LOMqt3F5/M1UH00aMeA2YkVnmfq6sGXEoy06kYBVoEs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ahzLZJdQP90OGShCjD/x7FrEcraMNYcPU6eqCq0UC6VjjDFWAXipQf5vJw25JuV18
	 El0P9RuuutEdqjSb/5NBigNlzhWGamSWEP0szp6yuZ6iXrYBvQ1dQXg5zIQMhEwTBV
	 eM/R8JLmpiMuH7/8dCU6T4P4bHR1Yre1dKWBhYhHh4u3v4ae7uGSt/ystnLfUIdQ9S
	 g1gCwd595mU/Rik7AwvCD6mnIRJOZKjv/kaZLnKMKrxnU7I2+N0pO3GuV+EI2lJPYv
	 uFMDK7sUiHtBh8/WYnjivdpYj29Y8IEECgJyw40qoOofTWtF2rH+0sVD76d+vNALnK
	 f9lCAhJUmVWzg==
Date: Mon, 26 Feb 2024 18:28:25 -0800
Subject: [PATCH 8/9] xfs: validate explicit directory block buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013227.938940.2647775527419976410.stgit@frogsfrogsfrogs>
In-Reply-To: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
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

Port the existing directory block header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.h       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c |   22 ++++++++++++++--------
 fs/xfs/libxfs/xfs_dir2_priv.h  |    2 +-
 fs/xfs/libxfs/xfs_exchmaps.c   |    2 +-
 fs/xfs/scrub/dir.c             |    2 +-
 fs/xfs/scrub/readdir.c         |    2 +-
 fs/xfs/xfs_dir2_readdir.c      |    2 +-
 7 files changed, 20 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d623bfdcd4218..eb3a5c35025b5 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -103,6 +103,7 @@ extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_block_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 467d73dfc0037..76b7ac3306dbb 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -115,18 +115,23 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.verify_struct = xfs_dir3_block_verify,
 };
 
-static xfs_failaddr_t
+xfs_failaddr_t
 xfs_dir3_block_header_check(
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
 {
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
+		ASSERT(hdr3->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+
+		if (be64_to_cpu(hdr3->owner) != owner) {
+			xfs_err(NULL, "dir block owner 0x%llx doesnt match block 0x%llx", owner, be64_to_cpu(hdr3->owner));
+			dump_stack();
 			return __this_address;
+		}
 	}
 
 	return NULL;
@@ -136,6 +141,7 @@ int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -148,7 +154,7 @@ xfs_dir3_block_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_block_header_check(dp, *bpp);
+	fa = xfs_dir3_block_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -383,7 +389,7 @@ xfs_dir2_block_addname(
 	tp = args->trans;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
@@ -698,7 +704,7 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 879aa2e9fd730..969e36a03fe5e 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -51,7 +51,7 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 
 /* xfs_dir2_block.c */
 extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			       struct xfs_buf **bpp);
+			       xfs_ino_t owner, struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index ab7a9cd3e94a9..7502cb872aba2 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -476,7 +476,7 @@ xfs_exchmaps_dir_to_sf(
 	if (!isblock)
 		return 0;
 
-	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, &bp);
+	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 6b572196bb43d..43f5bc8ce0d46 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -315,7 +315,7 @@ xchk_directory_data_bestfree(
 		/* dir block format */
 		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
-		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
+		error = xfs_dir3_block_read(sc->tp, sc->ip, sc->ip->i_ino, &bp);
 	} else {
 		/* dir data format */
 		error = xfs_dir3_data_read(sc->tp, sc->ip, sc->ip->i_ino, lblk,
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 734e4845a0351..3edb0bedc0cc0 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -99,7 +99,7 @@ xchk_dir_walk_block(
 	unsigned int		off, next_off, end;
 	int			error;
 
-	error = xfs_dir3_block_read(sc->tp, dp, &bp);
+	error = xfs_dir3_block_read(sc->tp, dp, dp->i_ino, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 233f6d5259ce2..59e1b88ffc2c0 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -157,7 +157,7 @@ xfs_dir2_block_getdents(
 	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
-	error = xfs_dir3_block_read(args->trans, dp, &bp);
+	error = xfs_dir3_block_read(args->trans, dp, args->owner, &bp);
 	if (error)
 		return error;
 

