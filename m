Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A246D3A0E92
	for <linux-xfs@vger.kernel.org>; Fri,  1 May 2026 11:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634445; cv=none; b=rMa13bTlRXG0HtNbeQ9faAFO3LXCPV4qkWnG4dgbEuq2h3bmz0vutMXj8zM1kPfcBfy7ZIOZE+nO2hfYkuXy9g+lxCR49Go9O32DVKzsXjqp3DDN6cOTaIPeFtoumNNo8xfD9xWcPC/O7gfWtoReQfJvkyh2P/kTUBxwkPO7wKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634445; c=relaxed/simple;
	bh=ZzHXJ4X7iMH9i2aegzD+c2AmtefxIEdZj8iE79chdcw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MgbzJs9Aqr8/4AnswTTmBdCWrdaGEXREMeoBqcEY0k/ZQdAF7YXmzhQ9o3d2DJPuo8dlnXnssK5ggsltYp7q5efPpyP9idTfE9PpX5tsDtcC4dEDJ1QpLlcorxuu7KK5rqypiW29iyVS5yTx0CPwxUyiKnFFQXO1cntqMbUtEiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4g6T9f1Crnz9tPB;
	Fri,  1 May 2026 13:20:38 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	kundan.kumar@samsung.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v4 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
Date: Fri,  1 May 2026 13:20:24 +0200
Message-ID: <20260501112026.673609-1-p.raghav@samsung.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The benefits of FALLOC_FL_WRITE_ZEROES was already discussed as a part
of Zhang Yi's initial patches[1]. Postgres developer Andres also
mentioned they would like to use this feature in Postgres [2].

This series has the changes proposed by Dave [3].

I tested the changes with fsstress and fsx based on the xfstests patch I
sent recently to test this flag[4]. generic/363 helped me debug the
crash I noticed when I did the initial implementation[3].

Changes since v3:
- Introduce xfs_bmap_alloc_or_convert_range() in xfs_iomap.c for easy
  review experience (christoph)
- Add extsz hint and rt support in xfs_bmap_alloc_or_convert_range()

Changes since v2:
- Add allow_write_zeroes to xfs_global so that we can enable this
  feature independent of the HW underneath.

Changes since v1 [5.1 5.2]:
- Added a new function xfs_bmap_alloc_or_convert_range() based on Dave's
  feedback.
- Changed the xfs_falloc_write_zeroes to use
  xfs_bmap_alloc_or_convert_range() instead of doing prealloc and
  convert approach.

[1] https://lore.kernel.org/linux-fsdevel/20250619111806.3546162-1-yi.zhang@huaweicloud.com/
[2] https://lore.kernel.org/linux-fsdevel/20260217055103.GA6174@lst.de/T/#m7935b9bab32bb5ff372507f84803b8753ad1c814
[3] https://lore.kernel.org/linux-xfs/6i2jvzn3lyugjlbgmjzpped3gogzyqv5mpe2uqaifz4vjpaega@pomzoq7ley77/
[4] https://lore.kernel.org/linux-xfs/20260312195308.738189-1-p.raghav@samsung.com/
[5.1] https://lore.kernel.org/linux-xfs/20260309180708.427553-2-lukas@herbolt.com/
[5.2] https://lore.kernel.org/linux-xfs/abC1LvRElctaHPe5@dread/

Pankaj Raghav (2):
  xfs: add xfs_bmap_alloc_or_convert_range function
  xfs: add support for FALLOC_FL_WRITE_ZEROES

 fs/xfs/xfs_file.c  |  56 +++++++++++-
 fs/xfs/xfs_iomap.c | 215 ++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_iomap.h |   2 +
 3 files changed, 210 insertions(+), 63 deletions(-)


base-commit: ad345c96913e1a5b507cea4e49d22e91d5947f56
-- 
2.51.2

