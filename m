Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430B333B955;
	Thu,  9 Apr 2026 20:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775765949; cv=none; b=dtEDQcd9gTIb3qN/O4Hv1Eg0zZ+XG1ynDCIPmcmEZr3NxtoRBFCbM9xpT0EU8dB0LBiMqhpUvwkokcs8REUI3M9fEQXEbfVHYcKXJUsFa6+g4odn6k9a7g7TGih/IvuDVT5D/7epu51uBR3KthSAx+uDwifq6ser+4nQ9kqxCIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775765949; c=relaxed/simple;
	bh=bFV0lDpHGG9HeKVfTcpkAU3gQosM08eTfmRyt2eGn30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bai0oREyCmA6iSIpk7SsKEypKDUKFhDGhPIZcbb3yywDaJ5gaPzVpSiCIkrC7+y2tyd9vWodJgt7JWXDn6wSLLVbK2Y01wMywbuJtZtsRiiWCSnaumUrB60PfFeePwBM/1zpu455ykm2zw21IkfiGCR5AS32AJB4YY8HYqbF0zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=da5CPd+0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="da5CPd+0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uetQL92ALql1aKqdvIjrKtP93zELYzZBGItlkQMM8q0=; b=da5CPd+0XDSMYqKszRNM05yMDp
	slyFGyXYQ4qS5VvbFKW9pH1T+F7f7qUF5dR6SBorhUUFg4t7CKPAHZbGeWKPtkhLOvgYqkrBGD7Wb
	0Uqn9hq60w5Dgd/eGpnPtMKgcFvpA9S2GF1GnBiFJak3RHWGBKOaeZPzGeQq3bJ4rudY+Z2rBCvA7
	3PfWgPiNHKMs5gOtp/AXMCFTA9OcVofN++n6Cd+D4jorjQnho5xk5dRLWnCQSiaaoibI8aRV1kY3v
	xXU/CmmHVxlH24eA73XP5E4Jg9VO7PodiJ+h+iN2CUnWteCePR8IAnNtI+ZKHkfGajyCf/uF+ZtNm
	eM3pCHCg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAvpy-00000007Vb9-3Sf6;
	Thu, 09 Apr 2026 20:18:50 +0000
Date: Thu, 9 Apr 2026 21:18:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <adgJqiA0vivaW7NA@casper.infradead.org>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409160243.1008358-5-hch@lst.de>

On Thu, Apr 09, 2026 at 06:02:17PM +0200, Christoph Hellwig wrote:
> @@ -1836,9 +1837,7 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
>  
> -	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> -		bio_queue_completion(bio);
> -	else if (bio->bi_end_io)
> +	if (bio->bi_end_io)
>  		bio->bi_end_io(bio);

What I liked about this before is that we had one central place that
needed to be changed.  This change means that every bi_end_io now needs
to check whether the BIO can be completed in its context.

> +++ b/fs/buffer.c
> @@ -2673,6 +2673,9 @@ static void end_bio_bh_io_sync(struct bio *bio)
>  {
>  	struct buffer_head *bh = bio->bi_private;
>  
> +	if (buffer_dropbehind(bh) && bio_complete_in_task(bio))
> +		return;

I really don't like this.  It assumes there's only one reason to
complete in task context -- whether the buffer belongs to a dropbehind
folio.  I want there to be other reasons.  Why would you introduce the
new BH_dropbehind flag instead of checking BIO_COMPLETE_IN_TASK?

>  	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
>  
> +	/* Page cache invalidation cannot be done in irq context. */
> +	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE) {
> +		if (bio_complete_in_task(bio))
> +			return;
> +	}

I thought we agreed to kill off IOMAP_IOEND_DONTCACHE?

