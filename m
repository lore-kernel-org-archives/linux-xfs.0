Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0A5156225
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224214; cv=none; b=Lik4cwHiRa8ZZNHntiowSVYcTnf49sqytFs9ZruLMtrgLTrO3Cb7kU8gMtwYVMJRlCglObAo8pq6bK9e+b6g+QfF2rbasqNHTDoLcbL0a7yd13yrxzfjshJpkywpp3ZSiY6Mw4tZp5iEvy+t5rbrHdM2W8xPM8g9dyvkKPHlBaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224214; c=relaxed/simple;
	bh=9EluAC+tiYuPaHJcMbo2rIeWlJOM5b0cnyWv48LVPf8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8DzbryuRFsrJxQkjPZRAAjevIrcA5e/TWWMyy1fIFU8w1LAllAdPzg2ApcFBUKMLii3bfQIZFSyBJo4Hp4E7yM5R3MWms0o0b+Xos7+xzE8HTU3O6GHZc6822gZKt23gdWIJY7zhIkb4EYEmtqQlh19jz+dOfLxuulD2/5BXNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Un2SHoZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Un2SHoZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60769C113CC;
	Mon, 15 Apr 2024 23:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224214;
	bh=9EluAC+tiYuPaHJcMbo2rIeWlJOM5b0cnyWv48LVPf8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Un2SHoZLGFArrrcXNmLLPjnnudeM8ghIK5NFnj75LHwV44lC03WSFJ7Go7E2mGuT+
	 h+UYXazxKFP/n0RC2L86V+LcmbEa2qgAgX6OPD5h0lhxf1k8Oof+EuqWA666jWIzZR
	 DIHwwsy0Px+JDCjNYo7Xjb8a3QEvMpiAeV+zABn062f8ravjjC73tDb4tz8cfK44+R
	 J3xdfYhEDF1XjtcRSBhuVBD44nl7TxRtuNfS9/5amA6pU1chGa5Ace1VADS8zm4hzI
	 WrdlXwXvPGvFzGJjhpogTRtz+eSWXaVbFmSwzfeOEqPlOILtTscuBUewr7Ch5aGk9U
	 vdOlRKfOdZndg==
Date: Mon, 15 Apr 2024 16:36:53 -0700
Subject: [PATCHSET v30.3 13/16] xfs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322385380.91610.2309150776734623689.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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
overflows.  Fourth, the x{chk,rep}_metadata_inode_fork functions
should be subclassing the main scrub context, not modifying the
parent's setup willy-nilly.

This scattered patchset fixes those three problems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements-6.10
---
Commits in this patchset:
 * xfs: check unused nlink fields in the ondisk inode
 * xfs: try to avoid allocating from sick inode clusters
 * xfs: pin inodes that would otherwise overflow link count
 * xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype
---
 fs/xfs/libxfs/xfs_format.h    |    6 ++++
 fs/xfs/libxfs/xfs_ialloc.c    |   40 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    8 +++++
 fs/xfs/scrub/common.c         |   23 ++------------
 fs/xfs/scrub/dir_repair.c     |   11 ++-----
 fs/xfs/scrub/inode_repair.c   |   12 +++++++
 fs/xfs/scrub/nlinks.c         |    4 ++
 fs/xfs/scrub/nlinks_repair.c  |    8 +----
 fs/xfs/scrub/repair.c         |   67 ++++++++---------------------------------
 fs/xfs/scrub/scrub.c          |   63 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h          |   11 +++++++
 fs/xfs/xfs_inode.c            |   33 +++++++++++++-------
 12 files changed, 187 insertions(+), 99 deletions(-)

