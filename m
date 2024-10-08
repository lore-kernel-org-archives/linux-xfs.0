Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9615413D601
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 09:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728379228; cv=none; b=ADWFZ2r8+KG6KhyHvapd3KgMNGQLGJgvXkrGnYAh98FOfI24eARLeUnUFRTBud+21uceeBsgQU18HFX646dNBgztX9pTBS77CTa+kQIAdEPQ7DDBDaTbFwsv0HupIEAog0UyOnxcDLxenaUPiG6tqhYE2Fz7NOWAcpAtOrZ2HYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728379228; c=relaxed/simple;
	bh=hOKj2SkZ2Gl4XF72JluTUjPO3MRvDwIKdg/bPqiCK9c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Jtf0Dj4w49EYeT11/08X/QS/XXEz8gqboKfI0gSkEJz6OgIVC8SLM1p997qs7PkHCXxiEjVqZABG/HmWmavc5np2n/9GT9H16muTGSsUMKc/9hJbpBeldKMzeEPs6JFPqRaPmLA3tUR2LFeCF0i9AWQL5bietYp8IdgXfQZwqlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfwqfzR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfwqfzR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946E5C4CEC7
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 09:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728379228;
	bh=hOKj2SkZ2Gl4XF72JluTUjPO3MRvDwIKdg/bPqiCK9c=;
	h=Date:From:To:Subject:From;
	b=bfwqfzR8M3BYsVL0oD3FA+yE9CIDsKD7BhX9p3eZkoQmXSt76f0zz/fTkGveBLws1
	 jWQcILKT1FkPGq1lieJ4MmMOzWxdHgZzueaLj58WyCefqg/U95mp9fV5niPx3llpQJ
	 GpTazoCglW6EFokg0EP2Eo42qkiAOd5NiN7UIfAeqhhIic1ted0jRw5oe480DiUhPW
	 bgCVUkdkjRFhMkYjgLqM1R/DYeuvworkuYdnBkD1g9bYaJcoPdzZ5Y3tNdeJR3AYR4
	 lRF0sUTYUv6TXxr2EytbuhnhrzAPnfqU/PXo+DzJLgcTW5OYiBTUtIQ0QlZICPQrZJ
	 2oDrpy8JdKIcw==
Date: Tue, 8 Oct 2024 11:20:24 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE V2] xfs-linux: for-next **rebased** to 44adde15022d
Message-ID: <d2ytdntpfth3vsynuqxzbaghna3dd2dgh66h5fpalrfuiimnz2@epzf7zftyhby>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is the same email as before, just sending it with the correct subject, my
apologies.


Hi folks,

The for-next branch of the xfs-linux repository at:

	git@gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been **REBASED**.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

This is a rebase of the for-next push from past week, where due problems with
testing the new patches to be included in the -rc, I needed to create a new tag
with the whole series to be sent to Linus later this week.

The patch list below contains the patches pushed past week + new patches that I
managed to test this weekend.

The new head of the for-next branch is commit:

44adde15022d xfs: fix a typo

15 new commits:

Andrew Kreimer (1):
      [44adde15022d] xfs: fix a typo

Brian Foster (2):
      [90a71daaf73f] xfs: skip background cowblock trims on inodes open for write
      [df81db024ef7] xfs: don't free cowblocks from under dirty pagecache on unshare

Chandan Babu R (1):
      [ae6f70c66748] MAINTAINERS: add Carlos Maiolino as XFS release manager

Christoph Hellwig (8):
      [b1c649da15c2] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
      [346c1d46d4c6] xfs: return bool from xfs_attr3_leaf_add
      [a5f73342abe1] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
      [b3f4e84e2f43] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
      [865469cd41bc] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
      [b611fddc0435] xfs: don't ifdef around the exact minlen allocations
      [405ee87c6938] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
      [6aac77059881] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc

Uros Bizjak (1):
      [20195d011c84] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()

Yan Zhen (1):
      [6148b77960cc] xfs: scrub: convert comma to semicolon

Zhang Zekun (1):
      [f6225eebd76f] xfs: Remove empty declartion in header file

Code Diffstat:

 MAINTAINERS                   |   2 +-
 fs/xfs/libxfs/xfs_alloc.c     |   7 +-
 fs/xfs/libxfs/xfs_alloc.h     |   4 +-
 fs/xfs/libxfs/xfs_attr.c      | 190 ++++++++++++++++++------------------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  40 +++++----
 fs/xfs/libxfs/xfs_attr_leaf.h |   2 +-
 fs/xfs/libxfs/xfs_bmap.c      | 140 ++++++++++---------------------
 fs/xfs/libxfs/xfs_da_btree.c  |   5 +-
 fs/xfs/scrub/ialloc_repair.c  |   4 +-
 fs/xfs/xfs_icache.c           |  37 ++++----
 fs/xfs/xfs_log.h              |   2 -
 fs/xfs/xfs_log_cil.c          |  11 +--
 fs/xfs/xfs_log_recover.c      |   2 +-
 fs/xfs/xfs_reflink.c          |   3 +
 fs/xfs/xfs_reflink.h          |  19 +++++
 15 files changed, 207 insertions(+), 261 deletions(-)
