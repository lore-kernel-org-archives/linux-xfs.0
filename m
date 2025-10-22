Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCE11FDA89;
	Wed, 22 Oct 2025 04:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761107254; cv=none; b=fut5YcfjhWuVIjamYY7Am/SeBnesIxQMHtbLLw1pUyaZ4XbIz195zcZZL370+Sls3p+LH0jutdOsRDAbEMu725LzqHkWr1NctXGKY7eYKZWmp2DPhmBbDzzWPFIUMxVfUfLWHtdRtue6EMAqTRNYHPNf/6kMfwTPaD0FVaGr6XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761107254; c=relaxed/simple;
	bh=YkeTLnNZQvgtM03ewfyqDhmSS19v4JsRrzReqqy8gzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxibQTDuQlmUA8DpabdztKlAftcJ4e9RHg+emq6m+p75yacM72He3C1utQsC5v9maQqlZIoq0z/irWSu05G4zeAos4dyMvpSTd5FUJTGVXfCsWaFZYUD0I4s5D9Y1a3XOEb9QVKXl+dlM4siQoC74pkAm3wSv8No8fOKGyAvhx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSAjT/J3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSAjT/J3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E00C4CEE7;
	Wed, 22 Oct 2025 04:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761107252;
	bh=YkeTLnNZQvgtM03ewfyqDhmSS19v4JsRrzReqqy8gzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gSAjT/J3D7uSV8EWy2giU0pFVZ1Ghq/k+J74MHIkgnRxykh33aDIOxtgTjXDPUhgb
	 jxPcLVWgioUO6JrAjPcaEAy2PPnSRpxSbRAHHH+b95tOfO9sIq0gQncNxIjUosNhqZ
	 dLqBnpP31IQFpiNMunmiyAKhFBRw5C/hLQJ/MUV//9HR0QMAcl2O5fp5CphFfk6LsZ
	 pexMwgVTB2uQNnOO1bQiqkc8fnRcOIlj0gMSminbfDpLSZjK6yXoVv8LBY08s+mNsh
	 2HhMNGa60OSisB7hTKro5yQ0x3GDp3SrelQwbjbubImjEfJBTcqhrvY+k2WSI0ihMn
	 w8YW8q2ZYP3oA==
Date: Tue, 21 Oct 2025 21:27:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] generic/778: fix severe performance problems
Message-ID: <20251022042731.GK3356773@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
 <aPhbp5xf9DgX0If7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPhbp5xf9DgX0If7@infradead.org>

On Tue, Oct 21, 2025 at 09:20:55PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 21, 2025 at 11:41:33AM -0700, Darrick J. Wong wrote:
> > As a result, one loop through the test takes almost 4 minutes.  The test
> > loops 20 times, so it runs for 80 minutes(!!) which is a really long
> > time.
> 
> Heh.  I'm glade none of my usual test setups even supports atomics I
> guess :)

FWIW the failure was on a regular xfs, no hw atomics.  So in theory
you're affected, but only if you pulled the 20 Oct next branch.

> > So the first thing we do is observe that the giant slow loop is being
> > run as a single thread on an empty filesystem.  Most of the time the
> > allocator generates a mostly physically contiguous file.  We could
> > fallocate the whole file instead of fallocating one block every other
> > time through the loop.  This halves the setup time.
> > 
> > Next, we can also stuff the remaining pwrite commands into a bash array
> > and only invoke xfs_io once every 128x through the loop.  This amortizes
> > the xfs_io startup time, which reduces the test loop runtime to about 20
> > seconds.
> 
> Wouldn't it make sense to adopt src/punch-alternating.c to also be
> able to create unwritten extents instead of holes for the punched
> range and run all of this from a C program?

For the write sizes it comes up with I'm guessing that this test will
almost always be poking the software fallbacks so it probably doesn't
matter if the file is full of holes.

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
