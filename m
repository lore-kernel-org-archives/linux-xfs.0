Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B60D39FCCD;
	Wed, 17 Jun 2026 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695252; cv=none; b=fpC/cNmS+JtbQWLE1lK5UAqU7oJ5bdEKnq98p7vNE6z77BZZtHhWjRY7EE9/QGuCMDKjhA//01ksQ0SFmN9m8H9mq6rqdU4Tm5gAXSPDo0oCaQ6F1Urj37gyVgxcvcB6/kWph0FxeM7ePNK/LQnQApq9XGfTVAxSBi3S42PXRDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695252; c=relaxed/simple;
	bh=lviHssK6RfHnHTYn0S/J2+9+idEjvPZ9TLOrfO8+yFc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HVmWM5Da4yOI1b5l+/wWesyZjL+B084auUjMUoHTzXGbruocjohcFgtukA+URrRusSPzjswzUGPACesmje12YBNqdydLgN98Wy130UYnbO0zan1TkhAgypZjDcBVxEQTMx9RwOjOoZ9PKg40nGB21ow+QhHCJ0nXAkIpOBdfBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUel3iRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUel3iRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3237B1F000E9;
	Wed, 17 Jun 2026 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695249;
	bh=7Zb3aYz8lZNlAUYkdsGBkMuML/PvX4Qn94h9tk/ibUs=;
	h=From:To:Cc:Subject:Date;
	b=TUel3iRgpz+g6/pSUIKEmsCkC1dorn7sHn/tFQuj8/LbJULYUa/982I3kp3ptdhgY
	 /JXJ3ky35/7RNB85s8VcbF7h+sdybpOfW5FfHWJGMhKrk/15KnQ0ioaN5m6t4Kc4P+
	 kPavcJu4lJYoth+zzDDuMXbgZeYw2LglQnuB4rJL9V0QN3YibzPbiOzH6wGaryNZpl
	 yvJnhcVIScWAAh0blg7YWToySUvBdc9H3Si0o1lt0y7QgF83743MuTO4VLA8fOW4V8
	 8djm9FRw6KDFpwC+WabcPpkvT439Ppy3pD2CN2Mm/OhdMPApfgG5oLMKip+CZ4LYTg
	 HjR7LpfIXWmAg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 0/11] fstests: add test coverage for cloned filesystem ids
Date: Wed, 17 Jun 2026 19:20:27 +0800
Message-ID: <cover.1781694879.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v7:
. 803, 806: Trimmed down the UUID checks to only what is required, mountinfo
   and libblkid.
. 802: Dropped the unnecessary echo statements previously used for logical
   flow in the golden output. On second thought, it looks fine without them.
. Swapped _fixed_by_kernel_commit for _fixed_by_fs_commit.
. _clone_mount_option(): Now echoes directly from the case block itself.
. _require_unique_f_fsid(): add the link to the ref. discussions.

v6:
  https://lore.kernel.org/fstests/cover.1779939330.git.asj@kernel.org

v5:
  https://lore.kernel.org/fstests/cover.1779367627.git.asj@kernel.org

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
   _loop_image_create_clone() and _loop_image_destroy() to help create fs and clone
   _clone_mount_option() helper to apply per-filesystem clone mount options
   _change_metadata_uuid() changes the UUID before the clone

  New tests:
  - fanotify events are isolated between cloned filesystems
  - f_fsid is unique across cloned filesystem instances
  - libblkid correctly resolves duplicate UUIDs to distinct devices
    with and without metadata_uuid
  - IMA distinct identity for each cloned filesystem
  - exportfs file handles resolve correctly on cloned filesystems

Kernel Patches:
  Requires Btrfs kernel patches for all tests to pass.
   [1] https://lore.kernel.org/linux-btrfs/cover.1777281686.git.asj@kernel.org

Anand Jain (11):
  fstests: add _loop_image_create_clone() helper
  fstests: add _clone_mount_option() helper
  fstests: add FSNOTIFYWAIT_PROG
  fstests: add _require_unique_f_fsid() helper
  fstests: verify fanotify isolation on cloned filesystems
  fstests: verify f_fsid for cloned filesystems
  fstests: verify libblkid resolution of duplicate UUIDs
  fstests: verify IMA isolation on cloned filesystems
  fstests: verify exportfs file handles on cloned filesystems
  fstests: add _change_metadata_uuid helper
  fstests: test UUID consistency for clones with metadata_uuid

 common/config         |   1 +
 common/rc             | 120 +++++++++++++++++++++++++++++++++++++
 tests/generic/801     | 135 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 tests/generic/802     |  64 ++++++++++++++++++++
 tests/generic/802.out |   4 ++
 tests/generic/803     |  72 ++++++++++++++++++++++
 tests/generic/803.out |   6 ++
 tests/generic/804     | 108 +++++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 ++++
 tests/generic/805     |  80 +++++++++++++++++++++++++
 tests/generic/805.out |   2 +
 tests/generic/806     |  74 +++++++++++++++++++++++
 tests/generic/806.out |   6 ++
 14 files changed, 689 insertions(+)
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

