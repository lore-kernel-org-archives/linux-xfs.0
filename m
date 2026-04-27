Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7B8169AD2;
	Mon, 27 Apr 2026 10:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285195; cv=none; b=WspqPUlKB/G+1enddQ6/TMLgmIe8RfUH1c37u9+2/ASOCFY4KL2SeNz2Jrbc9s+9pg95WIefdSG5cn52HeanUh4cOXautI2FYOmVvD3K3tqxSC1Yj1GYRYKqth83H1Ue1jOEPFtvzdcZxLI+Li29wQJMdH2stpD38fxphN0Z7HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285195; c=relaxed/simple;
	bh=esoc/cEbKrXi+tD+voYcu+IvUJflrY2/aZ2+rQTT5rs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J0qzqCQFMt/PU05UYvHIwZ+405XUzD2n6bQV1v37Au/sBPV1oCthENDlSX12uyldTm0Bh0Wkh9YlAN2HPp9wYcMqZmJCxcWVSL3ilpvOPc8q142OMm5PRlMJdPi2na9QGyyYS/Sp5lY82qWtHWskyW0Ah/VafyLG2gPNH2gWRk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cI2f/iRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cI2f/iRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFF2C2BCB4;
	Mon, 27 Apr 2026 10:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285195;
	bh=esoc/cEbKrXi+tD+voYcu+IvUJflrY2/aZ2+rQTT5rs=;
	h=From:To:Cc:Subject:Date:From;
	b=cI2f/iRIuRvGuqlOM4jNK4Dc7cKRks3xiCWW8sMbxlyc1DL7j47wUW/oxNOUAW/YX
	 id7lhAa/9haQ8mb5oNB0JEZc+aYva+tefSQeqCMKDBpJEDEAyRmpvHGxdaZk/HYCEz
	 POWYVGq2Ihp67Bc4dAD6ncyQslH034eulYzGyl1iGxXKT22IposYd/42wQW+kmoCMp
	 FqAnSr0R4Qu8awA0lYccVrWW+cColfhbl3Ty4RVkeVrsylNm2HGPLrb07Rw0MzhDiQ
	 Q2CMveKOZO1EUN0grQ4p91bhkOGz0nv81XOVFfehIU3es9jPwYYvbIp8CKe9hJq0YV
	 7H69JAIHVOkDw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 0/9] fstests: add test coverage for cloned filesystem ids
Date: Mon, 27 Apr 2026 18:19:32 +0800
Message-ID: <cover.1777281778.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3:
 Dropped the -o nouuid mount option.
 Added a Btrfs test case to verify clones of filesystems using the
   metadata_uuid superblock feature.
 Updated _loop_image_create_clone() to handle necessary pre-clone
   filesystem tuning.

v2:
  https://lore.kernel.org/fstests/cover.1774090817.git.asj@kernel.org

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
 common/rc             |  58 +++++++++++++++++++++
 tests/btrfs/348       |  91 +++++++++++++++++++++++++++++++++
 tests/btrfs/348.out   |  19 +++++++
 tests/generic/800     |  88 ++++++++++++++++++++++++++++++++
 tests/generic/800.out |   7 +++
 tests/generic/801     | 115 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   7 +++
 tests/generic/802     |  61 ++++++++++++++++++++++
 tests/generic/802.out |   7 +++
 tests/generic/803     |  75 +++++++++++++++++++++++++++
 tests/generic/803.out |  19 +++++++
 tests/generic/804     | 102 +++++++++++++++++++++++++++++++++++++
 tests/generic/804.out |  10 ++++
 tests/generic/805     |  72 ++++++++++++++++++++++++++
 tests/generic/805.out |   2 +
 16 files changed, 735 insertions(+)
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

