Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC38B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaDqZkra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E15C433C7;
	Sun, 31 Dec 2023 19:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051550;
	bh=zneHYGm7LulJ1rQwfFY7T6b6wNtrt4zbRNM1Kpw7Hkg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZaDqZkraGxoML71RD71Ty9e4nlMPJ/iUgBuK7GHoOuoFZ6hajsHexNIHezqVSjI2S
	 347iNBe/X8yyf76pv/hFKN4Tf2Z8uhsRbr+GoE6Ey5W+Ro1gHEL/lYEJQEq43GgZgz
	 LdERNnaaGvfzRewkL0KFilEuC8CU7tep+AqdLmDI/9iO+h6Uul7fF+u84nR/wnB3SG
	 ECFF+wtYwdhiUCHP5DWNQC2QixzQLNrOqxz8ZKjEdEZBYaJFbKWV3hKKboOKwabTGg
	 MVWKD+fyKunf8s2UrJacIJ9ccak2y1njYpVRwtbvlptMH/bcZ9+leMCjZtij8fzblK
	 bYJa19XxZcRLw==
Date: Sun, 31 Dec 2023 11:39:10 -0800
Subject: [PATCHSET 3/5] xfs: report refcount information to userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404855142.1769846.8435488593659046849.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182553.GV361584@frogsfrogsfrogs>
References: <20231231182553.GV361584@frogsfrogsfrogs>
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

Create a new ioctl to report the number of owners of each disk block so
that reflink-aware defraggers can make better decisions about which
extents to target.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=report-refcounts

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=report-refcounts

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=report-refcounts
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_fs_staging.h |   82 +++
 fs/xfs/xfs_fsrefs.c            |  970 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsrefs.h            |   34 +
 fs/xfs/xfs_ioctl.c             |  135 ++++++
 fs/xfs/xfs_trace.c             |    1 
 fs/xfs/xfs_trace.h             |   99 ++++
 7 files changed, 1322 insertions(+)
 create mode 100644 fs/xfs/xfs_fsrefs.c
 create mode 100644 fs/xfs/xfs_fsrefs.h

