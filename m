Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF03C4553;
	Thu, 14 May 2026 06:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778740493; cv=none; b=cV2vwuMxAwMSydUevGLEjV2YlXcxiXI0SjFQemApVznrD2bbPFI5Ri0FA9RBuz06KA4SUAGmvnW0hN4O/CVQR02C7lq8aw3p9v69omS5exWOa8mIhvH6f9UkzR0c8Lot1LG3rWiVVqkEgSFgyoAYiNXbunZ0jDejGq6aT+a13lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778740493; c=relaxed/simple;
	bh=yve/zbgSuUshC2W///tJeSfhRFvCvYaK5aTaNm0cRnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrlmPO0Ub0mzlTJV8L/G8/N8qcpk/iJzF2Mt+DiuY1GnazRm1sw2KzXYWL3N/cQ8EHjt2yG6rr4Bg5BiBbrBeYgSyWbf6uUMMx+6J95PGwu+0tSgYs/ry8bXKTvCjNRFiz965BEU/WlU2u0/rxRy0lhHUHd0Cr4fvw1qqzD6pdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGLBj4WbrzKHMQM;
	Thu, 14 May 2026 14:33:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D99CE40574;
	Thu, 14 May 2026 14:34:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1v4bAVqIcT3CA--.41732S6;
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
Subject: [PATCH 2/4] iomap: support invalidating partial folios
Date: Thu, 14 May 2026 14:29:53 +0800
Message-ID: <20260514062955.1183976-3-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnb1v4bAVqIcT3CA--.41732S6
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1xtrW5Jw48tw18Kr4fAFb_yoW8Cr43pF
	W3KrWDGryDGr17uw17Ca1fXF1j9a9xXFy7CFW3Gw1a9Fs8Jw1qgFyUKa1Ygay7JryxAF1S
	vrsFgFyvqF15A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
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
	vjDU0xZFpf9x0JUQXo7UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Current iomap_invalidate_folio() can only invalidate an entire folio. If
we truncate a partial folio on a filesystem where the block size is
smaller than the folio size, it will leave behind dirty bits for the
truncated or punched blocks. During the write-back process, it will
attempt to map the invalid hole range. Fortunately, this has not caused
any real problems so far because the ->writeback_range() function
corrects the length.

However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
the support for invalidating partial folios. When ext4 partially zeroes
out a dirty and unwritten folio, it does not perform a flush first like
XFS. Therefore, if the dirty bits of the corresponding area cannot be
cleared, the zeroed area after writeback remains in the written state
rather than reverting to the unwritten state. Fix this by supporting
invalidation of partial folios.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
This is taken from:
 https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-3-yi.zhang@huaweicloud.com/
No code changes, only update the commit message to explain why Ext4
needs this.

 fs/iomap/buffered-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 64351a448a8b..876c2f507f58 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -761,6 +761,8 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
 		WARN_ON_ONCE(folio_test_writeback(folio));
 		folio_cancel_dirty(folio);
 		ifs_free(folio);
+	} else {
+		iomap_clear_range_dirty(folio, offset, len);
 	}
 }
 EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
-- 
2.52.0

