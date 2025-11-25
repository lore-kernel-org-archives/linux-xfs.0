Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F6D254AFF
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 12:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764072222; cv=none; b=gRnnHGwN/m8xOCJ0XVHwaonvUPP/YL71qHa+GfcNV5sacbI+cOR8VY1tGbnUaRayaWOjqsTZXKKelmvy7jNIq5s1D2bfQZnRRwEAhu9P96sfLGIg7pHgDqYUcFiQ8RYu/WzgQqQF/1PHNLL2P9YU1BawKrfTfeI7umil3Nw9nj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764072222; c=relaxed/simple;
	bh=OoJayjNjGyOBWUMz3AXfo6bYb+JGe5ZiePcNzcWIaWY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iSzE/doPkfhsi8jWYBfSCxOQPwThb8nbsdH5TOWqUul/hyJuVvX83vq3gMISAVIxefJgCs3m0Jq/4ch49oJZ7wJFLu0azA0UAjr0D/G28zSpz4RobiEqPUz9ieugVqv5o1uXZAH9qwz5cQezup3sZhTI86JM/Ih2HsgnsrqDWTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edTJ2q4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edTJ2q4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F52AC4CEF1;
	Tue, 25 Nov 2025 12:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764072222;
	bh=OoJayjNjGyOBWUMz3AXfo6bYb+JGe5ZiePcNzcWIaWY=;
	h=Date:From:To:Cc:Subject:From;
	b=edTJ2q4qCO2mdJNjQ7o4ABBNbyLTPDNpaOzqtJflIIoueYfBxwxBeB7UVjY+KOwgc
	 Oo6Doz6DdYeFV56EdUzYPlu++rbztaRVXaydWqp4f155P44X1bkT/XqdVdUW+gSByt
	 98tFOP4ppb9QIOKuL2Q+pTYGybsTCeZ7mhJ+BsYfzNrbntQlj8K1wHaN17owHo2xkz
	 2QemoGt2gzHq8CgXfEkPjF9/0Db7pjTsOdPbhSKUUp3/Q2nMplW/7Pri1T1zBcaSTy
	 B6Oxthzk7FlLfrBZ8SztK3zWWSpKwJrczTbrOqrFxGxi4q7MoKqii9TrjxjV3JL9gq
	 +ZTIh7+A3nLww==
Date: Tue, 25 Nov 2025 13:03:37 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com, 
	david@fromorbit.com, djwong@kernel.org, hans.holmberg@wdc.com, hch@lst.de, 
	hubjin657@outlook.com, linux-xfs@vger.kernel.org, luca.dimaio1@gmail.com, 
	torsten.rupp@gmx.net
Subject: [ANNOUNCE] xfsprogs: for-next updated to b1b0f1a507b3
Message-ID: <by5k2dhfzvqgi3gjj4kpkdtifisvihbikrvidyqlu6dwszyqao@es47q4oooacg>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

b1b0f1a507b32d58b0d9f222c897020553a62e2d

New commits:

Andrey Albershteyn (1):
      [9ad52fc99722] xfs: centralize error tag definitions

Carlos Maiolino (2):
      [d7c096df3e8c] mkfs: fix zone capacity check for sequential zones
      [2a30566311e6] metadump: catch used extent array overflow

Christoph Hellwig (1):
      [d6d78495a0c8] xfs_io: use the XFS_ERRTAG macro to generate injection targets

Darrick J. Wong (1):
      [b1b0f1a507b3] xfs_scrub: fix null pointer crash in scrub_render_ino_descr

Luca Di Maio (1):
      [4a54700b4385] libxfs: support reproducible filesystems using deterministic time/seed

Torsten Rupp (1):
      [ac7ab8b0b80b] Fix alloc/free of cache item

Code Diffstat:

 db/metadump.c         |  27 ++++++++----
 io/inject.c           | 108 ++++++++++++++++-------------------------------
 libxfs/init.c         |   4 --
 libxfs/util.c         | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_errortag.h | 114 +++++++++++++++++++++++++++++---------------------
 mkfs/xfs_mkfs.c       |  50 ++++++++++++++--------
 scrub/common.c        |  11 +++--
 7 files changed, 273 insertions(+), 155 deletions(-)

-- 
- Andrey
