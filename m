Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63716BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIbalYDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF83AC433C8;
	Sun, 31 Dec 2023 20:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053629;
	bh=LhSkwu/Zc/3FRmXHL9Rku9EA3BzFlfUUMytXPnOu0zY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JIbalYDL1Z350lncqdL+DmiZ+IjeEoz17AE3ZPvnqG43pfCVYImdSOQWq4bZ2JgQg
	 YhbIxKCVlzBmWh1jFFuitnmzRl0fMMOnpCvK0dtWCUjNm+uQ4UfGN4femybQwf0NV/
	 AkD8MJVq5rsfPPCmhDOByQEB6jNHY8y2qrc2btgFT054if/PnUjU+FMe1h6Ceo1sXq
	 hsJXffspWR5eFHJc9Op4kIOux9OqtcjnMJW1c4kETQRFTmt9Zt4L3ZGRv1SqTP6PDQ
	 0qYhOZvAiAkjTPw9w45IztWRouSUeTK7RCdKPbbg/GqWrubX9U58AKM2t8WknJ5Ldf
	 WSBVWLG1rx7Yg==
Date: Sun, 31 Dec 2023 12:13:49 -0800
Subject: [PATCH 1/9] xfs: dump xfiles for debugging purposes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829594.1748854.13298793357113477286.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a debug function to dump an xfile's contents for debug purposes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfile.h |    2 +
 2 files changed, 100 insertions(+)


diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 090c3ead43fdf..a76677cba6a3b 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -417,3 +417,101 @@ xfile_put_page(
 		return -EIO;
 	return 0;
 }
+
+/* Dump an xfile to dmesg. */
+int
+xfile_dump(
+	struct xfile		*xf)
+{
+	struct xfile_stat	sb;
+	struct inode		*inode = file_inode(xf->file);
+	struct address_space	*mapping = inode->i_mapping;
+	loff_t			holepos = 0;
+	loff_t			datapos;
+	loff_t			ret;
+	unsigned int		pflags;
+	bool			all_zeroes = true;
+	int			error = 0;
+
+	error = xfile_stat(xf, &sb);
+	if (error)
+		return error;
+
+	printk(KERN_ALERT "xfile ino 0x%lx isize 0x%llx dump:", inode->i_ino,
+			sb.size);
+	pflags = memalloc_nofs_save();
+
+	while ((ret = vfs_llseek(xf->file, holepos, SEEK_DATA)) >= 0) {
+		datapos = rounddown_64(ret, PAGE_SIZE);
+		ret = vfs_llseek(xf->file, datapos, SEEK_HOLE);
+		if (ret < 0)
+			break;
+		holepos = min_t(loff_t, sb.size, roundup_64(ret, PAGE_SIZE));
+
+		while (datapos < holepos) {
+			struct page	*page = NULL;
+			void		*p, *kaddr;
+			u64		datalen = holepos - datapos;
+			unsigned int	pagepos;
+			unsigned int	pagelen;
+
+			cond_resched();
+
+			if (fatal_signal_pending(current)) {
+				error = -EINTR;
+				goto out_pflags;
+			}
+
+			pagelen = min_t(u64, datalen, PAGE_SIZE);
+
+			page = shmem_read_mapping_page_gfp(mapping,
+					datapos >> PAGE_SHIFT, __GFP_NOWARN);
+			if (IS_ERR(page)) {
+				error = PTR_ERR(page);
+				if (error == -EIO)
+					printk(KERN_ALERT "%.8llx: poisoned",
+							datapos);
+				else if (error != -ENOMEM)
+					goto out_pflags;
+
+				goto next_pgoff;
+			}
+
+			if (!PageUptodate(page))
+				goto next_page;
+
+			kaddr = kmap_local_page(page);
+			p = kaddr;
+
+			for (pagepos = 0; pagepos < pagelen; pagepos += 16) {
+				char prefix[16];
+				unsigned int linelen;
+
+				linelen = min_t(unsigned int, pagelen, 16);
+
+				if (!memchr_inv(p + pagepos, 0, linelen))
+					continue;
+
+				snprintf(prefix, 16, "%.8llx: ",
+						datapos + pagepos);
+
+				all_zeroes = false;
+				print_hex_dump(KERN_ALERT, prefix,
+						DUMP_PREFIX_NONE, 16, 1,
+						p + pagepos, linelen, true);
+			}
+			kunmap_local(kaddr);
+next_page:
+			put_page(page);
+next_pgoff:
+			datapos += PAGE_SIZE;
+		}
+	}
+	if (all_zeroes)
+		printk(KERN_ALERT "<all zeroes>");
+	if (ret != -ENXIO)
+		error = ret;
+out_pflags:
+	memalloc_nofs_restore(pflags);
+	return error;
+}
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index d56643b0f429e..9022fe8924b94 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -74,4 +74,6 @@ int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
 		struct xfile_page *xbuf);
 int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
 
+int xfile_dump(struct xfile *xf);
+
 #endif /* __XFS_SCRUB_XFILE_H__ */

