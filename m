Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242631FFC59;
	Tue, 14 Jul 2026 06:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009039; cv=none; b=TqnSCqJuFUrJJUL083MAn1KJWxf6wLGLnfZi3MHsl35+yZ4YCbIiwiFfDD11C4HrmyFhOfBOGmOhNTlJI186dsaQkPBnhSkMiQ8v+oQ8ag+2nIWL5a4ASpYAJ7xFMrYVTNY2hLrzRJ92JN0kfg1KmMl03AbLHGx08qAaCpoDoRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009039; c=relaxed/simple;
	bh=n4V8g3/xAGJ3QXCe6t90uCoV3YhkVCIteU3JdGY18yo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=XpyngbLXw1m9eyB3GTSgTB+5wtZjw2oqtdmBN0sG1uVyvCMc0IFrVhDNyrnQkSv3wuvMNwiud/egni4Xbm9Fx7iCZO29IHXwq9RGD70PBex8rR2+NV1RVWQIIy5aT4LYOPPQbig8ilnjKuz0mohzB3tWnbSsxclUhvUrTnrwtS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nda4NQu4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nda4NQu4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B02001F000E9;
	Tue, 14 Jul 2026 06:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009037;
	bh=y6HDB+LkIWrLbng22LKCJQJGo4JTbKj4Gu2qxbwSnZ4=;
	h=Date:Subject:From:To:Cc;
	b=nda4NQu4IXR82lykvHQ2esPrUaIkJMrcP9/i3iVOqhGUsxCwbJQd496r4JA0n4asB
	 kbvrFAok8dMYCRYjFAqCRmFaxGTjjcel/J1C59bDvDUgSDKxAtmcY4dXve2LfjZI88
	 YGnHkqzk/FT5U5YLKEcJP3Zfag1Ya5/m+9j9wfSNJX9j85uy8wqjNXRfQ7cqJajYNK
	 Oqy9NZuKxW627B9/pOvvfXFQks5hdak5XA25EEwl1ERXqvQtA6EHpVFVypQY4S+UNe
	 jyr0qPk4vy9wngMl6q5Y8Bn5IlQMVxdHwaRUC75b2y0HCVsLVWKpXmru5r6ubV90c8
	 fU1SrwuVZAceg==
Date: Mon, 13 Jul 2026 23:03:57 -0700
Subject: [PATCHSET v3 1/2] xfs: LLM-inspired bug fixes, part 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Someone gave me a pretty generous license for a large language model, so
I pointed it at every single file under fs/xfs and told it to find bugs.
After personally filtering out the errors and garbage, here are fixes
for the real bugs that I think it found.

Most of these fixes target the online fsck code because I'm most
familiar with it, but the LLM will read other parts of the xfs codebase
so there are miscellaneous bug fixes.

I'm sending these out as smallish bundles of bug fixes.  There's no
particular order or grouping.

v3: add rvb tags
v2: add debugging patch to make it easier to test new cow repair code,
    move cow fork replacement function to xfs_bmap_util.c.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-1
---
Commits in this patchset:
 * xfs: don't replace the wrong part of the cow fork
 * xfs: make cow repair somewhat flaky when debugging knob enabled
 * xfs: move cow_replace_mapping to xfs_bmap_util.c
 * xfs: don't wrap around quota ids in dqiterate
 * xfs: use rtrefcount btree cursor in xchk_xref_is_rt_cow_staging
 * xfs: use the rt version of the cow staging checker
 * xfs: write the rg superblock when fixing it
 * xfs: grab rtrmap btree when checking rgsuper
---
 fs/xfs/scrub/trace.h      |   35 ---------
 fs/xfs/xfs_bmap_util.h    |    4 +
 fs/xfs/xfs_trace.h        |   41 ++++++++++
 fs/xfs/scrub/cow_repair.c |  179 ++++++++++++++++++++++-----------------------
 fs/xfs/scrub/dqiterate.c  |    2 -
 fs/xfs/scrub/rgsuper.c    |   14 +++-
 fs/xfs/scrub/rtrefcount.c |    2 -
 fs/xfs/scrub/rtrmap.c     |    2 -
 fs/xfs/xfs_bmap_util.c    |   89 ++++++++++++++++++++++
 9 files changed, 236 insertions(+), 132 deletions(-)

