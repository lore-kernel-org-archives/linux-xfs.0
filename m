Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858CD10A1C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230202; cv=none; b=fg+3iLUckdxQSR4mDVyMCGEhPTepl84ZCDhXx9/a9YgEud7WGlzVkx4YHkE0rWhHHY3HTc8UCDYIqVMbMsdGjjvCAmtYFFJjcyaDuMsIuTgmJc/pYARiQjMCqg0f+AWYOlpi0p6JtdokO4n+jSIdgG+6LhbzGw2oy/VkAezxBuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230202; c=relaxed/simple;
	bh=Hf7GFMurwX4prYyKdtbGciG04XYKxzDCt7ym+O06N94=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FmoK8HC/Dj3uQhlnI9aGMouLBA2gQ+Dbasq1IlJeoZ16JxWnSfIYoziWJAyp0Ne7cdeEnyvbsFn2Kx7XlND+rRgclBAExJZxObdwl///QVHnDGMUYcNQrJodLRsLLv4y2GtSAA0lAHrNlLIzFfwbd92b7pn43INQRF4Y6icko0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URYWVuV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URYWVuV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADC4C113CC;
	Tue, 16 Apr 2024 01:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230201;
	bh=Hf7GFMurwX4prYyKdtbGciG04XYKxzDCt7ym+O06N94=;
	h=Date:From:To:Cc:Subject:From;
	b=URYWVuV2Z3gKVxdED7LPupIOx8iYeDxqpHxjv3VvO7rsmixbUgw0Mtzc3A9DO5U/P
	 sgtOWX8cCmQ8QgI+I5Z/MCBGt6Vgj+1Gzj5LNX4Yuvo98eB4ZE2h/UhZnyS2yzHh2M
	 7ziKifRao0ZqOfHzxIazbhniznS0aphMHQyQsYKt3p7TkEDM1q+4bpTRmdLO0Z3EvJ
	 84h9PRvDQNnj0dKw2S9l8BB+jbAFANwbB1cbEMmtWGNF0mvduD+Dyc9kKTs3XXMRSW
	 NLsjinQJrklTC2oscxfUv7OTRwBBVLkrolgm4XM67M7s+3YtKGV4PyngepuYT77CgN
	 ePhDtjAtxNpDw==
Date: Mon, 15 Apr 2024 18:16:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCHBOMB v13.2] xfs: directory parent pointers
Message-ID: <20240416011640.GG11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Christoph and I have been working to get the directory parent pointers
patchset into shape for merging in the next kernel cycle.  This v13
release contains what I hope are the last ondisk format changes -- we've
gone back to parent pointers being xattrs attached to the child, wherein
the attr name is the dirent name, and the attr value is a handle to the
parent directory.

We've solved the pptr lookup uniqueness problem by forcing all
XFS_ATTR_PARENT attr lookups to be done on the name and value; avoided
namehash collisions on container farms by adjusting the hash function
slightly; and avoided the entire log incompat feature flag mess by
defining a permanent incompat feature for parent pointers and using
totally separate attr log item opcodes.

With that, I think this is finally ready to go.

Full versions are here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

Of the 82 patches in this patchbomb, 15 have not completed review:

[PATCHSET v13.2 1/7] xfs: shrink struct xfs_da_args
  [PATCH 3/5] xfs: remove xfs_da_args.attr_flags
  [PATCH 4/5] xfs: make attr removal an explicit operation

[PATCHSET v13.2 2/7] xfs: improve extended attribute validation
  [PATCH 06/14] xfs: check shortform attr entry flags specifically
  [PATCH 13/14] xfs: refactor name/value iovec validation in

[PATCHSET v13.2 3/7] xfs: Parent Pointers
  [PATCH 08/31] xfs: refactor xfs_is_using_logged_xattrs checks in attr
  [PATCH 09/31] xfs: create attr log item opcodes and formats for
  [PATCH 10/31] xfs: record inode generation in xattr update log intent
  [PATCH 25/31] xfs: actually check the fsid of a handle

[PATCHSET v13.2 4/7] xfs: scrubbing for parent pointers
  [PATCH 1/7] xfs: revert commit 44af6c7e59b12

[PATCHSET v13.2 5/7] xfs: online repair for parent pointers
  [PATCH 01/17] xfs: remove some boilerplate from xfs_attr_set
  [PATCH 02/17] xfs: make the reserved block permission flag explicit
  [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling xfs_attr_set

[PATCHSET v13.2 7/7] xfs: vectorize scrub kernel calls
  [PATCH 2/4] xfs: move xfs_ioc_scrub_metadata to scrub.c
  [PATCH 3/4] xfs: introduce vectored scrub mode
  [PATCH 4/4] xfs: only iget the file once when doing vectored

Most of these are bug fixes, or cleanups that Christoph and Dave and I
talked about during the review of v13.2.

--D
