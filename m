Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABA21DA21
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 12:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731069093; cv=none; b=OTljgBScCycgNzktPJKooFDXKhnMGPj3pkHHCU40bOW1C44QiynpDCoPyN4nsnszS6eiowMGZsT4z6fWn5SrDvLU3eJ+UrydIxOtTAP8Zk7/2F4DpnYAwpz29efgw5pWxFur9KVG5+8OPO5sJjXr6nDS+z7yh1SkCY15JHbSHf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731069093; c=relaxed/simple;
	bh=3TkVF3R8W7Sp2eedBQQyjM8MnuxGisGbTTsQJQ4YLMg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i2KWfaPlehsTUEpCFel4Hkb1uQD9+LMOewgzNbYCuEZh/tb1rIbma844A2H8Hs3CiqrEpL0mw0z40EebpaMhIendFyZl/+izDGHOlynvSCRrWLgrjimBmDeo2DZbM4d1YUvdPS1v6ATFhku5joW/Z6qFfCYbztX7YjM5vRjXiQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XlJD20RB2z10V6W;
	Fri,  8 Nov 2024 20:29:38 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 06349180105;
	Fri,  8 Nov 2024 20:31:27 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 8 Nov
 2024 20:31:26 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>, <brauner@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH] iomap: fix zero padding data issue in concurrent append writes
Date: Fri, 8 Nov 2024 20:27:38 +0800
Message-ID: <20241108122738.2617669-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)

During concurrent append writes to XFS filesystem, zero padding data
may appear in the file after power failure. This happens due to imprecise
disk size updates when handling write completion.

Consider this scenario with concurrent append writes same file:

  Thread 1:                  Thread 2:
  ------------               -----------
  write [A, A+B]
  update inode size to A+B
  submit I/O [A, A+BS]
                             write [A+B, A+B+C]
                             update inode size to A+B+C
  <I/O completes, updates disk size to A+B+C>
  <power failure>

After reboot, file has zero padding in range [A+B, A+B+C]:

  |<         Block Size (BS)      >|
  |DDDDDDDDDDDDDDDD0000000000000000|
  ^               ^        ^
  A              A+B      A+B+C (EOF)

  D = Valid Data
  0 = Zero Padding

The issue stems from disk size being set to min(io_offset + io_size,
inode->i_size) at I/O completion. Since io_offset+io_size is block
size granularity, it may exceed the actual valid file data size. In
the case of concurrent append writes, inode->i_size may be larger
than the actual range of valid file data written to disk, leading to
inaccurate disk size updates.

This patch introduce ioend->io_end to trace the end position of the
valid data in ioend, rather than solely relying on ioend->io_size.
It ensures more precise disk size updates and avoids the zero padding
issue. Another benefit is that it makes the xfs_ioend_is_append()
check more accurate, which can reduce unnecessary end bio callbacks
of xfs_end_bio() in certain scenarios, such as repeated writes at the
file tail without extending the file size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/iomap/buffered-io.c | 4 ++++
 fs/xfs/xfs_aops.c      | 7 ++++---
 include/linux/iomap.h  | 1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ce73d2a48c1e..43c183476870 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1637,6 +1637,7 @@ iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends)
 			break;
 		list_move_tail(&next->io_list, &ioend->io_list);
 		ioend->io_size += next->io_size;
+		ioend->io_end = next->io_end;
 	}
 }
 EXPORT_SYMBOL_GPL(iomap_ioend_try_merge);
@@ -1723,6 +1724,7 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 	ioend->io_inode = inode;
 	ioend->io_size = 0;
 	ioend->io_offset = pos;
+	ioend->io_end = pos;
 	ioend->io_sector = bio->bi_iter.bi_sector;
 
 	wpc->nr_folios = 0;
@@ -1768,6 +1770,7 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 {
 	struct iomap_folio_state *ifs = folio->private;
 	size_t poff = offset_in_folio(folio, pos);
+	loff_t isize = i_size_read(inode);
 	int error;
 
 	if (!wpc->ioend || !iomap_can_add_to_ioend(wpc, pos)) {
@@ -1784,6 +1787,7 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 	if (ifs)
 		atomic_add(len, &ifs->write_bytes_pending);
 	wpc->ioend->io_size += len;
+	wpc->ioend->io_end = min_t(loff_t, pos + len, isize);
 	wbc_account_cgroup_owner(wbc, folio, len);
 	return 0;
 }
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 559a3a577097..e98e1b597156 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -37,8 +37,8 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
  */
 static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 {
-	return ioend->io_offset + ioend->io_size >
-		XFS_I(ioend->io_inode)->i_disk_size;
+	WARN_ON_ONCE(ioend->io_end > ioend->io_offset + ioend->io_size);
+	return ioend->io_end > XFS_I(ioend->io_inode)->i_disk_size;
 }
 
 /*
@@ -86,6 +86,7 @@ xfs_end_ioend(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_off_t		offset = ioend->io_offset;
+	xfs_off_t		end = ioend->io_end;
 	size_t			size = ioend->io_size;
 	unsigned int		nofs_flag;
 	int			error;
@@ -131,7 +132,7 @@ xfs_end_ioend(
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
 
 	if (!error && xfs_ioend_is_append(ioend))
-		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
+		error = xfs_setfilesize(ip, offset, end - offset);
 done:
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f61407e3b121..faed1f498b3b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -332,6 +332,7 @@ struct iomap_ioend {
 	struct inode		*io_inode;	/* file being written to */
 	size_t			io_size;	/* size of the extent */
 	loff_t			io_offset;	/* offset in the file */
+	loff_t			io_end;		/* end of valid data */
 	sector_t		io_sector;	/* start sector of ioend */
 	struct bio		io_bio;		/* MUST BE LAST! */
 };
-- 
2.39.2

