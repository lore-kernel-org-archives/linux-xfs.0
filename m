Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821598;
	b=O7BlmwwiL5q3XElXGqUR4pR09BYHTRRSMcUdHbYuB3Mf11/924k69uWbBsCHQaBVRZ/r
	 HYjSHYCwjlt5Q8mj9Mo5G4Ukq9F/ypSby4ct5ZWvoqznYo2RJxI1ofFToj7f6SqG1/EPl
	 xiogAiFXm24TJu6gCtQLNdwru3lPSrFvGIyQFX+LpPd/lec4fufOkci/LDm5HwJEKaZn8
	 ZNkNxtJg/Fq7QYFBvySP8BJVlw8UClKhpIhqbnm1gf6PckC/+ZnObYC/Ao/KQ2T/Cmifq
	 QF3gfflcax6fkLYc67MV39A5fv9OAg3ijbTIFztXVyQ6lU+LKP/RTbOfU+DSArbOJRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=S9Elr35owCGoWrbIbOfwaKZniSZ+EtPctIpo1HzYHSY=;
	b=bFdxtAXp4sYRnWg5st98n1DjrPUxzn0ApMPMSCO0EgQxWf0dONVE1N0ZsIwynjbkwlLJ
	 EI1d43SBLkh2aQcrhEeRZxyT67MvYZAsqwKBtjz52FDeKh19qv8r4zZ0uHS8yIk0c/sRg
	 vUFRkAfwEpvrapdTWdb7+RKTAymjp4iyW6G3vBGzi4J2ptxGUEHXDSTmh6dIygjHK9xgY
	 Q81LjoCvMar+hG/43N4O2PFkPvF6O2BKjzKrwjK1En0umm+zbiNkAPEc5eeWfycPMPHe1
	 EJLuDxTF49RGSqSu0I0eUDrjRQLJMjKs/K0xrAHuA4jjhnTazwpUaiNdZcUEWi6IZtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RvREwzu0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BBE606AB15;
	Wed,  4 Nov 2026 19:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RvREwzu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727AD1F0093A;
	Wed,  4 Nov 2026 19:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821597;
	bh=S9Elr35owCGoWrbIbOfwaKZniSZ+EtPctIpo1HzYHSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvREwzu0R6whKyoXu71qOhrFoLqmcBF2t8nvu0kWwP+K2N2TjZvJbX6VaVkaiNyb9
	 QbGlR1+G09aGLijkLguxbBf/0pnUpx3UH+KVSnDBFZmFd7ToRJw1ZvStv3iMstHHkI
	 Im9Wd2HVXOsAuWnx6RKofYsXYTajly9BXL9EcoVBeHwJ0zk3oghgHGJPZFLhk+aqyX
	 oysqXl1FVZ9Q5zvJlZBS5Oa0/skwEiqpFRYNvf+CcsWNxsLYTFwcFibp+xwwx2Syec
	 FaN4H+Cxa3OQYiXj/gvhorF2+GV4Dk0NyLRqOwVa0hIQito/h1z4NHDf/p+DNKwg+E
	 XAr4pmTRpbiiQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 1/5] fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS
Date: Wed,  4 Nov 2026 20:46:10 +0100
Message-ID: <20261104194618.103332-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104194618.103332-1-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
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

The common use of FS_IOC_GETFLAGS/SETFLAGS is get-modify-set loop.
Filesystems could return verity status with GETFLAGS, attempting to then
pass FS_VERITY_FL to SETFLAGS is not allowed.

The ext4 and f2fs already treat FS_VERITY_FL in the set path as no-op,
however, BTRFS returns -EOPNOTSUPP. So, the modification of other flags
doesn't work on BTRFS for fsverity inodes.

Fix it for BTRFS and anyone else, the ext4 and f2fs masking becomes
no-op. The file_get/setattr() path is fine here as this flag is cleared
right before fileattr_set_prepare(). The future fsverity support in XFS
would also need it.

Cc: Boris Burkov <boris@bur.io>
Cc: David Sterba <dsterba@suse.com>
Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..b43977d5f8e0 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -199,6 +199,16 @@ static int fileattr_set_prepare(struct inode *inode,
 	if (err)
 		return err;
 
+	/*
+	 * verity is settable only via FS_IOC_ENABLE_VERITY; never through
+	 * fileattr
+	 *
+	 * Treat it as a no-op so the FS_IOC_GETFLAGS/SETFLAGS round-trip
+	 * doesn't break for other flags
+	 */
+	fa->flags &= ~FS_VERITY_FL;
+	fa->fsx_xflags &= ~FS_XFLAG_VERITY;
+
 	/*
 	 * Project Quota ID state is only allowed to change from within the init
 	 * namespace. Enforce that restriction only if we are trying to change
-- 
2.54.0

