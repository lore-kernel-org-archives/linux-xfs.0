Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D46D3126B9;
	Sat, 25 Jul 2026 07:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965166; cv=none; b=pbPBWX1Ad9IEPa9KRRnOqRsRlemzk0M8xwwwQipcdrHPbaTmBJsQob9vzSWxHjo0W8abv0+kjSCHJUm3z7VD4BmYKyxxeVFOAYYlkHaiylYfGH4Z9ESj3Ok8sttMNpEwYySYUY8C6l+EgWfZuCVGgpQBM1zaBCtnZ9Nf9C/Ehh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965166; c=relaxed/simple;
	bh=OzSpj0XbVUSI2dyTTqGSMof1EdYSfQ7TWX8mN7MUVfY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XykXnbXOtBULm4iHnRdpS5tkd4RKVUPvnl87tuVywmEnd/qGHjao3NiWqrk9aB0FNISjTHxe5XVwwmL7v+mi+Y8XOj71rwP1fjlp7fNZQZhMJ8ssgU5g20qC8mONypxmfP7GZkhKPGnS4vU0d8E12HoKip0pTvSwqqj2ZUjANEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oa1KqavF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oa1KqavF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C83A1F000E9;
	Sat, 25 Jul 2026 07:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965164;
	bh=pj4RwUtaZyoGJA47a1bTHKUI+emrjLDYeojFHrfftF4=;
	h=From:To:Cc:Subject:Date;
	b=oa1KqavFff3v/BrMasPTc1neKvEvW28DoJj+4CJSHZpc12JSrLcckfFtJKzfkTwT6
	 tlXsw2yN4XROkcVYzGg+mzJKuDFn3YdYB6iL0vqM8C4Mg0HoCwfZdTYZPGp2/O1R47
	 uUJPwnI+RdW26Ms5NSuOVVd5EwogP0MCyuq0ayKODYw9UyznkWrmVdWjNrwh12wAtI
	 ZIO00cDK5iU9FRKHlFFtCVyrw7NkQTKH+aGarQ2I6F7yu6eMM0AysPuVPOLLFcCTUQ
	 MKQgtohhkjdFc66pU0b5g343LjCtvuYrFlKLMXuziuNDupD8y58gTkhtv3Oo50N58j
	 pmrpVZvw5UyNA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 0/13] fstests: add test coverage for cloned filesystem ids
Date: Sat, 25 Jul 2026 15:38:57 +0800
Message-ID: <cover.1784949154.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v8:
- _require_fs_space: double the required space (x2) to account for both source and clone
- Use proper quoting/unquoting for _mkfs_dev (Thanks Darrick)
- Call _fail() if cp fails
- _require_fanotify_function: check for kernel fsnotify support
- _require_unique_f_fsid: reorganize comments and replace 'if' with 'case' statement (Thanks Darrick)
- Add SEMANAGE_PROG variable (Thanks Darrick)
- fanotify verification: add checks for SEMANAGE_PROG and _require_fanotify_function
- Verify that the monitoring process is actually created

v7:
  https://lore.kernel.org/fstests/cover.1781694879.git.asj@kernel.org

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
   _require_fanotify_function check if kernel supports fs notification
   _require_unique_f_fsid() helper to handle fs difference in fsid implementation

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


Anand Jain (13):
  fstests: add _loop_image_create_clone() helper
  fstests: add _clone_mount_option() helper
  fstests: add FSNOTIFYWAIT_PROG
  fstests: add _require_fanotify_function
  fstests: add _require_unique_f_fsid() helper
  fstests: add SEMANAGE_PROG
  fstests: verify fanotify isolation on cloned filesystems
  fstests: verify f_fsid for cloned filesystems
  fstests: verify libblkid resolution of duplicate UUIDs
  fstests: verify IMA isolation on cloned filesystems
  fstests: verify exportfs file handles on cloned filesystems
  fstests: add _change_metadata_uuid helper
  fstests: test UUID consistency for clones with metadata_uuid

 common/config         |   2 +
 common/rc             | 135 +++++++++++++++++++++++++++++++++++++++
 tests/generic/801     | 143 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 tests/generic/802     |  64 +++++++++++++++++++
 tests/generic/802.out |   4 ++
 tests/generic/803     |  72 +++++++++++++++++++++
 tests/generic/803.out |   6 ++
 tests/generic/804     | 108 +++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 +++
 tests/generic/805     |  80 +++++++++++++++++++++++
 tests/generic/805.out |   2 +
 tests/generic/806     |  74 ++++++++++++++++++++++
 tests/generic/806.out |   6 ++
 14 files changed, 713 insertions(+)
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

