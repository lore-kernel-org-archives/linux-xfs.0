Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17477B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mowQXnQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFACC433C8;
	Sun, 31 Dec 2023 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051628;
	bh=2V5w+4X156J3Lo1x8sBOFeUEEinxFQI6SIafVRhP9EM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mowQXnQkvwW0v68Prz1v0m+WbHCtG4vyIyerC2OqzY708DtnlLsqZc1BE3UUT5/Tw
	 212WfCMy+tBWKCrIY2KRbEctTZf6mDmsg7Aa/px0f7pO05t4bwG/dqFozulvFtWjhE
	 EbjHWGEeP0BEAHfNOivzEVPk6nnhaQYmXq0BGWKSJ7BJhXMgyDCFdsscf1yDX6t99N
	 s7JnI+IlVukD/42MwfGi843rhcPnzE/kn4rhoRyxUjommQHetCwgLmDDUH1RRfViOD
	 57ZeDhAcXWi4WC8GuEScSLO2IsnAA+aVr8sgAF19/aXHuBFbrGY7V1rRH2NxxSX03B
	 ZMi5tf4QKuJOw==
Date: Sun, 31 Dec 2023 11:40:28 -0800
Subject: [PATCHSET v29.0 03/40] xfs_scrub: scan metadata files in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404989741.1793028.128055906817020002.stgit@frogsfrogsfrogs>
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

At this point, we need to clean up the libfrog and xfs_scrub code a
little bit.  First, correct some of the weird naming and organizing
choices I made in libfrog for scrub types and fs summary counter scans.
Second, break out metadata file scans as a separate group, and teach
xfs_scrub that it can ask the kernel to scan them in parallel.  On
filesystems with quota or realtime volumes, this can speed up that part
significantly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-metafile-parallel
---
 io/scrub.c      |   13 +++--
 libfrog/scrub.c |   51 ++++++++++-----------
 libfrog/scrub.h |   24 ++++------
 scrub/phase2.c  |  135 ++++++++++++++++++++++++++++++++++++++++++-------------
 scrub/phase4.c  |    2 -
 scrub/phase7.c  |    4 +-
 scrub/scrub.c   |   75 ++++++++++++++++++-------------
 scrub/scrub.h   |    6 ++
 8 files changed, 194 insertions(+), 116 deletions(-)

