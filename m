Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630558;
	b=Mlj0o/r2ACYFKd0M77IKh1a4iMQnpwZUq+FP8f+od8ePMAced2Lm0/+JVuP6n5yCrlgZ
	 I4so0U9DwQMZoPj5h/cTwzEWe+0zLuqg40diW2xiSdPfHW7GlL3069HGcbLaIMDJAStTM
	 nnxmlKcVHZqRBs8FetwCsa/ReABXSaGh0OYnScS6nVwt7y/tyc037RfkGynnLloFZrjYe
	 4W+momTzdml6mLwNQMuemQ6lg+YlNYYKDutsMmLhZMtmX/XyastJPdpPyjt9VZQ24xsJ2
	 bzQJCmcEGNkO43SJXb6bXXD3r38omCSY6ChU9xA+HmZ40E1IVsJ9jIZzIEHPV+Jzl6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mhi8hKhT1wsP3ktcPguqIrg7y3lPp+S8z3kD7+SeFPI=;
	b=v3CnaiChXpK7LvLq5cpy5QOrYZe7+o6ReJ9oDkduXcc5jmnsc/2KCJB270x+WHQH/Ujc
	 zjsTBYT3iAzQ7+eIjn/jlF3ESRFLYpgRIyz2yinhG6yQk5lMn7qyGadD97KX+8n9mkqBZ
	 0DHBL+eFBYLs8kaRxrg2G4wLOD/tXUF+KJM1T+e/uLgvuscwUoasZZILE2rBp9zm8HzNx
	 91z2LSo3LD0rE5z1Xe+37XoC0bvB9qJhi26+RSRBEdiShpg8n6IKRzr0V95ECSGFV3Eig
	 MTxSD+Oaj+c3djrxz5vrlowuyYTP6PBL074nxkTMfOLSDyIAdaToOXUz5USRjHKA/OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrJIOEL3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2D4607E0E9;
	Mon,  2 Nov 2026 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrJIOEL3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FFF1F00A16;
	Mon,  2 Nov 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630557;
	bh=mhi8hKhT1wsP3ktcPguqIrg7y3lPp+S8z3kD7+SeFPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrJIOEL3pMDF7YTeoNxecujV7/1g7ng86AnbKA7vaJXzz5xmxD5hDUACsr96MoLZY
	 byIEGsuZxbEknUMEhfVnRSkJ6Md8HOkN3QgCoUvNJ2XqMUJGSMoItIIn3HRTVsCPNW
	 gGoJiYGwpBlf0pEpojYXxuiEKRJBKna/4Rp9cI5uQswBz6rieCdBZq8NIx837YZQkz
	 a4ndu3fmQcAfPwjbzdiIyaGlQfivX7XEfbqwM9zEdqlv3JSIzowxL0P6dNef2tQHES
	 yhgo3BNtVYCOlnYor2cHQXXwKb8VQp0+djpzUV1R/f69Eo9htObMu02Uk8YlahUg08
	 GXNe09/04awxw==
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
Subject: [PATCH v18 11/15] xfs: add fs-verity ioctls
Date: Mon,  2 Nov 2026 15:41:41 +0100
Message-ID: <20261102144147.2393369-12-aalbersh@kernel.org>
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
index f81b6e52ac40..37c6a2fae58c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -49,6 +49,7 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1575,6 +1576,19 @@ xfs_file_ioctl(
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

