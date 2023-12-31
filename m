Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E5BA22;
	Sun, 31 Dec 2023 19:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nO+tbAIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6575C433C7;
	Sun, 31 Dec 2023 19:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052754;
	bh=16v//G9MNKTCke0KET7aA3wN5onMFfcIuBhvJCl0zFQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nO+tbAIhJz7fXPf0yacTeRK3HpSa4N3Tj1ZzBpPq72YANMv396oH/ISpx9cZ+n38D
	 a8dzgGrYg577JIQ2J19tSmuqrK5AYjEkmCpZmNHY2fyvdBTR9pgirlElqs27DubGQ9
	 ps/1oJH425p8n3XxF5IRdPM27EaaSjMDxjO0Tq7coMNZBgpe2LA1qwWbZYMbGU2Q/d
	 gsQrPirT9vcGwJOOd8mOsTz4sFP3sLAlWcyYLGsJV/tjbwNOXViX7lVNABVhdMRqTb
	 kJc5Fyzv9LPSgY71Xiuh452a8gipQ5pKQPZPJLIaPN1EcwYz2wOhf/umKSyNwMb8fT
	 ChEj8O1qgNpcQ==
Date: Sun, 31 Dec 2023 11:59:14 -0800
Subject: [PATCHSET v13.0 1/3] fstests: adjust tests for xfs parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, fstests@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com, guan@eryu.me,
 linux-xfs@vger.kernel.org
Message-ID: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

These are the test adjustments that are required for parent pointers.
There's also a few new tests to ensure that the GETPARENTS ioctl (and
 file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=pptrs
---
 common/parent             |  209 +++++++++
 common/populate           |   38 ++
 common/rc                 |    7 
 common/xfs                |   27 +
 doc/group-names.txt       |    1 
 src/popdir.pl             |   11 
 tests/generic/1834        |   93 ++++
 tests/generic/1834.out    |    2 
 tests/xfs/018             |    4 
 tests/xfs/021             |   15 +
 tests/xfs/021.cfg         |    1 
 tests/xfs/021.out.default |    0 
 tests/xfs/021.out.parent  |   62 +++
 tests/xfs/122.out         |    3 
 tests/xfs/1851            |  116 +++++
 tests/xfs/1851.out        |   69 +++
 tests/xfs/1852            |   69 +++
 tests/xfs/1852.out        | 1002 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1853            |   85 ++++
 tests/xfs/1853.out        |   14 +
 tests/xfs/191             |    3 
 tests/xfs/206             |    3 
 tests/xfs/288             |    4 
 tests/xfs/306             |    9 
 24 files changed, 1839 insertions(+), 8 deletions(-)
 create mode 100644 common/parent
 create mode 100755 tests/generic/1834
 create mode 100644 tests/generic/1834.out
 create mode 100644 tests/xfs/021.cfg
 rename tests/xfs/{021.out => 021.out.default} (100%)
 create mode 100644 tests/xfs/021.out.parent
 create mode 100755 tests/xfs/1851
 create mode 100644 tests/xfs/1851.out
 create mode 100755 tests/xfs/1852
 create mode 100644 tests/xfs/1852.out
 create mode 100755 tests/xfs/1853
 create mode 100644 tests/xfs/1853.out

