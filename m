Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5781E0B96
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730285081; cv=none; b=lqp8rnRIdkzEMRifVWWqVZPFgVf82buOgh+owhs1UF3FtYqOj1W76rAjFs38D5UgYo0YEmVi7naXI4E1Rh2Ljtz6nXZENK5NrRNM1S5T/eVMuRR3LdjESwmsjJ4rH64zMHYKe9Z/ENgkROfJ7OvtZHPAnBuHhZoO2DsTOcN5SQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730285081; c=relaxed/simple;
	bh=Wcll0aJF9iDvMdLWVytg021U2BwMUYklVZr8TIGf4iY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Hdn2qGGuvHr+vDiBsGk3Mt6Xur769lKnvQ/eFElnf56N8v4PCqk/WII2Etuobtu3RFYeQL1AN/x7gHzp8MlHrd3lpzhdODSASWiK0UZ+kTSX5yP2QR0pKEa4cuXqyrqpiMxXgR00HUdmwdevpw8DWPpKxfGvHZlIoZaC4442oiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uarcWm9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uarcWm9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9B8C4CEE3
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 10:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730285080;
	bh=Wcll0aJF9iDvMdLWVytg021U2BwMUYklVZr8TIGf4iY=;
	h=Date:From:To:Subject:From;
	b=uarcWm9Ns7TIdQTPNdugFsWZMi4liK/F+GGuQb43P9gT0FVGcjZ6DZB/xcEUWuESk
	 e9+4zVWAbxlDq0iYJ2j1h2wrbmHZyHIeKrlEO/e+VVDdBXyj2l9NA4f6f3Hzkp6UQB
	 92LZqqJM2r/l6NjqIfTU9iKNfvhIKrEuGf7t34hpIzQKmI1hq2WHzGsVqBGg151dOi
	 ECUUGPDEBUhpY1vT/SF8uYm9D73atj8wEkK+Efq6oBEDo0/eO7TgGCJuuWng7CnmAj
	 qD9CyGkal/nmrmr/vNlJ/iI3ZXyCuv8BbkYUaRytCsS3hP+h42/y5MEL9pUT119mGR
	 fWnXBkb3PLYwQ==
Date: Wed, 30 Oct 2024 11:44:36 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 81a1e1c32ef4
Message-ID: <x4opsrn3fr7gzulgcitenrqu7jdrartbzzkgth2rq27vpk5mzz@vzax3kcvuzt7>
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

81a1e1c32ef4 xfs: streamline xfs_filestream_pick_ag

4 new commits:

Chi Zhiling (1):
      [3ef22684038a] xfs: Reduce unnecessary searches when searching for the best extents

Christoph Hellwig (2):
      [dc60992ce76f] xfs: fix finding a last resort AG in xfs_filestream_pick_ag
      [81a1e1c32ef4] xfs: streamline xfs_filestream_pick_ag

Ojaswin Mujoo (1):
      [2a492ff66673] xfs: Check for delayed allocations before setting extsize

Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c |  2 +-
 fs/xfs/xfs_filestream.c   | 99 +++++++++++++++++++++++------------------------
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  5 +++
 fs/xfs/xfs_ioctl.c        |  4 +-
 fs/xfs/xfs_trace.h        | 15 +++----
 6 files changed, 62 insertions(+), 65 deletions(-)
