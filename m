Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596C4D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881594; cv=none; b=ai/H1+lApvu28GfhnZUE1Ndq25IOTbnPXVEb7sncwqaPQHU1DsHqLf1+RzjMGRee9bYwCA99zBXGxWKw5pDTKzfmtUn1Q3uUvRtM0fh0A0xTT0BY6jvrjMUbtoTfUEpa/pfTRb8sjpQd0Jn91ntQv04g/wJxA0un5w1/wf0aSt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881594; c=relaxed/simple;
	bh=8gvUDH7jjSua95MCwVPPCpjYbuGIdRnqTr+regVQkdI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTAmP0S35tdrV51aii6E8ZPZtgCPMiIPgRnGo5123qJGIUVk3ep6LBiAB74MOiK9LDtFTZt9pv9ai9K4aCFBhPIO5lKrZKnj5u4PFGeOHHO741RrtSIbnXp4wAM6rKgIxLCJ+GWfdDy5ZGOKUlQzlL6/MRjXDha+YsEkKFI6hLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQnqEldl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQnqEldl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1205C116B1;
	Tue,  2 Jul 2024 00:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881593;
	bh=8gvUDH7jjSua95MCwVPPCpjYbuGIdRnqTr+regVQkdI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nQnqEldlr7pUsDxnCgAJHFpGk7i4T8Lx+1QkXgorRcKvuTfxpt+g4N24YDgoTWA82
	 +FaLudgdha737J2AOSkRLyFyHB6Zeo01NFB3DQhv9bVcLvSsVRHbhyuCmGekR3ZV6j
	 AnE5C/1Iq8uu04WC9btii9I6OR2CTAX1ZnLCgQW8m6DAuSqiTPmGypIuMhRDEXGFu7
	 kR0dqdMY4ptOsIdrudyd7s3tfn8RfaKn688ZOaUFSCd9fUUbrZbo+gop67DNFH82uB
	 tTqe7XYDZB0eXNdGaL8pV1djGP3XNXEHQ2mbb+o6j4GUiLJPq0N8YxozY+ZAkelqoD
	 l5wrelUzh2wvQ==
Date: Mon, 01 Jul 2024 17:53:13 -0700
Subject: [PATCHSET v30.7 15/16] xfs_scrub: vectorize kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

