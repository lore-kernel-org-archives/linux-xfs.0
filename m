Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C9B3CB2FD
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 12:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910352; cv=none; b=T9FUqiW7Jr/feHHJVX3eTo5HpnF/ZJfKliA/K0WXoSIzGyfLVSZewqOLP0D3aDEkDnO6wbyFKaToFsPrPBkWt0KIXVXwpHAM3S0RYowlegd4JtLUywMyPm39PB/yh/kOnSLArvelBzuEGQi/CkO8CMewpCG25iZHKCxlptO8exQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910352; c=relaxed/simple;
	bh=K9/zzT0f9XM2i4SHWGWRnaFaFl9Fsj/eseAyr5GKdqo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ygl8YgG8TGdyhtuN4adtM506/rKcRvLt7ZvKEC+08mbyjvlUo+CYoMxtDy98kip69QNihipk+DIBIU9vUwAukZgB7oqhn+tUGyZ5wcVf2IYDenxSlpbq7tTucogKva2nbl86XpV4J7Ot7YOtWI52JL6CKTS+zDrqZsZOtnKh8vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9Dq0wy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9Dq0wy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739981F000E9
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 12:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782910351;
	bh=v5gLSRsfXshI/7qk60ez5Y9deoKg4CY6vioyyvBwzVo=;
	h=Date:From:To:Subject;
	b=I9Dq0wy+PacMdAiyCaiQX8SfLb9sfKRtfYSnEBgs8PWk9rjapk5e5MnYkNn1qywSi
	 QKlO2tySurEd1xp1e6vunmnKr33io2gm0uZ0emnoiCdQLrQxHpbZGv8c9gBAsLJi2O
	 eQYC/mDPJarNegqU+0ffZvoZtN9Eeq8a1OxiZUJhG/YCbXSK6A0W/8vR+sVUPpNVdL
	 fcrVYso6GWgt2m9lP4w7VrTit6fQUq2lQYXsbZ7WJ/RwmcRchdk3VEVYMKyW1wGnaw
	 DOXw+QqibtFie6eE4UZqqXGH/NK9pF9HPeus7pNzgTTWLnpWyKYwW/1eP1k7rqp7YO
	 7UAln+GInaIkQ==
Date: Wed, 1 Jul 2026 14:52:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e4281086ae6c
Message-ID: <akUNXDsTjZDlta81@nidhogg.toxiclabs.cc>
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

e4281086ae6c xfs: simplify __xfs_buf_ioend

14 new commits:

Christoph Hellwig (10):
      [c75283887457] xfs: split up xfs_buf_alloc_backing_mem
      [27d7d15184d7] xfs: lift setting __GFP_NOFAIL from xfs_buf_alloc_kmem to the caller
      [0144bcf61960] xfs: fix incorrect use of gfp flags in xfs_buf_alloc_backing_mem
      [19dc95d4b6cf] xfs: simplify the failure path in xfs_buf_alloc_vmalloc
      [6769087fd856] xfs: open code xfs_buf_ioend_fail in xfs_buf_submit
      [0b434b552ecd] xfs: also mark the buffer stale on verifier failure in xfs_buf_submit
      [4c8b46d832bd] xfs: improve the xfs_buf_ioend_fail calling convention
      [b53177d41822] xfs: remove xfs_buf_ioend
      [93e21ef2a819] xfs: fix handling of synchronous errors in xfs_buf_submit
      [e4281086ae6c] xfs: simplify __xfs_buf_ioend

Dawei Feng (1):
      [45de375b2506] xfs: fix memory leak in xfs_dqinode_metadir_create()

Yingjie Gao (1):
      [0c1b3a823a22] xfs: release dquot buffer after dqflush failure

Yousef Alhouseen (1):
      [cc9af5e461ea] xfs: use null daddr for unset first bad log block

jiazhenyuan (1):
      [7f53bf79bdba] xfs: fix AGFL extent count calculation in xrep_agfl_fill

Code Diffstat:

 fs/xfs/libxfs/xfs_dquot_buf.c  |  14 ++-
 fs/xfs/scrub/agheader_repair.c |   2 +-
 fs/xfs/xfs_buf.c               | 192 ++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf.h               |   2 +-
 fs/xfs/xfs_buf_item.c          |   3 +-
 fs/xfs/xfs_inode.c             |   3 +-
 fs/xfs/xfs_log_recover.c       |   6 +-
 fs/xfs/xfs_qm.c                |   5 +-
 8 files changed, 125 insertions(+), 102 deletions(-)
