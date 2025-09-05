Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B5E2FB082;
	Fri,  5 Sep 2025 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087727; cv=none; b=Y/nrGMYVHKHhLIyZjck9/Ix4N/B1plAajLYCxT204kKfGeYO6z9JMFH9uJUrwbQ5vodc4wSJg8NgQ5/ETMUCXuXWyrs7CcQ0aquxz3HxhXfn+obLk0zuKaj3dNVDW76fJGYTEAuMnpNJLFqRFFJaOuDXjvgHNxs8Skr8JUhRi0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087727; c=relaxed/simple;
	bh=bXt53vYMcymSfkfG7HrHTHkntjakZSVQaTHX0ZThmUo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=HE0kWEQjzAzT5oWThSaoc9OkaIc3WjOjyWmJXeBmDjicP9sP/vukxfUKtQFYgwrupJptEy+ABIY6D6l6Ybob60UqN4X4vW3TNdGqnBsb+zORMbLiCP1E7Er1CM4NweBc5lPqAef6COwl7reJ7dLiJtCxItD5axOCdB1FbHKA7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRzpaQ7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRzpaQ7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64B7C4CEF1;
	Fri,  5 Sep 2025 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087726;
	bh=bXt53vYMcymSfkfG7HrHTHkntjakZSVQaTHX0ZThmUo=;
	h=Date:Subject:From:To:Cc:From;
	b=KRzpaQ7tBHPe6QiThGVwnMeUWrrNJI6FS/QKLFllemN7mv/cyLVLrNslK5G1HZ8/y
	 oUGVp+DSA8694LFqqtTX7fHxR2hbxQ9NvipUr/TbvCq2bfiwazPikJndcFI6rHXrv7
	 /DVUiPROJ2LvcpidVHG9ltdgGonY4ianjWRYgcub3CMw2XxzIZAGIenCpcWAKDWUQG
	 yDVhlJOAXH9hqdQrkEfAbW8gG6XbdanW9c6j8OR4nfcG48NDB7wP2j5M75n16AfbEF
	 tZyIqJxBzDNa297dmD53/UHJNiYRRW+0V1ajVay9ZGUmsxh9xYCb+VI8j2u4+Aaa2j
	 CXc1L0ygDosyg==
Date: Fri, 05 Sep 2025 08:55:26 -0700
Subject: [PATCHSET 6.18 v2 1/2] xfs: improve online repair reap calculations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <175708765008.3402543.1267087240583066803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

A few months ago, the multi-fsblock untorn writes patchset added a bunch
of log intent item helper functions to estimate the number of intent
items that could be added to a particular transaction.  Those helpers
enabled us to compute a safe upper bound on the number of blocks that
could be written in an untorn fashion with filesystem-provided out of
place writes.

Currently, the online fsck code employs static limits on the number of
intent items that it's willing to accrue to a single transaction when
it's trying to reap what it thinks are the old blocks from a corrupt
structure.  There have been no problems reported with this approach
after years of testing, but static limits are scary and gross because
overestimating the intent item limit could result in transaction
overflows and dead filesystems; and underestimating causes unnecessary
overhead.

This series uses the new log intent item size helpers to estimate the
limits dynamically based on worst-case per-block repair work vs. the
size of the scrub transaction.  After several months of testing this,
there don't seem to be any problems here either.

v2: rearrange patches, add review tags

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-scrub-reap-calculations
---
Commits in this patchset:
 * xfs: use deferred intent items for reaping crosslinked blocks
 * xfs: prepare reaping code for dynamic limits
 * xfs: convert the ifork reap code to use xreap_state
 * xfs: compute per-AG extent reap limits dynamically
 * xfs: compute data device CoW staging extent reap limits dynamically
 * xfs: compute realtime device CoW staging extent reap limits dynamically
 * xfs: compute file mapping reap limits dynamically
 * xfs: remove static reap limits from repair.h
 * xfs: use deferred reaping for data device cow extents
---
 fs/xfs/scrub/repair.h |    8 -
 fs/xfs/scrub/trace.h  |   45 ++++
 fs/xfs/scrub/newbt.c  |    9 +
 fs/xfs/scrub/reap.c   |  622 +++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/scrub/trace.c  |    1 
 5 files changed, 554 insertions(+), 131 deletions(-)

