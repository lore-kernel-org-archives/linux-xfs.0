Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF3D1869
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706287844; cv=none; b=PENSsgWykZimNJ2sqAlycIW7WvBmHgoCBTRPaJ0qrjMJNa7Wk0s7CW8QZAO6FKGErDiY+mMOZpyekZ3ZB8+CamWonyKJMhwKlv+kzf1e1d8G4JPdMnAYnl/tcHh++bcRyPruLpk1DcsmpfRgMg5pBWVvuNbkLAq97H4wy4Qzpbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706287844; c=relaxed/simple;
	bh=BfRIfATJHiovJMXY+wQ8jZcQr7Vj+GqHwgZRvVisOfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWChNiTt2kJHbt9MxAXbzcXyzkty+W/vXtumTHtZQlh6VslNBnDoS7p/tfFlC9kQJfQSD8KucxPn+7q2x5b95cUwJhL8i+AnRNZilFokKlI3BRJcTX5aJoGLavtCjx/lZRB/JvVZfGmI6AIgPLbi0g4xhUHBgY8CHM1oQFOOIrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdbjJzjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdbjJzjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AA0C433F1;
	Fri, 26 Jan 2024 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706287844;
	bh=BfRIfATJHiovJMXY+wQ8jZcQr7Vj+GqHwgZRvVisOfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sdbjJzjvb9f2B3QKApxhUDOtKi48uRzli2JgXQ24RjV3wSPrP3fRL7HkuOeSyAUXW
	 E7v4K/tdSvVLBBhNBp73xV4s7M6E3LIkVpwpk3lo7iPVxubdtCqBzQh0YpRAoKGcB4
	 D2gNjfRJELacB/uLV7lsvCtNxxMbPnko+E6itUs7vY17J6dppGBVKL8+6CO/c8mpEI
	 zdHtD9uQZDl67saoRhmvb/RdGcr6NqKFqdWUPK2MPCEPbgve/ykYNQvSEu3FcxiCP9
	 cePyZ4gXRos+yBPZugmL4hbXwywGWPWLIykOzOgOKNuFNd1D5cgYtUaJnHkdc922oU
	 b8HQwBPnCkIAw==
Date: Fri, 26 Jan 2024 08:50:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 16/21] xfs: improve detection of lost xfile contents
Message-ID: <20240126165043.GC1371843@frogsfrogsfrogs>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-17-hch@lst.de>
 <ZbPe5FjDaQp1v8En@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbPe5FjDaQp1v8En@casper.infradead.org>

On Fri, Jan 26, 2024 at 04:33:40PM +0000, Matthew Wilcox wrote:
> On Fri, Jan 26, 2024 at 02:28:58PM +0100, Christoph Hellwig wrote:
> > +/* Has this file lost any of the data stored in it? */
> > +static inline bool
> > +xfile_has_lost_data(
> > +	struct inode		*inode,
> > +	struct folio		*folio)
> > +{
> > +	struct address_space	*mapping = inode->i_mapping;
> > +
> > +	/* This folio itself has been poisoned. */
> > +	if (folio_test_hwpoison(folio))
> > +		return true;
> > +
> > +	/* A base page under this large folio has been poisoned. */
> > +	if (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))
> > +		return true;
> > +
> > +	/* Data loss has occurred anywhere in this shmem file. */
> > +	if (test_bit(AS_EIO, &mapping->flags))
> > +		return true;
> > +	if (filemap_check_wb_err(mapping, 0))
> > +		return true;
> > +
> > +	return false;
> > +}
> 
> This is too much.  filemap_check_wb_err() will do just fine for your
> needs unless you really want to get fine-grained and perhaps try to
> reconstruct the contents of the file.

Hah no, we're not going to implement online fsck for xfiles. ;)

Online fsck might be a little special in that any data loss anywhere in
an xfile needs to result in the repair aborting without touching the
ondisk metadata, and the sooner we realise this the better.

--D
