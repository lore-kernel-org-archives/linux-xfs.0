Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80F4B667
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7BsPWAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5BDC433C7;
	Sun, 31 Dec 2023 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052473;
	bh=ZfLZFBXo6Y4lhPx+ZV2e+9xClBdtlSGtn0fKEJb/OXw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G7BsPWAQKsyCbFOrTheoUN03zjSlHx3f5htFUUpqGeJJodyPAq2KHSk/OM3da3c3N
	 cfvhz8dMkguV7cvtkLM+Hsgfx9Qoqe8Al/4oqy7t98bKWuHMNpGes98PeVGgNX3ngW
	 9J6geaG4MW5BtRbeQdUIFd/8vzKRNtNMimt6WiU7pX6ta71aNpR1R1pcGzPn2s30xH
	 8ncC3dAhoSdFfquy9XM99tN6UbjWjKIbFKUlzJlf3c+dY89n6ZSOs/wvjW+Kx2rZuj
	 MTzH4sUmVTtP/shlmDLoAh5+uKRB1NL6xud1mdS9ZP6rW+xNKoJDyxyl5rTcBizB4e
	 U9r2/NfPQmEHg==
Date: Sun, 31 Dec 2023 11:54:33 -0800
Subject: [PATCHSET v2.0 11/17] xfsprogs: rmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

This series cleans up the rmap intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rmap-intent-cleanups
---
 libxfs/defer_item.c |   62 +++++++-----
 libxfs/defer_item.h |    4 +
 libxfs/xfs_btree.c  |    4 +
 libxfs/xfs_btree.h  |    2 
 libxfs/xfs_rmap.c   |  268 ++++++++++++++++++---------------------------------
 libxfs/xfs_rmap.h   |   15 ++-
 6 files changed, 150 insertions(+), 205 deletions(-)

