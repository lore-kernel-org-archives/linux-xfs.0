Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24C8B66B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLGhITaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C966DC433C7;
	Sun, 31 Dec 2023 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052035;
	bh=stLZA4q9ha0T3xjPaybrL0lxfyC/FYXzdrpLIvtfYoc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MLGhITaHstgeNEz4CwQ0eYDpEQCGJWNSStD5Q+ouzRlCfRVrk9JdM9TabF8wXYXay
	 kQ9ezT5uqC2bIBezC68tCuP9NXiLdF4Tbu+pKXtfjH7DwuMICZaRJFKoeYJg0zFo5Y
	 mb35wCsJqrO1zPdSvB1ZKRMvXCDyFFh6lAlfAk+0F36XcyZOVsCejEjR9UbzkM/vl0
	 f4WI608r7/QVCtIDlIA/evam4UZqciN4cQXF4XPsPfrdHVwPMOWS/Lt5iNDtoWJJ1Q
	 zwNVYEnoyGl7pqYf9Uu3/gDFTybHLSI4dkvwDvUcMpYdGt1xtz7u75akz01XHflCAY
	 7zEYSFGnjNzwg==
Date: Sun, 31 Dec 2023 11:47:15 -0800
Subject: [PATCHSET v29.0 29/40] xfs_scrub: use scrub_item to track check
 progress
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
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

Now that we've introduced tickets to track the status of repairs to a
specific principal XFS object (fs, ag, file), use them to track the
scrub state of those same objects.  Ultimately, we want to make it easy
to introduce vectorized repair, where we send a batch of repair requests
to the kernel instead of making millions of ioctl calls.  For now,
however, we'll settle for easier bookkeepping.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-object-tracking
---
 scrub/phase1.c        |    3 
 scrub/phase2.c        |   12 +-
 scrub/phase3.c        |   41 ++----
 scrub/phase4.c        |   16 +-
 scrub/phase5.c        |    5 -
 scrub/phase7.c        |    5 +
 scrub/repair.c        |   71 +++++------
 scrub/scrub.c         |  321 ++++++++++++++++++++++---------------------------
 scrub/scrub.h         |   40 ++++--
 scrub/scrub_private.h |   14 ++
 10 files changed, 257 insertions(+), 271 deletions(-)

