Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46593 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751313AbeEJGhd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 02:37:33 -0400
Date: Thu, 10 May 2018 08:41:09 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/33] mm: give the 'ret' variable a better name
        __do_page_cache_readahead
Message-ID: <20180510064109.GC11422@lst.de>
References: <20180509074830.16196-1-hch@lst.de> <20180509074830.16196-7-hch@lst.de> <20180509154501.GD1313@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509154501.GD1313@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 09, 2018 at 08:45:01AM -0700, Matthew Wilcox wrote:
> On Wed, May 09, 2018 at 09:48:03AM +0200, Christoph Hellwig wrote:
> > It counts the number of pages acted on, so name it nr_pages to make that
> > obvious.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Yes!
> 
> Also, it can't return an error, so how about changing it to unsigned int?
> And deleting the error check from the caller?

I'll take a look at that.
