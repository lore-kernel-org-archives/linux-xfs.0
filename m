Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB913CD8AE
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776087193; cv=none; b=XM07XboWRicwLbkKCvTjFX6pwHKpJ0bN0DAXZCZ/zvCuhulXPVhhPrCJgKzzXofAnPu9MAP4kii9eAR4aprRQoFGHffmJP2Ck6NAHCu3wDGpIpMhz7TIEX0M1tFrPjaaZfQ/YE0BItsjA5vsu0l6FZtFt7TTP0lMO/N029Dau18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776087193; c=relaxed/simple;
	bh=yj/qfRfmAY9n44hzsqNfwU3Ga8Mwo10LnMHv39MwRoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZKkFKb7hydbXv1PWwRvvAUhMlERJRRn9LAEM2LWmX3SmwTl1SsU/AG9MMh8k3c2y6nkSgAL+ndCPNNxfeVeYDiUiaY3D7LcWhwT4vSXxZOwZlj4H0jCrMRK9yIYSPg3AAkp2bexl7qm1aKRLXwognqoujVN5eIOjJ88gHcZTxzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4fvSyq0QY4z9v4J;
	Mon, 13 Apr 2026 15:33:07 +0200 (CEST)
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	kundan.kumar@samsung.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v2 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
Date: Mon, 13 Apr 2026 15:32:54 +0200
Message-ID: <20260413133256.3378243-1-p.raghav@samsung.com>
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

Note: The previous version of Lukas's patches got mixed with version
numbers. The first patch is v1 while the second patch is v12. I am
sending it as v2 to make it uniform.

@Lukas: I didn't notice any activity from you regarding this series
since last month, so I decided to send it after spending some time on
Dave's feedback. I hope it is ok with you.

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

 fs/xfs/xfs_bmap_util.c | 165 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h |   3 +
 fs/xfs/xfs_file.c      |  56 +++++++++++++-
 fs/xfs/xfs_iomap.c     | 113 +---------------------------
 fs/xfs/xfs_iomap.h     |   1 +
 5 files changed, 227 insertions(+), 111 deletions(-)


base-commit: e0dc9e0f8da83cb70e2a7e9a10fd3541c2bd9a06
-- 
2.51.2

