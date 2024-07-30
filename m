Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221D820E6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298933; cv=none; b=acWpPzAA7yk5xPHqdj0OGMsZgD8pB56OHbZzDihxDLoljSZpwxxuXIfN4bqO0J79xwRxHhDvgsaMVMqV2bahNfJA1+LlPw8Q0JdeMWpsNKkPu5WncYnOi8ZZpEJOHD+Bp9FAPJZqMO/N5kF153Nffo4mZR4+AndFBCfpv//3OcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298933; c=relaxed/simple;
	bh=qJdgy0K7y128CyGuB+119wnPmAIi9qF+Eos8PkJboEA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGeavwonaPZ30AxbZn31ROLLmqHIgBRNDjt0vdP2SWhtXnE4gjjIQs40p623p1JB4Enm1jNviHjFWRF0SfpQ+pdnLf/OrJaS6o2KESShBwRUbipnb0Kkx8MhGBTw6t51lbykM/aNGobmjfNLYg9mxjEYeFN7JrtNLpWfCmRsrNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EI5CANsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EI5CANsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB57AC32786;
	Tue, 30 Jul 2024 00:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298933;
	bh=qJdgy0K7y128CyGuB+119wnPmAIi9qF+Eos8PkJboEA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EI5CANslrCBHxAJRib3yodCtcTw0biX3+iA5THV3BumdKf0B6PY2By8VewWn2lUdA
	 ZorSCdq4mePK1uW4HQX3b+2nq42J5B/ym+n7yLRv11g0bCS56pqgiyr2WRMrLL/JOP
	 j//awULjr1LsG62flaKHH/9RpG/I8o4fRTi9d8VPp2FVfhDvjvsTDwDj9+yczTVp6i
	 0JhM0ZrHCda9pyK9xW4J4dOHmBqcwjxxFf6VfjiAv3kX4mZElxqTLACaaWm6hSLjic
	 zCwsaHDFYMj1bagfls8OaUqctdltPFuetOK9brIxiwuiNcDVPC9OLrNaY+lVC1lT7o
	 4TlyW8rvdoKAg==
Date: Mon, 29 Jul 2024 17:22:12 -0700
Subject: [PATCHSET v30.9 22/23] xfs_scrub: vectorize kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852355.1353240.6151017907178495656.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub-6.10
---
Commits in this patchset:
 * man: document vectored scrub mode
 * libfrog: support vectored scrub
 * xfs_io: support vectored scrub
 * xfs_scrub: split the scrub epilogue code into a separate function
 * xfs_scrub: split the repair epilogue code into a separate function
 * xfs_scrub: convert scrub and repair epilogues to use xfs_scrub_vec
 * xfs_scrub: vectorize scrub calls
 * xfs_scrub: vectorize repair calls
 * xfs_scrub: use scrub barriers to reduce kernel calls
 * xfs_scrub: try spot repairs of metadata items to make scrub progress
---
 io/scrub.c                           |  368 ++++++++++++++++++++++++++++++----
 libfrog/fsgeom.h                     |    6 +
 libfrog/scrub.c                      |  137 +++++++++++++
 libfrog/scrub.h                      |   35 +++
 man/man2/ioctl_xfs_scrubv_metadata.2 |  171 ++++++++++++++++
 man/man8/xfs_io.8                    |   51 +++++
 scrub/phase1.c                       |    2 
 scrub/phase2.c                       |   93 +++++++--
 scrub/phase3.c                       |   84 ++++++--
 scrub/repair.c                       |  355 +++++++++++++++++++++------------
 scrub/scrub.c                        |  360 +++++++++++++++++++++++++--------
 scrub/scrub.h                        |   19 ++
 scrub/scrub_private.h                |   55 +++--
 scrub/xfs_scrub.c                    |    1 
 14 files changed, 1431 insertions(+), 306 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_scrubv_metadata.2

