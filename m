Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01E845C702
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 23:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788391557; cv=none; b=Qrr09/T1saRx/qQw+3KiG1bRppyG9CGyTwEtGcOpBGGdWTHWw1MMlL0p+icjj9QOE8jOoJL/nCDBLHOvmtKHCVaHgds++xIvlnLPU8J+L+0s85BZsfyb//1hvbNuFPqf+sPgjjho58lw5KEKvnf/RwU8MOep/5T3ACGAcs9AYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788391557; c=relaxed/simple;
	bh=8dBhPbXHEzI5lSjn/PMEXla7TMxJsT3LupY0pFSWsYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBZtLUQD1+KnpCOhb6K17fyx+JiIvnuu/ASFA1QEE7OZJ6PmU/9KezK9JifesD987zr9K6NqeMC6q/PKF1xkZGc0a2vbe+501zW2peLFJn5E8PUHOJWA8Etoy/fQi4CzPuSV1oOBR2mU2JZGPfNIwUMxFyyIacvgDaEjrKKtbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0la9Sb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0la9Sb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E2F1F000E9;
	Wed,  2 Sep 2026 23:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788391555;
	bh=UOQo8oi/KNsjnLtgdwfJywJA+99ikkV6IKLf7jxtEhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W0la9Sb2TOu4SsnqGbvjf6EAm3yv5LihAOHpmkHvtJT92yHFQPJXyebCjxvomGavb
	 YLp15PTUCnTtf6Z1EmNZr+sv1jP0+fuGw1cVY0LCp+7Cm4tipc9fZg6p2e7nGS5OKt
	 lD1KYq74AJewPShNS7JAfK1bWoqm7w15fc1Nx5tNiKk38XSrIKpEWu/TuI5uj7xZTh
	 GQuvv/+LnKM0PNuTM0LgiRSl/C1t6Q3XEdYuGi2hBUhfGY+Yjmp8rcZjFnw3X/uvVE
	 siP4E+wHJOGxiL0j5BKpz8FFkc1YQfBOsdw1AA+PSBc95PU5cFQLcnfuUyOCbLifsQ
	 DHhK/NtSuOyvA==
Date: Thu, 3 Sep 2026 09:25:37 +1000
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] libxfs-diff: also compare libxlog against the kernel
Message-ID: <apiwcS4g2yzOXJn2@dread>
References: <cover.1788110147.git.cw@f00f.org>
 <7e3d4d82541b0a7520a19d062fc0043e345066ca.1788110147.git.cw@f00f.org>
 <apWEWJyhaEQc62fK@infradead.org>
 <20260831173705.GA1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831173705.GA1933798@frogsfrogsfrogs>

On Mon, Aug 31, 2026 at 10:37:05AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 31, 2026 at 06:40:40AM -0700, Christoph Hellwig wrote:
> > On Wed, Aug 26, 2026 at 10:08:13PM -0700, Chris Wedgwood wrote:
> > > libxfs/ mirrors the kernel's fs/xfs/libxfs/, and the tool checks that.
> > > libxlog/ carries files taken from the top level of fs/xfs, and nothing
> > > checked those, so a divergence there was invisible.
> > 
> > Yeah, I recently ran into that as well recently.
> > 
> > > State the second mapping explicitly rather than searching for a matching
> > > name, so each directory has one declared kernel counterpart.
> > 
> > What I wonder then is why we don't actually have this code in libxfs.
> > I didn't get to investigate if there is a good reason for that, but
> > if we could move the files to libxfs life would be much easier.
> 
> I've long wondered if the kernel logging code should all move to
> fs/xfs/libxlog/ and the userspace logging code to libxlog/ to make this
> easier?

That was the intention I had over a decade ago when I created the
shared libxfs/ codebase infrastructure. It never happened because
the only thing that used libxlog (logprint) really never needed to
be kept in sync with the kernel code as libxlog could (and still
can) resolve the head and tail as well as log and ophdr structures
perfectly fine wihtout needing to be sync'd to the kernel.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
