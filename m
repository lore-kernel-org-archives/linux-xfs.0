Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBE93358B0;
	Tue, 21 Jul 2026 03:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604222; cv=none; b=Cl0E8NioZaXmrtbk9ITczMgP0Zg7IXAyeryxDyleJ+4otu3zcGqb+qTZQy9Cdmv4QUDywY+sAb4YyvFB0BxD5Ml2fhL4rSDKzjlNQfgZDfcQOuACZEXYTidWAbgt8A+Wzc8WS0KekdZRRNMscPyudXjCqCwFjbjtXsV/DarpiN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604222; c=relaxed/simple;
	bh=eqEgTQle8FfwYn8tAo2b7L97nX6lJKPx7UVmKMQvimE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Hlz8wkNNlHUbZk0HV5LW2mWHVnQ1aPdaSlQzYaoVq8ARRwwimv1Sl4lRrerngxERbyf7DHD4EA5Ltz2skqmdmIvwS40iMLIT9ZhfSTt6QWWc8q+bZLGF4s4CGCeqPmr9i/5KlXp3/Q3wTL7rG7/2NNMdwnXy/UbZOY67IilxuLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hg/ftGWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hg/ftGWi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 712121F000E9;
	Tue, 21 Jul 2026 03:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604221;
	bh=6WwFlGGrSD9C32yPvWoiy5x8vlluORsxZNtXPzxJM9s=;
	h=Date:Subject:From:To:Cc;
	b=Hg/ftGWi+pg5ZcCUXH/V+RtTNgA94/18ggBggKXCQm8DeTIW/bsC/RukM0zzRhd5Y
	 nrkEe7ovdxD/fX5UlGJo0Oostan9XJ1vf5Si5eM3VwfRUqstAsGFXm+4sbce9jw8P9
	 xX2/xvyoNAPYSNgulOot4shLiLoBMmp5czJ33FJugHSN9oxtdi/SSJVWibAz/Y/TyW
	 ldxWSvQ65xMDoPgHrKbPVJFDtt/5eAOSrhk0kI/e6XK3LMnQm1J0rOK1EHfXwpFiEh
	 h2RkGRc2XCCyEypr6LBPGxXGTQLI/91VWAn6ugm75RrF8VxVsk07DObusvEwCfPSUL
	 +aPd6Z9iuooLA==
Date: Mon, 20 Jul 2026 20:23:41 -0700
Subject: [PATCHSET 2/2] xfs: LLM-inspired iunlink repair bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

These bugfixes got started as part of a series of assorted bug fixes.
However, in writing a test case to exercise weird corruption scenarios
I discovered a few more fixes, so I decided to collect them all in a
targeted series.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-iunlink
---
Commits in this patchset:
 * xfs: hoist per-bucket unlinked list check to helper
 * xfs: don't livelock in scrub on a circular unlinked list
 * xfs: don't walk off the end of a null sc->sa.agi_bp in AGI repair
 * xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
 * xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
 * xfs: check xfarray iteration errors when committing unlinked inode lists
 * xfs: fix allocated inodes that show up in the unlinked list
 * xfs: fix another iunlink infinite loop bug in online fsck
 * xfs: set the prev pointer when reinserting an inode on the unlinked list
---
 fs/xfs/scrub/trace.h           |    2 +
 fs/xfs/scrub/agheader.c        |   94 ++++++++++++++++++++++++++--------
 fs/xfs/scrub/agheader_repair.c |  110 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 170 insertions(+), 36 deletions(-)

