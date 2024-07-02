Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9916FC3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881437; cv=none; b=V3AX2tStXgxKREd3cE6uUpADxDkw9ytDtxgYYvxHzAJJIhdxccKhDnKYhs0vc+bvcxvhwvzur3OFT0boQj+kpl9VOD1/72Ly1dUd9lc3LxdGzAGjYcZJzPgz/JNEyPjEtAdTRuWMv8Kl8VikN1wdHwioHQaVKm11PwgYPP6ICHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881437; c=relaxed/simple;
	bh=rCNI1vLg1xS42yhtMGYSQP99D23y6iHQy6QKg36SmU8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ff8vs88phjNzbgc6YtZThAPbItVABmDRu9ZuleI0KbdW6IDK2avThEsKGKsov2CTIFmqkgvq6GYU7/WOA8Mcw7XDjZ+fLZ9KExyWjpCmoDmZRTphRxLBmFtYmqQaOOfD6KjPuHGPwAC+0fG7JJcaSZJEtu780fcNDyUs3hpe188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rL6IrfeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rL6IrfeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53455C116B1;
	Tue,  2 Jul 2024 00:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881437;
	bh=rCNI1vLg1xS42yhtMGYSQP99D23y6iHQy6QKg36SmU8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rL6IrfeG0WG+eQeqHJ2QCyJtAHqPytGVqgKz9+FHXipYQe743/WlN6V3DU+cdK6ki
	 rpLKT3pMaOyaxHQ1D+hyRZM/rOmb/BcguLVsDNYyyzzeJIE4LGRYTJeXUI7QRHO66k
	 noyxA0wZiq1gJ0voniQ+rXpY+fGUvs6HeiMtbIvfVjB5u4dssBsoRkA9se7Utu6NBT
	 +MYNe5FL4YIBcCR+OTO4hxbWsKVQ7VCILWnwaS8rn+nY7KEnuf2pcjfLFRF6IawKon
	 xRQQZESHtRNZRMSsVHeGPn9wO9QwLlkWSNWqRK9yyoNwZcaNkX28YBIsjwPwGanLSy
	 GOCp+OA2AEM4A==
Date: Mon, 01 Jul 2024 17:50:36 -0700
Subject: [PATCHSET v30.7 05/16] xfs_scrub: use free space histograms to reduce
 fstrim runtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-fstrim-minlen-freesp-histogram
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
 db/freesp.c          |   83 +++-------------
 libfrog/Makefile     |    2 
 libfrog/histogram.c  |  252 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h  |   54 +++++++++++
 man/man8/xfs_scrub.8 |   16 +++
 scrub/phase7.c       |   47 +++++++++
 scrub/phase8.c       |   75 ++++++++++++++-
 scrub/spacemap.c     |   11 +-
 scrub/vfs.c          |    4 +
 scrub/vfs.h          |    2 
 scrub/xfs_scrub.c    |   45 +++++++++
 scrub/xfs_scrub.h    |   16 +++
 spaceman/freesp.c    |   93 +++++-------------
 13 files changed, 544 insertions(+), 156 deletions(-)
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h

