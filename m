Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC392BA22;
	Sun, 31 Dec 2023 20:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKdDhC2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D67C433C8;
	Sun, 31 Dec 2023 20:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052926;
	bh=UVjlDA5BQCKVTPL6RxkQjGqQF6EjNS9B8oFNyx1iGFA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PKdDhC2IHWUGK+g2d38XiFp/GHBL7AQ5KYnhiOiFKTiJ6EK8MmSbX6UCjd6sgQ31K
	 1gEIXDn7teDN6lU67fs288RLPGH3da84OWSVQ/568KZpgTgxU6d6ClDBdAbfxrJNOc
	 iJNhVrQZJ/gN2SbDS4op1tbkC8wIrizSYJDHo5ys1cLTqK4imLQIZaGigIgyjJJy6O
	 iYWWvV2ITyugzyc7CE33+/PGU570emnfizKwGQm1LuozqnLvvI0aDN3l2vpaRgtNPD
	 Ce6cQJxwFt2cSVohZGXzazde9L32HAh2rWhK3r5CGeFYJWdhiky+3pG/PdpJq+BsTI
	 SqDfNCemTkZVg==
Date: Sun, 31 Dec 2023 12:02:06 -0800
Subject: [PATCHSET v2.0 9/9] fstests: functional tests for rt quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405033118.1827880.4279631111094836504.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
 common/populate    |    2 -
 common/quota       |   64 ++++++++++++++++++--
 common/xfs         |   12 ++++
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
 tests/xfs/106      |    1 
 tests/xfs/108      |    2 +
 tests/xfs/152      |    1 
 tests/xfs/153      |    2 +
 tests/xfs/161      |    2 +
 tests/xfs/1858     |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1858.out |   41 +++++++++++++
 tests/xfs/213      |    1 
 tests/xfs/214      |    1 
 tests/xfs/220      |    2 +
 tests/xfs/299      |    2 +
 tests/xfs/330      |    1 
 tests/xfs/434      |    1 
 tests/xfs/435      |    1 
 tests/xfs/441      |    1 
 tests/xfs/442      |    1 
 tests/xfs/508      |    2 +
 tests/xfs/511      |   10 +++
 tests/xfs/720      |    5 ++
 34 files changed, 333 insertions(+), 10 deletions(-)
 create mode 100755 tests/xfs/1858
 create mode 100644 tests/xfs/1858.out

