Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC4619C55E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738880977; cv=none; b=ZwqIymMccT0v3FDZ6Z1GB/nA0nxNR6IQj4xDR8Sp0ger9G5lS+zhD7yDhtZYwafrlegUTj78d5kGH6gFFiU2nMLfAYf2J+fdOdDQajsOBO1FaK1zLiU0qn837Zo9Y3olAVvB9T+lEIbtzJyDGFHhBoaMgdHcmgGS20vkot77zdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738880977; c=relaxed/simple;
	bh=dbUrM0PBxO4C8gw/h4hnPetN8LbCa0ZiPaBZqPk4ntI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uRKa20A5NwzX7EnJXUEnxYkPfVHEZ1TdoFw2DWYR+AbCQci2cYqeYiBwy4m5UY4+GlCHB/AmESTyuExTMWOSqPrnZYMrHAHMcFbt2j37NiTxw1sBuSDtMHmYBfJm+1y33lHNwoqTkALjOZmaKxmz/u3XxB38QjF910btM4fGBW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBUD6vyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBUD6vyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8B9C4CEDD;
	Thu,  6 Feb 2025 22:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738880976;
	bh=dbUrM0PBxO4C8gw/h4hnPetN8LbCa0ZiPaBZqPk4ntI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pBUD6vyHLqOUS04LuRC250kR1fn16/rzTH8U+/sK77V++a0iSxZjVs3Uj4EbyBPqC
	 NG3iXOBARp2BQC1vpAbujhVG2uOYg/kXBWK9idIpckEL8zQAr2TzD+AiPNM3fqLF98
	 vEh6QglbnXMce35H7687kHXXXmNsJSqlV0HwHnpn2bwz7nDmX33ZAD4+zdd4bnezD4
	 63cYMJlEgD5QmgdhYcZZSpNy8Fsiu7UrMYCFM2xGJSZ+LWRYp/ZK0wdpB5y6TCbiy+
	 GOTcGU6yuykKpVwpFRBBlIZFiAxu4fGaONgqsComoK8jvdXE4DcWNPN46TlcNGBfUv
	 DCx+mV2IcZiJg==
Date: Thu, 06 Feb 2025 14:29:36 -0800
Subject: [PATCHSET 1/5] xfs_scrub: fixes and cleanups for inode iteration
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
In-Reply-To: <20250206222122.GA21808@frogsfrogsfrogs>
References: <20250206222122.GA21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Christoph and I were investigating some performance problems in
xfs_scrub on filesystems that have a lot of rtgroups, and we noticed
several problems and inefficiencies in the existing inode iteration
code.

The first observation is that two of the three callers of
scrub_all_inodes (phases 5 and 6) just want to walk all the user files
in the filesystem.  They don't care about metadir directories, and they
don't care about matching inumbers data to bulkstat data for the purpose
of finding broken files.  The third caller (phase 3) does, so it makes
more sense to create a much simpler iterator for phase 5 and 6 that only
calls bulkstat.

But then I started noticing other problems in the phase 3 inode
iteration code -- if the per-inumbers bulkstat iterator races with other
threads that are creating or deleting files we can walk off the end of
the bulkstat array, we can miss newly allocated files, miss old
allocated inodes if there are newly allocated ones, pointlessly try to
scan deleted files, and redundantly scan files from another inobt
record.

These races rarely happen, but they all need fixing.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-inode-iteration-fixes
---
Commits in this patchset:
 * libxfs: unmap xmbuf pages to avoid disaster
 * libxfs: mark xmbuf_{un,}map_page static
 * man: document new XFS_BULK_IREQ_METADIR flag to bulkstat
 * libfrog: wrap handle construction code
 * xfs_scrub: don't report data loss in unlinked inodes twice
 * xfs_scrub: call bulkstat directly if we're only scanning user files
 * xfs_scrub: remove flags argument from scrub_scan_all_inodes
 * xfs_scrub: selectively re-run bulkstat after re-running inumbers
 * xfs_scrub: actually iterate all the bulkstat records
 * xfs_scrub: don't double-scan inodes during phase 3
 * xfs_scrub: don't (re)set the bulkstat request icount incorrectly
 * xfs_scrub: don't complain if bulkstat fails
 * xfs_scrub: return early from bulkstat_for_inumbers if no bulkstat data
 * xfs_scrub: don't blow away new inodes in bulkstat_single_step
 * xfs_scrub: hoist the phase3 bulkstat single stepping code
 * xfs_scrub: ignore freed inodes when single-stepping during phase 3
 * xfs_scrub: try harder to fill the bulkstat array with bulkstat()
---
 include/cache.h               |    6 
 io/parent.c                   |    9 -
 libfrog/Makefile              |    1 
 libfrog/bitmask.h             |    6 
 libfrog/handle_priv.h         |   55 ++++
 libxfs/buf_mem.c              |  159 +++++++++---
 libxfs/buf_mem.h              |    3 
 libxfs/cache.c                |   11 +
 man/man2/ioctl_xfs_bulkstat.2 |    8 +
 scrub/common.c                |    9 -
 scrub/inodes.c                |  552 ++++++++++++++++++++++++++++++++++++-----
 scrub/inodes.h                |   12 +
 scrub/phase3.c                |    7 -
 scrub/phase5.c                |   14 -
 scrub/phase6.c                |   14 +
 spaceman/health.c             |    9 -
 16 files changed, 726 insertions(+), 149 deletions(-)
 create mode 100644 libfrog/handle_priv.h

