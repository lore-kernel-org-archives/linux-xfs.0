Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D31815AD7;
	Thu, 11 Jan 2024 11:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQb0Ky/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DEBC433F1;
	Thu, 11 Jan 2024 11:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704974365;
	bh=f1SPUTYEy9GQdnIBZIzCYWKpy1J5LBV9ZV+rzSNTngg=;
	h=From:To:Cc:Subject:Date:From;
	b=TQb0Ky/KOzmEktOQUzVOSNkNmSN3QLrHQBCHnOyVMFjVOaFGONVxck52/Z/OKIkGB
	 cC614fl9LDExWZPKDj51ZBWOJH4w+/Ab9eNgwClFfeDuLv4rIEn0Lug5XronXAKmCv
	 xHHVQVvO7HWDOL9yhCBLIT2ntqOGBjabCmGl1C9wf1IuxPn8jN8rptoDsDa/7FjJpL
	 wX1z30/Exj9eM4aYSqrh0vUDfd5QUlRxhZQM/5pIqMjPxb/ZcZBTWP9ZoHagmal4uu
	 LtXG9Bh6V/5wsehGcT/A5/xXerKY2qEj5mEiVRUSLOeTQJgBGS7iWO/rgwMSfT16oj
	 mkKwmGgMMWLyA==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V3 0/5] Add support for testing XFS metadump v2
Date: Thu, 11 Jan 2024 17:28:24 +0530
Message-ID: <20240111115913.1638668-1-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset modifies existing tests to add support for testing
Metadump v2 feature. Metadump v2 feature is already part of Xfsprogs'
for-next branch.

Changelog:
V2 -> V3:
   1. xfs/801: Initialize logdev to empty string in verify_metadump_v2().
   
V1 -> V2:
   1. Unroll loops which execute metadump/mdrestore for both v1 and v2
      variants.

Chandan Babu R (5):
  common/xfs: Do not append -a and -o options to metadump
  common/xfs: Add function to detect support for metadump v2
  _scratch_xfs_mdrestore: Pass scratch log device when applicable
  xfs: Add support for testing metadump v2
  xfs: Check correctness of metadump/mdrestore's ability to work with
    dirty log

 common/populate   |   2 +-
 common/xfs        |  32 +++++++--
 tests/xfs/129     |  97 ++++++++++++++++++++++---
 tests/xfs/129.out |   4 +-
 tests/xfs/234     |  97 ++++++++++++++++++++++---
 tests/xfs/234.out |   4 +-
 tests/xfs/253     | 118 +++++++++++++++++++++++++-----
 tests/xfs/291     |  25 +++++--
 tests/xfs/336     |   2 +-
 tests/xfs/432     |  29 ++++++--
 tests/xfs/432.out |   3 +-
 tests/xfs/503     |  94 +++++++++++++++---------
 tests/xfs/503.out |  12 ++--
 tests/xfs/801     | 178 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/801.out |  14 ++++
 15 files changed, 601 insertions(+), 110 deletions(-)
 create mode 100755 tests/xfs/801
 create mode 100644 tests/xfs/801.out

-- 
2.43.0

