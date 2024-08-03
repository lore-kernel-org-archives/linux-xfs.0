Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E942747F;
	Sat,  3 Aug 2024 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722697007; cv=none; b=FmC04+6ZOl9jV7wWsyBv7m5DKgc5PVApez+PZcp4yv6UQm7Y6r/KqD7qPkLt+xYBHQ9q3e25+hqslZRGCZZNAM6ql8RhnmdbEPBjd+zAuIpDh6Uu0wZwiLNVMm575qmZrkENbHZv2lu8plPSrfp8Iy9dyRNM0kMjsKCXEuRGPhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722697007; c=relaxed/simple;
	bh=6M1fLpvH8Cu+8uwdOVhkvLYWG8eOFml1oe3uqDnefao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T/AxSQq9boKU3HgrUtbrIWEf56c5mje5VYTVMZNKimMeZwCCVI0oDWqaPcemwkclFC7pxDObdGD/5GjBTTnb+jpWaXbyqIcYEpHKpE5cr7rTzPOsK1cscPUJInO1uCPhoJ+kCnnhL35Je40ESJCiHLpTKKrT0c/BY5w6klzNtoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxZWomx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxZWomx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF7EC4AF0A;
	Sat,  3 Aug 2024 14:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722697006;
	bh=6M1fLpvH8Cu+8uwdOVhkvLYWG8eOFml1oe3uqDnefao=;
	h=From:To:Cc:Subject:Date:From;
	b=gxZWomx8nlVEZdtPchXt1qU76luF02foxl7AdCLKVsIGznFs1We36UGFofgn7zkT4
	 W2FMlcZSyLz/ej5zd/heLTDA8zKjf7KlobiQql9he4uymoQuV2DmUV5jivPXygp/6a
	 545fvfQCjvZU1SUc/W98bueAfKMH9GhiavEdPuLjpFFVoQZtzJnLnGSSF76qbrpblC
	 Am4mHj1YGfMO+OLtpT6YJ1g0cH0we6B/TPltJN3riFecbbnxCvfuajOBXnmonCu5LL
	 aMTRlFuW7PWV9v4j6yA58S6D362SzkCxWx5iICXAWSYet6MMkWSyT8peBldTzl33kD
	 UBaTtl0dkVBAQ==
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: torvalds@linux-foundation.org
Cc: chandanbabu@kernel.org,linux-fsdevel@vger.kernel.org,linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: bug fixes for 6.11
Date: Sat, 03 Aug 2024 20:20:49 +0530
Message-ID: <87ikwh1wpg.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Linus,

Please pull this branch which contains XFS bug fixes for 6.11-rc2. A brief
description of the fixes is provided below.

I did a test-merge with the main upstream branch as of a few minutes ago and
didn't see any conflicts.  Please let me know if you encounter any problems.

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.11-fixes-1

for you to fetch changes up to 7bf888fa26e8f22bed4bc3965ab2a2953104ff96:

  xfs: convert comma to semicolon (2024-07-29 09:34:18 +0530)

----------------------------------------------------------------
Bug fixes for 6.11-rc1:

  * Fix memory leak when corruption is detected during scrubbing parent
    pointers.
  * Allow SECURE namespace xattrs to use reserved block pool to in order to
    prevent ENOSPC.
  * Save stack space by passing tracepoint's char array to file_path() instead
    of another stack variable.
  * Remove unused parameter in macro XFS_DQUOT_LOGRES.
  * Replace comma with semicolon in a couple of places.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

----------------------------------------------------------------
Chen Ni (2):
      xfs: convert comma to semicolon
      xfs: convert comma to semicolon

Darrick J. Wong (2):
      xfs: fix a memory leak
      xfs: fix file_path handling in tracepoints

Eric Sandeen (1):
      xfs: allow SECURE namespace xattrs to use reserved block pool

Julian Sun (1):
      xfs: remove unused parameter in macro XFS_DQUOT_LOGRES

 fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c | 28 ++++++++++++++--------------
 fs/xfs/scrub/agheader_repair.c |  2 +-
 fs/xfs/scrub/parent.c          |  2 +-
 fs/xfs/scrub/trace.h           | 10 ++++------
 fs/xfs/xfs_attr_list.c         |  2 +-
 fs/xfs/xfs_trace.h             | 10 ++++------
 fs/xfs/xfs_xattr.c             | 19 ++++++++++++++++++-
 8 files changed, 44 insertions(+), 31 deletions(-)
