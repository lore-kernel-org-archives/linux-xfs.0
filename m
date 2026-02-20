Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAD723B63C;
	Fri, 20 Feb 2026 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549205; cv=none; b=g3wBhvlZKVeg4Z1HUpgIjpYAt89A66dBxw8wH1W36RPYVmbid7wuiWIqez24sWw72vAvs4TjTe58bn4ifME+jO6kl5tUB9PZOhjTKS4j32A4BdEYI0vwWnY3tMCmPR3TWidLpgJAtND6Q2AtnnGzQvbFsNYCYbbWdhBQpAPjVY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549205; c=relaxed/simple;
	bh=5p7SbKqVircELTBuy2BmwTm1XnHnIBAJv2ZYxmBFy60=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=j7YTMAcv2ivtehrpvSK3Ojb7xG5jXlt6L73KH1m2UxwUnrnL6evTPlmaWw+kSHAh1SM18FEvgQwZAuMouTYUa1OYYTlc1+BDpf6Z31qcc6NMl8k4NvbR+Yh9gMpXPCLdY+SSieHiwRq8rPwNvJ1t3rz48k9mA/qTi/Jk+24Y/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azvdLG1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azvdLG1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B093CC4CEF7;
	Fri, 20 Feb 2026 01:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771549204;
	bh=5p7SbKqVircELTBuy2BmwTm1XnHnIBAJv2ZYxmBFy60=;
	h=Date:Subject:From:To:Cc:From;
	b=azvdLG1rE3gSwUuTeJueGUBh2AT4fZByrTzrbmKwQhXbuKh6XZIuTwBXhO3MqUN83
	 RsAUmtpG25VTQj1xiXXi8aGKXBd6pv4QcAdtMGHZWVfI+VzT8gHUKgYQaP9kQzZ/PW
	 8KTZMEH6cObC5gNJ5fRemBcQfMLPuyWN72KiYPNNVSEHFd/y3+xeepMDbVJ4FiYwjy
	 sN6vMlqEvDt68IklWZLK6y+qmIjfC00RA6gUSYnoNX4KjqtPw1jea/gpqCx20ia/hV
	 V1B+6vEP96LSLnllgUkByzood0bXxWYcIP67NQI4ZvsaZoCCRq9lnVQJVepg9qhU0j
	 gFodGPrxOTlow==
Date: Thu, 19 Feb 2026 17:00:04 -0800
Subject: [PATCHSET v2 1/2] xfs: bug fixes for 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, cmaiolino@redhat.com, stable@vger.kernel.org,
 samsun1006219@gmail.com, clm@meta.com, pankaj.raghav@linux.dev,
 p.raghav@samsung.com, linux-xfs@vger.kernel.org
Message-ID: <177154903631.1351708.2643960160835435965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 7.0.

v2: clean a couple of things up, add rvbs

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-7.0
---
Commits in this patchset:
 * xfs: fix copy-paste error in previous fix
 * xfs: fix xfs_group release bug in xfs_verify_report_losses
 * xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure
 * xfs: fix potential pointer access race in xfs_healthmon_get
 * xfs: don't report metadata inodes to fserror
 * xfs: don't report half-built inodes to fserror
---
 fs/xfs/xfs_mount.h          |    2 +-
 fs/xfs/scrub/dir_repair.c   |    2 +-
 fs/xfs/xfs_health.c         |   20 ++++++++++++++++++--
 fs/xfs/xfs_healthmon.c      |   11 +++++++----
 fs/xfs/xfs_icache.c         |    9 ++++++++-
 fs/xfs/xfs_notify_failure.c |    4 ++--
 fs/xfs/xfs_verify_media.c   |    4 ++--
 7 files changed, 39 insertions(+), 13 deletions(-)

