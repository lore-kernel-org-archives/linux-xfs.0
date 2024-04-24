Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A04B13340B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929682; cv=none; b=G2qqOSf7pEM98b/YdeYIaK7YI6eXtnyItLBzoQFNAj4BnJyZst2JNtS2uwzJ0Xg67RcEkLfWH+VySxJfDu7WilNahFyq6++b7DayR3Lpi3Dyl4yFR35iaSyzvEc0GQzcEoNmaPiuKYtfc2mym+/Sdkh60uZe+BOZzDCKJheo98M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929682; c=relaxed/simple;
	bh=Oyt3BaF223uFAOKojHp++gOTw9S1IZzhCHt98yjkiaE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=IDVGJxgej8vem6+kZ2+Ux0B+dETS4z2WWNwY89dMuVD90SZs8ixovd4YVa7YAySanmeus3WcRZYOFwMpDhViwp25WT1mRRMYApay3GJsKBYBznRLQWCuoBxdLioSQeOBHbLFPbw1erqBIV3XKVSCkS/ponKzC8fAscfDgOIDrxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7+jIRJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7+jIRJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24A8C116B1;
	Wed, 24 Apr 2024 03:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929682;
	bh=Oyt3BaF223uFAOKojHp++gOTw9S1IZzhCHt98yjkiaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I7+jIRJ2a3jMheR9e+eojNcye6DxABS7X019NKwMyvJ/KM2AoFYXmxc5zZFp35cYm
	 BQ8R738YWG6nTpTaFwTcqbBp350yn0nofKXA/ioF/KntVTZocaFfeaKEgKGGGPutdo
	 3E0w7Z46XyW3rbHdgm7xMyMe19kW5xnVyPowR4DzUxKHVYj2DAxX/LFB8pzT1Ss96d
	 qw/fhfKDRPotvisiaEVsLD/2rTVvlb4GZZ+E2rnQj4DbA/vtDFZ9490r+PBtxg6ziy
	 lTs3cH0IHswyd61Iu4sUkg05SwfCIWY44DHVUMjhkEdY/6qlMAd03KLgryTgBSRUI4
	 nQxP+yezqa//A==
Date: Tue, 23 Apr 2024 20:34:41 -0700
Subject: [GIT PULL 4/9] xfs: scrubbing for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392951311.1941278.4476150123059380764.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 67ac7091e35bd34b75c0ec77331b53ca052e0cb3:

xfs: enable parent pointers (2024-04-23 07:47:01 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-pptrs-6.10_2024-04-23

for you to fetch changes up to 59a2af9086f0d60fc8de7346da67db7d764c7221:

xfs: check parent pointer xattrs when scrubbing (2024-04-23 07:47:03 -0700)

----------------------------------------------------------------
xfs: scrubbing for parent pointers [v13.4 4/9]

Teach online fsck to use parent pointers to assist in checking
directories, parent pointers, extended attributes, and link counts.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
xfs: revert commit 44af6c7e59b12
xfs: check dirents have parent pointers
xfs: deferred scrub of dirents
xfs: scrub parent pointers
xfs: deferred scrub of parent pointers
xfs: walk directory parent pointers to determine backref count
xfs: check parent pointer xattrs when scrubbing

fs/xfs/Makefile              |   2 +-
fs/xfs/libxfs/xfs_parent.c   |  22 ++
fs/xfs/libxfs/xfs_parent.h   |   5 +
fs/xfs/scrub/attr.c          |  27 +-
fs/xfs/scrub/common.h        |   1 +
fs/xfs/scrub/dir.c           | 342 ++++++++++++++++++++-
fs/xfs/scrub/nlinks.c        |  85 +++++-
fs/xfs/scrub/nlinks_repair.c |   2 +
fs/xfs/scrub/parent.c        | 685 +++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/readdir.c       |  78 +++++
fs/xfs/scrub/readdir.h       |   3 +
fs/xfs/scrub/trace.c         |   1 +
fs/xfs/scrub/trace.h         |  65 ++++
13 files changed, 1307 insertions(+), 11 deletions(-)

