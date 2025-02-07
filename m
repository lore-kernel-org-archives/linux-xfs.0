Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83722417CA
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738901977; cv=none; b=K+EmBtS6E9zsavokmDp5dApA5IiVko5LaS992E0GRZXoGdydXcxfSqMSj2WbhYpkaiRIM8rJ44XzXcloW+dFYt1vVfUk1dTaAYsDJEh4s2P0cyawj6f0Cn+enhlp0m7xiOtqmAhg2SzHtFiNOni0791MH17UJ6FLNF10ZwTjalk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738901977; c=relaxed/simple;
	bh=rAD+dVbdM9EEv0PKc15MBTmdll9jVMDHDCvdPmfnXIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hs3n8yOFSFlTiNrcO7khaILQRRaML1Qf6Cf47UdOQ52R09rbPLjDg2lkTFQG9tJUVBDRwH2iNH5svIJ/UQdQuW0bxrA197iJ2X3cRYErweDRAH0IwD8tflKofh0y5BCVQ9311x5d/EKo0YMYtSStHZqeggAszILHlTdVCHdLCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D2F768C4E; Fri,  7 Feb 2025 05:19:32 +0100 (CET)
Date: Fri, 7 Feb 2025 05:19:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/43] xfs: reduce metafile reservations
Message-ID: <20250207041931.GC5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-12-hch@lst.de> <20250206205249.GM21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206205249.GM21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 12:52:49PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 07:44:27AM +0100, Christoph Hellwig wrote:
> > There is no point in reserving more space than actually available
> > on the data device for the worst case scenario that is unlikely to
> > happen.  Reserve at most 1/4th of the data device blocks, which is
> > still a heuristic.
> 
> I wonder if this should be a bugfix for 6.14?  Since one could format a
> filesystem with a 1T data volume and a 200T rt volume and immediately be
> out of space on the data volume.

Yeah.  But for this to be safe I think we also need the previous patch
to sitch to the global reservations.  Which at least in the current
form sits on top of the freecounter refactoring..

