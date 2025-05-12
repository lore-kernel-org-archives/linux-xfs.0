Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D622309BD
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747062872; cv=none; b=iXkTUTAoAkmgOTgTavlRplNLFbObaO6KMry4D/7jiAvTrRxTXYLd7+ePhpjhW5vhTe0W3sl1cv3nuM3bvYK+Rggc59GFkL15M/KKa7uBX9WJb5UFvO0OlSt1F+VDXS3EWMR0eDO5EamU/G6I/Hr2KrWEemHCL9Pae39+wTPo+f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747062872; c=relaxed/simple;
	bh=rUdOmlSRphu5xLNAoKkNiQhyFSGkiO10hUWuen9gcwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSf7e06P94BMh3uJbs2p616ARMptGmK64kGc0g+N7tolwIumKTQx682drPqfOFG003CLqtSnTZkZKMU9Pof3wfzT6BDqOcI5slfcHJlFJAS5G2YZqBH1Vzn3wD9RRk0xDP1jzn3SqMqpt9lXaqDiw5SFXE1s7sZYVvT1OnSPQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfqP+Vd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfqP+Vd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBA7C4CEE7;
	Mon, 12 May 2025 15:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747062871;
	bh=rUdOmlSRphu5xLNAoKkNiQhyFSGkiO10hUWuen9gcwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dfqP+Vd1rO7D5iQ/6gjN35MtBxKh2xbB+0OE4UV5jv7fBb+toODAZ1Od6rzeg0qMl
	 CBkAN7z2Laugx3hIZoZSAfF8MxWkBnvl/5YGFP2jyEiq3qrWjXK3q7pKbTMeFIoJnO
	 pQstfm3x/75eflW033aCHnQCdmzck4chvKTnT3jOfLXpI3hIXl6a6DdtHS2ZZ3BuAk
	 z57UT/yABPILn940+WjXalCycm0tjRNHg7rFElKmcXqMh44CI8stvMhrp+CLfYkZfU
	 ztLsuClJFGMG5f0zlHlda9LQuMp+Fr4pOVv6RXI41BSBfs/cQM6OsQDrUlVK2BLWB/
	 uKiRMYi9FMh/A==
Date: Mon, 12 May 2025 08:14:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove some EXPERIMENTAL warnings
Message-ID: <20250512151430.GF2701446@frogsfrogsfrogs>
References: <20250510155301.GC2701446@frogsfrogsfrogs>
 <aCF6UHNzRqZaH2dK@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCF6UHNzRqZaH2dK@infradead.org>

On Sun, May 11, 2025 at 09:34:24PM -0700, Christoph Hellwig wrote:
> On Sat, May 10, 2025 at 08:53:01AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Online fsck was finished a year ago, in Linux 6.10.  The exchange-range
> > syscall and parent pointers were merged in the same cycle.  None of
> > these have encountered any serious errors in the year that they've been
> > in the kernel (or the many many years they've been under development) so
> > let's drop the shouty warnings.
> 
> Looks good.  Talking about experimental warnings, I'd also like to
> drop the pnfs warning.  The code has been around forever, and while
> we found occasional issues in the nfsd side of it, they were quickly
> fixed.

I agree, let's drop the pnfs warning since warts or not the code has
been stable for a long time.  However, would you (hch) mind writing that
patch since you're the author of xfs_pnfs.c and I've never even used it.

--D
