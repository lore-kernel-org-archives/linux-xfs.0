Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E7C13B58C;
	Fri, 22 Nov 2024 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294238; cv=none; b=WGFZjhyyMOBd/AER+6graf7Ifl7peLN55tpDXgt3wpT1mOvNEybw+IhmKwFVgVmODFxRBXRwRfQCqcuwwmbzH8flv8/l+aJ+FwDCJm9QLm0Lh6LrIPl9uuLoKBg0p1lIu6kvukt54vpm+psDMftk0dG4nhB4nMWkPSBzca8YFNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294238; c=relaxed/simple;
	bh=/8KWVHBerelS5vbg2dfJo8+YvnwL2ZaICDBMkbcRoqI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=u+LoudP5zEqcnZnJDCtgLYp7UVy4b0Qm/5NIsjpji27RTPGHhEG8pU1sBkLrK/BGnPJp0nP2WF753UJw0UDQZPNwtCVhxYSneRDiIeqVDn0xTlPSx6IKTTbxSoAZLUBxac1ENBggFcP/+h5WImvhI+ZghnbJnw5dHN3HWOFwyBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXTwWnYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXTwWnYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE67FC4CED0;
	Fri, 22 Nov 2024 16:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294237;
	bh=/8KWVHBerelS5vbg2dfJo8+YvnwL2ZaICDBMkbcRoqI=;
	h=Date:Subject:From:To:Cc:From;
	b=mXTwWnYYYrs3rvjfALlZn/cRLHvZmexcM5BZwmBX/nGIC6T3spZJPJJsOmKik2/7W
	 8JVSVBUK5hRXUFVfq1X49U5VhKD59++e/LHNJgyHfcGvUHcMM0RfWvWvTNn7gYGqFR
	 JDh08vFb6qCg3ER/thTb6wbafh6zZ9OUhRKIwr+MhvN/Ti+LbArkCmEH330ooFeXm0
	 JUUV90rgVsDnuH+2uihIFcL3/QM85+e8DUGrRi310NjOgtUntYS+vqjXAG0qYnhB+K
	 /0KvJEy2qHSbvomNF9EVALdokHNWnHjrehtcfAqNcn/bHKWblYBKQOQ7cw/jssham3
	 WBC5JgA1H5ozg==
Date: Fri, 22 Nov 2024 08:50:37 -0800
Subject: [PATCHSET v2] fstests: random fixes for v2024.11.17
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, zlang@kernel.org,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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
bug fixes that have been aging in my djwong-wtf branch forever.  Now
with more cleanups to the logwrites code and better loop control for
251, as discussed on the v1 patchset.

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
 * generic/757: fix various bugs in this test
 * generic/757: convert to thinp
 * logwrites: warn if we don't think read after discard returns zeroes
 * logwrites: use BLKZEROOUT if it's available
 * logwrites: only use BLKDISCARD if we know discard zeroes data
 * xfs/113: fix failure to corrupt the entire directory
 * xfs/508: fix test for 64k blocksize
 * common/rc: capture dmesg when oom kills happen
 * generic/562: handle ENOSPC while cloning gracefully
 * xfs/163: skip test if we can't shrink due to enospc issues
 * xfs/009: allow logically contiguous preallocations
 * generic/251: use sentinel files to kill the fstrim loop
 * generic/251: constrain runtime via time/load/soak factors
 * generic/251: don't copy the fsstress source code
 * common/rc: _scratch_mkfs_sized supports extra arguments
 * xfs/157: do not drop necessary mkfs options
 * generic/366: fix directio requirements checking
---
 common/dmlogwrites          |   39 ++++++++++++++++++++++++++++++++++++++-
 common/rc                   |   35 +++++++++++++++++++----------------
 src/log-writes/log-writes.c |   10 ++++++++++
 src/log-writes/log-writes.h |    1 +
 src/log-writes/replay-log.c |    8 ++++++++
 tests/generic/251           |   42 +++++++++++++++++++++---------------------
 tests/generic/366           |    2 +-
 tests/generic/562           |   10 ++++++++--
 tests/generic/757           |   26 ++++++++++++++++++++------
 tests/xfs/009               |   29 ++++++++++++++++++++++++++++-
 tests/xfs/113               |   33 +++++++++++++++++++++++++++------
 tests/xfs/157               |    3 +--
 tests/xfs/163               |    9 ++++++++-
 tests/xfs/508               |    4 ++--
 14 files changed, 192 insertions(+), 59 deletions(-)

