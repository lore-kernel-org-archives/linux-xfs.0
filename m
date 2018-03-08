Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55948 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933471AbeCHIP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 03:15:29 -0500
Date: Thu, 8 Mar 2018 00:15:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] Get rid of XFS_BUF_PTR() macro
Message-ID: <20180308081527.GH15163@infradead.org>
References: <20180306130053.13958-1-cmaiolino@redhat.com>
 <20180306130053.13958-2-cmaiolino@redhat.com>
 <20180306222210.GL18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306222210.GL18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Mar 07, 2018 at 09:22:10AM +1100, Dave Chinner wrote:
> On Tue, Mar 06, 2018 at 02:00:50PM +0100, Carlos Maiolino wrote:
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> .....
> > @@ -275,9 +275,9 @@ newfile(
> >  		d = XFS_FSB_TO_DADDR(mp, map.br_startblock);
> >  		bp = libxfs_trans_get_buf(logit ? tp : 0, mp->m_dev, d,
> >  			nb << mp->m_blkbb_log, 0);
> > -		memmove(XFS_BUF_PTR(bp), buf, len);
> > +		memmove(bp->b_addr, buf, len);
> >  		if (len < XFS_BUF_COUNT(bp))
> > -			memset(XFS_BUF_PTR(bp) + len, 0, XFS_BUF_COUNT(bp) - len);
> > +			memset(bp->b_addr + len, 0, XFS_BUF_COUNT(bp) - len);
> 
> Bug there. pointer arithmetic changed, needs (char *) cast.

Not really.  In standard C pointer arithmetics on void * isn't even
defined, so this won't work.  In the GCC dialect it is defined the same
as on char *.  And I'd much prefer not adding these pointless casts that
just confuse everyone.
