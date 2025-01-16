Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917C1158520;
	Thu, 16 Jan 2025 23:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069815; cv=none; b=PYtC1/ptsSglZVME9ATVvKWG+UI1G9cykt8gOS+OYHP3UEXVLDOlAFaiVHkOanNMW3ne4rgKgWszG9DEVMSzWTA9ZthCl/gpZnDcVgvZGYE3S05ObSpFasY+5+yXOCE05dx4Obx+8Sz7cl6IfkV5KrJ/GiT8SWwjdzvdVz0SHF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069815; c=relaxed/simple;
	bh=7b390ZXP4KzHxAU7GPZFABSRKLY6lsgri5CZX6jSkFw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SpRk24ZykfaWns4NgoiyKvIHwCS1oHnnHI0ghRNp5E2bDmN0h4oTSqkyiab4jm6BWM9V69mY3RaQvfP8jHjgEGc33vpyqjxJ5B2YblqUJi+VUbLpGRWefXzHaIs29LyElqQT14Vi+jc8+sNJF/ovrJhNx/s0hcNco90VmuUBjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpRSZVrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpRSZVrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66205C4CED6;
	Thu, 16 Jan 2025 23:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069815;
	bh=7b390ZXP4KzHxAU7GPZFABSRKLY6lsgri5CZX6jSkFw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XpRSZVrsL34MMN929BMhID2mjno9WAxJcPxO0aQSLJqiBlwHSTJQefIJG3R1f6TgR
	 W7y0/50+4VX3EnYSz1CC7IGZ4AFaftFwweMHhoLItwungFegzVvHMv596OaLoDMAC6
	 iHAgKeNTkd/6CEnoJ9jewLl7moNpQu6Mwt6tEzH1hi+FpP46Npokoifjg48ON4MiD3
	 VFoDmpQdMHmp9Wp/R3+So/s8+3H0RY7OcQqnJJBj4+WJC7xvdiVRAqlkCF+K/xUcSa
	 GXAIV/tRcPd0zO0rwoceInf58JL9XiuZpSzNjOiKn+YZIQ/3hllNnvXDex0/DWgLXj
	 FR/5mU+QeweMw==
Date: Thu, 16 Jan 2025 15:23:34 -0800
Subject: [PATCHSET 1/7] fstests: random fixes for v2025.01.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
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

This is an unusually large set of bug fixes for fstests.  The first 20
patches in this patchset are corrections for that RFC series.

The most significant change is that I made ./check run each test with
its own Unix process session id.  This means that a test can use pkill
to kill all of its own subprocesses, without killing anyone else's
subprocesses.  I'm not completely sold on that approach, but it works
for me.  It seems to work for check-parallel as well, though I've not
tested that all that much.

Note: I am /not/ happy about Dave's RFC going straight to for-next
without even a complete review right before everyone went on PTO for
several weeks for xmas/solar new year.  But in the interests of getting
QA back on line for myself and everyone else who's having problems, here
it is.

The last two patches are bugs that have lurked in fstests for ages.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
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
 * generic/476: fix fsstress process management
 * metadump: make non-local function variables more obvious
 * metadump: fix cleanup for v1 metadump testing
 * generic/482: _run_fsstress needs the test filesystem
 * generic/019: don't fail if fio crashes while shutting down
 * fuzzy: do not set _FSSTRESS_PID when exercising fsx
 * common/rc: create a wrapper for the su command
 * common: fix pkill by running test program in a separate session
 * unmount: resume logging of stdout and stderr for filtering
 * mkfs: don't hardcode log size
 * common/xfs: find loop devices for non-blockdevs passed to _prepare_for_eio_shutdown
 * preamble: fix missing _kill_fsstress
 * generic/650: revert SOAK DURATION changes
 * generic/032: fix pinned mount failure
 * fuzzy: stop __stress_scrub_fsx_loop if fsx fails
 * fuzzy: don't use readarray for xfsfind output
 * fuzzy: always stop the scrub fsstress loop on error
 * fuzzy: port fsx and fsstress loop to use --duration
 * common/rc: don't copy fsstress to $TEST_DIR
 * fix _require_scratch_duperemove ordering
 * fsstress: fix a memory leak
 * fsx: fix leaked log file pointer
 * build: initialize stack variables to zero by default
---
 check                 |   43 +++++++++++++++++++---
 common/fuzzy          |   95 ++++++++++++++++++++++++++++++++-----------------
 common/metadump       |   42 ++++++++++------------
 common/preamble       |    2 +
 common/quota          |    2 +
 common/rc             |   93 +++++++++++++++++++++++++++++++++++++++++-------
 common/reflink        |    6 ++-
 common/xfs            |    6 +++
 configure.ac          |    1 +
 include/builddefs.in  |    3 +-
 ltp/fsstress.c        |    1 +
 ltp/fsx.c             |    1 +
 m4/package_libcdev.m4 |   14 +++++++
 src/xfsfind.c         |   14 ++++++-
 tests/generic/019     |    2 +
 tests/generic/032     |    9 +++++
 tests/generic/050     |    2 +
 tests/generic/085     |    2 +
 tests/generic/093     |    2 +
 tests/generic/125     |    2 +
 tests/generic/128     |    2 +
 tests/generic/193     |   36 +++++++++----------
 tests/generic/230     |   14 ++++---
 tests/generic/231     |    2 +
 tests/generic/233     |    2 +
 tests/generic/270     |   12 ++++--
 tests/generic/310     |    6 ++-
 tests/generic/314     |    2 +
 tests/generic/327     |    2 +
 tests/generic/328     |    4 +-
 tests/generic/355     |    2 +
 tests/generic/361     |    4 +-
 tests/generic/453     |    6 ++-
 tests/generic/476     |    2 +
 tests/generic/514     |    2 +
 tests/generic/530     |    6 +--
 tests/generic/531     |    6 +--
 tests/generic/561     |    2 +
 tests/generic/573     |    2 +
 tests/generic/590     |    2 +
 tests/generic/600     |    2 +
 tests/generic/601     |    2 +
 tests/generic/603     |   10 +++--
 tests/generic/650     |    5 +--
 tests/generic/673     |    2 +
 tests/generic/674     |    2 +
 tests/generic/675     |    2 +
 tests/generic/680     |    2 +
 tests/generic/681     |    2 +
 tests/generic/682     |    2 +
 tests/generic/683     |    2 +
 tests/generic/684     |    2 +
 tests/generic/685     |    2 +
 tests/generic/686     |    2 +
 tests/generic/687     |    2 +
 tests/generic/688     |    2 +
 tests/generic/691     |    8 ++--
 tests/generic/721     |   10 +++--
 tests/generic/726     |    2 +
 tests/generic/727     |    2 +
 tests/generic/746     |    2 +
 tests/xfs/149         |    2 +
 tests/xfs/501         |    2 +
 tests/xfs/502         |    2 +
 tests/xfs/530         |    2 +
 tests/xfs/720         |    2 +
 tests/xfs/795         |    2 +
 tests/xfs/803         |    2 +
 68 files changed, 347 insertions(+), 192 deletions(-)

