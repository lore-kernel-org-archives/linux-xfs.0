Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38781B81C
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275805; cv=none; b=iXooZAEZlLV2Rw3DlkozUy7zQmofbNgQ1zxEzaWb7ASw36claawlC8AdkNPGyBOumaLsmgYbtZVy4TVrGUCIRXmgMmIxeTWqmxrPUEIviic92HpRu9pZeMurB/2+2uQ1aGyX3t5bTsOyR/84Q0ptcBgOYWawwNV+Dq/ff6vMM0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275805; c=relaxed/simple;
	bh=jQ+3cjrCMkvT3s1cYhABQAkPqAQv60KfSHGAqMTz8z8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cHSYO8I9TJ9l3t263xuWgm232KsNJ6ySKLQwroblbkqlaRCyJZ8S3EkC6n+ct3tsMQAFCNScLAU4Z24tQcpO7dJ8BrcM2M6+dTutpXmDgCKsaTHhNdMLcHb+gg5scALUl/1OoXcOrBtEdUHwe2B9POen1A35Z8/Cq5lqJxt9hIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LO+DAdQY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LO+DAdQY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WZPrkSzC6JP8KIWSSwxcdUJBQA5TQKYe+UX++Ksig+4=; b=LO+DAdQYF+uOX8P49gTNG+QF1I
	iomfriNZnLrSsbT+efu9ZZXDF39DBlZIPZaw6ArFquVPkduQutCMvzh6oOd6PogtNkPlSClaZG+VU
	MOU+WEVg9/Wvpk39S11AcVL6pUcFgdh6w6nVt/nhtQtw/mUnUKl4ZjobkCPZ6vXsiqUo6lVxUDUAJ
	a6zoDPLVBnonIiXI3nl8p0altSRMBdxDvz/Dn+p4uyE5eDbw/Ad529L5WjibG1+bxH7TfAVlkd8+d
	YLpMJi+IoZsAverQmxLphYqvJ2F0m4+adZrixurxP2Vj74Nzur0pWuKELHXzvf4ngQ9iYrPAXSoPE
	osusjb6A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHS-00000004CpB-3el1;
	Fri, 26 Jan 2024 13:30:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/21] xfs: don't modify file and inode flags for shmem files
Date: Fri, 26 Jan 2024 14:28:54 +0100
Message-Id: <20240126132903.2700077-13-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
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

