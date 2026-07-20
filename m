Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED943033E8;
	Mon, 20 Jul 2026 09:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538314; cv=none; b=h1O3539z7c0N0fElFy/JmcIA8Nu4hWE+1Hh1d41PO40yHzyZZ/xt/j7e1Kfmu0gmXezq6ZN9mub118b5vYGcsviPrh/sjWpnvGNLYlvS5uBqYmv8hb2wLxydJZS373uJDEarL37xxesG4w8+dwRwFOvyVXHPwp1AdK/zeMdt1cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538314; c=relaxed/simple;
	bh=8g5BgA9mURecCv/apzQ2hLH2SYMpF55oRQsaZ2DgY7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCDXhHD4ce74YLqmPDExJeZbnWUTpYGCuO7aN2sxlzT56BcVT4Wwetjdy+cl5Dl9Vms5GoNf5unJiYrLgbpna5/oFlB+gtzodDENRjbK1EC116Jhe2FTTm0GxWBGWOq4kmd064qmy2mrmgy8C1+GcvBHdM1fj6sjMRupSxUVei0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVW1dtxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVW1dtxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19731F000E9;
	Mon, 20 Jul 2026 09:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538312;
	bh=VICvrkHJ76P3bbcz027VoiEo6h6DpXS/23ki+zkvasE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVW1dtxShDB7yvxNE2U1Xk8Tx8XDX8xkJi7Wvpt5y8Dstpsy50aKDpEI4+xRAReaj
	 Z+fXJqPvkfF25zDXimvrFQK8mVX8oyxQEHnFa8JPyHRpdgMh57TlaMkSL3rAhNdh12
	 XZHDp/EHkoDmWkE6dBcAZH9JRGX3sVJIfUbYCbZzwbkG4PR93JgCqWNWepe5piKDcm
	 SG7nmtLxPdTHhOs0+D+KMdE66mu3BeLZgq59ast5siiF6P1zBwy/DRlsnCUExNeo/q
	 kY/AM9aFxxVxAtdCBy3H6jea5mbvVgCmpVOScQxO+y8ZBIRFnl7kzFKsT4HSkwEqg/
	 TlKuCh+znfTfw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v12 06/21] fsverity: don't allow setting DAX file attribute on fsverity files
Date: Mon, 20 Jul 2026 11:03:34 +0200
Message-ID: <20260720090410.3487990-7-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
it checks if file has DAX enabled and fails if that's true. However, the
opposite case is not checked.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index bfb00d256dd5..5424ec4e3949 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -246,6 +246,11 @@ static int fileattr_set_prepare(struct inode *inode,
 	if (fa->fsx_cowextsize == 0)
 		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
 
+	/* Can not enable DAX on fsverity file */
+	if ((old_ma->fsx_xflags & FS_XFLAG_VERITY) &&
+			fa->fsx_xflags & FS_XFLAG_DAX)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.54.0

