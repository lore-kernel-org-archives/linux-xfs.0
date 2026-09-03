Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274633C8713
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415526; cv=none; b=uCwnvvnkD+0X0DXjUrQ7yBFRXUlgcoKQV/v51F8FWLLTqA5Z9Z8cNL5V6kcyirsN6nrG04EdL5itB0DAZZd3kWFCTlK4FVT4Bn1vrGuuRcUubhzFBLSUGHtfUK8CHRVa3TWAJZVSp9Ofhgl0nQ1rsU0lVNc5uhQGfDIHP6TVFRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415526; c=relaxed/simple;
	bh=4Cs9ylv9T8zQiznQdwgHUMKzRUIGz/4l2dhvm+Wc+3c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fdAW3UbyLIjWslINly0eXDM1Kg7BzNaQ86dQHWxSAbuR/CAHbsTCGyj8pVvpVKLTAtH7XpreAIqSvG+fZpKwXthCTDnX5YvMFIKVTNXvtWJkxrUlxL0YKM7QH0NLB5eePWBGWPzQR/BchSaCbU9sT/2EmeASC7iK4gQtA9DY47s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OkGthlb7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XBwD3XAY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OkGthlb7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XBwD3XAY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788415521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=uskfD/KTTNew69Tjdivgp3/40D5711G6TJyiiCxOr5I=;
	b=OkGthlb7gJVlvoe3RlEM3NC0lgrRcxAXe15ehZfj9ktnpi8NLg2ubMMsQ6/8/au4QQ7LYS
	igNZ047cXB0Vpc8U5wE6nLKPqhTFeghBSTAPX66nMbKrLWHSGz9Hm6ByVa0Xi/UkiH++ki
	NmWwex1txDyGf17DMQOqQCxt3bxb0LI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-bCIhjK_bM7mbiPw49e2w2w-1; Thu, 03 Sep 2026 02:05:19 -0400
X-MC-Unique: bCIhjK_bM7mbiPw49e2w2w-1
X-Mimecast-MFC-AGG-ID: bCIhjK_bM7mbiPw49e2w2w_1788415518
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so11237655e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 23:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788415518; x=1789020318; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uskfD/KTTNew69Tjdivgp3/40D5711G6TJyiiCxOr5I=;
        b=XBwD3XAYA7uyBJn60Xq+yWxq0p1EeLM4+Kp4kUf9aAUmESUx50bKdY8jI9LWUnTTof
         mRt1Wtbh+7lovHnn3BozwRqqw1g+qc3MDTGjfCctlmGxlZFZq1S2cnjMqomRm0ybVqME
         8rBIy+1208CAZk6s7PxwGQgqIvgSXNQ3Oja6zooTey1GwQPeO0+R2tuirhZbSSVsoxR+
         QW813Sd/TqwkDS1795xkkoNEb6JPsg6IMvy9kdB12EngrdWffL8UJYxY9LDUWFomktzI
         krHF7RyoJF+kQEI9zyKBX7hcHC74sh/EuLZ/B6ni3u9G2cDNju9KDv1XAecteK6ZbF8C
         rOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788415518; x=1789020318;
        h=content-disposition:content-type:mime-version:message-id:subject:to
         :from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uskfD/KTTNew69Tjdivgp3/40D5711G6TJyiiCxOr5I=;
        b=a0LdKQpNibQs3pGGq0qL1LSxZZj1RT8E1vWp80woXcOuuqr1NHTajCoFklprL1Wja3
         OCPluyF/7lT1QWIKKY446su14KY65JBM5mGVcELXzMo6hoVO2XG/JW8bxjdxTsGsD7u/
         yWvqzv05LKjApQLG8YvvvepDc1gZrg1rBVSDehWFrN4/o5kCEbgNbQB843mc1WQvTmvt
         96HFuweV5qIo5jVcitztIEaYNxmUTODYLwnWq2surPfQkLrvLdxvfVPrOi/NGVdCjSth
         hg7QORHT9CSZMcIdR/91ZICU8qG/cLQNgSwPcxlpumGlSm1RB5gS8YIbWGcsrl63b4KW
         G/Zg==
X-Gm-Message-State: AFuF++lHxyrjOGP5Z5ue69WGWWtYUrE5MjHoqAOZm2vhdquQsJjsqnsE
	I6P7AsJwn+5qMYiq2X/yNPpwADsorwGir/FdT5Fre0bG21VizEXbg+/jpd2VpzcKh4cWrTzf98H
	iOy8abYxhdNuNVdYfbVhpIf3GAfRAY2yeOkLjt113IV2F6z6fYD+CJne/fQ19BEpGLMI2/ImaPh
	TN5WEhzwGMWV6T6HlOFFtQzheoTUrOe7tIJ25cEasQw53MlAE=
X-Gm-Gg: AYBFou0zQZAQv8y9vbFxpDaFLaJ4ZchFWeQnXokTdObGZboPAlCg+MUqSSnFWXtOWHz
	z0mmjbNiEV3XicNDQERbp28GTEy2n4cUrRN506OQtD7fPiWyHMpx0GC/siI69MbafEF1k+sERbD
	lSlXI6AyaxK5LyXD68KJd+LTtVLp8pGPrn3D1WqECUBv8vRRzqv74M3VbNXK6Cmsworkzu+pJQd
	9piKuUZqGEkeA90o7UxaXMhyM+GtINOyL1yR37dkoTG5udtFssUHSQlPvtxVlf6KYeWRrJGfo+3
	BeUzrK1HJxiKFViGwscFRLUMxa0XZDic6Hl1LRMzkya3S4u8VHM4/+Ee8vv26/4x+sJWsO/Xv//
	isAD4zSLjgwo7RZvvycyTsxCqbnaOTFlSOuvyQ6NZB2A=
X-Received: by 2002:a05:600c:83c4:b0:499:8ff5:8ecc with SMTP id 5b1f17b1804b1-49ce58268afmr176104405e9.15.1788415518114;
        Wed, 02 Sep 2026 23:05:18 -0700 (PDT)
X-Received: by 2002:a05:600c:83c4:b0:499:8ff5:8ecc with SMTP id 5b1f17b1804b1-49ce58268afmr176102935e9.15.1788415517454;
        Wed, 02 Sep 2026 23:05:17 -0700 (PDT)
Received: from andromeda.toxiclabs.cc (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee60d8a6sm42919475e9.10.2026.09.02.23.05.16
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 23:05:16 -0700 (PDT)
Date: Thu, 3 Sep 2026 08:05:15 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next rebased to f7cc83204d79
Message-ID: <apkNzIuW6OiR3VId@andromeda.toxiclabs.cc>
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

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.
Giving the early stages, expecte a couple more planned rebases so xfs
tree does not get too far behind main tree during 7.3 develpment cycle.

The new head of the for-next branch is commit:

f7cc83204d79 xfs: release alleged child inode on metapath unlink error

42 new commits:

Anuj Gupta (1):
      [f7cc83204d79] xfs: release alleged child inode on metapath unlink error

Christoph Hellwig (24):
      [d7cf5c006dc3] xfs: remove an outdated comment above xfs_file_ioctl
      [fbbf446c322a] xfs: rename xfs_ioc_swapext to xfs_swapext
      [098a0ee1b45f] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      [6c015db4e9d9] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      [4b18c2835c83] xfs: split out the handler for XFS_IOC_DIOINFO
      [80e352a27758] xfs: split out the handlers for XFS_IOC_.*HANDLE
      [45af54ac546a] xfs: split out the handler for XFS_IOC_SWAPEXT
      [7c98c4461679] xfs: split out the handlers for XFS_IOC_FSGROWFS*
      [319acdc8b39e] xfs: split out the handler for XFS_IOC_GOINGDOWN
      [a443db96c14b] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      [2b7755e216c7] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      [3368d51225e8] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      [b193b5f5b124] xfs: cleanup XFS_IOC_GETVERSION_32 handling
      [af563225303d] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      [490ada212650] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      [0a57de878fcc] xfs: remove an extra cast in xfs_file_compat_ioctl
      [b47988c1881c] xfs: fix the lock annotation on xfs_iget_cache_hit
      [95e4f208b067] xfs: fix the lock annotation in xfs_extent_busy_update_extent
      [479fbaa8751b] xfs: fix the lock annotation in xfs_mru_cache_lookup
      [52f5bed99875] xfs: improve lock annotations in the log code
      [d5cb9fc90943] xfs: add lock annotations to xfs_try_open_zone
      [a34356467f2c] xfs: add lock annotations to xlog_state_shutdown_callbacks
      [24835368f11d] xfs: add a lock annotation to xlog_cil_push_background
      [dc1c4245c2c5] xfs: add lock annotations to xfs_ail_delete*

Darrick J. Wong (7):
      [153c75d93cd5] xfs: fix media verification ioctl for internal rt volumes
      [583c8e876783] xfs: don't spin forever on zero-length dirents when salvaging them
      [b2362aac3c91] xfs: don't stash removename operations with unknown ftype
      [6aaa121b24a3] xfs: log the tempip after we convert it to extents format
      [e5604e9446fd] xfs: fix parent rec lookup initialization in xrep_metapath_unlink
      [0b0a74f7fcbb] xfs: handle reconnecting metadir subdirectories
      [41fbf820b6d0] xfs: lock the healthmon when inserting unmount event

Eric Sandeen (2):
      [c1a54ce86def] xfs: fix reclaimed page accounting in xfs_buf_free
      [033067938274] xfs: mark slab-allocated xfs_buf backing memory as __GFP_RECLAIMABLE

Hans Holmberg (1):
      [d5ae1c095942] xfs: prevent race in zoned space reservations

Javier Tia (6):
      [08e6a7587c0a] xfs: initialise error in xfs_defer_finish_one()
      [6c81238928c1] xfs: give the deferred barrier op type a name
      [17783da399db] xfs: report the error that made deferred work shut down the fs
      [410822bd69ef] xfs: correct the parent pointer space reservation comment
      [47531ec00c81] xfs: initialise args->total for parent pointer updates
      [21a0382da84f] xfs: assert the reservation covers each da fork growth

Lin Jiapeng (1):
      [f3772e189ee8] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c    |   1 +
 fs/xfs/libxfs/xfs_defer.c       |  18 +-
 fs/xfs/libxfs/xfs_exchmaps.c    |  10 ++
 fs/xfs/libxfs/xfs_parent.c      |  12 +-
 fs/xfs/libxfs/xfs_trans_space.c |  19 +-
 fs/xfs/scrub/dir_repair.c       |  27 ++-
 fs/xfs/scrub/metapath.c         |  87 ++++++++-
 fs/xfs/scrub/symlink_repair.c   |   2 +-
 fs/xfs/xfs_buf.c                |   4 +-
 fs/xfs/xfs_extent_busy.c        |   4 +-
 fs/xfs/xfs_healthmon.c          |   6 +
 fs/xfs/xfs_icache.c             |   3 +-
 fs/xfs/xfs_ioctl.c              | 385 +++++++++++++++++++++++-----------------
 fs/xfs/xfs_ioctl.h              |   4 +-
 fs/xfs/xfs_ioctl32.c            | 188 +++++++++++---------
 fs/xfs/xfs_log.c                |  33 ++--
 fs/xfs/xfs_log_cil.c            |   3 +-
 fs/xfs/xfs_log_priv.h           |   4 +-
 fs/xfs/xfs_mru_cache.c          |   2 +-
 fs/xfs/xfs_trans_ail.c          |   4 +-
 fs/xfs/xfs_verify_media.c       |  24 ++-
 fs/xfs/xfs_zone_alloc.c         |   2 +
 fs/xfs/xfs_zone_space_resv.c    |   8 +-
 23 files changed, 563 insertions(+), 287 deletions(-)

