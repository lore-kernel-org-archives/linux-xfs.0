Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48763 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbeLST30 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 14:29:26 -0500
Date: Wed, 19 Dec 2018 20:29:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/11] xfs: don't use delalloc extents for COW on files
 with extsize hints
Message-ID: <20181219192924.GA28624@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181203222503.30649-7-hch@lst.de> <20181218214425.GL27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218214425.GL27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 01:44:25PM -0800, Darrick J. Wong wrote:
> > +	uint			*lockmode,
> > +	unsigned		flags)
> 
> I'm not thrilled with passing iomap flags into the reflink code here...

So what is the alternative?  A non-descriptive bool argument?

> ...because I feel that it's easy to miss the subtlety here that for
> buffered writes we don't care if the cow extent is unwritten or written,
> but for directio we very /much/ care that the cow extent is written,
> because we're writing to it immediately.  Can this grow a comment to
> reinforce why we skip the conversion?

Sure.

> Also, can we call this 'iomap_flags' to make it clearer which flags
> we're talking about?

Sure.
