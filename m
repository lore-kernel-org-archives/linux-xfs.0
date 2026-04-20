Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF3738423D
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682554; cv=none; b=t68cmRpQOvoPdfm9zNQSJWCc9VHkLhBDYJXE0J4C4fI+jPEEP0l36QcWazx1QO/vFLpBXJsN+NP4tJm4wIykjyHJ9wIOiljJK9jpzhXqcY2Oj3Xk7HUTJ2Q6warmlVXm35kVmdYK1qTF9NFbuiqh+oNkUxjt/TQQp/fzLDP2RcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682554; c=relaxed/simple;
	bh=e8xHIPsRY0mAWaggAFC9ySxQ5ZtLdlZZmXw5Bmoay+w=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lOpG7PMnL+bpJextO6I8DolZgM4jzrq1eENS2PHk+DzuheFB1YAlbW5cxrnyx4TCYLLZLMHxFXMKx/7f6qLuVwdIOucLNi86+ZBUPAMv/zYv25mEPk75JDtbgl40St0YBRVX3OZUoqmjwSbTY1SmfHd6tRY8/qCVTV+m639388M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4fzj845bKRz9txK;
	Mon, 20 Apr 2026 12:55:48 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
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
Subject: [PATCH v3 0/3] add FALLOC_FL_WRITE_ZEROES support to xfs
Date: Mon, 20 Apr 2026 12:55:36 +0200
Message-ID: <20260420105539.3644999-1-p.raghav@samsung.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4fzj845bKRz9txK

The benefits of FALLOC_FL_WRITE_ZEROES was already discussed as a part
of Zhang Yi's initial patches[1]. Postgres developer Andres also
mentioned they would like to use this feature in Postgres [2].

This series has the changes proposed by Dave [3].

I tested the changes with fsstress and fsx based on the xfstests patch I
sent recently to test this flag[4]. generic/363 helped me debug the
crash I noticed when I did the initial implementation[3].

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

Lukas Herbolt (1):
  xfs: add a sysfs entry to enable write zeroes even if HW does not
    support it

Pankaj Raghav (2):
  xfs: add xfs_bmap_alloc_or_convert_range function
  xfs: add support for FALLOC_FL_WRITE_ZEROES

 fs/xfs/xfs_bmap_util.c | 165 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h |   3 +
 fs/xfs/xfs_file.c      |  57 +++++++++++++-
 fs/xfs/xfs_iomap.c     | 113 +---------------------------
 fs/xfs/xfs_iomap.h     |   1 +
 fs/xfs/xfs_sysctl.h    |   1 +
 fs/xfs/xfs_sysfs.c     |  25 +++++++
 7 files changed, 254 insertions(+), 111 deletions(-)


base-commit: c43493d3df4aa2a4b39a058f965247dfbd4a708f
-- 
2.51.2

