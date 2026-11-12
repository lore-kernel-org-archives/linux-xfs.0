Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519985;
	b=wKkTVbrXOMzfe1uMWijBwFCdy3RUgOFg6KCAqTw16H8oRLTam4+h9KRrz3hnXcxkcDH+
	 +T8MSaQBNzkSiQy/VM0n5sNzJh06zZTI3IO+5xQ0APlAWt5FehSAmJuDs2C+6aoPHsejZ
	 eCWkk4ZEFYKQ7AhnXDoOXkQU51t8hSZnKaS1nGQHfGLbn6isF7N1w5YXMuIsumdqBXxMr
	 89Pn3A4J+BrQP/nLiolHGE+deUJTpZQ+HDq81KTpM4DvWrxixJ5LnvFk5HV6NkF30S/5z
	 KzoUKoVoPm+2vwKdPNZ5OR4qZzW1Ed61FcRsyocak9t1SJz3dxYeg4WfsQ4TcpIvcBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519985;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1mHPLrOS3OArzUqJuavd9J77wJ97SanHQHyuHIlePfA=;
	b=A94iDKHW/4iz4DGJVjvBDNSzo/E+lgJUKY/iq1YX40aqn4hfT0DOwFRNIp09aAmw2GuC
	 5H4OCdr6sMwK1GnTNELl9NlmvkwA8WJdx+od/goaaoNgCRDZnDplp3aTd24at8drus0TH
	 j0SQKAHeEvfXrM00G9649qL7EwoabK6o9T17+WzdMZ0dkcIhrLwnomnkwGBcxf6HrK0NO
	 8zIaWsYdQWBv0CCwQuhoEKcUeqiFqGslOwMgvJSX8WEodDxEhGn8bLN/u3BDxKjrhbKaK
	 ABn6btS4bFFZ3kd7J1Syon50H8+NyTA99Rep3xGpO0QnmPxuxzpQh1efyJUNfcih7KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2m4uqwe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAEF606A88A;
	Thu, 12 Nov 2026 21:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2m4uqwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8011F000C5;
	Thu, 12 Nov 2026 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519985;
	bh=1mHPLrOS3OArzUqJuavd9J77wJ97SanHQHyuHIlePfA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=T2m4uqwemM7yRTOm6LyhhtbwM/72QDRcgksnmYRZ9b1Oqb2ErIHNBisZdxSpQWISj
	 A2brGh+OSq/aUQUkY0dfg1mlb59YNKEg9RbvzMbhWL44eiyRP7g0x+Xc1L1nxZX9k6
	 9My3+Jxyife1yNiVHX4weMTfcEN1XvbxpMG8HLNnfaDKgWytc2VuIjbRTuu98A+OJm
	 gHpU8m8oHE+MuwzeyQ+fvjEaUS+KELHBAqa+sp5pdMLOqZiddpzAw/LhF2IcW13ueb
	 QvXuH9UM4LucQeRMpNCeDoVwWzXGGqZRcrLl3x+TJYOL3ohWZeIbbRA3OmxjYoWB5H
	 TB6P/15PRLR8Q==
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
Subject: [PATCH v9 10/14] xfs: refuse fallocate racing with realtime flag changes
Date: Thu, 12 Nov 2026 16:46:14 -0500
Message-ID: <20261112214604.67875-11-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
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
    v7->v9: no change
    
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

