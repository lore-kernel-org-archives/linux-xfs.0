Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2774AC8CB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQsttxVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985E0C433C7;
	Sun, 31 Dec 2023 19:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052598;
	bh=5FZKciNglf/WQjn9F5C9CVOZSN9r6RflWfN933rDVUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QQsttxVR7kWI5urrYYky0Z3nGLhL2uyP53vR3tlqTBX30OCzoX6JyK3rF0++iPuoH
	 85OltK+Kg9cHyEpQgov6kJ5CEr0PkK0rXhAQKusPBu+mtvhQufU1TBiH3iyLaTO9Xb
	 MidabIJSny33d+jbs848R/r3PrkcxRNsBBase9/HrKxtk7IknOTx1RMIukizo6K7Is
	 sFCaq4eCHiViKOHEW3xU0LJx800vUqd7X9Yypvj4EamV00p0xj1LhaIB61fDhSXz6v
	 NiW2C7oTL8tdvm4OWN23RFn+F8iZNmMrtKRoSvHkHVZaV0stfEo/I8BPNJa3c8XrV4
	 CHmRSj4oY18sg==
Date: Sun, 31 Dec 2023 11:56:38 -0800
Subject: [PATCHSET 2/3] xfsprogs: report refcount information to userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019960.1820694.6724336371015732540.stgit@frogsfrogsfrogs>
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
 io/Makefile                         |    2 
 io/fsrefcounts.c                    |  477 +++++++++++++++++++++++++++++++++++
 io/init.c                           |    1 
 io/io.h                             |    1 
 libxfs/xfs_fs_staging.h             |   82 ++++++
 man/man2/ioctl_xfs_getfsrefcounts.2 |  239 ++++++++++++++++++
 man/man8/xfs_io.8                   |   88 ++++++
 7 files changed, 889 insertions(+), 1 deletion(-)
 create mode 100644 io/fsrefcounts.c
 create mode 100644 man/man2/ioctl_xfs_getfsrefcounts.2

