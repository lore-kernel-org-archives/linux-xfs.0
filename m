Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF87137915
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 18:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711563135; cv=none; b=sMQztDBVcf1WYWVh14ps/U5RhzBs62gE+yp24QBMQ6o/WByuUgUOhZit6uIRCq5u5YCs3jGF6qGkjAy2llLuPiuOMI/Ejb6Y3fZnbN4AhCDojgSH6UqOTg4TeVocPjwzg3mbbBjaT8ieCzyz4SA5LW7/9Wop0b58JgNPr+aAxPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711563135; c=relaxed/simple;
	bh=POW32fCrn8neKI2hqSwNBYiGgBBpWGWU9zgMKEBAPrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7FupjofnkPXle0GPFwzg8afUwVIXQbBliHE7q+3hCSWDNoo26WHKdr3KnaShTXqhdYRTePusX4FMU1+rnzPkFr0yh2VpiS8IFMY9zlaF3ogGrKKc+faM8IzGEU8kzhFL69tkWghbmkli7rD+FgodbHNRNjsWB60R+BHnVOxiqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4205368D17; Wed, 27 Mar 2024 19:12:09 +0100 (CET)
Date: Wed, 27 Mar 2024 19:12:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240327181209.GB1142@lst.de>
References: <20240327110318.2776850-1-hch@lst.de> <20240327110318.2776850-5-hch@lst.de> <20240327150755.GX6390@frogsfrogsfrogs> <20240327170632.GC32019@lst.de> <20240327180600.GC6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327180600.GC6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 27, 2024 at 11:06:00AM -0700, Darrick J. Wong wrote:
> <nod> I think once we get to the rtgroups patchset then all we have to
> do in __xfs_bunmapi is:
> 
> 	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK &&
> 	    !xfs_has_rtgroups(mp))
> 		nexts = 1;
> 
> and then the XFS_TRANS_RTBITMAP_LOCKED flag can go away?

Probably.  We could also try to do it now, but that's just yet
another variable changing..

