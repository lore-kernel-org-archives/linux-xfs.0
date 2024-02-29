Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8B7160642
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709226993; cv=none; b=O2tAiAMzb6zjCkC82Gm33eD4pLoowLapu4c2ZHCJ7CEuKMQpKvYWgYNyEAKc3DvA/X+xG39obWTuaq37VHvTlvSqWzW+hnjdm4WTOFAX5l3hZuz47xDeQb9VAS5SH64Ml5JT5YHum6wkHYnd/MZPH2pLWr2xx1Z0zcWYeblIbms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709226993; c=relaxed/simple;
	bh=o6KPjTqKkgEf9hjnRt63LgDzK7UTpfwMRtxY0fIgbB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXvskF+HiSbrTIeNoVwoZXa7KUFduiVMd6YRWP6zc78AeczaHRPsAfm128e9c9dDnLLVS/Mhvd5D/iZ87LZ84FwEy8JIsy42666jckjukYPWgMZfXCJ1iTcWrjW8OsGqZ4/5L9Mtn02w1YpH8JRXpj2ywSvNhkNBvJDWDpgS24Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t7gIRVw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t7gIRVw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AF0C433F1;
	Thu, 29 Feb 2024 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709226992;
	bh=o6KPjTqKkgEf9hjnRt63LgDzK7UTpfwMRtxY0fIgbB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t7gIRVw2rhyJQ83LE7lVcCX6SrDpkggBo8aDTvPnX4kmvLjn3roU9dsesM9+m9jlu
	 hcfjFYTcyV6lMIY82p4GkSTwYR4SG8zEYjJIwHZx0+rNqVdNakG5pF4Bgs1nhJmX8l
	 9MlARQCaRxu9LI0YPVVMltUVMImk+knLRYPWpLKFM97CNYflNzvRoR49spPuBkCCuA
	 wRNnZXIeMs7ZLSMFAUBNByNSvcBcx/kME5FXrNE+ISfYUIHLXa/ER+IhOn2hIfRC3m
	 1Ibz6R8obP6h/Y9jh5KK31FT5kFyFpnxLlh+3nuUJUz5TaApf9X33EuES1q3XVN+n5
	 vw/04HXL7YNiQ==
Date: Thu, 29 Feb 2024 09:16:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <20240229171632.GA1927156@frogsfrogsfrogs>
References: <170900015254.939796.8033314539322473598.stgit@frogsfrogsfrogs>
 <170900015273.939796.12650929826491519393.stgit@frogsfrogsfrogs>
 <Zd9sqALoZMOvHm8P@infradead.org>
 <20240228183740.GO1927156@frogsfrogsfrogs>
 <Zd-BHo96SoY4Camr@infradead.org>
 <20240228205213.GS1927156@frogsfrogsfrogs>
 <Zd-vaC5xjJ_YgeD6@infradead.org>
 <20240228234630.GV1927156@frogsfrogsfrogs>
 <ZeCFrUVJ54Grt8qy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeCFrUVJ54Grt8qy@infradead.org>

On Thu, Feb 29, 2024 at 05:25:01AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 28, 2024 at 03:46:30PM -0800, Darrick J. Wong wrote:
> > If scrub (or the regular verifiers) hit anything, then we end up in
> > symlink_repair.c with CORRUPT set.  In this case we set the target to
> > DUMMY_TARGET.
> 
> Yes.
> 
> > If the salvage functions recover fewer bytes than i_disk_size, then
> > we'll set the target to DUMMY_TARGET because that could lead to things
> > like:
> > 
> > 0. touch autoexec autoexec@bat
> > 1. ln -s 'autoexec@bat' victimlink
> > 2. corrupt victimlink by s/@/\0/g' on the target
> > 3. repair salvages the target and ends up with 'autoexec'
> > 
> > Alternately:
> > 
> > 0. touch autoexec autoexec@bat
> > 1. ln -s 'autoexec@bat' victimlink
> > 2. corrupt victimlink by incrementing di_size (it's now 13)
> > 3. repair salvages the target and ends up with "autoexec@bat\0"
> > 
> > In both of those cases, something's inconsistent between the buffer
> > contents and di_size.
> 
> Yes.
> 
> > There aren't supposed to be nulls in the target,
> > but whatever might have been in that byte originally is long gone.  The
> > only thing to do here is replace it with DUMMY_TARGET.
> > 
> > If salvage recovers more bytes than i_disk_size then we have no idea if
> > di_size was broken or not because the target isn't null-terminated.
> > In theory the kernel will never do this (because it zeroes the xfs_buf
> > contents in xfs_trans_buf_get) but fuzzers could do that.
> 
> Now why do we even want to salvage parts of the symlink?  A truncated
> symlink generally would cause more harm than just refusing to follow it.

We don't want to salvage in that case.  I forgot to finish that last
paragraph:

"If salvage recovers more bytes than i_disk_size then we have no idea if
di_size was broken or not because the target isn't null-terminated.  In
theory the kernel will never do this (because it zeroes the xfs_buf
contents in xfs_trans_buf_get) but fuzzers could do that.  Set the
target to DUMMY_TARGET in this case."

and maybe add:

"The symlink target will be preserved if scrub does not find any errors
in the symlink file, the number of bytes recovered matches i_disk_size,
and there are no nulls in the recovered target.  In all other cases it
is set to DUMMY_TARGET."

--D
