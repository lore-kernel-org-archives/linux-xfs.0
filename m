Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9363A8489
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543398; cv=none; b=EkEMSzQryapedCsrW7Be+SyTXb2SxwN+pp4WcBN9v32CJpYyGpUOp4Po727p1nzkwqA2/fpbwdx0s/hJHlTfmAAMUSfTRBDT+Q198F/B48FkWqfYDoxo4Vt80oNclc6gvXwugyNtifTqSP6wyKLXHX50VenCAtBr5G8FgZM3pZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543398; c=relaxed/simple;
	bh=lOlNON4P1BN057dzyY3qm2ANVodbKaK5zujrUotiJ6U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=o02HYX1eVgNRObGRgSDTaclWyubu3N2PwFlnsTh4u9j6HH6Zh4ZldtOEsfJhTC3Y0x4ezBmOI1/mbhurgToAz5/NL6I12fnY/BTT2GoNR4u4icTwX9xvYP83vmDdUVM3kGbl9T+Hg7o2JyENvKZUJEa6U6JjFjMccMfZeCvsCAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOGrPkC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOGrPkC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E69C4CEC3;
	Thu, 14 Nov 2024 00:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543398;
	bh=lOlNON4P1BN057dzyY3qm2ANVodbKaK5zujrUotiJ6U=;
	h=Date:From:To:Cc:Subject:From;
	b=cOGrPkC8SoAUWf2JKe9ptLx3sbqKhe7ghG4LDrfm9TCDv+DQBEHgcMIxGoEn55LvR
	 mTQrgvoSzaWD9bbZVkJhLnJn8F8D9rCqTCZf9tnJ+TpR+7+ekbYa20d+w4exxN6GTM
	 DhW1molXoeS8ok41+jCc339pLyyO1ocLYI5+xJ6Tv01bJgTg1njHJQzZw6gW9w6RU8
	 QLp8KY2qXo4rkpJ3yWGy6bqO0bR2AwHp+vKmKwhkjbRj6XLes9fKsoSUDBfMi71zlu
	 SxghdS+pEDAeaoSfOGxWrKbDzL9b8qNY+uG9fKTVSn8SrE4tCTsbOgXnuq5y0fiWxM
	 tWTwnPMUTNsKQ==
Date: Wed, 13 Nov 2024 16:16:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULLBOMB v5.6] xfs: metadata directories and realtime groups
Message-ID: <20241114001637.GL9438@frogsfrogsfrogs>
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

The following excerpted range diff shows the differences between last
week's PRs and this week's:

  1:  62027820eb4486 !   1:  03326f42d6ef7a xfs: fix simplify extent lookup in xfs_can_free_eofblocks
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
  2:  cd8ae42a82d2d7 =   2:  5bbfaf522b8c42 xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
...
 68:  dcfc65befb76df !  68:  3065c8cf8c7082 xfs: clean up xfs_getfsmap_helper arguments
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
 69:  87fe4c34a383d5 =  69:  15165713e812d9 xfs: create incore realtime group structures
...
 83:  1029f08dc53920 !  83:  08ed382bba4f52 xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
    @@ Commit message
     
         Note that this changes the rmblocks calculation method to be based
         on the passed in rblocks and extsize and not the explicitly passed
         one, but both methods will always lead to the same result.  The new
         version just does a little bit more math while being more general.
     
    -    Signed-off-by: Christoph Hellwig <hch@lst.de>
    -    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/xfs_rtalloc.c ##
     @@ fs/xfs/xfs_rtalloc.c: xfs_rtginode_ensure(
      
      	if (error != -ENOENT)
      		return 0;
 84:  fc233f1fb0588a =  84:  bc1cc1849a4bfe xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
...
110:  b91afef724710e ! 110:  2a81329aa08d66 xfs: don't merge ioends across RTGs
    @@ Commit message
         Unlike AGs, RTGs don't always have metadata in their first blocks, and
         thus we don't get automatic protection from merging I/O completions
         across RTG boundaries.  Add code to set the IOMAP_F_BOUNDARY flag for
         ioends that start at the first block of a RTG so that they never get
         merged into the previous ioend.
     
    -    Signed-off-by: Christoph Hellwig <hch@lst.de>
    -    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
         Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    +    Reviewed-by: Christoph Hellwig <hch@lst.de>
     
      ## fs/xfs/libxfs/xfs_rtgroup.h ##
     @@ fs/xfs/libxfs/xfs_rtgroup.h: xfs_rtb_to_rgbno(
      	struct xfs_mount	*mp,
      	xfs_rtblock_t		rtbno)
      {
111:  d162491c5459f4 = 111:  4895d7326c2f49 xfs: make the RT allocator rtgroup aware
...
139:  13877bc79d8135 = 139:  b038df088d5bf2 xfs: port ondisk structure checks from xfs/122 to the kernel

Apologies for the last minute churn and paperwork stress.

--D
