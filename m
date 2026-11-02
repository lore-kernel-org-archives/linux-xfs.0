Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630560;
	b=dKp7k7AIpx41r3F350FVmNfIu57WCcSx6rY03FO+EqY8uySg/haVEajLOTp0UdBMYyNC
	 /szkHqDjbNB48XoZJd/gxa6YHWW0ANL5X2fiXy3NSzgxZWyQkZu6e9DBr4h4BFkHGx+Q8
	 Jt5NuDBh44KnwdIL/6mnCfGFWe9G0cVcrADkh3ndMTr04FG6iBRAp0aqo/cVMiNswSJY9
	 5/11725ISmhyH7k7Jb5knobWhEOKP8xJnpHKEy70xTvPSFtTBJ2eVO34t2U7hSrjtg+Uw
	 t2bBGf+k7mLTKRR6BRi6rs0KD9GisJyJkN5VJfaxIex4my2Kr2bOe30dFrbV/Mu9koA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2WPQVUYZvUdIxaKgiNTH7bti6DRxAsvvFMcWeztADhI=;
	b=a/EjW0ZllZNNFD4gkiW7xzw0h9ZSBr6pRfXP0BVdxg0k190o2EPcVhPEbUBKO0bC5+JU
	 Xzm086JbbI5CWWIEc41yfIlC21c41CIWGViMhd8HjysLSvFf4Yw/BkgFJyMMfOftrcwCf
	 QSEuNnv/4FHYsSrtgWqQ9w7ct5Ps8AW1DqKh5JiVy5YKVfkLmxyc8zCYJKaIChpW3/rr0
	 5vuRwQzp9oyLIj6sO9LpwS6jlYaIvMR3VZfEBPQIHThI/aqPGwPjMWgqPVAy2zZ4LQLuM
	 MERNT44ts5fyQUszT5LaLhan6jIbpO3M8bsE/9lbbl7dIh/JDf8uFU+Cp1YUr+vrl+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NDerxYqN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E3C606A5B3;
	Mon,  2 Nov 2026 14:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NDerxYqN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00351F00A17;
	Mon,  2 Nov 2026 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630560;
	bh=2WPQVUYZvUdIxaKgiNTH7bti6DRxAsvvFMcWeztADhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDerxYqNi9cwRi3J3Axa9KLDqWn9k7L/me7jEXXZX5Jmdd3MwdMJ0nZK+H/IYYlFw
	 SU5Vp0SjZEmXZlkrexnhD1UOZuilM5BJ7kpI9FAObWunY9aBc6Mr+dzmTJFPE88THb
	 rO+WqdP8FAk5av55HZ/W/wZWsvWDzhW47y+/4Zxq07P98NU9k+wveubI1l8Sv4bwNq
	 GuLxNC2kNTYleRdQI4+KxQixid90Inz0MZWbM61OsuBG0DKj4/FkhE9gTnQwHwuBzV
	 Aq44RQ/sHJuZLSxg52V7f17USLeNCQQHYob/VGLEqyfZgv+8q5TlR0MhaTECMw7oZm
	 L8qdS0I8hYE9w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v18 12/15] xfs: advertise fs-verity being available on filesystem
Date: Mon,  2 Nov 2026 15:41:42 +0100
Message-ID: <20261102144147.2393369-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 185f09f327c0..c80133784419 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7629fc3f499f..3323b8dcc793 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1546,6 +1546,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.54.0

