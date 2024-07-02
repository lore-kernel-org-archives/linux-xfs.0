Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4CD79DF
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898226; cv=none; b=SxKeOhcx6GCd4INzlQyVXJ0tffmQi5BBNQQ4U8IJB4JZ2nxkfY6Xjd3vxwC70ze/7jiOl9hwj38XfZMhzPII5CXSdFjjHImx3OOXLkOKvudsG3OAqxyi65Jm0I40aAEU7R5fTcchhT1mZSNMSmwGJjbIKvh6HVSJAJtsZl57vDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898226; c=relaxed/simple;
	bh=WfwK/n41KdR5Xoo8vwXl0yMPVDcBIpft3KEYiVohMHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2qcw3YSHhByG+bfwIakrA8xbWtxrQcKWRU3vDOq7oQfu2G7L2IXscCAOqej+iawjEAqNpHlse5kmuE9PCnh3fYsnVM9BRnixrn/VOh4vdMGe9ZXsNSwQZFqbBh2w6SsEyx4hOvj7gVMkGls6dnkIww+RyylmBW4SMekosKnlAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4DDB768B05; Tue,  2 Jul 2024 07:30:20 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:30:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 7/8] xfs_scrub: don't trim the first agbno of each AG
 for better performance
Message-ID: <20240702053019.GG22804@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 01, 2024 at 06:02:36PM -0700, Darrick J. Wong wrote:
> Therefore, we created a second implementation that will walk the bnobt
> and perform the trims in block number order.  This implementation avoids
> the worst problems of the original code, though it lacks the desirable
> attribute of freeing the biggest chunks first.
> 
> On the other hand, this second implementation will be much easier to
> constrain the system call latency, and makes it much easier to report
> fstrim progress to anyone who's running xfs_scrub.  Skip the first block
> of each AG to ensure that we get the sub-AG algorithm.

I completely fail to understand how skipping the first block improves
performance and is otherwise a good idea.  What am I missing?

