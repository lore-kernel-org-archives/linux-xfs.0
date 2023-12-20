Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252E38F45
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 03:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D289E68BFE; Wed, 20 Dec 2023 04:55:20 +0100 (CET)
Date: Wed, 20 Dec 2023 04:55:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove xfs_attr_shortform_lookup
Message-ID: <20231220035520.GA30958@lst.de>
References: <20231219120817.923421-1-hch@lst.de> <20231219120817.923421-6-hch@lst.de> <20231219144627.GA1477@lst.de> <20231219174505.GM361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219174505.GM361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 19, 2023 at 09:45:05AM -0800, Darrick J. Wong wrote:
> Eh, there's lots of, uh, cleanup opportunities in the xattr code. ;)
> 
> The changes below look reasonable, but I wonder -- the leaf and node add
> functions do a similar thing; can they go too?
> 
> I'm assuming those can't go away because they actually set @args->index
> and @args->rmt* and we might've blown that away after the initial lookup
> in xfs_attr_set?  But maybe they can?  Insofar as figuring all that out
> is probably an entire campaign on its own.

Yeah, this looks pretty scary to touch for a cleanup series that's
already gone kinda out of bounds..

> 
> > So..  I'm tempted to just turn these checks into asserts with something
> > like the below on top of this patch, I'll just need to see if it survives
> > testing:
> 
> I'll await your return then. :)

It has been surviving testing just fine over night.

