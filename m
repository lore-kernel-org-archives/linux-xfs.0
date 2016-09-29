Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17336 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933484AbcI2Ut1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 16:49:27 -0400
Date: Thu, 29 Sep 2016 13:48:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/63] xfs: log refcount intent items
Message-ID: <20160929204855.GG14092@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503128015.30303.2237183364098745952.stgit@birch.djwong.org>
 <20160929165601.GE4546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929165601.GE4546@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 09:56:01AM -0700, Christoph Hellwig wrote:
> > +/* The XFS_REFCOUNT_EXTENT_* in xfs_log_format.h must match these. */
> > +enum xfs_refcount_intent_type {
> > +	XFS_REFCOUNT_INCREASE = 1,
> > +	XFS_REFCOUNT_DECREASE,
> > +	XFS_REFCOUNT_ALLOC_COW,
> > +	XFS_REFCOUNT_FREE_COW,
> > +};
> 
> That's a nightmare for maintability!  Either we use
> XFS_REFCOUNT_EXTENT_* directly, or we need a helper to convert
> between them.

I'll simply use the values directly.

--D
