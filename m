Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268281;
	b=a9eAedaYFP+hdmnASI+FxNJGraTR+rk1bFPy0Gm6t2ULEs3Zivxz37ZvzgqKKmhyURkR
	 rzXUF4a7WL8+KmpQ7+QLCVXyW/qKC92nCHlQ2v0LNYx0FUmYgveT1HrU7q8tsTo+NaLaz
	 LWZJswht9VAKJnYXf9Wud5PJvAKeIrTSr6q3tuDniFZszjNVBexNgoNM8aFkctlMEi8ri
	 lmkR+327RNNoMZ6HyP4H+5Q8nqdu+pow2B3tPYQWdEE0d4Ow8NQMZPAe8W0yUX5pxgOWz
	 1+/CXzMiL5MYmj1MSq4FyF7eOPD0cb504pI4njWVLUMkFnp7X84guydV4/OprYtSK8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268281;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xebwCZ71jTrY9GbqrwXpYwC1G6Q6Dw22Bz/PxvMl554=;
	b=a4XsG31fCiIf0pUAFNqVMWXzOSvRgxu92fB1m7WfIkQ6Sp5eH+GFR5WWFKo8RDhSbfVi
	 dq9Q2HJKlEL/sqxVuRA5BMPzqQnv0uRCmxt1dQc+DooR5K7/RFxE8VTo4m7tOiUrbOxHO
	 ZUpzDkcdUgTs2zJExEJxHWEOVxCLvxnrZ+qNELonAN/5dhALQrtHQuJFIwjpf1wrFZq+O
	 G5gxQO10JMhGYox9/lxAvTgxqzGvq6JmSL9rLYeSYc/PO2iWOlunnadM7kncfc42MGjSk
	 06h5/l0R3dG97tDfZ1oHMH55feJpnF2yLHQYAVioIVRrnjZm/VLfTFFxW/cB5OZYDGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DUUfDsXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B88860A2600;
	Mon,  9 Nov 2026 23:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DUUfDsXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F9D1F00900;
	Mon,  9 Nov 2026 23:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268281;
	bh=xebwCZ71jTrY9GbqrwXpYwC1G6Q6Dw22Bz/PxvMl554=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DUUfDsXYi1WN7hevkFFr+Q30XN5fqR1eQdUqouT7ztBKf2vujvRi6IAUvSUlMRCjS
	 D+EonbPfBbdt2+TRn6bHwQl4TivZwHNl/lc6XyQ6Dwdsi+RQucJnOtv6VoUzsSF5f6
	 dpSow+Rtgn0wlKpw5hT8AIMhqtDE+Imc0/TM9gk66GVQYWjOFsf3usH+L/CRhePhaT
	 aN82dI9nYLi/+vH9hGir9tgERAFWKiJELW13I/FIFnNuMEPGbktawlmWsuMjGoXE4V
	 MJjw9nj+y38C2IR30WxxPbJ+nHfuturUC694z4aoAD+jWAAZ3K6bX2BgRFXpjnyzDY
	 zoM6BvWSCXjxg==
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
Subject: [PATCH v6 05/10] fs: validate atomic writes after O_APPEND and limits
Date: Mon, 09 Nov 2026 18:51:16 -0500
Message-ID: <20261109235111.14129-6-mason@kernel.org>
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

An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
aligned.

XFS and ext4 call generic_atomic_write_valid() on the range that the
caller passed. But generic_write_checks() changes the range later:
O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
then fill only a part of a new block, and still map the whole block into
the file:

    block size 4096, i_size 512, O_APPEND
    validated:        0 to 4095
    written:          512 to 4607
    new blocks:       0 to 8191
    stale below EOF:  0 to 511

The fix used here is to validate an atomic write in
generic_write_checks(), after its range is final, and to refuse one that
was cut. XFS no longer picks the path of an atomic write by the
alignment of the range that the caller passed.

Fixes: f096207d3276 ("xfs: Validate atomic writes")
Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
Signed-off-by: Chris Mason <mason@kernel.org>
---
 fs/ext4/file.c    |  4 ----
 fs/read_write.c   | 13 +++++++++++++
 fs/xfs/xfs_file.c | 17 +++++++++++------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 50d3c92709c8..e301d4faf1c3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -802,10 +802,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (len < EXT4_SB(inode->i_sb)->s_awu_min ||
 		    len > EXT4_SB(inode->i_sb)->s_awu_max)
 			return -EINVAL;
-
-		ret = generic_atomic_write_valid(iocb, from);
-		if (ret)
-			return ret;
 	}
 
 	if (iocb->ki_flags & IOCB_DIRECT)
diff --git a/fs/read_write.c b/fs/read_write.c
index 676728310899..1b34b7382619 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1775,6 +1775,19 @@ ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 	if (ret)
 		return ret;
 
+	/*
+	 * O_APPEND has moved the position and the file size limits have
+	 * shortened the write by now, so this is the range to validate.  An
+	 * atomic write is all or nothing, so refuse it if it got shorter.
+	 */
+	if (iocb->ki_flags & IOCB_ATOMIC) {
+		if (count != iov_iter_count(from))
+			return -EINVAL;
+		ret = generic_atomic_write_valid(iocb, from);
+		if (ret)
+			return ret;
+	}
+
 	iov_iter_truncate(from, count);
 	return iov_iter_count(from);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index be1f775128d1..153f53f964b9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -926,12 +926,21 @@ xfs_file_dio_write(
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
 		return -EINVAL;
 
+	/*
+	 * An atomic write is at least one block long, and generic_write_checks()
+	 * refuses it unless its final position is a multiple of its length.  So
+	 * there is no unaligned case to handle for it.
+	 */
+	if (iocb->ki_flags & IOCB_ATOMIC) {
+		if (xfs_is_zoned_inode(ip))
+			return xfs_file_dio_write_zoned(ip, iocb, from);
+		return xfs_file_dio_write_atomic(ip, iocb, from);
+	}
+
 	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
 		return xfs_file_dio_write_unaligned(ip, iocb, from);
 	if (xfs_is_zoned_inode(ip))
 		return xfs_file_dio_write_zoned(ip, iocb, from);
-	if (iocb->ki_flags & IOCB_ATOMIC)
-		return xfs_file_dio_write_atomic(ip, iocb, from);
 	return xfs_file_dio_write_aligned(ip, iocb, from,
 			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
 }
@@ -1128,10 +1137,6 @@ xfs_file_write_iter(
 
 		if (ocount > xfs_get_atomic_write_max(ip))
 			return -EINVAL;
-
-		ret = generic_atomic_write_valid(iocb, from);
-		if (ret)
-			return ret;
 	}
 
 	if (IS_DAX(inode))
-- 
2.55.0

