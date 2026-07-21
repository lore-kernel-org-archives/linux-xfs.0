Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDF647011E;
	Tue, 21 Jul 2026 18:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659457; cv=none; b=TmmrPiq3W2KTjVpw5GSoWIOzoD3vuMJPNHEhOBGiZLhbtte3UtbjuKatke6bTcaVxBMRJuKUjZTV9UL3t58Jar/gXx/se0tt4wAbg7EasTlawmAjeFbMPCFmPj1Vdbyo+QjDGf37iDnba3Z8HmFOf2UgqnYeAd+RgDfcK3Wca6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659457; c=relaxed/simple;
	bh=npcBKJ6prTDjQpBMieXMMabW1h/6XVeQwDMsId6l6vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndfscoJzxuAQoLUpkobb2HvxWu/gJaHjcVlXR27UduZMgI+p3o4Egq0caC9EZwWzDg6+ZfpH/ehu2FdOkT20JUr7OKmGv9Q8dSoAWgfFE9drelR6ACtmGLIi/uQFxVmgiruxcpeNaI21a/4Jq20OY24Txw87Jj2dlGOGJnVloMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLQlBmiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLQlBmiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A68A1F00A3D;
	Tue, 21 Jul 2026 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659455;
	bh=fmzb25jhZDNq4cfG2tBZE1WMkvl/GQ14vrzOhert9WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLQlBmiPCAKL5xe2t/n7HpcDOcLcgJwlpHxf4sTI6VxBgIvHsR70OO8uHlSHQUGYy
	 mEsy+hk4m92M0PDm89kHugj+4Ao1Hxgd5DKDYcelZ1KBac9k6GegVm0eTaKlbwCvII
	 svVjfJB7Mc/+QmhS/4vroeRbGnnoBgaDsXckoeIOrJ8KgXQt0/ChPQvmhEIaQvWdvX
	 sRUImd4hme+VN8+QP8xQ9iqcvHQYpBz9vHrtoldSURXDXBml6DRzPo4nKXQprF14PT
	 7GLRdsbpNB6h9oi/vGPZIZ1RpM7c5FJ/UEAyIp9pGji/B4Gbnkghc1batSR9eQf9X2
	 22UWt867AzNbQ==
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
Subject: [PATCH v13 07/23] fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
Date: Tue, 21 Jul 2026 20:40:44 +0200
Message-ID: <20260721184346.416657-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The check that fs-verity is available in the kernel is not necessary
here. Filesystems could have fsverity files even without fs-verity
module, then truncate will succeed. Previously, this would return
EOPNOTSUPP if verity is missing, but if it's not EPERM was returned
anyway.

Fixes: e9734653c523 ("fs,fsverity: reject size changes on fsverity files in setattr_prepare")
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/attr.c b/fs/attr.c
index 4f437fabb7f0..71888ac903c2 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,7 +176,7 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
 		 * covered by the open-time check because sys_truncate() takes a
 		 * path, not an open file.
 		 */
-		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
+		if (IS_VERITY(inode))
 			return -EPERM;
 
 		error = inode_newsize_ok(inode, attr->ia_size);
-- 
2.54.0

