Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C86C146588
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307422; cv=none; b=F0s/SOd+sVBYW89nBqdrDMoJP8sMix0+fqkuJrLvnt3i8LBIIa9G8yFNNSApG8DqlmFFTkJtMkn5waTDQGJoyZ1NQR76h+ewQeBGldAb0pjJVtnH8x8obp7wjSUPYK7hK9+RyCeTEqML3Zt0viRtBUN6d2S9PmI9LdRkkqhB2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307422; c=relaxed/simple;
	bh=cH+8GrP6Pa8i9ssvFnLbYQQ+lZXAzzZ2O7E0iMKiFSg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=N4WO+Ngyq/MgOb1NqgE0WV3nItvE08y0RlXI5UQWD938I2uUsoBDNxr4rH6ib6LDzBOHAevYZDGbCwo708phBHPt3VGjL9ZaklzBrgYpu0FqXyNlz3p2e/7QQoJgaYFSvW0yY5FNHq6H9dT16GKzoZrA82Q5Pn+QDXmsV8CO8nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GorZz2QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GorZz2QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B7CC32786;
	Tue, 30 Jul 2024 02:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307422;
	bh=cH+8GrP6Pa8i9ssvFnLbYQQ+lZXAzzZ2O7E0iMKiFSg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GorZz2QTbFdRqniUTmqEMUqWUsUWRN3fPVBeismJMCjLeOEnkQGfULttRv0PulEHD
	 oP4cqeHQuqfzP5hT9b1/Fo4+FlbfKo9Js81a//iCxIOHTWXSPN4dZCAg3hM5gFBEwk
	 4RO1Pea5BqSR1IreKaJoNJT46FbJvsFpePPIK8IjzEUgrwCtYNtpDAU/sVt3Cb5Dtm
	 tfTZwk6M2AGTRB+AXaLDNG/LJj9NlaCUYGb/u6KBhTagb+kRy5XHpFsnrt45iw6J4/
	 RE44SR2gUaCYqL1rMWQGH1aFUoB2m/693d/CuHfTJe5IeAf+Eg4HMwgTyo+bDWCG9j
	 mxwY9kSHGD4pQ==
Date: Mon, 29 Jul 2024 19:43:41 -0700
Subject: [GIT PULL 13/23] xfs_scrub: use free space histograms to reduce fstrim runtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459074.1455085.705786233665014114.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 5ccdd24dc9987b50333332b7381ff1a305e67ef7:

xfs_scrub: improve responsiveness while trimming the filesystem (2024-07-29 17:01:09 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-fstrim-minlen-freesp-histogram-6.10_2024-07-29

for you to fetch changes up to 34bed605490f936c3ead49e2e1cad78505260461:

xfs_scrub: tune fstrim minlen parameter based on free space histograms (2024-07-29 17:01:09 -0700)

----------------------------------------------------------------
xfs_scrub: use free space histograms to reduce fstrim runtime [v30.9 13/28]

This patchset dramatically reduces the runtime of the FITRIM calls made
during phase 8 of xfs_scrub.  It turns out that phase 8 can really get
bogged down if the free space contains a large number of very small
extents.  In these cases, the runtime can increase by an order of
magnitude to free less than 1%% of the free space.  This is not worth the
time, since we're spending a lot of time to do very little work.  The
FITRIM ioctl allows us to specify a minimum extent length, so we can use
statistical methods to compute a minlen parameter.

It turns out xfs_db/spaceman already have the code needed to create
histograms of free space extent lengths.  We add the ability to compute
a CDF of the extent lengths, which make it easy to pick a minimum length
corresponding to 99%% of the free space.  In most cases, this results in
dramatic reductions in phase 8 runtime.  Hence, move the histogram code
to libfrog, and wire up xfs_scrub, since phase 7 already walks the
fsmap.

We also add a new -o suboption to xfs_scrub so that people who /do/ want
to examine every free extent can do so.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
libfrog: hoist free space histogram code
libfrog: print wider columns for free space histogram
libfrog: print cdf of free space buckets
xfs_scrub: don't close stdout when closing the progress bar
xfs_scrub: remove pointless spacemap.c arguments
xfs_scrub: collect free space histograms during phase 7
xfs_scrub: tune fstrim minlen parameter based on free space histograms

db/freesp.c          |  89 +++++------------
libfrog/Makefile     |   2 +
libfrog/histogram.c  | 270 +++++++++++++++++++++++++++++++++++++++++++++++++++
libfrog/histogram.h  |  77 +++++++++++++++
man/man8/xfs_scrub.8 |  16 +++
scrub/phase7.c       |  47 ++++++++-
scrub/phase8.c       |  91 ++++++++++++++++-
scrub/spacemap.c     |  11 +--
scrub/vfs.c          |   4 +-
scrub/vfs.h          |   2 +-
scrub/xfs_scrub.c    |  45 ++++++++-
scrub/xfs_scrub.h    |  16 +++
spaceman/freesp.c    |  99 +++++++------------
13 files changed, 619 insertions(+), 150 deletions(-)
create mode 100644 libfrog/histogram.c
create mode 100644 libfrog/histogram.h

