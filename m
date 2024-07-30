Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2602E2563
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298792; cv=none; b=S0AwE9wxFHZG9PHSduGvY3mgraQMZtpCoHO6iAclpaIZnD1/mbK9HMmt6QXmq/M+wDRPjy3rbNpa5QYwDuH7fzy143BkCn6pa/+UEXctUZ66iXgets6dCS5pMBAwFUcng1jGdQTydxyULT8ZJlVIVurlLtKgEgZV9SCDfIN1HEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298792; c=relaxed/simple;
	bh=M1MPuQb1YGjNg8hFzwG00nAThgLDq74zhfv58T0FtGo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XXHmNZObnm2BY9YiXGxL+1kOz3vK755+lX3ynXqXnNAnB5j/K6Mfb4ukUIwB9sg6jcM0xaVjzXo9JbsaNketTyoz8nTEAHPEQamCwObwEf7KJZEf5QRqB/AhKpBS9gaYGK8XMQVOEXMHWnSfQHACZcs+LTE/TAKmbi3leMhyFCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHgoyJjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHgoyJjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3359C32786;
	Tue, 30 Jul 2024 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298792;
	bh=M1MPuQb1YGjNg8hFzwG00nAThgLDq74zhfv58T0FtGo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FHgoyJjWNX6+FXHfXfOiE587HZ1xe3U0CuQrU8xYN7T5Q8FVKf+LELfzGh9LkWYNQ
	 fG5fPI7VcsfrmRzNLQ07WZo0VNtmE/34mbvFGvwuTy8n8SYAtJTSY/SfzClI7cbLGL
	 vbZnZ/YHH1zgKVK5i47shSkE0djsBCRpbjDmp7cx3IwjixPGZL41XefjvpREX2vi9q
	 t7WxnMp+Rkl09LZUk49sUlDsjUVj6hbD8o8MurBbwJ+bNyQqEUiINqGSoJgm3GZLn5
	 dUMVa8jRgm2YytOnNt9GSBxFXqFRCgS78CGL2Ii2bbKy52AAgFh5rAK+dJkia1106C
	 nGPRxXRmbLJhg==
Date: Mon, 29 Jul 2024 17:19:51 -0700
Subject: [PATCHSET v30.9 13/23] xfs_scrub: use free space histograms to reduce
 fstrim runtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
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

This patchset dramatically reduces the runtime of the FITRIM calls made
during phase 8 of xfs_scrub.  It turns out that phase 8 can really get
bogged down if the free space contains a large number of very small
extents.  In these cases, the runtime can increase by an order of
magnitude to free less than 1% of the free space.  This is not worth the
time, since we're spending a lot of time to do very little work.  The
FITRIM ioctl allows us to specify a minimum extent length, so we can use
statistical methods to compute a minlen parameter.

It turns out xfs_db/spaceman already have the code needed to create
histograms of free space extent lengths.  We add the ability to compute
a CDF of the extent lengths, which make it easy to pick a minimum length
corresponding to 99% of the free space.  In most cases, this results in
dramatic reductions in phase 8 runtime.  Hence, move the histogram code
to libfrog, and wire up xfs_scrub, since phase 7 already walks the
fsmap.

We also add a new -o suboption to xfs_scrub so that people who /do/ want
to examine every free extent can do so.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram-6.10
---
Commits in this patchset:
 * libfrog: hoist free space histogram code
 * libfrog: print wider columns for free space histogram
 * libfrog: print cdf of free space buckets
 * xfs_scrub: don't close stdout when closing the progress bar
 * xfs_scrub: remove pointless spacemap.c arguments
 * xfs_scrub: collect free space histograms during phase 7
 * xfs_scrub: tune fstrim minlen parameter based on free space histograms
---
 db/freesp.c          |   89 ++++------------
 libfrog/Makefile     |    2 
 libfrog/histogram.c  |  270 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h  |   77 ++++++++++++++
 man/man8/xfs_scrub.8 |   16 +++
 scrub/phase7.c       |   47 ++++++++-
 scrub/phase8.c       |   91 ++++++++++++++++-
 scrub/spacemap.c     |   11 +-
 scrub/vfs.c          |    4 +
 scrub/vfs.h          |    2 
 scrub/xfs_scrub.c    |   45 ++++++++
 scrub/xfs_scrub.h    |   16 +++
 spaceman/freesp.c    |   99 ++++++------------
 13 files changed, 619 insertions(+), 150 deletions(-)
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h

