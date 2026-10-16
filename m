Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087B7190462;
	Fri, 16 Oct 2026 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121695; cv=none; b=M3HOb8f6FCt04/GWPpleQDkh4/LAu3XQQ7/Y0r1znUzhoaxl1p2TjYvjjeBaVWrkKTvZRFt7XeskQhqtCluoKgGcJM29wq8dFdM6ktlvXFBwi0JtrlSpasZ2P8n93xWd0YBdrihtn6GhVDprt7YSnAcNd3gn416rSyweagJR6W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121695; c=relaxed/simple;
	bh=vAHxlKValuzrf7fHdjJyLINvsVocAWsyJuxqCU924rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f70YjrYE374IPm40+hfwu4M9y7ZJSYMDHFvj6tHWunU22Fz2CjN3GRt/5o6/txExmsc2J5FuyU1PoaMh/esy3bSxmaBUHPt4IiIXpKmnH3ZNpbfmRuCV8chKCyPHHtmsZc79TdajubNc0qeke8u9GFKtGFX/2vsHtaz9sCYECc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=g6Q6tq9r; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="g6Q6tq9r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=wV
	g6dh31gWOkXJkdICl6ryGnaGtJLOBkftSZV8P268Y=; b=g6Q6tq9raSWShaYMfH
	cewNIfycktr89QMwHfCUu4XvTrs0OFkhlIxyHVKr0bWjfnyiDKVThKTHxG+W3amt
	mtmixD6utL8plCfwqpZb92qEVuNLW49ZwUj7a03IOsVQC3Tt0wgpqLWjeY7ZSYkp
	fRjVhUgYd2/636JfvVgH9weUs=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S5;
	Fri, 16 Oct 2026 11:34:22 +0800 (CST)
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
Subject: [PATCH v3 3/8] exfat: advance valid_size under the folio lock for buffered writes
Date: Fri, 16 Oct 2026 11:33:44 +0800
Message-ID: <20261016033349.3104509-4-chizhiling@163.com>
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
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw47tF45KF4kXFW8AF18Krg_yoW5JFW5p3
	98Kay5GrZ7Xay3Wr1DGFy5X34Y9a4fWr4fCr98GanxZFnIyw1IkF18KFy2kFW5Jwn8GF1F
	qFs09348XFnrCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jgF4_UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3B4FomrRmz4mkAAA3N

From: Chi Zhiling <chizhiling@kylinos.cn>

Buffered writes currently advance valid_size in
exfat_write_iomap_end(), which runs after the folio has been unlocked.
As a result, a folio beyond valid_size can become uptodate and dirty,
and be observed by writeback or reclaim while valid_size still points
to an earlier position.

If reclaim drops such a folio before valid_size covers its range, a
subsequent read treats the range as unwritten and zero-fills it without
reading from disk. When this zero-filled page is later written back,
the zeros overwrite the data that was just written, silently losing
the write even if valid_size has since been advanced.

Advance valid_size from the buffered write path via an iomap
put_folio callback while the folio is still locked. This ensures
valid_size is updated before the folio becomes visible to writeback,
preventing the written data from being lost. Mark the inode dirty
whenever valid_size advances.

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/exfat/file.c  |  3 +++
 fs/exfat/iomap.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index aa0e1e47e3d1..49c63364f747 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -929,6 +929,9 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret < 0)
 		goto unlock;
 
+	if (exfat_get_valid_size(ei) > valid_size)
+		mark_inode_dirty(inode);
+
 	inode_unlock(inode);
 
 	if (iocb->ki_pos > pos) {
diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 32ca90b61b1a..10416335e8ee 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -232,6 +232,18 @@ const struct iomap_ops exfat_write_iomap_ops = {
 	.iomap_next	= exfat_write_iomap_next,
 };
 
+static void exfat_iomap_put_folio(struct inode *inode, loff_t pos,
+		unsigned int copied, struct folio *folio)
+{
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+
+	if (copied)
+		exfat_advance_valid_size(ei, pos + copied);
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 /*
  * exfat_iomap_read_folio_range - Read a block range during a buffered write
  *
@@ -261,6 +273,7 @@ static int exfat_iomap_read_folio_range(const struct iomap_iter *iter,
 }
 
 const struct iomap_write_ops exfat_iomap_write_ops = {
+	.put_folio	= exfat_iomap_put_folio,
 	.read_folio_range = exfat_iomap_read_folio_range,
 };
 
-- 
2.53.0

