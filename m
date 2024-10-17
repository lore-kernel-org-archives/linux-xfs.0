Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606F8218D84
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190848; cv=none; b=gQzGohgMMDR5JS/0F6SR9+8cc6aHjkRLBKAptRwJtEoJoYoeUYySHzPbQ/AlZFekscd6Lwv417uj/Hew4vad2yx+IBpldmTcIT2TToGSzAJKeb2J2nZfTlXd7HXvvKfXwkOyWtHFh3tgsnTjLHus7WIHneGc0t+LUix+C9tOYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190848; c=relaxed/simple;
	bh=4rZl83bSyuqybUOn3sQYbPKs8jmcN2Pk15Edki09M+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uz9xu6zdb2cGURtvMRTeO2fq2+qDFjm4K76g9Vw7siFitCAbcMBz2aajzyzw+JoiI5y+8Bj4yPHH2aeqMGtFcb/tDGoKLUtTvo/IGCqZ8AhuRojS2RuqgAQ4BZQ3IdN2zCHKHdacKEu6eue4i5q4uMisCSq1U3IVojPuHGmYo/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdqA5cbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdqA5cbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF80C4CEC3;
	Thu, 17 Oct 2024 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190848;
	bh=4rZl83bSyuqybUOn3sQYbPKs8jmcN2Pk15Edki09M+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TdqA5cbj/7fa8LiG3/Twvwbyg+E5E+1CItxlvl9CPXO2sR8iVurOGYN5yC75sl8KI
	 4Nu5gsh8W7of5dtrQMpQ/aavg9Il2C9aV+LHC9QjBOjTenonx+c66o7PZEdW6HnNh5
	 8fvTyS8rhmVnTo7dLYBjlCo6PntIFpVxOlp5hlpGVhrQjTzO6woSvrrqYZObS5J/rK
	 SM9edREaphdinftZy3eT0xCjP/Nxf+nhmOPtxYX2HDykZ5dUwBaZZSHMkZl/PrP/RT
	 bg8km6U91X/audu1LtdHcmSPIYhBjRpW3NS2mDdErad0FnKN/KnKgPHBFXG4x0QlQM
	 n31v6q8lR6BQA==
Date: Thu, 17 Oct 2024 11:47:27 -0700
Subject: [PATCHSET v5.1 7/9] xfs: persist quota options with metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072618.3454331.12971255439040173668.stgit@frogsfrogsfrogs>
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
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
 * xfs: refactor xfs_qm_destroy_quotainos
 * xfs: use metadir for quota inodes
 * xfs: scrub quota file metapaths
 * xfs: persist quota flags with metadir
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  190 ++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_fs.h         |    6 +
 fs/xfs/libxfs/xfs_quota_defs.h |   43 +++++++
 fs/xfs/libxfs/xfs_sb.c         |    1 
 fs/xfs/scrub/metapath.c        |   76 ++++++++++++
 fs/xfs/xfs_mount.c             |   15 ++
 fs/xfs/xfs_mount.h             |    6 +
 fs/xfs/xfs_qm.c                |  250 +++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_qm_bhv.c            |   18 +++
 fs/xfs/xfs_quota.h             |    2 
 fs/xfs/xfs_super.c             |   22 ++++
 11 files changed, 571 insertions(+), 58 deletions(-)

