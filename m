Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7D236AF0;
	Tue,  9 Jan 2024 10:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tF6bqYwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3451EC433F1;
	Tue,  9 Jan 2024 10:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704795666;
	bh=lGJ7+cZiuPu2armpHdg3OL16/HS955v8jJ1Qds/S2qw=;
	h=From:To:Cc:Subject:Date:From;
	b=tF6bqYwra59iHC6J5+0VJnKALRJUBrUdwtM3uLG37pyQ0kqwcuSWm8sV7f1FZ5x8P
	 s7JaawTrTplbl2aeQgA7bHiws1X+iFehaJduZHK0XCCIxcsHnFn1g5mUFyUSrenNAn
	 aAfPNs7Mg6hBzG3sx550kG0UFI2o1DctzEU6J39smJM9sX0MeyFdGQaRtPtXMhHYF+
	 6lSyfk4P9T6s/fqrGOTxVl3dYVwihPFylVo8LWWGl+ddy3imka1FnoP17ZEUzLAzTi
	 nJ+owpFYKIOMFVodYcVQgl9BE2BwVql/FpgmJOKV+HBYnDPdPDjIcbgb+CACuev0zk
	 86ASa3JHJVs6w==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V2 0/5] Add support for testing XFS metadump v2
Date: Tue,  9 Jan 2024 15:50:42 +0530
Message-ID: <20240109102054.1668192-1-chandanbabu@kernel.org>
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

