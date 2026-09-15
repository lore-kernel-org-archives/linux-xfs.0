Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E71244A40C;
	Tue, 15 Sep 2026 20:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789502693; cv=none; b=oCkFp4twGaJWL3FYADE5KHI2agQ0yJsMX63oWSogJdeKWVWqH7IujC7M+2jw6uNzE5HdbkRI8Z3UYnom6jx90jzHdApHMqN2Y+yShSYPzHu/GfCf8RaJ03sGdAEyLEqo3c+olP58rfQ8d4q4KjlO2Dw641g475CWz4BKOviIY30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789502693; c=relaxed/simple;
	bh=inwyRSqo/vI3zXz/pCsWYc3LfvPY1MqQMkM2+6CMabE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTMo6FZyNQThDllodaaxHBDmpHgq5yc+kcZcjl3INUpNuCpsX1LmgFRCwrvMOUhNL8glvH1LJswTHjr9KZ7BIHwnJSOriSC2LkxzB5LAbZDSudHmRDC1uQvZ+rDvYs25laQIrJirRST2MFC/Sb/2fmxNuQKDl4sA+8axHaozbvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfQLZNg+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfQLZNg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483641F00893;
	Tue, 15 Sep 2026 20:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789502687;
	bh=RQmI3j80pBUNMggNJQ9yYNduDrQc4yjdaodGbPi9FFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gfQLZNg+OeHdIJ7e6TmFIAEu0HemEuSFv1GU2ko7gjvt8dIx2mtzyrjflClhK95x5
	 xo3aRcSzKT14h0Dv/GnBVxnAZwPwfKngKrKEdk+FVaCtvYPm6P18WOBvGhygnxlA+H
	 Q3Ha5lveEaCgV/X9i3mM7cVdKD4v8fj1+EATwf6NNPO4B5Wc4ZlbdMwl3gSE0aojL0
	 Z50a1lg/NcUCf5qlAiT3b/eQbjHAhMKxSXucXELo0n73XMn22qO0zddhzRy1HI3Djb
	 RKU1jXnABAhyUApN4yVkga33iknILkrmFB1wv2dfyzrqS7+in6blSVMrdKkm7Q+1m4
	 hpN0FEmQlM9uA==
Date: Tue, 15 Sep 2026 22:04:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: always call xfs_qm_adjust_dqlimits during
 quotacheck repair
Message-ID: <aqmknmvUNCeQ2Yc4@nidhogg.toxiclabs.cc>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
 <178945048522.3061055.5283654279910692050.stgit@frogsfrogsfrogs>
 <aqjkzGLzYfjrWI3Q@infradead.org>
 <20260915173820.GE2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915173820.GE2705364@frogsfrogsfrogs>

On Tue, Sep 15, 2026 at 10:38:20AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 14, 2026 at 11:25:16PM -0700, Christoph Hellwig wrote:
> > On Mon, Sep 14, 2026 at 10:36:49PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > LOLLM notices that everywhere else in the kernel, a call to
> > > xfs_qm_adjust_dqlimits precedes every call to xfs_qm_adjust_dqtimers.
> > > In particular, mount-time quotacheck does this.
> > > 
> > > Looking at xfs_qm_adjust_dqlimits, that function is in charge of
> > > conveying default limits to a dquot if that dquot's limits have been
> > > zeroed.  That's quite possible in a repair, so let's follow what
> > > everyone else does and set it.  This requires us to add a new predicate
> > > to decide if xfs_qm_adjust_dqlimits is likely to reset any of the
> > > dquot's limits, and to set the dirty flag to true if so.
> > 
> > I'd vote for merging the two functions as they clearly always should
> > be called together instead.
> 
> Ok, I'll combine them into an xfs_qm_adjust_dqenforcement() function as
> a separate patch...
> 
> > > A different LOLLM noticed that we have no way to force xchk_commit_dquot
> > > to call xfs_qm_adjust_dqtimers, so pack that in at the same time.
> > 
> > This feels completely unrelated, and could also use a much more
> > detailed explanation why we'd want that.
> 
> ...and turn this patch into a justification for code that forces dirty =
> true.  cem said he'd like to take the other 10 patches from part 15, so
> I'll move these two to the start of part 16.
> 

Yeah, I've got the other 10 patches already and discarded the first one.
Fell free to include that in the next series =]

Cheers
