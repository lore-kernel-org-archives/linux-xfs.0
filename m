Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C13C1C0DE7
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 04:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712811406; cv=none; b=AnyjtdOGY4LKRR8fGqLTXY6UhrKdCzLIsrV61DMPbeTNAkuuqtkO8uKT7zADQM3sXC+WzfTt3/SHzAhcXDQdvtwjlwIEf3WlaI5vUhzDM6gMTh/WyWqIN1/8nMOia/VO2Um/w4AjQzuU1C+/kBEwH0Na0r+9DFCXuUqaX5gcTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712811406; c=relaxed/simple;
	bh=+Y76GnBoIab5FgQfWzRoKPbXjfHG4q47Lf3XtyuGR5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tkytjx2gn/E+7XM9R3smFRhjuAGkhjNPT6jdEG0yWDKXQw37rQNAeR3OXrFfYJ7v5X9fI+B4m0ZXwotP17JKY+8C1SAVO7msBvMB/+krCJhG8Nv50MzLH6jmJ9DoT7w7orOAgUeZNTokxuYVQsCyZ09Ea+2tdpdqwBufa6LNmnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLzbRouv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLzbRouv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1013FC433F1;
	Thu, 11 Apr 2024 04:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712811406;
	bh=+Y76GnBoIab5FgQfWzRoKPbXjfHG4q47Lf3XtyuGR5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLzbRouvzKeqAkKmSQb9ZOLs6VaEQPrFA32Bl+ApiADRFLVBP66JttUYleKtpN/dX
	 lteHuyW6dbBjQiDa9iGtn1qq9FvZ7k/m7up9OAUIGaqGX/ruRCGdVX3TbE6meVuu9G
	 8MEZbYkfsUQFx1eMui9W6Suzgh9y5pMCmrqb22pdsOUN6pwyzAHdCEx3TAjYLnX/Ao
	 yKSYDRN0EOlJdZjiEpbnF3IKQe8oJEIP3W6oLFsKDL63kxfUgzdov9gcskq+PtXi0h
	 B3GLZHq/NK6ydcJmp2GU3SPruxnBWL2G3CQlUHC7fR9LSxF8rnO/RBhFdFogaMhYRT
	 H5lSOiMwrINdg==
Date: Wed, 10 Apr 2024 21:56:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <20240411045645.GX6390@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
 <Zhdd01E-ZNYxAnHO@infradead.org>
 <20240411044132.GW6390@frogsfrogsfrogs>
 <ZhdsmeHfGx7WTnNn@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhdsmeHfGx7WTnNn@infradead.org>

On Wed, Apr 10, 2024 at 09:52:41PM -0700, Christoph Hellwig wrote:
> > How does it determine that we're in a transaction?  We just stopped
> > storing transactions in current->journal_info due to problems with
> > nested transactions and ext4 assuming that it can blind deref that.
> 
> Oh, I was looking at an old tree and missed that.

It's not in my tree but I did ... oh crap that already got committed; I
need to rip out that part of xrep_trans_alloc_hook_dummy now.

> Well, someone needs to own it, it's just not just ext4 but could us.

Er... I don't understand this?        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> > >                    Talking about the in transaction part - why do
> > > we drop inodes in the transaction in scrub, but not elsewhere?
> > 
> > One example is:
> > 
> > Alloc transaction -> lock rmap btree for repairs -> iscan filesystem to
> > find rmap records -> iget/irele.
> 
> So this is just the magic empty transaction?

No, that's the fully featured repair transaction that will eventually be
used to write/commit the new rmap tree.

--D
