Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F4614DFD6
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709128396; cv=none; b=EfWV5CI9+TIoEr77mn9T6SibVzm7QCFLIkfJbBc7Jk4A7ADnFaE+egeEBZwlPhwo5HgHI45U5/cWKZeBR8ks8iaTOHmr1phlb4A7xhhEK9PZd00q7yabv6PxSgYnPj3QSrGA9eydRkGtcjHzpvimkzZYGpUq0ePrkj6etJwu1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709128396; c=relaxed/simple;
	bh=YglHG1yXcxmgwylo84DkEsmfa2R6xBEC8mHdrAwPWPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vClTxW02KD/ytLILJeFXAViaJN7hvruphiPZsLf8XilrI83FpvzZoRV3km2ZZ0V6m1ELGvkZEnbqzrKQcjsxA/phPyXePJK6ldW+/Gv8RFEwADpTsQoGNqL8tu1xwBhcbt4q3CjAQStMeavaKyIarBJtoVveShu96Layto4jAJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GhiNoLvB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GhiNoLvB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ok9hoGHAKJyj4+gkPdGiLyzuFd/tRGbhTw0LZ1l54Wk=; b=GhiNoLvByKHvyCsZ6CgLDjbVS8
	XxqCmx3HPByBdLaD8347zEwh1n3qQrZbmezCdp6Xqn/rxA1uij8tFb7W8nDP1jyPeTXN8KfBGqCz1
	cvGD1JmkQcgsb0zT0pKKDCuLiJz+Il6E4Hda/EetkoXYmu4us+0tF5XTCzNjbEp3PhLV7lVEJblcD
	LNZ3ys3YlHLeHs4Y2E+MtPV3CpIYnKS2KJbGhQtU7bVIiwfcQuNb2USG4bcMQnDFH2k9wCTMSkUn0
	W3Dimbb7EIMliyMJGmHxJgV0kMZ9EIvThvO+r5hErwz6oPy4o/2W8tAs5lEvqfmbiX+icj/bfNIhI
	VL2qAlSw==;
Received: from [12.229.247.3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfKMz-00000009YtS-3zaY;
	Wed, 28 Feb 2024 13:53:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfsdump/xfsrestore: don't use O_DIRECT on the RT device
Date: Wed, 28 Feb 2024 05:53:13 -0800
Message-Id: <20240228135313.854307-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240228135313.854307-1-hch@lst.de>
References: <20240228135313.854307-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For undocumented reasons xfsdump and xfsrestore use O_DIRECT for RT
files.  On a rt device with 4k sector size this runs into alignment
issues, e.g. xfs/060 fails with this message:

xfsrestore: attempt to write 237568 bytes to dumpdir/large000 at offset 54947844 failed: Invalid argument

Switch to using buffered I/O to match the main device and make these
alignment issues go away.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 doc/xfsdump.html  | 1 -
 dump/content.c    | 3 ---
 restore/content.c | 3 ---
 3 files changed, 7 deletions(-)

diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index efd3890..eec7dac 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -884,7 +884,6 @@ Initialize the mmap files of:
                    <ul>
                    <li> S_IFREG -> <b>restore_reg</b> - restore regular file
                       <ul>
-                      <li>if realtime set O_DIRECT
                       <li>truncate file to bs_size
                       <li>set the bs_xflags for extended attributes
                       <li>set DMAPI fields if necessary
diff --git a/dump/content.c b/dump/content.c
index 9117d39..f06dda1 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -4325,9 +4325,6 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
 
 	isrealtime = (bool_t)(statp->bs_xflags & XFS_XFLAG_REALTIME);
 	oflags = O_RDONLY;
-	if (isrealtime) {
-		oflags |= O_DIRECT;
-	}
 	(void)memset((void *)gcp, 0, sizeof(*gcp));
 	gcp->eg_bmap[0].bmv_offset = 0;
 	gcp->eg_bmap[0].bmv_length = -1;
diff --git a/restore/content.c b/restore/content.c
index 488ae20..c80ff34 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -7471,9 +7471,6 @@ restore_reg(drive_t *drivep,
 		return BOOL_TRUE;
 
 	oflags = O_CREAT | O_RDWR;
-	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
-		oflags |= O_DIRECT;
-
 	*fdp = open(path, oflags, S_IRUSR | S_IWUSR);
 	if (*fdp < 0) {
 		mlog(MLOG_NORMAL | MLOG_WARNING,
-- 
2.39.2

