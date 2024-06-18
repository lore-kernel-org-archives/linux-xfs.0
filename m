Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34F76AC0;
	Tue, 18 Jun 2024 00:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671583; cv=none; b=tciFv7rkryfr0Jog5Y5NJoslJAjEbWc32HEnVXSwIQoHfnFkMTDF2SwY3QvUVGsTEDdOzM1PF9h0roujM/7Po7Gzt3sh2CNAj9dH2kh96kqJaeAMtMuSMew3xAyi95Lqycav5v29RG6pOzhVfLJhTlcbz2PBB1plAl9T06igbhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671583; c=relaxed/simple;
	bh=3EHFadsL6+7UAeYq85ugskYBLVkkFx9qYwFv4wYYjMk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=J4uLDXx7y84FQp9sDeeWAOwgx/LIkw2HRjxvgvmZxkJ+uyq1cxiTynPqoPbjffijim2QbByDBRiMnEIphUofYwcZ8Wv3xqTlSy5euFXl5gG4fDDd0VGK/PmOUzpMgj7/UQAitUVnXRvyLKuzRqmoCYWxo9CQLp9HIKtlQNn+1HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fc1+YwVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fc1+YwVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F1EC2BD10;
	Tue, 18 Jun 2024 00:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671583;
	bh=3EHFadsL6+7UAeYq85ugskYBLVkkFx9qYwFv4wYYjMk=;
	h=Date:Subject:From:To:Cc:From;
	b=Fc1+YwVPHynRsBI1OjDm+Mn7F6n7luHcUtDmILwwW2OmTGAThHpfU95cP3MCQ6V7L
	 i3PGCcZkBGTcES8JZWXmms9JZMFXU9Fx6GLMfaPsv0IIFVXRegkWjxscFg/CPdLr2J
	 a6CcV0d+stsoRO5iMEB4YZAkJuUNwoEqJTskEP518I2pAjxCklq3MD7+ZiOYT6FK3i
	 bn92t9FCAc0WVhHF8bJ7DCgr4oJWX+Up3UUcaZmd0HuzPQFWdFdZJ1sax3ShFXaj0j
	 OMK9m496p8slstK4XsW4hq6P/CqSpOi/P1uTpXps2PVt24gt7xhvwScyLihJhHEO+H
	 qLOvXdXE0Bm6Q==
Date: Mon, 17 Jun 2024 17:46:22 -0700
Subject: [PATCHSET v13.5 3/6] fstests: adjust tests for xfs parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, fstests@vger.kernel.org,
 guan@eryu.me, linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
 catherine.hoang@oracle.com
Message-ID: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
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
Commits in this patchset:
 * generic: test recovery of extended attribute updates
 * xfs/206: filter out the parent= status from mkfs
 * xfs/122: update for parent pointers
 * populate: create hardlinks for parent pointers
 * xfs/021: adapt golden output files for parent pointers
 * xfs/{018,191,288}: disable parent pointers for this test
 * xfs/306: fix formatting failures with parent pointers
 * common: add helpers for parent pointer tests
 * xfs: add parent pointer test
 * xfs: add multi link parent pointer test
 * xfs: add parent pointer inject test
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
 tests/xfs/021.out.parent  |   64 +++
 tests/xfs/122.out         |    4 
 tests/xfs/1851            |  116 +++++
 tests/xfs/1851.out        |   69 +++
 tests/xfs/1852            |   69 +++
 tests/xfs/1852.out        | 1002 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1853            |   85 ++++
 tests/xfs/1853.out        |   14 +
 tests/xfs/191             |    3 
 tests/xfs/206             |    1 
 tests/xfs/288             |    4 
 tests/xfs/306             |    9 
 24 files changed, 1841 insertions(+), 7 deletions(-)
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

