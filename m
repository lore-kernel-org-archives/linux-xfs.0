Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E898B65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xxfe+Ntk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486E5C433C7;
	Sun, 31 Dec 2023 19:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051410;
	bh=4nWg6IVfpd5GFn8gLzNOPFVMG8xARRU467uVwwdPCMg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xxfe+NtkVwx0KlL5PV2Aj2JUJiTGk52MFNOk8N0n+GY8ryy1OSBk/pnobOWnA9nLf
	 85aPpB2KFRrbh+Fu0YLxkhpJzOldeXIIdAcqE7gppTbxdoCwOhm969BJ+o8xC1ycBW
	 qXGhSPvQouG0vkBKPkByA9vh9gHr6mlEkoNo+PwKFUGz7tVOopJVlBBRydJIsKiZr/
	 Sl5wGtnYU6D12P5b0Zj/qe7IzTC5GmM0mNguRTvP6wCjWVS7ItDE5YeeAW+2U7/4kC
	 0oM4mpE3ZxR2Y8lJlxLIJQ6quuqiNZ/jMqn2OsPxe9TfWTqG/nKINQqWueTlHSLUsH
	 ly66rUU0IKbMg==
Date: Sun, 31 Dec 2023 11:36:49 -0800
Subject: [PATCHSET v2.0 09/15] xfs: widen EFI format to support rt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848822.1764600.16492021865539804027.stgit@frogsfrogsfrogs>
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

Realtime reverse mapping (and beyond that, realtime reflink) needs to be
able to defer file mapping and extent freeing work in much the same
manner as is required on the data volume.  Make the extent freeing log
items operate on rt extents in preparation for realtime rmap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-extfree-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-extfree-intents
---
 fs/xfs/libxfs/xfs_alloc.c       |   16 ++
 fs/xfs/libxfs/xfs_alloc.h       |   17 ++
 fs/xfs/libxfs/xfs_defer.c       |    6 +
 fs/xfs/libxfs/xfs_defer.h       |    1 
 fs/xfs/libxfs/xfs_log_format.h  |    6 +
 fs/xfs/libxfs/xfs_log_recover.h |    2 
 fs/xfs/libxfs/xfs_rtbitmap.c    |    4 +
 fs/xfs/xfs_extfree_item.c       |  282 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_log_recover.c        |    2 
 9 files changed, 310 insertions(+), 26 deletions(-)

