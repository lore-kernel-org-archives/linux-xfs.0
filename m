Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1287519CC04
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301936; cv=none; b=oJx+g5BSDGfNdcfIJxbpVXeST7JlTNGEpo+2S75cbFzWr37Mqfd4EJIQW81ylYxZi8srD2i7vy2jLrZEo7FxAQY1U17lqVG0uoASYzp9aa71AIkuRmw/8dI108FGfI+72w8zpgZXo6UisMQM7qQMS+3twStWjrYA6TphMeGZE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301936; c=relaxed/simple;
	bh=haRgdh+s5nTLR6J5ufLuRVIb/UuwCX2+mg1WZoh6/aE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPKIZVi4oQzWJLxg7TLZDzW6mJfYaOUORbgKCU/j1u7UaqjXD/lbjfZoWCG15fsik636du+mUVD3gW8dzfbYMY5gD9R/nh3lUW5wdKWls7Yit9dzUA+D3Mv1v5Hpu3CALxGigKjsjl2V0Bxdp1YKIXUbtiW7oAbnQRUhbJO01J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZmFNina; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZmFNina"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8968EC4CEC2;
	Mon,  2 Sep 2024 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301935;
	bh=haRgdh+s5nTLR6J5ufLuRVIb/UuwCX2+mg1WZoh6/aE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FZmFNinabrW8F5cgIXXEW12kbuePULO0awYfkoi0irMA5XfuBOFciA5xq2tEQ8yJs
	 lbeXtckiXPFuvpbBzw8M1I1Ybq4dIm8wMAXZKPApV0JOIfKlu9/IdHvuJBSoNnmhi4
	 480oj2yyRM7aWSvEoc0u+R8+lDi6c+FjozxwX9DeuyQErqwo8/849itqY2sQ+6FOPU
	 zDbafWQr/ZEmCJuSLmqFrah5panJ/PzXtniAIR7mm+n56pbiA57Ju1cQnar9CE8tWb
	 /+BMNaxPVXqRhPbnKaH9i57e6JJr9ZeosJ23UGeKZJOESSe2qjXiiI8EGnGgWZ1ivA
	 suIgQtzt88Tww==
Date: Mon, 02 Sep 2024 11:32:15 -0700
Subject: [PATCH 10/10] xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106930.3326080.442944321188284872.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
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

Move this function out of xfs_ioctl.c to reduce the clutter in there,
and make the entire getfsmap implementation self-contained in a single
file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsmap.c |  134 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fsmap.h |    6 +-
 fs/xfs/xfs_ioctl.c |  130 --------------------------------------------------
 3 files changed, 134 insertions(+), 136 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 615253406fde..ae18ab86e608 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -44,7 +44,7 @@ xfs_fsmap_from_internal(
 }
 
 /* Convert an fsmap to an xfs_fsmap. */
-void
+static void
 xfs_fsmap_to_internal(
 	struct xfs_fsmap	*dest,
 	struct fsmap		*src)
@@ -889,7 +889,7 @@ xfs_getfsmap_check_keys(
  * xfs_getfsmap_info.low/high	-- per-AG low/high keys computed from
  *				   dkeys; used to query the metadata.
  */
-int
+STATIC int
 xfs_getfsmap(
 	struct xfs_mount		*mp,
 	struct xfs_fsmap_head		*head,
@@ -1019,3 +1019,133 @@ xfs_getfsmap(
 	head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }
+
+int
+xfs_ioc_getfsmap(
+	struct xfs_inode	*ip,
+	struct fsmap_head	__user *arg)
+{
+	struct xfs_fsmap_head	xhead = {0};
+	struct fsmap_head	head;
+	struct fsmap		*recs;
+	unsigned int		count;
+	__u32			last_flags = 0;
+	bool			done = false;
+	int			error;
+
+	if (copy_from_user(&head, arg, sizeof(struct fsmap_head)))
+		return -EFAULT;
+	if (memchr_inv(head.fmh_reserved, 0, sizeof(head.fmh_reserved)) ||
+	    memchr_inv(head.fmh_keys[0].fmr_reserved, 0,
+		       sizeof(head.fmh_keys[0].fmr_reserved)) ||
+	    memchr_inv(head.fmh_keys[1].fmr_reserved, 0,
+		       sizeof(head.fmh_keys[1].fmr_reserved)))
+		return -EINVAL;
+
+	/*
+	 * Use an internal memory buffer so that we don't have to copy fsmap
+	 * data to userspace while holding locks.  Start by trying to allocate
+	 * up to 128k for the buffer, but fall back to a single page if needed.
+	 */
+	count = min_t(unsigned int, head.fmh_count,
+			131072 / sizeof(struct fsmap));
+	recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
+	if (!recs) {
+		count = min_t(unsigned int, head.fmh_count,
+				PAGE_SIZE / sizeof(struct fsmap));
+		recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
+		if (!recs)
+			return -ENOMEM;
+	}
+
+	xhead.fmh_iflags = head.fmh_iflags;
+	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
+	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
+
+	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
+	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
+
+	head.fmh_entries = 0;
+	do {
+		struct fsmap __user	*user_recs;
+		struct fsmap		*last_rec;
+
+		user_recs = &arg->fmh_recs[head.fmh_entries];
+		xhead.fmh_entries = 0;
+		xhead.fmh_count = min_t(unsigned int, count,
+					head.fmh_count - head.fmh_entries);
+
+		/* Run query, record how many entries we got. */
+		error = xfs_getfsmap(ip->i_mount, &xhead, recs);
+		switch (error) {
+		case 0:
+			/*
+			 * There are no more records in the result set.  Copy
+			 * whatever we got to userspace and break out.
+			 */
+			done = true;
+			break;
+		case -ECANCELED:
+			/*
+			 * The internal memory buffer is full.  Copy whatever
+			 * records we got to userspace and go again if we have
+			 * not yet filled the userspace buffer.
+			 */
+			error = 0;
+			break;
+		default:
+			goto out_free;
+		}
+		head.fmh_entries += xhead.fmh_entries;
+		head.fmh_oflags = xhead.fmh_oflags;
+
+		/*
+		 * If the caller wanted a record count or there aren't any
+		 * new records to return, we're done.
+		 */
+		if (head.fmh_count == 0 || xhead.fmh_entries == 0)
+			break;
+
+		/* Copy all the records we got out to userspace. */
+		if (copy_to_user(user_recs, recs,
+				 xhead.fmh_entries * sizeof(struct fsmap))) {
+			error = -EFAULT;
+			goto out_free;
+		}
+
+		/* Remember the last record flags we copied to userspace. */
+		last_rec = &recs[xhead.fmh_entries - 1];
+		last_flags = last_rec->fmr_flags;
+
+		/* Set up the low key for the next iteration. */
+		xfs_fsmap_to_internal(&xhead.fmh_keys[0], last_rec);
+		trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
+	} while (!done && head.fmh_entries < head.fmh_count);
+
+	/*
+	 * If there are no more records in the query result set and we're not
+	 * in counting mode, mark the last record returned with the LAST flag.
+	 */
+	if (done && head.fmh_count > 0 && head.fmh_entries > 0) {
+		struct fsmap __user	*user_rec;
+
+		last_flags |= FMR_OF_LAST;
+		user_rec = &arg->fmh_recs[head.fmh_entries - 1];
+
+		if (copy_to_user(&user_rec->fmr_flags, &last_flags,
+					sizeof(last_flags))) {
+			error = -EFAULT;
+			goto out_free;
+		}
+	}
+
+	/* copy back header */
+	if (copy_to_user(arg, &head, sizeof(struct fsmap_head))) {
+		error = -EFAULT;
+		goto out_free;
+	}
+
+out_free:
+	kvfree(recs);
+	return error;
+}
diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
index a0775788e7b1..a0bcc38486a5 100644
--- a/fs/xfs/xfs_fsmap.h
+++ b/fs/xfs/xfs_fsmap.h
@@ -7,6 +7,7 @@
 #define __XFS_FSMAP_H__
 
 struct fsmap;
+struct fsmap_head;
 
 /* internal fsmap representation */
 struct xfs_fsmap {
@@ -27,9 +28,6 @@ struct xfs_fsmap_head {
 	struct xfs_fsmap fmh_keys[2];	/* low and high keys */
 };
 
-void xfs_fsmap_to_internal(struct xfs_fsmap *dest, struct fsmap *src);
-
-int xfs_getfsmap(struct xfs_mount *mp, struct xfs_fsmap_head *head,
-		struct fsmap *out_recs);
+int xfs_ioc_getfsmap(struct xfs_inode *ip, struct fsmap_head __user *arg);
 
 #endif /* __XFS_FSMAP_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 90b3ee21e7fe..7226d27e8afc 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -876,136 +876,6 @@ xfs_ioc_getbmap(
 	return error;
 }
 
-STATIC int
-xfs_ioc_getfsmap(
-	struct xfs_inode	*ip,
-	struct fsmap_head	__user *arg)
-{
-	struct xfs_fsmap_head	xhead = {0};
-	struct fsmap_head	head;
-	struct fsmap		*recs;
-	unsigned int		count;
-	__u32			last_flags = 0;
-	bool			done = false;
-	int			error;
-
-	if (copy_from_user(&head, arg, sizeof(struct fsmap_head)))
-		return -EFAULT;
-	if (memchr_inv(head.fmh_reserved, 0, sizeof(head.fmh_reserved)) ||
-	    memchr_inv(head.fmh_keys[0].fmr_reserved, 0,
-		       sizeof(head.fmh_keys[0].fmr_reserved)) ||
-	    memchr_inv(head.fmh_keys[1].fmr_reserved, 0,
-		       sizeof(head.fmh_keys[1].fmr_reserved)))
-		return -EINVAL;
-
-	/*
-	 * Use an internal memory buffer so that we don't have to copy fsmap
-	 * data to userspace while holding locks.  Start by trying to allocate
-	 * up to 128k for the buffer, but fall back to a single page if needed.
-	 */
-	count = min_t(unsigned int, head.fmh_count,
-			131072 / sizeof(struct fsmap));
-	recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
-	if (!recs) {
-		count = min_t(unsigned int, head.fmh_count,
-				PAGE_SIZE / sizeof(struct fsmap));
-		recs = kvcalloc(count, sizeof(struct fsmap), GFP_KERNEL);
-		if (!recs)
-			return -ENOMEM;
-	}
-
-	xhead.fmh_iflags = head.fmh_iflags;
-	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
-	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
-
-	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
-	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
-
-	head.fmh_entries = 0;
-	do {
-		struct fsmap __user	*user_recs;
-		struct fsmap		*last_rec;
-
-		user_recs = &arg->fmh_recs[head.fmh_entries];
-		xhead.fmh_entries = 0;
-		xhead.fmh_count = min_t(unsigned int, count,
-					head.fmh_count - head.fmh_entries);
-
-		/* Run query, record how many entries we got. */
-		error = xfs_getfsmap(ip->i_mount, &xhead, recs);
-		switch (error) {
-		case 0:
-			/*
-			 * There are no more records in the result set.  Copy
-			 * whatever we got to userspace and break out.
-			 */
-			done = true;
-			break;
-		case -ECANCELED:
-			/*
-			 * The internal memory buffer is full.  Copy whatever
-			 * records we got to userspace and go again if we have
-			 * not yet filled the userspace buffer.
-			 */
-			error = 0;
-			break;
-		default:
-			goto out_free;
-		}
-		head.fmh_entries += xhead.fmh_entries;
-		head.fmh_oflags = xhead.fmh_oflags;
-
-		/*
-		 * If the caller wanted a record count or there aren't any
-		 * new records to return, we're done.
-		 */
-		if (head.fmh_count == 0 || xhead.fmh_entries == 0)
-			break;
-
-		/* Copy all the records we got out to userspace. */
-		if (copy_to_user(user_recs, recs,
-				 xhead.fmh_entries * sizeof(struct fsmap))) {
-			error = -EFAULT;
-			goto out_free;
-		}
-
-		/* Remember the last record flags we copied to userspace. */
-		last_rec = &recs[xhead.fmh_entries - 1];
-		last_flags = last_rec->fmr_flags;
-
-		/* Set up the low key for the next iteration. */
-		xfs_fsmap_to_internal(&xhead.fmh_keys[0], last_rec);
-		trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
-	} while (!done && head.fmh_entries < head.fmh_count);
-
-	/*
-	 * If there are no more records in the query result set and we're not
-	 * in counting mode, mark the last record returned with the LAST flag.
-	 */
-	if (done && head.fmh_count > 0 && head.fmh_entries > 0) {
-		struct fsmap __user	*user_rec;
-
-		last_flags |= FMR_OF_LAST;
-		user_rec = &arg->fmh_recs[head.fmh_entries - 1];
-
-		if (copy_to_user(&user_rec->fmr_flags, &last_flags,
-					sizeof(last_flags))) {
-			error = -EFAULT;
-			goto out_free;
-		}
-	}
-
-	/* copy back header */
-	if (copy_to_user(arg, &head, sizeof(struct fsmap_head))) {
-		error = -EFAULT;
-		goto out_free;
-	}
-
-out_free:
-	kvfree(recs);
-	return error;
-}
-
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)

