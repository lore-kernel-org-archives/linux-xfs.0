Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49658 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbeLSTc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 14:32:57 -0500
Date: Wed, 19 Dec 2018 11:32:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/11] xfs: don't use delalloc extents for COW on files
 with extsize hints
Message-ID: <20181219193246.GY27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-7-hch@lst.de>
 <20181218214425.GL27208@magnolia>
 <20181219192924.GA28624@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219192924.GA28624@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 19, 2018 at 08:29:24PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 18, 2018 at 01:44:25PM -0800, Darrick J. Wong wrote:
> > > +	uint			*lockmode,
> > > +	unsigned		flags)
> > 
> > I'm not thrilled with passing iomap flags into the reflink code here...
> 
> So what is the alternative?  A non-descriptive bool argument?

More or less what I described below. :)

> > ...because I feel that it's easy to miss the subtlety here that for
> > buffered writes we don't care if the cow extent is unwritten or written,
> > but for directio we very /much/ care that the cow extent is written,
> > because we're writing to it immediately.  Can this grow a comment to
> > reinforce why we skip the conversion?
> 
> Sure.
> 
> > Also, can we call this 'iomap_flags' to make it clearer which flags
> > we're talking about?
> 
> Sure.

Cool!

--D
