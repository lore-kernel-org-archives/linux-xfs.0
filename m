Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA92853FD;
	Fri, 16 Oct 2026 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121694; cv=none; b=Cb4uvXHTW1JT0YjAgawNF0AXdOXdJV9EGqBLXM0IZUIyJ93nth3d6UIg/9wCylqDzl/zU2eGr9sgHIAz+/wL3TljZ4AonR2WXXzva++o0izb8CZhI8tRYXOjuNSCK3H42q+JFUfxrrHhLeYj/g+X/bomatiFd/Dy//rr2sNwkFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121694; c=relaxed/simple;
	bh=NJRSVpzPhzcTg0Y/35VFjaITL2kD5Un1ASMtT1q/2ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJV03hI0OdTUxmJcoNHa9abunf3xVnRcyLqjjVceAWPwHTWfkKt1YP/J0EWyqbjU2/2++AVBCvfcTF8oL9njOWMr5UmXJjPAXl/u6QtMHhY+n5SjvrWMYA6iMhIfBBTh1w0cQCYvUoA66CMEbd1k9GTzCB9Tl/baR2Qkvf9p/4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=H4Pa2apm; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="H4Pa2apm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=BB
	34cO0wxpI677RNqzl1i49aSu0q44HexQs1CzbIlE0=; b=H4Pa2apmmv9dQKO32W
	BxfY09amvrcAxSpHXj/YS9JDz7qkezQShG/CMlaUDyB6S3TkGpOi4SbGPN5ujFIp
	mH4Bi3OQi0GtVDCcZPSYtGELkyKA7ZJdlqrL1EbDY4cCKGNRecKKVP2YJe7BMrzd
	M3FPeGs+EZ486BMC4GZP1rGxg=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S8;
	Fri, 16 Oct 2026 11:34:23 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v3 6/8] exfat: drop i_rwsem from exfat_page_mkwrite
Date: Fri, 16 Oct 2026 11:33:47 +0800
Message-ID: <20261016033349.3104509-7-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016033349.3104509-1-chizhiling@163.com>
References: <20261016033349.3104509-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S8
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFyxtw4rAF4ftr4UKr1rJFb_yoW5Aw4Upr
	W3Gws5GwsxX3y5Wrn29F1ku3WYk3WSqrWUury5u3WvvwsrAw1Iyay8KFWkWFW5tw1kXa1j
	qF4YyrW8uwsFgaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UHyIUUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9x8FomrRmz-gGAAA3o

From: Chi Zhiling <chizhiling@kylinos.cn>

exfat_page_mkwrite() takes i_rwsem with inode_trylock() and returns
VM_FAULT_RETRY when that fails.  The MM subsystem does not propagate
VM_FAULT_RETRY from ->page_mkwrite(), so the fault still completes and
the page becomes writable without exfat_page_mkwrite() ever advancing
valid_size.

Blocking on i_rwsem is not an option either: ->page_mkwrite() runs under
mmap_lock, so waiting for i_rwsem would create an mmap_lock -> i_rwsem
ordering that can deadlock.

Now that valid_size is advanced under the folio lock, i_rwsem is no
longer needed here.  Take mapping->invalidate_lock shared instead, which
serializes the fault against truncate.

Without i_rwsem, i_size can shrink between the read fault and
->page_mkwrite(), so re-check that the faulting page still starts within
i_size before preparing the range below it; a truncate that slipped in
between would otherwise let the helper populate and dirty folios beyond
EOF and advance valid_size past i_size.

Fixes: 6630ea49103c ("exfat: move extend valid_size into ->page_mkwrite()")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/exfat/file.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 6d4f50795332..23b8a36acaf7 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -989,26 +989,25 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 	loff_t new_valid_size, mmap_valid_size, fault_page_start;
 	int err;
 
-	if (!inode_trylock(inode))
-		return VM_FAULT_RETRY;
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vmf->vma->vm_file);
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	fault_page_start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
 
-	/*
-	 * Zero only the gap below the faulting page. The read
-	 * fault populated its folio and iomap_page_mkwrite()
-	 * will dirty it.
-	 */
-	err = exfat_prepare_valid_range(inode, fault_page_start);
-	if (err < 0) {
-		inode_unlock(inode);
-		return vmf_fs_error(err);
+	if (i_size_read(inode) > fault_page_start) {
+		/*
+		 * Zero only the gap below the faulting page. The read
+		 * fault populated its folio and iomap_page_mkwrite()
+		 * will dirty it.
+		 */
+		err = exfat_prepare_valid_range(inode, fault_page_start);
+		if (err < 0) {
+			ret = vmf_fs_error(err);
+			goto out;
+		}
 	}
 
-	sb_start_pagefault(inode->i_sb);
-	file_update_time(vmf->vma->vm_file);
-
-	filemap_invalidate_lock_shared(inode->i_mapping);
 	ret = iomap_page_mkwrite(vmf, &exfat_iomap_ops, NULL);
 
 	if (ret == VM_FAULT_LOCKED) {
@@ -1021,10 +1020,9 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 		exfat_advance_zeroed_size(ei,
 				round_up(new_valid_size, i_blocksize(inode)));
 	}
-
+out:
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 	sb_end_pagefault(inode->i_sb);
-	inode_unlock(inode);
 
 	return ret;
 }
-- 
2.53.0

