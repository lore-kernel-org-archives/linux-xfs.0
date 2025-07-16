Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6211D7E26
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681761; cv=none; b=Rt8/2aiCPMZXHTgbRGyzpt+v9o3O3De+7s2sNMhWyjcOxkQLSXa1Sy1Smn2Y32cXFh7IDeVaUmRkozgov2E58EioiElGwS0fnJDhaysMKi5hL+36//sCR//9JBLtPbciwMdZPJGhXBEAJNPQZh3yrF1ZINy0NrNu9ve0JFqRhNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681761; c=relaxed/simple;
	bh=M24oBZXjGXPNtxozfWJRVakTGrli4bykecBxu3fkCy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+haFO9SioZ6+B63ujXIMsOcU+VcveVzl0VLfkhpgUyi+TQpf9QV/SCOh+lw7r3KMiMCTGb8DrQGyIzeYeBjjpIn0eOSHQ1sGLqxb38O7ICB6mMT5rP0o035JpBN5XC6m8MfhTflaEv9QTejLfcAUJRP4/WkKH5htA4zJ1fMmVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 50FB068BFE; Wed, 16 Jul 2025 18:02:35 +0200 (CEST)
Date: Wed, 16 Jul 2025 18:02:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Fedor Pchelkin <pchelkin@ispras.ru>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: flakey assert failures in xfs/538 in for-next
Message-ID: <20250716160234.GA15830@lst.de>
References: <20250716121339.GA2043@lst.de> <20250716153812.GG2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716153812.GG2672049@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 16, 2025 at 08:38:12AM -0700, Darrick J. Wong wrote:
> I've seen this happen maybe once or twice, I think the problem is that
> the symlink xfs_bmapi_write fails to allocate enough blocks to store the
> symlink target, doesn't notice, and then the actual target write runs
> out of blocks before it runs out of pathlen and kaboom.
> 
> Probably the right answer is to ENOSPC if we can't allocate blocks, but
> I guess we did reserve free space so perhaps we just keep bmapi'ing
> until we get all the space we need?
> 
> The weird part is that XFS_SYMLINK_MAPS should be large enough to fit
> all the target we need, so ... I don't know if bmapi_write is returning
> fewer than 3 nmaps because it hit ENOSPC or what?
> 
> (and because I can't reproduce it reliably, I have not investigated
> further :()

I guess the recent cleanups are not too blame then, or just slightly
changed the timing for me to have a streak to frequently hit it.

xfs/538 is the alloc minlen test that injects getting back the minlen
or failing allocations if minlen > 1.  I guess that interacts badly
somehow with the rather uncommon multi-map allocations.  The only
other one is xfs_da_grow_inode_int, and that only for directories
with a larger directory block size, and as a fallback when the contig
allocations fails.  It might be worth crafting a test doing a lot
of symlinking while doing that error injetion to trigger it more
reliably.
