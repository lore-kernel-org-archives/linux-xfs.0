Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED321BA5E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294518; cv=none; b=iJHbGk6uH00+lLHQysUqDpy4Rod5KCkIvgMhubatc4UzHmJ1QVeYH//wxieP2H0WD9W+IWl96+QJQSAFtu4VercMLUYIGZFoYbL5+Ofv63O4+FsVD9OUhBDCYMOxzQiASzU9Qdfen6krHPLqY211GvYuS6/V7+7dEkLGOyPjbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294518; c=relaxed/simple;
	bh=qeBoLSQ9bEyhMwGza8nH5VPT3AY4tpA7At8eQtlLFIA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjT0a/RlRS6iTKGu178sdpOzgnycVUVa2dTwUGjSUpb+zrRzN0W28haUmmAq2v+Jh0k56e7b2LQ3gBiVLqyMKQt/7MURm7a8QBkK7nQc3SgNCZ49fCF/wWpr5eSrJm72N7pfVCtOeJk7jCMvz9ErmqZTFu4K2k8qMyMaXw+xCZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uVJWlPVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uVJWlPVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F50C43390;
	Wed, 13 Mar 2024 01:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294517;
	bh=qeBoLSQ9bEyhMwGza8nH5VPT3AY4tpA7At8eQtlLFIA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uVJWlPVbGFWtI0fHwp5EYSwLAPDSCAuIcmzLdn89IAHXQLZyaif/GlNYIqi6orpMm
	 zpagrCISKeR38JvW0/4Qs7g6OfwS9Y2IrsNqeGjYYhcBvCuJr45SFsh8vznAwqTKnK
	 j2h9v6OTpYHfqXgPmLP1CqZRwZ+wJbd1is0FI5gmxQzKbM0l/b6mtXzauBE0fnEb+F
	 IvdB1d/RIdNUvfhMT8Ztw8ir4rNl8nmZdPmWcBbtFxWJg+mAemmE4ZfSlt2UtWFYid
	 K+H9Ao7Ru9Syd+hiOJt0nBMuEsUnrgYC62NgwfrOaC3ZDdLeBGB2XUes9FPwBAeiT9
	 z5aHYplouOxzw==
Date: Tue, 12 Mar 2024 18:48:36 -0700
Subject: [PATCHSET 06/10] mkfs: scale shards on ssds
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433596.2064472.12750332076033168727.stgit@frogsfrogsfrogs>
In-Reply-To: <20240313014127.GJ1927156@frogsfrogsfrogs>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
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

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-scale-geo-on-ssds

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=mkfs-scale-geo-on-ssds
---
Commits in this patchset:
 * mkfs: allow sizing allocation groups for concurrency
 * mkfs: allow sizing internal logs for concurrency
---
 man/man8/mkfs.xfs.8.in |   46 +++++++++
 mkfs/xfs_mkfs.c        |  251 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 291 insertions(+), 6 deletions(-)

