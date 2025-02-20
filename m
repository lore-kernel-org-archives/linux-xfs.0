Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A483C13AF2;
	Thu, 20 Feb 2025 22:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089138; cv=none; b=VcpqBdt3KwSp7/eQrbfIEI8o01QNS8ZC1TzHu/tP1VN9iv6jKWVyUcWq9h2VDBFkE0vNHTjhs1VduQHLBLZIEVV04Vu6RFRmfPKGAdxddxEs1HqGkvcVVdlPxrEZ4EpRcUlXFNzBFpQmDvKT4jxvf/oLEEyTdJC1vbMjOEYkM5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089138; c=relaxed/simple;
	bh=9iKywWoh9mA8tyJFgZJoGj1PXs30fkBBEuds41fFQiY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Duvll/LfbplH+q4NfoUZaU0n+hntxy3ga7AzElsB5SjKWBJI6b85bfbfdb7TIZPyjkBRdpRFn/6FnPJ3qX113HgcG+sGL8XI9YJ/6o2ZzeHbRyqPBidLudTOtwjlwe1zOG6Y1PhOwsjVik3oiz75gUcsRzHt0DZh/NVkzssnUu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrWelwee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrWelwee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81056C4CED1;
	Thu, 20 Feb 2025 22:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089138;
	bh=9iKywWoh9mA8tyJFgZJoGj1PXs30fkBBEuds41fFQiY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qrWelweeZpcqJBRPaqhRtlA3lRw4gmSEh2AuT6jrJpaLxkZOHnHX29jc9XoymOqK1
	 pdYAR8f8aJaL+Ek/lL1ab4Hmx4Wa1w827eDSOdR07gZs+wAU63Hm94Y+ORAlXcb0kh
	 pSRaeQ1l/PPKwfmQiUgLkz7+LcASftw4TlenoLl+pBIzoKqBdQqqrwqMcplRE9NVPE
	 4yv47p8hUpR6KyVUnmSm/R2CJd06A72QV7e5XERbFMM6ebcQOsjh+JzpMZVOIBhTUe
	 hpH0pDH86WqV/H7J2uGtnvuIlGgzHr4AORfyh5hxw0X/cWc75+CxZOLUjj837AV2rY
	 TcsBtutCor2hg==
Date: Thu, 20 Feb 2025 14:05:38 -0800
Subject: [GIT PULL 06/10] fstests: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008901875.1712746.17709030989014897277.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220220245.GW21799@frogsfrogsfrogs>
References: <20250220220245.GW21799@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 153e2550b7bf4b0ebb3c6d0e1757a6709858a0b0:

xfs: fix fuzz tests of rtgroups bitmap and summary files (2025-02-20 13:52:19 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/metadir-quotas_2025-02-20

for you to fetch changes up to 7ba79ac12c4be53d13673236b2d8f1a86076e5e0:

xfs: fix tests for persistent qflags (2025-02-20 13:52:20 -0800)

----------------------------------------------------------------
fstests: store quota files in the metadir [v6.5 06/22]

These are the fstests adjustments to quota handling in metadir
filesystems, which means finding the quota inodes through paths, and
adjusting to quota options being persistent.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: update tests for quota files in the metadir
xfs: test persistent quota flags
xfs: fix quota detection in fuzz tests
xfs: fix tests for persistent qflags

common/quota                           |   1 +
common/rc                              |   1 +
common/xfs                             |  21 +++++
tests/generic/563                      |   8 +-
tests/xfs/007                          |   2 +-
tests/xfs/096                          |   1 +
tests/xfs/096.out                      |   2 +-
tests/xfs/106                          |   2 +-
tests/xfs/116                          |  13 ++-
tests/xfs/116.cfg                      |   1 +
tests/xfs/{116.out => 116.out.default} |   0
tests/xfs/116.out.metadir              |   3 +
tests/xfs/152                          |   2 +-
tests/xfs/1891                         | 128 ++++++++++++++++++++++++++++
tests/xfs/1891.out                     | 147 +++++++++++++++++++++++++++++++++
tests/xfs/263                          |   1 +
tests/xfs/263.out                      |   2 +-
tests/xfs/425                          |   5 +-
tests/xfs/426                          |   5 +-
tests/xfs/427                          |   5 +-
tests/xfs/428                          |   5 +-
tests/xfs/429                          |   5 +-
tests/xfs/430                          |   5 +-
tests/xfs/487                          |   5 +-
tests/xfs/488                          |   5 +-
tests/xfs/489                          |   5 +-
tests/xfs/779                          |   5 +-
tests/xfs/780                          |   5 +-
tests/xfs/781                          |   5 +-
29 files changed, 376 insertions(+), 19 deletions(-)
create mode 100644 tests/xfs/116.cfg
rename tests/xfs/{116.out => 116.out.default} (100%)
create mode 100644 tests/xfs/116.out.metadir
create mode 100755 tests/xfs/1891
create mode 100644 tests/xfs/1891.out

