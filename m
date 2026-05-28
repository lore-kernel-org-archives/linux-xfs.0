Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233AEDF76;
	Thu, 28 May 2026 04:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941172; cv=none; b=ZUN5azbhKF7j86ZNiH12mmtQ6YSdenuMyfdlB6wXo6R8DjOKEGGmz8q9o4W9oGTRgXJXZ/RJYTUZ1SO1UCkPWJC0HBFedu4YhkpTisoDrjaTO5ZuKPjF3iD5kvQlaFSQfpp/IyFgfoaFz5b0gM2w1LtIJR2/xrWimZgpwPSz52c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941172; c=relaxed/simple;
	bh=IbVgOL69DQHxLm/ghzCUFjucKE2K70KrxDX85lVkxFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jfPQYdEuV1LfESY12ZUoLcO/FSkI2GSYsf0UFSs33KTSiJ4U+7iE8+sw/NDwcgInTas+u7AmyxkDeBSXmx/NXEYl5DeNXE5N31sqQN8JUoN0xpkqrxKI1SjMWinoOzljlSM+YbrzSyUd0/N9VCqIPETpG+YxyH6HM6hZ0U0kSBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ia9YxbI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ia9YxbI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013811F000E9;
	Thu, 28 May 2026 04:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941170;
	bh=CLUkiSIdhVjbGrdOUK5E/DEBmrwO/TzftuAwtmRq+Yk=;
	h=From:To:Cc:Subject:Date;
	b=ia9YxbI7iMZjO5I5NO8FW6Lsli1Unc6TEnlzXazf2uvMqs+5p1shgniqqT0eRkRik
	 4TErZyek9i+fQUsZJB7PSttB2rNHF6+j86YSp/U6yu6rL1LT9m5MAZzwtqubGl2kkH
	 L/CqVfQvpyR1LW7dmxK4CEad/ES1s0Syg7AwFmmpuUcgGQtKGNYlJX4U6SlfJLncFH
	 Eow44MPvrNbVEJSMFuaLm7jDXJEIamwiwgv/KWzSlpf3/mjrqACYZ81bezdT3zRgbs
	 0l19cnlwnf/qRC/4XKJXG05qW63gLMDN8mQq7dIIcd228CDGigcdAk8fEBVFmP+NGA
	 Cfw7v/wpgJypw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 0/11] fstests: add test coverage for cloned filesystem ids
Date: Thu, 28 May 2026 12:05:31 +0800
Message-ID: <cover.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v6:
. Renamed `pre_clone_tune_uuid()` to `_change_metadata_uuid()`.
. Created the `_require_unique_f_fsid()` helper instead of handling it inside the test case (patch 5/11).
. Separated `FSNOTIFYWAIT_PROG` into its own patch.
. Dropped the `inotify` test case in favor of `fsnotify`.
. Added comments throughout, especially for helper functions.

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
 common/rc             | 124 ++++++++++++++++++++++++++++++++++++++
 tests/generic/801     | 135 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 tests/generic/802     |  67 +++++++++++++++++++++
 tests/generic/802.out |   7 +++
 tests/generic/803     |  84 ++++++++++++++++++++++++++
 tests/generic/803.out |  19 ++++++
 tests/generic/804     | 108 +++++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 ++++
 tests/generic/805     |  80 +++++++++++++++++++++++++
 tests/generic/805.out |   2 +
 tests/generic/806     |  84 ++++++++++++++++++++++++++
 tests/generic/806.out |  19 ++++++
 14 files changed, 747 insertions(+)
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

