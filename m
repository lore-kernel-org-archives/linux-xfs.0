Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3222F5314
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670485; cv=none; b=TOwPGDzX0jEFd856FOHcv/FyiKt/M7Rsff+X1bgZgo8q86SmuMAeWaeUtOW5QfSHKCUR+4MybCPsPpyWzQGJaLMOdkK5Due27X/aZQ+Y359MwhQg8/YtoIqJxBmkC9Nm4oM7ng1YYmslmWsdgYVuAt40kQyS+VtaLXrD7Rr3534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670485; c=relaxed/simple;
	bh=lCxNIUB29sUCJXAv+MLENauL+OK8Jhc6UAnt362XrOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptJnIgsynEZn6osPCNHbMocQ7R+v0XBZ2iGBoO3yaMkPt0tDK68qtChtt4fb4kU9s9sEOGOyMpKonqfBkw8io1tJ9S+K3o9jMV15SoYM/ypwfHOQrOCVv0Ma7ko2Urh0u0Un0SwlGjr5oV+hKUgytLH8plsEFxQgq/xr2AA5BV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MhMKdW4l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MhMKdW4l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yOGa7Rg/qpPTSzURyHFQjMZ7hwBHYvcyAZqEMdZhnzA=; b=MhMKdW4lrTLaRFz2LwguDE5jJb
	yXLhTJGVKsxgGYZNUxK0DYyP/gKz3mOKwuVYdoYY3zcAqzPTziWAqs796z4ZwB9ils3ErJ/qaf2mv
	GQZIz8xnlJpg10BX4ETPfffCROP/yNpxqEjE1nwv5NmReVYPz39v6JGq1MiYQR7HUgard/XnFvQbr
	XVJQc+GDi9t9b1NHZm2aQt+f+ksUvAOXW/bKIV3kCobAPFKF10FqO6DuiaLiYG25lpoue6nHjdPcl
	53+2JoGdGo+UFeaz1OxSJNs6CrW7ley7byB+uzBehys5P8d9Tcj0f1b+hsMVKfMOuLhCv6qphs7uq
	0jWR9UTg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1el-00000007iQT-03CW;
	Wed, 16 Jul 2025 12:54:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: improve the comments in xfs_select_zone_nowait
Date: Wed, 16 Jul 2025 14:54:07 +0200
Message-ID: <20250716125413.2148420-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716125413.2148420-1-hch@lst.de>
References: <20250716125413.2148420-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The top of the function comment is outdated, and the parts still correct
duplicate information in comment inside the function.  Remove the top of
the function comment and instead improve a comment inside the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index c1f053f4a82a..4e4ca5bbfc47 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -654,13 +654,6 @@ static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
 		!(ip->i_diflags & XFS_DIFLAG_APPEND);
 }
 
-/*
- * Pick a new zone for writes.
- *
- * If we aren't using up our budget of open zones just open a new one from the
- * freelist.  Else try to find one that matches the expected data lifetime.  If
- * we don't find one that is good pick any zone that is available.
- */
 static struct xfs_open_zone *
 xfs_select_zone_nowait(
 	struct xfs_mount	*mp,
@@ -688,7 +681,8 @@ xfs_select_zone_nowait(
 		goto out_unlock;
 
 	/*
-	 * See if we can open a new zone and use that.
+	 * See if we can open a new zone and use that so that data for different
+	 * files is mixed as little as possible.
 	 */
 	oz = xfs_try_open_zone(mp, write_hint);
 	if (oz)
-- 
2.47.2

