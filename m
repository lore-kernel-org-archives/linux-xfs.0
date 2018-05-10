Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46608 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756572AbeEJGkd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 02:40:33 -0400
Date: Thu, 10 May 2018 08:44:09 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/33] iomap: add an iomap-based readpage and readpages
        implementation
Message-ID: <20180510064409.GE11422@lst.de>
References: <20180509074830.16196-1-hch@lst.de> <20180509074830.16196-12-hch@lst.de> <20180510011758.GR10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510011758.GR10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Thu, May 10, 2018 at 11:17:58AM +1000, Dave Chinner wrote:
> > +		if (ret <= 0)
> > +			break;
> > +		pos += ret;
> > +		length -= ret;
> > +	}
> > +
> > +	ret = 0;
> 
> This means the function will always return zero, regardless of
> whether iomap_apply returned an error or not.
> 
> > +	if (ctx.bio)
> > +		submit_bio(ctx.bio);
> > +	if (ctx.cur_page) {
> > +		if (!ctx.cur_page_in_bio)
> > +			unlock_page(ctx.cur_page);
> > +		put_page(ctx.cur_page);
> > +	}
> > +	WARN_ON_ONCE(ret && !list_empty(ctx.pages));
> 
> And this warning will never trigger. Was this intended behaviour?
> If it is, it needs a comment, because it looks wrong....

Yes, the break should have been a goto out which jumps after the
ret.
