Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941103BAD81
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775568201; cv=none; b=CIxTA+nPUptkoral1HOEMVKJLMv4k+zsikCwlNfvs5GflCDAcn0oZ8iZMtPYACTSCqohBGDYGDadB0nGZ7sY1Ub0SPDWzMknbBnalhgpj7swpLdA9tnaNPs8pWOIAvPlTUZwQPe+o0kl56RHG4eZX85qTRGCxZpl+JPIARwkP88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775568201; c=relaxed/simple;
	bh=WETSdJeLfDxeKedboNgR848kDMCPyKM4W5nGc1N5Fwk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WjUTjzo0/T8aP2R6749/vlZPcnJyzE4uLV1IarBsjgkPGPpzsvb8VcVLbkQMqfxuM6wskgeUqeIXaayfKwmMXJUbB2E2IpOT+HxHgnE14nOGqsDm9S7aOpItn6sQmfRAlt11lWXtyscp+0I0oGczFtcMjX4+APqbPMfOpiPoPKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=peU0bgWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="peU0bgWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54B1C116C6
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775568201;
	bh=WETSdJeLfDxeKedboNgR848kDMCPyKM4W5nGc1N5Fwk=;
	h=Date:From:To:Subject:From;
	b=peU0bgWZguuyoKKGU5tzOpkCJg9wFSP6rxbesnz2ShpF2Hp05uVA0tFzkwzJ1qoLA
	 knVC7Mnyp1CJIO7mEfGdyY3486+CpMkNFqg7h974ze74IelsHi07bEARGhI7GiOfQR
	 IO0ZE2kxKitKJ78ac9DxPenmH9zB8PZbfglffO+3qs0qDsQwNFoUua41smYArGfNsf
	 7jhbXHSZUEVCtFq6f6KtsxnPFbX9Zb9UsqaQmHDZU+0qgYTBdwSnnr95GtkaF3OivX
	 +pUuiyvaKiG3RtpvejINDjfhjFecqqLJVRJ8JQiDKpw9Eyz3ucDW6ueC4/+EI3uR21
	 0XXN4vRUqPOjw==
Date: Tue, 7 Apr 2026 15:23:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 2ffc6900d5c3
Message-ID: <adUFIZ8slrhBkrao@nidhogg.toxiclabs.cc>
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

2ffc6900d5c3 xfs: fix number of GC bvecs

18 new commits:

Christoph Hellwig (14):
      [0f7d2a9e0208] xfs: remove a duplicate assert in xfs_setattr_size
      [e92b3fc5b17c] xfs: fold xfs_setattr_size into xfs_vn_setattr_size
      [02367990bdcb] xfs: refactor xfs_mount_zones
      [c6584888864e] xfs: handle too many open zones when mounting
      [e771da0727c1] xfs: delay initial open of the GC zone
      [c2257d9f63bb] xfs: add a separate tracepoint for stealing an open zone for GC
      [a99ed5dbae01] xfs: put the open zone later xfs_open_zone_put
      [ca0170a7fa41] xfs: rename xfs_zone_gc_iter_next to xfs_zone_gc_iter_irec
      [53c1c822908d] xfs: refactor GC zone selection helpers
      [4c1b6e03e31c] xfs: streamline GC zone selection
      [1d0d9e9459c0] xfs: reduce special casing for the open GC zone
      [62c89988dc19] xfs: expose the number of open zones in sysfs
      [9de45faed34d] xfs: untangle the open zones reporting in mountinfo
      [2ffc6900d5c3] xfs: fix number of GC bvecs

Haoxiang Li (1):
      [29a7b2614357] xfs: fix a resource leak in xfs_alloc_buftarg()

Ravi Singh (1):
      [7338419a5e44] xfs: return default quota limits for IDs without a dquot

Yuto Ohnuki (2):
      [59e586d7dc78] xfs: fix integer overflow in deferred intent sort comparators
      [553a13e2076d] xfs: fix integer overflow in busy extent sort comparator

Code Diffstat:

 Documentation/admin-guide/xfs.rst |   4 +
 fs/xfs/xfs_buf.c                  |   1 +
 fs/xfs/xfs_extent_busy.c          |   4 +-
 fs/xfs/xfs_extfree_item.c         |   2 +-
 fs/xfs/xfs_iops.c                 |  39 ++----
 fs/xfs/xfs_qm_syscalls.c          |  43 ++++++-
 fs/xfs/xfs_refcount_item.c        |   2 +-
 fs/xfs/xfs_rmap_item.c            |   2 +-
 fs/xfs/xfs_sysfs.c                |  13 ++
 fs/xfs/xfs_trace.h                |   2 +
 fs/xfs/xfs_zone_alloc.c           | 150 ++++++++++++++++++-----
 fs/xfs/xfs_zone_gc.c              | 249 ++++++++++++++++++--------------------
 fs/xfs/xfs_zone_info.c            |  20 +--
 fs/xfs/xfs_zone_priv.h            |  15 +--
 14 files changed, 331 insertions(+), 215 deletions(-)
