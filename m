Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CCF524A;
	Fri,  8 Mar 2024 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709911308; cv=none; b=TAk8Vf9BZevuM3QOzzP3cVISMAMNlnO4f9PBU/5QjgzH1lOJoC0X2ECsauwg2T2c5Ak0wKKNu2pZIqUD7NpThjbF4B9myLslemgcnKz1LfI8n3+mWeCPRuFQi4+iyFfXgIe9MtsYAC2Fx7OUWp5xkmrvhHxGoZqc+jik6wfB/OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709911308; c=relaxed/simple;
	bh=Epcy6L/WHsfh5gEuVylKKhaqJvXihZWl1V8FN/nRcCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8sIZByg1+B3nsbja4+t0oa6bKTMFznQpfE41wZgGw+qJNz6phuGwnL/KxXQ97cBBO/VU7Ob0hI1+N+stOdkFViejV6+H7tdvADeahko1PeueqlCYpsa7rKMD98zoWSzZuUoodD6z7wQWpI22hn6foIp1pvSA+1shQyaZhiLLcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6F0BE68BEB; Fri,  8 Mar 2024 16:21:43 +0100 (CET)
Date: Fri, 8 Mar 2024 16:21:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: RFC: untangle and fix __blkdev_issue_discard
Message-ID: <20240308152143.GB11963@lst.de>
References: <20240307151157.466013-1-hch@lst.de> <Zeor_z55xu6ulRyP@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zeor_z55xu6ulRyP@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 07, 2024 at 02:05:03PM -0700, Keith Busch wrote:
> On Thu, Mar 07, 2024 at 08:11:47AM -0700, Christoph Hellwig wrote:
> > this tries to address the block for-next oops Chandan reported on XFS.
> > I can't actually reproduce it unfortunately, but this series should
> > sort it out by movign the fatal_signal_pending check out of all but
> > the ioctl path.
> 
> The last patch moves fatal_signal_pending check to blkdev_issue_discard
> path, which has a more users than just the ioctl path. 

That's true.  I guess I actually need to open code blkdev_issue_discard
in the ioctl path or pass a flag (which would be a bit annoying)
