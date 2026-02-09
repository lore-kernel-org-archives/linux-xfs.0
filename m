Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C49254B03;
	Mon,  9 Feb 2026 06:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770618625; cv=none; b=vBA1hx6ygxREW+y7ypDb8AKwfn0cvgUYJa1oWLwW2WMKQ1ltA9Ja3OcoCPDMD3gEpt7rqCrgGLSunuTGvQSFUzcfMLeUTe0RmwOAjlT3SSwBdkcHHm/CtMYI6MD1x2HNqdaPa0PNrGsCVbbDYjV2pPHdStRrQefHsIchrmcmEuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770618625; c=relaxed/simple;
	bh=N2L2HxztJFQlyH5vYhD3rePl+E4Fq4txNNYSsSY+8jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhHRx0IoruvDs1rp6XSwIFdePmsQvxa59i5JomXiKjKZ7zg1yY2Yxif0gOd3KL+IdZw4BB1BjK2Pm1HByhu5YG4bJ3+vXM2EAMOPPf1gn+WYGJrbq0h0WW2vBj0XNeGfSL7bZG1IFDycKDCExTpN/XEjNoEf9gvvuAnzsbL+Xbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA8A168B05; Mon,  9 Feb 2026 07:30:18 +0100 (CET)
Date: Mon, 9 Feb 2026 07:30:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
	Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <20260209063018.GB9021@lst.de>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com> <20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster> <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com> <aXN3EtxKFXX8DEbl@bfoster> <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com> <20260206062527.GA25841@lst.de> <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 06, 2026 at 03:37:38PM +0530, Kundan Kumar wrote:
> When you say "coarse-grained sharding", do you mean tracking a single
> "home AG" per inode (no per-folio tagging) and using it as a best-effort
> hint for writeback routing?

Yes, but..

> If so, we can align with that and keep the threading model generic by
> relying on bdi writeback contexts. Concretely, XFS would set up a 
> bounded number of bdi wb contexts at mount time, and route each inode to 
> its home shard. Does this align with what you have in mind?

Yes.

> We had implemented a similar approach in earlier versions of this
> series[1]. But the feedback[2] that we got was that mapping high level
> writeback to eventual AG allocation can be sometimes inaccurate (aged
> filesystems, inode spanning accross multiple AGs, etc.), so we moved to
> per folio tagging to make the routing decision closer to the actual IO.
> That said, I agree that the per folio approach is complex.

It is inaccurate, not to say often wrong.  And that's the point I'm
trying to make here:  start with simplifying the allocation policies
so that they make sense in this kind of environment, and then align
that sharding to that.

