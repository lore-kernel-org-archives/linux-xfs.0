Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B1528DD0;
	Wed, 19 Feb 2025 00:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926062; cv=none; b=mHrqNThdOMgMyDJf7P8maRZq0mvhp5Rdrz+rM/E9dPc4AIn6VETjImyghj1l4aHeRXB5IPYAPLWjmz3TZNTprnUzz+Gv7hW3qaP/FePQDJu+1bBt37g+j3FqMoFDitHcMaR6ezlQ3oBN4B/ZzhAIlYyqM9mxz5UgyFkQ94ILfWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926062; c=relaxed/simple;
	bh=hzePJna68kwsS8iSgk7DCf+cK++f5ojyD76UV4uJK0Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QY9NZp8p4fMqu30Bu5opI2byb9p9Xu7Pz/CRjbz/mQ7xu5YRAGXJ6GkKwkGgKK1Gp2jV+KQchhUxjzxpSTRmeDHuKwFmNB7GNP1s+bjT4CmuGtLLi7LddHMfX3dWdbMAfkcvYZjS6gd86w0uhbIoXxfINcdYmHlo9JLw+OxUVB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBJsayNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBJsayNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71980C4CEE2;
	Wed, 19 Feb 2025 00:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926062;
	bh=hzePJna68kwsS8iSgk7DCf+cK++f5ojyD76UV4uJK0Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KBJsayNpIdWFmiquJI5mH/55F1GAH4UJy6D+xRwO7vunrc2TInma5ieiFXB3c+ldM
	 b9HxzTVFMEZeT8PFxUC26hto5I6wu/VcD7NrtIxy1NnFK/JnDfRtJvtcMGqut5tHkh
	 zr5xLDIlIPc76iWzOsAJlcizwIlCvZbujbjcP7Qy3nB5tFUUCoJJxMsnl+XQ8aYatc
	 T1I6rkYVaYw22W+FiQBvyItguwuUrlEdH5Uztm90XlLZ3HUru+5VUHUz4Fs6PRCP6Y
	 daTg8VY5FUO0Kb0M/WCLWfgwqwpynEKE46jYly84yQp/YllTpNdGhRA+ChfQuwOV+w
	 MC/ebU1eSsm/Q==
Date: Tue, 18 Feb 2025 16:47:40 -0800
Subject: [PATCHSET v6.4 07/12] fstests: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589825.4080063.11871287620731205179.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Store the quota files in the metadata directory tree instead of the superblock.
Since we're introducing a new incompat feature flag, let's also make the mount
process bring up quotas in whatever state they were when the filesystem was
last unmounted, instead of requiring sysadmins to remember that themselves.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir-quotas
---
Commits in this patchset:
 * xfs: update tests for quota files in the metadir
 * xfs: test persistent quota flags
 * xfs: fix quota detection in fuzz tests
 * xfs: fix tests for persistent qflags
---
 common/quota              |    1 
 common/rc                 |    1 
 common/xfs                |   21 ++++++
 tests/generic/563         |    8 ++
 tests/xfs/007             |    2 -
 tests/xfs/096             |    1 
 tests/xfs/096.out         |    2 -
 tests/xfs/106             |    2 -
 tests/xfs/116             |   13 ++++
 tests/xfs/116.cfg         |    1 
 tests/xfs/116.out.default |    0 
 tests/xfs/116.out.metadir |    3 +
 tests/xfs/152             |    2 -
 tests/xfs/1891            |  128 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1891.out        |  147 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/263             |    1 
 tests/xfs/263.out         |    2 -
 tests/xfs/425             |    5 +-
 tests/xfs/426             |    5 +-
 tests/xfs/427             |    5 +-
 tests/xfs/428             |    5 +-
 tests/xfs/429             |    5 +-
 tests/xfs/430             |    5 +-
 tests/xfs/487             |    5 +-
 tests/xfs/488             |    5 +-
 tests/xfs/489             |    5 +-
 tests/xfs/779             |    5 +-
 tests/xfs/780             |    5 +-
 tests/xfs/781             |    5 +-
 29 files changed, 376 insertions(+), 19 deletions(-)
 create mode 100644 tests/xfs/116.cfg
 rename tests/xfs/{116.out => 116.out.default} (100%)
 create mode 100644 tests/xfs/116.out.metadir
 create mode 100755 tests/xfs/1891
 create mode 100644 tests/xfs/1891.out

