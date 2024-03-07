Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE533D0B8
	for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2024 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709853232; cv=none; b=FtQROzZCKcr8v2Xp/bYdqDal0HfFqqnU4qWA4YemcWsWoBPTCyYrDdyW19UenO0oYnphPEUtsPP6+mM38NX29BxQFaIsfeSCi15YZPNt+MU5z3Qsm6oCEXZ/54nAv6608+0bV2lnHiwEIDkR0Rk5qw2B72I0s+lxLS16xW8Agbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709853232; c=relaxed/simple;
	bh=+FlbKfMvC/tRPFHlBATI6nrtCh3tcdvBrMs11JRBBcU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kmG2RmcdhflFLFHUk3Ofh6hXenfNjFIFlmsl40bhZSzAp6Kye/W7HQ7HcNGWT/btb23VIcB8c0tg8EM9NI5lg/5rRyMUWJELQWAsH6cB958w/BHb5G01lOnclRb0PQ00feARhIhT1kV7nzocvdjXxougHN9bBPnxjNDQl43vNRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfD9KJA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfD9KJA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A631C433F1;
	Thu,  7 Mar 2024 23:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709853232;
	bh=+FlbKfMvC/tRPFHlBATI6nrtCh3tcdvBrMs11JRBBcU=;
	h=Date:From:To:Cc:Subject:From;
	b=QfD9KJA1Uje+SP4Ozpwc2fgEReIGQfbFbrHcC7J05OmHHXOqSFQNWspYC/FUGTzAs
	 NTk02rLxa56Tt32VapVFnBt4IlJG7hcN/8K+tWo505ZTkDgQlAdyUnUkJTK3VoWShj
	 kNVJKdl0274nhpHv6NyT0DLcOCKKrZydLmZUJBw3GmCVDEYIdPWOvQ2zJ92NOErSOR
	 F4NiYg4ikrz6Iq4M9c+z1DfE6/8kj0V70r44yQHwDr9081kYxzvXCMBx/w9KLlDHaT
	 GcfHLJ5+0l7YmiuRJusIEuoYdz24BkUaqvo3UwPT7Ab+aUg00RKCtbIXTMNEbUA76/
	 QEp/6eYsxBV7A==
Date: Thu, 7 Mar 2024 15:13:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix dev_t usage in xmbuf tracepoints
Message-ID: <20240307231352.GD1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix some inconsistencies in the xmbuf tracepoints -- they should be
reporting the major/minor of the filesystem that they're associated
with, so that we have some clue on whose behalf the xmbuf was created.
Fix the xmbuf_free tracepoint to report the same.

Don't call the trace function until the xmbuf is fully initialized.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_mem.c |    4 ++--
 fs/xfs/xfs_trace.h   |    9 +++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 8ad38c64708ec..9bb2d24de7094 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -81,8 +81,6 @@ xmbuf_alloc(
 	/* ensure all writes are below EOF to avoid pagecache zeroing */
 	i_size_write(inode, inode->i_sb->s_maxbytes);
 
-	trace_xmbuf_create(btp);
-
 	error = xfs_buf_cache_init(btp->bt_cache);
 	if (error)
 		goto out_file;
@@ -99,6 +97,8 @@ xmbuf_alloc(
 	if (error)
 		goto out_bcache;
 
+	trace_xmbuf_create(btp);
+
 	*btpp = btp;
 	return 0;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8652881a2151a..a12a59077dd09 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4651,6 +4651,7 @@ TRACE_EVENT(xmbuf_create,
 		char		*path;
 		struct file	*file = btp->bt_file;
 
+		__entry->dev = btp->bt_mount->m_super->s_dev;
 		__entry->ino = file_inode(file)->i_ino;
 		memset(pathname, 0, sizeof(pathname));
 		path = file_path(file, pathname, sizeof(pathname) - 1);
@@ -4658,7 +4659,8 @@ TRACE_EVENT(xmbuf_create,
 			path = "(unknown)";
 		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
 	),
-	TP_printk("xmino 0x%lx path '%s'",
+	TP_printk("dev %d:%d xmino 0x%lx path '%s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->pathname)
 );
@@ -4667,6 +4669,7 @@ TRACE_EVENT(xmbuf_free,
 	TP_PROTO(struct xfs_buftarg *btp),
 	TP_ARGS(btp),
 	TP_STRUCT__entry(
+		__field(dev_t, dev)
 		__field(unsigned long, ino)
 		__field(unsigned long long, bytes)
 		__field(loff_t, size)
@@ -4675,11 +4678,13 @@ TRACE_EVENT(xmbuf_free,
 		struct file	*file = btp->bt_file;
 		struct inode	*inode = file_inode(file);
 
+		__entry->dev = btp->bt_mount->m_super->s_dev;
 		__entry->size = i_size_read(inode);
 		__entry->bytes = (inode->i_blocks << SECTOR_SHIFT) + inode->i_bytes;
 		__entry->ino = inode->i_ino;
 	),
-	TP_printk("xmino 0x%lx mem_bytes 0x%llx isize 0x%llx",
+	TP_printk("dev %d:%d xmino 0x%lx mem_bytes 0x%llx isize 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->bytes,
 		  __entry->size)
