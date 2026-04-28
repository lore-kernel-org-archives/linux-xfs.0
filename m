Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399934F27F;
	Tue, 28 Apr 2026 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777358593; cv=none; b=aADOr+aX1UcRSmH+CKQDJIZcOrUpff7yEjh4YoHGPRlNerwIkah0Ts1uzwpU5nM6QxGsjZTqvtI+ZF9Yuh83A9C9X/ij3b8zedmxjf7lDiqGTf8EtHuHCrKzFkoNN+ztWX75paXNnE/ZdQc1AeeWZrzC9j3I/Jz4UaSEqj/CGj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777358593; c=relaxed/simple;
	bh=l+qw3Q3ifB9WNPZWwlW2iC7B0OX/qrtWAirYqrCxM4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pDpWtkB0Bd10Hp/PvPD5VEk7vV8/PPyiO/JVZP0/480P4yWwhA9qt5sLeYfoLNav76JllGAIQuOdyaQRq/CJo6ZI3tu5DTw25+StFmRDbzkMiIo+pepb3L3imCkmNClUsGJdxp+JgAUxFspSZM1/MXkRUfwMJhXiI6oMlRfS04s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qKkOPGjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qKkOPGjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC4DC2BCAF;
	Tue, 28 Apr 2026 06:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777358593;
	bh=l+qw3Q3ifB9WNPZWwlW2iC7B0OX/qrtWAirYqrCxM4s=;
	h=From:To:Cc:Subject:Date:From;
	b=qKkOPGjP7fTpt5gV19q7gqMzVZTZumOjDnORWH36oB7qmmjFteRspglA55N5aNren
	 voAbxlTO94+MsCtxA5vcuMY4BcimP/8z71FE1+eK4TaIwdOetyF/FWjOZRncOyBi6z
	 tVZ5pjzZfJKfLZXQ7Rd0DuG9NzooG8EvgEnGo+u6tkZPcXB7UyDRzVHxR5uiAZE0qr
	 JRPU75JYD1g3kU2zuWa5FkdUjo8NmhVu9w9Nf58fFBZpGuUG3Cl0uAPTJ17vCQfynY
	 c8ljiDeHVXxGOhsRB9b0Tq2Ykobj7XJuI9iMkQ8mSpfRkZC3Qg1Fufw9YXXc84VoFY
	 L9X0tZIgqEnbA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v4 0/9] fstests: add test coverage for cloned filesystem ids
Date: Tue, 28 Apr 2026 14:42:50 +0800
Message-ID: <cover.1777357320.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4:
  In _loop_image_create_clone() (Patch 1/9):
    . Added _require_fs_space $TEST_DIR $((size * 1024)).
    . Switched to the _create_file_sized() helper.
    . Used the loop device in mkfs instead of the image file directly.
    . Added a sync on the loop device before copying to ensure consistency.
  For test cases (Patches 3/9 to 9/9):
    . Added _require_block_device $TEST_DEV.
  For test case (Patch 4/9):
    . Removed the ext4 patch reference in _fixed_by_kernel_commit since
      that part of the plan was dropped.

v3:
  https://lore.kernel.org/fstests/cover.1777281778.git.asj@kernel.org

Anand Jain (9):
  fstests: add _loop_image_create_clone() helper
  fstests: add _clone_mount_option() helper
  fstests: add test for inotify isolation on cloned devices
  fstests: verify fanotify isolation on cloned filesystems
  fstests: verify f_fsid for cloned filesystems
  fstests: verify libblkid resolution of duplicate UUIDs
  fstests: verify IMA isolation on cloned filesystems
  fstests: verify exportfs file handles on cloned filesystems
  fstests: btrfs: test UUID consistency for clones with metadata_uuid

 common/config         |   2 +
 common/rc             |  61 +++++++++++++++++++++++
 tests/btrfs/348       |  92 ++++++++++++++++++++++++++++++++++
 tests/btrfs/348.out   |  19 +++++++
 tests/generic/800     |  89 +++++++++++++++++++++++++++++++++
 tests/generic/800.out |   7 +++
 tests/generic/801     | 113 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 tests/generic/802     |  62 +++++++++++++++++++++++
 tests/generic/802.out |   7 +++
 tests/generic/803     |  76 ++++++++++++++++++++++++++++
 tests/generic/803.out |  19 +++++++
 tests/generic/804     | 103 ++++++++++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 ++++
 tests/generic/805     |  73 +++++++++++++++++++++++++++
 tests/generic/805.out |   2 +
 16 files changed, 742 insertions(+)
 create mode 100644 tests/btrfs/348
 create mode 100644 tests/btrfs/348.out
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

-- 
2.43.0

