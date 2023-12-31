Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE26B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0H6Wru4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB95C433C7;
	Sun, 31 Dec 2023 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051941;
	bh=+Z6FB6Uk71A/LY570z22xT7Uu3zvrBDwL5ole2KsTzc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s0H6Wru4VzLMxlrB2EyecH6vWMNf+GHG9z7DiNEOeCjCNhJoX4onXqPIpgAhebTBj
	 dVjUoExoQTVsOpNg2hPo/uTDhWeXwhn2W8LLrNKDZLKaork6rAPZ33GQG2aZAviujS
	 jdR1EVjjZWls9K5/49ZpfenjmKFzCRP8yQAoxI930Vr7ffpFTokD1Nh0Leoy8Tnmm3
	 21x3Ly/4g6fjRdjN1MCfskaO2gbsV4YbwZlYph4cIRy32ftTPfCtoQkX3RDE2UKfG9
	 Py75dYNm2x0bhgcWcnWXKZh3sr7Tqr9hjTbVaX6mQi3eO3W4PA9pN1aY3R4L0vMwF9
	 HRKuK/PPPDSsQ==
Date: Sun, 31 Dec 2023 11:45:41 -0800
Subject: [PATCHSET v29.0 23/40] xfsprogs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404997630.1797016.5364223101109022436.stgit@frogsfrogsfrogs>
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
online fsck feature!  The sole patch in this set adds the ability to
repair the target buffer of a symbolic link, using the same salvage,
rebuild, and swap strategy used everywhere else.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink
---
 libxfs/xfs_bmap.c           |   11 ++++++-----
 libxfs/xfs_bmap.h           |    6 ++++++
 libxfs/xfs_symlink_remote.c |    9 +++++----
 libxfs/xfs_symlink_remote.h |   22 ++++++++++++++++++----
 4 files changed, 35 insertions(+), 13 deletions(-)

