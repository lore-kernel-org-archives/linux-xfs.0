Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8AE319604
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 19:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762370002; cv=none; b=f4IM2KSfH94mKxnvAYu/A1R/DGHKqRD3pLzbU8U3rIMWzNhhCTN3Uz5dZWq4qHfLywhn2hsOZYSfcnJeHOTVFndqXhl/nRSVSroB9BpmTA2iBK1ygbd1CgvC6xKm+c1HMjnzFtk5OWNetTsPhnhqeOMcRNR1G6I5ANqDXMFgh0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762370002; c=relaxed/simple;
	bh=OSCSNX5cY4t5bVWyezelQuUot3W5C/FP5ZGqW+HgnOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTRA6F/3iwn697UqYO8WH3c0rNllUPBu85JykJQGgJxIhpeVZL2HNPZHng19AsR+JIQs04Jae2d4KFog0mpbusclj6b6eic4EAwi1Hxf0eAv6SsqaaxeGGEoPly+/2RiwkhZj9cZgmvINknKd0CPNMr9dslAH8qr+OmXDDqMSJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxrIQ2P/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxrIQ2P/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46822C4CEF5;
	Wed,  5 Nov 2025 19:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762370002;
	bh=OSCSNX5cY4t5bVWyezelQuUot3W5C/FP5ZGqW+HgnOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LxrIQ2P/sCxgFJudzcLW9IB3gDceqO/Ta1JcIvuGe7taASXGHJfpzljOGHk4RgG0C
	 UZmGJxNjR/Ok/gsTq5M4QXZjiWMbF+2+J6vo9aT0TEkxTrITy0sYx3JvqqckU/jaU0
	 mtuMcAnleLLIIhyf0UfZUhSZ2jkfdy25m2csP10FJEiWrogSj8srpR+rK3vO+5wfDR
	 R1zj6+zLYWoTOMrlxBZ/qUTWaTNFr5KXF169zzJwepJtwqzVSDDGzvW6IQ0SWr4mOK
	 yJLOwPr6lp34OFrqLunmC2KY08ZN4mtA6aCE8lbG28L/mB7b4Y3RSi8iWmeDbRfxAT
	 1sMV4P2eW7Jtw==
Date: Wed, 5 Nov 2025 11:13:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, bfoster@redhat.com, david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Message-ID: <20251105191320.GD196370@frogsfrogsfrogs>
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <aPiFBxhc34RNgu5h@infradead.org>
 <20251022160532.GM3356773@frogsfrogsfrogs>
 <aPnMk_2YNHLJU5wm@infradead.org>
 <24f9b4c3-1210-4fb2-a400-ffaa30bafddb@gmail.com>
 <aQtNVxaIKy6hpuZh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQtNVxaIKy6hpuZh@infradead.org>

On Wed, Nov 05, 2025 at 05:12:55AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 05, 2025 at 01:26:50PM +0530, Nirjhar Roy (IBM) wrote:
> > Sorry for the delayed response. So, my initial plan was to get the the
> > shrink work only for empty AGs for now (since we already have the last AG
> > partial shrink merged).
> 
> For normal XFS file systems that isn't really very useful, as the last
> AG will typically have inodes as well.
> 
> Unless we decide and actively promoted inode32 for uses cases that want
> shrinking.  Which reminds me that we really should look into maybe
> promoting metadata primary AGs - on SSDs that will most likely give us
> better I/O patterns to the device, or at least none that are any worse
> without it.

I don't think we quite want inode32 per se -- I think what would be more
useful for these shrink cases is constraining inode allocations between
AG 0 and whichever AG the log is in (since you also can't move the log),
and only expanding the allowed AGs if we hit ENOSPC.

(Or as hch suggested, porting to rtgroups would at least strengthen the
justification for merging because there are no inodes to get in the way
on the realtime volume.)

> > Do you think this will be helpful for users?
> > Regarding the data/inode movement, can you please give me some
> > ideas/pointers as to how can we move the inodes. I can in parallel start
> > exploring those areas and work incrementally.
> 
> I don't really have a really good idea except for having either a new
> btree or a major modification to the inobt provide the inode number to
> disk location mapping.

Storing the inode cores in the inobt itself, which would be uuuuugly.

--D
