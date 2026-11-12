Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445371;
	b=MOo0axfCDrA48vnpUV7Va1Mk8MDoidsaUVD6q26jARYoVKb0bT/lDsqV2uItdiyXIV3w
	 HQr/u4Td24oZj+OTrJZvwS6rixUpgkQVddDtNGc/FD0HyxiYqwS52cMNMY8g6tbXOm7Iu
	 qs0Lnr/3JDUUrfe5+9eUILFpudJa3rcBZ9nGYFlGJoWf0VN7NGoiaJbi+SYbenpgWHstj
	 RdkWTRDK61QBEp4GnZkfpvAnzMxr4NKdEeTohp71RUIsmMpPd8VT4me3s0kKE7GE1wrwy
	 H4ENRd0sleHOMYAR2x0sTO5hGl0theMK1NwI3we5Pc+Z3oMi24Nf5dAUkb5xlAaTQuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445371;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3oCUFLs8ljgJ3Ngl4Ni/X5VdPd+G5PT1DsqljZniRw4=;
	b=ogmWPPJsLiV/QBfHOsqifiNR300C5ry03NsiJkRE3zrmfeuDCmW+Vt2NninamWDD8mDB
	 ig+HSCKi3kZugeKbTiTSIXGKcLCT0Q4Mh/sGZE1tZD3JF60+KtbHlVLlwNE7QXKbB3B8D
	 KCfooduDBko1kQzW27G8TqGq7LkNEMJXrSf/yICqIsBSC5E0ita9mPQcGw+DUcgNHWBdE
	 THqewpceIkjlon/KrKfmTwzOHLu2HmlTRS8Zqyxg7XHUjutE9elCaTNxo1bSg2UTTRHxm
	 mFtWXEFHzoCDjbfaTVF6dCTaKwBtba5V0PZ8IU6OwlY1t5n4v1eKiBv8/xqG4uUHWcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PER97LeO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AC460A5BE2;
	Thu, 12 Nov 2026 01:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PER97LeO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815651F00A0A;
	Thu, 12 Nov 2026 01:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445370;
	bh=3oCUFLs8ljgJ3Ngl4Ni/X5VdPd+G5PT1DsqljZniRw4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=PER97LeOBFo0r3W6XN526NOKCzo7DxAw628yvPoUBgIBOJHgWvpzQgpXx60+yNAfN
	 91bdG6IUQmxV5Zq2JfWBRlAPdGblrx1r4GksQr9WwQ7WaY4YI42bHfAMcfhQLGZft8
	 CMHnTMAkTOlwjy/uWicKUQIYGh6ARc+F8WBWZ4gw8Cvdm2w63XYHb8uiPnP+JqguSJ
	 za5LP7Xik4xIt85xE25M0sbmbYzBLhebovxK4FOPvTHezcrmO5ALgQgp2bMwTlkQfl
	 v2PiMQUGAbXFD6+kOay8eY7vcQHykYMg1pAFlGXjRhAy+wWhZYThSaGPZm/tw+Ykvq
	 44yt2p/wWSkCg==
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
Subject: [PATCH v8 11/15] xfs: restart faults racing with realtime flag changes
Date: Wed, 11 Nov 2026 20:02:40 -0500
Message-ID: <20261112010229.51029-12-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
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
reserved or allocated, and to make the fault start over if the flag has
changed. Any other caller that gets there fails, as a write does.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v7->v8:
    - Only a page fault gets -EAGAIN. Any other caller that gets to one of
      the tests fails with -EINVAL, as a write and an fallocate do. pNFS can
      get there: xfs_fs_map_blocks() tests the flag before it takes its
      locks (Christoph Hellwig).
    - The warning now says "during block mapping".
    - The helper reads the inode number with I_INO(), and its comment no
      longer says that the flag is stable once the inode has blocks.
    - Was 11/11.
    
    v6->v7:
    - xfs_direct_write_iomap_begin() tests the flag too, as soon as it holds
      the ILOCK. It could allocate blocks for a COW fork extent before it
      got to the test in xfs_iomap_write_direct().
    - The assert on the extent size hint in
      xfs_zoned_buffered_write_iomap_begin() moved below the test of the
      flag.
    - Dropped the Reviewed-by of Christoph Hellwig, since the patch changed.
    - Was 10/10.

 fs/xfs/xfs_iomap.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3465204b8d5..d36650450cbb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -264,6 +264,25 @@ xfs_iomap_eof_align_last_fsb(
 	return end_fsb;
 }
 
+/*
+ * A write fault picks the zoned or the regular path before it takes a lock, and
+ * it never takes the IOLOCK.  The realtime flag cannot change under the ILOCK,
+ * so look at it again there, before reserving or allocating blocks.  Only a
+ * fault can start over, so refuse any other caller, as the write path does.
+ */
+static int
+xfs_iomap_rtflag_changed(
+	struct xfs_inode	*ip,
+	unsigned int		flags)
+{
+	xfs_warn_ratelimited(ip->i_mount,
+		"RT flag modifying during block mapping for inode 0x%llx.",
+		I_INO(ip));
+	if (flags & IOMAP_FAULT)
+		return -EAGAIN;
+	return -EINVAL;
+}
+
 int
 xfs_iomap_write_direct(
 	struct xfs_inode	*ip,
@@ -334,6 +353,11 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
+	if (xfs_is_zoned_inode(ip)) {
+		error = xfs_iomap_rtflag_changed(ip, flags);
+		goto out_trans_cancel;
+	}
+
 	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
@@ -919,6 +943,11 @@ xfs_direct_write_iomap_begin(
 	if (error)
 		return error;
 
+	if (xfs_is_zoned_inode(ip)) {
+		error = xfs_iomap_rtflag_changed(ip, flags);
+		goto out_unlock;
+	}
+
 	/*
 	 * The reflink iflag could have changed since the earlier unlocked
 	 * check, check if it again and relock if needed.
@@ -1666,9 +1695,7 @@ xfs_zoned_buffered_write_iomap_begin(
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
-	ASSERT(!xfs_get_extsz_hint(ip));
 	ASSERT(!(flags & IOMAP_UNSHARE));
-	ASSERT(ac);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1682,6 +1709,12 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
+	if (!xfs_is_zoned_inode(ip) || !ac) {
+		error = xfs_iomap_rtflag_changed(ip, flags);
+		goto out_unlock;
+	}
+	ASSERT(!xfs_get_extsz_hint(ip));
+
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
@@ -1865,6 +1898,11 @@ xfs_buffered_write_iomap_begin(
 	if (error)
 		return error;
 
+	if (xfs_is_zoned_inode(ip)) {
+		error = xfs_iomap_rtflag_changed(ip, flags);
+		goto out_unlock;
+	}
+
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-- 
2.55.0

