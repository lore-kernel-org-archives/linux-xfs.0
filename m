Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F06262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388641; cv=none; b=eirv944mESxFaZ8t4num3iyoSckt5LU8nChj8+gK8QEYQZDQxqQhWZqOp+BiBK5/uphrhdfhzUv2DgOHVV3MiYtkRIBrKDx0x0GzYQfIC8M95HLtUgPmYzwvy5mfYw59pMoiv7wYi1rr26VD6VVXlW3RKPaZWkIIfOMs1jbcuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388641; c=relaxed/simple;
	bh=LVRilO4HhNrgjTqAcJnFLu52dnbSkU0n8FQUl1440X0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=owg1R290xW81nPFIX2s8BrrCErMSMZAKbgmNL06mpRR2WTwP3BbHDXtKbRx8ML76bfGBZ0OTC3l3yKzUphTo30/T/v13NYa/J76AWS/nlTKX3+DJbnMbbVmug8iOtax7OU4OAphFf4tO9Izd2irIfluM6feKB1OPeWBCO7M6xcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDTbHcq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDTbHcq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7898FC072AA;
	Wed, 17 Apr 2024 21:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388640;
	bh=LVRilO4HhNrgjTqAcJnFLu52dnbSkU0n8FQUl1440X0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dDTbHcq5gevzYc1Bj8Nzj2XmmPXNSE7KQTTEHAWxCLJ8ugW6XPPxrc69mupkVgPjX
	 zdGoQnyl8Xp/3q/rbI3gGDNvp1KkrGwRQRtlu7plFbmGdMpPY5mT+SmZ2kh0RIBRAP
	 E9NQEPVq7o+CR42yddt6xGHw0nY470jaL1OFcct2IpujUQvwINwZmUUWzJX43mgL6y
	 TV0Ro0XeqdKToc1joTmMKxpv9q4P2uqzcyKNHeVGskKYfbpCq3meAoPLiLTYj5btbl
	 XTtXfAJQ4gKmnBRtP1DQSEGK8DAUnV1bDkdjwgQ60/dV0HSZgmTfjfSSL2sO4BpI9X
	 cLoAwfDYBOJ3Q==
Date: Wed, 17 Apr 2024 14:17:19 -0700
Subject: [PATCHSET 08/11] mkfs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338844742.1856229.17239515484275736525.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

For a long time, the maintainers have had a gut feeling that we could
optimize performance of XFS filesystems on non-mechanical storage by
scaling the number of allocation groups to be a multiple of the CPU
count.

With modern ~2022 hardware, it is common for systems to have more than
four CPU cores and non-striped SSDs ranging in size from 256GB to 4TB.
The default mkfs geometry still defaults to 4 AGs regardless of core
count, which was settled on in the age of spinning rust.

This patchset adds a different computation for AG count and log size
that is based entirely on a desired level of concurrency.  If we detect
storage that is non-rotational (or the sysadmin provides a CLI option),
then we will try to match the AG count to the CPU count to minimize AGF
contention and make the log large enough to minimize grant head
contention.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-scale-geo-on-ssds-6.8
---
Commits in this patchset:
 * mkfs: allow sizing allocation groups for concurrency
 * mkfs: allow sizing internal logs for concurrency
---
 man/man8/mkfs.xfs.8.in |   46 +++++++++
 mkfs/xfs_mkfs.c        |  251 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 291 insertions(+), 6 deletions(-)

