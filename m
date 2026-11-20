Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190325;
	b=eNdPqqApqGMLuvCaBYuKpysJhVxoetHgchirAMsJDQY+XmRIRPuq3UWf+dULiwXWMNld
	 JGGMhSefNGIqOAHBwVHj/LVx11nT2zJuzkOJrH4sBkiYyNwHJGSOMEzPlsftBzOTmozhQ
	 k3BSOSzOHC5j7OoFI4+9HoBswqFxiSNMovH6/gCfJuLwqQSfqbfQmGL5Y2W2NuZVWEfWa
	 VArd5ALiwjIPOTbAByu0dUBAWtumjYZ73jJxlkc/w4GH8HYKTd0+gk3lZ0+jlFzVtg/UI
	 db9oZZyvy6LGLvXFkDXsBSfkSQayYitCo1kGSvCS+bj4qC3d7HCfMhtjU1ODZAu2blg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mnWkXeEixkV36E+OlJRYXSsFM5UW8ahRncZQY5k+qDc=;
	b=3FS50xzsXLgV55sHqwABmakfbQgSof/KFBTU/tP/t2GNoXruKlkdCW52mytekD4Cwaul
	 vI6rTmTFF2/lCH7583RGBi7oabU9EIZK9EYpgIO3TnyAfzfpaTvLBBjpl38963Pz1kUO0
	 Jc328kN1Tr7h50iRahyyb1748xRmL3p20TCeS8iFTaMHntufmdLZDoey6dXAroDsqqfRm
	 Tm9joVjpT+pCBuWutdTko1/XHNXUDM+Wa8A2iqY++3DHYszjZxTcU4CvxQr6pM8SRVEfn
	 Ogv0T7Efz4BP0vnm2YqbI768kKmYhqxeLkTftD/X+iCI+hghW0OqOR6qNOpIRJTJvLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XZMsbs2W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC2760A261B;
	Fri, 20 Nov 2026 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XZMsbs2W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED14F1F008B2;
	Fri, 20 Nov 2026 15:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190325;
	bh=mnWkXeEixkV36E+OlJRYXSsFM5UW8ahRncZQY5k+qDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZMsbs2WiemOvFuzbmg4x+eyfVCd+pcWxUzPX1slXYkVJxKjJIenKdB6qcYJXGQPz
	 EMxUfEPqvznj+joHVUpDKE2fyZVkNG4bdf5kuZsA1k/6zboANy4IJV2zD/fYkBQRlb
	 o/RseUaoiQ/CFnKcTfZK/1cj97i1gtNG/TGsrJfCYTHOHOm+Uw/ngbArsY+T13XbVO
	 VDSFdl5zdR6sQtYgvv89p5gYT8Jrc4jZByA+tfDuai2gbjViZ5BSpU/iS023WHQ/uy
	 UjEIIQ+RagPiHqce3hq9iYW1n2SqdOLJix2WA6Ksd1zAHYL1Sqe9Z5X7iZR+aFw8Zb
	 +5wHOPWmYvp2Q==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 10/15] xfs: initialize fs-verity on file open
Date: Fri, 20 Nov 2026 16:57:44 +0100
Message-ID: <20261120155752.192025-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
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
index 94cdc3166805..94835d615342 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1753,11 +1753,18 @@ xfs_file_open(
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

