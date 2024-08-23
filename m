Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E114B653
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372236; cv=none; b=KZijqsHLZesHo+bJdbNfjyZ+xjd7FGxamVmDYYFXG31It4odPpXYmMTQYp9o2R04oSh/EbcvefEG+kKGw7/CujJOslf4L/rfWc9tTGrvPanpuWX68yzVtGCsBrjijHFDmX3IG6rQFXvs0KZfKGz06UVhbu8K0wZe78wJaW2z0Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372236; c=relaxed/simple;
	bh=W/y3KxVD8ILShj7mNzn100m/2uBdtfqtMKl9cG+WcSo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsnQACuEGiCy9MS0O8/UHA9ipn2oDbOkk1huwUbXJDsTrkQ6Z1q9aDBAk+OJWN1QhXoF2KyVW0adSGSye6QO8jxGzw8q+yCKgi3gfXC8vC0mP8SaHV6IHRU/xrhjyRusv5dKRD6zuNgL53S4TaYWxtoouED2sLMvMAhrPG2KuBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igVu4el5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igVu4el5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393A4C32782;
	Fri, 23 Aug 2024 00:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372236;
	bh=W/y3KxVD8ILShj7mNzn100m/2uBdtfqtMKl9cG+WcSo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=igVu4el5pl4+rnfr7SbOWlT8b+h+pnEf9cB1ckUTnlJFY7sNQUw/jkkoLPvL6XOMw
	 xa3eUTcWDzjtGXciqqOGR/SBIIrUjrvvQe7MHViFPuluBkBaG8AhB8owE8gigWCJu1
	 IBBFgkTeH4t29THiqC25w1hYGzlXoaWwsqmokF7a0lT47yFNLQMlSyMEBLLGYZiYBq
	 NWTK4a7OT43M4hztqCTjT04L2kcXXrOy7bEF/x+XB0zcr07M6Gf62rk9nwVnVnCWVZ
	 BBYdrII4R2XEGuxRL48wTZeBiU87MXY8ancV7t9zd3LWPwBl0fTLapwgql4gSbYe9W
	 2TS+8XymstA+A==
Date: Thu, 22 Aug 2024 17:17:15 -0700
Subject: [PATCH 10/24] xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087416.59588.14421297568216399851.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_fsmap.c |  134 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fsmap.h |    6 +-
 fs/xfs/xfs_ioctl.c |  130 --------------------------------------------------
 3 files changed, 134 insertions(+), 136 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 615253406fde1..ae18ab86e608b 100644
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
index a0775788e7b13..a0bcc38486a56 100644
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
index b53af3e674912..461780ffb8fc0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -883,136 +883,6 @@ xfs_ioc_getbmap(
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

