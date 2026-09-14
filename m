Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F076B489FA4;
	Mon, 14 Sep 2026 17:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406726; cv=none; b=X99NNgpP3LvkUfUsouZI/sn9vKU1mczjtmYGMtteM09GM8dcBkltrTOwz33mNsrv8t8SfKFvPPfWTyao0fNeDF52Z/2XEc/LW/OnjbkH06dj8ejrvjQrG0kdinEIyukh7Y7ZnkQhQ1iNSojvPdyHwn8C3c5MeMxH4VJQ9qQjuh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406726; c=relaxed/simple;
	bh=yEWavbDR54J7O38WRPJJjQYsphw9f1Z5wC76+14JCic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qUpNzDQehm/E49TTZi9RHZ3aCcJZm8gCO6zw3m7WsNBsalYOWBCv7Ipr5EGeazktdymf59tuDb95UJ1xgej/3YkFUK6Yh0UG0dZQHf3Tb38wkT0sdhBPPdROXODO+czT2zPWGxTkqI2coy80MabgBJU6NaH4Yh6ZiNdwU+noxYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqL5ttEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqL5ttEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC50E1F000FF;
	Mon, 14 Sep 2026 17:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789406724;
	bh=ivTCssQ80Q5rXGcqqme9BCrgHmJUgofDp4I5tlkj8iw=;
	h=From:To:Cc:Subject:Date;
	b=mqL5ttErVCBhu3/itcbjExCEntGnVsT+dDmyAebTMDZGbp4otbJwJCnqq+xadI6ia
	 9ZZKGbCGMxPOOIl+RB/K6BMTd3pz26l4IYG3lc3fOy0Rsk3ajmZIghcKOUnRTv2ioO
	 AcxaUI5Z6Fl4F+px3iYteMGgSlTtKakK5qO3rD6QIqAc4RFvULtKknIyhoksCyqIOs
	 8OXiyOg7IvOMcR/2B/qS9fH/kbjfa2CPoZwVPNU5b4mJc/jX0JYn9oMLlBgUnI6maJ
	 5pt8rS8L+eR2mS3h0NML6jWzZKPV7zqHMvuTwbiA3rZCbrzGOuwhuSKzd9QbvS5Irb
	 C6TsTH5BFhNMg==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 0/5] Refactor *_fs_sysfs_* helpers
Date: Tue, 15 Sep 2026 01:25:04 +0800
Message-ID: <20260914172509.3799016-1-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As we talked in:
  https://lore.kernel.org/fstests/amhKovVDjwawoWdQ@zlang-mailbox/

This patchset refactors two redundant and messy sets of *_fs_sysfs_* helpers
(PATCH 1/5 2/5), introduces helpers for /sys/fs/$FSTYP/features (PATCH 3/5 4/5),
and replaces the original btrfs-specific helpers with these common ones
(PATCH 5/5).

Thanks,
Zorro

Zorro Lang (5):
  fstests: consolidate _require_fs_sysfs and _require_fs_sysfs_attr
  common/sysfs: adjust function naming
  common/rc: add helpers for /sys/fs/$FSTYP/features/
  common/rc: use common helper in _require_fanotify_ioerrors for f2fs
  fstests: replace btrfs specific helpers with common sysfs helpers

 common/btrfs      |  41 ++----------------
 common/rc         | 103 ++++++++++++++++++++++++++++++++--------------
 common/sysfs      |  72 ++++++++++++++++----------------
 common/xfs        |  22 +++++-----
 tests/btrfs/010   |   3 +-
 tests/btrfs/055   |   2 +-
 tests/btrfs/056   |   2 +-
 tests/btrfs/112   |   2 +-
 tests/btrfs/131   |   2 +-
 tests/btrfs/165   |   2 +-
 tests/btrfs/188   |   2 +-
 tests/btrfs/192   |   2 +-
 tests/btrfs/201   |   2 +-
 tests/btrfs/205   |   2 +-
 tests/btrfs/209   |   2 +-
 tests/btrfs/211   |   2 +-
 tests/btrfs/219   |   3 +-
 tests/btrfs/231   |   2 +-
 tests/btrfs/253   |  28 ++++++-------
 tests/btrfs/285   |   3 +-
 tests/btrfs/296   |   8 +---
 tests/btrfs/304   |   4 +-
 tests/btrfs/305   |   4 +-
 tests/btrfs/306   |   4 +-
 tests/btrfs/307   |   4 +-
 tests/btrfs/308   |   4 +-
 tests/btrfs/311   |   2 +-
 tests/btrfs/313   |   2 +-
 tests/btrfs/314   |   2 +-
 tests/btrfs/315   |   2 +-
 tests/btrfs/329   |   4 +-
 tests/btrfs/334   |   4 +-
 tests/btrfs/342   |   2 +-
 tests/btrfs/352   |   2 +-
 tests/f2fs/025    |   2 +-
 tests/generic/098 |   2 +-
 tests/generic/101 |   2 +-
 tests/xfs/006     |   4 +-
 tests/xfs/177     |   4 +-
 tests/xfs/264     |  14 +++----
 tests/xfs/668     |   6 +--
 tests/xfs/669     |   6 +--
 tests/xfs/670     |   2 +-
 43 files changed, 194 insertions(+), 195 deletions(-)

-- 
2.55.0

