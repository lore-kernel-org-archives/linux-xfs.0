Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1303E3A542D
	for <linux-xfs@vger.kernel.org>; Sat, 23 May 2026 14:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779546132; cv=none; b=Nwg8QUlmYqTQcNxBFta7C+d+dpGd95qv5pQo04mGrpTbMsxrrol0a2g9N8BWbSJHa/BxHxqW0rKjIb2H3PG0sPXNXKG+I4c6U7ixk5CinN6FMc+w8WSzB8tKo0xV9jIc5a1V+VN/ePH1xSucT9NDMQ9oROtxgID+h/JGjpJyW8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779546132; c=relaxed/simple;
	bh=q2HAHZzHHCg5Qe+TGmNGJ1ujjlIjGZbXTdtkTInZxfg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eiaIjb5IVNRTiNcqSTUAwe/l7zIqP2kAptg19Hc9kEcYKxQiNOTXx01eWmTOv/AVZ3ZpM2uIXspLPyAlrrHXN0lWETo4lYkR5UADSeOgW7/8giORVsGmSm4xyD+lQCNME+gnM+rtlWVQymVY2gGA/y0o8NzPrHVbbNn3qTFgh3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JE5n5f7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JE5n5f7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1481F00A3A;
	Sat, 23 May 2026 14:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779546131;
	bh=s9fjARsBMysz1G15TP7iWyQvrVYffiUhmqqsAqebBtA=;
	h=Date:From:To:Cc:Subject;
	b=JE5n5f7N9iJWw+M5+B1TweKIXMuXlEDJADsN0qGOgwnLRjxhpmKgWfoAR3ZG9O+ZH
	 ubNwywS8CuzEL9aCn8Zs0qv1rOGSdUg5lDbbpVGZTaL0MnFQd6mdonVF9kIslpr30W
	 87nEf77OxYPT4SvQ3J0chnA5dtUYP6RYzQnRj76Q6BX7MP/FSpHjt1CuT4m13mnsgy
	 W6pVDuM0pkwWWGhCWPtLtA4e4nisT9MgB8PNnGPCZtYTUUHwzgwl7u6BXU1F4O06PU
	 0ZwA2DX/p5U51qpMWO1dZgE/AS4LENexZIGdQjgybjTNnC15kWJtmnkNwplgj0mHuV
	 Ra72BnfXzgvDw==
Date: Sat, 23 May 2026 16:22:07 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.1-rc5
Message-ID: <ahG3Z0ngBT3K1Doc@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below? If there is
still time for -rc5?

An attempt merge against your current TOT has been successful.

This contains a single patch which if still on time I'd like to have in
-rc5. It's a fix for a race in xfs buffer cache which may lead to
filesystem shutdown due to inconsistent metadata if the buffer lookup
happens to find an old dead buffer still in the cache.

If it's too late for -rc5. I'll send you a pull request for -rc6 early
next week.

Thanks,
Carlos

"The following changes since commit 79bd2dded182b1d458b18e62684b7f82ffc682e5:

  Merge tag 'sched_ext-for-7.1-rc4-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext (2026-05-22 16:43:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc5

for you to fetch changes up to 8339dd0e5090f092c525c5e04b2a75ec5e5305a6:

  Merge tag 'xfs-fixes-7.1-rc5' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux into test_merge (2026-05-23 16:15:18 +0200)

----------------------------------------------------------------
xfs: fixes for v7.1-rc5

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (1):
      Merge tag 'xfs-fixes-7.1-rc5' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux into test_merge

Christoph Hellwig (1):
      xfs: fix a buffer lookup against removal race

 fs/xfs/xfs_buf.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)"
