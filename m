Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F0D1A682C;
	Sun, 10 May 2026 06:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778395756; cv=none; b=CWZ7KOMB80I8Csk7YnAxq+BYvu/pO3KGSpN0lQg1qLcyACu1wV68Ey+r+cvVdwmh1iJwkB7PrPzyiBJY5ddc3whWj0oFLJ3fLu+FYhm6PFQKRzrWWm5IniivrB+z8e5X9Qqjw1i1F1+bvgTPinakqNzvtZZgfln8rdeCqpMZMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778395756; c=relaxed/simple;
	bh=EzWGUfdYQiOout0YGYrTVDE/d950ERQgy6ztJqCnLAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=udp9G83oA8YolI1XzSsAAIA8LvBi6ONcjl8uXkK7m24DZ7og/19Xmg5oKaqHWb6f/+qBQQSeGekoqewOgNGPLc59ucJ7zoMONkHXONdiBhaTdzXDMplip4h4vMJ+bP0+7bJ+DRoYoU4HKvoTmBauZhSQLx+F4luoNgpHLvFQ0Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=V6ssRhYl; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="V6ssRhYl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=M6
	OZnrQ9NTeHYNCkVb0G8z8BWsRuRZ5gWA3G+JUn7e8=; b=V6ssRhYlEaEe3sy+zi
	8QYJ5qLm/MHBATW+V8hI7DsjTWLV4mAFZhAoGW39pTCjwFXo/CRs1SE/nAX1OHhM
	h2OGIOAsxLZ4ZyzosfFn+XD1lt8G05UxW+IvhVC1RHbYasfCFAMjAG8FuV5kZp2N
	cexFV8nkjktvvpGPeMJ+NxGVU=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wC3s+5IKgBqZG8YAg--.60749S2;
	Sun, 10 May 2026 14:48:41 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: brauner@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] iomap: add dirty page control to iomap_zero_iter
Date: Sun, 10 May 2026 14:47:37 +0800
Message-ID: <20260510064737.437597-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3s+5IKgBqZG8YAg--.60749S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFy3tFyxAr4xXFWUuF1xZrb_yoW8AF45pF
	Z5KF4vkr4xX3yxZFs7CF95Zryjvan3Gr47G3yYg3y5A398ZF1jyr1qgFW293Wxtryjkr1Y
	vr4q934xtr1UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjQ6JUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3Ao31GoAKkplfgAA3k

From: Chi Zhiling <chizhiling@kylinos.cn>

This patch prepares the iomap framework for exFAT's upcoming migration to
iomap. During testing of the exFAT iomap branch with xfstests generic/299
on a VM with 8GB RAM and a 40GB disk, system unresponsiveness was observed.

iomap_zero_iter() lacked dirty page throttling, which could cause memory
pressure when exFAT's valid_size mechanism triggers large-scale zeroing
operations during writes beyond valid_size.

Align iomap_zero_iter() with iomap_write_iter() by adding
balance_dirty_pages_ratelimited() to throttle dirty page generation during
large zeroing operations. Also add cond_resched() to provide voluntary
rescheduling points during long-running loops.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Namjae Jeon <linkinjeon@kernel.org>
---

exFAT iomap migration:
https://lore.kernel.org/linux-fsdevel/20260507124238.7313-1-linkinjeon@kernel.org/

 fs/iomap/buffered-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d7b648421a70..f6955786c8ad 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1543,6 +1543,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		size_t offset;
 		bool ret;
 
+		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
+
 		bytes = min_t(u64, SIZE_MAX, bytes);
 		status = iomap_write_begin(iter, write_ops, &folio, &offset,
 				&bytes);
@@ -1571,6 +1573,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		if (WARN_ON_ONCE(!ret))
 			return -EIO;
 
+		cond_resched();
+
 		status = iomap_iter_advance(iter, bytes);
 		if (status)
 			break;
-- 
2.43.0

