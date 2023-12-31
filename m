Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAE5B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyOuM/Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907F9C433C7;
	Sun, 31 Dec 2023 19:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051738;
	bh=E72fn/Tym3Qo4aiXR0lqNM3Yqt4n+M7fviqvfCVlp5o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kyOuM/UcClBpvriKBoLCeg/ShAITyngxTNXX8QPpVz/qPmK9pu886DiMXH4IA/Bdg
	 Eqrf22hZslaY4A/5LkGyhaNlQFrgpMD0aY3vT5LxUSiMa9IvcMOB3AcO/WGsSmFa3w
	 rT+3BPVZ1f6zaJAulAPrEw+O+XS4fxLUyD0vJiSOrYFLIpgqA2BFjbpmViS8jAXw4P
	 hDzkNoUcY6mWH8fyjfDqzSh7xIL+OtLcSCYWrrBixhZ6URUk42GnyclJbUQsBhwR+c
	 Et7bai3eH0Plfl3BRCf2hAnmrxr9crg4X5Spj+Ch02I6ZbFh6zrMQqbxQYBicSOlQ6
	 I9HnJvOI+a7SQ==
Date: Sun, 31 Dec 2023 11:42:18 -0800
Subject: [PATCHSET v29.0 10/40] xfsprogs: indirect health reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992400.1794340.13951488488074140755.stgit@frogsfrogsfrogs>
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

This series enables the XFS health reporting infrastructure to remember
indirect health concerns when resources are scarce.  For example, if a
scrub notices that there's something wrong with an inode's metadata but
memory reclaim needs to free the incore inode, we want to record in the
perag data the fact that there was some inode somewhere with an error.
The perag structures never go away.

The first two patches in this series set that up, and the third one
provides a means for xfs_scrub to tell the kernel that it can forget the
indirect problem report.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=indirect-health-reporting
---
 libfrog/scrub.c                     |    5 ++++
 libxfs/xfs_fs.h                     |    4 ++-
 libxfs/xfs_health.h                 |   47 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_buf.c              |    2 +
 man/man2/ioctl_xfs_scrub_metadata.2 |    6 ++++
 scrub/phase1.c                      |   38 ++++++++++++++++++++++++++++
 scrub/repair.c                      |   15 +++++++++++
 scrub/repair.h                      |    1 +
 scrub/scrub.c                       |   16 +++++++-----
 scrub/scrub.h                       |    1 +
 spaceman/health.c                   |    4 +++
 11 files changed, 131 insertions(+), 8 deletions(-)

