Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB9D1B0439
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 13:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629409; cv=none; b=JG8icduI/CwSPZ4JLD+HEyx17Qm8RBbcmTociwASbh2VQNH6tDP7vQZAyNNpWmdX7j/5PacaAcSvk6Q9uqxyly1yqOxha11ULrRW2561VNVHe5Q6qotjOmgHL1tnpdKm9p3+KmTvzo2yh+aatoKcnA/Vr4L4aSnLRtEKylIHAks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629409; c=relaxed/simple;
	bh=IiC2e3oBTwqENwiWIn1vE+sO08++8+V+5DdT+tYjpEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rT1sfn0JO6n2f672Hh2oP3k+97wAWvF+4abUknUlI6mqcG+WnzxGL+V7JO7hyYO309f3Wcbso2WHXuCiPlGW3lay3O/MRuU2dGWnXaWng+Z9jtBdj4Yl6Vy74A07vAFikpc4Sk8NQX/AkThp5BRN6M6zzcwHc6ZyWEHDUkFQq3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PDytRt9w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PDytRt9w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Uju5n5Q8CrxpEwDT1ALPoPmWv9pnDjrtFDs9MAdfk0o=; b=PDytRt9w0BAwnUhnV2NCCvI27k
	ozalnyEqlD0VyTYff9/iGWOLjNOPshbStLj+pPiqZ/yGMa+EHMGjTfPsnGb5JhSkOi4irKDP5Rzfm
	K2Iehrgf7dJLnoyIvpVxVlJjWVmGKEvnUUD7m0TexFM3onfrRzryq7bROdf4VxKx4f3A6JbWowJk1
	y7I2YBAT+YZ+eiz1l5HuBCM9ZPxLtFKrn7DfIEA4vl28m4h2Z5ykK3885I8ZmE53qlxgsPGx0yQtX
	ZnWVXdz4MaGu8r5UtTP/a3VaOOpj7n9XcQMafKbIYBYEW5WbY1H3PpEBvqzpAra+pIY0LSisf/n04
	XBwqKqNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxlst-0000000HDXe-03YM;
	Wed, 04 Mar 2026 13:03:27 +0000
Date: Wed, 4 Mar 2026 05:03:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs_healer: use getmntent to find moved filesystems
Message-ID: <aagtnm0-z3ldfFqd@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
 <aacDkSiRLgD1k3Tg@infradead.org>
 <20260303172654.GQ57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303172654.GQ57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 09:26:54AM -0800, Darrick J. Wong wrote:
> Or did you mean that xfs_healer should keep the rootdir fd open for the
> duration of its existence, that way weakhandle reconnection is trivial?
> 
> [from the next patch]
> 
> > > When xfs_healer reopens a mountpoint to perform a repair, it should
> > > validate that the opened fd points to a file on the same filesystem as
> > > the one being monitored.
> > 
> > .. and if we'd always keep the week handle around we would not need
> > this?
> 
> The trouble with keeping the rootdir fd around is that now we pin the
> mount and nobody can unmount the disk until they manually kill
> xfs_healer.  IOWs, struct weakhandle is basically a wrapper around
> struct xfs_handle with some cleverness to avoid maintaining an open fd
> to the xfs filesystem when it's not needed.

Ok.  I've officially forgot what all the kernel code did.  I somehow
expected a weak handle to be a fd that the kernel could close on us,
which would be much more handy here.

