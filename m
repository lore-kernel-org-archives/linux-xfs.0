Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337480;
	b=UwDoNkY48ALuC9VXzj+DTjKfipelo6pwKvPHQ3n7gGHp0OQ3uKDtcUe8P8CJSVYGE0cs
	 5U2tcrk04v1Au2yFsNebqsuuE1G42B+XBxJg745S/n9lmo4I1YUxPURYfyR7KlC34+OSq
	 jPGreV4eoch3aAnp5HZWdJAE5OR+mMEKHkBq6o/OUYxzzcw1ptQgsZxo+DSpFWeEQLLjv
	 uHiwip8LpIbK16OWXUuOBoPLscXdRmvUga8x0gyOouOq7sfAo4mC8qG1KNLN2Qi82AoBa
	 GmzEIwDVYIFdYC3l9khybH4yPat2UFMlC6X6cX0KinS5M4J2geoHGvuJusNa5H31ysA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337480;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tQvzT9puTGatA2/bGCasrd7zaUkAj8OK6E0hTTW9xsU=;
	b=VN7mvooriwWH/sMxvzMwAog3fWgCL9cVrCDTZ/X2N6QHGNPfw1duo0dHlEywn7QjNB9h
	 sEZu2J98SRtZrRY+vCHXWDvCWGw7mZTt8mWq4P0bRIX8B4Wl3I8u+KuFXgHRd8HMpgzAA
	 iK7BCCP5pcSL003x+ZFM1dzjvFmQBqAhLayMCvnLPUUc2LUIvHGJYwK9/lmZMWEyI106t
	 jFiF8u4jl5tmzL355MmCv1zyQnP7mxFtciuhIn6CALzfbovwVvg0kV7XLCNnuzGRO31iv
	 eq4psxOIXXdZlYNCIr7VoF3fGnWVjEGOySInODOUQ8QUu4Ua1tVfjmkMEOx79ZTwrbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wp2Lxnhx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B703660A260D;
	Tue, 10 Nov 2026 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wp2Lxnhx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31AB1F008A3;
	Tue, 10 Nov 2026 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337479;
	bh=tQvzT9puTGatA2/bGCasrd7zaUkAj8OK6E0hTTW9xsU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Wp2Lxnhx0gh8LLMkbgVK48CLcLorKcYtF5ULJnQlent0qLWwptopYmsE5BeTSPTUs
	 x+yXaC7r4VxnAR6BLKP073i7Zd+1WiNCpgIrXn6n4u26SH0njsbs4xA0njXG6aN7HH
	 2KkaH33YXXu9DOvGgjk62OnBHfqxS/I7adQg70B0yoPliacwmBV/7TI0ppUOkbgtEm
	 SaNhUngOH4ISPGmppKgvy0/1y3NKpJWyuXpfjLHYXe9taOKkYCEZvFVuYbfyPmY+v4
	 p/EpRAgZV6DIvhOqZq86S697iVk2dMuVd9384QGeqr7AGEE9r0k7H1HSUJpQ6F0Ns1
	 d5+i+2YDxZyQQ==
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
Subject: [PATCH v7 10/11] xfs: refuse fallocate racing with realtime flag changes
Date: Tue, 10 Nov 2026 14:04:28 -0500
Message-ID: <20261110190417.32650-12-mason@kernel.org>
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

