Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293193BF67E;
	Mon, 11 May 2026 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778492489; cv=none; b=EJx0PWMqhxonRjWW0JoTS2qpeYx4cXmysp1YgGZw7v7QyQHxA10saFpnKt7RLL120euiW5rattHLQ6IrQFuQJNfTZ0K7a+Yfu2OlJ54kdDRd/tz2hctxpmGlx7kTyOgCW9bvgtv3Z5Lm9AFPQF+gIZQjMNjDg2GCPcSRN7CEuv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778492489; c=relaxed/simple;
	bh=LV987saU/haAHHhM0QA0gqYG4j7drY6nUklyC19IhkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ucMzNp+VlzhnNSBCxBfVjSFU802cfGuPa9797pPM3MIgRmqiZPE9pqnea8lN0Q5jcdij3XflM7IwE2bRKQVQj6qi7b+XWVXn1uIlx2P0ZVpmSW0VLcK5xN2uaqdeXxG+5bIO8TQ4Cbohkbz/wgd3bYg2Eak0Tl6xWzxHfybQcCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=n80tatVQ; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="n80tatVQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=KD
	8EuOtVwLUcSSsQFPIWzjXfnSw8ORSQtnlNpdv95Sk=; b=n80tatVQkMwOz2z81F
	wKywpVv3PmMd3q73+ljzymSihL1humScDMwQD1P0Il+o/uThPDtaE+DWFatsEkYp
	Bvvg15hWy4jHHpVWtzFy0Kx7Ld5AwIN/Q4HKx8ZSeuz0jKxGYRkBZ2O7hOz49Q6L
	h7y7RxfmxdvYL2rFB2zD9RtE0=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgCn2+kkpAFqIgtKDQ--.230S2;
	Mon, 11 May 2026 17:40:55 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	chizhiling@kylinos.cn,
	djwong@kernel.org,
	hch@lst.de,
	linkinjeon@kernel.org,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com
Subject: [PATCH v2] iomap: add dirty page control to iomap_zero_iter
Date: Mon, 11 May 2026 17:40:07 +0800
Message-ID: <20260511094007.728011-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgCn2+kkpAFqIgtKDQ--.230S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFy3tFyxAr4xXFWUuF1xZrb_yoW8XFWxpF
	Z5KF4qkF4xX34xZa1kGF95Zryjvan3Wr4fGr90g3yYyFZ8ZF1j9r4q9FWxu3WxtryDCr4Y
	vr4qk34Igr15ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjPfdUUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2woOq2oBpCqxbQAA3N

From: Chi Zhiling <chizhiling@kylinos.cn>

This patch prepares the iomap framework for exFAT's upcoming migration to
iomap. During testing of the exFAT iomap branch with xfstests generic/299 on
a VM with 8GB RAM and a 40GB disk, system unresponsiveness was observed.

iomap_zero_iter() lacked dirty page throttling, which could cause memory
pressure when exFAT's valid_size mechanism triggers large-scale zeroing
operations during writes beyond valid_size.

Align iomap_zero_iter() with iomap_write_iter() by adding
balance_dirty_pages_ratelimited() to throttle dirty page generation during
large zeroing operations

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Namjae Jeon <linkinjeon@kernel.org>
---

v1:
https://lore.kernel.org/linux-fsdevel/00f28748-8244-4fb7-a61d-a08bf90630a9@163.com/T/#t

exFAT iomap migration:
https://lore.kernel.org/linux-fsdevel/20260507124238.7313-1-linkinjeon@kernel.org/

 fs/iomap/buffered-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d7b648421a70..437a7c527c4a 100644
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
-- 
2.43.0

