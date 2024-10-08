Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC72B13B286
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 09:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728379102; cv=none; b=TesCBOnjc0YJkvUBDjeE54FsTlT50XeLl7FrI7h+Zz5hiBcuCnKWPbl9HRYFSU36cp11nQsIvyIXo4ENPpZur9QZuOxvZa/B4Dt9BshTnpspW+69CiagZK9DQZgqCK6nK79aDpssYulsILLWFHq+6ZSoQwoPj3J0nrPbgVDiQQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728379102; c=relaxed/simple;
	bh=mVaGpusO+UtRPbcEgmu8X0Cini6lWgCmNo/QgapKuIY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQBB/0ZL3U9xlCSyCUYnuINjn2xXHpV3s3WKigvcHERvZ7skUkmVAR80sDMX7u59KKu5oa3rRL5VDsMfcZYx7b0Sniyip23CEcFBMkhfSE1GQg52RH0itO1A/hCTWoavSmwIcgnHEUSSHwZmNetw0Qo8RTpHBoZBjLQnwRrhfWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtsApbI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtsApbI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7E6C4CECC
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 09:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728379102;
	bh=mVaGpusO+UtRPbcEgmu8X0Cini6lWgCmNo/QgapKuIY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=dtsApbI0BC46z4kdTbYrG+plDTYoJVX//1i94X67IaYQQDP03yfTSuP59P+/vvwp8
	 c2dTX8KAwGZo/fzOLfmJxutm0hgIK1eqF3kN3fScCyyVMFgocJqavA9choRc/7isHS
	 cXM3vdwfJhmMa/f0OwfxPz6TPYeAF/k2GReDcoiu5gbYr2j/Z2TBiM0RCr60/17J+d
	 4IuCsiVFApbSRQTh8AcxmLjoFpj9qoM7z97W0VAc9d9PROyn8FtM9McUlyDMBQD2jN
	 wgKn/juYbanhJCCo67HHnmwA+4w5vTU7QNyLi04nEpkWsEIHAk6DAVibaEN9peIjM3
	 FQ1/owLnDxuOA==
Date: Tue, 8 Oct 2024 11:18:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next **rebased** to 44adde15022d
Message-ID: <hzb4c2evutstmyfwjob4t5fdegslxym2nq6dejh224imhtha35@m6l3j76bhlyi>
References: <ju73v7yffteh4abhp7liyyz6ta2thc7tkjimp25rosv6uaqzc7@swtwurbl7gnp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ju73v7yffteh4abhp7liyyz6ta2thc7tkjimp25rosv6uaqzc7@swtwurbl7gnp>

Sorry, correcting the subject :)


On Tue, Oct 08, 2024 at 10:59:29AM GMT, Carlos Maiolino wrote:
> Subject: [ANNOUNCE] xfs-linux: for-next **rebased** to 44adde15022d
> 
> Hi folks,
> 
> The for-next branch of the xfs-linux repository at:
> 
> 	git@gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git
> 
> has just been **REBASED**.
> 
> Patches often get missed, so please check if your outstanding patches
> were in this update. If they have not been in this update, please
> resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
> the next update.
> 
> This is a rebase of the for-next push from past week, where due problems with
> testing the new patches to be included in the -rc, I needed to create a new tag
> with the whole series to be sent to Linus later this week.
> 
> The patch list below contains the patches pushed past week + new patches that I
> managed to test this weekend.
> 
> The new head of the for-next branch is commit:
> 
> 44adde15022d xfs: fix a typo
> 
> 15 new commits:
> 
> Andrew Kreimer (1):
>       [44adde15022d] xfs: fix a typo
> 
> Brian Foster (2):
>       [90a71daaf73f] xfs: skip background cowblock trims on inodes open for write
>       [df81db024ef7] xfs: don't free cowblocks from under dirty pagecache on unshare
> 
> Chandan Babu R (1):
>       [ae6f70c66748] MAINTAINERS: add Carlos Maiolino as XFS release manager
> 
> Christoph Hellwig (8):
>       [b1c649da15c2] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
>       [346c1d46d4c6] xfs: return bool from xfs_attr3_leaf_add
>       [a5f73342abe1] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
>       [b3f4e84e2f43] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
>       [865469cd41bc] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
>       [b611fddc0435] xfs: don't ifdef around the exact minlen allocations
>       [405ee87c6938] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
>       [6aac77059881] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
> 
> Uros Bizjak (1):
>       [20195d011c84] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
> 
> Yan Zhen (1):
>       [6148b77960cc] xfs: scrub: convert comma to semicolon
> 
> Zhang Zekun (1):
>       [f6225eebd76f] xfs: Remove empty declartion in header file
> 
> Code Diffstat:
> 
>  MAINTAINERS                   |   2 +-
>  fs/xfs/libxfs/xfs_alloc.c     |   7 +-
>  fs/xfs/libxfs/xfs_alloc.h     |   4 +-
>  fs/xfs/libxfs/xfs_attr.c      | 190 ++++++++++++++++++------------------------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  40 +++++----
>  fs/xfs/libxfs/xfs_attr_leaf.h |   2 +-
>  fs/xfs/libxfs/xfs_bmap.c      | 140 ++++++++++---------------------
>  fs/xfs/libxfs/xfs_da_btree.c  |   5 +-
>  fs/xfs/scrub/ialloc_repair.c  |   4 +-
>  fs/xfs/xfs_icache.c           |  37 ++++----
>  fs/xfs/xfs_log.h              |   2 -
>  fs/xfs/xfs_log_cil.c          |  11 +--
>  fs/xfs/xfs_log_recover.c      |   2 +-
>  fs/xfs/xfs_reflink.c          |   3 +
>  fs/xfs/xfs_reflink.h          |  19 +++++
>  15 files changed, 207 insertions(+), 261 deletions(-)
