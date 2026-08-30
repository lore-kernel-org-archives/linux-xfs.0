Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400BE283142
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112173; cv=none; b=Mw0CLurB9VX00Vkn2ueYaMaAvtzTOBwXc4xwpsvc8etymFjEI1a9UaoDMfbyS2IXPenztvq3H4rTPSNOPMwsLIpM+8mIWacEC9QVrHjrGg32neI/qs2bgfk/0xUI6iJ5XDNzXBYAwFCVwl/bYCQ9NViTyKImPb5JHdGw7W3aTDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112173; c=relaxed/simple;
	bh=2fN1uFd/Q8RYdUoCSJfbiysHFcPTZl2JKfN6nOG01DI=;
	h=To:Message-ID:From:Date:Subject; b=qeZZ7W/tzVGYPFLKH+BezqZmkQbkJJsgfH8rUPotr/1DuWJNqMDWPm71XRkiEwPOV5Vj4nUSJYKVH0JrqQzydSaQ6zrAh4R6vq+aS0BJ0YUB57eb/X1KvzanehrdKiUyoUTHDujMVBxP/fivJgBJP2m15Ay1u4Ol+1s0c96hEbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=I+xuvl+a; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="I+xuvl+a"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04P5FhXzK8
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112165; bh=z3GJEFHCjeQzOnmoFjmr/77uy5pPH3cQdp6MEXhdo00=;
	h=To:Message-ID:From:Date:Subject;
	b=I+xuvl+aYZq0PsDhtjai6qlwGIyfwotKIkr52t8yzFxeKlmT/qVeJgWBV6Sq/jPOl
	 rjiN9jZgdDI76TUh7OuSGPvW5f28eG5MsYObVf3+i15jGduZGRzZwM0hhxEbcivYJl
	 hPqm53ISIAQBRbR9WAmyGSgTUzcgyBgP4F/HECUgU9EbI8PTReStkZHYN6ruWhxEnT
	 yCCdeE32fAARuYUMFpJpp+U2BNT93uzVbGN7yby3HYGqMgD0xo/a8mu/RLeGbNXub7
	 j6EBImYJ8CFATcH5TXQs9BiOoRtxnU71xy3iPRnYD9oB8HxdZHPRHISVjEdQ3gEgCH
	 Zp1a9t7/b0XgQ==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04N0SVvz9KQbD
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:24 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:23 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Sun, 30 Aug 2026 10:15:47 -0700
Subject: [PATCH 0/9] xfsprogs: add xfs_repair -R --- log replay
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Adds xfs_repair -R: replay the log then repair, without mounting and
without discarding it as -L does.  Patches 1-2 are standalone fixes; 3-9
implement -R, importing log recovery from v7.1 fs/xfs into libxlog/.

Chris Wedgwood (9):
  libxfs: make XBF_DONE actually mark a buffer uptodate
  libxfs: don't corrupt a delwri list when a buffer is queued twice
  libxfs: record a failed buffer write when it fails
  libxlog: rename xfs_log_recover.c to logscan.c
  libxlog: import the kernel's log recovery, log items and AIL
  libxfs-diff: also compare libxlog against the kernel
  libxlog: build the imported kernel code
  xfs_repair: add -R to replay a dirty log before repairing
  xfs_repair: finish deletions the crash interrupted

 db/logformat.c                   |    6 +-
 include/Makefile                 |    1 +
 include/atomic.h                 |    2 +
 include/builddefs.in             |    1 +
 include/hlist.h                  |   39 +-
 include/kernel_compat.h          |  231 +++
 include/kmem.h                   |   19 +
 include/libxfs.h                 |    2 +-
 include/libxlog.h                |   39 +-
 include/list.h                   |    7 +
 include/platform_defs.h          |   11 +-
 include/spinlock.h               |   18 +-
 include/xfs_inode.h              |    3 +
 include/xfs_mount.h              |    9 +-
 include/xfs_trace.h              |   30 +
 include/xfs_trans.h              |  118 +-
 libfrog/bitmask.h                |   17 +-
 libfrog/div64.h                  |    7 +
 libxfs/Makefile                  |   20 +-
 libxfs/defer_item.c              |  995 ---------
 libxfs/defer_item.h              |   56 -
 libxfs/inactive.c                |  181 ++
 libxfs/init.c                    |   73 +
 libxfs/inode.c                   |   43 +
 libxfs/libxfs_io.h               |   15 +
 libxfs/logitem.c                 |  204 +-
 libxfs/rdwr.c                    |  183 +-
 libxfs/trans.c                   |   34 +-
 libxfs/util.c                    |    8 +-
 libxfs/xfs_alloc.c               |    2 +-
 libxfs/xfs_attr.c                |    2 +-
 libxfs/xfs_bmap.c                |    2 +-
 libxfs/xfs_defer.c               |    4 +
 libxfs/xfs_exchmaps.c            |    2 +-
 libxfs/xfs_ialloc.c              |    3 +
 libxfs/xfs_parent.c              |    2 +-
 libxfs/xfs_platform.h            |   21 +-
 libxfs/xfs_refcount.c            |    2 +-
 libxfs/xfs_rmap.c                |    2 +-
 libxfs/xfs_trans_resv.c          |    7 +-
 libxlog/Makefile                 |   14 +-
 libxlog/logscan.c                | 1650 +++++++++++++++
 libxlog/util.c                   |   34 +-
 libxlog/xfs_attr_item.c          | 1206 +++++++++++
 libxlog/xfs_attr_item.h          |   64 +
 libxlog/xfs_bmap_item.c          |  718 +++++++
 libxlog/xfs_bmap_item.h          |   78 +
 libxlog/xfs_buf_item.h           |   71 +
 libxlog/xfs_buf_item_recover.c   | 1215 +++++++++++
 libxlog/xfs_dquot_item_recover.c |  214 ++
 libxlog/xfs_exchmaps_item.c      |  608 ++++++
 libxlog/xfs_exchmaps_item.h      |   64 +
 libxlog/xfs_extfree_item.c       | 1026 +++++++++
 libxlog/xfs_extfree_item.h       |  100 +
 libxlog/xfs_icreate_item.c       |  260 +++
 libxlog/xfs_icreate_item.h       |   22 +
 libxlog/xfs_inode_item.h         |   62 +
 libxlog/xfs_inode_item_recover.c |  602 ++++++
 libxlog/xfs_log.h                |  147 ++
 libxlog/xfs_log_priv.h           |  746 +++++++
 libxlog/xfs_log_recover.c        | 3308 +++++++++++++++++++++++-------
 libxlog/xfs_refcount_item.c      |  861 ++++++++
 libxlog/xfs_refcount_item.h      |   82 +
 libxlog/xfs_rmap_item.c          |  890 ++++++++
 libxlog/xfs_rmap_item.h          |   81 +
 libxlog/xfs_trans_ail.c          |  978 +++++++++
 libxlog/xfs_trans_priv.h         |  170 ++
 logprint/log_misc.c              |    4 +-
 logprint/log_print_all.c         |    2 +-
 logprint/logprint.c              |    2 +-
 logprint/logprint.h              |    2 +-
 man/man8/xfs_repair.8            |   68 +-
 repair/globals.c                 |    1 +
 repair/globals.h                 |    1 +
 repair/phase2.c                  |  246 ++-
 repair/xfs_repair.c              |   24 +-
 tools/libxfs-diff                |   11 +
 77 files changed, 16157 insertions(+), 1896 deletions(-)
 create mode 100644 include/kernel_compat.h
 delete mode 100644 libxfs/defer_item.c
 delete mode 100644 libxfs/defer_item.h
 create mode 100644 libxfs/inactive.c
 create mode 100644 libxlog/logscan.c
 create mode 100644 libxlog/xfs_attr_item.c
 create mode 100644 libxlog/xfs_attr_item.h
 create mode 100644 libxlog/xfs_bmap_item.c
 create mode 100644 libxlog/xfs_bmap_item.h
 create mode 100644 libxlog/xfs_buf_item.h
 create mode 100644 libxlog/xfs_buf_item_recover.c
 create mode 100644 libxlog/xfs_dquot_item_recover.c
 create mode 100644 libxlog/xfs_exchmaps_item.c
 create mode 100644 libxlog/xfs_exchmaps_item.h
 create mode 100644 libxlog/xfs_extfree_item.c
 create mode 100644 libxlog/xfs_extfree_item.h
 create mode 100644 libxlog/xfs_icreate_item.c
 create mode 100644 libxlog/xfs_icreate_item.h
 create mode 100644 libxlog/xfs_inode_item.h
 create mode 100644 libxlog/xfs_inode_item_recover.c
 create mode 100644 libxlog/xfs_log.h
 create mode 100644 libxlog/xfs_log_priv.h
 create mode 100644 libxlog/xfs_refcount_item.c
 create mode 100644 libxlog/xfs_refcount_item.h
 create mode 100644 libxlog/xfs_rmap_item.c
 create mode 100644 libxlog/xfs_rmap_item.h
 create mode 100644 libxlog/xfs_trans_ail.c
 create mode 100644 libxlog/xfs_trans_priv.h


base-commit: d6d4236027e31e9a54fd3916ff130b1d41e78027
-- 
2.47.3

