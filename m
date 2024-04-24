Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EF1BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928027; cv=none; b=tOyvKwY5dj0NaQdRGqJ+/21DQmUtjFmR48SU2EWn2pV8RD1fbwct0CtoWQAIcFLF1JLmQiDtu6HII1apzRBzsg0bEdVBc95cEXDTa1xJabPsHo4IlwCYSlur9tMQc4XHMuDnwu57DwqfptiF2/8qsvi6gRaUNlFEp7evQNXNn+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928027; c=relaxed/simple;
	bh=+oQA62V4oK4mPuie8MbA4uDEXnOm4V2wjMmRg+BjFL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bA12ZS38lyiQ+hYZ0phRYRHHHCMTSwvub/VCOd8WpPmeU7gXpEAVjkkLJIym4lRsXCgnLzw9ncJ+jfzIVHQmWj5E1YCRRrXMxEnjS4SRnPZ5AZVPKNqMnaR24hLzvogY5AGWUWlPyhjY3ZKqIlEhXvJMTrjODv43NSEOAihaL7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdL5OxNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdL5OxNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC7DC116B1;
	Wed, 24 Apr 2024 03:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928026;
	bh=+oQA62V4oK4mPuie8MbA4uDEXnOm4V2wjMmRg+BjFL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bdL5OxNO9UTRgdq4lI9BIp/TDSz52zFRrmpSogJnOmYGNRlGyNPgklaD1TinWhyhh
	 v7bXe6KNt/vqpIzfmw976Dc3OFWRgd/V5NCNVDCoeGYbnDstqSniljWPEqG7DWyr1D
	 2GECSwyeIYQhV2RoyIuMbwsaor/IKEYs88lllG3N4jIig9gzIg/yocbul8ntOiN3yI
	 YLPSJa613MUz6UCIF8I998t3j+q7dKF38jLxbk3ATNlBnABQ20IPCqNNNm4+MbZ1jL
	 NjthY8VYzBqUrS37oFd5GcWzGzx9zOpT8SDrWo5X38sEYkIgQl0cZ7pSJcppYvAKNH
	 Qp+ew+ZveQqEw==
Date: Tue, 23 Apr 2024 20:07:06 -0700
Subject: [PATCHSET v13.4 7/9] xfs: vectorize scrub kernel calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392785649.1907196.827031134623701813.stgit@frogsfrogsfrogs>
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

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This mitigates the impact of system call
overhead on xfs_scrub runtime.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub-6.10
---
Commits in this patchset:
 * xfs: reduce the rate of cond_resched calls inside scrub
 * xfs: move xfs_ioc_scrub_metadata to scrub.c
 * xfs: introduce vectored scrub mode
---
 fs/xfs/libxfs/xfs_fs.h   |   33 +++++++++
 fs/xfs/scrub/common.h    |   25 ------
 fs/xfs/scrub/scrub.c     |  177 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h     |   64 +++++++++++++++++
 fs/xfs/scrub/trace.h     |   79 ++++++++++++++++++++-
 fs/xfs/scrub/xfarray.c   |   10 +--
 fs/xfs/scrub/xfarray.h   |    3 +
 fs/xfs/scrub/xfile.c     |    2 -
 fs/xfs/scrub/xfs_scrub.h |    6 +-
 fs/xfs/xfs_ioctl.c       |   26 +------
 10 files changed, 366 insertions(+), 59 deletions(-)

