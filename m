Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268287;
	b=i4gYaPgW7N7/FX/xr3Dog6xvUZxovcTK9FnVcKByBiTzgC+YT6XYczByNzznvBRNc09r
	 Uu5JS5hQfYq/GgOymSnpISxbbtKhPJvhA79cRpbXVEyx2wweOQuzq7LWc/4QGSAn8gwwc
	 M1gE3FcQYweJQ+Fb07jtDvjuXhS1I1zGeKZDuBCjktUFexNM/8XPWJHIeIEhDXp1s9J7x
	 M5ZE9QlIsnh/1zOHTdYmHbIS6Kr9RtoLAgShfERutQSTKXs3351gMFh5Uk4EIphXRKIQB
	 /2JZn6kq+lvW07D57EcEoyO5fC9ocn1kS3UNBzlwekWjR7dpT0w0qUtWiq/SMpbzVYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268287;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ly7glYuDm45Thr2JWJRUPb8YPQdXsd0uuDa6zXjMgHs=;
	b=Z7onSswGrZCfDG+pyrKNoVAK8moSyQUTFqDtv2+cZEEx9JhJENsgcnJlFP+W4T9mhE0U
	 XcOKjMzuJ0ZgK0NBVGvLFBmGtKv0XOmd+UAPgyx46Pdg68NdmXSS3MhO14LckfRZyCqVO
	 bqZXw6ioeGElj/1DRcO/nxBKeCI+AJsDtbDTo1u7KTNnOMjQP9whPlYAVrRq7pDGjhrkV
	 KDWi4MyulKQY8tqHfVLQuqE6YmVwRRGO64sH0DPJVUDOpKLsFddWfF9C7KC4CYx0CIzhe
	 nGrBL1ZKmLo4RPEEAOnikV3LChvAwJrCw0MddGdKbeo4A1De5LJy51i5k5Vht4VWugg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="J6pw/EKA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F1B606A33D;
	Mon,  9 Nov 2026 23:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J6pw/EKA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4FF1F008A1;
	Mon,  9 Nov 2026 23:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268286;
	bh=ly7glYuDm45Thr2JWJRUPb8YPQdXsd0uuDa6zXjMgHs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=J6pw/EKAuQJ8a2XztrZjuouSP09aCET8KgYZXVt8O58II40n4rtjeu972YNAcibb7
	 SyjaN7cnrgCc2KbQWc6ZgMAXTTB5Hh1qakX3cKXIcjEPKZ2t4r4FEug4yRaW8utTfZ
	 jy9cCj2T8usYa1CPvYAkhXii7IMPSJzQ7+/TNWBApdHR3HeutPdFnkdhYA8FEMbnmn
	 fOdlgnKyoL7Lewy3lwbiX5ohbI/kjIuFzzMXAvIkIYjQnBbktO8RgG0vnPM/hkrNJ6
	 7HAdkYMRvP3UJHUhUCnxi9HqiVgCnOXYZZKkbKBSTFMz5YQnQtbuRW7WDZp9a6lHhR
	 aBAidff3kZ0NA==
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
Subject: [PATCH v6 09/10] xfs: refuse fallocate racing with realtime flag changes
Date: Mon, 09 Nov 2026 18:51:20 -0500
Message-ID: <20261109235111.14129-10-mason@kernel.org>
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
 fs/xfs/xfs_file.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 515ddafc6673..26967ca4f3fb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1572,6 +1572,21 @@ xfs_falloc_allocate_range(
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
@@ -1590,6 +1605,19 @@ __xfs_file_fallocate(
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
@@ -1685,16 +1713,11 @@ xfs_file_fallocate(
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

