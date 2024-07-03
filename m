Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09410282FA
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 05:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719983516; cv=none; b=tYagST28ldxPyaU6meoVLQoSwALIbtngsTIXkRn9/xYQ2M1yJBmUJc7Bc5wIgBWrwFfnN2pLxwWkyWjups1o/qgaWWeBejJXnLAcD+BYS4AJyG/1oomyihM2R17tqYtf8s+mXeL3a3XMBQhnMeBTtqVz2xdAeRZcGOWeWs1KSWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719983516; c=relaxed/simple;
	bh=hee66ztXpBZhj+oyXqlLPlAlC0rOpjQcwU6BrChUCpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hD6yE+sPQdcszHzuphpXrmOfgd8UVN/4tJ7yyMuRudlPPoH1cn7neMxBbortVHEZtbYqx0JBRNk91rtD1UYgtt9XHAV0QcCJX5EGOa6NXruhSwq72X+vIijOSvJz5DEGF6yqIkCiVBSovRUiz8Ht9UwRKFCfgsqe1g3jOdq7HS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 98F1D68AA6; Wed,  3 Jul 2024 07:11:50 +0200 (CEST)
Date: Wed, 3 Jul 2024 07:11:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240703051150.GA24923@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs> <20240702053627.GN22804@lst.de> <20240703022914.GT612460@frogsfrogsfrogs> <20240703042922.GB24160@lst.de> <20240703045539.GZ612460@frogsfrogsfrogs> <20240703045812.GA24691@lst.de> <20240703050422.GD612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703050422.GD612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 10:04:22PM -0700, Darrick J. Wong wrote:
> > I know people like to fetishize file access (and to be honest from a
> > shell it is really nice), but from a C program would you rather do
> > one ioctl to find a sysfs base path, then do string manipulation to
> > find the actual attribute, then open + read + close it, or do a single
> > ioctl and read a bunch of values from a struct?
> 
> Single ioctl and read from a struct.
> 
> Or single ioctl and read a bunch of json (LOL)
> 
> I wish the BLK* ioctls had kept pace with the spread of queue limits.

Let me propose a new BLKLIMITS ioctl, and then we'll work from there?

