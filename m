Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578751AAD7
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504214; cv=none; b=OIhUuFOOYDaOhygWURmb8U7qsffGWMJPTkZobMdW6eW3kqXjAfkO+rJwdjG/+6nohFEQHTN0buBE8VqzBcYkEAXqSvvQeoy0G8e6z1dFKa8tchMp79oa0hm+SeSQzxNTVi4l/VmuM8t+EdxNcQOOJPMpX7+/u72ENcfDVLZCWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504214; c=relaxed/simple;
	bh=6sxJn6IYX+Y+tqMgSQuJvsIj4WMSD09BZnB7OGFzyI4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kPy4zWUX9EuYFX1esVARHx4ptKRKuK5+ZsHneG/whi5HVJn0Yzu8A7sIC392pQs5HuK41HJaHbWj5zeDdJf5FFCjEHDdhG6Ik9UYbGNSn/r1qfjUVcFfO64vzFDJn85E2w5n1POvK9x6a8eKPDb4fsrh3yRAf5DaeADHUQlWyPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZqGz1Xv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZqGz1Xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB13BC433F1;
	Wed, 27 Mar 2024 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504213;
	bh=6sxJn6IYX+Y+tqMgSQuJvsIj4WMSD09BZnB7OGFzyI4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YZqGz1XvKvlL2nVNNpQURl6afn2uiaFj0e13qq0Ch6+Z+wE2yPt72PNxNfyTRnysC
	 2/JHYGKKIzGAcv8psvffcWLnqFy4geUngvIpDjqTZm6Ft9rl0L+4ShpcbgepW4PhHO
	 /xOcap6AyeLI74isYKDJvt/De/LycJkvaaopDcDQjVGGlGetyElGgTyZnwAZz9hB13
	 jzo7519ZalnuzMYuFr+RySvsvPy7gQpdDXRdXk5rJx4kDV/HjyNbtt+MWCNqFseZ+J
	 9GkYTPtgdJSqGN8UqBz/3Zd+jiLDZQWquUf9HCiCgD3ESVg3uL9x3BbIeD4N8CauPh
	 bjGvK5vncpyaQ==
Date: Tue, 26 Mar 2024 18:50:13 -0700
Subject: [PATCHSET v30.1 15/15] xfs: less heavy locks during fstrim
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

Congratulations!  You have made it to the final patchset of the main
online fsck feature!  This patchset fixes some stalling behavior that I
observed when running FITRIM against large flash-based filesystems with
very heavily fragmented free space data.  In summary -- the current
fstrim implementation optimizes for trimming the largest free extents
first, and holds the AGF lock for the duration of the operation.  This
is great if fstrim is being run as a foreground process by a sysadmin.

For xfs_scrub, however, this isn't so good -- we don't really want to
block on one huge kernel call while reporting no progress information.
We don't want to hold the AGF so long that background processes stall.
These problems are easily fixable by issuing smaller FITRIM calls, but
there's still the problem of walking the entire cntbt.  To solve that
second problem, we introduce a new sub-AG FITRIM implementation.  To
solve the first problem, make it relax the AGF periodically.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=discard-relax-locks
---
Commits in this patchset:
 * xfs: fix severe performance problems when fstrimming a subset of an AG
---
 fs/xfs/xfs_discard.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 169 insertions(+), 3 deletions(-)

