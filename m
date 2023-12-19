Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F508495
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 05:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nT+UGr3V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dOcHwBMuCN7pUNY3/1B2LfInQuPtQIXv8tdB+gbIOKM=; b=nT+UGr3VMEkNeKl9NbkBTdQnRG
	XOfgiSumJNE4r3tshhTuDfaBgbfDUevxj/EKXx9bcxlb+Ne7AwhoNdjH5+xtAuudMjlGu2OcIfv9Q
	i1ZrNJTYHO6QXtNyFw8kxfSJ7FYTWQlP9Ooupw/WDcltHHzQ5L80bqrse7aGodbVeY2ii0ELWLO0m
	qfwnNuoivpScYiOCisHCJ9yLMcnVXdxII0yjRsu5a1TWglCXsgmYapq14tL66xQaWpgsl+LUT5R6x
	YfRXrB9/5WxW0D2um0Kv7LUQx7ayAtTjUw5S+nQ7lJcPluliZsI8p379BpJadD7BPXqMYohhfExWR
	cH9Jqalw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rFT3l-00Cw3L-23;
	Tue, 19 Dec 2023 05:54:29 +0000
Date: Mon, 18 Dec 2023 21:54:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sam James <sam@gentoo.org>
Cc: linux-xfs@vger.kernel.org, Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH v3 2/4] io: Assert we have a sensible off_t
Message-ID: <ZYEwFUy6bFO3h7Lz@infradead.org>
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-2-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215013657.1995699-2-sam@gentoo.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 15, 2023 at 01:36:41AM +0000, Sam James wrote:
> +	/* We're only interested in supporting an off_t which can handle >=4GiB. */

This adds a < 80 character line.  Also I find the wording a bit odd, the
point is that xfsprogs relies on (it or rather will with your entire
series), so maybe:

	/*
	 * xfsprogs relies on the LFS interfaces with a 64-bit off_t to
	 * actually support sensible file systems sizes.
	 */

And while I'm nitpicking, maybe a better place would be to move this to
libxfs as that's where we really care.  If you use the C99 static_assert
instead of the kernel BUILD_BUG_ON this can even move outside a function
and just into a header somewhere, say include/xfs,h.  Which actually
happens to have this assert in an awkware open coded way already:

/*
 * make sure that any user of the xfs headers has a 64bit off_t type
 */
extern int xfs_assert_largefile[sizeof(off_t)-8];

Enough of my stream of consciousness, sorry.  To summarize the findings:

 - we don't really need this patch all
 - but cleaning up xfs_assert_largefile to just use static_assert would
   probably be nice to have anyway

