Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493174052C6
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313249; cv=none; b=dBBaiv6SdikOowoqKOqW+fWi48d/g5AeaukUhYQJ9bsEhrniA3cQ5Mp+4YZaNUdsAQzSlgCXeY92nrZmwOr/j4u4Uit9NvcqQLNgZfBtpug4PcR+RFSKjwmvb/4xSDYdpvZxncnP3P00iUiUSMqFHt48e9E/Tukq4XgPoDJcD3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313249; c=relaxed/simple;
	bh=MXis2n7MiX04f/C8Qszjw6K/+q70gqSXh3H/kdYJZEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhTU78MJdwzq3G1ogT4DDAXnJRitu4JQNSteHBfzWpwgVY7iljEEu6FdVuEXPoWo4vAmE0XIExXekuSpp5mtpk+I1CEsOy2P0qOefVjnO4EqMcmgT6o20p0XT4Q6znxCcAAU2yKiZ34/IXEfdGczzVmCS9CHLb8dyyKblZTsBKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vdC2euOO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vdC2euOO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ak0E4yO5+VFXQnjV5qCxhF7f0bRVTucuf8dDhhXZlJM=; b=vdC2euOOhvu5AIM/mg6sZEk/yL
	AGJKzdIX8m1BhTN/qs9Xtm+qWogqte4ONVSYXiSQaYUR1yDkZNQ4MA9D7TKdvPbDySudFHcqFv2aI
	J0tdNPx1xNqi5EFmte3AdY6KePFGAvjgBIxxAP0HQ7HrsICB8HNB7jqYP8K6ghN7bBlYHZnEZhZRL
	7eJBER4xyJsIeNJXs/OG6JaJq5h9tMS0SEX9GGc8jnlTtBN8xhkeLjw5gmaq6IEostYwim/pZI9l/
	ToVU9zJ/cNi22SafJj1TsVMOvh1OwXn89mu4U5NDC5axo/yBIiHcZtzUQhGDKjo96Zy/A/QIxUSwo
	fwykRijg==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yG5-0000000Cgd9-0jBF;
	Fri, 25 Sep 2026 05:14:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] libfrog: improve ramdisk handling in platform_flush_device
Date: Fri, 25 Sep 2026 07:12:55 +0200
Message-ID: <20260925051336.2997014-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The ramdisk driver was quirky for BLKFLSBUF, but there never was
any reason to skip the fsync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c    |  2 +-
 libfrog/linux.c    | 13 ++++++-------
 libfrog/platform.h |  2 +-
 libxfs/init.c      |  2 +-
 libxfs/rdwr.c      |  6 ++++--
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 5435c87dba38..4692a4ffb961 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -141,7 +141,7 @@ check_errors(void)
 
 	for (i = 0; i < num_targets; i++)  {
 		if (target[i].state != INACTIVE) {
-			if (platform_flush_device(target[i].fd, 0)) {
+			if (platform_flush_device(target[i].fd)) {
 				target[i].error = errno;
 				target[i].state = INACTIVE;
 				target[i].err_type = 2;
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 46a5ff39e2eb..5c0d3ed7e935 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -152,15 +152,11 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize,
  */
 int
 platform_flush_device(
-	int		fd,
-	dev_t		device)
+	int		fd)
 {
 	struct stat	st;
 	int		ret;
 
-	if (major(device) == RAMDISK_MAJOR)
-		return 0;
-
 	ret = fsync(fd);
 	if (ret)
 		return ret;
@@ -169,9 +165,12 @@ platform_flush_device(
 	if (ret)
 		return ret;
 
-	if (S_ISBLK(st.st_mode))
+	/*
+	 * Historically the ram disk driver destroyed all data when BLKFLSBUF
+	 * was called.  That has been fixed a long time, but still be careful.
+	 */
+	if (S_ISBLK(st.st_mode) && major(st.st_rdev) != RAMDISK_MAJOR)
 		return ioctl(fd, BLKFLSBUF, 0);
-
 	return 0;
 }
 
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 20f9bdf5ce5b..39d558f08629 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -12,7 +12,7 @@ int platform_check_ismounted(char *path, char *block, struct stat *sptr,
 int platform_check_iswritable(char *path, char *block, struct stat *sptr);
 void platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
 		bool fatal);
-int platform_flush_device(int fd, dev_t device);
+int platform_flush_device(int fd);
 int platform_direct_blockdev(void);
 int platform_align_blockdev(void);
 unsigned long platform_physmem(void);	/* in kilobytes */
diff --git a/libxfs/init.c b/libxfs/init.c
index 5a4b255165ab..4c71027d2805 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -172,7 +172,7 @@ libxfs_device_close(
 {
 	int			ret;
 
-	ret = platform_flush_device(dev->fd, dev->dev);
+	ret = platform_flush_device(dev->fd);
 	if (ret) {
 		ret = -errno;
 		fprintf(stderr,
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 837288be0307..33a0d144a1aa 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1112,8 +1112,10 @@ libxfs_blkdev_issue_flush(
 	if (btp->bt_dev == 0)
 		return 0;
 
-	ret = platform_flush_device(btp->bt_fd, btp->bt_dev);
-	return ret ? -errno : 0;
+	ret = platform_flush_device(btp->bt_fd);
+	if (ret)
+		return -errno;
+	return 0;
 }
 
 /*
-- 
2.53.0

