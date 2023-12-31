Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769CB666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cf9Xvzsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A234C433C8;
	Sun, 31 Dec 2023 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051160;
	bh=Ua0Z0oAU6iELwdFTzthgyOI5SXRVNDHv5pC+i6Gggp4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cf9Xvzsjafr3eINdAZGPGe3kJQPT0Gz+3oCU10161uO5156gICuNs7AmLCuwR9B2/
	 h1r/7tsaLgNfE8B+ERjPzqupLRlMOgu84eU72Rep3ce2FxAOSNSLDueeBYE44I6HNc
	 gNHlBkm1QXjyWdvaL94zomWBBW1Ee/6MI9iPSM51imP+cWQPTZjdbVsCq2jACfKykD
	 uE449FlTp0WsvboZnwu0zgCPhYx80q0lbFmyAcHWDz7PzggdRipuhP3fZPulLefSO1
	 bS4vFsyQDdNv86wpm1C20UWTJrj7o5i0X/+uhgjkCqlFytQoNo/ktR1Kk29d8N/u3t
	 7fi7D4qmKVR3A==
Date: Sun, 31 Dec 2023 11:32:39 -0800
Subject: [PATCHSET v29.0 28/28] xfs: less heavy locks during fstrim
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404838392.1754382.3493272901639286885.stgit@frogsfrogsfrogs>
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

Congratulations!  You have made it to the final patchset of the main
online fsck feature!  This patchset fixes some stalling behavior that I
observed when running FITRIM against large flash-based filesystems with
very heavily fragmented free space data.  In summary -- the current
fstrim implementation optimizes for trimming the largest free extents
first, and holds the AGF lock for the duration of the operation.  This
is great if fstrim is being run as a foreground process by a sysadmin.

For xfs_scrub, however, this isn't so good -- we don't really want to
block on one huge kernel call while reporting no progress information.
We don't want to hold the AGF so long that background processes stall.
These problems are easily fixable by issuing smaller FITRIM calls, but
there's still the problem of walking the entire cntbt.  To solve that
second problem, we introduce a new sub-AG FITRIM implementation.  To
solve the first problem, make it relax the AGF periodically.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=discard-relax-locks
---
 fs/xfs/xfs_discard.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 2 deletions(-)

