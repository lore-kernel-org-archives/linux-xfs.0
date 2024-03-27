Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF9421A1C;
	Wed, 27 Mar 2024 02:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711507399; cv=none; b=hPzgdUvhimOXtI5WIGf5IxLseKT5j2uMTrbp08VDESvmVokj3A+sUo53y3CrpK1+eteBTdwZXBALdtvw7Af6AnRvAGIrYrHBoGj+ME3PGzUsTkkPzLCIWObFOlW61ZfjNCuDFhvQeKCfIBzhXqqHMZZuJHo0mzzm7w8SvZvxeg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711507399; c=relaxed/simple;
	bh=TZ4+YKY9gAsxemx1AXiMd6mo/qldVsXmlgmESPMQ2Yk=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=gHHxkU2xxiHjhku8YiPXbtQj5v0G+a0gvY/PWyXWXgXiKlyie07UAkbkElG1hxzR0T4o5QgqoZZAC6juSU6qHFCEK86nIwY5wRnWYt+dWln/9SVG63QejN5IH9BS7vRU+Ao6+0kTlY+mUQONJ5/UoT6CIeKwrYE0yWn1u2ZzCsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uy82pLVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uy82pLVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA75C433C7;
	Wed, 27 Mar 2024 02:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711507398;
	bh=TZ4+YKY9gAsxemx1AXiMd6mo/qldVsXmlgmESPMQ2Yk=;
	h=Subject:From:To:Cc:Date:From;
	b=uy82pLVlz1+n9srXBQvHYLa10HJnkzTYgJOjajpBP9GjYEqCvqQtnIS25NNqJUyyF
	 XsbbqMqGcm78w49U7VWtVblUNPo+IGtoVYcX3OoztkM3idKE/NQGjGfkdvn5aiI2D5
	 xPNHPNKaodtWeBHciwfoVlJmT/VtdjnJv80jXU3LH6J+f0ZceZsOxB6PuSwdYuTEh2
	 m2455HCMZ7BIun1wq2dnedA1rWKhvxvlhhhKd/ZmOjcYgsphQZf35ORL1eHjDF3+Jl
	 5GrOtYdDf/4HaH/tm0T+yvMLi9PP1C42rat2Ew8SyHLQfftV3KUh1vyLD1jTqdAQKz
	 X7pRaw3jygf8A==
Subject: [PATCHSET] fstests: random fixes for v2024.02.09
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, David Hildenbrand <david@redhat.com>,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Date: Tue, 26 Mar 2024 19:43:17 -0700
Message-ID: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
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
bug fixes that have been aging in my djwong-wtf branch forever.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs/270: fix rocompat regex
 * xfs/176: fix stupid failure
 * generic/{166,167,333,334,671}: actually fill the filesystem with snapshots
 * generic: test MADV_POPULATE_READ with IO errors
---
 common/reflink         |    8 ++++++
 tests/generic/166      |    2 +
 tests/generic/167      |    2 +
 tests/generic/1835     |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1835.out |    4 +++
 tests/generic/333      |    2 +
 tests/generic/334      |    2 +
 tests/generic/671      |    2 +
 tests/xfs/176          |    2 +
 tests/xfs/270          |    3 +-
 10 files changed, 85 insertions(+), 7 deletions(-)
 create mode 100755 tests/generic/1835
 create mode 100644 tests/generic/1835.out

