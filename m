Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337481;
	b=BlK4XLk6L73T8GscO1xfHNL9iGpcPeGnPSukwVDkvExOV2ZzP2DS3jijNjYmMmCpEn32
	 mtyXnkd8fr39UL/4hzYLnxUdmHwn4EEM3s8Hcgii8SGIZuo44+dvM3Ttyk4KnUsRfky1U
	 AhJ1W3vuC4A+IUcuN8XxixcNVbHRjfTHIOkrVHb4+CzSsJnzYrllHlKpmFvRLmrofv9jl
	 fTfzCMy/3laT+KtCClm8ak387iW3pf+CJVGIot/Kii4gqDH547T9i3aoA/mxDKYxzrFb/
	 2LewaHUsayYTYR6jfWy8a54j4A0DJ3pjWmd3e9CYZciEs1d/ZsLsygOs4UoUQwxqN+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337481;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/+cIREyg0AGU7+zcF6+BlnbT1om/DZm0Kc0KnCIR9hU=;
	b=eOVoEB2ineKpAL8tKRbm/KgJ3yqbu3XjoRVzo87ZAv4DdyiMTsp1Gy+jgxoS8bhzc5/L
	 hCcfXv1U09tRBpgH95+Mp597NbHYJLzYnRgoXX4aLGA5FovqmcQKhhwuqFuhWC3+Nmwaw
	 7ZH09msf0KA3g3dxT5xydIhKP5VVtBNYhsECCmbdcNrZJTTphRsBCnXrf0uIhawSyOvgz
	 85uQtLNw/9dKV9aGwps1OkPj0i7YFwK1YIjG9UYizea2jV89wLkP+M89aRtWifZSJxC6b
	 bqNUbZsoW77l4Pw0Rhkr4pKYzGUx9nf3BHst4CqwuNrIHOjJrlAPcNbZtr3Tx6jFqZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kCVyNgfi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C76606A333;
	Tue, 10 Nov 2026 19:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kCVyNgfi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E2A1F0089F;
	Tue, 10 Nov 2026 19:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337481;
	bh=/+cIREyg0AGU7+zcF6+BlnbT1om/DZm0Kc0KnCIR9hU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=kCVyNgfieokHyoVlfLy0rcNxTGlWpB0QJOt3CrizXJx8whUmXkTuq3vyUOmwDK2P3
	 blCWOuwdjIWGlFhqZ+4rjWymKYUkSYhMCpCk1KTsCbgThCg3agjLxTQF7lhZoWoh7/
	 MTRozUAC5LOAjL98Dyy9IKQ4OBVcbuw+Nquh0qXFkKZWoTLkHWfC5K/5Rl8E9Zpbyk
	 fiRJWqWojMFdYSPa6/32eyFThxYta7JvcXGp8hpRJOcV7c7q3dzqQuFo1Mv4MaqnTz
	 bMSDUp5yyJjaKwm92WtobgKUE3nMxLXmqjTuZmc3iy+oybIMgEm1fllCDtWZKtLVFd
	 hOnNY92aC6gKg==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v7 11/11] xfs: restart faults racing with realtime flag changes
Date: Tue, 10 Nov 2026 14:04:29 -0500
Message-ID: <20261110190417.32650-13-mason@kernel.org>
In-Reply-To: <20261110190417.32650-1-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On a zoned XFS, a store through a shared mapping can dereference a NULL
pointer, or corrupt the free block counter, if the realtime flag of the
file changes during the write fault.

xfs_write_fault() reserves zoned space only for a zoned inode, and tests
for that with no lock held. xfs_buffered_write_iomap_begin() tests again
before it takes the ILOCK. FS_IOC_FSSETXATTR can change the flag of a
file with no blocks between the two tests, since a fault never takes the
IOLOCK:

    write fault                           FS_IOC_FSSETXATTR
    ===========                           =================
    xfs_write_fault()
      sees that the inode is not zoned
                                          sets the realtime flag
    xfs_buffered_write_iomap_begin()
      sees that the inode is zoned
      /* ac is NULL */

If the flag is cleared instead, xfs_zoned_buffered_write_iomap_begin()
can be waiting for the ILOCK at that time. It then reserves blocks the
zoned way on a regular inode, and the free block counter ends up too
high.

The fix used here is to test again under the ILOCK, before blocks are
reserved or allocated, and to return -EAGAIN if the flag has changed, so
that the fault starts over.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v6->v7:
    - xfs_direct_write_iomap_begin() tests the flag too, as soon as it holds
      the ILOCK. It could allocate blocks for a COW fork extent before it
      got to the test in xfs_iomap_write_direct().
    - The assert on the extent size hint in
      xfs_zoned_buffered_write_iomap_begin() moved below the test of the
      flag.
    - Dropped the Reviewed-by of Christoph Hellwig, since the patch changed.
    - Was 10/10.

 fs/xfs/xfs_iomap.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3465204b8d5..83ff105154b5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -264,6 +264,23 @@ xfs_iomap_eof_align_last_fsb(
 	return end_fsb;
 }
 
+/*
+ * A write fault picks the zoned or the regular path before it takes a lock, and
+ * it never takes the IOLOCK, which keeps the realtime flag stable for all other
+ * callers.  The flag cannot change under the ILOCK, or once the inode has
+ * blocks.  So look at it again under the ILOCK, before reserving or allocating
+ * blocks, and make the fault start over if it has changed.
+ */
+static int
+xfs_iomap_rtflag_changed(
+	struct xfs_inode	*ip)
+{
+	xfs_warn_ratelimited(ip->i_mount,
+		"RT flag modifying during page fault for inode 0x%llx.",
+		VFS_I(ip)->i_ino);
+	return -EAGAIN;
+}
+
 int
 xfs_iomap_write_direct(
 	struct xfs_inode	*ip,
@@ -334,6 +351,11 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
+	if (xfs_is_zoned_inode(ip)) {
+		error = xfs_iomap_rtflag_changed(ip);
+		goto out_trans_cancel;
+	}
+
 	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
@@ -919,6 +941,11 @@ xfs_direct_write_iomap_begin(
 	if (error)
 		return error;
 
+	if (xfs_is_zoned_inode(ip)) {
+		error = xfs_iomap_rtflag_changed(ip);
+		goto out_unlock;
+	}
+
 	/*
 	 * The reflink iflag could have changed since the earlier unlocked
 	 * check, check if it again and relock if needed.
@@ -1666,9 +1693,7 @@ xfs_zoned_buffered_write_iomap_begin(
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
-	ASSERT(!xfs_get_extsz_hint(ip));
 	ASSERT(!(flags & IOMAP_UNSHARE));
-	ASSERT(ac);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1682,6 +1707,12 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
+	if (!xfs_is_zoned_inode(ip) || !ac) {
+		error = xfs_iomap_rtflag_changed(ip);
+		goto out_unlock;
+	}
+	ASSERT(!xfs_get_extsz_hint(ip));
+
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
@@ -1865,6 +1896,11 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
+	if (xfs_is_zoned_inode(ip)) {
+		error = xfs_iomap_rtflag_changed(ip);
+		goto out_unlock;
+	}
+
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-- 
2.55.0

