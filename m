Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A77938423B;
	Tue, 22 Sep 2026 05:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790055398; cv=none; b=HjlAl54Ct78fJnVi2eXCIAOSsyYyiypHSRLCvfgdiW1VogJaJ4ad58+pBtct9JVhCaQS2WwE18bT7Rorqv/xm1xAC3Cum+/ov/k3H+JxmSONzRmm64GIK3dE5kTFmRZoPDom7w/6HLBQQJqZNhHxmMxp7m9TMPcFl5Tty8ozH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790055398; c=relaxed/simple;
	bh=99RtZy1XAXVt2hzVhroq3eDP1KmJzpQWIZiWFlr3CzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmLrcgSg4dF+iQZ0mIRDNcHJYd04tVVU1ODjz3oETNPgwwTFgd0tOaR+DwlLWtzC2SZvokMphaGzEjgiydYnM49b1EzAbPDKifVhlL3lIx9X/SnksgEZQawULF06PMI1Io3CIEqHCITNFf89DkwjmJj8o8AedUtzDf9jeSxIMJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sUJdXnkz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sUJdXnkz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BAvI42Vrt/4XJFppGzirAvU0yTLEdEWVLjEZ+TzS2cA=; b=sUJdXnkzJcfm9TWkLnDvGh52zq
	nwQGhwtXxyzNhdy7ea2NkQrnC12QB+6zAO9xJTQNN2aUSAgYuASFRvrA/Z54MhpqRuqVoDp92QFNe
	BBpYnvLdcelDLQJKdSnLhLC07LUMNDiYM7kUXvL3iyTkfK68wxtL5nOmrc8Fz97+z10nNzqYxFen2
	gHU+yNBWXdDbtbreW2n3A3a52hxt4r9IGP2OlXyUh50OgC0i6OmyCQp/jG1xQM7EWcD3ZYbV1teim
	99OI3stZClwlRmZS23u4uS6lxsdXuwU8Tb83IQ3S2rz0YngGuHSGW5snVrxTqvShQwUY6MPMkBpQg
	fFs+prCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8tBE-00000004G0w-0XfD;
	Tue, 22 Sep 2026 05:36:36 +0000
Date: Mon, 21 Sep 2026 22:36:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <arIT5A3MR7VtCeba@infradead.org>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-4-parri.andrea@gmail.com>
 <20260921223432.GO6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921223432.GO6283@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 21, 2026 at 03:34:32PM -0700, Darrick J. Wong wrote:
> > -		if (pad)
> > -			ret = iomap_dio_zero(iter, dio, pos,
> > -					     fs_block_size - pad);
> > +		if (pad) {
> > +			ssize_t zerror;
> 
> Why ssize_t?  iomap_dio_zero returns int, right?  I may have missed
> something in my absence, but AFAICT it should be:

More importantly iomap_dio_zero can only return an error for a
logic bomb assert using WARN_ON.  I'd suggest to simply return without
an error there and remove the handling of the iomap_dio_zero return
value entirely, as it clearly casues more harm than it helps.

