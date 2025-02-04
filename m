Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EC225A62C;
	Tue,  4 Feb 2025 21:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704148; cv=none; b=Vqc1mrLIzyAYw6ChxsnLV7GRwcYAmmareS231VZNz2lB1RkzKY5i1QvZHLaVLaVzaMrUzO6gVUQjR7VFZ4bgskPQ9jw7OQUMfR1sJ0QgFqQtHhXaCjsCZ7KWakav5ODqyp2cAPR4c1utp+6Xj5Pi6aILGx3IC4ZgSzaa5lPiVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704148; c=relaxed/simple;
	bh=yHGSzj1eCEAAlea1U8aWvMTeQXKnlBJYnyaW0djzLKo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=VuA6MKgF971fcG9XbDnwaDjvLWVVXQYhoehEGhsqixERkhVroGjyJnMsNAejjnAgUgW8d4SceR50Iak0mJVyFN2CoyVc+AqD1Qa3phWNelOQCeuD5CjQhVw8FYqMM5wf+dEu+cNlFDlCWwf96tnCrGKTVYBjrYystSSS3qxUuhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jz48GZWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jz48GZWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2263DC4CEDF;
	Tue,  4 Feb 2025 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704148;
	bh=yHGSzj1eCEAAlea1U8aWvMTeQXKnlBJYnyaW0djzLKo=;
	h=Date:Subject:From:To:Cc:From;
	b=Jz48GZWWh46JXtUcLTF0ot8nd7Mp5MQ2uxgrv7aJSxIa8+2R7S1fOnb0mqz3z0p7n
	 SN+oXH/T+LmUG2++y7WhV2TrCbQh5CDYL9LRwMhSbgnGf13mCTRfokguvF4W5F+vQC
	 GnLI0U21CQeXAgwgNU2JaVHtxFLyAVnq83BOelpLRvOI64wjVDqgB4q9cGmyAFuxnY
	 mwXbEX4TiTO1emTisCVWLPTXz3TfEYkLqQjLdQXG+rICROLKv26oxtZtiWLy3pEEAO
	 nhJysxn6oKH14ZQCXUiAIn1Mflgcx9QqqQK3gaGl09Tt+PRz/gCve/MJpJypCrOwVA
	 Wro4oaMVcMnvA==
Date: Tue, 04 Feb 2025 13:22:27 -0800
Subject: [PATCHSET v2] fstests: random fixes for v2025.02.02
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, joannelkoong@gmail.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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
subprocesses.  I wasn't completely sold on that approach, but it works
for me.  A better approach is to run each test in a separate pid and
mount namespace, but then kernel support for that becomes a hard
requirement.  Both approaches seems to work for check and
check-parallel, though I've not tested that all that much.

Note: I am /not/ happy about Dave's RFC going straight to for-next
without even a complete review right before everyone went on PTO for
several weeks for xmas/solar new year.  But in the interests of getting
QA back on line for myself and everyone else who's having problems, here
it is.

At this point this series has accumulated even more bug fixes: an
unexplained insertion of -R in a umount command; fixes for the new
generic/759 hugepages IO test, fixes to the pptr size calculations in
common/fuzzy, memory consumption reductions in scrub fsstress tests,
fixes for excessive fsstress ops scaling, and some cleanups to how we
locate the fsstress and fsx binaries.

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
 * generic/019: don't fail if fio crashes while shutting down
 * fuzzy: do not set _FSSTRESS_PID when exercising fsx
 * common/rc: revert recursive unmount in _clear_mount_stack
 * common/dump: don't replace pids arbitrarily
 * common/populate: correct the parent pointer name creation formulae
 * generic/759,760: fix MADV_COLLAPSE detection and inclusion
 * generic/759,760: skip test if we can't set up a hugepage for IO
 * common/rc: create a wrapper for the su command
 * fuzzy: kill subprocesses with SIGPIPE, not SIGINT
 * common/rc: hoist pkill to a helper function
 * common: fix pkill by running test program in a separate session
 * check: run tests in a private pid/mount namespace
 * check: deprecate using process sessions to isolate test instances
 * common/rc: don't copy fsstress to $TEST_DIR
 * unmount: resume logging of stdout and stderr for filtering
 * mkfs: don't hardcode log size
 * common/rc: return mount_ret in _try_scratch_mount
 * preamble: fix missing _kill_fsstress
 * generic/650: revert SOAK DURATION changes
 * generic/032: fix pinned mount failure
 * fuzzy: stop __stress_scrub_fsx_loop if fsx fails
 * fuzzy: don't use readarray for xfsfind output
 * fuzzy: always stop the scrub fsstress loop on error
 * fuzzy: port fsx and fsstress loop to use --duration
 * fix _require_scratch_duperemove ordering
 * fsstress: fix a memory leak
 * fsx: fix leaked log file pointer
 * misc: don't put nr_cpus into the fsstress -n argument
 * common/config: add $here to FSSTRESS_PROG
 * config: add FSX_PROG variable
 * build: initialize stack variables to zero by default
---
 check                 |   89 +++++++++++++++++++++++++------
 common/config         |    5 +-
 common/dump           |    1 
 common/fuzzy          |  100 ++++++++++++++++++++++-------------
 common/metadump       |   42 +++++++--------
 common/populate       |   13 +++--
 common/preamble       |    2 -
 common/quota          |    2 -
 common/rc             |  141 ++++++++++++++++++++++++++++++++++++++++++-------
 common/reflink        |    6 +-
 configure.ac          |    1 
 include/builddefs.in  |    3 +
 ltp/fsstress.c        |    1 
 ltp/fsx.c             |    8 ++-
 m4/package_libcdev.m4 |   14 +++++
 src/nsexec.c          |   18 +++++-
 src/xfsfind.c         |   14 ++++-
 tests/generic/019     |    2 -
 tests/generic/032     |    9 +++
 tests/generic/050     |    2 -
 tests/generic/075     |    2 -
 tests/generic/085     |    2 -
 tests/generic/093     |    2 -
 tests/generic/112     |    2 -
 tests/generic/125     |    2 -
 tests/generic/127     |   16 +++---
 tests/generic/128     |    2 -
 tests/generic/193     |   36 ++++++-------
 tests/generic/230     |   14 ++---
 tests/generic/231     |    4 +
 tests/generic/233     |    2 -
 tests/generic/270     |   12 ++--
 tests/generic/310     |    6 +-
 tests/generic/314     |    2 -
 tests/generic/327     |    2 -
 tests/generic/328     |    4 +
 tests/generic/355     |    2 -
 tests/generic/361     |    4 +
 tests/generic/453     |    6 +-
 tests/generic/455     |    2 -
 tests/generic/456     |    2 -
 tests/generic/457     |    2 -
 tests/generic/469     |    2 -
 tests/generic/476     |    4 +
 tests/generic/499     |    2 -
 tests/generic/504     |   15 +++++
 tests/generic/511     |    2 -
 tests/generic/514     |    2 -
 tests/generic/530     |    6 --
 tests/generic/531     |    6 --
 tests/generic/561     |    2 -
 tests/generic/573     |    2 -
 tests/generic/590     |    2 -
 tests/generic/600     |    2 -
 tests/generic/601     |    2 -
 tests/generic/603     |   10 ++-
 tests/generic/642     |    2 -
 tests/generic/650     |    6 +-
 tests/generic/673     |    2 -
 tests/generic/674     |    2 -
 tests/generic/675     |    2 -
 tests/generic/680     |    2 -
 tests/generic/681     |    2 -
 tests/generic/682     |    2 -
 tests/generic/683     |    2 -
 tests/generic/684     |    2 -
 tests/generic/685     |    2 -
 tests/generic/686     |    2 -
 tests/generic/687     |    2 -
 tests/generic/688     |    2 -
 tests/generic/691     |    8 +--
 tests/generic/721     |   10 ++-
 tests/generic/726     |    2 -
 tests/generic/727     |    2 -
 tests/generic/746     |    2 -
 tests/generic/750     |    2 -
 tests/generic/759     |    7 +-
 tests/generic/760     |    7 +-
 tests/xfs/149         |    2 -
 tests/xfs/501         |    2 -
 tests/xfs/502         |    2 -
 tests/xfs/530         |    2 -
 tests/xfs/720         |    2 -
 tests/xfs/795         |    2 -
 tests/xfs/803         |    2 -
 tools/run_seq_pidns   |   28 ++++++++++
 tools/run_seq_setsid  |   22 ++++++++
 87 files changed, 546 insertions(+), 250 deletions(-)
 create mode 100755 tools/run_seq_pidns
 create mode 100755 tools/run_seq_setsid

