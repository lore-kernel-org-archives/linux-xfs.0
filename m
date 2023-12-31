Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18F2BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hW/I7kIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE2BC433C7;
	Sun, 31 Dec 2023 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052989;
	bh=0skT2WMyZDSK9bG+P2cPreVWFZQhMXgxGQ3zc5usy6Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hW/I7kIof+LkMPw774X8n9mQLzf+3OhvAVBGTx/OE4kmtgKBXWXbYDvwLQZd1+5k0
	 mAdamBvc5D8H+2YhoN5Brytpy2rLz0sO+1hcR+BcAnLpvbHSZS9K5+6xQ2wjyy1soo
	 VLTXp8fNul+zlA1+lLeT1rhcTwjpfjq5MYcb/8KjBAOTfdHyHAuOff6ZwujliPO8ZA
	 ESuLczNFfcZKoe4aCDvmZ94szqSxjfWw16LYB4LNkJmdb0TTjILgksMn4FAlZYYkr/
	 iH260ofzdkfgBJk8d6tDZ6I6aKOciTrWd06g4ZAL9/7A9Ff/rGTuD/ipq7L3PrcCRc
	 Ud2Kl/pu1FRNA==
Date: Sun, 31 Dec 2023 12:03:08 -0800
Subject: [PATCHSET v13.0 1/2] xfs-documentation: document attr log item
 changes for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405036203.1829412.14716609287158101338.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

This patch documents the changes to the ondisk format of attr log items
that are needed to support directory parent pointers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-attr-nvlookups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-attr-nvlookups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=pptrs-attr-nvlookups
---
 .../journaling_log.asciidoc                        |   60 ++++++++++++++++++--
 1 file changed, 54 insertions(+), 6 deletions(-)

