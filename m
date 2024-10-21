Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541A71E47CE;
	Mon, 21 Oct 2024 10:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506932; cv=none; b=IBzQCXH37Dh87bCc8HE1NcOXPert1Valsj68fUgv6SIIJu+dSfho7EU4urBtxWeKkneYqwVEQwApe1Ax7uRmrNOSIU9MYZ03OwsWh1TluMlMGlp5N15z5W9mJ1iH05+DZbfNib/jIoQmtbU6jCzLA86hSxivaBVN+fDQILFAdN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506932; c=relaxed/simple;
	bh=yVumYYI/GQ2r0v4B3tFRJNQWjfD4NPCDhranD7Cwf/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PegF+fIZ5ig8lW3D6zdOoMNhnygqSsgoz6Na8uomp8DiCs5U+QUSIvmdrwFOKjDe/7C72V0m0qFDKLlzyqWZqJ2wfmDYwfNzSzN91fL2/DrbkwmXswPy4ijt6Naoej1kLXTKx1/ceNnmik797uMLsKD/BubAovTVF9PW3jJhY3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ln6WlpTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ln6WlpTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FB3C4CEC3;
	Mon, 21 Oct 2024 10:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506932;
	bh=yVumYYI/GQ2r0v4B3tFRJNQWjfD4NPCDhranD7Cwf/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ln6WlpTaSHYutiFBpEYcr4a3T/K9l7cyw9Lj+MEUMf8SxGzYKmRjLKOOo4ywfsnQO
	 upbglT9/UCRdQbPtWUI/dVE4FkpazuclGQM1E2GJY6ZsjGwCTBi751+nkuuvBNf7Mt
	 fhTdKFk4oAtxuDLp1bFh6aOhFjFs/IH6MsUvwngY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 034/124] xfs: use dontcache for grabbing inodes during scrub
Date: Mon, 21 Oct 2024 12:23:58 +0200
Message-ID: <20241021102258.047180264@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit b27ce0da60a523fc32e3795f96b2de5490642235 upstream.

[backport: resolve conflict due to missing iscan.c]

Back when I wrote commit a03297a0ca9f2, I had thought that we'd be doing
users a favor by only marking inodes dontcache at the end of a scrub
operation, and only if there's only one reference to that inode.  This
was more or less true back when I_DONTCACHE was an XFS iflag and the
only thing it did was change the outcome of xfs_fs_drop_inode to 1.

Note: If there are dentries pointing to the inode when scrub finishes,
the inode will have positive i_count and stay around in cache until
dentry reclaim.

But now we have d_mark_dontcache, which cause the inode *and* the
dentries attached to it all to be marked I_DONTCACHE, which means that
we drop the dentries ASAP, which drops the inode ASAP.

This is bad if scrub found problems with the inode, because now they can
be scheduled for inactivation, which can cause inodegc to trip on it and
shut down the filesystem.

Even if the inode isn't bad, this is still suboptimal because phases 3-7
each initiate inode scans.  Dropping the inode immediately during phase
3 is silly because phase 5 will reload it and drop it immediately, etc.
It's fine to mark the inodes dontcache, but if there have been accesses
to the file that set up dentries, we should keep them.

I validated this by setting up ftrace to capture xfs_iget_recycle*
tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
30 seconds.

Therefore, grab the inode with XFS_IGET_DONTCACHE, which only has the
effect of setting I_DONTCACHE for cache misses.  Remove the
d_mark_dontcache call that can happen in xchk_irele.

Fixes: a03297a0ca9f2 ("xfs: manage inode DONTCACHE status at irele time")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/common.c |   12 +++---------
 fs/xfs/scrub/scrub.h  |    7 +++++++
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -735,7 +735,7 @@ xchk_iget(
 {
 	ASSERT(sc->tp != NULL);
 
-	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
+	return xfs_iget(sc->mp, sc->tp, inum, XCHK_IGET_FLAGS, 0, ipp);
 }
 
 /*
@@ -786,8 +786,8 @@ again:
 	if (error)
 		return error;
 
-	error = xfs_iget(mp, tp, inum,
-			XFS_IGET_NORETRY | XFS_IGET_UNTRUSTED, 0, ipp);
+	error = xfs_iget(mp, tp, inum, XFS_IGET_NORETRY | XCHK_IGET_FLAGS, 0,
+			ipp);
 	if (error == -EAGAIN) {
 		/*
 		 * The inode may be in core but temporarily unavailable and may
@@ -994,12 +994,6 @@ xchk_irele(
 		spin_lock(&VFS_I(ip)->i_lock);
 		VFS_I(ip)->i_state &= ~I_DONTCACHE;
 		spin_unlock(&VFS_I(ip)->i_lock);
-	} else if (atomic_read(&VFS_I(ip)->i_count) == 1) {
-		/*
-		 * If this is the last reference to the inode and the caller
-		 * permits it, set DONTCACHE to avoid thrashing.
-		 */
-		d_mark_dontcache(VFS_I(ip));
 	}
 
 	xfs_irele(ip);
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -17,6 +17,13 @@ struct xfs_scrub;
 #define XCHK_GFP_FLAGS	((__force gfp_t)(GFP_KERNEL | __GFP_NOWARN | \
 					 __GFP_RETRY_MAYFAIL))
 
+/*
+ * For opening files by handle for fsck operations, we don't trust the inumber
+ * or the allocation state; therefore, perform an untrusted lookup.  We don't
+ * want these inodes to pollute the cache, so mark them for immediate removal.
+ */
+#define XCHK_IGET_FLAGS	(XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE)
+
 /* Type info and names for the scrub types. */
 enum xchk_type {
 	ST_NONE = 1,	/* disabled */


