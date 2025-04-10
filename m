Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FD31C9B97
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744267537; cv=none; b=qvmFD0qnhzq6tkke2F4BUE+bD6Ilvix6EFRmMBYur2tS2BCd5N3HzkckQl+tZG+Dl4z3oXxzMFpiCPsmTH6915l7YdblXCn4Uq5slvt9pdZohfu9tn37vQ7aZQPZPtsmiHGKZ1ubwHXKzJ9LPz7iREfNEuMpUy+AB5cfw+b62Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744267537; c=relaxed/simple;
	bh=M8XSgRdoFtmTzZ79nnyphpdHUap00bFpKKRIWGYGlJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MoHdEQjV82sZCHvavA2JIgUGBaywKMvWvHAheVSyL5BwqQ+sS1knaq3VBUkWMAXz4ztAT3qAm+yTKmRg13QCIYiXODfpc8244eJjXM46Svil4fB7rDThzKWHJedfJtjiz9FkWxNWMq7OvJ7gk/SH52gN/9W6XD0K69puPcRXx3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A762668BFE; Thu, 10 Apr 2025 08:45:32 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:45:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/45] xfs_mkfs: default to rtinherit=1 for zoned file
 systems
Message-ID: <20250410064532.GF31075@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-33-hch@lst.de> <20250409185921.GG6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409185921.GG6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 11:59:21AM -0700, Darrick J. Wong wrote:
> > +		/*
> > +		 * Force the rtinherit flag on the root inode for zoned file
> > +		 * systems as they use the data device only as a metadata
> > +		 * container.
> > +		 */
> > +		cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
> 
> If the caller specified -d rtinherit=0, this will override their choice.
> Perhaps only do this if !cli_opt_set(&dopts, D_RTINHERIT) ?  I can
> imagine people trying to combine a large SSD and a large SMR drive and
> wanting to be able to store files on both devices.

Sounds reasonable.

