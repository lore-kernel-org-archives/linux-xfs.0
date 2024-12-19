Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6018816CD1D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629782; cv=none; b=cQ0TX3vqVdCFvFD25U60lU+8uTuXDRcqqQlPzMt/MMZrulE30e1JJBVuqLt6a/pajtUBzLcU/8IA24cClEkc6e5rfpUTiUmm7YmXOalHmfv3zablCgv0caFZnmpdNPeGrzvvOIvf5YRM609Y0Llgj81S+p3ebBZTcUBVeZh+iM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629782; c=relaxed/simple;
	bh=TE72nDkb7kURmQhJwqIjjYoG4Ub6RjREh2pFGbGbmEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOTH/WETZMDs08Sv1qJYG7dDFsNA5NrTxsLOdPjOPWO5Ts87+UsOr6uXbtMMZfeyngRZLkoiIrsmAVNX9tZ+tvUe1+iLnD6NqcLtZdqBTXdpRfOCUTZzpOQ2H4avnyeqWIAZVQ73BdIvvP92LDoOo53l0t8v0tgeXHUlYJ/NEjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8A87D67373; Thu, 19 Dec 2024 18:36:16 +0100 (CET)
Date: Thu, 19 Dec 2024 18:36:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: add support for zoned space reservations
Message-ID: <20241219173616.GB30295@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-26-hch@lst.de> <20241213210140.GO6678@frogsfrogsfrogs> <20241215053135.GE10051@lst.de> <20241217165955.GG6174@frogsfrogsfrogs> <20241219055059.GA19058@lst.de> <20241219160004.GI6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219160004.GI6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 19, 2024 at 08:00:04AM -0800, Darrick J. Wong wrote:
> > I really hate that, as it encodes the policy how to get (or not) the
> > blocks vs what they are.
> 
> Yeah, me too.  Want to leave it as XC_FREE_RTAVAILABLE?

That would be my preference (at least based on the so far presented
options)

