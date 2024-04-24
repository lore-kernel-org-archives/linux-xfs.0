Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D2284DF9
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713927933; cv=none; b=YvIDCEqBN16GKw2B/be6FeG7OZ2qMPzPn67RuU0vjilEQRytohuRF4VkMeXHPv82Q9y2wTyt5985OyGlFf+E0sGvhb/uwwcBox0U2P2w+d58Hzxbg8tNN7nhRFfU4Kd6swY99BSLUtPxzhnrqUyuVYdlYg6XipRwnWFLOrUprRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713927933; c=relaxed/simple;
	bh=A/rN3Wdo7hTzPv62OeNfgJkTebNLlVyAbgA7PJh9SRk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMBSDDjKmGQIn2N5O2dhllE95Ywpnlf4bltpscvTwapgC7DTsRTLEggQ3eKHOttrkDP6EZm8TUO4295n+hiiC/ifGB9ofwnukp92v1LBrHddci7jFJdaq5Va6fn6f5vRybOSIhIkAC8N4Ws02kxYBALXPPsBHRbCwbQ3FuF21Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMgzf8MO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMgzf8MO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C374FC116B1;
	Wed, 24 Apr 2024 03:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713927932;
	bh=A/rN3Wdo7hTzPv62OeNfgJkTebNLlVyAbgA7PJh9SRk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SMgzf8MON5XDsottmoh1cSMIWIincBrNptCpSdBb5upMrye4XazUFZzFFxNFcb1sB
	 V+JIOeCOBnD9EERwdOwcCMMqcTDe7bV0ybxBG4M5AQ+ivt5wnfM2DdS/1H3y85r2bU
	 qeBztyew/ICiNEDg/mmWeAALmaYceCqz1eshODreZqzhjxd22BzXIU3k4tHFXqWfsw
	 IyA4TB+1d2FXGa/cyk56QYdj5VORiLF1GC/J3YEzPLfLOxWtKbW7PcWgWjhwWT3G3w
	 vvG7sGsx9cjqJ/tWCr4BXojWUV1Y0jV6SBtmhf5/YwysIlywNH0M3IioC9jOLC7L7F
	 gyxv/R067di+A==
Date: Tue, 23 Apr 2024 20:05:32 -0700
Subject: [PATCHSET v13.4 1/9] xfs: shrink struct xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
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

Let's clean out some unused flags and fields from struct xfs_da_args.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=shrink-dirattr-args-6.10
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
 fs/xfs/xfs_acl.c             |   17 +++++++++--------
 fs/xfs/xfs_ioctl.c           |   19 ++++++++++---------
 fs/xfs/xfs_iops.c            |    2 +-
 fs/xfs/xfs_trace.h           |    7 +------
 fs/xfs/xfs_xattr.c           |   22 ++++++++++++++++++----
 fs/xfs/xfs_xattr.h           |    3 ++-
 11 files changed, 80 insertions(+), 65 deletions(-)

