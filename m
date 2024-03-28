Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1862C6B8
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609511; cv=none; b=vGd+bh6ynqEYVXYqyWAUgRIvqw/VWrT/d6ApsiImfW9zcWgyWF5aEFLpF8pS4C3QeUvSddLdrh9KCJ22iitHBgqoZenLR0RwMb7A0e+qlOZA2G8mF7aL8dEBJkdBHrdKNeiuItzaVwrANrYT2EnjfBJuhrK4LovQNk+wddNIU60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609511; c=relaxed/simple;
	bh=l/Hedltg0/cHLK5KwA6Zgat1Uh4Ecv2h3nZhbLmGh5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoRjpKy6Xc12iWxHxpfjQssn1cctf9e5Fql3htwbqjLRbGTTovOdL6TaL7Z9HW5i3rmovsd3tC2cZonyA7jMUmT8/3XWyfxkqsyUhylHaM/sj3DUBk5W2WiI5cNwPnfbEK6IhhQX52V4XcG6WDllcyMxDsWayNokwaINYUTjjcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W5MR8kTR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W5MR8kTR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BRoGfIPTSobVI0h2/TFgtVOokkHPwG4FYQzIWLZzG2A=; b=W5MR8kTR16o2ddVRIi0b5Nw4Ti
	y1mCPmzktvJ8HVduz3CStFKXCxk79Q4LItbUqZoWbnnUg0E/UV/R6FeLqK4N7RTgB+/apPSfE/6w2
	8Rv2oP/OERLCNEfE2+HyANb7w/XdeYBOOvAkX5nDxaDWswnh5zX6rtl4tb9SN1RXiSY68aH2LErzl
	yXuVvZXPdpPj1U91YPGrLCuOKO7ezgNXEPdvaDnVrHJV0AiLlLt1MdNZVVLCjXytUYkymqQg7UEZc
	lA5M1j8ZOCfRwAG5JOgmm2S39G43UlufX3QTDVJXmlmNhfr1zsmwhq40Ok+6uO2wprPNo1Mtr7I8w
	IJkRHURw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjp0-0000000Cnx3-09V2;
	Thu, 28 Mar 2024 07:05:10 +0000
Date: Thu, 28 Mar 2024 00:05:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] writeback: soft lockup encountered on a
 next-20240327 kernel
Message-ID: <ZgUWptdgdBrcFZ1O@infradead.org>
References: <8734sa3o0x.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734sa3o0x.fsf@debian-BULLSEYE-live-builder-AMD64>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 28, 2024 at 11:11:05AM +0530, Chandan Babu R wrote:
> Hi,
> 
> Executing fstest on XFS on a next-20240327 kernel resulted in two of my test
> VMs getting into soft lockup state.

What was the last linux-next tree that did work fine?

