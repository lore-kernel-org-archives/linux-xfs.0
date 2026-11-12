Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445368;
	b=rVVyJZEP5dD4MUK4yg+yzcRMTukkNemRFS9bXbJGdO1mIGJhVfO0YocTICCXeso50Qnt
	 yTBp91DwVLwzdIiEX1DYGLBALaUW6B9LErxskJS+QbKXXTee7Pe4QMvCXxsBs2E+XKoqe
	 9ZMeeTC/HkJgqawPPREKe7qV1xJn0jFOpRF6aJhaSA9IJVcqv3bPaj6yA8RDazdaU7lTV
	 SNUf1JNQYWbqfijeGjMMAzT81lQ0ElsyihQIsuwCvsqShYMonqxftHRfU2tvVnwJch/rI
	 4I19ubVGop9SakiySbcsKU/SK7piz9ycRepqIlacbR5+KnbcwT6eYIC/5MqzwWXhzag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445368;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lUK6YF1bFMngqoNDc85Bin642rb9R+vc3V9PjQqVUGQ=;
	b=zom0cVreHpyk+eP48o68lme4MRQWWaXc5MKiyVO/R4YPuycXCDohv/RiPNTiOH0GaRut
	 zg3vnWkSv/xxRJ9RIKxpJZTL3iNuq1L9m3K96ewhNDJfjfSOWGyCQMuAynZGJu/k3unA+
	 tzp7Zg9634ld7EyrXzZGIww7lHt+KxuVLW0hDObULPgcTKDjF8MME+M9kL4wedHg7O649
	 IjUr5/13ea9Pn3AEO5YSPKsv27aXdoYjzCQIkihpq2LHuxRCc5ZIk3hq+w1Qm2T51c4W/
	 IklgMmFO8xwFJduEBxoV7kOGuVZUyTWsFi3hTeGdIui856iBOleDKSSxvdP1RUQFG4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBgk95Eq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FB860A380D;
	Thu, 12 Nov 2026 01:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBgk95Eq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287811F00A07;
	Thu, 12 Nov 2026 01:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445367;
	bh=lUK6YF1bFMngqoNDc85Bin642rb9R+vc3V9PjQqVUGQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=WBgk95EqNsRsMZcxUcCQJHikK1racZ9a/NUhLXMJtDo5ERXoWjaz8RQQSrvHnz06J
	 vp/gtz6RfJSUTPL8byINzazHSfbXj1BlwZM8z2/k+rqZQm5ELKqWCyb4BBM2a7m74B
	 6KSIHkMNy19oQiikRqDLfsco6zjgSfBL6PKCJ1txEcKC0WxjA762ijvCcfA9SrETPA
	 viLSNfWwNwjj5EJ6oSpLLmAXtea1eqo/obDWLxpzLVcFhi5j0epw+wDld4mkSm99CH
	 W+EbDLGjMGkF+hccOsjGEutriQiHGsYk9WV0u11OFVkXeQgYyk+SMvfyPrgDM14VR0
	 1tg2fwxyXNFXA==
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
Subject: [PATCH v8 09/15] xfs: test for always COW after the dio write checks
Date: Wed, 11 Nov 2026 20:02:38 -0500
Message-ID: <20261112010229.51029-10-mason@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v7->v8:
    - Added the Reviewed-by of Christoph Hellwig.
    
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

