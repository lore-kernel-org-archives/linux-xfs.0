Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AB13033E8;
	Mon, 20 Jul 2026 09:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538316; cv=none; b=Vzl8h/lzQgrtdO7jUOJmMziapYFswe10oC2HjYHXUITv4Y1Ax8Mdj/u6oosKCqhjb/XmBOz39WDhfc90F+HDaIL808qZe4Z9/AWOX6Q8kAPhgUMyDYST6ecd0hWWCW2Ak5plGbBzpwGDS2po71PE0IpT1BKeHYUcrLbAcw0JeJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538316; c=relaxed/simple;
	bh=npcBKJ6prTDjQpBMieXMMabW1h/6XVeQwDMsId6l6vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrIBnKRDRa7isWMtwUJEY3QtObEMmN8aXT4NE7Av6GtKGpy3n//Z+TPZhOS8K8PWJYh91Isz6wk0gDvzJM9CGXZFbg1abypjEx/ypm6HZbTNdYLOauaJL+j7/GC6lYT7NQ5oITdLmcARRkU7ZCt8hP97dAb/mY9wAcOpoqexog8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZ1pRiVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZ1pRiVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DDD1F00A3A;
	Mon, 20 Jul 2026 09:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538315;
	bh=fmzb25jhZDNq4cfG2tBZE1WMkvl/GQ14vrzOhert9WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZ1pRiVXQH7m0lMtKeVjtWUFhiy9gQ+id7Lk9deUWD1HT1fu/16I094RgyNr38bzu
	 qGhNLnU590aRYgMIkuO9MJ9Pp2rrRPkUP4ama2ohr9yNN/WAaVZzNx2O1R1+PbagW4
	 mtYD9H9/nrDil+NvmJ5wvyN25P1USZB+1mLfoHNw/ayfIxBbUP3Azn4l3P9+xr4ePU
	 tLZ+FpxMpcr5YqI53eZIctWTtAZIZ6hkO+Q1vizUEVuEc1mHCui9oglvCXVJS1bM8w
	 +Ha+JO2Jd9bSTSEAid/29IyhGGdwRR+m2NkJqGWD01nRJFMGLI+I5DP647ddwra87A
	 0Dw82M05aDVqg==
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
Subject: [PATCH v12 07/21] fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
Date: Mon, 20 Jul 2026 11:03:35 +0200
Message-ID: <20260720090410.3487990-8-aalbersh@kernel.org>
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

