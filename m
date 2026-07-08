Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66D71A9F82;
	Wed,  8 Jul 2026 05:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487000; cv=none; b=OwiRNGR6lFv5cRpSIbTnxgf8xq5VEqiTyIdXZEBvs9qwvwYoRA1Zrtg5c0TsCjEGS6qfZeFi7RPu5LEt1Ph0VYyI14EjclTNpfHqRtv4GsKbCFxLX6gp7RNL/4QmomCkourShgNhV6TTX0NyW2sOdNuAYYxEVUV71vrWHYR85RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487000; c=relaxed/simple;
	bh=zYbjv8cY/Jlp/+R1fNy1RX7oDqykDx+r+hZibMny70U=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=We4Ze6HaeB5fCcbUaZd3JwRDJ/T0ke4bxhQAmgqoTxSiOUim0gg97xzHLRZs2+G4KAHlnirvZurzQgk2xV/1C5KCQ27RzY+p49yRVwpQMAKllYRvF9/xEItWZp0X9zbhb2qDC5JJilWp/nUMbMRaiglBDG+6RfRmaveb8sRC9KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg/qLXVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg/qLXVU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4AD3C1F000E9;
	Wed,  8 Jul 2026 05:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783486999;
	bh=oiANhu/E2IQzyT6RpxIUebTEPtVz9hwvTuCJMAb81qk=;
	h=Date:Subject:From:To:Cc;
	b=Kg/qLXVUXN9viBariOxoJHQhLbPOPTbAPUrx2HMCw/ATnI4fpSF/2bZ3VJc3GNBib
	 ZzB6QKq52eB3VqEUnQJBJsHunkRmL3b16B4wmGwjlPVXVYGJLKAGQLitPofPbII5CW
	 4CDtyahGWPLC2la62m5IWKGzz2BKG/j0+k0gaQjlXkKiEi1nwR434loyD5CL69Fgn7
	 Qo5fDZ1tRzJKhrruA93d/fKjUpF3TPWWDOn28hjy2mu1chIkGC+WJVO+6sbMb+6JN4
	 iNNxXYLMydnzr+Jx+mJtt6z2xUip6uFLELn4oUT3UUEFaRHdUdJWGz8z1F0nuTfgzk
	 1lPSknZZuJFTA==
Date: Tue, 07 Jul 2026 22:03:18 -0700
Subject: [PATCHSET] xfs: LLM-inspired bug fixes, part 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs>
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
 * xfs: don't wrap around quota ids in dqiterate
 * xfs: use rtrefcount btree cursor in xchk_xref_is_rt_cow_staging
 * xfs: use the rt version of the cow staging checker
 * xfs: write the rg superblock when fixing it
 * xfs: grab rtrmap btree when checking rgsuper
---
 fs/xfs/scrub/trace.h      |   28 ++++--
 fs/xfs/scrub/cow_repair.c |  203 +++++++++++++++++++++++++++++----------------
 fs/xfs/scrub/dqiterate.c  |    2 
 fs/xfs/scrub/rgsuper.c    |   14 +++
 fs/xfs/scrub/rtrefcount.c |    2 
 fs/xfs/scrub/rtrmap.c     |    2 
 6 files changed, 164 insertions(+), 87 deletions(-)

