Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C219A1FA3
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324073; cv=none; b=n+jHsv/vu49JjTPyaMkgjh8y/OiHB3pCsKi54C3SX+sTX2plIaYEuupmygWkYm+QzsqVy5BFHod4+ZnUfyjwunwaM80F8MetDb7ntHo881vR2DDz/kyV83QRBgta3nDLKCkRQwRK6BjwUc7aWImzckVz7lER4BmNqpdr23onj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324073; c=relaxed/simple;
	bh=7rQXvKj1QH9RPMVD+tA+fvtMHKlwq5gzgPJWMLR+Zu0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Leq6K9zUTxL6oQSgIjdr+kz/1T6Y4aCqvDhD88aUxsacQObEBHQoV1YzFj39/54JW0rvd8/8SjJCN04E5JgvFOOCA9joGRhM1OKPbhVIXW0ZbkcxnXoteif8V3x70+h3OmzaCM70D5raJ/2S35+IbKUxJYTiMhAkbt/JLX1yQuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RHqOkPT4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RHqOkPT4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jHJLbhzbQM88bSKvGjvpGu8mOibQcB/FZYvTZsZJGfs=; b=RHqOkPT4qmpCVEsIyABsD0OQnz
	tYDZ2iIzJAvY3uXOUGcqEJxyneuEiIwQ7a73AGoj2RzlVYEG8jIlzMea4llly1Ot50UAznCAEcpXm
	N2cIxiMUGZmm8TxWeNQNuQjPsEsdcbOv97BOJCOH3CgvzgiuriP1DO3jjwB0Sp+4IoTJsm1NyD5kg
	nlY5McIxIcC7+bfMAKR41Ax6GY+i/5v0+NAZy2bc8ANkVZkUlXHEiFNEBv/Xwcu8T84lupd7itQJ6
	EIB4NUJoq008JfzwtfEnB9mSsr9ETzMjR7+3DovntfAOEB6TEyAPHrkfweL+NEihY4lSfwRVyzAlL
	EikAmf9g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx81-00000009FDA-3143;
	Mon, 19 Feb 2024 06:27:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/22] xfs: use shmem_kernel_file_setup in xfile_create
Date: Mon, 19 Feb 2024 07:27:18 +0100
Message-Id: <20240219062730.3031391-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_kernel_file_setup is equivalent to shmem_file_setup except that it
already sets the S_PRIVATE flag.  Use it instead of open coding the
logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index e649558351bc5a..99a2b48f5662e6 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -68,7 +68,7 @@ xfile_create(
 	if (!xf)
 		return -ENOMEM;
 
-	xf->file = shmem_file_setup(description, isize, VM_NORESERVE);
+	xf->file = shmem_kernel_file_setup(description, isize, VM_NORESERVE);
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
@@ -85,7 +85,7 @@ xfile_create(
 			    FMODE_LSEEK;
 	xf->file->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;
 	inode = file_inode(xf->file);
-	inode->i_flags |= S_PRIVATE | S_NOCMTIME | S_NOATIME;
+	inode->i_flags |= S_NOCMTIME | S_NOATIME;
 	inode->i_mode &= ~0177;
 	inode->i_uid = GLOBAL_ROOT_UID;
 	inode->i_gid = GLOBAL_ROOT_GID;
-- 
2.39.2

