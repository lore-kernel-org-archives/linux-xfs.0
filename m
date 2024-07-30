Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379B0144312
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307375; cv=none; b=q9nZjLz4CD/rA7CbWjL9I/k69tFY6m/mYYa0TeIznmhgM5MX8Lx600HlZdVsXQDNfJr5whUbeSLdJq/ImpkspD6JH6N/1MBw32CfGZddIO/pSfVNW3krHeYkn+McOZiib+gwHbntpE+hYuDDefEX9dS8e60aBlt757zxYDRiXSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307375; c=relaxed/simple;
	bh=5v/Z6no3e3dykoIL6rxtC4dvw+zZ0s+MsCenOQJEjSY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=NqmpaXYdVJuCOFQIaR8c8YWx5icTHrXhhBeSUqXqLeaEvkEE8uz6JzNWfF1XJvpUHHfWmeRoIZalKrT2R0oem5eWHWx2d9vlKABK+OcQ3g/5SRdSE3VWcwSnRM3EGLktnzXsDVefMgTkSNA+ay/xVO8Ec9VYbvpgXOab8Sp7h+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8Z1yStr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8Z1yStr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFC3C32786;
	Tue, 30 Jul 2024 02:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307375;
	bh=5v/Z6no3e3dykoIL6rxtC4dvw+zZ0s+MsCenOQJEjSY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R8Z1yStrrGQPT2gN5ZP9iUX2uwaVI6cScqB1bX3kXuL5tJbkB8MTpg1i6hnrwoAtE
	 UHT6Jc9QptPEQRbk8LOLb3SWUNQRh27dY6EA+cYO746fkiW2A2TDsTBVXngn+HYIMF
	 zzmmJRajSK89+kcJ1yiPDa/lSn+CHEktZ0DxtBK46Es2WoiUuETB7WsRq7Lt3hsQpa
	 Imo0c1e2ywt14Q3zev/I+q2wipMuChnt1IidsH4nz9unOqwVqybFbUiGMRDPzm7WIt
	 y4/2B4Jzq0UUdoY1TM0wD2iz/YhySzhHaxgxzlFMVDYhDdY5uIYBydXAw2R/a/s8xl
	 DZGH4AwpHC7+Q==
Date: Mon, 29 Jul 2024 19:42:54 -0700
Subject: [GIT PULL 10/23] xfs_scrub: improve scheduling of repair items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230458756.1455085.11655778070760827192.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 8dd67c8eccbe0e6b8dd7975ba53f9ccaf532aa9c:

xfs_scrub: hoist scrub retry loop to scrub_item_check_file (2024-07-29 17:01:08 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-repair-scheduling-6.10_2024-07-29

for you to fetch changes up to 474ff27d466c053f1cd51024e6b0c5a741a2d4bd:

xfs_scrub: try to repair space metadata before file metadata (2024-07-29 17:01:08 -0700)

----------------------------------------------------------------
xfs_scrub: improve scheduling of repair items [v30.9 10/28]

Currently, phase 4 of xfs_scrub uses per-AG repair item lists to
schedule repair work across a thread pool.  This scheme is suboptimal
when most of the repairs involve a single AG because all the work gets
dumped on a single pool thread.

Instead, we should create a thread pool with the same number of workers
as CPUs, and dispatch individual repair tickets as separate work items
to maximize parallelization.

However, we also need to ensure that repairs to space metadata and file
metadata are kept in separate queues because file repairs generally
depend on correctness of space metadata.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
libfrog: enhance ptvar to support initializer functions
xfs_scrub: improve thread scheduling repair items during phase 4
xfs_scrub: recheck entire metadata objects after corruption repairs
xfs_scrub: try to repair space metadata before file metadata

libfrog/ptvar.c       |   9 +-
libfrog/ptvar.h       |   4 +-
scrub/counter.c       |   2 +-
scrub/descr.c         |   2 +-
scrub/phase1.c        |  15 +++-
scrub/phase2.c        |  23 ++++-
scrub/phase3.c        | 106 ++++++++++++++--------
scrub/phase4.c        | 244 +++++++++++++++++++++++++++++++++++++-------------
scrub/phase7.c        |   2 +-
scrub/read_verify.c   |   2 +-
scrub/repair.c        | 172 ++++++++++++++++++++++-------------
scrub/repair.h        |  37 ++++++--
scrub/scrub.c         |   5 +-
scrub/scrub.h         |  10 +++
scrub/scrub_private.h |   2 +
scrub/xfs_scrub.h     |   3 +-
16 files changed, 455 insertions(+), 183 deletions(-)

