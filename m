Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA15B19644B
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 07:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233500; cv=none; b=VqSP4jxddH0xM+G2SOblJeMWZqO/W8r+kDmENkKtqo7msMDURRGNKxu0uvVjXTWIEosnw/EwnWN1AaJqhOaYAcd2hfCmyXeFygjq3+PMPl2U/hsiHFXXr/DWfPp8EnT8l9cHJDvqXg9goK1GGoziqWyykk5D7dBxUweAdICxcOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233500; c=relaxed/simple;
	bh=VNhNdzH+CJYBDyobAZ8g0ixKR82b703cypcQ9ZkvFaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NUITYqaCifHDtWqahFL65Neu33jnxZilYtoc8WN5FqUhiIrvrOLBJFEdfiNJ6/npy3zaXbgO67XG41kny7+LIset5JZW3cgeQP1GxXK4kraaaOfqJoJwQ/3EsUpUFE1x3H3ZA3HJAKzFHMtPnNZzu75apAjv6KyNIaHBSGE7kO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPgNNbGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPgNNbGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFDBC4CEE0;
	Tue,  7 Jan 2025 07:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736233500;
	bh=VNhNdzH+CJYBDyobAZ8g0ixKR82b703cypcQ9ZkvFaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dPgNNbGSSbw2zibU8hC/jy6ptfZ9x9vTQBuuFmbQFsZAwg7iwEt8ivnKWqJTwcrIJ
	 Ma0i2YUBZT1ehDohMea9JXixfepC9qG0cvQnmIPY4iHgzIc/OrLJrN+byUmJFZSxKD
	 SI6vhHQav3LS4r0V6NhL3E7i9JWGFxKbDYSob/RUPL5fgbX1OY1FEMH4ud6S6Vt08v
	 lYXw7c/eHPGVR2gtVmrb/DE6zyr0+Zc87TePyZ75geCB3kaNaUNrWLAUMhUNQ1U4Gd
	 VoKAcdslD/FQLxAInD4JlRKgrzEYA2ndIRpzmhH3EgDV2FLmKBYhaRpRNCsg7MDrv7
	 RYcnWBe0gDa5A==
Date: Mon, 6 Jan 2025 23:04:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sai Chaitanya Mitta <mittachaitu@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <20250107070459.GI6174@frogsfrogsfrogs>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
 <20241223215317.GR6174@frogsfrogsfrogs>
 <CAN=PFfKDd=Y=14re01hY970JJNG7QCKUb6NOiZisQ0WWNmhcsw@mail.gmail.com>
 <20250106194639.GH6174@frogsfrogsfrogs>
 <Z3zGS9Ha13I8VBtI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3zGS9Ha13I8VBtI@infradead.org>

On Mon, Jan 06, 2025 at 10:14:35PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 11:46:39AM -0800, Darrick J. Wong wrote:
> > That sounds brittle -- even if someday a FALLOC_FL_WRITE_ZEROES gets
> > merged into the kernel, if anything perturbs the file mapping (e.g.
> > background backup process reflinks the file) then you immediately become
> > vulnerable to these crash integrity problems without notice.
> > 
> > (Unless you're actually getting leases on the file ranges and reacting
> > appropriately when the leases break...)
> 
> They way I understood the description they have a user space program
> exposing the XFS file over the network.  So if a change to the mapping
> happens (e.g. due to defragmentation) they would in the worst case pay
> the cost of an allocation transaction.
> 
> That is if they are really going through the normal kernel file
> abstraction and don't try to bypass it by say abusing FIEMAP
> information, in which case all hope is lost and the scheme has no chance
> of reliably working, unless we add ioctls to expose the pNFS layouts
> to userspace and they use that instead of FIEMAP.

I get this funny feeling that a lot of programs might like to lease
space and get told by the kernel when someone wants/took it back.
Swapfiles and lilo ftw.

--D
