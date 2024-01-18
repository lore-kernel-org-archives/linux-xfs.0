Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BDB184C
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 01:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705541572; cv=none; b=NIaen9adyIwPIVrXQQNRGFshjw5B+5W4D6aUu9BnZkLKBSMgAi8nY0RdgAvKltV74IObQPOyXoWKRbTT78lJyLS85lvykAt6H9nOZITF9nL6gmN/GHxrFFttNNmnuoG1kIk1L7FuHS30JmjD2DBKzE4WyVGEuvg5LV3Axh5oyGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705541572; c=relaxed/simple;
	bh=9KKzCYt8A4nwQ9G1ehv7KuMyLOzlHc64f65si3j7ftc=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To; b=KhSfsblxFch1b70IVLmC6Ga90bcWvKhYBLuFVreu/oxRzJ69p1itscCyp5ivrhhaHosxS4eIHPMVrz7BccGWOG0D8xQEvCN2SzuyhuoeH2Nv4GGCdNeBz9+j39LUrHNnCwoOVsLdRfIiBYMRLDwkP1zyKcdDv0Y0ry0w6XWpRC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ht3SRo1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ht3SRo1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941ADC433F1;
	Thu, 18 Jan 2024 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705541571;
	bh=9KKzCYt8A4nwQ9G1ehv7KuMyLOzlHc64f65si3j7ftc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ht3SRo1gCVqbWnRI2eNTM0JmIRRStjpy3+5vDsqic84gdbAy9mVXBPKLSflWX7g5h
	 N7naAi9ezNw6tVc2z1PjGvYWWPP7L4z6qWOCZEeingpg2a0kB+WwP3RcZbEJjE0CYN
	 //Dl1bg7aeJpKgRfmCx9Q+Np+4jUIYvLHWB6rNEcY3OfkCLd3i9hUn1OFRydMB8iqI
	 spaRBvoloaEb7Y6YdLobUQ3VptdRTA2cR8uVXAoQclSUw27ORSWg0vGHzxH8JOKCJo
	 67rCClvNrZ8Dhs5ilUZdyv8/ox+qL0t90a1fCOGcRLAEuShYEsbF6cJxx+iD73huzh
	 IDawm3QNYnPpA==
Date: Wed, 17 Jan 2024 17:32:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: use directio for device access
Message-ID: <20240118013250.GC674499@frogsfrogsfrogs>
References: <169567914468.2320255.9161174588218371786.stgit@frogsfrogsfrogs>
 <169567915609.2320255.8945830759168479067.stgit@frogsfrogsfrogs>
 <Zagcv3rWRQMeTujZ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zagcv3rWRQMeTujZ@infradead.org>

On Wed, Jan 17, 2024 at 10:30:23AM -0800, Christoph Hellwig wrote:
> On Mon, Sep 25, 2023 at 02:59:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS and tools (mkfs, copy, repair) don't generally rely on the block
> > device page cache, preferring instead to use directio.  For whatever
> > reason, the debugger was never made to do this, but let's do that now.
> > 
> > This should eliminate the weird fstests failures resulting from
> > udev/blkid pinning a cache page while the unmounting filesystem writes
> > to the superblock such that xfs_db finds the stale pagecache instead of
> > the post-unmount superblock.
> 
> After some debugging I found out that this breaks a bunch of tests
> (at least xfs/002 xfs/070 xfs/424 in the quick group) on 4k device
> because xfs_db tries some unaligned reads.
> 
> For xfs/002 that is the libxfs_buf_read in __set_cur, when setting the
> type to data, but I haven't looked at the other test in detail.

Hmm.  Perhaps the userspace buftarg setup should go find the physical
sector size of the device?  That "bb_count = 1" in set_iocur_type looks
a bit smelly.

> Should I look into finding all these assumptions in xfs_db, or
> just make the direct I/O enablement conditional n a 612 byte sector
> size?

Let me go run a lbasize=4k fstests run overnight and see what happens.
IIRC zorro told me last year that it wasn't pretty.

--D
