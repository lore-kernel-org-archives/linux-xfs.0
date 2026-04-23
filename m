Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D15D2868A9;
	Thu, 23 Apr 2026 05:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776923353; cv=none; b=QcXR+GbeMuaAuqnL6HoBTIiBjX9iG+CasTCDWIgGsOu14vpAXsNK/m0pwmdu9GYXqm25t4n/khmn3g2sNm+KHOdp5kKxNp8AkuoBzc8bypQ8fbhEc9bb7JvlxAz3drjMdX4Rbra7rtWlmNomUy5qNlYu/Ir2n0TNSaYihKg+vMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776923353; c=relaxed/simple;
	bh=KDxzkvM08iZ1n+znZEcdqWNiL8ZgPsUKuUA2rGBREWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNlHFz3YUfX0w9GkM+NeZyFijxj7bZ/OViYEQkIzum0r0v3KkEysx8YTAv3Slzh8p4KWRJU5afmSV8zKYmcHut1YXOjgwpjrhWDVuxyx8/gzZ1hV7XRYVnRliK0O291TNvvk3QBVrp8hY/uxqoXAxfjA4zdGSM6WcWOpHe+3gB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pyl35UR7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pyl35UR7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mH1ddnuN59lMkrFuCSAsacD4xLHTN8u5J5HYKL1a30Y=; b=Pyl35UR7IThUYMTHIm+a/cWSYX
	0HrBz+M3TGEKzSWdKkcQsDCPbJSKoGmd2h16jwadfiZiHdmi7R9VIimlWhAq72JKHtzWSxYnHCljN
	BEJa5uH8cKX03Kcxzln18lRfQ0/0U2SgBqqGIku3huprWeijw848UTViTVs/t9x15PFxl1o5x0grr
	wRKK5FNDrjl3ovm5LenRwUJ96hspfUBY7IlNFCcCqt3Kygy87NU3zo4dMCg6mPBwXtee15tTX42eq
	dgd7Bh5XsdUMTqQ9V0A99cI9pXFBD47noKmZxggGcDoFth2bQAlLMZEF1Q3aw0JTcj1gTOBJyHXXm
	Ek0YrS2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFmw0-0000000B5Ai-2394;
	Thu, 23 Apr 2026 05:49:08 +0000
Date: Wed, 22 Apr 2026 22:49:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, hyc.lee@gmail.com,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH] ntfs: use page allocation for resident attribute inline
 data
Message-ID: <aemy1Pyl2W7JYKVl@infradead.org>
References: <20260422104627.8193-1-linkinjeon@kernel.org>
 <aejFTDGOnDbQ3OJK@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aejFTDGOnDbQ3OJK@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 22, 2026 at 01:55:40PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 22, 2026 at 07:46:27PM +0900, Namjae Jeon wrote:
> > The current kmemdup() based allocation for IOMAP_INLINE can result in
> > inline_data pointer having a non-zero page offset. This causes
> > iomap_inline_data_valid() to fail the check:
> > 
> >     iomap->length <= PAGE_SIZE - offset_in_page(iomap->inline_data)
> > 
> > and triggers the kernel BUG at fs/iomap/buffered-io.c:1061.
> 
> Hang on, hang on, hang on.
> 
> First, maybe this check is too strict.  I'm sure it's true for EROFS,
> but I don't see why it should be true for everybody.  Perhaps we should
> delete this check or relax it?

I think the current check should just go.  ->iomap_inline_data is
treated as a normal linear address everywhere, so any offset in page
check is weird.

> Second, why are you calling kmemdup() to begin with?  This seems
> entirely pointless; the iomap code is going to call memcpy() on it.
> You're supposed to just be pointing into your data structures.

Yes.

