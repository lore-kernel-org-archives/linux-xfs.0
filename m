Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818068;
	b=isWJWg/L/cUjXiBZsPqYsGGx05pmbJ16gEPRHP3CZFpzWBrqs1KNGYqxOK8TLDY9K+CF
	 e6qihTw90ttAnvs9EglAOoGhbLrSk558lvPiK0BOn09yA4H3i+aOuOvquWPCaGhoID0/2
	 jL20GurOIKh0JcRCElnrvvb54RrHTp0FCIK5XvZ3El4u3EZziDyONz5GKFuEYLxs1REki
	 8XStH5GI2kcnGwcMbCk/tp9UnyCCP3sZRDhHTe/6sRNVGJ/jxMot1bpWkeB2BgvNttcCD
	 yYSqh+BW92mxWSYbDqJVd3XwvKMjdpGCZeS6RQFwkXRobezVpb/wVB5w5n7sjrvp+UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DtGS0vRMqbkR2qIhIMFsNn2Em9iffczI0GITCsA+yA4=;
	b=Zn+3gsgTy0WPRCQuLz8kKA8a+UYI/KeKlA6LcyZh5gbXkhamu8O+VJ20aNatOvStfStI
	 TYAnuEbhE9GAnZpFmQD3RKrliJG2z5dxMCVTf0ZhZhcWxn6cdGSxWijT3n7+llMQD12nd
	 eNAodf5rzx+aqBSN06F/D2T+Vt+Ol7Q68w4rMUZW35xfGKR5Rp82K6nYI1z01ZUHwBWbY
	 GcXJAWGw7IfN0Bm5qNZ6fO4WrFOLWQ42D3Dx+JZCh2rd/7Maw2BW4qRePNJ0pKL3qS8kY
	 WQ9pg/8h4SWiSq41Hmyc6md62+PJ3WuRXZ+3TZux11h0EoUTM+XbIeZxvVvs9s5L9jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKwgfDQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7AE606A31B;
	Wed,  4 Nov 2026 18:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKwgfDQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70D61F000C1;
	Wed,  4 Nov 2026 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793818068;
	bh=DtGS0vRMqbkR2qIhIMFsNn2Em9iffczI0GITCsA+yA4=;
	h=From:To:Cc:Subject:Date;
	b=JKwgfDQwsMS6KGOlyV6kgkK8PuL9pcEY9I6pNQRZrg9V6xL4XKfTmxBRPvBrzdFzA
	 RpNCjyz0DT/0b+Er0bji0QV/9s5wS6eADVHodHWMxkC4MnEgH+LC70vvu0ZMnuWCFp
	 Qlfma9a5NfklR2gj/wn8h9q6sDXnDxgQigMLwcPSN6E+tu8e/yBHNeAAyWVnYeKsSk
	 s2Sr9eCWNYR0vFH+UQQoFUCIdWsEc638UCPSNnuh0IRbAbNNLzugjM5G4V06loqqOp
	 Lz0m6BHWCPhpxjoWsGxA3yBb+dgJln/tCqnTbRNqRLvluUrw5a2HOoS7ZHUsQmDeSc
	 f0suYEkq8F8WA==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 0/6] Refactor *_fs_sysfs_* helpers
Date: Thu,  5 Nov 2026 02:47:30 +0800
Message-ID: <20261104184736.1564283-1-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
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

V3 did below changes:
1) Address Christoph's review points on [PATCH 2/6] by introducing
   _require_{test,scratch}_sysfs_dev_attr and wrapping lines that were too
   long (Waiting for RVB).
2) Since an upcoming test case (btrfs/363) is also affected by [PATCH 6/6],
   I have rebased patch 6/6 and the entire patchset onto the latest
   patches-in-queue branch.

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
 common/rc         | 109 +++++++++++++++++++++-------
 common/sysfs      | 145 --------------------------------------
 common/xfs        |  24 ++++---
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
 tests/btrfs/363   |   2 +-
 tests/f2fs/025    |   2 +-
 tests/generic/098 |   2 +-
 tests/generic/101 |   2 +-
 tests/xfs/006     |   4 +-
 tests/xfs/177     |   4 +-
 tests/xfs/264     |  14 ++--
 tests/xfs/668     |   6 +-
 tests/xfs/669     |   6 +-
 tests/xfs/670     |   2 +-
 44 files changed, 307 insertions(+), 303 deletions(-)
 delete mode 100644 common/sysfs

-- 
2.56.0

