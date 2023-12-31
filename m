Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCF2B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FR8Qw5qV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48462C433C8;
	Sun, 31 Dec 2023 19:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051488;
	bh=K5vd+eGo7LWTNPjRfEwfPayIk/auzUJyWUikFi7f+5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FR8Qw5qVD+oQdL3rDxOfIUk+R9Uk8woqtevQAWsbcmJjRC8Lfouzf95pDZQ0ECDZT
	 MbqD+uuiBQTotlDwLNCStyetjHoEgsXOD2ZYWaBZ8iilJIYU0qyAUzPRKA0xuBMSAb
	 F1eFIN/45UAAqupL9zLrfhzR4hp2rjdaCMdHUWkK6hSj15MhPMvt9ROPwvrf0bMuzP
	 1SJOzbJDIVlbN9b6fYLubkEXHQsUgJ8WGvI10lzjBPYnkvjBOpKHBpRl4k85u51ZYn
	 IUOYXoi/Oo5l04AFkTxGMI7/uPSZ1mfNqCXW9qCtP6Y50qmwlumjeO+uMND2l1ZhXn
	 D26O4RlciPA2Q==
Date: Sun, 31 Dec 2023 11:38:07 -0800
Subject: [PATCHSET v2.0 14/15] xfs: reflink with large realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
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

Now that we've landed support for reflink on the realtime device for
cases where the rt extent size is the same as the fs block size, enhance
the reflink code further to support cases where the rt extent size is a
power-of-two multiple of the fs block size.  This enables us to do data
block sharing (for example) for much larger allocation units by dirtying
pagecache around shared extents and expanding writeback to write back
shared extents fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize
---
 fs/dax.c                      |    5 +
 fs/remap_range.c              |   30 +++--
 fs/xfs/libxfs/xfs_bmap.c      |   22 ++++
 fs/xfs/libxfs/xfs_inode_buf.c |   20 +---
 fs/xfs/xfs_aops.c             |   57 +++++++++-
 fs/xfs/xfs_file.c             |  224 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.h             |    3 +
 fs/xfs/xfs_inode.h            |    6 +
 fs/xfs/xfs_iops.c             |   22 ++++
 fs/xfs/xfs_reflink.c          |  223 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_rtalloc.c          |    3 -
 fs/xfs/xfs_super.c            |   17 ++-
 fs/xfs/xfs_trace.h            |   39 +++++++
 include/linux/fs.h            |    3 -
 14 files changed, 627 insertions(+), 47 deletions(-)

