Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E1245C710;
	Fri, 14 Aug 2026 09:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699638; cv=none; b=iePBKixQl0oTl61QKJDwcr5E14CCKNVnC9gWVS4pC6f0G7fcMR8lXEAdtx/wOtvY7tuiIz+eqLJgIZYeNE43LDBe8voA94z8amSr080Hh9WqY/psleStk8oVA3ci2gs6mPYJs+9RCI4/HYL48sU62PotxJk0ai+s8WVUnEnbPd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699638; c=relaxed/simple;
	bh=08IlujqPqVk1QGQ37v/KeGG0OZDBxQsHen2T9yEOLl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nr+TDEy5Zr5NAemaWFUzkdmfSRsXKaWA6ek7en1GKqNVRtk1Xu7McIj61KfjO04B3CXksszqT480sKOuNTexCSun0A9Ym2Vqc/p52bnFEYJVPJKMcL7gBN5Kk2BYK+1PBym+pQ1w3gsS7PZrXUaIZCF/YpioTn5y8LOPqzS466k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhO+kJSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhO+kJSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0991F00A3A;
	Fri, 14 Aug 2026 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699635;
	bh=FcfrVvu5lchr1e1sUVC5XjbFLS3hhJKHv222lwYU8aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhO+kJSic4st/GaZfDT/Wi9+tPgzsrJZ2HW+GBlSBmv1Ycgc6PHiBW51kFO1T5GLQ
	 n25hvGdwvsfNd8xI2lGbM+7RWeS51bpC3nVWEeY9MWIXFFxD+JAO4puyDn3g8eC0b3
	 D98ddNpvhIK1kfU4q0KzE/3dIGWU1hrIe6kUnlxLoUVJuTrQ1WTvL0vyJrR8yQ6hT6
	 v3DMM9sDuIktccZ8Kvz7s+FgMNTXXVtoOCaO0l/+1NnKHqKTDE01dGzYoBlKUFBN3T
	 ZJyTLXnlXFCbR3vaHHa90OVIFvzkN1HuIOit+CSlr6u3JX3ko35vJ+0dNYiN1+R0fj
	 FUXwy8LX+IeQw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 20/25] xfs: initialize fs-verity on file open
Date: Fri, 14 Aug 2026 11:24:37 +0200
Message-ID: <20260814092448.1818082-21-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1bedf2ef647c..a9775415f3fd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1721,11 +1721,18 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 	if (xfs_get_atomic_write_min(XFS_I(inode)) > 0)
 		file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
-- 
2.54.0

