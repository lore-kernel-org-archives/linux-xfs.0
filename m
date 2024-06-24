Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2B87604D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719249780; cv=none; b=Xd67uE9n0h3Z1ZsimiIA/fREfVYqN4z+SHdj03Tj53URiqVpLZhcrA4Bl+nhRVx/sjMf4MLlEXjPiTX27kd5vkcqhzRwOx9Lbum5sE+6Gb+NOsve01oCAySCl209I5hlng2+W3mVmWRUJ+91HiXELvoVCC4/lpxBkI/gNAMRHkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719249780; c=relaxed/simple;
	bh=YE/vtGiWOO28E01wE/10yMHrcaXxQASjGWMbhRS10o4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ym1+8/13xGS2hnK3SInxMMQ7IqWJRU/MxSsk/mHQxfgQOpeErxOZzEGD+n2mrNh1JubwP1UnBXmCXpNJMWXYM2SYLiuEQ1rFl/X17uEdLhplqgSPZkRxLF1USdZyThYDGcXiSBdwWNloBsgwFdC7phCLgicyg550hfpyqOtw9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3A36968CFE; Mon, 24 Jun 2024 19:22:54 +0200 (CEST)
Date: Mon, 24 Jun 2024 19:22:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: reclaim speculative preallocations for
 append only files
Message-ID: <20240624172253.GA22044@lst.de>
References: <20240623053532.857496-1-hch@lst.de> <20240623053532.857496-11-hch@lst.de> <20240624155443.GN3058325@frogsfrogsfrogs> <20240624160735.GA15941@lst.de> <20240624170618.GN103057@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624170618.GN103057@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 24, 2024 at 10:06:18AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2024 at 06:07:35PM +0200, Christoph Hellwig wrote:
> > On Mon, Jun 24, 2024 at 08:54:43AM -0700, Darrick J. Wong wrote:
> > > >  
> > > >  		if (xfs_get_extsz_hint(ip) ||
> > > > -		    (ip->i_diflags &
> > > > -		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
> > > > +		    (ip->i_diflags & XFS_DIFLAG_PREALLOC))
> > > 
> > > The last time you tried to remove XFS_DIFLAG_APPEND from this test, I
> > > noticed that there's some fstest that "fails" because the bmap output
> > > for an append-only file now stops at isize instead of maxbytes.  Do you
> > > see this same regression?
> > 
> > No.   What test did you see it with?  Any special mkfs or mount options?
> 
> IIRC /think/ it was xfs/009.  No particularly special mkfs/mount
> options, though my memory of 10 days ago is a bit hazy now. :(

009 was the case when I also removed the XFS_DIFLAG_PREALLOC check
accidentally in the very first version.

