Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207652;
	b=cPmznuKDIImdO7jHpegnRG4OFEBNKG/CiN7twXKSKWgRvG1y2bsqsSVq8l3xwLuSQCkF
	 TGXNQa+VNt9nBNJxZQn+6ABVPHKDcJUufvFj3PwB5kb1QwGch68oPxKKTi7osZsMdJ48G
	 aigBBB9HUyWyVbPAn+LLdpN3XnxBwzOH3rYpOxgroofo8XL2WHC2vXspBtWSJDz+BQIIt
	 GWHOn++wOyY1aB1HXjSy9YqAgFRrJYUroVEN/qko79XOWV8Y4vO9mYkPmRUi65TGFBNLS
	 33KhvvCCtzNmlZCqmYi+aCTI5ivFwnS2J2XVGl6Axzpq/HwyfLD1jBFeqvEEHvd/65g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207652;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=QB3DQkHKewxyAlfXCuIaA2xVKs4/vXc3oiydASgPqyM=;
	b=HLRZGdyRwSSQe6ojOnGQVeeGilpJeHhxNAI6RcLixAu6wfJ2kUBKDs2iEEo42kyUQiKU
	 hWWK7/Ba8hxs/36oEfHh9bV0EAPxZ4RZKFoEjFqVQ1On18IXPQLXnKv8JwoIZesxPRTgV
	 mCBREWcPoAjDUzdNFjxRd8rFnJ/WIw6ObI6XK6IRbfdhcx//cuRuuaqV6W2G+GUXk8+7D
	 pzfLPQkDfGiOYgRD6NHRYoCMsax06vPRNrGeChtjLF2NasCAAtnSCPdMGd6xQDVvQtFZU
	 tRB9rE7BhZMI7tOvLcsP2sLj8zpDxgHqyV9cPzT2nML3/W0XSy7/PN71mn4MoFGAegA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b="nVT2P7/B";
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4331606A70B;
	Fri, 20 Nov 2026 20:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4331606A70B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=nVT2P7/B
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=QB3DQkHKewxyAlfXCuIaA2xVKs4/vXc3oiydASgPqyM=; b=nVT2P7/Bs452hZaK/VqjLiX+R/
	NSRhKMvDeo9euErshbHfv88yqYhDYFxfBcR/3nszgAZigyMzZ8+9qwxQep8o6LJx0xh+0ncHesY2f
	L34n9y114SCHc8mpXvAtalNIKuyzFLHOWNWIsjJEjaIsiYPHAvT5qz9fLOOczJ60XFwFA3H1ELzyx
	MGd7oYZ4kRzAtqpQpycChvsz+vQ0g/R60zQ3mSAn17zFh4svdVsibLuFJPQRUk+cVkCcaqOLCNPUD
	KG6XdL9NyJFlolakVleDHPhDsBHyOyME80CkL7UScMWL/cVwnZ/JnqqtIh0UshKX1LscAxxrscnAU
	IilsvSFQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xUVVs-0038lG-1l;
	Fri, 20 Nov 2026 20:47:17 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 20 Nov 2026 12:24:39 -0800
Subject: [PATCH v2] iomap: don't update i_size of block devices on buffered
 write
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-iomap-bdev-isize-v2-1-f25cc668fbc1@debian.org>
X-B4-Tracking: v=1; b=H4sIAIasAGsC/32NQQ6CMBBFr0Jm7RgGYmtdeQ/DoqUjzMKWtKZRC
 Xe3cgCX7+f/91fInIQzXJoVEhfJEkOF7tDAONswMYqvDF3bKSLqUeLDLug8F6zlD6NVmpQajSa
 noc6WxHd57crbUHmW/IzpvT8U+qV/ZIWQUBmj2t6dzsbbq2cnNhxjmmDYtu0LKJPIdrEAAAA=
X-Change-ID: 20261113-iomap-bdev-isize-a67166c971b7
To: Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Hannes Reinecke <hare@suse.de>, Pankaj Raghav <p.raghav@samsung.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, 
 Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3415; i=leitao@debian.org;
 h=from:subject:message-id; bh=OeqcVAltHM4RtPQZXAK+e1A+oZ2XU3m4yMm6IB1Ax4E=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBrALHRlQvyjp+VC8HvnqlGkW++MaT+b7D97kq34
 iG11+f/00+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCawCx0QAKCRA1o5Of/Hh3
 beEoD/9ZzAYRp4F4Gkw7NJ+WslnwPRyCx8Q2Q2nl9miIDVxpp2gUM8XHJgtLkAMVHd/JW4HgM3m
 7DcMaz7+WKeqNmGi9wJ+2dVDgHQ3WdkORU1xD0zS0cJ9fPRCpkzOAKFfmtybry96PAHEmbeXXVS
 Zs2+GGO2hsjTNh2vWzPcyTH3p3Qi2MJ8fr8+KgAacXD6zR6Ag5vICgahCzhkq4F0hqbvqJ5aCdX
 cGZPiFfvrwJF+uicrUZOHktiv+pXXkW8xMA4a4+YUaRb9IaJ1hMv2bUap+0dO6PxZAXQ8ciXyf2
 qEmuGYeXSUXNlSHKJIsPIsqr0MX6ijvl2AoR74dAWZ1ikz98ICXygf+ejJclshFMaFiZ0uXp4U0
 nN2cbIG4jrJGDdJ2+80vKgKzExuQrD1akdCz9rmj+3l+pVXu6fo/3Ys4PHOXbuZktZNiRla81VN
 GOqJ1pgsmNjd1axhZEElECcwmHS0Sqeg0+mlCe7oLgJajrqLbwFUBDaBfmZmfg+eF+OMfhEd5ED
 FG+Rzwn5Yzxd6plXk3tWSvL0TV1Zzdao9fGSzmux3MhXGAPBIYrD03f2FCr+lyo0jVnYyzKCyFp
 yAF/RtwWAnbnC4ZC35ytsSJGtZz9LbVUfXwbQ31D1TfNyTCyFayxke19SmWIvQIW2RgJiLOD3p7
 IFQQ1+JrCuMkLgQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

We are seeing this warning on an arm64 linux-next host while the ublk
selftests run (stress_01 deletes the ublk disks under fio buffered
writes):

  WARNING: mm/truncate.c:902 at pagecache_isize_extended+0x37c/0x490, CPU#40: iou-wrk-3496756/3497370
  Call trace:
   pagecache_isize_extended+0x37c/0x490 (P)
   iomap_file_buffered_write+0x38c/0x5d0
   blkdev_buffered_write+0xcc/0x138
   blkdev_write_iter+0x32c/0x4e0
   io_write+0x77c/0xff8

The theory is that the disk shrank under the write. del_gendisk() sets
the capacity to 0, which writes the bdev inode's i_size under
bd_size_lock only. A writer whose mapping predates that reads
old_size == 0 in iomap_write_iter(), sets i_size to pos + written and
calls pagecache_isize_extended(inode, 0, pos). blkdev_buffered_write()
holds i_rwsem shared, so a writer at a lower offset can store a smaller
i_size in between, and WARN_ON(to > inode->i_size) fires. Even without
the warning, the write path regrows the size of a dead disk. The block
layer owns that size (bdev_set_nr_sectors()), and blkdev_write_end()
never touched it before the switch to iomap.

A reproducer on linux-next supports the theory: 128 threads doing 64K
buffered writes to a loop device, while another thread flips its
capacity between 1M and 1G with LOOP_SET_STATUS64, hit the warning 6
to 18 times per 30 second run (4 runs). With this patch it never fires,
and data written through the page cache still reads back intact.

Skip the size update and pagecache_isize_extended() for block devices.

Fixes: 487c607df790 ("block: use iomap for writes to block devices")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Use a function-scope update_isize variable instead of duplicating the
  S_ISBLK and IOMAP_F_FSVERITY checks (hch)
- Link to v1: https://patch.msgid.link/20261113-iomap-bdev-isize-v1-1-699603b589da@debian.org
---
 fs/iomap/buffered-io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d843b168d5f7d..d3311e7066c13f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1191,6 +1191,8 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 {
 	int status = 0;
 	struct address_space *mapping = iter->inode->i_mapping;
+	bool update_isize = !S_ISBLK(iter->inode->i_mode) &&
+			    !(iter->iomap.flags & IOMAP_F_FSVERITY);
 	size_t chunk = mapping_max_folio_size(mapping);
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
 
@@ -1256,14 +1258,13 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		 * unlock and release the folio.
 		 */
 		old_size = iter->inode->i_size;
-		if (pos + written > old_size &&
-		    !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
+		if (pos + written > old_size && update_isize) {
 			i_size_write(iter->inode, pos + written);
 			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		}
 		__iomap_put_folio(iter, write_ops, written, folio);
 
-		if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
+		if (old_size < pos && update_isize)
 			pagecache_isize_extended(iter->inode, old_size, pos);
 
 		cond_resched();

---
base-commit: 6d582d78fad9d828e575ca0cdcff8ea47a77220b
change-id: 20261113-iomap-bdev-isize-a67166c971b7

Best regards,
--  
Breno Leitao <leitao@debian.org>

