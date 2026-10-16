Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958803B058E;
	Fri, 16 Oct 2026 03:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121729; cv=none; b=Pu3rJRKuTye6npOfFPWxGCD5QdCI2O1ipSR1TtmhmY9Yg1SDW+B5GMenmrOJSuWnKOgcJ6F2q/59iSel/U0aeDwUoLPZaA97D9cnTtXD/hlZy/ZsQp2i+ZAd1aACcWOIcoZyGb0uKWbPx97KCNXoXyy1oc20EhvZwnsXwZoyM2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121729; c=relaxed/simple;
	bh=/ucqjeq4Z0X43h5QZ/ZnaMgMaJuX2GyffTaSmQeXXas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbMeVsD0ndOhTgN7hCe2zwf7Ig8koehGqSOR0TAeHuw3RMCnoFOd1I7AZ18ZiaHNb5FcwJX2d35eM6PU5k8LMMcUSsI0TzyMCV0EHpjiiOp2UUIc7BPp5EV6DEQZk60wkv3+BGvANb4V7ooFl6kCT+SLKK59tjLXAqPDqiJnchA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TZ7bMrxh; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TZ7bMrxh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=KB
	QsnqfgMVbXbgh//cAiUhOPNT731GlXPIwXwXR6P+Q=; b=TZ7bMrxhNL7m/rwnaX
	+6k9JtMvdLlbVd/xc922Begs0IRLxNNriLOyDNU6MABAEIennsEIPhsRmGGvFvKs
	1v2MtG02YYptU4bExm7p1Wztvgx0cl8SuR3uTcy0FIWZ0AibWlrD5Yr00Zhvja/b
	UOM58bz7RcGMEs63WjfypK7rc=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S10;
	Fri, 16 Oct 2026 11:34:24 +0800 (CST)
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
Subject: [PATCH v3 8/8] exfat: publish i_size and valid_size on direct I/O completion
Date: Fri, 16 Oct 2026 11:33:49 +0800
Message-ID: <20261016033349.3104509-9-chizhiling@163.com>
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
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S10
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF17Aw1xtry5GFW7ZF1xuFg_yoWrtFykpr
	Z0g3Z3GrWDJ347Wr1kKFyUXa4Fka1fKay7GryFkr45Zr90ywn3KFyjqFyF9ay3J392yw1j
	qF4qgrWrur9rC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UHuWLUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+AAGo2rRm0DibwAA3w

From: Chi Zhiling <chizhiling@kylinos.cn>

exfat_write_iomap_end() advances valid_size from the submission path.
A direct write that later fails or completes short has therefore already
marked its range valid, and __exfat_write_inode() records
max(i_size, valid_size) as DataLength, growing the file on disk even
though no data was written.

Advancing valid_size early also lets a racing mmap fault map the range
and pull the not-yet-overwritten contents of the recycled cluster into
the page cache.

Publish both fields from ->end_io() instead, once the transfer has
completed successfully, and stop advancing valid_size from ->iomap_end();
buffered writes still publish valid_size under the folio lock via
->put_folio().

Note the trade-off: clusters for an extending direct write are allocated
in ->iomap_begin() while i_size is published only at completion.  An
inode writeback racing with an in-flight direct write, or a crash before
it completes, can therefore temporarily leave DataLength smaller than
the allocated cluster chain, which fsck reports as "more clusters are
allocated".

Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/exfat/inode.c |  9 +++------
 fs/exfat/iomap.c | 34 +++++++++++++++++++---------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 5129df1e79b4..f627b53eb3ca 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -74,12 +74,9 @@ int __exfat_write_inode(struct inode *inode, int sync)
 			     NULL);
 
 	/*
-	 * During a DIO write, valid_size is updated eagerly in iomap_end (so
-	 * that concurrent buffered reads see IOMAP_MAPPED) while i_size is
-	 * updated asynchronously in end_io.  The FAT chain was already
-	 * extended to cover ceil(valid_size/cluster_size) clusters.  Use the
-	 * maximum so the on-disk size field always covers the FAT chain,
-	 * preventing fsck from reporting "more clusters are allocated".
+	 * TODO: DIO allocates clusters in ->iomap_begin() but updates i_size
+	 * only at completion.  A crash after the inode was written back in
+	 * that window makes fsck report "more clusters are allocated".
 	 */
 	on_disk_size = max_t(unsigned long long, i_size_read(inode),
 			valid_size);
diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index b25d149f8004..46bf057efcdc 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -15,22 +15,31 @@
 /*
  * exfat_file_write_dio_end_io - Direct I/O write completion handler
  *
- * Updates i_size if the write extended the file. Called from the dio layer
- * after I/O completion.
+ * Updates i_size and valid_size after the transfer has completed
+ * successfully. Whenever metadata is published, this runs in process
+ * context and under i_rwsem.
  */
 static int exfat_file_write_dio_end_io(struct kiocb *iocb, ssize_t size,
 		int error, unsigned int flags)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t end = iocb->ki_pos + size;
+	bool dirtied = false;
 
-	if (error)
+	if (error || !size)
 		return error;
 
-	if (size && i_size_read(inode) < iocb->ki_pos + size) {
-		i_size_write(inode, iocb->ki_pos + size);
-		mark_inode_dirty(inode);
+	if (i_size_read(inode) < end) {
+		i_size_write(inode, end);
+		dirtied = true;
 	}
 
+	if (exfat_advance_valid_size(EXFAT_I(inode), end))
+		dirtied = true;
+
+	if (dirtied)
+		mark_inode_dirty(inode);
+
 	return 0;
 }
 
@@ -193,15 +202,11 @@ static const struct iomap_ops exfat_swap_iomap_ops = {
 
 /*
  * exfat_write_iomap_end - Update the state after write
- *
- * Extends ->valid_size to cover the newly written range.
- * Marks the inode dirty if metadata was changed.
  */
 static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		ssize_t written, unsigned int flags, struct iomap *iomap)
 {
 	struct exfat_inode_info *ei = EXFAT_I(inode);
-	bool dirtied = false;
 	loff_t end;
 
 	if (!written)
@@ -209,18 +214,17 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	end = pos + written;
 
-	if (exfat_advance_valid_size(ei, end))
-		dirtied = true;
-
 	/*
 	 * IOMAP_F_ZERO_TAIL zeroes the remainder of the last block. Track that
 	 * block as zeroed so later valid_size extensions do not zero it again.
 	 */
 	if (iomap->flags & IOMAP_F_ZERO_TAIL)
 		end = round_up(end, i_blocksize(inode));
-	exfat_advance_zeroed_size(ei, end);
 
-	if (dirtied || iomap->flags & IOMAP_F_SIZE_CHANGED)
+	if (!(flags & IOMAP_DIRECT))
+		exfat_advance_zeroed_size(ei, end);
+
+	if (iomap->flags & IOMAP_F_SIZE_CHANGED)
 		mark_inode_dirty(inode);
 
 	return written;
-- 
2.53.0

