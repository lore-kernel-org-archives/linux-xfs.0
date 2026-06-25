Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902BC3DD501
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782387975; cv=none; b=NOt1NXSAbaxmSJnc+9D76A3BwfYLyoHXehk9hJcNWl698SrKkVM2gFbeOnKz75QXqoW5G9GjVV4lCwPz1dPU+GCFmFyItskqJzTwmzpA8p8HI/FPd0YWban3Imb6R5sm56rX4rlwO/TxRoO1svzIQ3ZUGHluUk46i4Xf8vTcTJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782387975; c=relaxed/simple;
	bh=MQfBxYYlIx1bVFVU95wv5oj5U1wvVWpB4bFFOArJDyw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iI06mzxvdihHX5p0aK4NNLRkRjcu7/R6hIjTxnTeb683U3yvwyAdGziWRgv1AENiYqMFZRdBHWvd1z6FGMrifCi/AYggioQmA57tHZ9n87FG58ZAnC4B98OCcjXk7s9is0mXK/9Le1OnEgyfoqHH8j5BhmOrNRayFrg70p/hgck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gmH7Z5nHvz9tgY;
	Thu, 25 Jun 2026 13:46:02 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	kundan.kumar@samsung.com,
	hch@lst.de,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v8 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
Date: Thu, 25 Jun 2026 13:45:48 +0200
Message-ID: <20260625114550.4109104-1-p.raghav@samsung.com>
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

I tested the changes with fsstress and fsx based on the xfstests patch I
sent recently to test this flag[4]. generic/363 helped me debug the
crash I noticed when I did the initial implementation[3].

Dave initially suggested to create a common helper based on
xfs_iomap_convert_unwritten() but as it can be seen in the previous
version, a lot of the code had to be rewritten. The changes had more in
common with xfs_alloc_file_space(). This version reuses
xfs_alloc_file_space() for write zeroes.

Thanks to Christoph for all the review comments and design suggestions
that were made both offline and online for this series.

Stress test generic/363 generic/127 xfs/131 are passing. I have started
the full xfstest suite for this series.

I will be sending a new generic test case for testing boundary block
corner case handling.

Changes since v7:
- Pass offset and len to xfs_alloc_file_space (Based on Sashiko's feedback).
- Add a lot of comments to prove correctness based on Zhang's feedback.
- Add Darrick's comment about xfs_alloc_file_space description.

Changes since v6:
- Pass only offset that needs to be zeroed to alloc_file_space (Christoph).
- Add RVB from Christoph.
- Change the call order. Call xfs_falloc_setsize() and then call
  xfs_alloc_file_space().
- Remove the prep patch to allow xfs_set_filesize to take 64-bit len.

Changes since v5:
- Add a prep patch to allow xfs_set_filesize to take 64-bit len
  (Sashiko)

Changes since v4:
- Introduce an enum for allocation mode in xfs_alloc_file_space (Christoph)
- Use xfs_set_filesize instead of updating the on-disk size in the
  function.

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
  xfs: add an allocation mode to xfs_alloc_file_space()
  xfs: add support for FALLOC_FL_WRITE_ZEROES

 fs/xfs/xfs_bmap_util.c | 42 +++++++++++++++++---
 fs/xfs/xfs_bmap_util.h |  7 +++-
 fs/xfs/xfs_file.c      | 87 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 125 insertions(+), 11 deletions(-)


base-commit: 6e24acc45ab58d39a0162b4d5f3fd001d07d868e
-- 
2.51.2

