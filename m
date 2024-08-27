Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCDA1D2F64;
	Tue, 27 Aug 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784305; cv=none; b=WJkY5oZTzeAq2rfK3D3tRtDIuY4XeZYP9TAoZv77E8E7qxEvWFOuP5YHMSLqtmm0mEqk6wlmhT3C3KP8MDSYEyBkPAhrz4de/Bi5sb7VkxiU2H2nK00L0TE+QnpfnFu0xdXk6xJgcurhqgKkhYEqBUPUvca3zPqYXbq4QYLyT/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784305; c=relaxed/simple;
	bh=Y1MZ+OuMJ+rJ8tYiaC/fQIXNHYGdiE+R7ZPPpXbJH0k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JTCtydNOivRUQekiY6hCxy11ABjiyGXZXArat0LWZ4KCVVA5p+0MbKfUiaksv05ROr6w5Z/8Xr+OMwrw66eiFKj93NYv0AESX0vjMhODd7jPA1ALnPpRClsEJiZtDXPBXmiKUXCQjHdz/dNFGTJjDJNX30nLaQ0qLFJbH4l1LNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9JF88N/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9JF88N/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82048C4FE98;
	Tue, 27 Aug 2024 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784305;
	bh=Y1MZ+OuMJ+rJ8tYiaC/fQIXNHYGdiE+R7ZPPpXbJH0k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k9JF88N/Z9F7lEyTuY+CFP6qxOdAIxWjnu6SCnfukiahmSBrMapbuzeVnm3QZ/7ps
	 x5jS7Ozoj0V5oodcD/DatdIporoM183TYNkx3bOjQy53Zt54v5Xicxie0Q1x1ILmsa
	 pTUyf6nVKQqMsdiHiRfnTBx38M1U/y0+8i4JkLzE+Mqh9bozgTYqE1JQqShVhw5wI3
	 NUobVKvvsOlUFOP6aB8u3tLRKC2anJIB6LRvywRMS5Dv4TaKUoSLgaitqbl1jtHjFl
	 i+3SLDoKqWQCl4xSbAEDeHK4QD58cb+6CAsjRZcJ/YVsu9upTlMbKE+baCVld6f1An
	 g3yDVfww+a0IA==
Date: Tue, 27 Aug 2024 11:45:05 -0700
Subject: [PATCHSET v31.0 3/5] fstests: use free space histograms to reduce
 fstrim runtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478423001.2039568.8722356306961050383.stgit@frogsfrogsfrogs>
In-Reply-To: <20240827184204.GM6047@frogsfrogsfrogs>
References: <20240827184204.GM6047@frogsfrogsfrogs>
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
 * xfs/004: fix column extraction code
---
 tests/xfs/004 |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

