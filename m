Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867A33FADFD;
	Tue, 14 Jul 2026 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017912; cv=none; b=CyUePhpU+FLZsrRx4b+7I4GDkHltAxAcjMjPMo/c4K+zuA6Rt6WV2aPhi/wu7qCm4VjDg6vM0bZGM2jPDpnI7hrwv2HxSUit/ikU+QCINV6eZC/V2RRemy0pTgq4c/pkFrwKrFwHPjQ08K4/4U43YZpW9Zlj0T0vYnH05WlAOMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017912; c=relaxed/simple;
	bh=QoJVaDEx6avjuCddykKA75FmCiy4nlNPQjeqbaDA23E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCnZhprjiTMZ0oCm4hZR38sxASR7tl5eznNJrKsgn6Ewu66xrOcS+wJrQcSyG5zOviVKCmDQ1dTY1Qu/GIfQErnEfhBMP4Oxm9d+IL63V5fsCh9KDQqtjYQVnutB/wvP4OyoMJVNJlRfoJR3w/4Fs9dztsNqP+GhqsxveOOuzDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzsvz46PBzKHMNQ;
	Tue, 14 Jul 2026 16:31:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E5D644058D;
	Tue, 14 Jul 2026 16:31:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nLl81VqTRS8BA--.57256S6;
	Tue, 14 Jul 2026 16:31:41 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	joannelkoong@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 2/5] iomap: support invalidating partial folios
Date: Tue, 14 Jul 2026 16:23:22 +0800
Message-ID: <20260714082325.325163-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH1nLl81VqTRS8BA--.57256S6
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1xtrW5Jw48tw18Kr4fAFb_yoW8ArWxpF
	ZxK3yDGryDGr17uw17CayfZa4j9a93WFW7GFW3Gw1a9Fs8trn8KF17Ka1F9ay3Jr1kAF1S
	vrsF9Fy0qF15A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUbH5lUUUUUU==
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 48878bc4ff62..aeeed6316cf9 100644
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

