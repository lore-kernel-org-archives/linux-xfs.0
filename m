Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190328;
	b=Liwo5cNtjdl3VC1y4YYpqXp+b+pDk84Pa6poQdaUkQPS9MPkvqJMZUGKbg6+gTyDVycQ
	 UHwc3ypWNIIsi8T0msyi/w/017D/UTI0FlqYuRAQ/GAWzdxTiLxCD4b+hgUbSG1uR0rtX
	 8nYLocikpsXV+TidDCroYcDRbsu2eOocjCWaSdMRMJapDuf40WkAoTLNfA4vCjLludhSA
	 yLZoEiBqdF+BR1NXGjSa0bMTAnpSVrNfHbG57ya3fvMIDoljM4k83AnZTytd/lux76VSu
	 VYELiIcjaojg41TpOxROf197K34nmlDZoZ3FRRqXnbRbgFigJgD0sohtNmrO3wo24zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kcnLCVeOvAnbfn1FDI4YrZWNTy/6k+zpuCZ+0SsF0UA=;
	b=cUqYGcoqBY8r6eQCmLZy44dSBqxygSEggzEXIHSZnEzjJwh+yD/2EF9GQzHDCJ8RFe6m
	 uZS2uDdTyMdUwpo8lUn27pL5tvCGgGMve64bwa7PPmDAlDwhpq39aymjhgM1JX0Tx/3L5
	 xJgUbOJSz50O9eBURH8VeX8t6Rd/dN5YdouEyjNl0uCRSnlkBcjEVvVa2Vppa0zE6Jjss
	 Li3vXxVRIga+uZsm5pEm1zFyszA2nQYbgLsRMWXErQ4OwPiXOZ9tfdPD1WHA2/YmhaD9j
	 +Cdn35wQpGkRNssJbdl4isrJdbc5PRPCooNwIKoHdgUlfON2/fMhfx7cXTvunZgcUKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="BJ/qD3q0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0E0606A330;
	Fri, 20 Nov 2026 15:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BJ/qD3q0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094271F000CA;
	Fri, 20 Nov 2026 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190328;
	bh=kcnLCVeOvAnbfn1FDI4YrZWNTy/6k+zpuCZ+0SsF0UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJ/qD3q0a/+2k8uq/mO2jh+3ycIa3E7zFsmSEO/iWOwQ0PEADkzIZcOWRZbHlZUtw
	 5HhS63lEEWbBTVzfo8h9Kf3s+oigNG6TENqXoDNLcd1qoOUZsE+hJhRFAc3T5wn9QS
	 NArOJA68ClsEm5NKQtxxbzVlomCbY1vsieIXJhsx/KMuVQVUO5giifNbPn9OI8xt9i
	 xJFcioAtrYsi2BdIJdjpTP52Ts9cwHc5IySGgV/Dzz6Y3dvxPB/S1RN6lCOi0BORoG
	 jG8wZBQUbkD707ivSdGCuNtGHQ3hRFYvhhBmo7GjdP+qs4DUdSQ6moLx1HGCQWv4dT
	 6TGSNkdN3WC8A==
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
Subject: [PATCH v19 11/15] xfs: add fs-verity ioctls
Date: Fri, 20 Nov 2026 16:57:45 +0100
Message-ID: <20261120155752.192025-12-aalbersh@kernel.org>
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

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

[djwong: remove unnecessary casting]

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7c7435543051..2d0a2d37e71c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -49,6 +49,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1594,6 +1595,19 @@ xfs_file_ioctl(
 	case XFS_IOC_VERIFY_MEDIA:
 		return xfs_ioc_verify_media(filp, arg);
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, arg);
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, arg);
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.54.0

