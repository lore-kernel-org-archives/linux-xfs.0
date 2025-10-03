Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8CF34BA40
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 07:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759477608; cv=none; b=XnJHQSPGuV2zdRDH5NjxEkBjboME7Bs8SDMJkf3rQ+lZfQei53yc/vZzM5wGuXveIlybf/J/m25ZmCoXBcVX8k6BIw0SsFNA4x5xzDTCQBYdegILV8zc279xMGxZPELOddnOdhLO9ACkS/8s6DvrT72sIQp8JwYmYaYOi/8wKWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759477608; c=relaxed/simple;
	bh=N9HHHXWvLW1S8ThpNTzDjbuL7SSs+WpgXb4K8vmoSNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/B2Tu+/uSL8jovigWs27h+3KKHITHpn4DNahPPyjhCg1wOQqrz7UcEIMOu1FUSUA2BEFEcyz2w8h0VzOFCWHMPJKU73NE8ubF23/KsAatGlmMJuynJiVCzyCgyqbxfPmBLmLtjt2itDD0eku3hA77TDyWYpVoHj+dwnq2wYRds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UGcNGpJJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UGcNGpJJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JWxvVbhWRBy+xjqP9wqk+HG2cGj55mfgXGHeT6MutEg=; b=UGcNGpJJEh2u8UmJTgnFpBlX+S
	YQa9aOyu0Wj36lskJhDSlMixGQD3YOVYCKHVkQiQV9HKh51bbk/4/Q3YJjPeUK5jEyIitNtT8lnZM
	qjEVm5pzdu2DQC9U+TsC62+g8+dTk40LHIVqvioclORsZKef0mCRfFJv7/Z2jKIX7/90kXJCKod/S
	/tc4F2+nmdW2q/Nx9MlVCix7+k1kj+7+L3aOQCrQ2YOGyIMg46FC26IxWDvTcf5EyfImJ2DuhrH8I
	awQQYuAPE/IZqW9+MTj7pY3/jhEs7eVRzFRiDDudpZUfQaDOig/PSvnytNU9ErV6/ZEolpYXKZDgP
	cUrahQoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v4aV3-0000000BqE9-1kpN;
	Fri, 03 Oct 2025 07:46:45 +0000
Date: Fri, 3 Oct 2025 00:46:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: lukas@herbolt.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <aN9_ZfFEdDCuSTJW@infradead.org>
References: <20250926123829.2101207-2-lukas@herbolt.com>
 <aNotI3z54Om5MmE1@infradead.org>
 <80069d04a7bcbbfbb8daad7191c83fb2@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80069d04a7bcbbfbb8daad7191c83fb2@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 29, 2025 at 10:59:24AM +0200, lukas@herbolt.com wrote:
> > You Before/after also contain changes for metadir/zoned, looks like you
> > upgraded to a new xfsprogs for your patch, but not the baseline.
> > 
> Yeah it was fedora rawhide, 6.12, did not notice the metadir/zoned.

Np.  I just started at it to see what you changed.

> > I don't think just picking the data stripe unit is correct here, given
> > that the log can also be external and on a separate device.  Instead
> > we'll need to duplicate the calculation based on ft.log, preferably by
> > factoring it into a helper.
> Hmmm, aren't all the <data|rt|log>.sunit" set by blkid_get_topology()?

Yes.

> So as log is internal lsunit should be equal to dsunit and it can only
> differ if the log is external?

Yes.

> My understanding was the LSU check is there mostly if cli->lsu is set.
> Actually if that's assumption is correct it can be done just like this.

That might be a better idea, and should be done in a prep patch.

