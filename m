Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87C21D6AA
	for <linux-xfs@vger.kernel.org>; Sun, 28 Jan 2024 20:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706474014; cv=none; b=ZheVWPrc/EGolbfgr9TRPtcBQY7cybamVt18uWb35I65yES/kXec9fJMzrfUcyaFg+9wtXOJGBflSQWPwOh8LOtSKh7qYiy0j/Hn1Pv2Ajn93omxOwmMw+wjVM9jzZE3LMSkFowLfI6GsDh7nXb0MpPCatXLyKKjR719rFSWJ4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706474014; c=relaxed/simple;
	bh=Irnxzo9KitvbOqweW5W9trTQeSYFjFL4UUrG+HYICiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P8ybTF5VRGiSrNrvZcw8VmN7UkLhR/FIkPNv4LuRWH3m0pDd0wX4UKp7apcQbw8JwnVpXP3Rs117K1xrTxSAWTpiXFYRAIkLmJdghxeWxyW7YrswV1zmFwuQGFLXcKe3tudep3oBtsBrD2QmDHBYgDqKwciI7W5W0XtRqLzCuWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oqnQIp+t; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oqnQIp+t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IZEIuzWowjgS5paVGB9Th9MFI7haSD4QDPVH8hqmr8Q=; b=oqnQIp+tGoCwXg3AX5ySUTiKnx
	13q0cLtA01S03CnX0BvnXvmGb+kyK0eQG5q1XZQXg1VoTPvvv+AHJnKUuixCYy411HNRHCLd+fNRG
	PvoYvXlC5K4ngxC5yhj+UtSiqqqvD/tInnu29iH3gzokOn/30ZXd48a751ghasoVVKz8ukeQxMpJO
	zoL1N8noutboa7xeU44qU7kOEF9p/jdAsgCYCTd7eBWjhdDJ/BZsOZ9AYcsf40W1PtRORZnDOwzy3
	Ro8e7AhfQ50dDGQyjJLvbQsKxeGt8u5nIPQagqh3PcRb5gUvBowbPOAoao7T+0vs0bmIaUH6tPYth
	8hMUlsZw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUBqC-00000004UMo-21gF;
	Sun, 28 Jan 2024 20:33:20 +0000
Date: Sun, 28 Jan 2024 20:33:20 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 16/21] xfs: improve detection of lost xfile contents
Message-ID: <Zba6EOFba2sW3bb5@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-17-hch@lst.de>
 <ZbPe5FjDaQp1v8En@casper.infradead.org>
 <20240128165549.GA5727@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240128165549.GA5727@lst.de>

On Sun, Jan 28, 2024 at 05:55:49PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 26, 2024 at 04:33:40PM +0000, Matthew Wilcox wrote:
> > > +static inline bool
> > > +xfile_has_lost_data(
> > > +	struct inode		*inode,
> > > +	struct folio		*folio)
> > > +{
> > > +	struct address_space	*mapping = inode->i_mapping;
> > > +
> > > +	/* This folio itself has been poisoned. */
> > > +	if (folio_test_hwpoison(folio))
> > > +		return true;
> > > +
> > > +	/* A base page under this large folio has been poisoned. */
> > > +	if (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))
> > > +		return true;
> > > +
> > > +	/* Data loss has occurred anywhere in this shmem file. */
> > > +	if (test_bit(AS_EIO, &mapping->flags))
> > > +		return true;
> > > +	if (filemap_check_wb_err(mapping, 0))
> > > +		return true;
> > > +
> > > +	return false;
> > > +}
> > 
> > This is too much.  filemap_check_wb_err() will do just fine for your
> > needs unless you really want to get fine-grained and perhaps try to
> > reconstruct the contents of the file.
> 
> As in only call filemap_check_wb_err and do away with all the
> hwpoisoned checks and the extra AS_EIO check?

Yes, that's what i meant.
