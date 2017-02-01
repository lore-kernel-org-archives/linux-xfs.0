Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57913 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750920AbdBAOtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 09:49:42 -0500
Date: Wed, 1 Feb 2017 06:49:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: error propagation problem on xfs over dm stripe
Message-ID: <20170201144935.GB27071@infradead.org>
References: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
 <20170201074249.GA22669@infradead.org>
 <20170201143351.GA18848@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170201143351.GA18848@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, dm-devel@redhat.com

On Wed, Feb 01, 2017 at 09:33:51AM -0500, Mike Snitzer wrote:
> > FYI, what we do both in the XFS buffer cache and the new direct I/O
> > code is to use a
> > 
> > 	        cmpxchg(&dio->error, 0, ret);
> > 
> > in a similar situation, which should work here, too.
> 
> What is the benefit?  Faster than the conditional?

In the cases where I added the code the concern is that multiple
bio completions could race updating the flag, cmpxchg is a good
protection against that.  I'll need to take a look at the dm
case Eric reported in more detail to comment on it, though.
