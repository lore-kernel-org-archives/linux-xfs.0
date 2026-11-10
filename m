Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337478;
	b=yRY3i2bw4NaCwFm1pS7yqegyvoI8m3/kHTT4+Glwn5CWSMjjqPHyhad4MSUfG9vZDZME
	 2SPM0bs/v6T2GCUu7xQvO4BogDRXBstIprqcj/3x/MTGO1MdL6iaUrRzD00iHi2Je/ZJ8
	 XSpXjRBDfNvSYn0n/YJ1d0ZIUixqEFckY0XCOyq4l819Zam6SIGLpLDT/AxGxsAqPPKBB
	 Pjju/3m0hqXcFUl4QFNYtekbWJbDobQfztSkaFFCjvZCPgAsrp2SehDMcKozUavsJybxq
	 azUr6LJLkiQ9NPuAJ8AO67My7j7IdVRYpgaoCj6LhjwZtWHe1qeluqbqgd3vbg4ECLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337478;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rxdJ8KakWw3PUEAJqv8hxTpjLiDD/gOH2FhQaIppEkQ=;
	b=FuOhlsr8mi9keQHYcAzdE+rUCmxeneIXHFL9a92W0Jt9W+Qj2Zw4NZTLmLeVI1S2ORoB
	 VsBeZpRN6bVFIFV5dKfIN914VX69tx+F/VZgoAcc2cUZFkAYY08Ipl11U2jHR9JjXzk4D
	 m53O0IjIjGcmsifX8KkZOZuBQMG1ZrXMJY6XvaxL5XVLK72LR4P/AR38/zm4Vrbamf+hB
	 KfUBdSOTVID/zVrOZpK2WFjrbMzQ3Qk3AVmEtY4fKIJHMCgrnxzR+lZF5MzkNAhqlB2J5
	 tmOUKQR2T9uOAu8Mjok0rBRFGrLi4btH50IhMJWVI6QLcJDuVE0+VdXyU/CLRBVevuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CJdev+WC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCED060A260E;
	Tue, 10 Nov 2026 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CJdev+WC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7E61F0089F;
	Tue, 10 Nov 2026 19:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337477;
	bh=rxdJ8KakWw3PUEAJqv8hxTpjLiDD/gOH2FhQaIppEkQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=CJdev+WC9N9tkV8ySq3ssX/mOX96l5qFMJ3GYl3dc3k9gz9k8GWoeF/glaSUotU9v
	 0oiYVVBsmMzgF2Fyi1FEmW3H+S1X4F4nMA41ts4Od9KU6FkeoAzMJiT+ZdzUFJgc7w
	 ZBfC8i3y4gGwbYCdefT7h7IsP5JcPxLSyQyTcaHZZKRgfVjGzhmYIdfLXmvZZhz48Q
	 yrQV4XbQyTgBF1w9gQ7ttny/rTOXwAAcZm6qRnh/RB23ykNnGIXzVUd0gXpTYAE1Ls
	 AY1qr6Z4kvplc5JKJFp40zHJ+/kH3A7WO/Mzn8FDPPC2VrbvJzzuc8pm2RIaY5jfiE
	 dpEiNnnsGvcyA==
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
Subject: [PATCH v7 09/11] xfs: test for always COW after the dio write checks
Date: Tue, 10 Nov 2026 14:04:27 -0500
Message-ID: <20261110190417.32650-11-mason@kernel.org>
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

A direct write to a zoned file from vectors that are not block aligned
can silently corrupt the file's data, if the realtime flag is cleared
and set again while the write starts.

Every bio of an always COW write has to cover whole blocks, so
xfs_file_dio_write_aligned() passes IOMAP_DIO_FSBLOCK_ALIGNED for such
an inode. But it tests for always COW before it takes the IOLOCK, and
the realtime flag of a file with no blocks can change until then:

    xfs_file_dio_write_zoned()            FS_IOC_FSSETXATTR
    ==========================            =================
    xfs_zoned_write_space_reserve()
                                          clears the realtime flag
    xfs_file_dio_write_aligned()
      xfs_is_always_cow_inode() is false
                                          sets the realtime flag
      xfs_ilock_iocb_for_write()
      xfs_file_write_checks()
      iomap_dio_rw()
        splits a bio inside a block

The fix used here is to test for always COW once the IOLOCK is held.

Before commit 8caec6c9fef7 ("xfs: support sub-block aligned vectors in
always COW mode"), xfs_file_dio_write() made the same test with no lock
held, to send such vectors down the unaligned path. So v6.15 to v6.18
have the same race, and need a different version of this fix.

Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v6->v7:
    - New patch.

 fs/xfs/xfs_file.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 515ddafc6673..5fa8b07a779d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -708,14 +708,6 @@ xfs_file_dio_write_aligned(
 	unsigned int		dio_flags = 0;
 	ssize_t			ret;
 
-	/*
-	 * For always COW inodes, each bio must be aligned to the file system
-	 * block size and not just the device sector size because we need to
-	 * allocate a block-aligned amount of space for each write.
-	 */
-	if (xfs_is_always_cow_inode(ip))
-		dio_flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
-
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
@@ -743,6 +735,15 @@ xfs_file_dio_write_aligned(
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
+
+	/*
+	 * For always COW inodes, each bio must be aligned to the file system
+	 * block size and not just the device sector size because we need to
+	 * allocate a block-aligned amount of space for each write.  The
+	 * realtime flag can change until we hold the IOLOCK, so test only now.
+	 */
+	if (xfs_is_always_cow_inode(ip))
+		dio_flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
 	if (mapping_stable_writes(iocb->ki_filp->f_mapping))
 		dio_flags |= IOMAP_DIO_BOUNCE;
 	trace_xfs_file_direct_write(iocb, from);
-- 
2.55.0

