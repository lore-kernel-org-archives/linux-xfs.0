Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329D514F125
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 04:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760588633; cv=none; b=Jl9v2h+rbDw/G/7wEYcOvKfOTKzamRytXgL/LYlg3XSRZdYScoIc31/fp84m3vR3okoBHIAgv4TPt8Ri2xHy/GOXlqrEhogkppDOKgHXMEaEQXc6CO58UTAQYvgEGEGun0Gn7GwnLokiDsQJBNpbGt9WzLcwYL2R1WOowTKL60Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760588633; c=relaxed/simple;
	bh=5vUsXIJQ3UBrYFxpBilDeiJzfEFI88OhXiuMDHBLe4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCO2xrv3n4IbcE+y8i21l4U+C1cFAy22eF2y4DBVyIWsatI5EBE5TkNwTvZKWXxaRJGyGz9ZrMQrlFAQSiSZWitnrfX+CfuDmz7gQ1ayNAMq/EWSOV/o1HFrlWV1EHJpnq7ZwtcANuDBBrsxL6HNAIx6HIrbk/kiyQmc7zIdDl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 65FF8227A87; Thu, 16 Oct 2025 06:23:48 +0200 (CEST)
Date: Thu, 16 Oct 2025 06:23:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs: reduce ilock roundtrips in
 xfs_qm_vop_dqalloc
Message-ID: <20251016042348.GC29822@lst.de>
References: <20251013024851.4110053-1-hch@lst.de> <20251013024851.4110053-18-hch@lst.de> <20251015212707.GM2591640@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015212707.GM2591640@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 15, 2025 at 02:27:07PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 13, 2025 at 11:48:18AM +0900, Christoph Hellwig wrote:
> > xfs_qm_vop_dqalloc only needs the (exclusive) ilock for attaching dquots
> > to the inode if not done so yet.  All the other locks don't touch the inode
> > and don't need the ilock - the i_rwsem / iolock protects against changes
> > to the IDs while we are in a method, and the ilock would not help because
> > dropping it for the dqget calls would be racy anyway.
> 
> ...and I guess we no longer detach dquots from live inodes now, so we
> really only need ILOCK_EXCL to prevent multiple threads from trying to
> allocate and attach a new xfs_dquot object to the same inode, right?

Yes.

> Changing the i_dquot pointers (aka chown/chproj) is what's coordinated
> under the iolock, right?

Yes.  i_rwsem in the VFS to be specific, but they are the same actual
lock.

