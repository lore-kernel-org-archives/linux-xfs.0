Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DD8B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUyjusFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6B2C433C7;
	Sun, 31 Dec 2023 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051660;
	bh=yqeUhj7q4Xs6/ULCCWJ1V8kiaFpiMOjgCb3fcpY/H+s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CUyjusFE+DXeWFIECEnmd9obeiaEm38wXaKoOep+VNBTRygtOKErJ8DpzFsf74DQA
	 CMc2LFmE+sD8eCloBtrudF38/bxSKE5NxK/4M3ykbq0TBARieqTreq3joJp2zWEsUU
	 XDYcQshmA4+fxHxJ+pbYwG8NkDGa9b0aYVTe8UZKCvfzO48kmbDMZlwJFdrdIToqUC
	 0d388esE+5CnEo3tSW4liu9+ljOm71Nhid4w810YXa3ER+nt8ZZg8xj+OD49pav2fi
	 WUr3mqq+9AhNFPqzPgwb6EAC8KUIOne1D4VnUN+iBz0Y1ohfoSXDJMYbvidvXkXMsu
	 Ab/IS/VaKu9Kg==
Date: Sun, 31 Dec 2023 11:40:59 -0800
Subject: [PATCHSET v29.0 05/40] xfsprogs: online repair of quota counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404990467.1793446.3205173493024934532.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

This series uses the inode scanner and live update hook functionality
introduced in the last patchset to implement quotacheck on a live
filesystem.  The quotacheck scrubber builds an incore copy of the
dquot resource usage counters and compares it to the live dquots to
report discrepancies.

If the user chooses to repair the quota counters, the repair function
visits each incore dquot to update the counts from the live information.
The live update hooks are key to keeping the incore copy up to date.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quotacheck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quotacheck
---
 io/scrub.c                      |    1 +
 libfrog/scrub.c                 |    5 +++++
 libfrog/scrub.h                 |    1 +
 libxfs/xfs_fs.h                 |    4 +++-
 libxfs/xfs_health.h             |    4 +++-
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 scrub/phase4.c                  |   17 ++++++++++++++++
 scrub/phase5.c                  |   22 +++++++++++++++++++-
 scrub/repair.c                  |    3 +++
 scrub/scrub.c                   |   42 +++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h                   |    2 ++
 scrub/xfs_scrub.h               |    1 +
 spaceman/health.c               |    4 ++++
 13 files changed, 105 insertions(+), 4 deletions(-)

