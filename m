Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37163B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NMIdRefW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC015C433C8;
	Sun, 31 Dec 2023 19:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051863;
	bh=zstzYcGPEqAdNwDp5h/TbmxOOj5u9R5JqG1B1v/xysQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NMIdRefWO9n5+rylvoFdn/KAMuR0gFrOOfxSyFiHE02acosLxY8K/YPUCGE/ZkxPf
	 PN90+1QfypPnUSQkPLx1O19ip9yVo4HyeTCTVo92f4Q0+Zhkg421ZK0UNjqw0f/wIG
	 MjuDYzuBVXzDE/Ixrn8w6lmBMFiFw8P3vMnqQ4IN2ZWtg0SEFDmubvdsg3DmWRlb25
	 nLx8VW+lADQtnBZanAZAnhO6EON9q5Nk7eNveWJS8Y3VY5mSD6VmhdHCc3Qw3loWn8
	 aYydo/9M3tED15xarAT7Bgwn5xfmj8dKj73fB3bKMuBNTYf2+i2/fepO+Juh17tOsL
	 WDVBecm02D/pQ==
Date: Sun, 31 Dec 2023 11:44:23 -0800
Subject: [PATCHSET v29.0 18/40] xfsprogs: support attrfork and unwritten BUIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995537.1795876.9859168140445827889.stgit@frogsfrogsfrogs>
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

In preparation for atomic extent swapping and the online repair
functionality that wants atomic extent swaps, enhance the BUI code so
that we can support deferred work on the extended attribute fork and on
unwritten extents.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=expand-bmap-intent-usage

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=expand-bmap-intent-usage
---
 libxfs/xfs_bmap.c |   49 +++++++++++++++++++++----------------------------
 libxfs/xfs_bmap.h |    4 ++--
 2 files changed, 23 insertions(+), 30 deletions(-)

