Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3263932CF
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 10:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828600; cv=none; b=utFk0NeL6SwGj0MFQ+mlik1yCmdhabSQDUAJlsw6e+7Q0oXbAvEdXed8ZKoqeCackmWUQ+y+xj/0STCHh1oXHn54SYC17vu1xMngdbZZQqlRwu3qN/cz4J4ePouaIH3Vk6MF7l++h6loUpQHYvPYMuVJPTb0aOoBuYNDaU15ALc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828600; c=relaxed/simple;
	bh=A/joLl+nvTim08tBpBzVaERuw2wDtihdg1pgWOdBn4A=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CZnSUveDPYocsRn2ltmCKr+vhbG+gGlJMCwtmn0wQk4/fvleBrecx9GJdhTCdD6tJSxOOnaJb3xcRKSMj97nfzW5rY8D2SPzj2NQyoLQiMesXbQfTVAVCBSpNeBC8rjlwIioq0tkmOhG1pItHH3pkDd23NIkoIDqGie4xYt8EQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sedjQmMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sedjQmMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47D9C19421
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 10:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828599;
	bh=A/joLl+nvTim08tBpBzVaERuw2wDtihdg1pgWOdBn4A=;
	h=Date:From:To:Subject:From;
	b=sedjQmMQv5dcRnKehxGt8jt/sls2xWYDIxTKg0q8hVp4vPZttKRk3YeLf0MFSfeto
	 JIkzTznOiFZPdTC3Rb8K89a2gRIFqEC2n4ko0hTBQ/2kBSIrcgtHLzXEqRRr+mHYmq
	 OuriBPLUciW5fcckPRJw2xCj+lMubglumutUG8dOPdGABPdQl1c9E6nas6pTczLoZA
	 OuzQ32vrFj7LDi/FaOXDdGa7xOa19PvZ/OAhGn4FMkqS1rtuoA+Nxuq3yi6x/m7jAY
	 Pn8F2+Eu1Wy8DQjZWokwclciNl67p124ctpvIDuYwIbkVq5FSY/FSVic9BbimdKNiq
	 I06qrJOV0gkVw==
Date: Wed, 18 Mar 2026 11:09:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 2c0ff6151c7b
Message-ID: <abp5xbbTP82DAogh@nidhogg.toxiclabs.cc>
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

has just been *REBASED*.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

2c0ff6151c7b Merge branch 'xfs-7.1-merge' into for-next

17 new commits:

Bill Wendling (1):
      [e5966096d085] xfs: annotate struct xfs_attr_list_context with __counted_by_ptr

Carlos Maiolino (5):
      [db8367f63b30] xfs: factor out isize updates from xfs_dio_write_end_io
      [02a5d8993b09] xfs: factor out xfs_dio_write_zoned_end_io
      [3bdc20b005c2] xfs: factor out xfs_zone_inc_written
      [01478f356ff7] xfs: opencode xfs_zone_record_blocks
      [2c0ff6151c7b] Merge branch 'xfs-7.1-merge' into for-next

Christoph Hellwig (1):
      [0c98524ab201] xfs: cleanup buftarg handling in XFS_IOC_VERIFY_MEDIA

Damien Le Moal (4):
      [770323d418ed] xfs: avoid unnecessary open zone check in xfs_select_zone_nowait()
      [6a82a691b080] xfs: fix a comment typo in xfs_select_zone_nowait()
      [68aa101bf204] xfs: display more zone related information in mountstats
      [c1f955437440] xfs: avoid unnecessary calculations in xfs_zoned_need_gc()

Wilfred Mallawa (1):
      [c6ce65cb17aa] xfs: add write pointer to xfs_rtgroup_geometry

Yuto Ohnuki (4):
      [4f24a767e3d6] xfs: stop reclaim before pushing AIL during unmount
      [79ef34ec0554] xfs: avoid dereferencing log items after push callbacks
      [394d70b86fae] xfs: save ailp before dropping the AIL lock in push callbacks
      [7cac60947335] xfs: refactor xfsaild_push loop into helper

hongao (1):
      [268378b6ad20] xfs: scrub: unlock dquot before early return in quota scrub

Code Diffstat:

 fs/xfs/libxfs/xfs_attr.h  |   3 +-
 fs/xfs/libxfs/xfs_fs.h    |   5 +-
 fs/xfs/scrub/quota.c      |   4 +-
 fs/xfs/xfs_dquot_item.c   |   9 +++-
 fs/xfs/xfs_file.c         |  95 ++++++++++++++++++++++++----------
 fs/xfs/xfs_handle.c       |   2 +-
 fs/xfs/xfs_inode_item.c   |   9 +++-
 fs/xfs/xfs_ioctl.c        |  19 +++++++
 fs/xfs/xfs_mount.c        |   7 +--
 fs/xfs/xfs_trace.h        |  36 +++++++++++--
 fs/xfs/xfs_trans_ail.c    | 127 +++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_verify_media.c |  18 +++----
 fs/xfs/xfs_xattr.c        |   2 +-
 fs/xfs/xfs_zone_alloc.c   |  44 ++++++++--------
 fs/xfs/xfs_zone_gc.c      |  24 ++++++---
 fs/xfs/xfs_zone_info.c    |   7 ++-
 16 files changed, 277 insertions(+), 134 deletions(-)
