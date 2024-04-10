Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AC5A55
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711350; cv=none; b=l05tHEo324KCi/qUDqRmm96gmMYBU0JYjJA9X1JRPJqgeccwZSRrgNJFmTpZ3wLrCd22M2NHEr8bDrwlfBcLS5XW9oWIrMJ6vxBItru5lJ4m+QSFzKpr58oKsE0/ebGzPzV8HoBk7kNPXRYUShuWVF/pVYBqLgDtzvmQqVgRE9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711350; c=relaxed/simple;
	bh=sen0UDeZGYs3CDXqBpwJ3ey8rVUvjhV/kbkrkVT6+MA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fvXlXRlsg7p6TrIVDhKBfFdk/mqk1d+pqJkj04fM9urfZWPcqxHhYrBKD3BVBC5SOMOMpJHwTWrdW1mPefGCaQHIvb5IR3eY4aDLvds0rrl6ITGPWdnLvNOniwZTeTaWd/jBW4/PKvzZ6lwaOfS33Yw0o0iYCJsgWFRQ0CybiRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACtDtVAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACtDtVAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CB9C433C7;
	Wed, 10 Apr 2024 01:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711350;
	bh=sen0UDeZGYs3CDXqBpwJ3ey8rVUvjhV/kbkrkVT6+MA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ACtDtVAURjfWkJbhfcFsW5dEhxiaJSoOFc6yszIVrFCds3lhrRqBRr3zewypVVjHa
	 sKzzOR4NTOLoRpYIiJ4ZzwQIxlLuwjN+AiBT+W5ZEV7yWiD3e9H4bxjZyIhr557O7c
	 Dtme3qRy1i9Aotkzt9iMTliIoffN/455qV7OOIaqCF9DKm6V0l9D8pfSvyWzzBaMIL
	 S+0JNohIAss77TTT1AXurLCwGVScqWjvobvd8IFTbO6BOfIoW0Qz5/b1CMfRACgyb7
	 ZVykdysiEtdM1P6aPBL42ivGL7ne11jVPrbN6OZ+/hp8lYNAl7WtcteAx5N/WMjx7I
	 c3UCTBjK4G3og==
Date: Tue, 09 Apr 2024 18:09:09 -0700
Subject: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
In-Reply-To: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
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
index cab34823f3c91..f1a17f986b6cf 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -761,6 +761,31 @@ xfs_scrubv_previous_failures(
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
@@ -769,7 +794,9 @@ xfs_scrubv_metadata(
 {
 	struct xfs_inode		*ip_in = XFS_I(file_inode(file));
 	struct xfs_mount		*mp = ip_in->i_mount;
+	struct xfs_inode		*handle_ip = NULL;
 	struct xfs_scrub_vec		*v;
+	bool				set_dontcache = false;
 	unsigned int			i;
 	int				error = 0;
 
@@ -788,9 +815,28 @@ xfs_scrubv_metadata(
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
@@ -814,6 +860,10 @@ xfs_scrubv_metadata(
 		v->sv_ret = xfs_scrub_metadata(file, &sm);
 		v->sv_flags = sm.sm_flags;
 
+		/* Leave the inode in memory if something's wrong with it. */
+		if (xchk_needs_repair(&sm))
+			set_dontcache = false;
+
 		if (vhead->svh_rest_us) {
 			ktime_t		expires;
 
@@ -828,5 +878,16 @@ xfs_scrubv_metadata(
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

