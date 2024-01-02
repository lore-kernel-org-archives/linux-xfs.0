Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ACC5672;
	Tue,  2 Jan 2024 08:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/n0jzEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CD0C433C7;
	Tue,  2 Jan 2024 08:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704185071;
	bh=5KD7xRUocAGwYR9y33oIZDWtyjPG6zed9+Uv3vU8R+s=;
	h=From:To:Cc:Subject:Date:From;
	b=D/n0jzEt/aPqUNokGjrkUNJ7GTAGtn/8vwcSCAvI8jnHsPbDQyY//GsFIONcGfzUR
	 3LUwi9wlJdoMAWuoXRgsyJE5Wc9xHcENAj+7U/lZ1xQkcXfLM4mbaHYhZW9a3Ad9fS
	 K+hsq0y1IU9kYS+jt4Y1Gdy+aj36oafO2MBb/krBm5XuIWtDUhecV8BBFSSe0EwFRx
	 VBH0LfXRijz9zFAJuwNhbym0UiLLn8WINb2MbqJHkjkgkiikUB8i90qo/5SYJScoAw
	 luPMn1uwzTZzottcbd7m3ZP/jou0z94YjXUDHP+B6aSgaklQUclu9nvVl3Ympqc4rd
	 4HAGHOdKbC6kg==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH 0/5] Add support for testing XFS metadump v2
Date: Tue,  2 Jan 2024 14:13:47 +0530
Message-ID: <20240102084357.1199843-1-chandanbabu@kernel.org>
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

Chandan Babu R (5):
  common/xfs: Do not append -a and -o options to metadump
  common/xfs: Add function to detect support for metadump v2
  _scratch_xfs_mdrestore: Pass scratch log device when applicable
  xfs: Add support for testing metadump v2
  xfs: Check correctness of metadump/mdrestore's ability to work with
    dirty log

 common/populate   |   2 +-
 common/xfs        |  34 ++++++--
 tests/xfs/129     |  63 ++++++++++++---
 tests/xfs/129.out |   4 +-
 tests/xfs/234     |  63 ++++++++++++---
 tests/xfs/234.out |   4 +-
 tests/xfs/253     | 195 ++++++++++++++++++++++++++--------------------
 tests/xfs/291     |  25 +++++-
 tests/xfs/336     |   2 +-
 tests/xfs/432     |  29 +++++--
 tests/xfs/432.out |   3 +-
 tests/xfs/503     |  94 +++++++++++++---------
 tests/xfs/503.out |  12 +--
 tests/xfs/801     | 115 +++++++++++++++++++++++++++
 tests/xfs/801.out |  14 ++++
 15 files changed, 485 insertions(+), 174 deletions(-)
 create mode 100755 tests/xfs/801
 create mode 100644 tests/xfs/801.out

-- 
2.43.0

