Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E282413FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735687941; cv=none; b=JQwdC7Nu3/b3tdySP3jX502BDzjCQDAiI1Hc+kwzLv0EXEWb21suSoQVpJ2ahTwtXAWZWZQbMLMV0n+dlOnd4iMZrtMiZLjFvPKXbXhFtdZ8KnkFFth3j/LcbD+Q+JB5YNfBmaHeTScA610TBBYjMuqMAlwUR5hT6xuLPpIdhq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735687941; c=relaxed/simple;
	bh=0IeuFBHroJdIOLBzYpIm8YUDD5Ug873vX8bSaDW3xlM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=anqYTd/DvO1KLlhafEL+pdOhisiJzHVHdnYPBP6mMhBwchu8MLWkOAfydSLPeev3A37m5TOSJqu/4wlEHuVFf7/jmRqsxv6OZVE9RkrsMFGX2xH8ihTE4tHkrrL4RC1v4lGi+esRBixQsRlnUxETGL5kKpXvUrgl2UMeYcvAHWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMbkolpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMbkolpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461ADC4CED2;
	Tue, 31 Dec 2024 23:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735687940;
	bh=0IeuFBHroJdIOLBzYpIm8YUDD5Ug873vX8bSaDW3xlM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HMbkolpDT2plysB5uA2Xze9KQzjXxFZHUuHjfMvjW5FODKWUKOGEZcOFXKLAVXLnX
	 RaTP1ZEkBRXEcNxafZh+ndgBpicK7uONOI3F0X3xxkHaPkBGTzhWOtIdiP2mBlhVWv
	 P8SXDSXGzH6T1K3J31GTLWTE+e5Sd/s0mw1hpU1TZVcvjKCILHrFe0j9s/Ne9FnE/J
	 iHB2xjEIvo5rURM2tCyvhx0F1fOotW65srQJh5C73ml1Zy5hhpqXf5pVUpgDFXFiPD
	 jcuwi68x+E84dfiGc3bzuj1rOFyXY8zqo7XCrbEISaIMH8n6U34+EBCsAL3wsDXih7
	 nwBNmDLZw0qCg==
Date: Tue, 31 Dec 2024 15:32:19 -0800
Subject: [PATCHSET 1/5] xfs: improve post-close eofblocks gc behavior
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <173568752878.2704305.6940024185435305877.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a few patches mostly from Dave to make XFS more aggressive about
keeping post-eof speculative preallocations when closing files.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-eofblocks-gc-on-close
---
Commits in this patchset:
 * xfs: Don't free EOF blocks on close when extent size hints are set
---
 fs/xfs/xfs_bmap_util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

