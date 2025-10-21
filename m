Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D801B7F4
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761038862; cv=none; b=iOH5UPlc7hlWbKfIidoSQJsCi7o7mY48/4qhG5h6lC7SC6+lzj5C2Ya1FGWRh3yDt/n30fRXZnmw1SVXas+dpFUlYD6pTS2EJ8bJ2tVWLu7mGs4N0dfIkPHWVcb8zVdjBOwp2Oo60ebQKm8Mj7AtxV/UDy8a5laWLS1vIBuFQAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761038862; c=relaxed/simple;
	bh=iq9pi6r9e/8xBlD9CtW1bXesm2Hfusi21v0x9AYtQcQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nJF8N6HqO5Xvxe03NqvEAGIRL3ukaGBaws63ryBj1P3OqqFIwlDU1bSz73xHdSLI3udfWjkHIPgvej+XkTbkL5dO4ajD6VuZCXJ2kF8sdj0+nUFmpf7XT3P5IKImRwq34JiF8/XKI3u29BgY/1CBKBFIXtKobYwyeygS/46/s3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdxWIyzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdxWIyzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6B8C4CEF1
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761038861;
	bh=iq9pi6r9e/8xBlD9CtW1bXesm2Hfusi21v0x9AYtQcQ=;
	h=Date:From:To:Subject:From;
	b=TdxWIyzEBbMp+aPVTT0yD+beg04frWphQ71ldmnCrgzreXj9uFoGwrvZnZGSBe574
	 s1KSvYF0fWi0fWvwad7U+Msmvht8EX75apKddzkVK6l9TNFH1Yh7uoC0+HMQ0mojgL
	 9+9u5QRUFGMR+YqPUBA4XMlc2cEHeIiKNnjOAo1TN1vhPD0gY1o5axIHn9ywrjyl3G
	 +c0kaufIbL3f/mbr59p5rwLUrWiiQ/OzE+tdIcnrIz8IC4h9el2MvEBExUr083vg6h
	 vgYFYU73fTqdzvBZbujLrJMHfRsfDl5OSiQQahkwbdyOjtdouFCEVgKZRYUGZWoFTI
	 7t5dN5+6NKStw==
Date: Tue, 21 Oct 2025 11:27:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 3bfae8297367
Message-ID: <rwvoabw5zuxpvomreva4mxukjbjcblpymf7jjme6hxxq6kmthg@2aqld53xalgm>
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

3bfae8297367 xfs: don't use __GFP_NOFAIL in xfs_init_fs_context

9 new commits:

Christoph Hellwig (3):
      [778fce1346b3] xfs: avoid busy loops in GCD
      [3ad676ac0304] xfs: cache open zone in inode->i_private
      [3bfae8297367] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context

Damien Le Moal (2):
      [914f377075d6] xfs: Improve CONFIG_XFS_RT Kconfig help
      [b00bcb190eef] xfs: do not tightly pack-write large files

Darrick J. Wong (3):
      [6bd754bbd0b1] xfs: don't set bt_nr_sectors to a negative number
      [7806b6a3301d] xfs: always warn about deprecated mount options
      [43f2f9ec576d] xfs: quietly ignore deprecated mount options

Geert Uytterhoeven (1):
      [f5caeb3689ea] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS

Code Diffstat:

 fs/xfs/Kconfig          |  11 +++-
 fs/xfs/xfs_buf.c        |   2 +-
 fs/xfs/xfs_buf.h        |   1 +
 fs/xfs/xfs_mount.h      |   1 -
 fs/xfs/xfs_super.c      |  53 +++++++++++++----
 fs/xfs/xfs_zone_alloc.c | 148 ++++++++++++++++++++----------------------------
 fs/xfs/xfs_zone_gc.c    |  81 ++++++++++++++------------
 fs/xfs/xfs_zone_priv.h  |   2 +
 8 files changed, 162 insertions(+), 137 deletions(-)
