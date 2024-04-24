Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B18627C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929326; cv=none; b=lBX4KUgclekJ911IpGtliVtE8ZSG7w0KiyFpIBnnUvNiqB2k71oZZELrDp5AMlfPsRWGuGCtlZ1Vsqi4B9UH8we67sovMrOOPXKMJ7bYOIIBu8C3BJCmlhorbguYdA3Q+VsAFVhPg2yNt5ZSGOHziVDZzUOoLzhD2PNRGS68neg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929326; c=relaxed/simple;
	bh=v0KzAMBL1jK/aezzc+Q9kWrMLjJoEVjNIFljOfrmzOc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agspsJtqkayk0F+ox+WRdTLtmR4L3/UQF92l/5UdDOW5Gbp9pVcWNUNxhy3yU7PerKX4CYiRfg9e3Q3TdQxdQ0KTb8SIx4DZz3HQe2rCBBJqunoyihXFBloywcqicMAVBLKe4uZ0Wld059VzID32jac8qCZZoBQy7GXYvim+OWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5fnqbRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5fnqbRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62070C116B1;
	Wed, 24 Apr 2024 03:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929326;
	bh=v0KzAMBL1jK/aezzc+Q9kWrMLjJoEVjNIFljOfrmzOc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B5fnqbRqO7VEVxsnsIywH8mqE17djRvgg3fwasljkT8VXkh1LETaH7caW9W7C07wH
	 N3htGOiWpvWEuWUZoSWY1dgUangZmXjjmeBa+7ulBu0sTlVTr6hYmdtp29RO1nn3/i
	 h+Ta2fgS3lNbqVfTnCV9fzdLzgiI/dMrbirb0+7O38SPtNq4ywsC//hTp3z4e0DTfH
	 vE+BOyslswv2P3V7QdDJOigMhgg5CxRtxIouLNDGe7Ko0WZPXIO8evijfVg/NSi5sa
	 c95viQ6FQzM1vCtzDXQ8313CLINOp12DGMSQe71YtbFBRGo96O71Pu4HzoaxnjLS3q
	 7gVD6d+aVbF3g==
Date: Tue, 23 Apr 2024 20:28:45 -0700
Subject: [PATCH 2/2] xfs: only iget the file once when doing vectored
 scrub-by-handle
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786065.1907355.5679414563891460560.stgit@frogsfrogsfrogs>
In-Reply-To: <171392786026.1907355.15363148011407104351.stgit@frogsfrogsfrogs>
References: <171392786026.1907355.15363148011407104351.stgit@frogsfrogsfrogs>
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

If a program wants us to perform a scrub on a file handle and the fd
passed to ioctl() is not the file referenced in the handle, iget the
file once and pass it into the scrub code.  This amortizes the untrusted
iget lookup over /all/ the scrubbers mentioned in the scrubv call.

When running fstests in "rebuild all metadata after each test" mode, I
observed a 10% reduction in runtime on account of avoiding repeated
inobt lookups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/scrub.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 78b00ab85c9c..43af5ce1f99f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -792,6 +792,37 @@ xfs_scrubv_check_barrier(
 	return 0;
 }
 
+/*
+ * If the caller provided us with a nonzero inode number that isn't the ioctl
+ * file, try to grab a reference to it to eliminate all further untrusted inode
+ * lookups.  If we can't get the inode, let each scrub function try again.
+ */
+STATIC struct xfs_inode *
+xchk_scrubv_open_by_handle(
+	struct xfs_mount		*mp,
+	const struct xfs_scrub_vec_head	*head)
+{
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+	int				error;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return NULL;
+
+	error = xfs_iget(mp, tp, head->svh_ino, XCHK_IGET_FLAGS, 0, &ip);
+	xfs_trans_cancel(tp);
+	if (error)
+		return NULL;
+
+	if (VFS_I(ip)->i_generation != head->svh_gen) {
+		xfs_irele(ip);
+		return NULL;
+	}
+
+	return ip;
+}
+
 /* Vectored scrub implementation to reduce ioctl calls. */
 int
 xfs_ioc_scrubv_metadata(
@@ -804,6 +835,7 @@ xfs_ioc_scrubv_metadata(
 	struct xfs_scrub_vec		__user *uvectors;
 	struct xfs_inode		*ip_in = XFS_I(file_inode(file));
 	struct xfs_mount		*mp = ip_in->i_mount;
+	struct xfs_inode		*handle_ip = NULL;
 	struct xfs_scrub_vec		*v;
 	size_t				vec_bytes;
 	unsigned int			i;
@@ -848,6 +880,17 @@ xfs_ioc_scrubv_metadata(
 		trace_xchk_scrubv_item(mp, &head, i, v);
 	}
 
+	/*
+	 * If the caller wants us to do a scrub-by-handle and the file used to
+	 * call the ioctl is not the same file, load the incore inode and pin
+	 * it across all the scrubv actions to avoid repeated UNTRUSTED
+	 * lookups.  The reference is not passed to deeper layers of scrub
+	 * because each scrubber gets to decide its own strategy and return
+	 * values for getting an inode.
+	 */
+	if (head.svh_ino && head.svh_ino != ip_in->i_ino)
+		handle_ip = xchk_scrubv_open_by_handle(mp, &head);
+
 	/* Run all the scrubbers. */
 	for (i = 0, v = vectors; i < head.svh_nr; i++, v++) {
 		struct xfs_scrub_metadata	sm = {
@@ -895,6 +938,8 @@ xfs_ioc_scrubv_metadata(
 	}
 
 out_free:
+	if (handle_ip)
+		xfs_irele(handle_ip);
 	kfree(vectors);
 	return error;
 }

