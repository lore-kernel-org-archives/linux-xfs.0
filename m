Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF56B223DEA
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 20:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760560023; cv=none; b=bqEVlPrZUzFFMOq8oJfOFhPnS/RkOOfehm8JV56HV+aGtCAoeuk16ygLkiaE9R1cVj74MNeO7DQ0xDc3gHNzBbU8W7EVCD04ycG3/gnibFdUN1n/B64fKPeaJNkq32yEZtT/CjIaVlbjQabkNHYrMTbT71Dsm7/vGps2f0+iW2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760560023; c=relaxed/simple;
	bh=xDA7lSajPyD6ZfBQy3QmTdgZ0leKjKeJ3seg/SSRK10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2+cwVw6SWX0gyKpK2TAEmFQXH5YXNmMilylG3rEtD1kRveu8chTNYf7gvb+ZuU7lEc3ysys4Aj4YyexUvhw5xcUAa/4F3+ZLxa8pFWtueiDXLBh1xdO6nkJa2e1fix88kWujbMAW7eePpPqd7dn2t3FArabZQkZXBz0POyhKIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bA52MVQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bA52MVQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B41C4CEF8;
	Wed, 15 Oct 2025 20:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760560023;
	bh=xDA7lSajPyD6ZfBQy3QmTdgZ0leKjKeJ3seg/SSRK10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bA52MVQExpxJg9tZDezNiElMj+9sm0Re9tiauy3sy+N8LMD351N9l7NLz3KOTh0DV
	 yhP6n8tNMo1xIATvvfzK33EXM26RFtHs5Wx99SLCBneiS7oDIunV//BP56qxQzVZTh
	 9x01loxbtxnzptpkIqgbxaBBmad3QN+/hjNIPoK/KQ5pcWCbljn85gRLl24bo9jWVK
	 r+8QmtTiWRZkqI9D3fbGaP+icjIfTGWRKNBsVD780B3R+pd/c7w6543fHSS1R7EVL2
	 1ujyDs6iVLLsWY0OijVVcbv6g8f5gS0EsSPYNcfV8yHUyDBJniC/baeKX7sEHkrcTa
	 YbL6spBGcniSw==
Date: Wed, 15 Oct 2025 13:27:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: remove xlog_in_core_2_t
Message-ID: <20251015202702.GG6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-7-hch@lst.de>
 <20251014220757.GL6188@frogsfrogsfrogs>
 <20251015044109.GD7253@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015044109.GD7253@lst.de>

On Wed, Oct 15, 2025 at 06:41:09AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 14, 2025 at 03:07:57PM -0700, Darrick J. Wong wrote:
> > > +	__be32		xh_cycle_data[XLOG_CYCLE_DATA_SIZE];
> > > +	__u8		xh_reserved[252];
> > 
> > Just out of curiosity, why do we reserve so much space at the end of the
> > extended header?  Wouldn't it have been more efficient to fill all 508
> > bytes with xh_cycle_data?
> 
> That's something I asked myself when doing this as well.  Or if we're
> so inefficient, why don't we at least put the cycle data into the same
> offset for both the initial and extended headers.  Also why do we write
> xh_cycle into the extended header and don't every read it?

Oh well, log v3 then. :(

> > > +
> > > +	__u8	  h_reserved[184];
> > > +	struct xlog_rec_ext_header h_ext[];
> > 
> > Ok, so you're explicitly padding struct xlog_rec_header and
> > xlog_rec_ext_header to be 512 bytes now, and making the xlog_rec_header
> > have a VLA of xlog_rec_ext_header.
> 
> Yes.
> 
> > The log buffer crc is computed from the start of xlog_rec_header::h_crc
> > to the end(ish) of the xlog_rec_header; and the first 256 bytes of each
> > xlog_rec_ext_header, right?
> 
> Yes.
> 
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -1526,12 +1526,8 @@ xlog_pack_data(
> > >  		dp += BBSIZE;
> > >  	}
> > >  
> > > -	if (xfs_has_logv2(log->l_mp)) {
> > 
> > Is the xfs_has_logv2 still necessary here?
> > 
> > What happens if log->l_iclog_heads > 1 && !logv2?  Or has the kernel
> > already checked for that and aborted the mount?
> 
> l_iclog_heads is set based on m_logbsize, and xfs_finish_flags verifies
> that it is never bigger than XLOG_BIG_RECORD_BSIZE for v1 logs.

Sounds good to me!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

