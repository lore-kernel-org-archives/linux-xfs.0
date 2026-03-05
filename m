Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFAB375F86
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 09:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703910; cv=none; b=Dmtm+pXCuphsMtKStaPbmpOW7LQZWPJVtiGLGZE6mveR/px2Y/qvWZCfFzBo5vp+FeVGRKe9eX/z7/A87Ofo5Hsfcb+cTaMB2aWOiJWoScC1HiYbG1yVm79QXOYH571wBmfqje43lmOhfgJbqDvE0CslS9NWCD2Du1EQbW2CLfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703910; c=relaxed/simple;
	bh=uxQsYzThzDRnaCaV3sfw6HNfaeHM2phM5iyO01dOR9Q=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pY96c5sWwV6mlKtp7K9s/DsmctknNBXZ0+o4taA+YDDEmELDSAZsFgeKdfp4OdrgpEToPy7KpW+Ply8pWQKXhj4Y+nfQfCo4NfFY3LFsw5rWMt9aFoHUj4AwTbGg5rf4exg27yBnH9Vo5GyrmuFN7MuO+jDkHgyRwQfH8p5CFwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=myEhMP0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="myEhMP0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E11C116C6
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 09:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772703909;
	bh=uxQsYzThzDRnaCaV3sfw6HNfaeHM2phM5iyO01dOR9Q=;
	h=Date:From:To:Subject:From;
	b=myEhMP0ehgzdET8HxaqH8LjJV24cKJRgw2NWtva4Zy5LFBNiw48/y1SZZgtAeATGc
	 jIMU2xRIZyq1pQDc/dHa4rge/H9wCxoofbiMTIfsgL8a/rc6Yw0XdqQzDKHpWga3q3
	 TXR9RvJ/V23VP37It3Pl8hOffFY93F1j53MshTAwaWebH01ny8icJ4HFkUlGFMaEc8
	 dnqrmOFQBfe0uLXIBDgr45FrjjMByqecH/TPfZqC4/9bj4PGdHQrWpA4CapkiP0toq
	 f7DEsgRdc2zJ9x9YgQNp1QauratrgCSPqI5GZWduvome6GUF+F4lp/Hv7ppS1ARAqA
	 cXTYOHfqpskbA==
Date: Thu, 5 Mar 2026 10:45:06 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 625f2cf0ed12
Message-ID: <aalQOTbe52ssILn8@nidhogg.toxiclabs.cc>
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

625f2cf0ed12 xfs: fix returned valued from xfs_defer_can_append

5 new commits:

Andreas Gruenbacher (1):
      [5be2161f245b] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit

Carlos Maiolino (1):
      [625f2cf0ed12] xfs: fix returned valued from xfs_defer_can_append

Damien Le Moal (1):
      [6270b8ac2f41] xfs: remove scratch field from struct xfs_gc_bio

Darrick J. Wong (1):
      [0ca1a8331c0f] xfs: fix race between healthmon unmount and read_iter

hongao (1):
      [281cb17787d4] xfs: Remove redundant NULL check after __GFP_NOFAIL

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c |  8 ++------
 fs/xfs/libxfs/xfs_defer.c    |  2 +-
 fs/xfs/xfs_healthmon.c       | 17 ++++++++++-------
 fs/xfs/xfs_zone_alloc.c      |  9 ++++++---
 fs/xfs/xfs_zone_gc.c         |  2 --
 5 files changed, 19 insertions(+), 19 deletions(-)
