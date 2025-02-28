Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F3A23CB
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 02:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740710975; cv=none; b=Kfm7hDYB/eHk2jvlDRdWM4zMUSJAXSgX/kJEX/TbCQ7V/zwtDPf+em87IZ0KOCBmZY5DoopLXn8YXIWINqnfCbK1FWx+ESCmsfKeLaIC0+3lM0vArelbiuwcm3ONIaUjT9vuEpvPsgG8WQuUwNQcwXfABgTbaKHTSu9J8vr/3LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740710975; c=relaxed/simple;
	bh=NGneAqcPa9uXRnmOYI7TQF4nMDkTJ2vJ9JtxfzZEhl8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A1s/zBNdAvCZTgikD6RaighjV7iRe6eddJEb0fD2SpfT77PsERjqBQtjK5Lwn9K7738SxHmCAfcupVNBzTgWVyXzp9XK0ok7P73fGgvzmdw1mWUKOcP6eaALssRibL3aIp9+dOfx17d7XeqbIHoOi9W9G3c6MqPkGdjRV/MxqWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=J2S8Rj5P; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="J2S8Rj5P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=yWjiI
	zfU/RA5I19orKkX0tddrj8f3zVyDIkfRACWU7Q=; b=J2S8Rj5PR2LSAy3hZvFTK
	R8Tis6mQdT0jxtKISvSwSMuUxKscJ6Y0PXRt6baU+lYWsXODHNLuUWoJD/sf+Uvx
	I89sYUjrmeJoquWrpwTMQp/YGuRK/K+XHh3xHsbLNgq2YlOE7snaWGXGJLyRcXQu
	WcHMrqnvZbPioaSELt0VEA=
Received: from icess-ProLiant-DL380-Gen10.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDXT20MJMFnHQ_VPA--.15749S4;
	Fri, 28 Feb 2025 10:48:59 +0800 (CST)
From: Yuanjun Gong <ruc_gongyuanjun@163.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Yuanjun Gong <ruc_gongyuanjun@163.com>
Subject: [PATCH 1/1] fs/xfs: Add check to kmem_cache_zalloc()
Date: Fri, 28 Feb 2025 10:48:42 +0800
Message-Id: <20250228024842.3739554-1-ruc_gongyuanjun@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXT20MJMFnHQ_VPA--.15749S4
X-Coremail-Antispam: 1Uf129KBjvdXoW5tw43AF18uw18tFykXr45GFg_yoWxXrX_Ka
	17Kr1fGa45J347Ja17Ar9YyryDtw47Ars3uan0ka4rtryxZFykKryDZr45Zr17WrnxJr9r
	Xws7Cryagry7AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sR_FALtUUUUU==
X-CM-SenderInfo: 5uxfsw5rqj53pdqm30i6rwjhhfrp/1tbiUR8C5WfBG--EfgAAsR

Add check to the return value of kmem_cache_zalloc() in case it
fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
---
 fs/xfs/xfs_buf_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 47549cfa61cd..3c23223b7d70 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -880,6 +880,8 @@ xfs_buf_item_init(
 	}
 
 	bip = kmem_cache_zalloc(xfs_buf_item_cache, GFP_KERNEL | __GFP_NOFAIL);
+	if (!bip)
+		return -ENOMEM;
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
 
-- 
2.25.1

