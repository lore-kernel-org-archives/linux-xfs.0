Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C14DC2C8
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 02:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470915; cv=none; b=rf894Pd+B3y2RUH7kDTzfqgahPSDQV7MnHAvxY7WMjvK3jWU6W0BdtabK7RNx0ncIYVOUWpLAop63qnsb2CcX9JvTbG7FUANHYsB7yQ7h9wsKaL4tdxNJb32SG+EA2HNR9plhMldxxjIJ+lTwWjlQn/MhGyFljtiiFPrBrmT+dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470915; c=relaxed/simple;
	bh=lq4QXkAw6HySz+YBIUJEGxQtYvhpyHavrPPSNOUJZJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNrfSBO468Xmg9oXuQVF5mZy7h8Vkc0mK1ffcplLnwsyI1woqMGPkRx0enrCuDebiHw6ntkbGUYGzwhcS4cantCoOuy+Az8VEnc11qVeP+2fXmE/+5LZdSmw+w0IwKGgFyiCN0odkaensj5pVmKgFx2dB5HVTplDiuInoXyugyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jOhUmESp; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jOhUmESp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1kXlVCUzsWHu7LUvV/LZDMbfzkf5pQ2psnCrhAnoqW0=; b=jOhUmESp+nx+WKkMjbLu8x4gmY
	7F86+q57MZzuu5CbE6HS5RzGCzT96JXT+NGN/PPx1aCiWnoc42nj1RA1kBdaBqp04es/YpWwPs0+5
	SzE3vFniwn+o/rJ6raKFaGVH5cnRakULvqPxte39d5uvp7gOr9n5vijmlrkr4MBNNG8Yi1XDUOOn6
	an/VWyybcHTCuKADUSxkf0T7rWc9wIClpB/G4yKMjcXChHl8M24ymugDx6dz4RVWVO9cP2yR90nXx
	EYsvg1k/bzUHQKHYzyvEepPfgDgaEwBiqOC8WMh5fxO/cdazuEtHKTWDwyEyOfRdD+NmNY8mSqzyr
	soVloHyw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkxcR-00000009Gzs-3n1m;
	Fri, 15 Mar 2024 02:48:27 +0000
Date: Fri, 15 Mar 2024 02:48:27 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: Max theoretical XFS filesystem size in review
Message-ID: <ZfO2-wefNDEJGL5w@casper.infradead.org>
References: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
 <ZcQYIAmiGdEbJCxG@dread.disaster.area>
 <ZfOSZnYi-02SoBIJ@bombadil.infradead.org>
 <ZfOg3dTO/R43FGiZ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfOg3dTO/R43FGiZ@dread.disaster.area>

On Fri, Mar 15, 2024 at 12:14:05PM +1100, Dave Chinner wrote:
> On Thu, Mar 14, 2024 at 05:12:22PM -0700, Luis Chamberlain wrote:
> > Joining two 8 EB files with device-mapper seems allowed:
> > 
> > truncate -s 8EB /mnt-pmem/sparse-8eb.1; losetup /dev/loop1 /mnt-pmem/sparse-8eb.1
> > truncate -s 8EB /mnt-pmem/sparse-8eb.2; losetup /dev/loop2 /mnt-pmem/sparse-8eb.2
> > 
> > cat /home/mcgrof/dm-join-multiple.sh 
> > #!/bin/sh
> > # Join multiple devices with the same size in a linear form
> > # We assume the same size for simplicity
> > set -e
> > size=`blockdev --getsz $1`
> > FILE=$(mktemp)
> > for i in $(seq 1 $#) ; do
> >         offset=$(( ($i -1)  * $size))
> > 	echo "$offset $size linear $1 0" >> $FILE
> > 	shift
> > done
> > cat $FILE | dmsetup create joined
> > rm -f $FILE
> > 
> > /home/mcgrof/dm-join-multiple.sh /dev/loop1 /dev/loop2
> > 
> > And mkfs.xfs seems to go through on them, ie, its not rejected
> 
> Ah, I think mkfs.xfs has a limit of 8EiB on image files, maybe not
> on block devices. What's the actual limit of block device size on
> Linux?

We can't seek past 2^63-1.  That's the limit on lseek, llseek, lseek64
or whatever we're calling it these days.  If we're missing a check
somewhere, that's a bug.

