Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E3B291E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066559; cv=none; b=J2JfNn85fGOk1yMTctkS6wj6TRKpPil9u1Ve05RKORKcR+4XfH9pDaeJ2yFiWjuxDtuE9aWjsnQYZ9z19APP/PaTVPIV4cSIze3H7rN6zSm5V9QvA8zigOS6Bncnl/aZoXjVm+PUluo8UINHllLfRcp++cRFmIu3cjYOVXgVQGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066559; c=relaxed/simple;
	bh=YgZ9FGc+4qtBlvA+6bwOH42tGKHrVrNS5Fk+Jf+Fmfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kv6QHmqTDIp9WGNlSuaFOWPkfLokALPvosZxw+7S9p+4Ptp32+yAyREhJquHlhCrn2t8qkvvz1G5BSo5tjddCZ35YenaXzJGmMNEDQgdQMvPHDvZtHNNzEb1zfU4/R1fJzPMIHOcjYALPbKHBTWLZGZxHMaW09C1FjXTGQTZLZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 58C4868BEB; Fri, 13 Dec 2024 06:09:15 +0100 (CET)
Date: Fri, 13 Dec 2024 06:09:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/43] xfs: report the correct dio alignment for COW
 inodes
Message-ID: <20241213050914.GE5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-9-hch@lst.de> <20241212212953.GT6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212212953.GT6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:29:53PM -0800, Darrick J. Wong wrote:
> > +	/*
> > +	 * On COW inodes we are forced to always rewrite an entire file system
> > +	 * block.
> 
> That's not quite accurate -- we're always forced to write an entire file
> allocation unit so that the rest of the bmap code doesn't have to deal
> with a file range that's mapped to multiple different space extents.
> For all the existing reflink scenarios the allocation unit is always an
> fsblock so this is a trifling difference.

Which right now is a block until we support horrors such as reflink
on larget rtextsize inodes or the forcealign stuff.  But yes, it
could use the helper.

