Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337471;
	b=F23ucLmOmT3NZkAmFDGB4X4NyoexNWTooE6M0566mMwbvtSnIDQWoyPJhhUpx+Dj+4Yv
	 jENs21QKihjapYMeJKGwBZmxtwdkM0JvnSwMqdbkCZnXm2aIp3FwAPWTqQ6gCE5Ynlg86
	 bAB05KKDymjx89ZK4Qme2smqsF8JfszENqgn0uO+9gIK7+gtX08pE1fGAB30SAGIwiz/N
	 xmZJDJuBNUYjO1ByfupAr3BPLOL5qealAB/GAIB95BSCwdHxLUAahXewRQHxSyKeCt9DT
	 HyqprzB8DBQGcKYWFuwXTktymvtYMosdvpZRtkAMyhM1DoytI/WlMOv1+El0IUt3E3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337471;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mKZp1cEAstiO25PQkTLbAIw3ePZ/EShNAvHBq53tKcg=;
	b=Xe3WuC8NEFqkApre8Lnp0QtYpotN1sKkAcaa3iFOukrjr3rYgLel9Cgu5Je1Vka6qmTT
	 nI9DfaMYMaJ4+sYAbaAOZKJ6qQVKINK8rDTBzmklJGQKA/d2LplB2Bl8Db+enZdTt0FTe
	 qhLQwOgROc7snOXtNAxdh9L5eSTCZOCauwqAzt/y9D81oGRQIjx0+UW9eaAVM8KQNlnxQ
	 9zyDvWi/9bdvmhGhJbIRF/daMnVCVkw15qMHA4LSMzkdV6XCTW1OLFqy+CR2mqfblaKst
	 hMjAwQT1uPvsrsdgL1eTSGNcdX7zEjmXCMqmJc56lUi+6k+GoiEnRVEAlnnacONl+tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FNRD2O8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C5F606A32A;
	Tue, 10 Nov 2026 19:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FNRD2O8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAEE1F00900;
	Tue, 10 Nov 2026 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337470;
	bh=mKZp1cEAstiO25PQkTLbAIw3ePZ/EShNAvHBq53tKcg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=FNRD2O8VP63z3MXtC8IS3ayJv1quqf1U3ya1Ou39JBOFmF+FbvtnSpbIlPR7ny0IM
	 vHjkoUI+LCc47rPqiYzIChOP1Pbb1buS+uTKK/yIR4VOSUd0ZWZ/HPEAe1/slgoyEn
	 c6Ne92W68yDt3XEBo51NqteMAik9dWD+Asdx+iXXMd9KmTX8yC/AkaiUAWK+iqXVJ8
	 5HgdsbvrCFgutruVaCuBHjwaX3CKkMSsxJ0UG+YjIZKbFVRINAa54ZkVxo1dubQqXQ
	 oIP170P772K4++0wI4AuGOLeRNd550QPto77tEBKGgOGr/g0xX73fdZfyW0W+Vkrmq
	 2Sz7981Gexmfw==
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
Subject: [PATCH v7 05/11] fs: validate atomic writes after O_APPEND and limits
Date: Tue, 10 Nov 2026 14:04:23 -0500
Message-ID: <20261110190417.32650-7-mason@kernel.org>
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
    v6->v7:
    - No change.

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

