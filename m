Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBE1B65C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaIBnUNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D922C433C8;
	Sun, 31 Dec 2023 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050909;
	bh=iTkhXmoHEowS20gXlmqkVdfK60KHplqkSVZw6qbOOcI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CaIBnUNB8GFXiMj4WgJF6ZrT+64xPqkfALJBjK8Ou77fg5zgxCi2r1Qb/RxDoQ2e1
	 p+GVhqsmEtovLPm9qVMRceyVZQIz/DB6EvG2SIHuas7cwMPZn3xEAsjV7xC4w9IqBU
	 BRZDBULoQX1ki4rUYSfoplAxYOLZdEgnpUGC/6ulddPLO3DJFykyj3xO2EmMrGqYyI
	 uKJIvZrBwHElrVzj4NdpG/zRKegi3N1RjM9ox7Ra3f2JEJDaY84SOL4sqSGtSPlgZv
	 mCr/xWJG9c4R+mhkBxavnm0sJ6ku/6ljXVkd2bqJFFNpfnWhj08n+h6TdosmgqGDN+
	 TRUORoqO+glpg==
Date: Sun, 31 Dec 2023 11:28:28 -0800
Subject: [PATCHSET v29.0 12/28] xfs: bmap log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
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

The next major target of online repair are metadata that are persisted
in blocks mapped by a file fork.  In other words, we want to repair
directories, extended attributes, symbolic links, and the realtime free
space information.  For file-based metadata, we assume that the space
metadata is correct, which enables repair to construct new versions of
the metadata in a temporary file.  We then need to swap the file fork
mappings of the two files atomically.  With this patchset, we begin
constructing such a facility based on the existing bmap log items and a
new extent swap log item.

This series cleans up a few parts of the file block mapping log intent
code before we start adding support for realtime bmap intents.  Most of
it involves cleaning up tracepoints so that more of the data extraction
logic ends up in the tracepoint code and not the tracepoint call site,
which should reduce overhead further when tracepoints are disabled.
There is also a change to pass bmap intents all the way back to the bmap
code instead of unboxing the intent values and re-boxing them after the
_finish_one function completes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-intent-cleanups
---
 fs/xfs/libxfs/xfs_bmap.c |   21 +---
 fs/xfs/libxfs/xfs_bmap.h |    7 +
 fs/xfs/xfs_attr_item.c   |   11 +-
 fs/xfs/xfs_bmap_item.c   |   95 ++++++++--------
 fs/xfs/xfs_bmap_item.h   |    4 +
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |  267 +++++++++++++++++++++++++++++-----------------
 7 files changed, 237 insertions(+), 169 deletions(-)

