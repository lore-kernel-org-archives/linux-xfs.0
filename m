Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9918E3FBB67;
	Tue, 14 Jul 2026 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017914; cv=none; b=If6NwMeMhzCVyygDCEISjzIIxTfj9A9mThUzQ1+6wApAktxW9/hKQg3Zhd02ioSQ4uBsUTBLfOdNZVAkRQ1CwVAIoY/zfK3HZBmqaZzdwHN7YfX+EB/P9O6Zu+olmmz6PycedFGKddZNOpnC0rI+qSSlEt/loUS/ZU90C6A75/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017914; c=relaxed/simple;
	bh=9cksmDzyht38Xs3RpMzyLto/ApFPrVE5v868t+IGv9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dgRqFOdsbWp0zJ9gjFsNqZePNM6qeKtkf+8BBjp8Q+yr9rS43SEFfLUk78vCf/lvtzZHYYamEbgFrx6UZ842CgFxqv02/ixa5z/t4GavUyDgzBjz6/ltn7hHumEctPGvKwllMZPkyylE/FtDxn5GWpiXwq5ig/7js4ykobxH4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gzswG511lzYQtkJ;
	Tue, 14 Jul 2026 16:31:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id AF6384058D;
	Tue, 14 Jul 2026 16:31:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nLl81VqTRS8BA--.57256S4;
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
Subject: [PATCH v4 0/5] iomap: trivial fixes for ext4 conversion
Date: Tue, 14 Jul 2026 16:23:20 +0800
Message-ID: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH1nLl81VqTRS8BA--.57256S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW8Aw45Jr1UGFy8Ww17KFg_yoW8tr18pF
	Z3Ka15Wr4UK34xJ3yfAFW7Jr1Yv3WfXrW8Way3Gwn5AF4YyF18XF4xKa15ur1DCrWrCFyF
	gr1293Z3KFyqyrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi,

This is v4 of the trivial iomap fixes for the ext4 conversion. There are
no code changes relative to v3, the only update is the addition of a
Fixes tag in patch 03.

Changes since v3:
 - Collect RVB tags from Christoph.
 - Add fix tag in patch patch 03 ("iomap: fix incorrect did_zero setting
   in iomap_zero_iter()").
Changes since v2:
 - Collect RVB tags from Darrick and Joanne.
 - Remove CC stable tag in patch 01 as Joanne suggested.
Changes since v1:
 - Add fix tags to patch 01 and 04.
 - In patch 04, change ifs_set_range_uptodate() to always fall through
   to ifs_is_fully_uptodate(), preventing a false-positive uptodate
   mask.
 - Add patch 05, add comments for ifs_clear/set_range_dirty().

v3: https://lore.kernel.org/linux-fsdevel/20260713072906.1726059-1-yi.zhang@huaweicloud.com/
v2: https://lore.kernel.org/linux-fsdevel/20260520030357.679687-1-yi.zhang@huaweicloud.com/
v1: https://lore.kernel.org/linux-fsdevel/20260514062955.1183976-1-yi.zhang@huaweicloud.com/


Original Cover-letter:

This patch series contains a few trivial iomap-related fixes in
preparation for converting ext4 buffered I/O to use iomap. 

The first three patches are taken from my ext4 conversion series [1], as
suggested by Christoph. The fourth patch fixes a bug originally reported
by Sashiko during review of my series; although unrelated to the ext4
conversion, it is worth fixing on its own. Please see the following
patches for detail. The fifth patch add comments for
ifs_clear/set_range_dirty(), and the last patch avoids merging ioends
that have different private data.

Thanks,
Yi.

[1] https://lore.kernel.org/linux-ext4/20260511072344.191271-1-yi.zhang@huaweicloud.com/

Zhang Yi (5):
  iomap: correct the range of a partial dirty clear
  iomap: support invalidating partial folios
  iomap: fix incorrect did_zero setting in iomap_zero_iter()
  iomap: fix out-of-bounds bitmap_set() with zero-length range
  iomap: add comments for ifs_clear/set_range_dirty()

 fs/iomap/buffered-io.c | 58 ++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

-- 
2.52.0

