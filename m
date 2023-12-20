Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C35F41874
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GX65nSb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E36C433C7;
	Wed, 20 Dec 2023 17:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092239;
	bh=qHNH2R9m8HpiXUt5wFH9+35GTGqUFUNU8F6jFNZdRYM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GX65nSb0vla0cGve6MhHBrMvLMxH4dp8tYpV1Lu1uQzYra4EvFNQSCcdRrJd0cT2d
	 teqxjDLGCrTHgvWO63xCxnEvYYgPNHS90SI+/FVRdUviRGeIo4gKUS+ma81cCT0xPm
	 uggsS0DG6YtMaxUTTzDiYVuRCYjwPFe4vrY1tb1+PDmHjuiz5RSwCmy8K0VZM7X86r
	 ITmfsNhN/mpgjdoVDtR63NpRAaEBvEOqdHi4XNxG30uGztK89pL7jMhcnrT/1jL9Qq
	 6R2fxNo53j7jF5cwYcpqCyFsopauvpZ0+hZo8OYLv62ea+R8Wq3BN/zH52A2JmGLj2
	 XFC444r/SxVLA==
Date: Wed, 20 Dec 2023 09:10:39 -0800
Subject: [PATCHSET 1/4] xfsprogs: various bug fixes for 6.6
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
In-Reply-To: <20231220170641.GQ361584@frogsfrogsfrogs>
References: <20231220170641.GQ361584@frogsfrogsfrogs>
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

This series fixes a couple of bugs that I found in the userspace support
libraries.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.6
---
 copy/xfs_copy.c      |   24 +++++++++----
 db/block.c           |   14 +++++++
 db/io.c              |   35 +++++++++++++++++-
 db/io.h              |    3 ++
 include/libxfs.h     |    1 +
 libfrog/Makefile     |    1 +
 libfrog/div64.h      |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/defer_item.c  |    7 ++++
 libxfs/libxfs_priv.h |   77 +---------------------------------------
 9 files changed, 171 insertions(+), 87 deletions(-)
 create mode 100644 libfrog/div64.h

