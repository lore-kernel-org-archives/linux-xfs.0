Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519978;
	b=dFC6/14xAusKjOV8DjJbbXxi1g79T0YJ7ykn75dF8yQV1ZjxOniPGHv+jpGqrvUqa561
	 nZOuhKw2I6gUsgSQ/5aKbPH+QsFI3914hk0DK1A0u344/92J12thFnDbIgWR+VQm8Jski
	 Er2wpTx+2u4bn0RDFCXmXblSe+JhEvimBtUah6Qckc4AypR/NjLpYp8TXhoEFECW5CCDh
	 Cv67Zjs8KfdTI83TI59mNUyXSxd8F8H4okOoLuij27tVTR3O82DkbtLMyNqG1Kl9NU8Tl
	 IQfgJtAjrz5OhxA5C3RZiivpVSC+6Zjk96T3QxakD7oNM/Q7SktN3Jrxx/bpr0m2taw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519978;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rl/PbKsTJF0pJDZxebmQ7rtJpHMrnVDAE4d6qabG+6Y=;
	b=AXRhHvF6Rg1QswQcWDANSprZ5FxW4NuCP8DEYBMyLz2UtiNM0lo97duzXBNJm66B6U3R
	 I0S+G+ImBzFdPXLVGqy3Q9OjqZmK/7T+60HQwo7I3cj04dvznc+t6rO0VRXjzYkA4wWzG
	 0nMakx8gI3aggECHxdGinqsyv7xluKO7IB4B56z7nO2AF3x89QznxyhhAgV4jqTWa5x+/
	 6W1tkhVIeBwDS3AEkVYz3F0CzAVe1x9BrJoemjEsNPSZrU70kPV9UwZ9vAKplfeER3P+u
	 eGWVzdxElDBvfwq3o9sALDUA3U2XMXoZq1BqJBWI6cpFPhP2fllHAUPnoR0cMkkaWjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KrjQv6la;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B5E60A2605;
	Thu, 12 Nov 2026 21:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KrjQv6la
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42A71F000C7;
	Thu, 12 Nov 2026 21:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519978;
	bh=rl/PbKsTJF0pJDZxebmQ7rtJpHMrnVDAE4d6qabG+6Y=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=KrjQv6lab2KH2JzsfKl0r6Td2nUO38RHztNAhP0dgZkwyoD3siyDsWts9QABX4j3l
	 K3QuU308unReJL+jqLsFxZ8BnaGLTwCHuZ5kPeYDD5VYNXffMAdiTRa/Ere4V7fmU9
	 /I3wHWUYZybf6gRzTwQEkTEjRo/vJba3H09e9W9kL03YsPk+XCBLeJe5kw+E41d7aC
	 nUUikl9ygoWbaDVtNH9LnMzvGHLxCBSkE2jzBnWCCxdCRNSbWmPh/AZnfsHsoygOOb
	 0LQ/A6r/aR8yBA0ZqSsuf8WqJcSYu0z35gwgvrQdAsgkeee1naeqUQ89Qb9oscereR
	 xb7dmFsLs+H8Q==
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
Subject: [PATCH v9 06/14] xfs: recheck direct write alignment after write checks
Date: Thu, 12 Nov 2026 16:46:10 -0500
Message-ID: <20261112214604.67875-7-mason@kernel.org>
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

Notes:
    v6->v9: no change

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

