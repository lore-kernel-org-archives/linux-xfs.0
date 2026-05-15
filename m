Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E493F8894
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778867097; cv=none; b=Bb9He/e1srIs/HzHn2TQflFIlJUT3QQk1rYKCRS5RTBJudk/MxiEedYIF9oKYMnegTUX9PsvkEa4UBHISgD6t9J3K3tXLqNFsEmwNERbz2yhpUoL45m3tUtixW6xY66MiF7K4rNxGtkfxNeTKii9NByWmAjgQamYtuDn2eaTY88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778867097; c=relaxed/simple;
	bh=6fCaB3apd6vhSsv+6m3ItKq6KkH8E/dZed7/nRERkJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m2TQt4dNUelWYLpbMzxLe1ZIrYu9z2ZErhf/PhEDBN0CiCwXc5dC+/JQ0i4M7YxGMRSLm+y7cN2Bg6OCq3bFmIIMEwIEvptTmmkETVGj+xnIVkiE+sMf9LSMMDRX923bHYo7Em/bjayc+4BzbIYIKJha6sNMS1TXwcaicO0murI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1X87NAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1X87NAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C636BC2BCB0;
	Fri, 15 May 2026 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778867097;
	bh=6fCaB3apd6vhSsv+6m3ItKq6KkH8E/dZed7/nRERkJ0=;
	h=Date:From:To:Cc:Subject:From;
	b=Q1X87NAOYFqkIiTgJK1XmM93BIq+v17wLz0qtlP+8zTwM/VVWJIvVWFdzGTRCQG+L
	 d1JoRD6r7RLB3g/eh/jEgQSwBf7kdAOI0oQxSuBIN6TazWchFTrRv+0eWn8kYGQtdv
	 XdP38fObIDAUMQGVo4Pl3aVTw+GcMmO5+1jXRr7QP4W0cKJf4oh/Vq3v1ICMGIzpkQ
	 DiLj7wAiSarcKQInnhkeRna05VnxruQ1pbO4w0Jk1uxF+8xLwQULwhTHR3tfFyBbUA
	 PmAJLDS7ghUifsXa4yOD6/0bd75LKpMHRYmYL06lGP1o7tjGMaebHghuC5L42iCYfq
	 FaSbPaIXEbK0Q==
Date: Fri, 15 May 2026 19:44:53 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, ailiop@suse.com, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to b623033285fa
Message-ID: <m5ggtwyzilbszthawlxz3u3ctf7ncncl7zosk3pr5lla4bojgv@gysoo7h5aaap>
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

The new head of the for-next branch is commit:

b623033285faa158581ba5d345797c8a9ae66ada

New commits:

Andrey Albershteyn (2):
      [6149155d0589] xfsprogs: update release.sh with fixes from xfsdump
      [b623033285fa] libfrog: add missing HAVE_LISTMOUNT flag

Anthony Iliopoulos (4):
      [5a26358ae3d9] configure: always check for statmount supported_mask
      [877f0e57a10d] libfrog: add missing statmount flag definitions
      [b30356f25335] libfrog: add fallback stubs for libfrog_statmount and fstatmount
      [434afafebb3d] gitignore: add xfs_healer binaries and services

Darrick J. Wong (3):
      [66fff0c12fda] platform_defs.h: fix __counted_by_ptr annotation
      [7329ba24ac39] xfs_scrub_all: remove dead code
      [46efb75687bd] xfs_scrub: remove dead code

Code Diffstat:

 .gitignore                |  3 +++
 configure.ac              |  2 +-
 include/platform_defs.h   |  2 ++
 libfrog/Makefile          |  1 +
 libfrog/statmount.h       | 22 +++++++++++++++++++++-
 release.sh                | 20 +++++++++-----------
 scrub/unicrash.c          |  7 -------
 scrub/xfs_scrub_all.py.in |  6 ------
 8 files changed, 37 insertions(+), 26 deletions(-)

-- 
- Andrey
