Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:38556 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750995AbcLDWMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 17:12:34 -0500
Date: Mon, 5 Dec 2016 09:12:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: optimise CRC updates
Message-ID: <20161204221231.GM31101@dastard>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-4-david@fromorbit.com>
 <20161202132245.GD426@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161202132245.GD426@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 02, 2016 at 05:22:45AM -0800, Christoph Hellwig wrote:
> > +xfs_start_cksum_safe(char *buffer, size_t length, unsigned long cksum_offset)
> 
> > +xfs_start_cksum_update(char *buffer, size_t length, unsigned long cksum_offset)
> 
> What about turning the first argument into a void * for both so that
> we can avoid all the pointless casts?

I thought the C standard specifically disallowed pointer arithmetic
on void pointers because they are an incomplete type, even though
they have the same alignment/representation as a char *.

IIRC, gcc will throw errors on such code if -pedantic-errors or
-Werror-pointer-arith is specified...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
