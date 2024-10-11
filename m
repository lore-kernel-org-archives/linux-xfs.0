Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A7D23BB
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606999; cv=none; b=LTtWc7oJc/Z0VK6OQvF416gPaqATgHtf3yRyJlIzpvm+YdNAomHNiyI1N+9lb9dVc4V+vCLrPCPr0ArpqjItO/NtUQD6+nC3aR2ZNvlpPIZEDsp9oZUYH3kTOkzhIDyONZoK8DOCBvKBhMTmiHHfDTagX1033Nv+5lN/iF722gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606999; c=relaxed/simple;
	bh=iUsLdeT9CYqWy3BSO5FsYdfFmD7VB+8GvDg70L1+QB4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OpxChKld9mtRtlvMTFW9hHWGMQjJna0k0cKP6HpV6PQCWj+14n8IoS9co1ACR4wfHVzqmMOM+KZ//0e0YzVeuVYHr1bBYsKt1etVuNbNnhGtqcepGx/v/RRPGqNLmwlC2N8kmBlTuPaHlcDmQErwrje9D26Gk3kKP31NR3EMVzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Io1NdpiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Io1NdpiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF0EC4CEC5;
	Fri, 11 Oct 2024 00:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606999;
	bh=iUsLdeT9CYqWy3BSO5FsYdfFmD7VB+8GvDg70L1+QB4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Io1NdpiCPLhP32/U6FXSi1ZADcZi4/R/2UmQ4KvMmIKNPggfhrf2UHT87MrrnLbXx
	 /upUEI4ckQHLGgGwtY4eSds0xBFJ9DXBUL1s2EuOlJOc1R7XBJGQpMY8snCeMeGW01
	 YKoPfVM4lHI0kzSS4/i4HTiGVpIttvDaMT6I/nm/E0sf5hh0kJAM6QB5YWTzj7TO5B
	 IsF4VW7Aejw1YUAJKO6XQpHVI4rcjsA3IBbH1VRAAy+733z9ClbQU/+lrhRdouT0xn
	 xH2XKs9iLfj5cMK/0a2tatvPaceNum9xvSEcZ3p1pjBJkAUmD5GvwglHjfkKmg1EWk
	 CbmAetMg8lKhw==
Date: Thu, 10 Oct 2024 17:36:38 -0700
Subject: [PATCHSET v5.0 4/5] xfsprogs: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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

Store the quota files in the metadata directory tree instead of the
superblock.  Since we're introducing a new incompat feature flag, let's
also make the mount process bring up quotas in whatever state they were
when the filesystem was last unmounted, instead of requiring sysadmins
to remember that themselves.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir-quotas
---
Commits in this patchset:
 * libfrog: scrub quota file metapaths
 * xfs_db: support metadir quotas
 * xfs_repair: refactor quota inumber handling
 * xfs_repair: hoist the secondary sb qflags handling
 * xfs_repair: support quota inodes in the metadata directory
 * xfs_repair: try not to trash qflags on metadir filesystems
 * mkfs: add quota flags when setting up filesystem
---
 db/dquot.c               |   59 +++++++++++++----
 include/xfs_mount.h      |    1 
 libfrog/scrub.c          |   20 ++++++
 libxfs/init.c            |    2 -
 libxfs/libxfs_api_defs.h |    6 ++
 man/man8/mkfs.xfs.8.in   |   48 ++++++++++++++
 mkfs/xfs_mkfs.c          |  113 ++++++++++++++++++++++++++++++++
 repair/agheader.c        |  161 +++++++++++++++++++++++++---------------------
 repair/dinode.c          |   18 +++--
 repair/dir2.c            |   12 ++-
 repair/globals.c         |  111 ++++++++++++++++++++++++++++++--
 repair/globals.h         |   15 +++-
 repair/phase2.c          |    3 +
 repair/phase4.c          |  116 +++++++++++++++++----------------
 repair/phase6.c          |  128 +++++++++++++++++++++++++++++++++++--
 repair/quotacheck.c      |  118 ++++++++++++++++++++++++++++++----
 repair/quotacheck.h      |    3 +
 repair/sb.c              |    3 +
 repair/versions.c        |    9 +--
 repair/xfs_repair.c      |   13 +++-
 20 files changed, 753 insertions(+), 206 deletions(-)

