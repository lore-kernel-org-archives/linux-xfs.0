Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D584476CEE
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325204; cv=none; b=O64nVarWKGBExje69JPZ7iSpmnjGIBZoilvTchxQ+kWT4nGAOvmOJsqnakhw9q4exKF8gxDll6vixZDej+K6X/GhF8zuiG+985k3F7GLfsqxra0Lv2nbGo8dPgLnhGjY2nNhyitsL1egRd5cxhxajUklNSVvIx8rx8inp4tFEeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325204; c=relaxed/simple;
	bh=Agjr3w9AmaijXN7DE379QNe8BYbTyJIPLG+cCXWDThs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvV80ZO78bKkd4R/zzyVjdPCVDjOnKHOqLAuqufRQNP6LwJ8ieR9f+cGX8ca1f3NnRZN9ODNu6ak115LaBrdV7jVS8jPJgZuw+rJyMsezfq5lYNkPC0v+NP/xvp4j9FeYsH2s58440jg5Erypun6ZXuUXcd9E/kMMH2lQGOopLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=skW+FeQC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="skW+FeQC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VgTceEYaPkawBFBpZZGCDYed4mJoxhPZLQz5u36Xw88=; b=skW+FeQC9wdQ+T6BJz1VJ97qIZ
	/M0YuFHhNAxsU9VmxwJhV+/V3DGuUpJI61xYb0op0MZjDehGqdIMFrAeCZIP0C9a89rKlJyCJ4jOf
	n8npI4YxM2H6tSj+oZ0lY8qZxRwGXyp3zL/oxxPAYLHdIN0J5Qp/0LgAs0tLzNtp1uqNtQAnqeCEC
	Kr/0yMdv4nolj+c2XEeRNCdrr3dN6/GKw91IFYO7RfLCGHf/mJO/T4MINIjodAeNamBlV2Nag6+Ax
	22SnQKRTVjHoMd6X0VGuAhG0N+VAxioooOr3d0+lT76i7bG2Kpy16fMUoU6+yiUcWe3FlaCqpKNEc
	PG5KFJEA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2dk-00000007l0M-3Wlc;
	Wed, 29 Jul 2026 11:40:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/16] xfs: rename xfs_ioc_swapext to xfs_swapext
Date: Wed, 29 Jul 2026 13:39:02 +0200
Message-ID: <20260729113952.2255638-3-hch@lst.de>
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

The usual convention is that the ioc_ prefix is used for direct ioctl
handlers that take a user pointer.  The current xfs_ioc_swapext does not
fit that pattern, so rename it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c   | 8 ++++----
 fs/xfs/xfs_ioctl.h   | 4 +---
 fs/xfs/xfs_ioctl32.c | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ec5412a9eb1d..9a10645f5222 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -962,10 +962,10 @@ xfs_ioc_getbmap(
 }
 
 int
-xfs_ioc_swapext(
-	xfs_swapext_t	*sxp)
+xfs_swapext(
+	struct xfs_swapext	*sxp)
 {
-	xfs_inode_t     *ip, *tip;
+	struct xfs_inode	*ip, *tip;
 
 	/* Pull information for the target fd */
 	CLASS(fd, f)((int)sxp->sx_fdtarget);
@@ -1341,7 +1341,7 @@ xfs_file_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_ioc_swapext(&sxp);
+		error = xfs_swapext(&sxp);
 		mnt_drop_write_file(filp);
 		return error;
 	}
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index f5ed5cf9d3df..e57d8f5148bf 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -10,9 +10,7 @@ struct xfs_bstat;
 struct xfs_ibulk;
 struct xfs_inogrp;
 
-int
-xfs_ioc_swapext(
-	xfs_swapext_t	*sxp);
+int xfs_swapext(struct xfs_swapext *sxp);
 
 extern int
 xfs_fileattr_get(
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c66e192448a8..250df2bbf214 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -475,7 +475,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_ioc_swapext(&sxp);
+		error = xfs_swapext(&sxp);
 		mnt_drop_write_file(filp);
 		return error;
 	}
-- 
2.53.0

