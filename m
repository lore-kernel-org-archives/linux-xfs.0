Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03C52DCBFA
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106324; cv=none; b=Ei0uMq54tNIuWyNT/ORTcTV5f4JuOfTrOUlTLr4GTcbZ66DEqrfrcqeufvEmFE7ZHMHvC0AN1J73qiJNnr/bvfagXqkioMobsGK2SZDlZ0HGL2H4+cmYWZkWBFL4FcdFJtyuvYv5su/THZ93JFwXQp6Q8PcVT0OJSOCEVzq49Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106324; c=relaxed/simple;
	bh=TggmjViF/l8halHk5NgQbyyKK6rev0jd6+0H3dpU4KU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uyjmtCLNRB8QonNFq0fptlYk5V/bSWlxeHhsUC8VhQrfABlLI+ejV1WuZlRjxX7RSToNU7ONnGFktHnjhY11rJZR2sjxI9vUUPWs6Orr5r6K6xdGMXwgSwdWrw2IvKFlLh02nOiJhHN4guPSXkUmOGwii7eIVJewhkOVV9c/bDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYhaGQu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYhaGQu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21C01F00893
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 15:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106323;
	bh=nqOrn4hI7f9FDEMCo+5JgcVHL+lh28kUvwn5swVUCQQ=;
	h=Date:From:To:Subject;
	b=eYhaGQu5Xj8KRF2sgSXrgDtjJ9BAdzGr7IT8uy0inmh3T23Qdm8+cU947SPLT0hp2
	 pbVJCrsGZWf2Glh0V8kXQktVAzuo8Sqe88EjJNErNs5EjsFIliaXKBzvELzIaYD93I
	 KUHRIAOOrkzOKS/hKcgmeessD5WTFnW2B6mecGYhLuRpCqhrKqO7EaUu/R50f8Px1Q
	 urpeyZhqhcJNKnMcakBP2yQtJvMY8DwM8ia1uSzj1fcvfPn6gA0VmqRSLRb/7x83d+
	 KWBoIRHFzQEoHxKFSC5EHUIOt9pKl8nFeBTVeMyJeC8cAj6rWWRtdaqFfE/D/Np7X5
	 ZjNxNVc8PbCzw==
Date: Wed, 10 Jun 2026 17:45:19 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to dfac6ba84819
Message-ID: <aimGf3Kmrfe9MluF@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

dfac6ba84819 xfs: cleanup xfs_growfs_compute_deltas

7 new commits:

Christoph Hellwig (6):
      [16fc9d358d12] xfs: factor out a xfs_zone_mark_free helper
      [ae3692c7f440] xfs: add newly added RTGs to the free pool in growfs
      [44cccefe6574] xfs: only log freed extents for the current RTG in zoned growfs
      [327e58826eb7] xfs: initialize iomap->flags earlier in xfs_bmbt_to_iomap
      [4cb6e89a3d90] xfs: pass back updated nb from xfs_growfs_compute_deltas
      [dfac6ba84819] xfs: cleanup xfs_growfs_compute_deltas

Darrick J. Wong (1):
      [84eec3f7fc73] xfs: fix pointer arithmetic error on 32-bit systems

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c         | 44 ++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_ag.h         |  5 ++---
 fs/xfs/libxfs/xfs_bmap_btree.h |  2 +-
 fs/xfs/xfs_fsops.c             |  4 +++-
 fs/xfs/xfs_iomap.c             |  2 +-
 fs/xfs/xfs_rtalloc.c           | 16 +++++++++++----
 fs/xfs/xfs_zone_alloc.c        | 11 +++++++++--
 fs/xfs/xfs_zone_alloc.h        |  1 +
 fs/xfs/xfs_zone_gc.c           |  4 +---
 9 files changed, 51 insertions(+), 38 deletions(-)
