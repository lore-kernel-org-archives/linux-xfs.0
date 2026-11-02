Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630555;
	b=x6tKmNZuduNSAMVKMlyI4nxfvtaHHlqc7PNgoH/i3teyUSi5VeFQ1wtw6FQuYCuyKONd
	 qB8/IOv597YwquREswo/1CukyhQe42Rt0HuKpX/1dSPRpdh3BPDysiz+fafz1tgfBenqD
	 ik+FDj14fyb8GcPuOxOHO1tI+tGnEAXAW0FKpFsH0YQBgwLDfczpZo1//ZH/eBeMxNDK6
	 CNHreVIlOXGOSZlUdyUZq3FdTOsM1SCmDFPhtHtH+Xop7InGcOAWvTSP6WS+lphdO5Vk0
	 HB1JuemqFOROwqhnQ98NgShUHq87U9s4cD5g82W3y8tEZ0s8d0KviDQ+o+xNgYsBd5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TLtUxR+/Tr6ujbyljIYu0n1EPkoz4aYMHP0/3Q8WpVw=;
	b=uL1/zz0aYbLH+h6Pgco8dNm+wjRG2GlgkVcvNh7NpiRYHICYFbLL5R1JcYwL8vcGhLkq
	 GP0l8zWZQiweCvApcolIpf+dMx93lwIK7+wxGl/J8/7ZOrEvQn37J+JQuKW+CgFqA9Dfr
	 3LEKgAi8fyFLruRNdrH/YmuiI448HxGgHhqsemTz2m41HWksNq92CVI4eKxFXMr96t4xf
	 F1FzREDrfICVduC6DTQC4LsD2xZACUj8Cce8sPZqObEVklhhBQ1LRaII81YYEPNTfPNOM
	 LtGExjvZI9IFxSfXo6gfgvfxiDNimHyZIBWZtHlOShMVtVJRQecovgtXzHY0GHF9jnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvQmmpqC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12334606FB7B;
	Mon,  2 Nov 2026 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvQmmpqC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40BB1F00A1A;
	Mon,  2 Nov 2026 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630554;
	bh=TLtUxR+/Tr6ujbyljIYu0n1EPkoz4aYMHP0/3Q8WpVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvQmmpqCgandJEhyQdJpGv8aQjo7kyEoOShrr8GNZzFGwmTYFDZcj/lye6GLRLNKp
	 hSrxPja8lrVBqTPmTsxeXWOcbg5dMNVG0vb+qvnIOEkdTZWce8IItWUUk/6nw0znB9
	 Bt5cNJ2b91qFCdhs/rKnzS0+lqsMkXjwC2qUyl+OdWO3gfl8CP1DNdfoM1VQ/8QCwS
	 5mDv8mJiinYHjdJ5CFz+HQa1jpvQMgmrD3G3DMNprIpOzF5u7YJPVQktGN070aRFbU
	 r4mcUpd8p2q2dACrUT3DjF8984vHKmzLjG7tWKej+srAM1Nk1nPBftvtzl6AAjQkWZ
	 J4r6NHDBR6CTQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 10/15] xfs: initialize fs-verity on file open
Date: Mon,  2 Nov 2026 15:41:40 +0100
Message-ID: <20261102144147.2393369-11-aalbersh@kernel.org>
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

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dbb5f8f59678..a610adc90c02 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1793,11 +1793,18 @@ xfs_file_open(
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

