Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEECE329378
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 13:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762435719; cv=none; b=dgal2PjSxQSpzvbg6s581xKGT6puj61O1GDVc75GuPB9rscjrHpdWxkyfxx67Y7Y3TcG4SFsCRgQ9rHERoEzFD3XJ3tZXW+aDlkimYDmnh4rOkQ6EpnUE6/9CFlofk/hM+oGO/6K6oTaBsG8a2462sOJzbZ2nXGj4HHRmNCjZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762435719; c=relaxed/simple;
	bh=F3euZAkOv81UjY5I3HX4Otr/a7YiYAHBWOdwBL3dNd8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gi2n4eF5WoS1l0H4VmnoWE/HlcpWIz7dejBkH8uRj5+lEyKk3zXSi3z32kqemspEsyh/CZCtOVZfh6hWluPlh1hANgxK8GvYcLd8f9OBdJymVtyKA4Z6LhFVIT6CcEKyVeZ44t0mfbbkiZI5Q/98HDU+CiSuYD6DiEMsNMy2Pi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJEFaHQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJEFaHQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0927BC116D0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 13:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762435718;
	bh=F3euZAkOv81UjY5I3HX4Otr/a7YiYAHBWOdwBL3dNd8=;
	h=Date:From:To:Subject:From;
	b=nJEFaHQo6pB02xz8LIbKcZYeO8KVyvI+pfE0dleqbMiqRlHWzyuvLUy1lz+2z1leZ
	 0P9rSAZqcwRKo9owOg149N5wc4mpDbQ3HO+3/Dmh4JRMGvrDn8s2g1dSP0v34mth/6
	 yNPPujN8Os5pJ12BnZZuQBiRiW9cVRaCEQ7uiPEU2NmoES9IXSj2sF+ofV2/oFJzHe
	 byFEqywLb3xowzBXn+G+gYt7dCxPSd3ZhEm1kOtak8/rNuMUp8wxhtigXKxCaBkgQI
	 vVxsz/CBpZj5ighmvoXTB7sS+t4WAYHhVOzu20vByFE6rM7N8OK3DJj0Mit1Vzl6BK
	 NP3yG+MhZvwjg==
Date: Thu, 6 Nov 2025 14:28:34 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to d8a823c6f04e
Message-ID: <c7i4jh7rg2veresz4gdziig55rdq2zk5yit57ikzosgapfsobm@ufuqzttifija>
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

d8a823c6f04e xfs: free xfs_busy_extents structure when no RT extents are queued

5 new commits:

Christoph Hellwig (3):
      [f5714a3c1a56] xfs: fix a rtgroup leak when xfs_init_zone fails
      [21ab5179aafa] xfs: fix zone selection in xfs_select_open_zone_mru
      [d8a823c6f04e] xfs: free xfs_busy_extents structure when no RT extents are queued

Darrick J. Wong (2):
      [8d54eacd82a0] xfs: fix delalloc write failures in software-provided atomic writes
      [8d7bba1e8314] xfs: fix various problems in xfs_atomic_write_cow_iomap_begin

Code Diffstat:

 fs/xfs/xfs_discard.c    |  4 ++-
 fs/xfs/xfs_iomap.c      | 82 +++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_zone_alloc.c |  6 ++--
 3 files changed, 76 insertions(+), 16 deletions(-)
