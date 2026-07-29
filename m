Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CFF446C01
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325205; cv=none; b=VxfYEzNmTY99Moj8VuZtJeFvICnd9luJP4kFMvK0xGf1Xh8zjnMK9dQBz0dvj5kHGp/UctLKpMvwaz0dFsa+UN5R+grReX/Ho+r56rVxQ5x8v2vvWWe7rLt6J+UMXOmoP8QA1sMUhqVXV3O9CRKB98mQa1qtUBfAEsR0QwntV5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325205; c=relaxed/simple;
	bh=XBgeXh4VSTKCS6/yMewDTP3aMB8mEyjNsaiR2QbJUgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgwLkE+n1KntHpkdUczx8KBfvhW+O5STJ8YjTMCqXtGpSoHfa+/JuAo1GknzJGl48KNsLqfxUkbMgQ7GWltwsRI2sviIqtoznK/+lQgUIPBf3YC8TElw0xBfNbgUbkWZoRogtwV3PKcOLppMLjeIZ4T9M0NrUvoh2S5fACHdg9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YuVQqvH3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YuVQqvH3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2ysKG/QXP9FDep+jIVlqPmyIkmLTWEAU/TcsK4C3SlI=; b=YuVQqvH3+VTDsjVd4FkE1NvfPH
	7sCvGbJhjkNESatbwhUxgOK0Rw9JZmO77Z9IW7tDZHCUQzeIy//R3Ylg/GKUJG/GK6vSIjrlVgu7q
	kWjsJ2YOOcT66maoZNJSoGvcSwfeyjRew58oJMj46A7okN8+OfaSEyEcgXa7k9YsiuyzK2wYdWH6k
	DBl9mR7aw0FCjvURki+R8a6W/6Uy79ZFGVtovqssWjVvG7Rw4w+BxwXr/0BUxmhRBxbmt4Jucf6ac
	5wQWRvvqWtrZ0vv3txUfBYPQgaJjBK3ZnB9Tpfp95r4vV3cQLOaMnjFFdGa5S+Rism/DAZrySWXuF
	NF27u4Nw==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2dn-00000007l1M-2XSf;
	Wed, 29 Jul 2026 11:40:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/16] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
Date: Wed, 29 Jul 2026 13:39:03 +0200
Message-ID: <20260729113952.2255638-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729113952.2255638-1-hch@lst.de>
References: <20260729113952.2255638-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Match the naming scheme of most other ioctl handlers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9a10645f5222..2d68b868b4e2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1183,7 +1183,7 @@ xfs_ioctl_getset_resblocks(
 }
 
 static int
-xfs_ioctl_fs_counts(
+xfs_ioc_fs_counts(
 	struct xfs_mount	*mp,
 	struct xfs_fsop_counts __user	*uarg)
 {
@@ -1347,7 +1347,7 @@ xfs_file_ioctl(
 	}
 
 	case XFS_IOC_FSCOUNTS:
-		return xfs_ioctl_fs_counts(mp, arg);
+		return xfs_ioc_fs_counts(mp, arg);
 
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
-- 
2.53.0

