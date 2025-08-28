Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E0E226D18;
	Thu, 28 Aug 2025 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391282; cv=none; b=TdEvoRNzeFAGbj+baDEI1YW1c8a2KkgGdCyJexbLxGB+ktiPhoIjaMxV3lPZOgn+PrknlbEfLgmMz78W/JVRsB7VgRAhaEQZatBzBjyLcSXQ2CwB/8Y2t6KNztyy4vSSCSmWig90f8aHIXT7oL+QrGqQPEjBxE5v09+4tCWdkns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391282; c=relaxed/simple;
	bh=8Y1aM2Nx929N3/lsRZDxgK5NO9SlpyO8VfSG4BzWSpA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZXhZ+sQGd3D0Q3QqwPMlx0B3Z46lKAh8Jm0lJAu0WeyQRGP8weFwLmPLenI5guVyj3D+S7QPhtewAsHmyT0GfDyIOc3SnjJv/S37/Zjz1D5PPMpq+TDqZUbOapfvwleJUmSy1mu1SlybQG3yYRZ7yIU5vD+gIJ1MhdEprPRL68s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJODl3jE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJODl3jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAC2C4CEEB;
	Thu, 28 Aug 2025 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756391282;
	bh=8Y1aM2Nx929N3/lsRZDxgK5NO9SlpyO8VfSG4BzWSpA=;
	h=Date:Subject:From:To:Cc:From;
	b=rJODl3jEaU2U0T3t4tzoQ8N1F4M8UJDUBoL8GvTzdggYIv7y2M39XvinrkreCy/zS
	 XB2f4+92zvohDBUhI6p+ct1wFrufxE0Ne/ZXryJnYbDdTvbR0KdQtjCC+dC7oHN7nX
	 GxK15cw/LbiwQdTYuNRhc1PBahNjZ4t6Glhnezvzh/q4ogBbkdtvwaU4WbLcy3+nlV
	 E0nA9yh6S6HzJ6rUd4aaKtxhTihK9Wlb7IeG03RdG2cpyPOSOdGymqghpUpWVSMmg/
	 bzwa70D8DPSPiXSHo1de7XTXHq8/+/obtr8Gf/afdSRYxXaRHeow793Kds9Gh1bzuQ
	 +t4flYGYDwKOw==
Date: Thu, 28 Aug 2025 07:28:01 -0700
Subject: [PATCHSET] xfs: improve online repair reap calculations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

A few months ago, the multi-fsblock untorn writes patchset added a bunch
of log intent item helper functions to estimate the number of intent
items that could be added to a particular transaction.  Those helpers
enabled us to compute a safe upper bound on the number of blocks that
could be written in an untorn fashion with filesystem-provided out of
place writes.

Currently, the online fsck code employs static limits on the number of
intent items that it's willing to accrue to a single transaction when
it's trying to reap what it thinks are the old blocks from a corrupt
structure.  There have been no problems reported with this approach
after years of testing, but static limits are scary and gross because
overestimating the intent item limit could result in transaction
overflows and dead filesystems; and underestimating causes unnecessary
overhead.

This series uses the new log intent item size helpers to estimate the
limits dynamically based on worst-case per-block repair work vs. the
size of the scrub transaction.  After several months of testing this,
there don't seem to be any problems here either.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-scrub-reap-calculations
---
Commits in this patchset:
 * xfs: prepare reaping code for dynamic limits
 * xfs: convert the ifork reap code to use xreap_state
 * xfs: use deferred intent items for reaping crosslinked blocks
 * xfs: compute per-AG extent reap limits dynamically
 * xfs: compute data device CoW staging extent reap limits dynamically
 * xfs: compute realtime device CoW staging extent reap limits dynamically
 * xfs: compute file mapping reap limits dynamically
 * xfs: remove static reap limits
 * xfs: use deferred reaping for data device cow extents
---
 fs/xfs/scrub/repair.h |    8 -
 fs/xfs/scrub/trace.h  |   45 ++++
 fs/xfs/scrub/newbt.c  |    7 +
 fs/xfs/scrub/reap.c   |  622 +++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/scrub/trace.c  |    1 
 5 files changed, 552 insertions(+), 131 deletions(-)

