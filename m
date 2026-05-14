Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A643A36604C;
	Thu, 14 May 2026 06:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778740490; cv=none; b=ZfIIenBte2douR9sE68nq/oLv4v/OklewALDHQTZfPlQIkuetGXrjjJMQWz012XDiW80U6CLvhYcOgJKqtKUJWtZT84aHyTI2/nURVngzP6S2dyXG3GRGjNV71BR4cWUKuHPI2ETyd626/BsFDr96F7DYK24DOBxYnTKM7ZuoMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778740490; c=relaxed/simple;
	bh=2wZ4jznOhPUYM8F9x4n6kgyHx1pEIWJdJlky+NdfO6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk1LNe+UWJgdOIyOUgl2+7WG+kxSRMHyzxlLdFwieSnsoTxWMqYEJ01FzFk1/eMvwD15b7Q2g2WkZWrDKnEzvczv0W+qeZLxMxEJDjXUDMfgsnnkP/nI4wf4Z+vWo3W++5nMosPIHDvErrzCmLuOLIP1/h/UEiAl5KxM3bqhygM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGLBj3lxQzKHMQM;
	Thu, 14 May 2026 14:33:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C2BDD4058F;
	Thu, 14 May 2026 14:34:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1v4bAVqIcT3CA--.41732S5;
	Thu, 14 May 2026 14:34:44 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH 1/4] iomap: correct the range of a partial dirty clear
Date: Thu, 14 May 2026 14:29:52 +0800
Message-ID: <20260514062955.1183976-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnb1v4bAVqIcT3CA--.41732S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ury5ArW5Wr4DKF1xuryDJrb_yoW8Zr4DpF
	s3KFs8KrWDX348ua4kZFW8XFnYya9rXF48JrW3Wwn3Wa15AF1FgF1v93y5uF97Kr47AF10
	vF13trWxCr4DArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JU2dgAUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The block range calculation in ifs_clear_range_dirty() is incorrect when
partially clearing a range in a folio. We cannot clear the dirty bit of
the first block or the last block if the start or end offset is not
blocksize-aligned. This has not yet caused any issues since we always
clear a whole folio in iomap_writeback_folio().

Fix this by rounding up the first block to blocksize alignment, and
calculate the last block by rounding down (using truncation). Correct
the nr_blks calculation accordingly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
This is modified from:
 https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-2-yi.zhang@huaweicloud.com/
Changes:
 - Use round_up() instead of DIV_ROUND_UP() to prevent wasted integer
   division.

 fs/iomap/buffered-io.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d7b648421a70..64351a448a8b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -176,13 +176,17 @@ static void ifs_clear_range_dirty(struct folio *folio,
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
-	unsigned int first_blk = (off >> inode->i_blkbits);
-	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
-	unsigned int nr_blks = last_blk - first_blk + 1;
+	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
+				 inode->i_blkbits;
+	unsigned int last_blk = (off + len) >> inode->i_blkbits;
 	unsigned long flags;
 
+	if (first_blk >= last_blk)
+		return;
+
 	spin_lock_irqsave(&ifs->state_lock, flags);
-	bitmap_clear(ifs->state, first_blk + blks_per_folio, nr_blks);
+	bitmap_clear(ifs->state, first_blk + blks_per_folio,
+		     last_blk - first_blk);
 	spin_unlock_irqrestore(&ifs->state_lock, flags);
 }
 
-- 
2.52.0

