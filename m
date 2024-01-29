Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B137615442F
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538951; cv=none; b=OHeyf88QUdggh5enl3/VbCAvjCC6gMRxPLa+v61KySDrYPrEDw7ywoFf2AGTev3ixPBKQdElP9Sq9fnCVi0ZVKq8B6AyvipOTGqKut5Z7pyY7XUfCViWYRAEXcHOdyAPFnkqVhitabtVtFRWlnec7OGWzrJS8XobVSSH2gFSkvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538951; c=relaxed/simple;
	bh=jQ+3cjrCMkvT3s1cYhABQAkPqAQv60KfSHGAqMTz8z8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J8lp0Kacf3ExBQhDVZus4jCRn+dWoNyZjb+Cse4vqozGi0q19g0fNv4insCNcpGjNcOWQp09lI7LF1l8kMPSeEOlzS1B8CvqOXcaAmn/4jyDAz52SZiM3BD+PpMyG6Jros/rn1LUuKyAS6bWxEs6t8zrApFTUg/BB85fCF/u6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XU4lx99Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XU4lx99Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WZPrkSzC6JP8KIWSSwxcdUJBQA5TQKYe+UX++Ksig+4=; b=XU4lx99QKPPKmDgve+lLL6ig3j
	BLlmqQ1Pp7IJC2RnK+90IsIg/JiwDBGW4sSQhoKXo2cLYwVMBJPTgBFsXc7x4rccgqhY0ZMuPbsTP
	G/jiTROM8vMNGQxyIQGOIlBR4VcHP/Zvd1LuIlTmprOqgmYZDOomYkWFKDUOTom9HaatTvLOMc4SY
	ivE/cFH/7Ld/uKB2gG4+zPILYWnKw5OecUJXYv3G7+/SlWGB48DHSnTmpNCnsWmepYdeqqfNq8ksY
	dlSCoUciXUs/je+p5B4zN/JkXDubOOr/FRZ6H43RJBtlipdiO/94EB5twwyh00wm+i9E7yZJfjbYz
	Y24Xi/xw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjk-0000000D6L4-0ciP;
	Mon, 29 Jan 2024 14:35:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/20] xfs: don't modify file and inode flags for shmem files
Date: Mon, 29 Jan 2024 15:34:54 +0100
Message-Id: <20240129143502.189370-13-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_file_setup is explicitly intended for a file that can be
fully read and written by kernel users without restrictions.  Don't
poke into internals to change random flags in the file or inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 7785afacf21809..7e915385ef0011 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -68,28 +68,13 @@ xfile_create(
 	if (!xf)
 		return -ENOMEM;
 
-	xf->file = shmem_file_setup(description, isize, 0);
+	xf->file = shmem_kernel_file_setup(description, isize, 0);
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
 	}
 
-	/*
-	 * We want a large sparse file that we can pread, pwrite, and seek.
-	 * xfile users are responsible for keeping the xfile hidden away from
-	 * all other callers, so we skip timestamp updates and security checks.
-	 * Make the inode only accessible by root, just in case the xfile ever
-	 * escapes.
-	 */
-	xf->file->f_mode |= FMODE_PREAD | FMODE_PWRITE | FMODE_NOCMTIME |
-			    FMODE_LSEEK;
-	xf->file->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;
 	inode = file_inode(xf->file);
-	inode->i_flags |= S_PRIVATE | S_NOCMTIME | S_NOATIME;
-	inode->i_mode &= ~0177;
-	inode->i_uid = GLOBAL_ROOT_UID;
-	inode->i_gid = GLOBAL_ROOT_GID;
-
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
 	trace_xfile_create(xf);
-- 
2.39.2

