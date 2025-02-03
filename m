Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E6120468D
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 12:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738586431; cv=none; b=t64jD+OIQS3AN0ykwnv1pl/lM7P5AawkeI/XRPRXkxXCkJudf3K2wEFtzu+dtQYNfhGzr/8BacQLr7zSxcWDxmIwCRKMjSBURJCzox7blA+5bHWGQ2bfjXX5pBSd3kL/9Q5Iqu0HWanXbnJar2BwW4o9f+hCvooV+cvLGzJgFJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738586431; c=relaxed/simple;
	bh=FE1NYBZ+dVMfCi+qz7wbbqi4UawhsmtUntEsP+8VCCs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uAEXshz2HDcst3GM060c489fom3KUSunXfCKrANw6zcjNi/icvvQixg3d2vEMl/wx9UXYHf17bLN6xxSzoXX9Bd2LSqb3OWwlYI1XBBsm51Eds4cbuQ6ry87Zkw/f/tz52HsSmE61U9CQaFMR6mbdm7KW2VJSoRuXIpbaPADKdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqagxHhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqagxHhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA27C4CED2;
	Mon,  3 Feb 2025 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738586430;
	bh=FE1NYBZ+dVMfCi+qz7wbbqi4UawhsmtUntEsP+8VCCs=;
	h=Date:From:To:Cc:Subject:From;
	b=OqagxHhUc7VSCYT/GJuFrGfQXwmrLt6o4ianBa6qCi4AmA3vi9YC0PYDA4yjANZGq
	 1oEugaM29mlYQxLIjzIEuokiOpR0pbD5NBWn8dq0nyfeGmXNtu9/jUPGmpXwCsOuwe
	 yblB/r4G+xzOQNzDczX4mm61QGrl4NWYi8vkNLhXMSctAwrOWpZ143Gi9MJ1T4+0QM
	 Ix+9D+DudGiaKYNkOIQuHXdxNLLzwG4mqeAFIZkGaW3TqbTaV4+zUDUnNvEjLT6/wQ
	 YnVYcpS4FP1Nmd1VXoQDae5aEFqWFv3Y2TP0Z7beYHv8lvJROLwRk44I7ahwZLhTWg
	 MUjXlocrPqIyg==
Date: Mon, 3 Feb 2025 13:40:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for 6.14-rc2
Message-ID: <asmybeduuf7ue3yd4akkyhjuwxbeb5yepprzs72zgedgj2xjir@cxbpahwzp5c2>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi Linus,

Could you please pull the changes contained in the tag below?

It contains a few fixes for XFS, but the most notable one is:

* xfs: remove xfs_buf_cache.bc_lock

Which has been hit by different persons including syzbot.

I just tried a trial rebase against your TOT, and no conflicts have been reported.

Thanks,
Carlos


The following changes since commit a9ab28b3d21aec6d0f56fe722953e20ce470237b:

  xfs: remove xfs_buf_cache.bc_lock (2025-01-28 11:18:22 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc2

for you to fetch changes up to a9ab28b3d21aec6d0f56fe722953e20ce470237b:

  xfs: remove xfs_buf_cache.bc_lock (2025-01-28 11:18:22 +0100)

----------------------------------------------------------------
xfs bug fixes 6.14-rc2

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
