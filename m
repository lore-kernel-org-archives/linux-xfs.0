Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88132361D6;
	Thu, 16 Jan 2025 23:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069911; cv=none; b=Y435ZoDVA1lBg1k1AZjJmMvJdBK6D7wz1cMWJgj24Z6y8ftM8p15cHFYIvNimKfbyg36nZNHdWt0IUntVt9f4wfj5PC+1BVpZpLtSWJ3KM+CouMMRatats18uVUaRWaoTTgDNbZLfhLYl4WbxPQaHBtiGsg/BBG016QxJRb6XrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069911; c=relaxed/simple;
	bh=eEDrvMh5G5pKjB7IcbK2ByivKoqpKAA1OmgnaRc0WOM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uu4uPsNTj7f5aFQ7x6zMdpeYDd1aOITifl0oJg5ygbtsCJLcLS8Pz/1K382HNt3++ahjhydDrDhhkZ44SKhcKNIu/1pin6c6mlCMPSkfK2nwWZkO3OErw93Kf6lHD+Ck6DIbrRmS/+WsVje21RrKXyYBnFTHF9X2qKCQ65w2j0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u9ACD/SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9ACD/SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F76C4CED6;
	Thu, 16 Jan 2025 23:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069911;
	bh=eEDrvMh5G5pKjB7IcbK2ByivKoqpKAA1OmgnaRc0WOM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u9ACD/SYyfB63zjOxNmOEHppL+okG1b8YMav28PYL4WIyQ9lFbTIP/lMnL3Yz6jTn
	 iHk50I48VYHQXqHCXsghbV5VOV2l9JNngCgkSd3FxyQzB4mIad4IVtLeak4HjeTN/w
	 gyl8NhgptlmHeyIUXqytiWz4gV3BGrIUmeqC1Rw3dWVKKt3a2JYa8DxUYlyZ3vMwIo
	 IqEY44LhRF96AtWKdn7AtyBJI5aSUikohY3Z6eU/BwxnY1tAZx/ErBU247db8jv+/P
	 sbkJf7x0SQvwSlgYurzs8fS5mXsYY5mhuQTGSZ0ndqFnbLoxk/UOxkxpzgZZfxGO07
	 Y8FerChseIA4Q==
Date: Thu, 16 Jan 2025 15:25:10 -0800
Subject: [PATCHSET v6.2 7/7] fstests: enable quota for realtime volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706977056.1931302.2974286403286751639.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116232151.GH3557695@frogsfrogsfrogs>
References: <20250116232151.GH3557695@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

The sole patch in this series sets up functional testing for quota on
the xfs realtime device.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
Commits in this patchset:
 * common: enable testing of realtime quota when supported
 * xfs: fix quota tests to adapt to realtime quota
 * xfs: regression testing of quota on the realtime device
---
 common/populate    |   10 ++-
 common/quota       |   45 ++++++++-----
 common/xfs         |   62 +++++++++++++++++++
 tests/generic/219  |    1 
 tests/generic/230  |    1 
 tests/generic/305  |    1 
 tests/generic/326  |    1 
 tests/generic/327  |    1 
 tests/generic/328  |    1 
 tests/generic/566  |    4 +
 tests/generic/587  |    1 
 tests/generic/603  |    1 
 tests/generic/691  |    2 +
 tests/generic/710  |    4 +
 tests/xfs/050      |    2 +
 tests/xfs/096      |    4 +
 tests/xfs/106      |    1 
 tests/xfs/108      |    2 +
 tests/xfs/152      |    1 
 tests/xfs/153      |    2 +
 tests/xfs/161      |    1 
 tests/xfs/1858     |  174 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1858.out |   47 ++++++++++++++
 tests/xfs/213      |    1 
 tests/xfs/214      |    1 
 tests/xfs/220      |    2 +
 tests/xfs/299      |    2 +
 tests/xfs/330      |    1 
 tests/xfs/434      |    1 
 tests/xfs/435      |    1 
 tests/xfs/440      |    3 +
 tests/xfs/441      |    1 
 tests/xfs/442      |    1 
 tests/xfs/508      |    2 +
 tests/xfs/511      |   10 +++
 tests/xfs/720      |    5 +
 36 files changed, 377 insertions(+), 23 deletions(-)
 create mode 100755 tests/xfs/1858
 create mode 100644 tests/xfs/1858.out

