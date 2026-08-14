Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A871A5B8C
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 06:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786688675; cv=none; b=VNCoqG0xynP58k+Brl2wZjMtdMT5qxwr8fyZW/sYHfBH1KdKj7O7HKSCPoRpSNkIdJqFtTPKGVTncnPDWnfQjrO93LorgkNtDXgHI2zqYXSY71/DGtxsgLG7aVBYZUJEZZWJc3wEQg+O6/x28RckvJaC8ckOlASiOUjilu5bAkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786688675; c=relaxed/simple;
	bh=M1DslrhiaGi1KvoK2BLKEHSZNche+aLBKZJQ2It2TfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKh3LI8NS3W2DyOO4oH5OyywBnqJ4QG+fWuwZBaCcIvTU/f2POyoN7hHWW5LTI4RjEIrtN4n/oiZ/uvXCXwEah0FTIv/qv6QwTHK1eIjvSBcwzHtNX3QuwTen296O/f5sYPGLxu8MZPUoqZf3vdzjenLJ87Ei089JJCOPg+gMrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43C0268B05; Fri, 14 Aug 2026 08:24:23 +0200 (CEST)
Date: Fri, 14 Aug 2026 08:24:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, hans.holmberg@wdc.com,
	dlemoal@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: restore bi_bdev in xfs_zone_gc_write_chunk
Message-ID: <20260814062422.GA8819@lst.de>
References: <20260813145617.419537-1-hch@lst.de> <20260813151150.GE3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813151150.GE3556460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 13, 2026 at 08:11:50AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 13, 2026 at 04:56:12PM +0200, Christoph Hellwig wrote:
> > xfs_zone_gc_write_chunk relies on bi_bdev to still be valid, which is not
> > true when XFS is used on top of a stacked block device.  This can lead to
> > misdirected GC writes, writing of plain text when using dm-crypt, or
> > miscalculated I/O limits in xfs_zone_gc_split_write.
> > 
> > Fix this by reassigning bi_bdev.
> 
> ewww, what??
> 
> Should bio_reuse take a bdev parameter and set_dev itself?  I had no
> idea that bi_bdev could get changed by the time the bio completes.

It probably should, and at some point it did, but it got dropped
somewhere in review.  But ket's get the fix in without that first.

Also note that dm-crypt actually always clones these days as I figured
out when trying to come up with an xfstests for this.  So this is
mostly limited to dm-linear and nvme-multipath.
