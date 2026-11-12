Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519976;
	b=WbYh7bZM9Kdqv+/PYxztOQD3OMFZkkhZ2j9qXABFkeFsfNjp662991ilMpoUqWAcQik8
	 UcwjIw2D9z10WQVJEuTzv0AW6TaDRMFTjt2YeGTWRMz0/ZU/D/JtU6OLXR7TL+DroBQdS
	 52LATN66URAGCuKj/27OvDR7UFe/QLeWgPwi8TNOTqbqq/BSvWrsKsVfUqbIFxeZI2kjC
	 ie6gQ2/ubGZwJria0ZO7hlrp7Fe6IEy4rY9EnpZ2a8BmcEAV4v3v9FIgzgIcdveDBYlF9
	 XOJ/wbrtDxvPFeXxAonlxrqnozXozu1sivdUpFQuIiGDAiQ3wfneanDXmdJrJtV84pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519976;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VqLLZ+m89LNB6v4/YDdcYD1Qq3WxZefRLjwiUmiHR40=;
	b=1WvSAuYtmBmS2naYHKBag5O3Zl5ds3ZwIpYHlRIAxe0f12K9hVjDY2jv/cisgQ4bT1UX
	 j/dVFnlKwlnMm1PVfcIxwTGmvkGee42xr43asEKlV1YY5+NhQ/b5qK8qQ1KpBsWaHoUZ+
	 TVnJMSVEvkzcBgtKZUSyXji7hEYuIspmBJQ2C6Zh0oZzumhgwhTL5AW4qCepsjeEK6hJU
	 5OczciQcOELVoQtTaH28JkwMP31FRoGA1zLzddEKLu7HAOjPhP19Z1JiLrdJxm/QKQ6Aa
	 4lCdXO8cHGfM0qMVEqb+taBnuRLag0UwcqWxbw0Y8ecGKf9UsPnp2qASIFTo0MfzrJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knt71bnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E983606A335;
	Thu, 12 Nov 2026 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knt71bnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9601F000CA;
	Thu, 12 Nov 2026 21:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519976;
	bh=VqLLZ+m89LNB6v4/YDdcYD1Qq3WxZefRLjwiUmiHR40=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=knt71bnre30zOiZHeHZAKVZIpYA6GoPRtYJl7CZ5bgQCDGzjnixxHDVrsJoqCp3Hs
	 YFV6s583Y4+YY/VIYIoce8KoGHFojFxwxfKebF9KGVmrDrBvxvAgW4xiCbHb7vGd4n
	 76jWXZdKWV9TiIXuMWGpQkqqvjJkacDPxmlD0RSJyWmcWQa0qU5ixtBK+mxLGndVVi
	 Q8qP2r9SiJFahqoERZNNwrGhBk5DSLSlbQy5S0n7XYmHcLypcmtDnNtfCURXzOZd8d
	 heH7qtIgd3bVK+sHjZpBFy8OfUJT1wUSmJQG6KRFFJVFvvstrPhgnVmaE7pmxmBw5O
	 sAvGlziIp6t0Q==
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
Subject: [PATCH v9 05/14] fs: validate atomic writes after O_APPEND and limits
Date: Thu, 12 Nov 2026 16:46:09 -0500
Message-ID: <20261112214604.67875-6-mason@kernel.org>
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

Notes:
    v6->v9: no change

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

