Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268289;
	b=LYD+c4bwknP0W6JRKp2cR84AAFtPhMRFEiH8biMkVAOmZOYVbaBxJ9NVn3kNMMSdTCX2
	 oWJQBNEWCD0mOw+1EqVhb3glGDKvYepQkFNw3rsb+fTcqsDYOAEYcAoWUdYb99l4aSHlE
	 a0hTFKNxOGunU31upKMfqtSF8YIt3rwAY1lnr7rTDbUwA+4PsHmkrm52P3ydOTZYKp2Pk
	 k+cUphxyj6czK/dGT5qkVQAJX6Yiaq41GWLMTZl8qV+SZHvweJ+6GjXW3xklBgZzQhxLI
	 VWC8fiZELatIPBM8SgtpIYM5Wz0JFrrvNfoLPLyj6hXNX7+QvIHcRIR0o02DdnYeaUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268289;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QDooGSmj6o+7BecvXiHqRFpr+EwV+FnQqyyovvptWSw=;
	b=pcv+ubsWQEbhO1WifTtSDPtW7qfOSDyPhHhx7gvwUQNxaVlGAwkZdM+01YjqWUsqnQrQ
	 pE16NzUAezGlCojLjtoIJJwt5TRUcePSAYSVP7bz6tuJ7RSce/FQGOBNEyugMMkftvwK6
	 v0enK0S033hnv5cPpfMgjGmKuEtwkhLM0vcBIqYIvUHqSwsqcLtFp9hKZF/azEiAaX/Fz
	 vnKOOKZuuxeaoEIvau2X4WqX2QTPYoB62Idl33Y5znN5Y4o17SaCBoXsnNRIP5TNhA0KB
	 ZM5tEBSDa94n2LGrOHwCfQsF1ioLPTQcQiLDId1Uyb9/r/5DpxUpCHKT3EIh6wajVNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=frwkv9fM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A567E606A326;
	Mon,  9 Nov 2026 23:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=frwkv9fM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4401F00900;
	Mon,  9 Nov 2026 23:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268288;
	bh=QDooGSmj6o+7BecvXiHqRFpr+EwV+FnQqyyovvptWSw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=frwkv9fMlEG8vp+JQMtGpatzZTOVa5eyoBqQUJnTxdS1XVYIbxHL/TM+FrH1wDroY
	 PifbHkzzrohxl+78qP1uyRrTpoKCwIhi1uwCmvaf/3rwG5WwxZhA2vCDLrZvK6AAWp
	 mkB+uHaZr6X1Be3MsfTLoGbCnKaywFSXRX8QeevDepcbT0+Mxm/XXNmWQ07+9n1SBp
	 btGEDlr5WRV2D4jbgYdTN0EHPbAZHQqH0SXd/qzqGhor6DEPKr+1wZXPGGHAyDYp5D
	 MUIImvetkpZ93A+rVK+02C7Vrs8hm1TQIJni47e1UzuX/3tFHM+dt1gU3+IMssQ4hG
	 ymSTo7QJiTZiA==
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 10/10] xfs: restart faults racing with realtime flag changes
Date: Mon, 09 Nov 2026 18:51:21 -0500
Message-ID: <20261109235111.14129-11-mason@kernel.org>
In-Reply-To: <20261109235111.14129-1-mason@kernel.org>
References: <20261109235111.14129-1-mason@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c3465204b8d5..3e71d619c657 100644
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
@@ -1668,7 +1690,6 @@ xfs_zoned_buffered_write_iomap_begin(

 	ASSERT(!xfs_get_extsz_hint(ip));
 	ASSERT(!(flags & IOMAP_UNSHARE));
-	ASSERT(ac);

 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1682,6 +1703,11 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (error)
 		return error;

+	if (!xfs_is_zoned_inode(ip) || !ac) {
+		error = xfs_iomap_rtflag_changed(ip);
+		goto out_unlock;
+	}
+
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
@@ -1865,6 +1891,11 @@ xfs_buffered_write_iomap_begin(
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

