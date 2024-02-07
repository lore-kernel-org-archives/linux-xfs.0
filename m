Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03693DDB7;
	Wed,  7 Feb 2024 02:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272315; cv=none; b=lL4oWQDCoaXNPUR/51bYeAlBhJqoxI5pMocLAdP8KldOsvX6gONAWpg0u4kdE528Nk9InbhzV4UcRj7Vvv19AAeGsnLtS9aMK20agdVKfO9icYsWRez1Ms5gz4St/1P66+wz1lE2lA880hUa4c5LK6uUKvv3XDqmBFQI69xysSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272315; c=relaxed/simple;
	bh=NtjFuNssegON7wE/CPdDMN5tol9xingzRprbAtDBhZc=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=mXBukcRxupcGoQHd0e33eir0Q/0HDg0t5h0EdTZAxwfNnlPhrC3gFxvkJ+eSpgPDyqTTbSh4LiIqg9bKCa51hZWJdbvBnQ8y+6qszqdOBoIBzgRnajFSRHCs1VUwKwbnyGfBPAkdBbzVlAaKuewG4ZhvWbZXKNVogheT1AmbJjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mO5qeEGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mO5qeEGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F32C433F1;
	Wed,  7 Feb 2024 02:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272314;
	bh=NtjFuNssegON7wE/CPdDMN5tol9xingzRprbAtDBhZc=;
	h=Subject:From:To:Cc:Date:From;
	b=mO5qeEGzheQwU3+gzQsSnUEZcusMKc3xzARBQlhYNlsd6ZrSqWxwvOhX1gL35QY6Z
	 BCQbTfsz4/NdKNQpqjKEMQLkelqMmX7cOugsc2tuUEJVLE1lL7+ARgYFv8O9efVrcH
	 InpkOKurXtmNpJW3YHb9GzMGj2uBBLwlHHhHiGHuUB2HxExcOVOwUGw5QWInyDOWWz
	 HrDy6926Qd/NRgrt+Mn2h2thZ9RJTpdEDaMyo1x5RvkD0xZrSUkelzq4j8qj4ZY/mO
	 TVXj0lGLoUktfOC9Dj6e1yJvXZW31HM98w0C8TuZm8ZF+bcZ/49yaor9I9S2AA1Und
	 MyGNvYmP1xWfQ==
Subject: [PATCHSET] fstests: random fixes for v2024.01.14
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Andrey Albershteyn <aalbersh@redhat.com>,
 Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:18:33 -0800
Message-ID: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
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

Here's the usual odd fixes for fstests.  Most of these are cleanups and
bug fixes for the recently merged xfs metadump v2 testing code.

This second attempt fixes a severe bug in the cleanup code from the
refactored metadump testing code and adds a few adjustments that the
maintainer asked for.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes-2024.01.14
---
Commits in this patchset:
 * generic/256: constrain runtime with TIME_FACTOR
 * common/xfs: simplify maximum metadump format detection
 * common/populate: always metadump full metadata blocks
 * xfs/336: fix omitted -a and -o in metadump call
 * common: refactor metadump v1 and v2 tests, version 2
 * xfs/{129,234,253,605}: disable metadump v1 testing with external devices
 * xfs/503: test metadump obfuscation, not progressbars
 * xfs/503: split copy and metadump into two tests
 * common/xfs: only pass -l in _xfs_mdrestore for v2 metadumps
 * xfs/122: fix for xfs_attr_shortform removal in 6.8
---
 common/metadump   |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/populate   |    2 -
 common/rc         |   10 ---
 common/xfs        |   49 ++++++++++++++++-
 tests/generic/256 |    7 ++
 tests/xfs/122.out |    2 +
 tests/xfs/129     |   91 ++------------------------------
 tests/xfs/234     |   92 ++------------------------------
 tests/xfs/253     |   90 ++-----------------------------
 tests/xfs/284     |    4 +
 tests/xfs/291     |   32 ++++-------
 tests/xfs/336     |    2 -
 tests/xfs/432     |   31 ++---------
 tests/xfs/503     |   82 ++++-------------------------
 tests/xfs/503.out |    6 +-
 tests/xfs/601     |   54 +++++++++++++++++++
 tests/xfs/601.out |    4 +
 tests/xfs/605     |   92 +-------------------------------
 18 files changed, 318 insertions(+), 484 deletions(-)
 create mode 100644 common/metadump
 create mode 100755 tests/xfs/601
 create mode 100755 tests/xfs/601.out

