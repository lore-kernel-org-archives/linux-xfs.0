Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967921EF0BE
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751030486; cv=none; b=TOQpg+9t8DmXoi/lgNEo05G37m0SuFOr1ro9TRuIsZ2SrETUk5kxlY7cYIb5KiYmrNZKOYkcFOvbxEzACXxZD+zvxpO573Q6ZiEeqev3G0GI2yEf1X5Kq/aA7MfxOJDC620wvIp3Q+oZXHi0IFxQTCePgjhm8XMfP7rrPRI/n28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751030486; c=relaxed/simple;
	bh=HXJk5vKYOm8oEcJ1jF+yDTRDbVOSm3lbl5Xdev94fxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kREbqWExt41o3c0N8/+sIpGuldbKw11VmlatEk2QtVaPxMuDaW5UT3WfKTDmIzhCvztYgvG7XQHeSAl2Hd2i2U4Zn4m38xwElC6LC9uZzg5S7Pr5YMOVSUsXLoVcA4XcnpEybezxguMcoj6DvrYRD/WS+jk25/CXlAGg4Vjrafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=suSt86Iz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="suSt86Iz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NK5vM8Uyv9spJGnWlqBgpNmy2e1UQNR3HlREtrOA7dA=; b=suSt86Iz4JR0YwhydnxLsI8RXl
	0T1j9BjYI50lLBO9Xpg+SNocUDZdw5lkD89y5DmBTC75qsNtvh6psXl6sDtF0KDwbYtkHXTHPEp0g
	HdwCFDv13B54bp0U5x1gOGsVyKCW2nxtpvD8+B18QwtVBiXLgQmouExezmiyEO372h44eknyef2kk
	nHxujDYuSvpRgwvriTT/hGGGR6SnZIr97HB2WnxQqUo+LUd7hvI1DVdzKD5NOOH9pPkOstVOR0Cl4
	iMAu0Q0byjwERru2rbJq/6x+Yje5Ci3pbdnlKa2pyc5dmWkrruyI3jheWr0l+J81EJgbASmBvIywI
	ugMnDipw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV91A-0000000El6s-2za4;
	Fri, 27 Jun 2025 13:21:24 +0000
Date: Fri, 27 Jun 2025 06:21:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f259584cb40c
Message-ID: <aF6a1GhCdT_llDSm@infradead.org>
References: <hyw5332gxstbro2j5lswrypary3h2snvozqw5tszboku4trals@3x3wntciy3bi>
 <_qWWont5Uiw8o6UT-bt1v6DA5p1jvtb_2N4kdjoRU7zexNFw_ubgNBvkKhS-wEMgOVbyhl_2qrHucLqn6RRJNg==@protonmail.internalid>
 <aF6VYKOp4JutnLme@infradead.org>
 <k2jkeacuav6orgxae3sflzgeszc2wfmffjhhu5okjulkglcnvn@2gyui2k6htql>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k2jkeacuav6orgxae3sflzgeszc2wfmffjhhu5okjulkglcnvn@2gyui2k6htql>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 27, 2025 at 03:13:55PM +0200, Carlos Maiolino wrote:
> On Fri, Jun 27, 2025 at 05:58:08AM -0700, Christoph Hellwig wrote:
> > Btw, I assumed you'd send my fixes from three weeks ago to Linus for
> > 6.16.   Do you plan to wait for 6.17 or did you just not get around
> > sending a pull request?  At least for the zone allocator shutdown
> > check that would be annoying as it causes hangs during testing.
> > 
> 
> You meant the ones we already have in for-next?

Yes.

> I'll send them for 6.16,

Awesome, I kjust wanted to double check.

> I'm planning to send everything we have now in for-next to Linus on next
> week. I can send a pull tomorrow with things already staged for a few
> days (i.e. without the patches from today) if you need it urgently, but
> I'd rather wait to send it to -rc5 if that's ok with you.

In general I'd like to see them out rather sooner than later, but
if it's easier for your it can wait.
