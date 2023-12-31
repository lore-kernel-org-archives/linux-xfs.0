Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A998B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8Jfi1EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C1AC433C7;
	Sun, 31 Dec 2023 19:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051425;
	bh=3YqxKLqo+pAdeWzpF6elKvZuKPBXzBUCFRDX68fYMvA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H8Jfi1EP5oeOClL8shR2X2WA0PltE4s2MW7Z8sGja8/1WxXnl6DiUGtC2CT/8q8fk
	 AizKAKGQNQ9pvDTUm9AZOL6ZKjMzlY5HudZuz4LEfBSohxybCgXoo4nc6RHJRb7wyw
	 nj4fHRK7GkSu7GNRKpUosX3gvuck5qQeAEHtjUY2oQDOJAJR2mAFNCuAUK02N1WO8H
	 m0M67oE4y1Nss938KdlERVwXDSBN0yd2pdm3UPUTLAl94gJuKPxILokZtGd7UrU00S
	 lqq4ZoceEvB5lqaWnefhlnawFNoz0+e1UCJxi7vpETjT/IhDvnncPS8mgel8LckuUU
	 JDI04+jHsYvlw==
Date: Sun, 31 Dec 2023 11:37:05 -0800
Subject: [PATCHSET v2.0 10/15] xfs: rmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_btree.c |    4 +
 fs/xfs/libxfs/xfs_btree.h |    2 
 fs/xfs/libxfs/xfs_rmap.c  |  268 ++++++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_rmap.h  |   15 ++-
 fs/xfs/xfs_rmap_item.c    |  148 +++++++++++++------------
 fs/xfs/xfs_rmap_item.h    |    4 +
 fs/xfs/xfs_trace.c        |    1 
 fs/xfs/xfs_trace.h        |  187 +++++++++++++++++++++----------
 8 files changed, 316 insertions(+), 313 deletions(-)

