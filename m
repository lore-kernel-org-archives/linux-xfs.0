Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268283;
	b=B0kVRP6cOULNL2q+yRyFJumGVWOv193Nq1uHxC2YtxKIHzU8VBfq9gevmvhY030JQEDL
	 0DM5aTJAHqwSDKPdMvgM8IXqQTN10r7ilZq8hVmwYBFkT2x+ZHf9TjlCy5uJTEbC8Jz4H
	 vVgxg6iuvH3HpAC5oj6kx7MrvNECO93w7NPJyooqAP1sniiZytSScTDX4RxQGpguLfJK6
	 cIxDXKymroGhiGoeEYdPHemFwUau1zghJ+prY/zkPOyWMPKkRY9+p2KEyXBddhzu03OfW
	 JvPI0SkhDUm0zTdNZTx3CpL1Jmo3B2gQlW0W7+M063VsVSC/Z6igRxWnOnD2/HQwiyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268283;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XAWNM3kzn/LYxCGbDzP8JTW/FEVZ1ezcTplGuS8V3Mc=;
	b=2/yIo3PUbeLyTD0Ixe0q+9plyW1ee0EKVhyr0iCaEVv8SBVnGu7rLQNu7L5IhVsq4vE7
	 FeudXjoheH7BGz8O63oD5T3KJHkgl3PXgTfNT2s4yyEBA5fkVKMfqDLQmS3LW2pWlybJL
	 FhcQuZIPa8XDK03s8THXDGklEc3V9hch6PM0pWCfjdLuoTA0bqf7m01J8bSO7SGCPRGJG
	 huiHl4YtWtMklnggANpSHUKnmFWZ23M/YSIv017Q0bUYZ40jD1xK/iL41lnGOFC0HgUrS
	 JTst5Q35SqR2fR3IkhyW4E2/3Gvoo5p51yBQDbFfGDMc+WZniEKJroKY4GMS76M/23w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q20t0SH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0013606A332;
	Mon,  9 Nov 2026 23:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q20t0SH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BB01F00902;
	Mon,  9 Nov 2026 23:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268282;
	bh=XAWNM3kzn/LYxCGbDzP8JTW/FEVZ1ezcTplGuS8V3Mc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Q20t0SH8VrddnUGBhMmPK2xbEK0b8crG9w/CMr2Ovu78HxBu5KtoWdJbtoee8pirG
	 1mX568I5Cx95M6dGQHnIqEdTYwlyfxIHZz2fomWbDqCi9uRHU571SBx9ZFWmI1M8e9
	 Arh455mifdsiRylONt3ZKqWRk073yCuC2Y8EkkqRxkA8RPYTdlFUkWma0io15MdxMd
	 Zv4Z+qwnCakuzzefyUo7x50ZT0peTMESSXSNwmIiZQe7+goeblf/gJmicWdpsSDe3W
	 zSv74qFo2wN4AazF3s33M7cT+S7KNeRZUyYCrwoMeFz7BNABDr7Ep9vOhxwIgAoLfd
	 WlMnZ+cPq62uA==
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
Subject: [PATCH v6 06/10] xfs: recheck direct write alignment after write checks
Date: Mon, 09 Nov 2026 18:51:17 -0500
Message-ID: <20261109235111.14129-7-mason@kernel.org>
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

A direct write to a reflinked file on XFS can expose stale disk contents
if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
aligned.

A direct write cannot fill only a part of a shared block, so XFS does
such a write through the page cache. xfs_file_dio_write() decides that
from the range that the caller passed. But O_APPEND and RLIMIT_FSIZE
change the range later, in xfs_file_write_checks():

    block size 4096, i_size 4608, O_APPEND, block 1 is shared
    checked:        0 to 4095, block aligned
    written:        4608 to 8703
    new COW block:  4096 to 8191
    never written:  4096 to 4607

The fix used here is to check the alignment again once the range is
final, and to start over on the unaligned path if it no longer holds. A
zoned file now falls back to buffered I/O ahead of that path.

Fixes: 0613f16cd201 ("xfs: implement CoW for directio writes")
Fixes: 3c68d44a2b49 ("xfs: allocate direct I/O COW blocks in iomap_begin")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 153f53f964b9..8ee88910b487 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -710,6 +710,17 @@ xfs_file_dio_write_aligned(
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * O_APPEND moves the position and the file size limits shorten the
+	 * write, so only now is the range final.  If it is not block aligned,
+	 * this is the wrong path for it.  Return -EAGAIN to
+	 * xfs_file_dio_write(), which picks the path.
+	 */
+	if ((iocb->ki_pos | iov_iter_count(from)) & ip->i_mount->m_blockmask) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
 	/*
 	 * We don't need to hold the IOLOCK exclusively across the IO, so demote
 	 * the iolock back to shared if we had to take the exclusive lock in
@@ -921,6 +932,7 @@ xfs_file_dio_write(
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
 	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
 	size_t			count = iov_iter_count(from);
+	ssize_t			ret;
 
 	/* direct I/O must be aligned to device logical sector size */
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
@@ -937,12 +949,32 @@ xfs_file_dio_write(
 		return xfs_file_dio_write_atomic(ip, iocb, from);
 	}
 
-	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
-		return xfs_file_dio_write_unaligned(ip, iocb, from);
-	if (xfs_is_zoned_inode(ip))
-		return xfs_file_dio_write_zoned(ip, iocb, from);
-	return xfs_file_dio_write_aligned(ip, iocb, from,
-			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
+	/*
+	 * O_APPEND and the file size limits can still change the range, in
+	 * xfs_file_write_checks().  So a range that is block aligned here may
+	 * not stay so, and the write then comes back with -EAGAIN.  If we are
+	 * doing nonblocking user I/O, propagate the error.
+	 */
+	if (!((iocb->ki_pos | count) & ip->i_mount->m_blockmask)) {
+		if (xfs_is_zoned_inode(ip))
+			ret = xfs_file_dio_write_zoned(ip, iocb, from);
+		else
+			ret = xfs_file_dio_write_aligned(ip, iocb, from,
+					&xfs_direct_write_iomap_ops,
+					&xfs_dio_write_ops, NULL);
+		if (ret != -EAGAIN || (iocb->ki_flags & IOCB_NOWAIT))
+			return ret;
+	}
+
+	/*
+	 * Zoned inodes always write out of place, which does not work for a
+	 * part of a block.  Fall back to buffered I/O.
+	 */
+	if (xfs_is_zoned_inode(ip)) {
+		trace_xfs_reflink_bounce_dio_write(iocb, from);
+		return -ENOTBLK;
+	}
+	return xfs_file_dio_write_unaligned(ip, iocb, from);
 }
 
 static noinline ssize_t
-- 
2.55.0

