Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41641361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298666; cv=none; b=d5h9nk0LCySCzGgIDpKBvPLkQTSBrv9VheGbpxLLLWePSt89Fb5qvTYUoRJ9UMW6txVPhZ83j/RwLBNtVIsjTCV1AvuweEk9L9Yp5MJU4GrpHtrsn4D+TopwsWiemJe6b93GDL/sZIiuX2VdXwSzLvwZC0uHu/b8Ncc+Cu0MboM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298666; c=relaxed/simple;
	bh=poFuqxK9hF9a3nJ9SlqNN44fHTl7LyYpo2yYyggNaUQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rtQz963+WHKiDS8BhzPn6cPvoVkcKm6/JyC28nuPOO3lk1GizPKf6/ZHZcEWEjXXT5LwQpe1Ll1cax0e0y7lGyK0kTB1c/OU020U93gRTB6dHy9Nfr+2Dk6a5ZIUSzeUUf2zaIVFk+chOAI3/H8MPLDHMGVK3WmxgQ37mAQin9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5QDHb4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5QDHb4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47406C32786;
	Tue, 30 Jul 2024 00:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298666;
	bh=poFuqxK9hF9a3nJ9SlqNN44fHTl7LyYpo2yYyggNaUQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k5QDHb4PagxWFhoJI9/mFgV9C7cvR/V7EQfw9QTT7CV5f+9fJeZD8Gm4y8DEjAYww
	 1zSS8QChMN3o3jhLOPUyV7uYqryWjHN8kf7DNAT+FFft9GhC5dic0PvyjkNAPJhoj0
	 ZNa+VFGFV6ppP7AuzKTl1rWVkKLTM/ov0Q5p9i6RDnCJYTfR0sHV9TK4SL8Wfj9SFd
	 A+q7Rar8XyaXlMHEXsJ2He0TzHFaPFJOdR0qNkIhCWitNPhzeVbEcKf42S5LxGYoxf
	 kgalgP8xn8IP66bLodOKaLLCRzwlOt2+lDK9sXsXC2OYBuSCyDeXtR9YvZsQvZgWFM
	 CbWvJ5guh1jSw==
Date: Mon, 29 Jul 2024 17:17:45 -0700
Subject: [PATCHSET v30.9 05/23] xfsprogs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845209.1345564.9915639548188043835.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.

This scattered patchset fixes those three problems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-repair-improvements-6.10
---
Commits in this patchset:
 * libxfs: port the bumplink function from the kernel
 * mkfs/repair: pin inodes that would otherwise overflow link count
---
 include/xfs_inode.h |    2 ++
 libxfs/util.c       |   18 ++++++++++++++++++
 mkfs/proto.c        |    4 ++--
 repair/incore_ino.c |   14 +++++++++-----
 repair/phase6.c     |   10 +++++-----
 5 files changed, 36 insertions(+), 12 deletions(-)

