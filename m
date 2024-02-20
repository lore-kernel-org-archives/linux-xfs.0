Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8076B58135
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 05:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708406028; cv=none; b=IBnVAWnsj/q8jtiXFF1U+KggcvzA7gr7FcoUGyEIQbwwdNSX7jxqLUzOskfIVe7hDvkeU4dVmJF8QXAoEHbXAyQBCB2qnXANWLrqeT0+RKev2V2F532k/ganWAc82N2tSNzE1m6zD9Hqydd6soy7dJKvbboLOUY1mto0oShKxc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708406028; c=relaxed/simple;
	bh=6U+SpNqUivRkAg9YCeYZYg0cXA22AlitGKnU+ifcPNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWKJXqw8qjSzRvdbD1dKSGDdx7W37evPsSXkZzST4eeen/xaiqF+eI6nauCJv+bKg7CyXHWv9yHpLBSzBnmPGV8yWeZRjEcf3bsz66up3FSqmsIgeYLfmKidMynUobh24RgxoHg5Bq8ueghYm3kjnBbeXRd28CY4YBEqbnwBAYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EFFAF68AFE; Tue, 20 Feb 2024 06:13:41 +0100 (CET)
Date: Tue, 20 Feb 2024 06:13:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: stop the steal (of data blocks for RT
 indirect blocks)
Message-ID: <20240220051341.GB5988@lst.de>
References: <20240219063450.3032254-1-hch@lst.de> <20240219063450.3032254-9-hch@lst.de> <ZdPogLjdypKDgm0D@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdPogLjdypKDgm0D@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 20, 2024 at 10:47:12AM +1100, Dave Chinner wrote:
> Ok. If you delay the ip->i_delayed_blks and quota accounting until
> after the incore extent tree updates are done, this code doesn't
> need to undo anything and can just return an error. We should also
> keep in mind that an error here will likely cause a filesystem
> shutdown when the transaction is canceled....

Yes.  However (as documented in the commit log), the only place where
I think it can actually happen is on a buffered write errors as "real"
hole punches always flush delalloc space before.

> FWIW, if we are going to do this for rt, we should probably also
> consider do it for normal delalloc conversion when the indlen
> reservation runs out due to excessive fragmentation of large
> extents. Separate patch and all that, but it doesn't really make
> sense to me to only do this for RT when we know it is also needed in
> reare cases on non-rt workloads...

Can it happen for non-RT extents?  That would assume the required new
indirect block reservation for splitting an extent would have to be
larger than the amount we punch out.
