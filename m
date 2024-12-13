Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B7A4A21
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070083; cv=none; b=bm/tuShZTmP8jwhNTB4pDzypAvcEShvyV150brl4NuLzFjE74NKt2yA1Y06QL9rxHIzZwK3WAnIvDGj4fv4Fg24lQ7KobzqeEchQkdjYNGJ/SvsDwAb0aC03Y6u496ZJnmn6YMkuPHGLhQ02FamX64pVovrVKPd5K0gIIGJ11kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070083; c=relaxed/simple;
	bh=YDI0lQy2jA+6T6mdnt1vOjAv9dUSFYfaR5L0D4RPxSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWLklSRn8qvDKt8+wEkBzP1ak5tzbkIICsMU6aQt1UMqWfnpEYXKdtCfmpPnhHOdVVjkk021ReIEWTmHqZxMcT9isYHdpok9oYSJpkPEAvL1cMyeCENSdxeuxMeMbCkotLw+v+oLfLTO0VBQXEEHROpI9vLUrDRyYS+vdV8/V8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nRAxl1uo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nRAxl1uo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qtsWOa6agU/mA6LLU5Evha6JOtYw6Sex9m0cBhRCDdw=; b=nRAxl1uofj4aoKxZafWCGZQDp8
	3a2j9YVA71ZC2DpQDBQlEQbKY4liYtea0UeF8UfVjk+PrG5l/+Dr6J4s3lyvKZydERpybsFl+rMk4
	MrhQgUxSzGNQAWXkPIuObN4xP4A3pCkcudCeAjtysrE2tU7mrR+TOLFQFfNCZ497UwOiiSRMBdb0N
	jISM8aJCr01AuwzxrSHqL3U+IuAlEojMY71Yc51/vmFl3J9e1+UONaQVFa2kgbX4mll4d6PHsc7Ub
	iLOj73nbcK38EpUl4kCX+3KBlZFBlH/3IHHJIHBclveYvaWXjO7w2g3t5xJa8rFs9P2z+PGoS5HWe
	CFulsjDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLyqF-00000002prN-2BXH;
	Fri, 13 Dec 2024 06:07:59 +0000
Date: Thu, 12 Dec 2024 22:07:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: tidy up xfs_bmap_broot_realloc a bit
Message-ID: <Z1vPPz3eWHXdcKvM@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122246.1180922.12746792857754358632.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122246.1180922.12746792857754358632.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 04:59:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Hoist out the code that migrates broot pointers during a resize
> operation to avoid code duplication and streamline the caller.  Also
> use the correct bmbt pointer type for the sizeof operation.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
