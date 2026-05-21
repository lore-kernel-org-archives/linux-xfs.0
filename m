Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C4325B095;
	Thu, 21 May 2026 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368419; cv=none; b=pmtudY3xlIwg3o7C7WruogQjaQDVf65ZXtHs9Ddi+gb/fv7kkwTXi0/qgymbYdb1/bzGFcbPTmQBcULeqEIPoc09j7csDJpHdWChqEC1vMKGeoo43oECgvslZAFwZIZGNSQBn6kSvlxH6hNVIlAO/pVhUp+AmbtinUTjaXHvHvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368419; c=relaxed/simple;
	bh=idos7dKTS7lHhDXf49lbeC5f8DGS7EjSExem0TP69sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pQgdq4P25SJPwNOaoJYu+WftYVpIrpPh7nahNmvSUlLhNBv291cuC1OS1jO9a2h7pEoz2pz1tJRbUduj7JIEcUVoNXHr+PlPiPiRcgoVmSzpbCKyLxxnSs1NPqO1sVeTPvwzqZDWRxe4FxtoLCCOa2r1blDCBMPxRx+u9/CE/M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8QkDJTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8QkDJTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739581F000E9;
	Thu, 21 May 2026 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368418;
	bh=kw2UZRDIEaKvsqt9NlP7FIGKTM4BOEgXuuS0tV1nQmM=;
	h=From:To:Cc:Subject:Date;
	b=R8QkDJTZgTuI0rXgEEopzY3USVPfa0milAZBrl5l0ey9XNfwMTcBJ/sg10x9xujzW
	 FIql9C4OwgIxy4pE2E4gxEWvTmzoFmCZ+hVTuYnYtQZUrfq/ZW9hOoMo0baGFQ7/pa
	 cGHD1V2kDN4NfYS+6uHBOhdBW3dBJRXx7lSHZ+afLD4XN/fHv2smiTJ2mLGwDeV6h8
	 W6hN6ELz2qneOp/9Ewjj8BEquFr8AjcdLBf3tEvDMpDCbLZrXK938Vp77L64ENLXHS
	 tfpKXxdQXBkqTj+PUsWoc/MaNTQIrSKiP1BF2bFI3lOqiAltnJU5xukQ10bnKi/zQb
	 WLCMHPwAk3NZA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 0/10] fstests: add test coverage for cloned filesystem ids
Date: Thu, 21 May 2026 20:54:50 +0800
Message-ID: <cover.1779367627.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v5:
  XFS supports metadata_uuid, I converted patch 10/10 to a generic
   test. To do this, I moved the in-test helper to common/rc as
   `pre_clone_tune_uuid()`.

  I also verified fanotifywait with SELinux in enforcing mode and
    fixed patch 4/10.

v4:
  https://lore.kernel.org/fstests/cover.1777357320.git.asj@kernel.org

v3:
  https://lore.kernel.org/fstests/cover.1777281778.git.asj@kernel.org

v2:
  https://lore.kernel.org/fstests/cover.1774090817.git.asj@kernel.org

v1:
  https://lore.kernel.org/fstests/cover.1772095513.git.asj@kernel.org

This series adds fstests infrastructure and test cases to verify correct
filesystem identity when a filesystem is cloned (block-level copy).
Test covers inotify, fanotify, f_fsid, libblkid, IMA, exportfs file handles
and libblkid tools verify with metadata_uuid.
  New helpers:
  - _mkfs_scratch_sized_clone() helper to create a cloned filesystem
  - _clone_mount_option() helper to apply per-filesystem clone mount options
  - pre_clone_tune_uuid() changes the UUID before the clone

  New tests:
  - inotify and fanotify events are isolated between cloned filesystems
  - f_fsid is unique across cloned filesystem instances
  - libblkid correctly resolves duplicate UUIDs to distinct devices
    with and without metadata_uuid
  - IMA distinct identity for each cloned filesystem
  - exportfs file handles resolve correctly on cloned filesystems

Kernel Patches:
  Requires Btrfs kernel patches for all tests to pass.
   [1] https://lore.kernel.org/linux-btrfs/cover.1777281686.git.asj@kernel.org

Anand Jain (10):
  fstests: add _loop_image_create_clone() helper
  fstests: add _clone_mount_option() helper
  fstests: add test for inotify isolation on cloned devices
  fstests: verify fanotify isolation on cloned filesystems
  fstests: verify f_fsid for cloned filesystems
  fstests: verify libblkid resolution of duplicate UUIDs
  fstests: verify IMA isolation on cloned filesystems
  fstests: verify exportfs file handles on cloned filesystems
  fstests: add pre_clone_tune_uuid() healper
  fstests: test UUID consistency for clones with metadata_uuid

 common/config         |   2 +
 common/rc             |  84 ++++++++++++++++++++++++++++
 tests/generic/800     |  89 ++++++++++++++++++++++++++++++
 tests/generic/800.out |   7 +++
 tests/generic/801     | 125 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 tests/generic/802     |  62 +++++++++++++++++++++
 tests/generic/802.out |   7 +++
 tests/generic/803     |  76 +++++++++++++++++++++++++
 tests/generic/803.out |  19 +++++++
 tests/generic/804     | 103 ++++++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 ++++
 tests/generic/805     |  73 ++++++++++++++++++++++++
 tests/generic/805.out |   2 +
 tests/generic/806     |  78 ++++++++++++++++++++++++++
 tests/generic/806.out |  19 +++++++
 16 files changed, 763 insertions(+)
 create mode 100644 tests/generic/800
 create mode 100644 tests/generic/800.out
 create mode 100644 tests/generic/801
 create mode 100644 tests/generic/801.out
 create mode 100644 tests/generic/802
 create mode 100644 tests/generic/802.out
 create mode 100644 tests/generic/803
 create mode 100644 tests/generic/803.out
 create mode 100644 tests/generic/804
 create mode 100644 tests/generic/804.out
 create mode 100644 tests/generic/805
 create mode 100644 tests/generic/805.out
 create mode 100644 tests/generic/806
 create mode 100644 tests/generic/806.out

-- 
2.43.0

