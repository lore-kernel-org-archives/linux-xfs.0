Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9480A17E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371064; cv=none; b=pYChnuhUReEJmXvuNTLsv0p/zBcguw6Q1t54lU4UN6gFV8nj56IgmdH4noeM9UvI6vzEZ51ac+nCYxIqMRmhCmbLICVRaYnxpIqUluy5KluaO9M1s89ICBXNg5WMF+EtyboIfcgKxbDnfGXhc0zeVGyBf14rVP4UJIr8UC3lpwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371064; c=relaxed/simple;
	bh=iJX8pD1K+wawZm0D+nFyDQMN8mNLDmxcOAJEoWHQVY0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGVhehK0sTkpnaRZNKF4sfFIUIWuf2eOyTc6EjXCrHoe6Cnx3h8ZT1qsTK57KzIINFAxFN1N3Rkmqfgv6PcmX/DjayaOjXiDrbL7CppuSfi4MJXr1hSMrzKLkAc1aXZvdF8HZzeUNvHIlwopliITvxa0wOHjOVUKycQ9scXELN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VkdwHzVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkdwHzVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2A6C32782;
	Thu, 22 Aug 2024 23:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371064;
	bh=iJX8pD1K+wawZm0D+nFyDQMN8mNLDmxcOAJEoWHQVY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VkdwHzVzpDUVJh5apdyx1etD0o56UpVF2mgP1cEnWw2IISvSsMFEMxfFnEqdU7bfp
	 Od/LtiDLhPYN45cN+AKC7EKM971YrA0UWTGKYioYQiH7MfkcwQFxECsMr6wLAMnaBW
	 TsZvlYyIVUCK9lvuMICB1ZMWnSdWE4Ijto4xusUIPWc2Dp7K3kmuOHfCf1b8bJu9y/
	 a2vnGAkCZqSnMIN7oi7jiatr2QkZoDeWebr6pLD/RDhhzKJolbeayV0iKKv/vp908N
	 tNBlvWcDZtI1CMWF7utIAqEHh8b+Id0cKQpugpPz7jYvCeHkF4cbFGgYyhjkzxvVqZ
	 xqbsQQnOrtzfA==
Date: Thu, 22 Aug 2024 16:57:43 -0700
Subject: [PATCHSET v4.0 06/10] xfs: fixes and cleanups for the realtime
 allocator
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086590.59070.9398644715198875909.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
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

While I was reviewing how to integrate realtime allocation groups with
the rt allocator, I noticed several bugs in the existing allocation code
with regards to calculating the maximum range of rtx to scan for free
space.  This series fixes those range bugs and cleans up a few things
too.

I also added a few cleanups from Christoph.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtalloc-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rtalloc-fixes
---
Commits in this patchset:
 * xfs: use the recalculated transaction reservation in xfs_growfs_rt_bmblock
 * xfs: ensure rtx mask/shift are correct after growfs
 * xfs: don't return too-short extents from xfs_rtallocate_extent_block
 * xfs: don't scan off the end of the rt volume in xfs_rtallocate_extent_block
 * xfs: refactor aligning bestlen to prod
 * xfs: clean up xfs_rtallocate_extent_exact a bit
 * xfs: reduce excessive clamping of maxlen in xfs_rtallocate_extent_near
 * xfs: fix broken variable-sized allocation detection in xfs_rtallocate_extent_block
 * xfs: remove xfs_rtb_to_rtxrem
 * xfs: simplify xfs_rtalloc_query_range
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   51 ++++++---------
 fs/xfs/libxfs/xfs_rtbitmap.h |   21 ------
 fs/xfs/libxfs/xfs_sb.c       |   12 +++
 fs/xfs/libxfs/xfs_sb.h       |    2 +
 fs/xfs/xfs_discard.c         |   15 ++--
 fs/xfs/xfs_fsmap.c           |   11 +--
 fs/xfs/xfs_rtalloc.c         |  145 +++++++++++++++++++++++-------------------
 7 files changed, 124 insertions(+), 133 deletions(-)

