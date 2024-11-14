Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D88B640
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565488; cv=none; b=QbiD9VrHWxtJSXKj2RQln3J7S86IKS8p5p77x/yQKyWjg+ManmShoWTgTp095OIxON7XRq2IlLCclGAlb6cN7t77fH1GF4natLU6TTfP7xonBSYnI2cvxrghO8eLNZ6P0/mmamg18ToWUBz0VuJqSY5lIWWN9gCYY2EnKy1XAus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565488; c=relaxed/simple;
	bh=TYO6LvfRY/A6VX9NIvFEU2G+JOkyUDDkYsFF+0KkrVM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m5Dl9JDp6iLsJIltg9SzgYVRhPZTmLswfLZVx6bud82aWpyCariybARRED4md5Up1fBh1+b5cZVhxAGErGebd0TN05VbAr6vz+V0Lpt1vyPqguuj7f8N5Jp1vmpf60kyEi224AhzsQacXxdNYaN2eMLp46/AWAxjWpKNructhsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPdH3RGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPdH3RGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C1C4CECF;
	Thu, 14 Nov 2024 06:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565488;
	bh=TYO6LvfRY/A6VX9NIvFEU2G+JOkyUDDkYsFF+0KkrVM=;
	h=Date:From:To:Cc:Subject:From;
	b=fPdH3RGCri4rR/DJlzWLpao2ksBRepIN0wUU7csPLPVvG5k4S64OCS60R1VY1UBcU
	 sjH1xif+toYax6xw3aCQVsMBetubGFJLZCjsoeMjvlJD6EAAIFVMSEU75kBdFPTdJu
	 Q6IZ+726fWTiGA7rGM8RtDdsKYOOEZjhqBwlZEQmVySpQsErzPUruV/nAUxzL2pLm+
	 k+MJaon+KQmccDeYVW6HWhlJpFVrqxY8AJMvkbhWaHClwcxTzGnX7HruYrliLKXOwQ
	 1VEFlZVkH4jB3GbPuTnzm1LixGsACgwpL+gbL5O88j4xp2aFNA+ShBko/MLIc7mp34
	 Sg+Y8xViljK6A==
Date: Wed, 13 Nov 2024 22:24:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULLBOMB v5.7] xfs: metadata directories and realtime groups
Message-ID: <20241114062447.GO9438@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Please pull these fully reviewed patchsets for kernel 6.13.  This
patchbomb corrects numerous paperwork errors in the v5.5 submission so
that we can pass linux-next linter.

I have corrected my stgit wrapper program to invoke git checkpatch
before issuing pull requests.  Despite its name, this means I now have
automated checks for tagging errors in git commits.  Freeform text
fields that require a lot of parsing cleverness to check and that can be
corrupted easily buc*********.

This is now being resent as a v5.7 because hch pointed out that I got
the polarity reversed and hence misattributed some patches.  So here's a
fresh PR with ($deity I hope so) all the problems fixed.  Long after
working hours were supposed to be over.  So much for relaxing.

The following excerpted range diff shows the differences between last
week's PRs and this week's:

  1:  62027820eb4486 !   1:  0fed1fb2b6d4ef xfs: fix simplify extent lookup in xfs_can_free_eofblocks
    @@ Commit message
         this patch, we'd invoke xfs_free_eofblocks on first close if anything
         was in the CoW fork.  Now we don't do that.
     
         Fix the problem by reverting the removal of the i_delayed_blks check.
     
         Cc: <stable@vger.kernel.org> # v6.12-rc1
    -    Fixes: 11f4c3a53adde ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
    +    Fixes: 11f4c3a53adde1 ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
         Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_bmap_util.c ##
     @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
      		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
  2:  cd8ae42a82d2d7 =   2:  3aeee6851476d4 xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
...
 68:  dcfc65befb76df !  68:  eae72acae5a564 xfs: clean up xfs_getfsmap_helper arguments
    @@ Commit message
         fsmap irec structure that contains exactly the data we need, once.
     
         Note that we actually do need rm_startblock for rmap key comparisons
         when we're actually querying an rmap btree, so leave that field but
         document why it's there.
     
    -    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Signed-off-by: Christoph Hellwig <hch@lst.de>
         Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    +    [djwong: fix the SoB tag from hch, somehow my scripts replaced it...]
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
     
      ## fs/xfs/xfs_fsmap.c ##
     @@ fs/xfs/xfs_fsmap.c: xfs_fsmap_owner_to_rmap(
      	}
      	return 0;
 69:  87fe4c34a383d5 =  69:  f106058ca77fa9 xfs: create incore realtime group structures
...
 83:  1029f08dc53920 !  83:  12693186fbb282 xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
    @@
      ## Metadata ##
    -Author: Darrick J. Wong <djwong@kernel.org>
    +Author: Christoph Hellwig <hch@lst.de>
     
      ## Commit message ##
         xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
     
         Split the code to set up a fake mount point to calculate new RT
         geometry out of xfs_growfs_rt_bmblock so that it can be reused.
 84:  fc233f1fb0588a =  84:  52690d80b09ca5 xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
...
110:  b91afef724710e ! 110:  d4918d151be0bd xfs: don't merge ioends across RTGs
    @@
      ## Metadata ##
    -Author: Darrick J. Wong <djwong@kernel.org>
    +Author: Christoph Hellwig <hch@lst.de>
     
      ## Commit message ##
         xfs: don't merge ioends across RTGs
     
         Unlike AGs, RTGs don't always have metadata in their first blocks, and
         thus we don't get automatic protection from merging I/O completions
111:  d162491c5459f4 = 111:  54a89f75c4d972 xfs: make the RT allocator rtgroup aware
...
139:  13877bc79d8135 = 139:  c70402363d6d27 xfs: port ondisk structure checks from xfs/122 to the kernel

Apologies for the last minute churn and paperwork stress.

--D
