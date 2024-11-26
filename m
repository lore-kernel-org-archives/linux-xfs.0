Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F3D8F5B;
	Tue, 26 Nov 2024 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584017; cv=none; b=vFQKREY/tDY3pxLwTlseAvd/Oq0oCHnRlQP+lIin8R1qVf+PKHO2WObuRzjc3m2K+Ox8MHXxCC/i+cH30ZWMgAE2RfzsevtQBLEz0Y4tW7gwGzvIGwUYS1PJN131fDuJJf/LIznqWLQIQhQuSZnwJlyX+MGndDRGCB+Zq2PXZQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584017; c=relaxed/simple;
	bh=Ip1H1DWgoijBnzVKaipW4l8nd82suYuwnHmGC2CGmZY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RYk5eHK/ePS+LqRAYUhU/A94uecPNdz0TaPohCOyqvg33skbS4wkyxg3pY/epUHMuPzhlLbDeRkn0k23imIv96tPiWyx9dIDQe4VYq77Gdcm2Vb7VlNZwA8T8/XJmYiFwJ2t6m7JGumSvj48Pc/wlR7oOrjIs5m18/Bzr1kDL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBlQt5iM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBlQt5iM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867D2C4CECF;
	Tue, 26 Nov 2024 01:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584016;
	bh=Ip1H1DWgoijBnzVKaipW4l8nd82suYuwnHmGC2CGmZY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dBlQt5iMtSH2QqUmjOCjhkYezESmGXW+r582v1utvfijhTVZi6fRc/jDhN1rYlI28
	 FUBqi/Z22erAeP0cSEkxfCyjc4+LN5vcQZm78onrtSAjVNcwec/gsYyM235XJFpaLm
	 v3Gaj86rj8/2y7r6Bj3rAbxqeO5b/KCHglVt7IxejUvzp2SQfpHxuoOxDFwE1gms7O
	 iIFH+NxBwcMwuAynGd7iot5o75mLxw2ksvA5XCiWTGJABwJHwtEn/0iNqMyNlBd7Wi
	 nMmDBC0fH2eLfcDZ2IXQ5JqWv32Duv28BRuzLbPPWdUyZ8X2wTJZ9GFW0XAGuMgvuj
	 gsgzrVlE6jeTA==
Date: Mon, 25 Nov 2024 17:20:16 -0800
Subject: [PATCHSET v3] fstests: random fixes for v2024.11.17
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: tytso@mit.edu, hch@lst.de, zlang@kernel.org, fstests@vger.kernel.org,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
In-Reply-To: <20241126011838.GI9438@frogsfrogsfrogs>
References: <20241126011838.GI9438@frogsfrogsfrogs>
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

v2: Now with more cleanups to the logwrites code and better loop control
    for 251, as discussed on the v1 patchset.
v3: Add more acks, kick out some of the logwrites stuff, add more
    bugfixes.

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
 * generic/454: actually set attr value for llamapirate subtest
 * xfs/122: add tests for commitrange structures
---
 common/rc         |   35 +++++++++++++++++++----------------
 tests/generic/251 |   42 +++++++++++++++++++++---------------------
 tests/generic/366 |    2 +-
 tests/generic/454 |    8 ++++----
 tests/generic/562 |   10 ++++++++--
 tests/generic/757 |   26 ++++++++++++++++++++------
 tests/xfs/009     |   29 ++++++++++++++++++++++++++++-
 tests/xfs/113     |   33 +++++++++++++++++++++++++++------
 tests/xfs/122.out |    1 +
 tests/xfs/157     |    3 +--
 tests/xfs/163     |    9 ++++++++-
 tests/xfs/508     |    4 ++--
 12 files changed, 140 insertions(+), 62 deletions(-)

