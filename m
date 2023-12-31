Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077B2BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6LbD7+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C840DC433C7;
	Sun, 31 Dec 2023 21:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056445;
	bh=iku2M6TWjzbwmk5lajO1Ofqfb2KvBBjJyAy636araTE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u6LbD7+ursTbYYcGE98Z6JKPCyniHSy2RsVaJIHIqC9cdvCOnsT/mC7oJ7P0ij42K
	 8xOTXmYkd3QR+b+iKPe8/4RCSXDzCv80BFTI0JYMtdXWBNqbICP8n3pnTxJzN7eraQ
	 sKWXS3PS12TT6yPJRzVXgXpZoeUV/AvMhW36B4phXJn0ZrR8YVS7D22F6IsTrkOYXy
	 3cdVvVME3RmYqNcIGWecHp9pEGCvpJa5LLtl/3coiE/za5XXTRxQaNuTWVIueGxJTs
	 +3xN5RLY+lbJ/nZLtaUriK4U18EuD69D6+x97iwMSe9g9sFwzfo0usdmqpUwGIcgiL
	 NO++8PksEhcXQ==
Date: Sun, 31 Dec 2023 13:00:45 -0800
Subject: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842912.1758126.5295850690380079776.stgit@frogsfrogsfrogs>
In-Reply-To: <170404842857.1758126.13889834380054922462.stgit@frogsfrogsfrogs>
References: <170404842857.1758126.13889834380054922462.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/scrub.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1a0018537b054..7b70dfb30287b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -764,6 +764,31 @@ xfs_scrubv_previous_failures(
 	return false;
 }
 
+/*
+ * If the caller provided us with a nonzero inode number that isn't the ioctl
+ * file, try to grab a reference to it to eliminate all further untrusted inode
+ * lookups.  If we can't get the inode, let each scrub function try again.
+ */
+STATIC struct xfs_inode *
+xchk_scrubv_open_by_handle(
+	struct xfs_mount		*mp,
+	const struct xfs_scrub_vec_head	*vhead)
+{
+	struct xfs_inode		*ip;
+	int				error;
+
+	error = xfs_iget(mp, NULL, vhead->svh_ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error)
+		return NULL;
+
+	if (VFS_I(ip)->i_generation != vhead->svh_gen) {
+		xfs_irele(ip);
+		return NULL;
+	}
+
+	return ip;
+}
+
 /* Vectored scrub implementation to reduce ioctl calls. */
 int
 xfs_scrubv_metadata(
@@ -772,7 +797,9 @@ xfs_scrubv_metadata(
 {
 	struct xfs_inode		*ip_in = XFS_I(file_inode(file));
 	struct xfs_mount		*mp = ip_in->i_mount;
+	struct xfs_inode		*handle_ip = NULL;
 	struct xfs_scrub_vec		*v;
+	bool				set_dontcache = false;
 	unsigned int			i;
 	int				error = 0;
 
@@ -791,9 +818,28 @@ xfs_scrubv_metadata(
 		    (v->sv_flags & ~XFS_SCRUB_FLAGS_OUT))
 			return -EINVAL;
 
+		/*
+		 * If we detect at least one inode-type scrub, we might
+		 * consider setting dontcache at the end.
+		 */
+		if (v->sv_type < XFS_SCRUB_TYPE_NR &&
+		    meta_scrub_ops[v->sv_type].type == ST_INODE)
+			set_dontcache = true;
+
 		trace_xchk_scrubv_item(mp, vhead, v);
 	}
 
+	/*
+	 * If the caller wants us to do a scrub-by-handle and the file used to
+	 * call the ioctl is not the same file, load the incore inode and pin
+	 * it across all the scrubv actions to avoid repeated UNTRUSTED
+	 * lookups.  The reference is not passed to deeper layers of scrub
+	 * because each scrubber gets to decide its own strategy for getting an
+	 * inode.
+	 */
+	if (vhead->svh_ino && vhead->svh_ino != ip_in->i_ino)
+		handle_ip = xchk_scrubv_open_by_handle(mp, vhead);
+
 	/* Run all the scrubbers. */
 	for (i = 0, v = vhead->svh_vecs; i < vhead->svh_nr; i++, v++) {
 		struct xfs_scrub_metadata	sm = {
@@ -817,6 +863,10 @@ xfs_scrubv_metadata(
 		v->sv_ret = xfs_scrub_metadata(file, &sm);
 		v->sv_flags = sm.sm_flags;
 
+		/* Leave the inode in memory if something's wrong with it. */
+		if (xchk_needs_repair(&sm))
+			set_dontcache = false;
+
 		if (vhead->svh_rest_us) {
 			ktime_t		expires;
 
@@ -831,5 +881,16 @@ xfs_scrubv_metadata(
 		}
 	}
 
+	/*
+	 * If we're holding the only reference to an inode opened via handle
+	 * and the scan was clean, mark it dontcache so that we don't pollute
+	 * the cache.
+	 */
+	if (handle_ip) {
+		if (set_dontcache &&
+		    atomic_read(&VFS_I(handle_ip)->i_count) == 1)
+			d_mark_dontcache(VFS_I(handle_ip));
+		xfs_irele(handle_ip);
+	}
 	return error;
 }

