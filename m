Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16778529E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928042; cv=none; b=NZ/PVcZqBHD68VKqE2i37kCZkULPZzP/17J9ZNtfj5UAMXA+Qo9rrkgNjYz4BgLPXCGkqkyYAyYU365Fz6FfiuMOnLIsf4hDtfV8QMUuiF1FD0YIkP9EFw4+LF75AeuVRiEeBzhM0hvQuBiNBOAGiCkWT1Qe/0qnhxh4eqpjuOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928042; c=relaxed/simple;
	bh=+SHxYqVo+eN4Tmx6ahq+O+SHyYm4w5cC/7/Esbt0THU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWLXlnNCauD7fYdojhjdVNFfbHL0YpqzESSvnxyREWDAlsl5HAbKMr/WGD2H4Ve1QImhnTrld/zpudwgokbQpwiBCcq+KNvbsWVnZzqNRU+FmkgXf17pSs30zI9LE47gHE4M+kKJuuOhtQ5l311wvduJ4i0iT0A4TxNdrRBq2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rKzUn+A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rKzUn+A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61662C116B1;
	Wed, 24 Apr 2024 03:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928042;
	bh=+SHxYqVo+eN4Tmx6ahq+O+SHyYm4w5cC/7/Esbt0THU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rKzUn+A4ftaD8j5iKj+VuEvx/BaNJ50bOesYH/mIosdlepnyJ/d0ivNGpykHVNYMW
	 oZ/3aFNSBMXwVPEYE3qQHyQrSYghiG62IoDiSIFIQGKaugEE11WK8jipPt3o6NdsCA
	 D34BJkKP/DxlU0JVmm877BJc47z0rdLSM+71i4Gh6Za8QO5OGCOXcfzQ9q16uc3f/c
	 /xpwtt9Sf0u58ZHwdHQScaaz9pkQXad3BlUZkFY7/C07Lhbkz08FuOEKihXed8PRaG
	 HiROdIMvOsbR5BwjbbIepYBi//gT9eUlQRWZRJVr90bPc6r7pu/Z8tKYUmQW5GBtVy
	 ThzdsGOzHF7Ow==
Date: Tue, 23 Apr 2024 20:07:21 -0700
Subject: [PATCHSET v13.4 8/9] xfs: reduce iget overhead in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786026.1907355.15363148011407104351.stgit@frogsfrogsfrogs>
In-Reply-To: <20240424030246.GB360919@frogsfrogsfrogs>
References: <20240424030246.GB360919@frogsfrogsfrogs>
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

This patchset looks to reduce iget overhead in two ways: First, a
previous patch conditionally set DONTCACHE on inodes during xchk_irele
on the grounds that we knew better at irele time if an inode should be
dropped.  Unfortunately, over time that patch morphed into a call to
d_mark_dontcache, which resulted in inodes being dropped even if they
were referenced by the dcache.  This actually caused *more* recycle
overhead than if we'd simply called xfs_iget to set DONTCACHE only on
misses.

The second patch reduces the cost of untrusted iget for a vectored scrub
call by having the scrubv code maintain a separate refcount to the inode
so that the cache will always hit.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-scrub-iget-overhead-6.10
---
Commits in this patchset:
 * xfs: use dontcache for grabbing inodes during scrub
 * xfs: only iget the file once when doing vectored scrub-by-handle
---
 fs/xfs/scrub/common.c |   12 +++---------
 fs/xfs/scrub/iscan.c  |   13 +++++++++++--
 fs/xfs/scrub/scrub.c  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h  |    7 +++++++
 4 files changed, 66 insertions(+), 11 deletions(-)

