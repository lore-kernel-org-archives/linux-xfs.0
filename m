Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808457464
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395601; cv=none; b=h3WnW+tKqKfAyU650qJHQ8DBzf6Sb7mIv710E4DOBhHHBeWYGgfOzpH3wc/NLKN80GaA7CqxTPO91z9tXVxB3EIwNFClIczhnDwSf/kXNPCnHfkvCF3zpwzfpKrd58y89daF46zA/0W/+bOtmSoji9ACflh+Znat3+GnUmiv0nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395601; c=relaxed/simple;
	bh=FhVq+BlcUlLvaIOS8rpwVDenpzX6JbE0Mv7no0DwjyI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYDOOm5FHbtiEMXVER+lu1ve+BMxxRCTrYKyOzQ4G890/gI8N6eIZldXRuulcxyPfZuZWFKW1ZtsBdeGSLCheoDRmUi5Ssn6Pz55EPe0PZSaRTBPWiEOnJLTWiB+PAblAlx597T4ih/vTGLdTRDoOlPouV9SokKc6T1x76zEwzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQLH71gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQLH71gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29434C32781;
	Wed, 17 Apr 2024 23:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395601;
	bh=FhVq+BlcUlLvaIOS8rpwVDenpzX6JbE0Mv7no0DwjyI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tQLH71gnNSvk3fvW4kYqTKGUs9WccBXp7MsRn0rBnylaC6u018oN1UUEcpz41MHG3
	 zVlsoPmZftg0TAPwEVhr0Ntfc+gfh+hxTwrRgHHG9+aLycJ/edsy+y+4g9Wz6tY14P
	 8RQxLTn1v9Fbp2BKQUU9QvZU7nvM8MJeI5XUOG58NU4YIek/ffD2UM3I/a/cfErkLC
	 u4tngQRuaBs3Wg6aY3JEoD/h6m1Sov7j/RaFWvgyRhqf/7SHe8Dep+qaRk/nVIhM3e
	 VWBy5+JeIlOrkbL3qDzZvfN7AyWnw92y2l/qfOB9YAYlGu6g6EK5cyOJ7Ob65mLJ33
	 9ljuQlZhAkiHw==
Date: Wed, 17 Apr 2024 16:13:20 -0700
Subject: [PATCHSET v13.3 1/2] xfs: reduce iget overhead in scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171339555559.1999874.4456227116424200314.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417231037.GD11948@frogsfrogsfrogs>
References: <20240417231037.GD11948@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-scrub-iget-overhead
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

