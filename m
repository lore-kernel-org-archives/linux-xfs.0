Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18351 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932838AbcI3BvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 21:51:00 -0400
Date: Thu, 29 Sep 2016 18:50:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 43/63] xfs: teach get_bmapx about shared extents and the
 CoW fork
Message-ID: <20160930015027.GB21076@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503149320.30303.9720221974285402096.stgit@birch.djwong.org>
 <20160929170537.GI4546@infradead.org>
 <20160929174059.GX14092@birch.djwong.org>
 <20160929195112.GA26321@infradead.org>
 <20160930001853.GI27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930001853.GI27872@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Sep 30, 2016 at 10:18:53AM +1000, Dave Chinner wrote:
> On Thu, Sep 29, 2016 at 12:51:12PM -0700, Christoph Hellwig wrote:
> > On Thu, Sep 29, 2016 at 10:40:59AM -0700, Darrick J. Wong wrote:
> > > There are a few xfstests that check the contents of the CoW extent fork
> > > to make sure it's working properly.  How about a compromise -- leave the
> > > flag in, but return -EINVAL unless CONFIG_XFS_DEBUG=y ?
> > 
> > Personally I'd prefer to remove it.  Maybe we'll need Dave as a tie
> > breaker?
> 
> Well, I kinda see it like reporting delalloc extents - they are
> in-memory, but we can report them to userspace even though they will
> change shortly.  I don't think it's generally useful, but right now
> we need all the validation checks we can get.
> 
> <shrug>
> 
> Ok, Darrick, let's make it debug only right now so those tests work
> while we get this code all sorted. And then plan to remove it before
> we remove the EXPERIMENTAL flag from reflink?

Sounds fine with me.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
