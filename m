Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A9A303A37;
	Tue,  6 Oct 2026 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276976; cv=none; b=YoiETY7vh9CyJ6Bjr2aMCv4XC3Ts8x7a0GD2OF0z5UfYW95xr7T2x8f8eEF+Ab5bJyCnpQigHl1pBrI3CrJO1pjSqCW3liun7K1qJmBcpZikO6l2L6OiY1P2ehSNd94XHv6Ef2WpboZdtsLOSI/QMMaVrEmJuqbblto/IFPiNM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276976; c=relaxed/simple;
	bh=itcVxzZvDRSl1iKWLBo+35u2tM2XCFh4QMiTclT7kQM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qFsg4WWkQisKy0T6HeBvQYOms2AMsk8h7Sz85aHOtGzqvvGppb/H4KOXd13TH33SYJSAuJWp2oG04AZV3NbCKMbpyCJlBwuVPk+KW5BlTCTBbzMpWafsYwC/BtbOG4eBh80MC+Mu43+IJGsAMzIkcXipUuQpIhuShs67X20c8Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUmk/2Ze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUmk/2Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEB81F00893;
	Tue,  6 Oct 2026 08:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276974;
	bh=887Qidn2IRSbVRJeH3AxCvsj1VaDhX8Vn5amfqTDK7Q=;
	h=From:To:Cc:Subject:Date;
	b=LUmk/2Zee1xt1ArSwUTbOuXhvYztZbP0+ykOMresbfu7ihWnjGspvwQQg2Ks9dN2I
	 BJUlumreKETHpypw8uGQre65AkoBrNfPf4FuOrK0RCA2XdS7oeb39QIoxvbykEpjQk
	 x1fq3bXJ1P0LGlcPNyJ4HaY3BwdBkekA2r3UgWdgCFr1DJqCwlDALH6WBmgwFlNTT1
	 hlGSugz/GnTJzF0K3dk1I9dwXZYkzMfZ6x6ksoRwLRrH7S1Vlo91i0S1dm9HIZoJog
	 gZS09tJHTSROJ80rJPwFoLD5r5pzD428LXO5pV6YJvDTZtSrtYspZPie+8NXV91wx4
	 bc0bxfSbvQP/g==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 0/21] fstests: tests for cloned filesystem validation and f_fsid
Date: Tue,  6 Oct 2026 16:55:26 +0800
Message-ID: <cover.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series continues the work from the earlier "test coverage for cloned
filesystem ids" series (last posted as v8 [1]) and has been tested against
the major filesystems: Btrfs, XFS, ext4, and f2fs.

Although this version incorporates the review feedback received on v8, it
expands substantially with additional infrastructure helpers, an extra test
case to cover the recent regression report, and migration/cleanup of
existing generic/744. Because the patch count grew from 13 to 21 patches,
disrupting the previous patch numbering and scope, I have reset the
versioning and updated the subject line to better reflect the broader
validation coverage.

The core motivation remains identical: testing that mounting a block-level
cloned filesystem concurrently with the original filesystem behaves
correctly across filesystems and VFS subsystems (fanotify, statfs/f_fsid,
libblkid resolution, IMA measurement, exportfs file handles, and
metadata_uuid handling).

Summary of major changes since v8:
- Added 1 new regression test case to verify statfs f_fsid derivation against FS UUID.
- Dropped the test case verifying f_fsid persistence across mount cycles on
  cloned filesystems, as this assumption is no longer valid following the Btrfs kernel
  regression fix [2].
- Introduced common helpers:
  . _require_security_ima() and _require_metadata_uuid().
  . _scratch_mkfs_uuid() and helpers for f_fsid verification.
- Migrated generic/744 to utilize the new common clone helpers.
- Worked on the review comments.

Details of changes:
- _create_cloned_loop_devs():
  . Renamed from _loop_image_create_clone() to _create_cloned_loop_devs().
  . Relocated backing image files from "$TEST_DIR/${seq}.*" to a dedicated
    directory "$TEST_DIR/${seq}/*".
  . Added internal call to _require_clone_mount().
  . Switched from _create_loop_device() to _create_loop_device_like_bdev()
    to guarantee identical logical/physical sector sizes (512 vs 4096)
    between the original and cloned loop devices.
  . Used an intermediate local setup step to ensure consistent Direct I/O
    attributes across both loop devices (preventing the first device from
    enabling DIO while the cloned device fell back to buffered mode).
  . Added device geometry and DIO attribute dump to $seqres.full for debugging.
  . Renamed teardown helper _loop_image_destroy() to _destroy_cloned_loop_devs().
- _clone_mount_options():
  . Renamed from _clone_mount_option() to _clone_mount_options().
- _require_metadata_uuid():
  . Factored out prerequisite checks from _change_metadata_uuid() into a new
    dedicated helper _require_metadata_uuid() and invoked it accordingly.
- _require_clone_mount():
  . Introduced new helper to check kernel support for concurrent clone mounts.
  . Removed obsolete _require_duplicate_fsid() in favor of _require_clone_mount().
- _require_security_ima():
  . Introduced new helper to check securityfs and IMA policy availability.
- _create_loop_device_like_bdev():
  . Removed unused local variable 'dev'.

- Test Cases common update:
  - Adjusted test groups: replaced 'clone' with 'tempfsid'.
  - Standardized test exits: replaced open-coded "status=0; exit" with "_exit 0".
  - Dropped stale "_require_block_device $TEST_DEV" checks left over from before
    migrating tests to loop devices.
  - Percolated helper renames across all tests:
    . _loop_image_create_clone -> _create_cloned_loop_devs
    . _loop_image_destroy      -> _destroy_cloned_loop_devs
    . _clone_mount_option      -> _clone_mount_options
  - Added cleanup of "$TEST_DIR/$seq" in test exit/cleanup handlers.

- Test Cases Individual Updates:
  - generic/744:
    . Replaced _require_duplicate_fsid with _require_clone_mount().
    . Migrated to common _create_cloned_loop_devs() and _clone_mount_options().
  - generic/902:
    . New regression test case added to verify statfs f_fsid derivation against filesystem UUID.
  - generic/903:
    . Added --noheadings flag to findmnt queries for cleaner output parsing.
  - generic/904:
    . Dropped 'auto' and 'quick' from test groups due to runtime and policy requirements.
    . Updated referenced kernel commit IDs.

[1] https://lore.kernel.org/fstests/cover.1784949154.git.asj@kernel.org
[2] 72de4807ba84 ("btrfs: derive f_fsid with dev_t only when temp_fsid is active")

Anand Jain (21):
  fstests: introduce _require_clone_mount() helper
  fstests: introduce _create_cloned_loop_devs() helper
  fstests: add _clone_mount_options() helper
  fstests: add FSNOTIFYWAIT_PROG
  fstests: add _require_fanotify_function
  fstests: add _require_unique_f_fsid() helper
  fstests: add SEMANAGE_PROG
  fstests: verify fanotify isolation on cloned filesystems
  fstests: introduce helper _scratch_mkfs_uuid()
  fstests: add helpers to verify the expected f_fsid
  fstests: verify statfs f_fsid is derived from the filesystem UUID
  fstests: verify libblkid resolution of duplicate UUIDs
  fstests: introduce _require_security_ima() helper
  fstests: verify IMA isolation on cloned filesystems
  fstests: verify exportfs file handles on cloned filesystems
  fstests: introduce _require_metadata_uuid() helper
  fstests: add _change_metadata_uuid helper
  fstests: test UUID consistency for clones with metadata_uuid
  fstests: generic/744: use new helper _require_clone_mount()
  fstests: generic/744: migrate to _create_cloned_loop_devs()
  fstests: _create_loop_device_like_bdev() remove unused variable

 common/config         |   2 +
 common/rc             | 262 +++++++++++++++++++++++++++++++++++++++---
 tests/generic/744     |  72 +++++-------
 tests/generic/901     | 142 +++++++++++++++++++++++
 tests/generic/901.out |   7 ++
 tests/generic/902     |  38 ++++++
 tests/generic/902.out |   2 +
 tests/generic/903     |  71 ++++++++++++
 tests/generic/903.out |   6 +
 tests/generic/904     | 113 ++++++++++++++++++
 tests/generic/904.out |  10 ++
 tests/generic/905     |  79 +++++++++++++
 tests/generic/905.out |   2 +
 tests/generic/906     |  74 ++++++++++++
 tests/generic/906.out |   6 +
 15 files changed, 827 insertions(+), 59 deletions(-)
 create mode 100644 tests/generic/901
 create mode 100644 tests/generic/901.out
 create mode 100644 tests/generic/902
 create mode 100644 tests/generic/902.out
 create mode 100644 tests/generic/903
 create mode 100644 tests/generic/903.out
 create mode 100644 tests/generic/904
 create mode 100644 tests/generic/904.out
 create mode 100644 tests/generic/905
 create mode 100644 tests/generic/905.out
 create mode 100644 tests/generic/906
 create mode 100644 tests/generic/906.out

-- 
2.43.0

