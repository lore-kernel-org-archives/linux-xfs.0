Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7986938B15D;
	Sat, 21 Mar 2026 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094319; cv=none; b=RhwURBoFuyZqr9rxB10DZnasz8aKBeWrbr7FPpKa6yb7kxXpwzl/8uJDjAjZPtxTzNany+dcpT40G5HuGqk2VHu9/IfUGW5FBHpJLdWQTNQN8GTQQxV7cimlsotKInwrJYCeGA9fRGnulyJwmbpnbIjEc9dvVvgbWkHKRSJS/JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094319; c=relaxed/simple;
	bh=u45BPGTz+pSWYCpXNvPHDOjmVhhDkrRcZAEszetxCmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SyiWRj8YYBC1fBVmNDJb/Ixk54QFDKyZ8pFuCraaK3cY1l9e4uxPL5iOFwj6H91q8y6Nt4kXXnEPsNn7yMJuKnSHP5+lzRUMCkXHtolIsL2x544HnRb/u5qtC34lxXk129Ae+y161FKruOyXl3BihLepNIMpUlCAu1jK40KI6V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAjy8r1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAjy8r1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF850C19421;
	Sat, 21 Mar 2026 11:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094319;
	bh=u45BPGTz+pSWYCpXNvPHDOjmVhhDkrRcZAEszetxCmQ=;
	h=From:To:Cc:Subject:Date:From;
	b=mAjy8r1ssdti7A9Adw+UG2EGuSm018SNsUl6e+7svAzjt5MSjD0BRkOUeXogaLKiM
	 hRzB/TBK6ItI8d7vGPHxBBA1ts6LmSm/BYtZ61Noio1JR4btlUE7lIV2scxeSyBm/h
	 R5/T1Z0QCPAz7SeKJY+GIvTnThixdvAiCPHGTdalwnEv7iUPaOVfj1cL/l1EYExGQo
	 q6lroY+4LZz4kPXqQ+fNPxHhhortJP7+ER2INpwkKshZOGAmZznH+ZhjvIugu75e8l
	 fmkGhRWt6xOAqwMokBEOK7MsSVyMWA0cJQ3h1VK7hUWr7yfMP9/n4SIbWhr86V4dxp
	 d7KtcK6FMUvwg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v2 0/9] fstests: add test coverage for cloned filesystem ids
Date: Sat, 21 Mar 2026 19:58:21 +0800
Message-ID: <cover.1774090817.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
  - Add new helper _require_nouuid_mountopt() inline with the btrfs and
    ext4 nouuid mount option, matching xfs.
  - Clean up background processes in the _cleanup().
  - Use fsnotifywait(1) instead of a local tool.
  - Drop the use of SCRATCH_DEV_POOL for generic test cases to keep the
    existing xfs/ext4 test environment compatible for better coverage.

v1:
  https://lore.kernel.org/fstests/cover.1772095513.git.asj@kernel.org

Anand Jain (9):
  fstests: add _require_nouuid_mountopt() helper
  fstests: add _loop_image_create_clone() helper
  fstests: add _clone_mount_option() helper
  fstests: add test for inotify isolation on cloned devices
  fstests: verify fanotify isolation on cloned filesystems
  fstests: verify f_fsid for cloned filesystems
  fstests: verify libblkid resolution of duplicate UUIDs
  fstests: verify IMA isolation on cloned filesystems
  fstests: verify exportfs file handles on cloned filesystems

 common/config         |   2 +
 common/rc             |  74 +++++++++++++++++++++++++++
 tests/generic/790     |  89 ++++++++++++++++++++++++++++++++
 tests/generic/790.out |   7 +++
 tests/generic/791     | 116 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/791.out |   7 +++
 tests/generic/792     |  62 ++++++++++++++++++++++
 tests/generic/792.out |   7 +++
 tests/generic/793     |  76 +++++++++++++++++++++++++++
 tests/generic/793.out |  19 +++++++
 tests/generic/794     | 103 +++++++++++++++++++++++++++++++++++++
 tests/generic/794.out |  10 ++++
 tests/generic/795     |  73 ++++++++++++++++++++++++++
 tests/generic/795.out |   2 +
 14 files changed, 647 insertions(+)
 create mode 100644 tests/generic/790
 create mode 100644 tests/generic/790.out
 create mode 100644 tests/generic/791
 create mode 100644 tests/generic/791.out
 create mode 100644 tests/generic/792
 create mode 100644 tests/generic/792.out
 create mode 100644 tests/generic/793
 create mode 100644 tests/generic/793.out
 create mode 100644 tests/generic/794
 create mode 100644 tests/generic/794.out
 create mode 100644 tests/generic/795
 create mode 100644 tests/generic/795.out

-- 
2.43.0

