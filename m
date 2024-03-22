Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526C8BA5E
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 03:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711077906; cv=none; b=TLouF6rQcLLu/2D3T+WtufdvSXbDWjKKDzdiEk33LVXy+kiyRgwfcdW5iYKpMSZDZyeEubI6iiGOXgdi5Z1fVcS1m2NtEQ4iTDP73aeBKyr0dCfwVKZicziZMrzX+apdRIyPY1yzJhwlBpnDUNFHxzy/Bok4tM8bFO5tT1TrZ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711077906; c=relaxed/simple;
	bh=SiT4M+jnvqfHIay64VoFA/Ky2jvySG22uJUKY9Nqr3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VXEoe27FN6dk/aQM30bWyQcCjALEcBnNtr6fzH5seHu844X35cFZ+vGb9JLpd6exz3iLjlCZGJnuNCcbZK2e5RDQ/dskNasLdId/bbLZno5dRryX7LjkAW4NxifxNw+iIDxk3zRPn9Tbd/OALtktMBOVbPa9GPgCsSA7+R1+HIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CTNu1pqx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CTNu1pqx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yoEOUDG72LpxHnANLLVKAqNewp5j4p1jWX67IHPV8+A=; b=CTNu1pqxbdhE1F5Vq+Dgd0mGPe
	jO3VxPCTSpqbqp5gVTEzexGjEX9xyzsinY+xtkp51pS3MhKcPuxHmNLHI0XLqfAb75aOilFg/mcT7
	qVY57/CcMQpDNG6SCk0EPTvG9OCfnBBOfWJlcwFQlKoeytqqSAytEsx5+5ggp9i8l8MZXhXbYGjkk
	M5r9yN7T6ynmYO3jkdH2sdBZLoY5R10hfHzR2pF/8wZtOSAsxpaASFpJvF94m+ryMRFCAB2pk4sDP
	RlpRqDR5iMsLl5JBsA4XwZfQcSalbeoY3dLL5HDFGY62fK49cJt9oCfOG4Cd7yPmRFv9p+tBpi1dy
	UPQC+Kpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rnVWh-00000005dW5-1lyq;
	Fri, 22 Mar 2024 03:25:03 +0000
Date: Thu, 21 Mar 2024 20:25:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: compile out v4 support if disabled
Message-ID: <Zfz6D_A0h6_VrfSp@infradead.org>
References: <20240319071952.682266-1-hch@lst.de>
 <Zfn+CTA88U78hiQw@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfn+CTA88U78hiQw@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 20, 2024 at 08:05:13AM +1100, Dave Chinner wrote:
> Is that right? This can only return true if V4 support is compiled
> in, but it should be the other way around - always return true if
> V4 support is not compiled in. i.e:

Yes.  I actually also fixed that when I redid the patch.  The downside
is that despite the additional stubs we actually remove less code now.
