Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11351FA3
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324075; cv=none; b=GHLL4LZ766aqkKmT+c6JZsGGg+vhwWyt5R3QKet+icnTfLflk99a/iTFwe23jcX9Pom0zxn2rV52R0EYkxHyD3oFDh0TiR/mGHGugSY8gjGB4uMKHRC2jJjHZUrJCuLRsDIVE8BdufvmdeX5Hh5eSBYLDnpgnPpMW5UpjLAPD/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324075; c=relaxed/simple;
	bh=JltxyXQNjUu1x07QdArCu/VN39dDEk4AJAxyJHUnWWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m8gSdcjOsKUNjUo58+jW8P2LrU52N3NawP5nBCgCTOPN9rgRcM3yLskHmQjAasNbTqgwFBiQ7n5/+GHs4NABSvzi//9HVjrk5WJTScmG9dJQY4A7pEXC/7wqGOz7SX7GZhgsWAMddjxRe1+42z9dMjeYdTa/8lsqgDnKNFJJy5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2gyvYLq8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2gyvYLq8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o1hweSz38RYb00ePEUoeWH5QKSAPHiuuZqJTaYjg4ME=; b=2gyvYLq8mbKaJ7NKdsAaeSwbT9
	1eROmAQ10UrNavhRg+70C7Ejm1uLfG2JeO5CL0/YDzeT50nvn0DGkqiKm8/WalQ7mSKc5s70ZQVqT
	3gJwWsycYuHsYJ9wwi5CVdLOeZ9O/tDKLxdydy1JH05zOr33icc3XmuMvW3wh/TAnNFXW9RUj6/vW
	EGShW5N+4lVXTXO9bL9VUUGGtJVGuQWXY7FTzhJV2sR1vnOnwudWgV4fSuXceLqNQbG6QudzcvOuZ
	Rkw6qye0/RmLQltWYT3liXBelPjRnAAdF8bwvIe7opDoJuic+F3mWZFuP78CtMLEAdXUblO8M6bqL
	pTGq2woA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx84-00000009FEF-0rbU;
	Mon, 19 Feb 2024 06:27:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/22] xfs: don't modify file and inode flags for shmem files
Date: Mon, 19 Feb 2024 07:27:19 +0100
Message-Id: <20240219062730.3031391-12-hch@lst.de>
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

shmem_file_setup is explicitly intended for a file that can be
fully read and written by kernel users without restrictions.  Don't
poke into internals to change random flags in the file or inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 99a2b48f5662e6..95250db81981ab 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -74,22 +74,7 @@ xfile_create(
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
-	inode->i_flags |= S_NOCMTIME | S_NOATIME;
-	inode->i_mode &= ~0177;
-	inode->i_uid = GLOBAL_ROOT_UID;
-	inode->i_gid = GLOBAL_ROOT_GID;
-
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
 	trace_xfile_create(xf);
-- 
2.39.2

