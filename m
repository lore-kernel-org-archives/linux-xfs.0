Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B7885278
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817413; cv=none; b=aMkjFBSTqDLY//X65SjbArc5PucC8CXj1OgqO+nQ5o5E/IuNfbfYD8uORu0X4HdweqKY92L+9BlPHVJQ7Ndi0KsNmaJOvvZNOWLZkNJTxeQFbTripDBVGBK3ZgrheYo2gjbpwli2GKydKMdCEyWlsd8wA4GeVWeWMd5/y18BUgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817413; c=relaxed/simple;
	bh=eTCiqeMaDoKjhmfVX3L3Z9m4L3GsRIjSnzoagfYjbW4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdbbjIAYbpj/W+Gtn6H13/rk0YCx+lhDJ4QKnq08RsW+CFbASeCSE5BvXuj5wE1FeqbIa0U4j2HidTGsLwm42c528XOtH5rSCqqoHZJ9jcedF0+bNh/mLnUSy23Xtz3R0Xrsd2XpeGcFbmW8As9iB4KswnLs4HIDZDmtliicfVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1KqBIDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1KqBIDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C524C433F1;
	Thu,  1 Feb 2024 19:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817412;
	bh=eTCiqeMaDoKjhmfVX3L3Z9m4L3GsRIjSnzoagfYjbW4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U1KqBIDQxt+b7A+df4vkpXyFzQiih4swekrNugJpaH6kR7eA5qQd04Ss1cAjIwlAK
	 BoZtFaKcxnL7nnBdManwtn4v4Aolki4ef8AyoJKuCurJfh0YBKUusdAVEzdFf5YscD
	 raQ8Ytjm7BXbFn53oh+3ZbCV2DL7edhrk958l3Z7tZAsgsdk9J2A0yB75BR1NvPCY2
	 cmZ8dTW5GpR4kclAfuepwhtOFVG6SvnlEwozPyMnWwYh6qQDnf8+ux9x8aYfYMUueS
	 xwksocKnf+bxvICSQabDmj+tCeMlWb36LsmArxuNVkDHYD7jpDro5BVijeiw+ttb/D
	 gorBUJC+LH5FQ==
Date: Thu, 01 Feb 2024 11:56:52 -0800
Subject: [PATCH 2/4] xfs: remove the xfs_buftarg_t typedef
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336565.1608248.8421408023169114803.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
References: <170681336524.1608248.13038535665701540297.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Switch the few remaining holdouts to the struct version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c   |    6 +++---
 fs/xfs/xfs_buf.h   |    4 ++--
 fs/xfs/xfs_log.c   |   14 +++++++-------
 fs/xfs/xfs_mount.h |    6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ebaf630182530..57dd2c2471b18 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1974,7 +1974,7 @@ xfs_free_buftarg(
 
 int
 xfs_setsize_buftarg(
-	xfs_buftarg_t		*btp,
+	struct xfs_buftarg	*btp,
 	unsigned int		sectorsize)
 {
 	/* Set up metadata sector size info */
@@ -2002,7 +2002,7 @@ xfs_setsize_buftarg(
  */
 STATIC int
 xfs_setsize_buftarg_early(
-	xfs_buftarg_t		*btp)
+	struct xfs_buftarg	*btp)
 {
 	return xfs_setsize_buftarg(btp, bdev_logical_block_size(btp->bt_bdev));
 }
@@ -2012,7 +2012,7 @@ xfs_alloc_buftarg(
 	struct xfs_mount	*mp,
 	struct bdev_handle	*bdev_handle)
 {
-	xfs_buftarg_t		*btp;
+	struct xfs_buftarg	*btp;
 	const struct dax_holder_operations *ops = NULL;
 
 #if defined(CONFIG_FS_DAX) && defined(CONFIG_MEMORY_FAILURE)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b470de08a46ca..b9216dee7810c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -96,7 +96,7 @@ typedef unsigned int xfs_buf_flags_t;
  * The latter is derived from the underlying device, and controls direct IO
  * alignment constraints.
  */
-typedef struct xfs_buftarg {
+struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct bdev_handle	*bt_bdev_handle;
 	struct block_device	*bt_bdev;
@@ -114,7 +114,7 @@ typedef struct xfs_buftarg {
 
 	struct percpu_counter	bt_io_count;
 	struct ratelimit_state	bt_ioerror_rl;
-} xfs_buftarg_t;
+};
 
 #define XB_PAGES	2
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a1650fc81382f..a5f92e362a248 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -633,14 +633,14 @@ xlog_state_release_iclog(
  */
 int
 xfs_log_mount(
-	xfs_mount_t	*mp,
-	xfs_buftarg_t	*log_target,
-	xfs_daddr_t	blk_offset,
-	int		num_bblks)
+	xfs_mount_t		*mp,
+	struct xfs_buftarg	*log_target,
+	xfs_daddr_t		blk_offset,
+	int			num_bblks)
 {
-	struct xlog	*log;
-	int		error = 0;
-	int		min_logfsbs;
+	struct xlog		*log;
+	int			error = 0;
+	int			min_logfsbs;
 
 	if (!xfs_has_norecovery(mp)) {
 		xfs_notice(mp, "Mounting V%d Filesystem %pU",
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e86dfe67894fb..6c44e6db4d862 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -94,9 +94,9 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
-	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
-	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
-	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
+	struct xfs_buftarg	*m_ddev_targp;	/* data device */
+	struct xfs_buftarg	*m_logdev_targp;/* log device */
+	struct xfs_buftarg	*m_rtdev_targp;	/* rt device */
 	void __percpu		*m_inodegc;	/* percpu inodegc structures */
 
 	/*

