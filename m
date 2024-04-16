Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4273D76
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230466; cv=none; b=qKcmAefqCTv7V3gzgUfjStNmHsYUgPlZPZyDYqgfhRDjBCtkvGofhZXZ+5TczmaoL53iI56UUvoN5nXQmtd8sdC7uXifTFQiwu32YHmCXflEPI2eMGbx/QKaVOATI1uWVfnB5pRScIrvMG11xKgqMIl5pEMw1Dydc+i7hyi8gYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230466; c=relaxed/simple;
	bh=m6P+M0kbD964jsj2WWowQsD4kgt2ZEgL2YVM8Wv6gMw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wa7XJvf7lJy9wsE1LpaSyMeIQ6C/ose/Ep9JMKRlpmpbL7uQAOpEQXjiKIxo78S0y1faSBOwbwRVa8ETDW2QLkySkknBWNic5lm16E9EtcObZWPbV+7/rDr1dVdgi53Y9vmQQWinFyoWK8zBxKqYDTDWn3tC9fLJ8pSz2zaYe8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g58iySdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g58iySdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECBDC113CC;
	Tue, 16 Apr 2024 01:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230465;
	bh=m6P+M0kbD964jsj2WWowQsD4kgt2ZEgL2YVM8Wv6gMw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g58iySdkN55o0qfHK7ers4A2oKMrSUo880iYHyNLixg/pWUKN6TXbckaDNHoG3Wsv
	 hDBks+jK60/6kW9LAfG4p1AiJJh+5/gaZs7j4oykO2obyllKeu9y5QPtIrSoGglwN2
	 SwVx6oTVlId1WMuIK22ksdctVeNo7nkiEOGLpM7WAqK0sjlRaSgZW4v1eOEpo2aMne
	 ubbqhKtrRszglH10kIaMG1602t++CR/72bEGhBhnSU+m7nzv7xX/uCRRuv5Eo+55aS
	 3+2jZGVI+2wvLgMbGSkWg0pCDqhN5XYGBiEeBB5SwteTy0cNxPn4tNP+4RBwBZ8NuS
	 O2IcrSDhtp0vA==
Date: Mon, 15 Apr 2024 18:21:05 -0700
Subject: [PATCHSET v13.2 7/7] xfs: vectorize scrub kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416011640.GG11948@frogsfrogsfrogs>
References: <20240416011640.GG11948@frogsfrogsfrogs>
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

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
Commits in this patchset:
 * xfs: reduce the rate of cond_resched calls inside scrub
 * xfs: move xfs_ioc_scrub_metadata to scrub.c
 * xfs: introduce vectored scrub mode
 * xfs: only iget the file once when doing vectored scrub-by-handle
---
 fs/xfs/libxfs/xfs_fs.h   |   33 +++++++
 fs/xfs/scrub/common.h    |   25 -----
 fs/xfs/scrub/scrub.c     |  223 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h     |   64 +++++++++++++
 fs/xfs/scrub/trace.h     |   79 ++++++++++++++++
 fs/xfs/scrub/xfarray.c   |   10 +-
 fs/xfs/scrub/xfarray.h   |    3 +
 fs/xfs/scrub/xfile.c     |    2 
 fs/xfs/scrub/xfs_scrub.h |    6 +
 fs/xfs/xfs_ioctl.c       |   26 -----
 10 files changed, 412 insertions(+), 59 deletions(-)

