Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF795B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBQFjirZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F14C433C7;
	Sun, 31 Dec 2023 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051910;
	bh=MiyZ8+UpileYQ1a2fe8UEoibUq7nwTsHDP/kX1frtNk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tBQFjirZ896VTHQe4Tgn09O5arpWK5Vfi+lcxg7cpfNMpe15/m1F2KwLzpK3XM/Un
	 S45BA4hkYTxT7WG4a14c1+QHG59T1fho61OKArk831kY2ju1ZNLjtzI4FI+XHdw2xK
	 dj5N3Q6iqBXOZwv+7JkbGf8CeJdDhu9h/X6DS++Q9s8ouiNvIPfl53RZSrZd1wHFH0
	 qcUlXfbNlRX7waspfJ08OjRrIO9vyZYaNPhzhuFLnGNuM7eeoeID8Nk9fCuc5nsJqy
	 HHztUbcvj45uxUazek/isVJV6tawWDYtjKCP+B9KHjEoU31pZNadMjJRoKQO2YEDQV
	 F/P41I3TJKSmQ==
Date: Sun, 31 Dec 2023 11:45:10 -0800
Subject: [PATCHSET v29.0 21/40] xfsprogs: set and validate dir/attr block
 owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
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

There are a couple of significatn changes that need to be made to the
directory and xattr code before we can support online repairs of those
data structures.

The first change is because online repair is designed to use libxfs to
create a replacement dir/xattr structure in a temporary file, and use
atomic extent swapping to commit the corrected structure.  To avoid the
performance hit of walking every block of the new structure to rewrite
the owner number, we instead change libxfs to allow callers of the dir
and xattr code the ability to set an explicit owner number to be written
into the header fields of any new blocks that are created.

The second change is to update the dir/xattr code to actually *check*
the owner number in each block that is read off the disk, since we don't
currently do that.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=dirattr-validate-owners

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=dirattr-validate-owners
---
 db/attrset.c             |    2 +
 db/namei.c               |    6 +-
 libxfs/libxfs_api_defs.h |    3 +
 libxfs/xfs_attr.c        |   10 +--
 libxfs/xfs_attr_leaf.c   |   59 +++++++++++++---
 libxfs/xfs_attr_leaf.h   |    4 +
 libxfs/xfs_attr_remote.c |   13 ++--
 libxfs/xfs_bmap.c        |    1 
 libxfs/xfs_da_btree.c    |  168 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_da_btree.h    |    3 +
 libxfs/xfs_dir2.c        |    5 +
 libxfs/xfs_dir2.h        |    4 +
 libxfs/xfs_dir2_block.c  |   44 +++++++-----
 libxfs/xfs_dir2_data.c   |   17 +++--
 libxfs/xfs_dir2_leaf.c   |   99 +++++++++++++++++++++------
 libxfs/xfs_dir2_node.c   |   44 +++++++-----
 libxfs/xfs_dir2_priv.h   |   11 ++-
 libxfs/xfs_swapext.c     |    7 +-
 repair/phase6.c          |    3 +
 19 files changed, 402 insertions(+), 101 deletions(-)

