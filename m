Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6A2200AD
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324078; cv=none; b=d8vEs5OA5yQ9IVUBTkk0Hp+/keUIrzIykd/OKGwBUvAWXeinZTQxXo2CI+BFAJnxwnN70Vkb0exI/NoFrg8jOiMltpxtDpvCNMZ4ClCuhJTeeLlnmnt8reVTC+glUaTnnzD8tIib+lnSDJu2Ggv8O1wXEMiiKHNmbx6IjTXcTwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324078; c=relaxed/simple;
	bh=RCWy3MvsE/+NfQqFYbxFAIr3Xvwzg9ROHL180mPorus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qPhJduAyTgCqHKxL0kRFnOzA8woFdkh+t6VIL06UsB2GhTvMe2OLp+p+KQjNpS4q1LvkIizXSSGGMWe7+Fc6Z6H/IdNaMXdxot2tdvLUL2j1Nx5W4mCIE2pBAuuNE37wiGC8hVYJmZQp5AyvC+1qM2mth4DnQ54+96xBNRxRacA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ylps9fj9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ylps9fj9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4/RzxoU6qCYdRXE8FBWrLOZ1ZhnSkg1CJzUAgg76AuQ=; b=Ylps9fj9kWswSH/VAjHL0D99wO
	ZtNrfmMTyxBNhCzdsrb+GHan1koTpZ+48krwxaSBys3nUG5nU4YfcUcY+QEK+BqOvThIq6hWCoE1g
	TVqt5cwjhleyjDv4UoIz6SGk3Z4Iq9+zTUT762u9Iigm4yJ/lNSvEXE1surrmYKXZCI5Q4LQ9tfF0
	23Pku9TH5bSskgXJEMhsBM97A9sdfYcsSLuWXDPuS7eVXTGnYz5+uhgKYjEU1vrZbSb0IZNrX9kWI
	Lk8xqb3R5ZDqlqJQABoseBufqf0Qxsy8s7f5lcnOGmUi7dhmoiMp/EXyqoI5rHPzWs0bJw7TrmVox
	DWV2VB8A==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx86-00000009FFe-27dM;
	Mon, 19 Feb 2024 06:27:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/22] xfs: remove xfile_stat
Date: Mon, 19 Feb 2024 07:27:20 +0100
Message-Id: <20240219062730.3031391-13-hch@lst.de>
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

vfs_getattr is needed to query inode attributes for unknown underlying
file systems.  But shmemfs is well known for users of shmem_file_setup
and shmem_read_mapping_page_gfp that rely on it not needing specific
inode revalidation and having a normal mapping.  Remove the detour
through the getattr method and an extra wrapper, and just read the
inode size and i_bytes directly in the scrub tracing code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h | 34 ++++++++++------------------------
 fs/xfs/scrub/xfile.c | 19 -------------------
 fs/xfs/scrub/xfile.h |  7 -------
 3 files changed, 10 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 6bbb4e8639dca6..260b8fe0a80296 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -861,18 +861,11 @@ TRACE_EVENT(xfile_destroy,
 		__field(loff_t, size)
 	),
 	TP_fast_assign(
-		struct xfile_stat	statbuf;
-		int			ret;
-
-		ret = xfile_stat(xf, &statbuf);
-		if (!ret) {
-			__entry->bytes = statbuf.bytes;
-			__entry->size = statbuf.size;
-		} else {
-			__entry->bytes = -1;
-			__entry->size = -1;
-		}
-		__entry->ino = file_inode(xf->file)->i_ino;
+		struct inode		*inode = file_inode(xf->file);
+
+		__entry->ino = inode->i_ino;
+		__entry->bytes = inode->i_blocks << SECTOR_SHIFT;
+		__entry->size = i_size_read(inode);
 	),
 	TP_printk("xfino 0x%lx mem_bytes 0x%llx isize 0x%llx",
 		  __entry->ino,
@@ -891,19 +884,12 @@ DECLARE_EVENT_CLASS(xfile_class,
 		__field(unsigned long long, bytecount)
 	),
 	TP_fast_assign(
-		struct xfile_stat	statbuf;
-		int			ret;
-
-		ret = xfile_stat(xf, &statbuf);
-		if (!ret) {
-			__entry->bytes_used = statbuf.bytes;
-			__entry->size = statbuf.size;
-		} else {
-			__entry->bytes_used = -1;
-			__entry->size = -1;
-		}
-		__entry->ino = file_inode(xf->file)->i_ino;
+		struct inode		*inode = file_inode(xf->file);
+
+		__entry->ino = inode->i_ino;
+		__entry->bytes_used = inode->i_blocks << SECTOR_SHIFT;
 		__entry->pos = pos;
+		__entry->size = i_size_read(inode);
 		__entry->bytecount = bytecount;
 	),
 	TP_printk("xfino 0x%lx mem_bytes 0x%llx pos 0x%llx bytecount 0x%llx isize 0x%llx",
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 95250db81981ab..b212d4a9c78028 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -274,25 +274,6 @@ xfile_seek_data(
 	return ret;
 }
 
-/* Query stat information for an xfile. */
-int
-xfile_stat(
-	struct xfile		*xf,
-	struct xfile_stat	*statbuf)
-{
-	struct kstat		ks;
-	int			error;
-
-	error = vfs_getattr_nosec(&xf->file->f_path, &ks,
-			STATX_SIZE | STATX_BLOCKS, AT_STATX_DONT_SYNC);
-	if (error)
-		return error;
-
-	statbuf->size = ks.size;
-	statbuf->bytes = ks.blocks << SECTOR_SHIFT;
-	return 0;
-}
-
 /*
  * Grab the (locked) page for a memory object.  The object cannot span a page
  * boundary.  Returns 0 (and a locked page) if successful, -ENOTBLK if we
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index d56643b0f429e1..c602d11560d8ee 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -63,13 +63,6 @@ xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
 
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
-struct xfile_stat {
-	loff_t			size;
-	unsigned long long	bytes;
-};
-
-int xfile_stat(struct xfile *xf, struct xfile_stat *statbuf);
-
 int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
 		struct xfile_page *xbuf);
 int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
-- 
2.39.2

