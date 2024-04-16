Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEDC3D76
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230372; cv=none; b=sgm/Zo4NiFFMhJNRu2E6Pa83GQoFcbFktkwFjvqK8ALX0z1Cmf1t4918xBkYANkLRmEgj95kICoPhgR+mTdb+irJ2y74d0nCc0OyztIxdbAnPhSJ5IVwVSyb36E7aPdPLWC28Q9j/A8NyEEZ1OoVGJyaGALGJ4ilA98HTIkbCnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230372; c=relaxed/simple;
	bh=CPW9unbLNs4+M7ecMz9pLiDFn5rMJlEvklG/JfLbSwg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iuyplZPWnjuW6M4UWtqEOw7vaWf1uWl57FWAiO2blSrtkJ+CcPC/5cao9FDMqSXozOmfB5mpLopKctJvEgxz67rSK5gGbPIpJggQuVhRchryZhfTB5outtFHc7xDJajFzZmtVDKnA58JmhbSCAWOba2Q8oep8/e+4Z5qyixxjsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KauOVgie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KauOVgie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C940C113CC;
	Tue, 16 Apr 2024 01:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230372;
	bh=CPW9unbLNs4+M7ecMz9pLiDFn5rMJlEvklG/JfLbSwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KauOVgie6U9eR6CfHCPdL158SI0cn52VVsyXLvgmhiRNScLgY5RBkRJQ37NTUHk4v
	 XDrLL0v+7zJ0UZcLCc7t5lHRe/t8+ilpMW1H+4x8H9OtW+k2Yl84Z+uFzYjEw05MpS
	 /w1Bx7kdDTN56Tb5LDjymrqxt035CZLE4Xl445omX/wa6pSsA3T4r4NGG4G1Ig83/I
	 rzGPbUX3cIsv1NFdck7O+SoOst6Y+yZKZ1O9Aq9FUq2lLuz9E6U1dg7E12HA6SMaXp
	 1zIXE/xo2TOsSq/lmHzuNcpgWHXdh5Z/5Schn8F46nDwCR3LkpdRmR+RyMmSmhqk/s
	 OoJR4bNrdFEMQ==
Date: Mon, 15 Apr 2024 18:19:31 -0700
Subject: [PATCHSET v13.2 1/7] xfs: shrink struct xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416011640.GG11948@frogsfrogsfrogs>
References: <20240416011640.GG11948@frogsfrogsfrogs>
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

Let's clean out some unused flags and fields from struct xfs_da_args.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=shrink-dirattr-args

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=shrink-dirattr-args
---
Commits in this patchset:
 * xfs: remove XFS_DA_OP_REMOVE
 * xfs: remove XFS_DA_OP_NOTIME
 * xfs: remove xfs_da_args.attr_flags
 * xfs: make attr removal an explicit operation
 * xfs: rearrange xfs_da_args a bit to use less space
---
 fs/xfs/libxfs/xfs_attr.c     |   31 ++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h     |   11 +++++++++--
 fs/xfs/libxfs/xfs_da_btree.h |   29 +++++++++++++----------------
 fs/xfs/scrub/attr.c          |    1 -
 fs/xfs/scrub/attr_repair.c   |    3 +--
 fs/xfs/xfs_acl.c             |    3 ++-
 fs/xfs/xfs_ioctl.c           |   19 ++++++++++---------
 fs/xfs/xfs_iops.c            |    2 +-
 fs/xfs/xfs_trace.h           |    7 +------
 fs/xfs/xfs_xattr.c           |   22 ++++++++++++++++++----
 fs/xfs/xfs_xattr.h           |    3 ++-
 11 files changed, 73 insertions(+), 58 deletions(-)

