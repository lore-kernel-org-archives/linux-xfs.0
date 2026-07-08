Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EA93B14DD
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 19:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783539261; cv=none; b=CeUUzUzSBWHpSlP4qrGMnD6PwD56aNmfeT6QHAou7JlnGXg01R1shZIg0aXrUzLnpjbluKb+MThZrv7/rI7eDwmpRBPfLi5sZNNurtTBhzOsJknIRMmSji1RnOepQN3nxUbhyL6R8xF09hfd0mjWCK2RGyAT7etCj2M3ZP2ZqW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783539261; c=relaxed/simple;
	bh=XeaM4y0MFCroUxqiv2Bwq1btEUWlKSYfmcevF87U9iY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GuEidIPn6KtbjrJRr+KfC1QL76lm85qqlNlopGmwkfnHN6Kcn/F2d/2H01Q9LHi8LCF4o5St3RPOqazcSwdLJItV60yJcfNKwFNKKxuLh6BNr3TSl82vCCVjPSkGDbgdfD6aWu+TySvm4IgRkVIsP16C43L473TWNdH2DFvj9UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAB3BV4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAB3BV4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EEE1F00A3A;
	Wed,  8 Jul 2026 19:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783539260;
	bh=7yOuR5UJzfufHmwtkkwzhzFchYm22bvzLklNq1t5tR0=;
	h=Date:From:To:Cc:Subject;
	b=cAB3BV4neUPgQucDS7cvkUWsZLMtyBe23pwDWYNQ2y6s4S1Ng8VOQ/AoTrmYHlLPW
	 e1RYFAqwXqg9NWAbhnKvYQ8JXXk4lKuTUOyAls+gCyRo8Kcn6BIQyy5QsLzrfw7C0z
	 EhHeaIm4UDOUk01WhpxG9PqMgeheUHLbPXpmr3f0g1D16pa3KLof1uZx36e2ona5nN
	 hO76RXRF2Tavg60I1fG+Bi9ULUDXD77GhBG34Nb1oLr6Qt80+PCXwQmcVNd+wAgUkV
	 gG7zEZPAIJnYCaszDmRC5WKfJe5Wf15MHznzZCCvBpqfFQsL5ZPkHr7barDabn6MSA
	 +dgQ6OxAGhDvA==
Date: Wed, 8 Jul 2026 21:34:13 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: alexjlzheng@tencent.com, bfoster@redhat.com, cem@kernel.org, 
	dgc@kernel.org, djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, 
	liuhuan01@kylinos.cn, syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com, 
	wilfred.mallawa@wdc.com, ytohnuki@amazon.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to d89fea99c26e
Message-ID: <ak6mHkI6ybAEX3on@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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

d89fea99c26e4301c5f6ecdd509999cce9fbc7bf

New commits:

Christoph Hellwig (1):
      [846570fc6498] xfs: switch (back) to a per-buftarg buffer hash

Darrick J. Wong (8):
      [b07c386bc60b] mkfs: don't redefine DIRT for protofiles
      [2df5f48fb829] mkfs: fix PATH_MAX check
      [46b0ee102f25] mkfs: fix symlink target length check in create_nondir_inode
      [b3268fb3d822] xfs_protofile: make nondirectory arguments actually work
      [a2b765f7d0fd] mkfs: pass stat buf pointers around the protofile code
      [63a4a9d6966c] mkfs: fix hardlink detection in directory import code
      [8c6bf6721ac4] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
      [074c18165ea3] xfs_scrub: fix spacemap scan for internal rt devices

Jinliang Zheng (1):
      [bae44fee8d42] xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING

Wilfred Mallawa (1):
      [270a5f354ab7] xfs: add write pointer to xfs_rtgroup_geometry

Yuto Ohnuki (2):
      [c957be18e5e5] xfs: zero entire directory data block header region at init
      [622d715e372d] xfs: zero directory data block padding on write verification

liuh (1):
      [d89fea99c26e] fsr: preserve xfrog_bulkstat error codes

Code Diffstat:

 fsr/xfs_fsr.c            |  2 +-
 libxfs/xfs_ag.c          | 13 ++----------
 libxfs/xfs_ag.h          |  2 --
 libxfs/xfs_dir2_data.c   | 18 ++++++++++------
 libxfs/xfs_fs.h          |  5 ++++-
 libxfs/xfs_refcount.c    |  3 +--
 mkfs/Makefile            |  2 +-
 mkfs/proto.c             | 55 +++++++++++++++++++++++++++++-------------------
 mkfs/xfs_mkfs.c          |  2 +-
 mkfs/xfs_protofile.py.in | 40 ++++++++++++++++++++++-------------
 scrub/spacemap.c         | 26 +++++++++++++++++++++++
 11 files changed, 105 insertions(+), 63 deletions(-)

-- 
- Andrey
