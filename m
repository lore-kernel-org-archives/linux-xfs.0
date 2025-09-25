Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446332BB13
	for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 07:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758785035; cv=none; b=XeOJvnQu4EMmGWVWJV+j9+EWWW2iPbCyoIfCJ3bpKEoJM60vWN28ib/yQY65gWRgeGgwVVPE2/tZ7wG8KnPnGBD++WsPRuvfH+QwTF3BpR1oUOyRTbFHc75j/LuxP+eKYn3NAi8k97+u6SdpGM8TkRv4YkDqMiEJQYzGYejxq50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758785035; c=relaxed/simple;
	bh=7L77JVPVv9S6EfIasBey715YJbSyOi5x3oazU7GBROk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkEMEKeXxXUv/aNq/FbmPMG3vMpgfVlga+qZ2MsiSKM7BkDrj2pJZQCBhDGlSA8CURJYspqIVAK77A5sBD0JYBg3ZY5xJVTK0dYp1meCh5ntyVfX3grqJ6XbQlZZgOYGv/vzAPYjZ6LBQHJh5C8pUNRcj3Hb9YCq1Bw/SfFgvj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g6t7Z4go; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g6t7Z4go"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Rx1gSxD5gleu9sSApweQU6azlkLIZgnGYoZippdUne0=; b=g6t7Z4gowZHpR7Uf4t1WRiWHPL
	0G8EHw5GLv0vu3giC6IU0MWnqb6UcvAFBcfOsex3n/6Vf/kcIob7eD1s5SDVUVANaVzbQtrwOjXV9
	iFlqVPtVZqkSM7b/1nHVTYe8DjCnqhmt6H6qh4rWvRIyoiNOYnsP9yTRVVYzopQ6XuuMBVjgFDnhO
	zb8So1/Hj72FkRy5GA8Hv3DER1ATRCSVo370SkRipYPwGRAqaW/Xs9NT6T6i3U8TAONzj1AI1xnyD
	ePZQ4EVP2fW/Tw4/DolVw5CDeMakfjuHfBCJDKpK6V9x1HsXpKAQ/wssGTtGPWRb224+xeOJRejwS
	Gg3Yv6Yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v1gKS-00000006gEs-18J4;
	Thu, 25 Sep 2025 07:23:48 +0000
Date: Thu, 25 Sep 2025 00:23:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <aNTuBDBU4q42J03E@infradead.org>
References: <20250919161400.GO8096@frogsfrogsfrogs>
 <aNGA3WV3vO5PXhOH@infradead.org>
 <20250924005353.GW8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924005353.GW8096@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 23, 2025 at 05:53:53PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 22, 2025 at 10:01:17AM -0700, Christoph Hellwig wrote:
> > The autoconf maigc looks good (as good as autoconf can look anyway),
> > but why is this code using strerror_r to start with?  AFAIK on Linux
> > strerror is using thread local storage since the damn of time, so
> > just doing this as:
> > 
> > 	fprintf(stream, _("%s."), strerror(error));
> > 
> > should be perfectly fine, while also simpler and more portable.
> 
> But there's no guarantee that the implementation does this, is there?
> The manpage doesn't say anything like that.

To me this pretty clear reads that the return string is stable until
the next call to strerror as long as you only use it in the calling
thread:

"The strerror() function returns a pointer to a string that describes
the error code passed in the argument errnum,  ...
This string must not be modified by the application, and the returned
pointer will be invalidated on a subsequent call to strerror() or
strerror_l(), or if the thread that obtained the string exits.  No
other library function, including perror(3), will modify this string."

