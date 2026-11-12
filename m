Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445369;
	b=FdjdBuHARhC1xiSZv8+CFGI5kzfvrjIdauRo2lkeFxOSQ08yRabcNinNhKyFPNdCGsQs
	 jptLujkias2DbwelPVW672zJ21A/CJn9uWoT13jvUxMcDDW65fou/df+alblwv9koPGvn
	 SJ7PkhhQeLgwK3kz+EJSPUoJ2Aahd78xHxoR21PiqgE8BD9HFJsOp3L7S383ZUfyiZU3j
	 /r3llCU2WssGiO71DZJ6I/jMuh2RnoSr51ZgI6j3GZ6mK9XwJD18xZxHHysYJqrqEPrWw
	 SU1srtz3M7WIywGOEJmctW4xzHoVfG6RzkxnDl70uAj6R8vQVrVFlevelbni0n2YCYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445369;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5mYGuCCwo2TeR7oWhjIaNcgwRGLBBpFXbA369b682Nk=;
	b=zn3/ZMqN9bzF4Kn1ZnAH7U/INgaFI4YcOsg7VgUgB2jDmmULyREL8mSGNQFhaXqEQB8a
	 pB0yyxK5YAq1WllMyJQtOOZfSQX5k7/dz7p0LdQk5V0BJLT+0+kvd5xn4uII6hyuJcjVV
	 d9yKRPKLuhJLZCl5INYe43JcjblVgZrLghBaUQfGfvIEftHfM8WW4g8cbG6DONGbotroR
	 d0Z1NYSSZMY1Nz2I/G+rNOVyf/j0gX/Pn3mGGTY4728kiAFQHwZIkq8HsTlT+muLxBYTi
	 pYhL8eECCUQ5p38/cBfDFSHzG4VRHF3gAUDadjRZvgpjgb8p0XIvHZQKb1RObSJ39tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eULeAXVs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA3260A3814;
	Thu, 12 Nov 2026 01:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eULeAXVs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD32F1F00A11;
	Thu, 12 Nov 2026 01:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445369;
	bh=5mYGuCCwo2TeR7oWhjIaNcgwRGLBBpFXbA369b682Nk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=eULeAXVs08VclAgJEGsrgG/zPLa+ohJcwSehdEoMF2xhBsmj4X3WRGh2zawFCGQQG
	 iNtd97Ghk99F2MFyltmOYH6YNaud/8Lx9G1HSkwNa2osZDwx7PxALrIyILtJRswJoi
	 FXbhuJ5R95x2xhpTIpQlUIjl1gOARDwtHjmN0nU1wuBgSD6FlflRMB/QATD3mBlvxv
	 UkCOVuPosOk8CJMoYCq1B8ueDLh7QfPrtTsT+x292QsPFMGS+Rs8/rMmk0fcSred0n
	 FvOyJq2tVHh7Iqvnc3A0Zp1XFCZsetgygZU3xZMYUPCKfnDt/Eg5Nb6VnFmFD2X0KD
	 j3Ml+azSgUzLw==
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
Subject: [PATCH v8 10/15] xfs: refuse fallocate racing with realtime flag changes
Date: Wed, 11 Nov 2026 20:02:39 -0500
Message-ID: <20261112010229.51029-11-mason@kernel.org>
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

On a zoned XFS, fallocate() can dereference a NULL pointer if the
realtime flag of the file is set during the call.

xfs_file_fallocate() reserves zoned space only for a zoned inode, and
tests for that before it takes the iolock. FS_IOC_FSSETXATTR can change
the realtime flag of a file with no blocks in that gap.
xfs_falloc_force_zero() then sees a zoned inode and reads the
reservation, which is NULL:

    fallocate(FALLOC_FL_ZERO_RANGE)     FS_IOC_FSSETXATTR
    ===============================     =================
                                        takes the iolock
    sees that the inode is not zoned
    waits for the iolock
                                        sets the realtime flag
                                        drops the iolock
    xfs_falloc_force_zero()
      sees that the inode is zoned
      /* ac is NULL */

The fix used here is to test again under the iolock, and to fail the
call with -EINVAL if the answer has changed, as the write path does.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v7->v8:
    - No change.
    
    v6->v7:
    - No change.
    - Was 9/10.

 fs/xfs/xfs_file.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5fa8b07a779d..78c9668c806b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1573,6 +1573,21 @@ xfs_falloc_allocate_range(
 		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
 		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
 
+/*
+ * For zoned file systems, zeroing the first and last block of a hole punch
+ * requires allocating a new block to rewrite the remaining data and new zeroes
+ * out of place, which needs a space reservation.
+ */
+static inline bool
+xfs_falloc_needs_zoned_resv(
+	struct xfs_inode	*ip,
+	int			mode)
+{
+	return xfs_is_zoned_inode(ip) &&
+		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
+			 FALLOC_FL_COLLAPSE_RANGE));
+}
+
 STATIC long
 __xfs_file_fallocate(
 	struct file		*file,
@@ -1591,6 +1606,19 @@ __xfs_file_fallocate(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * The caller looked at the realtime flag before we took the IOLOCK, to
+	 * decide if it has to reserve space.  Bail out if the flag has changed
+	 * since.
+	 */
+	if (xfs_falloc_needs_zoned_resv(ip, mode) != !!ac) {
+		xfs_warn_ratelimited(ip->i_mount,
+			"RT flag modifying during fallocate for inode 0x%llx.",
+			inode->i_ino);
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Must wait for all AIO to complete before we continue as AIO can
 	 * change the file size on completion without holding any locks we
@@ -1686,16 +1714,11 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	/*
-	 * For zoned file systems, zeroing the first and last block of a hole
-	 * punch requires allocating a new block to rewrite the remaining data
-	 * and new zeroes out of place.  Get a reservations for those before
-	 * taking the iolock.  Dip into the reserved pool because we are
-	 * expected to be able to punch a hole even on a completely full
-	 * file system.
+	 * Get the reservation before taking the iolock.  Dip into the reserved
+	 * pool because we are expected to be able to punch a hole even on a
+	 * completely full file system.
 	 */
-	if (xfs_is_zoned_inode(XFS_I(inode)) &&
-	    (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
-		     FALLOC_FL_COLLAPSE_RANGE)))
+	if (xfs_falloc_needs_zoned_resv(XFS_I(inode), mode))
 		return xfs_file_zoned_fallocate(file, mode, offset, len);
 	return __xfs_file_fallocate(file, mode, offset, len, NULL);
 }
-- 
2.55.0

