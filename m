Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190301;
	b=bFMMfOEv4bCO8TcjgWuahe6LHUTtATGMh83RhOuqIZ3Na00FJDYRnBgA+MjfYO25336h
	 myxdniaUF4pX6sTBEKAK3g1Gznk91mZfLdYIf1vqHhj9X3zE9ImPwP3/TuN+MIHGbEBnX
	 iOyou/UhkoOw9iGZ14B5ilRSF2YYESkV03EY643NIdN3ghh1PCVrgxWNmR2r14OURNO7F
	 9wQtEZBbxTEN3Y4XLAijOIsu0VJ3Th6uMTLYBiXDL5NJwt1fh0+IWzebONnQMyDy39/qX
	 ZVnU1hSlgippRZiyfd4120yA+cKZfNcKC2h+b6c3lqSQ+WtduOPHIv/Qf2F4pYe1IFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HoodDwyFd+52Ad9MI4ni5ys2fShx7qglGwX+47OTbF8=;
	b=YcZkmQKIl88+aKq/2yJ3s+DGnVkgbmKYWOjF4nPQa5r28EzH/CmtuaHjB590yz+0BrGq
	 wKzv7I6JVbmcgnxJwDGhjgrusbW8MALzwFCg1C+kqp7UgON4yYPEbfk+xbfpujtDEIfSw
	 9qdpohuIl1erGm8fFuSPuLnrY5h3o1/B2jhkXFHwi6t1P7LY9+EpP65FyRQhvo8mLIaOv
	 P6SiunQLfzsKngdh1HpYURJYLpk4dk3YygESLd45hN85lFeIkjBVr0mhBUukbBkur8rKg
	 AruBYyMPmooAeecd3tmmT/k9ZeKKQXyf1LMnedy8pcSRmKbOJFFq5nlhDJtzWJNX2Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pw3hxK4w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE79606A330;
	Fri, 20 Nov 2026 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pw3hxK4w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2579B1F000ED;
	Fri, 20 Nov 2026 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190301;
	bh=HoodDwyFd+52Ad9MI4ni5ys2fShx7qglGwX+47OTbF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pw3hxK4wc3mDFy6PnEHiby/bgyf6z3sColgeZSR1DzM8O50RM+mSIev1XMFMsQwlY
	 NATpJZ4+tGGBaandfdEJls5fhGLIDfgT5jBT/8FmrcscU5sVztaJbDwSfYroUcmz4P
	 rkN4vE8ym9kApKsEXBEsnGPHIFzSVmTquklABqgxxmsnbegtCYRif5tdfmBDBBKhto
	 cfxLX1mtfE0jG2tf/6lSzxeZKoU4On4UU2ryLneZtSR4WhNbGJrO366VXbvMWukzbD
	 UiMMhkJjBaQeXL2hul+llFqGqql0wPeMhzhUaOGCvu8NjE5XMF+OxpZQbq2mbfOLJG
	 vZnGn43k9JRbA==
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
Subject: [PATCH v19 02/15] xfs: don't allow to enable DAX on fs-verity sealed inode
Date: Fri, 20 Nov 2026 16:57:36 +0100
Message-ID: <20261120155752.192025-3-aalbersh@kernel.org>
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

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ff12b7ac446e..f5b3cbe7dce9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1387,6 +1387,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.54.0

