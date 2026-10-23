Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787488;
	b=JGpg7mMWd+esxCIRaXjLXW/OuhD7/6IhAAWqOjfdcVcEicsmbVccghZZVCTllpNFFZlS
	 DGPcNH7dR7KrsQBlvZs2sKUKPOOUbSgL3y7njBB9hBYUBcBtB16WSkgBLjmnep5hpcHc/
	 +5TOIrfcSRPSxnGUQL0DvUDzQvjpcQcwBZ+8IsmB6Lpc5REL8mcXYQEycrvdS/1kOn2gY
	 m+4HTxZ4Fanranw0MW3KcxJcI3AohWtUoHG0U24IBDscK4CoFf5qlbMoGB6/CD75TvbJy
	 RwWpSpIsau/QC/JgFk9L4SsqJzQ8qhgJolwA4oT1gLZbwnKz/3woBKizl2Kh0cL18RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9cT1VTOlUBOfcryXhCHaLFJ3tus9e0MKJZq0yWA2+ZU=;
	b=tTYPiB02F2VZtdkynDkZx7rdCi5oksL58Re4XL76y/+I8KlhBoadPEhmNSnBpnTJ0VKS
	 Z2uDOVqitMGgpUBXV05e4NuxthREP4vhnOUNxyeKNrnNCClgoOg3BrXjJA5UUo+K5Ct1D
	 9OhVl6MhuSuP9rnckQg0gGzvHRdqHZIsFhesRPcQZn/CsXJQ4HLbtopXTX/cqNmVJyAnQ
	 4hIQ28rUeEJXpa/+kkaA8Qdsbjx51fYbkqmhVH/RwOgAirTDkdYu1lnBbXKGFiX4xIK4E
	 4Oe6nYGbl1G9assnL2XhmZPJUONLBLBK7A14bQUbI5wpy0j4ccDziya6AA4ALxVPahA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5baT8p4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCA1606A31A;
	Fri, 23 Oct 2026 20:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5baT8p4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B4C1F01825;
	Fri, 23 Oct 2026 20:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787487;
	bh=9cT1VTOlUBOfcryXhCHaLFJ3tus9e0MKJZq0yWA2+ZU=;
	h=From:To:Cc:Subject:Date;
	b=i5baT8p4YNUMgp0D0SjcmU0L8bWTgKPbzMkwVbdDbWjxyHNKHW4IpM8ZSLQOi5Z31
	 OBxLtI3ja2rr6YNlfSn1A+83UgV/fHbOSF9+swEGmeqe9V0CaiX/cwpv1IHefUN9Fk
	 uV1GV61N+CDmDYq0p9aRzWZEM4v8TCUTF6TgxGI9YMFQqWXMKgasi5hzhzjJDBJpXi
	 FVOMD4PVZQdpOeGoUo4I4zLVRGcCKuMspsGUpv522GvJLNDZaXuAk4+a4zpamyzIhs
	 yKEsCG/Qg9dcsDOgYS+BBFzEm1+K5A9pYP3Ub/xBdV4vTT2SKi+N+9XWu823RhOkk6
	 DZr2LM2NUt5LQ==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 0/6] Refactor *_fs_sysfs_* helpers
Date: Sat, 24 Oct 2026 04:31:08 +0800
Message-ID: <20261023203114.1655019-1-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As we talked in:
  https://lore.kernel.org/fstests/amhKovVDjwawoWdQ@zlang-mailbox/

This patchset refactors two redundant and messy sets of *_fs_sysfs_* helpers
(PATCH 1/6 2/6), move btrfs specific sysfs policy helpers to common/btrfs
(PATCH 3/6), introduces helpers for /sys/fs/$FSTYP/features (PATCH 4/6),
and replaces the original btrfs-specific helpers with these common ones
(PATCH 6/6).

V2 did below changes:

1) According to review point:
     https://lore.kernel.org/fstests/aqjsBs6QUtIukk05@infradead.org/
   split original patch 1/5 to two patches 1/6 and 2/6.
2) According to review point:
     https://lore.kernel.org/fstests/aqjsZZD4RPVK-uBn@infradead.org/
   rename functions in common/sysfs and move them to common/btrfs.

Thanks,
Zorro

Zorro Lang (6):
  fstests: rename _*_fs_sysfs_attr helpers to _*_fs_sysfs_dev_attr
  fstests: consolidate _require_fs_sysfs and _require_fs_sysfs_dev_attr
  common: move btrfs-only sysfs policy helpers out of common/sysfs
  common/rc: add helpers for /sys/fs/$FSTYP/features/
  common/rc: use common helper in _require_fanotify_ioerrors for f2fs
  fstests: replace btrfs specific helpers with common sysfs helpers

 common/btrfs      | 176 ++++++++++++++++++++++++++++++++++++----------
 common/rc         | 103 ++++++++++++++++++---------
 common/sysfs      | 145 --------------------------------------
 common/xfs        |  22 +++---
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
 tests/btrfs/253   |  29 ++++----
 tests/btrfs/285   |   3 +-
 tests/btrfs/296   |   8 +--
 tests/btrfs/304   |   4 +-
 tests/btrfs/305   |   4 +-
 tests/btrfs/306   |   4 +-
 tests/btrfs/307   |   4 +-
 tests/btrfs/308   |   4 +-
 tests/btrfs/311   |   2 +-
 tests/btrfs/313   |   2 +-
 tests/btrfs/314   |   2 +-
 tests/btrfs/315   |   2 +-
 tests/btrfs/329   |   5 +-
 tests/btrfs/334   |   5 +-
 tests/btrfs/342   |   2 +-
 tests/btrfs/352   |   2 +-
 tests/f2fs/025    |   2 +-
 tests/generic/098 |   2 +-
 tests/generic/101 |   2 +-
 tests/xfs/006     |   4 +-
 tests/xfs/177     |   4 +-
 tests/xfs/264     |  14 ++--
 tests/xfs/668     |   6 +-
 tests/xfs/669     |   6 +-
 tests/xfs/670     |   2 +-
 43 files changed, 293 insertions(+), 307 deletions(-)
 delete mode 100644 common/sysfs

-- 
2.55.0

