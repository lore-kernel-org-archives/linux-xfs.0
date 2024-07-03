Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8BB191F80
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043226; cv=none; b=dUEDpluXmHeS6YO/4N2VfAAAw6R5u5vx5X+5IXIVnouG7YC3J9lrcggx66cS/ej7c+QU+4kuCdjQre9ihoJIiNQOyTEkTO1IT37UNPWvRvNFyKalE46Fz6y+P3uY2Bj1/wALi6Q2x+Pm/3u7bc65hQAJPZTjqwpiUAOsk0iW484=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043226; c=relaxed/simple;
	bh=DvjCNd9dCw1BF6yXXZt6+fsrtj1UYBWfo9uIMj9cNhw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Y6Rk1IuHMY7ZQzlW2aQ4h2H1Js0FkEu2etOQCtgSd7VrT83a6W/+Tazdl/4XlhpMFgpDbWaAVBnGGSfhMf3vPvjjNSwgROtUkczazeVRVt0brulh0KwH2MoO5vc0NT0k2gGhorlLlN8VK3BI01Tew0sTm3znT9T+ECkpQ76ey70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fq+sr9aj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fq+sr9aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82485C2BD10;
	Wed,  3 Jul 2024 21:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043225;
	bh=DvjCNd9dCw1BF6yXXZt6+fsrtj1UYBWfo9uIMj9cNhw=;
	h=Date:Subject:From:To:Cc:From;
	b=Fq+sr9ajsl46py4E6/0mUFnF2DUSobafrzuYNy3/WVOZYKvvTthZ3VfAsHkST/fLI
	 XqnuSHh4wFUjpVxEHoWHTbrT39l9ZM0v+UkTF6p36RuExTb5GvHd87a/URkP3Ts4H7
	 eT9Alrz7YtVI09FgJgI34CAw0J18dAQH4zdo86/TTuYg4INWZiCug02w/3qFzh9kJE
	 lN2/Um04lZp+hdWFPII9DiNvdBxSJU10okx2/RSKVuljVaUIvG2iF7p5KYAC0mBHNE
	 XZ77IZ+oLKv8blc/wtK9mT8LmaUxF2z/i3W/7+wiqbwFWmbQRdGOM5PR2upNRAbj8C
	 T2I0EKe+iPqgw==
Date: Wed, 03 Jul 2024 14:47:04 -0700
Subject: [PATCHSET v30.8] xfs_scrub: use free space histograms to reduce
 fstrim runtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
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

This patchset dramatically reduces the runtime of the FITRIM calls made
during phase 8 of xfs_scrub.  It turns out that phase 8 can really get
bogged down if the free space contains a large number of very small
extents.  In these cases, the runtime can increase by an order of
magnitude to free less than 1% of the free space.  This is not worth the
time, since we're spending a lot of time to do very little work.  The
FITRIM ioctl allows us to specify a minimum extent length, so we can use
statistical methods to compute a minlen parameter.

It turns out xfs_db/spaceman already have the code needed to create
histograms of free space extent lengths.  We add the ability to compute
a CDF of the extent lengths, which make it easy to pick a minimum length
corresponding to 99% of the free space.  In most cases, this results in
dramatic reductions in phase 8 runtime.  Hence, move the histogram code
to libfrog, and wire up xfs_scrub, since phase 7 already walks the
fsmap.

We also add a new -o suboption to xfs_scrub so that people who /do/ want
to examine every free extent can do so.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram
---
Commits in this patchset:
 * libfrog: hoist free space histogram code
 * libfrog: print wider columns for free space histogram
 * libfrog: print cdf of free space buckets
 * xfs_scrub: don't close stdout when closing the progress bar
 * xfs_scrub: remove pointless spacemap.c arguments
 * xfs_scrub: collect free space histograms during phase 7
 * xfs_scrub: tune fstrim minlen parameter based on free space histograms
---
 db/freesp.c          |   89 ++++------------
 libfrog/Makefile     |    2 
 libfrog/histogram.c  |  270 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h  |   78 ++++++++++++++
 man/man8/xfs_scrub.8 |   16 +++
 scrub/phase7.c       |   47 ++++++++-
 scrub/phase8.c       |   91 ++++++++++++++++-
 scrub/spacemap.c     |   11 +-
 scrub/vfs.c          |    4 +
 scrub/vfs.h          |    2 
 scrub/xfs_scrub.c    |   45 ++++++++
 scrub/xfs_scrub.h    |   16 +++
 spaceman/freesp.c    |   99 ++++++------------
 13 files changed, 620 insertions(+), 150 deletions(-)
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h

